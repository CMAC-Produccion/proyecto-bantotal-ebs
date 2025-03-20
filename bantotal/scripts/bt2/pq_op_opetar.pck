create or replace package PQ_OP_OPETAR is

   procedure SP_OP_OPETARHAB(pd_fecini date,pd_fecfin date,ps_codusu varchar2,ps_coderr out char,ps_msgerr out varchar2);
   procedure SP_OP_OPETARHABCRE(pd_fecpro date,ps_codusu varchar2,ps_coderr out char,ps_msgerr out varchar2);
  
end PQ_OP_OPETAR;
/

create or replace package body PQ_OP_OPETAR is

procedure SP_OP_OPETARHAB(pd_fecini date,pd_fecfin date,ps_codusu varchar2,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_OP_OPETARHAB
  -- Sistema                    : TARJETAS
  -- Módulo                     : REPORTE DE TARJETA HABIENTES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/04/2019
  -- Autor de Creación          : WCRW
  -- Uso                        : Reporte de tarjeta habientes
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ln_codpro number(12);
   ln_tippro number(12);
   ls_numtar char(19);
   begin
      EXECUTE IMMEDIATE 'truncate table JAQL839T';
      EXECUTE IMMEDIATE 'truncate table JAQL839Z';
      EXECUTE IMMEDIATE 'truncate table JAQL839W';
      ln_codpro := 1;
      ln_tippro := 1;
      insert into JAQL839Z (jaql839zntar,jaql839zcpro,jaql839ztpro)
      select substr(trim(y.txtord),1,19),2,2
        from fsx016 y 
       where y.pgcod= 1
         and y.txcod = 601 
         and y.hcmod <> 30
         and y.hfcon >= pd_fecini
         and y.hfcon <= pd_fecfin;
      commit;
      insert into JAQL839Z (jaql839zntar,jaql839zcpro,jaql839ztpro)
      select distinct(x.jaqz208nutar),3,3
        from jaqz208 x 
       where x.jaqz208fetra >= pd_fecini
         and x.jaqz208fetra <= pd_fecfin;
      commit;
      insert into JAQL839T (jaql839tcpro,jaql839ttpro,jaql839tntar,jaql839tcpai,jaql839ttdoc,
                           jaql839tndoc,jaql839tttar,jaql839tczon,jaql839tcusu,Jaql839tcage)
      select ln_codpro,ln_tippro,t_base.z0e478nro,t_base.z0e478thp,t_base.z0e478tht,
             t_base.z0e478thd,t_base.z0e468cod,substr(t_ubag.bc206chr1,1,6),ps_codusu,t_base.z0e478suc
        from z0e478 t_base,z0e463 t_esta,fbc206 t_ubag          
       where t_base.z0e463cod = 1
         and t_esta.z0e463cod = t_base.z0e463cod
         and t_ubag.bc205emp = 1
         and t_ubag.bc205cod = 412
         and t_ubag.bc206id1 = t_base.z0e478suc;
       commit;
       -- ATMS
       update JAQL839T a set a.jaql839ttatm = nvl(a.jaql839ttatm,0) + 1 
        where exists 
              (select 1  
                 from jaqy254 t_movi
                where t_movi.jaqy254nutar = a.jaql839tntar
                  and t_movi.jaqy254feini >= pd_fecini
                  and t_movi.jaqy254feini <= pd_fecfin)
           and a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu;
        commit;    
        -- CCs      
        update JAQL839T a set a.jaql839ttcco = nvl(a.jaql839ttcco,0) + 1 
         where exists 
              (select 1  
                 from jaql006 t_mov1
                where t_mov1.jaql6nutar = a.jaql839tntar
                  and t_mov1.jaql6fetra >= pd_fecini
                  and t_mov1.jaql6fetra <= pd_fecfin)
           and a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu;       
         commit;
         -- KASNET
         update JAQL839T a set a.jaql839ttkas = nvl(a.jaql839ttkas,0) + 1 
         where exists 
              (select 1  
                 from jaql674 t_kmov
                where t_kmov.jaql674nutar = a.jaql839tntar
                  and t_kmov.jaql674fetra >= pd_fecini
                  and t_kmov.jaql674fetra <= pd_fecfin)
           and a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu;       
         commit;
         insert into jaql839w (jaql839wntar,jaql839wcpro,jaql839wtpro)
         select distinct(jaql839zntar),jaql839zcpro,jaql839ztpro
           from jaql839z;
         commit;  
         -- VENTANILLA
         update JAQL839T a set a.jaql839ttven = nvl(a.jaql839ttven,0) + 1 
         where exists 
              (select 1  
                 from jaql839W t_vmov
                where t_vmov.jaql839wntar = a.jaql839tntar
                  and t_vmov.jaql839wcpro = 2
                  and t_vmov.jaql839wtpro = 2)
           and a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu;       
         commit;
         -- CAJA MOVIL
         update JAQL839T a set a.jaql839ttcmo = nvl(a.jaql839ttcmo,0) + 1 
         where exists 
              (select 1  
                 from jaql839W t_cmov
                where t_cmov.jaql839wntar = a.jaql839tntar
                  and t_cmov.jaql839wcpro = 3
                  and t_cmov.jaql839wtpro = 3)
           and a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu;       
         commit;
         update JAQL839T a set a.jaql839tflat = 1
         where a.jaql839tcpro = 1
           and a.jaql839ttpro = 1
           and a.jaql839tcusu = ps_codusu
           and nvl(a.jaql839ttatm,0) + nvl(a.jaql839ttcco,0) + nvl(a.jaql839ttkas,0) + 
               nvl(a.jaql839ttven,0) + nvl(a.jaql839ttcmo,0) > 0;
         commit;
         update JAQL839T a set (jaql839tddep,jaql839tdpro,jaql839tddis) =
                (select t_dept.depnom,t_prov.locnom,t_dist.fst071dsc
                   from fst068 t_dept,fst070 t_prov,fst071 t_dist
                  where t_dept.pais = 604
                    and t_dept.depcod = to_number(substr(a.jaql839tczon,1,2))
                    and t_prov.pais = 604
                    and t_prov.depcod = to_number(substr(a.jaql839tczon,1,2))
                    and t_prov.loccod = to_number(substr(a.jaql839tczon,1,4))
                    and t_dist.fst071pai = 604
                    and t_dist.fst071dpt = to_number(substr(a.jaql839tczon,1,2))
                    and t_dist.fst071loc = to_number(substr(a.jaql839tczon,1,4))
                    and t_dist.fst071col = to_number(substr(a.jaql839tczon,1,6)))
                  where a.jaql839tcpro = 1
                    and a.jaql839ttpro = 1
                    and a.jaql839tcusu = ps_codusu;
         commit;
         update JAQL839T x set (x.jaql839tdreg) =
                (select upper(trim(b.regnom))
                   from fst811 a,fst810 b 
                  where a.pgcod = 1 
                    and a.oficod = x.jaql839tcage
                    and a.regcod < 100 
                    and a.regcod = b.regcod)
          where x.jaql839tcpro = 1
            and x.jaql839ttpro = 1
            and x.jaql839tcusu = ps_codusu;         
         insert into JAQL839T (jaql839tcpro,jaql839ttpro,jaql839tdreg,jaql839tddep,
                               jaql839tdpro,jaql839tddis,jaql839tctra,jaql839tstra)                    
         select 2,2,a.jaql839tdreg,a.jaql839tddep,a.jaql839tdpro,a.jaql839tddis,
                sum(case when not(a.jaql839tflat is null) then 1 else 0 end),
                sum(case when a.jaql839tflat is null then 1 else 0 end)
           from jaql839t a
          where a.jaql839tcpro = 1
            and a.jaql839ttpro = 1
            and a.jaql839tcusu = ps_codusu     
         group by 2,2,a.jaql839tdreg,a.jaql839tddep,a.jaql839tdpro,a.jaql839tddis
         order by a.jaql839tdreg,a.jaql839tddep,a.jaql839tdpro,a.jaql839tddis;
         commit;                      
end SP_OP_OPETARHAB;

procedure SP_OP_OPETARHABCRE(pd_fecpro date,ps_codusu varchar2,ps_coderr out char,ps_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : SP_OP_OPETARHABCRE
  -- Sistema                    : TARJETAS
  -- Módulo                     : REPORTE DE TARJETA HABIENTES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 17/04/2019
  -- Autor de Creación          : WCRW
  -- Uso                        : Clientes de Créditos con tarjeta
  -- Estado                     : Activo
  -- Fecha Modificación         : 
  -- Autor de Creación          : 
  -- Descripcion Modificacion   : 
  -- *****************************************************************

   ln_codpro number(12);
   ln_tippro number(12);
   ls_numtar char(19);
   begin
      EXECUTE IMMEDIATE 'truncate table JAQL839T';
      EXECUTE IMMEDIATE 'truncate table JAQL839C';
      ln_codpro := 1;
      ln_tippro := 1;
      insert into JAQL839T (jaql839tcpro,jaql839ttpro,jaql839tntar,jaql839tcpai,jaql839ttdoc,
                           jaql839tndoc,jaql839tttar,jaql839tczon,jaql839tcusu)
      select ln_codpro,ln_tippro,t_base.z0e478nro,t_base.z0e478thp,t_base.z0e478tht,
             t_base.z0e478thd,t_base.z0e468cod,substr(t_ubag.bc206chr1,1,6),ps_codusu
        from z0e478 t_base,z0e463 t_esta,fbc206 t_ubag          
       where t_base.z0e463cod = 1
         and t_esta.z0e463cod = t_base.z0e463cod
         and t_ubag.bc205emp = 1
         and t_ubag.bc205cod = 412
         and t_ubag.bc206id1 = t_base.z0e478suc;
      insert into JAQL839C (jaql839ccpro,jaql839ctpro,jaql839ccpai,jaql839ctdoc,jaql839cndoc,
                           jaql839ccage,jaql839cnreg,jaql839ccusu)
      select ln_codpro,ln_tippro,t_rela.pepais,t_rela.petdoc,t_rela.pendoc,max(t_hist.bcsuc),
             count(*) numreg,ps_codusu
        from fsh012 t_hist,fsr008 t_rela
       where t_hist.bcemp = 1
         and substr(t_hist.bcrubr,1,4) in (1411,1414,1415,1416, 1421,1424,1425,1426)
         and t_hist.bcfech = pd_fecpro
         and t_hist.bcmod not in (33,141)
         and t_rela.pgcod = t_hist.bcemp
         and t_rela.ctnro = t_hist.bccta
         and t_rela.ttcod = 1
         and t_rela.cttfir = 'T'
       group by ln_codpro,ln_tippro,t_rela.pepais,t_rela.petdoc,t_rela.pendoc;
      commit;
      /*update jaql839c a set a.jaql839cflat = (select case when b.jaql839tntar is null then 'N' else 'S' end
                                                from jaql839t b
                                                where b.jaql839tcpai(+) = a.jaql839ccpai
                                                  and b.jaql839ttdoc(+) = a.jaql839ctdoc
                                                  and b.jaql839tndoc(+) = a.jaql839cndoc);*/
      update jaql839c a set a.jaql839cflat = (select 'S' 
                                                from jaql839t b
                                               where a.jaql839ccpai = b.jaql839tcpai
                                                 and a.jaql839ctdoc = b.jaql839ttdoc
                                                 and a.jaql839cndoc = b.jaql839tndoc
                                                 and ROWNUM = 1);
                                               
      commit;
      update jaql839t x set (x.jaql839tmcod,x.jaql839tmcor) = 
             (select mincod,mincor
                from (select jaql839tcpai,jaql839ttdoc,jaql839tndoc,a.mincod,min(b.sngc13corr) as mincor
                         from (select t_tarj.jaql839tcpai,t_tarj.jaql839ttdoc,t_tarj.jaql839tndoc,min(t_dire.docod) mincod
                                 from sngc13 t_dire,jaql839t t_tarj
                                where t_dire.sngc13pais(+) = t_tarj.jaql839tcpai
                                  and t_dire.sngc13tdoc(+) = t_tarj.jaql839ttdoc
                                   and t_dire.sngc13ndoc(+) = t_tarj.jaql839tndoc
                                   and t_dire.sngc13est(+) = 'H'     
                               group by t_tarj.jaql839tcpai,t_tarj.jaql839ttdoc,t_tarj.jaql839tndoc) a,
                               sngc13 b
                         where b.sngc13pais(+) = a.jaql839tcpai
                           and b.sngc13tdoc(+) = a.jaql839ttdoc
                           and b.sngc13ndoc(+) = a.jaql839tndoc
                           and b.docod(+) = a.mincod
                           and b.sngc13est(+) = 'H'
                       group by jaql839tcpai,jaql839ttdoc,jaql839tndoc,a.mincod)
              where jaql839tcpai = x.jaql839tcpai
                and jaql839ttdoc = x.jaql839ttdoc
                and jaql839tndoc = x.jaql839tndoc);
      commit;                            
      update JAQL839T a set (jaql839tddep,jaql839tdpro,jaql839tddis) =
             (select t_dept.depnom,t_prov.locnom,t_dist.fst071dsc              
                from sngc13 t_dire,fst068 t_dept,fst070 t_prov,fst071 t_dist
               where t_dire.sngc13pais(+) = a.jaql839tcpai
                 and t_dire.sngc13tdoc(+) = a.jaql839ttdoc
                 and t_dire.sngc13ndoc(+) = a.jaql839tndoc
                 and t_dire.docod(+) = a.jaql839tmcod
                 and t_dire.sngc13corr(+) = a.jaql839tmcor
                 and t_dire.sngc13est(+) = 'H'
                 and t_dept.pais(+) = 604
                 and t_dept.depcod(+) = t_dire.sngc13dpto
                 and t_prov.pais(+) = 604
                 and t_prov.depcod(+) = t_dire.sngc13dpto
                 and t_prov.loccod(+) = t_dire.sngc13prov
                 and t_dist.fst071pai(+) = 604
                 and t_dist.fst071dpt(+) = t_dire.sngc13dpto
                 and t_dist.fst071loc(+) = t_dire.sngc13prov
                 and t_dist.fst071col(+) = t_dire.sngc13dist);              
      commit;    
      update jaql839c x set (x.jaql839cmcod,x.jaql839cmcor) = 
             (select mincod,mincor
                from (select jaql839ccpai,jaql839ctdoc,jaql839cndoc,a.mincod,min(b.sngc13corr) as mincor
                         from (select t_cred.jaql839ccpai,t_cred.jaql839ctdoc,t_cred.jaql839cndoc,min(t_dire.docod) mincod
                                 from sngc13 t_dire,jaql839c t_cred
                                where t_dire.sngc13pais(+) = t_cred.jaql839ccpai
                                  and t_dire.sngc13tdoc(+) = t_cred.jaql839ctdoc
                                   and t_dire.sngc13ndoc(+) = t_cred.jaql839cndoc
                                   and t_dire.sngc13est(+) = 'H'     
                               group by t_cred.jaql839ccpai,t_cred.jaql839ctdoc,t_cred.jaql839cndoc) a,
                               sngc13 b
                         where b.sngc13pais(+) = a.jaql839ccpai
                           and b.sngc13tdoc(+) = a.jaql839ctdoc
                           and b.sngc13ndoc(+) = a.jaql839cndoc
                           and b.docod(+) = a.mincod
                           and b.sngc13est(+) = 'H'
                       group by jaql839ccpai,jaql839ctdoc,jaql839cndoc,a.mincod)
              where jaql839ccpai = x.jaql839ccpai
                and jaql839ctdoc = x.jaql839ctdoc
                and jaql839cndoc = x.jaql839cndoc);
      commit;
      update JAQL839C a set (jaql839cddep,jaql839cdpro,jaql839cddis) =
             (select t_dept.depnom,t_prov.locnom,t_dist.fst071dsc              
                from sngc13 t_dire,fst068 t_dept,fst070 t_prov,fst071 t_dist
               where t_dire.sngc13pais(+) = a.jaql839ccpai
                 and t_dire.sngc13tdoc(+) = a.jaql839ctdoc
                 and t_dire.sngc13ndoc(+) = a.jaql839cndoc
                 and t_dire.docod(+) = a.jaql839cmcod
                 and t_dire.sngc13corr(+) = a.jaql839cmcor
                 and t_dire.sngc13est(+) = 'H'
                 and t_dept.pais(+) = 604
                 and t_dept.depcod(+) = t_dire.sngc13dpto
                 and t_prov.pais(+) = 604
                 and t_prov.depcod(+) = t_dire.sngc13dpto
                 and t_prov.loccod(+) = t_dire.sngc13prov
                 and t_dist.fst071pai(+) = 604
                 and t_dist.fst071dpt(+) = t_dire.sngc13dpto
                 and t_dist.fst071loc(+) = t_dire.sngc13prov
                 and t_dist.fst071col(+) = t_dire.sngc13dist);              
      commit;          
      insert into JAQL839C (jaql839ccpro,jaql839ctpro,jaql839cddep,jaql839cdpro,
                            jaql839cddis,jaql839cnreg)                    
           select 2,2,a.jaql839cddep,a.jaql839cdpro,a.jaql839cddis,
                  sum(case when (a.jaql839cflat is null) then 1 else 0 end)
           from jaql839c a
          where a.jaql839ccpro = 1
            and a.jaql839ctpro = 1
            and a.jaql839ccusu = ps_codusu     
         group by 2,2,a.jaql839cddep,a.jaql839cdpro,a.jaql839cddis
         order by a.jaql839cddep,a.jaql839cdpro,a.jaql839cddis;
         commit;                            
end SP_OP_OPETARHABCRE;


end PQ_OP_OPETAR;
/

