CREATE OR REPLACE TRIGGER TG_SCH003_AU_01
  after update on SCH003
  for each row

DECLARE
  pc_hora    char(8);
  lc_usuario char(10);
  pn_hsucor  fsd015.itsuc%type;
  pd_fecpro  date;
BEGIN
     pc_hora := to_char(sysdate,'HH24:mi:ss');
     lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);
                    
      begin
            select UBSUC into pn_hsucor from fst046 where ubuser= lc_usuario;
      exception
      when others then
            pn_hsucor := 999;                
      end;
          
      begin
            select a.pgfape into pd_fecpro from fst017 a where a.pgcod= :new.sch003emp;
      end;
        -- Call the procedure
      begin
        insert into jaqz186a(jaqz186apgc,
                             jaqz186asol,
                             jaqz186acor,
                             jaqz186afec,
                             jaqz186ahor,
                             jaqz186aage,
                             jaqz186ausr,
                             jaqz186aean,
                             jaqz186aeac
                            ) 
                      values(:old.sch003emp,
                             :old.sch003ped,
                             SQ_AH_ID_CHEQUERAS.NEXTVAL,
                             pd_fecpro,
                             pc_hora,
                             pn_hsucor,
                             lc_usuario,
                             :old.sch003est,
                             :new.sch003est
                            );                            
      exception 
      when others then  
        null;
      end;          
Exception
When others then
    null;
END TG_SCH003_AU_01;
/

