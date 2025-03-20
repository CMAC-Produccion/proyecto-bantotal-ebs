create or replace package PQ_OCUM_PROCESOS is

  -- Author  : ABERNEDO
  -- Created : 28/05/2014 11:47:57 a.m.
  -- Purpose : 
  
  Function Fn_Ejecutivo (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                       pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;
  Function fn_analista (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;
  function fn_meses (pn_mes in char) return varchar2;
  Procedure SP_Multiples(Pd_fecpro in date);
  Procedure SP_Unicas(Pd_fecini in date,Pd_fecfin in date);                      
  Procedure SP_OCUM_CANCADL(PD_FECINI IN DATE, PD_FECFIN IN DATE);
  Procedure SP_Ocum_OpeExtr(pd_fecini in date,pd_fecfin in date);
  function fn_ordinal_sin_relacion (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn1 in number,
                                  pn_trn2 in number,pd_fec in date) return number;
  function fn_ordinal (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn in number,
                     pn_nrel in number, pd_fec in date) return number;   
  Procedure SP_Ocum_SinCredVig(Pd_fecini in date,Pd_fecfin in date);                                                
  Procedure Sp_CliIngPromMensual (PN_SUC IN NUMBER);
end PQ_OCUM_PROCESOS;
/

create or replace package body PQ_OCUM_PROCESOS is


Procedure SP_Unicas(Pd_fecini in date,Pd_fecfin in date) is

ln_cta number;
ln_oper number;
ln_toper number;
lc_suc  varchar(100);
ln_mod  number;
ln_mda number; 
lc_titular repoue.titular%type;
ln_pais number;
ln_tdoc number;
lc_numdoc fsd001.pendoc%type;
lc_existe varchar(1);
lc_listneg fst501.tlisde%type;
lc_entfin varchar(1);
ln_suc number;
ln_pap number;
ln_sbop number;
ln_pri number;

cursor tues (Pd_fecini in date, Pd_fecfin in date) is
--create table repoue as 
select  /*+ FULL(A) */  --mod@abr 20180524
        a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod, 
        b.hfcon,
        b.hcmod , 
        b.hsucor, 
        b.htran, 
        b.hnrel, 
        f.trnom Nomoperacion, 
       (a.bc604suc||a.bc604mod||a.bc604trn||a.bc604nrel) NroTransaccion,
        a.bc604mod ModuloOperacion,
        a.bc604mda MdaOperacion,
        i.scnom AgenciaOperacion,
        CASE
                when a.bc604mda = 0 then 'S/.'
                when a.bc604mda = 101 then '$'
        END MdaTransaccion,
        a.bc604impmo Monto,
        a.bc604oefe origendefondos,
        a.bc604fch Fecha,
        a.bc604usid Operador,
        (select l.bc605pais 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )Pais,
        (select l.bc605tdoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )TipoDoc,
        (select l.bc605ndoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )numdoc,
        (select l.bc605ndoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
        )NroDnitramitante,
        (select m.tdnom 
           from fbc605 l,fst014 m 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and l.bc605tdoc     = m.tdocum
        )TDocumento,
        (select n.penom 
           from fbc605 l,fsd001 n 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and l.bc605ndoc     = n.pendoc
        )Tramitante,
        (select (trim(o.bc602nom)||trim(o.bc602ape)||trim(o.bc602apem)) 
           from fbc605 l,fbc602 o 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and L.BC605PAIS     = O.BC602PAIS --mod@abr 20180524
            and l.bc605tdoc     = o.bc602tdoc
            and l.bc605ndoc     = o.bc602ndoc
        )TramitanteNoCliente
  from fbc604 a, 
       fsh015 b,
       fst034 f,
       fst001 i
 where a.bc604co     ='S' 
   and a.bc604fch      between Pd_fecini and Pd_fecfin
   and a.bc604emp      =1 
   and a.BC604EMP      = b.pgcod
   and a.BC604MOD      = b.hcmod
   and a.BC604SUC      = b.hsucor
   and a.BC604TRN      = b.htran
   and a.BC604NREL     = b.hnrel
   and a.BC604FCH      = b.hfcon
   and a.BC604TTrn     in (2,3)
   and a.bc604emp      = f.pgcod
   and a.bc604mod      = f.trmod
   and a.bc604trn      = f.trnro
   AND B.PGCOD         = F.PGCOD  --mod@abr 20180524
   AND B.HCMOD         = F.TRMOD  --mod@abr 20180524
   AND B.HTRAN         = F.TRNRO  --mod@abr 20180524 
   and a.bc604emp      = i.pgcod
   and a.bc604suc      = i.sucurs
   and I.PGCOD         = 1        --mod@abr 20180524
   AND B.PGCOD         = I.PGCOD  --mod@abr 20180524
   AND B.HSUCOR        = I.SUCURS --mod@abr 20180524
   and b.hccorr        <> 99
   
;
   
   
begin

execute immediate ('truncate table JAQY501');
execute immediate ('truncate table JAQY502');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 100;COMMIT;
                   

for i in tues (Pd_fecini, Pd_fecfin) loop
ln_cta     := null;
ln_oper    := null;
ln_toper   := null;
lc_suc     := null;
ln_mod     := null;
ln_mda     := null;
lc_titular :=null;
ln_pais    :=null;
ln_tdoc    :=null;
lc_numdoc  :=null;
lc_existe  :=null;
lc_listneg := null;
lc_entfin  := null;
ln_suc     := null;
ln_pap     := null;
ln_sbop    := null;
ln_pri     := null;


       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
           from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.hcmod  = i.hcmod   
                and c.hsucor = i.hsucor 
                and c.htran  = i.htran   
                and c.hnrel  = i.hnrel   
                and c.hfcon  = i.hfcon 
                and hcta <> 0
				and e.pgcod = 1
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and c.hcodmo = 2
                --and g.ctxcod = 1
                --and g.ctxnro = c.hcta
                --and g.ctxsuc = h.sucurs
                and h.pgcod = 1
                and c.hsucur = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.hcmod  = i.hcmod   
                      and c.hsucor = i.hsucor 
                      and c.htran  = i.htran   
                      and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.hfcon   
                      and hcta <> 0
                      and e.pgcod = 1
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and c.hcodmo = 2
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.hcta
                      --and g.ctxsuc = h.sucurs
                      and h.pgcod = 1
                      and c.hsucur = h.sucurs
                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select hcta, 
                              hoper, 
                              htoper, 
                              scnom , 
                              hmodul, 
                              hmda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              hsucur,
                              hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                           
                        from(select distinct c.hcta, 
                                         c.hoper, 
                                         c.htoper, 
                                         h.scnom , 
                                         c.hmodul, 
                                         c.hmda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.hsucur,
                                         c.hpap,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e/*,fse008 g*/,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.pgcod = 1
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and h.pgcod = 1
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                             dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                       dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                   from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.hcmod  = i.hcmod   
                        and c.hsucor = i.hsucor 
                        and c.htran  = i.htran   
                        and c.hnrel  = i.hnrel   
                        and c.hfcon  = i.hfcon   
                        and hcta <> 0
                        and e.pgcod = 1
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.hcta
                        and c.hcodmo = 2
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.hcta
                        --and g.ctxsuc = h.sucurs
                        and h.pgcod = 1
                        and c.hsucur = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.pgcod = 1
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and h.pgcod = 1
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.hcmod  = i.hcmod   
                                    and c.hsucor = i.hsucor 
                                    and c.htran  = i.htran   
                                    and c.hnrel  = i.hnrel   
                                    and c.hfcon  = i.hfcon   
                                    and hcta <> 0
                                    and e.pgcod = 1
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.hcta
                                    and c.hcodmo = 2
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.hcta
                                    --and g.ctxsuc = h.sucurs
                                    and h.pgcod = 1
                                    and c.hsucur = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                         from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.hcmod  = i.hcmod   
                              and c.hsucor = i.hsucor 
                              and c.htran  = i.htran   
                              and c.hnrel  = i.hnrel   
                              and c.hfcon  = i.hfcon   
                              and hcta <> 0
                              and e.pgcod = 1
                              and e.ctnro  = c.hcta
                              and e.cttfir = 'T'
                              and c.hcodmo = 2
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.hcta
                              --and g.ctxsuc = h.sucurs
                              and h.pgcod = 1
                              and c.hsucur = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.pgcod = 1
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
                                      and h.pgcod = 1
                                      and c.hsucur = h.sucurs
                                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.pgcod = 1
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
                                      and h.pgcod = 1
                                      and c.hsucur = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;     
                             end;       
                     end;       
               end;       
         end;  
         begin
              select j.penom 
                into lc_titular
                from fsd001 j 
               where j.pepais = ln_pais 
                 and j.petdoc = ln_tdoc
                 and j.pendoc = lc_numdoc;
         exception
            when others then 
                 if i.TRAMITANTE is not null then
                    lc_titular:= i.TRAMITANTE;     
                 elsif i.TRAMITANTENOCLIENTE is not null then   
                    lc_titular:= i.TRAMITANTENOCLIENTE; 
                 else
                    lc_titular:= null;   
                 end if;   
         end;
         -- Exite
          begin
            select distinct 'S'   
              into lc_existe
             from fsh016 c 
                where c.pgcod  = i.pgcod  
                  and c.hcmod  = i.hcmod   
                  and c.hsucor = i.hsucor 
                  and c.htran  = i.htran   
                  and c.hnrel  = i.hnrel   
                  and c.hfcon  = i.hfcon
                  and c.hcord  = i.bc604ord ;
         exception 
           when no_data_found then
                lc_existe:='N';
                
         end;
         -- Lista negra
          begin
            select y.tlisde
              into lc_listneg 
              from fsd201 x, LN_Priori  y 
             where x.lnpais = ln_pais 
               and x.lntdoc = ln_tdoc
               and x.lnndoc = lc_numdoc
               and x.tlis   = y.tlis
               and y.tlis <> 2;
         exception 
           when no_data_found then
              lc_listneg:= null;
           when others then 
            begin 
                select tlisde
                  into lc_listneg 
                  from LN_Priori where prioridad = (
                 select min(y.prioridad)
                  from fsd201 x, LN_Priori  y 
                 where x.lnpais = ln_pais 
                   and x.lntdoc = ln_tdoc
                   and x.lnndoc = lc_numdoc
                   and x.tlis   = y.tlis
                   and y.tlis <> 2);    
            exception
              when others then 
                  lc_listneg:= null;
            end;          
         end;
         
         -- Es Entidad Financiera
          begin
            select 'S'
              into lc_entfin 
              from fsd004 o 
             where o.ifpais = i.pais 
               and o.iftdoc = i.tipodoc
               and o.ifndoc = i.numdoc;
           
         exception 
           when no_data_found then
              lc_entfin := 'N';
           when others then 
              lc_entfin := 'N'; 
              dbms_output.put_line ('EF : '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
         end;             
 
   insert into JAQY501 (JAQY501EMP,JAQY501MOD,JAQY501SUC,JAQY501TRN,JAQY501NREL,JAQY501FCH,JAQY501NOMOPE,
                       JAQY501NROTRAN,JAQY501HMODUL,JAQY501MDA,JAQY501SCNOM,JAQY501DESMDA,JAQY501MONTO,
                       JAQY501ORIGENFON,JAQY501USU,JAQY501PAIS,JAQY501TIPDOC,JAQY501NUMDOC,JAQY501HCTA,
                       JAQY501HOPER,JAQY501HTOPE,JAQY501SUCCUENTA,JAQY501TITULAR,JAQY501NRODOCTRA,
                       JAQY501TDOCTRA,JAQY501TRA,JAQY501TRAMNOCLI,JAQY501PERSBNCPEP,JAQY501HORA,JAQY501EXTORD,
                       JAQY501ENTFIN,JAQY501HSUCUR,JAQY501HPAP,JAQY501HSUBO,JAQY501HMDA)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             i.OPERADOR,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda);                 
    commit;

end loop;  

begin

    INSERT INTO JAQY502(JAQY502EMP,JAQY502MOD,JAQY502SUC,JAQY502TRN,JAQY502NREL,JAQY502FCH,JAQY502NUMTRA,
                        JAQY502NOMOPE,JAQY502SUCCTA,JAQY502SCNOM,JAQY502NUMCTA,JAQY502HCTA,JAQY502TITULAR,
                        JAQY502DESMDA,JAQY502MONTO,JAQY502ORIGENFON,JAQY502TRAM,JAQY502TRAMNOCLI,
                        JAQY502TDOCTRAM,JAQY502NDOCTRAM,JAQY502USU,JAQY502LISTN,JAQY502EJE,JAQY502ANA)
                        
    select o.jaqy501emp,
           o.jaqy501mod,
           o.jaqy501suc,
           o.jaqy501trn,
           o.jaqy501nrel,
           o.jaqy501fch,
           lpad(to_char(o.jaqy501suc),2,'0')||lpad(to_char(o.jaqy501mod),3,'0')||
           lpad(to_char(o.jaqy501trn),3,'0')||lpad(to_char(o.jaqy501nrel),4,'0'),
           o.jaqy501nomope,
           o.jaqy501succuenta,
           o.jaqy501scnom,
           (lpad(to_char(o.jaqy501hcta),9,'0')||lpad(to_char(o.jaqy501hmodul),3,'0')||
           lpad(to_char(o.jaqy501hmda),3,'0')||lpad(to_char(o.jaqy501hoper),9,'0')||
           lpad(to_char(o.jaqy501htope),3,'0')),
           o.jaqy501hcta,
           o.jaqy501titular,
           o.jaqy501desmda,
           o.jaqy501monto,
           o.jaqy501origenfon,
           o.jaqy501tra,
           o.jaqy501tramnocli,
           o.jaqy501tdoctra,
           o.jaqy501nrodoctra,
           o.jaqy501usu,
           o.jaqy501persbncpep,
           pq_ocum_procesos.Fn_Ejecutivo(o.jaqy501hmodul,o.jaqy501pais,o.jaqy501tipdoc,o.jaqy501numdoc,
                                    o.jaqy501hsucur,o.jaqy501hmda,o.jaqy501hcta,O.JAQY501HOPER,
                                    o.jaqy501htope)Ejecutivo,
           pq_ocum_procesos.fn_analista(o.jaqy501hmodul,o.jaqy501pais,o.jaqy501tipdoc,o.jaqy501numdoc,
                                   o.jaqy501hsucur,o.jaqy501hmda,o.jaqy501hcta,O.JAQY501HOPER,
                                   o.jaqy501htope)ANALISTA
    from jaqy501 o;

    COMMIT;
    
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 100;COMMIT;
    end;
end;


end;

Procedure SP_Multiples(Pd_fecpro in date)is

ln_priori number;
lc_lndes  varchar(100);
ln_list   number;
ln_tipcam number :=0;
ln_anio number;
ln_mes number;
ln_mod number(3);
ln_top number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_sucfin number(3);
ln_aosuc  number(3);
lc_age     char(30);
ln_cantpre number(2);

cursor trans_multi (Pd_fecpro in date, ln_tipcam in number) is
--create table repom as 
select DISTINCT bc606pais,bc606tdoc,bc606ndoc,bc606fch,bc606treg,bc606impa,
       (case
              when bc606treg = 100 then 'Tramitante'
              when bc606treg = 200 then 'Beneficiario'
              
        end)Rol,
       (select c.penom from fsd001 c where bc606pais = c.pepais
              and bc606tdoc = c.petdoc
              and bc606ndoc = c.pendoc)NombreCliente,
       (select f.sngc13dir from sngc13 f where f.sngc13pais = bc606pais 
               and bc606tdoc = f.sngc13tdoc
               and bc606ndoc = f.sngc13ndoc
               and f.docod = 1
               and f.sngc13est = 'H')DireccionCliente,
       (select b.dotelfp from fsr005 b where bc606pais = b.pepais 
              and bc606tdoc = b.petdoc 
              and bc606ndoc = b.pendoc
              and rownum = 1) telefonoCliente,
       (select (d.bc602nom||d.bc602ape||d.bc602apem) from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)NombreNoCliente,--Descripcion del cliente que no tiene cuenta en la Caja
       (select d.bc602dire from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)DireccionNoCliente,
       (select d.bc602telr from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)TelefonoNoCliente,
        
        bc607emp,
        bc607mod,
        bc607suc,
        bc607trn,
        bc607nrel,
        bc607fch
        
                     
from (
--sacar la sucursal de mayor monto sin considerar aun las cuentas
      select bc606tdoc,
             bc606pais,
             bc606ndoc,
             bc606fch,
             bc606treg,
             bc606impa,
             bc607emp,
             bc607mod,
             bc607suc,
             bc607trn,
             bc607nrel,
             bc607fch,
             dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa,n_priori order by bc607mod,bc607suc,bc607trn,bc607nrel,bc607fch desc nulls last) n_priori2
        from (select distinct bc606tdoc,
                              bc606pais,
                              bc606ndoc,
                              bc606fch,
                              bc606treg,
                              bc606impa,
                              bc607emp,
                              bc607mod,
                              bc607suc,
                              bc607trn,
                              bc607nrel,
                              bc607fch,
                              dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa order by totapro desc nulls last) n_priori
                        from (select distinct t.bc606pais,
                                              t.bc606tdoc,
                                              t.bc606ndoc,
                                              t.bc606fch,
                                              t.bc606treg,
                                              t.bc606impa,
                                              u.bc607emp,
                                              u.bc607mod,
                                              u.bc607suc,
                                              u.bc607trn,
                                              u.bc607nrel,
                                              u.bc607fch,
                                              round(sum(decode(z.bc604mda, 0, z.bc604impmo /ln_tipcam, z.bc604impmo)), 2) totapro
                                from fbc606 t, fbc607 u,fbc604 z
                               where t.bc606pais = u.bc606pais
                                 and t.bc606tdoc = u.bc606tdoc
                                 and t.bc606ndoc = u.bc606ndoc
                                 and t.bc606fch = u.bc606fch
                                 and t.bc606treg = u.bc606treg
                                 and t.bc606fch = pd_fecpro
                                 and z.bc604emp  = u.bc607emp
                                 and z.bc604mod  = u.bc607mod
                                 and z.bc604suc  = u.bc607suc
                                 and z.bc604trn  = u.bc607trn
                                 and z.bc604nrel = u.bc607nrel
                                 and z.bc604fch  = u.bc607fch
                                
                               group by t.bc606pais,
                                        t.bc606tdoc,
                                        t.bc606ndoc,
                                        t.bc606fch,
                                        t.bc606treg,
                                        bc606impa,
                                        u.bc607emp,
                                        u.bc607mod,
                                        u.bc607suc,
                                        u.bc607trn,
                                        u.bc607nrel,
                                        u.bc607fch))
                        where n_priori = 1)
        Where n_priori2 = 1;

begin

execute immediate ('truncate table JAQY503');
execute immediate ('truncate table JAQY504');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 200;COMMIT;
--ld_fech :=to_date(pd_fecpro,'dd/mm/yy');
ln_anio := to_number(to_char(Pd_fecpro,'yyyy'));
ln_mes := to_number(to_char(Pd_fecpro,'mm'));

begin 
    select tccpa
      into ln_tipcam
      from (select tccpa,
                   tchor,
                   dense_rank() over(partition by tcfch order by tchor desc nulls last) n_priori
              from fsD120
             WHERE TCCOD = 999
               AND TCFCH between to_date('01'||to_char(Pd_fecpro,'mmyyyy'),'ddmmyyyy') and Pd_fecpro
               and tccpa > 0)
     where n_priori = 1;
exception  
  when too_many_rows then
       begin
                     select tccpa
                       into ln_tipcam
                       from (select tccpa,
                                    tchor,
                                    tcfch,
                                    dense_rank() over(partition by tccod,tcmda,tcimp order by tcfch,tchor desc nulls last) n_priori
                               from fsD120
                              WHERE TCCOD = 999
                                AND TCFCH between to_date('01'||to_char(Pd_fecpro,'mmyyyy'),'ddmmyyyy') and Pd_fecpro
                                and tccpa > 0)
                      where n_priori = 1;
       exception
                      when others then 
                           ln_tipcam:=1;
       end;   
  when others then 
       ln_tipcam:=1;
end;
dbms_output.put_line(ln_tipcam);
for i in trans_multi (Pd_fecpro, ln_tipcam) loop
ln_priori  := null;
lc_lndes   := null;
ln_list    := null;
ln_cantpre := 1;
ln_mod     := null;
ln_top     := null;
ln_suc     := null;
ln_mda     := null;
ln_pap     := null;
ln_cta     := null;
ln_ope     := null;
ln_sbo     := null;
ln_sucfin  := null;
ln_aosuc   := null;
lc_age     := null;
       begin
        --Busca los datos del producto
           select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
             from fsh016 f, fsh015  g
            where f.pgcod  = i.bc607emp
              and f.hcmod  = i.bc607mod
              and f.hsucor = i.bc607suc
              and f.htran  = i.bc607trn
              and f.hnrel  = i.bc607nrel
              and f.hfcon  = i.bc607fch
              and f.pgcod  = g.pgcod
              and f.hcmod  = g.hcmod
              and f.hsucor = g.hsucor
              and f.htran  = g.htran
              and f.hnrel  = g.hnrel
              and f.hfcon  = g.hfcon
              and g.hccorr <> 99
              and f.hcta <> 0
              and f.hcodmo = 2
              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
        exception
             
           when too_many_rows then
               begin
                   select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                     into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                 from fsh016 f, fsh015  g
                    where f.pgcod  = i.bc607emp 
                      and f.hcmod  = i.bc607mod  
                      and f.hsucor = i.bc607suc 
                      and f.htran  = i.bc607trn  
                      and f.hnrel  = i.bc607nrel  
                      and f.hfcon  = i.bc607fch  
                      and f.hcta <> 0
                      and f.hcodmo = 2
                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                      and f.pgcod  = g.pgcod
                      and f.hcmod  = g.hcmod
                      and f.hsucor = g.hsucor
                      and f.htran  = g.htran
                      and f.hnrel  = g.hnrel
                      and f.hfcon  = g.hfcon
                      and g.hccorr <> 99;
                  exception
                    when too_many_rows then
                       begin
                       
                             select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                               into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo     
                                 
                              from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                               dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                              
                             from fsh016 f, fsh015  g
                                where f.pgcod  = i.bc607emp
                                  and f.hcmod  = i.bc607mod 
                                  and f.hsucor = i.bc607suc
                                  and f.htran  = i.bc607trn 
                                  and f.hnrel  = i.bc607nrel 
                                  and f.hfcon  = i.bc607fch
                                  and f.pgcod  = g.pgcod
                                  and f.hcmod  = g.hcmod
                                  and f.hsucor = g.hsucor
                                  and f.htran  = g.htran
                                  and f.hnrel  = g.hnrel
                                  and f.hfcon  = g.hfcon
                                  and g.hccorr <> 99 
                                  and f.hcta <> 0
                                  and f.hcodmo = 2
                                  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                            where n_priori = 1
                            ;
                        exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 1.1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                                       
                                      select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                                       from fsh016 f, fsh015  g
                                      where f.pgcod  = i.bc607emp
                                        and f.hcmod  = i.bc607mod
                                        and f.hsucor = i.bc607suc
                                        and f.htran  = i.bc607trn
                                        and f.hnrel  = i.bc607nrel
                                        and f.hfcon  = i.bc607fch
                                        and f.hcta <> 0
                                        and f.hcodmo = 2
                                      --  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                                        and f.hcsubo = (select min(ff.hcsubo)
                                                          from fsh016 ff
                                                         where ff.pgcod  = f.pgcod 
                                                           and ff.hcmod  = f.hcmod 
                                                           and ff.hsucor = f.hsucor
                                                           and ff.htran  = f.htran 
                                                           and ff.hnrel  = f.hnrel 
                                                           and ff.hfcon  = f.hfcon 
                                                           and ff.hcord  = f.hcord)
                                        and f.pgcod  = g.pgcod
                                        and f.hcmod  = g.hcmod
                                        and f.hsucor = g.hsucor
                                        and f.htran  = g.htran
                                        and f.hnrel  = g.hnrel
                                        and f.hfcon  = g.hfcon
                                        and g.hccorr <> 99;
                         
                         exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);  
                         end;
                    
                                   
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                   from fsh016 f, fsh015  g
                      where f.pgcod  = i.bc607emp 
                        and f.hcmod  = i.bc607mod  
                        and f.hsucor = i.bc607suc 
                        and f.htran  = i.bc607trn  
                        and f.hnrel  = i.bc607nrel  
                        and f.hfcon  = i.bc607fch  
                        and f.pgcod  = g.pgcod
                        and f.hcmod  = g.hcmod
                        and f.hsucor = g.hsucor
                        and f.htran  = g.htran
                        and f.hnrel  = g.hnrel
                        and f.hfcon  = g.hfcon
                        and g.hccorr <> 99
                        and f.hcta <> 0
                        and f.hcodmo = 2;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct f.hmodul,htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo
                       from fsh016 f, fsh015  g 
                          where f.pgcod  = i.bc607emp 
                            and f.hcmod  = i.bc607mod  
                            and f.hsucor = i.bc607suc 
                            and f.htran  = i.bc607trn  
                            and f.hnrel  = i.bc607nrel  
                            and f.hfcon  = i.bc607fch  
                            and f.pgcod  = g.pgcod
                            and f.hcmod  = g.hcmod
                            and f.hsucor = g.hsucor
                            and f.htran  = g.htran
                            and f.hnrel  = g.hnrel
                            and f.hfcon  = g.hfcon
                            and g.hccorr <> 99
                            and f.hcta <> 0
                            and f.hcodmo = 2
                            and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo      
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                  where f.pgcod  = i.bc607emp 
                                    and f.hcmod  = i.bc607mod  
                                    and f.hsucor = i.bc607suc 
                                    and f.htran  = i.bc607trn  
                                    and f.hnrel  = i.bc607nrel  
                                    and f.hfcon  = i.bc607fch 
                                    and f.pgcod  = g.pgcod
                                    and f.hcmod  = g.hcmod
                                    and f.hsucor = g.hsucor
                                    and f.htran  = g.htran
                                    and f.hnrel  = g.hnrel
                                    and f.hfcon  = g.hfcon
                                    and g.hccorr <> 99 
                                    and f.hcta <> 0
                                    and f.hcodmo = 2)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                  end ;
                             --null;
                             /*dbms_output.put_line ('no data1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                            ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );  */
                     end;
                 when no_data_found then
                      begin
                        select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                          into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                         from fsh016 f, fsh015  g
                            where f.pgcod  = i.bc607emp 
                              and f.hcmod  = i.bc607mod  
                              and f.hsucor = i.bc607suc 
                              and f.htran  = i.bc607trn  
                              and f.hnrel  = i.bc607nrel  
                              and f.hfcon  = i.bc607fch  
                              and f.pgcod  = g.pgcod
                              and f.hcmod  = g.hcmod
                              and f.hsucor = g.hsucor
                              and f.htran  = g.htran
                              and f.hnrel  = g.hnrel
                              and f.hfcon  = g.hfcon
                              and g.hccorr <> 99
                              and f.hcta <> 0
                              and f.hcodmo = 2
                              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo 
                                 from fsh016 f , fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod 
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn 
                                      and f.hnrel  = i.bc607nrel 
                                      and f.hfcon  = i.bc607fch 
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0
                                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo    
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn
                                      and f.hnrel  = i.bc607nrel
                                      and f.hfcon  = i.bc607fch
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       begin
                       
                                           select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                             into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo    
                                               
                                            from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                             dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                            
                                           from fsh016 f, fsh015  g
                                              where f.pgcod  = i.bc607emp
                                                and f.hcmod  = i.bc607mod
                                                and f.hsucor = i.bc607suc
                                                and f.htran  = i.bc607trn
                                                and f.hnrel  = i.bc607nrel
                                                and f.hfcon  = i.bc607fch
                                                and f.pgcod  = g.pgcod
                                                and f.hcmod  = g.hcmod
                                                and f.hsucor = g.hsucor
                                                and f.htran  = g.htran
                                                and f.hnrel  = g.hnrel
                                                and f.hfcon  = g.hfcon
                                                and g.hccorr <> 99)
                                        where n_priori = 1
                                                ;
                                            exception
                                              when too_many_rows then
                                                 dbms_output.put_line ('mas de 44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                              
                                              when no_data_found then 
                                                 dbms_output.put_line ('nohaydata44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                            end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                                                     
                                  end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                             end;       
                     end;       
               end;       
        end;
        
        
       begin
            select y.tlis, y.prioridad, y.tlisde
              into ln_list,ln_priori,lc_lndes 
              from fsd201 x, LN_Priori  y 
             where x.lntdoc = i.BC606TDOC
               and x.lnndoc = i.BC606NDOC
               and x.tlis   = y.tlis
               and y.tlis <> 2;
         exception 
           when no_data_found then
              lc_lndes:= null;
           when others then 
            begin 
                select tlis, prioridad, tlisde
                  into ln_list,ln_priori,lc_lndes 
                  from LN_Priori where prioridad = (
                 select min(y.prioridad)
                  from fsd201 x, LN_Priori  y 
                 where x.lntdoc = i.BC606TDOC
                   and x.lnndoc = i.BC606NDOC
                   and x.tlis   = y.tlis
                   and y.tlis <> 2);    
            exception
              when others then 
                  lc_lndes:= null;
            end;          
         end;
                             
         --Agencia
         
         Begin
         
            select scnom
              into lc_age
              from fst001
             where pgcod = 1 
             and sucurs = ln_suc;
         exception 
             when others then null;
         end;
   begin
   insert into JAQY503 (JAQY503TDOC,JAQY503NDOC,JAQY503FCH,JAQY503TREG,JAQY503IMPA,JAQY503NOMCLI,
                      JAQY503ROL,JAQY503DIRCLI,JAQY503TELCLI,JAQY503NOMNOCLI,JAQY503DIRNOCLI,
                      JAQY503TELNOCLI,JAQY503MONTO,JAQY503AGENCIA,JAQY503NROLIST,JAQY503PRIORI,
                      JAQY503LISTDES,JAQY503ANOPRO,JAQY503MESPRO,JAQY503HMODUL,JAQY503HTOPER,
                      JAQY503HMDA,JAQY503HPAP,JAQY503HCTA,JAQY503HOPER,JAQY503HSUBOP,JAQY503HSUCUR,
                      JAQY503PAIS)
      values(i.BC606TDOC,i.BC606NDOC,i.BC606FCH,i.BC606TREG,i.BC606IMPA,i.NOMBRECLIENTE,i.ROL,i.DIRECCIONCLIENTE,
             i.TELEFONOCLIENTE,i.NOMBRENOCLIENTE,i.DIRECCIONNOCLIENTE,i.TELEFONONOCLIENTE,i.bc606impa,lc_age,
             ln_list,ln_priori,lc_lndes,ln_anio, ln_mes,ln_mod,ln_top,ln_mda,ln_pap,ln_cta,ln_ope,
             ln_sbo,ln_suc,i.bc606pais);                 
    commit;
    exception
      when others then
        dbms_output.put_line(i.BC606NDOC);
    end; 
end loop;  

Begin

INSERT INTO JAQY504(JAQY504ANOPRO,JAQY504MESPRO,JAQY504NOMCLI,JAQY504ROL,JAQY504DIRCLI,JAQY504TELCLI,
                    JAQY504NOMNOCLI,JAQY504DIRNOCLI,JAQY504TELNOCLI,JAQY504MONTO,JAQY504AGENCIA,
                    JAQY504LISTDES,JAQY504EJE,JAQY504ANA,JAQY504FCH,JAQY504HSUCUR)
       select ja3.jaqy503anopro,
              pq_ocum_procesos.fn_meses(ja3.jaqy503mespro),
              ja3.jaqy503nomcli,
              ja3.jaqy503rol,
              ja3.jaqy503dircli,
              ja3.jaqy503telcli,
              ja3.jaqy503nomnocli,
              ja3.jaqy503dirnocli,
              ja3.jaqy503telnocli,
              ja3.jaqy503monto,
              ja3.jaqy503agencia,
              ja3.jaqy503listdes,
              pq_ocum_procesos.Fn_Ejecutivo(JA3.JAQY503HMODUL,ja3.jaqy503pais,ja3.jaqy503tdoc,ja3.jaqy503ndoc,
                                       ja3.jaqy503hsucur,ja3.jaqy503hmda,ja3.jaqy503hcta,ja3.jaqy503hoper,
                                       ja3.jaqy503htoper),
              pq_ocum_procesos.fn_analista(JA3.JAQY503HMODUL,ja3.jaqy503pais,ja3.jaqy503tdoc,ja3.jaqy503ndoc,
                                       ja3.jaqy503hsucur,ja3.jaqy503hmda,ja3.jaqy503hcta,ja3.jaqy503hoper,
                                       ja3.jaqy503htoper),
              ja3.jaqy503fch,
              ja3.jaqy503hsucur
         from JAQY503 ja3;
         
         
     COMMIT;
       
       
end;
begin
    update jaqy500 set jaqy500flg = 0 where jaqy500cod = 200;COMMIT;
end;


end;

function fn_meses (pn_mes in char) return varchar2 is
lc_mes varchar2(20);
begin
  begin
       if pn_mes = '1' then
          lc_mes := 'ENERO';
       End If;
       if pn_mes = '2' then
          lc_mes := 'FEBRERO';
       End If;
       if pn_mes = '3' then
          lc_mes := 'MARZO';
       End If;
       if pn_mes = '4' then
          lc_mes := 'ABRIL';
       End If;
       if pn_mes = '5' then
          lc_mes := 'MAYO';
       End If;
       if pn_mes = '6' then
          lc_mes := 'JUNIO';
       End If;
       if pn_mes = '7' then
          lc_mes := 'JULIO';
       End If;
       if pn_mes = '8' then
          lc_mes := 'AGOSTO';
       End If;
       if pn_mes = '9' then
          lc_mes := 'SETIEMBRE';
       End If;
       if pn_mes = '10' then
          lc_mes := 'OCTUBRE';
       End If;
       if pn_mes = '11' then
          lc_mes := 'NOVIEMBRE';
       End If;
       if pn_mes = '12' then
          lc_mes := 'DICIEMBRE';
       End If;
       
         
    
  exception 
      when others then
           lc_mes := null;
       
      
  end;   
    
   return lc_mes;
end fn_meses;

Function Fn_Ejecutivo (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                       pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) 
return char
IS


lc_user      char(10);
lc_flag      char(5);
ln_sbop      number(5);
ln_instancia number(20);

Begin

    --if pn_mod in(21,22) then
           
         begin
         
             select a.jaql61user
               into lc_user
               from jaql061 a
              where a.jaql61pgco = 1
                and a.jaql61pais = pn_pais
                and a.jaql61tdoc = pn_tdoc
                and a.jaql61ndoc = pc_ndoc
                and a.jaql61esta = 'S';
          exception 
                when others then
                      lc_user:=null;
          end; 
    --end if; 
    if lc_user is null then
        Begin
             select 'S',b.aosbop 
               into lc_flag,ln_sbop
               from fsd010 b
              where b.pgcod  = 1
                and b.aomod  = pn_mod
                and b.aosuc  = pn_suc
                and b.aomda  = pn_mda
                and b.aopap  = 0
                and b.aocta  = pn_cta
                and b.aooper = pn_oper
                and b.aotope = pn_top
                and b.aostat <> 99;
          exception
                when others then
                     lc_flag := 'N';
          end; 
          
          ln_instancia := fn_instancia_credito(pn_mod,pn_suc,pn_mda,0,pn_cta,pn_oper,ln_sbop,pn_top);
          
                    
          if lc_flag = 'S' then
          
             begin 
               select c.sng001ase
                 into lc_user 
                 from sng001 c
                where c.sng001emp = 1
                  --and c.sng001cta  = pn_cta
                  and c.sng001inst = ln_instancia
                  /*and rownum = 1*/;
             exception     
             when others then
                  lc_user := null;
             end;
             
          end if;
       
    
    
    end if;
    
          
    return lc_user;

end Fn_Ejecutivo;

Function fn_analista (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char 

IS

--lc_user char(20);
lc_flag char(5);
ln_sbop number(5);
ln_instancia number(20);
lc_analista char(10);
ln_mod       number(5); 
ln_suc       number(5);
ln_mda       number(5);
ln_pap       number(5);
ln_cta       number(12);
ln_oper      number(12);
ln_tope      number(5);

Begin

    if /*lc_user is null and*/ pn_cta <> 0 then
        Begin
             select 'S',b.aosbop 
               into lc_flag,ln_sbop
               from fsd010 b
              where b.pgcod  = 1
                and b.aomod  = pn_mod
                and b.aosuc  = pn_suc
                and b.aomda  = pn_mda
                and b.aopap  = 0
                and b.aocta  = pn_cta
                and b.aooper = pn_oper
                and b.aotope = pn_top
                and b.aostat <> 99
                and rownum = 1;
          exception
                when no_data_found then
                     Begin
                       select 'S',b.aosbop 
                         into lc_flag,ln_sbop
                         from fsd010 b
                        where b.pgcod  = 1
                          and b.aomod  = pn_mod
                          and b.aosuc  = pn_suc
                          and b.aomda  = pn_mda
                          and b.aopap  = 0
                          and b.aocta  = pn_cta
                          and b.aooper = pn_oper
                          and b.aotope = pn_top
                          and rownum = 1;
                    exception
                          when others then
                               lc_flag := 'N';
                    end;
          end; 
          
          ln_instancia := fn_instancia_credito(pn_mod,pn_suc,pn_mda,0,pn_cta,pn_oper,ln_sbop,pn_top);
          
                    
          if lc_flag = 'S' then
          
             begin 
               select c.sng001ase
                 into lc_analista 
                 from sng001 c
                where c.sng001emp = 1
                  --and c.sng001cta  = pn_cta
                  and c.sng001inst = ln_instancia
                  /*and rownum = 1*/;
             exception     
             when others then
                  lc_analista := null;
             end;
             
          end if;
       
          else
              Begin
                 select 'S',b.aomod,b.aosuc,b.aomda,b.aopap,b.aocta,b.aooper,b.aosbop,b.aotope 
                   into lc_flag,ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope
                   from fsd010 b,fsr008 h
                  where h.pgcod  = 1
                    and h.pepais = pn_pais
                    and h.petdoc = pn_tdoc
                    and h.pendoc = pc_ndoc
                    and b.pgcod  = 1
                    and b.aocta  = h.ctnro
                    and h.pgcod = 1
                    and h.cttfir = 'T'
                    and b.aomod  in (select modulo from fst111 f where f.dscod = 50)
                    and rownum   = 1;
              exception
                   when others then
                        lc_flag := 'N';
                   
              end; 
              
              ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,ln_pap,ln_cta,ln_oper,ln_sbop,ln_tope);
          
                    
              if lc_flag = 'S' then
              
                 begin 
                   select c.sng001ase
                     into lc_analista 
                     from sng001 c
                    where c.sng001emp = 1
                      --and c.sng001cta  = pn_cta
                      and c.sng001inst = ln_instancia
                      /*and rownum = 1*/;
                 exception     
                 when others then
                      lc_analista := null;
                 end;
                 
              end if;
        
    end if;
    return lc_analista;
end fn_analista;

Procedure SP_OCUM_CANCADL(PD_FECINI IN DATE, PD_FECFIN IN DATE) IS


BEGIN

execute immediate ('truncate table JAQY509');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 300;COMMIT;

       Begin
       
       INSERT INTO jaqy509 (JAQY509EMP,JAQY509HSUCOR,JAQY509PENOM,JAQY509HMDA,JAQY509HMODUL,
                            JAQY509NROCRED,JAQY509AOFVAL,JAQY509AOFVTO,JAQY509HFCON,JAQY509AOIMP,
                            JAQY509HCIMP1,JAQY509SCNOM,JAQY509MDNOM)
       select PGCOD,
              HSUCOR,
              PENOM,
              HMDA,
              HMODUL,
              Nro_Credito,
              fecha_desembolso,
              fecha_vcto,
              fecha_canc,
              monto_desembolsado,
              monto_ult_pago,
              agencia,
              MDNOM
       
        from(
              select /*+parallel(s,2)*/
                     R.PGCOD,
                     (select a.scnom from fst001 a where a.PGCOD = r.PGCOD and a.SUCURS = r.HSUCOR) agencia,
                     R.HMODUL,
                     r.HCMOD,
                     r.HSUCOR,
                     r.HTRAN,
                     r.HNREL,
                     r.HFCON fecha_canc,
                     r.HCTA,
                     r.HCIMP1 monto_ult_pago,
                     r.HCORD,
                     s.AOFVAL fecha_desembolso,
                     s.AOFVTO fecha_vcto,
                     s.AOIMP monto_desembolsado,
                     u.MDNOM,
                     (lpad(to_char(r.HCTA), 9, '0') || lpad(to_char(r.HMODUL), 3, '0') ||
                     lpad(to_char(r.HMDA), 3, '0') || lpad(to_char(r.HOPER), 9, '0') ||
                     lpad(to_char(r.HTOPER), 3, '0')) Nro_Credito,
                     w.PENOM,
                     r.HMDA,
                     --(select u.MDNOM from fst003 u where u.MODULO = r.HMODUL),
                     dense_rank() over(partition by r.HCMOD,r.HSUCOR,r.HTRAN,r.HNREL,r.HFCON order by r.HCORD asc nulls last) n_priori
                      from fsh016 r, fsd010 s,fst003 u,fsr008 v, fsd001 w
                   where r.HCMOD = 30 
                     and r.HTRAN = 150 
                     and r.HFCON between PD_FECINI and PD_FECFIN
                     and r.PGCOD  = s.PGCOD  --(+)
                     and r.HMODUL = s.AOMOD  --(+)
                     and r.HSUCUR = s.AOSUC  --(+)
                     and r.HMDA   = s.AOMDA  --(+)
                     and r.HPAP   = s.AOPAP  --(+)
                     and r.HCTA   = s.AOCTA  --(+)
                     and r.HOPER  = s.AOOPER --(+)
                     and r.HSUBOP = s.AOSBOP --(+)
                     and r.HTOPER = s.AOTOPE
                     and r.HMODUL = u.MODULO (+)
                     and r.PGCOD  = v.PGCOD
                     and r.HCTA   = v.CTNRO
                     and v.pgcod = 1
                     and v.CTTFIR = 'T'
                     and v.TTCOD  = 1
                     and v.PEPAIS = w.PEPAIS
                     and v.PETDOC = w.PETDOC
                     and v.PENDOC = w.PENDOC
                     and r.HFCON  < s.AOFVTO                                                            
                     
                     
              order by 1,2,3,4,5)
              where n_priori = 1;
       
       COMMIT;
    
       begin
           update jaqy500 set jaqy500flg = 0 where jaqy500cod = 300;COMMIT;
       end;
       end;
END SP_OCUM_CANCADL;


Procedure SP_Ocum_OpeExtr(pd_fecini in date,pd_fecfin in date) is

cursor ope_extrj (pd_fecini in date, pd_fecfin in date) is

--create table repext as 
select t.jaqy254pgctr,
       t.jaqy254suctr,
       t.jaqy254modtr,
       t.jaqy254codtr,
       t.jaqy254reltr,
       t.jaqy254fetra,
       t.jaqy254feneg,
       t.jaqy254feini,
       t.jaqy254fefin,
       t.jaqy254comsg,
       t.jaqy254cotra trac,
       t.jaqy254nutar tarjeta,
       t.jaqy254fetra fecha,
       t.JAQY254HOFIN hora,
       case
            when t.jaqy254codtr in (16,0) then 'RETIRO' 
            when t.jaqy254codtr = 50      then 'COMPRAS'
       end operacion,
       t.jaqy254moned moneda_trx,
       t.jaqy254imdeb monto_trx,
       case
            when t.jaqy254comsg = '00' then t.jaqy254ubtra
            else ''
       end lugar,
       case
            when t.jaqy254comsg = '00' then 'NORMAL'
            else 'RECHAZADA'
       end estado,
       case
            when t.jaqy254comsg <> '00' then (select y.descripcion from atm_error y where y.jaqy254comsg = t.jaqy254comsg)
            else ''
       end motivo_rechazo
   from jaqy254 t 
 where jaqy254titra not in (34)  and jaqy254cored in (5,2) and jaqy254codtr in (16,0,50) and jaqy254moned=101
 and t.jaqy254comsg = '00'
 and t.jaqy254fetra between pd_fecini and pd_fecfin

;


ln_cta number;
ln_oper number;
ln_toper number;
ln_mod  number;
ln_mda number; 
lc_titular varchar2(200);
ln_pais number;
ln_tdoc number;
lc_numdoc fsd001.pendoc%type;
ln_variable1 number;
ln_variable2 number;
ln_importe number(17,2);
lc_operacion varchar2(30);

begin

ln_variable1 := 16;
ln_variable2 := 50;
execute immediate ('truncate table JAQY510');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 400;COMMIT;
for i in ope_extrj (pd_fecini, pd_fecfin) loop
ln_cta        := null;
ln_oper       := null;
ln_toper      := null;
ln_mod        := null;
ln_mda        := null;
lc_titular    := null;
ln_pais       := null;
ln_tdoc       := null;
lc_numdoc     := null;
ln_importe    := null;
lc_operacion  := null;


       begin 
           select /*+index(C FSH01600)*/ distinct c.hcta, c.hoper, c.htoper, c.hmodul, c.hmda,--2023.02.08
                  e.pepais ,e.petdoc ,e.pendoc, c.hcimp1,
                  case
                      when c.htran = 16   then 'RETIRO' 
                      when c.htran = 50   then 'COMPRAS'
                  end operacion    
            into ln_cta, ln_oper, ln_toper, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_importe, lc_operacion
           from fsh016 c, fsr008 e
              where c.pgcod  = i.jaqy254pgctr  
                and c.hcmod  = i.jaqy254modtr   
                and c.hsucor = i.jaqy254suctr 
                and c.htran  = i.jaqy254codtr   
                and c.hnrel  = i.jaqy254reltr   
                and c.hfcon  = i.jaqy254feini 
                and hcta <> 0
                and e.pgcod = 1
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and i.jaqy254comsg = '00'
                and c.hcord  = pq_ocum_procesos.fn_ordinal(i.jaqy254pgctr,i.jaqy254modtr,i.jaqy254suctr,i.jaqy254codtr,
                                                           i.jaqy254reltr,i.jaqy254feini);
         exception
           when no_data_found then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc, c.hcimp1 ,
                        case
                           when c.htran = 16   then 'RETIRO' 
                           when c.htran = 50   then 'COMPRAS'
                        end operacion       
                  into ln_cta, ln_oper, ln_toper, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_importe, lc_operacion
                 from fsh016 c, fsr008 e
                    where c.pgcod  = 1  
                      and c.hcmod  = 66   
                      and c.hsucor = 903 
                      and c.htran  in (16,50)    
                      --and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.jaqy254feini
                      and c.hcimp1 = i.monto_trx
                      and c.hcord  = pq_ocum_procesos.fn_ordinal_sin_relacion(1,66,903, ln_variable1,ln_variable2,i.jaqy254feini)  
                      and hcta <> 0
                      and e.pgcod = 1
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and i.jaqy254comsg = '00';
                      
                  exception
                    when too_many_rows then
                       dbms_output.put_line ('mas de 1: '||i.jaqy254fetra||'-'||i.monto_trx);
                    when no_data_found then
                       null;
                  end ;
           when too_many_rows then
               null;
               
         end;  
         begin
              select j.penom 
                into lc_titular
                from fsd001 j 
               where j.pepais = ln_pais 
                 and j.petdoc = ln_tdoc
                 and j.pendoc = lc_numdoc;
         exception
            when others then 
                  lc_titular := null;  
         end;
         
  --if lc_entfin = 'N' then 
   insert into JAQY510 (JAQY510pgctr,JAQY510suctr,JAQY510modtr,JAQY510codtr,JAQY510reltr,JAQY510fetra,JAQY510feneg,
                       JAQY510feini,JAQY510fefin,JAQY510comsg,JAQY510trac,JAQY510tarj,JAQY510fec,JAQY510hora,
                       JAQY510nomoper,JAQY510mdatrx,JAQY510mtotrx,JAQY510lugar,JAQY510estado,JAQY510motrechazo,
                       JAQY510cta,JAQY510oper,JAQY510toper,JAQY510modul,JAQY510mda,JAQY510pepais,JAQY510petdoc,
                       JAQY510pendoc,JAQY510imp1,JAQY510penom,JAQY510operh16,JAQY510NUMCTA)
      values(i.jaqy254pgctr,i.jaqy254suctr,i.jaqy254modtr,i.jaqy254codtr,i.jaqy254reltr,i.jaqy254fetra,i.jaqy254feneg,
             i.jaqy254feini,i.jaqy254fefin,i.jaqy254comsg,i.trac,i.tarjeta,i.fecha,i.hora,i.operacion,i.moneda_trx,
             i.monto_trx,i.lugar,i.estado,i.motivo_rechazo,ln_cta, ln_oper, ln_toper, ln_mod, ln_mda,ln_pais, ln_tdoc, 
             lc_numdoc,ln_importe,lc_titular,lc_operacion,(lpad(to_char(ln_cta), 9, '0')||lpad(to_char(ln_mod), 3, '0')||
             lpad(to_char(ln_mda), 3, '0')||lpad(to_char(ln_oper), 9, '0') || lpad(to_char(ln_toper), 3, '0')));                 
    commit;
  --end if;  
end loop; 

begin
     update jaqy500 set jaqy500flg = 0 where jaqy500cod = 400;COMMIT;
end; 
end;


function fn_ordinal_sin_relacion (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn1 in number,
                                  pn_trn2 in number,pd_fec in date) return number is
ln_ordinal number;
ln_mod number;
ln_sucor number;
ln_tran number;
ln_nrel number;
ld_hfcon date;
begin
  begin
    select y.HCMOD,
           y.HSUCOR,
           y.HTRAN,
           y.HNREL,
           y.HFCON,
           min(y.HCORD)
        into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
        from fsh016 y 
      where y.PGCOD  = pn_emp
        and y.HCMOD  = pn_mod
        and y.HSUCOR =  pn_suc
        and y.HTRAN  in (pn_trn1 ,pn_trn2)
        --and y.HNREL  = pn_nrel
        and y.HFCON  = pd_fec
      group by y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON;
  exception 
      when no_data_found then 
          ln_ordinal := null;
          
      when too_many_rows then
      
      begin
             select y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON,
               min(y.HCORD)
            into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
            from fsh016 y 
          where y.PGCOD  = pn_emp
            and y.HCMOD  = pn_mod
            and y.HSUCOR =  pn_suc
            and y.HTRAN  in (pn_trn1 , pn_trn2)
            --and y.HNREL  = pn_nrel
            and y.HFCON  = pd_fec
            and rownum   = 1
          group by y.HCMOD,
                   y.HSUCOR,
                   y.HTRAN,
                   y.HNREL,
                   y.HFCON;
      exception
          when others then
               ln_ordinal := null;
     end;
  end;   
   return ln_ordinal;
end fn_ordinal_sin_relacion;


function fn_ordinal (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn in number,
                     pn_nrel in number, pd_fec in date) return number is
ln_ordinal number;
ln_mod number;
ln_sucor number;
ln_tran number;
ln_nrel number;
ld_hfcon date;
begin
  begin
    select y.HCMOD,
           y.HSUCOR,
           y.HTRAN,
           y.HNREL,
           y.HFCON,
           min(y.HCORD)
        into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
        from fsh016 y 
      where y.PGCOD  = pn_emp
        and y.HCMOD  = pn_mod
        and y.HSUCOR =  pn_suc
        and y.HTRAN  = pn_trn 
        and y.HNREL  = pn_nrel
        and y.HFCON  = pd_fec
      group by y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON;
  exception 
      when no_data_found then 
          ln_ordinal := null;
          
      when too_many_rows then
         ln_ordinal := null;
  end;   
   return ln_ordinal;
end fn_ordinal;


Procedure SP_Ocum_SinCredVig(Pd_fecini in date,Pd_fecfin in date) is

ln_cta number;
ln_oper number;
ln_toper number;
lc_suc  varchar(100);
ln_mod  number;
ln_mda number; 
lc_titular repoue.titular%type;
ln_pais number;
ln_tdoc number;
lc_numdoc fsd001.pendoc%type;
lc_existe varchar(1);
lc_listneg fst501.tlisde%type;
lc_entfin varchar(1);
ln_suc number;
ln_pap number;
ln_sbop number;
ln_pri number;
ln_sux number;

ln_priori number;
lc_lndes  varchar(100);
ln_list   number;
ln_tipcam number :=0;
ln_anio number;
ln_mes number;
ln_mod_mul number(3);
ln_suc_mul number(3);
ln_mda_mul number(4);
ln_pap_mul number(4);
ln_cta_mul number(9);
ln_top number(3);
ln_ope number(9);
ln_sbo number(3);
ln_sucfin number(3);
ln_aosuc  number(3);
lc_age     char(30);
ln_cantpre number(2);

cursor tues (Pd_fecini in date, Pd_fecfin in date) is
--create table repoue as 
select  /*+all_rows*/
        a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod, 
        b.hfcon,
        b.hcmod , 
        b.hsucor, 
        b.htran, 
        b.hnrel, 
        f.trnom Nomoperacion, 
       (a.bc604suc||a.bc604mod||a.bc604trn||a.bc604nrel) NroTransaccion,
        a.bc604mod ModuloOperacion,
        a.bc604mda MdaOperacion,
        i.scnom AgenciaOperacion,
        CASE
                when a.bc604mda = 0 then 'S/.'
                when a.bc604mda = 101 then '$'
        END MdaTransaccion,
        a.bc604impmo Monto,
        a.bc604oefe origendefondos,
        a.bc604fch Fecha,
        a.bc604usid Operador,
        (select l.bc605pais 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )Pais,
        (select l.bc605tdoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )TipoDoc,
        (select l.bc605ndoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg between 300 and  399 
            and rownum = 1
        )numdoc,
        (select l.bc605ndoc 
           from fbc605 l 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
        )NroDnitramitante,
        (select m.tdnom 
           from fbc605 l,fst014 m 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and l.bc605tdoc     = m.tdocum
        )TDocumento,
        (select n.penom 
           from fbc605 l,fsd001 n 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and l.bc605ndoc     = n.pendoc
        )Tramitante,
        (select (trim(o.bc602nom)||trim(o.bc602ape)||trim(o.bc602apem)) 
           from fbc605 l,fbc602 o 
          where a.BC604EMP      = l.BC604EMP
            and a.BC604MOD      = l.BC604MOD
            and a.BC604SUC      = l.BC604SUC
            and a.BC604TRN      = l.BC604TRN
            and a.BC604NREL     = l.BC604NREL
            and a.BC604FCH      = l.BC604FCH
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1
            and l.bc605tdoc     = o.bc602tdoc
            and l.bc605ndoc     = o.bc602ndoc
        )TramitanteNoCliente
  from fbc604 a, 
       fsh015 b,
       fst034 f,
       fst001 i
 where a.bc604co     ='S' 
   and a.bc604fch      between Pd_fecini and Pd_fecfin
   and a.bc604emp      =1 
   and a.BC604EMP      = b.pgcod
   and a.BC604MOD      = b.hcmod
   and a.BC604SUC      = b.hsucor
   and a.BC604TRN      = b.htran
   and a.BC604NREL     = b.hnrel
   and a.BC604FCH      = b.hfcon
   and a.BC604TTrn     in (2,3)
   and a.bc604emp      = f.pgcod
   and a.bc604mod      = f.trmod
   and a.bc604trn      = f.trnro
   and a.bc604emp      = i.pgcod
   and a.bc604suc      = i.sucurs
   and b.hccorr        <> 99;


cursor trans_multi (Pd_fecfin in date, ln_tipcam in number) is
--create table repom as 
select DISTINCT bc606pais,bc606tdoc,bc606ndoc,bc606fch,bc606treg,bc606impa,
       (case
              when bc606treg = 100 then 'Tramitante'
              when bc606treg = 200 then 'Beneficiario'
              
        end)Rol,
       (select c.penom from fsd001 c where bc606pais = c.pepais
              and bc606tdoc = c.petdoc
              and bc606ndoc = c.pendoc)NombreCliente,
       (select f.sngc13dir from sngc13 f where f.sngc13pais = bc606pais 
               and bc606tdoc = f.sngc13tdoc
               and bc606ndoc = f.sngc13ndoc
               and f.docod = 1
               and f.sngc13est = 'H')DireccionCliente,
       (select b.dotelfp from fsr005 b where bc606pais = b.pepais 
              and bc606tdoc = b.petdoc 
              and bc606ndoc = b.pendoc
              and rownum = 1) telefonoCliente,
       (select (d.bc602nom||d.bc602ape||d.bc602apem) from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)NombreNoCliente,--Descripcion del cliente que no tiene cuenta en la Caja
       (select d.bc602dire from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)DireccionNoCliente,
       (select d.bc602telr from fbc602 d where bc606pais = d.bc602pais
               and bc606tdoc = d.bc602tdoc 
               and bc606ndoc = d.bc602ndoc)TelefonoNoCliente,
        
        bc607emp,
        bc607mod,
        bc607suc,
        bc607trn,
        bc607nrel,
        bc607fch
        
                     
from (
--sacar la sucursal de mayor monto sin considerar aun las cuentas
      select bc606tdoc,
             bc606pais,
             bc606ndoc,
             bc606fch,
             bc606treg,
             bc606impa,
             bc607emp,
             bc607mod,
             bc607suc,
             bc607trn,
             bc607nrel,
             bc607fch,
             dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa,n_priori order by bc607mod,bc607suc,bc607trn,bc607nrel,bc607fch desc nulls last) n_priori2
        from (select distinct bc606tdoc,
                              bc606pais,
                              bc606ndoc,
                              bc606fch,
                              bc606treg,
                              bc606impa,
                              bc607emp,
                              bc607mod,
                              bc607suc,
                              bc607trn,
                              bc607nrel,
                              bc607fch,
                              dense_rank() over(partition by bc606tdoc, bc606ndoc, bc606fch, bc606treg, bc606impa order by totapro desc nulls last) n_priori
                        from (select distinct t.bc606pais,
                                              t.bc606tdoc,
                                              t.bc606ndoc,
                                              t.bc606fch,
                                              t.bc606treg,
                                              t.bc606impa,
                                              u.bc607emp,
                                              u.bc607mod,
                                              u.bc607suc,
                                              u.bc607trn,
                                              u.bc607nrel,
                                              u.bc607fch,
                                              round(sum(decode(z.bc604mda, 0, z.bc604impmo /ln_tipcam, z.bc604impmo)), 2) totapro
                                from fbc606 t, fbc607 u,fbc604 z
                               where t.bc606pais = u.bc606pais
                                 and t.bc606tdoc = u.bc606tdoc
                                 and t.bc606ndoc = u.bc606ndoc
                                 and t.bc606fch = u.bc606fch
                                 and t.bc606treg = u.bc606treg
                                 and t.bc606fch = Pd_fecfin
                                 and z.bc604emp  = u.bc607emp
                                 and z.bc604mod  = u.bc607mod
                                 and z.bc604suc  = u.bc607suc
                                 and z.bc604trn  = u.bc607trn
                                 and z.bc604nrel = u.bc607nrel
                                 and z.bc604fch  = u.bc607fch
                                
                               group by t.bc606pais,
                                        t.bc606tdoc,
                                        t.bc606ndoc,
                                        t.bc606fch,
                                        t.bc606treg,
                                        bc606impa,
                                        u.bc607emp,
                                        u.bc607mod,
                                        u.bc607suc,
                                        u.bc607trn,
                                        u.bc607nrel,
                                        u.bc607fch))
                        where n_priori = 1)
        Where n_priori2 = 1;   
   
begin

execute immediate ('truncate table JAQY511');
execute immediate ('truncate table JAQY512');
execute immediate ('truncate table JAQY513');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 500;COMMIT;
                   
ln_anio := to_number(to_char(Pd_fecfin,'yyyy'));
ln_mes := to_number(to_char(Pd_fecfin,'mm'));

begin 
    select tccpa
      into ln_tipcam
      from (select tccpa,
                   tchor,
                   dense_rank() over(partition by tcfch order by tchor desc nulls last) n_priori
              from fsD120
             WHERE TCCOD = 999
               AND TCFCH between to_date('01'||to_char(Pd_fecfin,'mmyyyy'),'ddmmyyyy') and Pd_fecfin
               and tccpa > 0)
     where n_priori = 1;
exception  
  when too_many_rows then
       begin
                     select tccpa
                       into ln_tipcam
                       from (select tccpa,
                                    tchor,
                                    tcfch,
                                    dense_rank() over(partition by tccod,tcmda,tcimp order by tcfch,tchor desc nulls last) n_priori
                               from fsD120
                              WHERE TCCOD = 999
                                AND TCFCH between to_date('01'||to_char(Pd_fecfin,'mmyyyy'),'ddmmyyyy') and Pd_fecfin
                                and tccpa > 0)
                      where n_priori = 1;
       exception
                      when others then 
                           ln_tipcam:=1;
       end;   
  when others then 
       ln_tipcam:=1;
end;

for i in tues (Pd_fecini, Pd_fecfin) loop
ln_cta     := null;
ln_oper    := null;
ln_toper   := null;
lc_suc     := null;
ln_mod     := null;
ln_mda     := null;
lc_titular :=null;
ln_pais    :=null;
ln_tdoc    :=null;
lc_numdoc  :=null;
lc_existe  :=null;
lc_listneg := null;
lc_entfin  := null;
ln_suc     := null;
ln_pap     := null;
ln_sbop    := null;
ln_pri     := null;


       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,g.CTXSUC
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
           from fsh016 c, fsr008 e,fse008 g,fst001 h 
              where c.pgcod  = i.pgcod  
                and c.hcmod  = i.hcmod   
                and c.hsucor = i.hsucor 
                and c.htran  = i.htran   
                and c.hnrel  = i.hnrel   
                and c.hfcon  = i.hfcon 
                and hcta <> 0
                and e.pgcod = 1
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and c.hcodmo = 2
                and g.ctxcod = 1
                and g.ctxnro = c.hcta
                and h.pgcod = 1
                and g.ctxsuc = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,g.CTXSUC
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.hcmod  = i.hcmod   
                      and c.hsucor = i.hsucor 
                      and c.htran  = i.htran   
                      and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.hfcon   
                      and hcta <> 0
                      and e.pgcod = 1
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and c.hcodmo = 2
                      and g.ctxcod = 1
                      and g.ctxnro = c.hcta
                      and h.pgcod = 1
                      and g.ctxsuc = h.sucurs
                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select hcta, 
                              hoper, 
                              htoper, 
                              scnom , 
                              hmodul, 
                              hmda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              hsucur,
                              hpap,
                              CTXSUC
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux      
                           
                        from(select distinct c.hcta, 
                                         c.hoper, 
                                         c.htoper, 
                                         h.scnom , 
                                         c.hmodul, 
                                         c.hmda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.hsucur,
                                         c.hpap,
                                         g.CTXSUC,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.pgcod = 1
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and h.pgcod = 1
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                             dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                       dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,g.CTXSUC
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
                   from fsh016 c, fsr008 e,fse008 g,fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.hcmod  = i.hcmod   
                        and c.hsucor = i.hsucor 
                        and c.htran  = i.htran   
                        and c.hnrel  = i.hnrel   
                        and c.hfcon  = i.hfcon   
                        and hcta <> 0
                        and e.pgcod = 1
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.hcta
                        and c.hcodmo = 2
                        and g.ctxcod = 1
                        and g.ctxnro = c.hcta
                        and h.pgcod = 1
                        and g.ctxsuc = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,g.CTXSUC
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
                       from fsh016 c, fsr008 e,fse008 g,fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.pgcod = 1
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and h.pgcod = 1
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap,
                                        CTXSUC
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   g.CTXSUC,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.hcmod  = i.hcmod   
                                    and c.hsucor = i.hsucor 
                                    and c.htran  = i.htran   
                                    and c.hnrel  = i.hnrel   
                                    and c.hfcon  = i.hfcon   
                                    and hcta <> 0
                                    and e.pgcod = 1
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.hcta
                                    and c.hcodmo = 2
                                    and g.ctxcod = 1
                                    and g.ctxnro = c.hcta
                                    and h.pgcod = 1
                                    and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,g.CTXSUC
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
                         from fsh016 c, fsr008 e,fse008 g,fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.hcmod  = i.hcmod   
                              and c.hsucor = i.hsucor 
                              and c.htran  = i.htran   
                              and c.hnrel  = i.hnrel   
                              and c.hfcon  = i.hfcon   
                              and hcta <> 0
                              and e.pgcod = 1
                              and e.ctnro  = c.hcta
                              and e.cttfir = 'T'
                              and c.hcodmo = 2
                              and g.ctxcod = 1
                              and g.ctxnro = c.hcta
                              and h.pgcod = 1
                              and g.ctxsuc = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap,g.CTXSUC
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.pgcod = 1
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and h.pgcod = 1
                                      and g.ctxsuc = h.sucurs
                                      and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select hcta, 
                                        hoper, 
                                        htoper, 
                                        scnom , 
                                        hmodul, 
                                        hmda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        hsucur,
                                        hpap,
                                        CTXSUC
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,ln_sux      
                                     
                                  from(select distinct c.hcta, 
                                                   c.hoper, 
                                                   c.htoper, 
                                                   h.scnom , 
                                                   c.hmodul, 
                                                   c.hmda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.hsucur,
                                                   c.hpap,
                                                   g.CTXSUC,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,fse008 g,fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.pgcod = 1
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and h.pgcod = 1
                                      and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                                  end ;     
                             end;       
                     end;       
               end;       
         end;  
         begin
              select j.penom 
                into lc_titular
                from fsd001 j 
               where j.pepais = ln_pais 
                 and j.petdoc = ln_tdoc
                 and j.pendoc = lc_numdoc;
         exception
            when others then 
                 if i.TRAMITANTE is not null then
                    lc_titular:= i.TRAMITANTE;     
                 elsif i.TRAMITANTENOCLIENTE is not null then   
                    lc_titular:= i.TRAMITANTENOCLIENTE; 
                 else
                    lc_titular:= null;   
                 end if;   
         end;
         -- Exite
          begin
            select distinct 'S'   
              into lc_existe
             from fsh016 c 
                where c.pgcod  = i.pgcod  
                  and c.hcmod  = i.hcmod   
                  and c.hsucor = i.hsucor 
                  and c.htran  = i.htran   
                  and c.hnrel  = i.hnrel   
                  and c.hfcon  = i.hfcon
                  and c.hcord  = i.bc604ord ;
         exception 
           when no_data_found then
                lc_existe:='N';
                
         end;
         -- Lista negra
          begin
            select y.tlisde
              into lc_listneg 
              from fsd201 x, LN_Priori  y 
             where x.lnpais = ln_pais 
               and x.lntdoc = ln_tdoc
               and x.lnndoc = lc_numdoc
               and x.tlis   = y.tlis
               and y.tlis <> 2;
         exception 
           when no_data_found then
              lc_listneg:= null;
           when others then 
            begin 
                select tlisde
                  into lc_listneg 
                  from LN_Priori where prioridad = (
                 select min(y.prioridad)
                  from fsd201 x, LN_Priori  y 
                 where x.lnpais = ln_pais 
                   and x.lntdoc = ln_tdoc
                   and x.lnndoc = lc_numdoc
                   and x.tlis   = y.tlis
                   and y.tlis <> 2);    
            exception
              when others then 
                  lc_listneg:= null;
            end;          
         end;
         
         -- Es Entidad Financiera
          begin
            select 'S'
              into lc_entfin 
              from fsd004 o 
             where o.ifpais = i.pais 
               and o.iftdoc = i.tipodoc
               and o.ifndoc = i.numdoc;
           
         exception 
           when no_data_found then
              lc_entfin := 'N';
           when others then 
              lc_entfin := 'N'; 
              dbms_output.put_line ('EF : '||ln_pais||'-'||ln_tdoc||'-'||lc_numdoc);  
         end;             
 
   insert into JAQY511 (JAQY511EMP,JAQY511MOD,JAQY511SUC,JAQY511TRN,JAQY511NREL,JAQY511FCH,JAQY511NOMOPE,
                       JAQY511NROTRAN,JAQY511HMODUL,JAQY511MDA,JAQY511SCNOM,JAQY511DESMDA,JAQY511MONTO,
                       JAQY511ORIGENFON,JAQY511USU,JAQY511PAIS,JAQY511TIPDOC,JAQY511NUMDOC,JAQY511HCTA,
                       JAQY511HOPER,JAQY511HTOPE,JAQY511SUCCUENTA,JAQY511TITULAR,JAQY511NRODOCTRA,
                       JAQY511TDOCTRA,JAQY511TRA,JAQY511TRAMNOCLI,JAQY511PERSBNCPEP,JAQY511HORA,JAQY511EXTORD,
                       JAQY511ENTFIN,JAQY511HSUCUR,JAQY511HPAP,JAQY511HSUBO,JAQY511HMDA,JAQY511XSUC)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             i.OPERADOR,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,ln_sux);                 
    commit;

end loop;  


for i in trans_multi (Pd_fecfin, ln_tipcam) loop
ln_priori  := null;
lc_lndes   := null;
ln_list    := null;
ln_cantpre := 1;
ln_top     := null;
ln_ope     := null;
ln_sbo     := null;
ln_sucfin  := null;
ln_aosuc   := null;
lc_age     := null;
ln_mod_mul := null;
ln_suc_mul := null;
ln_mda_mul := null;
ln_pap_mul := null;
ln_cta_mul := null;

       begin
        --Busca los datos del producto
           select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
             into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo
             from fsh016 f, fsh015  g
            where f.pgcod  = i.bc607emp
              and f.hcmod  = i.bc607mod
              and f.hsucor = i.bc607suc
              and f.htran  = i.bc607trn
              and f.hnrel  = i.bc607nrel
              and f.hfcon  = i.bc607fch
              and f.pgcod  = g.pgcod
              and f.hcmod  = g.hcmod
              and f.hsucor = g.hsucor
              and f.htran  = g.htran
              and f.hnrel  = g.hnrel
              and f.hfcon  = g.hfcon
              and g.hccorr <> 99
              and f.hcta <> 0
              and f.hcodmo = 2
              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
        exception
             
           when too_many_rows then
               begin
                   select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                     into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo
                 from fsh016 f, fsh015  g
                    where f.pgcod  = i.bc607emp 
                      and f.hcmod  = i.bc607mod  
                      and f.hsucor = i.bc607suc 
                      and f.htran  = i.bc607trn  
                      and f.hnrel  = i.bc607nrel  
                      and f.hfcon  = i.bc607fch  
                      and f.hcta <> 0
                      and f.hcodmo = 2
                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                      and f.pgcod  = g.pgcod
                      and f.hcmod  = g.hcmod
                      and f.hsucor = g.hsucor
                      and f.htran  = g.htran
                      and f.hnrel  = g.hnrel
                      and f.hfcon  = g.hfcon
                      and g.hccorr <> 99;
                  exception
                    when too_many_rows then
                       begin
                       
                             select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                               into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo   
                                 
                              from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                               dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                              
                             from fsh016 f, fsh015  g
                                where f.pgcod  = i.bc607emp
                                  and f.hcmod  = i.bc607mod 
                                  and f.hsucor = i.bc607suc
                                  and f.htran  = i.bc607trn 
                                  and f.hnrel  = i.bc607nrel 
                                  and f.hfcon  = i.bc607fch
                                  and f.pgcod  = g.pgcod
                                  and f.hcmod  = g.hcmod
                                  and f.hsucor = g.hsucor
                                  and f.htran  = g.htran
                                  and f.hnrel  = g.hnrel
                                  and f.hfcon  = g.hfcon
                                  and g.hccorr <> 99 
                                  and f.hcta <> 0
                                  and f.hcodmo = 2
                                  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                            where n_priori = 1
                            ;
                        exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 1.1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata1: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                                       
                                      select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                             into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo 
                                       from fsh016 f, fsh015  g
                                      where f.pgcod  = i.bc607emp
                                        and f.hcmod  = i.bc607mod
                                        and f.hsucor = i.bc607suc
                                        and f.htran  = i.bc607trn
                                        and f.hnrel  = i.bc607nrel
                                        and f.hfcon  = i.bc607fch
                                        and f.hcta <> 0
                                        and f.hcodmo = 2
                                      --  and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 )
                                        and f.hcsubo = (select min(ff.hcsubo)
                                                          from fsh016 ff
                                                         where ff.pgcod  = f.pgcod 
                                                           and ff.hcmod  = f.hcmod 
                                                           and ff.hsucor = f.hsucor
                                                           and ff.htran  = f.htran 
                                                           and ff.hnrel  = f.hnrel 
                                                           and ff.hfcon  = f.hfcon 
                                                           and ff.hcord  = f.hcord)
                                        and f.pgcod  = g.pgcod
                                        and f.hcmod  = g.hcmod
                                        and f.hsucor = g.hsucor
                                        and f.htran  = g.htran
                                        and f.hnrel  = g.hnrel
                                        and f.hfcon  = g.hfcon
                                        and g.hccorr <> 99;
                         
                         exception
                                when too_many_rows then
                                   dbms_output.put_line ('mas de 9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                
                                when no_data_found then 
                                   dbms_output.put_line ('nohaydata9: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                       ||'-'||i.bc607nrel||'-'||i.bc607fch);  
                         end;
                    
                                   
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo
                   from fsh016 f, fsh015  g
                      where f.pgcod  = i.bc607emp 
                        and f.hcmod  = i.bc607mod  
                        and f.hsucor = i.bc607suc 
                        and f.htran  = i.bc607trn  
                        and f.hnrel  = i.bc607nrel  
                        and f.hfcon  = i.bc607fch  
                        and f.pgcod  = g.pgcod
                        and f.hcmod  = g.hcmod
                        and f.hsucor = g.hsucor
                        and f.htran  = g.htran
                        and f.hnrel  = g.hnrel
                        and f.hfcon  = g.hfcon
                        and g.hccorr <> 99
                        and f.hcta <> 0
                        and f.hcodmo = 2;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct f.hmodul,htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                         into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo
                       from fsh016 f, fsh015  g 
                          where f.pgcod  = i.bc607emp 
                            and f.hcmod  = i.bc607mod  
                            and f.hsucor = i.bc607suc 
                            and f.htran  = i.bc607trn  
                            and f.hnrel  = i.bc607nrel  
                            and f.hfcon  = i.bc607fch  
                            and f.pgcod  = g.pgcod
                            and f.hcmod  = g.hcmod
                            and f.hsucor = g.hsucor
                            and f.htran  = g.htran
                            and f.hnrel  = g.hnrel
                            and f.hfcon  = g.hfcon
                            and g.hccorr <> 99
                            and f.hcta <> 0
                            and f.hcodmo = 2
                            and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo      
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                  where f.pgcod  = i.bc607emp 
                                    and f.hcmod  = i.bc607mod  
                                    and f.hsucor = i.bc607suc 
                                    and f.htran  = i.bc607trn  
                                    and f.hnrel  = i.bc607nrel  
                                    and f.hfcon  = i.bc607fch 
                                    and f.pgcod  = g.pgcod
                                    and f.hcmod  = g.hcmod
                                    and f.hsucor = g.hsucor
                                    and f.htran  = g.htran
                                    and f.hnrel  = g.hnrel
                                    and f.hfcon  = g.hfcon
                                    and g.hccorr <> 99 
                                    and f.hcta <> 0
                                    and f.hcodmo = 2)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                  end ;
                             --null;
                             /*dbms_output.put_line ('no data1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                            ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );  */
                     end;
                 when no_data_found then
                      begin
                        select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                          into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo 
                         from fsh016 f, fsh015  g
                            where f.pgcod  = i.bc607emp 
                              and f.hcmod  = i.bc607mod  
                              and f.hsucor = i.bc607suc 
                              and f.htran  = i.bc607trn  
                              and f.hnrel  = i.bc607nrel  
                              and f.hfcon  = i.bc607fch  
                              and f.pgcod  = g.pgcod
                              and f.hcmod  = g.hcmod
                              and f.hsucor = g.hsucor
                              and f.htran  = g.htran
                              and f.hnrel  = g.hnrel
                              and f.hfcon  = g.hfcon
                              and g.hccorr <> 99
                              and f.hcta <> 0
                              and f.hcodmo = 2
                              and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop
                                   into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo
                                 from fsh016 f , fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod 
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn 
                                      and f.hnrel  = i.bc607nrel 
                                      and f.hfcon  = i.bc607fch 
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0
                                      and f.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                   into ln_mod,ln_top,ln_suc,ln_mda,ln_pap,ln_cta,ln_ope,ln_sbo    
                                     
                                  from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                   dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                  
                                 from fsh016 f, fsh015  g
                                    where f.pgcod  = i.bc607emp
                                      and f.hcmod  = i.bc607mod
                                      and f.hsucor = i.bc607suc
                                      and f.htran  = i.bc607trn
                                      and f.hnrel  = i.bc607nrel
                                      and f.hfcon  = i.bc607fch
                                      and f.pgcod  = g.pgcod
                                      and f.hcmod  = g.hcmod
                                      and f.hsucor = g.hsucor
                                      and f.htran  = g.htran
                                      and f.hnrel  = g.hnrel
                                      and f.hfcon  = g.hfcon
                                      and g.hccorr <> 99
                                      and f.hcta <> 0)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                 ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                    
                                    when no_data_found then 
                                       begin
                       
                                           select distinct hmodul,htoper,hsucur,hmda,hpap,hcta,hoper,hsubop
                                             into ln_mod_mul,ln_top,ln_suc_mul,ln_mda_mul,ln_pap_mul,ln_cta_mul,ln_ope,ln_sbo    
                                               
                                            from(select distinct f.hmodul,f.htoper,f.hsucur,f.hmda,f.hpap,f.hcta,f.hoper,f.hsubop,
                                                             dense_rank() over(partition by f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon order by f.hcord asc nulls last) n_priori
                                            
                                           from fsh016 f, fsh015  g
                                              where f.pgcod  = i.bc607emp
                                                and f.hcmod  = i.bc607mod
                                                and f.hsucor = i.bc607suc
                                                and f.htran  = i.bc607trn
                                                and f.hnrel  = i.bc607nrel
                                                and f.hfcon  = i.bc607fch
                                                and f.pgcod  = g.pgcod
                                                and f.hcmod  = g.hcmod
                                                and f.hsucor = g.hsucor
                                                and f.htran  = g.htran
                                                and f.hnrel  = g.hnrel
                                                and f.hfcon  = g.hfcon
                                                and g.hccorr <> 99)
                                        where n_priori = 1
                                                ;
                                            exception
                                              when too_many_rows then
                                                 dbms_output.put_line ('mas de 44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);
                                              
                                              when no_data_found then 
                                                 dbms_output.put_line ('nohaydata44: '||i.bc607emp||'-'||i.bc607mod||'-'||i.bc607suc||'-'||i.bc607trn
                                                                           ||'-'||i.bc607nrel||'-'||i.bc607fch);                  
                                            end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                                                     
                                  end ;     --null;
                                    /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                                    ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
                             end;       
                     end;       
               end;       
        end;
        
        
       begin
            select y.tlis, y.prioridad, y.tlisde
              into ln_list,ln_priori,lc_lndes 
              from fsd201 x, LN_Priori  y 
             where x.lntdoc = i.BC606TDOC
               and x.lnndoc = i.BC606NDOC
               and x.tlis   = y.tlis
               and y.tlis <> 2;
         exception 
           when no_data_found then
              lc_lndes:= null;
           when others then 
            begin 
                select tlis, prioridad, tlisde
                  into ln_list,ln_priori,lc_lndes 
                  from LN_Priori where prioridad = (
                 select min(y.prioridad)
                  from fsd201 x, LN_Priori  y 
                 where x.lntdoc = i.BC606TDOC
                   and x.lnndoc = i.BC606NDOC
                   and x.tlis   = y.tlis
                   and y.tlis <> 2);    
            exception
              when others then 
                  lc_lndes:= null;
            end;          
         end;
         
                               
         --Agencia
         
         Begin
         
            select scnom
              into lc_age
              from fst001
             where pgcod = 1 and sucurs = ln_suc_mul;
         exception 
             when others then null;
         end;
   begin
   insert into JAQY512 (JAQY512TDOC,JAQY512NDOC,JAQY512FCH,JAQY512TREG,JAQY512IMPA,JAQY512NOMCLI,
                      JAQY512ROL,JAQY512DIRCLI,JAQY512TELCLI,JAQY512NOMNOCLI,JAQY512DIRNOCLI,
                      JAQY512TELNOCLI,JAQY512MONTO,JAQY512AGENCIA,JAQY512NROLIST,JAQY512PRIORI,
                      JAQY512LISTDES,JAQY512ANOPRO,JAQY512MESPRO,JAQY512HMODUL,JAQY512HTOPER,
                      JAQY512HMDA,JAQY512HPAP,JAQY512HCTA,JAQY512HOPER,JAQY512HSUBOP,JAQY512HSUCUR,
                      JAQY512PAIS)
      values(i.BC606TDOC,i.BC606NDOC,i.BC606FCH,i.BC606TREG,i.BC606IMPA,i.NOMBRECLIENTE,i.ROL,i.DIRECCIONCLIENTE,
             i.TELEFONOCLIENTE,i.NOMBRENOCLIENTE,i.DIRECCIONNOCLIENTE,i.TELEFONONOCLIENTE,i.bc606impa,lc_age,
             ln_list,ln_priori,lc_lndes,ln_anio, ln_mes,ln_mod_mul,ln_top,ln_mda_mul,ln_pap_mul,ln_cta_mul,
             ln_ope,ln_sbo,ln_suc_mul,i.bc606pais);      
                     
    commit;
    exception
      when others then
        dbms_output.put_line(i.BC606NDOC);
    end; 
end loop;  

begin

    insert into JAQY513 (JAQY513fec,JAQY513PENOM,JAQY513pais,JAQY513tipdoc,JAQY513TDNOM,JAQY513NDOC,
                         JAQY513SUC,JAQY513MTODOL,JAQY513SCNOM,JAQY513TIPREP)
    
    select Pd_fecfin,
           p2.Jaqy511titular, 
           p2.Jaqy511pais, 
           p2.Jaqy511tipdoc, 
           p2.tdnom, 
           p2.Jaqy511numdoc, 
           p2.bc604suc, 
           p2.montotal MtoDolares,
           (select scnom from fst001 where pgcod = 1 and sucurs = p2.bc604suc) scnom,
           'UNICO'tiprep
     from   (select p1.Jaqy511titular, 
                    p1.Jaqy511pais, 
                    p1.Jaqy511tipdoc, 
                    (select tdnom from fst014 where tdocum = p1.Jaqy511tipdoc) tdnom,
                    p1.Jaqy511numdoc, 
                    (select t2.jaqy511xsuc 
                       from JAQY511 t2
                      where t2.Jaqy511titular = p1.Jaqy511titular /*or t2.numdoc = p1.numdoc)*/
                        and t2.Jaqy511monto   = (select max(t3.Jaqy511monto)
                                           from JAQY511 t3
                                          where t3.Jaqy511titular = t2.Jaqy511titular
                                            group by t3.Jaqy511titular) 
                        and rownum = 1)bc604suc, 
                     p1.montotal
                from (select r1.Jaqy511titular, 
                             r1.Jaqy511pais, 
                             r1.Jaqy511tipdoc, 
                             r1.Jaqy511numdoc, 
                             sum(r1.Jaqy511monto) MONTOTAL,/*cuentas vigentes*/
                             (select count(t1.pgcod) 
                                from fsd010 t1, fsr008 t2
                               where t1.pgcod = 1 
                                 and t1.aocta  = t2.ctnro                                 
                                 and t2.PEPAIS = r1.Jaqy511pais
                                 and t2.PETDOC = r1.Jaqy511tipdoc
                                 and t2.pendoc = r1.Jaqy511numdoc
                                 --and t2.cttfir ='T'
                                 and t1.aomod in (select modulo from fst111 where dscod=50)
                                 and t1.aostat <> 99) cantctas
                        from JAQY511 r1
                       where r1.Jaqy511pais is not null
                       group by r1.Jaqy511titular, r1.Jaqy511pais, r1.Jaqy511tipdoc, r1.Jaqy511numdoc
                      )p1 
               where  p1.cantctas = 0)p2

    UNION

    select Pd_fecfin,
           p2.nombre, 
           p2.jaqy512pais, 
           p2.jaqy512tdoc, 
           p2.tdnom, 
           p2.jaqy512ndoc, 
           p2.bc607suc, 
           p2.montotal,
           (select scnom 
              from fst001 
             where pgcod = 1 
               and sucurs = p2.bc607suc) scnom,
           'MULTIPLE'TipRep
    from 
    (
    select p1.nombre, 
             p1.jaqy512pais, 
             p1.jaqy512tdoc, 
             ( select tdnom from fst014 where tdocum = p1.jaqy512tdoc) tdnom,
             p1.jaqy512ndoc, 
             (select t2.jaqy512hsucur 
                from JAQY512 t2
               where t2.jaqy512pais = p1.jaqy512pais
                 and t2.jaqy512tdoc = p1.jaqy512tdoc
                 and t2.jaqy512ndoc = p1.jaqy512ndoc
                 and t2.jaqy512impa = (select max(jaqy512impa)
                                         from JAQY512 a3
                                        where a3.jaqy512pais = t2.jaqy512pais
                                          and a3.jaqy512tdoc = t2.jaqy512tdoc
                                          and a3.jaqy512ndoc = t2.jaqy512ndoc
                                          
                                       group by a3.jaqy512pais,a3.jaqy512tdoc,a3.jaqy512ndoc) 
                 and rownum = 1) bc607suc, --No existe Sucursal
              p1.montotal       
        
              from (select nvl(r1.jaqy512nomcli,r1.jaqy512nomnocli)nombre, 
                           r1.jaqy512pais, 
                           r1.jaqy512tdoc, 
                           r1.jaqy512ndoc, 
                           sum(r1.jaqy512monto) MONTOTAL,/*cuentas vigentes*/
                           (select count(t1.pgcod) 
                              from fsd010 t1, fsr008 t2  
                             where t1.pgcod = 1 
                               and t1.aocta  = t2.ctnro
                               and t2.PEPAIS = r1.jaqy512pais
                               and t2.PETDOC = r1.jaqy512tdoc
                               and t2.pendoc = r1.jaqy512ndoc
                               --and t2.cttfir ='T'
                               and t1.aomod in (select modulo from fst111 where dscod=50)
                               and t1.aostat <> 99) cantctas
                      from JAQY512 r1
                     where r1.jaqy512pais is not null
                       --and r1.bc606ndoc = '45159232'
                     group by nvl(r1.jaqy512nomcli,r1.jaqy512nomnocli), jaqy512pais, r1.jaqy512tdoc, r1.jaqy512ndoc)p1 
             where  p1.cantctas = 0
    )p2;



end;
    
begin
     update jaqy500 set jaqy500flg = 0 where jaqy500cod = 500;COMMIT;
end;

end SP_Ocum_SinCredVig;


Procedure Sp_CliIngPromMensual (PN_SUC IN NUMBER) IS

BEGIN
     
execute immediate ('truncate table JAQY282');
execute immediate ('truncate table JAQY283');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 600;COMMIT;     
     begin
     
     insert into JAQY282 (JAQY282SCSUC,JAQY282PAIS,JAQY282TIPDOC,JAQY282NDOC,JAQY282PEX)
     
     select /*+parallel(f11,2) parallel(f8,2)*/
            distinct scSUC, 
            f8.pepais, 
            f8.petdoc, 
            f8.pendoc, 
            PEXING
        from fsr008 f8, fsd011 f11,fse101 fe1
       where f8.pgcod = f11.pgcod
         and f8.ctnro = f11.sccta
         and f11.scrub in ( select rubro from fsd014 where pcnivc in (select modulo
                                     from fst111
                                    where dscod in (1,2,3,16,50,150)))      
         and f11.scfval =  (select /*+parallel(f82,2) parallel(f112,2)*/max(f112.scfval) 
                                    from fsr008 f82, FSD011 f112
                                   where f82.pgcod     = f8.pgcod
                                     and f82.pepais    = f8.pepais 
                                     and f82.petdoc    = f8.petdoc 
                                     and f82.pendoc    = f8.pendoc 
                                     and f82.ctnro     = f112.scCTA 
                                     and f112.scstat   <> 99
                                     and f112.scrub    in ( select rubro from fsd014 where pcnivc in (select modulo
                                                                                                        from fst111
                                                                                                       where dscod in (1,2,3,16,50,150))))                             
         and f11.scstat <> 99     
         and f8.pepais = fe1.pepais
         and f8.petdoc = fe1.petdoc
         and f8.pendoc = fe1.pendoc
         and fe1.PEXING    = 0
         and fe1.PEXFECHA  = (select min(pexfecha) 
                                from fse101 b 
                               where b.PEPAIS = fe1.PEPAIS 
                                 and b.PETDOC = fe1.PETDOC 
                                 and b.PENDOC = fe1.PENDOC) ;

      commit;
      end;
      
      begin
      
      insert into Jaqy283(JAQY283PENOM,JAQY283PAIS,JAQY283TIPDOC,JAQY283TDNOM,
                          JAQY283NDOC,JAQY283SCSUC,JAQY283SCNOM,JAQY283PEX)
      
      select /*+parallel(t2,2) */
             (select penom 
                from fsd001 a 
               where a.pepais = t2.JAQY282PAIS 
                 and a.petdoc = t2.JAQY282TIPDOC 
                 and a.pendoc = t2.JAQY282NDOC),
             t2.JAQY282PAIS, 
             t2.JAQY282TIPDOC, 
             ( select f14.tdnom from fst014 f14 where f14.tdocum = t2.JAQY282TIPDOC),
             t2.JAQY282NDOC,
             t2.aosuc,
             (select scnom from fst001 where pgcod = 1 and sucurs = t2.aosuc) ,
             --pgcod CODIGO_CMAC, 
             JAQY282PEX 
        from  (
                select /*+parallel(t,2) */t.JAQY282PAIS, 
                       t.JAQY282TIPDOC,
                       t.JAQY282NDOC, 
                       JAQY282PEX, 
                       max(JAQY282SCSUC) aosuc 
                  from JAQY282 t 
                group by JAQY282PAIS, 
                         JAQY282TIPDOC, 
                         JAQY282NDOC, 
                         JAQY282PEX  )t2
       where aosuc = PN_SUC         ;
       
       commit;
       end;      
       
begin
     update jaqy500 set jaqy500flg = 0 where jaqy500cod = 600;COMMIT;
end;
               
END;

end PQ_OCUM_PROCESOS;
/

