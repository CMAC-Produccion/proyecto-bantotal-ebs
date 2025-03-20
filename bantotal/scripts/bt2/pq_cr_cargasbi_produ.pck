create or replace package PQ_CR_CARGASBI_PRODU is

  -- Author  : MPOSTIGOC
  -- Created : 7/07/2023 10:30:06
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_cargaAQPB162;

end PQ_CR_CARGASBI_PRODU;
/

create or replace package body PQ_CR_CARGASBI_PRODU is

  procedure sp_cr_cargaAQPB162 is
  
    lc_hora        varchar2(8) := '00:00:00';
    ld_fchaSist    date;
    ln_CInfoPuente number(17);
  
  begin
  
    begin
      select f.pgfape into ld_fchaSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*) into ln_CInfoPuente from USRBNDJ.aqpb162A a;
    exception
      when others then
        null;
    end;
  
    if ln_CInfoPuente > 0 then
    
      begin
        -- aqpb162A Carga de informacion de BI para Opinion de Riesgos
        insert into aqpb162
          select a.*, ld_fchaSist, lc_hora from USRBNDJ.aqpb162A a;
        commit;
      end;
    
    end if;
  end;
end PQ_CR_CARGASBI_PRODU;
/

