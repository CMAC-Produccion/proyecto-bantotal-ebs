CREATE OR REPLACE PROCEDURE SP_CR_DESAC_OFERT_JAQZ697(FECHA DATE) IS
  CURSOR CREDITOS IS
    SELECT I.JAQZ697FEP FECHA, I.JAQZ697NDO NRO_DOC, S.XWFPRCINS INSTANCIA
      FROM JAQZ697 I, XWF700 S
     WHERE I.JAQZ697FEP >= FECHA
       AND I.JAQZ697AU5 IN ('N', 'F')
       AND S.XWFEMPRESA = 1
       AND S.XWFSUCURSAL = I.JAQZ697SUC
       AND S.XWFMODULO = I.JAQZ697MOD
       AND S.XWFMONEDA = I.JAQZ697MDA
       AND S.XWFCUENTA = I.JAQZ697CTA
       AND S.XWFTIPOPE = I.JAQZ697TOP
       AND S.XWFCAR3 = '1'
       AND NOT EXISTS (SELECT 1
              FROM XWF070 D, FSH015 C
             WHERE D.XWFPGCOD = 1
               AND D.XWFPRCIN = S.XWFPRCINS
               AND D.XWFCONT = 'S'
               AND C.PGCOD = D.XWFPGCOD
               AND C.HCMOD = D.XWFTMOD
               AND C.HSUCOR = D.XWFTSUC
               AND C.HTRAN = D.XWFTTRAN
               AND C.HNREL = D.XWFNREL
               AND C.HFCON = D.XWFFCON
               AND C.HCCORR = 0)
     GROUP BY I.JAQZ697FEP, I.JAQZ697NDO, S.XWFPRCINS;

  LN_ID NUMBER(10);
BEGIN
  --06.06.2022 +parallel ctas
  EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                    TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                    SUBSTR(USER, 1, 3) ||
                    ' as
                      select /*+parallel(i,40)*/ i.*
                      from jaqz697 i, xwf700 s
                      where i.jaqz697fep >= TO_DATE(''' ||
                    TO_CHAR(FECHA, 'YYYYMMDD') ||
                    ''','' YYYYMMDD '')
                            and i.jaqz697au5 in (''N'',''F'')
                            and s.xwfempresa = 1
                            and s.xwfsucursal = i.jaqz697suc
                            and s.xwfmodulo = i.jaqz697mod
                            and s.xwfmoneda = i.jaqz697mda
                            and s.xwfcuenta = i.jaqz697cta
                            and s.xwftipope = i.jaqz697top
                            and s.xwfcar3 = ''1''
                            and not exists (select 1
                                      from xwf070 d,
                                           fsh015 c
                                      where d.xwfpgcod = 1
                                            and d.xwfprcin =  s.xwfprcins
                                            and d.xwfcont = ''S''
                                            and c.pgcod = d.xwfpgcod
                                            and c.hcmod = d.xwftmod
                                            and c.hsucor = d.xwftsuc
                                            and c.htran = d.xwfttran
                                            and c.hnrel = d.xwfnrel
                                            and c.hfcon = d.xwffcon
                                            and c.hccorr = 0
                                     )';
  FOR I IN CREDITOS LOOP
    UPDATE JAQZ697 R
       SET R.JAQZ697AU5 = 'Q'
     WHERE R.JAQZ697FEP = I.FECHA
       AND R.JAQZ697NDO = I.NRO_DOC
       AND R.JAQZ697AU5 IN ('N', 'F');
    COMMIT;

  END LOOP;
insert into AQPB876 values (user,sysdate,'SP_CR_DESAC_OFERT_JAQZ697',   to_char(FECHA,'DD/MM/RRRR'));
commit;
END SP_CR_DESAC_OFERT_JAQZ697;
/

