create or replace procedure SP_INSERTA_JAQL099(PGFAPE  date,
                                               certini number,
                                               certfin number) is
  error varchar2(200);

  cursor seg is
    select PGFAPE,
           trim("CodProducto") "CODPRODUCTOCOBRO",
           trim("NumCertificado") "NUMCERTIFICADOCOBRO",
           trim("NumCuota") "NUMCUOTACOBRO",
           trim("IDTitularCta") "IDTITULARCTA",
           trim("TipoID") "TIPOID",
           trim("TipoCta") "TIPOCTA",
           trim("NumCta") "NUMCTA",
           trim("NumTarjeta") "NUMTARJETA",
           trim("MontoPrimaCuota") "MONTOPRIMACUOTA",
           trim("FecEmisionCuota") "FECEMISIONCUOTA",
           '97' estado,
           'SIN PROCESAR' descestado
      from "CMAC_Cobros"@sisretail
     where to_number(trim("NumCertificado")) >= certini
       and to_number(trim("NumCertificado")) <= certfin;

begin

  delete from JAQL099
   where jaql99fepr = PGFAPE
     and codproductocobro99 in ('0001', '0002', '0003', '0006', '0007')
     and to_number(trim(NUMCERTIFICADOCOBRO99)) >= certini
     and to_number(trim(NUMCERTIFICADOCOBRO99)) <= certfin
     and CODERROR99 in ('96', '97');

  INSERT into jaql099
    (JAQL99FEPR,
     CODPRODUCTOCOBRO99,
     NUMCERTIFICADOCOBRO99,
     NUMCUOTACOBRO99,
     IDTITULARCTA99,
     TIPOID99,
     TIPOCTA99,
     NUMCTA99,
     NUMTARJETA99,
     MONTOPRIMACUOTA99,
     FECEMISIONCUOTA99,
     CODERROR99,
     DESCERROR99)
    select PGFAPE,
           trim("CodProducto") "CODPRODUCTOCOBRO",
           trim("NumCertificado") "NUMCERTIFICADOCOBRO",
           trim("NumCuota") "NUMCUOTACOBRO",
           trim("IDTitularCta") "IDTITULARCTA",
           trim("TipoID") "TIPOID",
           trim("TipoCta") "TIPOCTA",
           trim("NumCta") "NUMCTA",
           trim("NumTarjeta") "NUMTARJETA",
           trim("MontoPrimaCuota") "MONTOPRIMACUOTA",
           trim("FecEmisionCuota") "FECEMISIONCUOTA",
           '97',
           'SIN PROCESAR'
      from "CMAC_Cobros"@sisretail
     where to_number(trim("NumCertificado")) >= certini
       and to_number(trim("NumCertificado")) <= certfin;

  commit;

exception
  when dup_val_on_index then
    for i in seg loop
      begin
        INSERT into jaql099
          (JAQL99FEPR,
           CODPRODUCTOCOBRO99,
           NUMCERTIFICADOCOBRO99,
           NUMCUOTACOBRO99,
           IDTITULARCTA99,
           TIPOID99,
           TIPOCTA99,
           NUMCTA99,
           NUMTARJETA99,
           MONTOPRIMACUOTA99,
           FECEMISIONCUOTA99,
           CODERROR99,
           DESCERROR99)
        values
          (PGFAPE,
           i.CODPRODUCTOCOBRO,
           i.NUMCERTIFICADOCOBRO,
           i.NUMCUOTACOBRO,
           i.IDTITULARCTA,
           i.TIPOID,
           i.TIPOCTA,
           i.NUMCTA,
           i.NUMTARJETA,
           i.MONTOPRIMACUOTA,
           i.FECEMISIONCUOTA,
           i.estado,
           i.descestado);
      exception
        when dup_val_on_index then
          null;
      end;
    end loop;
  
end SP_INSERTA_JAQL099;
/

