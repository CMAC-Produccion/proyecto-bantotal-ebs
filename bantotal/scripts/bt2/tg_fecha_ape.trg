CREATE OR REPLACE TRIGGER "TG_FECHA_APE"
  before update of pgfape on fst017
  for each row
declare
  AUFECINS  DATE;
  AUUSUINS  VARCHAR2(30);
  AUTERINS  VARCHAR2(64);
  AUIPINSE  VARCHAR2(15);
  AUUSOINS  VARCHAR2(30);
  pgfapeant date;
  pgfapenew date;
begin

  pgfapeant := :old.pgfape;
  pgfapenew := :new.pgfape;

  AUFECINS := SYSDATE;
  AUUSUINS := USER;
  AUTERINS := SUBSTR(SYS_CONTEXT('USERENV', 'host'), 1, 20);
  AUIPINSE := SUBSTR(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), 1, 20);
  AUUSOINS := SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'), 1, 20);

  /*  execute immediate 'insert into fecha_ape (pgfapeant, pgfapenew, AUFECINS, AUUSUINS, AUTERINS, AUIPINSE, AUUSOINS) values ('''
    || pgfapeant ||''', ''' || pgfapenew ||''', ''' || AUFECINS ||''', ''' || AUUSUINS ||''', ''' || AUTERINS ||''', ''' || AUIPINSE ||''', ''' || AUUSOINS||
    ''') ';
  */

  execute immediate 'insert into fecha_ape (pgfapeant, pgfapenew) values (''' ||
                    pgfapeant || ''', ''' || pgfapenew || ''') ';

exception
  when others then
    null;
end;

/*
create table fecha_ape
(
  AUFECINS  DATE default SYSDATE,
  AUUSUINS  VARCHAR2(30) default USER,
  AUTERINS  VARCHAR2(64) default SUBSTR(SYS_CONTEXT('USERENV', 'host'),1,20),
  AUIPINSE  VARCHAR2(15) default SUBSTR(SYS_CONTEXT('USERENV','IP_ADDRESS'),1,20),
  AUUSOINS  VARCHAR2(30) default SUBSTR(SYS_CONTEXT('USERENV','OS_USER'),1,20),
  PGFAPEANT DATE,
  PGFAPENEW DATE
)

select * from  fecha_ape

truncate table fecha_ape

*/
/

