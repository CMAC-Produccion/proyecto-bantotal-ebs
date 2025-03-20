create or replace package PQ_CR_NAVIDAD2017 is

  -- Author  : MPOSTIGOC
  -- Created : 18/09/2017 08:50:19 a.m.
  -- Purpose : Campaña Navidad 2017 Ticket en Ventanilla

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
  -------------------------------------------------------------------                                 
  Procedure sp_cr_excepcionTrans(ln_tmod       in number,
                                 ln_ttran      in number,
                                 flag_Exptrans out varchar2);
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
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
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
                          ln_opcion     in number);

  ---------------------------------------------------------------
  procedure sp_cr_AnulaRegNvdd2017(PPgcod  in number,
                                   Pitmod  in number,
                                   PItsuc  in number,
                                   PIttran in number,
                                   PItnrel in number,
                                   PItord  in number,
                                   PItsbor in number);

end PQ_CR_NAVIDAD2017;
/

create or replace package body PQ_CR_NAVIDAD2017 is

  procedure sp_cr_inicio(ln_trItsuc  in number,
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
  
  begin
  
    begin
    
      select pgfape into ld_fechatrans from fst017 where pgcod = 1;
    end;
  
    Begin
      --************************** cambiar formato ******************
      select to_date('0' || Tp1nro1 || '/' || Tp1nro2 || '/' || Tp1nro3,
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
        
          pq_cr_navidad2017.sp_cr_ChekTrabajador(i.jaql406cta,
                                                 lc_flgtrabajador);
        
          if lc_flgtrabajador = 'N' then
          
            pq_Cr_navidad2017.sp_cr_excepcionTrans(i.jaql406tmod,
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
            
              pq_cr_navidad2017.sp_Excepciones(i.jaql406mod,
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
                
                  pq_cr_navidad2017.sp_cr_verificaferiado(diasatraso,
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
              
                lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
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
                
                  PQ_CR_NAVIDAD2017.sp_cr_verificajaql406(i.JAQL406pgc,
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
                    
                      PQ_CR_NAVIDAD2016_REGULA.sp_cr_inserta(SQ_CR_JAQL406_1.NEXTVAL,
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
                                                             ln_opcion);
                    
                      l := l + 1;
                    
                    end loop;
                  end if;
                end if;
              
              end if;
            
            end if;
          
          end if;
        end if;
      
      end loop;
    
    End If;
  
  end sp_cr_inicio;
  ----------------------------------------------------------------
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
         and s.ctnro = ln_cta;
    exception
      when others then
        lc_flgtrabajador := 'N';
      
    end;
  
  end sp_cr_ChekTrabajador;
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
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
    C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
    
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
    
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
    
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
    
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
    End;
    return C_TDOCID;
  end fn_Tipo_Doc_SBS;
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
      
        /*if LD_FCHPAGO >= '27/09/2016' and LD_FCHPAGO <= '21/10/2016' then
        
          D_FECPRE1 := '31/08/2016';
        else
          if LD_FCHPAGO >= '22/10/2016' and LD_FCHPAGO <= '21/11/2016' then
          
            D_FECPRE1 := '30/09/2016';
          else
            if LD_FCHPAGO >= '22/11/2016' and LD_FCHPAGO <= '24/12/2016' then
            
              D_FECPRE1 := '31/10/2016';
            else
              if LD_FCHPAGO >= '25/12/2016' and LD_FCHPAGO <= '31/12/2016' then
              
                D_FECPRE1 := '30/11/2016';
              end if;
            end if;
          end if;
        end if;*/
      
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
                          ln_opcion     in number) is
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
         JAQL406OPC)
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
         ln_opcion);
    End;
    COMMIT;
  
  end sp_cr_inserta;

  --------------------------------------------------------------------------

  procedure sp_cr_AnulaRegNvdd2017(PPgcod  in number,
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
         and JAQL406Tsbor = PItsbor
         and JAQL406ExCup = 'C';
      commit;
    end;
  
  end sp_cr_AnulaRegNvdd2017;

end PQ_CR_NAVIDAD2017;
/

