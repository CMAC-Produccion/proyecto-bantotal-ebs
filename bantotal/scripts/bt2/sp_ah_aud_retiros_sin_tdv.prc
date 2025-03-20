CREATE OR REPLACE PROCEDURE SP_AH_AUD_RETIROS_SIN_TDV(P_FECINI IN DATE, P_FECFIN IN DATE) IS

  lc_AGENOM VARCHAR(30);
  ln_PEPAIS NUMBER(3);
  ln_PETDOC NUMBER(2);
  lc_DOCNRO CHAR(12);

  lc_DOCTIP VARCHAR(20);
  lc_TITULA VARCHAR(30);

  lc_USUEXE VARCHAR(10);
  lc_USUAUT VARCHAR(10);
  ld_ACTFEC DATE;
  lc_ACTHOR VARCHAR(8);
  lc_CTANRO VARCHAR(30);

  lc_MOSIGN VARCHAR(4);
  lc_CTATIP VARCHAR(20);
  lc_TIPOPE VARCHAR(30);
  lc_TIPAPE VARCHAR(50);

  BEGIN
  ---***
  DELETE FROM AQPB510A;
  COMMIT;
  ---***
  FOR rowM IN
  (select f6.PGCOD, f6.HCTA, f6.HSUCUR, f6.HRUBRO, f6.HMDA, f6.HPAP, f6.HOPER, f6.HSUBOP, f6.HTOPER, f6.HMODUL, f6.HSUCOR,
  f8.PEPAIS, f8.PETDOC, f8.PENDOC,
  (select scnom from fst001 where sucurs = f6.hsucor) AGENCIA,
           decode (f9.tp1nro1,22,'Depositos Plazo Fijo','Cuentas de Ahorro') PRODUCTO,
           decode(f6.hmda,0,'Nuevos Soles','Dolares Americanos') MONEDA,
           f6.hmda nromoneda,
           f9.tp1desc descripcion,
           f5.hfcon fecha,
           f5.hhora hora,
            decode(f9.tp1nro1,22, (Lpad(trim(to_char(f6.Hcta)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f6.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.hoper)),9,'0') ||'-'|| Lpad(trim(to_char(f6.htoper)),3,'0')),
                  (Lpad(trim(to_char(f6.Hcta)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f6.hmda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.hsubop)),2,'0') ||'-'|| Lpad(trim(to_char(f6.htoper)),3,'0'))) cuenta,
           (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc) titular,
           f5.husing usuing,
           f5.huscnf usucof,
           f10.exusau usuauto
      from fst198 f9, fsh016 f6, fsh015 f5, fsr008 f8, fsh010 f10
     Where f9.Tp1cod = 1
       and f9.Tp1cod1 = 10891
       and f9.Tp1corr1 = 4
       and f9.Tp1corr2 = 1
       and f6.pgcod = f9.tp1cod
       and f5.hfcon Between P_FECINI AND P_FECFIN
       ---*** TEST
       --and f6.hsucor = 11
       --and f8.ctnro = 778308
       ---***
       and f6.hcmod = f9.tp1nro1
       and f6.htran = f9.tp1nro2
       and f6.hcord = f9.tp1nro3
       and f5.pgcod = f6.pgcod
       and f5.hsucor = f6.hsucor
       and f5.hcmod = f6.hcmod
       and f5.htran = f6.htran
       and f5.hnrel = f6.hnrel
       and f5.hfcon = f6.hfcon
       and f5.hccorr <> 99
       and f8.pgcod = f6.pgcod
       and f8.ctnro = f6.hcta
       and f8.cttfir = 'T'
       and f10.pgcod = f6.pgcod
       and f10.hcmod = f6.hcmod
       and f10.hsucor = f6.hsucor
       and f10.htran = f6.htran
       and f10.hcord = trunc(f9.tp1imp2)
       and f10.hnrel = f6.hnrel
       and f10.hfcont = f6.hfcon)

       LOOP

       SELECT SCNOM INTO lc_AGENOM FROM FST001 WHERE PGCOD = 1 AND SUCURS = rowM.HSUCOR;
       SELECT TRIM(TDNOM) INTO lc_DOCTIP FROM FST014 WHERE TDOCUM = rowM.PETDOC;
       SELECT TRIM(PENOM) INTO lc_TITULA FROM FSD001 WHERE PEPAIS = rowM.PEPAIS AND PETDOC = rowM.PETDOC AND PENDOC = rowM.PENDOC;

       SELECT TRIM(TONOM) INTO lc_TIPOPE FROM FST004 WHERE MODULO = rowM.HMODUL AND TOTOPE = rowM.HTOPER;
       SELECT TRIM(MOSIGN) INTO lc_MOSIGN FROM FST005 WHERE MONEDA = rowM.HMDA;

       --lc_CTATIP := 'INDI-MANCO';
       lc_CTATIP := FN_AH_TIPO_CTAV(rowM.PGCOD, rowM.HSUCUR, rowM.HMDA
       , rowM.HPAP, rowM.HCTA, rowM.HOPER, rowM.HSUBOP, rowM.HTOPER, rowM.HMODUL);
       ---***
       --** TIPO DE APERTURA NORMAL-DIGITAL
       lc_TIPAPE := 'Contratación Normal';
       IF(rowM.usuing IN ('USRMOVIL','NSBTUSER')) THEN
         lc_TIPAPE := 'Contratación Digital';
       END IF;
       --**
       --***
       lc_CTANRO := CASE WHEN rowM.HMODUL = 21 THEN
                         lpad(rowM.HCTA,9,'0')  ||
                         lpad(rowM.HMODUL,3,'0')  ||
                         lpad(rowM.HMDA,3,'0')  ||
                         lpad(rowM.HSUBOP,2,'0') ||
                         lpad(rowM.HTOPER,3,'0')
                         WHEN rowM.HMODUL = 22 THEN
                         lpad(rowM.HCTA,9,'0')  ||
                         lpad(rowM.HMODUL,3,'0')  ||
                         lpad(rowM.HMDA,3,'0')  ||
                         lpad(rowM.HOPER,9,'0') ||
                         lpad(rowM.HTOPER,3,'0')
                         ELSE
                         lpad(rowM.HCTA,9,'0')  ||
                         lpad(rowM.HMDA,3,'0')  ||
                         lpad(rowM.HOPER,9,'0')
                    END;
       ---***
       INSERT INTO AQPB510A (AQPB510APGCOD, AQPB510ASCSUC, AQPB510ASCRUB, AQPB510ASCMDA, AQPB510ASCPAP
       , AQPB510ASCCTA, AQPB510ACOPER, AQPB510ACSUBO, AQPB510ACTOPE, AQPB510ASCMOD, AQPB510AAGECOD
       , AQPB510AAGENOM, AQPB510ADOCTIP, AQPB510ADOCNRO, AQPB510ATITULA, AQPB510ACTANRO, AQPB510ACTATIP
       , AQPB510ACTAOPE, AQPB510ATIPAPE, AQPB510ACTAMDA, AQPB510ARETFEC, AQPB510ARETHOR, AQPB510AUSUEXE
       , AQPB510AUSUCON, AQPB510AUSUAUT, AQPB510ACRETIM)
       VALUES (rowM.PGCOD, rowM.HSUCUR, rowM.HRUBRO, rowM.HMDA, rowM.HPAP
       , rowM.HCTA, rowM.HOPER, rowM.HSUBOP, rowM.HTOPER, rowM.HMODUL, rowM.HSUCOR
       , lc_AGENOM, lc_DOCTIP, rowM.PENDOC, lc_TITULA, lc_CTANRO, lc_CTATIP
       , lc_TIPOPE, lc_TIPAPE, lc_MOSIGN, rowM.fecha, rowM.hora, rowM.usuing
       , rowM.usucof, rowM.usuauto, SYSDATE);
       ---***

       END LOOP;
       ---*********************************************************************************************
       FOR rowM IN
       (SELECT f6.PGCOD APGCOD, f6.ITSUCD AITSUCD, f6.RUBRO ARUBRO, f6.MONEDA AMONEDA, f6.PAPEL APAPEL,
       f6.CTNRO ACTNRO, f6.ITOPER AITOPER, f6.ITSUBO AITSUBO, f6.ITTOPE AITTOPE, f6.MODULO AMODULO, f6.ITSUC AITSUC,
       f8.PEPAIS, f8.PETDOC, f8.PENDOC,
       (select scnom from fst001 where sucurs = f6.itsuc) agencia,
           decode (f9.tp1nro1,22,'Depositos Plazo Fijo','Cuentas de Ahorro') producto,
           decode(f6.moneda,0,'Nuevos Soles','Dolares Americanos') moneda,
           f6.moneda nromoneda,
           f9.tp1desc descripcion,
           f5.itfcon fecha,
           f5.ithora hora,
           f9.tp1nro1 moduloo,
           decode(f9.tp1nro1,22, (Lpad(trim(to_char(f6.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( f6.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.itoper)),9,'0') ||'-'|| Lpad(trim(to_char(f6.ittope)),3,'0')),
                  (Lpad(trim(to_char(f6.ctnro)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( f6.moneda)),3,'0') ||'-'|| Lpad(trim(to_char(f6.itsubo)),2,'0') ||'-'|| Lpad(trim(to_char(f6.ittope)),3,'0'))) cuenta,
           (select penom from fsd001 where pepais = f8.pepais and petdoc = f8.petdoc and pendoc = f8.pendoc) titular,
           f5.ituing usuing,
           f5.itucnf usucof,
           f10.exusau usuauto
       FROM fst198 f9, fsd016 f6, fsd015 f5, fsr008 f8, fsh010 f10
       WHERE f9.Tp1cod = 1
       and f9.Tp1cod1 = 10891
       and f9.Tp1corr1 = 4
       and f9.Tp1corr2 = 1
       and f6.pgcod = f9.tp1cod
       and f6.itmod = f9.tp1nro1
       and f6.ittran = f9.tp1nro2
       and f6.itord = f9.tp1nro3
       and f5.pgcod = f6.pgcod
       and f5.itsuc = f6.itsuc
       and f5.itmod = f6.itmod
       and f5.ittran = f6.ittran
       and f5.itnrel = f6.itnrel
       and f5.itcorr = 0
       and f5.itcont = 'S'
       and f8.pgcod = f6.pgcod
       and f8.ctnro = f6.ctnro
       and f8.cttfir = 'T'
       ---*** TEST
       --and f6.itsuc = 11
       --and f8.ctnro = 43071
       ---***
       and f10.pgcod = f6.pgcod
       and f10.hcmod = f6.itmod
       and f10.hsucor = f6.itsuc
       and f10.htran = f6.ittran
       and f10.hcord = trunc(f9.tp1imp2)
       and f10.hnrel = f6.itnrel
       and f10.hfcont = f5.itfcon
       and f5.itfcon Between P_FECINI AND P_FECFIN)

       LOOP

       SELECT SCNOM INTO lc_AGENOM FROM FST001 WHERE PGCOD = 1 AND SUCURS = rowM.AITSUC;
       SELECT TRIM(TDNOM) INTO lc_DOCTIP FROM FST014 WHERE TDOCUM = rowM.PETDOC;
       SELECT TRIM(PENOM) INTO lc_TITULA FROM FSD001 WHERE PEPAIS = rowM.PEPAIS AND PETDOC = rowM.PETDOC AND PENDOC = rowM.PENDOC;
       SELECT TRIM(TONOM) INTO lc_TIPOPE FROM FST004 WHERE MODULO = rowM.AMODULO AND TOTOPE = rowM.AITTOPE;
       SELECT TRIM(MOSIGN) INTO lc_MOSIGN FROM FST005 WHERE MONEDA = rowM.AMONEDA;

       --lc_CTATIP := 'INDI-MANCO';
       lc_CTATIP := FN_AH_TIPO_CTAV(rowM.APGCOD, rowM.AITSUC, rowM.AMONEDA
       , rowM.APAPEL, rowM.ACTNRO, rowM.AITOPER, rowM.AITSUBO, rowM.AITTOPE, rowM.AMODULO);
       ---***
       --** TIPO DE APERTURA NORMAL-DIGITAL
       lc_TIPAPE := 'Contratación Normal';
       IF(rowM.usuing IN ('USRMOVIL','NSBTUSER')) THEN
         lc_TIPAPE := 'Contratación Digital';
       END IF;
       --**
       --***
       lc_CTANRO := CASE WHEN rowM.AMODULO = 21 THEN
                         lpad(rowM.ACTNRO,9,'0')  ||
                         lpad(rowM.AMODULO,3,'0')  ||
                         lpad(rowM.AMONEDA,3,'0')  ||
                         lpad(rowM.AITSUBO,2,'0') ||
                         lpad(rowM.AITTOPE,3,'0')
                         WHEN rowM.AMODULO = 22 THEN
                         lpad(rowM.ACTNRO,9,'0')  ||
                         lpad(rowM.AMODULO,3,'0')  ||
                         lpad(rowM.AMONEDA,3,'0')  ||
                         lpad(rowM.AITOPER,9,'0') ||
                         lpad(rowM.AITTOPE,3,'0')
                         ELSE
                         lpad(rowM.ACTNRO,9,'0')  ||
                         lpad(rowM.AMONEDA,3,'0')  ||
                         lpad(rowM.AITOPER,9,'0')
                    END;
       ---***
       INSERT INTO AQPB510A (AQPB510APGCOD, AQPB510ASCSUC, AQPB510ASCRUB, AQPB510ASCMDA, AQPB510ASCPAP
       , AQPB510ASCCTA, AQPB510ACOPER, AQPB510ACSUBO, AQPB510ACTOPE, AQPB510ASCMOD, AQPB510AAGECOD
       , AQPB510AAGENOM, AQPB510ADOCTIP, AQPB510ADOCNRO, AQPB510ATITULA, AQPB510ACTANRO, AQPB510ACTATIP
       , AQPB510ACTAOPE, AQPB510ATIPAPE, AQPB510ACTAMDA, AQPB510ARETFEC, AQPB510ARETHOR, AQPB510AUSUEXE
       , AQPB510AUSUCON, AQPB510AUSUAUT, AQPB510ACRETIM)

       VALUES (rowM.APGCOD, rowM.AITSUCD, rowM.ARUBRO, rowM.AMONEDA, rowM.APAPEL
       , rowM.ACTNRO, rowM.AITOPER, rowM.AITSUBO, rowM.AITTOPE, rowM.AMODULO, rowM.AITSUC
       , lc_AGENOM, lc_DOCTIP, rowM.PENDOC, lc_TITULA, lc_CTANRO, lc_CTATIP
       , lc_TIPOPE, lc_TIPAPE, lc_MOSIGN, rowM.fecha, rowM.hora, rowM.usuing
       , rowM.usucof, rowM.usuauto, SYSDATE);
       ---***
       END LOOP;
       ---***
       COMMIT;
       ---***
END SP_AH_AUD_RETIROS_SIN_TDV;
/

