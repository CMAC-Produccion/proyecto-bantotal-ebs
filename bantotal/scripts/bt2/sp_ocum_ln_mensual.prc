create or replace procedure sp_ocum_ln_mensual
is
  ---***
  lc_ndoc CHAR(12);
  lc_ndoc_old CHAR(12);
  ln_cony_check NUMBER(2);
  ln_cony_pais  NUMBER(3);
  ln_cony_tdoc  NUMBER(2);
  lc_cony_ndoc  CHAR(12);
  ---***
  ln_PGCOD NUMBER(3);
  ln_SCSUC NUMBER(3);
  ln_SCRUB NUMBER(16);
  ln_SCMDA NUMBER(4);
	ln_SCPAP NUMBER(4);
	ln_SCCTA NUMBER(9);
	ln_SCOPER NUMBER(9);
	ln_SCSBOP NUMBER(3);
	ln_SCTOPE NUMBER(3);
	ln_SCMOD NUMBER(3);
  ld_SCFVAL DATE;
  ---*** FSD010
  ln_APGCOD NUMBER(3);
	ln_AOMOD  NUMBER(3);
	ln_AOSUC  NUMBER(3);
	ln_AOMDA  NUMBER(4);
	ln_AOPAP  NUMBER(4);
	ln_AOCTA  NUMBER(9);
	ln_AOOPER NUMBER(9);
	ln_AOSBOP NUMBER(3);
	ln_AOTOPE NUMBER(3);
	ld_AOFVAL DATE;
  ---*** FSH016
  ln_16PGCOD NUMBER(3);
	ln_16HCMOD NUMBER(3);
	ln_16HSUCOR NUMBER(3);
	ln_16HTRAN NUMBER(3);
	ln_16HNREL NUMBER(4);
	ln_16HFCON DATE;
	ln_16HCORD NUMBER(2);
	ln_16HCSUBO NUMBER(3);
  ---***
  ln_CHECK NUMBER(3);
  ---*** XWF700
  ln_XWFPRCINS NUMBER(10);
  ln_XWFEMPRESA NUMBER(3);
  ln_XWFCUENTA NUMBER(9);
  ---***
  lv_USRALT VARCHAR(30);
  ---***
  ln_R2MOD  NUMBER(3);
  ln_R2CTA  NUMBER(9);
  ln_R2OPER NUMBER(9);
  ln_R2SBOP NUMBER(3);
  ln_R2TOPE NUMBER(3);
  ---***

   cursor c_listas is select tlis from fst501;
   cursor c_jaqz146 is select * from jaqz146 where jaqz146tiprep = 'C' order by jaqz146nrodoc;
   ---*** CVILLON.20230523
   CURSOR C_USRALT IS SELECT * FROM JAQZ146 WHERE JAQZ146TIPREP = 'C' FOR UPDATE;
   ---***   

begin

  execute immediate 'truncate table jaqz146';
  execute immediate 'truncate table jaqz146a';
  execute immediate 'truncate table jaqz146r';

  insert into jaqz146a
  select d_Aud.Aud_New_Lnpais,
         d_Aud.Aud_New_Lntdoc,
         d_Aud.aud_New_Lnndoc,
         d_Aud.aud_fsd201_ubu,
         trunc(d_Aud.aud_fsd201_uon) Fecha,
         to_char(d_Aud.aud_fsd201_uon,'hh:mi:ss') Hora
    from aud_fsd201_audit d_Aud
   where d_Aud.aud_fsd201_uas = 'I';

  insert into jaqz146r
  select *
    from fst111 t_111
   where t_111.dscod = 50
      or t_111.modulo in (21,22);

  for x in c_listas loop

    insert into jaqz146
    select
           0,
           case
              when trim(d_201.lndeno) is null then
                 trim(d_201.lnapea) || ' ' ||
                 trim(d_201.lnape1) || ' ' ||
                 trim(d_201.lnnoma) || ' ' ||
                 trim(d_201.lnnom1)
              else
                 trim(d_201.lndeno)
           end Nombre,
           trim(t_014.tdnom) Tip_Docum,
           trim(d_201.lnndoc) Nro_Docum,
           trim(d_201.lnmotdes) Oficio,
           trim(d_201.lnmoobs) Observaciones,
           d_201.lnmofdes Fec_Registro,
           d_201.lnfact Fecha_Crea,
           d_201.lnmofhas Fec_Baja,
           d_201.tlis Tipo_Lista,
           trim(t_501.tlisde) Tipo,
           null,
           null,
           null,
           null,
           null,
           null,
           null,
           0,
           0,
           null,
           0,
           0,
           'P',
            (select d_Aud.jaqz146aubu
               from jaqz146a d_Aud
              where d_Aud.jaqz146apais = d_201.lnpais
                and d_Aud.jaqz146atipdoc = d_201.lntdoc
                and d_Aud.jaqz146anrodoc = d_201.lnndoc
                and rownum = 1) Oper_Ing_Aud,
            (select d_Aud.jaqz146afec
               from jaqz146a d_Aud
              where d_Aud.jaqz146apais = d_201.lnpais
                and d_Aud.jaqz146atipdoc = d_201.lntdoc
                and d_Aud.jaqz146anrodoc = d_201.lnndoc
                and rownum = 1) Fec_Ing_Aud,
            (select d_Aud.jaqz146ahor
               from jaqz146a d_Aud
              where d_Aud.jaqz146apais = d_201.lnpais
                and d_Aud.jaqz146atipdoc = d_201.lntdoc
                and d_Aud.jaqz146anrodoc = d_201.lnndoc
                and rownum = 1) Hora_Ing_Aud, '-'
                , SYSDATE
                , '-'
      from fsd201 d_201
     inner join fst014 t_014
        on t_014.tdocum = d_201.lntdoc
     inner join fst501 t_501
        on t_501.tlis = d_201.tlis
     where d_201.tlis = x.tlis
     ---***
     --AND d_201.LNNDOC = '44172135'
     ---***
     order by d_201.lnfact;

  end loop;

  for x in c_listas loop

    insert into jaqz146
    select r_008.ctnro Cta_Cliente,
           case
              when trim(d_201.lndeno) is null then
                 trim(d_201.lnapea) || ' ' ||
                 trim(d_201.lnape1) || ' ' ||
                 trim(d_201.lnnoma) || ' ' ||
                 trim(d_201.lnnom1)
              else
                 trim(d_201.lndeno)
           end Nombre,
           trim(t_014.tdnom) Tip_Docum,
           trim(d_201.lnndoc) Nro_Docum,
           trim(d_201.lnmotdes) Oficio,
           trim(d_201.lnmoobs) Observaciones,
           d_201.lnmofdes Fec_Registro,
           null Fecha_Crea,
           d_201.lnmofhas Fec_Baja,
           d_201.tlis Tipo_Lista,
           trim(t_501.tlisde) Tipo,
           (select scnom from fst001 s where  s.pgcod = d_011.pgcod and s.sucurs = d_011.scsuc and rownum = 1) Agencia,
           trim(t_003.mdnom) Modulo,
           trim(t_004.tonom) Tip_Operacion,
           case
              when d_011.scmod = 21 then
                   lpad(d_011.sccta,9,'0')  ||
                   lpad(d_011.scmod,3,'0')  ||
                   lpad(d_011.scmda,3,'0')  ||
                   lpad(d_011.scsbop,2,'0') ||
                   lpad(d_011.sctope,3,'0')
              when d_011.scmod = 22 then
                   lpad(d_011.sccta,9,'0')  ||
                   lpad(d_011.scmod,3,'0')  ||
                   lpad(d_011.scmda,3,'0')  ||
                   lpad(d_011.scoper,9,'0') ||
                   lpad(d_011.sctope,3,'0')
              else
                   lpad(d_011.sccta,9,'0')  ||
                   lpad(d_011.scmda,3,'0')  ||
                   lpad(d_011.scoper,9,'0')
           end Cod_Operacion,
           t_005.mosign,
           abs(d_011.scsdo) Saldo,
           d_011.scfulm Fec_Ult_Saldo,
           d_011.sccta,
           d_011.scoper,
           d_011.scmod,
           d_011.sctope,
           d_011.scsbop,
           'C',
           null,
           null,
           null, 'TITULAR'
           , SYSDATE
           , '-'
      from fsd201 d_201
     inner join fsr008 r_008
        on r_008.pgcod = 1
       and r_008.pepais = d_201.lnpais
       and r_008.petdoc = d_201.lntdoc
       and r_008.pendoc = substr(d_201.lnndoc,1,12)
     inner join fsd011 d_011
        on d_011.pgcod = 1
       and d_011.sccta = r_008.ctnro
     inner join fst014 t_014
        on t_014.tdocum = d_201.lntdoc
     inner join fst003 t_003
        on t_003.modulo = d_011.scmod
     inner join fst004 t_004
        on t_004.modulo = d_011.scmod
       and t_004.totope = d_011.sctope
     inner join fst005 t_005
        on t_005.moneda = d_011.scmda
     inner join jaqz146r t_111
        on t_111.jaqz146rmod = d_011.scmod
     inner join fst501 t_501
        on t_501.tlis = d_201.tlis
     where d_201.tlis = x.tlis
     ---***
     --AND d_201.LNNDOC IN('44172135')
     ---***
     and d_011.scstat <> 99;

  end loop;

  commit;


  update jaqz146 x1
     set x1.jaqz146fecrea = fn_ocum_fec_desembolso(x1.jaqz146sccta, x1.jaqz146scoper)
   where x1.jaqz146scmod not in (21, 22)
   and x1.jaqz146tiprep = 'C';

  update jaqz146 x1
     set x1.jaqz146fecrea = (select d_011.scfval
                            from fsd011 d_011
                           where d_011.pgcod  = 1
                             and d_011.sccta  = x1.jaqz146sccta
                             and d_011.sctope = x1.jaqz146sctope
                             and d_011.scsbop = x1.jaqz146scsbop
                             and d_011.scmod  = 21
                             and rownum = 1)
   where x1.jaqz146scmod = 21
   and x1.jaqz146tiprep = 'C';

  update jaqz146 x1
     set x1.jaqz146fecrea = (select d_011.scfval
                            from fsd011 d_011
                           where d_011.pgcod  = 1
                             and d_011.sccta  = x1.jaqz146sccta
                             and d_011.scoper = x1.jaqz146scoper
                             and d_011.sctope = x1.jaqz146sctope
                             and d_011.scsbop = x1.jaqz146scsbop
                             and d_011.scmod  = 22
                             and rownum = 1)
   where x1.jaqz146scmod = 22
   and x1.jaqz146tiprep = 'C';

  commit;

  ---*** MCVILLONZ.2021.08.19 (CONDICIONES EXTRA)
  lc_ndoc := '000';
  lc_ndoc_old := '111';
  ln_cony_check := 0;
  --***
  FOR reg IN c_jaqz146 LOOP
    ---***
    --dbms_output.PUT_LINE('reg.JAQZ146CTA: '||reg.JAQZ146CTA);
    ---***
    lc_ndoc := TRIM(reg.JAQZ146NRODOC);
    ---***
    IF(lc_ndoc <> lc_ndoc_old) THEN
      /*
      INSERT INTO jaqz146 VALUES (369, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
      , reg.JAQZ146OBS, reg.JAQZ146FECREG, reg.JAQZ146FECREA, reg.JAQZ146FECBAJ
      , reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS, reg.JAQZ146AGE, reg.JAQZ146MOD
      , reg.JAQZ146TIPOPE, reg.JAQZ146CODOPE, reg.JAQZ146MOSIGN, reg.JAQZ146SALDO
      , reg.JAQZ146FECULTSAL, reg.JAQZ146SCCTA, reg.JAQZ146SCOPER, reg.JAQZ146SCMOD
      , reg.JAQZ146SCTOPE, reg.JAQZ146SCSBOP, reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU
      , reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, reg.JAQZ146CONDIC);
      */

      --dbms_output.PUT_LINE('lc_ndoc: '||lc_ndoc);
      ---***
      ln_cony_check := 0;
      ---***
      ---*** AVAL INI
      FOR row1 IN
      (select DISTINCT(XWFCUENTA) AS XWFCUENTA from XWF700 where xwfcar3 = '1'
      and XWFPRCINS IN (select s.sng001inst
      from sng003 s
      where s.sng003cta in (select f.CTNRO
                         from fsr008 f
                        where f.PEPAIS = 604
                          and f.PETDOC = 21
                          and f.PENDOC = lc_ndoc
                          and f.cttfir = 'T')))

      LOOP
        --dbms_output.PUT_LINE('row1.XWFCUENTA: '||row1.XWFCUENTA);
        ---***
        FOR row2 IN
        (SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCSDO, SCFULM
         FROM FSD011
         WHERE SCCTA = row1.XWFCUENTA
         AND SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
         AND SCSTAT <> 99)
        LOOP
          --dbms_output.PUT_LINE('row2.SCCTA: '||row2.SCCTA);
          INSERT INTO jaqz146 VALUES (row2.SCCTA, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
        , reg.JAQZ146OBS, reg.JAQZ146FECREG, fn_ocum_fec_desembolso(row2.SCCTA, row2.SCOPER), reg.JAQZ146FECBAJ
        , reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS
        , (select SCNOM from fst001 s where s.pgcod = row2.PGCOD and s.sucurs = row2.SCSUC and rownum = 1)
        , (select MDNOM from fst003 where MODULO = row2.SCMOD)
        , (select TONOM from fst004 where MODULO = row2.SCMOD and TOTOPE = row2.SCTOPE)
        , (lpad(row2.SCCTA,9,'0') || lpad(row2.SCMDA,3,'0') || lpad(row2.SCOPER,9,'0'))
        , (select MOSIGN from fst005 where MONEDA = row2.SCMDA)
        , abs(row2.SCSDO), row2.SCFULM, row2.SCCTA, row2.SCOPER, row2.SCMOD, row2.SCTOPE, row2.SCSBOP
        , reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU, reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, 'AVAL', SYSDATE, '-');
        END LOOP;
        ---***
      END LOOP;
      ---*** AVAL FIN

      ---*** CONYUGE INI
      select COUNT(*) INTO ln_cony_check
      from fsr002 where RPCCYG = 66 and PEPAIS = 604 and PETDOC = 21 and PENDOC = lc_ndoc and rownum = 1;
      IF(ln_cony_check > 0) THEN
        select RPPAIS, RPTDOC, RPNDOC INTO ln_cony_pais, ln_cony_tdoc, lc_cony_ndoc
        from fsr002 where RPCCYG = 66 and PEPAIS = 604 and PETDOC = 21 and PENDOC = lc_ndoc and rownum = 1;
      ELSE
        select COUNT(*) INTO ln_cony_check
        from fsr002 where RPCCYG = 66 and RPPAIS = 604 and RPTDOC = 21 and RPNDOC = lc_ndoc and rownum = 1;
        IF(ln_cony_check > 0) THEN
          select PEPAIS, PETDOC, PENDOC INTO ln_cony_pais, ln_cony_tdoc, lc_cony_ndoc
          from fsr002 where RPCCYG = 66 and RPPAIS = 604 and RPTDOC = 21 and RPNDOC = lc_ndoc and rownum = 1;
        END IF;
      END IF;
      ---*** SI Conyuge Existe
      IF(ln_cony_check > 0) THEN
        --dbms_output.PUT_LINE('ln_cony_pais: '||ln_cony_pais);
        --dbms_output.PUT_LINE('ln_cony_tdoc: '||ln_cony_tdoc);
        --dbms_output.PUT_LINE('lc_cony_ndoc: '||lc_cony_ndoc);

        FOR row1 IN
        (select * from fsr008 where PEPAIS = ln_cony_pais and PETDOC = ln_cony_tdoc and PENDOC = lc_cony_ndoc and CTTFIR = 'T')
        LOOP
          --dbms_output.PUT_LINE('CONYUGE row1.CTNRO: '||row1.CTNRO);
          ---***
          FOR row2 IN
          (SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCSDO, SCFULM, SCFVAL
           FROM FSD011
           WHERE SCCTA = row1.CTNRO
           AND SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD IN (2,3,50))
           AND SCSTAT <> 99)
          LOOP
            --dbms_output.PUT_LINE('row2.SCCTA: '||row2.SCCTA);
            INSERT INTO jaqz146 VALUES (row2.SCCTA, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
            , reg.JAQZ146OBS, reg.JAQZ146FECREG
            , case when row2.SCMOD IN (21,22) then row2.SCFVAL
                   else fn_ocum_fec_desembolso(row2.SCCTA, row2.SCOPER)
              end
            , reg.JAQZ146FECBAJ, reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS
            , (select SCNOM from fst001 s where s.pgcod = row2.PGCOD and s.sucurs = row2.SCSUC and rownum = 1)
            , (select MDNOM from fst003 where MODULO = row2.SCMOD)
            , (select TONOM from fst004 where MODULO = row2.SCMOD and TOTOPE = row2.SCTOPE)
            , case when row2.SCMOD = 21 then
                     lpad(row2.SCCTA,9,'0')  ||
                     lpad(row2.SCMOD,3,'0')  ||
                     lpad(row2.SCMDA,3,'0')  ||
                     lpad(row2.SCSBOP,2,'0') ||
                     lpad(row2.SCTOPE,3,'0')
                   when row2.SCMOD = 22 then
                     lpad(row2.SCCTA,9,'0')  ||
                     lpad(row2.SCMOD,3,'0')  ||
                     lpad(row2.SCMDA,3,'0')  ||
                     lpad(row2.SCOPER,9,'0') ||
                     lpad(row2.SCTOPE,3,'0')
                   else
                     lpad(row2.SCCTA,9,'0')  ||
                     lpad(row2.SCMDA,3,'0')  ||
                     lpad(row2.SCOPER,9,'0')
              end
            , (select MOSIGN from fst005 where MONEDA = row2.SCMDA)
            , abs(row2.SCSDO), row2.SCFULM, row2.SCCTA, row2.SCOPER, row2.SCMOD, row2.SCTOPE, row2.SCSBOP
            , reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU, reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, 'CONYUGE', SYSDATE, '-');
          END LOOP;
          ---***
        END LOOP;

      END IF;
      ---*** CONYUGE FIN

      ---*** CONYUGE ES AVAL? INI
      IF(ln_cony_check > 0) THEN
        --dbms_output.PUT_LINE('CONYUGE ES AVAL?');
      FOR row1 IN
      (select DISTINCT(XWFCUENTA) AS XWFCUENTA from XWF700 where xwfcar3 = '1'
      and XWFPRCINS IN (select s.sng001inst
      from sng003 s
      where s.sng003cta in (select f.CTNRO
                         from fsr008 f
                        where f.PEPAIS = ln_cony_pais
                          and f.PETDOC = ln_cony_tdoc
                          and f.PENDOC = lc_cony_ndoc
                          and f.cttfir = 'T')))

      LOOP
        --dbms_output.PUT_LINE('row1.XWFCUENTA: '||row1.XWFCUENTA);
        ---***
        FOR row2 IN
        (SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCSDO, SCFULM FROM FSD011
        WHERE SCCTA = row1.XWFCUENTA AND SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50))
        LOOP
          --dbms_output.PUT_LINE('row2.SCCTA: '||row2.SCCTA);
          INSERT INTO jaqz146 VALUES (row2.SCCTA, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
        , reg.JAQZ146OBS, reg.JAQZ146FECREG, fn_ocum_fec_desembolso(row2.SCCTA, row2.SCOPER), reg.JAQZ146FECBAJ
        , reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS
        , (select SCNOM from fst001 s where s.pgcod = row2.PGCOD and s.sucurs = row2.SCSUC and rownum = 1)
        , (select MDNOM from fst003 where MODULO = row2.SCMOD)
        , (select TONOM from fst004 where MODULO = row2.SCMOD and TOTOPE = row2.SCTOPE)
        , (lpad(row2.SCCTA,9,'0') || lpad(row2.SCMDA,3,'0') || lpad(row2.SCOPER,9,'0'))
        , (select MOSIGN from fst005 where MONEDA = row2.SCMDA)
        , abs(row2.SCSDO), row2.SCFULM, row2.SCCTA, row2.SCOPER, row2.SCMOD, row2.SCTOPE, row2.SCSBOP
        , reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU, reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, 'CONYUGE de AVAL', SYSDATE, '-');
        END LOOP;
        ---***
      END LOOP;

      END IF;
      ---*** CONYUGE ES AVAL? FIN

      ---*** REPRESENTANTE LEGAL INI
      FOR row1 IN
      (select * from FSR003 WHERE PFPAI1 = 604 AND PFTDO1 = 21 AND PFNDO1 = lc_ndoc AND VICOD = 7)
      LOOP
        --dbms_output.PUT_LINE('REP. LEGAL row1.PJNDOC: '||row1.PJNDOC);
        FOR row2 IN
        (select * from fsr008 where PEPAIS = row1.PJPAIS and PETDOC = row1.PJTDOC and PENDOC = row1.PJNDOC and CTTFIR = 'T')
        LOOP
          --dbms_output.PUT_LINE('REP. LEGAL row2.CTNRO: '||row2.CTNRO);
          ---***
          FOR row3 IN
          (SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCSDO, SCFULM, SCFVAL
           FROM FSD011
           WHERE SCCTA = row2.CTNRO
           AND SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD IN (2,3,50))
           AND SCSTAT <> 99)
          LOOP
            --dbms_output.PUT_LINE('row3.SCCTA: '||row3.SCCTA);
            INSERT INTO jaqz146 VALUES (row3.SCCTA, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
            , reg.JAQZ146OBS, reg.JAQZ146FECREG
            , case when row3.SCMOD IN (21,22) then row3.SCFVAL
                   else fn_ocum_fec_desembolso(row3.SCCTA, row3.SCOPER)
              end
            , reg.JAQZ146FECBAJ, reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS
            , (select SCNOM from fst001 s where s.pgcod = row3.PGCOD and s.sucurs = row3.SCSUC and rownum = 1)
            , (select MDNOM from fst003 where MODULO = row3.SCMOD)
            , (select TONOM from fst004 where MODULO = row3.SCMOD and TOTOPE = row3.SCTOPE)
            , case when row3.SCMOD = 21 then
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMOD,3,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCSBOP,2,'0') ||
                     lpad(row3.SCTOPE,3,'0')
                   when row3.SCMOD = 22 then
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMOD,3,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCOPER,9,'0') ||
                     lpad(row3.SCTOPE,3,'0')
                   else
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCOPER,9,'0')
              end
            , (select MOSIGN from fst005 where MONEDA = row3.SCMDA)
            , abs(row3.SCSDO), row3.SCFULM, row3.SCCTA, row3.SCOPER, row3.SCMOD, row3.SCTOPE, row3.SCSBOP
            , reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU, reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, 'REP. LEGAL', SYSDATE, '-');
          END LOOP;
          ---***
        END LOOP;
      END LOOP;
      ---*** REPRESENTANTE LEGAL FIN

      ---*** ACCIONISTA INI
      FOR row1 IN
      (select * from FSR003 WHERE PFPAI1 = 604 AND PFTDO1 = 21 AND PFNDO1 = lc_ndoc AND VICOD = 1)
      LOOP
        --dbms_output.PUT_LINE('ACCIONISTA row1.PJNDOC: '||row1.PJNDOC);
        FOR row2 IN
        (select * from fsr008 where PEPAIS = row1.PJPAIS and PETDOC = row1.PJTDOC and PENDOC = row1.PJNDOC and CTTFIR = 'T')
        LOOP
          --dbms_output.PUT_LINE('ACCIONISTA row2.CTNRO: '||row2.CTNRO);
          ---***
          FOR row3 IN
          (SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCSDO, SCFULM, SCFVAL
           FROM FSD011
           WHERE SCCTA = row2.CTNRO
           AND SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD IN (2,3,50))
           AND SCSTAT <> 99)
          LOOP
            --dbms_output.PUT_LINE('row3.SCCTA: '||row3.SCCTA);
            INSERT INTO jaqz146 VALUES (row3.SCCTA, reg.JAQZ146NOM, reg.JAQZ146TIPDOC, reg.JAQZ146NRODOC, reg.JAQZ146OFICIO
            , reg.JAQZ146OBS, reg.JAQZ146FECREG
            , case when row3.SCMOD IN (21,22) then row3.SCFVAL
                   else fn_ocum_fec_desembolso(row3.SCCTA, row3.SCOPER)
              end
            , reg.JAQZ146FECBAJ, reg.JAQZ146CODLIS, reg.JAQZ146TIPLIS
            , (select SCNOM from fst001 s where s.pgcod = row3.PGCOD and s.sucurs = row3.SCSUC and rownum = 1)
            , (select MDNOM from fst003 where MODULO = row3.SCMOD)
            , (select TONOM from fst004 where MODULO = row3.SCMOD and TOTOPE = row3.SCTOPE)
            , case when row3.SCMOD = 21 then
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMOD,3,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCSBOP,2,'0') ||
                     lpad(row3.SCTOPE,3,'0')
                   when row3.SCMOD = 22 then
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMOD,3,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCOPER,9,'0') ||
                     lpad(row3.SCTOPE,3,'0')
                   else
                     lpad(row3.SCCTA,9,'0')  ||
                     lpad(row3.SCMDA,3,'0')  ||
                     lpad(row3.SCOPER,9,'0')
              end
            , (select MOSIGN from fst005 where MONEDA = row3.SCMDA)
            , abs(row3.SCSDO), row3.SCFULM, row3.SCCTA, row3.SCOPER, row3.SCMOD, row3.SCTOPE, row3.SCSBOP
            , reg.JAQZ146TIPREP, reg.JAQZ146AUDUBU, reg.JAQZ146AUDFEC, reg.JAQZ146AUDHOR, 'ACCIONISTA', SYSDATE, '-');
          END LOOP;
          ---***
        END LOOP;
      END LOOP;
      ---*** ACCIONISTA FIN

    END IF;
    ---***
    lc_ndoc_old := lc_ndoc;
    ---***
  END LOOP;
  commit;
  ---***
  ---***CVILLON.20230523
  FOR XROW IN C_USRALT
    LOOP
    IF(XROW.JAQZ146SCMOD = 21) THEN
      ---***
      lv_USRALT := '-';
      ---***
      BEGIN
      SELECT PGCOD, SCSUC, SCRUB, SCMDA, SCPAP, SCCTA, SCOPER, SCSBOP, SCTOPE, SCMOD, SCFVAL
      INTO ln_PGCOD, ln_SCSUC, ln_SCRUB, ln_SCMDA, ln_SCPAP, ln_SCCTA, ln_SCOPER, ln_SCSBOP, ln_SCTOPE, ln_SCMOD, ld_SCFVAL 
      FROM FSD011 WHERE PGCOD = 1
      AND SCCTA = XROW.JAQZ146SCCTA
      AND SCMOD = XROW.JAQZ146SCMOD
      AND SCOPER = XROW.JAQZ146SCOPER
      AND SCSBOP = XROW.JAQZ146SCSBOP
      AND SCTOPE = XROW.JAQZ146SCTOPE
      AND SCFULM = XROW.JAQZ146FECULTSAL
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      BEGIN
      SELECT TRIM(CV1AUX6) INTO lv_USRALT FROM FSE113 WHERE PGCOD = ln_PGCOD
      AND CV1MOD = ln_SCMOD
      AND CV1MDA = ln_SCMDA
      AND CV1PAP = ln_SCPAP
      AND CV1CTA = ln_SCCTA
      AND CV1SUC = ln_SCSUC
      AND CV1OPER = ln_SCOPER
      AND CV1SBOP = ln_SCSBOP
      AND CV1TOPE = ln_SCTOPE
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      BEGIN  
      UPDATE JAQZ146 SET JAQZ146USRALT = lv_USRALT WHERE CURRENT OF C_USRALT;
      exception
        when others then
          CONTINUE;
      END;
      ---***  
    ELSIF(XROW.JAQZ146SCMOD = 22) THEN
      ---***
      lv_USRALT := '-';
      ---***
      /*
      IF(XROW.JAQZ146SCCTA = 27506 AND XROW.JAQZ146SCOPER = 1339200) THEN
      SELECT COUNT (*) INTO ln_CHECK
      FROM FSD010 WHERE PGCOD = 1
      AND AOCTA = XROW.JAQZ146SCCTA
      AND AOMOD = XROW.JAQZ146SCMOD
      AND AOOPER = XROW.JAQZ146SCOPER
      AND AOSBOP = 0 -- Siempre 0
      AND AOTOPE = XROW.JAQZ146SCTOPE
      AND ROWNUM = 1;
      DBMS_OUTPUT.PUT_LINE('ld_AOFVAL - ln_CHECK:'||ln_CHECK); 
      END IF;
      */
      BEGIN
      SELECT PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE, AOFVAL  
      INTO ln_APGCOD, ln_AOMOD, ln_AOSUC, ln_AOMDA, ln_AOPAP, ln_AOCTA, ln_AOOPER, ln_AOSBOP, ln_AOTOPE, ld_AOFVAL 
      FROM FSD010 WHERE PGCOD = 1
      AND AOCTA = XROW.JAQZ146SCCTA
      AND AOMOD = XROW.JAQZ146SCMOD
      AND AOOPER = XROW.JAQZ146SCOPER
      AND AOSBOP = XROW.JAQZ146SCSBOP 
      AND AOTOPE = XROW.JAQZ146SCTOPE
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      /*
      IF(XROW.JAQZ146SCCTA = 27506 AND XROW.JAQZ146SCOPER = 1339200) THEN
      SELECT COUNT(*) INTO ln_CHECK
      FROM FSH016 WHERE PGCOD = ln_APGCOD
      AND HCTA = ln_AOCTA
      AND HFCON = ld_AOFVAL 
      AND HMODUL = ln_AOMOD
      AND HOPER = ln_AOOPER
      AND HSUBOP = ln_AOSBOP
      AND HTOPER = ln_AOTOPE
      AND HSUCUR = ln_AOSUC
      AND ROWNUM = 1;
      DBMS_OUTPUT.PUT_LINE('ld_FSH016 - ln_CHECK:'||ln_CHECK); 
      END IF;
      */
     
      BEGIN
      SELECT PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, HCORD, HCSUBO 
      INTO ln_16PGCOD, ln_16HCMOD, ln_16HSUCOR, ln_16HTRAN, ln_16HNREL, ln_16HFCON, ln_16HCORD, ln_16HCSUBO
      FROM FSH016 
      WHERE PGCOD = ln_APGCOD
      AND HCTA = ln_AOCTA
      AND HFCON = ld_AOFVAL 
      AND HMODUL = ln_AOMOD
      AND HOPER = ln_AOOPER
      AND HSUBOP = ln_AOSBOP
      AND HTOPER = ln_AOTOPE
      AND HSUCUR = ln_AOSUC
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      /*
      IF(XROW.JAQZ146SCCTA = 27506 AND XROW.JAQZ146SCOPER = 1339200) THEN
      SELECT COUNT(*) INTO ln_CHECK
      FROM FSH015
      WHERE PGCOD = ln_16PGCOD 
      AND HCMOD = ln_16HCMOD
      AND HSUCOR = ln_16HSUCOR
      AND HTRAN = ln_16HTRAN
      AND HNREL = ln_16HNREL
      AND HFCON = ln_16HFCON
      AND ROWNUM = 1;
      DBMS_OUTPUT.PUT_LINE('ld_FSH015 - ln_CHECK:'||ln_CHECK); 
      END IF;
      */
      
      BEGIN
      SELECT TRIM(HUSING) INTO lv_USRALT FROM FSH015 WHERE PGCOD = ln_16PGCOD 
      AND HCMOD = ln_16HCMOD
      AND HSUCOR = ln_16HSUCOR
      AND HTRAN = ln_16HTRAN
      AND HNREL = ln_16HNREL
      AND HFCON = ln_16HFCON
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      BEGIN  
      UPDATE JAQZ146 SET JAQZ146USRALT = lv_USRALT WHERE CURRENT OF C_USRALT;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      ---***
    ELSIF(XROW.JAQZ146SCMOD = 116) THEN
      ---***
      lv_USRALT := '-';
      ---***
      BEGIN
      SELECT R2MOD, R2CTA, R2OPER, R2SBOP, R2TOPE 
      INTO ln_R2MOD, ln_R2CTA, ln_R2OPER, ln_R2SBOP, ln_R2TOPE 
      FROM FSR011 WHERE R1COD = 1
      AND R1MOD = XROW.JAQZ146SCMOD
      AND R1CTA = XROW.JAQZ146SCCTA
      AND R1OPER = XROW.JAQZ146SCOPER
      AND R1SBOP = XROW.JAQZ146SCSBOP
      AND R1TOPE = XROW.JAQZ146SCTOPE
      AND RELCOD = 46 -- Siempre 46
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      BEGIN
      SELECT XWFPRCINS, XWFEMPRESA, XWFCUENTA
      INTO ln_XWFPRCINS, ln_XWFEMPRESA, ln_XWFCUENTA
      FROM XWF700 WHERE XWFEMPRESA = 1
      AND XWFCUENTA = ln_R2CTA 
      AND XWFOPERACION = ln_R2OPER
      AND XWFSUBOPE = ln_R2SBOP
      AND XWFTIPOPE = ln_R2TOPE
      AND XWFMODULO = ln_R2MOD
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      BEGIN
      SELECT TRIM(SNG001ASE) INTO lv_USRALT  
      FROM SNG001 
      WHERE SNG001INST = ln_XWFPRCINS
      AND SNG001EMP = ln_XWFEMPRESA
      AND SNG001CTA = ln_XWFCUENTA
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      BEGIN  
      UPDATE JAQZ146 SET JAQZ146USRALT = lv_USRALT WHERE CURRENT OF C_USRALT;
      exception
        when others then
          CONTINUE;
      END;
      ---***
       
    ELSE
      BEGIN
      SELECT XWFPRCINS, XWFEMPRESA, XWFCUENTA
      INTO ln_XWFPRCINS, ln_XWFEMPRESA, ln_XWFCUENTA
      FROM XWF700 WHERE XWFEMPRESA = 1
      AND XWFCUENTA = XROW.JAQZ146SCCTA 
      AND XWFOPERACION = XROW.JAQZ146SCOPER
      AND XWFSUBOPE = XROW.JAQZ146SCSBOP
      AND XWFTIPOPE = XROW.JAQZ146SCTOPE
      AND XWFMODULO = XROW.JAQZ146SCMOD
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      
      BEGIN
      SELECT TRIM(SNG001ASE) INTO lv_USRALT  
      FROM SNG001 
      WHERE SNG001INST = ln_XWFPRCINS
      AND SNG001EMP = ln_XWFEMPRESA
      AND SNG001CTA = ln_XWFCUENTA
      AND ROWNUM = 1;
      exception
        when others then
          CONTINUE;
      END;
      ---***
      BEGIN  
      UPDATE JAQZ146 SET JAQZ146USRALT = lv_USRALT WHERE CURRENT OF C_USRALT;
      exception
        when others then
          CONTINUE;
      END;
      ---***

    END IF;  
    END LOOP;
  ---***
  commit;
  ---***   

end sp_ocum_ln_mensual;
/

