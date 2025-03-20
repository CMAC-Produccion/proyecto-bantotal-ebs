create or replace package PQ_AH_CALC_DPF is

  -- Author  : MARAUJO
  -- Created : 27/07/2016 05:06:42 p.m.
  -- Purpose : 

  PROCEDURE SP_AH_CANCELA_DPF(P_N_PGCOD  IN number,
                              P_N_SCSUC  IN number,
                              P_N_SCMDA  IN number,
                              P_N_SCPAP  IN number,
                              P_N_SCCTA  IN number,
                              P_N_SCOPER IN number,
                              P_N_SCSBOP IN number,
                              P_N_SCTOPE IN number,
                              P_N_SCMOD  IN number,
                              P_N_TASINT IN number,
                              P_D_FECCAN IN date,
                              P_N_TOTPAG OUT number,
                              P_N_ORICAP OUT number,
                              P_N_ORIINT OUT number,
                              P_N_PAGCAP OUT number,
                              P_N_PAGINT OUT number,
                              P_N_DIFCAP OUT number,
                              P_N_DIFINT OUT number,
                              P_N_TOTDIF OUT number,
                              P_N_ITF    OUT number);

  PROCEDURE SP_AH_SIMULADOR_DPF(P_C_USUARIO IN varchar2,
                                P_N_TOTOPE  IN number,
                                P_D_FECAPE  IN date,
                                P_N_MTOCAP  IN number,
                                P_N_PLAZO   IN number,
                                P_N_TASINT  IN number,
                                P_N_NUMDIA  IN number,
                                P_N_MTORET  IN number,
                                P_N_MAXRET  IN number,
                                P_D_FECEXT  IN date,
                                P_N_MTOEXT  IN number,
                                P_N_TOTRET  OUT number,
                                P_N_CAPRET  OUT number,
                                P_N_INTRET  OUT number,
                                P_N_INTERE  OUT number);

  FUNCTION FN_AH_CALCINT(P_N_NUMDIA IN number,
                         P_N_TASINT IN number,
                         P_N_MTOCAP IN number) RETURN NUMBER;

  PROCEDURE SP_AH_RECALCULA_FSD602(p_pgcod  in number,
                                   p_scmod  in number,
                                   p_scsuc  in number,
                                   p_scmda  in number,
                                   p_scpap  in number,
                                   p_sccta  in number,
                                   p_scoper in number,
                                   p_scsbop in number,
                                   p_sctope in number,
                                   p_result out varchar2);

end PQ_AH_CALC_DPF;
/

create or replace package body PQ_AH_CALC_DPF is

  PROCEDURE SP_AH_CANCELA_DPF(P_N_PGCOD  IN number,
                              P_N_SCSUC  IN number,
                              P_N_SCMDA  IN number,
                              P_N_SCPAP  IN number,
                              P_N_SCCTA  IN number,
                              P_N_SCOPER IN number,
                              P_N_SCSBOP IN number,
                              P_N_SCTOPE IN number,
                              P_N_SCMOD  IN number,
                              P_N_TASINT IN number,
                              P_D_FECCAN IN date,
                              P_N_TOTPAG OUT number,
                              P_N_ORICAP OUT number,
                              P_N_ORIINT OUT number,
                              P_N_PAGCAP OUT number,
                              P_N_PAGINT OUT number,
                              P_N_DIFCAP OUT number,
                              P_N_DIFINT OUT number,
                              P_N_TOTDIF OUT number,
                              P_N_ITF    OUT number) is
  
    cursor retiros is
      select *
        from fsd602
       where pgcod = P_N_PGCOD
         and ppmod = P_N_SCMOD
         and ppsuc = P_N_SCSUC
         and ppmda = P_N_SCMDA
         and pppap = P_N_SCPAP
         and ppcta = P_N_SCCTA
         and ppoper = P_N_SCOPER
         and ppsbop = P_N_SCSBOP
         and pptope = P_N_SCTOPE
         and d602co = 'S'
       order by PP1FECH;
  
    fecape    date;
    fecfin    date;
    numdia    number;
    mtocap    number;
    ln_intere number := 0;
    ln_totcap number := 0;
    ln_totint number := 0;
    mtoret    number;
    ln_totret number := 0;
    ln_retcap number := 0;
    ln_retint number := 0;
    ln_capori number;
    ln_intori number;
    ln_afect  number;
    ld_fecvto date;
  
  Begin
  
    RETURN;  
  
    P_N_TOTPAG := 0;
    P_N_ORICAP := 0;
    P_N_ORIINT := 0;
    P_N_PAGCAP := 0;
    P_N_PAGINT := 0;
    P_N_DIFCAP := 0;
    P_N_DIFINT := 0;
    P_N_TOTDIF := 0;
    P_N_ITF    := 0;
  
    begin
      select aofval, aoimp, aofvto
        into fecape, ln_totcap, ld_fecvto
        from fsd010
       where pgcod = P_N_PGCOD
         and aomod = P_N_SCMOD
         and aosuc = P_N_SCSUC
         and aomda = P_N_SCMDA
         and aopap = P_N_SCPAP
         and aocta = P_N_SCCTA
         and aooper = P_N_SCOPER
         and aosbop = P_N_SCSBOP
         and aotope = P_N_SCTOPE;
    exception
      when others then
        null;
    end;
  
    fecfin := fecape;
  
    if ld_fecvto <> P_D_FECCAN then
    
      for i in retiros loop
        numdia    := i.PP1FECH - fecfin;
        mtocap    := ln_totcap + ln_totint - ln_totret;
        ln_intere := round(fn_ah_calcint(numdia, P_N_TASINT, mtocap), 2);
        ln_totint := ln_totint + ln_intere;
      
        --        If (i.d602mo = 99 and i.d602tr = 924) or (i.d602mo = 22 and i.d602tr = 203) then
        --        If i.pp1cap > 0 then  
        mtoret := i.Pp1icap + i.pp1int;
        --        else
        --           mtoret    := i.pp1int;
        --        end if;
      
        ln_totret := ln_totret + mtoret;
      
        fecfin := i.PP1FECH;
      
      end loop;
    
      ln_retint := ln_totint - ln_totret;
    
      if ln_retint < 0 then
        ln_retint := ln_totint; -- retira el total de intereses
      
        if ln_totcap > 0 then
          ln_retcap := ln_totcap - ln_totret - ln_retint;
        
          if ln_retcap < 0 then
            ln_retcap := ln_totcap;
          else
            ln_retcap := ln_totret - ln_retint;
          end if;
        end if;
      else
        ln_retint := ln_totret; -- retira el total de intereses
        ln_retcap := 0;
      end if;
    
      numdia    := P_D_FECCAN - fecfin;
      mtocap    := ln_totcap + ln_totint - ln_totret;
      ln_intere := round(fn_ah_calcint(numdia, P_N_TASINT, mtocap), 2);
      ln_totint := ln_totint + ln_intere;
    
      P_N_TOTPAG := mtocap + ln_intere; -- total a pagar a cliente
    
      P_N_PAGCAP := ln_totcap - ln_retcap;
      P_N_PAGINT := ln_totint - ln_retint;
    
      begin
        select scsdo
          into ln_capori
          from fsd011
         where pgcod = P_N_PGCOD
           and scmod = P_N_SCMOD
           and scsuc = P_N_SCSUC
           and scmda = P_N_SCMDA
           and scpap = P_N_SCPAP
           and sccta = P_N_SCCTA
           and scoper = P_N_SCOPER
           and scsbop = P_N_SCSBOP
           and sctope = P_N_SCTOPE;
      exception
        when others then
          ln_capori := 0;
      end;
    
      P_N_ORICAP := ln_capori;
    
      begin
        select scsdo
          into ln_intori
          from fsd011
         where pgcod = P_N_PGCOD
           and scmod = 426
           and scsuc = P_N_SCSUC
           and scmda = P_N_SCMDA
           and scpap = P_N_SCPAP
           and sccta = P_N_SCCTA
           and scoper = P_N_SCOPER
           and scsbop = P_N_SCSBOP
           and sctope = 0;
      exception
        when others then
          ln_intori := 0;
      end;
    
      P_N_ORIINT := ln_intori;
    
      --P_N_TOTORI := ln_capori + ln_intori;
    
      P_N_DIFCAP := P_N_ORICAP - P_N_PAGCAP;
      P_N_DIFINT := P_N_ORIINT - P_N_PAGINT;
    
      P_N_TOTDIF := (ln_capori + ln_intori) - P_N_TOTPAG;
    
      SP_CALCULA_ITF(P_N_PGCOD,
                     P_N_SCMOD,
                     P_N_SCSUC,
                     P_N_SCMDA,
                     P_N_SCPAP,
                     P_N_SCCTA,
                     P_N_SCOPER,
                     P_N_SCSBOP,
                     P_N_SCTOPE,
                     P_N_TOTPAG,
                     ln_afect,
                     P_N_ITF);
    
    end if;
  
  End;

  ---------------------------------------------------------

  PROCEDURE SP_AH_SIMULADOR_DPF(P_C_USUARIO IN varchar2,
                                P_N_TOTOPE  IN number,
                                P_D_FECAPE  IN date,
                                P_N_MTOCAP  IN number,
                                P_N_PLAZO   IN number,
                                P_N_TASINT  IN number,
                                P_N_NUMDIA  IN number,
                                P_N_MTORET  IN number,
                                P_N_MAXRET  IN number,
                                P_D_FECEXT  IN date,
                                P_N_MTOEXT  IN number,
                                P_N_TOTRET  OUT number,
                                P_N_CAPRET  OUT number,
                                P_N_INTRET  OUT number,
                                P_N_INTERE  OUT number) is
    /*    
    Fecha de Apertura   
    Fecha Vencimiento   
    Moneda    
    Capital   
    Plazo   
    TEA   
    Periodo Retiro    
    Monto pactado con el cliente    
    % m?ximo a retirar    
    Monto Capital m?ximo a retirar    
    Saldo m?nimo Capital    
    */
  
    fecini    date := P_D_FECAPE;
    fecfin    date := P_D_FECAPE;
    mtoret    number;
    numdia    number;
    mtocap    number := P_N_MTOCAP;
    ld_fecvto date := P_D_FECAPE + P_N_PLAZO;
    ld_fecret date;
    ln_intere number := 0;
    ln_totint number := 0;
    ln_maxcap number;
    ln_retcap number := 0;
    ln_retint number := 0;
    ln_totcap number := 0;
    ln_ItfRet number := 0;
    ln_capret number := 0;
    capital   number := 0;
    esrete    char(1);
  
    ln_dias number := P_N_NUMDIA;
  
  begin
  
    delete from jaql728 where jaql728user = rpad(P_C_USUARIO, 10, ' ');
  
    ln_maxcap := P_N_MTOCAP * (P_N_MAXRET / 100);
    ln_totcap := P_N_MTOCAP;
  
    while fecfin < ld_fecvto loop
      fecini := fecfin;
    
      if P_N_NUMDIA = 0 or (P_N_MTORET = 0 and P_N_TOTOPE <> 2) then
        ln_dias := P_N_PLAZO;
      end if;
    
      If (P_D_FECEXT > fecini) and (P_D_FECEXT <= fecini + ln_dias) then
        ld_fecret := fecini + ln_dias;
        fecfin    := P_D_FECEXT;
        mtoret    := P_N_MTOEXT;
        esrete    := 'S';
      Else
        If ld_fecret is not null then
          fecfin := ld_fecret;
        Else
          fecfin := fecini + ln_dias;
        End If;
      
        If P_N_TOTOPE = 2 then
          mtoret := round(fn_ah_calcint(ln_dias, P_N_TASINT, mtocap), 2);
        Else
          mtoret := P_N_MTORET;
        End If;
      
        ld_fecret := null;
        esrete    := 'N';
      End If;
    
      numdia    := fecfin - fecini;
      mtocap    := ln_totcap + ln_totint;
      ln_intere := round(fn_ah_calcint(numdia, P_N_TASINT, mtocap), 2);
    
      ln_totint := ln_totint + ln_intere;
    
      If mtoret > 0 then
      
        Capital := ln_maxcap - ln_capret;
      
        if Capital < 0 then
          Capital := 0;
        End if;
      
        ln_RetCap := 0;
      
        ln_retint := ln_totint - (mtoret + ln_ItfRet);
      
        If ln_RetInt < 0 then
          ln_RetInt := ln_totint; -- retira el total de intereses
        
          If capital > 0 then
            ln_RetCap := capital - ((mtoret + ln_ItfRet) - ln_retint);
          
            If ln_RetCap < 0 then
              ln_RetCap := capital;
            Else
              ln_RetCap := ((mtoret + ln_ItfRet) - ln_RetInt);
            End If;
          End If;
        Else
          ln_RetInt := (mtoret + ln_ItfRet); -- retira el total de intereses
          ln_RetCap := 0;
        End If;
      
        ln_totcap := ln_totcap - ln_RetCap;
        ln_capret := ln_capret + ln_RetCap;
        ln_totint := ln_totint - ln_retint;
      end if;
    
      insert into jaql728
        (jaql728user,
         jaql728fein,
         jaql728fefi,
         jaql728dias,
         jaql728tasa,
         jaql728capi,
         jaql728inte,
         jaql728reso,
         jaql728rere,
         jaql728care,
         jaql728inre,
         jaql728tire)
      values
        (P_C_USUARIO,
         fecini,
         fecfin,
         numdia,
         P_N_TASINT,
         mtocap,
         ln_intere,
         mtoret,
         ln_retcap + ln_retint,
         ln_retcap,
         ln_retint,
         esrete);
    
      select count(*)
        into P_N_TOTRET
        from jaql728
       where jaql728reso - jaql728rere = 0
         and jaql728reso > 0
         and jaql728tire = 'N';
    
      select sum(jaql728care), sum(jaql728inre), sum(jaql728inte)
        into P_N_CAPRET, P_N_INTRET, P_N_INTERE
        from jaql728;
    
    end loop;
  
    commit;
  end;

  ------------------------------------------------------------------------

  FUNCTION FN_AH_CALCINT(P_N_NUMDIA IN number,
                         P_N_TASINT IN number,
                         P_N_MTOCAP IN number) RETURN NUMBER IS
  
    -- *****************************************************************
    -- Nombre                     : FN_AH_PLF_CALCINT
    -- Sistema                    : BT
    -- M?dulo                     : Ahorros
    -- Versi?n                    : 1.0
    -- Fecha de Creaci?n          : 27/07/2016
    -- Autor de Creaci?n          : Mersali A.
    -- Uso                        : Calcula monto interes con TEA.
    -- Estado                     : Activo
    -- Acceso                     : P?blico
    -- Par?metros de Entrada      : p_n_mtocap ( MONTO CAPITAL )
    --                              p_n_tasint ( TASA DE INTERES )
    --                              p_n_numdia  ( NUMERO DE DIAS )
    -- Par?metros de Salida       :
    -- Retorno                    : INTERES PROVISIONADO
    -- Fecha de Modificaci?n      :
    -- Autor de la Modificaci?n   :
    -- Descripci?n de Modificaci?n:
    -- *****************************************************************
    ln_intcal number;
  begin
    ln_intcal := p_n_mtocap *
                 (power((1 + p_n_tasint / 100), (p_n_numdia / 360)) - 1);
    return(ln_intcal);
  end;

  ------------------------------------------------------------------------

  PROCEDURE SP_AH_RECALCULA_FSD602(p_pgcod  in number,
                                   p_scmod  in number,
                                   p_scsuc  in number,
                                   p_scmda  in number,
                                   p_scpap  in number,
                                   p_sccta  in number,
                                   p_scoper in number,
                                   p_scsbop in number,
                                   p_sctope in number,
                                   p_result out varchar2) is
/* ************************************************************************************************************
    -- Nombre                     : SP_AH_RECALCULA_FSD602
    -- Sistema                    : BANTOTAL
    -- Módulo                     : DPF
    -- Descripción                : Arma FSD602
    -- Versión                    : 1.0
    -- Fecha de Creación          : 05/06/2019
    -- Autor de Creación          : Mersalí Araujo
    -- Versión                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/

                                   
  
    cursor ctas is
      select a.*
        from FSD010 a
       where pgcod = p_pgcod
         and aomod = p_scmod
         and aosuc = p_scsuc
         and aomda = p_scmda
         and aopap = p_scpap
         and aocta = p_sccta
         and aooper = p_scoper
         and aosbop = p_scsbop
         and aotope = p_sctope;
  
    cursor movs is
      select *
        from fsd602
       where pgcod = 1
         and ppmod = p_scmod
         and ppsuc = p_scsuc
         and ppmda = p_scmda
         and pppap = p_scpap
         and ppcta = p_sccta
         and ppoper = p_scoper
         and ppsbop = p_scsbop
         and pptope = p_sctope
         and D602CO = 'S'
       order by pp1nump;
  
    vPP1CAP      number;
    vPP1INT      number;
    vPP1ICAP     number;
    vPP1IINT     number;
    vPP1IINTM    number;
    vPP1SALCAP   number;
    vhcimp1      number;
    vfecmov      date;
    vdias        number;
    vmtoacu      number;
    vacucap      number;
    vinteres     number;
    vacuint      number;
    vretcap      number;
    vretint      number;
    vPp1cap_old  number;
    vPp1icap_old number;
  
    vtxnesp char(1);
  
  begin
  
    p_result := 'S';
  
    RETURN;  
  
    for i in ctas loop
      vfecmov := i.aofval;
      vdias   := 0;
      vmtoacu := i.aoimp;
      vacucap := i.aoimp;
      vacuint := 0;
      vretcap := 0;
      vretint := 0;
    
      vPP1IINTM    := 0;
      vPP1SALCAP   := 0;
      vPp1cap_old  := 0;
      vPp1icap_old := 0;
    
      for j in movs loop
        --calcula interes
        vdias    := j.PP1FECH - vfecmov;
        vinteres := pq_ah_calc_dpf.fn_ah_calcint(p_n_numdia => vdias,
                                                 p_n_tasint => i.aotasa,
                                                 p_n_mtocap => vmtoacu);
      
        vacuint := round(vacuint + vinteres,2);
      
        --vacuint := vacuint + vinteres;
      

        begin
        
          select 'S'
            into vtxnesp
            from FST198
           Where Tp1cod = i.pgcod
             and Tp1cod1 = 11002
             and Tp1corr1 = 1
             and Tp1corr2 = 6
             and Tp1nro1 = j.d602mo
             and Tp1nro2 = j.d602tr;
        exception
          when no_data_found then
            vtxnesp := 'N';
          when too_many_rows then
            vtxnesp := 'S';
        end;
      
        begin
          select sum(hcimp1)
            into vhcimp1
            from (select hcimp1
                    from fsh016 a
                   where pgcod = j.d602cd
                     and hcmod = j.d602mo
                     and hsucor = j.d602su
                     and htran = j.d602tr
                     and hnrel = j.d602re
                     and hfcon = j.PP1FECH --d602fc
                     and a.hcta = i.aocta
                     and a.hoper = i.aooper
                     and a.hsubop = i.aosbop
                     and HCORD = decode(vtxnesp, 'S', j.d602or, HCORD)
                     and HCSUBO = decode(vtxnesp, 'S', j.d602sb, HCSUBO)
                  union
                  select itimp1
                    from fsd016 a
                   where pgcod = j.d602cd
                     and itmod = j.d602mo
                     and itsuc = j.d602su
                     and ittran = j.d602tr
                     and itnrel = j.d602re
                     and itfval = j.PP1FECH --d602fc
                     and ctnro = i.aocta
                     and itoper = i.aooper
                     and itsubo = i.aosbop
                     and itord = decode(vtxnesp, 'S', j.d602or, itord)
                     and itsbor = decode(vtxnesp, 'S', j.d602sb, itsbor));
          --        
        exception
          when no_data_found then
            vhcimp1  := 0;
            p_result := 'N';
            return;
        end;
      
        vmtoacu := round(vmtoacu + vinteres - vhcimp1,2);
        vfecmov := j.PP1FECH;
      
        -- fsd602
        --calcular cuanto de cap y de int
        if vhcimp1 - vacuint < 0 then
          vretcap := 0;
        else
          vretcap := vhcimp1 - vacuint;
        end if;
      
        vretint := vhcimp1 - vretcap;
      
        vacucap := vacucap - vretcap; -- cap para la 11
        vacuint := vacuint - vretint;
      
        vPp1cap := 0 - (vinteres - vhcimp1);
      
        If trunc(vPp1cap, 2) = 0 then
          vPp1cap := -0.01;
        End If;
      
        vPp1cap  := vPp1cap;
        vPp1int  := vRetInt; -- ok
        vPp1icap := vRetCap; -- ok
        vPp1iint := vmtoacu - vacucap; --vacuint;    
      
        vPp1iintm  := vpp1iintm + vPp1cap_old;
        vPp1salcap := vpp1salcap + vPp1icap_old;
      
        vPp1cap_old  := round(vPp1cap,2);
        vPp1icap_old := vPp1icap;
      
        update fsd602 x
           set Pp1cap    = vPp1cap,
               Pp1int    = vPp1int,
               Pp1icap   = vPp1icap,
               Pp1iint   = vPp1iint,
               Pp1iintm  = vPp1iintm,
               Pp1salcap = vPp1salcap--, PP1INTMEX = j.pp1nump
         where pgcod = 1
           and ppmod = j.ppmod
           and ppsuc = j.ppsuc
           and ppmda = j.ppmda
           and pppap = j.pppap
           and ppcta = j.ppcta
           and ppoper = j.ppoper
           and ppsbop = j.ppsbop
           and pptope = j.pptope
           and ppfpag = j.ppfpag
           and pptipo = j.pptipo
           and pp1nump = j.pp1nump
           and D602CO = 'S';
      
      end loop;
    end loop;
  
  exception
    when others then
      p_result := 'N';
  end SP_AH_RECALCULA_FSD602;

end PQ_AH_CALC_DPF;
/

