create or replace function sp_cr_tipo_sbs(pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number,pn_gru in number,pn_rub in number) return char is
lc_tip char(30);
begin
  
  if pn_gru = 0 then
        begin
                 select (case  when a.n_codcont_bcgpo = 2 then 'MICROEMPRESAS'
                         when a.n_codcont_bcgpo = 3 and substr(a.n_rubr_bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
                         when a.n_codcont_bcgpo = 3 and substr(a.n_rubr_bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
                         when a.n_codcont_bcgpo = 4 then 'HIPOTECARIO'
                         when a.n_codcont_bcgpo = 12 then 'MEDIANA EMPRESA'
                         when a.n_codcont_bcgpo = 13 then 'PEQUEÑA EMPRESA'
                         when a.n_codcont_bcgpo in ( 5,6,7,8,9) then 'CORPORATIVO'
                   END ) 
                   into lc_tip
                   
                   from uai_aclpre a 
            where a.n_emp_bcemp = pn_emp
              and a.n_mod_bcmod = pn_mod
              and a.n_suc_bcsuc = pn_suc
              and a.n_mda_bcmda =pn_mda
              and a.n_pap_bcpap = pn_pap
              and a.n_cta_bccta = pn_cta
              and a.n_oper_bcoper = pn_oper
              and a.n_sbop_bcsbop =pn_sbop
              and a.n_tope_bctop =pn_top;
        end;
  else
        case  when pn_gru = 2 then lc_tip := 'MICROEMPRESAS';
               when pn_gru = 3 and substr(pn_rub,11,3)='015' then lc_tip :='CONSUMO REVOLVENTE';
               when pn_gru = 3 and substr(pn_rub,11,3)<>'015' then lc_tip :='CONSUMO NO REVOLVENTE';
               when pn_gru = 4 then lc_tip :='HIPOTECARIO';
               when pn_gru = 12 then lc_tip :='MEDIANA EMPRESA';
               when pn_gru = 13 then lc_tip :='PEQUEÑA EMPRESA';
               when pn_gru in ( 5,6,7,8,9) then lc_tip :='CORPORATIVO';
                   END case;
  end if;
  
  return lc_tip;
end sp_cr_tipo_sbs;
/

