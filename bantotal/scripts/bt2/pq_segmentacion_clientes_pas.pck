create or replace package PQ_SEGMENTACION_CLIENTES_PAS is

  procedure inicio(TipoSeg number, Hoy date, Tcbio number);

  procedure sp_posiciona(vpgcod   number,
                         TDcd     number,
                         TDch     number,
                         TNcd     varchar2,
                         TNch     varchar2,
                         TipoSeg  number,
                         Hoy      date,
                         Tcbio    number,
                         Pbthread number);

  procedure sp_posiciona2(vpgcod  number,
                          TDcd    number,
                          TDch    number,
                          TNcd    varchar2,
                          TNch    varchar2,
                          TipoSeg number,
                          --Hoy      date,
                          HoyC char,
                          --Tcbio    number,
                          TcbioC   varchar2,
                          Pbthread number);

  procedure sp_saldo(vpgcod  number,
                     vScsuc  number,
                     vSccta  number,
                     vScmda  number,
                     vScpap  number,
                     vScoper number,
                     vScsbop number,
                     vSctope number,
                     vScmod  number,
                     vRubro  number,
                     Hoy     date,
                     vscsdo  out number);

  procedure sp_tasa(vpgcod  number,
                    vScsuc  number,
                    vSccta  number,
                    vScmda  number,
                    vScpap  number,
                    vScoper number,
                    vScsbop number,
                    vSctope number,
                    vScmod  number,
                    tasa    out number);

  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob VARCHAR2,
                                pi_vc2_nomusr VARCHAR2) RETURN NUMBER;

  procedure sp_posiciona_persona(vpgcod  number,
                                 vPepais number,
                                 vPetdoc number,
                                 vPendoc char,
                                 TipoSeg number,
                                 Hoy     date,
                                 Tcbio   number);

  procedure Fecha_Antig(vpgcod  number,
                        vpepais number,
                        vpetdoc number,
                        vpendoc char,
                        --vtipo   number,
                        vFecAnt out date);

  procedure sp_saldo_2(vpgcod  number,
                       vScsuc  number,
                       vSccta  number,
                       vScmda  number,
                       vScpap  number,
                       vScoper number,
                       vScsbop number,
                       vSctope number,
                       vScmod  number,
                       vRubro  number,
                       Hoy     date,
                       vscsdo  out number);
  procedure sp_tasa_grupo(vpgcod number,
                          vScmda number,
                          vscsdo number,
                          Hoy    date,
                          vPzo   number,
                          tgcod  number,
                          grnro  number,
                          tasa   out number);
end PQ_SEGMENTACION_CLIENTES_PAS;
/

CREATE OR REPLACE package BODY PQ_SEGMENTACION_CLIENTES_PAS is

  procedure inicio(TipoSeg number, Hoy date, Tcbio number) is
  
    cursor doc is
      select *
        from fsr101
       where pbnsec = 601 /*
                                                                                                  and pbthread in (61)*/
      ;
  
    TNcd varchar2(8);
    TNch varchar2(8);
  
  begin
    for i in doc loop
    
      If i.pbd1 = 21 then
        if i.pbd2 = 0 then
          TNcd := lpad(i.pbd2, 8, '0');
        else
          TNcd := lpad(i.pbd2 - 1, 8, '0');
        end if;
      
        if i.pbh2 = 99999999 then
          TNch := lpad(i.pbh2, 8, '0');
        else
          TNch := lpad(i.pbh2 + 1, 8, '0');
        end if;
      
      else
        TNcd := '0';
        TNch := '0';
      End If;
    
      sp_posiciona(i.pbcod,
                   i.pbd1,
                   i.pbh1,
                   TNcd,
                   TNch,
                   TipoSeg,
                   Hoy,
                   Tcbio,
                   i.pbthread);
    end loop;
  end;

  -----------------------------------------------------------

  procedure sp_posiciona(vpgcod   number,
                         TDcd     number,
                         TDch     number,
                         TNcd     varchar2,
                         TNch     varchar2,
                         TipoSeg  number,
                         Hoy      date,
                         Tcbio    number,
                         Pbthread number) is
    hoyC               char(8);
    TcbioC             varchar2(15);
  begin
  
    hoyC          := to_char(hoy, 'ddmmyyyy');
    TcbioC        := replace(to_char(Tcbio), ',', '.');

  
    pq_segmentacion_clientes_pas.sp_posiciona2(vpgcod   => vpgcod,
                                               tdcd     => tdcd,
                                               tdch     => tdch,
                                               tncd     => tncd,
                                               tnch     => tnch,
                                               tiposeg  => tiposeg,
                                               hoyc     => hoyc,
                                               tcbioc   => tcbioc,
                                               pbthread => pbthread);
  

  
  end sp_posiciona;

  ------------------------------------------------------------------------  
  procedure sp_posiciona2(vpgcod   number,
                          TDcd     number,
                          TDch     number,
                          TNcd     varchar2,
                          TNch     varchar2,
                          TipoSeg  number,
                          HoyC     char,
                          TcbioC   varchar2,
                          Pbthread number) is
  
    cursor clientes is
    
      select *
        from fsd001
       Where Pepais >= 1
         and Pepais <= 999
         and Petdoc >= TDcd
         and Petdoc <= TDch
         and Pendoc >= decode(TNcd, '0', Pendoc, TNcd)
         and Pendoc <= decode(TNch, '0', Pendoc, TNch);
  
    cursor cuentas(v1pepais number, v1petdoc number, v1Pendoc char) is
      select Scsuc,
             Sccta,
             Scmda,
             Scpap,
             Scoper,
             Scsbop,
             Sctope,
             Scmod,
             Scrub Rubro
        from fsd011 x, fsr008 y
       where x.pgcod = vpgcod
         and x.sccta = y.ctnro
         and y.Ttcod = 1
         and y.cttfir = 'T'
         and x.scmod = 21
         and y.pepais = v1pepais
         and y.petdoc = v1petdoc
         and y.pendoc = v1pendoc
         and x.scstat <> 99
         and y.pgcod = vpgcod;

  
    VPepais     fsd001.Pepais%type;
    VPetdoc     fsd001.Petdoc%type;
    VPendoc     fsd001.Pendoc%type;
    Vpetipo     fsd001.Petipo%type;
    VPefalt     fsd001.Pefalt%type;
    VJAQL56TIPE JAQL056.Jaql56tipe%type;
    Tipper      varchar2(10);
    Saldpf      number(17, 2);
    Salcts      number(17, 2);
    Salaho      number(17, 2);
    SalFta      number(17, 2);
    SalFan      number(17, 2);
    Saltot      number(17, 2);
    Pasivo      char(1);
    Numcta      number(9); 
    TYPE Array IS TABLE OF NUMBER;
    VAgencia Array := Array();
    MovHoy      char(1);
    NumHoy      number;
    Scsdo       number(17, 2);   
    dscerr      varchar2(250);
    Hilo        number; 
    totcli number := 0; 
    Hoy   date;
    Tcbio number;
  
  begin
    Hilo := 100 + Pbthread;
  
    Hoy   := to_date(HoyC, 'ddmmyyyy');
    Tcbio := to_number(TcbioC, '999999999.999990');

    begin
      for i in clientes loop
        begin

          VPepais := i.Pepais;
          VPetdoc := i.Petdoc;
          VPendoc := i.Pendoc;
          Vpetipo := i.Petipo;
          VPefalt := i.Pefalt;
        
          If Vpetipo = 'F' then
            VJAQL56TIPE := 1;
          Else
            VJAQL56TIPE := 2;
          End If;
        
          select trim(Replace(Tp1desc, 'Normal', ''))
            into Tipper
            from FST198
           Where Tp1cod = vPgcod
             and Tp1cod1 = 10818
             and Tp1corr1 = 2
             and Tp1nro1 = VJAQL56TIPE;
        
          Saldpf := 0;
          Salcts := 0;
          Salaho := 0;
          SalFta := 0;
          SalFan := 0;
          Saltot := 0;
          Pasivo := 'N';
          Numcta := 0;
          VAgencia.delete;
          VAgencia.EXTEND(999);
        
          If TipoSeg = 1 then
            --si va a segmentar solo a los que tuvieron movimientos hoy
            begin
              select count(*)
                into NumHoy
                from fsd016 d, fsd015 c, fsr008 b
               where c.pgcod = vpgcod
                 and c.pgcod = d.pgcod
                 and d.itsuc = c.itsuc
                 and d.itmod = c.itmod
                 and d.ittran = c.ittran
                 and d.itnrel = c.itnrel
                 and c.itcont = 'S'
                 and d.itanu = 'N'
                 and c.itcorr <> 99
                 and b.pgcod = vpgcod
                 and d.ctnro = b.ctnro
                 and d.modulo in (21, 22, 426)
                 and b.pepais = i.pepais
                 and b.petdoc = i.petdoc
                 and b.pendoc = i.pendoc
                 and b.Ttcod = 1
                 and b.cttfir = 'T';
            exception
              when others then
                NumHoy := 0;
                Movhoy := 'N';
            end;
            If NumHoy > 0 then
              MovHoy := 'S';
            end if;
          Else
            MovHoy := 'S';
          End If;
        
          If MovHoy = 'S' then
            For j in cuentas(vpepais, vpetdoc, VPendoc) loop
              begin
                Pasivo := 'S';
                sp_saldo_2(vpgcod,
                           j.Scsuc,
                           j.Sccta,
                           j.Scmda,
                           j.Scpap,
                           j.Scoper,
                           j.Scsbop,
                           j.Sctope,
                           j.Scmod,
                           j.Rubro,
                           Hoy,
                           scsdo);
              exception
                when others then
                  dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                            VPendoc || '-' || trim(to_char(j.sccta));
                  dbms_output.put_line(dscerr);
              end;
            end loop;
          End if;
        
          totcli := totcli + 1;
          If totcli = 1 then
            commit;
            totcli := 0;
          End If;
        exception
          when others then
            dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                      VPendoc;
            dbms_output.put_line(dscerr);
        end;
      end loop;
    
    exception
      when others then
        dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                  VPendoc;
        dbms_output.put_line(dscerr);
    end;
    commit;
  end sp_posiciona2;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_saldo(vpgcod  number,
                     vScsuc  number,
                     vSccta  number,
                     vScmda  number,
                     vScpap  number,
                     vScoper number,
                     vScsbop number,
                     vSctope number,
                     vScmod  number,
                     vRubro  number,
                     Hoy     date,
                     vscsdo  out number) is
  
    Rrrubr number;
    Capcts number;
    Intcts number;
    PerCal number;
    Bcfech date;
    Totaho number;
    Capaho number;
    Intaho number;
  
  begin
    case
      when vscmod = 22 then
        begin
          select scsdo
            into vscsdo
            from fsd011
           where pgcod = vpgcod
             and scsuc = vscsuc
             and scrub = vrubro
             and scmda = vscmda
             and scpap = vscpap
             and sccta = vsccta
             and scoper = vscoper
             and scsbop = vscsbop
             and sctope = vSctope;
        exception
          when no_data_found then
            vscsdo := 0;
        end;
      
      when vsctope = 2 then
        --cap intangible
        begin
          select Rrrubr
            into Rrrubr
            from FSR014
           Where Rubro = vRubro
             and Rrcod = 169;
        exception
          when no_data_found then
            Rrrubr := 0;
        end;
      
        begin
          select case
                   when Scsdo < 0 then
                    Scsdo * (-1)
                   else
                    Scsdo
                 end case
            into Capcts
            from FSD011
           Where Pgcod = vPgcod
             and Scsuc = vScsuc
             and Scrub = Rrrubr
             and Sccta = vSCCTA
             and Scmda = vScmda
             and Scpap = vScpap
             and Scoper = vScoper
             and Scsbop = vScsbop;
        exception
          when no_data_found then
            Capcts := 0;
        end;
        --int intangible
        begin
          select Rrrubr
            into Rrrubr
            from FSR014
           Where Rubro = vRubro
             and Rrcod = 1;
        exception
          when no_data_found then
            Rrrubr := 0;
        end;
        begin
          select case
                   when Scsdo < 0 then
                    Scsdo * (-1)
                   else
                    Scsdo
                 end case
            into Intcts
            from FSD011
           Where Pgcod = vPgcod
             and Scsuc = vScsuc
             and Scrub = Rrrubr
             and Sccta = vSCCTA
             and Scmda = vScmda
             and Scpap = vScpap
             and Scoper = vScoper
             and Scsbop = vScsbop;
        exception
          when no_data_found then
            Intcts := 0;
        end;
        VScsdo := Capcts + Intcts;
      else
        select Tp1nro1
          into PerCal
          from FST198
         Where Tp1cod = vpgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 2;
      
        Bcfech := add_months(Hoy, -1 * PerCal);
        begin
          select sum(BCSdMO), count(*)
            into Capaho, Totaho
            from FSH012
           Where BCEmp = vPgcod
             and BCSuc = vScsuc
             and BCRubr = vRubro
             and BCMda = vScmda
             and BCPap = vScpap
             and BCCta = vSccta
             and BCOper = vScoper
             and BCSbOp = vScsbop
             and BCTOp = vSctope
             and BCFech between Bcfech and Hoy;
        exception
          when no_data_found then
            Capaho := 0;
            Totaho := 0;
        end;
      
        If Capaho = 0 or Totaho = 0 then
          Capaho := 0;
        Else
          Capaho := Capaho / Totaho;
        End If;
      
        Totaho := 0;
        begin
          select Rrrubr
            into Rrrubr
            from FSR014
           Where Rubro = vRubro
             and Rrcod = 1;
        exception
          when no_data_found then
            Rrrubr := 0;
        end;
      
        begin
          select sum(BCSdMO), count(*)
            into Intaho, Totaho
            from FSH012
           Where BCEmp = vPgcod
             and BCSuc = vScsuc
             and BCRubr = Rrrubr
             and BCMda = vScmda
             and BCPap = vScpap
             and BCCta = vSccta
             and BCOper = vScoper
             and BCSbOp = vScsbop
                --and BCTOp = vSctope
             and BCFech between Bcfech and Hoy;
        exception
          when no_data_found then
            Intaho := 0;
            Totaho := 0;
        end;
        If Intaho = 0 or Totaho = 0 then
          Intaho := 0;
        Else
          Intaho := Intaho / Totaho;
        End If;
      
        VScsdo := Capaho + Intaho;
      
    end case;
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tasa(vpgcod  number,
                    vScsuc  number,
                    vSccta  number,
                    vScmda  number,
                    vScpap  number,
                    vScoper number,
                    vScsbop number,
                    vSctope number,
                    vScmod  number,
                    tasa    out number) is
  
    petipo   char(1);
    tipo     number(9);
    ctifin   char(1);
    monto    number;
    vmodtcli number(9);
    vsfval   date;
    vpgfape  date;
  
  begin
  
    begin
      select pgfape into vpgfape from fst017 where pgcod = vpgcod;
    exception
      when others then
        vpgfape := trunc(sysdate);
    end;
  
    vsfval := vpgfape;
  
    begin
      select 'S'
        into ctifin
        from fsd008
       where pgcod = vpgcod
         and ctnro = vsccta
         and ctccli in (3, 5);
    exception
      when no_data_found then
        ctifin := 'N';
    end;
  
    begin
      select b.petipo
        into petipo
        from fsr008 a, fsd001 b
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and a.ctnro = vsccta
         and a.ttcod = 1
         and a.cttfir = 'T';
    exception
      when no_data_found then
        petipo := 'F';
    end;
  
    if vscmod = 21 then
    
      begin
        select totpiz
          into tipo
          from fst004
         where modulo = 21
           and toeleg = 'S'
           and totope = vsctope;
      exception
        when others then
          tipo := 0;
      end;
      if petipo = 'J' then
        If ctifin = 'S' then
          /*
          If vsctope = 3 then
            tipo := 97;
          Else
            tipo := 96;
          End if;*/
        
          vmodtcli := 3;
        
        Else
          vmodtcli := 2;
        End If;
      
        begin
          select ModCodn
            into tipo
            from FST100 -- ModCodN
           Where ModTcli = vmodtcli -- 2
             and ModSuc = 0
             and ModCod = tipo;
        exception
          when no_data_found then
            null; -- tipo := 0; 20171025 si no existe para el modificador dejar el de PF
        end;
      end if;
    
      begin
        select scsdo
          into monto
          from fsd011
         where Pgcod = vpgcod
           and scmod = vscmod
           and scsuc = vscsuc
           and scmda = vscmda
           and scpap = vScpap
           and sccta = vsccta
           and scoper = vscoper
           and scsbop = vscsbop
           and sctope = vsctope
           and rownum = 1;
      exception
        when no_data_found then
          monto := 0;
      end;
    
      begin
        if vscmod = 21 and vsctope = 2 then --si es cts filtrar sin vigencia
          select tastasa
            into tasa
            from (select tastasa
                    from FSR427 t1, fsd427 t2
                   where t1.tasemp = t2.tasemp
                     and t1.tasmod = t2.tasmod
                     and t1.taspiz = t2.taspiz
                     and t1.tascta = t2.tascta
                     and t1.tassop = t2.tassop
                     and t1.tasmda = t2.tasmda
                     and t1.taspap = t2.taspap
                     and t1.tasfdes = t2.tasfdes
                     and t1.tasmto = t2.tasmto
                     and t1.tasemp = vpgcod
                     and t1.tasmod = vscmod
                     and t1.taspiz = tipo
                     and t1.tascta = vsccta
                     and t1.tassop = vscsbop
                     and t1.tasmda = vscmda
                     and t1.tasmto >= monto
                     and t1.tasfdes <= vSfval
                     and t2.tasvig = 'S'
                   order by t1.tasfdes desc, t1.tasmto)
           where rownum = 1;
        else
          select tastasa
            into tasa
            from (select tastasa
                    from FSR427 t1, fsd427 t2, fsd328 t3
                   where t1.tasemp = t2.tasemp
                     and t1.tasmod = t2.tasmod
                     and t1.taspiz = t2.taspiz
                     and t1.tascta = t2.tascta
                     and t1.tassop = t2.tassop
                     and t1.tasmda = t2.tasmda
                     and t1.taspap = t2.taspap
                     and t1.tasfdes = t2.tasfdes
                     and t1.tasmto = t2.tasmto
                        --
                     and t1.tasemp = t3.vtasemp (+)
                     and t1.tasmod = t3.vtasmod (+) 
                     and t1.taspiz = t3.vtaspiz (+)
                     and t1.tascta = t3.vtascta (+)
                     and t1.tassop = t3.vtassop (+)
                     and t1.tasmda = t3.vtasmda (+)
                     and t1.taspap = t3.vtaspap (+)
                     and t1.tasfdes = t3.vtasfdes (+)
                     and t3.vtasfvto (+) >= vSfval
                        --
                     and t1.tasemp = vpgcod
                     and t1.tasmod = vscmod
                     and t1.taspiz = tipo
                     and t1.tascta = vsccta
                     and t1.tassop = vscsbop
                     and t1.tasmda = vscmda
                     and t1.tasmto >= monto
                     and t1.tasfdes <= vSfval
                     and t2.tasvig = 'S'
                   order by t1.tasfdes desc, t1.tasmto)
           where rownum = 1;
        end if;
      exception
        when no_data_found then
          begin
            select tptasa
              into tasa
              from (select tptasa
                      from FSR027 t3, fsd027 t4, fsd327 t5
                     where t3.pgcod = t4.pgcod
                       and t3.modulo = t4.modulo
                       and t3.tpizar = t4.tpizar
                       and t3.ctnro = t4.ctnro
                       and t3.moneda = t4.moneda
                       and t3.papel = t4.papel
                       and t3.tpfdes = t4.tpfdes
                       and t3.tpmto = t4.tpmto
                          --
                       and t3.pgcod = t5.vt1pgcod (+)
                       and t3.modulo = t5.vt1mod (+)
                       and t3.tpizar = t5.vt1tpiz (+)
                       and t3.ctnro = t5.vt1ctnr (+)
                       and t3.moneda = t5.vt1mon (+)
                       and t3.papel = t5.vt1pap (+)
                       and t3.tpfdes = t5.vt1tpfd (+)
                       and t5.vt1fchven (+) >= vsfval
                          --
                       and t3.pgcod = vpgcod
                       and t3.modulo = vscmod
                       and t3.tpizar = tipo
                       and t3.ctnro = vSccta
                       and t3.moneda = vscmda
                       and t4.tpmto >= monto
                       and t4.tpfdes <= vSfval
                       and t4.tpvig = 'Ss'
                     order by t4.tpfdes desc, t4.tpmto)
             where rownum = 1;
          exception
            when no_data_found then
              begin
                select tatasa
                  into tasa
                  from (select a.tatasa
                          from fsr025 a, fsd025 b
                         Where a.pgcod = b.pgcod
                           and a.tamod = b.tamod
                           and a.tpizar = b.tpizar
                           and a.tamda = b.tamda
                           and a.tapap = b.tapap
                           and a.tafdes = b.tafdes
                           and a.tamto = b.tamto
                           and a.Pgcod = vpgcod
                           and a.Tamod = vscmod
                           and a.Tamda = vscmda -- moneda
                           and a.Tapap = vScpap
                           and a.Tpizar = tipo -- totpiz  
                           and a.tamto >= monto
                           and a.tafdes <= vSfval
                         order by a.tafdes desc, a.tamto)
                 where rownum = 1;
              exception
                when no_data_found then
                  tasa := 0;
              end;
          end;
      end;
    else
      begin
        select Evtasa
          into tasa
          from (select Evtasa
                  from fsd012 -- Evtasa      
                 Where Pgcod = vpgcod
                   and Aomod = vscmod
                   and Aosuc = vscsuc
                   and Aomda = vscmda
                   and Aopap = vScpap
                   and Aocta = vsccta
                   and Aooper = vscoper
                   and Aosbop = vscsbop
                   and Aotope = vsctope
                   and Evtipo = 3 --fijo interes
                   and D012co = 'S'
                   and evfval <= vSfval
                 order by evfval desc, evcorr desc)
         where rownum = 1; --fijo
      exception
        when no_data_found then
          -- si no encontré en fsd012 entonces nunca tuvo cambio tasa y busco en la fsd010
          begin
            select Aotasa
              into tasa
              from FSD010 -- Aotasa      
             Where Pgcod = vpgcod
               and Aomod = vscmod
               and Aosuc = vscsuc
               and Aomda = vscmda
               and Aopap = vScpap
               and Aocta = vsccta
               and Aooper = vscoper
               and Aosbop = vScsbop
               and Aotope = vSctope;
          exception
            when no_data_found then
              tasa := 0;
          end;
      end;
    end if;
  end;

  ------------------------------------------------

  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2) RETURN NUMBER IS
  
    num_job NUMBER(10);
  
  BEGIN
  
    SELECT COUNT(1)
      INTO num_job
      FROM dba_scheduler_jobs job
     WHERE owner = pi_vc2_nomusr
       AND job.job_name LIKE pi_vc2_nomjob || '%';
  
    RETURN num_job;
  
  END;

  ------------------------------------------------  

  procedure sp_posiciona_persona(vpgcod  number,
                                 vPepais number,
                                 vPetdoc number,
                                 vPendoc char,
                                 TipoSeg number,
                                 Hoy     date,
                                 Tcbio   number) is
  
    cursor clientes is
      select *
        from fsd001
       Where Pepais = vpepais
         and Petdoc = vPetdoc
         and Pendoc = vPendoc;
  
    cursor cuentas(v1pepais number, v1petdoc number, v1Pendoc char) is
      select Scsuc,
             Sccta,
             Scmda,
             Scpap,
             Scoper,
             Scsbop,
             Sctope,
             Scmod,
             Scrub Rubro
        from fsd011 x, fsr008 y
       where x.pgcod = vpgcod
         and x.sccta = y.ctnro
         and y.Ttcod = 1
         and y.cttfir = 'T'
         and x.scmod in (21, 22)
         and y.pepais = v1pepais
         and y.petdoc = v1petdoc
         and y.pendoc = v1pendoc
         and x.scstat <> 99;
  
    cursor sucursal is
      select sucurs from fst001 where pgcod = vpgcod;
  
    Vpetipo     fsd001.Petipo%type;
    VPefalt     fsd001.Pefalt%type;
    VJAQL56TIPE JAQL056.Jaql56tipe%type;
    Tipper      varchar2(10);
    Saldpf      number(17, 2);
    Salcts      number(17, 2);
    Salaho      number(17, 2);
    Salnac      number(17, 2);
    Salext      number(17, 2);
    SalFta      number(17, 2);
    SalFan      number(17, 2);
    Saltot      number(17, 2);
    Pasivo      char(1);
    Numcta      number(9);
    /*  
    TYPE Array IS VARRAY(999) OF number(3);
    VAgencia Array := Array(999);*/
  
    TYPE Array IS TABLE OF NUMBER;
    VAgencia Array := Array();
    age      number(3);
    Agesal   number;
  
    MovHoy      char(1);
    NumHoy      number;
    Scsdo       number(17, 2);
    tasa        number(10, 6);
    Porfac      number(5, 2);
    SalFct      number(17, 2);
    error       varchar2(500);
    dscerr      varchar2(250);
    FecAnt      date;
    numano      number;
    Vsucurs     number(3);
    Agencia     number(3);
    Salmay      number(17, 2);
    Salage      number(17, 2);
    vJAQL57FPRO date;
    Segage      char(1);
    Calcli      char(1);
    Hilo        number;
  

    totcli number := 0;
  
  begin
    Hilo := 999;
  
    --delete from jaql063 where jaql63nu05 = hilo;
  
    begin
      for i in clientes loop
        begin
          --dbms_output.put_line(i.pendoc);
          Vpetipo := i.Petipo;
          VPefalt := i.Pefalt;
        
          If Vpetipo = 'F' then
            VJAQL56TIPE := 1;
          Else
            VJAQL56TIPE := 2;
          End If;
        
          select trim(Replace(Tp1desc, 'Normal', ''))
            into Tipper
            from FST198
           Where Tp1cod = vPgcod
             and Tp1cod1 = 10818
             and Tp1corr1 = 2
             and Tp1nro1 = VJAQL56TIPE;
        
          Saldpf := 0;
          Salcts := 0;
          Salaho := 0;
          SalFta := 0;
          SalFan := 0;
          Saltot := 0;
          Pasivo := 'N';
          Numcta := 0;
          VAgencia.delete;
          VAgencia.EXTEND(999);
        
          If TipoSeg = 1 then
            --si va a segmentar solo a los que tuvieron movimientos hoy
            begin
              select count(*)
                into NumHoy
                from fsd016 d, fsd015 c, fsr008 b
               where c.pgcod = vpgcod
                 and c.pgcod = d.pgcod
                 and d.itsuc = c.itsuc
                 and d.itmod = c.itmod
                 and d.ittran = c.ittran
                 and d.itnrel = c.itnrel
                 and c.itcont = 'S'
                 and d.itanu = 'N'
                 and c.itcorr <> 99
                 and b.pgcod = vpgcod
                 and d.ctnro = b.ctnro
                 and d.modulo in (21, 22, 426)
                 and b.pepais = i.pepais
                 and b.petdoc = i.petdoc
                 and b.pendoc = i.pendoc
                 and b.Ttcod = 1
                 and b.cttfir = 'T';
            exception
              when others then
                NumHoy := 0;
                Movhoy := 'N';
            end;
            If NumHoy > 0 then
              MovHoy := 'S';
            end if;
          Else
            MovHoy := 'S';
          End If;
        
          If MovHoy = 'S' then
            For j in cuentas(vpepais, vpetdoc, VPendoc) loop
              begin
                Pasivo := 'S';
                sp_saldo_2(vpgcod,
                           j.Scsuc,
                           j.Sccta,
                           j.Scmda,
                           j.Scpap,
                           j.Scoper,
                           j.Scsbop,
                           j.Sctope,
                           j.Scmod,
                           j.Rubro,
                           Hoy,
                           scsdo);
              
                sp_tasa(vpgcod,
                        j.Scsuc,
                        j.Sccta,
                        j.Scmda,
                        j.Scpap,
                        j.Scoper,
                        j.Scsbop,
                        j.Sctope,
                        j.Scmod,
                        tasa);
              
                If j.Scmda = 0 then
                  Salnac := Scsdo;
                  Salext := 0;
                Else
                  Salnac := Scsdo * Tcbio;
                  Salext := Scsdo;
                End If;
              
                case
                  when j.Scmod = 22 then
                    Saldpf := Saldpf + Salnac;
                  when j.Sctope = 2 then
                    SalCts := SalCts + Salnac;
                  else
                    Salaho := Salaho + Salnac;
                end case;
              
                begin
                  select JAQL58POFA
                    into Porfac
                    from JAQL058
                   where JAQL58TIMO = j.Scmda
                     and JAQL58TIPE = VJAQL56TIPE
                     and JAQL58ESTA = 'S'
                     and JAQL58FEVI <= Hoy
                     and tasa between JAQL58VAMI and JAQL58VAMA;
                  Error := 'Factor : ' || to_char(Porfac, '999.99');
                exception
                  when no_data_found then
                    Error  := 'No se encontro factor tasa';
                    Porfac := 0;
                End;
              
                SalFct := Salnac * (Porfac / 100);
                SalFta := SalFta + SalFct;
                age    := j.Scsuc;
              
                if VAgencia(age) is null then
                  VAgencia(age) := 0;
                end if;
              
                VAgencia(age) := VAgencia(age) + Salnac;
                Agesal := VAgencia(age);
                /*              
                insert into jaql063
                  (jaql63nu05, --1XX
                   jaql63ch01, --petdoc+pendoc+tiper
                   jaql63de05, --scmod
                   jaql63ch02, --scmda
                   jaql63nu01, --sccta
                   jaql63nu02, --scsuc
                   jaql63nu03, --scoper
                   jaql63nu04, --scsbop
                   jaql63ch03, --sctope
                   jaql63de01, --Rubro
                   jaql63de02, --Scsdo
                   jaql63de03, --Salnac
                   jaql63de04, --Salext
                   jaql63ch04, --tasa               
                   jaql63ch05, -- error
                   jaql63da01, --libre
                   jaql63da02, --libre
                   jaql63da03, --libre
                   jaql63da04, --libre
                   jaql63da05 --libre
                   )
                values
                  (Hilo,
                   lpad(to_char(VPePais), 3, '0') || '-' ||
                   lpad(to_char(VPetdoc), 2, '0') || '-' ||
                   lpad(trim(VPendoc), 12, '*') || '-' || Trim(Tipper),
                   j.scmod,
                   to_char(j.scmda),
                   j.sccta,
                   j.scsuc,
                   j.scoper,
                   j.scsbop,
                   to_char(j.sctope),
                   to_char(j.Rubro),
                   Scsdo,
                   Salnac,
                   Salext,
                   to_char(tasa, '999.9999999'),
                   substr(Error, 1, 50),
                   Hoy,
                   Hoy,
                   Hoy,
                   Hoy,
                   Hoy);
                
                totcta := totcta + 1;
                If totcta = 1 then
                  commit;
                  totcta := 0;
                End If;*/
              exception
                when others then
                  dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                            VPendoc || '-' || trim(to_char(j.sccta));
                  dbms_output.put_line(dscerr);
              end;
            end loop;
          
            Saltot := Saldpf + Salcts + Salaho;
          
            Error := '';
          
            if Pasivo = 'S' then
              fecha_antig(vpgcod, vpepais, vpetdoc, vpendoc, fecant);
            
              numano := floor((Hoy - FecAnt) / 365);
            
              begin
                select JAQL59POFA
                  into Porfac
                  from JAQL059
                 Where JAQL59TIPE = VJAQL56TIPE
                   and JAQL59ESTA = 'S'
                   and JAQL59FEVI <= Hoy
                   and numano >= JAQL59VAMI
                   and numano <= JAQL59VAMA;
              exception
                when No_data_found then
                  Porfac := 0;
                  Error  := Error || '-No se encontro factor antiguedad';
              end;
            
              SalFan := SalFta * (Porfac / 100);
            
              Salmay := 0;
            
              for b in sucursal loop
                VSucurs := b.Sucurs;
                If VAgencia(VSucurs) is not null then
                  Salage := VAgencia(VSucurs);
                  If Salage > Salmay then
                    Salmay  := Salage;
                    Agencia := VSucurs;
                  End If;
                End If;
              end loop;
            
              vJAQL57FPRO := last_day(Add_months(Hoy, -1));
            
              begin
                select JAQL57SENU
                  into Segage
                  from JAQL057
                 Where JAQL57FPRO = VJAQL57FPRO
                   and JAQL57PGCO = VPgcod
                   and JAQL57SUCU = Agencia;
              exception
                When No_Data_Found then
                  Segage := '';
                  Error  := Error ||
                            '-No se encontro clasificacion de la agencia: ' ||
                            +trim(to_char(Agencia));
              end;
            
              Calcli := 'D';
            
              begin
                select JAQL56CLCL
                  into Calcli
                  from JAQL056
                 Where JAQL56TISU = Segage
                   and JAQL56TIPE = VJAQL56TIPE
                   and JAQL56ESTA = 'S'
                   and JAQL56FEVI <= Hoy
                   and SalFan between JAQL56SAMI and JAQL56SAMA;
              exception
                When no_data_found then
                  Calcli := 'D';
                  Error  := Error ||
                            '-No se encontro clasificacion del cliente: ' ||
                            'Segmento  = ' || Segage || ' /Saldo  = ' ||
                            trim(to_char(SalFan));
              end;
            
              begin
                insert into jaql060
                  (JAQL60PGCO,
                   JAQL60PAIS,
                   JAQL60TDOC,
                   JAQL60NDOC,
                   JAQL60SUCU,
                   JAQL60SAPF,
                   JAQL60SACT,
                   JAQL60SAAH,
                   JAQL60SATO,
                   JAQL60FATA,
                   JAQL60FAAN,
                   JAQL60CALI,
                   JAQL60FECH,
                   JAQL60HORA,
                   JAQL60MOTI,
                   JAQL60TIPE,
                   JAQL60AU10,
                   JAQL60AU07,
                   JAQL60AU04,
                   JAQL60AU08,
                   JAQL60AU01)
                values
                  (vPgcod,
                   vPepais,
                   vPetdoc,
                   vPendoc,
                   Agencia,
                   Saldpf,
                   Salcts,
                   Salaho,
                   Saltot,
                   SalFta,
                   SalFan,
                   Calcli,
                   Hoy,
                   to_char(sysdate, 'HH24:mi:ss'),
                   'SEGMENTACION MASIVA',
                   VJAQL56TIPE,
                   FecAnt,
                   numano,
                   Salmay,
                   Hilo,
                   substr(Error, 1, 50));
              
              exception
                when dup_val_on_index then
                  update jaql060
                     set JAQL60SUCU = Agencia,
                         JAQL60SAPF = Saldpf,
                         JAQL60SACT = Salcts,
                         JAQL60SAAH = Salaho,
                         JAQL60SATO = Saltot,
                         JAQL60FATA = SalFta,
                         JAQL60FAAN = SalFan,
                         JAQL60CALI = Calcli,
                         JAQL60FECH = Hoy,
                         JAQL60HORA = to_char(sysdate, 'HH24:mi:ss'),
                         JAQL60MOTI = 'SEGMENTACION MASIVA',
                         JAQL60AU01 = substr(Error, 1, 50),
                         JAQL60AU10 = FecAnt,
                         JAQL60AU07 = numano,
                         JAQL60AU04 = Salmay,
                         JAQL60AU08 = Hilo
                   Where JAQL60PGCO = vPgcod
                     and JAQL60PAIS = vPepais
                     and JAQL60TDOC = vPetdoc
                     and JAQL60NDOC = vPendoc;
              end;
            
            else
              update jaql060
                 set JAQL60SAPF = 0,
                     JAQL60SACT = 0,
                     JAQL60SAAH = 0,
                     JAQL60SATO = 0,
                     JAQL60FATA = 0,
                     JAQL60FAAN = 0,
                     JAQL60CALI = 'D',
                     JAQL60FECH = Hoy,
                     JAQL60HORA = to_char(sysdate, 'HH24:mi:ss'),
                     JAQL60MOTI = 'SEGMENTACION MASIVA',
                     JAQL60AU08 = Hilo
               Where JAQL60PGCO = vPgcod
                 and JAQL60PAIS = vPepais
                 and JAQL60TDOC = vPetdoc
                 and JAQL60NDOC = vPendoc;
            
            end if;
          End if;
        
          totcli := totcli + 1;
          If totcli = 1 then
            commit;
            totcli := 0;
          End If;
        exception
          when others then
            dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                      VPendoc;
            dbms_output.put_line(dscerr);
        end;
      end loop;
    
    exception
      when others then
        dscerr := sqlerrm || '-' || trim(to_char(VPetdoc)) || '-' ||
                  VPendoc;
        dbms_output.put_line(dscerr);
    end;
    commit;
  end sp_posiciona_persona;

  ---------------------------------------------------

  procedure Fecha_Antig(vpgcod  number,
                        vpepais number,
                        vpetdoc number,
                        vpendoc char,
                        --vtipo   number,
                        vFecAnt out date) is
  
    vFecAnt_ah date;
    vFecAnt_pf date;
  
  begin
    select JAQL106Fhc
      into vFecAnt
      from jaql106
     Where JAQL106Pai = vPepais
       and JAQL106Tdo = vPetdoc
       and JAQL106Doc = vPendoc;
    --       and JAQL106A01 = vtipo;
  exception
    when no_data_found then
      begin
        select min(Scfval)
          into vFecAnt_ah
          from fsd011 x, fsr008 y
         where x.pgcod = vpgcod
           and x.sccta = y.ctnro
           and y.Ttcod = 1
           and x.scmod = 21
           and y.pepais = vpepais
           and y.petdoc = vpetdoc
           and y.pendoc = vpendoc
           and x.scstat <> 99;
      exception
        when others then
          vFecAnt_ah := null;
      end;
    
      begin
        select min(aofval)
          into vFecAnt_pf
          from fsd010 x, fsr008 y
         where x.pgcod = vpgcod
           and x.aocta = y.ctnro
           and y.Ttcod = 1
           and x.aomod = 22
           and y.pepais = vpepais
           and y.petdoc = vpetdoc
           and y.pendoc = vpendoc;
      exception
        when others then
          vFecAnt_pf := null;
      end;
    
      if vFecAnt_ah is not null then
        if vFecAnt_pf is not null then
          if vFecAnt_ah < vFecAnt_pf then
            vFecAnt := vFecAnt_ah;
          else
            vFecAnt := vFecAnt_pf;
          end if;
        else
          vFecAnt := vFecAnt_ah;
        end if;
      else
        vFecAnt := vFecAnt_pf;
      end if;
    
      If vFecAnt = to_date('01/01/0001', 'dd/mm/yyyy') or vFecAnt is null then
        select pgfape into vFecAnt from fst017 where pgcod = vpgcod;
      End if;
  End;

  ---------------------------------------------------  

  procedure sp_saldo_2(vpgcod  number,
                       vScsuc  number,
                       vSccta  number,
                       vScmda  number,
                       vScpap  number,
                       vScoper number,
                       vScsbop number,
                       vSctope number,
                       vScmod  number,
                       vRubro  number,
                       Hoy     date,
                       vscsdo  out number) is
  
    Rrrubr   number;
    Capcts   number;
    Intcts   number;
    PerCal   number;
    Bcfech   date;
    Totaho   number;
    Capaho   number := 0;
  
    Capaho_d number;

    Dia      date;
  
    -- variables para saldo promedio mensual
    ln_salpro number(17, 2) := 0;
    ln_totsal number(17, 2) := 0;
    ln_totdia number(10) := 0;
    ld_fecini date;
    ld_fecfin date;
    lc_error  varchar2(500);
  
  begin
    case
      when vscmod = 22 then
        begin
          select scsdo
            into vscsdo
            from fsd011
           where pgcod = vpgcod
             and scsuc = vscsuc
             and scrub = vrubro
             and scmda = vscmda
             and scpap = vscpap
             and sccta = vsccta
             and scoper = vscoper
             and scsbop = vscsbop
             and sctope = vSctope;
        exception
          when no_data_found then
            vscsdo := 0;
        end;
      
      when vsctope = 2 then
        --cap intangible
        begin
          select Rrrubr
            into Rrrubr
            from FSR014
           Where Rubro = vRubro
             and Rrcod = 169;
        exception
          when no_data_found then
            Rrrubr := 0;
        end;
      
        begin
          select case
                   when Scsdo < 0 then
                    Scsdo * (-1)
                   else
                    Scsdo
                 end case
            into Capcts
            from FSD011
           Where Pgcod = vPgcod
             and Scsuc = vScsuc
             and Scrub = Rrrubr
             and Sccta = vSCCTA
             and Scmda = vScmda
             and Scpap = vScpap
             and Scoper = vScoper
             and Scsbop = vScsbop;
        exception
          when no_data_found then
            Capcts := 0;
        end;
        --int intangible
        begin
          select Rrrubr
            into Rrrubr
            from FSR014
           Where Rubro = vRubro
             and Rrcod = 1;
        exception
          when no_data_found then
            Rrrubr := 0;
        end;
        begin
          select case
                   when Scsdo < 0 then
                    Scsdo * (-1)
                   else
                    Scsdo
                 end case
            into Intcts
            from FSD011
           Where Pgcod = vPgcod
             and Scsuc = vScsuc
             and Scrub = Rrrubr
             and Sccta = vSCCTA
             and Scmda = vScmda
             and Scpap = vScpap
             and Scoper = vScoper
             and Scsbop = vScsbop;
        exception
          when no_data_found then
            Intcts := 0;
        end;
        VScsdo := Capcts + Intcts;
      
      else
      
        select Tp1nro1
          into PerCal
          from FST198
         Where Tp1cod = vpgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 2;
      
        Bcfech := add_months(Hoy, -1 * PerCal);
      
        dia    := Bcfech;
        Totaho := 0;
        --saldo promedio
        ld_fecini := add_months(Hoy, -1) + 1;
        ld_fecfin := Hoy;
        --      
        while dia <= Hoy loop
          begin
            select /*+index (FSH012 FSH01200)*/
             BCSdMO
              into Capaho_d
              from FSH012
             Where BCEmp = vPgcod
               and BCSuc = vScsuc
               and BCRubr = vRubro
               and BCMda = vScmda
               and BCPap = vScpap
               and BCCta = vSccta
               and BCOper = vScoper
               and BCSbOp = vScsbop
               and BCTOp = vSctope
               and BCFech = dia;
          
            Totaho := Totaho + 1;
          
            if ld_fecini <= dia and dia <= ld_fecfin Then
              ln_totsal := ln_totsal + Capaho_d;
              ln_totdia := ln_totdia + 1;
            End If;
            --                
          exception
            when no_data_found then
              Capaho_D := 0;
          end;
        
          Capaho := Capaho + Capaho_d;
        
          dia := dia + 1;
        end loop;
      
        --saldo promedio
        If ln_totsal = 0 or ln_totdia = 0 then
          ln_salpro := 0;
        Else
          ln_salpro := round(ln_totsal / ln_totdia, 2);
        End If;
      
        begin
          INSERT /*+ append */
          INTO JAQL483
            (JAQL483FCH,
             JAQL483SUC,
             JAQL483BCR,
             JAQL483PGO,
             JAQL483MOD,
             JAQL483MDA,
             JAQL483PAP,
             JAQL483CTA,
             JAQL483OPE,
             JAQL483SBO,
             JAQL483TPO,
             JAQL483TOT,
             JAQL483DIA,
             JAQL483AX6)
          VALUES
            (ld_fecfin,
             vScsuc,
             vRubro,
             vPgcod,
             vscmod,
             vScmda,
             vScpap,
             vSccta,
             vScoper,
             vScsbop,
             vSctope,
             ln_totsal,
             ln_totdia,
             ln_salpro);
        Exception
          when others then
            lc_error := sqlerrm;
            --insertar a una tabla generica de excepciones (dato y la bandeja)
            insert into LOG_ERROR_BANDEJA
              (n_nro, c_codbdj, c_deserr, d_fecerr)
            values
              (999, 'JAQL483', lc_error, sysdate);
            commit;
        end;            
      
    end case;
  end;
  procedure sp_tasa_grupo(vpgcod number,
                          vScmda number,
                          vscsdo number,
                          Hoy    date,
                          vPzo   number,
                          tgcod  number,
                          grnro  number,
                          tasa   out number) is
  begin
    select tptasa
      into tasa
      from (select tptasa
              from FSR027 t3, fsd027 t4
             where t3.pgcod = t4.pgcod
               and t3.modulo = t4.modulo
               and t3.tpizar = t4.tpizar
               and t3.ctnro = t4.ctnro
               and t3.moneda = t4.moneda
               and t3.papel = t4.papel
               and t3.tpfdes = t4.tpfdes
               and t3.tpmto = t4.tpmto
               and t3.pgcod = vpgcod
               and t3.modulo = 522
               and t3.ctnro = (tgcod * 10000000) + grnro
               and t3.moneda = vScmda
               and t4.tpmto >= vscsdo
               and t4.tpfdes <= Hoy
               and t4.tpvig = 'S'
               and t3.tppzo >= vPzo
               and t3.tpizar = 1
             order by t4.tpfdes desc, t4.tpmto, t3.tppzo)
     where rownum = 1;
  exception
    when others then
      tasa := 0;
  end sp_tasa_grupo;
end PQ_SEGMENTACION_CLIENTES_PAS;
/

