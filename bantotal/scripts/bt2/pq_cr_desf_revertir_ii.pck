create or replace package PQ_CR_DESF_REVERTIR_II is

  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION DUPLICADOS VIDA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CREDITOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.12.05
  -- Autor de Creación          : MSOLARI 
  -- Uso                        : REVERTIR DESAFILIACION
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2017.02.10
  -- Autor de la Modificación   : MSOLARI
  -- Descripción de Modificación: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_Identificacion_Crd;
  
  Procedure sp_Proceso_Crd(ln_cod1  in number,
                           ln_suc1  in number,
                           ln_mod1  in number,
                           ln_mda1  in number,
                           ln_pap1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ln_tope1 in number,
                           lc_esta  in char,
                           ld_fech1 in date,
                           lc_indr1 in char);

  Procedure sp_Desaf_fsd611(ln_cod1  in number,
                            ln_mod1  in number,
                            ln_suc1  in number,
                            ln_mda1  in number,
                            ln_pap1  in number,
                            ln_cta1  in number,
                            ln_oper1 in number,
                            ln_sbop1 in number,
                            ln_tope1 in number,
                            ld_fech1 in date);
                              
  Procedure sp_Desaf_fpp001(ln_cod1  in number,
                            ln_mod1  in number,
                            ln_suc1  in number,
                            ln_mda1  in number,
                            ln_pap1  in number,
                            ln_cta1  in number,
                            ln_oper1 in number,
                            ln_sbop1 in number,
                            ln_tope1 in number);
                               
  Procedure sp_Backup_fsd611(ln_cod1    in number,
                             ln_mod1    in number,
                             ln_suc1    in number,
                             ln_mda1    in number,
                             ln_pap1    in number,
                             ln_cta1    in number,
                             ln_oper1   in number,
                             ln_sbop1   in number,
                             ln_tope1   in number,
                             lc_hora    in char,
                             ld_FchSist in date);
                                
  Procedure sp_Backup_fpp001(ln_cod1    in number,
                             ln_mod1    in number,
                             ln_suc1    in number,
                             ln_mda1    in number,
                             ln_pap1    in number,
                             ln_cta1    in number,
                             ln_oper1   in number,
                             ln_sbop1   in number,
                             ln_tope1   in number,
                             lc_hora    in char,
                             ld_FchSist in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_DESF_REVERTIR_II;
/

create or replace package body PQ_CR_DESF_REVERTIR_II is
  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION DUPLICADOS VIDA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CREDITOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.12.05
  -- Autor de Creación          : MSOLARI 
  -- Uso                        : REVERTIR DESAFILIACION
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : -
  -- Autor de la Modificación   : -
  -- Descripción de Modificación: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Identificacion_Crd is
  
    cursor cur_creditos is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag,
             a.pp1stat,
             b.jaqy752indr
        from fsd602 a, jaqy752 b
       where a.ppcta = b.jaqy752cta
         and a.ppoper = b.jaqy752oper
         and a.ppfpag = (select max(ppfpag)
                           from fsd602
                          where ppcta = b.jaqy752cta
                            and ppoper = b.jaqy752oper
                            and d602co = 'S')
         and a.pp1stat = 'T'
         and a.pp1nump = (select max(pp1nump)
                            from fsd602
                           where ppcta = b.jaqy752cta
                             and ppoper = b.jaqy752oper
                             and d602co = 'S')
            --and b.jaqy752indr = 'A';
         and b.jaqy752indr = 'R';
  
    ln_cod  number(3);
    ln_mod  number(4);
    ln_suc  number(3);
    ln_mda  number(3);
    ln_pap  number(3);
    ln_cta  number(9);
    ln_oper number(9);
    ln_sbop number(3);
    ln_tope number(3);
    --ln_ndoc  char(12);
    ln_consg number(5);
    lc_estd  char(1);
    ld_fech  date;
    lc_indr  char(1);
  
  Begin
    for x in cur_creditos loop
      ln_cod  := x.pgcod;
      ln_suc  := x.ppsuc;
      ln_mod  := x.ppmod;
      ln_mda  := x.ppmda;
      ln_pap  := x.pppap;
      ln_cta  := x.ppcta;
      ln_oper := x.ppoper;
      ln_sbop := x.ppsbop;
      ln_tope := x.pptope;
      lc_estd := x.pp1stat;
      ld_fech := x.ppfpag;
      lc_indr := x.jaqy752indr;
    
      select count(*)
        into ln_consg
        from fpp001 f
       where f.aocta = ln_cta
         and f.aooper = ln_oper
         and f.sgcod in (118, 119, 120, 121, 122, 200, 201, 202);
    
      If ln_consg >= 1 then
        -- Call the procedure
        /*bantprod.*/
        pq_cr_desf_revertir_ii.sp_Proceso_Crd(ln_cod,
                                              ln_suc,
                                              ln_mod,
                                              ln_mda,
                                              ln_pap,
                                              ln_cta,
                                              ln_oper,
                                              ln_sbop,
                                              ln_tope,
                                              lc_estd,
                                              ld_fech,
                                              lc_indr);
      End If;
    
    End loop;
  
  End sp_Identificacion_Crd;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Proceso_Crd(ln_cod1  in number,
                           ln_suc1  in number,
                           ln_mod1  in number,
                           ln_mda1  in number,
                           ln_pap1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ln_tope1 in number,
                           lc_esta  in char,
                           ld_fech1 in date,
                           lc_indr1 in char) is
  
    ln_stat    number(2);
    lc_hora    char(8);
    ld_FchSist date;
  
  Begin
    Begin
      select b.aostat
        into ln_stat
        from FSD010 b
       where b.pgcod = ln_cod1
         and b.aomod = ln_mod1
         and b.aosuc = ln_suc1
         and b.aomda = ln_mda1
         and b.aopap = ln_pap1
         and b.aocta = ln_cta1
         and b.aooper = ln_oper1
         and b.aosbop = ln_sbop1
         and b.aotope = ln_tope1;
    exception
      When others then
        null;
    End;
  
    If ln_stat <> 99 then
    
      Begin
        select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
      Exception
        when no_data_found then
          null;
      End;
    
      Begin
        select Pgfape into ld_FchSist from fst017 Where Pgcod = 1;
      Exception
        when no_data_found then
          null;
      End;
    
      PQ_CR_DESF_REVERTIR_ii.sp_Backup_fsd611(ln_cod1,
                                              ln_mod1,
                                              ln_suc1,
                                              ln_mda1,
                                              ln_pap1,
                                              ln_cta1,
                                              ln_oper1,
                                              ln_sbop1,
                                              ln_tope1,
                                              lc_hora,
                                              ld_FchSist);
    
      PQ_CR_DESF_REVERTIR_ii.sp_Backup_fpp001(ln_cod1,
                                              ln_mod1,
                                              ln_suc1,
                                              ln_mda1,
                                              ln_pap1,
                                              ln_cta1,
                                              ln_oper1,
                                              ln_sbop1,
                                              ln_tope1,
                                              lc_hora,
                                              ld_FchSist);
    
      --If lc_indr1 = 'A' then
      If lc_indr1 = 'R' then
        If lc_esta = 'T' then
          PQ_CR_DESF_REVERTIR_ii.sp_Desaf_fsd611(ln_cod1,
                                                 ln_mod1,
                                                 ln_suc1,
                                                 ln_mda1,
                                                 ln_pap1,
                                                 ln_cta1,
                                                 ln_oper1,
                                                 ln_sbop1,
                                                 ln_tope1,
                                                 ld_fech1);
        
          PQ_CR_DESF_REVERTIR_ii.sp_Desaf_fpp001(ln_cod1,
                                                 ln_mod1,
                                                 ln_suc1,
                                                 ln_mda1,
                                                 ln_pap1,
                                                 ln_cta1,
                                                 ln_oper1,
                                                 ln_sbop1,
                                                 ln_tope1);
        End If;
      
        Update JAQY752 y
           set y.jaqy752indE = 'H',
               y.jaqy752indr = 'X'
         where y.jaqy752cta = ln_cta1
           and y.jaqy752oper = ln_oper1 /*
                     and y.jaqy752ndoc = lc_ndoc1*/
        ;
        commit;
      
      End If;
    End If;
  End sp_Proceso_Crd;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Desaf_fsd611(ln_cod1  in number,
                            ln_mod1  in number,
                            ln_suc1  in number,
                            ln_mda1  in number,
                            ln_pap1  in number,
                            ln_cta1  in number,
                            ln_oper1 in number,
                            ln_sbop1 in number,
                            ln_tope1 in number,
                            ld_fech1 in date) is
  
    Cursor Move1 is
      select distinct q.ppcta, q.ppoper
        from fsd611 q -->>> fsd611_1
       where q.pgcod = ln_cod1
         and q.ppmod = ln_mod1
         and q.ppsuc = ln_suc1
         and q.ppmda = ln_mda1
         and q.pppap = ln_pap1
         and q.ppcta = ln_cta1
         and q.ppoper = ln_oper1
         and q.ppsbop = ln_sbop1
         and q.pptope = ln_tope1
         and q.ppfpag > ld_fech1;
  
  BEGIN
    For x in Move1 loop
    
      Update fsd611 t --->>  <<<fsd611_1>>>
         set t.ppimp11 = t.ppimp12,
             t.ppimp12 = t.ppimp13,
             t.ppimp13 = t.ppimp14,
             t.ppimp14 = t.ppimp15,
             t.ppimp15 = 0.00
       where t.ppcta = x.ppcta
         and t.ppoper = x.ppoper
         and t.ppfpag > ld_fech1;
      commit;
    End Loop;
  
  End sp_Desaf_fsd611;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Desaf_fpp001(ln_cod1  in number,
                            ln_mod1  in number,
                            ln_suc1  in number,
                            ln_mda1  in number,
                            ln_pap1  in number,
                            ln_cta1  in number,
                            ln_oper1 in number,
                            ln_sbop1 in number,
                            ln_tope1 in number) is
  
  BEGIN
  
    delete from fpp001 t --fpp001_1 
     where t.pgcod = ln_cod1
       and t.aomod = ln_mod1
       and t.aosuc = ln_suc1
       and t.aomda = ln_mda1
       and t.aopap = ln_pap1
       and t.aocta = ln_cta1
       and t.aooper = ln_oper1
       and t.aosbop = ln_sbop1
       and t.aotope = ln_tope1
       and t.sgcod in (116, 117, 118, 120, 121, 122);
    commit;
  
  End sp_Desaf_fpp001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_fsd611(ln_cod1    in number,
                             ln_mod1    in number,
                             ln_suc1    in number,
                             ln_mda1    in number,
                             ln_pap1    in number,
                             ln_cta1    in number,
                             ln_oper1   in number,
                             ln_sbop1   in number,
                             ln_tope1   in number,
                             lc_hora    in char,
                             ld_FchSist in date) is
  
    Cursor data1 is
      select fs.*
        from fsd611 fs --->>  <<<fsd611_1>>>
       where fs.pgcod = ln_cod1
         and fs.ppmod = ln_mod1
         and fs.ppsuc = ln_suc1
         and fs.ppmda = ln_mda1
         and fs.pppap = ln_pap1
         and fs.ppcta = ln_cta1
         and fs.ppoper = ln_oper1
         and fs.ppsbop = ln_sbop1
         and fs.pptope = ln_tope1;
  
  BEGIN
    For c in data1 loop
    
      Begin
        insert into jaqy759 -->>>> backup_fsd611 
          (jaqy759cod,
           jaqy759mod,
           jaqy759suc,
           jaqy759mda,
           jaqy759pap,
           jaqy759cta,
           jaqy759oper,
           jaqy759sbop,
           jaqy759tope,
           jaqy759fpag,
           jaqy759tipo,
           jaqy759exte,
           jaqy759imp1,
           jaqy759imp2,
           jaqy759imp3,
           jaqy759imp4,
           jaqy759imp5,
           jaqy759imp6,
           jaqy759imp7,
           jaqy759imp8,
           jaqy759imp9,
           jaqy759imp10,
           jaqy759imp11,
           jaqy759imp12,
           jaqy759imp13,
           jaqy759imp14,
           jaqy759imp15,
           jaqy759imp16,
           jaqy759imp17,
           jaqy759imp18,
           jaqy759imp19,
           jaqy759imp20,
           jaqy759fsist,
           jaqy759HraSis)
        values
          (c.pgcod,
           c.ppmod,
           c.ppsuc,
           c.ppmda,
           c.pppap,
           c.ppcta,
           c.ppoper,
           c.ppsbop,
           c.pptope,
           c.ppfpag,
           c.pptipo,
           c.ppexte,
           c.ppimp1,
           c.ppimp2,
           c.ppimp3,
           c.ppimp4,
           c.ppimp5,
           c.ppimp6,
           c.ppimp7,
           c.ppimp8,
           c.ppimp9,
           c.ppimp10,
           c.ppimp11,
           c.ppimp12,
           c.ppimp13,
           c.ppimp14,
           c.ppimp15,
           c.ppimp16,
           c.ppimp17,
           c.ppimp18,
           c.ppimp19,
           c.ppimp20,
           ld_FchSist,
           lc_hora);
      End;
    End loop;
    commit;
  
  End sp_Backup_fsd611;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_fpp001(ln_cod1    in number,
                             ln_mod1    in number,
                             ln_suc1    in number,
                             ln_mda1    in number,
                             ln_pap1    in number,
                             ln_cta1    in number,
                             ln_oper1   in number,
                             ln_sbop1   in number,
                             ln_tope1   in number,
                             lc_hora    in char,
                             ld_FchSist in date) is
  
    Cursor data2 is
      select fp.*
        from fpp001 fp --->>  <<<fpp001_1>>>
       where fp.pgcod = ln_cod1
         and fp.aomod = ln_mod1
         and fp.aosuc = ln_suc1
         and fp.aomda = ln_mda1
         and fp.aopap = ln_pap1
         and fp.aocta = ln_cta1
         and fp.aooper = ln_oper1
         and fp.aosbop = ln_sbop1
         and fp.aotope = ln_tope1;
  
  BEGIN
    For d in data2 loop
    
      Begin
      
        insert into jaqy761 -->>>> backup fpp001 
          (jaqy761pgcod,
           jaqy761mod,
           jaqy761suc,
           jaqy761mda,
           jaqy761pap,
           jaqy761cta,
           jaqy761oper,
           jaqy761sbop,
           jaqy761tope,
           jaqy761sgcod,
           jaqy761vc,
           jaqy761imp,
           jaqy761porc,
           jaqy761plus,
           jaqy761part,
           jaqy761veh,
           jaqy761inm,
           jaqy761end,
           jaqy761stat,
           jaqy761co,
           jaqy761aux1,
           jaqy761aux2,
           jaqy761aux3,
           jaqy761aux4,
           jaqy761aux5,
           jaqy761aux6,
           jaqy761aux7,
           jaqy761fsist,
           jaqy761HraSis)
        values
          (d.pgcod,
           d.aomod,
           d.aosuc,
           d.aomda,
           d.aopap,
           d.aocta,
           d.aooper,
           d.aosbop,
           d.aotope,
           d.sgcod,
           d.pp001vc,
           d.pp001imp,
           d.pp001porc,
           d.pp001plus,
           d.pp001part,
           d.pp001veh,
           d.pp001inm,
           d.pp001end,
           d.pp001stat,
           d.pp001co,
           d.pp001aux1,
           d.pp001aux2,
           d.pp001aux3,
           d.pp001aux4,
           d.pp001aux5,
           d.pp001aux6,
           d.pp001aux7,
           ld_FchSist,
           lc_hora);
      End;
    End loop;
    commit;
  
  End sp_Backup_fpp001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_DESF_REVERTIR_II;
/

