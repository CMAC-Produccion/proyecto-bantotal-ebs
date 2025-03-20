CREATE OR REPLACE TRIGGER TG_TDW041_AI_01
  after insert on tdw041
  for each row
declare 
pc_hora char(8);
pc_fecha date;

begin
    delete from aqpb101b where aqpb101btar = :new.tdw041tar;

    
    pc_hora := to_char(sysdate,'HH24:mi:ss');  
    select to_date(sysdate) into pc_fecha from dual;  
    insert into aqpb101b
    (aqpb101bpro, aqpb101btar, aqpb101bfec, aqpb101bhor)
    
    values(:new.tdw040pro, :new.tdw041tar, pc_fecha, pc_hora)


    ;


END TG_TDW041_AI_01;
/

