create or replace package pq_ca_rep_canales is

  FUNCTION FN_CT_Z0E4GE(p_fechaini in date, p_fechafin in date) return number;
  FUNCTION FN_CT_Z0E478_BANDA(p_fecha in date) return number;
  FUNCTION FN_CT_Z0E478_CARDLESS(p_fecha in date) return number;
  FUNCTION FN_CT_Z0E478_CARDLESSPLATIUM(p_fecha in date) return number;
  FUNCTION FN_CT_Z0E478_CHIP(p_fecha in date) return number;
  FUNCTION FN_CT_Z0E478_TODO(p_fecha in date) return number;
  PROCEDURE SP_BUSCAR_CORRESPONSALES_H(BL_DATOS   IN OUT SYS_REFCURSOR,P_NUMTAR CHAR,
                                       P_FECHAINI DATE,
                                       P_FECHAFIN DATE);
  PROCEDURE SP_BUSCAR_CORRESPONSALES(BL_DATOS   IN OUT SYS_REFCURSOR,P_NUMTAR CHAR,
                                     P_FECHAINI DATE,
                                     P_FECHAFIN DATE);
  PROCEDURE SP_BUSCAR_GLOBOKAS(BL_DATOS   IN OUT SYS_REFCURSOR,P_NUMTAR CHAR,
                               P_FECHAINI DATE,
                               P_FECHAFIN DATE);
  PROCEDURE SP_BUSCAR_HOMEBANKING(BL_DATOS   IN OUT SYS_REFCURSOR,P_NUMTAR CHAR,
                                  P_FECHAINI DATE,
                                  P_FECHAFIN DATE);
  PROCEDURE SP_BUSCAR_CAJAMOVIL(BL_DATOS   IN OUT SYS_REFCURSOR,P_NUMTAR CHAR,
                                P_FECHAINI DATE,
                                P_FECHAFIN DATE);
end pq_ca_rep_canales;
/

CREATE OR REPLACE PACKAGE BODY PQ_CA_REP_CANALES IS

  FUNCTION FN_CT_Z0E4GE(P_FECHAINI IN DATE, P_FECHAFIN IN DATE) RETURN NUMBER IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM (SELECT DISTINCT (TRIM(Z0E4GETAR))
              FROM Z0E4GE
             WHERE Z0E4GEFEC >= P_FECHAINI --ATMS 2
               AND Z0E4GEFEC < P_FECHAFIN
               AND Z0E4GEEST = '00'
               AND (TRIM(Z0E4GETAR) LIKE '426153%'));
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E4GE;

  FUNCTION FN_CT_Z0E478_BANDA(P_FECHA IN DATE) RETURN NUMBER IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM Z0E478 B
     WHERE B.Z0E478NRO LIKE '426153%'
       AND B.Z0E463COD = 1
       AND B.Z0E468COD <> 'C'--Robert B. 08042024
       AND B.Z0E478FMD < P_FECHA
       AND B.Z0E478NRO IN
           (SELECT PAN
              FROM CARD@TXNSWT
             WHERE BIN = '426153'
               AND SUBSTR(TRACK2, 22, 3) = '126')
     GROUP BY B.Z0E463COD;
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E478_BANDA;

  FUNCTION FN_CT_Z0E478_CARDLESS(P_FECHA IN DATE) RETURN NUMBER IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM Z0E478 B
     WHERE B.Z0E478NRO LIKE '426153%'
       AND B.Z0E463COD = 1
       AND B.Z0E478FMD < P_FECHA
       AND B.Z0E478NRO IN
           (SELECT PAN FROM CARD@TXNSWT WHERE PAN LIKE '4261534%')
     GROUP BY B.Z0E463COD;
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E478_CARDLESS;

  FUNCTION FN_CT_Z0E478_CARDLESSPLATIUM(P_FECHA IN DATE) RETURN NUMBER IS   --20072023
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM Z0E478 B
     WHERE B.Z0E478NRO LIKE '42615346%'
       AND B.Z0E463COD = 1
       AND B.Z0E478FMD < P_FECHA
       AND B.Z0E478NRO IN
           (SELECT PAN FROM CARD@TXNSWT WHERE PAN LIKE '4261534%')
     GROUP BY B.Z0E463COD;
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E478_CARDLESSPLATIUM;

  FUNCTION FN_CT_Z0E478_CHIP(P_FECHA IN DATE) RETURN NUMBER IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM Z0E478 B
     WHERE B.Z0E478NRO LIKE '426153%'
       AND B.Z0E463COD = 1
       AND B.Z0E478FMD < P_FECHA
       AND B.Z0E478NRO IN
           (SELECT PAN
              FROM CARD@TXNSWT
             WHERE PAN LIKE '426153%'
               AND SUBSTR(TRACK2, 22, 3) = '226')
     GROUP BY B.Z0E463COD;
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E478_CHIP;

  FUNCTION FN_CT_Z0E478_TODO(P_FECHA IN DATE) RETURN NUMBER IS
    N_CONT NUMBER;
  BEGIN
    SELECT COUNT(1)
      INTO N_CONT
      FROM Z0E478
     WHERE Z0E478NRO LIKE '426153%'
       AND Z0E463COD = 1
       AND Z0E478EST = 'AC'
       AND Z0E478FMD < P_FECHA;
    RETURN N_CONT;
  EXCEPTION
    WHEN OTHERS THEN
      N_CONT := NULL;
      RETURN N_CONT;
  END FN_CT_Z0E478_TODO;

  PROCEDURE SP_BUSCAR_CORRESPONSALES_H(BL_DATOS   IN OUT SYS_REFCURSOR,
                                       P_NUMTAR CHAR, 
                                       P_FECHAINI DATE,
                                       P_FECHAFIN DATE) IS
  BEGIN
    OPEN BL_DATOS FOR
      SELECT A.JAQL5NUTAR "Tarjeta",
             A.JAQL5FETRA "Fecha",
             A.JAQL5HOTRA "Hora",
             A.JAQL5TEXTO "Texto",
             A.JAQL5CORES "CodResp",
             B.C_DESTRA   "Descripcion",
             A.JAQL5COTRA "CodTransac",
             C.JAQL4NOCOM "Comercio",
             A.JAQL5SEISO "Trace",
             A.JAQL5CISOT,
             A.JAQL5FEHOT,
             A.JAQL5SECRE,
             A.JAQL5COAUT,
             A.JAQL5SEINT
        FROM JAQL005@BTHIST A, ITXNCOD@TXNSWT B, JAQL004 C
       WHERE A.JAQL5NUTAR = P_NUMTAR--'426153%4397'
         AND A.JAQL5FETRA >= P_FECHAINI
         AND A.JAQL5FETRA <= P_FECHAFIN
         AND B.C_CANAL = 'CC'
         AND B.C_CODTRA = LPAD(TRIM(A.JAQL5COTRA), 6, '0')
         AND C.JAQL4COCOM = A.JAQL5CISOC
         AND A.JAQL3CORED = 2
       ORDER BY JAQL5FETRA, JAQL5HOTRA;
  END SP_BUSCAR_CORRESPONSALES_H;

  PROCEDURE SP_BUSCAR_CORRESPONSALES(BL_DATOS   IN OUT SYS_REFCURSOR,
                                     P_NUMTAR CHAR, 
                                     P_FECHAINI DATE,
                                     P_FECHAFIN DATE) IS
  lc_card char(19);
  BEGIN
    lc_card := P_NUMTAR;
    OPEN BL_DATOS FOR
      SELECT A.JAQL5NUTAR "Tarjeta",
             A.JAQL5FETRA "Fecha",
             A.JAQL5HOTRA "Hora",
             A.JAQL5TEXTO "Texto",
             A.JAQL5CORES "CodResp",
             B.C_DESTRA   "Descripcion",
             A.JAQL5COTRA "CodTransac",
             C.JAQL4NOCOM "Comercio",
             A.JAQL5SEISO "Trace",
             A.JAQL5CISOT,
             A.JAQL5FEHOT,
             A.JAQL5SECRE,
             A.JAQL5COAUT,
             A.JAQL5SEINT
        FROM JAQL005 A, ITXNCOD@TXNSWT B, JAQL004 C
       WHERE A.JAQL5NUTAR = lc_card
         AND A.JAQL5FETRA >= P_FECHAINI
         AND A.JAQL5FETRA <= P_FECHAFIN
         AND B.C_CANAL = 'CC'
         AND B.C_CODTRA = LPAD(TRIM(A.JAQL5COTRA), 6, '0')
         AND C.JAQL4COCOM = A.JAQL5CISOC
         AND A.JAQL3CORED = 2
       ORDER BY JAQL5FETRA, JAQL5HOTRA;
  END SP_BUSCAR_CORRESPONSALES;

  PROCEDURE SP_BUSCAR_GLOBOKAS(BL_DATOS   IN OUT SYS_REFCURSOR,
                               P_NUMTAR CHAR, 
                               P_FECHAINI DATE,
                               P_FECHAFIN DATE) IS
  lc_card char(19);
  BEGIN
    lc_card := P_NUMTAR;
    OPEN BL_DATOS FOR
      SELECT A.JAQL673FETRA "Fecha",
             A.JAQL673HOTRA "Hora",
             A.JAQL673NUTAR "Tarjeta",
             A.JAQL673TEXTO "DescTrans",
             A.JAQL673COTRA,
             B.C_DESTRA,
             A.JAQL673TEXTI,
             A.JAQL673COMEN,
             A.JAQL673SEISO,
             A.JAQL673CISOT,
             A.JAQL673CISOC,
             A.JAQL673SEINT,
             A.JAQL673SECRE
        FROM JAQL673 A, ITXNCOD@TXNSWT B
       WHERE A.JAQL673CORED = 3
         AND A.JAQL673FETRA >= P_FECHAINI
         AND JAQL673FETRA <= P_FECHAFIN
         AND A.JAQL673NUTAR =lc_card
         AND B.C_CODTRA = A.JAQL673COTRA
       ORDER BY JAQL673FETRA, JAQL673HOTRA DESC;
  END SP_BUSCAR_GLOBOKAS;

  PROCEDURE SP_BUSCAR_HOMEBANKING(BL_DATOS   IN OUT SYS_REFCURSOR,
                                  P_NUMTAR CHAR, 
                                  P_FECHAINI DATE,
                                  P_FECHAFIN DATE) IS
  BEGIN
    OPEN BL_DATOS FOR
    
      SELECT DECODE(B.X9996ACNCO,
                    '5',
                    'HomeBanking',
                    '9',
                    'CelBanking',
                    '10',
                    'IVR',
                    '11',
                    'DataEntry',
                    '15',
                    'ConsultasVarias',
                    '80',
                    'Tarjeta Debito',
                    '105',
                    'Tarjeta Coordenadas',
                    '991',
                    'Caja Movil',
                    '994',
                    'KASNET',
                    '997',
                    'Tarjeta Coordenadas',
                    '998',
                    'Cajeros Corresponsales',
                    '999',
                    'ATMs') "Canal",
             B.X9996DFESV "Fecha",
             B.X9996DHOSV "Hora",
             B.X9996DRQSV "TransCabe",
             B.X9996DRQCL "Tarjeta",
             B.X9996GRSCO "RespTrans",
             C.X9996BOPDS "SubOpe",
             A.X9996CDESC "DetalleOpe",
             B.X9996DRQUS "UsrConex",
             B.X9996DRQWS "ConexUbica",
             B.X9996DDCTA "Cnta",
             B.X9996DIMPO "CreoImporte",
             B.X9996DIMP2 "Creo Importe2",
             B.X9996DCOTZ "AunNoSe",
             B.X9996DDPGC,
             B.X9996DDSUC,
             B.X9996DDMOD,
             B.X9996CVART,
             B.X9996BOPCO
        FROM X9996D B, X9996C A, X9996B C
       WHERE B.X9996DFESV >= P_FECHAINI
         AND B.X9996DFESV <= P_FECHAFIN
         AND B.X9996ACNCO = 5 -->HB=5,
         AND B.X9996DRQCL like trim(P_NUMTAR)||'%'
         AND B.X9996ACNCO = A.X9996ACNCO
         AND B.X9996BOPCO = A.X9996BOPCO
         AND B.X9996CVART = A.X9996CVART
         AND B.X9996BOPCO = C.X9996BOPCO
       ORDER BY B.X9996DFESV DESC, B.X9996DHOSV DESC;
  END SP_BUSCAR_HOMEBANKING;

  PROCEDURE SP_BUSCAR_CAJAMOVIL(BL_DATOS   IN OUT SYS_REFCURSOR,
                                P_NUMTAR CHAR, 
                                P_FECHAINI DATE,
                                P_FECHAFIN DATE) IS
  lc_card char(19);
  BEGIN
    lc_card := P_NUMTAR;
    OPEN BL_DATOS FOR
      SELECT A.JAQZ208SEINT "Trace",
             A.JAQZ208COTRA "CodTrans",
             B.C_DESTIP,
             B.C_DESTRA,
             A.JAQZ208FETRA "Fecha",
             A.JAQZ208HOTRA "Hora",
             A.JAQZ208CORES "CodResp",
             A.JAQZ208NUTAR "Tarjeta",
             A.JAQZ208TEXTO "Texto",
             A.JAQZ208TRAMA "Trama",
             A.JAQZ208SECRE,
             A.JAQZ208SECRS
        FROM JAQZ208 A, ITXNCOD@TXNSWT B
       WHERE A.JAQZ208FETRA >= P_FECHAINI
         AND A.JAQZ208FETRA <= P_FECHAFIN
         AND A.JAQZ208NUTAR = lc_card
         AND B.C_CANAL = 'CM'
         AND B.C_CODTRA = A.JAQZ208COTRA
       ORDER BY A.JAQZ208FETRA, A.JAQZ208HOTRA;
  END SP_BUSCAR_CAJAMOVIL;

END PQ_CA_REP_CANALES;
/

