CREATE OR REPLACE TRIGGER "TG_JAQL082_AU_01"
  after update on jaql082
  for each row
declare
pc_pgcod number(3);


begin

    pc_pgcod := 1;
    if (:new.JAQL82ESTA='S') then

    insert into fsx016
    (PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, HCORD, HCSUBO, TXCOD, TXOREN, TXTORD)

    values(pc_pgcod, :new.JAQL82ITMO, :new.JAQL82ITSU, :new.JAQL82ITTR, :new.JAQL82ITRE,:new.JAQL82ITFC,10,1,174,1,:new.JAQL82COPA );
    end if;
END TG_JAQL082_AU_01;
/

