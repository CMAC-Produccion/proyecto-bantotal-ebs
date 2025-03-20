CREATE OR REPLACE TRIGGER TG_UPD_Z0E478
  after update on Z0E478
  for each row

DECLARE
  pn_hcmod  fst003.modulo%type;
  pn_htran  fsd015.ittran%type;
  pn_hsucor fsd015.itsuc%type;
  pn_pgcod  fst017.pgcod%type;
  pd_fecpro fst017.pgfape%type;
  pc_hora char(8);
  lc_z0e463dscant z0e463.z0e463dsc%type;
  lc_z0e463dscact z0e463.z0e463dsc%type;
  lc_valido char(1) := 'N';
BEGIN

  If  :new.z0e463cod <> :old.z0e463cod Then
        pn_pgcod := 1;
        pn_hcmod := 800;
        pc_hora := to_char(sysdate,'HH24:mi:ss');
        begin
                 select a.pgfape into pd_fecpro from fst017 a where a.pgcod= pn_pgcod;
        end;

        /*If  :new.z0e463cod in (5,9) Then*/
            pn_htran := 100;
        /*ElsIf :new.z0e463cod = 1 Then
            pn_htran := 101;
        end If;*/

        If  :old.z0e463cod not in (/*1,*/5,9) Then
        -- Call the procedure
           begin
                select a.z0e463dsc into lc_z0e463dscant from z0e463 a  where z0e463cod = :old.z0e463cod;
           exception
           when others then
                lc_z0e463dscant := null;
           end;

           begin
                select a.z0e463dsc into lc_z0e463dscact from z0e463 a  where z0e463cod = :new.z0e463cod;
           exception
           when others then
                lc_z0e463dscact := null;
           end;

           begin
                select UBSUC into pn_hsucor from fst046 where ubuser= :new.z0e478uau;
           exception
           when others then
                pn_hsucor := 999;
           end;
            pq_op_asientos_mplus.sp_op_registra_jaql977a(pn_pgcod  => pn_pgcod,
                                                         pn_hcmod  => pn_hcmod,
                                                         pn_hsucor => pn_hsucor,
                                                         pn_htran  => pn_htran,
                                                         pn_hnrel  => 0,
                                                         pd_fecpro => pd_fecpro,
                                                         pc_uing   => :new.z0e478uau,
                                                         pc_hora   => pc_hora,
                                                         pc_cont   => 'S',
                                                         pn_corr   => 0,
                                                         pn_pais   => :old.z0e478thp,
                                                         pn_tipo   => :old.z0e478tht,
                                                         pc_numero => :old.z0e478thd,
                                                         pc_valant => lc_z0e463dscant,
                                                         pc_valact => trim(:new.Z0E478NRO)||lc_z0e463dscact
                                                         );
       End If;
  End IF;
  
  If :new.z0e463cod in (5,8,9) Then
     lc_valido := PQ_AH_CAMPANA_ROJINEGRA.fn_ah_valida_tarjeta(:new.z0e478nro);
     If lc_valido = 'S' Then

          begin
            -- Call the procedure
            pq_ah_campana_rojinegra.sp_ah_reg_bloque_tar(p_d_fecact => :new.z0e478fau,
                                                         p_n_codpai => :new.z0e478thp,
                                                         p_n_codtpd => :new.z0e478tht,
                                                         p_c_numdoc => :new.z0e478thd
                                                         );                                                                                                                 
          end;
     End If;
  End If;
Exception
When others then
    null;
END TG_UPD_Z0E478;
/

