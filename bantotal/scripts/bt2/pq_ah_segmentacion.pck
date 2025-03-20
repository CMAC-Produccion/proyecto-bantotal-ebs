create or replace package PQ_AH_SEGMENTACION is
-- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AH_SEGMENTACION
  -- Sistema               : BANTOTAL
  -- Módulo                : PASIVAS
  -- Versión               : 1.0
  -- Fecha de Creación     : 23/12/2013
  -- Autor de Creación     : Silvia Patricia Marquez Avendaño
  -- Aplicacion            : REaliza la segmentacion de Clientes-Ejecutivos
  -- Estado                : Activo
  -- Acceso                : Público
  --------------------------------------------------------------------------------------------------
  -- Modificacion          : Smarquez 18/03/2015
  -- -----------------------------------------------------------------------------------------------

procedure Asignacion_Cliente(
                             Pgcod IN NUMBER,
                             Tipope IN NUMBER,
                             Ubuser IN VARCHAR2,
                             Sucurs IN NUMBER,
                             Pepais IN NUMBER,
                             Petdoc IN NUMBER,
                             Pendoc IN VARCHAR2,
                             Usuario IN VARCHAR2,
                             SaldoMin IN NUMBER,
                             SaldoMax IN NUMBER,
                             Onomastico IN VARCHAR2,
                             Vencimiento IN VARCHAR2,
                             Rpta OUT VARCHAR2
                             );
------------------------------------------------------------------------------------------------------------
function Valida_Agencia(
                        Pgcod in NUMBER,
                        Sucurs in NUMBER
                        ) return Varchar2;
-------------------------------------------------------------------------------------------------------------
Function Nombre_Cliente(
                        PEPAISC IN NUMBER,
                        PETDOCC IN NUMBER,
                        PENDOCC IN VARCHAR2
                       )return varchar2;
-------------------------------------------------------------------------------------------------------------
Procedure Saldo_Cliente (
                         Pgcod IN NUMBER,
                         Pepais IN NUMBER,
                         petdoc IN NUMBER,
                         pendoc IN VARCHAR2,
                         califi OUT varchar2,
                         saltot OUT NUMBER,
                         sucur  OUT NUMBER
                       );
-------------------------------------------------------------------------------------------------------------
Function Verifica_mes(PAIS IN NUMBER,
                      TDOC IN NUMBER,
                      NDOC IN VARCHAR2,
                      VMES  IN VARCHAR2
                       )RETURN VARCHAR2;
-------------------------------------------------------------------------------------------------------------
Function Verifica_VEN(PAISV IN NUMBER,
                      TDOCV IN NUMBER,
                      NDOCV IN VARCHAR2,
                      MESV  IN VARCHAR2
                       )RETURN VARCHAR2;
-------------------------------------------------------------------------------------------------------------
end PQ_AH_SEGMENTACION;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_SEGMENTACION IS
-- ------------------------------------------------------------------------------------------------
  -- NOMBRE                : PQ_AH_SEGMENTACION
  -- SISTEMA               : BANTOTAL
  -- M¿DULO                : PASIVAS
  -- VERSI¿N               : 1.0
  -- FECHA DE CREACI¿N     : 23/12/2013
  -- AUTOR DE CREACI¿N     : SILVIA PATRICIA MARQUEZ AVENDA¿O
  -- APLICACION            : REALIZA LA SEGMENTACION DE CLIENTES-EJECUTIVOS
  -- ESTADO                : ACTIVO
  -- ACCESO                : P¿BLICO
  --------------------------------------------------------------------------------------------------
  -- Modificacion          : Smarquez 18/03/2015
  -- PRY4920 - NUEVA SEGMENTACION (CVILLON 2023.01.26)
  --------------------------------------------------------------------------------------------------
  

PROCEDURE ASIGNACION_CLIENTE(PGCOD IN NUMBER,
                             TIPOPE IN NUMBER,
                             UBUSER IN VARCHAR2,
                             SUCURS IN NUMBER,
                             PEPAIS IN NUMBER,
                             PETDOC IN NUMBER,
                             PENDOC IN VARCHAR2,
                             USUARIO  IN VARCHAR2,
                             SALDOMIN IN NUMBER,
                             SALDOMAX IN NUMBER,
                             ONOMASTICO  IN VARCHAR2,
                             VENCIMIENTO IN VARCHAR2,
                             RPTA OUT VARCHAR2)IS

   TYPE REG_JAQL61 IS RECORD (J61PGCO  NUMBER,
                              J61PAIS  NUMBER,
                              J61TDOC  NUMBER,
                              J61NDOC  CHAR(12),
                              NOMBRE   CHAR(30),
                              J61AU01  CHAR(1),
                              J61AU03  NUMBER,
                              J61AU05  NUMBER);

    TYPE V_OBJECT IS TABLE of REG_JAQL61 INDEX BY BINARY_INTEGER;

    TYPE REG_JAQL60 IS RECORD (J60PGCO  NUMBER,
                               J60PAIS  NUMBER,
                               J60TDOC  NUMBER,
                               J60NDOC  CHAR(12),
                               NOMBRE  CHAR(30),
                               J60SUCU  NUMBER,
                               J60SATO  NUMBER(17,2),
                               J60CALI  CHAR(1));
    TYPE V_TABLA  IS TABLE OF REG_JAQL60 INDEX BY BINARY_INTEGER;

    TYPE matriz_rowid IS TABLE OF ROWID;
    TYPE matriz_JAQY653PAI IS TABLE OF JAQY653.JAQY653PAI%TYPE;
    TYPE matriz_JAQY653TDO IS TABLE OF JAQY653.JAQY653TDO%TYPE;
    TYPE matriz_JAQY653NDO IS TABLE OF JAQY653.JAQY653NDO%TYPE;
    TYPE matriz_JAQY653ONO IS TABLE OF JAQY653.JAQY653ONO%TYPE;
    TYPE matriz_JAQY653VEN IS TABLE OF JAQY653.JAQY653VEN%TYPE;


    DATOS     V_OBJECT;
    DATO1     V_TABLA;


    CURSOR TOT (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653ASI = 2;
     CURSOR VEN (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, VCTO CHAR)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653VEN = VCTO
            AND JAQY653ASI = 2;
     CURSOR ONO (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, ONO CHAR)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653ONO = ONO
            AND JAQY653ASI = 2;
     CURSOR ONOVEN (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, ONO CHAR, VEN CHAR)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653ONO = ONO
            AND JAQY653VEN = VEN
            AND JAQY653ASI = 2;
     CURSOR TODO (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, ONO CHAR, VEN CHAR,SMIN NUMBER,SMAX NUMBER)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653ONO = ONO
            AND JAQY653VEN = VEN
            AND JAQY653SAL >= SMIN
            AND JAQY653SAL <= SMAX
            AND JAQY653ASI = 2;
     CURSOR SALVEN (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, VEN CHAR,SMIN NUMBER,SMAX NUMBER)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653VEN = VEN
            AND JAQY653SAL >= SMIN
            AND JAQY653SAL <= SMAX
            AND JAQY653ASI = 2;
     CURSOR SALONO (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR, ONO CHAR,SMIN NUMBER,SMAX NUMBER)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653ONO = ONO
            AND JAQY653SAL >= SMIN
            AND JAQY653SAL <= SMAX
            AND JAQY653ASI = 2;
     CURSOR SALDOS (USUARIO1 CHAR, SUC NUMBER, CLASE CHAR,SMIN NUMBER,SMAX NUMBER)IS
         SELECT *
           FROM JAQY653
          WHERE JAQY653USU = USUARIO1
            AND JAQY653SUC = SUC
            AND JAQY653CLA = CLASE
            AND JAQY653SAL >= SMIN
            AND JAQY653SAL <= SMAX
            AND JAQY653ASI = 2;

    CURSOR MODIFICA (VAR_USU IN VARCHAR2) IS
       SELECT rowid, JAQY653PAI, JAQY653TDO, JAQY653NDO, JAQY653ONO,JAQY653VEN
         FROM JAQY653
        WHERE JAQY653USU = VAR_USU
          AND JAQY653ASI = 2;

    m_rowid      matriz_rowid;
    m_JAQY653PAI matriz_JAQY653PAI;
    m_JAQY653TDO matriz_JAQY653TDO;
    m_JAQY653NDO matriz_JAQY653NDO;
    m_JAQY653ONO matriz_JAQY653ONO;
    m_JAQY653VEN matriz_JAQY653VEN;
    contador NUMBER := 500;

    VAR CHAR := NULL;
    JAQL61PGCO  JAQL061.JAQL61PGCO%TYPE;
    JAQL61USER  JAQL061.JAQL61USER%TYPE;
    JAQL61ESTA  JAQL061.JAQL61ESTA%TYPE;
    USU CHAR(10);
    DOC CHAR(12);
    VAR1 JAQL063.JAQL63CH04%TYPE;
    VAR2 JAQL063.JAQL63DE01%TYPE;
    VAR3 JAQL063.JAQL63NU03%TYPE;
    CALI JAQL060.JAQL60CALI%TYPE;
    VUSU CHAR(10);
    VUBUSER CHAR(10);
    VUSER CHAR(10);
    CALIF CHAR(1);
    FECHA DATE;
    v_MES VARCHAR2(10);
BEGIN
       fecha := sysdate;

      SELECT to_chaR(fecha,'FMMONTH')
        INTO v_MES
        FROM  DUAL;

        CASE TIPOPE

             WHEN  1
             THEN
                  VAR :='1';-- VALIDA_AGENCIA(PGCOD,SUCURS);
                  IF VAR = '1' THEN
                     BEGIN
                       INSERT INTO JAQL062 (JAQL62PGCO,
                                            JAQL62USER,
                                            JAQL62SUCU,
                                            JAQL62ESTA)
                                    VALUES (1,
                                            UBUSER,
                                            SUCURS,
                                            'S');
                       COMMIT;
                     EXCEPTION
                       WHEN DUP_VAL_ON_INDEX THEN
                         BEGIN
                           UPDATE JAQL062
                              SET JAQL62ESTA='S'
                            WHERE JAQL62PGCO = PGCOD
                              AND JAQL62USER = UBUSER
                              AND JAQL62SUCU = SUCURS
                              AND JAQL62ESTA = 'N';
                           COMMIT;
                         EXCEPTION
                           WHEN OTHERS THEN
                             RPTA := 'NO SE PUDO REALIZAR LA OPERACION';
                         END;
                     END;
                  ELSE
                     RPTA := VAR;
                  END IF;
             /*     
             WHEN  2 --ELIMINA ASIGNACION DE AGENCIA EJECUTIVO
             THEN
                   BEGIN
                     UPDATE JAQL062
                       SET JAQL62ESTA = 'N'
                     WHERE JAQL62PGCO = PGCOD
                       AND JAQL62USER = UBUSER
                       AND JAQL62SUCU = SUCURS;
                     COMMIT;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        RPTA := 'NO SE PUDO REALIZAR LA OPERACION';
                   END;
                   BEGIN
                        UPDATE JAQL061 B
                           SET B.JAQL61ESTA = 'N',
                               B.JAQL61FECH = TO_CHAR(SYSDATE,'DD/MM/RRRR')
                         WHERE EXISTS (SELECT NULL
                                         FROM JAQL060 A
                                        WHERE A.JAQL60PAIS = B.JAQL61PAIS
                                          AND A.JAQL60TDOC = B.JAQL61TDOC
                                          AND A.JAQL60NDOC = B.JAQL61NDOC
                                          AND A.JAQL60SUCU = SUCURS
                                          AND B.JAQL61PGCO = PGCOD
                                          AND B.JAQL61USER = UBUSER
                                          AND B.JAQL61ESTA = 'S');
                         COMMIT;
                   EXCEPTION
                      WHEN  OTHERS THEN
                        RPTA:= 'NO SE PUDO REALIZAR LA OPERACION';
                   END;
                   */


             WHEN  2 --ELIMINA ASIGNACION DE AGENCIA EJECUTIVO (NVA.SEGMENTACION)
             THEN
                   BEGIN
                     UPDATE JAQL062
                       SET JAQL62ESTA = 'N'
                     WHERE JAQL62PGCO = PGCOD
                       AND JAQL62USER = UBUSER
                       AND JAQL62SUCU = SUCURS;
                     COMMIT;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        RPTA := 'NO SE PUDO REALIZAR LA OPERACION';
                   END;
                   BEGIN
                        UPDATE JAQL061 B
                           SET B.JAQL61ESTA = 'N',
                               B.JAQL61FECH = TO_CHAR(SYSDATE,'DD/MM/RRRR')
                         WHERE EXISTS (SELECT NULL
                                         FROM JAQL750 A
                                        WHERE A.JAQL750PAIS = B.JAQL61PAIS
                                          AND A.JAQL750TDOC = B.JAQL61TDOC
                                          AND A.JAQL750NDOC = B.JAQL61NDOC
                                          AND A.JAQL750SUCU = SUCURS
                                          AND B.JAQL61PGCO  = PGCOD
                                          AND B.JAQL61USER  = UBUSER
                                          AND B.JAQL61ESTA  = 'S');
                         COMMIT;
                   EXCEPTION
                      WHEN  OTHERS THEN
                        RPTA:= 'NO SE PUDO REALIZAR LA OPERACION';
                   END;

              WHEN 3 -- CARGA CLIENTE DE USUARIO
              THEN
                   BEGIN
                     VUSU := TRIM(USUARIO);
                     DELETE JAQY653
                    --  WHERE JAQY653USU  = VUSU
                        WHERE JAQY653ASI = 1;
                     COMMIT;

                     VUBUSER := TRIM(UBUSER);

                     SELECT j.jaql61pgco,
                            j.jaql61pais,
                            j.jaql61tdoc,
                            j.jaql61ndoc,
                            NVL((SELECT PENOM FROM FSD001 WHERE PEPAIS = j.JAQL61PAIS
                                                        AND PETDOC = j.JAQL61TDOC
                                                        AND PENDOC = j.jaql61ndoc),'No hay valor'),
                            j.jaql61au01,
                            j.jaql61au03,
                            j.JAQL61AU05
                       BULK COLLECT INTO
                            DATOS
                       FROM JAQL061 J
                      WHERE j.JAQL61PGCO = 1
                        AND j.JAQL61USER = VUBUSER
                        AND j.JAQL61ESTA = 'S';

                         FORALL I IN  1..DATOS.COUNT
                         INSERT INTO JAQY653(JAQY653PAI,
                                              JAQY653TDO,
                                              JAQY653NDO,
                                              JAQY653NOM,
                                              JAQY653SUC,
                                              JAQY653CLA,
                                              JAQY653SAL,
                                              JAQY653ASI,
                                              JAQY653FEC,
                                              JAQY653USU)
                                     VALUES (DATOS(I).J61PAIS,
                                             DATOS(I).J61TDOC,
                                             DATOS(I).J61NDOC,
                                             DATOS(I).NOMBRE,
                                             DATOS(I).J61AU05,
                                             DATOS(I).J61AU01,
                                             DATOS(I).J61AU03,
                                             1,
                                             SYSDATE,
                                             VUSU);


                         COMMIT;
                        EXCEPTION
                         WHEN DUP_VAL_ON_INDEX THEN
                           RPTA := 'NO SE REALIZO LA OPERACION';
                       END;


              WHEN 4 --LIBERA CARTERA
              THEN

                   BEGIN
                      SELECT A.JAQL61PGCO, A.JAQL61USER, A.JAQL61ESTA
                         INTO JAQL61PGCO, JAQL61USER, JAQL61ESTA
                         FROM JAQL061 A
                        WHERE JAQL61PGCO = PGCOD
                          AND JAQL61USER = UBUSER
                          AND JAQL61ESTA = 'S';
                   END;
                   BEGIN
                       UPDATE JAQL061
                          SET JAQL61ESTA = 'N',
                              JAQL61FECH = SYSDATE
                        WHERE JAQL61PGCO = PGCOD
                          AND JAQL61USER = UBUSER
                          AND JAQL61ESTA = 'S';
                       COMMIT;
                   EXCEPTION
                      WHEN OTHERS THEN
                          RPTA := 'NO SE PUDO REALIZAR LA OPERACION.';-- PGCOD:'+STR(PGCOD)+', UBUSER:(UBUSER)'
                   END;

              WHEN 5
              THEN
                   BEGIN
                     UPDATE JAQL061
                        SET JAQL61ESTA ='N',
                            JAQL61FECH = TO_CHAR(SYSDATE,'DD/MM/RRRR')
                      WHERE JAQL61PGCO = PGCOD
                        AND JAQL61USER = TRIM(UBUSER)
                        AND JAQL61PAIS = PEPAIS
                        AND JAQL61TDOC = PETDOC
                        AND JAQL61NDOC = PENDOC
                        AND JAQL61ESTA = 'S';
                     COMMIT;
                   EXCEPTION
                     WHEN OTHERS THEN
                       RPTA := 'NO SE PUDO REALIZAR LA OPERACION. PGCOD:'||PGCOD||' UBUSER: '||UBUSER||' PENDOC: '||PENDOC;
                   END;
              /*     
              WHEN 6 --CARGA TODOS LOS CLIENTES
              THEN

                   BEGIN
                     USU := TRIM(USUARIO);

                     DELETE FROM  JAQY653 B
                      WHERE B.JAQY653USU =USU
                        AND B.JAQY653ASI = 2;
                     COMMIT;
                     CALI := TRIM(PENDOC);

                     SELECT A.JAQL60PGCO,
                            A.JAQL60PAIS,
                            A.JAQL60TDOC,
                            TRIM(A.JAQL60NDOC),
                            NVL((SELECT PENOM
                                  FROM FSD001
                                 WHERE PEPAIS = A.JAQL60PAIS
                                   AND PETDOC = A.JAQL60TDOC
                                   AND PENDOC = A.JAQL60NDOC),
                                'No hay valor'),
                            A.JAQL60SUCU,
                            A.JAQL60SATO,
                            A.JAQL60CALI BULK COLLECT
                       INTO DATO1
                       FROM JAQL060 A
                      WHERE A.JAQL60SUCU = SUCURS
                        AND A.JAQL60CALI = CALI
                        AND NOT EXISTS
                      (SELECT '1'
                               FROM JAQL061 B
                              WHERE B.JAQL61PGCO = A.JAQL60PGCO
                                AND B.JAQL61PAIS = A.JAQL60PAIS
                                AND B.JAQL61TDOC = A.JAQL60TDOC
                                AND B.JAQL61NDOC = A.JAQL60NDOC
                                AND B.JAQL61ESTA = 'S');

                     FORALL J IN 1..DATO1.COUNT
                         INSERT INTO JAQY653
                           (JAQY653PAI,
                            JAQY653TDO,
                            JAQY653NDO,
                            JAQY653NOM,
                            JAQY653SUC,
                            JAQY653CLA,
                            JAQY653SAL,
                            JAQY653ASI,
                            JAQY653FEC,
                            JAQY653USU)
                         VALUES
                           (DATO1(J).J60PAIS,
                            DATO1(J).J60TDOC,
                            DATO1(J).J60NDOC,
                            DATO1(J).NOMBRE,
                            DATO1(J).J60SUCU,
                            DATO1(J).J60CALI,
                            DATO1(J).J60SATO,
                            2,
                            SYSDATE,
                            USU);
                         COMMIT;
                        BEGIN
                          OPEN MODIFICA(USU);
                          LOOP
                          FETCH MODIFICA BULK COLLECT
                           INTO m_rowid, m_JAQY653PAI, m_JAQY653TDO, m_JAQY653NDO,m_JAQY653ONO, m_JAQY653VEN LIMIT contador;
                          FOR X IN 1 .. m_rowid.count LOOP
                            m_JAQY653ONO(X) := VERIFICA_MES(m_JAQY653PAI(X), m_JAQY653TDO(X), m_JAQY653NDO(X),v_MES);
                            m_JAQY653VEN(X) := Verifica_VEN(m_JAQY653PAI(X), m_JAQY653TDO(X), m_JAQY653NDO(X),v_MES);
                          END LOOP;

                          FORALL X IN 1 .. m_rowid.count
                          UPDATE JAQY653 A
                             SET A.JAQY653ONO  = m_JAQY653ONO(X),
                                 A.JAQY653VEN  = m_JAQY653VEN(X)
                           WHERE A.ROWID = m_rowid(X);
                           EXIT WHEN MODIFICA%NOTFOUND;
                          END LOOP;
                          COMMIT;
                          CLOSE MODIFICA;
                       END;
                      EXCEPTION
                      WHEN DUP_VAL_ON_INDEX THEN
                         RPTA:='ERRROR';
                   END;
                   */
                   
             WHEN 6 --CARGA TODOS LOS CLIENTES (NVA.SEGMENTACION)
              THEN

                   BEGIN
                     USU := TRIM(USUARIO);

                     DELETE FROM  JAQY653 B
                      WHERE B.JAQY653USU = USU
                        AND B.JAQY653ASI = 2;
                     COMMIT;
                     CALI := TRIM(PENDOC);
                     
                     

                     SELECT A.JAQL750PGCO,
                            A.JAQL750PAIS,
                            A.JAQL750TDOC,
                            TRIM(A.JAQL750NDOC),
                            NVL((SELECT PENOM
                                  FROM FSD001
                                 WHERE PEPAIS = A.JAQL750PAIS
                                   AND PETDOC = A.JAQL750TDOC
                                   AND PENDOC = A.JAQL750NDOC),
                                'No hay valor'),
                            A.JAQL750SUCU,
                            A.JAQL750SAHO,
                            TRIM(TO_CHAR(A.JAQL750SEGM)) BULK COLLECT
                       INTO DATO1
                       FROM JAQL750 A
                      WHERE A.JAQL750SUCU = SUCURS
                        AND A.JAQL750SEGM = TO_NUMBER(TRIM(CALI))
                        --AND A.JAQL750SEGM = 3
                        AND NOT EXISTS
                      (SELECT '1'
                               FROM JAQL061 B
                              WHERE B.JAQL61PGCO = A.JAQL750PGCO
                                AND B.JAQL61PAIS = A.JAQL750PAIS
                                AND B.JAQL61TDOC = A.JAQL750TDOC
                                AND B.JAQL61NDOC = A.JAQL750NDOC
                                AND B.JAQL61ESTA = 'S');

                     FORALL J IN 1..DATO1.COUNT
                         INSERT INTO JAQY653
                           (JAQY653PAI,
                            JAQY653TDO,
                            JAQY653NDO,
                            JAQY653NOM,
                            JAQY653SUC,
                            JAQY653CLA,
                            JAQY653SAL,
                            JAQY653ASI,
                            JAQY653FEC,
                            JAQY653USU)
                         VALUES
                           (DATO1(J).J60PAIS,
                            DATO1(J).J60TDOC,
                            DATO1(J).J60NDOC,
                            DATO1(J).NOMBRE,
                            DATO1(J).J60SUCU,
                            DATO1(J).J60CALI,
                            DATO1(J).J60SATO,
                            2,
                            SYSDATE,
                            USU);
                         COMMIT;
                        BEGIN
                          OPEN MODIFICA(USU);
                          LOOP
                          FETCH MODIFICA BULK COLLECT
                           INTO m_rowid, m_JAQY653PAI, m_JAQY653TDO, m_JAQY653NDO,m_JAQY653ONO, m_JAQY653VEN LIMIT contador;
                          FOR X IN 1 .. m_rowid.count LOOP
                            m_JAQY653ONO(X) := VERIFICA_MES(m_JAQY653PAI(X), m_JAQY653TDO(X), m_JAQY653NDO(X),v_MES);
                            m_JAQY653VEN(X) := Verifica_VEN(m_JAQY653PAI(X), m_JAQY653TDO(X), m_JAQY653NDO(X),v_MES);
                          END LOOP;

                          FORALL X IN 1 .. m_rowid.count
                          UPDATE JAQY653 A
                             SET A.JAQY653ONO  = m_JAQY653ONO(X),
                                 A.JAQY653VEN  = m_JAQY653VEN(X)
                           WHERE A.ROWID = m_rowid(X);
                           EXIT WHEN MODIFICA%NOTFOUND;
                          END LOOP;
                          COMMIT;
                          CLOSE MODIFICA;
                       END;
                      EXCEPTION
                      WHEN DUP_VAL_ON_INDEX THEN
                         RPTA:='ERRROR';
                   END; 

              WHEN 7 --ASIGNA cliente seleccionados
              THEN

                   BEGIN
                     USU := TRIM(USUARIO);
                     DOC := TRIM(PENDOC);
                     VUBUSER := UBUSER;
                     SELECT C.JAQY653CLA,C.JAQY653SAL,C.JAQY653SUC
                       INTO VAR1 , VAR2, VAR3
                      FROM JAQY653 C
                      WHERE C.JAQY653PAI = PEPAIS
                        AND C.JAQY653TDO = PETDOC
                        AND C.JAQY653NDO = DOC
                        AND C.JAQY653USU = USU
                        AND C.JAQY653ASI = 2;
                     BEGIN
                       INSERT INTO JAQL061 (JAQL61PGCO,
                                            JAQL61PAIS,
                                            JAQL61TDOC,
                                            JAQL61NDOC,
                                            JAQL61USER,
                                            JAQL61FECH,
                                            JAQL61AU01,
                                            JAQL61AU03,
                                            JAQL61AU05,
                                            JAQL61ESTA)
                                    VALUES (PGCOD,
                                            PEPAIS,
                                            PETDOC,
                                            DOC,
                                            VUBUSER,
                                            SYSDATE,
                                            VAR1,
                                            VAR2,
                                            VAR3,
                                            'S');
                       COMMIT;
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                          BEGIN

                            UPDATE JAQL061
                               SET JAQL61ESTA = 'S',
                                   JAQL61FECH = SYSDATE,
                                   JAQL61AU01 = VAR1,
                                   JAQL61AU03 = VAR2,
                                   JAQL61AU05 = VAR3
                             WHERE JAQL61PGCO = PGCOD
                               AND JAQL61USER = VUBUSER
                               AND JAQL61PAIS = PEPAIS
                               AND JAQL61TDOC = PETDOC
                               AND JAQL61NDOC = DOC
                               AND JAQL61ESTA = 'N';
                            COMMIT;
                          EXCEPTION
                            WHEN OTHERS THEN
                               RPTA := 'NOSE PUDO REALIZAR LA OPERACION PGCOD'|| PGCOD || ' '||USU||' ' ||PENDOC;
                          END;
                     END;
                     DELETE JAQY653 R
                      WHERE R.JAQY653USU = USU
                        AND R.JAQY653ASI = 2
                        AND R.JAQY653PAI = PEPAIS
                        AND R.JAQY653TDO = PETDOC
                        AND R.JAQY653NDO = DOC;
                     COMMIT;
                   END;

                 WHEN 8 --ASIGNA TODO
                 THEN
                   BEGIN
                     USU   := TRIM(USUARIO);
                     VUSER := TRIM(UBUSER);
                     CALIF := TRIM(PENDOC);
                     CASE PEPAIS
                          WHEN 000
                          THEN
                               FOR K IN TOT(USU,SUCURS,CALIF ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653ASI = 2;
                               COMMIT; -----&SaldoMax = 0 and &ONO = 'N' and &VEN = 'S'
                          WHEN   001
                          THEN
                              FOR K IN VEN(USU,SUCURS,CALIF, VENCIMIENTO ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653VEN = VENCIMIENTO
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                       WHEN   010   -- if &SaldoMax = 0 and &ONO = 'S' and &VEN = 'N'
                       THEN
                              FOR K IN ONO(USU,SUCURS,CALIF, ONOMASTICO ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653VEN = ONOMASTICO
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                       WHEN   011   --&SaldoMax = 0 and &ONO = 'S' and &VEN = 'S'
                       THEN
                              FOR K IN ONOVEN(USU,SUCURS,CALIF, ONOMASTICO,VENCIMIENTO ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653ONO = ONOMASTICO
                                  AND Q.JAQY653VEN = VENCIMIENTO
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                      WHEN   111   -- &SaldoMax <> 0 and &ONO = 'S' and &VEN = 'S'
                      THEN
                              FOR K IN TODO(USU,SUCURS,CALIF,ONOMASTICO,VENCIMIENTO,SALDOMIN,SALDOMAX ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653ONO = ONOMASTICO
                                  AND Q.JAQY653VEN = VENCIMIENTO
                                  AND Q.JAQY653SAL >= SALDOMIN
                                  AND Q.JAQY653SAL <= SALDOMAX
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                       WHEN   101    ---&SaldoMax <> 0 and &ONO = 'N' and &VEN = 'S'
                       THEN
                              FOR K IN SALVEN(USU,SUCURS,CALIF,VENCIMIENTO,SALDOMIN,SALDOMAX ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653VEN = VENCIMIENTO
                                  AND Q.JAQY653SAL >= SALDOMIN
                                  AND Q.JAQY653SAL <= SALDOMAX
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                       WHEN   110    --- &SaldoMax <> 0 and &ONO = 'S' and &VEN = 'N'
                       THEN
                              FOR K IN SALONO(USU,SUCURS,CALIF,ONOMASTICO,SALDOMIN,SALDOMAX ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653ONO = ONOMASTICO
                                  AND Q.JAQY653SAL >= SALDOMIN
                                  AND Q.JAQY653SAL <= SALDOMAX
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                      WHEN   100  ----  &SaldoMax <> 0 and &ONO = 'N' and &VEN = 'N'
                      THEN
                              FOR K IN SALDOS(USU,SUCURS,CALIF,SALDOMIN,SALDOMAX ) LOOP
                                 BEGIN
                                   INSERT INTO JAQL061 (JAQL61PGCO,
                                                   JAQL61PAIS,
                                                   JAQL61TDOC,
                                                   JAQL61NDOC,
                                                   JAQL61USER,
                                                   JAQL61FECH,
                                                   JAQL61AU01,
                                                   JAQL61AU03,
                                                   JAQL61AU05,
                                                   JAQL61ESTA)
                                           VALUES (PGCOD,
                                                   K.JAQY653PAI,
                                                   K.JAQY653TDO,
                                                   K.JAQY653NDO,
                                                   VUSER,
                                                   SYSDATE,
                                                   K.JAQY653CLA,
                                                   K.JAQY653SAL,
                                                   K.JAQY653SUC,
                                                   'S');
                                  COMMIT;
                                EXCEPTION
                                  WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE JAQL061
                                           SET JAQL61ESTA = 'S',
                                               JAQL61FECH = SYSDATE,
                                               JAQL61AU01 = K.JAQY653CLA,
                                               JAQL61AU03 = K.JAQY653SAL,
                                               JAQL61AU05 = K.JAQY653SUC
                                         WHERE JAQL61PGCO = PGCOD
                                           AND JAQL61USER = VUSER
                                           AND JAQL61PAIS = K.JAQY653PAI
                                           AND JAQL61TDOC = K.JAQY653TDO
                                           AND JAQL61NDOC = K.JAQY653NDO
                                           AND JAQL61ESTA = 'N';
                                        COMMIT;
                                 END;
                              END LOOP;
                               DELETE JAQY653 Q
                                WHERE Q.JAQY653USU = USU
                                  AND Q.JAQY653SUC = SUCURS
                                  AND Q.JAQY653CLA = CALIF
                                  AND Q.JAQY653SAL >= SALDOMIN
                                  AND Q.JAQY653SAL <= SALDOMAX
                                  AND Q.JAQY653ASI = 2;
                               COMMIT;
                      END CASE;
                 END;

        ELSE RPTA:='NO EXISTE EL TIPO DE OPERACION ';
        END CASE;

END ASIGNACION_CLIENTE;


FUNCTION VALIDA_AGENCIA(PGCOD IN NUMBER,
                        SUCURS IN NUMBER)RETURN VARCHAR2 IS
   VARIABLE VARCHAR(1);
   VARIABLE1 VARCHAR(30);

BEGIN
   SELECT '1' INTO VARIABLE
     FROM FST001
    WHERE PGCOD = PGCOD
      AND SUCURS = SUCURS;
    RETURN VARIABLE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       VARIABLE1 := 'NO SE PUDO REALIZAR LA OPERACION. SUCURSAL INCORRECTA.';
       RETURN VARIABLE1;
END VALIDA_AGENCIA;

FUNCTION NOMBRE_CLIENTE(PEPAISC IN NUMBER,
                        PETDOCC IN NUMBER,
                        PENDOCC IN VARCHAR2)RETURN VARCHAR2 IS
   PENOM1 VARCHAR2(30);

BEGIN

   SELECT PENOM INTO PENOM1
     FROM FSD001
  WHERE PEPAIS = PEPAISC
    AND PETDOC = PETDOCC
    AND PENDOC = TRIM(PENDOCC);
    RETURN PENOM1;
EXCEPTION

  WHEN NO_DATA_FOUND THEN
     RETURN 'Nro No valido';
END NOMBRE_CLIENTE;

/*
PROCEDURE SALDO_CLIENTE ( PGCOD IN NUMBER,
                         PEPAIS IN NUMBER,
                         PETDOC IN NUMBER,
                         PENDOC IN VARCHAR2,
                         CALIFI OUT VARCHAR2,
                         SALTOT OUT NUMBER,
                         SUCUR  OUT NUMBER
                       )IS
BEGIN

  SELECT JAQL60CALI,JAQL60SATO,JAQL60SUCU
    INTO CALIFI,SALTOT,SUCUR
    FROM JAQL060
   WHERE JAQL60PGCO = PGCOD
     AND JAQL60PAIS = PEPAIS
     AND JAQL60TDOC = PETDOC
     AND JAQL60NDOC = PENDOC;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        CALIFI := '';
        SALTOT := 0;
        SUCUR := 0;
END SALDO_CLIENTE;
*/

--***(NVA.SEGMENTACION)
PROCEDURE SALDO_CLIENTE (PGCOD IN NUMBER,
                         PEPAIS IN NUMBER,
                         PETDOC IN NUMBER,
                         PENDOC IN VARCHAR2,
                         CALIFI OUT VARCHAR2,
                         SALTOT OUT NUMBER,
                         SUCUR  OUT NUMBER
                       )IS
BEGIN

  SELECT TO_CHAR(JAQL750SEGM), JAQL750POSI, JAQL750SUCU
    INTO CALIFI, SALTOT, SUCUR
    FROM JAQL750
   WHERE JAQL750PGCO = PGCOD
     AND JAQL750PAIS = PEPAIS
     AND JAQL750TDOC = PETDOC
     AND JAQL750NDOC = PENDOC;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        CALIFI := '';
        SALTOT := 0;
        SUCUR := 0;
END SALDO_CLIENTE;

function VERIFICA_MES(PAIS IN NUMBER,
                      TDOC IN NUMBER,
                      NDOC IN VARCHAR2,
                      VMES IN VARCHAR2
                      )RETURN VARCHAR2 is

  lv_RTA VARCHAR2(1);
  mes varchar(20);
  begin
    BEGIN
      SELECT to_char(PFFNAC,'FMMONTH')
        into Mes
        FROM FSD002
        WHERE PFPAIS = PAIS
          AND PFTDOC = TDOC
          AND PFNDOC = NDOC;
    Exception
       When no_data_found then
         bEGIN
           SELECT TO_CHAR(Pjfcon,'FMMONTH')
             into Mes
             FROM FSD003
            WHERE PJPAIS = PAIS
              AND PJTDOC = TDOC
              AND PJNDOC = ndoc;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            MES:= 'NINGUNO';
       END;
   End;

      IF MES = VMES THEN
         lv_RTA := 'S';
      ELSE
         lv_RTA := 'N';
      END IF;
      return lv_RTA;
end;

/*
FUNCTION Verifica_VEN(PAISV IN NUMBER,
                      TDOCV IN NUMBER,
                      NDOCV IN VARCHAR2,
                      MESV  IN VARCHAR2)RETURN VARCHAR2 IS
  CONTROL NUMBER;
  LV_VEN  VARCHAR2(1);

  CURSOR CTA_DPF IS
  SELECT TO_CHAR(F1.AOFVTO,'FMMONTH') MES
    FROM FSR008 F8,
         FSD010 F1
   WHERE f8.pgcod  = f1.pgcod
     and F8.PEPAIS = PAISV
     AND F8.PETDOC = TDOCV
     AND F8.PENDOC = NDOCV
     AND F1.AOCTA  = F8.CTNRO
     AND F1.AOMOD  = 22
     AND F1.AOSTAT <> 99;

BEGIN

   SELECT 1
     INTO CONTROL
     FROM JAQL060 J6
    WHERE J6.JAQL60PAIS = PAISV
      AND J6.JAQL60TDOC = TDOCV
      AND J6.JAQL60NDOC = NDOCV
      AND J6.JAQL60SAPF <> 0;
    IF CONTROL = 1 THEN
       FOR C1 IN CTA_DPF LOOP
           IF C1.MES = MESV THEN
              LV_VEN := 'S';
              EXIT;
           ELSE
               LV_VEN := 'N';
           END IF;
       END LOOP;
       RETURN LV_VEN;
    ELSE
       LV_VEN := 'N';
       RETURN  LV_VEN;
    END IF;

EXCEPTION
  When NO_DATA_FOUND THEN
     LV_VEN := 'N';
     RETURN  LV_VEN;
END;
*/

---***(NVA.SEGMENTACION)
FUNCTION Verifica_VEN(PAISV IN NUMBER,
                      TDOCV IN NUMBER,
                      NDOCV IN VARCHAR2,
                      MESV  IN VARCHAR2)RETURN VARCHAR2 IS
  CONTROL NUMBER;
  LV_VEN  VARCHAR2(1);

  CURSOR CTA_DPF IS
  SELECT TO_CHAR(F1.AOFVTO,'FMMONTH') MES
    FROM FSR008 F8,
         FSD010 F1
   WHERE f8.pgcod  = f1.pgcod
     and F8.PEPAIS = PAISV
     AND F8.PETDOC = TDOCV
     AND F8.PENDOC = NDOCV
     AND F1.AOCTA  = F8.CTNRO
     AND F1.AOMOD  = 22
     AND F1.AOSTAT <> 99;

BEGIN

   SELECT 1
     INTO CONTROL
     FROM JAQL750 J6
    WHERE J6.JAQL750PAIS = PAISV
      AND J6.JAQL750TDOC = TDOCV
      AND J6.JAQL750NDOC = NDOCV
      AND J6.JAQL750SDPF <> 0;
    IF CONTROL = 1 THEN
       FOR C1 IN CTA_DPF LOOP
           IF C1.MES = MESV THEN
              LV_VEN := 'S';
              EXIT;
           ELSE
               LV_VEN := 'N';
           END IF;
       END LOOP;
       RETURN LV_VEN;
    ELSE
       LV_VEN := 'N';
       RETURN  LV_VEN;
    END IF;

EXCEPTION
  When NO_DATA_FOUND THEN
     LV_VEN := 'N';
     RETURN  LV_VEN;
END;

END PQ_AH_SEGMENTACION;
/

