create or replace package PQ_OCUM_CALIFICACION is

  -- Author  : ABERNEDO
  -- Created : 11/08/2014 09:38:40 a.m.
  -- Purpose : Reporte de calificacion de operaciones unicas y multiples
 Procedure SP_VERIFICA(Pd_fecini in date,Pd_fecfin in date,/*pn_sucope in number,*/
                      pc_user in varchar2,pc_ubuser in varchar2,pc_flag in char); 
 Procedure SP_Unicas(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2);
 Procedure SP_Unicas_Usu(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2);
 

 Function Fn_Ejecutivo (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                       pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;
  Function fn_analista (pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in char,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number) return char;
  Procedure SP_Multiples(Pd_fecpro in date);
  function fn_meses (pn_mes in char) return varchar2;
  
  Procedure SP_Unicas_Diario(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2);
  Procedure SP_Unicas_Usu_Diario(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2);
  
  Procedure SP_CONSOLIDAR_HD(pc_ubuser in varchar2);
  Procedure SP_Unicas_H(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2);
  Procedure SP_Unicas_Usu_H(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2);
  
  Procedure SP_Unicas_Diario_D(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2);
  Procedure SP_Unicas_Usu_Diario_D(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2) ;
                             
  Procedure sp_analista(pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in varchar2,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number, pc_analista out varchar2);  
end PQ_OCUM_CALIFICACION;
/

create or replace package body PQ_OCUM_CALIFICACION is

Procedure SP_VERIFICA(Pd_fecini in date,Pd_fecfin in date,/*pn_sucope in number,*/
                      pc_user in varchar2,pc_ubuser in varchar2,pc_flag in char)is
ld_fecaux date;                    
begin

     begin
     
     if pc_flag = 'D' then
     
          if pc_user = 'N' then
             Pq_Ocum_Calificacion.SP_Unicas_Diario(Pd_fecini,Pd_fecfin,pc_ubuser);
          end if;
          if pc_user <> 'N' then
             Pq_Ocum_Calificacion.SP_Unicas_Usu_Diario(Pd_fecini,Pd_fecfin,pc_user,pc_ubuser);
          end if;

      
      end if;
      
      
      if pc_flag = 'H' then
     

          if pc_user = 'N' then
             Pq_Ocum_Calificacion.SP_Unicas(Pd_fecini,Pd_fecfin,pc_ubuser);
          end if;
          if pc_user <> 'N' then
             Pq_Ocum_Calificacion.SP_Unicas_Usu(Pd_fecini,Pd_fecfin,pc_user,pc_ubuser);
          end if;
        
      
      end if;
      
      if pc_flag = 'HD' then
         ld_fecaux := Pd_fecfin - 1;
         

            if pc_user = 'N' then
               Pq_Ocum_Calificacion.SP_Unicas_Diario_D(Pd_fecfin,Pd_fecfin,pc_ubuser);
               Pq_Ocum_Calificacion.SP_Unicas_H(Pd_fecini,ld_fecaux,pc_ubuser);
               Pq_Ocum_Calificacion.SP_CONSOLIDAR_HD(pc_ubuser);
            end if;
            if pc_user <> 'N' then
               Pq_Ocum_Calificacion.SP_Unicas_Usu_Diario_D(Pd_fecfin,Pd_fecfin,pc_user,pc_ubuser);
               Pq_Ocum_Calificacion.SP_Unicas_Usu_H(Pd_fecini,ld_fecaux,pc_user,pc_ubuser);
               Pq_Ocum_Calificacion.SP_CONSOLIDAR_HD(pc_ubuser);
            end if;
      
      end if;
    
    end;

end;                    


Procedure SP_Unicas(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);

cursor tues (Pd_fecini in date, Pd_fecfin in date) is
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
                          and l.bc605pais     = o.bc602pais
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

   
   
begin

delete from JAQY295 where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296 where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295');
--execute immediate ('truncate table JAQY296');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;

       lc_analista := i.operador;
       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                --and g.ctxcod = 1
                --and g.ctxnro = c.hcta
                --and g.ctxsuc = h.sucurs
                and c.hsucur = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.hcta
                      --and g.ctxsuc = h.sucurs
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
                              hpap,
                              /*hsucur,*/
                              hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop  
                           
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
                                         /*c.hsucur,*/
                                         c.hsubop,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
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
                                             /* hsucur,*/
                                              hsubop
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
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
                                              /*hsucur,*/
                                              hsubop,
                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                        from(                      

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
                                              /*hsucur,*/
                                              hsubop,
                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                         /*c.hsucur,*/
                                                         c.hsubop,
                                                         c.hcodmo,
                                                         hfcon,
                                                         hcmod, hsucor, htran, hnrel,
                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                
                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.hcmod  =  i.hcmod 
                                            and c.hsucor =  i.hsucor
                                            and c.htran  =  i.htran 
                                            and c.hnrel  =  i.hnrel 
                                            and c.hfcon  =  i.hfcon 
                                            and hcta <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.hcta
                                            and c.hcodmo = 2
                                           --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs
                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
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
                                                              /*hsucur,*/
                                                              hsubop
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
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
                                                                      /*hsucur,*/
                                                                      hsubop,
                                                                      dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hsubop desc nulls last) n_priori3
                                                                  from  (

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
                                                                              /*hsucur,*/
                                                                              hsubop,hfcon,hcmod, hsucor, htran, hnrel 
                                                                        
                                                                         from (    
                                                                              
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
                                                                              /*hsucur,*/
                                                                              hsubop,
                                                                              hfcon,hcmod, hsucor, htran, hnrel ,
                                                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                                                        from(                      

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
                                                                              /*hsucur,*/
                                                                              hsubop,
                                                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                                                         /*c.hsucur,*/
                                                                                         c.hsubop,
                                                                                         c.hcodmo,
                                                                                         hfcon,
                                                                                         hcmod, hsucor, htran, hnrel,
                                                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                                                
                                                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.hcmod  =  i.hcmod 
                                                                            and c.hsucor =  i.hsucor
                                                                            and c.htran  =  i.htran 
                                                                            and c.hnrel  =  i.hnrel 
                                                                            and c.hfcon  =  i.hfcon 
                                                                            and hcta <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.hcta
                                                                            and c.hcodmo = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.hcta
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.hsucur = h.sucurs
                                                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);   
                                        END;
                                        
                                   
                                   
                                        
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.hcta
                        --and g.ctxsuc = h.sucurs
                        and c.hsucur = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        /*hsucur,*/
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   /*c.hsucur,*/
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.hcta
                                    --and g.ctxsuc = h.sucurs
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
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.hcta
                              --and g.ctxsuc = h.sucurs
                              and c.hsucur = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        /*hsucur,*/
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   /*c.hsucur,*/
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
         -- Existe
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop ,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295 (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop;  

begin

    INSERT INTO JAQY296(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295 o
   where TRIM(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;

Procedure SP_Unicas_Usu(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date,pc_user in varchar2) is

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
            and l.bc605pais     = o.bc602pais
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
   and b.hccorr        <> 99
   and trim(a.bc604usid)     = trim(pc_user);
   
   
begin

delete from JAQY295 where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296 where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295');
--execute immediate ('truncate table JAQY296');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

for i in tues (Pd_fecini, Pd_fecfin,pc_user) loop
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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
       begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                --and g.ctxcod = 1
                --and g.ctxnro = c.hcta
                --and g.ctxsuc = h.sucurs
                and c.hsucur = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.hcta
                      --and g.ctxsuc = h.sucurs
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
                              hpap,
                              /*hsucur,*/
                              hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop  
                           
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
                                         /*c.hsucur,*/
                                         c.hsubop,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
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
                                              /*hsucur,*/
                                              hsubop
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
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
                                              --hsucur,
                                              hsubop,
                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                        from(                      

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
                                              --hsucur,
                                              hsubop,
                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                         --c.hsucur,
                                                         c.hsubop,
                                                         c.hcodmo,
                                                         hfcon,
                                                         hcmod, hsucor, htran, hnrel,
                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                
                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.hcmod  =  i.hcmod 
                                            and c.hsucor =  i.hsucor
                                            and c.htran  =  i.htran 
                                            and c.hnrel  =  i.hnrel 
                                            and c.hfcon  =  i.hfcon 
                                            and hcta <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.hcta
                                            and c.hcodmo = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs
                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
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
                                                              --hsucur,
                                                              hsubop
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
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
                                                                      --hsucur,
                                                                      hsubop,
                                                                      dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hsubop desc nulls last) n_priori3
                                                                  from  (

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
                                                                              --hsucur,
                                                                              hsubop,hfcon,hcmod, hsucor, htran, hnrel 
                                                                        
                                                                         from (    
                                                                              
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
                                                                              --hsucur,
                                                                              hsubop,
                                                                              hfcon,hcmod, hsucor, htran, hnrel ,
                                                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                                                        from(                      

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
                                                                              --hsucur,
                                                                              hsubop,
                                                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                                                         --c.hsucur,
                                                                                         c.hsubop,
                                                                                         c.hcodmo,
                                                                                         hfcon,
                                                                                         hcmod, hsucor, htran, hnrel,
                                                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                                                
                                                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.hcmod  =  i.hcmod 
                                                                            and c.hsucor =  i.hsucor
                                                                            and c.htran  =  i.htran 
                                                                            and c.hnrel  =  i.hnrel 
                                                                            and c.hfcon  =  i.hfcon 
                                                                            and hcta <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.hcta
                                                                            and c.hcodmo = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.hcta
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.hsucur = h.sucurs
                                                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);   
                                        END;
                                        
                                   
                                   
                                        
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.hcta
                        --and g.ctxsuc = h.sucurs
                        and c.hsucur = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.hcta
                                    --and g.ctxsuc = h.sucurs
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
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.hcta
                              --and g.ctxsuc = h.sucurs
                              and c.hsucur = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
         -- Existe
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295 (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop; 

begin

    INSERT INTO JAQY296(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295 o
   where TRIM(o.jaqy295usuario) = TRIM(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;


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

ld_fecrolben date;

cursor trans_multi (Pd_fecpro in date, ln_tipcam in number, ld_fecrolben in date) is
--create table repom as 
select DISTINCT bc606pais,bc606tdoc,bc606ndoc,bc606fch,bc606treg,bc606impa,
       (case
              when bc606treg = 100 then 'Tramitante'
              when bc606treg = 200 then 'Beneficiario'
              when bc606treg = 300 then 'Ordenante'              
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
       (select (trim(d.bc602nom)||' '||trim(d.bc602ape)||' '||trim(d.bc602apem)) 
          from fbc602 d where bc606pais = d.bc602pais
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
                                 and t.bc606fch = pd_fecpro
                                 and z.bc604emp  = u.bc607emp
                                 and z.bc604mod  = u.bc607mod
                                 and z.bc604suc  = u.bc607suc
                                 and z.bc604trn  = u.bc607trn
                                 and z.bc604nrel = u.bc607nrel
                                 and z.bc604fch  = u.bc607fch
                                 and ( ( t.bc606fch >= ld_fecrolben and t.bc606treg = 200 ) or ( t.bc606fch < ld_fecrolben ) )
                                
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

execute immediate ('truncate table JAQY297');
execute immediate ('truncate table JAQY298');
update jaqy500 set jaqy500flg = 1 where jaqy500cod = 800;COMMIT;

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

begin
  select to_date(trim(to_char(tpnro,'99999999')),'yyyymmdd') 
  into ld_fecrolben
  from fst098 
  where pgcod = 1 
  and tpcod = 7678 
  and tpcorr = 100;  
exception
  when others then
    ld_fecrolben := Pd_fecpro;
end;

for i in trans_multi (Pd_fecpro, ln_tipcam, ld_fecrolben) loop
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
             where sucurs = ln_suc;
         exception 
             when others then null;
         end;
   begin
   insert into JAQY297 (JAQY297TDOC,JAQY297NDOC,JAQY297FCH,JAQY297TREG,JAQY297IMPA,JAQY297NOMCLI,
                      JAQY297ROL,JAQY297DIRCLI,JAQY297TELCLI,JAQY297NOMNOCLI,JAQY297DIRNOCLI,
                      JAQY297TELNOCLI,JAQY297MONTO,JAQY297AGENCIA,JAQY297NROLIST,JAQY297PRIORI,
                      JAQY297LISTDES,JAQY297ANOPRO,JAQY297MESPRO,JAQY297HMODUL,JAQY297HTOPER,
                      JAQY297HMDA,JAQY297HPAP,JAQY297HCTA,JAQY297HOPER,JAQY297HSUBOP,JAQY297HSUCUR,
                      JAQY297PAIS,JAQY297SUCOPE)
      values(i.BC606TDOC,i.BC606NDOC,i.BC606FCH,i.BC606TREG,i.BC606IMPA,i.NOMBRECLIENTE,i.ROL,i.DIRECCIONCLIENTE,
             i.TELEFONOCLIENTE,i.NOMBRENOCLIENTE,i.DIRECCIONNOCLIENTE,i.TELEFONONOCLIENTE,i.bc606impa,lc_age,
             ln_list,ln_priori,lc_lndes,ln_anio, ln_mes,ln_mod,ln_top,ln_mda,ln_pap,ln_cta,ln_ope,
             ln_sbo,ln_suc,i.bc606pais,i.bc607suc);                 
    commit;
    exception
      when others then
        dbms_output.put_line(i.BC606NDOC);
    end; 
end loop;  

Begin

INSERT INTO JAQY298(JAQY298ANOPRO,JAQY298MESPRO,JAQY298NOMCLI,JAQY298ROL,JAQY298DIRCLI,JAQY298TELCLI,
                    JAQY298NOMNOCLI,JAQY298DIRNOCLI,JAQY298TELNOCLI,JAQY298MONTO,JAQY298AGENCIA,
                    JAQY298LISTDES,JAQY298EJE,JAQY298ANA,JAQY298FCH,JAQY298HSUCUR,JAQY298PAIS,
                    JAQY298TDOC,JAQY298NDOC,JAQY298CTA,JAQY298TREG,JAQY298SUCOPE)
       select ja3.JAQY297anopro,
              PQ_OCUM_CALIFICACION.fn_meses(ja3.JAQY297mespro),
              ja3.JAQY297nomcli,
              ja3.JAQY297rol,
              ja3.JAQY297dircli,
              ja3.JAQY297telcli,
              ja3.JAQY297nomnocli,
              ja3.JAQY297dirnocli,
              ja3.JAQY297telnocli,
              ja3.JAQY297monto,
              ja3.JAQY297agencia,
              ja3.JAQY297listdes,
              PQ_OCUM_CALIFICACION.Fn_Ejecutivo(JA3.JAQY297HMODUL,ja3.JAQY297pais,ja3.JAQY297tdoc,ja3.JAQY297ndoc,
                                       ja3.JAQY297hsucur,ja3.JAQY297hmda,ja3.JAQY297hcta,ja3.JAQY297hoper,
                                       ja3.JAQY297htoper),
              PQ_OCUM_CALIFICACION.fn_analista(JA3.JAQY297HMODUL,ja3.JAQY297pais,ja3.JAQY297tdoc,ja3.JAQY297ndoc,
                                       ja3.JAQY297hsucur,ja3.JAQY297hmda,ja3.JAQY297hcta,ja3.JAQY297hoper,
                                       ja3.JAQY297htoper),
              ja3.JAQY297fch,
              ja3.JAQY297hsucur,
              JA3.JAQY297PAIS,
              ja3.jaqy297tdoc,
              ja3.jaqy297ndoc,
              ja3.jaqy297hcta,
              JAQY297TREG,
              ja3.jaqy297sucope
         from JAQY297 ja3;
         
         
     COMMIT;
       
       
end;
begin
    update jaqy500 set jaqy500flg = 0 where jaqy500cod = 800;COMMIT;
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



Procedure SP_Unicas_Diario(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date) is
                select  a.bc604emp, 
                        a.bc604mod, 
                        a.bc604suc, 
                        a.bc604trn, 
                        a.bc604nrel, 
                        a.bc604fch,
                        a.bc604hor,
                        a.bc604ord,
                        b.pgcod pgcod, 
                        --b.hfcon,
                        b.itmod hcmod , 
                        b.itsuc hsucor, 
                        b.ittran htran, 
                        b.itnrel hnrel, 
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
                          and l.bc605pais     = o.bc602pais
                      )TramitanteNoCliente
                from fbc604 a, 
                     fsd015 b,
                     fst034 f,
                     fst001 i
               where a.bc604co     ='S' 
                 and a.bc604fch      between Pd_fecini and Pd_fecfin
                 and a.bc604emp      =1 
                 and a.BC604EMP      = b.pgcod
                 and a.BC604MOD      = b.itmod
                 and a.BC604SUC      = b.itsuc
                 and a.BC604TRN      = b.ittran
                 and a.BC604NREL     = b.itnrel
                 --and a.BC604FCH      = b.hfcon
                 and a.BC604TTrn     in (2,3)
                 and a.bc604emp      = f.pgcod
                 and a.bc604mod      = f.trmod
                 and a.bc604trn      = f.trnro
                 and a.bc604emp      = i.pgcod
                 and a.bc604suc      = i.sucurs
                 and b.itcorr        <> 99;

   
   
begin

delete from JAQY295 where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296 where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295');
--execute immediate ('truncate table JAQY296');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
       begin 
           select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.itmod  = i.hcmod   
                and c.itsuc  = i.hsucor 
                and c.ittran = i.htran   
                and c.itnrel = i.hnrel   
                --and c.hfcon  = i.hfcon 
                and c.ctnro <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.ctnro
                and c.itdbha = 2
                --and g.ctxcod = 1
                --and g.ctxnro = c.ctnro
                --and g.ctxsuc = h.sucurs
                and c.itsucd = h.sucurs
                and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.itmod  = i.hcmod   
                      and c.itsuc  = i.hsucor 
                      and c.ittran = i.htran   
                      and c.itnrel = i.hnrel   
                      --and c.hfcon  = i.hfcon   
                      and c.ctnro <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.ctnro
                      and c.itdbha = 2
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.ctnro
                      --and g.ctxsuc = h.sucurs
                      and c.itsucd = h.sucurs
                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select ctnro, 
                              itoper, 
                              ittope, 
                              scnom , 
                              modulo, 
                              moneda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              itsucd,
                              papel,
                              --itsucd,
                              itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                           
                        from(select distinct c.ctnro, 
                                         c.itoper, 
                                         c.ittope, 
                                         h.scnom , 
                                         c.modulo, 
                                         c.moneda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         C.itsucd,
                                         c.papel,
                                         --c.itsucd,
                                         c.itsubo,
                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                        
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                               begin
                                       select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by ctnro asc nulls last) n_priori2
                                        from(                      

                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              itmod, itsuc, ittran, itnrel              
                                        from(select distinct c.ctnro, 
                                                         c.itoper, 
                                                         c.ittope, 
                                                         h.scnom , 
                                                         c.modulo, 
                                                         c.moneda,
                                                         e.pepais ,
                                                         e.petdoc ,
                                                         e.pendoc ,
                                                         c.itsucd,
                                                         c.papel,
                                                         --c.itsucd,
                                                         c.itsubo,
                                                         itmod, itsuc, ittran, itnrel,
                                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                                                
                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.itmod  =  i.hcmod 
                                            and c.itsuc  =  i.hsucor
                                            and c.ittran =  i.htran 
                                            and c.itnrel =  i.hnrel 
                                            --and c.hfcon  =  i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs
                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
                                                      select  ctnro, 
                                                              itoper, 
                                                              ittope, 
                                                              scnom , 
                                                              modulo, 
                                                              moneda,
                                                              pepais ,
                                                              petdoc ,
                                                              pendoc ,
                                                              itsucd,
                                                              papel,
                                                              --itsucd,
                                                              itsubo
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
                                                                select  ctnro, 
                                                                        itoper, 
                                                                        ittope, 
                                                                        scnom , 
                                                                        modulo, 
                                                                        moneda,
                                                                        pepais ,
                                                                        petdoc ,
                                                                        pendoc ,
                                                                        itsucd,
                                                                        papel,
                                                                        --itsucd,
                                                                        itsubo,
                                                                      dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by itsubo desc nulls last) n_priori3
                                                                  from  (

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel  
                                                                        
                                                                         from (    
                                                                              
                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel ,
                                                                              dense_rank() over(partition by itmod,itsuc,ittran,itnrel  order by ctnro asc nulls last) n_priori2
                                                                        from(                      

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel              
                                                                        from(select distinct c.ctnro, 
                                                                                         c.itoper, 
                                                                                         c.ittope, 
                                                                                         h.scnom , 
                                                                                         c.modulo, 
                                                                                         c.moneda,
                                                                                         e.pepais ,
                                                                                         e.petdoc ,
                                                                                         e.pendoc ,
                                                                                         c.itsucd,
                                                                                         c.papel,
                                                                                         --c.itsucd,
                                                                                         c.itsubo,
                                                                                         c.itdbha,
                                                                                         --hfcon,
                                                                                         itmod,itsuc,ittran,itnrel,
                                                                                         dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by c.itord asc nulls last) n_priori
                                                                                                
                                                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.itmod  =  i.hcmod 
                                                                            and c.itsuc  =  i.hsucor
                                                                            and c.ittran =  i.htran 
                                                                            and c.itnrel =  i.hnrel 
                                                                            --and c.hfcon  =  i.hfcon 
                                                                            and c.ctnro <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.ctnro
                                                                            and c.itdbha = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.ctnro
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.itsucd = h.sucurs
                                                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);   
                                        END;
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                              e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  = i.pgcod 
                                            and c.itmod  = i.hcmod 
                                            and c.itsuc  = i.hsucor
                                            and c.ittran = i.htran 
                                            and c.itnrel = i.hnrel 
                                            --and c.hfcon  = i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.itmod  = i.hcmod   
                        and c.itsuc  = i.hsucor 
                        and c.ittran = i.htran   
                        and c.itnrel = i.hnrel   
                        --and c.hfcon  = i.hfcon   
                        and c.ctnro <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.ctnro
                        and c.itdbha = 2
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.ctnro
                        --and g.ctxsuc = h.sucurs
                        and c.itsucd = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.itmod  = i.hcmod   
                                    and c.itsuc  = i.hsucor 
                                    and c.ittran = i.htran   
                                    and c.itnrel = i.hnrel   
                                    --and c.hfcon  = i.hfcon   
                                    and c.ctnro <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.ctnro
                                    and c.itdbha = 2
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.ctnro
                                    --and g.ctxsuc = h.sucurs
                                    and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.itmod  = i.hcmod   
                              and c.itsuc  = i.hsucor 
                              and c.ittran = i.htran   
                              and c.itnrel = i.hnrel   
                              --and c.hfcon  = i.hfcon   
                              and c.ctnro <> 0
                              and e.ctnro  = c.ctnro
                              and e.cttfir = 'T'
                              and c.itdbha = 2
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.ctnro
                              --and g.ctxsuc = h.sucurs
                              and c.itsucd = h.sucurs
                              and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs
                                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro  <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
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
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsd016 c 
                where c.pgcod  = i.pgcod  
                  and c.itmod  = i.hcmod   
                  and c.itsuc  = i.hsucor 
                  and c.ittran = i.htran   
                  and c.itnrel = i.hnrel   
                  --and c.hfcon  = i.hfcon
                  and c.itord  = i.bc604ord ;
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc 
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc 
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295 (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                
    commit;

end loop;  

begin

    INSERT INTO JAQY296(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295 o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;

Procedure SP_Unicas_Usu_Diario(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date,pc_user in varchar2) is

select  a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod pgcod, 
        b.itmod hcmod,
        b.itsuc hsucor, 
        b.ittran htran, 
        b.itnrel hnrel, 
        --b., 
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
            and l.bc605pais     = o.bc602pais
        )TramitanteNoCliente
  from fbc604 a, 
       fsd015 b,
       fst034 f,
       fst001 i
 where a.bc604co     ='S' 
   and a.bc604fch      between Pd_fecini and Pd_fecfin
   and a.bc604emp      =1 
   and a.BC604EMP      = b.pgcod
   and a.BC604MOD      = b.itmod
   and a.BC604SUC      = b.itsuc
   and a.BC604TRN      = b.ittran
   and a.BC604NREL     = b.itnrel
   --and a.BC604FCH      = b.hfcon
   and a.BC604TTrn     in (2,3)
   and a.bc604emp      = f.pgcod
   and a.bc604mod      = f.trmod
   and a.bc604trn      = f.trnro
   and a.bc604emp      = i.pgcod
   and a.bc604suc      = i.sucurs
   and b.itcorr        <> 99
   and trim(a.bc604usid)     = trim(pc_user);
   
   
begin

delete from JAQY295 where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296 where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295');
--execute immediate ('truncate table JAQY296');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

for i in tues (Pd_fecini, Pd_fecfin,pc_user) loop
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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
        begin 
           select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.itmod  = i.hcmod   
                and c.itsuc  = i.hsucor 
                and c.ittran = i.htran   
                and c.itnrel = i.hnrel   
                --and c.hfcon  = i.hfcon 
                and c.ctnro <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.ctnro
                and c.itdbha = 2
                --and g.ctxcod = 1
                --and g.ctxnro = c.ctnro
                --and g.ctxsuc = h.sucurs
                and c.itsucd = h.sucurs
                and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.itmod  = i.hcmod   
                      and c.itsuc  = i.hsucor 
                      and c.ittran = i.htran   
                      and c.itnrel = i.hnrel   
                      --and c.hfcon  = i.hfcon   
                      and c.ctnro <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.ctnro
                      and c.itdbha = 2
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.ctnro
                      --and g.ctxsuc = h.sucurs
                      and c.itsucd = h.sucurs
                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select ctnro, 
                              itoper, 
                              ittope, 
                              scnom , 
                              modulo, 
                              moneda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              itsucd,
                              papel,
                              --itsucd,
                              itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                           
                        from(select distinct c.ctnro, 
                                         c.itoper, 
                                         c.ittope, 
                                         h.scnom , 
                                         c.modulo, 
                                         c.moneda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.itsucd,
                                         c.papel,
                                         --c.itsucd,
                                         c.itsubo,
                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                        
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                               begin
                                       select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by ctnro asc nulls last) n_priori2
                                        from(                      

                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              itmod, itsuc, ittran, itnrel              
                                        from(select distinct c.ctnro, 
                                                         c.itoper, 
                                                         c.ittope, 
                                                         h.scnom , 
                                                         c.modulo, 
                                                         c.moneda,
                                                         e.pepais ,
                                                         e.petdoc ,
                                                         e.pendoc ,
                                                         c.itsucd,
                                                         c.papel,
                                                         --c.itsucd,
                                                         c.itsubo,
                                                         itmod, itsuc, ittran, itnrel,
                                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                                                
                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.itmod  =  i.hcmod 
                                            and c.itsuc  =  i.hsucor
                                            and c.ittran =  i.htran 
                                            and c.itnrel =  i.hnrel 
                                            --and c.hfcon  =  i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs
                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
                                                      select  ctnro, 
                                                              itoper, 
                                                              ittope, 
                                                              scnom , 
                                                              modulo, 
                                                              moneda,
                                                              pepais ,
                                                              petdoc ,
                                                              pendoc ,
                                                              itsucd,
                                                              papel,
                                                              --itsucd,
                                                              itsubo
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
                                                                select  ctnro, 
                                                                        itoper, 
                                                                        ittope, 
                                                                        scnom , 
                                                                        modulo, 
                                                                        moneda,
                                                                        pepais ,
                                                                        petdoc ,
                                                                        pendoc ,
                                                                        itsucd,
                                                                        papel,
                                                                        --itsucd,
                                                                        itsubo,
                                                                      dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by itsubo desc nulls last) n_priori3
                                                                  from  (

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel  
                                                                        
                                                                         from (    
                                                                              
                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel ,
                                                                              dense_rank() over(partition by itmod,itsuc,ittran,itnrel  order by ctnro asc nulls last) n_priori2
                                                                        from(                      

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel              
                                                                        from(select distinct c.ctnro, 
                                                                                         c.itoper, 
                                                                                         c.ittope, 
                                                                                         h.scnom , 
                                                                                         c.modulo, 
                                                                                         c.moneda,
                                                                                         e.pepais ,
                                                                                         e.petdoc ,
                                                                                         e.pendoc ,
                                                                                         c.itsucd,
                                                                                         c.papel,
                                                                                         --c.itsucd,
                                                                                         c.itsubo,
                                                                                         c.itdbha,
                                                                                         --hfcon,
                                                                                         itmod,itsuc,ittran,itnrel,
                                                                                         dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by c.itord asc nulls last) n_priori
                                                                                                
                                                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.itmod  =  i.hcmod 
                                                                            and c.itsuc  =  i.hsucor
                                                                            and c.ittran =  i.htran 
                                                                            and c.itnrel =  i.hnrel 
                                                                            --and c.hfcon  =  i.hfcon 
                                                                            and c.ctnro <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.ctnro
                                                                            and c.itdbha = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.ctnro
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.itsucd = h.sucurs
                                                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);   
                                        END;
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                              e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  = i.pgcod 
                                            and c.itmod  = i.hcmod 
                                            and c.itsuc  = i.hsucor
                                            and c.ittran = i.htran 
                                            and c.itnrel = i.hnrel 
                                            --and c.hfcon  = i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.itmod  = i.hcmod   
                        and c.itsuc  = i.hsucor 
                        and c.ittran = i.htran   
                        and c.itnrel = i.hnrel   
                        --and c.hfcon  = i.hfcon   
                        and c.ctnro <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.ctnro
                        and c.itdbha = 2
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.ctnro
                        --and g.ctxsuc = h.sucurs
                        and c.itsucd = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.itmod  = i.hcmod   
                                    and c.itsuc  = i.hsucor 
                                    and c.ittran = i.htran   
                                    and c.itnrel = i.hnrel   
                                    --and c.hfcon  = i.hfcon   
                                    and c.ctnro <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.ctnro
                                    and c.itdbha = 2
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.ctnro
                                    --and g.ctxsuc = h.sucurs
                                    and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.itmod  = i.hcmod   
                              and c.itsuc  = i.hsucor 
                              and c.ittran = i.htran   
                              and c.itnrel = i.hnrel   
                              --and c.hfcon  = i.hfcon   
                              and c.ctnro <> 0
                              and e.ctnro  = c.ctnro
                              and e.cttfir = 'T'
                              and c.itdbha = 2
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.ctnro
                              --and g.ctxsuc = h.sucurs
                              and c.itsucd = h.sucurs
                              and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs
                                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro  <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
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
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsd016 c 
                where c.pgcod  = i.pgcod  
                  and c.itmod  = i.hcmod   
                  and c.itsuc  = i.hsucor 
                  and c.ittran = i.htran   
                  and c.itnrel = i.hnrel   
                  --and c.hfcon  = i.hfcon
                  and c.itord  = i.bc604ord ;
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc 
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295 (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                
    commit;

end loop;  

begin

    INSERT INTO JAQY296(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295 o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;



Procedure SP_Unicas_H(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date) is
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
                          and l.bc605pais     = o.bc602pais
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

   
   
begin

delete from JAQY295_H where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296_H where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295_H');
--execute immediate ('truncate table JAQY296_H');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   
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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
      begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                --and g.ctxcod = 1
                --and g.ctxnro = c.hcta
                --and g.ctxsuc = h.sucurs
                and c.hsucur = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.hcta
                      --and g.ctxsuc = h.sucurs
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
                              hpap,
                              --hsucur,
                              hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop  
                           
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
                                         --c.hsucur,
                                         c.hsubop,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
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
                                              --hsucur,
                                              hsubop
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
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
                                              --hsucur,
                                              hsubop,
                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                        from(                      

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
                                              --hsucur,
                                              hsubop,
                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                         --c.hsucur,
                                                         c.hsubop,
                                                         c.hcodmo,
                                                         hfcon,
                                                         hcmod, hsucor, htran, hnrel,
                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                
                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.hcmod  =  i.hcmod 
                                            and c.hsucor =  i.hsucor
                                            and c.htran  =  i.htran 
                                            and c.hnrel  =  i.hnrel 
                                            and c.hfcon  =  i.hfcon 
                                            and hcta <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.hcta
                                            and c.hcodmo = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs
                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
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
                                                              --hsucur,
                                                              hsubop
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
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
                                                                      --hsucur,
                                                                      hsubop,
                                                                      dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hsubop desc nulls last) n_priori3
                                                                  from  (

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
                                                                              --hsucur,
                                                                              hsubop,hfcon,hcmod, hsucor, htran, hnrel 
                                                                        
                                                                         from (    
                                                                              
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
                                                                              --hsucur,
                                                                              hsubop,
                                                                              hfcon,hcmod, hsucor, htran, hnrel ,
                                                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                                                        from(                      

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
                                                                              --hsucur,
                                                                              hsubop,
                                                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                                                         --c.hsucur,
                                                                                         c.hsubop,
                                                                                         c.hcodmo,
                                                                                         hfcon,
                                                                                         hcmod, hsucor, htran, hnrel,
                                                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                                                
                                                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.hcmod  =  i.hcmod 
                                                                            and c.hsucor =  i.hsucor
                                                                            and c.htran  =  i.htran 
                                                                            and c.hnrel  =  i.hnrel 
                                                                            and c.hfcon  =  i.hfcon 
                                                                            and hcta <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.hcta
                                                                            and c.hcodmo = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.hcta
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.hsucur = h.sucurs
                                                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);   
                                        END;
                                        
                                   
                                   
                                        
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.hcta
                        --and g.ctxsuc = h.sucurs
                        and c.hsucur = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.hcta
                                    --and g.ctxsuc = h.sucurs
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
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.hcta
                              --and g.ctxsuc = h.sucurs
                              and c.hsucur = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
         -- Existe
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc 
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295_H (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop;   

begin

    INSERT INTO JAQY296_H(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295_H o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;

Procedure SP_Unicas_Usu_H(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date,pc_user in varchar2) is

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
            and l.bc605pais     = o.bc602pais
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
   and b.hccorr        <> 99
   and trim(a.bc604usid)     = trim(pc_user);
   
   
begin

delete from JAQY295_H where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296_H where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295_H');
--execute immediate ('truncate table JAQY296_H');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

for i in tues (Pd_fecini, Pd_fecfin,pc_user) loop
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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
      begin 
           select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                --and g.ctxcod = 1
                --and g.ctxnro = c.hcta
                --and g.ctxsuc = h.sucurs
                and c.hsucur = h.sucurs
                and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.hcta
                      --and g.ctxsuc = h.sucurs
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
                              hpap,
                              --hsucur,
                              hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop  
                           
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
                                         --c.hsucur,
                                         c.hsubop,
                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                        
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
                            and c.hsucur = h.sucurs
                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
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
                                              --hsucur,
                                              hsubop
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
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
                                              --hsucur,
                                              hsubop,
                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                        from(                      

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
                                              --hsucur,
                                              hsubop,
                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                         --c.hsucur,
                                                         c.hsubop,
                                                         c.hcodmo,
                                                         hfcon,
                                                         hcmod, hsucor, htran, hnrel,
                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                
                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.hcmod  =  i.hcmod 
                                            and c.hsucor =  i.hsucor
                                            and c.htran  =  i.htran 
                                            and c.hnrel  =  i.hnrel 
                                            and c.hfcon  =  i.hfcon 
                                            and hcta <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.hcta
                                            and c.hcodmo = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs
                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
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
                                                              --hsucur,
                                                              hsubop
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
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
                                                                      --hsucur,
                                                                      hsubop,
                                                                      dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hsubop desc nulls last) n_priori3
                                                                  from  (

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
                                                                              --hsucur,
                                                                              hsubop,hfcon,hcmod, hsucor, htran, hnrel 
                                                                        
                                                                         from (    
                                                                              
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
                                                                              --hsucur,
                                                                              hsubop,
                                                                              hfcon,hcmod, hsucor, htran, hnrel ,
                                                                              dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by hcta asc nulls last) n_priori2
                                                                        from(                      

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
                                                                              --hsucur,
                                                                              hsubop,
                                                                               hfcon,hcmod, hsucor, htran, hnrel               
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
                                                                                         --c.hsucur,
                                                                                         c.hsubop,
                                                                                         c.hcodmo,
                                                                                         hfcon,
                                                                                         hcmod, hsucor, htran, hnrel,
                                                                                         dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                                                                                
                                                                        from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.hcmod  =  i.hcmod 
                                                                            and c.hsucor =  i.hsucor
                                                                            and c.htran  =  i.htran 
                                                                            and c.hnrel  =  i.hnrel 
                                                                            and c.hfcon  =  i.hfcon 
                                                                            and hcta <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.hcta
                                                                            and c.hcodmo = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.hcta
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.hsucur = h.sucurs
                                                                            and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);   
                                        END;
                                        
                                   
                                   
                                        
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.hcta
                                            --and g.ctxsuc = h.sucurs
                                            and c.hsucur = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel||'-'||i.hfcon);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                          e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.hcta
                        --and g.ctxsuc = h.sucurs
                        and c.hsucur = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                              e.pepais ,e.petdoc ,e.pendoc ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.hcta
                            --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.hcta
                                    --and g.ctxsuc = h.sucurs
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
                               e.pepais ,e.petdoc ,e.pendoc  ,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
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
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.hcta
                              --and g.ctxsuc = h.sucurs
                              and c.hsucur = h.sucurs
                              and c.hmodul in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.hcta, c.hoper, c.htoper, h.scnom , c.hmodul, c.hmda,
                                       e.pepais ,e.petdoc ,e.pendoc,c.hsucur,c.hpap,/*c.hsucur,*/c.hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
                                        hpap,
                                        --hsucur,
                                        hsubop
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
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
                                                   --c.hsucur,
                                                   c.hsubop,
                                                   dense_rank() over(partition by hcmod, hsucor, htran, hnrel, hfcon order by c.hcord asc nulls last) n_priori
                                  
                                 from fsh016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.hcmod  = i.hcmod   
                                      and c.hsucor = i.hsucor 
                                      and c.htran  = i.htran   
                                      and c.hnrel  = i.hnrel   
                                      and c.hfcon  = i.hfcon   
                                      and hcta <> 0
                                      and e.ctnro  = c.hcta
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.hcta
                                      --and g.ctxsuc = h.sucurs
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
         -- Existe
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc 
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc 
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
   insert into JAQY295_H (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop; 

begin

    INSERT INTO JAQY296_H(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295_H o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;


Procedure SP_Unicas_Diario_D(Pd_fecini in date,Pd_fecfin in date,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date) is
                select  a.bc604emp, 
                        a.bc604mod, 
                        a.bc604suc, 
                        a.bc604trn, 
                        a.bc604nrel, 
                        a.bc604fch,
                        a.bc604hor,
                        a.bc604ord,
                        b.pgcod pgcod, 
                        --b.hfcon,
                        b.itmod hcmod , 
                        b.itsuc hsucor, 
                        b.ittran htran, 
                        b.itnrel hnrel, 
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
                          and l.bc605pais     = o.bc602pais
                      )TramitanteNoCliente
                from fbc604 a, 
                     fsd015 b,
                     fst034 f,
                     fst001 i
               where a.bc604co     ='S' 
                 and a.bc604fch      between Pd_fecini and Pd_fecfin
                 and a.bc604emp      =1 
                 and a.BC604EMP      = b.pgcod
                 and a.BC604MOD      = b.itmod
                 and a.BC604SUC      = b.itsuc
                 and a.BC604TRN      = b.ittran
                 and a.BC604NREL     = b.itnrel
                 --and a.BC604FCH      = b.hfcon
                 and a.BC604TTrn     in (2,3)
                 and a.bc604emp      = f.pgcod
                 and a.bc604mod      = f.trmod
                 and a.bc604trn      = f.trnro
                 and a.bc604emp      = i.pgcod
                 and a.bc604suc      = i.sucurs
                 and b.itcorr        <> 99;

   
   
begin

delete from JAQY295_D where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296_D where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295_D');
--execute immediate ('truncate table JAQY296_D');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
       begin 
           select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.itmod  = i.hcmod   
                and c.itsuc  = i.hsucor 
                and c.ittran = i.htran   
                and c.itnrel = i.hnrel   
                --and c.hfcon  = i.hfcon 
                and c.ctnro <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.ctnro
                and c.itdbha = 2
                --and g.ctxcod = 1
                --and g.ctxnro = c.ctnro
                --and g.ctxsuc = h.sucurs
                and c.itsucd = h.sucurs
                and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.itmod  = i.hcmod   
                      and c.itsuc  = i.hsucor 
                      and c.ittran = i.htran   
                      and c.itnrel = i.hnrel   
                      --and c.hfcon  = i.hfcon   
                      and c.ctnro <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.ctnro
                      and c.itdbha = 2
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.ctnro
                      --and g.ctxsuc = h.sucurs
                      and c.itsucd = h.sucurs
                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select ctnro, 
                              itoper, 
                              ittope, 
                              scnom , 
                              modulo, 
                              moneda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              itsucd,
                              papel,
                              --itsucd,
                              itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                           
                        from(select distinct c.ctnro, 
                                         c.itoper, 
                                         c.ittope, 
                                         h.scnom , 
                                         c.modulo, 
                                         c.moneda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.itsucd,
                                         c.papel,
                                         --c.itsucd,
                                         c.itsubo,
                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                        
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                               begin
                                       select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by ctnro asc nulls last) n_priori2
                                        from(                      

                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              itmod, itsuc, ittran, itnrel              
                                        from(select distinct c.ctnro, 
                                                         c.itoper, 
                                                         c.ittope, 
                                                         h.scnom , 
                                                         c.modulo, 
                                                         c.moneda,
                                                         e.pepais ,
                                                         e.petdoc ,
                                                         e.pendoc ,
                                                         c.itsucd,
                                                         c.papel,
                                                         --c.itsucd,
                                                         c.itsubo,
                                                         itmod, itsuc, ittran, itnrel,
                                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                                                
                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.itmod  =  i.hcmod 
                                            and c.itsuc  =  i.hsucor
                                            and c.ittran =  i.htran 
                                            and c.itnrel =  i.hnrel 
                                            --and c.hfcon  =  i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs
                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
                                                      select  ctnro, 
                                                              itoper, 
                                                              ittope, 
                                                              scnom , 
                                                              modulo, 
                                                              moneda,
                                                              pepais ,
                                                              petdoc ,
                                                              pendoc ,
                                                              itsucd,
                                                              papel,
                                                              --itsucd,
                                                              itsubo
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
                                                                select  ctnro, 
                                                                        itoper, 
                                                                        ittope, 
                                                                        scnom , 
                                                                        modulo, 
                                                                        moneda,
                                                                        pepais ,
                                                                        petdoc ,
                                                                        pendoc ,
                                                                        itsucd,
                                                                        papel,
                                                                        --itsucd,
                                                                        itsubo,
                                                                      dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by itsubo desc nulls last) n_priori3
                                                                  from  (

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel  
                                                                        
                                                                         from (    
                                                                              
                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel ,
                                                                              dense_rank() over(partition by itmod,itsuc,ittran,itnrel  order by ctnro asc nulls last) n_priori2
                                                                        from(                      

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel              
                                                                        from(select distinct c.ctnro, 
                                                                                         c.itoper, 
                                                                                         c.ittope, 
                                                                                         h.scnom , 
                                                                                         c.modulo, 
                                                                                         c.moneda,
                                                                                         e.pepais ,
                                                                                         e.petdoc ,
                                                                                         e.pendoc ,
                                                                                         c.itsucd,
                                                                                         c.papel,
                                                                                         --c.itsucd,
                                                                                         c.itsubo,
                                                                                         c.itdbha,
                                                                                         --hfcon,
                                                                                         itmod,itsuc,ittran,itnrel,
                                                                                         dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by c.itord asc nulls last) n_priori
                                                                                                
                                                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.itmod  =  i.hcmod 
                                                                            and c.itsuc  =  i.hsucor
                                                                            and c.ittran =  i.htran 
                                                                            and c.itnrel =  i.hnrel 
                                                                            --and c.hfcon  =  i.hfcon 
                                                                            and c.ctnro <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.ctnro
                                                                            and c.itdbha = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.ctnro
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.itsucd = h.sucurs
                                                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);   
                                        END;
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                              e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  = i.pgcod 
                                            and c.itmod  = i.hcmod 
                                            and c.itsuc  = i.hsucor
                                            and c.ittran = i.htran 
                                            and c.itnrel = i.hnrel 
                                            --and c.hfcon  = i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.itmod  = i.hcmod   
                        and c.itsuc  = i.hsucor 
                        and c.ittran = i.htran   
                        and c.itnrel = i.hnrel   
                        --and c.hfcon  = i.hfcon   
                        and c.ctnro <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.ctnro
                        and c.itdbha = 2
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.ctnro
                        --and g.ctxsuc = h.sucurs
                        and c.itsucd = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.itmod  = i.hcmod   
                                    and c.itsuc  = i.hsucor 
                                    and c.ittran = i.htran   
                                    and c.itnrel = i.hnrel   
                                    --and c.hfcon  = i.hfcon   
                                    and c.ctnro <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.ctnro
                                    and c.itdbha = 2
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.ctnro
                                    --and g.ctxsuc = h.sucurs
                                    and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.itmod  = i.hcmod   
                              and c.itsuc  = i.hsucor 
                              and c.ittran = i.htran   
                              and c.itnrel = i.hnrel   
                              --and c.hfcon  = i.hfcon   
                              and c.ctnro <> 0
                              and e.ctnro  = c.ctnro
                              and e.cttfir = 'T'
                              and c.itdbha = 2
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.ctnro
                              --and g.ctxsuc = h.sucurs
                              and c.itsucd = h.sucurs
                              and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs
                                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro  <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
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
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsd016 c 
                where c.pgcod  = i.pgcod  
                  and c.itmod  = i.hcmod   
                  and c.itsuc  = i.hsucor 
                  and c.ittran = i.htran   
                  and c.itnrel = i.hnrel   
                  --and c.hfcon  = i.hfcon
                  and c.itord  = i.bc604ord ;
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
  insert into JAQY295_D (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop;  

begin

    INSERT INTO JAQY296_D(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295_D o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;

Procedure SP_Unicas_Usu_Diario_D(Pd_fecini in date,Pd_fecfin in date,pc_user in varchar2,pc_ubuser in varchar2) is

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
--ln_sucP number;
lc_flag char(5);
ln_sbopP number(5);
ln_instancia number(20);
lc_analista char(10);
ln_sucCre number(3);
cursor tues (Pd_fecini in date, Pd_fecfin in date,pc_user in varchar2) is

select  a.bc604emp, 
        a.bc604mod, 
        a.bc604suc, 
        a.bc604trn, 
        a.bc604nrel, 
        a.bc604fch,
        a.bc604hor,
        a.bc604ord,
        b.pgcod pgcod, 
        b.itmod hcmod,
        b.itsuc hsucor, 
        b.ittran htran, 
        b.itnrel hnrel, 
        --b., 
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
            and l.bc605pais     = o.bc602pais
        )TramitanteNoCliente
  from fbc604 a, 
       fsd015 b,
       fst034 f,
       fst001 i
 where a.bc604co     ='S' 
   and a.bc604fch      between Pd_fecini and Pd_fecfin
   and a.bc604emp      =1 
   and a.BC604EMP      = b.pgcod
   and a.BC604MOD      = b.itmod
   and a.BC604SUC      = b.itsuc
   and a.BC604TRN      = b.ittran
   and a.BC604NREL     = b.itnrel
   --and a.BC604FCH      = b.hfcon
   and a.BC604TTrn     in (2,3)
   and a.bc604emp      = f.pgcod
   and a.bc604mod      = f.trmod
   and a.bc604trn      = f.trnro
   and a.bc604emp      = i.pgcod
   and a.bc604suc      = i.sucurs
   and b.itcorr        <> 99
   and trim(a.bc604usid)     = trim(pc_user);
   
   
begin

delete from JAQY295_D where TRIM(JAQY295usuario) = TRIM(pc_ubuser);
COMMIT;
delete from JAQY296_D where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
COMMIT;
--execute immediate ('truncate table JAQY295_D');
--execute immediate ('truncate table JAQY296_D');
--update jaqy500 set jaqy500flg = 1 where jaqy500cod = 700;COMMIT;
                   

for i in tues (Pd_fecini, Pd_fecfin,pc_user) loop
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
--ln_sucP    := null;
lc_flag    := null;
ln_sbopP   := null;
ln_instancia := null;
lc_analista  := null;
ln_sucCre    := null;
       lc_analista := i.operador;
         begin 
           select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
            into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                 ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
           from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
              where c.pgcod  = i.pgcod  
                and c.itmod  = i.hcmod   
                and c.itsuc  = i.hsucor 
                and c.ittran = i.htran   
                and c.itnrel = i.hnrel   
                --and c.hfcon  = i.hfcon 
                and c.ctnro <> 0
                and e.cttfir = 'T'     
                and e.ctnro  = c.ctnro
                and c.itdbha = 2
                --and g.ctxcod = 1
                --and g.ctxnro = c.ctnro
                --and g.ctxsuc = h.sucurs
                and c.itsucd = h.sucurs
                and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
         exception
           when too_many_rows then
               begin
                   select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                    where c.pgcod  = i.pgcod  
                      and c.itmod  = i.hcmod   
                      and c.itsuc  = i.hsucor 
                      and c.ittran = i.htran   
                      and c.itnrel = i.hnrel   
                      --and c.hfcon  = i.hfcon   
                      and c.ctnro <> 0
                      and e.cttfir = 'T'     
                      and e.ctnro  = c.ctnro
                      and c.itdbha = 2
                      --and g.ctxcod = 1
                      --and g.ctxnro = c.ctnro
                      --and g.ctxsuc = h.sucurs
                      and c.itsucd = h.sucurs
                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 );
                  exception
                    when too_many_rows then
                       begin
                       
                       select ctnro, 
                              itoper, 
                              ittope, 
                              scnom , 
                              modulo, 
                              moneda,
                              pepais ,
                              petdoc ,
                              pendoc ,
                              itsucd,
                              papel,
                              --itsucd,
                              itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                           
                        from(select distinct c.ctnro, 
                                         c.itoper, 
                                         c.ittope, 
                                         h.scnom , 
                                         c.modulo, 
                                         c.moneda,
                                         e.pepais ,
                                         e.petdoc ,
                                         e.pendoc ,
                                         c.itsucd,
                                         c.papel,
                                         --c.itsucd,
                                         c.itsubo,
                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                        
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'     
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                    where n_priori = 1
                            ;
                        exception
                          when too_many_rows then
                               begin
                                       select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo
                                         into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                         from (    
                                              
                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by ctnro asc nulls last) n_priori2
                                        from(                      

                                        select ctnro, 
                                              itoper, 
                                              ittope, 
                                              scnom , 
                                              modulo, 
                                              moneda,
                                              pepais ,
                                              petdoc ,
                                              pendoc ,
                                              itsucd,
                                              papel,
                                              --itsucd,
                                              itsubo,
                                              itmod, itsuc, ittran, itnrel              
                                        from(select distinct c.ctnro, 
                                                         c.itoper, 
                                                         c.ittope, 
                                                         h.scnom , 
                                                         c.modulo, 
                                                         c.moneda,
                                                         e.pepais ,
                                                         e.petdoc ,
                                                         e.pendoc ,
                                                         c.itsucd,
                                                         c.papel,
                                                         --c.itsucd,
                                                         c.itsubo,
                                                         itmod, itsuc, ittran, itnrel,
                                                         dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                                                
                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  =  i.pgcod 
                                            and c.itmod  =  i.hcmod 
                                            and c.itsuc  =  i.hsucor
                                            and c.ittran =  i.htran 
                                            and c.itnrel =  i.hnrel 
                                            --and c.hfcon  =  i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs
                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                            where n_priori = 1))
                                            where n_priori2 = 1;
                               
                               
                               exception
                                   when too_many_rows then
                                        BEGIN
                                                      select  ctnro, 
                                                              itoper, 
                                                              ittope, 
                                                              scnom , 
                                                              modulo, 
                                                              moneda,
                                                              pepais ,
                                                              petdoc ,
                                                              pendoc ,
                                                              itsucd,
                                                              papel,
                                                              --itsucd,
                                                              itsubo
                                                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                                           from (
                                                                select  ctnro, 
                                                                        itoper, 
                                                                        ittope, 
                                                                        scnom , 
                                                                        modulo, 
                                                                        moneda,
                                                                        pepais ,
                                                                        petdoc ,
                                                                        pendoc ,
                                                                        itsucd,
                                                                        papel,
                                                                        --itsucd,
                                                                        itsubo,
                                                                      dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by itsubo desc nulls last) n_priori3
                                                                  from  (

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel  
                                                                        
                                                                         from (    
                                                                              
                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel ,
                                                                              dense_rank() over(partition by itmod,itsuc,ittran,itnrel  order by ctnro asc nulls last) n_priori2
                                                                        from(                      

                                                                        select ctnro, 
                                                                              itoper, 
                                                                              ittope, 
                                                                              scnom , 
                                                                              modulo, 
                                                                              moneda,
                                                                              pepais ,
                                                                              petdoc ,
                                                                              pendoc ,
                                                                              itsucd,
                                                                              papel,
                                                                              --itsucd,
                                                                              itsubo,
                                                                               itmod,itsuc,ittran,itnrel              
                                                                        from(select distinct c.ctnro, 
                                                                                         c.itoper, 
                                                                                         c.ittope, 
                                                                                         h.scnom , 
                                                                                         c.modulo, 
                                                                                         c.moneda,
                                                                                         e.pepais ,
                                                                                         e.petdoc ,
                                                                                         e.pendoc ,
                                                                                         c.itsucd,
                                                                                         c.papel,
                                                                                         --c.itsucd,
                                                                                         c.itsubo,
                                                                                         c.itdbha,
                                                                                         --hfcon,
                                                                                         itmod,itsuc,ittran,itnrel,
                                                                                         dense_rank() over(partition by itmod,itsuc,ittran,itnrel order by c.itord asc nulls last) n_priori
                                                                                                
                                                                        from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                                                          where c.pgcod  =  i.pgcod 
                                                                            and c.itmod  =  i.hcmod 
                                                                            and c.itsuc  =  i.hsucor
                                                                            and c.ittran =  i.htran 
                                                                            and c.itnrel =  i.hnrel 
                                                                            --and c.hfcon  =  i.hfcon 
                                                                            and c.ctnro <> 0
                                                                            and e.cttfir = 'T'     
                                                                            and e.ctnro  = c.ctnro
                                                                            and c.itdbha = 2
                                                                            --and g.ctxcod = 1
                                                                            --and g.ctxnro = c.ctnro
                                                                            --and g.ctxsuc = h.sucurs
                                                                            and c.itsucd = h.sucurs
                                                                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod and bb.dscod <> 52 ))
                                                                            where n_priori = 1))
                                                                            where n_priori2 = 1))
                                                                 WHERE n_priori3 = 1;
                                                      
                                        
                                        EXCEPTION 
                                           when too_many_rows then   
                                                dbms_output.put_line ('mas de 1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                           when no_data_found then     
                                                dbms_output.put_line ('mas de 1.1.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);   
                                        END;
                                        
                                   when no_data_found then     
                                        dbms_output.put_line ('mas de 1.2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                        
                               end;
                             
                          
                          when no_data_found then 
                             dbms_output.put_line ('nohaydata1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                        end ;
                    
                    when no_data_found then 
                    
                         begin
                              select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                              e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                       into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                              ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop 
                                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                          where c.pgcod  = i.pgcod 
                                            and c.itmod  = i.hcmod 
                                            and c.itsuc  = i.hsucor
                                            and c.ittran = i.htran 
                                            and c.itnrel = i.hnrel 
                                            --and c.hfcon  = i.hfcon 
                                            and c.ctnro <> 0
                                            and e.cttfir = 'T'     
                                            and e.ctnro  = c.ctnro
                                            and c.itdbha = 2
                                            --and g.ctxcod = 1
                                            --and g.ctxnro = c.ctnro
                                            --and g.ctxsuc = h.sucurs
                                            and c.itsucd = h.sucurs;
                         exception
                              when too_many_rows then
                                   dbms_output.put_line ('mas de 2.1: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                              when no_data_found then   
                                   dbms_output.put_line ('nohaydata2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);       
                         end;
                                         
                  end ;
                  
                  
           when no_data_found then
               begin
                  select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                    into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                         ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                   from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                      where c.pgcod  = i.pgcod  
                        and c.itmod  = i.hcmod   
                        and c.itsuc  = i.hsucor 
                        and c.ittran = i.htran   
                        and c.itnrel = i.hnrel   
                        --and c.hfcon  = i.hfcon   
                        and c.ctnro <> 0
                        and e.cttfir = 'T'  
                        and e.ctnro  = c.ctnro
                        and c.itdbha = 2
                        --and g.ctxcod = 1
                        --and g.ctxnro = c.ctnro
                        --and g.ctxsuc = h.sucurs
                        and c.itsucd = h.sucurs;
               exception 
                 when too_many_rows then 
                   begin 
                       select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                        into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                             ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                       from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                          where c.pgcod  = i.pgcod  
                            and c.itmod  = i.hcmod   
                            and c.itsuc  = i.hsucor 
                            and c.ittran = i.htran   
                            and c.itnrel = i.hnrel   
                            --and c.hfcon  = i.hfcon   
                            and c.ctnro <> 0
                            and e.cttfir = 'T'  
                            and e.ctnro  = c.ctnro
                            and c.itdbha = 2
                            --and g.ctxcod = 1
                            --and g.ctxnro = c.ctnro
                            --and g.ctxsuc = h.sucurs
                            and c.itsucd = h.sucurs
                            and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception
                         when no_data_found then
                              begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                  where c.pgcod  = i.pgcod  
                                    and c.itmod  = i.hcmod   
                                    and c.itsuc  = i.hsucor 
                                    and c.ittran = i.htran   
                                    and c.itnrel = i.hnrel   
                                    --and c.hfcon  = i.hfcon   
                                    and c.ctnro <> 0
                                    and e.cttfir = 'T'  
                                    and e.ctnro  = c.ctnro
                                    and c.itdbha = 2
                                    --and g.ctxcod = 1
                                    --and g.ctxnro = c.ctnro
                                    --and g.ctxsuc = h.sucurs
                                    and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 2: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata5: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
                                  end ;
                             
                     end;
                 when no_data_found then
                      begin
                        select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                          into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                               ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                         from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                            where c.pgcod  = i.pgcod  
                              and c.itmod  = i.hcmod   
                              and c.itsuc  = i.hsucor 
                              and c.ittran = i.htran   
                              and c.itnrel = i.hnrel   
                              --and c.hfcon  = i.hfcon   
                              and c.ctnro <> 0
                              and e.ctnro  = c.ctnro
                              and e.cttfir = 'T'
                              and c.itdbha = 2
                              --and g.ctxcod = 1
                              --and g.ctxnro = c.ctnro
                              --and g.ctxsuc = h.sucurs
                              and c.itsucd = h.sucurs
                              and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                     exception 
                       when no_data_found then
                            begin
                                select distinct c.ctnro, c.itoper, c.ittope, h.scnom , c.modulo, c.moneda,
                                  e.pepais ,e.petdoc ,e.pendoc  ,c.itsucd,c.papel,/*c.itsucd,*/c.itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs
                                      and c.modulo in (select aa.modulo from fst111 aa , fst110 bb where aa.dscod = bb.dscod );
                             exception 
                               when no_data_found then
                               begin
                       
                                 select ctnro, 
                                        itoper, 
                                        ittope, 
                                        scnom , 
                                        modulo, 
                                        moneda,
                                        pepais ,
                                        petdoc ,
                                        pendoc ,
                                        itsucd,
                                        papel,
                                        --itsucd,
                                        itsubo
                                  into ln_cta, ln_oper, ln_toper, lc_suc, ln_mod, ln_mda,
                                       ln_pais, ln_tdoc, lc_numdoc,ln_suc,ln_pap,/*ln_sucP,*/ln_sbop      
                                     
                                  from(select distinct c.ctnro, 
                                                   c.itoper, 
                                                   c.ittope, 
                                                   h.scnom , 
                                                   c.modulo, 
                                                   c.moneda,
                                                   e.pepais ,
                                                   e.petdoc ,
                                                   e.pendoc ,
                                                   c.itsucd,
                                                   c.papel,
                                                   --c.itsucd,
                                                   c.itsubo,
                                                   dense_rank() over(partition by itmod, itsuc, ittran, itnrel order by c.itord asc nulls last) n_priori
                                  
                                 from fsd016 c, fsr008 e,/*fse008 g,*/fst001 h 
                                    where c.pgcod  = i.pgcod  
                                      and c.itmod  = i.hcmod   
                                      and c.itsuc  = i.hsucor 
                                      and c.ittran = i.htran   
                                      and c.itnrel = i.hnrel   
                                      --and c.hfcon  = i.hfcon   
                                      and c.ctnro  <> 0
                                      and e.ctnro  = c.ctnro
                                      and e.cttfir = 'T'
                                      --and g.ctxcod = 1
                                      --and g.ctxnro = c.ctnro
                                      --and g.ctxsuc = h.sucurs
                                      and c.itsucd = h.sucurs)
                              where n_priori = 1
                                      ;
                                  exception
                                    when too_many_rows then
                                       dbms_output.put_line ('mas de 33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);
                                    
                                    when no_data_found then 
                                       dbms_output.put_line ('nohaydata33: '||i.hcmod||'-'||i.hsucor||'-'||i.htran||'-'||i.hnrel);                  
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
         -- Existe
          begin
            select distinct 'S'   
              into lc_existe
             from fsd016 c 
                where c.pgcod  = i.pgcod  
                  and c.itmod  = i.hcmod   
                  and c.itsuc  = i.hsucor 
                  and c.ittran = i.htran   
                  and c.itnrel = i.hnrel   
                  --and c.hfcon  = i.hfcon
                  and c.itord  = i.bc604ord ;
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
         
         ---Analista si es cancelacion total adelantada o pago parcial     
         
         if i.hcmod = 30and i.htran = 150 then --CANCELACION ADELANTADA
            begin
                 select case
                           when i.bc604fch < aofvto then 'S'
                           else 'N'
                        end,
                        aosbop,aosuc 
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select case
                                         when i.bc604fch < aofvto then 'S'
                                         else 'N'
                                      end,
                                      b.aosbop,aosuc
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;   
         
         if i.hcmod = 30and i.htran = 100 then --PAGO PARCIAL
            begin
                 select 'S',aosbop,aosuc 
                   into lc_flag,ln_sbopP,ln_sucCre
                   from fsd010  
                  where fsd010.pgcod  = 1
                    and fsd010.aomod  = ln_mod
                    and fsd010.aosuc  = ln_suc
                    and fsd010.aomda  = ln_mda
                    and fsd010.aopap  = 0
                    and fsd010.aocta  = ln_cta
                    and fsd010.aooper = ln_oper
                    and fsd010.aosbop = ln_sbop
                    and fsd010.aotope = ln_toper
                    and fsd010.aostat <> 99
                    and rownum = 1;
                    
                    exception
                        when no_data_found then
                             Begin
                               select 'S',b.aosbop,aosuc  
                                 into lc_flag,ln_sbopP,ln_sucCre
                                 from fsd010 b
                                where b.pgcod  = 1
                                  and b.aomod  = ln_mod
                                  and b.aosuc  = ln_suc
                                  and b.aomda  = ln_mda
                                  and b.aopap  = 0
                                  and b.aocta  = ln_cta
                                  and b.aooper = ln_oper
                                  and b.aosbop = ln_sbop
                                  and b.aotope = ln_toper
                                  and rownum = 1;
                            exception
                                  when others then
                                       lc_flag := 'N';
                            end;
            end; 
            
            if lc_flag = 'S' then
               
               ln_instancia := fn_instancia_credito(ln_mod,ln_suc,ln_mda,0,ln_cta,ln_oper,ln_sbopP,ln_toper);
               
               begin 
                 select c.sng001ase
                   into lc_analista 
                   from sng001 c
                  where c.sng001emp = 1
                    --and c.sng001cta  = pn_cta
                    and c.sng001inst = ln_instancia
                    and rownum = 1;
               exception     
               when others then
                    lc_analista := null;
               end;
               
            end if;
         end if;  
 
  insert into JAQY295_D (JAQY295EMP,JAQY295MOD,JAQY295SUC,JAQY295TRN,JAQY295NREL,JAQY295FCH,JAQY295NOMOPE,
                       JAQY295NROTRAN,JAQY295HMODUL,JAQY295MDA,JAQY295SCNOM,JAQY295DESMDA,JAQY295MONTO,
                       JAQY295ORIGENFON,JAQY295USU,JAQY295PAIS,JAQY295TIPDOC,JAQY295NUMDOC,JAQY295HCTA,
                       JAQY295HOPER,JAQY295HTOPE,JAQY295SUCCUENTA,JAQY295TITULAR,JAQY295NRODOCTRA,
                       JAQY295TDOCTRA,JAQY295TRA,JAQY295TRAMNOCLI,JAQY295PERSBNCPEP,JAQY295HORA,JAQY295EXTORD,
                       JAQY295ENTFIN,JAQY295HSUCUR,JAQY295HPAP,JAQY295HSUBO,JAQY295HMDA,JAQY295USUARIO,
                       JAQY295SUCRED)
      values(i.BC604EMP,i.BC604MOD,i.BC604SUC,i.BC604TRN,i.BC604NREL,i.BC604FCH,i.NOMOPERACION,i.NROTRANSACCION,
             ln_mod,i.MDAOPERACION,i.AGENCIAOPERACION,i.MDATRANSACCION,i.MONTO,i.ORIGENDEFONDOS,
             /*i.OPERADOR*/lc_analista,ln_pais,ln_tdoc,lc_numdoc,ln_cta,ln_oper,ln_toper,lc_suc,
             lc_titular,i.NRODNITRAMITANTE,i.TDOCUMENTO,i.TRAMITANTE,i.TRAMITANTENOCLIENTE,lc_listneg,
             i.bc604hor,lc_existe,lc_entfin,ln_suc,ln_pap,ln_sbop,ln_mda,pc_ubuser,ln_sucCre);                 
    commit;

end loop;  

begin

    INSERT INTO JAQY296_D(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                        JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                        JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                        JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                        JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                        
    select o.JAQY295emp,
           o.JAQY295mod,
           o.JAQY295suc,
           o.JAQY295trn,
           o.JAQY295nrel,
           o.JAQY295fch,
           lpad(to_char(o.JAQY295suc),3,'0')||lpad(to_char(o.JAQY295mod),3,'0')||
           lpad(to_char(o.JAQY295trn),3,'0')||lpad(to_char(o.JAQY295nrel),4,'0'),
           o.JAQY295nomope,
           o.JAQY295succuenta,
           o.JAQY295scnom,
           (lpad(to_char(o.JAQY295hcta),9,'0')||lpad(to_char(o.JAQY295hmodul),3,'0')||
           lpad(to_char(o.JAQY295hmda),3,'0')||lpad(to_char(o.JAQY295hoper),9,'0')||
           lpad(to_char(o.JAQY295htope),3,'0')),
           o.JAQY295hcta,
           o.JAQY295titular,
           o.JAQY295desmda,
           o.JAQY295monto,
           o.JAQY295origenfon,
           o.JAQY295tra,
           o.JAQY295tramnocli,
           o.JAQY295tdoctra,
           o.JAQY295nrodoctra,
           o.JAQY295usu,
           o.JAQY295persbncpep,
           pq_ocum_calificacion.Fn_Ejecutivo(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                    o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                    o.JAQY295htope)Ejecutivo,
           pq_ocum_calificacion.fn_analista(o.JAQY295hmodul,o.JAQY295pais,o.JAQY295tipdoc,o.JAQY295numdoc,
                                   o.JAQY295hsucur,o.JAQY295hmda,o.JAQY295hcta,O.JAQY295HOPER,
                                   o.JAQY295htope)ANALISTA,
           --Ubuser,
           JAQY295USUARIO,
           o.JAQY295hsucur,
           JAQY295SUCRED
           
    from JAQY295_D o
   where trim(o.jaqy295usuario) = trim(pc_ubuser)
   ;

    COMMIT;
    /*
    begin
         update jaqy500 set jaqy500flg = 0 where jaqy500cod = 700;COMMIT;
    end;*/
end;


end;


Procedure SP_CONSOLIDAR_HD(pc_ubuser in varchar2) is

begin
     delete from JAQY296 where TRIM(JAQY296usuario) = TRIM(pc_ubuser);
     COMMIT;   
     begin
     
          INSERT INTO JAQY296(JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                              JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                              JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                              JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                              JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED)
                              
          Select JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                 JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                 JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                 JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                 JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED
            from Jaqy296_D
           
       union all
       
          Select JAQY296EMP,JAQY296MOD,JAQY296SUC,JAQY296TRN,JAQY296NREL,JAQY296FCH,JAQY296NUMTRA,
                 JAQY296NOMOPE,JAQY296SUCCTA,JAQY296SCNOM,JAQY296NUMCTA,JAQY296HCTA,JAQY296TITULAR,
                 JAQY296DESMDA,JAQY296MONTO,JAQY296ORIGENFON,JAQY296TRAM,JAQY296TRAMNOCLI,
                 JAQY296TDOCTRAM,JAQY296NDOCTRAM,JAQY296USU,JAQY296LISTN,JAQY296EJE,JAQY296ANA,
                 JAQY296USUARIO,JAQY296HSUCUR,JAQY296SUCRED
            from Jaqy296_H;
      
     
       commit;  
     
     end;
     commit;

end;

Procedure sp_analista(pn_mod in number, pn_pais in number,pn_tdoc in number,pc_ndoc in varchar2,
                      pn_suc in number, pn_mda in number, pn_cta in number, pn_oper in number,
                      pn_top in number, pc_analista out varchar2) is

begin

  pc_analista := fn_analista(pn_mod, pn_pais, pn_tdoc, pc_ndoc, pn_suc, pn_mda, pn_cta, pn_oper, pn_top);
   
end sp_analista;

end PQ_OCUM_CALIFICACION;
/

