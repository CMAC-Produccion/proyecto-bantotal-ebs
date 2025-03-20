CREATE OR REPLACE TRIGGER TG_FSD012_BU_01
  before update on FSD012
  for each row
  
DECLARE
  pn_hcmod   fst003.modulo%type;
  pn_htran   fsd015.ittran%type;
  pn_hsucor  fsd015.itsuc%type;
  pn_pgcod   fst017.pgcod%type;
  pd_fecpro  fst017.pgfape%type;
  pc_hora    char(8);
  lc_cuenta  char(27);
  lc_usuario char(10);
  WrkstName  varchar2(50);
  ExistConData      NUMBER;
BEGIN
    
  if :new.aomod = 22  and :old.evtasa <> :new.evtasa then
      pn_pgcod := 1;
      pn_hcmod := 800;
      pn_htran := 501;          

              
      begin
               select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
      end;

      pc_hora := to_char(sysdate,'HH24:mi:ss');
      lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);

               
      begin
            select UBSUC into pn_hsucor from fst046 where ubuser= lc_usuario;
      exception
      when others then
            pn_hsucor := 999;                
      end;
      
      lc_cuenta := lpad(:new.aocta,9,'0')||lpad(:new.aomod,3,'0')||lpad(:new.aomda,3,'0')||lpad(:new.aooper,9,'0')||lpad(:new.aotope,3,'0');                
      
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
                                                   pc_uing   => lc_usuario,
                                                   pc_hora   => pc_hora,
                                                   pc_cont   => 'S',
                                                   pn_corr   => 0,
                                                   pn_pais   => :old.evtasa,
                                                   pn_tipo   => :new.evtasa,
                                                   pc_numero => to_char(:new.aosbop),
                                                   pc_valant => lc_cuenta||substr(WrkstName,1,15),
                                                   pc_valact => to_char(:new.aosuc)
                                                   );  
  end if;                                                   
                                     
Exception
When others then
    null;
END TG_FSD012_BU_01;
/

