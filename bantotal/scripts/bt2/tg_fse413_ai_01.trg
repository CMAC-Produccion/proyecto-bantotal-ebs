CREATE OR REPLACE TRIGGER TG_FSE413_AI_01 after insert on FSE413 for each row

DECLARE

vusuario char(10);
vfecha date := trunc(sysdate);
vhora char(8) := to_char(sysdate, 'HH24:mi:ss');

BEGIN
  If :new.SE413FTE = 22 Then
    -- motivo credinka
    begin
      select trim(CV1AUX6)
        into vusuario
        from fse113
       where pgcod = :new.se413cod
         and cv1mod = :new.se413mod
         and cv1mda = :new.se413mda
         and cv1pap = :new.se413pap
         and cv1cta = :new.se413cta
         and cv1suc = :new.se413suc
         and cv1oper = :new.se413ope
         and cv1sbop = :new.se413sbo
         and cv1tope = :new.se413top;


    Exception
      When others then
        vusuario := '';
    END;


      begin

      insert into jaql054
        (JAQL54PGCO,
         JAQL54SCSU,
         JAQL54SCMD,
         JAQL54SCPA,
         JAQL54SCCT,
         JAQL54SCOP,
         JAQL54SCSB,
         JAQL54SCTO,
         JAQL54SCMO,
         JAQL54TIMI,
         JAQL54ENTI,
         JAQL54FECH,
         JAQL54HORA,
         JAQL54SACA,
         JAQL54SAIN,
         JAQL54AU01)
      values
        (:new.se413cod,
         :new.se413suc,
         :new.se413mda,
         :new.se413pap,
         :new.se413cta,
         :new.se413ope,
         :new.se413sbo,
         :new.se413top,
         :new.se413mod,
         'M',
         230,
         vfecha,
         vhora,
         0,
         0,
         vusuario);
    end;
  end if;

Exception
  When others then
    null;
END TG_FSE413_AI_01;
/

