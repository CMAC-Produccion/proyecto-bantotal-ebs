create or replace package PQ_CR_CUPONESENLINEA is

  -- Author  : MPOSTIGOC
  -- Created : 18/09/2017 08:50:19 a.m.
  -- Purpose : Campañas Ticket en Ventanilla para Desembolsos y Pagos

  procedure sp_cr_inicio(ln_trItsuc  in number,
                         ln_trItmod  in number,
                         ln_trIttran in number,
                         ln_trItnrel in number,
                         ln_trItord  in number,
                         ln_trItsbor in number,
                         pc_uing     in varchar2);
  -----------------------------------------------------------------                         

  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2);
  ---------------------------------------------------------------------
  procedure sp_cr_VerfDesmbPoC(ln_Modulo   in number,
                               ln_TipOper  in number,
                               lc_TipDesem out varchar2);
  -------------------------------------------------------------------                                 
  Procedure sp_cr_excepcionTrans(ln_tmod       in number,
                                 ln_ttran      in number,
                                 flag_Exptrans out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_VerifGradoConsagui(ln_NroCuenta    in number,
                                     lc_FlafFamiliar out varchar2);
  ---------------------------------------------------------------   

  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           --ln_scrub1  in number,
                           ln_scstat1 in number,
                           FlgIncl    out varchar2);

  ----------------------------------------------------------------
  procedure sp_cr_verificaferiado(ln_diastraso in number,
                                  ln_sucursal  in number,
                                  ld_fecha     in date,
                                  Flag_habil   out varchar2);
  -------------------------------------------------------------------
  -- function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
  --------------------------------------------------------
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number;

  ---------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number,
                          LC_TipCredPC  in varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_Desembolsos(ln_trItsuc  in number,
                              ln_trItmod  in number,
                              ln_trIttran in number,
                              ln_trItnrel in number,
                              ln_trItord  in number,
                              ln_trItsbor in number,
                              pc_uing     in varchar2);
  --------------------------------------------------------------
  procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_Pagos(ln_trItsuc  in number,
                        ln_trItmod  in number,
                        ln_trIttran in number,
                        ln_trItnrel in number,
                        ln_trItord  in number,
                        ln_trItsbor in number,
                        pc_uing     in varchar2);
  -------------------------------------------------------------
  procedure sp_cr_nroopcionesdes(P_N_CODCAl in number,
                                 ln_opcion  out number,
                                 FlagCl     out varchar2);

  ---------------------------------------------------------------
  procedure sp_cr_AnulaCupon(PPgcod  in number,
                             Pitmod  in number,
                             PItsuc  in number,
                             PIttran in number,
                             PItnrel in number,
                             PItord  in number,
                             PItsbor in number);
  ---------------------------------------------------------------
  procedure sp_cr_ImpresionCupon(Pitmod         in number,
                                 PItsuc         in number,
                                 PIttran        in number,
                                 PItnrel        in number,
                                 PItord         in number,
                                 ln_NroOpciones out number);

end PQ_CR_CUPONESENLINEA;
/

create or replace package body PQ_CR_CUPONESENLINEA is

  procedure sp_cr_inicio(ln_trItsuc  in number,
                         ln_trItmod  in number,
                         ln_trIttran in number,
                         ln_trItnrel in number,
                         ln_trItord  in number,
                         ln_trItsbor in number,
                         pc_uing     in varchar2) is
  
    -- Numero de Cupones
  
    ld_FchI        date;
    ld_FchF        date;
    ld_fechatrans  date;
    lc_FlagTipCupo varchar2(2) := 'N';
  
  begin
  
    begin
    
      select pgfape into ld_fechatrans from fst017 where pgcod = 1;
    end;
  
    Begin
      --************************** cambiar formato ******************
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY'), --fech_inicio,
             to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                     'DD/MM/YYYY')
      --************************** cambiar formato ******************              
        into ld_FchI, ld_FchF
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 4;
    
    End;
  
    If (ld_fechatrans >= ld_FchI and ld_fechatrans <= ld_FchF) then
    
      begin
        -- Verifica si la transaccion es un Desembolso
        select 'D'
          into lc_FlagTipCupo
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10871
           and Tp1corr1 = 7
           and Tp1corr2 = 150
           and tp1nro2 = ln_trItmod
           and tp1nro3 = ln_trIttran
           and tp1imp1 = 1;
      exception
        when others then
          lc_FlagTipCupo := 'N';
      end;
    
      if lc_FlagTipCupo = 'N' then
      
        begin
          -- Verifica si la transaccion es un pago
        
          select 'P'
            into lc_FlagTipCupo
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10871
             and tp1corr1 = 7
             and tp1corr2 = 10
             and tp1nro2 = ln_trItmod
             and tp1nro3 = ln_trIttran;
        exception
          when others then
            lc_FlagTipCupo := 'N';
          
        end;
      
      end if;
    
      if lc_FlagTipCupo = 'D' then
      
        PQ_CR_CUPONESENLINEA.sp_cr_Desembolsos(ln_trItsuc,
                                               ln_trItmod,
                                               ln_trIttran,
                                               ln_trItnrel,
                                               ln_trItord,
                                               ln_trItsbor,
                                               pc_uing);
      
      else
        if lc_FlagTipCupo = 'P' then
        
          PQ_CR_CUPONESENLINEA.sp_cr_Pagos(ln_trItsuc,
                                           ln_trItmod,
                                           ln_trIttran,
                                           ln_trItnrel,
                                           ln_trItord,
                                           ln_trItsbor,
                                           pc_uing);
        
        end if;
      end if;
    
    End If;
  
  end sp_cr_inicio;
  ----------------------------------------------------------------
  procedure sp_cr_Pagos(ln_trItsuc  in number,
                        ln_trItmod  in number,
                        ln_trIttran in number,
                        ln_trItnrel in number,
                        ln_trItord  in number,
                        ln_trItsbor in number,
                        pc_uing     in varchar2) is
  
    cursor inicio(ld_fechatrans in date) is
      select h.modulo JAQL406Mod,
             h.itsucd JAQL406Suc,
             h.moneda JAQL406Mda,
             h.ctnro JAQL406Cta,
             h.itoper JAQL406Ope,
             h.itsubo JAQL406Sbo,
             h.ittope JAQL406Top,
             h.ittran JAQL406TTRAN,
             h.itmod JAQL406TMOD,
             h.itnrel JAQL406TNREL,
             h.itord JAQL406TORD,
             h.itsuc JAQL406TSUC,
             h.itsbor JAQL406TSBOR,
             h.pgcod JAQL406PGC,
             h.papel JAQL406PAP,
             lpad(trim(to_char(h.ctnro)), 9, '0') ||
             lpad(trim(to_char(h.moneda)), 3, '0') ||
             lpad(trim(to_char(h.itoper)), 9, '0') CREDITO,
             (select r2.regcod
                from fst810 r2, fst811 r
               where r2.pgcod = r.pgcod
                 and r2.regcod = r.regcod
                 and r.pgcod = 1
                 and r.oficod = h.itsucd
                 and r2.regcod < 100) REGION,
             f.pp1nump NRO_CUOTA,
             f.pp1fech fch_pp1,
             F.D602FC Fch_d602,
             f.ppfpag FECH_CTA
        from fsd602 f, fsd016 h
       where h.pgcod = f.PGCOD
         and h.itsucd = f.ppsuc
         and h.modulo = f.ppmod
         and h.moneda = f.ppmda
         and h.papel = f.pppap
         and h.ctnro = f.ppcta
         and h.itoper = f.ppoper
         and h.itsubo = f.ppsbop
         and h.ittope = f.pptope
         and f.d602mo = h.itmod
         and f.d602su = h.itsuc
         and f.d602tr = h.ittran
         and f.d602re = h.itnrel
         and f.d602fc = ld_fechatrans
         and f.d602or = h.itord
         and f.d602sb = h.itsbor
         and f.pgcod = 1
         and f.d602co = 'S'
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and f.pp1stat = 'T'
         and h.Itsuc = ln_trItsuc
         and h.Itmod = ln_trItmod
         and h.Ittran = ln_trIttran
         and h.Itnrel = ln_trItnrel
         and h.Itord = ln_trItord
         and h.Itsbor = ln_trItsbor;
  
    -- Numero de Cupones
  
    ld_FchI          date;
    ld_FchF          date;
    lc_flgtrabajador varchar2(2);
    flag_Exptrans    varchar2(2);
    ln_scstat1       number;
    FlgInc           varchar2(2);
    Flag_habil       varchar2(2);
    ln_opcion        number;
    l                number := 1;
    ln_nrocred       varchar2(21);
    ld_ope           date;
    lc_Est           varchar2(2);
    lc_Ant           varchar2(2);
    ln_Atr           NUMBER(10);
    ln_calific       number(10);
    lc_Tip           varchar2(2);
    lc_EXCUP         varchar2(2);
    ld_fcta          date;
    ln_NUMP          NUMBER(9);
    ln_CUPNUM        NUMBER(10);
    lc_tndoc         varchar2(12);
    lc_docsbs        varchar2(1);
    ln_tdoc          number(2);
    ld_fechatrans    date;
    diasatraso       number;
    flag_exist       varchar2(2);
    lc_FlagFamiliar  varchar2(2) := 'N';
    lc_TipDesem      varchar2(2) := 'N';
  
  begin
  
    begin
      select pgfape into ld_fechatrans from fst017 where pgcod = 1;
    end;
  
    Begin
      --************************** cambiar formato ******************
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY'), --fech_inicio,
             to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                     'DD/MM/YYYY')
      --************************** cambiar formato ******************              
        into ld_FchI, ld_FchF
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 4;
    
    End;
  
    If (ld_fechatrans >= ld_FchI and ld_fechatrans <= ld_FchF) then
    
      for i in inicio(ld_fechatrans) loop
      
        if i.fech_cta >= ld_FchI and i.fech_cta <= ld_FchF then
        
          if I.FCH_PP1 <= i.fch_d602 then
            ld_ope := i.fch_pp1;
          else
            ld_ope := i.fch_d602;
          end if;
        
          ln_nrocred := i.CREDITO;
          -- ld_ope     := i.FECH_OPE;
          ld_fcta    := i.fech_cta;
          diasatraso := (ld_ope - ld_fcta);
        
          PQ_CR_CUPONESENLINEA.sp_cr_ChekTrabajador(i.jaql406cta,
                                                    lc_flgtrabajador);
          PQ_CR_CUPONESENLINEA.sp_cr_VerfDesmbPoC(i.jaql406mod,
                                                  i.jaql406top,
                                                  lc_TipDesem);
        
          if lc_flgtrabajador = 'N' and lc_TipDesem = 'P' then
          
            pq_cr_cuponesenlinea.sp_cr_VerifGradoConsagui(i.jaql406cta,
                                                          lc_FlagFamiliar);
          
            if lc_FlagFamiliar = 'N' then
            
              PQ_CR_CUPONESENLINEA.sp_cr_excepcionTrans(i.jaql406tmod,
                                                        i.jaql406ttran,
                                                        flag_Exptrans);
            
              begin
                select f.aostat
                  into ln_scstat1
                  from fsd010 f
                 where f.pgcod = 1
                   and f.aomod = i.jaql406mod
                   and f.aosuc = i.jaql406suc
                   and f.aomda = i.jaql406mda
                   and f.aopap = i.jaql406pap
                   and f.aocta = i.jaql406cta
                   and f.aooper = i.jaql406ope
                   and f.aosbop = i.jaql406sbo
                   and f.aotope = i.jaql406top;
              exception
                when others then
                  null;
              end;
            
              if flag_Exptrans = 'S' then
              
                PQ_CR_CUPONESENLINEA.sp_Excepciones(i.jaql406mod,
                                                    i.jaql406suc,
                                                    i.jaql406mda,
                                                    i.jaql406cta,
                                                    i.jaql406ope,
                                                    i.jaql406sbo,
                                                    i.jaql406top,
                                                    ln_scstat1,
                                                    FlgInc);
              
                If FlgInc <> 'N' then
                
                  l := 1;
                
                  if diasatraso > 0 then
                  
                    PQ_CR_CUPONESENLINEA.sp_cr_verificaferiado(diasatraso,
                                                               i.jaql406suc,
                                                               i.fech_cta,
                                                               -- ld_ope,
                                                               Flag_habil);
                  
                    if Flag_habil = 'N' then
                    
                      begin
                        select tp1nro3
                          into ln_opcion
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 10871
                           and tp1corr1 = 7
                           and tp1corr2 = 2
                           and tp1corr3 = 1;
                      end;
                    
                    else
                      if Flag_habil = 'S' then
                      
                        if diasatraso > 0 then
                          begin
                            select tp1nro3
                              into ln_opcion
                              from fst198
                             where tp1cod = 1
                               and tp1cod1 = 10871
                               and tp1corr1 = 7
                               and tp1corr2 = 2
                               and tp1nro2 = diasatraso;
                          exception
                            when others then
                              ln_opcion := 0;
                          end;
                        end if;
                      
                      end if;
                    end if;
                  
                  else
                    if diasatraso = 0 or diasatraso < 0 then
                      begin
                        select tp1nro3
                          into ln_opcion
                          from fst198
                         where tp1cod = 1
                           and tp1cod1 = 10871
                           and tp1corr1 = 7
                           and tp1corr2 = 2
                           and tp1corr3 = 1;
                      end;
                    
                    end if;
                  end if;
                
                  begin
                    select f.pendoc, f.petdoc
                      into lc_tndoc, ln_tdoc
                      from fsr008 f
                     where f.ctnro = i.jaql406cta
                       and f.cttfir = 'T';
                  end;
                
                  lc_tndoc := trim(lc_tndoc);
                
                  --  lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
                
                  Begin
                    -- Tipo de DOC para la RCC
                    select to_char(a.tp1corr3)
                      into lc_docsbs
                      from fst198 a
                     where a.tp1cod = 1
                       and a.tp1cod1 = 11111
                       and a.tp1corr1 = 1
                       and a.tp1corr2 = 3
                       and a.tp1nro1 = ln_tdoc;
                  exception
                    when others then
                      lc_docsbs := '0';
                  End;
                
                  ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
                
                  If FlgInc <> 'N' and ln_calific = 1 then
                  
                    lc_Est := 'S';
                  
                    lc_EXCUP  := 'C';
                    ln_Atr    := diasatraso;
                    ln_NUMP   := i.NRO_CUOTA;
                    ln_CUPNUM := 1;
                  
                    IF ln_Atr = 0 or ln_Atr > 0 then
                      lc_Ant := 'N';
                    Else
                      if ln_Atr < 0 THEN
                        lc_Ant := 'S';
                      end if;
                    end if;
                  
                    lc_Tip := 'P';
                  
                    PQ_CR_CUPONESENLINEA.sp_cr_verificajaql406(i.JAQL406pgc,
                                                               i.JAQL406Mod,
                                                               i.JAQL406Suc,
                                                               i.JAQL406Mda,
                                                               i.JAQL406pap,
                                                               i.JAQL406Cta,
                                                               i.JAQL406Ope,
                                                               i.JAQL406Sbo,
                                                               i.JAQL406Top,
                                                               ld_fcta,
                                                               i.JAQL406tsbor,
                                                               i.JAQL406tord,
                                                               i.JAQL406tnrel,
                                                               i.JAQL406ttran,
                                                               i.JAQL406tmod,
                                                               i.JAQL406tsuc,
                                                               flag_exist);
                  
                    if flag_exist <> 'S' then
                    
                      while l <= ln_opcion loop
                      
                        PQ_CR_CUPONESENLINEA.sp_cr_inserta(SQ_CR_JAQL406_1.NEXTVAL,
                                                           i.JAQL406pgc,
                                                           i.JAQL406Mod,
                                                           i.JAQL406Suc,
                                                           i.JAQL406Mda,
                                                           i.JAQL406pap,
                                                           i.JAQL406Cta,
                                                           i.JAQL406Ope,
                                                           i.JAQL406Sbo,
                                                           i.JAQL406Top,
                                                           ln_nrocred,
                                                           ld_fechatrans,
                                                           i.fch_d602,
                                                           lc_Est,
                                                           UPPER(pc_uing),
                                                           i.JAQL406Suc,
                                                           i.region,
                                                           lc_Ant,
                                                           ln_Atr,
                                                           ln_calific,
                                                           lc_Tip,
                                                           lc_EXCUP,
                                                           i.JAQL406tsbor,
                                                           i.JAQL406tord,
                                                           i.JAQL406tnrel,
                                                           i.JAQL406ttran,
                                                           i.JAQL406tmod,
                                                           i.JAQL406tsuc,
                                                           ld_fcta,
                                                           ln_NUMP,
                                                           ln_CUPNUM,
                                                           ln_opcion,
                                                           lc_TipDesem);
                      
                        l := l + 1;
                      
                      end loop;
                    end if;
                  end if;
                
                end if;
              
              end if;
            
            end if;
          end if;
        end if;
      
      end loop;
    
    End If;
  
  end sp_cr_Pagos;
  ----------------------------------------------------------------
  procedure sp_cr_Desembolsos(ln_trItsuc  in number,
                              ln_trItmod  in number,
                              ln_trIttran in number,
                              ln_trItnrel in number,
                              ln_trItord  in number,
                              ln_trItsbor in number,
                              pc_uing     in varchar2) is
  
    Cursor data1(ld_fechatrans date) is
    
      select distinct h.modulo JAQL406Mod,
                      h.itsucd JAQL406Suc,
                      h.moneda JAQL406Mda,
                      h.ctnro JAQL406Cta,
                      h.itoper JAQL406Ope,
                      h.itsubo JAQL406Sbo,
                      h.ittope JAQL406Top,
                      h.ittran JAQL406TTRAN,
                      h.itmod JAQL406TMOD,
                      h.itnrel JAQL406TNREL,
                      h.itord JAQL406TORD,
                      h.itsuc JAQL406TSUC,
                      h.itsbor JAQL406TSBOR,
                      h.pgcod JAQL406PGC,
                      h.papel JAQL406PAP,
                      lpad(trim(to_char(h.ctnro)), 9, '0') ||
                      lpad(trim(to_char(h.moneda)), 3, '0') ||
                      lpad(trim(to_char(h.itoper)), 9, '0') CREDITO,
                      (select r2.regcod
                         from fst810 r2, fst811 r
                        where r2.pgcod = r.pgcod
                          and r2.regcod = r.regcod
                          and r.pgcod = 1
                          and r.oficod = h.itsucd
                          and r2.regcod < 100) REGION,
                      f.d601fc Fch_Desembolso
        from fsd601 f, fsd016 h
       where h.pgcod = f.PGCOD
         and h.itsucd = f.ppsuc
         and h.modulo = f.ppmod
         and h.moneda = f.ppmda
         and h.papel = f.pppap
         and h.ctnro = f.ppcta
         and h.itoper = f.ppoper
         and h.itsubo = f.ppsbop
         and h.ittope = f.pptope
         and f.d601mo = h.itmod
         and f.d601su = h.itsuc
         and f.d601tr = h.ittran
         and f.d601re = h.itnrel
         and f.d601fc = ld_fechatrans
         and f.d601or = h.itord
         and f.d601sb = h.itsbor
         and f.pgcod = 1
         and f.ppmod in (select modulo from fst111 where dscod = 50)
         and f.d601co = 'S'
         and h.Itsuc = ln_trItsuc
         and h.Itmod = ln_trItmod
         and h.Ittran = ln_trIttran
         and h.Itnrel = ln_trItnrel
         and h.Itord = ln_trItord
         and h.Itsbor = ln_trItsbor;
  
    ln_sbop number(3);
    ln_tope number(3);
    ln_cta  NUMBER(9);
    ln_mod  NUMBER(4);
    ln_mda  NUMBER(3);
    ln_oper NUMBER(9);
    ln_suc  number(3);
  
    ln_ttran   number;
    ln_tmod    number;
    ln_tnrel   number;
    ln_tord    number;
    ln_tsuc    number;
    ln_tsbor   number;
    ln_pgcod   number;
    ln_papel   number;
    ln_nrocred varchar2(21);
    ln_region  number;
  
    lc_Est     char(1);
    lc_Ant     char(1);
    ln_Atr     NUMBER(10);
    lc_Tip     char(1);
    lc_EXCUP   char(5);
    ld_fecha   date;
    FlgInc     char(1);
    p_c_numdoc varchar2(12);
    ln_tdoc    number(2);
    lc_tndoc   char(12);
    ln_opcion  number(5);
  
    ln_scstat        number(2);
    lc_docsbs        char(1);
    ln_calific       number(10);
    ln_NUMP          NUMBER(9);
    ln_CUPNUM        NUMBER(10);
    P_N_CODCAl       number;
    FlagCl           varchar2(2);
    flag_exist       varchar2(2);
    P_C_DESCAL       varchar2(40);
    i                number := 1;
    Fecha_operacion  date;
    P_N_PAIS         number;
    lc_flgtrabajador varchar2(2) := 'N';
    ld_fechatrans    date;
    ld_FchI          date;
    ld_FchF          date;
    lc_FlagFamiliar  varchar2(2) := 'N';
    ln_Instancia     number;
    lc_TipDesem      varchar2(5);
  
  BEGIN
  
    begin
      select pgfape into ld_fechatrans from fst017 where pgcod = 1;
    end;
  
    Begin
      --************************** cambiar formato ******************
      select to_date(Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
                     'DD/MM/YYYY'), --fech_inicio,
             to_date(Tp1imp1 || '/' || Tp1imp2 || '/' || Tp1imp3,
                     'DD/MM/YYYY')
      --************************** cambiar formato ******************              
        into ld_FchI, ld_FchF
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 4;
    
    End;
  
    If (ld_fechatrans >= ld_FchI and ld_fechatrans <= ld_FchF) then
    
      For j in data1(ld_fechatrans) loop
      
        ln_mod          := j.jaql406mod;
        ln_suc          := j.jaql406suc;
        ln_mda          := j.jaql406mda;
        ln_cta          := j.jaql406cta;
        ln_oper         := j.jaql406ope;
        ln_sbop         := j.jaql406sbo;
        ln_tope         := j.jaql406top;
        ln_ttran        := j.JAQL406TTRAN;
        ln_tmod         := j.JAQL406TMOD;
        ln_tnrel        := j.JAQL406TNREL;
        ln_tord         := j.JAQL406TORD;
        ln_tsuc         := j.JAQL406TSUC;
        ln_tsbor        := j.JAQL406TSBOR;
        ln_pgcod        := j.JAQL406PGC;
        ln_papel        := j.JAQL406PAP;
        ln_nrocred      := j.CREDITO;
        ln_region       := j.region;
        Fecha_operacion := j.Fch_Desembolso;
      
        begin
          -- Estado del credito 
          select f.aostat
            into ln_scstat
            from fsd010 f
           where f.pgcod = ln_pgcod
             and f.aomod = ln_mod
             and f.aosuc = ln_suc
             and f.aomda = ln_mda
             and f.aopap = ln_papel
             and f.aocta = ln_cta
             and f.aooper = ln_oper
             and f.aosbop = ln_sbop
             and f.aotope = ln_tope
             and f.aofval = Fecha_operacion;
        exception
          when others then
            ln_scstat := 0;
        end;
      
        PQ_CR_CUPONESENLINEA.sp_cr_ChekTrabajador(ln_cta, lc_flgtrabajador);
        PQ_CR_CUPONESENLINEA.sp_cr_VerfDesmbPoC(ln_mod,
                                                ln_tope,
                                                lc_TipDesem);
      
        if lc_flgtrabajador = 'N' and lc_TipDesem = 'P' then
        
          pq_cr_cuponesenlinea.sp_cr_VerifGradoConsagui(j.jaql406cta,
                                                        lc_FlagFamiliar);
        
          if lc_FlagFamiliar = 'N' then
          
            PQ_CR_CUPONESENLINEA.sp_Excepciones(ln_mod,
                                                ln_suc,
                                                ln_mda,
                                                ln_cta,
                                                ln_oper,
                                                ln_sbop,
                                                ln_tope,
                                                ln_scstat,
                                                FlgInc);
          
            If FlgInc <> 'N' then
            
              begin
              
                select PETDOC, PENDOC, PEPAIS
                  into ln_tdoc, lc_tndoc, P_N_PAIS
                  from fsr008 f
                 where PGCOD = 1
                   and CTNRO = j.jaql406cta
                   AND f.cttfir = 'T';
              exception
                when others then
                  null;
                
              end;
              p_c_numdoc := trim(lc_tndoc);
            
              ln_Instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                                   v_Scsuc  => ln_suc,
                                                   v_Scmda  => ln_mda,
                                                   v_Scpap  => 0,
                                                   v_Sccta  => ln_cta,
                                                   v_Scoper => ln_oper,
                                                   v_Scsbop => ln_sbop,
                                                   v_Sctope => ln_tope);
            
              pq_cr_cuponesenlinea.sp_cr_SegmntLinea(ln_Instancia,
                                                     P_N_CODCAl,
                                                     P_C_DESCAL);
            
              PQ_CR_CUPONESENLINEA.sp_cr_nroopcionesdes(P_N_CODCAl,
                                                        ln_opcion,
                                                        FlagCl);
            
              If ln_opcion <> 0 and FlagCl <> 'N' then
              
                --  lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
              
                Begin
                  -- Tipo de DOC para la RCC
                  select a.tp1corr3
                    into lc_docsbs
                    from fst198 a
                   where a.tp1cod = 1
                     and a.tp1cod1 = 11111
                     and a.tp1corr1 = 1
                     and a.tp1corr2 = 3
                     and a.tp1nro1 = ln_tdoc;
                exception
                  when others then
                    lc_docsbs := 0;
                End;
              
                ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
              
                If FlgInc <> 'N' and ln_calific = 1 then
                
                  lc_Est   := 'S';
                  lc_Ant   := 'N';
                  lc_EXCUP := 'C';
                  ln_Atr   := 0;
                
                  ln_NUMP   := 0;
                  ln_CUPNUM := 1;
                
                  begin
                    select pgfape
                      into ld_fecha
                      from fst017
                     where pgcod = 1;
                  exception
                    when others then
                      null;
                    
                  end;
                
                  --if j.jaql406ttran = 951 and j.jaql406tmod = 30 then
                
                  lc_Tip := 'D';
                
                  PQ_CR_CUPONESENLINEA.sp_cr_verificajaql406(j.jaql406pgc,
                                                             j.JAQL406Mod,
                                                             j.JAQL406Suc,
                                                             j.JAQL406Mda,
                                                             j.JAQL406pap,
                                                             j.JAQL406Cta,
                                                             j.JAQL406Ope,
                                                             j.JAQL406Sbo,
                                                             j.JAQL406Top,
                                                             Fecha_operacion,
                                                             j.JAQL406tsbor,
                                                             j.JAQL406tord,
                                                             j.JAQL406tnrel,
                                                             j.JAQL406ttran,
                                                             j.JAQL406tmod,
                                                             j.JAQL406tsuc,
                                                             flag_exist);
                  if flag_exist <> 'S' then
                  
                    while i <= ln_opcion loop
                      PQ_CR_CUPONESENLINEA.sp_cr_inserta(SQ_CR_JAQL406_1.NEXTVAL,
                                                         j.JAQL406pgc,
                                                         j.JAQL406Mod,
                                                         j.JAQL406Suc,
                                                         j.JAQL406Mda,
                                                         j.JAQL406pap,
                                                         j.JAQL406Cta,
                                                         j.JAQL406Ope,
                                                         j.JAQL406Sbo,
                                                         j.JAQL406Top,
                                                         ln_nrocred,
                                                         ld_fecha,
                                                         Fecha_operacion,
                                                         lc_Est,
                                                         UPPER(pc_uing),
                                                         j.JAQL406Suc,
                                                         j.region,
                                                         lc_Ant,
                                                         ln_Atr,
                                                         ln_calific,
                                                         lc_Tip,
                                                         lc_EXCUP,
                                                         ln_tsbor,
                                                         j.JAQL406tord,
                                                         j.JAQL406tnrel,
                                                         j.JAQL406ttran,
                                                         j.JAQL406tmod,
                                                         j.JAQL406tsuc,
                                                         Fecha_operacion,
                                                         ln_NUMP,
                                                         ln_CUPNUM,
                                                         ln_opcion,
                                                         lc_TipDesem);
                      i := i + 1;
                    
                    end loop;
                  
                  End If;
                  i := 1;
                
                  -- End IF;
                
                End If;
              End If;
            End If;
          End If;
        
        else
          if lc_flgtrabajador = 'N' and lc_TipDesem = 'C' then
          
            pq_cr_cuponesenlinea.sp_cr_VerifGradoConsagui(j.jaql406cta,
                                                          lc_FlagFamiliar);
          
            if lc_FlagFamiliar = 'N' then
            
              if ln_mod <> 107 then
                PQ_CR_CUPONESENLINEA.sp_Excepciones(ln_mod,
                                                    ln_suc,
                                                    ln_mda,
                                                    ln_cta,
                                                    ln_oper,
                                                    ln_sbop,
                                                    ln_tope,
                                                    ln_scstat,
                                                    FlgInc);
              else
                FlgInc := 'S';
              end if;
            
              If FlgInc <> 'N' then
              
                begin
                
                  select PETDOC, PENDOC, PEPAIS
                    into ln_tdoc, lc_tndoc, P_N_PAIS
                    from fsr008 f
                   where PGCOD = 1
                     and CTNRO = j.jaql406cta
                     AND f.cttfir = 'T';
                exception
                  when others then
                    null;
                  
                end;
                p_c_numdoc := trim(lc_tndoc);
              
                begin
                  -- Nro de Cupones Desembolso Consumo
                  select tp1imp1
                    into ln_opcion
                    from fst198
                   where tp1cod = 1
                     and tp1cod1 = 10871
                     and tp1corr1 = 7
                     and tp1corr2 = 160
                     and tp1corr3 = 0
                     and tp1nro2 = 0
                     and tp1nro3 = 0;
                end;
              
                If ln_opcion <> 0 then
                
                  --  lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
                
                  Begin
                    -- Tipo de DOC para la RCC
                    select a.tp1corr3
                      into lc_docsbs
                      from fst198 a
                     where a.tp1cod = 1
                       and a.tp1cod1 = 11111
                       and a.tp1corr1 = 1
                       and a.tp1corr2 = 3
                       and a.tp1nro1 = ln_tdoc;
                  exception
                    when others then
                      lc_docsbs := 0;
                  End;
                
                  ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
                
                  If FlgInc <> 'N' and ln_calific = 1 then
                  
                    lc_Est   := 'S';
                    lc_Ant   := 'N';
                    lc_EXCUP := 'C';
                    ln_Atr   := 0;
                  
                    ln_NUMP   := 0;
                    ln_CUPNUM := 1;
                  
                    begin
                      select pgfape
                        into ld_fecha
                        from fst017
                       where pgcod = 1;
                    exception
                      when others then
                        null;
                      
                    end;
                  
                    --if j.jaql406ttran = 951 and j.jaql406tmod = 30 then
                  
                    lc_Tip := 'D';
                  
                    PQ_CR_CUPONESENLINEA.sp_cr_verificajaql406(j.jaql406pgc,
                                                               j.JAQL406Mod,
                                                               j.JAQL406Suc,
                                                               j.JAQL406Mda,
                                                               j.JAQL406pap,
                                                               j.JAQL406Cta,
                                                               j.JAQL406Ope,
                                                               j.JAQL406Sbo,
                                                               j.JAQL406Top,
                                                               Fecha_operacion,
                                                               j.JAQL406tsbor,
                                                               j.JAQL406tord,
                                                               j.JAQL406tnrel,
                                                               j.JAQL406ttran,
                                                               j.JAQL406tmod,
                                                               j.JAQL406tsuc,
                                                               flag_exist);
                    if flag_exist <> 'S' then
                    
                      while i <= ln_opcion loop
                        PQ_CR_CUPONESENLINEA.sp_cr_inserta(SQ_CR_JAQL406_1.NEXTVAL,
                                                           j.JAQL406pgc,
                                                           j.JAQL406Mod,
                                                           j.JAQL406Suc,
                                                           j.JAQL406Mda,
                                                           j.JAQL406pap,
                                                           j.JAQL406Cta,
                                                           j.JAQL406Ope,
                                                           j.JAQL406Sbo,
                                                           j.JAQL406Top,
                                                           ln_nrocred,
                                                           ld_fecha,
                                                           Fecha_operacion,
                                                           lc_Est,
                                                           UPPER(pc_uing),
                                                           j.JAQL406Suc,
                                                           j.region,
                                                           lc_Ant,
                                                           ln_Atr,
                                                           ln_calific,
                                                           lc_Tip,
                                                           lc_EXCUP,
                                                           ln_tsbor,
                                                           j.JAQL406tord,
                                                           j.JAQL406tnrel,
                                                           j.JAQL406ttran,
                                                           j.JAQL406tmod,
                                                           j.JAQL406tsuc,
                                                           Fecha_operacion,
                                                           ln_NUMP,
                                                           ln_CUPNUM,
                                                           ln_opcion,
                                                           lc_TipDesem);
                        i := i + 1;
                      
                      end loop;
                    
                    End If;
                    i := 1;
                  
                    -- End IF;
                  
                  End If;
                End If;
              End If;
            End If;
          End If;
        End If;
      End loop;
    End If;
  
  end sp_cr_Desembolsos;
  --------------------------------------------------------------
  procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2) is
  
    lc_Usuario       char(30);
    ln_SegLinea      number;
    ln_pae70nro      number;
    P_N_PAIS         number;
    p_n_tipdoc       number;
    p_c_numdoc       char(12);
    lc_UltSegmnLinea varchar2(30);
  
  begin
  
    begin
      select wfitemusrcod
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wftaskcod = 3
         and w.wfiteminit =
             (select max(r.wfiteminit)
                from wfwrkitems r
               where r.wfinsprcid = w.wfinsprcid
                 and r.wftaskcod = w.wftaskcod);
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into P_N_PAIS, p_n_tipdoc, p_c_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia
         and s.sng001emp = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select b.segcod
        into ln_SegLinea
        from sngc60 a, sngc07 b
       where a.sngc60pais = P_N_PAIS
         and a.sngc60tdoc = p_n_tipdoc
         and a.sngc60ndoc = p_c_numdoc
         and a.sngc60ocup = b.sngc07cod;
    exception
      when too_many_rows then
        begin
          select b.segcod
            into ln_SegLinea
            from sngc60 a, sngc07 b
           where a.sngc60pais = P_N_PAIS
             and a.sngc60tdoc = p_n_tipdoc
             and a.sngc60ndoc = p_c_numdoc
             and a.sngc60ocup = b.sngc07cod
             and a.sngc60corr =
                 (select max(a.sngc60corr)
                    from sngc60 a, sngc07 b
                   where a.sngc60pais = P_N_PAIS
                     and a.sngc60tdoc = p_n_tipdoc
                     and a.sngc60ndoc = p_c_numdoc
                     and a.sngc60ocup = b.sngc07cod);
        
        end;
      when no_data_found then
        null;
    end;
  
    if p_n_tipdoc = 9 then
      ln_SegLinea := 1;
    end if;
  
    begin
    
      select max(f.pae70nro)
        into ln_pae70nro
        from fpae70 f
       where f.pae70ins = ln_Instancia
         and f.pae70usr = lc_Usuario
         and f.pae51eva = 1
         and f.pae70nro = (select max(g.pae70nro)
                             from fpae70 g
                            where g.pae70ins = f.pae70ins
                              and g.pae70usr = f.pae70usr
                              and g.pae51eva = f.pae51eva);
    exception
      when others then
        null;
    end;
  
    if ln_SegLinea = 1 then
      begin
        select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                              '[0-9]',
                                                              '')),
                                              ':',
                                              '')),
                                     '/',
                                     '')),
                            '.',
                            ''))
          into lc_UltSegmnLinea
          from fpae71 h
         where h.pae51eva = 1
           and h.pae70nro = ln_pae70nro
           and h.pae71ite = 380; --PYME
      exception
        when others then
          null;
      end;
    else
      if ln_SegLinea = 2 then
      
        begin
          select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                                '[0-9]',
                                                                '')),
                                                ':',
                                                '')),
                                       '/',
                                       '')),
                              '.',
                              ''))
            into lc_UltSegmnLinea
            from fpae71 h
           where h.pae51eva = 1
             and h.pae70nro = ln_pae70nro
             and h.pae71ite = 443; -- CONSUMO
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
    begin
      select tp1nro1, tp1desc
        into P_N_CODCAl, P_C_DESCAL
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 2
         and Tp1corr2 = 7
         and tp1nro1 >= 22
         and trim(tp1desc) = TRIM(lc_UltSegmnLinea);
    exception
      when others then
        null;
    end;
  
    begin
      select c1.jaqy067ncal
        into P_C_DESCAL
        from jaqy067 c1
       where c1.jaqy067ccal = P_N_CODCAl;
    exception
      when no_data_found then
        If P_N_CODCAl = 0 then
          P_C_DESCAL := 'SIN CALIFICACION';
        Else
          P_C_DESCAL := 'NO DEFINIDA';
        End If;
    end;
  
  end sp_cr_SegmntLinea;
  ---------------------------------------------------------------
  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2) is
  
    -- lc_flgtrabajador :='N';
  
  begin
    lc_flgtrabajador := 'N';
    begin
      select 'S'
        into lc_flgtrabajador
        from fsd002 d, fsr008 s
       where d.pfebco = 'S'
         and d.pfpais = s.pepais
         and d.pftdoc = s.petdoc
         and d.pfndoc = s.pendoc
         and s.cttfir = 'T'
         and s.ctnro = ln_cta;
    exception
      when others then
        lc_flgtrabajador := 'N';
      
    end;
  
  end sp_cr_ChekTrabajador;

  --------------------------------------------------------------------
  procedure sp_cr_VerifGradoConsagui(ln_NroCuenta    in number,
                                     lc_FlafFamiliar out varchar2) is
  
    ln_pais   number;
    ln_tipdoc number;
    ln_nrodoc varchar2(12);
  
  begin
    lc_FlafFamiliar := 'N';
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tipdoc, ln_nrodoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_NroCuenta
         and f.cttfir = 'T';
    exception
      when others then
        ln_pais   := 0;
        ln_tipdoc := 0;
        ln_nrodoc := null;
    end;
  
    --- Verificamos el Grados de Consaguinidad 1er y 2do Grado
    begin
      select 'S'
        into lc_FlafFamiliar
        from fsr002 f, FSD002 d
       WHERE f.rppais = ln_pais
         and f.rptdoc = ln_tipdoc
         and f.rpndoc = ln_nrodoc
         and f.rpccyg in (select tp1nro3
                            from fst198
                           where tp1cod = 1
                             and tp1cod1 = 10871
                             and tp1corr1 = 7
                             and tp1corr2 = 151
                             and tp1corr3 > 0)
         and d.pfpais = f.pepais
         and d.pftdoc = f.petdoc
         and d.pfndoc = f.pendoc
         and d.pfebco = 'S';
    exception
      when others then
        lc_FlafFamiliar := 'N';
    end;
  
    if lc_FlafFamiliar = 'N' then
    
      begin
        select 'S'
          into lc_FlafFamiliar
          from fsr002 f, FSD002 d
         WHERE f.pepais = ln_pais
           and f.petdoc = ln_tipdoc
           and f.pendoc = ln_nrodoc
           and f.rpccyg in (select tp1nro3
                              from fst198
                             where tp1cod = 1
                               and tp1cod1 = 10871
                               and tp1corr1 = 7
                               and tp1corr2 = 151
                               and tp1corr3 > 0)
           and d.pfpais = f.rppais
           and d.pftdoc = f.rptdoc
           and d.pfndoc = f.rpndoc
           and d.pfebco = 'S';
      exception
        when others then
          lc_FlafFamiliar := 'N';
      end;
    end if;
  
  end sp_cr_VerifGradoConsagui;
  ---------------------------------------------------------------------

  Procedure sp_cr_excepcionTrans(ln_tmod       in number,
                                 ln_ttran      in number,
                                 flag_Exptrans out varchar2) is
  
  begin
    flag_Exptrans := 'N';
  
    begin
    
      select 'S'
        into flag_Exptrans
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10871
         and tp1corr1 = 7
         and tp1corr2 = 10
         and tp1nro2 = ln_tmod
         and tp1nro3 = ln_ttran;
    exception
      when others then
        flag_Exptrans := 'N';
      
    end;
  
  End sp_cr_excepcionTrans;

  ---------------------------------------------------------------------

  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           --ln_scrub1  in number,
                           ln_scstat1 in number,
                           FlgIncl    out varchar2) is
  
    ln_modulo number;
    ln_cta    number;
    ln_oper   number;
    ln_sboper number;
    ln_sucur  number;
    ln_mda    number;
    ln_tipoer number;
  
  Begin
    Begin
    
      FlgIncl := 'S';
    
      If modulo = 108 And ittope = 1 then
        ---créditos prendarios
        FlgIncl := 'N';
      Else
        If modulo = 200 then
          --créditos judiciales
          FlgIncl := 'N';
          --créditos administrativos
        Else
        
          If modulo = 106 And (ittope = 30 Or ittope = 31) then
            FlgIncl := 'N';
            --consumo para trabajadores -- Tipos de Operacion de Trabajador CMAC Arequipa.
          Else
            If modulo = 106 And (ittope = 10 Or ittope = 11 Or ittope = 32 Or
               ittope = 33 Or ittope = 34) then
              FlgIncl := 'N';
              --créditos hipotecarios para trabajadores c/cts s/cts -- Tipos de Operacion de Trabajador CMAC Arequipa.
            Else
              If modulo = 110 And
                 (ittope = 20 Or ittope = 21 Or ittope = 22 Or ittope = 23 Or
                 ittope = 24 Or ittope = 25 Or ittope = 26 Or ittope = 27 Or
                 ittope = 84 Or ittope = 85 Or ittope = 86 Or ittope = 87 or
                 ittope = 101) then
                FlgIncl := 'N';
              
                --créditos consumo convenios
              Else
                If /*Scgru = 3 And*/
                 modulo = 107 then
                  FlgIncl := 'N';
                Else
                  --créditos refinanciados, pj
                  If ln_scstat1 IN (61, 33, 34, 21, 22, 23, 25, 64, 90) then
                    FlgIncl := 'N';
                    --creditos Vehicular Nvo Trabajador c/CTS  ---Tipos de Operacion de Trabajador CMAC Arequipa.
                  Else
                    If modulo = 112 And (ittope = 65 Or ittope = 66 Or
                       ittope = 70 Or ittope = 71) then
                      FlgIncl := 'N';
                    else
                      If modulo = 103 And (ittope = 50 Or ittope = 51) then
                        FlgIncl := 'N';
                      else
                        If modulo = 116 And
                           (ittope = 16 Or ittope = 17 Or ittope = 18) then
                          FlgIncl := 'N';
                        End If;
                      End If;
                    End If;
                  End If;
                End If;
              End If;
            End If;
          End If;
        End If;
      End If;
    
      If FlgIncl = 'S' then
      
        --créditos reprogramados 
        begin
          select 'N' --distinct R2cta
            into FlgIncl
            from FSR011
           Where R1cod = 1
             and R1mod = modulo
             and R1suc = ln_suc1
             and R1mda = ln_mda1
             and R1pap = 0
             and R1cta = ln_cta1
             and R1oper = ln_oper1
             and R1sbop = ln_sbop1
             and R1tope = ittope
             and Relcod in (860, 870, 890) --Reprog. Cambio de Fecha-860 / Reprog. Desastres Naturales-870
             and R2mod = modulo
             and rownum = 1;
          -- FlgIncl := 'N';
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
        end;
      
      End If;
    
      If FlgIncl = 'S' then
      
        If FlgIncl = 'S' then
        
          if modulo = 116 then
          
            begin
            
              select f.r2mod,
                     f.r2cta,
                     f.r2oper,
                     f.r2sbop,
                     f.r2suc,
                     f.r2mda,
                     f.r2tope
                into ln_modulo,
                     ln_cta,
                     ln_oper,
                     ln_sboper,
                     ln_sucur,
                     ln_mda,
                     ln_tipoer
                from fsr011 f
               where f.r1cod = 1
                 and f.r1mod = modulo
                 and f.r1suc = ln_suc1
                 and f.r1mda = ln_mda1
                 and f.r1pap = 0
                 and f.r1cta = ln_cta1
                 and f.r1oper = ln_oper1
                 and f.r1sbop = ln_sbop1
                 and f.r1tope = ittope
                 and f.relcod = 46;
            
            end;
          
            begin
              Select 'N'
                into FlgIncl
                from fsr011 a, fsr011 b
               where a.relcod = 50
                 and a.r1cod = 1
                 and a.r1mod = ln_modulo
                 and a.r1suc = ln_sucur
                 and a.r1mda = ln_mda
                 and a.r1pap = 0
                 and a.r1cta = ln_cta
                 and a.r1oper = ln_oper
                 and a.r1sbop = ln_sboper
                 and a.r1tope = ln_tipoer
                 and b.r2cta = a.r2cta
                 and b.r2oper = a.r2oper
                 and b.r2sbop = a.r2sbop
                 and b.relcod in (2, 25)
                 and a.r011co = 'S'
                 and b.r011co = 'S'
                 and rownum = 1;
            exception
              when no_data_found then
                -- ln_rcta := 0;
                FlgIncl := 'S';
              
            end;
          
          else
            if modulo <> 116 then
            
              begin
                --créditos con garantía de plazo fijo o cts
              
                Select 'N'
                  into FlgIncl
                  from fsr011 a, fsr011 b
                 where a.relcod = 50
                   and a.r1cod = 1
                   and a.r1mod = modulo
                   and a.r1suc = ln_suc1
                   and a.r1mda = ln_mda1
                   and a.r1pap = 0
                   and a.r1cta = ln_cta1
                   and a.r1oper = ln_oper1
                   and a.r1sbop = ln_sbop1
                   and a.r1tope = ittope
                   and b.r2cta = a.r2cta
                   and b.r2oper = a.r2oper
                   and b.r2sbop = a.r2sbop
                   and b.relcod in (2, 25)
                   and a.r011co = 'S'
                   and b.r011co = 'S'
                   and rownum = 1;
              exception
                when no_data_found then
                  -- ln_rcta := 0;
                  FlgIncl := 'S';
              end;
            End If;
          
          end if;
        end if;
      End If;
    
    End;
  end sp_Excepciones;

  ----------------------------------------------------------------
  procedure sp_cr_VerfDesmbPoC(ln_Modulo   in number,
                               ln_TipOper  in number,
                               lc_TipDesem out varchar2) is
  begin
    lc_TipDesem := 'N';
  
    begin
      -- Verifica Consumo Permitidos
      select 'C'
        into lc_TipDesem
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10871
         and tp1corr1 = 7
         and tp1corr2 = 160
         and tp1corr3 > 0
         and tp1nro2 = ln_Modulo
         and tp1nro3 = ln_TipOper
         and tp1imp1 = 1;
    exception
      when others then
        lc_TipDesem := 'N';
    end;
  
    if lc_TipDesem = 'N' then
    
      begin
        -- Verifica  Pyme Permitidos
        select 'P'
          into lc_TipDesem
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10871
           and tp1corr1 = 7
           and tp1corr2 = 161
           and tp1corr3 > 0
           and tp1nro2 = ln_Modulo
           and tp1nro3 = ln_TipOper
           and tp1imp1 = 1;
      exception
        when others then
          lc_TipDesem := 'N';
      end;
    end if;
  
  end sp_cr_VerfDesmbPoC;

  -----------------------------------------------------------------
  procedure sp_cr_verificaferiado(ln_diastraso in number,
                                  ln_sucursal  in number,
                                  ld_fecha     in date,
                                  Flag_habil   out varchar2) is
    ln_calcod number;
  begin
  
    Flag_habil := 'S';
  
    begin
      select f.calcod
        into ln_calcod
        from fst001 f
       where f.pgcod = 1
         and f.sucurs = ln_sucursal;
    exception
      when others then
        null;
    end;
  
    begin
    
      If ln_diastraso = 1 then
        begin
          select Fhabil
            into Flag_habil
            from FST028
           where calcod = ln_calcod
             and ffecha = ld_fecha;
        exception
          when others then
            Flag_habil := 'S';
        end;
      
      Else
        If ln_diastraso = 2 then
          begin
            select Fhabil
              into Flag_habil
              from FST028
             where calcod = ln_calcod
               and ffecha = ld_fecha;
          exception
            when others then
              Flag_habil := 'S';
          end;
        
          If Flag_habil = 'N' then
            --//DIA FERIADO -verificar si el siguiente dia tambien fue feriado
            begin
              select Fhabil
                into Flag_habil
                from FST028
               where calcod = ln_calcod
                 and ffecha = ld_fecha + 1;
            end;
          end if;
        
        Else
          If ln_diastraso = 3 then
            begin
              select Fhabil
                into Flag_habil
                from FST028
               where calcod = ln_calcod
                 and ffecha = ld_fecha;
            exception
              when others then
                Flag_habil := 'S';
            end;
          
            If Flag_habil = 'N' then
              --//DIA FERIADO -verificar si el siguiente dia tambien fue feriado
              begin
                select Fhabil
                  into Flag_habil
                  from FST028
                 where calcod = ln_calcod
                   and ffecha = ld_fecha + 1;
              end;
              If Flag_habil = 'N' then
                --//DIA FERIADO -verificar si el siguiente dia tambien fue feriado
                begin
                  select Fhabil
                    into Flag_habil
                    from FST028
                   where calcod = ln_calcod
                     and ffecha = ld_fecha + 2;
                end;
              
              end if;
            
            end if;
          else
            If ln_diastraso = 4 then
              begin
                select Fhabil
                  into Flag_habil
                  from FST028
                 where calcod = ln_calcod
                   and ffecha = ld_fecha;
              exception
                when others then
                  Flag_habil := 'S';
              end;
              If Flag_habil = 'N' then
                --//DIA FERIADO -verificar si dia anterior tambien fue feriado
                begin
                  select Fhabil
                    into Flag_habil
                    from FST028
                   where calcod = ln_calcod
                     and ffecha = ld_fecha + 1;
                end;
                If Flag_habil = 'N' then
                  --//DIA FERIADO -verificar si dia anterior tambien fue feriado
                  begin
                    select Fhabil
                      into Flag_habil
                      from FST028
                     where calcod = ln_calcod
                       and ffecha = ld_fecha + 2;
                  end;
                  If Flag_habil = 'N' then
                    --//DIA FERIADO -verificar si dia anterior tambien fue feriado
                    begin
                      select Fhabil
                        into Flag_habil
                        from FST028
                       where calcod = ln_calcod
                         and ffecha = ld_fecha + 3;
                    end;
                  end if;
                end if;
              end if;
            
            end if;
          
          end if;
        
        end if;
      end if;
    end;
  end sp_cr_verificaferiado;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number is
  
    ln_FchSBS  number(8);
    D_FECPRE   varchar2(15);
    ln_dia     number(2);
    ln_Mes     number(2);
    ln_Anio    number(4);
    JAQY774Cal number(10);
    ln_cal0    number(5, 2);
    ln_cal1    number(5, 2);
    ln_cal2    number(5, 2);
    ln_cal3    number(5, 2);
    ln_cal4    number(5, 2);
    D_FECPRE1  date;
    PNDOC      char(12);
    PNDOC1     varchar2(12);
  
  Begin
    Begin
      Begin
        select Tpnro
          into ln_FchSBS
          from FST098
         Where Pgcod = 1
           and Tpcod = 7647
           and Tpcorr = 12;
      
        ln_dia  := SubStr(ln_FchSBS, 1, 2);
        ln_Mes  := SubStr(ln_FchSBS, 3, 2);
        ln_Anio := SubStr(ln_FchSBS, 5, 4);
      
        D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
        D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
      
        PNDOC  := rpad(lc_tndoc, 12, ' ');
        PNDOC1 := trim(PNDOC);
      
        select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
        
          into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
          from CLDRCCI
         where D_FECPRE = D_FECPRE1
           and C_TDOCID = lc_docsbs
           and C_DOCIDE = PNDOC1; --trim(PNDOC); --lc_tndoc;
      exception
        when too_many_rows then
          begin
            select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
              into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
              from CLDRCCI
             where D_FECPRE = D_FECPRE1
               and C_TDOCID = lc_docsbs
               and C_DOCIDE = PNDOC
               and C_PERSON = 1
               and N_CALIF0 <> 0
               and rownum = 1;
          
          exception
          
            when no_data_found then
              ln_cal0 := 0;
              ln_cal1 := 0;
              ln_cal2 := 0;
              ln_cal3 := 0;
              ln_cal4 := 0;
          end;
        
        when no_data_found then
          ln_cal0 := 0;
          ln_cal1 := 0;
          ln_cal2 := 0;
          ln_cal3 := 0;
          ln_cal4 := 0;
        
      end;
    
      If ln_cal0 > 0 and ln_cal1 = 0 and ln_cal2 = 0 and ln_cal3 = 0 and
         ln_cal4 = 0 then
        JAQY774Cal := 1;
      else
        if ln_cal0 = 0 and ln_cal1 = 0 and ln_cal2 = 0 and ln_cal3 = 0 and
           ln_cal4 = 0 then
          JAQY774Cal := 1;
        End If;
      End If;
    
    End;
  
    return JAQY774Cal;
  
  end fn_Calif_SBS_Cliente;

  ---------------------------------------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2) is
  
  begin
    begin
      select 'S'
        INTO flag_exist
        from jaql406 j
       where j.JAQL406PGC = ln_pgcod
         and j.JAQL406MOD = ln_modulo
         and j.JAQL406SUC = ln_sucursal
         and j.JAQL406MDA = ln_moneda
         and j.JAQL406PAp = ln_papel
         and j.JAQL406CTA = ln_cuenta
         and j.JAQL406OPE = ln_operacion
         and j.JAQL406SBO = ln_subope
         and j.JAQL406TOP = ln_tope
         and j.JAQL406Fcta = pd_fecha
         and j.jaql406tsbor = JAQL406tsbor
         and j.jaql406tord = JAQL406tord
         and j.jaql406tnrel = JAQL406tnrel
         and j.jaql406ttran = JAQL406ttran
         and j.jaql406tmod = JAQL406tmod
         and j.jaql406tsuc = JAQL406tsuc
         and j.jaql406excup = 'C'
         and rownum = 1;
    
    exception
      when others then
        flag_exist := 'N';
    end;
  
  end sp_cr_verificajaql406;
  ---------------------------------------------------------------------------
  procedure sp_cr_nroopcionesdes(P_N_CODCAl in number,
                                 ln_opcion  out number,
                                 FlagCl     out varchar2) is
  
  begin
    FlagCl := 'N';
    begin
    
      select Tp1nro3, 'S'
        into ln_opcion, FlagCl
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 7
         and Tp1nro2 = P_N_CODCAl;
    exception
      when others then
        ln_opcion := 0;
      
    end;
  
  end sp_cr_nroopcionesdes;

  -------------------------------------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number,
                          LC_TipCredPC  in varchar2) is
  begin
    begin
      insert into JAQL406
        (JAQL406Cup,
         JAQL406PGC,
         JAQL406Mod,
         JAQL406Suc,
         JAQL406Mda,
         JAQL406PAP,
         JAQL406Cta,
         JAQL406Ope,
         JAQL406Sbo,
         JAQL406Top,
         JAQL406CRE,
         JAQL406FEC,
         JAQL406FOP,
         JAQL406EST,
         JAQL406USR,
         JAQL406AGE,
         JAQL406DPT,
         JAQL406ANT,
         JAQL406ATR,
         JAQL406CAL,
         JAQL406TIP,
         JAQL406EXCUP,
         JAQL406TSBOR,
         JAQL406TORD,
         JAQL406TNREL,
         JAQL406TTRAN,
         JAQL406TMOD,
         JAQL406TSUC,
         JAQL406FCTA,
         JAQL406NUMP,
         JAQL406CUPNUM,
         JAQL406OPC,
         jaql406TipCredPC)
      values
        (nro_cupon,
         ln_pgcod,
         ln_modulo,
         ln_sucursal,
         ln_moneda,
         ln_papel,
         ln_cuenta,
         ln_operacion,
         ln_subope,
         ln_tope,
         ln_nrocred,
         ld_fecha1,
         pd_fecha,
         lc_Est,
         lc_usuario,
         ln_sucusuario,
         lc_region,
         lc_Ant,
         ln_Atr,
         ln_calific,
         lc_Tip,
         lc_EXCUP,
         JAQL406tsbor,
         JAQL406tord,
         JAQL406tnrel,
         JAQL406ttran,
         JAQL406tmod,
         JAQL406tsuc,
         ld_fecha2,
         ln_NUMP,
         ln_CUPNUM,
         ln_opcion,
         LC_TipCredPC);
    End;
    COMMIT;
  
  end sp_cr_inserta;

  --------------------------------------------------------------------------

  procedure sp_cr_AnulaCupon(PPgcod  in number,
                             Pitmod  in number,
                             PItsuc  in number,
                             PIttran in number,
                             PItnrel in number,
                             PItord  in number,
                             PItsbor in number) is
  
    ld_fchSist     date;
    ModAnu         number;
    ln_NroRelacion number;
  begin
  
    begin
    
      select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
    
    end;
    begin
    
      select to_number(Txtext)
        into ln_NroRelacion
        from FSX015
       Where PgCod = PPgcod
         and Hcmod = Pitmod
         and Hsucor = PItsuc
         and Htran = PIttran
         and Hnrel = PItnrel
         and Hfcon = ld_fchSist
         and Txcod = 0
         and Txreng = 1;
    
    end;
    ModAnu := Pitmod - 500;
  
    begin
    
      update jaql406
         set JAQL406ExCup = 'E'
       where JAQL406Pgc = PPgcod
         and JAQL406Tsuc = PItsuc
         and JAQL406Tmod = ModAnu
         and JAQL406Ttran = PIttran
         and JAQL406Tnrel = ln_NroRelacion
         and JAQL406Fop = ld_fchSist
         and JAQL406Tord = PItord
            -- and JAQL406Tsbor = PItsbor
         and JAQL406ExCup = 'C';
      commit;
    end;
  
  end sp_cr_AnulaCupon;
  ------------------------------------------------------------------------------
  procedure sp_cr_ImpresionCupon(Pitmod         in number,
                                 PItsuc         in number,
                                 PIttran        in number,
                                 PItnrel        in number,
                                 PItord         in number,
                                 ln_NroOpciones out number) is
  
    ld_fchSist date;
  begin
  
    begin
      select pgfape into ld_fchSist from fst017 where pgcod = 1;
    end;
  
    begin
      select count(*)
        into ln_NroOpciones
        from jaql406 j
       where j.jaql406tord = PItord
         and j.jaql406tnrel = PItnrel
         and j.jaql406ttran = PIttran
         and j.jaql406tmod = Pitmod
         and j.jaql406tsuc = PItsuc
         and j.jaql406fop = ld_fchSist
         and j.jaql406excup = 'C';
    exception
      when others then
        ln_NroOpciones := 0;
    end;
  
  end sp_cr_ImpresionCupon;

end PQ_CR_CUPONESENLINEA;
/

