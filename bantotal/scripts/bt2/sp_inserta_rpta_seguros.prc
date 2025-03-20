create or replace procedure SP_INSERTA_RPTA_SEGUROS(PGFAPE date) is

  error varchar2(200);

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
       and CODPRODUCTOcobro99 not in ('0004', '0005');

begin
  commit;
  --delete from jaql361 where CODPRODUCTORPTA != '0004';
  
  SP_REGISTRO_SEG_FSD602;

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
      commit;
    exception
      when others then
        error := sqlerrm;
        --dbms_output.put_line(error || '-' || i.docdeposito99);
    end;
  end loop;

  commit;

  --execute immediate 'DBMS_SESSION.close_database_link(''SISRETAIL'')';
  --DBMS_SESSION.close_database_link('SISRETAIL');  
 
  execute immediate 'ALTER SESSION ADVISE COMMIT';    
  delete from jaql360;
  commit;
 
 delete from fsd016
   where itmod = 98
     and ittran in (290, 291, 292, 293)
     and itanu <> 'N';
  
   commit;

end SP_INSERTA_RPTA_SEGUROS;
/

