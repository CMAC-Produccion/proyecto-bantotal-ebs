CREATE OR REPLACE TRIGGER TG_SCH003_AU_02
  after update on SCH003
  for each row

DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_hsucor fsd015.itsuc%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora   char(8);
  lc_cuenta char(27);
  WrkstName varchar2(50);
  ExistConData      NUMBER;
BEGIN
    if :old.sch003est <> :new.sch003est then   
               
          pn_pgcod := 1;
          pn_hcmod := 800;
          pn_htran := 502;          
          pc_hora := to_char(sysdate,'HH24:mi:ss');
          
          begin
                   select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
          end;
        -- Call the procedure
           
           begin
                select UBSUC into pn_hsucor from fst046 where ubuser= :new.sch003usc;
           exception
           when others then
                pn_hsucor := 999;                
           end;

            lc_cuenta := lpad(:old.sch003cta,9,'0')||lpad(:old.sch003mod,3,'0')||lpad(:old.sch003mda,3,'0')||lpad(:old.sch003sbo,2,'0')||lpad(:old.sch003top,3,'0');
            
            SELECT COUNT(*)
              INTO ExistConData
              FROM DBA_OBJECTS
             WHERE OWNER = sys_context('userenv', 'current_schema')
               AND OBJECT_TYPE = 'TABLE'
               AND OBJECT_NAME = 'CONDATA';
                 
            if ExistConData > 0 then
              begin
                SELECT MAX(Value) 
                  INTO WrkstName 
                  FROM CONDATA 
                 WHERE Data = 'WRKST';--'SERVER'
              exception
              when others then
                WrkstName := null;
              end;
            else
              SELECT COALESCE(WrkstName, sys_context('USERENV', 'HOST'), 'NOTDEFINED')
                INTO WrkstName
                FROM dual;        
            end if;   
            pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => 0,
                                                         pd_fecpro => pd_fecpro,
                                                         pc_uing   => :new.sch003usc,
                                                         pc_hora   => pc_hora,
                                                         pc_cont   => 'S',
                                                         pn_corr   =>  0,
                                                         pn_pais   => :old.sch003est,
                                                         pn_tipo   => :new.sch003est,
                                                         pc_numero => lpad(to_char(:new.sch003cnt),5,'0')||lpad(to_char(:new.sch003tdo),3,'0')||lpad(to_char(:new.sch003cin),9,'0'),
                                                         pc_valant => lc_cuenta||substr(WrkstName,1,15),
                                                         pc_valact => to_char(:old.sch003suc)
                                                         );
    end if;                                                         
Exception
When others then
    null;
END TG_SCH003_AU_02;
/

