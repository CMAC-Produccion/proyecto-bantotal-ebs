CREATE OR REPLACE TRIGGER TG_UPD_FSR003
  after update on FSR003
  for each row
  
DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  lc_numtar varchar2(65);
  lc_estado char(1):= 'N';
  pc_valant CHAR(150);
  pc_valact CHAR(150);  
BEGIN
        pn_pgcod := 1;
        pn_hcmod := 800;
        pn_htran := 106;
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
       
            BEGIN
                select 'S' into lc_estado
                  from FST198
                 Where Tp1cod = 1
                   AND Tp1cod1 = 10817
                   AND Tp1corr1 = 1
                   and tp1nro1 = :new.vicod;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               lc_estado := 'N';
            END;
            If  lc_estado = 'S' Then       
       
                  begin
                    select trim(pfape1)||' '||trim(pfape2)||', '||trim(pfnom1)||' '||trim(pfnom2) into pc_valant
                      from fsd002
                     where pfpais = :old.pfpai1
                       and pftdoc = :old.pftdo1
                       and pfndoc = :old.pfndo1;
                  exception
                  when others then    
                    pc_valant := null;
                  end; 
                  
                  begin
                    select trim(pfape1)||' '||trim(pfape2)||', '||trim(pfnom1)||' '||trim(pfnom2) into pc_valact
                      from fsd002
                     where pfpais = :new.pfpai1
                       and pftdoc = :new.pftdo1
                       and pfndoc = :new.pfndo1;
                  exception
                  when others then    
                    pc_valact := null;
                  end;                      
                      
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
                                                               pc_valant => pc_valant,
                                                               pc_valact => pc_valact
                                                               );
          
            End If;                                             
       End If;                                                           
Exception
When others then
    null;
END TG_UPD_FSR003;


--select * from JAQL977A for update
/

