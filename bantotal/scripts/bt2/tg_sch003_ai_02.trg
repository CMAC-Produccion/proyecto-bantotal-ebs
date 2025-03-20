CREATE OR REPLACE TRIGGER TG_SCH003_AI_02
  after insert on SCH003
  for each row

DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_hsucor fsd015.itsuc%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora   char(8);
  lc_cuenta char(27);
  --lc_trx    char(16);
BEGIN
               
          pn_pgcod := 1;
          pn_hcmod := 800;
          pn_htran := 600;          
          pc_hora := to_char(sysdate,'HH24:mi:ss');
          
          begin
                   select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
          end;
        -- Call the procedure
           
           begin
                select UBSUC into pn_hsucor from fst046 where ubuser= :new.sch003usi;
           exception
           when others then
                pn_hsucor := 999;                
           end;
           
            lc_cuenta := lpad(:new.sch003cta,9,'0')||lpad(:new.sch003mod,3,'0')||lpad(:new.sch003mda,3,'0')||lpad(:new.sch003sbo,2,'0')||lpad(:new.sch003top,3,'0');
            --lc_trx    := lpad(:new.SCH003PG,3,'0')||lpad(:new.SCH003MO,3,'0')||lpad(:new.SCH003CSU,3,'0')||lpad(:new.SCH003TR,3,'0')||lpad(:new.SCH003RE,4,'0');          
            pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => 0,
                                                         pd_fecpro => pd_fecpro,
                                                         pc_uing   => :new.sch003usi,
                                                         pc_hora   => pc_hora,
                                                         pc_cont   => 'S',
                                                         pn_corr   =>  0,
                                                         pn_pais   => :new.sch003ped,
                                                         pn_tipo   => :new.sch003cnt,
                                                         pc_numero => to_char(:new.sch003tdo),
                                                         pc_valant => lc_cuenta,
                                                         pc_valact => to_char(:new.sch003suc)
                                                         );
Exception
When others then
    null;
END TG_SCH003_AI_02;
/

