CREATE OR REPLACE TRIGGER TG_UPD_FSD003
  after update on FSD003
  for each row
  
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  lc_numtar varchar2(65);
  
BEGIN
  
  If  :new.pjrazs <> :old.pjrazs Then
  
        pn_pgcod := 1;
        pn_hcmod := 800;
        pn_htran := 105;
        pc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
           select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
        end;

          
       lc_numtar := pq_op_asientos_mplus.fn_ah_doctarjeta(pn_pais   => :new.pjpais,
                                                          pn_tipo   => :new.pjtdoc,
                                                          pc_numero => :new.pjndoc,
                                                          pd_fecpro => pd_fecpro
                                                          );   
                                                          

       If lc_numtar is not null then    
       
            pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => 999,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => 0,
                                                         pd_fecpro => pd_fecpro,
                                                         pc_uing   => 'BANTOTAL',
                                                         pc_hora   => pc_hora,
                                                         pc_cont   => 'S',
                                                         pn_corr   =>  0,
                                                         pn_pais   => :new.pjpais,
                                                         pn_tipo   => :new.pjtdoc,
                                                         pc_numero => :new.pjndoc,
                                                         pc_valant => :old.pjrazs,
                                                         pc_valact => :new.pjrazs
                                                         );
          
                                                         
       End If;                                                           
  End IF;
Exception
When others then
    null;
END TG_UPD_FSD003;


--select * from JAQL977A for update
/

