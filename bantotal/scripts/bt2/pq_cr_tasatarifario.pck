create or replace package PQ_CR_TASATARIFARIO is

  -- Author  : ABERNEDO
  -- Created : 25/07/2017 06:35:23 p.m.
  -- Purpose : 
  
  -- Public type declarations
  Procedure Sp_cr_Inicio(pn_ins in number,
                       pd_fecpro in date,
                       pn_tasa out number);
end PQ_CR_TASATARIFARIO;
/

create or replace package body PQ_CR_TASATARIFARIO is

  -- Private type declarations
Procedure Sp_cr_Inicio(pn_ins in number,
                       pd_fecpro in date,
                       pn_tasa out number)is
ln_emp  number(3);
ln_mod  number(3);
ln_suc  number(3);
ln_mda  number(4);
ln_pap  number(4);
ln_cta  number(9);
ln_ope  number(9);
ln_sbo  number(3);
ln_top  number(3);
ln_mto  number(17,2);
ln_pzo  number(5);
ln_defn number(17,2);
ln_cont number(5) := 0;
ln_tas  number(10,6);
ln_mtt  number(17,2);
ln_fde  date;
ln_tat  number(7,4);
ln_cont2 number(5) := 0;
ln_tvmpo number(7,4);
ln_porc  number(4) := 100;

cursor tasa(cn_defn in number,
            cn_mod in number,
            cn_mda in number,
            cn_pap in number,
            cn_mto in number,
            cn_pzo in number,
            cf_fec in date) is
select *
  from fsr025 a
 where a.pgcod  =  1
   and a.tpizar =  cn_defn
   and a.tamod  =  cn_mod
   and a.tamda  =  cn_mda
   and a.tapap  =  cn_pap
   and a.tamto  >= cn_mto
   and a.tapzo  >= cn_pzo 
   and a.tafdes <= cf_fec
   and a.tafdes  = (select max(aa.tafdes)
                      from fsr025 aa
                     where aa.pgcod  =  1
                       and aa.tpizar =  cn_defn
                       and aa.tamod  =  cn_mod
                       and aa.tamda  =  cn_mda
                       and aa.tapap  =  cn_pap
                       --and aa.tamto  >= cn_mto
                       --and aa.tapzo  >= cn_pzo 
                       and aa.tafdes <= cf_fec
                       );
cursor region (cn_sucR in number)is
select *
  from fst811 a
 where a.pgcod  =  1
   and a.regcod >= 100
   and a.oficod =  cn_sucR;
   
   
cursor tasa_esp(cn_modE in number,
                cn_defE in number,
                cn_papE in number,
                cn_mdaE in number,
                cn_mtoE in number,
                cn_regE in number,
                cd_fecE in date
                ) is   
                
select *
  from fsd527 a
 where a.pgcod  = 1
   and a.tamod  = cn_modE
   and a.tpizar = cn_defE
   and a.tapap  = cn_papE
   and a.tamda  = cn_mdaE
   and a.tvfmon = cn_mtoE
   and a.tvsuc  = cn_regE
   and a.tvfdes <=cd_fecE;
                
begin
     begin
         select a.xwfempresa,
                a.xwfmodulo,
                a.xwfsucursal,
                a.xwfmoneda,
                a.xwfpapel,
                a.xwfcuenta,
                a.xwfoperacion,
                a.xwfsubope,
                a.xwftipope,
                a.xwfmonto1,
                a.xwfplazo1
           into ln_emp,
                ln_mod,
                ln_suc,
                ln_mda,
                ln_pap,
                ln_cta,
                ln_ope,
                ln_sbo,
                ln_top,
                ln_mto,
                ln_pzo
           from xwf700 a
          where a.xwfprcins = pn_ins
            and a.xwfcar3   = '1';
     exception
       when others then null;
     end;
     
     --obtiene pizarra
     begin
         select Pp028DefN
           into ln_defn
           from fpp028 
          where Pp010Prd = 1
            and Pp017Par = 17
            and Pp028Mod = ln_mod
            and Pp028Mda = ln_mda
            and Pp028Pap = ln_pap
            and Pp028Top = ln_top;
     exception
       when others then null;
     end;
     
     for i in tasa (ln_defn,
                    ln_mod,
                    ln_mda,
                    ln_pap,
                    ln_mto,
                    ln_pzo,
                    pd_fecpro
                    )loop
                    
         ln_tas  := i.Tatasa;
         ln_mtt  := i.Tamto;
         ln_fde  := i.Tafdes;
         ln_tat  := i.Tatol;
         ln_cont := ln_cont + 1;
         
         if ln_cont > 0 then
            exit;
         end if;
         
     end loop;
     
     for j in region(ln_suc) loop
         for k in tasa_esp(ln_mod,
                           ln_defn,
                           ln_pap,
                           ln_mda,
                           ln_mtt,--MOD@ABR 20171018
                           j.regcod,
                           pd_fecpro)loop
         
         ln_tvmpo := k.TvMPorc - ln_porc;
         ln_cont2 := ln_cont2 + 1;
         
         if ln_cont2 > 0 then
            exit;
         end if;
         
         end loop;
     end loop;
     
     pn_tasa := nvl(ln_tas,0)+nvl(ln_tvmpo,0);
     
end Sp_cr_Inicio; 

end PQ_CR_TASATARIFARIO;
/

