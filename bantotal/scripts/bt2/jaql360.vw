create or replace force view jaql360 as
select
"CodProducto" "CODPRODUCTOCOBRO",
"NumCertificado" "NUMCERTIFICADOCOBRO",
"NumCuota" "NUMCUOTACOBRO",
"IDTitularCta" "IDTITULARCTA",
"TipoID" "TIPOID",
"TipoCta" "TIPOCTA",
"NumCta" "NUMCTA",
"NumTarjeta" "NUMTARJETA",
"MontoPrimaCuota" "MONTOPRIMACUOTA",
"FecEmisionCuota" "FECEMISIONCUOTA"
from  cmac_cobros@sisretail;

