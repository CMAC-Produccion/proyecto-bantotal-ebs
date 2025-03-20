create or replace package PQ_CR_DESF_REVERTIR is

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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Procedure sp_Identificacion_Crd;

  Procedure sp_Revertir_Data1(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fech1 in date);

  Procedure sp_Revertir_Data2(ln_cod1  in number,
                              ln_mod1  in number,
                              ln_suc1  in number,
                              ln_mda1  in number,
                              ln_pap1  in number,
                              ln_cta1  in number,
                              ln_oper1 in number,
                              ln_sbop1 in number,
                              ln_tope1 in number,
                              ld_fech1 in date);
                              
  Procedure sp_Revertir_fpp001(ln_cod1  in number,
                               ln_mod1  in number,
                               ln_suc1  in number,
                               ln_mda1  in number,
                               ln_pap1  in number,
                               ln_cta1  in number,
                               ln_oper1 in number,
                               ln_sbop1 in number,
                               ln_tope1 in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_CR_DESF_REVERTIR;
/

create or replace package body PQ_CR_DESF_REVERTIR is
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
  
    Cursor CImp1 is
    --->>>>>>JAQY751 - Tabla temporal         
      select *
        from JAQY752 a, FSD010 b 
       where a.jaqy752cta = jaqy752cta --ln_Ccta
         and a.jaqy752oper = jaqy752oper --ln_Coper
         and b.AOCTA = a.jaqy752cta
         and b.AOOPER = a.jaqy752oper
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
    --lc_hora    char(8);
    --ld_FchSist date;
    lc_indr    char(1);
    ln_estd    number(2);  
    lc_esta char(1);
    ld_fech date;
  
  Begin
  
    For a in CImp1 loop
     /* ln_Ccta  := a.jaqy752cta;
      ln_Coper := a.jaqy752oper;
      lc_ndoc  := a.jaqy752ndoc;
    
      For b in CImp2(ln_Ccta, ln_Coper) loop*/
        ln_cod  := a.pgcod;
        ln_suc  := a.aosuc;
        ln_mod  := a.aomod;
        ln_mda  := a.aomda;
        ln_pap  := a.aopap;
        ln_cta  := a.aocta;
        ln_oper := a.aooper;
        ln_sbop := a.aosbop;
        ln_tope := a.aotope;
        ln_estd := a.aostat;
        lc_esta := a.jaqy752estpg;
        ld_fech := a.jaqy752fchpg;
        lc_indr := a.jaqy752indr;
      
      
        If lc_indr = 'R' then
        If lc_esta = 'T' or lc_esta = 'N' then
          PQ_CR_DESF_REVERTIR.sp_Revertir_Data1(ln_cod,
                                                ln_mod,
                                                ln_suc,
                                                ln_mda,
                                                ln_pap,
                                                ln_cta,
                                                ln_oper,
                                                ln_sbop,
                                                ln_tope,
                                                ld_fech);
        Else
          If  lc_esta = 'P' then
          PQ_CR_DESF_REVERTIR.sp_Revertir_Data2(ln_cod,
                                                ln_mod,
                                                ln_suc,
                                                ln_mda,
                                                ln_pap,
                                                ln_cta,
                                                ln_oper,
                                                ln_sbop,
                                                ln_tope,
                                                ld_fech);
          End If;
        End If;
        
        If lc_esta = 'T' or lc_esta = 'N' or lc_esta = 'P' then
        PQ_CR_DESF_REVERTIR.sp_Revertir_fpp001(ln_cod,
                                               ln_mod,
                                               ln_suc,
                                               ln_mda,
                                               ln_pap,
                                               ln_cta,
                                               ln_oper,
                                               ln_sbop,
                                               ln_tope);
        End If;
        End If;
    End loop;
  End sp_Identificacion_Crd;
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
                              ld_fech1 in date) is
  
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
             p.jaqy756imp15
        from jaqy756 p
       where p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
         and p.jaqy756fpag >= ld_fech1
       order by p.jaqy756fpag;
  
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
    
      Update fsd611  t
         set t.ppimp11 = ln_ppimp11,
             t.ppimp12 = ln_ppimp12,
             t.ppimp13 = ln_ppimp13,
             t.ppimp14 = ln_ppimp14,
             t.ppimp15 = ln_ppimp15
       where t.pgcod = ln_cod
         and t.ppmod = ln_mod 
         and t.ppsuc = ln_suc 
         and t.ppmda = ln_mda  
         and t.pppap = ln_pap 
         and t.ppcta = ln_cta 
         and t.ppoper = ln_oper 
         and t.ppsbop = ln_sbop 
         and t.pptope = ln_tope 
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
                              ld_fech1 in date) is
  
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
             p.jaqy756imp15
        from jaqy756 p
       where p.jaqy756cod = ln_cod1
         and p.jaqy756mod = ln_mod1
         and p.jaqy756suc = ln_suc1
         and p.jaqy756mda = ln_mda1
         and p.jaqy756pap = ln_pap1
         and p.jaqy756cta = ln_cta1
         and p.jaqy756oper = ln_oper1
         and p.jaqy756sbop = ln_sbop1
         and p.jaqy756tope = ln_tope1
         and p.jaqy756fpag > ld_fech1
       order by p.jaqy756fpag;
  
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
  Procedure sp_Revertir_fpp001(ln_cod1  in number,
                               ln_mod1  in number,
                               ln_suc1  in number,
                               ln_mda1  in number,
                               ln_pap1  in number,
                               ln_cta1  in number,
                               ln_oper1 in number,
                               ln_sbop1 in number,
                               ln_tope1 in number) is
    cursor cur_revt is
       select p.*
        from jaqy753 p 
       where p.jaqy753pgcod = ln_cod1
         and p.jaqy753mod = ln_mod1
         and p.jaqy753suc = ln_suc1
         and p.jaqy753mda = ln_mda1
         and p.jaqy753pap = ln_pap1
         and p.jaqy753cta = ln_cta1
         and p.jaqy753oper = ln_oper1
         and p.jaqy753sbop = ln_sbop1
         and p.jaqy753tope = ln_tope1
         and p.jaqy753sgcod in (116, 117, 118, 120, 121, 122);
  
  BEGIN
  
    For y in cur_revt loop
      begin
        insert into fpp001
          (pgcod,
           aomod,
           aosuc,
           aomda,
           aopap,
           aocta,
           aooper,
           aosbop,
           aotope,
           sgcod,
           pp001vc,
           pp001imp,
           pp001porc,
           pp001plus,
           pp001part,
           pp001veh,
           pp001inm,
           pp001end,
           pp001stat,
           pp001co,
           pp001aux1,
           pp001aux2,
           pp001aux3,
           pp001aux4,
           pp001aux5,
           pp001aux6,
           pp001aux7)
        values
          (y.jaqy753pgcod,
           y.jaqy753mod,
           y.jaqy753suc,
           y.jaqy753mda,
           y.jaqy753pap,
           y.jaqy753cta,
           y.jaqy753oper,
           y.jaqy753sbop,
           y.jaqy753tope,
           y.jaqy753sgcod,
           y.jaqy753vc,
           y.jaqy753imp,
           y.jaqy753porc,
           y.jaqy753plus,
           y.jaqy753part,
           y.jaqy753veh,
           y.jaqy753inm,
           y.jaqy753end,
           y.jaqy753stat,
           y.jaqy753co,
           y.jaqy753aux1,
           y.jaqy753aux2,
           y.jaqy753aux3,
           y.jaqy753aux4,
           y.jaqy753aux5,
           y.jaqy753aux6,
           y.jaqy753aux7);
        commit;
      end;
    End loop;
  End sp_Revertir_fpp001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_DESF_REVERTIR;
/

