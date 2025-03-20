create or replace package PQ_OP_DESAFILIACION is
 
    -- *****************************************************************
    -- Nombre                     : PROCESO DE DESAFILIACION PARTE II
    -- Sistema                    : BANTOTAL
    -- Módulo                     : CREDITOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.04.01
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : MODIFICACION DEL PROCESO DE DESAFILIACION DE SEGUROS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de la Modificación   : -
    -- Descripción de Modificación: -
    -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 Procedure sp_Cuotas_Impagas;
 Procedure sp_Backup_Tabla;   
 Procedure sp_Mover_Seguros; 
 Procedure sp_Comparar_Seguros;  
 Procedure sp_Revertir_Data;          
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_DESAFILIACION;
/

create or replace package body PQ_OP_DESAFILIACION is
    -- *****************************************************************
    -- Nombre                     : PROCESO DE DESAFILIACION PARTE II
    -- Sistema                    : BANTOTAL
    -- Módulo                     : CREDITOS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.04.01
    -- Autor de Creación          : MSOLARI 
    -- Uso                        : MODIFICACION DEL PROCESO DE DESAFILIACION DE SEGUROS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : -
    -- Autor de la Modificación   : -
    -- Descripción de Modificación: -
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 
 Procedure sp_Cuotas_Impagas is
  
   Cursor CImp1 is
      select  distinct min(f01.ppfpag) ppfpag,
                     f01.pgcod,
                     f01.ppmod,
                     f01.ppsuc,
                     f01.ppmda,
                     f01.pppap,
                     f01.ppcta,
                     f01.ppoper,
                     f01.ppsbop,
                     f01.pptope
        from fsd601 f01 
        inner join fsd010 a 
           on f01.pgcod  = a.pgcod 
          and f01.ppmod  = a.aomod  
          and f01.ppsuc  = a.aosuc  
          and f01.ppmda  = a.aomda  
          and f01.pppap  = a.aopap  
          and f01.ppcta  = a.aocta  
          and f01.ppoper = a.aooper 
          and f01.ppsbop = a.aosbop 
          and f01.pptope = a.aotope
        inner join fpp001 fp 
           on f01.pgcod  = fp.pgcod 
          and f01.ppmod  = fp.aomod   
          and f01.ppsuc  = fp.aosuc   
          and f01.ppmda  = fp.aomda   
          and f01.pppap  = fp.aopap  
          and f01.ppcta  = fp.aocta 
          and f01.ppoper = fp.aooper
          and f01.ppsbop = fp.aosbop
          and f01.pptope = fp.aotope 
        left  join fsd602 f02
           on f01.pgcod  = f02.pgcod 
          and f01.ppmod  = f02.ppmod  
          and f01.ppsuc  = f02.ppsuc  
          and f01.ppmda  = f02.ppmda  
          and f01.pppap  = f02.pppap  
          and f01.ppcta  = f02.ppcta  
          and f01.ppoper = f02.ppoper 
          and f01.ppsbop = f02.ppsbop 
          and f01.pptope = f02.pptope
          and f01.ppfpag = f02.ppfpag
          where f02.ppfpag is null
          and (a.aomod in (select modulo
                             from fst111
                            where dscod = 50)) 
          and a.aostat  <> 99
          and a.aofval >= '01/10/2015'
          and fp.sgcod in (250,251,252,253,254,255,256,257,258,261,262,263,264,265,266,267,268,271,272,273,274,275,276,277,278)       
          and f01.ppstat <> 'P'
          group by f01.pgcod, f01.ppmod, f01.ppsuc, f01.ppmda,f01.pppap,
                   f01.ppcta, f01.ppoper, f01.ppsbop, f01.pptope;  
                        
   Cursor CImp2 (ln_cod number, ln_mod number, ln_suc number, ln_mda number, ln_pap number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number, ld_pfpag date)is
       select sum(f611.ppimp11) sumseg,
              sum(f611.ppimp12) a12,
              sum(f611.ppimp13) a13,
              sum(f611.ppimp14) a14,
              sum(f611.ppimp15) a15,
              count(f611.ppfpag) fch_cuo 
         from fsd611 f611
         where f611.pgcod  = ln_cod 
           and f611.ppmod  = ln_mod  
           and f611.ppsuc  = ln_suc   
           and f611.ppmda  = ln_mda   
           and f611.pppap  = ln_pap  
           and f611.ppcta  = ln_cta 
           and f611.ppoper = ln_oper
           and f611.ppsbop = ln_sbop
           and f611.pptope = ln_tope;

    ln_cod    number(3);
    ln_mod    number(4);
    ln_suc    number(3);
    ln_mda    number(3);
    ln_pap    number(3);
    ln_cta    number(9);
    ln_oper   number(9);
    ln_sbop   number(3);
    ln_tope   number(3);
    ld_pfpag  date;
    ln_sumseg number(17,2);
    ld_fmax   date;
    lc_Stat   varchar2(1);
    lc_FlgF   varchar2(8);
      
   Begin
   
     For a in CImp1 loop
         ln_cod   := a.pgcod;
         ln_mod   := a.ppmod;
         ln_suc   := a.ppsuc;
         ln_mda   := a.ppmda; 
         ln_pap   := a.pppap;
         ln_cta   := a.ppcta;
         ln_oper  := a.ppoper;
         ln_sbop  := a.ppsbop;
         ln_tope  := a.pptope;
         ld_pfpag := a.ppfpag;      
         
         For b in CImp2 (ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop, ln_tope, ld_pfpag) loop 
            If b.sumseg = 0 then
            
            Begin
             select max(x.ppfpag),max(x.pp1stat)
               into ld_fmax, lc_Stat
               from fsd602 x
              where x.pgcod   = ln_cod 
                and x.ppmod   = ln_mod 
                and x.ppsuc   = ln_suc 
                and x.ppmda   = ln_mda 
                and x.pppap   = ln_pap 
                and x.ppcta   = ln_cta 
                and x.ppoper  = ln_oper 
                and x.ppsbop  = ln_sbop 
                and x.pptope  = ln_tope 
                and x.D602Co  = 'S';
             Exception when no_data_found then
                  ld_fmax := null;
                  lc_Stat := '-';     
             End; 
             
             If ld_fmax is null then 
                   lc_FlgF := 'SinCalen';
             Else
                   lc_FlgF := 'ConCalen';
             End If;
                                  
             insert into jaqy779 -->>>>Cred_Seguros
             (    
                  jaqy779cod,   
                  jaqy779mod,   
                  jaqy779suc,   
                  jaqy779mda,   
                  jaqy779pap,   
                  jaqy779cta,   
                  jaqy779oper,  
                  jaqy779sbop,  
                  jaqy779tope,  
                  jaqy779FchMax,  
                  jaqy779imp11,
                  jaqy779imp12,
                  jaqy779imp13,
                  jaqy779imp14,
                  jaqy779imp15,
                  jaqy779NumCuoT,
                  jaqy779FchPag, 
                  jaqy779Est,
                  jaqy779Descp
             )
             values 
             (    ln_cod,  
                  ln_mod,  
                  ln_suc,  
                  ln_mda,  
                  ln_pap,  
                  ln_cta,  
                  ln_oper, 
                  ln_sbop, 
                  ln_tope, 
                  ld_pfpag,
                  b.sumseg,
                  b.a12,
                  b.a13,
                  b.a14,
                  b.a15,
                  b.fch_cuo,
                  ld_fmax,
                  lc_Stat, 
                  lc_FlgF
              );
              commit;
            End If; 
         End loop;
       commit;
    End loop; 
    Begin
        pq_op_desafiliacion.sp_Backup_Tabla;
    End;    
 End sp_Cuotas_Impagas; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

 procedure sp_Backup_Tabla is
  
 Cursor data1 is 

    select distinct f.*  
      from jaqy779 f;
     
   Cursor data2 (ln_cod number, ln_mod number, ln_suc number, ln_mda number, ln_pap number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number, ld_fpag date)is 
    select fs.*       
     from fsd611 fs
    where fs.pgcod   = ln_cod 
      and fs.ppmod   = ln_mod  
      and fs.ppsuc   = ln_suc 
      and fs.ppmda   = ln_mda 
      and fs.pppap   = ln_pap 
      and fs.ppcta   = ln_cta 
      and fs.ppoper  = ln_oper
      and fs.ppsbop  = ln_sbop
      and fs.pptope  = ln_tope;  
       
    ln_cod    number(3);
    ln_mod    number(4);
    ln_suc    number(3);
    ln_mda    number(3);
    ln_pap    number(3);
    ln_cta    number(9);
    ln_oper   number(9);
    ln_sbop   number(3);
    ln_tope   number(3);
    ld_fpag   date;
    ln_CtaTm  number(9);
    ln_ImpTot number(17,2);
     
BEGIN  
    ln_CtaTm := 0;   
    For c in data1 loop
         ln_cod   := c.jaqy779cod;
         ln_mod   := c.jaqy779mod;
         ln_suc   := c.jaqy779suc;
         ln_mda   := c.jaqy779mda; 
         ln_pap   := c.jaqy779pap;
         ln_cta   := c.jaqy779cta;
         ln_oper  := c.jaqy779oper;
         ln_sbop  := c.jaqy779sbop;
         ln_tope  := c.jaqy779tope;
         ld_fpag  := c.jaqy779fchmax;       
         
       For d in data2 (ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop, ln_tope, ld_fpag) loop 

       Begin 
           If ln_CtaTm <> ln_cta then
              ln_ImpTot := 0;
              ln_ImpTot := d.ppimp12;
           Else
              ln_ImpTot := ln_ImpTot + d.ppimp12;
           End If;
                
             insert into jaqy780 -->>>> backup_fsd611 
             (    
                  jaqy780cod,  
                  jaqy780mod,  
                  jaqy780suc,  
                  jaqy780mda,  
                  jaqy780pap,  
                  jaqy780cta,  
                  jaqy780oper, 
                  jaqy780sbop, 
                  jaqy780tope, 
                  jaqy780fpag,
                  jaqy780tipo,
                  jaqy780exte, 
                  jaqy780imp1, 
                  jaqy780imp2, 
                  jaqy780imp3, 
                  jaqy780imp4, 
                  jaqy780imp5, 
                  jaqy780imp6, 
                  jaqy780imp7, 
                  jaqy780imp8, 
                  jaqy780imp9, 
                  jaqy780imp10,
                  jaqy780imp11,
                  jaqy780imp12,
                  jaqy780imp13,
                  jaqy780imp14,
                  jaqy780imp15,
                  jaqy780imp16,
                  jaqy780imp17,
                  jaqy780imp18,
                  jaqy780imp19,
                  jaqy780imp20
             )
             values 
             (   
                  d.pgcod,  
                  d.ppmod,  
                  d.ppsuc,  
                  d.ppmda,  
                  d.pppap,  
                  d.ppcta,  
                  d.ppoper, 
                  d.ppsbop, 
                  d.pptope, 
                  d.ppfpag, 
                  d.pptipo, 
                  d.ppexte, 
                  d.ppimp1, 
                  d.ppimp2, 
                  d.ppimp3, 
                  d.ppimp4, 
                  d.ppimp5, 
                  d.ppimp6, 
                  d.ppimp7, 
                  d.ppimp8, 
                  d.ppimp9, 
                  d.ppimp10,
                  d.ppimp11,
                  d.ppimp12,
                  d.ppimp13,
                  d.ppimp14,
                  d.ppimp15,
                  d.ppimp16,
                  d.ppimp17,
                  d.ppimp18,
                  d.ppimp19,
                  d.ppimp20
              );     
              commit; 
          End;        
       End loop;
       commit;
       ln_CtaTm := ln_cta; 
    End loop;  
    
    begin
        pq_op_desafiliacion.sp_Mover_Seguros;
    end;      
 End sp_Backup_Tabla; 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Mover_Seguros is
  
  	Cursor Move1 is 
      select distinct p.jaqy779cta,  
                      p.jaqy779oper, 
                      p.jaqy779fchpag,
                      p.jaqy779descp
       from jaqy779 p, fsd611 q  --fsd611_1 <=> fsd611
      where q.pgcod  = p.jaqy779cod
        and q.ppmod  = p.jaqy779mod 
        and q.ppsuc  = p.jaqy779suc 
        and q.ppmda  = p.jaqy779mda 
        and q.pppap  = p.jaqy779pap 
        and q.ppcta  = p.jaqy779cta 
        and q.ppoper = p.jaqy779oper
        and q.ppsbop = p.jaqy779sbop
        and q.pptope = p.jaqy779tope;
     
BEGIN     
    For x in Move1 loop 
       If  x.jaqy779descp = 'ConCalen' then            
           Update fsd611 /*fsd611_1*/ t
              set t.ppimp11 = t.ppimp12,
                  t.ppimp12 = t.ppimp13,
                  t.ppimp13 = t.ppimp14,
                  t.ppimp14 = t.ppimp15,
                  t.ppimp15 = 0.00
            where t.ppcta   = x.jaqy779cta
              and t.ppoper  = x.jaqy779oper
              and t.ppfpag  > x.jaqy779fchpag;
          commit;  
       Else
           Update fsd611 /*fsd611_1*/ t
            set t.ppimp11 = t.ppimp12,
                t.ppimp12 = t.ppimp13,
                t.ppimp13 = t.ppimp14,
                t.ppimp14 = t.ppimp15,
                t.ppimp15 = 0.00
          where t.ppcta   = x.jaqy779cta
            and t.ppoper  = x.jaqy779oper; 
          commit;  
       End If;  
       --commit;        
    End loop;  
    
    Begin
        pq_op_desafiliacion.sp_Comparar_Seguros;
    End; 
 End sp_Mover_Seguros;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Comparar_Seguros is
 
 cursor cur_temp1 is
     select p.jaqy780cod,  
            p.jaqy780mod,  
            p.jaqy780suc,  
            p.jaqy780mda,  
            p.jaqy780pap,  
            p.jaqy780cta,  
            p.jaqy780oper, 
            p.jaqy780sbop, 
            p.jaqy780tope,
            p.jaqy780fpag,
            p.jaqy780imp12
       from jaqy780 p
   order by p.jaqy780cta, p.jaqy780fpag;
       
  cursor cur_temp2 (ln_cod number, ln_mod number, ln_suc number, ln_mda number, ln_pap number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number, ld_pfpag date)is
     select p.*
       from fsd611 /*fsd611_1 */p
       where p.pgcod   = ln_cod 
         and p.ppmod   = ln_mod  
         and p.ppsuc   = ln_suc 
         and p.ppmda   = ln_mda 
         and p.pppap   = ln_pap 
         and p.ppcta   = ln_cta 
         and p.ppoper  = ln_oper
         and p.ppsbop  = ln_sbop
         and p.pptope  = ln_tope
         and p.ppfpag  = ld_pfpag
    order by p.ppcta, p.ppfpag;
         
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
  ln_imp12 number(17,2); 
  ln_SegT  number(9);
    
 Begin

   For k in cur_temp1 loop 
   
       ln_cod   := k.jaqy780cod;
       ln_mod   := k.jaqy780mod;
       ln_suc   := k.jaqy780suc;
       ln_mda   := k.jaqy780mda; 
       ln_pap   := k.jaqy780pap;
       ln_cta   := k.jaqy780cta;
       ln_oper  := k.jaqy780oper;
       ln_sbop  := k.jaqy780sbop;
       ln_tope  := k.jaqy780tope;
       ld_pfpag := k.jaqy780fpag;
       ln_imp12 := k.jaqy780imp12;
       
       For l in cur_temp2 (ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop, ln_tope, ld_pfpag) loop 
           Begin 
             If l.ppimp11 <> 0 then
                 If l.ppimp11 <> ln_imp12 then
                    Insert into jaqy781 -->>>> Comparar_Seguros
                    (
                      jaqy781cod,
                      jaqy781mod,
                      jaqy781suc,
                      jaqy781mda,
                      jaqy781pap,
                      jaqy781cta,
                      jaqy781oper,
                      jaqy781sbop,
                      jaqy781tope, 
                      jaqy781fpag,
                      jaqy781tipo,
                      jaqy781exte, 
                      jaqy781imp1, 
                      jaqy781imp2, 
                      jaqy781imp3, 
                      jaqy781imp4, 
                      jaqy781imp5, 
                      jaqy781imp6, 
                      jaqy781imp7, 
                      jaqy781imp8, 
                      jaqy781imp9, 
                      jaqy781imp10,
                      jaqy781imp11,
                      jaqy781imp12,
                      jaqy781imp13,
                      jaqy781imp14,
                      jaqy781imp15,
                      jaqy781imp16,
                      jaqy781imp17,
                      jaqy781imp18,
                      jaqy781imp19,
                      jaqy781imp20 
                    )
                    values
                    ( 
                      l.pgcod, 
                      l.ppmod, 
                      l.ppsuc, 
                      l.ppmda, 
                      l.pppap, 
                      l.ppcta, 
                      l.ppoper,
                      l.ppsbop,
                      l.pptope,
                      l.ppfpag,
                      l.pptipo,
                      l.ppexte,
                      l.ppimp1,
                      l.ppimp2,
                      l.ppimp3,
                      l.ppimp4,
                      l.ppimp5,
                      l.ppimp6,
                      l.ppimp7,
                      l.ppimp8,
                      l.ppimp9,
                      l.ppimp10,
                      l.ppimp11, 
                      l.ppimp12,
                      l.ppimp13,
                      l.ppimp14,
                      l.ppimp15,
                      l.ppimp16,
                      l.ppimp17,
                      l.ppimp18,
                      l.ppimp19,
                      l.ppimp20   
                    );
                    commit;
                 End If;
             Else
                 If l.ppimp12 <> ln_imp12 then
                    Insert into jaqy781
                    (
                      jaqy781cod,
                      jaqy781mod,
                      jaqy781suc,
                      jaqy781mda,
                      jaqy781pap,
                      jaqy781cta,
                      jaqy781oper,
                      jaqy781sbop,
                      jaqy781tope, 
                      jaqy781fpag,
                      jaqy781tipo,
                      jaqy781exte, 
                      jaqy781imp1, 
                      jaqy781imp2, 
                      jaqy781imp3, 
                      jaqy781imp4, 
                      jaqy781imp5, 
                      jaqy781imp6, 
                      jaqy781imp7, 
                      jaqy781imp8, 
                      jaqy781imp9, 
                      jaqy781imp10,
                      jaqy781imp11,
                      jaqy781imp12,
                      jaqy781imp13,
                      jaqy781imp14,
                      jaqy781imp15,
                      jaqy781imp16,
                      jaqy781imp17,
                      jaqy781imp18,
                      jaqy781imp19,
                      jaqy781imp20 
                    )
                    values
                    ( 
                      l.pgcod, 
                      l.ppmod, 
                      l.ppsuc, 
                      l.ppmda, 
                      l.pppap, 
                      l.ppcta, 
                      l.ppoper,
                      l.ppsbop,
                      l.pptope,
                      l.ppfpag,
                      l.pptipo,
                      l.ppexte,
                      l.ppimp1,
                      l.ppimp2,
                      l.ppimp3,
                      l.ppimp4,
                      l.ppimp5,
                      l.ppimp6,
                      l.ppimp7,
                      l.ppimp8,
                      l.ppimp9,
                      l.ppimp10,
                      l.ppimp11, 
                      l.ppimp12,
                      l.ppimp13,
                      l.ppimp14,
                      l.ppimp15,
                      l.ppimp16,
                      l.ppimp17,
                      l.ppimp18,
                      l.ppimp19,
                      l.ppimp20
                    );
                    commit; 
                 End If;
             End If;
             commit; 
           End;
       End loop;
   End loop;
   
  Begin
    select count(*)
      into ln_SegT 
      from jaqy781;
     
    If ln_SegT <> 0 then   
        pq_op_desafiliacion.sp_Revertir_Data;
    End If;
  End;
 End sp_Comparar_Seguros;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 Procedure sp_Revertir_Data is
 
   cursor cur_rev1 is
     select distinct c.jaqy781cod,
                     c.jaqy781mod,
                     c.jaqy781suc,
                     c.jaqy781mda,
                     c.jaqy781pap,
                     c.jaqy781cta,
                     c.jaqy781oper,
                     c.jaqy781sbop,
                     c.jaqy781tope
       from jaqy781 c;
     
   cursor cur_rev2 (ln_cod number, ln_mod number, ln_suc number, ln_mda number, ln_pap number, ln_cta number, ln_oper number, ln_sbop number, ln_tope number, ld_pfpag date, ln_imp11 number, ln_imp12 number, ln_ppimp13 number, ln_ppimp14 number, ln_ppimp15 number)is
      select p.*
        from fsd611 /*fsd611_1*/ p
       where p.pgcod   = ln_cod 
         and p.ppmod   = ln_mod  
         and p.ppsuc   = ln_suc 
         and p.ppmda   = ln_mda 
         and p.pppap   = ln_pap 
         and p.ppcta   = ln_cta 
         and p.ppoper  = ln_oper
         and p.ppsbop  = ln_sbop
         and p.pptope  = ln_tope
         order by p.ppcta, p.ppfpag; 
  
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
  ln_imp11 number(17,2);
  ln_imp12 number(17,2);
  
  ln_codi    number(3);
  ln_modu    number(4);
  ln_sucu    number(3);
  ln_mnda    number(3);
  ln_papel   number(3);
  ln_cuenta  number(9);
  ln_operac  number(9);
  ln_sboper  number(3);
  ln_topera  number(3);
  ld_fecha   date;
  ln_ppimp11 number(17,2);
  ln_ppimp12 number(17,2);
  ln_ppimp13 number(17,2);
  ln_ppimp14 number(17,2);
  ln_ppimp15 number(17,2);
         
  BEGIN   
  
    For xx in cur_rev1 loop 
       ln_cod   := xx.jaqy781cod;
       ln_mod   := xx.jaqy781mod;
       ln_suc   := xx.jaqy781suc;
       ln_mda   := xx.jaqy781mda; 
       ln_pap   := xx.jaqy781pap;
       ln_cta   := xx.jaqy781cta;
       ln_oper  := xx.jaqy781oper;
       ln_sbop  := xx.jaqy781sbop;
       ln_tope  := xx.jaqy781tope;
      -- ld_pfpag := xx.ppfpag;
     --  ln_imp11 := xx.ppimp11;
        
       For yy in cur_rev2 (ln_cod, ln_mod, ln_suc, ln_mda, ln_pap, ln_cta, ln_oper, ln_sbop, ln_tope, ld_pfpag, ln_imp11, ln_imp12, ln_ppimp13, ln_ppimp14, ln_ppimp15) loop 
          select b.jaqy780cod,
                 b.jaqy780mod,
                 b.jaqy780suc,
                 b.jaqy780mda,
                 b.jaqy780pap,
                 b.jaqy780cta,
                 b.jaqy780oper,
                 b.jaqy780sbop,
                 b.jaqy780tope,
                 b.jaqy780fpag,
                 b.jaqy780imp11,
                 b.jaqy780imp12,
                 b.jaqy780imp13,
                 b.jaqy780imp14,
                 b.jaqy780imp15
            into ln_codi,  
                 ln_modu,  
                 ln_sucu,  
                 ln_mnda,  
                 ln_papel, 
                 ln_cuenta,
                 ln_operac,
                 ln_sboper,
                 ln_topera,
                 ld_fecha,
                 ln_ppimp11,
                 ln_ppimp12,
                 ln_ppimp13,
                 ln_ppimp14,
                 ln_ppimp15
            from jaqy780 b
           where b.jaqy780cod   = yy.pgcod 
             and b.jaqy780mod   = yy.ppmod 
             and b.jaqy780suc   = yy.ppsuc 
             and b.jaqy780mda   = yy.ppmda 
             and b.jaqy780pap   = yy.pppap 
             and b.jaqy780cta   = yy.ppcta 
             and b.jaqy780oper  = yy.ppoper 
             and b.jaqy780sbop  = yy.ppsbop 
             and b.jaqy780tope  = yy.pptope 
             and b.jaqy780fpag  = yy.ppfpag;	
       
         If yy.ppfpag = ld_fecha then
            Update fsd611 /*fsd611_1*/ t
              set t.ppimp11 = ln_ppimp11,
                  t.ppimp12 = ln_ppimp12,
                  t.ppimp13 = ln_ppimp13,
                  t.ppimp14 = ln_ppimp14,
                  t.ppimp15 = ln_ppimp15
            where t.pgcod   = ln_codi 
              and t.ppmod   = ln_modu 
              and t.ppsuc   = ln_sucu 
              and t.ppmda   = ln_mnda 
              and t.pppap   = ln_papel
              and t.ppcta   = ln_cuenta
              and t.ppoper  = ln_operac
              and t.ppsbop  = ln_sboper
              and t.pptope  = ln_topera
              and t.ppfpag  = ld_fecha; 
            commit;   
         End If;        
       End loop;
   End loop;
 End sp_Revertir_Data;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_OP_DESAFILIACION;
/

