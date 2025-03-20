create or replace package PQ_CR_DESF_DUPLICADOS_VC is

  -- *****************************************************************
  -- Nombre                     : PROCESO DE DESAFILIACION DUPLICADOS VIDA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CREDITOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.11.24
  -- Autor de Creación          : MSOLARI 
  -- Uso                        : DESAFILIACION DE SEGUROS VIDA CAJA DUPLICADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : -
  -- Autor de la Modificación   : -
  -- Descripción de Modificación: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_Identificacion_Crd;
  Procedure sp_Backup_Fsd611(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_hora1    in char,
                             ld_FchSist1 in date);
  Procedure sp_Backup_Fpp001(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_hora1    in char,
                             ld_FchSist1 in date,
                             ln_contsg1  out number);

  Procedure sp_Mover_Seguros(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_ndoc1    in char,
                             ln_contsg2  in number,
                             ln_estd1    in number,
                             ld_FchSist1 in date,
                             lc_hora1    in char,
                             ld_fmax_1   in date,
                             lc_Stat_1   in char);

  Procedure sp_Comparar_Seguros1(ln_cod1    in number,
                                ln_mod1    in number,
                                ln_suc1    in number,
                                ln_mda1    in number,
                                ln_pap1    in number,
                                ln_cta1    in number,
                                ln_oper1   in number,
                                ln_sbop1   in number,
                                ln_tope1   in number,
                                ln_contsg2 in number,
                                ln_cont_1  out number,
                                ln_cont_2  out number,
                                ld_fmax_1  in date,
                                lc_Stat_1  in char,
                                lc_indr1   out char);
                                
  Procedure sp_Comparar_Seguros2(ln_cod1    in number,
                                ln_mod1    in number,
                                ln_suc1    in number,
                                ln_mda1    in number,
                                ln_pap1    in number,
                                ln_cta1    in number,
                                ln_oper1   in number,
                                ln_sbop1   in number,
                                ln_tope1   in number,
                                ln_contsg2 in number,
                                ln_cont_1  out number,
                                ln_cont_2  out number,
                                ld_fmax_1  in date,
                                lc_Stat_1  in char,
                                lc_indr1   out char);

  Function fn_Maxima_FechaPago(ln_cod1  in number,
                               ln_mod1  in number,
                               ln_suc1  in number,
                               ln_mda1  in number,
                               ln_pap1  in number,
                               ln_cta1  in number,
                               ln_oper1 in number,
                               ln_sbop1 in number,
                               ln_tope1 in number) return date;

  Function fn_Maxima_NumPago(ln_cod1  in number,
                             ln_mod1  in number,
                             ln_suc1  in number,
                             ln_mda1  in number,
                             ln_pap1  in number,
                             ln_cta1  in number,
                             ln_oper1 in number,
                             ln_sbop1 in number,
                             ln_tope1 in number,
                             ld_fmax1 in date) return number;

  Function fn_Estado(ln_cod1  in number,
                     ln_mod1  in number,
                     ln_suc1  in number,
                     ln_mda1  in number,
                     ln_pap1  in number,
                     ln_cta1  in number,
                     ln_oper1 in number,
                     ln_sbop1 in number,
                     ln_tope1 in number,
                     ld_fmax1 in date,
                     ln_nump1 in number) return char;

  Procedure sp_Revertir_Data1(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fmax1 in date);

  Procedure sp_Revertir_Data2(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fmax1 in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_DESF_DUPLICADOS_VC;
/

create or replace package body PQ_CR_DESF_DUPLICADOS_VC is
  -- *****************************************************************
  -- Nombre                     : PROCESO DE DESAFILIACION DUPLICADOS VIDA CAJA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CREDITOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.11.24
  -- Autor de Creación          : MSOLARI 
  -- Uso                        : DESAFILIACION DE SEGUROS VIDA CAJA DUPLICADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : -
  -- Autor de la Modificación   : -
  -- Descripción de Modificación: -
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure sp_Identificacion_Crd is
  
    Cursor CImp1 is
      select ds.jaqy752cta, ds.jaqy752oper, ds.jaqy752ndoc from JAQY752 ds; --->>>>>>Tabla temporal 
  
    cursor CImp2(ln_Ccta number, ln_Coper number) is
    --->>>>>>JAQY751 - Tabla temporal         
      select b.*
        from JAQY752 a, FSD010 b, fpp001 c --->>  <<<fpp001_1>>>
       where a.jaqy752cta = ln_Ccta
         and a.jaqy752oper = ln_Coper
         and b.AOCTA = a.jaqy752cta
         and b.AOOPER = a.jaqy752oper
         and c.pgcod = b.pgcod
         and c.aomod = b.aomod
         and c.aosuc = b.aosuc
         and c.aomda = b.aomda
         and c.aopap = b.aopap
         and c.aocta = b.aocta
         and c.aooper = b.aooper
         and c.aosbop = b.aosbop
         and c.aotope = b.aotope
         and c.sgcod in (116, 117, 118, 120, 121, 122)
         and (b.aomod in (select modulo from fst111 where dscod = 50))
         and b.aostat <> 99;
  
    ln_cod  number(3);
    ln_mod  number(4);
    ln_suc  number(3);
    ln_mda  number(3);
    ln_pap  number(3);
    ln_cta  number(9);
    ln_oper number(9);
    ln_sbop number(3);
    ln_tope number(3);
    ---------------------
    lc_hora    char(8);
    ld_FchSist date;
    lc_ndoc    char(12);
    ln_contsg2 number(3);
    ln_contsg  number(3);
    ln_estd    number(2);
    ln_cont1   number(5);
    ln_cont2   number(5);
    ld_fmax    date;
    lc_Stat    char(1);
    ln_Ccta    number(9);
    ln_Coper   number(9);
    lc_indr1   char(1);
  
    ln_nump number(9);
  Begin
  
    For a in CImp1 loop
      ln_Ccta  := a.jaqy752cta;
      ln_Coper := a.jaqy752oper;
      lc_ndoc  := a.jaqy752ndoc;
    
      For b in CImp2(ln_Ccta, ln_Coper) loop
        ln_cod  := b.pgcod;
        ln_suc  := b.aosuc;
        ln_mod  := b.aomod;
        ln_mda  := b.aomda;
        ln_pap  := b.aopap;
        ln_cta  := b.aocta;
        ln_oper := b.aooper;
        ln_sbop := b.aosbop;
        ln_tope := b.aotope;
        ln_estd := b.aostat;
      
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
      
        pq_cr_desf_duplicados_vc.sp_Backup_Fsd611(ln_cod,
                                                  ln_mod,
                                                  ln_suc,
                                                  ln_mda,
                                                  ln_pap,
                                                  ln_cta,
                                                  ln_oper,
                                                  ln_sbop,
                                                  ln_tope,
                                                  lc_hora,
                                                  ld_FchSist);
      
        pq_cr_desf_duplicados_vc.sp_Backup_Fpp001(ln_cod,
                                                  ln_mod,
                                                  ln_suc,
                                                  ln_mda,
                                                  ln_pap,
                                                  ln_cta,
                                                  ln_oper,
                                                  ln_sbop,
                                                  ln_tope,
                                                  lc_hora,
                                                  ld_FchSist,
                                                  ln_contsg);
        ln_contsg2 := ln_contsg;  
      
        ld_fmax := fn_Maxima_FechaPago(ln_cod,
                                       ln_mod,
                                       ln_suc,
                                       ln_mda,
                                       ln_pap,
                                       ln_cta,
                                       ln_oper,
                                       ln_sbop,
                                       ln_tope);
      
        ln_nump := fn_Maxima_NumPago(ln_cod,
                                     ln_mod,
                                     ln_suc,
                                     ln_mda,
                                     ln_pap,
                                     ln_cta,
                                     ln_oper,
                                     ln_sbop,
                                     ln_tope,
                                     ld_fmax);
      
        lc_Stat := fn_Estado(ln_cod,
                             ln_mod,
                             ln_suc,
                             ln_mda,
                             ln_pap,
                             ln_cta,
                             ln_oper,
                             ln_sbop,
                             ln_tope,
                             ld_fmax,
                             ln_nump);
      
        pq_cr_desf_duplicados_vc.sp_Mover_Seguros(ln_cod,
                                                  ln_mod,
                                                  ln_suc,
                                                  ln_mda,
                                                  ln_pap,
                                                  ln_cta,
                                                  ln_oper,
                                                  ln_sbop,
                                                  ln_tope,
                                                  lc_ndoc,
                                                  ln_contsg2,
                                                  ln_estd,
                                                  ld_FchSist,
                                                  lc_hora,
                                                  ld_fmax,
                                                  lc_Stat);
        If lc_Stat = 'T' or lc_Stat = 'N' then
        pq_cr_desf_duplicados_vc.sp_Comparar_Seguros1(ln_cod,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_oper,
                                                     ln_sbop,
                                                     ln_tope,
                                                     ln_contsg2,
                                                     ln_cont1,
                                                     ln_cont2,
                                                     ld_fmax,
                                                     lc_Stat,
                                                     lc_indr1);
        Else
            pq_cr_desf_duplicados_vc.sp_Comparar_Seguros2(ln_cod,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_oper,
                                                     ln_sbop,
                                                     ln_tope,
                                                     ln_contsg2,
                                                     ln_cont1,
                                                     ln_cont2,
                                                     ld_fmax,
                                                     lc_Stat,
                                                     lc_indr1);
       End If;                                         
       /* If lc_indr1 = 'R' and (lc_Stat = 'T' or lc_Stat = 'N') then
          pq_cr_desf_duplicados_vc.sp_Revertir_Data1(ln_cod,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_oper,
                                                     ln_sbop,
                                                     ln_tope,
                                                     ld_fmax);
        Else
          pq_cr_desf_duplicados_vc.sp_Revertir_Data2(ln_cod,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_oper,
                                                     ln_sbop,
                                                     ln_tope,
                                                     ld_fmax);
        End If;*/
      End loop;
    End loop;
  End sp_Identificacion_Crd;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_Fsd611(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_hora1    in char,
                             ld_FchSist1 in date) is
  
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
        insert into jaqy756 -->>>> backup_fsd611 
          (jaqy756cod,
           jaqy756mod,
           jaqy756suc,
           jaqy756mda,
           jaqy756pap,
           jaqy756cta,
           jaqy756oper,
           jaqy756sbop,
           jaqy756tope,
           jaqy756fpag,
           jaqy756tipo,
           jaqy756exte,
           jaqy756imp1,
           jaqy756imp2,
           jaqy756imp3,
           jaqy756imp4,
           jaqy756imp5,
           jaqy756imp6,
           jaqy756imp7,
           jaqy756imp8,
           jaqy756imp9,
           jaqy756imp10,
           jaqy756imp11,
           jaqy756imp12,
           jaqy756imp13,
           jaqy756imp14,
           jaqy756imp15,
           jaqy756imp16,
           jaqy756imp17,
           jaqy756imp18,
           jaqy756imp19,
           jaqy756imp20,
           jaqy756fsist,
           jaqy756HraSis)
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
           ld_FchSist1,
           lc_hora1);
      End;
    End loop;
    commit;
  End sp_Backup_Fsd611;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Backup_Fpp001(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_hora1    in char,
                             ld_FchSist1 in date,
                             ln_contsg1  out number) is
  
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
  
    ln_contsgI number := 0;
  
  BEGIN
    For d in data2 loop
    
      Begin
        ln_contsgI := ln_contsgI + 1;
      
        insert into jaqy753 -->>>> backup fpp001 
          (jaqy753pgcod,
           jaqy753mod,
           jaqy753suc,
           jaqy753mda,
           jaqy753pap,
           jaqy753cta,
           jaqy753oper,
           jaqy753sbop,
           jaqy753tope,
           jaqy753sgcod,
           jaqy753vc,
           jaqy753imp,
           jaqy753porc,
           jaqy753plus,
           jaqy753part,
           jaqy753veh,
           jaqy753inm,
           jaqy753end,
           jaqy753stat,
           jaqy753co,
           jaqy753aux1,
           jaqy753aux2,
           jaqy753aux3,
           jaqy753aux4,
           jaqy753aux5,
           jaqy753aux6,
           jaqy753aux7,
           jaqy753fsist,
           jaqy753HraSis)
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
           ld_FchSist1,
           lc_hora1);
      End;
    End loop;
    commit;
    ln_contsg1 := ln_contsgI;
  End sp_Backup_Fpp001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Mover_Seguros(ln_cod1     in number,
                             ln_mod1     in number,
                             ln_suc1     in number,
                             ln_mda1     in number,
                             ln_pap1     in number,
                             ln_cta1     in number,
                             ln_oper1    in number,
                             ln_sbop1    in number,
                             ln_tope1    in number,
                             lc_ndoc1    in char,
                             ln_contsg2  in number,
                             ln_estd1    in number,
                             ld_FchSist1 in date,
                             lc_hora1    in char,
                             ld_fmax_1   in date,
                             lc_Stat_1   in char) is
  
    Cursor Move1 is
    select distinct q.ppcta, q.ppoper
     -- select q.*
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
      /*order by q.ppfpag*/;
  
  BEGIN
    For x in Move1 loop
    
      If ln_contsg2 = 1 or ln_contsg2 = 2 then
        If lc_Stat_1 = 'T' or lc_Stat_1 = 'N' then
          Update fsd611 t --->>  <<<fsd611_1>>>
             set t.ppimp11 = t.ppimp12,
                 t.ppimp12 = t.ppimp13,
                 t.ppimp13 = t.ppimp14,
                 t.ppimp14 = t.ppimp15,
                 t.ppimp15 = 0.00
           where t.ppcta = x.ppcta
             and t.ppoper = x.ppoper
             and t.ppfpag >= ld_fmax_1;
        Else
          Update fsd611 t --->>  <<<fsd611_1>>>
             set t.ppimp11 = t.ppimp12,
                 t.ppimp12 = t.ppimp13,
                 t.ppimp13 = t.ppimp14,
                 t.ppimp14 = t.ppimp15,
                 t.ppimp15 = 0.00
           where t.ppcta = x.ppcta
             and t.ppoper = x.ppoper
             and t.ppfpag > ld_fmax_1;
        End If;
        commit;
      End If;

    End loop;
  
    --//////////////Actualizar JAQY752 - TABLA TEMPORAL
        Update JAQY752 y
           set y.jaqy752indE   = 'S', --Seguros 'S'
               y.jaqy752fchsis = ld_FchSist1,
               y.jaqy752horsis = lc_hora1,
               y.jaqy752estcrd = ln_estd1,
               y.jaqy752contsg = ln_contsg2,
               y.jaqy752fchpg  = ld_fmax_1,
               y.jaqy752estpg  = lc_Stat_1
         where y.jaqy752cta = ln_cta1
           and y.jaqy752oper = ln_oper1
           and y.jaqy752ndoc = lc_ndoc1;
        commit;
        
    --//////////////Eliminar     
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
    
     --//////////////Actualizar JAQY752 - TABLA TEMPORAL
      Update JAQY752 y
         set y.jaqy752indE   = 'E', --eliminado 'E'
             y.jaqy752fchsis = ld_FchSist1,
             y.jaqy752horsis = lc_hora1,
             y.jaqy752estcrd = ln_estd1,
             y.jaqy752contsg = ln_contsg2,
             y.jaqy752fchpg  = ld_fmax_1,
             y.jaqy752estpg  = lc_Stat_1
       where y.jaqy752cta = ln_cta1
         and y.jaqy752oper = ln_oper1
         and y.jaqy752ndoc = lc_ndoc1;
      commit;
      
  End sp_Mover_Seguros;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Comparar_Seguros1(ln_cod1    in number,
                                ln_mod1    in number,
                                ln_suc1    in number,
                                ln_mda1    in number,
                                ln_pap1    in number,
                                ln_cta1    in number,
                                ln_oper1   in number,
                                ln_sbop1   in number,
                                ln_tope1   in number,
                                ln_contsg2 in number,
                                ln_cont_1  out number,
                                ln_cont_2  out number,
                                ld_fmax_1  in date,
                                lc_Stat_1  in char,
                                lc_indr1   out char) is
  
    cursor cur_temp1 is
      select p.jaqy756cod,
             p.jaqy756mod,
             p.jaqy756suc,
             p.jaqy756mda,
             p.jaqy756pap,
             p.jaqy756cta,
             p.jaqy756oper,
             p.jaqy756sbop,
             p.jaqy756tope,
             p.jaqy756fpag,
             p.jaqy756imp12,
             q.ppimp11
        from jaqy756 p, fsd611 q -->> fsd611_1 
       where q.pgcod = p.jaqy756cod
         and q.ppmod = p.jaqy756mod
         and q.ppsuc = p.jaqy756suc
         and q.ppmda = p.jaqy756mda
         and q.pppap = p.jaqy756pap
         and q.ppcta = p.jaqy756cta
         and q.ppoper = p.jaqy756oper
         and q.ppsbop = p.jaqy756sbop
         and q.pptope = p.jaqy756tope
         and q.ppfpag = p.jaqy756fpag
         and p.jaqy756fpag >= ld_fmax_1
         and p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
      /*and p.jaqy756cta  = 1528009 
      and p.jaqy756oper = 2266195*/
       order by p.jaqy756fpag;
  
    ln_cod   number(3);
    ln_mod   number(4);
    ln_suc   number(3);
    ln_mda   number(3);
    ln_pap   number(3);
    ln_cta   number(9);
    ln_oper  number(9);
    ln_sbop  number(3);
    ln_tope  number(3);
    ld_pfpag date;
    ln_imp12 number(17, 2);
    ----------------------
    ln_cont1  number := 0;
    ln_cont2  number := 0;
    ln_sumseg number := 0;
    --lc_ndoc   char(12);
    ln_imp11 number(17, 2);
  
    --ld_fmax date;
    --lc_Stat char(1);
    lc_indr char(1);
  
  Begin
  
    For k in cur_temp1 loop
    
      ln_cod   := k.jaqy756cod;
      ln_mod   := k.jaqy756mod;
      ln_suc   := k.jaqy756suc;
      ln_mda   := k.jaqy756mda;
      ln_pap   := k.jaqy756pap;
      ln_cta   := k.jaqy756cta;
      ln_oper  := k.jaqy756oper;
      ln_sbop  := k.jaqy756sbop;
      ln_tope  := k.jaqy756tope;
      ld_pfpag := k.jaqy756fpag;
      ln_imp11 := k.ppimp11;
      ln_imp12 := k.jaqy756imp12;
    
      Begin
        If lc_Stat_1 = 'T' then
        
          If ln_contsg2 = 1 then
          
            Begin
              select sum(p.ppimp11)
                into ln_sumseg
                from fsd611 /*fsd611_1*/ p
               where p.pgcod = ln_cod
                 and p.ppmod = ln_mod
                 and p.ppsuc = ln_suc
                 and p.ppmda = ln_mda
                 and p.pppap = ln_pap
                 and p.ppcta = ln_cta
                 and p.ppoper = ln_oper
                 and p.ppsbop = ln_sbop
                 and p.pptope = ln_tope
                 and p.ppfpag >= ld_fmax_1
               order by p.ppcta, p.ppfpag;
            Exception
              when no_data_found then
                ln_sumseg := 0;
            End;
          
            If ln_sumseg <> 0 then
              ln_cont1 := ln_cont1 + 1;
              Exit;
            End If;
          Else
            If ln_imp11 <> ln_imp12 then
              ln_cont2 := ln_cont2 + 1;
            End If;
          End If;
        Else
          Begin
            select sum(p.ppimp11)
              into ln_sumseg
              from fsd611 /*fsd611_1*/ p
             where p.pgcod = ln_cod
               and p.ppmod = ln_mod
               and p.ppsuc = ln_suc
               and p.ppmda = ln_mda
               and p.pppap = ln_pap
               and p.ppcta = ln_cta
               and p.ppoper = ln_oper
               and p.ppsbop = ln_sbop
               and p.pptope = ln_tope
               and p.ppfpag >= ld_fmax_1
             order by p.ppcta, p.ppfpag;
          Exception
            when no_data_found then
              ln_sumseg := 0;
          End;
        
          If ln_contsg2 = 1 then
            If ln_sumseg <> 0 then
              ln_cont1 := ln_cont1 + 1;
            End If;
          Else
            If ln_imp11 <> ln_imp12 then
              ln_cont2 := ln_cont2 + 1;
            End If;
          End If;
        End If;
      Exception
        when no_data_found then
          null;
      End;
      --//////////////Actualizar JAQY752 - TABLA TEMPORAL
    End loop;
  
    ln_cont_1 := ln_cont1;
    ln_cont_2 := ln_cont2;
  
    Begin
      -- If ln_cont1 <> 0 or ln_cont2 <> 0 then
      If ln_cont_1 <> 0 or ln_cont_2 <> 0 then
        Update JAQY752 y
           set y.jaqy752indr = 'R' --eliminado
         where y.jaqy752cta = ln_cta
           and y.jaqy752oper = ln_oper;
        commit;
      
        lc_indr := 'R';
      End If;
      /* pq_cr_desf_duplicados_vc.sp_Revertir_Data(ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, 
            ln_cta, ln_oper, ln_sbop, ln_tope,
      ld_fmax, lc_Stat);*/
    End;
    lc_indr1 := lc_indr;
  End sp_Comparar_Seguros1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Comparar_Seguros2(ln_cod1    in number,
                                ln_mod1    in number,
                                ln_suc1    in number,
                                ln_mda1    in number,
                                ln_pap1    in number,
                                ln_cta1    in number,
                                ln_oper1   in number,
                                ln_sbop1   in number,
                                ln_tope1   in number,
                                ln_contsg2 in number,
                                ln_cont_1  out number,
                                ln_cont_2  out number,
                                ld_fmax_1  in date,
                                lc_Stat_1  in char,
                                lc_indr1   out char) is
  
    cursor cur_temp1 is
      select p.jaqy756cod,
             p.jaqy756mod,
             p.jaqy756suc,
             p.jaqy756mda,
             p.jaqy756pap,
             p.jaqy756cta,
             p.jaqy756oper,
             p.jaqy756sbop,
             p.jaqy756tope,
             p.jaqy756fpag,
             p.jaqy756imp12,
             q.ppimp11
        from jaqy756 p, fsd611 q -->> fsd611_1 
       where q.pgcod = p.jaqy756cod
         and q.ppmod = p.jaqy756mod
         and q.ppsuc = p.jaqy756suc
         and q.ppmda = p.jaqy756mda
         and q.pppap = p.jaqy756pap
         and q.ppcta = p.jaqy756cta
         and q.ppoper = p.jaqy756oper
         and q.ppsbop = p.jaqy756sbop
         and q.pptope = p.jaqy756tope
         and q.ppfpag = p.jaqy756fpag
         and p.jaqy756fpag > ld_fmax_1
         and p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
      /*and p.jaqy756cta  = 1528009 
      and p.jaqy756oper = 2266195*/
       order by p.jaqy756fpag;
  
    ln_cod   number(3);
    ln_mod   number(4);
    ln_suc   number(3);
    ln_mda   number(3);
    ln_pap   number(3);
    ln_cta   number(9);
    ln_oper  number(9);
    ln_sbop  number(3);
    ln_tope  number(3);
    ld_pfpag date;
    ln_imp12 number(17, 2);
    ----------------------
    ln_cont1  number := 0;
    ln_cont2  number := 0;
    ln_sumseg number := 0;
    --lc_ndoc   char(12);
    ln_imp11 number(17, 2);
  
    --ld_fmax date;
    --lc_Stat char(1);
    lc_indr char(1);
  
  Begin
  
    For k in cur_temp1 loop
    
      ln_cod   := k.jaqy756cod;
      ln_mod   := k.jaqy756mod;
      ln_suc   := k.jaqy756suc;
      ln_mda   := k.jaqy756mda;
      ln_pap   := k.jaqy756pap;
      ln_cta   := k.jaqy756cta;
      ln_oper  := k.jaqy756oper;
      ln_sbop  := k.jaqy756sbop;
      ln_tope  := k.jaqy756tope;
      ld_pfpag := k.jaqy756fpag;
      ln_imp11 := k.ppimp11;
      ln_imp12 := k.jaqy756imp12;
    
      Begin
        If lc_Stat_1 = 'T' then
        
          If ln_contsg2 = 1 then
          
            Begin
              select sum(p.ppimp11)
                into ln_sumseg
                from fsd611 /*fsd611_1*/ p
               where p.pgcod = ln_cod
                 and p.ppmod = ln_mod
                 and p.ppsuc = ln_suc
                 and p.ppmda = ln_mda
                 and p.pppap = ln_pap
                 and p.ppcta = ln_cta
                 and p.ppoper = ln_oper
                 and p.ppsbop = ln_sbop
                 and p.pptope = ln_tope
                 and p.ppfpag > ld_fmax_1
               order by p.ppcta, p.ppfpag;
            Exception
              when no_data_found then
                ln_sumseg := 0;
            End;
          
            If ln_sumseg <> 0 then
              ln_cont1 := ln_cont1 + 1;
              Exit;
            End If;
          Else
            If ln_imp11 <> ln_imp12 then
              ln_cont2 := ln_cont2 + 1;
            End If;
          End If;
        Else
          Begin
            select sum(p.ppimp11)
              into ln_sumseg
              from fsd611 /*fsd611_1*/ p
             where p.pgcod = ln_cod
               and p.ppmod = ln_mod
               and p.ppsuc = ln_suc
               and p.ppmda = ln_mda
               and p.pppap = ln_pap
               and p.ppcta = ln_cta
               and p.ppoper = ln_oper
               and p.ppsbop = ln_sbop
               and p.pptope = ln_tope
               and p.ppfpag > ld_fmax_1
             order by p.ppcta, p.ppfpag;
          Exception
            when no_data_found then
              ln_sumseg := 0;
          End;
        
          If ln_contsg2 = 1 then
            If ln_sumseg <> 0 then
              ln_cont1 := ln_cont1 + 1;
            End If;
          Else
            If ln_imp11 <> ln_imp12 then
              ln_cont2 := ln_cont2 + 1;
            End If;
          End If;
        End If;
      Exception
        when no_data_found then
          null;
      End;
      --//////////////Actualizar JAQY752 - TABLA TEMPORAL
    End loop;
  
    ln_cont_1 := ln_cont1;
    ln_cont_2 := ln_cont2;
  
    Begin
      -- If ln_cont1 <> 0 or ln_cont2 <> 0 then
      If ln_cont_1 <> 0 or ln_cont_2 <> 0 then
        Update JAQY752 y
           set y.jaqy752indr = 'R' --eliminado
         where y.jaqy752cta = ln_cta
           and y.jaqy752oper = ln_oper;
        commit;
      
        lc_indr := 'R';
      End If;
      /* pq_cr_desf_duplicados_vc.sp_Revertir_Data(ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, 
            ln_cta, ln_oper, ln_sbop, ln_tope,
      ld_fmax, lc_Stat);*/
    End;
    lc_indr1 := lc_indr;
  End sp_Comparar_Seguros2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_Estado(ln_cod1  in number,
                     ln_mod1  in number,
                     ln_suc1  in number,
                     ln_mda1  in number,
                     ln_pap1  in number,
                     ln_cta1  in number,
                     ln_oper1 in number,
                     ln_sbop1 in number,
                     ln_tope1 in number,
                     ld_fmax1 in date,
                     ln_nump1 in number) return char is
  
    lc_Stat char(1);
  Begin
    Begin
      select y.pp1stat
        into lc_Stat
        from fsd602 y
       where y.pgcod = ln_cod1
         and y.ppmod = ln_mod1
         and y.ppsuc = ln_suc1
         and y.ppmda = ln_mda1
         and y.pppap = ln_pap1
         and y.ppcta = ln_cta1
         and y.ppoper = ln_oper1
         and y.ppsbop = ln_sbop1
         and y.pptope = ln_tope1
         and y.ppfpag = ld_fmax1
         and y.pp1nump = ln_nump1;
    Exception
      when no_data_found then
        lc_Stat := 'N';
    End;
  
    return lc_Stat;
  
  End fn_Estado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_Maxima_NumPago(ln_cod1  in number,
                             ln_mod1  in number,
                             ln_suc1  in number,
                             ln_mda1  in number,
                             ln_pap1  in number,
                             ln_cta1  in number,
                             ln_oper1 in number,
                             ln_sbop1 in number,
                             ln_tope1 in number,
                             ld_fmax1 in date) return number is
  
    ln_pp1nump number(9);
  Begin
    Begin
      select max(a.pp1nump)
        into ln_pp1nump
        from fsd602 a
       Where a.pgcod = ln_cod1
         and a.ppmod = ln_mod1
         and a.ppsuc = ln_suc1
         and a.ppmda = ln_mda1
         and a.pppap = ln_pap1
         and a.ppcta = ln_cta1
         and a.ppoper = ln_oper1
         and a.ppsbop = ln_sbop1
         and a.pptope = ln_tope1
         and a.ppfpag = ld_fmax1;
    exception
      when no_data_found then
        ln_pp1nump := 0;
    End;
    return ln_pp1nump;
  
  End fn_Maxima_NumPago;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_Maxima_FechaPago(ln_cod1  in number,
                               ln_mod1  in number,
                               ln_suc1  in number,
                               ln_mda1  in number,
                               ln_pap1  in number,
                               ln_cta1  in number,
                               ln_oper1 in number,
                               ln_sbop1 in number,
                               ln_tope1 in number) return date is
  
    ld_fmax date;
  Begin
    Begin
      select max(f.ppfpag)
        into ld_fmax
        from fsd602 f
       where f.pgcod = ln_cod1
         and f.ppmod = ln_mod1
         and f.ppsuc = ln_suc1
         and f.ppmda = ln_mda1
         and f.pppap = ln_pap1
         and f.ppcta = ln_cta1
         and f.ppoper = ln_oper1
         and f.ppsbop = ln_sbop1
         and f.pptope = ln_tope1
         and f.D602Co = 'S';
    Exception
      when others then
        null;
    End;
  
    If ld_fmax is null then
    
      select min(f.ppfpag)
        into ld_fmax
        from fsd601 f
       where f.pgcod = ln_cod1
         and f.ppmod = ln_mod1
         and f.ppsuc = ln_suc1
         and f.ppmda = ln_mda1
         and f.pppap = ln_pap1
         and f.ppcta = ln_cta1
         and f.ppoper = ln_oper1
         and f.ppsbop = ln_sbop1
         and f.pptope = ln_tope1;
    End If;
  
    return ld_fmax;
  End fn_Maxima_FechaPago;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Revertir_Data1(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fmax1 in date) is
  
    cursor cur_rev1 is
      select p.jaqy756cod,
             p.jaqy756mod,
             p.jaqy756suc,
             p.jaqy756mda,
             p.jaqy756pap,
             p.jaqy756cta,
             p.jaqy756oper,
             p.jaqy756sbop,
             p.jaqy756tope,
             p.jaqy756fpag,
             p.jaqy756imp11,
             p.jaqy756imp12,
             p.jaqy756imp13,
             p.jaqy756imp14,
             p.jaqy756imp15,
             q.ppimp11
        from jaqy756 p, fsd611 q -->> fsd611_1 
       where q.pgcod = p.jaqy756cod
         and q.ppmod = p.jaqy756mod
         and q.ppsuc = p.jaqy756suc
         and q.ppmda = p.jaqy756mda
         and q.pppap = p.jaqy756pap
         and q.ppcta = p.jaqy756cta
         and q.ppoper = p.jaqy756oper
         and q.ppsbop = p.jaqy756sbop
         and q.pptope = p.jaqy756tope
         and q.ppfpag = p.jaqy756fpag
         and p.jaqy756fpag >= ld_fmax1
         and p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
       order by p.jaqy756cta, p.jaqy756fpag;
  
    ln_cod     number(3);
    ln_mod     number(4);
    ln_suc     number(3);
    ln_mda     number(3);
    ln_pap     number(3);
    ln_cta     number(9);
    ln_oper    number(9);
    ln_sbop    number(3);
    ln_tope    number(3);
    ld_pfpag   date;
    ln_ppimp11 number(17, 2);
    ln_ppimp12 number(17, 2);
    ln_ppimp13 number(17, 2);
    ln_ppimp14 number(17, 2);
    ln_ppimp15 number(17, 2);
  
  BEGIN
  
    For xx in cur_rev1 loop
      ln_cod     := xx.jaqy756cod;
      ln_mod     := xx.jaqy756mod;
      ln_suc     := xx.jaqy756suc;
      ln_mda     := xx.jaqy756mda;
      ln_pap     := xx.jaqy756pap;
      ln_cta     := xx.jaqy756cta;
      ln_oper    := xx.jaqy756oper;
      ln_sbop    := xx.jaqy756sbop;
      ln_tope    := xx.jaqy756tope;
      ld_pfpag   := xx.jaqy756fpag;
      ln_ppimp11 := xx.jaqy756imp11;
      ln_ppimp12 := xx.jaqy756imp12;
      ln_ppimp13 := xx.jaqy756imp13;
      ln_ppimp14 := xx.jaqy756imp14;
      ln_ppimp15 := xx.jaqy756imp15;
    
      Update fsd611 /*fsd611_1*/ t
         set t.ppimp11 = ln_ppimp11,
             t.ppimp12 = ln_ppimp12,
             t.ppimp13 = ln_ppimp13,
             t.ppimp14 = ln_ppimp14,
             t.ppimp15 = ln_ppimp15
       where t.pgcod = ln_cod
         and t.ppmod = ln_mod --xx.jaqy756mod -- 
         and t.ppsuc = ln_suc --xx.jaqy756suc -- 
         and t.ppmda = ln_mda --xx.jaqy756mda -- 
         and t.pppap = ln_pap --xx.jaqy756pap --
         and t.ppcta = ln_cta --xx.jaqy756cta --ln_cta
         and t.ppoper = ln_oper --xx.jaqy756oper --
         and t.ppsbop = ln_sbop --xx.jaqy756sbop --
         and t.pptope = ln_tope --xx.jaqy756tope --
         and t.ppfpag = ld_pfpag;
      commit;
    End loop;
  End sp_Revertir_Data1;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Revertir_Data2(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fmax1 in date) is
  
    cursor cur_rev1 is
      select p.jaqy756cod,
             p.jaqy756mod,
             p.jaqy756suc,
             p.jaqy756mda,
             p.jaqy756pap,
             p.jaqy756cta,
             p.jaqy756oper,
             p.jaqy756sbop,
             p.jaqy756tope,
             p.jaqy756fpag,
             p.jaqy756imp11,
             p.jaqy756imp12,
             p.jaqy756imp13,
             p.jaqy756imp14,
             p.jaqy756imp15,
             q.ppimp11
        from jaqy756 p, fsd611 q -->> fsd611_1 
       where q.pgcod = p.jaqy756cod
         and q.ppmod = p.jaqy756mod
         and q.ppsuc = p.jaqy756suc
         and q.ppmda = p.jaqy756mda
         and q.pppap = p.jaqy756pap
         and q.ppcta = p.jaqy756cta
         and q.ppoper = p.jaqy756oper
         and q.ppsbop = p.jaqy756sbop
         and q.pptope = p.jaqy756tope
         and q.ppfpag = p.jaqy756fpag
         and p.jaqy756fpag > ld_fmax1
         and p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
       order by p.jaqy756cta, p.jaqy756fpag;
  
    ln_cod     number(3);
    ln_mod     number(4);
    ln_suc     number(3);
    ln_mda     number(3);
    ln_pap     number(3);
    ln_cta     number(9);
    ln_oper    number(9);
    ln_sbop    number(3);
    ln_tope    number(3);
    ld_pfpag   date;
    ln_ppimp11 number(17, 2);
    ln_ppimp12 number(17, 2);
    ln_ppimp13 number(17, 2);
    ln_ppimp14 number(17, 2);
    ln_ppimp15 number(17, 2);
  
  BEGIN
  
    For xx in cur_rev1 loop
      ln_cod     := xx.jaqy756cod;
      ln_mod     := xx.jaqy756mod;
      ln_suc     := xx.jaqy756suc;
      ln_mda     := xx.jaqy756mda;
      ln_pap     := xx.jaqy756pap;
      ln_cta     := xx.jaqy756cta;
      ln_oper    := xx.jaqy756oper;
      ln_sbop    := xx.jaqy756sbop;
      ln_tope    := xx.jaqy756tope;
      ld_pfpag   := xx.jaqy756fpag;
      ln_ppimp11 := xx.jaqy756imp11;
      ln_ppimp12 := xx.jaqy756imp12;
      ln_ppimp13 := xx.jaqy756imp13;
      ln_ppimp14 := xx.jaqy756imp14;
      ln_ppimp15 := xx.jaqy756imp15;
    
      Update fsd611 /*fsd611_1*/ t
         set t.ppimp11 = ln_ppimp11,
             t.ppimp12 = ln_ppimp12,
             t.ppimp13 = ln_ppimp13,
             t.ppimp14 = ln_ppimp14,
             t.ppimp15 = ln_ppimp15
       where t.pgcod = ln_cod
         and t.ppmod = ln_mod --xx.jaqy756mod -- 
         and t.ppsuc = ln_suc --xx.jaqy756suc -- 
         and t.ppmda = ln_mda --xx.jaqy756mda -- 
         and t.pppap = ln_pap --xx.jaqy756pap --
         and t.ppcta = ln_cta --xx.jaqy756cta --ln_cta
         and t.ppoper = ln_oper --xx.jaqy756oper --
         and t.ppsbop = ln_sbop --xx.jaqy756sbop --
         and t.pptope = ln_tope --xx.jaqy756tope --
         and t.ppfpag = ld_pfpag;
      commit;
    End loop;
  End sp_Revertir_Data2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_DESF_DUPLICADOS_VC;
/

