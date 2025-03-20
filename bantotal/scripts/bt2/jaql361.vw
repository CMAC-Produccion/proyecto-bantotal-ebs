create or replace force view jaql361 as
select
"CodProducto" "CODPRODUCTORPTA",
"NumCertificado" "NUMCERTIFICADORPTA",
"NumCuota" "NUMCUOTARPTA",
"FecPagoCuota" "FECPAGOCUOTA",
"DocDeposito" "DOCDEPOSITO",
"FecDeposito" "FECDEPOSITO",
"CodError" "CODERROR",
"DescError" "DESCERROR",
"MontoPrimaCuota"  "MONTOPRIMA"
from  cmac_respuesta@sisretail;

