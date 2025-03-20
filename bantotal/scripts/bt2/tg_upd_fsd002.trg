CREATE OR REPLACE TRIGGER TG_UPD_FSD002
  after update on FSD002
  for each row
  
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  lc_numtar varchar2(65);
  pc_valant CHAR(150);
  pc_valact CHAR(150);
BEGIN

  pc_valant := trim(:old.pfape1)||' '||trim(:old.pfape2)||', '||trim(:old.pfnom1)||' '||trim(:old.pfnom2);
  pc_valact := trim(:new.pfape1)||' '||trim(:new.pfape2)||', '||trim(:new.pfnom1)||' '||trim(:new.pfnom2);
  
  If  pc_valant <> pc_valact Then
  
        pn_pgcod := 1;
        pn_hcmod := 800;
        pn_htran := 105;
        pc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
           select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
        end;

          
       lc_numtar := pq_op_asientos_mplus.fn_ah_doctarjeta(pn_pais   => :new.pfpais,
                                                          pn_tipo   => :new.pftdoc,
                                                          pc_numero => :new.pfndoc,
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
                                                         pn_pais   => :new.pfpais,
                                                         pn_tipo   => :new.pftdoc,
                                                         pc_numero => :new.pfndoc,
                                                         pc_valant => pc_valant,
                                                         pc_valact => pc_valact
                                                         );
          
                                                         
       End If;                                                           
  End IF;
Exception
When others then
    null;
END TG_UPD_FSD002;


--select * from JAQL977A for update
/

