create or replace procedure SP_COBROS_SEGUROS_CRED_FAMILIA(pgfape in date) is
------------------------------------------------------------------------------
-- Modificacion : Adicion de Codigos de Salud FAmiliar codigo producto 0011
-- Autor        : Silvia MArquez
-- Fecha        :04/03/2020
-------------------------------------------------------------------------------
  error varchar2(200);
  -- pgfape date := trunc(sysdate) - 1;
  NUM_JOB_PENDIENTES number(10) := 0;
  -- pgfape date := to_date('25/05/2016', 'dd/mm/yyyy');
  fechades date;
  codpro   char(4);
  cursor pagos is
    select pgfape jaql99fepr,
           '0005' codproductocobro99,
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
           0 jaql99itre,
           jaqy145suc suc, --SMA 04032020 adicion de campos
           jaqy145cta cta,
           jaqy145mod modu,
           jaqy145mda mda,
           jaqy145ope oper,
           jaqy145top tipo 
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
           MONTOPRIMACUOTA99 --10.08.2016
      from jaql099
     where JAQL99FEPR = PGFAPE
       and CODPRODUCTOcobro99 in ('0005','0011');

begin

  -- select pgfape - 1 into PGFAPE from fst017 where pgcod = 1;
  begin
    delete from jaql099
     where JAQL99FEPR = PGFAPE
       and CODPRODUCTOcobro99 in ('0005','0011'); --SMA codigo '0011'
  end;

  begin
    delete from jaql361 q
     where q.CODPRODUCTORPTA in ('0005','0011') --SMA codigo '0011'
       and q.FecDeposito = PGFAPE;
      commit;
  end;

  begin
    -- Call the procedure
    pq_cr_famsegura.sp_carga(pd_fecini => pgfape, pd_fecpro => pgfape);
  end;

  begin
    -- Call the procedure
    pq_cr_famsegura.sp_cr_cargavc_job(pd_fecini => pgfape,
                                      pd_fecpro => pgfape);
  end;
  --verificar que los jobs hayan terminado
  NUM_JOB_PENDIENTES := pq_cr_famsegura.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'FAM_SEG',
                                                             pi_vc2_nomusr => USER);

  WHILE NUM_JOB_PENDIENTES > 0 LOOP

    NUM_JOB_PENDIENTES := pq_cr_famsegura.FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'FAM_SEG',
                                                               pi_vc2_nomusr => USER);
  end loop;

  for i in pagos loop
    Begin --SMA 04032020
      select a.aofval             
        into fechades 
        from fsd010 a,
             fpp001 b
       where a.pgcod = 1
         and a.aomod = i.modu
         and a.aosuc = i.suc
         and a.aomda = i.mda
         and a.aopap = 0
         and a.aocta = i.cta
         and a.aooper = i.oper
         and a.aotope = i.tipo
         and b.pgcod = a.pgcod
         and b.aomod = a.aomod
         and b.aosuc = a.aosuc
         and b.aomda = a.aomda
         and b.aopap = a.aopap
         and b.aocta = a.aocta
         and b.aooper = a.aooper
         and b.aotope = a.aotope
         and b.sgcod in (select tp1nro1
                             from fst198
                            where tp1cod = 1
                              and tp1cod1 = 10875
                              and tp1corr1 = 4
                              AND TP1CORR2 = 1 
                              and tp1nro2 = 2);
       if fechades >= to_date('18/11/2019','dd/mm/yyyy') then
         codpro := '0011';
       else
         codpro := '0005';
       end if;
    exception
      when others then
        codpro := '0004';
    end;
    
    Begin
      insert into jaql099
      values
        (i.jaql99fepr,
         codpro,--i.codproductocobro99, --SMA codigo 
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
         j.MONTOPRIMACUOTA99); --10.08.2016

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
end SP_COBROS_SEGUROS_CRED_FAMILIA;
/

