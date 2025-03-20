create or replace package PQ_CR_VENTA_LUREN is

  -- Author  : ABERNEDO
  -- Created : 21/07/2015 05:40:34 p.m.
  -- Purpose : 
  
  Procedure Sp_Venta(P_C_DIGITO in varchar2);
  Procedure Sp_PreVenta(pn_nro in number);
  procedure sp_cr_venta_job(pn_gru IN number);
  Procedure Sp_Venta_II(pn_nro in number);
  Procedure Sp_cr_desem (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,ld_fecdes out date, ln_aoimp out number);
  Procedure Sp_cr_CredIni (/*pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                         pn_pap in number,*/pn_cta in number,pn_ope in number/*,pn_sbo in number,
                         pn_top in number*/,ln_empC out number,ln_modC out number,ln_sucC out number,
                         ln_mdaC out number,ln_papC out number,ln_ctaC out number,ln_opeC out number,
                         ln_sboC out number,ln_topC out number);
  Function Fn_cr_fecult (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,pn_cti in number,pn_opi in number) return date ;
  function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return number;
  Procedure Sp_cr_Direcciones (pn_pai in number,pn_tdo in number,pc_doc in char,pn_tip in number,
                             pc_dir out char,pv_ref out varchar2,pc_dis out char);                                                                                                    
  function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pn_cta in number) 
                                return varchar2;
  function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char ;
  function fn_categoria (pn_emp in number, pn_cta in number, pn_codcat in number ) 
                      return char;     
  function fn_provisiones (pn_emp in number,pn_mod in number,pn_mda in number,pn_pap in number,
                         pn_cta in number,pn_ope in number,pn_sbo in number,pn_top in number) 
                      return number ;
  function fn_refinanciado (pn_cta in number, pn_oper in number) return char;
  Procedure Sp_cr_fsd010(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,ld_aofvto out date, ln_aostat out number,
                       ld_aofvalJ out date,ld_aofvalC out date);                                                                       
  Procedure Sp_cr_Avales (pn_ins in number,pn_num out number, pn_pai out number,
                        pn_tdo out number,pc_doc out char,pc_nom out char,
                        pc_tel out char);
  function fn_tipSBS (/*pd_fecpro in date,pn_emp in number,pn_mod in number,pn_suc in number,
                    pn_mda in number,pn_pap in number,*/pn_cta in number,pn_ope in number/*,
                    pn_sbo in number,pn_top in number*/) return char;
  Function Fn_cr_GarantiaTipo (pn_mod in number,pn_top in number) return char ;
  Function Fn_Garantia_mto (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                         pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                         pn_top in number)return number;
  function fn_correlativo (pn_prop in number) return number ;                                                                    
  function fn_correlativo_II (pn_prop in number) return number;
  function fn_fechafin (pd_fecha in date) return date;
  function fn_cl_telefonos(lv_pepais in number,lv_petdoc in number,lv_pendoc in char,pn_tip in number)
   return varchar2;
  Procedure Sp_Garantias (pn_nro in number,pn_emp in number, pn_mod in number, pn_suc in number,
                        pn_mda in number,pn_pap in number, pn_cta in number, pn_ope in number,
                        pn_sbo in number,pn_top in number);
  --Procedure Sp_fechaUltimoPag(pn_cta in number,pn_ope in number,pd_fec out date);
  Procedure Sp_jaql124(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                     pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                     pn_top in number,ld_fju out date,ld_fca out date,lc_ref out varchar2,
                     ld_fup out date,ln_cpa out number,ld_fde out date,ln_mde out number,
                     lc_cal out varchar2,ln_ppv out number,lc_dir out varchar2);                        
end PQ_CR_VENTA_LUREN;
/

create or replace package body PQ_CR_VENTA_LUREN is

Procedure Sp_PreVenta(pn_nro in number) is
begin

  execute immediate('truncate table jaqz064_aux');
  begin
  insert into jaqz064_aux(JAQY952NRO,
                          JAQY953EMP,
                          JAQY953MOD,
                          JAQY953SUC,
                          JAQY953MDA,
                          JAQY953PAP,
                          JAQY953CTA,
                          JAQY953OPE,
                          JAQY953SBO,
                          JAQY953TOP,
                          PEPAIS    ,
                          PETDOC    ,
                          PENDOC    ,
                          JAQY953CAV,
                          JAQY953INV,
                          JAQY953MOV,
                          JAQY953OTV,
                          TELLEG    ,
                          TELGES    ,
                          INSTANCIA ,
                          TIPCRE    ,
                          TOTDEU    ,
                          JAQY953FEV,
                          JAQY952GRU,
                          TITULAR   )
  
     select  /*+all_rows */
               a.jaqy952nro,
               a.jaqy953emp,
               a.jaqy953mod,
               a.jaqy953suc,
               a.jaqy953mda,
               a.jaqy953pap,
               a.jaqy953cta,
               a.jaqy953ope,
               a.jaqy953sbo,
               a.jaqy953top,
               b.pepais,
               b.petdoc,
               b.pendoc,
               a.jaqy953cav,
               a.jaqy953inv,
               a.jaqy953mov,
               a.jaqy953otv,
          
               PQ_CR_VENTA_LUREN.fn_cl_telefonos(b.pepais,b.petdoc,b.pendoc,1)telLeg,
               PQ_CR_VENTA_LUREN.fn_cl_telefonos(b.pepais,b.petdoc,b.pendoc,6)telGes,
            
               fn_instancia_credito(a.jaqy953mod,a.jaqy953suc,a.jaqy953mda,a.jaqy953pap,a.jaqy953cta,
                                    a.jaqy953ope,a.jaqy953sbo,a.jaqy953top)instancia,
               case when a.jaqy953mod = 200 then 'JUDICIAL'
                    when a.jaqy953mod = 33  then 'CASTIGADO'
                    else null
               end tipcre,
               (a.jaqy953cav+a.jaqy953inv+a.jaqy953mov+a.jaqy953otv)totdeu,
               --a.jaqy953fev,
               g.jaqy952fev,
               g.jaqy952gru,
               (select penom from fsd001 T where t.pepais =b.pepais and t.petdoc =b.petdoc 
                                        and t.pendoc = b.pendoc)titular           
          
               
          from jaqy953 a, /*bantprod.*/fsr008 b,  jaqy952 g
         where g.jaqy952gru = pn_nro
           and a.jaqy953vig = 'S'
           and a.jaqy953itc = 'S'
           and a.jaqy952nro = g.jaqy952nro
           and g.jaqy952est = 'V'
           and a.jaqy953cta = b.ctnro
           and b.pgcod = 1
           and b.cttfir = 'T';
           
           
           commit;
  end;
end Sp_PreVenta;

procedure sp_cr_venta_job(pn_gru IN number) is

     cursor c_clientes_job is 
      select to_char(substr(trim(j.jaqy953cta), -1, 1)) digito
          from JAQZ064_aux j
         where j.jaqy952gru  = pn_gru
         group by to_char(substr(trim(j.jaqy953cta), -1, 1));

     --lc_fecpro varchar2(10);
     lc_variable   varchar2(4000);
     ln_job        number:= 0;
     lc_hostname varchar2(64);
     --l_jaqy066pano  jaqy066.jaqy066pano%type;
     --l_jaqy066pmes  jaqy066.jaqy066pmes%type;
     ln_cont number(2):=0;
     ln_inst number(1):=1;
  BEGIN
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;

     --execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
     --lc_fecpro := to_char(P_D_FECPRO,'RRRR.MM.DD');  
     --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
     --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
         
    
  
     for job in c_clientes_job loop
         lc_variable := ' begin '||
              ' PQ_CR_VENTA_LUREN.Sp_Venta('''||job.digito||''');'||
                                                                  ' End; ';
              ln_cont := ln_cont +1;
              
              if(ln_cont>=50) then
                  ln_inst:=2;    
              end if;        
                                                            
              ln_job := ln_job +1;
              
--              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
              
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then   
      IF SYS.FN_BD_ISRAC='TRUE' THEN
              DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      instance => ln_inst,
                      --instance => 1,--Solo por hoy 01.07.2015 hmev
                      force => false
                      );
else
                DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*60),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        commit;

     end loop;

end sp_cr_venta_job;



Procedure Sp_Venta(P_C_DIGITO in varchar2) is

cursor creditos is
select * 
  from jaqz064_aux a 
 where to_char(substr(trim(a.jaqy953cta), -1, 1)) = P_C_DIGITO;

ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);           
lc_dirLeg char(140);
lv_refLeg varchar2(140);
lc_disLeg char(30);
lc_dirGes char(140);
lv_refGes varchar2(140);
lc_disGes char(30);
lc_dirNeg char(140);
lv_refNeg varchar2(140);
lc_disNeg char(30);
lv_sbs varchar2(10);           
lc_actividad char(60);
lc_categoria char(15);
fec_des date;
ln_aoimp number(17,2);
ln_provision number(14,8);
lc_refinan char(1);
ld_fecul date;
ln_dia number(5);
ld_vto date;
ld_fvalJ date;
ld_fvalC date;
ln_stat number(2);
ln_cuotas number(5);
ln_numaval number(4);
ln_paiaval number(3);
ln_tipaval number(2);
lc_docaval char(12);
lc_nomaval char(30);
lc_dirLegAv char(140);
lv_refLegAv varchar2(140);
lc_disLegAv char(30);
lc_telaval char(20);
lc_tipSBS char(30);   
ld_fecSBS date;  
ln_correlativo number(30);
lc_coderr varchar2(300); 


ld_fju date;
ld_fca date;
lc_ref varchar2(1);
ld_fup date;
ln_cpa number(4);
ld_fde date;
ln_mde number(18,2);
lc_cal varchar2(50);
ln_ppv number(3);
lc_dir varchar2(100);

  begin
  
  
  
        --execute immediate ('truncate table JAQZ064');
   
        ln_correlativo := 0;
  BEGIN
  For i in creditos loop  
    ln_emp := null;
    ln_mod := null;
    ln_suc := null;
    ln_mda := null;
    ln_pap := null;
    ln_cta := null;
    ln_ope := null;
    ln_sbo := null;
    ln_top := null;           
    lc_dirLeg := null;
    lv_refLeg := null;
    lc_disLeg := null;
    lc_dirGes := null;
    lv_refGes := null;
    lc_disGes := null;
    lc_dirNeg := null;
    lv_refNeg := null;
    lc_disNeg := null;
    lv_sbs := null;           
    lc_actividad := null;
    lc_categoria := null;
    fec_des := null;
    ln_aoimp := null;
    ln_provision := null;
    lc_refinan := null;
    ld_fecul := null;
    ln_dia := null;
    ld_vto := null;
    ld_fvalC:= null;
    ld_fvalJ:= null;
    ln_stat:= null;
    ln_cuotas := null;
    ln_numaval:= null;
    ln_paiaval:=null;
    ln_tipaval:=null;
    lc_docaval:=null;
    lc_nomaval:=null;
    lc_dirLegAv := null;
    lv_refLegAv := null;
    lc_disLegAv := null;
    lc_telaval := null;
    lc_tipSBS := null;
    ld_fecSBS := null;
    lc_coderr := null;
        begin
        ln_emp:=null;
        ln_mod:=null;
        ln_suc:=null;
        ln_mda:=null;
        ln_pap:=null;
        ln_cta:=null;
        ln_ope:=null;
        ln_sbo:=null;
        ln_top:=null;
        
        --pq_cr_venta.sp_cr_credini(i.jaqy953cta,i.jaqy953ope,ln_emp,ln_mod,
        --                          ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo,ln_top);     
        --direccion legal
        PQ_CR_VENTA_LUREN.Sp_cr_Direcciones(i.pepais,i.petdoc,i.pendoc,1,lc_dirLeg,lv_refLeg,lc_disLeg);
        
        --tabla luren
        PQ_CR_VENTA_LUREN.sp_jaql124(i.jaqy953emp,i.jaqy953mod,i.jaqy953suc,i.jaqy953mda,i.jaqy953pap,
                                 i.jaqy953cta,i.jaqy953ope,i.jaqy953sbo,i.jaqy953top,ld_fju,ld_fca,
                                     lc_ref,ld_fup,ln_cpa,ld_fde,ln_mde,lc_cal,ln_ppv,lc_dir);
        if lc_dirLeg is null then
           lc_dirLeg:=lc_dir;
        end if;
                
        
        --direccion gestion
        PQ_CR_VENTA_LUREN.Sp_cr_Direcciones(i.pepais,i.petdoc,i.pendoc,6,lc_dirGes,lv_refGes,lc_disGes);        
        --direccion negocio
        PQ_CR_VENTA_LUREN.Sp_cr_Direcciones(i.pepais,i.petdoc,i.pendoc,3,lc_dirNeg,lv_refNeg,lc_disNeg);
        --actividad
        lc_actividad := PQ_CR_VENTA_LUREN.fn_actividad(i.pepais,i.petdoc,i.pendoc);
        --codigo sbs
        lv_sbs := PQ_CR_VENTA_LUREN.fn_codsbs(i.pepais,i.petdoc,i.pendoc,i.jaqy953cta);
        --categoria sbs
        --lc_categoria := pq_cr_venta.fn_categoria(i.jaqy953emp,i.jaqy953cta,9);
        lc_categoria := lc_cal;
        --fecha y monto de desembolso
        --pq_cr_venta.sp_cr_desem(ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo,ln_top,
        --                        fec_des,ln_aoimp);
        
        fec_des  := ld_fde;
        ln_aoimp := ln_mde;
        --provisiones
        --ln_provision := 100.00000000;--pq_cr_venta.fn_provisiones(i.jaqy953emp,i.jaqy953mod,i.jaqy953mda,i.jaqy953pap,
                                --i.jaqy953cta,i.jaqy953ope,i.jaqy953sbo,i.jaqy953top);
        ln_provision := ln_ppv;
        --refinanciado
        --lc_refinan := pq_cr_venta.fn_refinanciado(i.jaqy953cta,i.jaqy953ope);     
        lc_refinan := lc_ref;
        --fecha de ultimo pago
        --pq_cr_venta.Sp_fechaUltimoPag(i.jaqy953cta,i.jaqy953ope,ld_fecul);
        ld_fecul := ld_fup;
        --pq_cr_venta.Fn_cr_fecult(ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,
        --                                    ln_sbo,ln_top,i.jaqy953cta,i.jaqy953ope);
        --fecha de vcto, fecha ingreso a Judicial/castigo, estado
        pq_cr_venta_luren.Sp_cr_fsd010(i.jaqy953emp,i.jaqy953mod,i.jaqy953suc,i.jaqy953mda,i.jaqy953pap,
                                 i.jaqy953cta,i.jaqy953ope,i.jaqy953sbo,i.jaqy953top,ld_vto,ln_stat,
                                 ld_fvalJ,ld_fvalC);
        ld_fvalJ := ld_fju;
        ld_fvalC := ld_fca;
        
        --dias de atraso
        ln_dia := /*bantprod.*/fn_dias_atraso(trunc(sysdate),i.jaqy953emp,i.jaqy953mod,i.jaqy953suc,i.jaqy953mda,i.jaqy953pap,
                                 i.jaqy953cta,i.jaqy953ope,i.jaqy953sbo,i.jaqy953top,ln_stat,ld_vto);
        --cuotas pagadas
        --ln_cuotas := pq_cr_venta.fn_cuotas_pagadas(ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,
        --                                    ln_sbo,ln_top);
        ln_cuotas :=ln_cpa;
        
        --numero de avales, aval
        PQ_CR_VENTA_LUREN.Sp_cr_Avales(i.instancia,ln_numaval,ln_paiaval,ln_tipaval,lc_docaval,lc_nomaval,
                                 lc_telaval);
        --direccion legal aval
        PQ_CR_VENTA_LUREN.Sp_cr_Direcciones(ln_paiaval,ln_tipaval,lc_docaval,1,lc_dirLegAv,lv_refLegAv,lc_disLegAv); 

        --tipo SBS
        ld_fecSBS := i.jaqy953fev - 1;
         
        lc_tipSBS := PQ_CR_VENTA_LUREN.fn_tipSBS(/*ld_fecSBS,i.jaqy953emp,i.jaqy953mod,i.jaqy953suc,i.jaqy953mda,i.jaqy953pap,
                                 */i.jaqy953cta,i.jaqy953ope/*,i.jaqy953sbo,i.jaqy953top*/);
        --correlativo
        ln_correlativo := PQ_CR_VENTA_LUREN.fn_correlativo(i.jaqy952nro);
    insert into jaqz064 (JAQZ064NRO,JAQZ064PGC,JAQZ064MOD,JAQZ064SUC,JAQZ064MDA,JAQZ064PAP,
                             JAQZ064CTA,JAQZ064OPE,JAQZ064SBO,JAQZ064TOP,JAQZ064PAI,JAQZ064TDO,
                             JAQZ064NDO,JAQZ064CAP,JAQZ064MOR,JAQZ064INT,JAQZ064GAS,Jaqz064dil,
                             Jaqz064tel,JAQZ064FED,JAQZ064INS,Jaqz064pgi,Jaqz064moi,Jaqz064sui,
                             Jaqz064mdi,Jaqz064ppi,Jaqz064cti,Jaqz064opi,Jaqz064sbi,Jaqz064toi,
                             Jaqz064rel,Jaqz064teg,Jaqz064dsl,Jaqz064dsg,Jaqz064dsn,Jaqz064dig,
                             Jaqz064reg,Jaqz064din,Jaqz064act,Jaqz064sbs,Jaqz064cal,Jaqz064aoi,
                             Jaqz064pro,Jaqz064tic,Jaqz064tod,Jaqz064ref,Jaqz064ful,Jaqz064fij,
                             Jaqz064fic,Jaqz064dia,Jaqz064cuo,Jaqz064nav,Jaqz064paa,Jaqz064tda,
                             Jaqz064nda,Jaqz064noa,Jaqz064dra,Jaqz064rea,Jaqz064dsa,Jaqz064tea,
                             Jaqz064tsb,Jaqz064cor,Jaqz064gru,jaqz064tit)
        values(i.jaqy952nro,i.jaqy953emp,i.jaqy953mod,i.jaqy953suc,i.jaqy953mda,i.jaqy953pap,
               i.jaqy953cta,i.jaqy953ope,i.jaqy953sbo,i.jaqy953top,i.pepais,i.petdoc,i.pendoc,
               i.jaqy953cav,i.jaqy953inv,i.jaqy953mov,i.jaqy953otv,lc_dirLeg,i.telLeg,fec_des,
               i.instancia,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo,ln_top,lv_refLeg,
               i.telGes,lc_disLeg,lc_disGes,lc_disNeg,lc_dirGes,lv_refGes,lc_dirNeg,lc_actividad,
               lv_sbs,lc_categoria,ln_aoimp,ln_provision,i.tipcre,i.totdeu,lc_refinan,ld_fecul,
               ld_fvalJ,ld_fvalC,ln_dia,ln_cuotas,ln_numaval,ln_paiaval,ln_tipaval,lc_docaval,
               lc_nomaval,lc_dirLegAv,lv_refLegAv,lc_disLegAv,lc_telaval,lc_tipSBS,ln_correlativo,
               i.jaqy952gru,I.TITULAR);
        
           commit;
           
        exception 
           when others then
                lc_coderr:=sqlerrm;
                
                insert into jaqz064_error(jaqz064dig,
                                          jaqz064cta,
                                          jaqz064ope,
                                          jaqz064err)
                values(P_C_DIGITO,i.jaqy953cta,i.jaqy953ope,lc_coderr);
                commit;
                
                --dbms_output.put_line(i.jaqy952nro||'-'||i.jaqy953cta||'-'||i.jaqy953ope||lc_coderr);
           
        
        
        end;
  end loop;
  commit;
  END;
    
  --pq_cr_venta.Sp_Venta_II;
  
end Sp_Venta;

Procedure Sp_Venta_II(pn_nro in number) is

cursor creditos is
select * from jaqz064 a
where a.jaqz064gru = pn_nro;

lc_coderr varchar2(300); 

  begin

  BEGIN
  For i in creditos loop  
    
    lc_coderr := null;
        begin
       PQ_CR_VENTA_LUREN.sp_garantias(i.JAQZ064NRO,i.JAQZ064PGC,i.JAQZ064MOD,i.JAQZ064SUC,i.JAQZ064MDA,i.JAQZ064PAP,
               i.JAQZ064CTA,i.JAQZ064OPE,i.JAQZ064SBO,i.JAQZ064TOP);
        
      
        exception 
           when others then
                lc_coderr:=sqlerrm;
                dbms_output.put_line(i.JAQZ064NRO||'-'||i.JAQZ064CTA||'-'||i.JAQZ064OPE||lc_coderr);
           
        
        
        end;
     COMMIT;   
  end loop;
    COMMIT;
  END;
  

end Sp_Venta_II;


Procedure Sp_cr_desem (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,ld_fecdes out date, ln_aoimp out number)is
ln_sboR1 number(3);
ln_sboR2 number(3);
ln_sboMax number(3);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);

begin
      ln_sboMax := null; 
      begin
      
      
                  select a.aofval,a.aoimp
                    into ld_fecdes,ln_aoimp
                    from /*bantprod.*/FSD010 a
                   where a.aomod  = pn_mod
                     and a.aocta  = pn_cta
                     and a.aooper = pn_ope
                     and a.aosbop = pn_sbo
                     and a.pgcod  = pn_emp
                     and a.aosuc  = pn_suc
                     and a.aomda  = pn_mda
                     and a.aopap  = pn_pap
                     and a.aotope = pn_top
                     and rownum = 1;
                     
             exception when others then
                 ld_fecdes := null;
   
  
             
      end;
      
      begin 
        select max(a.r1sbop)
          into ln_sboR1
          from fsr011 a
         where relcod   = 120
           and r1cta    = pn_cta
           and a.r1oper = pn_ope;
        exception
           when no_data_found then
                ln_sboR1 := null;
        end;
      
      begin 
        select max(a.r2sbop)
          into ln_sboR2
          from fsr011 a
         where relcod   = 120
           and r2cta    = pn_cta
           and a.r2oper = pn_ope;
        exception
           when no_data_found then
                ln_sboR2 := null;
        
      end;
      
      if ln_sboR1 is not null and ln_sboR2 is not null then
        if ln_sboR1 = ln_sboR2 then
           ln_sboMax :=ln_sboR1;
           begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_emp,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbo,
                   ln_top
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_emp := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := null;
            end;
        end if;
        
        if ln_sboR1 > ln_sboR2 then
           ln_sboMax :=ln_sboR1;
           begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_emp,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbo,
                   ln_top
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_emp := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := null;
            end;
           Else
               ln_sboMax :=ln_sboR2;
               begin 
                select a.r2cod,
                       a.r2mod,
                       a.r2suc,
                       a.r2mda,
                       a.r2pap,
                       a.r2cta,
                       a.r2oper,
                       a.r2sbop,
                       a.r2tope
                  into ln_emp,
                       ln_mod,
                       ln_suc,
                       ln_mda,
                       ln_pap,
                       ln_cta,
                       ln_ope,
                       ln_sbo,
                       ln_top
                  from fsr011 a
                 where relcod   = 120
                   and r2cta    = pn_cta
                   and a.r2oper = pn_ope
                   and a.r2sbop = ln_sboMax
                   and r2mod not in (200,33,65)
               and a.r2tope<>550
                   and rownum = 1;
                exception
                   when no_data_found then
                        ln_emp := null;
                        ln_mod := null;
                        ln_suc := null;
                        ln_mda := null;
                        ln_pap := null;
                        ln_cta := null;
                        ln_ope := null;
                        ln_sbo := null;
                        ln_top := null;
                end;
        end if;
      end if;
      
      if ln_sboR1 is null and ln_sboR2 is not null then 
         ln_sboMax :=ln_sboR2;
         begin 
            select a.r2cod,
                   a.r2mod,
                   a.r2suc,
                   a.r2mda,
                   a.r2pap,
                   a.r2cta,
                   a.r2oper,
                   a.r2sbop,
                   a.r2tope
              into ln_emp,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbo,
                   ln_top
              from fsr011 a
             where relcod   = 120
               and r2cta    = pn_cta
               and a.r2oper = pn_ope
               and a.r2sbop = ln_sboMax
               and r2mod not in (200,33,65)
               and a.r2tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_emp := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := null;
            end;
      end if;
      
      if ln_sboR1 is not null and ln_sboR2 is null then 
         ln_sboMax :=ln_sboR1;
         begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_emp,
                   ln_mod,
                   ln_suc,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbo,
                   ln_top
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_emp := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := null;
            end;
      end if;
      
      if ln_sboMax is not null then
         begin
      
          
                      select a.aofval,a.aoimp
                        into ld_fecdes,ln_aoimp
                        from /*bantprod.*/FSD010 a
                       where a.aomod  = ln_mod
                         and a.aocta  = ln_cta
                         and a.aooper = ln_ope
                         and a.aosbop = ln_sbo
                         and a.pgcod  = ln_emp
                         and a.aosuc  = ln_suc
                         and a.aomda  = ln_mda
                         and a.aopap  = ln_pap
                         and a.aotope = ln_top
                         and rownum = 1;
                         
                 exception when others then
                     ld_fecdes := null;
       
      
                 
          end;
      end if;
      
      
end Sp_cr_desem;     


Procedure Sp_cr_CredIni (/*pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                         pn_pap in number,*/pn_cta in number,pn_ope in number/*,pn_sbo in number,
                         pn_top in number*/,ln_empC out number,ln_modC out number,ln_sucC out number,
                         ln_mdaC out number,ln_papC out number,ln_ctaC out number,ln_opeC out number,
                         ln_sboC out number,ln_topC out number)is
ln_sboR1 number(3);
ln_sboR2 number(3);
ln_sboMax number(3);
/*ln_emp number;
ln_mod number;
ln_suc number;
ln_mda number;
ln_pap number;
ln_cta number;
ln_ope number;
ln_sbo number;
ln_top number;
ln_empA number;
ln_modA number;
ln_sucA number;
ln_mdaA number;
ln_papA number;
ln_ctaA number;
ln_opeA number;
ln_sboA number;
ln_topA number;*/


begin
       
      begin
      
        select a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope
          into ln_empC,
               ln_modC,
               ln_sucC,
               ln_mdaC,
               ln_papC,
               ln_ctaC,
               ln_opeC,
               ln_sboC,
               ln_topC
          from fsd010 a
         where a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aomod in (select modulo from fst111 where dscod = 50)
           and a.aosbop = (select min(aa.aosbop)
                            from fsd010 aa
                           where aa.aocta  = a.aocta 
                             and aa.aooper = a.aooper
                             and aa.aomod in (select modulo from fst111 where dscod = 50))
           and a.aofval = (select min(aa.aofval)
                            from fsd010 aa
                           where aa.aocta  = a.aocta 
                             and aa.aooper = a.aooper
                             and aa.aomod in (select modulo from fst111 where dscod = 50))
           and aomod not in(200,33,65) and aotope <> 550
           and rownum = 1;
                             
      exception
          when no_data_found then
               ln_empC := null;
               ln_modC := null;
               ln_sucC := null;
               ln_mdaC := null;
               ln_papC := null;
               ln_ctaC := null;
               ln_opeC := null;
               ln_sboC := null;
               ln_topC := null;
         /* if pn_mod = 33 then
             begin
             
                  select a.r1cod,a.r1mod,a.r1suc,a.r1mda,a.r1pap,a.r1cta,a.r1oper,a.r1sbop,a.r1tope
                    into ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo,ln_top
                    from \*bantprod.*\fsr011 a
                   where a.r2mod  = pn_mod
                     and a.r2cta  = pn_cta
                     and a.r2oper = pn_ope
                     and a.r2sbop = pn_sbo
                     and a.r2cod  = pn_emp
                     and a.r2suc  = pn_suc
                     and a.r2mda  = pn_mda
                     and a.r2pap  = pn_pap
                     and a.r2tope = pn_top
                     and a.relcod = 33
                     and rownum = 1;
                     
             exception when others then
                 ln_emp := null;
                 ln_mod := null;
                 ln_suc := null;
                 ln_mda := null;
                 ln_pap := null;
                 ln_cta := null;
                 ln_ope := null;
                 ln_sbo := null;
                 ln_top := null;
             end;
             
             begin
             
                  select a.r1cod,a.r1mod,a.r1suc,a.r1mda,a.r1pap,a.r1cta,a.r1oper,a.r1sbop,a.r1tope
                    into ln_empC,ln_modC,ln_sucC,ln_mdaC,ln_papC,ln_ctaC,ln_opeC,ln_sboC,ln_topC
                    from \*bantprod.*\fsr011 a
                   where a.r2mod  = ln_mod
                     and a.r2cta  = ln_cta
                     and a.r2oper = ln_ope
                     -- a.r2sbop = ln_sbo
                     and a.r2cod  = ln_emp
                     and a.r2suc  = ln_suc
                     and a.r2mda  = ln_mda
                     and a.r2pap  = ln_pap
                     --and a.r2tope = ln_top
                     and a.relcod = 34
                     and rownum = 1;
                     
             exception when others then
                 ln_empC := null;
                 ln_modC := null;
                 ln_sucC := null;
                 ln_mdaC := null;
                 ln_papC := null;
                 ln_ctaC := null;
                 ln_opeC := null;
                 ln_sboC := null;
                 ln_topC := null;
             end;
             
      
         end if;
         
         
         
         if pn_mod = 200 then
             begin
             
                  select a.r1cod,a.r1mod,a.r1suc,a.r1mda,a.r1pap,a.r1cta,a.r1oper,a.r1sbop,a.r1tope
                    into ln_empC,ln_modC,ln_sucC,ln_mdaC,ln_papC,ln_ctaC,ln_opeC,ln_sboC,ln_topC
                    from \*bantprod.*\fsr011 a
                   where a.r2mod  = pn_mod
                     and a.r2cta  = pn_cta
                     and a.r2oper = pn_ope
                     and a.r2sbop = pn_sbo
                     and a.r2cod  = pn_emp
                     and a.r2suc  = pn_suc
                     and a.r2mda  = pn_mda
                     and a.r2pap  = pn_pap
                     and a.r2tope = pn_top
                     and a.relcod = 34
                     and rownum = 1;
                     
             exception when others then
                 ln_empC := null;
                 ln_modC := null;
                 ln_sucC := null;
                 ln_mdaC := null;
                 ln_papC := null;
                 ln_ctaC := null;
                 ln_opeC := null;
                 ln_sboC := null;
                 ln_topC := null;
             end;
             

         end if;
         
         if ln_topC = 550 then
            begin
             
                  select a.r1cod,a.r1mod,a.r1suc,a.r1mda,a.r1pap,a.r1cta,a.r1oper,a.r1sbop,a.r1tope
                    into ln_empA,ln_modA,ln_sucA,ln_mdaA,ln_papA,ln_ctaA,ln_opeA,ln_sboA,ln_topA
                    from \*bantprod.*\fsr011 a
                   where a.r2mod  = ln_modC
                     and a.r2cta  = ln_ctaC
                     and a.r2oper = ln_opeC
                     and a.r2sbop = ln_sboC
                     and a.r2cod  = ln_empC
                     and a.r2suc  = ln_sucC
                     and a.r2mda  = ln_mdaC
                     and a.r2pap  = ln_papC
                     and a.r2tope = ln_topC
                     and a.relcod = 52
                     and rownum = 1;
                     
             exception when others then
                 ln_empA := null;
                 ln_modA := null;
                 ln_sucA := null;
                 ln_mdaA := null;
                 ln_papA := null;
                 ln_ctaA := null;
                 ln_opeA := null;
                 ln_sboA := null;
                 ln_topA := null;
             end;
             
             ln_empC :=ln_empA;
             ln_modC :=ln_modA;
             ln_sucC :=ln_sucA;
             ln_mdaC :=ln_mdaA;
             ln_papC :=ln_papA;
             ln_ctaC :=ln_ctaA;
             ln_opeC :=ln_opeA;
             ln_sboC :=ln_sboA;
             ln_topC :=ln_topA;
             
             
             
         end if;*/
             
      end;
      
      begin 
        select max(a.r1sbop)
          into ln_sboR1
          from fsr011 a
         where relcod   = 120
           and r1cta    = pn_cta
           and a.r1oper = pn_ope;
        exception
           when no_data_found then
                ln_sboR1 := null;
        end;
      
      begin 
        select max(a.r2sbop)
          into ln_sboR2
          from fsr011 a
         where relcod   = 120
           and r2cta    = pn_cta
           and a.r2oper = pn_ope;
        exception
           when no_data_found then
                ln_sboR2 := null;
        
      end;
      
      if ln_sboR1 is not null and ln_sboR2 is not null then
        if ln_sboR1 = ln_sboR2 then
           ln_sboMax :=ln_sboR1;
           begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_empC,
                   ln_modC,
                   ln_sucC,
                   ln_mdaC,
                   ln_papC,
                   ln_ctaC,
                   ln_opeC,
                   ln_sboC,
                   ln_topC
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_empC := null;
                    ln_modC := null;
                    ln_sucC := null;
                    ln_mdaC := null;
                    ln_papC := null;
                    ln_ctaC := null;
                    ln_opeC := null;
                    ln_sboC := null;
                    ln_topC := null;
            end;
        end if;
        
        if ln_sboR1 > ln_sboR2 then
           ln_sboMax :=ln_sboR1;
           begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_empC,
                   ln_modC,
                   ln_sucC,
                   ln_mdaC,
                   ln_papC,
                   ln_ctaC,
                   ln_opeC,
                   ln_sboC,
                   ln_topC
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_empC := null;
                    ln_modC := null;
                    ln_sucC := null;
                    ln_mdaC := null;
                    ln_papC := null;
                    ln_ctaC := null;
                    ln_opeC := null;
                    ln_sboC := null;
                    ln_topC := null;
            end;
           Else
               ln_sboMax :=ln_sboR2;
               begin 
                select a.r2cod,
                       a.r2mod,
                       a.r2suc,
                       a.r2mda,
                       a.r2pap,
                       a.r2cta,
                       a.r2oper,
                       a.r2sbop,
                       a.r2tope
                  into ln_empC,
                       ln_modC,
                       ln_sucC,
                       ln_mdaC,
                       ln_papC,
                       ln_ctaC,
                       ln_opeC,
                       ln_sboC,
                       ln_topC
                  from fsr011 a
                 where relcod   = 120
                   and r2cta    = pn_cta
                   and a.r2oper = pn_ope
                   and a.r2sbop = ln_sboMax
                   and r2mod not in (200,33,65)
               and a.r2tope<>550
                   and rownum = 1;
                exception
                   when no_data_found then
                        ln_empC := null;
                        ln_modC := null;
                        ln_sucC := null;
                        ln_mdaC := null;
                        ln_papC := null;
                        ln_ctaC := null;
                        ln_opeC := null;
                        ln_sboC := null;
                        ln_topC := null;
                end;
        end if;
      end if;
      
      if ln_sboR1 is null and ln_sboR2 is not null then 
         ln_sboMax :=ln_sboR2;
         begin 
            select a.r2cod,
                   a.r2mod,
                   a.r2suc,
                   a.r2mda,
                   a.r2pap,
                   a.r2cta,
                   a.r2oper,
                   a.r2sbop,
                   a.r2tope
              into ln_empC,
                   ln_modC,
                   ln_sucC,
                   ln_mdaC,
                   ln_papC,
                   ln_ctaC,
                   ln_opeC,
                   ln_sboC,
                   ln_topC
              from fsr011 a
             where relcod   = 120
               and r2cta    = pn_cta
               and a.r2oper = pn_ope
               and a.r2sbop = ln_sboMax
               and r2mod not in (200,33,65)
               and a.r2tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_empC := null;
                    ln_modC := null;
                    ln_sucC := null;
                    ln_mdaC := null;
                    ln_papC := null;
                    ln_ctaC := null;
                    ln_opeC := null;
                    ln_sboC := null;
                    ln_topC := null;
            end;
      end if;
      
      if ln_sboR1 is not null and ln_sboR2 is null then 
         ln_sboMax :=ln_sboR1;
         begin 
            select a.r1cod,
                   a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_empC,
                   ln_modC,
                   ln_sucC,
                   ln_mdaC,
                   ln_papC,
                   ln_ctaC,
                   ln_opeC,
                   ln_sboC,
                   ln_topC
              from fsr011 a
             where relcod   = 120
               and r1cta    = pn_cta
               and a.r1oper = pn_ope
               and a.r1sbop = ln_sboMax
               and r1mod not in (200,33,65)
               and a.r1tope<>550
               and rownum = 1;
            exception
               when no_data_found then
                    ln_empC := null;
                    ln_modC := null;
                    ln_sucC := null;
                    ln_mdaC := null;
                    ln_papC := null;
                    ln_ctaC := null;
                    ln_opeC := null;
                    ln_sboC := null;
                    ln_topC := null;
            end;
      end if;
      /*
      if ln_sboMax is not null then
         begin
      
          
                      select a.aofval,a.aoimp
                        into ld_fecdes,ln_aoimp
                        from FSD010 a
                       where a.aomod  = ln_modC
                         and a.aocta  = ln_ctaC
                         and a.aooper = ln_opeC
                         and a.aosbop = ln_sboC
                         and a.pgcod  = ln_empC
                         and a.aosuc  = ln_sucC
                         and a.aomda  = ln_mdaC
                         and a.aopap  = ln_papC
                         and a.aotope = ln_topC
                         and rownum = 1;
                         
                 exception when others then
                     ld_fecdes := null;
       
      
                 
          end;
      end if;*/

end Sp_cr_CredIni;    
      
Function Fn_cr_fecult (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,pn_cti in number,pn_opi in number) return date is
ld_fecupa date;


begin
    begin
    
    select max(h.hfcon)
      into ld_fecupa
              from /*bantprod.*/fsh016 h
             inner join /*bantprod.*/fst198 f
             on h.hcmod = f.tp1corr1
               and h.htran = f.tp1corr2
               and h.hcord = f.tp1corr3
             where h.pgcod = pn_emp
               and h.hcta = pn_cti
               and h.hoper = pn_opi
               and f.tp1cod1=10876
;

    /*
    
      select max(o.pp1fech) 
        into ld_fecupa     
        from fsd602 o
       where o.pgcod   = pn_emp 
         and o.ppmod   = pn_mod 
         and o.ppsuc   = pn_suc  
         and o.ppmda   = pn_mda
         and o.pppap   = pn_pap 
         and o.ppcta   = pn_cta 
         and o.ppoper  = pn_ope
         and o.ppsbop  = pn_sbo
         and o.pptope  = pn_top 
         and o.pp1stat = 'T' 
         and o.d602co  = 'S' ;*/
    exception 
        when no_data_found then 
           ld_fecupa := null;
        when too_many_rows then
           ld_fecupa := null;
    end;   
    
    if ld_fecupa is null then
           begin
    
               
                  select max(o.pp1fech) 
                    into ld_fecupa     
                    from /*bantprod.*/fsd602 o
                   where o.pgcod   = pn_emp 
                     and o.ppmod   = pn_mod 
                     and o.ppsuc   = pn_suc  
                     and o.ppmda   = pn_mda
                     and o.pppap   = pn_pap 
                     and o.ppcta   = pn_cta 
                     and o.ppoper  = pn_ope
                     and o.ppsbop  = pn_sbo
                     and o.pptope  = pn_top 
                     and o.pp1stat = 'T' 
                     and o.d602co  = 'S' ;
                exception 
                    when no_data_found then 
                       ld_fecupa := null;
                    when too_many_rows then
                       ld_fecupa := null;
                end;   
    
    end if;
     return ld_fecupa; 

end Fn_cr_fecult;    

function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return number is
ln_numcuotas number;
begin
  begin
    select /*+ parallel(o,2,1)*/
            sum(count(*))
       into ln_numcuotas
       from /*bantprod.*/fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc
        and o.ppmda   = pn_mda
        and o.pppap   = pn_pap
        and o.ppcta   = pn_cta
        and o.ppoper  = pn_oper
        and o.ppsbop  = pn_sbop
        and o.pptope  = pn_top
        and o.pp1stat = 'T'
        and o.d602co  = 'S'
        and (d602mo,d602tr) not in ( select 300,390 from dual)
        and (d602mo,d602tr) not in ( select 300,406 from dual)
        and (d602mo,d602tr) not in ( select 300,400 from dual)
        --o.d602mo,o.d602tr) not in (300,390) or
        -- and o.d602tr not in (390,406,400))
        and (o.pp1cap+o.pp1int)<>0
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception
      when no_data_found then
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;
  
  begin
  
    if ln_numcuotas is null then
       ln_numcuotas := 0;
    end if;
  end;
  
   return ln_numcuotas;
end fn_cuotas_pagadas;


Procedure Sp_cr_Direcciones (pn_pai in number,pn_tdo in number,pc_doc in char,pn_tip in number,
                             pc_dir out char,pv_ref out varchar2,pc_dis out char)is


begin
       --direccion
      begin
          select nvl(sngc13dir,aa.sngc13dsc1)
            into pc_dir
            from /*bantprod.*/sngc13 aa
           where aa.sngc13pais = pn_pai
             and aa.sngc13tdoc = pn_tdo
             and aa.sngc13ndoc = pc_doc
             and aa.docod = pn_tip
             and aa.sngc13est = 'H';
      exception 
          when no_data_found then 
             pc_dir := null;
          when too_many_rows then
             pc_dir := null;
       end;   
       
       
       --referencia
       begin
          select aa.sngc13ref1
            into pv_ref
            from /*bantprod.*/sngc13 aa
           where aa.sngc13pais = pn_pai
             and aa.sngc13tdoc = pn_tdo
             and aa.sngc13ndoc = pc_doc
             and aa.docod = pn_tip
             and aa.sngc13est = 'H'
             and rownum = 1;
       exception 
            when no_data_found then 
               pv_ref := null;
            when too_many_rows then
               pv_ref := null;
            when others then
               dbms_output.put_line(pn_pai||'-'||pn_tdo||'-'||pc_doc||'-'||pn_tip);
               --pv_ref := null;
       end;   
       
       --distrito
       
         begin
            select xx.fst071dsc
              into pc_dis
              from/*bantprod.*/sngc13 aa,/*bantprod.*/fst071 xx
             where aa.sngc13pais = pn_pai
               and aa.sngc13tdoc = pn_tdo
               and aa.sngc13ndoc = pc_doc
               and aa.sngc13pais = xx.fst071pai
               and aa.sngc13dpto = xx.fst071dpt
               and aa.sngc13prov = xx.fst071loc
               and aa.sngc13dist = xx.fst071col
               and aa.sngc13est = 'H'
               and aa.docod = pn_tip;
          exception 
              when no_data_found then 
                 pc_dis := null;
              when too_many_rows then
                 pc_dis := null;
          end; 
      
end Sp_cr_Direcciones;    


function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pn_cta in number) return varchar2
is
lc_codsbs varchar2(10);
begin
  begin
    
    select lpad(to_char(c.bc739sbs),10,0) 
      into lc_codsbs
      from/*bantprod.*/fbc739 c
     where c.bc739pais = pn_pepais
       and c.bc739tdoc = pn_petdoc
       and c.bc739ndoc = pc_pendoc
       and c.bc739cta  = pn_cta;
  exception 
      when others then 
         lc_codsbs := null;
  end;   
   return lc_codsbs;
end fn_codsbs;


function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return char is
lc_activi char(60);
begin
  begin
      select xx.actnom1
        into lc_activi
        from/*bantprod.*/sngc60 aa,/*bantprod.*/fst750 xx
       where aa.sngc60pais = pn_pais
         and aa.sngc60tdoc = pn_tdoc
         and aa.sngc60ndoc = pc_ndoc
         and aa.sngc60corr = 0
         and aa.sngc60acte = xx.actcod1;
  exception
      when no_data_found then
           begin
           
                  select xxx.actnom1
                    into lc_activi
                    from/*bantprod.*/sngc11 cc,/*bantprod.*/fst750 xxx
                   where cc.sngc11pais = pn_pais
                     and cc.sngc11tdoc = pn_tdoc
                     and cc.sngc11ndoc = pc_ndoc
                     and cc.sngc11act2 = xxx.actcod1;
           exception
               when no_data_found then
                    begin
                        
                        select xxx.actnom1
                        into lc_activi
                        from/*bantprod.*/fse001 cc,/*bantprod.*/fst750 xxx
                       where cc.d511pais = pn_pais
                         and cc.d511tdoc = pn_tdoc
                         and cc.d511ndoc = pc_ndoc
                         and cc.expnins = xxx.actcod1;
                    exception
                         when others then 
                              lc_activi := null;
                    end;
           end;
         
      when too_many_rows then
         lc_activi := null;
  end;
   return lc_activi;
end fn_actividad;

function fn_categoria (pn_emp in number, pn_cta in number,pn_codcat in number ) 
                      return char is
lc_categoria char(15);
ld_fecha date;

begin

  --devuelve fecha activa de fin de mes
  
  ld_fecha := PQ_CR_VENTA_LUREN.fn_fechafin(trunc(sysdate));
  
  
  
  begin
    select l.catcateg 
      into lc_categoria
      from/*bantprod.*/fsd212 l 
     where l.pgcod     = pn_emp
       and l.catcta    = pn_cta
       and l.catfchdes = ld_fecha
       and l.catcod    = pn_codcat;
  exception 
      when no_data_found then 
         lc_categoria := null;
      when too_many_rows then
         lc_categoria := null;
  end;   
   return lc_categoria;
end fn_categoria;

function fn_provisiones (pn_emp in number,pn_mod in number,pn_mda in number,pn_pap in number,
                         pn_cta in number,pn_ope in number,pn_sbo in number,pn_top in number) 
                      return number is
ln_provision number(14,8);
begin
  
  begin
    select l.ri105coef
      into ln_provision
      from/*bantprod.*/fri105 l 
     where l.ri105cod  = pn_emp
       and l.ri105mod  = pn_mod
       and l.ri105mda  = pn_mda
       and l.ri105pap  = pn_pap
       and l.ri105cta  = pn_cta
       and l.ri105oper = pn_ope
       and l.ri105sbop = pn_sbo
       and l.ri105tope = pn_top;
  exception 
      when no_data_found then 
         ln_provision := 0;
      when too_many_rows then
         ln_provision := 0;
  end;   
  
  if nvl(ln_provision,0) = 0 then
     ln_provision := 100;
  end if;
   return ln_provision;
end fn_provisiones;


function fn_refinanciado (pn_cta in number, pn_oper in number) return char is
lc_existe char(1);
begin
  begin
       select 'S'
         into lc_existe
         from fsr011 a 
        where a.r1cta = pn_cta
          and a.r1oper = pn_oper
          and relcod = 35
          and a.r011co = 'S'
          and rownum = 1;
  exception
          when no_data_found then
             lc_existe := 'N'  ;
  end;
  
  if lc_existe = 'N' then
         begin
               select 'S'
                 into lc_existe
                 from fsr011 a 
                where a.r1cta = pn_cta
                  and a.r1oper = pn_oper
                  and relcod = 120
                  and a.r011co = 'S'
                  and rownum = 1;
          exception
                  when no_data_found then
                     lc_existe := 'N'  ;
          end;
          
          if lc_existe = 'N' then
                 begin
                       select 'S'
                         into lc_existe
                         from fsr011 a 
                        where a.r2cta = pn_cta
                          and a.r2oper = pn_oper
                          and relcod = 120
                          and a.r011co = 'S'
                          and rownum = 1;
                  exception
                          when no_data_found then
                             lc_existe := 'N'  ;
                  end;
                  
          end if;
          
  end if;
  
  /*begin
    select 'S'
      into lc_existe
      from\*bantprod.*\sng001 l 
     where l.sng001inst = pn_ins
       and l.sng001ori  = 3;
     
  exception 
      when no_data_found then 
         lc_existe := 'N';
  end;   */
   return lc_existe;
end fn_refinanciado;

Procedure Sp_cr_fsd010(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                       pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                       pn_top in number,ld_aofvto out date, ln_aostat out number,
                       ld_aofvalJ out date,ld_aofvalC out date)is

--ln_mod number(3);
ln_cta number(9);
ln_ope number(9);
ln_cor number(10);

begin
      begin
      
          IF pn_mod = 33 then
          
                ld_aofvalJ := null;
                begin
                
                
                   select a.aofvto,
                          --a.aofval,
                          a.aostat
                     into ld_aofvto,
                          --ld_aofvalC,
                          ln_aostat
                     from/*bantprod.*/fsd010 a
                    where a.pgcod  = pn_emp
                      and a.aomod  = pn_mod
                      and a.aosuc  = pn_suc
                      and a.aomda  = pn_mda
                      and a.aopap  = pn_pap
                      and a.aocta  = pn_cta
                      and a.aooper = pn_ope
                      and a.aosbop = pn_sbo
                      and a.aotope = pn_top;
                
                
                       exception when others then
                           ld_aofvto := null;
                           --ld_aofvalC := null;
                           ln_aostat := null;
                           
                       
                end;
                
                begin
                     select a.jaql166scfvl
                       into ld_aofvalC
                       from jaql166 a
                      where jaql166nrpag= 0
                        and a.jaql166sccta = pn_cta
                        and a.jaql166scope = pn_ope
                        and a.jaql166scmod = pn_mod;
                exception 
                        when no_data_found then
                             ld_aofvalC := null;   
                        when too_many_rows then
                              begin
                                   select a.jaql166scfvl
                                     into ld_aofvalC
                                     from jaql166 a
                                    where jaql166nrpag= 0
                                      and a.jaql166sccta = pn_cta
                                      and a.jaql166scope = pn_ope
                                      and a.jaql166scmod = pn_mod
                                      and a.jaql166est = 90
                                      and rownum = 1;
                              exception 
                                      when no_data_found then
                                           ld_aofvalC := null;   
                                              
                              end;
                                
                end;
                
                begin
             
                      select a.r1cta,a.r1oper
                        into ln_cta,ln_ope
                        from /*bantprod.*/fsr011 a
                       where a.r2mod  = pn_mod
                         and a.r2cta  = pn_cta
                         and a.r2oper = pn_ope
                         and a.r2sbop = pn_sbo
                         and a.r2cod  = pn_emp
                         and a.r2suc  = pn_suc
                         and a.r2mda  = pn_mda
                         and a.r2pap  = pn_pap
                         and a.r2tope = pn_top
                         and a.relcod = 33
                         and rownum = 1;
                         
                 exception when others then
                     --ln_mod := null;
                     ln_cta := null;
                     ln_ope := null;
                     
                 end;
                 
                  begin
                     select a.jaqm33cor 
                       into ln_cor
                       from jaqm27 a
                      where a.jaqm27cta  = ln_cta
                        and a.jaqm27oper = ln_ope;
                    exception 
                            when no_data_found then
                                 ln_cor := null;  
                            when too_many_rows then    
                                 begin
                                       select a.jaqm33cor 
                                         into ln_cor
                                         from jaqm27 a
                                        where a.jaqm27cta  = ln_cta
                                          and a.jaqm27oper = ln_ope
                                          and a.jaqm27chr3 = 'FIRME'
                                          and rownum = 1;
                                  exception 
                                          when no_data_found then
                                               begin
                                                     select a.jaqm33cor 
                                                       into ln_cor
                                                       from jaqm27 a
                                                      where a.jaqm27cta  = ln_cta
                                                        and a.jaqm27oper = ln_ope
                                                        and rownum = 1;
                                                exception 
                                                        when no_data_found then
                                                             ln_cor := null;  
                                                end;
                                  end;
                    end;
                    begin
                         select a.jaqm33fdem
                           into ld_aofvalJ
                           from jaqm33 a
                          where a.jaqm33cor = ln_cor
                            and rownum = 1;
                    exception 
                            when no_data_found then
                                 ld_aofvalJ := null;
                    end;
                  
         End If;
         
         IF pn_mod = 200 then
          
                ld_aofvalC := null;
                begin
                
                
                   select a.aofvto,
                          --a.aofval,
                          a.aostat
                     into ld_aofvto,
                          --ld_aofvalJ,
                          ln_aostat
                     from/*bantprod.*/fsd010 a
                    where a.pgcod  = pn_emp
                      and a.aomod  = pn_mod
                      and a.aosuc  = pn_suc
                      and a.aomda  = pn_mda
                      and a.aopap  = pn_pap
                      and a.aocta  = pn_cta
                      and a.aooper = pn_ope
                      and a.aosbop = pn_sbo
                      and a.aotope = pn_top;
                
                
                       exception when others then
                           ld_aofvto := null;
                           --ld_aofvalJ := null;
                           ln_aostat := null;
                           
                       
                end;
                
                begin
                     select a.jaqm33cor 
                       into ln_cor
                       from jaqm27 a
                      where a.jaqm27cta  = pn_cta
                        and a.jaqm27oper = pn_ope;
                    exception 
                            when no_data_found then
                                 ln_cor := null;  
                            when too_many_rows then    
                                 begin
                                       select a.jaqm33cor 
                                         into ln_cor
                                         from jaqm27 a
                                        where a.jaqm27cta  = pn_cta
                                          and a.jaqm27oper = pn_ope
                                          and a.jaqm27chr3 = 'FIRME'
                                          and rownum = 1;
                                  exception 
                                          when no_data_found then
                                               begin
                                                     select a.jaqm33cor 
                                                       into ln_cor
                                                       from jaqm27 a
                                                      where a.jaqm27cta  = pn_cta
                                                        and a.jaqm27oper = pn_ope
                                                        and rownum = 1;
                                                exception 
                                                        when no_data_found then
                                                             ln_cor := null;  
                                                end;
                                  end;
                    end;
                    begin
                         select a.jaqm33fdem
                           into ld_aofvalJ
                           from jaqm33 a
                          where a.jaqm33cor = ln_cor
                            and rownum = 1;
                    exception 
                            when no_data_found then
                                 ld_aofvalJ := null;
                    end;
                  
         End If;
     end;

end Sp_cr_fsd010;    
      
Procedure Sp_cr_Avales (pn_ins in number,pn_num out number, pn_pai out number,
                        pn_tdo out number,pc_doc out char,pc_nom out char,
                        pc_tel out char)is

ln_cta number(9);


begin
       
      begin
         
          select count(a.sng003cta)
            into pn_num
            from/*bantprod.*/sng003 a
           where a.sng001inst = pn_ins
             and a.sng003pgc  = 1;
      exception
           when others then 
                pn_num := 0;
      end;
      
      begin
         
          select a.sng003cta
            into ln_cta
            from/*bantprod.*/sng003 a
           where a.sng001inst = pn_ins
             and a.sng003pgc  = 1
             and rownum = 1;
      exception
           when others then 
                ln_cta := null;
      end;
      
      begin
         
          select a.pepais,
                 a.petdoc,
                 a.pendoc
            into pn_pai,
                 pn_tdo,
                 pc_doc
            from/*bantprod.*/fsr008 a
           where a.pgcod = 1
             and a.ctnro = ln_cta;
      exception
           when others then 
                pn_pai := null;
                pn_tdo := null;
                pc_doc := null;
      end;
      
      begin
         
          select a.penom
            into pc_nom
            from/*bantprod.*/fsd001 a
           where a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_doc;
      exception
           when others then 
                pc_nom := null;
             
      end;
      
      begin
         
          select a.dotelfp
            into pc_tel
            from/*bantprod.*/fsr005 a
           where a.pepais = pn_pai
             and a.petdoc = pn_tdo
             and a.pendoc = pc_doc
             and a.docod = 1
             and rownum=1;
      exception
           when others then 
                pc_tel := null;
             
      end;
      

end Sp_cr_Avales;    

function fn_tipSBS (/*pd_fecpro in date,pn_emp in number,pn_mod in number,pn_suc in number,
                    pn_mda in number,pn_pap in number,*/pn_cta in number,pn_ope in number/*,
                    pn_sbo in number,pn_top in number*/) return char is
lc_tipsbs char(30);
/*ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ld_fecj date;*/
lc_codsbs char(2);
begin

        begin
          select a.jqy470ctip
            into lc_codsbs
            from jaqy470c a
           where a.jqy470ccta = pn_cta
             and a.jqy470cope = pn_ope
             and rownum = 1;
        exception 
             when no_data_found then
                  lc_codsbs := null;
        end;
        
        begin
           select a.tpdesc
             into lc_tipsbs
             from FST098  a
            where Pgcod = 1 
              and Tpcod = 7701 
              and Tpcorr > 599 
              and Tpcorr < 650
              and tpnro = to_number(lc_codsbs);
        exception 
             when no_data_found then
                  lc_tipsbs := null;
        end;


  /*if pn_mod = 33 then
  
     begin
             
          select a.r1cod,a.r1mod,a.r1suc,a.r1mda,a.r1pap,a.r1cta,a.r1oper,a.r1sbop,a.r1tope
            into ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo,ln_top
            from\*bantprod.*\fsr011 a
           where a.r2mod  = pn_mod
             and a.r2cta  = pn_cta
             and a.r2oper = pn_ope
             and a.r2sbop = pn_sbo
             and a.r2cod  = pn_emp
             and a.r2suc  = pn_suc
             and a.r2mda  = pn_mda
             and a.r2pap  = pn_pap
             and a.r2tope = pn_top
             and a.relcod = 33;
                     
     exception when others then
         ln_emp := null;
         ln_mod := null;
         ln_suc := null;
         ln_mda := null;
         ln_pap := null;
         ln_cta := null;
         ln_ope := null;
         ln_sbo := null;
         ln_top := null;
     end;
     
     begin
             
          select a.aofval
            into ld_fecj
            from\*bantprod.*\FSD010 a
           where a.aomod  = ln_mod
             and a.aocta  = ln_cta
             and a.aooper = ln_ope
             and a.aosbop = ln_sbo
             and a.pgcod  = ln_emp
             and a.aosuc  = ln_suc
             and a.aomda  = ln_mda
             and a.aopap  = ln_pap
             and a.aotope = ln_top;
                     
     exception when others then
         ld_fecj := null;
   
     end;
     
     begin
        select case  when BCGpo = 2 then 'MICROEMPRESAS'
                     when BCGpo = 3 and substr(l.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
                     when BCGpo = 3 and substr(l.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
                     when BCGpo = 4 then 'HIPOTECARIO'
                     when BCGpo = 12 then 'MEDIANA EMPRESA'
                     when BCGpo = 13 then 'PEQUEÑA EMPRESA'
                     when BCGpo in ( 5,6,7,8,9) then 'CORPORATIVO'
               END TIPSBS

          into lc_tipsbs
          from\*bantprod.*\fsh012 l 
         where l.bcemp  = ln_emp
           and l.bcsuc  = ln_suc
           and l.bcmda  = ln_mda
           and l.bcpap  = ln_pap
           and l.bccta  = ln_cta
           and l.bcoper = ln_ope
           and l.bcsbop = ln_sbo
           and l.bctop  = ln_top
           and l.bcmod  = ln_mod
           and l.bcfech = ld_fecj;
         
      exception 
          when no_data_found then 
             lc_tipsbs := null;
      end;   
      
      
      else
             begin
                select case  when BCGpo = 2 then 'MICROEMPRESAS'
                             when BCGpo = 3 and substr(l.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE'
                             when BCGpo = 3 and substr(l.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'
                             when BCGpo = 4 then 'HIPOTECARIO'
                             when BCGpo = 12 then 'MEDIANA EMPRESA'
                             when BCGpo = 13 then 'PEQUEÑA EMPRESA'
                             when BCGpo in ( 5,6,7,8,9) then 'CORPORATIVO'
                       END TIPSBS

                  into lc_tipsbs
                  from\*bantprod.*\fsh012 l 
                 where l.bcemp  = pn_emp
                   and l.bcsuc  = pn_suc
                   and l.bcmda  = pn_mda
                   and l.bcpap  = pn_pap
                   and l.bccta  = pn_cta
                   and l.bcoper = pn_ope
                   and l.bcsbop = pn_sbo
                   and l.bctop  = pn_top
                   and l.bcmod  = pn_mod
                   and l.bcfech = pd_fecpro;
                   
              exception 
                  when no_data_found then 
                     lc_tipsbs := null;
              end;   
  
  end if;*/
  
return lc_tipsbs;
end fn_tipSBS;

Function Fn_cr_GarantiaTipo (pn_mod in number,pn_top in number) return char is
lc_tip char(20);
begin
       
      begin
          
          select case when a.tp1corr2 =1 then 'GARANTIAS INSCRITAS'
                      when a.tp1corr2 =2 then 'BIENES DECLARADOS'
                      when a.tp1corr2 =3 then 'AVALES'
                      else null
                 end
            into lc_tip
            from/*bantprod.*/fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10897
             and a.tp1corr1 = 500
             and a.tp1nro1 = pn_mod 
             and a.tp1nro2 = pn_top;
             
       exception
             when others then
                  lc_tip := null;
                  
      end;
      return lc_tip;
      
end Fn_cr_GarantiaTipo;    

Function Fn_Garantia_mto (pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                         pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                         pn_top in number) return number is
ln_mtogar number(17,2);                       

begin
       
      
      begin
      
      select a.scsdo
        into ln_mtogar
        from/*bantprod.*/fsd011 a
       where a.pgcod  = pn_emp
         and a.scsuc  = pn_suc
         and a.scmda  = pn_mda
         and a.scpap  = pn_pap
         and a.sccta  = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.scmod  = pn_mod 
         and a.scstat = 54;
      exception
        when others then
             ln_mtogar := null;
      
      end; 
     return ln_mtogar;

end Fn_Garantia_mto;    

function fn_correlativo (pn_prop in number) return number is
ln_corr number(30);
begin
  begin
   select max(a.jaqz064cor)
     into ln_corr
     from jaqz064 a
    where a.jaqz064nro = pn_prop;
     
  exception 
      when no_data_found then 
         ln_corr := 0;
  end;  
  if ln_corr is null then
      ln_corr := 0;
      else
           ln_corr := ln_corr + 1;
   end if;
  
   return ln_corr;
end fn_correlativo;

function fn_correlativo_II (pn_prop in number) return number is
ln_corr number(30);
begin
  begin
   select max(a.jaqz064cor)
     into ln_corr
     from jaqz064 a
    where a.jaqz064nro = pn_prop;
     
  exception 
      when no_data_found then 
         ln_corr := 0;
  end;  
  if ln_corr is null then
      ln_corr := 0;
      else
           ln_corr := ln_corr + 1;
   end if;
  
   return ln_corr;
end fn_correlativo_II;

function fn_fechafin (pd_fecha in date) return date is

ld_finme date;
lc_diafm char(2);
lc_diaaux char(2);
ld_fecha date;
ln_mes number(2);
lc_dia char(2);
lc_ani char(4);
ln_mesant number(2);
lc_mesant char(2);
ld_fec date;
ln_ani number(4);

begin

   begin
      ld_finme    := last_day(pd_fecha);
      lc_diafm    := to_char(ld_finme,'dd');
      lc_diaaux   := to_char(pd_fecha,'dd');
      
      if lc_diaaux = lc_diafm then
         ld_fecha := pd_fecha;
         else
               ln_mes := to_number(to_char(pd_fecha,'mm'));
               lc_dia := to_char(pd_fecha,'dd');
               --lc_ani := to_char((trunc(sysdate)),'yyyy');
               ln_ani := to_number(to_char(pd_fecha,'yyyy'));
                 
               if ln_mes = 1 then 
                  ln_mesant := 12;
                  ln_ani := ln_ani -1;
                  else
                       ln_mesant := ln_mes - 1;
               end if;
                  
               lc_mesant := to_char(ln_mesant);
               lc_ani := to_char(ln_ani);
              -- to_date('01'||to_char(Pd_fecpro,'mmyyyy'),'ddmmyyyy')
               ld_fec    := to_date(lc_ani||lc_mesant||lc_dia,'yyyymmdd');
               ld_fecha  := last_day(ld_fec);
        
      end if;
    
   end;
   return ld_fecha;
end fn_fechafin;

function fn_cl_telefonos(lv_pepais in number,lv_petdoc in number,lv_pendoc in char,
                         pn_tip in number) return varchar2
  IS

    lv_pendoc2 char(12);
    lv_telefonos varchar2(50);

    cursor c_tele_pers is
           select Dotelfp
             from/*bantprod.*/Fsr005
            Where Pepais = lv_pepais
              and Petdoc = lv_petdoc
              and Pendoc = lv_pendoc2
              and Docod  = pn_tip
            ;

  BEGIN
    lv_pendoc2 := lv_pendoc;

    for i in c_tele_pers  loop
        lv_telefonos := lv_telefonos || trim(i.Dotelfp)|| '|';
    end loop;
    lv_telefonos := substr(lv_telefonos, 1, length(lv_telefonos) - 1);
    return lv_telefonos;

  EXCEPTION
    when others then
         return null;

  END fn_cl_telefonos;
  
Procedure Sp_Garantias (pn_nro in number,pn_emp in number, pn_mod in number, pn_suc in number,
                        pn_mda in number,pn_pap in number, pn_cta in number, pn_ope in number,
                        pn_sbo in number,pn_top in number) is

cursor garantias (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                  pn_pap in number, pn_cta in number, pn_ope in number, pn_sbo in number, 
                  pn_top in number) is
                  
select (select d.tonom from fst004 d where d.modulo = a.jaqy954mod1 and d.totope = a.jaqy954top1) tipgar,
       PQ_CR_VENTA_LUREN.Fn_Garantia_mto(a.jaqy954emp1,a.jaqy954mod1,a.jaqy954suc1,a.jaqy954mda1,a.jaqy954pap1,
                                   a.jaqy954cta1,a.jaqy954ope1,a.jaqy954sbo1,a.jaqy954top1)mtogar
  from jaqy954 a
 where (a.jaqy954est ='S' OR a.jaqy954est IS NULL)
   and nvl(a.jaqy954vig,'S') ='S'
   and jaqy952nro = pn_nro
   and jaqy954emp2 = pn_emp
   and jaqy954suc2 = pn_suc
   and jaqy954cta2 = pn_cta
   and jaqy954pap2 = pn_pap
   and jaqy954ope2 = pn_ope
   and jaqy954sbo2 = pn_sbo
   and jaqy954mda2 = pn_mda
   and jaqy954mod2 = pn_mod
   and jaqy954top2 = pn_top
   ;
ln_count number(6);                  
begin
    ln_count:= 0;
    
    begin
    
    for i in garantias(pn_emp,pn_mod,pn_suc,pn_mda,pn_pap,pn_cta,pn_ope,pn_sbo,pn_top) loop
    
        ln_count := ln_count + 1;
        
        if ln_count = 1 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg1 = i.tipgar,
               jaqz064mg1 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
        
        if ln_count = 2 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg2 = i.tipgar,
               jaqz064mg2 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
        
        if ln_count = 3 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg3 = i.tipgar,
               jaqz064mg3 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
        
        if ln_count = 4 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg4 = i.tipgar,
               jaqz064mg4 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
        
        if ln_count = 5 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg5 = i.tipgar,
               jaqz064mg5 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
        
        if ln_count = 6 and  ln_count <= 6 then
           
        update jaqz064 f
           set jaqz064tg6 = i.tipgar,
               jaqz064mg6 = i.mtogar
         where f.jaqz064pgc = pn_emp
           and f.jaqz064mod = pn_mod
           and f.jaqz064suc = pn_suc
           and f.jaqz064mda = pn_mda
           and f.jaqz064pap = pn_pap
           and f.jaqz064cta = pn_cta
           and f.jaqz064ope = pn_ope
           and f.jaqz064sbo = pn_sbo
           and f.jaqz064top = pn_top;
           
           commit;
        
        end if;
    
    end loop;
    
end;

end Sp_Garantias;

Procedure Sp_jaql124(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                     pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                     pn_top in number,ld_fju out date,ld_fca out date,lc_ref out varchar2,
                     ld_fup out date,ln_cpa out number,ld_fde out date,ln_mde out number,
                     lc_cal out varchar2,ln_ppv out number,lc_dir out varchar2)is


begin
  begin
       select a.jaql124fju, --fecha judicial
              a.jaql124fca, --fecha castigado
              a.jaql124ref, --refinanciado
              a.jaql124fup, --fecha de ultimo pago
              a.jaql124cpa, --cuotas pagadas
              a.jaql124fde, --fecha de desembolso
              a.jaql124mde, --monto desembolsado
              a.jaql124cal, --calificacion sbs
              a.jaql124ppv, --provisiones
              a.jaql124dir  --direccion
         into ld_fju,
              ld_fca,
              lc_ref,
              ld_fup,
              ln_cpa,
              ld_fde,
              ln_mde,
              lc_cal,
              ln_ppv,
              lc_dir
         from jaql124 a
        where a.jaql124cod = pn_emp
          and a.jaql124suc = pn_suc
          and a.jaql124mod = pn_mod
          and a.jaql124pap = pn_pap
          and a.jaql124cta = pn_cta
          and a.jaql124ope = pn_ope
          and a.jaql124sbo = pn_sbo
          and a.jaql124top = pn_top;
  end;
end;
/*Procedure Sp_fechaUltimoPag(pn_cta in number,pn_ope in number,pd_fec out date)is

begin
       select distinct fecha_pago
         into pd_fec
         from (
    select distinct j.lote,
                    j.cuenta,
                    j.operacion,
                    j.modulo, 
                    i.moneda, 
                    i.mod, 
                    i.trans, 
                    i.sucu, 
                    i.hnrel, 
                    i.fecha_pago 
                    , z.hhora ,  
                    sum(i.pago) pago
        from operador.creditosv j ,
        (
        select d.hcta, d.hoper, d.mod, d.trans, d.sucu, d.hnrel, d.fecha_pago , q.pago , q.moneda from
                  operador.pagosv q , operador.transacciones w ,
                  (
                        select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago  --, t.ordinal --, sum(t.pago)
                        from operador.pagosv t , operador.transacciones o
                        where t.mod = o.tp1corr1
                        and t.trans = o.tp1corr2
                        and o.tp1corr3 = t.ordinal
                        and o.tp1nro2 = 2
                        group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago             --order by 1,2,3,4,5,6,7,8  --6361    total: 26617
                        minus
                        select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago
                        from operador.pagosv t , operador.transacciones o
                        where t.mod = o.tp1corr1
                        and t.trans = o.tp1corr2
                        and o.tp1corr3 = t.ordinal
                        and o.tp1nro2 = 1
                        group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago
                  ) d
                  where d.hcta = q.hcta
                  and d.hoper = q.hoper
                  and d.mod = q.mod
                  and d.trans = q.trans
                  and d.sucu = q.sucu
                  and d.hnrel = q.hnrel
                  and d.fecha_pago =  q.fecha_pago
                  and w.tp1corr1 = q.mod
                  and w.tp1corr2 = q.trans
                  and w.tp1corr3 = q.ordinal
                  and w.tp1nro2 = 2 --713

                  union
                  select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago, t.pago ,t.moneda
                  from operador.pagosv t , operador.transacciones o
                  where t.mod = o.tp1corr1
                  and t.trans = o.tp1corr2
                  and o.tp1corr3 = t.ordinal
                  and o.tp1nro2 = 1
                  group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago, t.pago,  t.moneda
        ) i,
        fsh015 z,
        (select c.lote,
               c.cuenta,
               c.operacion,
               c.modulo,
               p.moneda,
               max(p.fecha_pago) ULTIMO_PAGO,
               sum(p.pago) PAGO
               --p.pago
          from operador.creditosv c,
           (
                  select d.hcta, d.hoper, d.mod, d.trans, d.sucu, d.hnrel, d.fecha_pago , q.pago , q.moneda from
                  operador.pagosv q , operador.transacciones w ,
                  (
                        select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago  --, t.ordinal --, sum(t.pago)
                        from operador.pagosv t , operador.transacciones o
                        where t.mod = o.tp1corr1
                        and t.trans = o.tp1corr2
                        and o.tp1corr3 = t.ordinal
                        and o.tp1nro2 = 2
                        group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago             --order by 1,2,3,4,5,6,7,8  --6361    total: 26617
                        minus
                        select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago
                        from operador.pagosv t , operador.transacciones o
                        where t.mod = o.tp1corr1
                        and t.trans = o.tp1corr2
                        and o.tp1corr3 = t.ordinal
                        and o.tp1nro2 = 1
                        group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago
                  ) d
                  where d.hcta = q.hcta
                  and d.hoper = q.hoper
                  and d.mod = q.mod
                  and d.trans = q.trans
                  and d.sucu = q.sucu
                  and d.hnrel = q.hnrel
                  and d.fecha_pago =  q.fecha_pago
                  and w.tp1corr1 = q.mod
                  and w.tp1corr2 = q.trans
                  and w.tp1corr3 = q.ordinal
                  and w.tp1nro2 = 2 --713

                  union
                  select t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago, t.pago ,t.moneda
                  from operador.pagosv t , operador.transacciones o
                  where t.mod = o.tp1corr1
                  and t.trans = o.tp1corr2
                  and o.tp1corr3 = t.ordinal
                  and o.tp1nro2 = 1
                  group by t.hcta, t.hoper, t.mod, t.trans, t.sucu, t.hnrel, t.fecha_pago, t.pago,  t.moneda
           ) p
        where c.cuenta = p.hcta(+)
           and c.operacion = p.hoper(+)
        --  and c.cuenta = 9992--292569 --
        --  and c.operacion = 2291683--53859  --
        --and c.nro < 56413
        group by c.lote, c.cuenta, c.operacion, c.modulo, p.moneda

        ) w
        where w.ULTIMO_PAGO = i.fecha_PAGO(+)
        and w.cuenta = i.hcta(+)
        and w.operacion = i.hoper(+)
        and w.cuenta = j.cuenta
        and w.operacion =  j.operacion
        and z.pgcod(+) = 1
        and z.hcmod(+) = i.mod
        and z.hsucor(+) =  i.sucu
        and z.htran(+) = i.trans
        and z.hnrel(+) = i.hnrel
        and z.hfcon(+) = i.fecha_pago
        and w.cuenta = pn_cta
        and w.operacion = pn_ope
        and rownum= 1
        --and w.cuenta in (103159  )--(58486,69602,84467,84467,85559,88915) --9992--292569
        --and w.operacion in (2021612) --(2593071,2050417,2608728,2608748,2213397,2365985) --2291683--53859
        group by j.lote,j.cuenta,j.operacion,j.modulo,
        i.moneda, i.mod, i.trans, i.sucu, i.hnrel, i.fecha_pago , z.hhora);
                    

end Sp_fechaUltimoPag;*/
end PQ_CR_VENTA_LUREN;
/

