create or replace procedure SP_COBROS_SEGUROS_CRED(pgfape in date) is
  error varchar2(500);
  -- pgfape date := trunc(sysdate) - 1; 29/11/2016 MPOSTIGOC

  NUM_JOB_PENDIENTES number(10) := 0;
  --pgfape date := to_date('01/07/2013', 'dd/mm/yyyy');

  cursor pagos is
    select pgfape jaql99fepr,
           '0004' codproductocobro99,
           lpad(to_char(rownum), 10, '0') numcertificadocobro99,
           '0000' numcuotacobro99,
           trim(JAQY145doc) idtitularcta99,
           '001' tipoid99,
           'CRE' tipocta99,
           lpad(trim(to_char(jaqy145cta)), 9, '0') ||
           lpad(trim(to_char(jaqy145mod)), 3, '0') ||
           lpad(trim(to_char(jaqy145mda)), 3, '0') ||
           lpad(trim(to_char(jaqy145ope)), 9, '0') ||
           lpad(trim(to_char(jaqy145top)), 3, '0') numcta99,
           '0000000000000000' numtarjeta99,
           lpad(decode(jaqy145mda,
                       101,
                       trunc(jaqy145impsg *
                             fn_tipo_cambio(pgfape + 1, jaqy145mda, 0, 2),
                             1),
                       jaqy145impsg) * 100,
                5,
                '0') montoprimacuota99,
           to_char(jaqy145fchcuo, 'yyyymmdd') fecemisioncuota99,
           to_char(jaqy145fchpag, 'yyyymmdd') fecpagocuota99,
           lpad(trim(to_char(jaqy145cta)), 9, '0') ||
           lpad(trim(to_char(jaqy145mod)), 3, '0') ||
           lpad(trim(to_char(jaqy145mda)), 3, '0') ||
           lpad(trim(to_char(jaqy145ope)), 9, '0') ||
           lpad(trim(to_char(jaqy145top)), 3, '0') docdeposito99,
           to_char(pgfape, 'yyyymmdd') fecdeposito99,
           '00' coderror99,
           '' descerror99,
           to_char(jaqy145mda) jaql99au01,
           0 jaql99itmo,
           0 jaql99ittr,
           0 jaql99itre
      from JAQY145;

  cursor resp is
    select CODPRODUCTOcobro99,
           NUMCERTIFICADOcobro99,
           NUMCUOTACOBRO99,
           FECPAGOCUOTA99,
           DOCDEPOSITO99,
           FECDEPOSITO99,
           decode(trim(CODERROR99), '00', '', CODERROR99) CODERROR99,
           decode(trim(CODERROR99), '00', '', DESCERROR99) DESCERROR99,
           MONTOPRIMACUOTA99
      from jaql099
     where JAQL99FEPR = PGFAPE
       and CODPRODUCTOcobro99 = '0004';

begin

  begin
    delete from jaql099
     where JAQL99FEPR = PGFAPE
       and CODPRODUCTOcobro99 = '0004';
  
    commit;
  end;

  begin
    delete from jaql361 q
     where q.CODPRODUCTORPTA = '0004'
       and q.FecDeposito = PGFAPE;
  
    commit;
  end;

  begin
    -- Call the procedure
    pq_cr_vidacaja.sp_carga(pd_fecini => pgfape, pd_fecpro => pgfape);
  end;

  begin
    -- Call the procedure
    pq_cr_vidacaja.sp_cr_cargavc_job(pd_fecini => pgfape,
                                     pd_fecpro => pgfape);
  end;
  --verificar que los jobs hayan terminado
  NUM_JOB_PENDIENTES := pq_cr_vidacaja.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'SEG_VIDA',
                                                            pi_vc2_nomusr => USER);

  WHILE NUM_JOB_PENDIENTES > 0 LOOP
  
    NUM_JOB_PENDIENTES := pq_cr_vidacaja.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'SEG_VIDA',
                                                              pi_vc2_nomusr => USER);
  end loop;

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
         j.MONTOPRIMACUOTA99);
    exception
      when others then
        error := sqlerrm;
    end;
  end loop;

  commit;
exception
  when others then
    error := sqlerrm;
    --dbms_output.put_line(error);  
end SP_COBROS_SEGUROS_CRED;
/

