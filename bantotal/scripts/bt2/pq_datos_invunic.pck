create or replace package pq_datos_InvUnic is

  -- Author  : ABERNEDO
  -- Created : 17/02/2014 09:37:41 a.m.
  -- Purpose : 

  Procedure sp_InvUnic_datos (Pd_FECINI in date,Pd_FECFIN in date,PC_UBUSER IN VARCHAR2) ;
  Procedure Sp_datos(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                   pn_rel in number,pd_fec in date,ln_pai out NUMBER,ln_tdo out NUMBER,
                   lc_ndo out CHAR,lc_ndo_tra out CHAR,lc_tdo_tra out char,
                   lc_nom_tra out CHAR,lc_nom_not out VARChar2);
  Procedure sp_carga(Pd_FECINI in date,Pd_FECFIN in date,PC_UBUSER IN VARCHAR2);                   
                                                                                                                                                                                                                                        
end pq_datos_InvUnic;
/

create or replace package body pq_datos_InvUnic is

 
Procedure sp_InvUnic_datos (Pd_FECINI in date,Pd_FECFIN in date,PC_UBUSER IN VARCHAR2) is

--ld_fecpro date ;
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
ln_sbop number;
ln_suc number(3);
ln_pap number(4);

cursor rubro is 
select * from jaqy455_aux a where a.ubuser=pc_ubuser;

--MOD 2016.04.04 ABR
/*  select  
        a.bc604emp, a.bc604mod, a.bc604suc, a.bc604trn, a.bc604nrel, a.bc604fch,a.bc604hor,a.bc604ord,
        b.pgcod, b.hfcon,b.hcmod , b.hsucor, b.htran, b.hnrel, 
        f.trnom Nomoperacion, 
       lpad(to_char(a.bc604suc),3,'0')||lpad(to_char(a.bc604mod),3,'0')||lpad(to_char(a.bc604trn),3,'0')
        ||lpad(to_char(a.bc604nrel),4,'0') NroTransaccion,
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
        --d.bc605pais Pais,
        --d.bc605tdoc TipoDoc,
        --d.bc605ndoc Numdoc,
        (select l.bc605pais from fbc605 l where \*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )Pais,
        (select l.bc605tdoc from fbc605 l where \*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )TipoDoc,
        (select l.bc605ndoc from fbc605 l where \*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg between 300 and  399 
                and rownum = 1
        )numdoc,
        (select l.bc605ndoc from fbc605 l where \*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
        )NroDnitramitante,
        (select m.tdnom from fbc605 l,fst014 m where \*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
                and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605tdoc     = m.tdocum
        )TDocumento,
        (select n.penom from fbc605 l,fsd001 n where \*a.bc604co ='S' --and a.bc604fch between ld_fecini and ld_fecfin 
                and a.BC604TTrn     = 2
                and*\ a.BC604EMP      = l.BC604EMP
                and a.BC604MOD      = l.BC604MOD
               and a.BC604SUC      = l.BC604SUC
                and a.BC604TRN      = l.BC604TRN
                and a.BC604NREL     = l.BC604NREL
                and a.BC604FCH      = l.BC604FCH
                and l.bc605treg     in (100,101,102,103,104)
                and rownum = 1
                and l.bc605ndoc     = n.pendoc
        )Tramitante,
        (select (trim(o.bc602nom)||trim(o.bc602ape)||trim(o.bc602apem)) from fbc605 l,fbc602 o where \*a.bc604co ='S' and a.bc604fch = to_date('20130701','yyyymmdd') 
                and a.BC604TTrn     = 2*\
                 a.BC604EMP      = l.BC604EMP
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
        
from fbc604 a, fsh015 b,fst034 f,fst001 i
where a.bc604co ='S' 
and a.bc604fch BETWEEN Pd_FECINI AND Pd_FECFIN-- Pd_FECPRO--ld_fecpro
and a.bc604emp=1 
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
and b.hccorr <> 99;*/


begin
  execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
  begin
    pq_datos_invunic.sp_carga(Pd_FECINI,Pd_FECFIN,PC_UBUSER);
  end;
  
  --ld_fecpro := to_date(Pd_FECPRO,'yyyymmdd');
  --execute immediate ('truncate table JAQY455');
  
  /*modificado 13/07/2021
  --EFUENTES
  */
  --  Delete from jaqy455 where trim(jaqy455ubuser) = trim(PC_UBUSER);
  Delete from jaqy455 where jaqy455ubuser  = rpad(trim(PC_UBUSER),10,' ');
  commit;
  
  --update jaqy500 set jaqy500flg = 1 where jaqy500cod = 900;COMMIT;
  for i in rubro loop
  ln_cta  := null;
  ln_oper := null;
  ln_toper:= null;
  ln_sbop := null;
  lc_suc  := null;
  ln_mod  := null;
  ln_mda  := null;
  lc_titular:=null;
  ln_pais :=null;
  ln_tdoc :=null;
  lc_numdoc :=null;
  lc_existe :=null;
  lc_listneg:= null;
  lc_entfin := null;
  ln_suc := null;
  ln_pap := null;
  
            begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
           from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.hcmod  = i.hcmod   
                and c.hsucor = i.hsucor 
                and c.htran  = i.htran   
                and c.hnrel  = i.hnrel   
                and c.hfcon  = i.hfcon 
                and hcta <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.hcta
                and c.hcodmo = 2
                and g.ctxcod = 1
                and g.ctxnro = c.hcta
                and g.ctxsuc = h.sucurs
                and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                        e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                 from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.hcmod  = i.hcmod   
                      and c.hsucor = i.hsucor 
                      and c.htran  = i.htran   
                      and c.hnrel  = i.hnrel   
                      and c.hfcon  = i.hfcon   
                      and hcta <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.hcta
                      and c.hcodmo = 2
                      and g.ctxcod = 1
                      and g.ctxnro = c.hcta
                      and g.ctxsuc = h.sucurs
                      and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
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
                        
                       from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
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
                  select /*+index(c FSH01600) index(e SYS_C00982110) index(g FSE00802)*/ distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                   from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.hcmod  = i.hcmod   
                        and c.hsucor = i.hsucor 
                        and c.htran  = i.htran   
                        and c.hnrel  = i.hnrel   
                        and c.hfcon  = i.hfcon   
                        and hcta <> 0
                        and e.pgcod = 1 --13.07.2021
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.hcta
                        and c.hcodmo = 2
                        and g.ctxcod = 1
                        and g.ctxnro = c.hcta
                        and g.ctxsuc = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                       from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.hcmod  = i.hcmod   
                            and c.hsucor = i.hsucor 
                            and c.htran  = i.htran   
                            and c.hnrel  = i.hnrel   
                            and c.hfcon  = i.hfcon   
                            and hcta <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.hcta
                            and c.hcodmo = 2
                            and g.ctxcod = 1
                            and g.ctxnro = c.hcta
                            and g.ctxsuc = h.sucurs
                            and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod );
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
                                  
                                 from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.hcmod  = i.hcmod   
                                    and c.hsucor = i.hsucor 
                                    and c.htran  = i.htran   
                                    and c.hnrel  = i.hnrel   
                                    and c.hfcon  = i.hfcon   
                                    and hcta <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.hcta
                                    and c.hcodmo = 2
                                    and g.ctxcod = 1
                                    and g.ctxnro = c.hcta
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
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                         from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.hcmod  = i.hcmod   
                              and c.hsucor = i.hsucor 
                              and c.htran  = i.htran   
                              and c.hnrel  = i.hnrel   
                              and c.hfcon  = i.hfcon   
                              and hcta <> 0
                              and e.ctnro  = c.hcta
                              and e.cttfir = 'T'
                              and c.hcodmo = 2
                              and g.ctxcod = 1
                              and g.ctxnro = c.hcta
                              and g.ctxsuc = h.sucurs
                              and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap
                                 from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs
                                      and c.hmodul in (select aa.modulo from /*bantprod.*/fst111 aa , /*bantprod.*/fst110 bb where aa.dscod = bb.dscod );
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
                                  
                                 from /*bantprod.*/fsh016 c, /*bantprod.*/fsr008 e,/*bantprod.*/fse008 g,/*bantprod.*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      and g.ctxcod = 1
                                      and g.ctxnro = c.hcta
                                      and g.ctxsuc = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                    
                                    when no_data_found then 
                                       null;
                                       --dbms_output.put_line ('nohaydata33: '||i.BC604MOD||'-'||i.bc604suc||'-'||i.bc604trn||'-'||i.bc604nrel||'-'||i.bc604fch);                  
                                  end ;     
                             end;       
                     end;       
               end;       
         end; 
         begin
              select j.penom 
                into lc_titular
                from /*bantprod.*/fsd001 j 
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
             from /*bantprod.*/fsh016 c 
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
                /*dbms_output.put_line ('no data2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon
                ||'-'||i.pais||'-'||i.tipodoc||'-'||i.numdoc );*/
         end;
         -- Lista negra
          begin
            select y.tlisde
              into lc_listneg 
              from /*bantprod.*/fsd201 x, LN_Priori  y 
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
                  from /*bantprod.*/fsd201 x, LN_Priori  y 
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
              from /*bantprod.*/fsd004 o 
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
        
         begin
           insert into JAQY455 (JAQY455EMP,JAQY455MOD,JAQY455SUC,JAQY455TRN,JAQY455NREL,JAQY455FCH,JAQY455NOMOPE,JAQY455NROTRAN,
                                JAQY455HMODUL,JAQY455MDAOPE,JAQY455SCNOMOPE,JAQY455MDATRAN,JAQY455MTO,JAQY455ORIGFON,JAQY455FEC,
                                JAQY455USU,JAQY455PAIS,JAQY455TDOC,JAQY455NDOC,JAQY455CTA,JAQY455OPE,JAQY455TOP,JAQY455SUCCTA,
                                JAQY455PENOM,JAQY455NDOCTRA,JAQY455TDOCTRA,JAQY455PENOMTRA,JAQY455TRAMNOCTE,JAQY455TIPPERNEG,JAQY455HORA,
                                JAQY455EXTORD,JAQY455ENTFIN,JAQY455SBOP,JAQY455UBUSER)
              values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
                     ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
                     i.FECHA,i.OPERADOR,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
                     lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
                     i.bc604hor,lc_existe,lc_entfin,ln_sbop,PC_UBUSER);                 
            commit;
          end;
  --end if;  
end loop; 
  /*  begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 900;COMMIT;
    end;*/

end sp_InvUnic_datos;  

Procedure Sp_datos(pn_emp in number,pn_mod in number,pn_suc in number,pn_trn in number,
                   pn_rel in number,pd_fec in date,ln_pai out NUMBER,ln_tdo out NUMBER,
                   lc_ndo out CHAR,lc_ndo_tra out CHAR,lc_tdo_tra out char,
                   lc_nom_tra out CHAR,lc_nom_not out VARChar2)is
                   

begin
       begin
         
        select  l.bc605pais ,
                l.bc605tdoc ,
                l.bc605ndoc
           into ln_pai,
                ln_tdo,
                lc_ndo           
           from /*bantprod.*/fbc605 l 
          where l.BC604EMP      = pn_emp
            and l.BC604MOD      = pn_mod
            and l.BC604SUC      = pn_suc
            and l.BC604TRN      = pn_trn
            and l.BC604NREL     = pn_rel
            and l.BC604FCH      = pd_fec
            and l.bc605treg between 300 and  399 
            and rownum = 1;
            
      exception
          when others then null;
      end;   
      
      begin
      
          select l.bc605ndoc,
                 (select m.tdnom from /*bantprod.*/fst014 m where l.bc605tdoc = m.tdocum),
                 (select n.penom from /*bantprod.*/fsd001 n where l.bc605pais = n.pepais
                                                          and l.bc605tdoc = n.petdoc
                                                          and l.bc605ndoc = n.pendoc),
                 (select (trim(o.bc602nom)||trim(o.bc602ape)||trim(o.bc602apem)) 
                    from /*bantprod.*/fbc602 o
                   where l.bc605pais = o.bc602pais
                     and l.bc605tdoc = o.bc602tdoc
                     and l.bc605ndoc = o.bc602ndoc)
           into lc_ndo_tra,
                lc_tdo_tra,
                lc_nom_tra,
                lc_nom_not        
           
           from /*bantprod.*/fbc605 l 
          where l.BC604EMP      = pn_emp
            and l.BC604MOD      = pn_mod
            and l.BC604SUC      = pn_suc
            and l.BC604TRN      = pn_trn
            and l.BC604NREL     = pn_rel
            and l.BC604FCH      = pd_fec
            and l.bc605treg     in (100,101,102,103,104)
            and rownum = 1;
            
      exception
          when others then null;
      end;    
      
end Sp_datos;

Procedure sp_carga(Pd_FECINI in date,Pd_FECFIN in date,PC_UBUSER IN VARCHAR2)is

Cursor operaciones is
--select  /*+parallel(a,2) parallel(f,2)*/
select  a.bc604emp, 
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
       lpad(to_char(a.bc604suc),3,'0')||lpad(to_char(a.bc604mod),3,'0')||lpad(to_char(a.bc604trn),3,'0')
        ||lpad(to_char(a.bc604nrel),4,'0') NroTransaccion,
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
        a.bc604usid Operador    
from /*bantprod.*/fbc604 a, /*bantprod.*/fsh015 b,/*bantprod.*/fst034 f,/*bantprod.*/fst001 i
where a.bc604co ='S' 
and a.bc604fch BETWEEN Pd_FECINI AND Pd_FECFIN
and a.bc604emp=1 
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
and b.hccorr <> 99;

ln_pai NUMBER(3);
ln_tdo NUMBER(2);
lc_ndo CHAR(12);
lc_ndo_tra CHAR(12);
lc_tdo_tra char(20);
lc_nom_tra CHAR(30);
lc_nom_not VARChar2(140);

begin
    delete from jaqy455_aux a where a.ubuser=PC_UBUSER;
    commit;
    begin
       for i in operaciones loop
           pq_datos_invunic.sp_datos(i.bc604emp,i.bc604mod,i.bc604suc,i.bc604trn,i.bc604nrel,
                                     i.bc604fch,ln_pai,ln_tdo,lc_ndo,lc_ndo_tra,lc_tdo_tra,
                                     lc_nom_tra,lc_nom_not);
                                     
           insert into jaqy455_aux
           values(i.bc604emp,i.bc604mod,i.bc604suc,i.bc604trn,i.bc604nrel,i.bc604fch,
                  i.bc604hor,i.bc604ord,i.pgcod,i.hfcon,i.hcmod,i.hsucor,i.htran, 
                  i.hnrel,i.Nomoperacion,i.NroTransaccion,i.ModuloOperacion,i.MdaOperacion,
                  i.AgenciaOperacion,i.MdaTransaccion,i.Monto,i.origendefondos,i.Fecha,
                  i.Operador,ln_pai,ln_tdo,lc_ndo,lc_ndo_tra,lc_tdo_tra,lc_nom_tra,lc_nom_not,
                  PC_UBUSER);
          commit;
                                     
       end loop;
       
    end;

end sp_carga;

end pq_datos_InvUnic;
/

