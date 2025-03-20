create or replace procedure SP_COBROS_SEGUROS_DESGRAVAMEN is
  error varchar2(200);
  pgfape date := trunc(sysdate) - 1;
  --pgfape date := to_date('01/07/2013', 'dd/mm/yyyy');

----------------<<<<<<<<<<<<<<<<<<<
---///ejecutar los fines de mes 2015.04.30
---------------->>>>>>>>>>>>>>>>>>>>

  cursor pagos is
    select 
      a.jaql986fpa jaql99fepr, 
      '0006' codproductocobro99, 
      lpad(to_char(rownum), 10, '0') numcertificadocobro99,
      '0000' numcuotacobro99,
      trim(b.pendoc) IDTITULARCTA99,
      '001' tipoid99,
      'CRE' tipocta99,
       lpad(trim(to_char(a.jaql986cta)), 9, '0') ||
                                 lpad(trim(to_char(a.jaql986mod)), 3, '0') ||
                                 lpad(trim(to_char(a.jaql986mda)), 3, '0') ||
                                 lpad(trim(to_char(a.jaql986ope)), 9, '0') ||
                                 lpad(trim(to_char(a.jaql986top)), 3, '0') numcta99, 
      '0000000000000000' numtarjeta99,
       lpad(a.jaql986imp*100,'5','0') montoprimacuota99,
        to_char(trunc(a.jaql986fpa), 'yyyymmdd') fecemisioncuota99,
        to_char(trunc(a.jaql986fpa), 'yyyymmdd') fecpagocuota99,        
        lpad(trim(to_char(a.jaql986cta)), 9, '0') ||
                                  lpad(trim(to_char(a.jaql986mod)), 3, '0') ||
                                  lpad(trim(to_char(a.jaql986mda)), 3, '0') ||
                                  lpad(trim(to_char(a.jaql986ope)), 9, '0') ||
                                  lpad(trim(to_char(a.jaql986top)), 3, '0') docdeposito99,
           to_char(max(a.jaql986fec), 'yyyymmdd') fecdeposito99,
                                  '00' coderror99,
                                  '' descerror99,
                                  to_char(a.jaql986mda) jaql99au01,
                                  0 jaql99itmo,
                                  0 jaql99ittr,
                                  0 jaql99itre                        
                               
      from jaql986 a, fsr008 b, fst198 c 
      where b.ctnro = a.jaql986cta and b.cttfir = 'T' and b.ttcod = 1 
      and c.tp1cod1 = 10898 and c.tp1corr1 = 8 and a.jaql986seg = c.tp1imp1
      and a.jaql986fec = pgfape
      group by 
      a.jaql986fpa , 
      '0006', 
      lpad(to_char(rownum), 10, '0') ,
      '0000' ,
      trim(b.pendoc) ,
      '001' ,
      'CRE' ,
       lpad(trim(to_char(a.jaql986cta)), 9, '0') ||
                                 lpad(trim(to_char(a.jaql986mod)), 3, '0') ||
                                 lpad(trim(to_char(a.jaql986mda)), 3, '0') ||
                                 lpad(trim(to_char(a.jaql986ope)), 9, '0') ||
                                 lpad(trim(to_char(a.jaql986top)), 3, '0') , 
      '0000000000000000' ,
       lpad(a.jaql986imp*100,'5','0'),
        to_char(trunc(a.jaql986fpa), 'yyyymmdd') ,
        lpad(trim(to_char(a.jaql986cta)), 9, '0') ||
                                  lpad(trim(to_char(a.jaql986mod)), 3, '0') ||
                                  lpad(trim(to_char(a.jaql986mda)), 3, '0') ||
                                  lpad(trim(to_char(a.jaql986ope)), 9, '0') ||
                                  lpad(trim(to_char(a.jaql986top)), 3, '0'), 
                                  '00', 
                                  '' ,
                                  to_char(a.jaql986mda),
                                  0 ,
                                  0 ,
                                  0      ;
      

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
       and CODPRODUCTOcobro99 = '0006';

begin

  -- select pgfape - 1 into PGFAPE from fst017 where pgcod = 1;

  delete from jaql099
   where JAQL99FEPR = PGFAPE
     and CODPRODUCTOcobro99 = '0006';

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
end SP_COBROS_SEGUROS_DESGRAVAMEN;
/

