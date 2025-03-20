create or replace package PQ_CR_DESF_REVERTIR_REPROGM is

  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION REPROGRAMADOS
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
  Procedure sp_cr_cargaRepg_job;
  
  Procedure sp_Identificacion_Crd(lc_digito in varchar2);

  Procedure sp_Revertir_fsd611_M(ln_cod1  in number,
                                 ln_mod1  in number,
                                 ln_suc1  in number,
                                 ln_mda1  in number,
                                 ln_pap1  in number,
                                 ln_cta1  in number,
                                 ln_oper1 in number,
                                 ln_sbop1 in number,
                                 ln_tope1 in number,
                                 ld_fech1 in date/*,
                                 ld_antfch1 in date*/);
                              
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
end PQ_CR_DESF_REVERTIR_REPROGM;
/

create or replace package body PQ_CR_DESF_REVERTIR_REPROGM is
  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION REPROGRAMADOS
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
  Procedure sp_cr_cargaRepg_job is

    lc_variable varchar2(1000);  
    ln_job number := 0;
    lc_hostname varchar2(64);
  
  begin

  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
    for x in 0..9 loop

       lc_variable := ' begin ' || ' pq_cr_desf_revertir_reprogm.sp_identificacion_crd(''' ||
                       x || ''');' ||
                       ' End; ';
        ln_job := ln_job + 1;
      
    if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2, 
                        force => false);
     else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force => false);
       end if;
        commit;
      
      end loop;
  
  end sp_cr_cargaRepg_job;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Identificacion_Crd(lc_digito in varchar2) is
  
    Cursor CImp1 is
    --->>>>>>JAQY768 - Tabla temporal         
      select distinct a.jaqy768cod,
                      a.jaqy768mod, 
                      a.jaqy768suc, 
                      a.jaqy768mda, 
                      a.jaqy768pap, 
                      a.jaqy768cta, 
                      a.jaqy768oper,
                      a.jaqy768sbop,
                      a.jaqy768tope
        from JAQY768 a, FSD010 b
       where a.jaqy768cod = b.pgcod
         and a.jaqy768mod = b.aomod
         and a.jaqy768suc = b.aosuc
         and a.jaqy768mda = b.aomda
         and a.jaqy768pap = b.aopap
         and a.jaqy768cta = b.aocta
         and a.jaqy768oper = b.aooper
         and a.jaqy768sbop = b.aosbop
         and a.jaqy768tope = b.aotope
         and a.jaqy768indp001 = 'R'
         and (b.aomod in (select modulo from fst111 where dscod = 50))
         --and b.aostat <> 99
         and to_char(substr(trim(a.jaqy768cta), -1, 1)) = lc_digito;
  
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
    lc_Stat    varchar2(1);
    lc_FlgF    varchar2(8);
    ld_fmax    date;
    /*lc_data    char(1);
    lc_repro   char(1);
    lc_revC    char(1);
    lc_revS    char(1);*/
    ld_antfch  date;
    lc_tipo    char(1);
    ld_fmax6   date;
    ld_f611    date;
    ln_nump    number(9);
    ln_dt611   number(9);
    --lc_flgch   char(5);
    --ln_TrNo    number(9);
  
  Begin
  
    For a in CImp1 loop
    
      ln_cod   := a.jaqy768cod;
      ln_suc   := a.jaqy768suc;
      ln_mod   := a.jaqy768mod;
      ln_mda   := a.jaqy768mda;
      ln_pap   := a.jaqy768pap;
      ln_cta   := a.jaqy768cta;
      ln_oper  := a.jaqy768oper;
      ln_sbop  := a.jaqy768sbop;
      ln_tope  := a.jaqy768tope;
      /*lc_data  := 'N';
      lc_repro := 'N';
      lc_revC  := 'N';
      lc_revS  := 'N';*/
     -- ln_TrNo  := 0;
      lc_tipo   := '-';
      ln_dt611  := 0;
    
      Begin
        select Pgfape into ld_FchSist from fst017 Where Pgcod = 1;
      Exception
        when no_data_found then
          null;
      End;
    
      select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
    
      Begin
        Begin
          select max(x.ppfpag)
            into ld_fmax6
            from fsd602 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope
             and x.D602Co = 'S';
        Exception
          when no_data_found then
            ld_fmax6 := null;
        End;
        lc_FlgF := 'ConCalen';
      End;
      
      Begin
        select max(x.pp1nump)
          into ln_nump
          from fsd602 x
         where x.pgcod = ln_cod
           and x.ppmod = ln_mod
           and x.ppsuc = ln_suc
           and x.ppmda = ln_mda
           and x.pppap = ln_pap
           and x.ppcta = ln_cta
           and x.ppoper = ln_oper
           and x.ppsbop = ln_sbop
           and x.pptope = ln_tope
           and x.ppfpag = ld_fmax6
           and x.D602Co = 'S';
      Exception
          when no_data_found then
            ln_nump := 0;
      End;
    
      
      If  ld_fmax6 is null then
        Begin
         select min(x.ppfpag)
            into ld_fmax6
            from fsd601 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope;
        Exception
          when others then ld_fmax6:= null;
        End;
        
        lc_FlgF := 'SinCalen';
      End If;
      
      If  ld_fmax6 is null then  --- fsd601 tipo
        Begin
            select x.pptipo
              into lc_tipo
              from fsd601 x
             where x.pgcod = ln_cod
               and x.ppmod = ln_mod
               and x.ppsuc = ln_suc
               and x.ppmda = ln_mda
               and x.pppap = ln_pap
               and x.ppcta = ln_cta
               and x.ppoper = ln_oper
               and x.ppsbop = ln_sbop
               and x.pptope = ln_tope
               and x.ppfpag = ld_fmax6 --ld_fmax
               and x.D601Co = 'S';
        Exception
            when no_data_found then
              lc_tipo := '-';
        End;
      End If;
        
      If ld_fmax6 is not null then --- fsd602 tipo
        Begin
          select x.pptipo
            into lc_tipo
            from fsd602 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope
             and x.ppfpag = ld_fmax6 --ld_fmax
             and x.pp1nump = ln_nump
             and x.D602Co = 'S';
        Exception
          when no_data_found then
            lc_tipo := '-';
        End;
      End If;
      
      If ld_fmax6 is not null then --- estado fsd602
        Begin
          select max(x.pp1stat)
            into lc_Stat
            from fsd602 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope
             and x.ppfpag = ld_fmax6 --ld_fmax
             and x.D602Co = 'S';
        Exception
          when no_data_found then
            lc_Stat := '-';
        End;
      Else
        lc_Stat := '-';
      End If;
      
      If lc_FlgF = 'SinCalen' then
         lc_Stat := '-';
      End If;
    
      Begin
        select min(x.ppfpag) --minima cuota de la fsd611 estado F
          into ld_f611
          from fsd611 x
         where x.pgcod = ln_cod
           and x.ppmod = ln_mod
           and x.ppsuc = ln_suc
           and x.ppmda = ln_mda
           and x.pppap = ln_pap
           and x.ppcta = ln_cta
           and x.ppoper = ln_oper
           and x.ppsbop = ln_sbop
           and x.pptope = ln_tope
           and x.pptipo= 'F';
      Exception
        when no_data_found then
          ld_f611 := null;
      End;
      
      If ld_fmax6 = ld_f611 then
         ld_fmax  := ld_fmax6;
      End If;
      
      If ld_fmax6 > ld_f611 then
         ld_fmax  := ld_fmax6;
      End If;
      
      If ld_fmax6 < ld_f611 then
         ld_fmax  := ld_f611;
      End If;
      
      Begin
         select max(x.ppfpag)
            into ld_antfch
            from fsd601 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope
             and x.ppfpag < ld_fmax;
      Exception
          when others then ld_antfch:= null;
      End;
      
      Begin
          select count(*)
            into ln_dt611
            from fsd611 x
           where x.pgcod = ln_cod
             and x.ppmod = ln_mod
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = ln_cta
             and x.ppoper = ln_oper
             and x.ppsbop = ln_sbop
             and x.pptope = ln_tope;
      Exception
          when others then ln_dt611:= 0;
      End; 
        
      If ln_dt611 > 0 then
        If lc_Stat = 'T' or lc_Stat = 'P' or lc_Stat = '-' then --Los estados de la maxima cuota debe ser T
            BEGIN
                PQ_CR_DESF_REVERTIR_REPROGM.sp_Revertir_fsd611_M(ln_cod,
                                                                 ln_mod,
                                                                 ln_suc,
                                                                 ln_mda,
                                                                 ln_pap,
                                                                 ln_cta,
                                                                 ln_oper,
                                                                 ln_sbop,
                                                                 ln_tope,
                                                                 ld_fmax/*,
                                                                 ld_antfch*/);--fsd611
                          
                Update jaqy768 t
                   set t.jaqy768newdescp  = lc_FlgF,
                       t.jaqy768newest    = lc_Stat,
                       t.jaqy768newfchpag = ld_fmax,
                       t.jaqy768indf601   = 'S',
                       t.jaqy768oldfchpag = ld_fmax6, --ld_antfch, fecha maxima cuota de la fsd602
                       t.jaqy768oldest    = lc_tipo, --tipo de la maxima cuota de la fsd602
                       t.jaqy768olddescp  = 'Reprg'
                 where t.jaqy768cta = ln_cta
                   and t.jaqy768oper = ln_oper;
                commit;
                      
                BEGIN
                           
                  PQ_CR_DESF_REVERTIR_REPROGM.sp_Revertir_fpp001(ln_cod,
                                                                 ln_mod,
                                                                 ln_suc,
                                                                 ln_mda,
                                                                 ln_pap,
                                                                 ln_cta,
                                                                 ln_oper,
                                                                 ln_sbop,
                                                                 ln_tope);--fpp001
                    Update jaqy768 t
                       set t.jaqy768indp001 = 'S',
                           t.jaqy768fchasis = ld_FchSist, 
                           t.jaqy768hrasis  = lc_hora
                     where t.jaqy768cta  = ln_cta
                       and t.jaqy768oper = ln_oper;
                    commit;
               EXCEPTION WHEN OTHERS THEN
                  Update jaqy768 t
                       set t.jaqy768indp001 = '1',
                           t.jaqy768fchasis = ld_FchSist, 
                           t.jaqy768hrasis  = lc_hora
                     where t.jaqy768cta  = ln_cta
                       and t.jaqy768oper = ln_oper;
                    commit;
               END;
                      
          EXCEPTION WHEN OTHERS THEN
               Update jaqy768 t
                   set t.jaqy768indf601 = '1'
                 where t.jaqy768cta  = ln_cta
                   and t.jaqy768oper = ln_oper;
               commit;
          END;   
       End If;
       Else
          If ln_dt611 = 0 then  --jaqz519  ya existe
            Update jaqy768 t
               set t.jaqy768oldest = 'X' -- No tiene fsd611
             where t.jaqy768cta = ln_cta
               and t.jaqy768oper = ln_oper;
            commit;
          End If;
      End If;
    End loop;
  End sp_Identificacion_Crd;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Revertir_fsd611_M(ln_cod1  in number,
                                 ln_mod1  in number,
                                 ln_suc1  in number,
                                 ln_mda1  in number,
                                 ln_pap1  in number,
                                 ln_cta1  in number,
                                 ln_oper1 in number,
                                 ln_sbop1 in number,
                                 ln_tope1 in number,
                                 ld_fech1 in date/*,
                                 ld_antfch1 in date*/) is
  
    cursor cur_rev1 is
      select p.pgcod, 
             p.ppmod, 
             p.ppsuc, 
             p.ppmda,
             p.pppap, 
             p.ppcta, 
             p.ppoper,
             p.ppsbop,
             p.pptope,
             p.ppfpag,
             p.ppimp11,
             p.ppimp12,
             p.ppimp13,
             p.ppimp14,
             p.ppimp15
        from fsd611 p
       where p.pgcod = ln_cod1
         and p.ppmod = ln_mod1
         and p.ppsuc = ln_suc1
         and p.ppmda = ln_mda1
         and p.pppap = ln_pap1
         and p.ppcta = ln_cta1
         and p.ppoper = ln_oper1
         and p.ppsbop = ln_sbop1
         and p.pptope = ln_tope1
         and p.ppfpag >= ld_fech1
       order by p.ppfpag;
  
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
    ln_seg     number(5);
    ln_sgimp11 number(17, 2);
    ln_sgimp12 number(17, 2);
    ld_sgfpag  date;
  
  BEGIN
  
    For xx in cur_rev1 loop
      
      ln_cod     := xx.pgcod;
      ln_mod     := xx.ppmod;
      ln_suc     := xx.ppsuc;
      ln_mda     := xx.ppmda;
      ln_pap     := xx.pppap;
      ln_cta     := xx.ppcta;
      ln_oper    := xx.ppoper;
      ln_sbop    := xx.ppsbop;
      ln_tope    := xx.pptope;
      ld_pfpag   := xx.ppfpag;
      ln_seg     := 0;
     /* ln_ppimp11 := 0;
      ln_ppimp12 := 0;
      ln_ppimp13 := 0;
      ln_ppimp14 := 0;
      ln_ppimp15 := 0;*/
      
      Begin
        select count(*)
          into ln_seg
          from jaqy786 p 
         where p.jaqy786pgcod = ln_cod1
           and p.jaqy786mod = ln_mod1
           and p.jaqy786suc = ln_suc1
           and p.jaqy786mda = ln_mda1
           and p.jaqy786pap = ln_pap1
           and p.jaqy786cta = ln_cta1
           and p.jaqy786oper = ln_oper1
           and p.jaqy786sbop = ln_sbop1
           and p.jaqy786tope = ln_tope1
           and p.jaqy786sgcod in (116, 117, 118, 120, 121, 122,200,201,202);
     Exception
          when no_data_found then
            ln_seg := 0;        
     End;
     
     Begin
        select max(x.ppfpag)
          into ld_sgfpag
          from fsd611 x
         where x.pgcod = ln_cod1
           and x.ppmod = ln_mod1
           and x.ppsuc = ln_suc1
           and x.ppmda = ln_mda1
           and x.pppap = ln_pap1
           and x.ppcta = ln_cta1
           and x.ppoper = ln_oper1
           and x.ppsbop = ln_sbop1
           and x.pptope = ln_tope1
           and x.ppfpag < ld_fech1;
      Exception
          when others then ld_sgfpag:= null;
      End;
      
      Begin
         select x.ppimp11, x.ppimp12
           into ln_sgimp11, ln_sgimp12
           from fsd611 x
          where x.pgcod = ln_cod1
            and x.ppmod = ln_mod1
            and x.ppsuc = ln_suc1
            and x.ppmda = ln_mda1
            and x.pppap = ln_pap1
            and x.ppcta = ln_cta1
            and x.ppoper = ln_oper1
            and x.ppsbop = ln_sbop1
            and x.pptope = ln_tope1
            and x.ppfpag = ld_sgfpag; --ld_antfch1;
       Exception
            when others then null;
       End;
                  
      /*case when ln_seg = 1 then
           
           ln_ppimp11 := ln_sgimp11;
           ln_ppimp12 := xx.ppimp11;
           ln_ppimp13 := xx.ppimp12;
           ln_ppimp14 := xx.ppimp13;
           ln_ppimp15 := xx.ppimp14;
           
      when ln_seg = 2 then
      
           ln_ppimp11 := ln_sgimp11;
           ln_ppimp12 := ln_sgimp12;
           ln_ppimp13 := xx.ppimp11;
           ln_ppimp14 := xx.ppimp12;
           ln_ppimp15 := xx.ppimp13;

      End Case;*/
      
      If ln_seg = 1 then
           
           ln_ppimp11 := ln_sgimp11;
           ln_ppimp12 := xx.ppimp11;
           ln_ppimp13 := xx.ppimp12;
           ln_ppimp14 := xx.ppimp13;
           ln_ppimp15 := xx.ppimp14;
      End If;
           
      If ln_seg = 2 then
      
           ln_ppimp11 := ln_sgimp11;
           ln_ppimp12 := ln_sgimp12;
           ln_ppimp13 := xx.ppimp11;
           ln_ppimp14 := xx.ppimp12;
           ln_ppimp15 := xx.ppimp13;
      End If;
      
      If ln_seg > 0 then
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
      End If;
    End loop;
       
  End sp_Revertir_fsd611_M;
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
        from jaqy786 p 
       where p.jaqy786pgcod = ln_cod1
         and p.jaqy786mod = ln_mod1
         and p.jaqy786suc = ln_suc1
         and p.jaqy786mda = ln_mda1
         and p.jaqy786pap = ln_pap1
         and p.jaqy786cta = ln_cta1
         and p.jaqy786oper = ln_oper1
         and p.jaqy786sbop = ln_sbop1
         and p.jaqy786tope = ln_tope1
         and p.jaqy786sgcod in (116, 117, 118, 120, 121, 122,200,201,202); ---01042017
  
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
          (y.jaqy786pgcod,
           y.jaqy786mod,
           y.jaqy786suc,
           y.jaqy786mda,
           y.jaqy786pap,
           y.jaqy786cta,
           y.jaqy786oper,
           y.jaqy786sbop,
           y.jaqy786tope,
           y.jaqy786sgcod,
           y.jaqy786vc,
           y.jaqy786imp,
           y.jaqy786porc,
           y.jaqy786plus,
           y.jaqy786part,
           y.jaqy786veh,
           y.jaqy786inm,
           y.jaqy786end,
           y.jaqy786stat,
           y.jaqy786co,
           y.jaqy786aux1,
           y.jaqy786aux2,
           y.jaqy786aux3,
           y.jaqy786aux4,
           y.jaqy786aux5,
           y.jaqy786aux6,
           y.jaqy786aux7);
        commit;
      end;
    End loop;
  End sp_Revertir_fpp001;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
End PQ_CR_DESF_REVERTIR_REPROGM;
/

