CREATE OR REPLACE TRIGGER TG_FSR427_BI_01
  before insert on FSR427
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
  ln_tope    fsd011.sctope%type;
  ln_sucu    fsd011.scsuc%type;
  WrkstName  varchar2(50);
  ExistConData      NUMBER;
BEGIN
    
  if :new.tasmod = 21 then
      pn_pgcod := 1;
      pn_hcmod := 800;
      pn_htran := 500;          

              
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
      
      --fsd011 para obtener sucursal y tipo de operacion
      begin
          select a.scsuc, a.sctope
            into ln_sucu, ln_tope
            from fsd011 a
           where a.pgcod  = :new.tasemp
             and a.sccta  = :new.tascta
             and a.scmod  = :new.tasmod
             and a.scmda  = :new.tasmda
             and a.scpap  = :new.taspap
             and a.scoper = 0
             and a.scsbop = :new.tassop;
      Exception
      When others then     
        ln_sucu := 999; 
        ln_tope := 0;
      end;           
      lc_cuenta := lpad(:new.tascta,9,'0')||lpad(:new.tasmod,3,'0')||lpad(:new.tasmda,3,'0')||lpad(:new.tassop,2,'0')||lpad(ln_tope,3,'0');
      
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
                                                   pn_pais   => 0,--el estado actual lo obtenemos en el paquete
                                                   pn_tipo   => :new.tastasa,
                                                   pc_numero => to_char(:new.tassop),
                                                   pc_valant => lc_cuenta||substr(WrkstName,1,15),
                                                   pc_valact => to_char(ln_sucu)
                                                   );  
  end if;                                                   
                                     
Exception
When others then
    null;
END TG_FSR427_BI_01;
/

