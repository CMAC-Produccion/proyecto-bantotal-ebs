create or replace package PQ_CR_DESF_REVERTIR_PP70 is

  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION PERMANENCIA
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
  Procedure sp_cr_cargaPP70_job;
  
  Procedure sp_Identificacion_Crd(lc_digito in number);

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
end PQ_CR_DESF_REVERTIR_PP70;
/

create or replace package body PQ_CR_DESF_REVERTIR_PP70 is
  -- *****************************************************************
  -- Nombre                     : REVERTIR DESAFILIACION PERMANENCIA
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
  Procedure sp_cr_cargaPP70_job is

    lc_variable varchar2(1000);  
    ln_job number := 0;
    lc_hostname varchar2(64);
  
  
    cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 ;

  
  begin

  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
    for i in sucursal loop    


       lc_variable := ' begin ' || ' pq_cr_desf_revertir_pp70.sp_identificacion_crd(''' ||
                       i.sucurs || ''');' ||
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
  
  end sp_cr_cargaPP70_job;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Identificacion_Crd(lc_digito in number) is
  
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
         and (b.aomod in (select modulo from fst111 where dscod = 50))
         and b.aostat <> 99
         and a.jaqy768suc = lc_digito;
  
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
    lc_data    char(1);
    lc_repro   char(1);
    lc_revC    char(1);
    lc_revS    char(1);
    ld_antfch  date;
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
      lc_data  := 'N';
      lc_repro := 'N';
      lc_revC  := 'N';
      lc_revS  := 'N';
     -- ln_TrNo  := 0;
    
      Begin
        select Pgfape into ld_FchSist from fst017 Where Pgcod = 1;
      Exception
        when no_data_found then
          null;
      End;
    
      select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
    
      -----------01042017
      Begin
        select 'S'
          into lc_revC
          from jaqy768 j
         where j.jaqy768cod = ln_cod
           and j.jaqy768mod = ln_mod
           and j.jaqy768suc = ln_suc
           and j.jaqy768mda = ln_mda
           and j.jaqy768pap = ln_pap
           and j.jaqy768cta = ln_cta
           and j.jaqy768oper = ln_oper
           and j.jaqy768sbop = ln_sbop
           and j.jaqy768tope = ln_tope
           and j.jaqy768newest = 'T'
           and rownum = 1;
      Exception
        when no_data_found then
          lc_revC := 'N';
      end;

      Begin
        select 'S'
          into lc_revS
          from jaqy768 j
         where j.jaqy768cod = ln_cod
           and j.jaqy768mod = ln_mod
           and j.jaqy768suc = ln_suc
           and j.jaqy768mda = ln_mda
           and j.jaqy768pap = ln_pap
           and j.jaqy768cta = ln_cta
           and j.jaqy768oper = ln_oper
           and j.jaqy768sbop = ln_sbop
           and j.jaqy768tope = ln_tope
           and j.jaqy768newest = '-'
           and rownum = 1;
      Exception
        when no_data_found then
          lc_revS := 'N';
      end;
      -----------01042017
      Begin
        select 'S'
          into lc_data
          from jaqy784 j
         where j.jaqy784cod = ln_cod
           and j.jaqy784mod = ln_mod
           and j.jaqy784suc = ln_suc
           and j.jaqy784mda = ln_mda
           and j.jaqy784pap = ln_pap
           and j.jaqy784cta = ln_cta
           and j.jaqy784oper = ln_oper
           and j.jaqy784sbop = ln_sbop
           and j.jaqy784tope = ln_tope
           and rownum = 1;
      Exception
        when no_data_found then
          lc_data := 'N';
      end;
    
      Begin
        select 'S'
          into lc_repro
          from jaqz519 a
         where a.jaqz519emp = ln_cod
           and a.jaqz519mod = ln_mod
           and a.jaqz519suc = ln_suc
           and a.jaqz519mda = ln_mda
           and a.jaqz519pap = ln_pap
           and a.jaqz519cta = ln_cta
           and a.jaqz519ope = ln_oper
           and a.jaqz519sbo = ln_sbop
           and a.jaqz519top = ln_tope
           and a.jaqz519ind = 'S'
           and rownum = 1;
      Exception
        when no_data_found then
          lc_repro := 'N';
      end;
    
      Begin
        Begin
          select max(x.ppfpag)
            into ld_fmax
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
            ld_fmax := null;
        End;
        lc_FlgF := 'ConCalen';
        
        /*30	350	Refinanciaciones "1 a 1"      
         30  351 Refinanciaciones "n a 1"       
         30  360 Ampliación de Créditos          
         300 390 Asignación Abogado - Comisione */--01042017
         
        -----------01042017 
        /*Begin
            select count(*)
              into ln_TrNo
              from fsd602 k
             where k.pgcod = ln_cod
               and k.ppmod = ln_mod
               and k.ppsuc = ln_suc
               and k.ppmda = ln_mda
               and k.pppap = ln_pap
               and k.ppcta = ln_cta
               and k.ppoper = ln_oper
               and k.ppsbop = ln_sbop
               and k.pptope = ln_tope
               and k.ppfpag = ld_fmax
               and ((k.d602mo = 30 and k.d602tr = 350) or
                   (k.d602mo = 30 and k.d602tr = 351) or
                   (k.d602mo = 30 and k.d602tr = 360) or
                   (k.d602mo = 300 and k.d602tr = 390)
                   );
        Exception
          when no_data_found then
            ln_TrNo := 0;
        End; */
        -----------01042017
      End;
    
      If ld_fmax is null then
        Begin
         select min(x.ppfpag)
            into ld_fmax
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
          when others then ld_fmax:= null;
        End;
        
        lc_FlgF := 'SinCalen';
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

             
      If ld_fmax is not null then
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
             and x.ppfpag = ld_fmax
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
    
      If lc_revC = 'N' then --Para los casos que sean T y el flag sea S no entra
        If lc_repro = 'N' then -- Para los casos de reporgramados si el flag sea S no entra
          If lc_data = 'N' then --Para los casos de jaqy784 si el flag sea S no entra
            --If ln_TrNo = 0 then --No reprogramados, refinaciados ni asignacion de abogado
              If lc_Stat = 'T' or lc_Stat = 'P' then --Los estados de la maxima cuota debe ser T
                  BEGIN
                      PQ_CR_DESF_REVERTIR_PP70.sp_Revertir_Data1(ln_cod,
                                                                 ln_mod,
                                                                 ln_suc,
                                                                 ln_mda,
                                                                 ln_pap,
                                                                 ln_cta,
                                                                 ln_oper,
                                                                 ln_sbop,
                                                                 ln_tope,
                                                                 ld_fmax);--fsd611
                    
                      Update jaqy768 t
                         set t.jaqy768newdescp  = lc_FlgF,
                             t.jaqy768newest    = lc_Stat,
                             t.jaqy768newfchpag = ld_fmax,
                             t.jaqy768indf601   = 'S',
                             t.jaqy768oldfchpag = ld_antfch
                       where t.jaqy768cta = ln_cta
                         and t.jaqy768oper = ln_oper;
                      commit;
                
                      BEGIN
                     
                        PQ_CR_DESF_REVERTIR_PP70.sp_Revertir_fpp001(ln_cod,
                                                                    ln_mod,
                                                                    ln_suc,
                                                                    ln_mda,
                                                                    ln_pap,
                                                                    ln_cta,
                                                                    ln_oper,
                                                                    ln_sbop,
                                                                    ln_tope);--fpp001
                          Update jaqy768 t
                             set t.jaqy768indp001   = 'S',
                                 t.jaqy768fchasis = ld_FchSist, 
                                 t.jaqy768hrasis = lc_hora
                           where t.jaqy768cta = ln_cta
                             and t.jaqy768oper = ln_oper;
                          commit;
                     EXCEPTION WHEN OTHERS THEN
                        Update jaqy768 t
                             set t.jaqy768indp001   = '1',
                                 t.jaqy768fchasis = ld_FchSist, 
                                 t.jaqy768hrasis = lc_hora
                           where t.jaqy768cta = ln_cta
                             and t.jaqy768oper = ln_oper;
                          commit;
                     END;
                
                EXCEPTION WHEN OTHERS THEN
                     Update jaqy768 t
                         set t.jaqy768indf601   = '1'
                       where t.jaqy768cta = ln_cta
                         and t.jaqy768oper = ln_oper;
                     commit;
                END;
                    
             End If;
            
            If lc_Stat = '-' then --En caso no hubiera pagos sea la min cuota de la fsd601
                BEGIN
                  PQ_CR_DESF_REVERTIR_PP70.sp_Revertir_Data2(ln_cod,
                                                             ln_mod,
                                                             ln_suc,
                                                             ln_mda,
                                                             ln_pap,
                                                             ln_cta,
                                                             ln_oper,
                                                             ln_sbop,
                                                             ln_tope,
                                                             ld_fmax);--FSD611
                
                    Update jaqy768 t
                       set t.jaqy768newdescp  = lc_FlgF,
                           t.jaqy768newest    = lc_Stat,
                           t.jaqy768newfchpag = ld_fmax,
                           t.jaqy768indf601   = 'S',
                           t.jaqy768oldfchpag = ld_antfch
                     where t.jaqy768cta = ln_cta
                       and t.jaqy768oper = ln_oper;
                    commit;
                    
                    BEGIN
                        If lc_revS = 'N' then -- para los casos que sean stat='-' no entran hacer revertidos
                          PQ_CR_DESF_REVERTIR_PP70.sp_Revertir_fpp001(ln_cod,
                                                                      ln_mod,
                                                                      ln_suc,
                                                                      ln_mda,
                                                                      ln_pap,
                                                                      ln_cta,
                                                                      ln_oper,
                                                                      ln_sbop,
                                                                      ln_tope);--FPP001
                          Update jaqy768 t
                             set t.jaqy768indp001   = 'S',
                                 t.jaqy768fchasis = ld_FchSist, 
                                 t.jaqy768hrasis = lc_hora
                           where t.jaqy768cta = ln_cta
                             and t.jaqy768oper = ln_oper;
                          commit;
                        End If;
                    EXCEPTION WHEN OTHERS THEN
                        Update jaqy768 t
                           set t.jaqy768indp001   = '2',
                               t.jaqy768fchasis = ld_FchSist, 
                               t.jaqy768hrasis = lc_hora
                         where t.jaqy768cta = ln_cta
                           and t.jaqy768oper = ln_oper;
                        commit;
                    END;
              
                EXCEPTION WHEN OTHERS THEN
                    Update jaqy768 t
                       set t.jaqy768indf601   = '2'
                     where t.jaqy768cta  = ln_cta
                       and t.jaqy768oper = ln_oper;
                    commit;        
                END;
            End If;
          
          Else
            If lc_data = 'S' then --jaqy784  ya existe
              Update jaqy768 t
                 set t.jaqy768indp001 = 'T'
               where t.jaqy768cta = ln_cta
                 and t.jaqy768oper = ln_oper;
              commit;
            End If;
          End If;
        Else
          If lc_repro = 'S' then  --jaqz519  ya existe
            Update jaqy768 t
               set t.jaqy768indp001 = 'R'
             where t.jaqy768cta = ln_cta
               and t.jaqy768oper = ln_oper;
            commit;
          End If;
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
      select p.jaqy785cod,
             p.jaqy785mod,
             p.jaqy785suc,
             p.jaqy785mda,
             p.jaqy785pap,
             p.jaqy785cta,
             p.jaqy785oper,
             p.jaqy785sbop,
             p.jaqy785tope,
             p.jaqy785fpag,
             p.jaqy785imp11,
             p.jaqy785imp12,
             p.jaqy785imp13,
             p.jaqy785imp14,
             p.jaqy785imp15
        from jaqy785 p
       where p.jaqy785cod = ln_cod1
         and p.jaqy785mod = ln_mod1
         and p.jaqy785suc = ln_suc1
         and p.jaqy785mda = ln_mda1
         and p.jaqy785pap = ln_pap1
         and p.jaqy785cta = ln_cta1
         and p.jaqy785oper = ln_oper1
         and p.jaqy785sbop = ln_sbop1
         and p.jaqy785tope = ln_tope1
         and p.jaqy785fpag > ld_fech1
       order by p.jaqy785fpag;
  
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
      ln_cod     := xx.jaqy785cod;
      ln_mod     := xx.jaqy785mod;
      ln_suc     := xx.jaqy785suc;
      ln_mda     := xx.jaqy785mda;
      ln_pap     := xx.jaqy785pap;
      ln_cta     := xx.jaqy785cta;
      ln_oper    := xx.jaqy785oper;
      ln_sbop    := xx.jaqy785sbop;
      ln_tope    := xx.jaqy785tope;
      ld_pfpag   := xx.jaqy785fpag;
      ln_ppimp11 := xx.jaqy785imp11;
      ln_ppimp12 := xx.jaqy785imp12;
      ln_ppimp13 := xx.jaqy785imp13;
      ln_ppimp14 := xx.jaqy785imp14;
      ln_ppimp15 := xx.jaqy785imp15;
    
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
      select p.jaqy785cod,
             p.jaqy785mod,
             p.jaqy785suc,
             p.jaqy785mda,
             p.jaqy785pap,
             p.jaqy785cta,
             p.jaqy785oper,
             p.jaqy785sbop,
             p.jaqy785tope,
             p.jaqy785fpag,
             p.jaqy785imp11,
             p.jaqy785imp12,
             p.jaqy785imp13,
             p.jaqy785imp14,
             p.jaqy785imp15
        from jaqy785 p
       where p.jaqy785cod = ln_cod1
         and p.jaqy785mod = ln_mod1
         and p.jaqy785suc = ln_suc1
         and p.jaqy785mda = ln_mda1
         and p.jaqy785pap = ln_pap1
         and p.jaqy785cta = ln_cta1
         and p.jaqy785oper = ln_oper1
         and p.jaqy785sbop = ln_sbop1
         and p.jaqy785tope = ln_tope1
         and p.jaqy785fpag >= ld_fech1
       order by p.jaqy785fpag;
  
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
      ln_cod     := xx.jaqy785cod;
      ln_mod     := xx.jaqy785mod;
      ln_suc     := xx.jaqy785suc;
      ln_mda     := xx.jaqy785mda;
      ln_pap     := xx.jaqy785pap;
      ln_cta     := xx.jaqy785cta;
      ln_oper    := xx.jaqy785oper;
      ln_sbop    := xx.jaqy785sbop;
      ln_tope    := xx.jaqy785tope;
      ld_pfpag   := xx.jaqy785fpag;
      ln_ppimp11 := xx.jaqy785imp11;
      ln_ppimp12 := xx.jaqy785imp12;
      ln_ppimp13 := xx.jaqy785imp13;
      ln_ppimp14 := xx.jaqy785imp14;
      ln_ppimp15 := xx.jaqy785imp15;
    
      Update fsd611 t
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
End PQ_CR_DESF_REVERTIR_PP70;
/

