create or replace procedure pr_cr_rpt_trabafami(p_fecha in date) is

begin

  delete from AQPA016B;
  delete from AQPA016C;
  delete from AQPA016D;
  delete from AQPA016E;
  delete from AQPA016F;
  commit;
  --12062019  
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016B',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016C',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016D',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016E',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016F',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016A',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;

  insert into AQPA016B
    (aqpa016bcor,
     aqpa016buni,
     aqpa016bsed,
     aqpa016bcod,
     aqpa016bnom,
     aqpa016bcar,
     aqpa016bfec,
     aqpa016btdo,
     aqpa016bdni,
     aqpa016bfna,
     aqpa016bsn,
     aqpa016brelc,
     aqpa016bcrel,
     aqpa016brel,
     aqpa016bnomf,
     aqpa016btdof,
     aqpa016bdnif,
     aqpa016bfnaf,
     aqpa016bvfcc,
     aqpa016btre,
     AQPA016BTDON,
     AQPA016BPAIN,
     AQPA016BTDOFN,
     AQPA016BPAIFN)
  
    select /*+all_rows*/
     rownum,
     t_trab.aqpa016auni,
     t_trab.aqpa016ased,
     t_trab.aqpa016acod,
     t_trab.aqpa016aape,
     t_trab.aqpa016acar,
     t_trab.aqpa016afec,
     t_tido.tdnom Tipo_Doc,
     t_trab.aqpa016adni,
     t_iden.pffnac Fec_Nac,
     t_iden.pfebco SN,
     t_trel.vinom Rel_Caja,
     
     t_relf.rpccyg Cod_rela,
     t_desp.vinom Relacion,
     trim(t_idfa.pfape1) || ' ' || trim(t_idfa.pfape2) || ' ' ||
     trim(t_idfa.pfnom1) || ' ' || trim(t_idfa.pfnom2) Nom_Fam,
     t_tdfa.tdnom Tip_Doc_Fam,
     t_idfa.pfndoc DNI_Fam,
     t_idfa.pffnac Fec_Nac_Fam,
     t_rcde.vinom Vinc_Fam_con_Caja,
     1 Tipo_Reg,
     
     t_trab.aqpa016atdo,
     t_trab.aqpa016apai,
     t_idfa.pftdoc,
     t_idfa.pfpais
    
      from AQPA016A t_trab,
           fsd002   t_iden,
           fsr002   t_relf,
           fst020   t_desp,
           fsd002   t_idfa,
           
           fst014 t_tido,
           fsr003 t_rcaj,
           fst020 t_trel,
           
           fst014 t_tdfa,
           fsr003 t_rcfa,
           fst020 t_rcde
     where t_iden.pfndoc = t_trab.aqpa016adni
       and t_iden.pftdoc = t_trab.aqpa016atdo -- solo dni
       and t_iden.pfpais = t_trab.aqpa016apai --pais
       and t_relf.pepais = t_iden.pfpais
       and t_relf.petdoc = t_iden.pftdoc
       and t_relf.pendoc = t_iden.pfndoc
       and t_desp.vicod = t_relf.rpccyg
          
       and t_idfa.pfpais = t_relf.rppais
       and t_idfa.pftdoc = t_relf.rptdoc
       and t_idfa.pfndoc = t_relf.rpndoc
          
       and t_tido.tdocum(+) = t_iden.pftdoc
          
       and t_rcaj.pjndoc(+) = '20100209641 '
       and t_rcaj.pfndo1(+) = t_iden.pfndoc --t
       and t_trel.vicod(+) = t_rcaj.vicod
          
       and t_tdfa.tdocum(+) = t_idfa.pftdoc
          
       and t_rcfa.pjndoc(+) = '20100209641 '
       and t_rcfa.pfndo1(+) = t_idfa.pfndoc
       and t_rcde.vicod(+) = t_rcfa.vicod;

  commit;
  
  --12062019
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016B',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
  insert into AQPA016C
    (aqpa016ccor,
     aqpa016cuni,
     aqpa016csed,
     aqpa016ccod,
     aqpa016cnom,
     aqpa016ccar,
     aqpa016cfec,
     aqpa016ctdo,
     aqpa016cdni,
     aqpa016cfna,
     aqpa016csn,
     aqpa016crelc,
     aqpa016ccrel,
     aqpa016crel,
     aqpa016cnomf,
     aqpa016ctdof,
     aqpa016cdnif,
     aqpa016cfnaf,
     aqpa016cvfcc,
     aqpa016ctre,
     aqpa016ctdon,
     aqpa016cpain,
     aqpa016ctdofn,
     aqpa016cpaifn)
  
    select rownum, a.*
      from (select /*+all_rows*/
             t_trab.aqpa016auni,
             t_trab.aqpa016ased,
             t_trab.aqpa016acod,
             t_trab.aqpa016aape,
             t_trab.aqpa016acar,
             t_trab.aqpa016afec,
             t_tido.tdnom Tipo_Doc,
             t_trab.aqpa016adni,
             t_iden.pffnac Fec_Nac,
             t_iden.pfebco SN,
             t_trel.vinom Rel_Caja,
             
             t_relf.rpccyg Cod_rela,
             t_desp.vinom Relacion,
             trim(t_idfa.pfape1) || ' ' || trim(t_idfa.pfape2) || ' ' ||
             trim(t_idfa.pfnom1) || ' ' || trim(t_idfa.pfnom2) Nom_Fam,
             t_tdfa.tdnom Tip_Doc_Fam,
             t_idfa.pfndoc DNI_Fam,
             t_idfa.pffnac Fec_Nac_Fam,
             t_rcde.vinom Vinc_Fam_con_Caja,
             1 Tipo_Reg,
             t_trab.aqpa016atdo,
             t_trab.aqpa016apai,
             t_idfa.pftdoc,
             t_idfa.pfpais
            
              from aqpa016a t_trab,
                   fsd002   t_iden,
                   fsr002   t_relf,
                   fst020   t_desp,
                   fsd002   t_idfa,
                   
                   fst014 t_tido,
                   fsr003 t_rcaj,
                   fst020 t_trel,
                   
                   fst014 t_tdfa,
                   fsr003 t_rcfa,
                   fst020 t_rcde
            
             where t_iden.pfndoc = t_trab.aqpa016adni
               and t_iden.pftdoc = t_trab.aqpa016atdo --solo dni
               and t_iden.pfpais = t_trab.aqpa016apai --pais
               and t_relf.pepais = t_iden.pfpais
               and t_relf.petdoc = t_iden.pftdoc
               and t_relf.pendoc = t_iden.pfndoc
               and t_desp.vicod = t_relf.rpccyg
                  
               and t_idfa.pfpais = t_relf.rppais
               and t_idfa.pftdoc = t_relf.rptdoc
               and t_idfa.pfndoc = t_relf.rpndoc
                  
               and t_tido.tdocum(+) = t_iden.pftdoc
                  
               and t_rcaj.pjndoc(+) = '20100209641 '
               and t_rcaj.pfndo1(+) = t_iden.pfndoc --t
               and t_trel.vicod(+) = t_rcaj.vicod
                  
               and t_tdfa.tdocum(+) = t_idfa.pftdoc
                  
               and t_rcfa.pjndoc(+) = '20100209641 '
               and t_rcfa.pfndo1(+) = t_idfa.pfndoc
               and t_rcde.vicod(+) = t_rcfa.vicod
            union all
            select t_trab.aqpa016auni,
                   t_trab.aqpa016ased,
                   t_trab.aqpa016acod,
                   t_trab.aqpa016aape,
                   t_trab.aqpa016acar,
                   t_trab.aqpa016afec,
                   t_tido.tdnom Tipo_Doc,
                   t_trab.aqpa016adni,
                   t_iden.pffnac Fec_Nac,
                   t_iden.pfebco SN,
                   t_trel.vinom Rel_Caja,
                   
                   t_relf.rpccyg Cod_rela,
                   t_desp.vinom Relacion,
                   trim(t_idfa.pfape1) || ' ' || trim(t_idfa.pfape2) || ' ' ||
                   trim(t_idfa.pfnom1) || ' ' || trim(t_idfa.pfnom2) Nom_Fam,
                   t_tdfa.tdnom Tip_Doc_Fam,
                   t_idfa.pfndoc DNI_Fam,
                   t_idfa.pffnac Fec_Nac_Fam,
                   t_rcde.vinom Vinc_Fam_con_Caja,
                   
                   2 Tipo_reg,
                   t_trab.aqpa016atdo,
                   t_trab.aqpa016apai,
                   t_idfa.pftdoc,
                   t_idfa.pfpais
            
              from aqpa016a t_trab,
                   fsd002   t_iden,
                   fsr002   t_relf,
                   fst020   t_desp,
                   fsd002   t_idfa,
                   
                   fst014 t_tido,
                   fsr003 t_rcaj,
                   fst020 t_trel,
                   
                   fst014 t_tdfa,
                   fsr003 t_rcfa,
                   fst020 t_rcde
            
             where t_iden.pfndoc = t_trab.aqpa016adni
               and t_iden.pftdoc = t_trab.aqpa016atdo --solo dni
               and t_iden.pfpais = t_trab.aqpa016apai --pais
               and t_relf.rppais = t_iden.pfpais
               and t_relf.rptdoc = t_iden.pftdoc
               and t_relf.rpndoc = t_iden.pfndoc
               and t_desp.vicod = t_relf.rpccyg
                  
               and t_idfa.pfpais = t_relf.pepais
               and t_idfa.pftdoc = t_relf.petdoc
               and t_idfa.pfndoc = t_relf.pendoc
                  
               and t_tido.tdocum(+) = t_iden.pftdoc
                  
               and t_rcaj.pjndoc(+) = '20100209641 '
               and t_rcaj.pfndo1(+) = t_iden.pfndoc --t
               and t_trel.vicod(+) = t_rcaj.vicod
                  
               and t_tdfa.tdocum(+) = t_idfa.pftdoc
                  
               and t_rcfa.pjndoc(+) = '20100209641 '
               and t_rcfa.pfndo1(+) = t_idfa.pfndoc
               and t_rcde.vicod(+) = t_rcfa.vicod
                  
               and not exists
             (select 1
                      from AQPA016B t_otfa
                     where t_otfa.aqpa016bdnif = t_idfa.pfndoc
                       and t_otfa.aqpa016btdofn = t_idfa.pftdoc
                       and t_otfa.aqpa016bpaifn = t_idfa.pfpais
                    
                    )) a;

  commit;

  --12062019
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016C',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
  insert into AQPA016D
    (aqpa016dcor,
     aqpa016duni,
     aqpa016dsed,
     aqpa016dcod,
     aqpa016dnom,
     aqpa016dcar,
     aqpa016dfec,
     aqpa016dtdo,
     aqpa016ddni,
     aqpa016dfna,
     aqpa016dsn,
     aqpa016drelc,
     aqpa016dcrel,
     aqpa016drel,
     aqpa016dnomf,
     aqpa016dtdof,
     aqpa016ddnif,
     aqpa016dfnaf,
     aqpa016dvfcc,
     aqpa016dtre,
     aqpa016dpgcod,
     aqpa016dctnro,
     aqpa016dpepais,
     aqpa016dpetdoc,
     aqpa016dpendoc,
     aqpa016dttcod,
     aqpa016dcttfir,
     aqpa016dtdon,
     aqpa016dpain,
     aqpa016dtdofn,
     aqpa016dpaifn)
  
    select rownum,
           aqpa016cuni,
           aqpa016csed,
           aqpa016ccod,
           aqpa016cnom,
           aqpa016ccar,
           aqpa016cfec,
           aqpa016ctdo,
           aqpa016cdni,
           aqpa016cfna,
           aqpa016csn,
           aqpa016crelc,
           aqpa016ccrel,
           aqpa016crel,
           aqpa016cnomf,
           aqpa016ctdof,
           aqpa016cdnif,
           aqpa016cfnaf,
           aqpa016cvfcc,
           aqpa016ctre,
           pgcod,
           ctnro,
           pepais,
           petdoc,
           pendoc,
           ttcod,
           cttfir,
           aqpa016ctdon,
           aqpa016cpain,
           aqpa016ctdofn,
           aqpa016cpaifn
    
      from AQPA016C t_fami, fsr008 t_rela
     where t_rela.pgcod = 1
       and t_rela.pendoc = t_fami.aqpa016cdnif
       and t_rela.petdoc = t_fami.aqpa016ctdofn -- 21 --dni
       and t_rela.pepais = t_fami.aqpa016cpaifn --604 --pais
       and t_rela.ttcod = 1
       and t_rela.cttfir = 'T';

  commit;
  --12062019  
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016D',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
  insert into AQPA016E
    (aqpa016ecor,
     aqpa016euni,
     aqpa016esed,
     aqpa016ecod,
     aqpa016enom,
     aqpa016ecar,
     aqpa016efec,
     aqpa016etdo,
     aqpa016edni,
     aqpa016efna,
     aqpa016esn,
     aqpa016erelc,
     aqpa016ecrel,
     aqpa016erel,
     aqpa016enomf,
     aqpa016etdof,
     aqpa016ednif,
     aqpa016efnaf,
     aqpa016evfcc,
     aqpa016etre,
     aqpa016epgco,
     aqpa016ecta,
     aqpa016epais,
     aqpa016etdoc,
     aqpa016edoc,
     aqpa016ettc,
     aqpa016ectt,
     AQPA016ESUC,
     AQPA016ERUBR,
     AQPA016EMDA,
     AQPA016EBCCTA,
     AQPA016EOPER,
     AQPA016EPROD,
     AQPA016ESDMN,
     AQPA016ETDON,
     AQPA016EPAIN,
     AQPA016ETDOFN,
     AQPA016EPAIFN)
  
--    select /*+all_rows*/
     select /*+all_rows parallel(T_FACU,4) parallel(T_HIST,4)*/   --12062019
     rownum,
     aqpa016duni,
     aqpa016dsed,
     aqpa016dcod,
     aqpa016dnom,
     aqpa016dcar,
     aqpa016dfec,
     aqpa016dtdo,
     aqpa016ddni,
     aqpa016dfna,
     aqpa016dsn,
     aqpa016drelc,
     aqpa016dcrel,
     aqpa016drel,
     aqpa016dnomf,
     aqpa016dtdof,
     aqpa016ddnif,
     aqpa016dfnaf,
     aqpa016dvfcc,
     aqpa016dtre,
     aqpa016dpgcod,
     aqpa016dctnro,
     aqpa016dpepais,
     aqpa016dpetdoc,
     aqpa016dpendoc,
     aqpa016dttcod,
     aqpa016dcttfir,
     
     t_hist.bcsuc,
     t_hist.bcrubr,
     t_hist.bcmda,
     t_hist.bccta,
     t_hist.bcoper,
     t_hist.bcprod,
     t_hist.bcsdmn,
     
     aqpa016dtdon,
     aqpa016dpain,
     aqpa016dtdofn,
     aqpa016dpaifn
    
      from aqpa016d t_facu, fsh012 t_hist
     where t_hist.bcemp = 1
       and t_hist.bccta = t_facu.aqpa016dctnro
       and substr(t_hist.bcrubr, 1, 4) in
           (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
       and t_hist.bcmod not in (33, 141)
       and t_hist.bcfech = p_fecha;

  commit;

  --12062019  
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016E',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
  insert into aqpa016f
    (aqpa016fcor,
     aqpa016funi,
     aqpa016fsed,
     aqpa016fcod,
     aqpa016fnom,
     aqpa016fcar,
     aqpa016fdni,
     aqpa016fsuc,
     aqpa016frub,
     aqpa016fmda,
     aqpa016fcta,
     aqpa016fope,
     aqpa016fpro,
     aqpa016fsmn,
     AQPA016FTDON,
     AQPA016FPAIN)
  
--    select /*+all_rows*/
     select /*+all_rows parallel(t_trab,4) parallel(t_rela,4) parallel(T_HIST,4)*/   --12062019
     rownum,
     t_trab.aqpa016auni,
     t_trab.aqpa016ased,
     t_trab.aqpa016acod,
     t_trab.aqpa016aape,
     t_trab.aqpa016acar,
     t_trab.aqpa016adni,
     
     t_hist.bcsuc,
     t_hist.bcrubr,
     t_hist.bcmda,
     t_hist.bccta,
     t_hist.bcoper,
     t_hist.bcprod,
     t_hist.bcsdmn,
     
     t_trab.aqpa016atdo,
     t_trab.aqpa016apai
    
      from aqpa016a t_trab, fsr008 t_rela, fsh012 t_hist
     where t_rela.pgcod = 1
       and t_rela.pepais = 604
       and t_rela.petdoc = 21
       and t_rela.pendoc = t_trab.aqpa016adni
       and t_rela.ttcod = 1
       and t_rela.cttfir = 'T'
       and t_hist.bcemp = 1
       and t_hist.bccta = t_rela.ctnro
       and t_hist.bcfech = p_fecha
       and substr(t_hist.bcrubr, 1, 4) in
           (1411, 1414, 1415, 1416, 1421, 1424, 1425, 1426)
       and t_hist.bcmod not in (33, 141);
  commit;
  --12062019  
  begin
    DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                  tabname          => 'AQPA016F',
                                  degree           => 4,
                                  granularity      => 'ALL',
                                  estimate_percent => 100,
                                  cascade          => TRUE);
  end;
  
end pr_cr_rpt_trabafami;
/

