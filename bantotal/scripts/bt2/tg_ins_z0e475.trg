CREATE OR REPLACE TRIGGER TG_INS_Z0E475
  after insert on Z0E475
  for each row
  
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  --pc_valant CHAR(150);
  --pc_valact CHAR(150);  
BEGIN
        pn_pgcod := 1;
        pn_hcmod := 800;
        pn_htran := 201;
        pc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
           select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
        end;                      
                  pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                               pn_hcmod  => pn_hcmod,
                                                               pn_hsucor => 903,
                                                               pn_htran  => pn_htran,
                                                               pn_hnrel  => 0,
                                                               pd_fecpro => pd_fecpro,
                                                               pc_uing   => 'BANTOTAL',
                                                               pc_hora   => pc_hora,
                                                               pc_cont   => 'S',
                                                               pn_corr   =>  0,
                                                               pn_pais   => to_number(to_char(pd_fecpro,'yyyymmdd')),
                                                               pn_tipo   => 0,
                                                               pc_numero => substr(trim(:new.Z0E475COD),1,12),
                                                               pc_valant => substr(:new.z0e475dsc,1,40),
                                                               pc_valact => substr(:new.z0e475ubi,1,50)
                                                               );                                                          
Exception
When others then
    null;
END TG_INS_Z0E475;


--select * from JAQL977A for update
/

