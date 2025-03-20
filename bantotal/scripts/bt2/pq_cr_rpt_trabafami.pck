create or replace package PQ_CR_RPT_TRABAFAMI is

  -- Author  : RMONTESR
  -- Created : 13/12/2020 21:08:23
  -- Purpose : Reporte Creditos Familiares Trabajadores

  procedure sp_cr_carga(p_fecha in date);

  procedure sp_cr_carga_familiares(p_fecha in date);

  procedure sp_cr_carga_casuistica1(p_fecha in date);

  procedure sp_cr_carga_casuistica2(p_fecha in date);

  procedure sp_cr_carga_cuentasclientes(p_fecha in date);

  procedure sp_cr_carga_creditosfam(p_fecha in date);

  procedure sp_cr_carga_creditosfamagrupa(p_fecha in date);

  procedure sp_cr_carga_creditosfamagrupa2(p_fecha in date);

  procedure sp_cr_carga_creditostrabajad(p_fecha in date);
  
  procedure sp_cr_carga_listacontrol(p_fecha in date);

end PQ_CR_RPT_TRABAFAMI;
/

create or replace package body PQ_CR_RPT_TRABAFAMI is
  -- Author  : RMONTESR
  -- Created : 13/12/2020 21:08:23
  -- Purpose : Reporte Creditos Familiares Trabajadores

  --------------------------------------------------------
  -- ********** carga de familiares de trabajadores 15/12/2020**********
  procedure sp_cr_carga(p_fecha in date) is
  begin
    sp_cr_carga_familiares(p_fecha);
  
    sp_cr_carga_casuistica1(p_fecha);
  
    sp_cr_carga_casuistica2(p_fecha);
  
    sp_cr_carga_cuentasclientes(p_fecha);
  
    sp_cr_carga_creditosfam(p_fecha);
  
    sp_cr_carga_creditosfamagrupa(p_fecha);
    
    sp_cr_carga_listacontrol(p_fecha);
    
    sp_cr_carga_creditosfamagrupa2(p_fecha);
  
    sp_cr_carga_creditostrabajad(p_fecha);
  end;
  --------------------------------------------------------
  -- ********** carga de familiares de trabajadores 15/12/2020**********
  procedure sp_cr_carga_familiares(p_fecha in date) is
  begin
    delete from AQPA016B;
  
    
    commit;
  
    insert into aqpa016b
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
       aqpa016bpfcant)
    
      select rownum, a.*
        from (select t_trab.aqpa016auni,
                     t_trab.aqpa016ased,
                     t_trab.aqpa016acod,
                     t_trab.aqpa016aape,
                     t_trab.aqpa016acar,
                     t_trab.aqpa016afec,
                     t_tido.tdnom       Tipo_Doc,
                     t_trab.aqpa016adni,
                     t_iden.pffnac      Fec_Nac,
                     t_iden.pfebco      SN,
                     t_trel.vinom       Rel_Caja,
                     
                     t_relf.rpccyg Cod_rela,
                     t_desp.vinom Relacion,
                     trim(t_idfa.pfape1) || ' ' || trim(t_idfa.pfape2) || ' ' ||
                     trim(t_idfa.pfnom1) || ' ' || trim(t_idfa.pfnom2) Nom_Fam,
                     t_tdfa.tdnom Tip_Doc_Fam,
                     t_idfa.pfndoc DNI_Fam,
                     t_idfa.pffnac Fec_Nac_Fam,
                     
                     t_rcde.vinom  Vinc_Fam_con_Caja,
                     1             Tipo_Reg,
                     t_idfa.pfcant sexo
              
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
                 and t_relf.pepais = t_iden.pfpais
                 and t_relf.petdoc = t_iden.pftdoc
                 and t_relf.pendoc = t_iden.pfndoc
                 and t_desp.vicod = t_relf.rpccyg
                    
                 and t_idfa.pfpais = t_relf.rppais
                 and t_idfa.pftdoc = t_relf.rptdoc
                 and t_idfa.pfndoc = t_relf.rpndoc
                    
                 and t_tido.tdocum(+) = t_iden.pftdoc
                    
                 and t_rcaj.pjndoc(+) = '20100209641'
                 and t_rcaj.pfndo1(+) = t_iden.pfndoc
                 and t_trel.vicod(+) = t_rcaj.vicod
                    
                 and t_tdfa.tdocum(+) = t_idfa.pftdoc
                    
                 and t_rcfa.pjndoc(+) = '20100209641'
                 and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                 and t_rcde.vicod(+) = t_rcfa.vicod
              
              union all
              
              select t_trab.aqpa016auni,
                     t_trab.aqpa016ased,
                     t_trab.aqpa016acod,
                     t_trab.aqpa016aape,
                     t_trab.aqpa016acar,
                     t_trab.aqpa016afec,
                     t_tido.tdnom       Tipo_Doc,
                     t_trab.aqpa016adni,
                     t_iden.pffnac      Fec_Nac,
                     t_iden.pfebco      SN,
                     t_trel.vinom       Rel_Caja,
                     
                     t_relf.rpccyg Cod_rela,
                     t_desp.vinom Relacion,
                     trim(t_idfa.pfape1) || ' ' || trim(t_idfa.pfape2) || ' ' ||
                     trim(t_idfa.pfnom1) || ' ' || trim(t_idfa.pfnom2) Nom_Fam,
                     t_tdfa.tdnom Tip_Doc_Fam,
                     t_idfa.pfndoc DNI_Fam,
                     t_idfa.pffnac Fec_Nac_Fam,
                     t_rcde.vinom Vinc_Fam_con_Caja,
                     
                     2             Tipo_reg,
                     t_idfa.pfcant sexo
              
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
                 and t_relf.rppais = t_iden.pfpais
                 and t_relf.rptdoc = t_iden.pftdoc
                 and t_relf.rpndoc = t_iden.pfndoc
                 and t_desp.vicod = t_relf.rpccyg
                    
                 and t_idfa.pfpais = t_relf.pepais
                 and t_idfa.pftdoc = t_relf.petdoc
                 and t_idfa.pfndoc = t_relf.pendoc
                    
                 and t_tido.tdocum(+) = t_iden.pftdoc
                    
                 and t_rcaj.pjndoc(+) = '20100209641'
                 and t_rcaj.pfndo1(+) = t_iden.pfndoc
                 and t_trel.vicod(+) = t_rcaj.vicod
                    
                 and t_tdfa.tdocum(+) = t_idfa.pftdoc
                    
                 and t_rcfa.pjndoc(+) = '20100209641'
                 and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                 and t_rcde.vicod(+) = t_rcfa.vicod) a;
  
    commit;
  end;
  ---------------------------------------------------------------
  -- ************** Lista de familiares de trabajadores casuistica 1  *****
  procedure sp_cr_carga_casuistica1(p_fecha in date) is
  begin
    delete from AQPA016G;
    commit;
    insert into aqpa016g
      (aqpa016gcor,
       aqpa016gcod,
       aqpa016gnom,
       aqpa016gfec,
       aqpa016gdni,
       aqpa016gcrel,
       aqpa016grel,
       aqpa016gnomf,
       aqpa016gdnif,
       aqpa016gnreg)
      select rownum, a.*
        from (select t_fami.aqpa016bcod,
                     t_fami.aqpa016bnom,
                     t_fami.aqpa016bfec,
                     t_fami.aqpa016bdni,
                     t_fami.aqpa016bcrel,
                     t_fami.aqpa016brel,
                     t_fami.aqpa016bnomf,
                     t_fami.aqpa016bdnif,
                     count(*) numreg
                from aqpa016b t_fami
               group by t_fami.aqpa016bcod,
                        t_fami.aqpa016bnom,
                        t_fami.aqpa016bfec,
                        t_fami.aqpa016bdni,
                        t_fami.aqpa016bcrel,
                        t_fami.aqpa016brel,
                        t_fami.aqpa016bnomf,
                        t_fami.aqpa016bdnif) a;
    commit;
  end;

  ---------------------------------------------------------------
  -- ************** Lista de familiares de trabajadores casuistica 2  *****
  procedure sp_cr_carga_casuistica2(p_fecha in date) is
  begin
    delete from AQPA016G1;
    commit;
    insert into aqpa016g1
      (aqpa016g1cor,
       aqpa016g1cod,
       aqpa016g1nom,
       aqpa016g1fec,
       aqpa016g1dni,
       aqpa016g1crel,
       aqpa016g1rel,
       aqpa016g1nomf,
       aqpa016g1dnif,
       aqpa016g1nreg)
      select rownum, a.*
        from (select t_fami.aqpa016gcod,
                     t_fami.aqpa016gnom,
                     t_fami.aqpa016gfec,
                     t_fami.aqpa016gdni,
                     t_fami.aqpa016gcrel,
                     t_fami.aqpa016grel,
                     t_fami.aqpa016gnomf,
                     t_fami.aqpa016gdnif,
                     t_fami.aqpa016gnreg
                from aqpa016g t_fami
               where t_fami.aqpa016gcrel in (63, 66, 91, 68, 69, 70, 71, 75)) a;
    commit;
  end;
  ----------------------------------------------------------------
  -- *********** Lista de familiares de trabajadores casuistica 3 ******
  procedure sp_cr_carga_cuentasclientes(p_fecha in date) is
  begin
    delete from AQPA016h;
    commit;
    insert into aqpa016h
      (aqpa016hcor,
       aqpa016hcod,
       aqpa016hnom,
       aqpa016hfec,
       aqpa016hdni,
       aqpa016hcrel,
       aqpa016hrel,
       aqpa016hnomf,
       aqpa016hdnif,
       aqpa016hnreg,
       aqpa016hpgcod,
       aqpa016hctnro,
       aqpa016hpepais,
       aqpa016hpetdoc,
       aqpa016hpendoc)
      select rownum,
             t_bas2.aqpa016gcod,
             t_bas2.aqpa016gnom,
             t_bas2.aqpa016gfec,
             t_bas2.aqpa016gdni,
             t_bas2.aqpa016gcrel,
             t_bas2.aqpa016grel,
             t_bas2.aqpa016gnomf,
             t_bas2.aqpa016gdnif,
             t_bas2.aqpa016gnreg,
             t_rela.pgcod,
             t_rela.ctnro,
             t_rela.pepais,
             t_rela.petdoc,
             t_rela.pendoc
        from aqpa016g t_bas2, fsr008 t_rela
       where t_rela.pgcod(+) = 1
         and t_rela.petdoc(+) = 21
         and t_rela.pendoc(+) = t_bas2.aqpa016gdnif
         and t_rela.ttcod(+) = 1
         and t_rela.cttfir(+) = 'T'
         and t_bas2.aqpa016gcrel in (63, 66, 91, 68, 69, 70, 71, 75);
    commit;
  end;
  ------------------------------------------------------------------
  -- ********** Creditos de familiares de trabajadores **********
  procedure sp_cr_carga_creditosfam(p_fecha in date) is
  begin
    delete from aqpa016i;
    commit;
    insert into aqpa016i
      (aqpa016icor,
       aqpa016icod,
       aqpa016inom,
       aqpa016ifec,
       aqpa016idni,
       aqpa016icrel,
       aqpa016irel,
       aqpa016inomf,
       aqpa016idnif,
       aqpa016ibccta,
       aqpa016ibcoper,
       aqpa016ibcsbop,
       aqpa016ibctop,
       aqpa016ibcmod,
       aqpa016isaldo)
      select rownum, a.*
        from (select t_bas3.aqpa016hcod,
                     t_bas3.aqpa016hnom,
                     t_bas3.aqpa016hfec,
                     t_bas3.aqpa016hdni,
                     t_bas3.aqpa016hcrel,
                     t_bas3.aqpa016hrel,
                     t_bas3.aqpa016hnomf,
                     t_bas3.aqpa016hdnif,
                     
                     t_hist.bccta,
                     t_hist.bcoper,
                     t_hist.bcsbop,
                     t_hist.bctop,
                     t_hist.bcmod,
                     abs(t_hist.bcsdmn) saldo
              
                from aqpa016h t_bas3, fsh012 t_hist
               where t_hist.bcemp = t_bas3.aqpa016hPGcod
                 and t_hist.bcfech = p_fecha
                 and t_hist.bcrubr in (select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144))
                 /*and substr(t_hist.bcrubr, 1, 4) in
                     ('1411',
                      '1414',
                      '1415',
                      '1416',
                      '1421',
                      '1424',
                      '1425',
                      '1426')*/
                 and t_hist.bccta = t_bas3.aqpa016hctnro
                 and t_hist.bcprod <> 99
               ) a
               order by a.aqpa016hcod, a.aqpa016hcrel;
    commit;
  end;
  --------------------------------------------------------------------
  -- ******** Creditos de familiares de trabajadores agrupado para evitar duplicados*****
  procedure sp_cr_carga_creditosfamagrupa(p_fecha in date) is
  begin
    delete from aqpa016i1;
    commit;
    insert into aqpa016i1
      (aqpa016i1cor,
       aqpa016i1cod,
       aqpa016i1nom,
       aqpa016i1fec,
       aqpa016i1dni,
       aqpa016i1nomf,
       aqpa016i1dnif,
       aqpa016i1bccta,
       aqpa016i1bcoper,
       aqpa016i1bcsbop,
       aqpa016i1bctop,
       aqpa016i1bcmod,
       aqpa016i1saldo)
      select rownum, a.*
        from (select aqpa016icod,
                     aqpa016inom,
                     aqpa016ifec,
                     aqpa016idni,
                     aqpa016inomf,
                     aqpa016idnif,
                     aqpa016ibccta,
                     aqpa016ibcoper,
                     aqpa016ibcsbop,
                     aqpa016ibctop,
                     aqpa016ibcmod,
                     aqpa016isaldo
                from aqpa016i
               group by aqpa016icod,
                        aqpa016inom,
                        aqpa016ifec,
                        aqpa016idni,
                        aqpa016inomf,
                        aqpa016idnif,
                        aqpa016ibccta,
                        aqpa016ibcoper,
                        aqpa016ibcsbop,
                        aqpa016ibctop,
                        aqpa016ibcmod,
                        aqpa016isaldo) a;
    commit;
  end;
  ---------------------------------------------------------------------
  ----**********Carga lista de control creditos repetidos*****************************
  procedure sp_cr_carga_listacontrol(p_fecha in date) is
   begin
    delete from aqpa016i2;
    commit;
    insert into aqpa016i2
      (aqpa016i2cor,       
       aqpa016i2bccta,
       aqpa016i2bcoper,
       aqpa016i2bcsbop,
       aqpa016i2bctop,
       aqpa016i2bcmod,
       aqpa016i2saldo,
       aqpa016i2nvec)
      select rownum, a.*
        from (select 
                     aqpa016i1bccta,
                     aqpa016i1bcoper,
                     aqpa016i1bcsbop,
                     aqpa016i1bctop,
                     aqpa016i1bcmod,
                     aqpa016i1saldo,
                     count(*) nro_veces
                from aqpa016i1
                group by 
                        aqpa016i1bccta,
                        aqpa016i1bcoper,
                        aqpa016i1bcsbop,
                        aqpa016i1bctop,
                        aqpa016i1bcmod,
                        aqpa016i1saldo
               having count(*) > 1              
               ORDER BY aqpa016i1bccta,
               aqpa016i1bcoper) a;
    commit;
  end;
  --------------------------------------------------------------------
  -- ******** Creditos de familiares de trabajadores agrupado para evitar duplicados*****
  procedure sp_cr_carga_creditosfamagrupa2(p_fecha in date) is
  begin
    delete from aqpa016j;
    commit;
    insert into aqpa016j
      (aqpa016jcor,
       aqpa016jnomf,
       aqpa016jdnif,
       aqpa016jbccta,
       aqpa016jbcoper,
       aqpa016jbcsbop,
       aqpa016jbctop,
       aqpa016jbcmod,
       aqpa016jsaldo)
      select rownum, a.*
        from (select aqpa016inomf,
                     aqpa016idnif,
                     aqpa016ibccta,
                     aqpa016ibcoper,
                     aqpa016ibcsbop,
                     aqpa016ibctop,
                     aqpa016ibcmod,
                     aqpa016isaldo
                from aqpa016i
               group by aqpa016inomf,
                        aqpa016idnif,
                        aqpa016ibccta,
                        aqpa016ibcoper,
                        aqpa016ibcsbop,
                        aqpa016ibctop,
                        aqpa016ibcmod,
                        aqpa016isaldo) a
       where not exists (select 1 --- tabla de créditos de trabajadores  / para evitar que salgan los créditos de familiares trabajadores
                from aqpa016i t_bas4
               where t_bas4.aqpa016idni = a.aqpa016idnif);
    commit;
  end;
  ----------------------------------------------------------------------
  -- ****** Creditos de trabajadores ***********
  procedure sp_cr_carga_creditostrabajad(p_fecha in date) is
  begin
    delete from aqpa016k;
    commit;
    insert into aqpa016k
      (aqpa016kcor,
       aqpa016kcod,
       aqpa016knom,
       aqpa016kfec,
       aqpa016kdni,
       aqpa016kbccta,
       aqpa016kbcoper,
       aqpa016kbcsbop,
       aqpa016kbctop,
       aqpa016kbcmod,
       aqpa016ksaldo)
      select rownum, a.*
        from (select t_bas3.aqpa016acod,
                     t_bas3.aqpa016aape,
                     t_bas3.aqpa016afec,
                     t_bas3.aqpa016adni,
                     t_hist.bccta,
                     t_hist.bcoper,
                     t_hist.bcsbop,
                     t_hist.bctop,
                     t_hist.bcmod,
                     abs(t_hist.bcsdmn) saldo
              
                from aqpa016a t_bas3, fsr008 t_rela, fsh012 t_hist
               where t_rela.pgcod(+) = 1
                 and t_rela.petdoc(+) = 21
                 and t_rela.pendoc(+) = t_bas3.aqpa016adni
                 and t_rela.ttcod(+) = 1
                 and t_rela.cttfir(+) = 'T'
                 and t_hist.bcemp = t_rela.pgcod
                 and t_hist.bcfech = p_fecha
                 and t_hist.bcrubr in (select rubro
                          from fsd014
                         where pcnivc in (select MODULO
                                            from fst111
                                           Where Dscod = 50
                                             and Modulo <> 29
                                             and Modulo <> 120
                                             and Modulo <> 144))
                 /*and substr(t_hist.bcrubr, 1, 4) in
                     ('1411',
                      '1414',
                      '1415',
                      '1416',
                      '1421',
                      '1424',
                      '1425',
                      '1426')*/
                 and t_hist.bccta = t_rela.ctnro
                 and t_hist.bcprod <> 99
                 
               ) a
               order by a.aqpa016acod, a.bccta;
               commit;
  end;
end PQ_CR_RPT_TRABAFAMI;
/

