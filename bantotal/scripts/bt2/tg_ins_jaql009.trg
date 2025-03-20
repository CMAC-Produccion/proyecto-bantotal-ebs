CREATE OR REPLACE TRIGGER TG_INS_JAQL009
  after insert on JAQL009
  for each row
  
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  --pc_valant CHAR(150);
  pc_valact CHAR(150);  
BEGIN
        pn_pgcod := 1;
        pn_hcmod := 800;
        pn_htran := 200;
        pc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
           select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
        end;                      
                  pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                               pn_hcmod  => pn_hcmod,
                                                               pn_hsucor => 902,
                                                               pn_htran  => pn_htran,
                                                               pn_hnrel  => 0,
                                                               pd_fecpro => pd_fecpro,
                                                               pc_uing   => 'BANTOTAL',
                                                               pc_hora   => pc_hora,
                                                               pc_cont   => 'S',
                                                               pn_corr   =>  0,
                                                               pn_pais   => to_number(to_char(:new.jaql9fealt,'yyyymmdd')),
                                                               pn_tipo   => :new.jaql9nuele,
                                                               pc_numero => substr(trim(:new.JAQL4COCOM),1,12),
                                                               pc_valant => substr(:new.jaql2coter,1,20),
                                                               pc_valact => pc_valact
                                                               );                                                          
Exception
When others then
    null;
END TG_INS_JAQL009;


--select * from JAQL977A for update
/

