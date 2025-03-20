CREATE OR REPLACE TRIGGER TG_UPD_JAQL420
  after update on JAQL420
  for each row

DECLARE
  pn_pgcod     number := 1;
  pd_fecpro    date;
  pc_hora      char(8);
  pn_hsucor    number(3);
  pn_htran     number(3);
  pn_hcmod     number(3);
  LN_SECUENCIA number;
  ln_valida    number:=0;
  ln_null      number;
BEGIN

  If  :new.jaql420esr = 3 and :old.jaql420fdt = '1' Then
        pn_hcmod := 800;
        pn_htran := 300;
               
        begin
          pq_op_asientos_mplus.sp_ah_valida_trx(pn_pgcod  => pn_pgcod,
                                                pn_hcmod  => pn_hcmod,
                                                pn_htran  => pn_htran,
                                                pn_indvig => ln_valida,
                                                pn_tipmon => ln_null
                                                );      
        end;                                                             
        
        If ln_valida > 0 then
        
            begin
                     select a.pgfape into pd_fecpro from fst017 a where a.pgcod = pn_pgcod;
            end;
            
            begin
                     select ubsuc into pn_hsucor from fst046 where ubuser= :new.jaql420usp;
            end;
            
            pc_hora := to_char(sysdate,'HH24:mi:ss');
            
            select SEQ_JAQL977A.NEXTVAL INTO LN_SECUENCIA from DUAL;
            
           begin
             insert into JAQL977A
                (
                jaql977acor,
                jaql977acod,
                jaql977asuc,
                jaql977amod,
                jaql977atran,
                jaql977anrel,
                jaql977afcon,
                jaql977auing,
                jaql977ahora,
                jaql977acont,
                JAQL977acorr
                )
             values
                (LN_SECUENCIA,
                 pn_pgcod,
                 pn_hsucor,
                 pn_hcmod,
                 pn_htran,
                 0,
                 pd_fecpro,
                 :new.jaql420usp,--pc_uing,
                 pc_hora,
                 'S',
                 0
                 );
           Exception
           When others then 
               null;
           End;
                         
                         
          begin
            -- Call the procedure
            pq_op_asientos_mplus.sp_op_carga_jaql978(pn_cor    => LN_SECUENCIA,
                                                     pd_fecpro => pd_fecpro,
                                                     pc_hora   => pc_hora,
                                                     pc_codrec => :new.jaql420cod,
                                                     pn_numrec => :new.jaql420cor,
                                                     pd_fecreg => :new.jaql420fcr,
                                                     pd_fecsol => :new.jaql420fcp,
                                                     pc_usureg => :new.jaql420usr,
                                                     pc_ususol => :new.jaql420usp,
                                                     pc_numero => :new.jaql420ndc,
                                                     pc_detrec => :new.jaql420cmr,
                                                     pc_canrec => :new.jaql420vir,
                                                     pc_solrec => :new.jaql420cms
                                                     );
          end;   
                            
      End If;                                   
                                                         
  End If;
Exception
When others then
    null;
END TG_UPD_Z0E478;
/

