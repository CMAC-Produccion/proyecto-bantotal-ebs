CREATE OR REPLACE PACKAGE PQ_MIGRA_LINEAS_CREDITO IS

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_LC_MONTO_LINEA (P_C_CODCLI IN VARCHAR2
                             ) RETURN NUMBER;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_LC_DATOS_BT (P_C_NUMCRE IN  VARCHAR2,
                            P_N_SUCURS OUT NUMBER,
                            P_N_MONEDA OUT NUMBER,
                            P_N_PAPEL  OUT NUMBER,
                            P_N_CTABTT OUT NUMBER,
                            P_N_OPERAC OUT NUMBER,
                            P_N_SUBOPE OUT NUMBER,
                            P_N_TOTOPE OUT NUMBER
                           );  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_LC_CARGA_BNJ002_V1(P_N_CODEMP IN NUMBER,
                               P_N_CODBAN IN NUMBER
                              );                             
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_LC_CARGA_BNJ002_V2(P_N_CODEMP IN NUMBER,
                               P_N_CODBAN IN NUMBER
                              );                             
end PQ_MIGRA_LINEAS_CREDITO;
/

