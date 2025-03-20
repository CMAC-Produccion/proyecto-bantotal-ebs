create or replace procedure SP_COBROS_SEGUROS_CRED_PLAN_IV is
  error varchar2(200);
  pgfape date := trunc(sysdate) - 1;
  --pgfape date := to_date('01/07/2013', 'dd/mm/yyyy');

  cursor pagos is
    select pgfape jaql99fepr,
           codproductocobro99,
           lpad(to_char(rownum), 10, '0') numcertificadocobro99,
           numcuotacobro99,
           idtitularcta99,
           tipoid99,
           tipocta99,
           numcta99,
           numtarjeta99,
           montoprimacuota99,
           fecemisioncuota99,
           fecpagocuota99,
           docdeposito99,
           fecdeposito99,
           coderror99,
           descerror99,
           jaql99au01,
           jaql99itmo,
           jaql99ittr,
           jaql99itre
      from (select distinct --distinct trunc(sysdate)  jaql99fepr,
                            max(pp1fech) jaql99fepr,
                            '0005' codproductocobro99,
                            '0000000000' numcertificadocobro99,
                            '0000' numcuotacobro99,
                            trim(b.pendoc) IDTITULARCTA99,
                            '001' tipoid99,
                            'CRE' tipocta99,
                            a.numcta99,
                            '0000000000000000' numtarjeta99,
                            --'00150'
                            lpad(decode(a.ppmda,
                                        101,
                                        trunc((case
                                                when d.ppimp11 > 0 then
                                                 d.ppimp11
                                                when d.ppimp11 = 0 and d.ppimp12 > 0 then
                                                 d.ppimp12
                                                else
                                                 d.ppimp13
                                              end) * fn_tipo_cambio(trunc(sysdate),
                                                                    a.ppmda,
                                                                    0,
                                                                    2),
                                              1),
                                        (case
                                          when d.ppimp11 > 0 then
                                           d.ppimp11
                                          when d.ppimp11 = 0 and d.ppimp12 > 0 then
                                           d.ppimp12
                                          else
                                           d.ppimp13
                                        end)) * 100,
                                 5,
                                 '0') montoprimacuota99,
                            a.fecemisioncuota99,
                            to_char(max(pp1fech), 'yyyymmdd') fecpagocuota99,
                            lpad(trim(to_char(a.Ppcta)), 9, '0') ||
                            lpad(trim(to_char(a.Ppmod)), 3, '0') ||
                            lpad(trim(to_char(a.Ppmda)), 3, '0') ||
                            lpad(trim(to_char(a.Ppoper)), 9, '0') ||
                            lpad(trim(to_char(a.Pptope)), 3, '0') docdeposito99,
                            to_char(max(pp1fech), 'yyyymmdd') fecdeposito99,
                            '00' coderror99,
                            '' descerror99,
                            to_char(a.Ppmda) jaql99au01,
                            0 jaql99itmo,
                            0 jaql99ittr,
                            0 jaql99itre,
                            a.ppfpag,
                            case
                              when d.ppimp11 > 0 then
                               d.ppimp11
                              when d.ppimp11 = 0 and d.ppimp12 > 0 then
                               d.ppimp12
                              else
                               d.ppimp13
                            end prima,
                            g.scnom,
                            a.ppcta,
                            a.ppoper
            
              from fsr008 b,
                   fsd611 d,
                   fpp001 c,
                   (select d.pgcod,
                           d.Ppmod,
                           d.ppsuc,
                           d.ppmda,
                           d.pppap,
                           d.ppcta,
                           d.ppoper,
                           d.pptope,
                           d.ppsbop,
                           d.ppfpag,
                           lpad(trim(to_char(d.Ppcta)), 9, '0') ||
                           lpad(trim(to_char(d.Ppmod)), 3, '0') ||
                           lpad(trim(to_char(d.Ppmda)), 3, '0') ||
                           lpad(trim(to_char(d.Ppoper)), 9, '0') ||
                           lpad(trim(to_char(d.Pptope)), 3, '0') numcta99,
                           to_char(trunc(d.ppfpag), 'yyyymmdd') fecemisioncuota99,
                           sum(d.pp1imp11 + pp1imp12 + pp1imp13) pago
                      from fsd612 d
                     group by d.pgcod,
                              d.Ppmod,
                              d.ppsuc,
                              d.ppmda,
                              d.pppap,
                              d.ppcta,
                              d.ppoper,
                              d.pptope,
                              d.ppsbop,
                              d.ppfpag) a,
                   fsd602 x,
                   fst001 g
             where c.pgcod = 1
               and c.aomod = a.Ppmod
               and c.aosuc = a.Ppsuc
               and c.aomda = a.Ppmda
               and c.aopap = a.Pppap
               and c.aocta = a.Ppcta
               and c.aooper = a.Ppoper
               and c.aotope = a.Pptope
               and c.aosbop = a.Ppsbop
               and c.SgCod in (120,121,122)
               and c.pp001imp > 0
               and d.ppmod = a.Ppmod
               and d.ppsuc = a.Ppsuc
               and d.ppmda = a.Ppmda
               and d.pppap = a.Pppap
               and d.ppcta = a.Ppcta
               and d.ppoper = a.Ppoper
               and d.pptope = a.Pptope
               and d.ppsbop = a.Ppsbop
               and d.ppfpag = a.ppfpag
               and (case when d.ppimp11 > 0 then d.ppimp11 when
                    d.ppimp11 = 0 and d.ppimp12 > 0 then d.ppimp12 else
                    d.ppimp13 end) = a.pago
               and b.pgcod = a.pgcod
               and b.ctnro = a.ppcta
               and g.pgcod = 1
               and g.sucurs = a.ppsuc
               and b.ttcod = 1
               and b.Cttfir = 'T'
               and not exists
             (select 1
                      from jaql099 j
                     where j.codproductocobro99 = '0005'
                       and j.numcta99 = a.numcta99
                       and j.fecemisioncuota99 = a.fecemisioncuota99)
               and x.ppmod not in (22, 21)
               and x.pgcod = a.pgcod
               and x.Ppmod = a.Ppmod
               and x.ppsuc = a.ppsuc
               and x.ppmda = a.ppmda
               and x.pppap = a.pppap
               and x.ppcta = a.ppcta
               and x.ppoper = a.ppoper
               and x.pptope = a.pptope
               and x.ppsbop = a.ppsbop
               and x.ppfpag = a.ppfpag
             group by '0005',
                      '0000000000',
                      '0000',
                      trim(b.pendoc),
                      '001',
                      'CRE',
                      a.numcta99,
                      '0000000000000000',
                      --'00150'
                      lpad(decode(a.ppmda,
                                  101,
                                  trunc((case
                                          when d.ppimp11 > 0 then
                                           d.ppimp11
                                          when d.ppimp11 = 0 and d.ppimp12 > 0 then
                                           d.ppimp12
                                          else
                                           d.ppimp13
                                        end) * fn_tipo_cambio(trunc(sysdate),
                                                              a.ppmda,
                                                              0,
                                                              2),
                                        1),
                                  (case
                                    when d.ppimp11 > 0 then
                                     d.ppimp11
                                    when d.ppimp11 = 0 and d.ppimp12 > 0 then
                                     d.ppimp12
                                    else
                                     d.ppimp13
                                  end)) * 100,
                           5,
                           '0'),
                      a.fecemisioncuota99,
                      to_char(trunc(trunc(sysdate)), 'yyyymmdd'),
                      lpad(trim(to_char(a.Ppcta)), 9, '0') ||
                      lpad(trim(to_char(a.Ppmod)), 3, '0') ||
                      lpad(trim(to_char(a.Ppmda)), 3, '0') ||
                      lpad(trim(to_char(a.Ppoper)), 9, '0') ||
                      lpad(trim(to_char(a.Pptope)), 3, '0'),
                      to_char(trunc(trunc(sysdate)), 'yyyymmdd'),
                      '00',
                      '',
                      to_char(a.Ppmda),
                      0,
                      0,
                      0,
                      a.ppfpag,
                      case
                        when d.ppimp11 > 0 then
                         d.ppimp11
                        when ppimp11 = 0 and d.ppimp12 > 0 then
                         d.ppimp12
                        else
                         d.ppimp13
                      end,
                      g.scnom,
                      a.ppcta,
                      a.ppoper);

  cursor resp is
    select CODPRODUCTOcobro99,
           NUMCERTIFICADOcobro99,
           NUMCUOTACOBRO99,
           FECPAGOCUOTA99,
           DOCDEPOSITO99,
           FECDEPOSITO99,
           decode(trim(CODERROR99), '00', '', CODERROR99) CODERROR99,
           decode(trim(CODERROR99), '00', '', DESCERROR99) DESCERROR99,
           MONTOPRIMACUOTA99 --10.08.2016
      from jaql099
     where JAQL99FEPR = PGFAPE
       and CODPRODUCTOcobro99 = '0005';

begin

  -- select pgfape - 1 into PGFAPE from fst017 where pgcod = 1;

  delete from jaql099
   where JAQL99FEPR = PGFAPE
     and CODPRODUCTOcobro99 = '0005';

  for i in pagos loop
    begin
      insert into jaql099
      values
        (i.jaql99fepr,
         i.codproductocobro99,
         i.numcertificadocobro99,
         i.numcuotacobro99,
         i.idtitularcta99,
         i.tipoid99,
         i.tipocta99,
         i.numcta99,
         i.numtarjeta99,
         i.montoprimacuota99,
         i.fecemisioncuota99,
         i.fecpagocuota99,
         i.docdeposito99,
         i.fecdeposito99,
         i.coderror99,
         i.descerror99,
         i.jaql99au01,
         i.jaql99itmo,
         i.jaql99ittr,
         i.jaql99itre);
    exception
      when others then
        error := sqlerrm;
        dbms_output.put_line(error || '-' || i.docdeposito99);
    end;
  end loop;

  commit;

  --delete from jaql361 where CODPRODUCTORPTA = '0005';

  for j in resp loop
    begin
      insert into jaql361
      values
        (j.CODPRODUCTOcobro99,
         j.NUMCERTIFICADOcobro99,
         j.NUMCUOTACOBRO99,
         j.FECPAGOCUOTA99,
         j.DOCDEPOSITO99,
         j.FECDEPOSITO99,
         j.CODERROR99,
         j.DESCERROR99,
         j.MONTOPRIMACUOTA99);--10.08.2016
    exception
      when others then
        error := sqlerrm;
        --dbms_output.put_line(error || '-' || i.docdeposito99);
    end;
  end loop;

  commit;

exception
  when others then
    error := sqlerrm;
    --dbms_output.put_line(error);  
end SP_COBROS_SEGUROS_CRED_PLAN_IV;
/

