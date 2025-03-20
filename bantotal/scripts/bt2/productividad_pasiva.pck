create or replace package Productividad_Pasiva is

  -- Author  : MARAUJO
  -- Created : 16/09/2013 06:08:27 p.m.
  -- Purpose : P4roductividad pasiva

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   Tcbio     number);

  procedure Proceso_CV(pd_fecini date,
                       pd_fecfin date,
                       pd_fecpro date,
                       Tcbio     number,
                       pn_ctaini number,
                       pn_ctafin number);

  procedure Proceso_DPF(pd_fecini date,
                        pd_fecfin date,
                        pd_fecpro date,
                        Tcbio     number,
                        pn_ctaini number,
                        pn_ctafin number);

  procedure Cartera(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    Tcbio     number);

  procedure Titular(vpgcod  number,
                    vctnro  number,
                    vpepais out number,
                    vpetdoc out number,
                    vpendoc out char,
                    vpetipo out char);

  procedure Fecha_Antig(vpgcod  number,
                        vpepais number,
                        vpetdoc number,
                        vpendoc char,
                        --vtipo   number,
                        vFecAnt out date);

  procedure Fecha_Antig_cta(vJAQL106PGC NUMBER,
                            vJAQL106MOD NUMBER,
                            vJAQL106SUC NUMBER,
                            vJAQL106MDA NUMBER,
                            vJAQL106PAP NUMBER,
                            vJAQL106CTA NUMBER,
                            vJAQL106OPE NUMBER,
                            vJAQL106SBO NUMBER,
                            vJAQL106TOP NUMBER,
                            vFecAnt     out date);

  procedure Ejecutivo(vpgcod      number,
                      vpepais     number,
                      vpetdoc     number,
                      vpendoc     char,
                      pd_fecini   date,
                      pd_fecfin   date,
                      vJAQL61USER out char,
                      vUbsuc      out number);

  procedure Agente(vPgcod      number,
                   vScmod      number,
                   vScsuc      number,
                   vScmda      number,
                   vScpap      number,
                   vSccta      number,
                   vScoper     number,
                   vScsbop     number,
                   vSctope     number,
                   vScfval     date,
                   Tipo        char,
                   vJAQL61USER out char,
                   vUbsuc      out number);

  procedure Saldo_pro(vpgcod  number,
                      vScsuc  number,
                      vSccta  number,
                      vScmda  number,
                      vScpap  number,
                      vScoper number,
                      vScsbop number,
                      vSctope number,
                      vRubro  number,
                      Fecini  date,
                      Fecfin  date,
                      vscsdo  out number);

  function Sucursal_Eje(vPgcod number, vUbuser char) return number;

  function Es_Ejecutivo(vPgcod number, vUbuser char) return char;

  procedure Paga_Comision(vPgcod   number,
                          vUbuser  char,
                          vPrfGCod out char,
                          paga_com out char);

  Function Monto_Cancelacion(vPgcod  number,
                             vScmod  number,
                             vScmda  number,
                             vScpap  number,
                             vSccta  number,
                             vScsuc  number,
                             vScoper number,
                             vScsbop number,
                             vSctope number,
                             vScfulm date) return number;

  procedure Inserta_Detalle(vjaql81fepr date,
                            vjaql81user char,
                            vjaql81pgco number,
                            vjaql81scsu number,
                            vjaql81scmd number,
                            vjaql81scmo number,
                            vjaql81scpa number,
                            vjaql81scct number,
                            vjaql81scop number,
                            vjaql81scsb number,
                            vjaql81scto number,
                            vjaql81feva date,
                            vjaql81feca date,
                            vjaql81tipo char,
                            vJAQL81TIPE char,
                            ---
                            vjaql81mtap number,
                            vjaql81mtsp number,
                            vjaql81mtre number,
                            vjaql81mtca number,
                            vjaql81clnu char,
                            vjaql81au02 char,
                            vjaql81au07 number,
                            vjaql81au08 number,
                            vjaql81au03 char,
                            vjaql81au04 number,
                            vjaql81fein date,
                            vjaql81fefi date);

  procedure Inserta_Detalle_Acum(vjaql79user char,
                                 vjaql79fepr date,
                                 vjaql79tipe number,
                                 vjaql79modu number,
                                 vjaql79tope number,
                                 vjaql79fein date,
                                 vjaql79fefi date,
                                 vjaql79mtap number,
                                 vjaql79spap number,
                                 vjaql79mtac number,
                                 vjaql79spac number,
                                 vjaql79mtre number,
                                 vjaql79mtca number,
                                 vjaql79clap number,
                                 vjaql79clac number,
                                 vPrfGCod    char,
                                 vUbsuc      number,
                                 vjaql79au07 number);

  procedure Actualiza_Det_Meta(vjaql79user char,
                               vjaql79fepr date,
                               vjaql79modu number,
                               vjaql79tope number,
                               vjaql79memt char,
                               vjaql79mecl char,
                               vjaql79comt number,
                               vjaql79cocl number);

  procedure Paga_Captacion(vJAQL79USER char,
                           vprfgcod    char,
                           pd_fecini   date,
                           --pd_fecfin   date,
                           pd_fecpro date);

  procedure Paga_Cartera(vJAQL79USER char,
                         vprfgcod    char,
                         pd_fecpro   date,
                         analista    number,
                         pd_fecini   date,
                         pd_fecfin   date);

  function Supervision(vJAQL79USER char, pd_fecpro date) return number;

  procedure Inserta_Comision(vJAQL80USER char,
                             vJAQL80FEPR date,
                             vJAQL80PERF char,
                             vJAQL80SUCU number,
                             vJAQL80COCA number,
                             vJAQL80COCL number,
                             vJAQL80COCC number,
                             vJAQL80PAMC number,
                             vJAQL80COMC number,
                             vJAQL80NUSP number,
                             vJAQL80COSP number,
                             vJAQL80TOCO number,
                             TotCli      number,
                             vjaql80fein date,
                             vjaql80fefi date,
                             analista    number);

end Productividad_Pasiva;
/

create or replace package body Productividad_Pasiva is

  ----------------------------------------------------------------------

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   Tcbio     number) is
    cursor cta is
      select pbd1 pn_ctaini, pbh1 pn_ctafin
        from fsr101
       where pbnsec = 611
      --and pbthread = 1
      ;
  
    /*    cursor cta is
    select ctnro pn_ctaini, ctnro pn_ctafin
      from fsd008
     where ctnro in (442161);*/
  
    cursor ejecutivo is
      select b.ubuser, b.prfgcod, a.tp1nro3
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 3
         and Tp1nro1 <> 2;
  
    cursor promotor is
      select b.ubuser, b.prfgcod, a.tp1nro3
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 3
         and Tp1nro1 = 2;
  
  begin
  
    Delete from jaql081 Where JAQL81FEPR = pd_fecpro;
  
    Delete from jaql079 Where JAQL79FEPR = pd_fecpro;
  
    Delete from jaql080 Where JAQL80FEPR = pd_fecpro;
  
    commit;
  
    for i in cta loop
      Proceso_CV(pd_fecini,
                 pd_fecfin,
                 pd_fecpro,
                 Tcbio,
                 i.pn_ctaini,
                 i.pn_ctafin);
    
      Proceso_DPF(pd_fecini,
                  pd_fecfin,
                  pd_fecpro,
                  Tcbio,
                  i.pn_ctaini,
                  i.pn_ctafin);
    end loop;
  
    Cartera(pd_fecini, pd_fecfin, pd_fecpro, Tcbio);
  
    for j in promotor loop
    
      Paga_Captacion(j.ubuser, j.prfgcod, pd_fecini, pd_fecpro);
    
      Paga_Cartera(j.ubuser,
                   j.prfgcod,
                   pd_fecpro,
                   j.tp1nro3,
                   pd_fecini,
                   pd_fecfin);
    end loop;
  
    for j in ejecutivo loop
    
      Paga_Captacion(j.ubuser, j.prfgcod, pd_fecini, pd_fecpro);
    
      Paga_Cartera(j.ubuser,
                   j.prfgcod,
                   pd_fecpro,
                   j.tp1nro3,
                   pd_fecini,
                   pd_fecfin);
    end loop;
  end;

  ----------------------------------------------------------------------

  procedure Proceso_CV(pd_fecini date,
                       pd_fecfin date,
                       pd_fecpro date,
                       Tcbio     number,
                       pn_ctaini number,
                       pn_ctafin number) is
  
    Corte_cal number;
  
    cursor cta_vista is
      select *
        from fsd011
       where pgcod = 1
         and sccta >= pn_ctaini
         and sccta <= pn_ctafin
         and scmod = 21
         and scmda in (0, 101)
         and scpap = 0
            --and sccta in (1659560)
         and ((Scfval >= pd_fecini and Scfval <= pd_fecfin) or
             (Scfcon >= pd_fecini and Scfcon <= pd_fecfin));
  
    vpepais     fsd001.pepais%type;
    vpetdoc     fsd001.petdoc%type;
    vpendoc     fsd001.pendoc%type;
    vpetipo     fsd001.petipo%type;
    vJAQL79TIPE jaql079.jaql79tipe%type;
    --
    TipoSal char(2);
    TipoCli number(1);
    vScfval fsd011.Scfval%type;
    Feccan  date;
    --
    vagente  fst046.ubuser%type;
    vUbsuc   fst046.ubsuc%type;
    vPrfGCod prfu00.prfgcod%type;
    Paga_com char(1);
    --
    sucori number(3);
    fcon   date;
    ptrmod fsd016.itmod%type;
    ptrnro fsd016.ittran%type;
    nrel   fsd016.itnrel%type;
    impmov number(17, 2);
  
    --
    vFecAnt    date;
    cli_fecini date;
    CliNuevo   char(1);
    NumCliNue  number;
    sal_fecini date;
    sal_fecfin date;
    Proaho     number(17, 2);
    --
    vjaql79mtap number(17, 2);
    vjaql79spap number(17, 2);
    vjaql79mtac number(17, 2);
    vjaql79spac number(17, 2);
    vjaql79clap number(4);
    vjaql79clac number(4);
  
    vmodulo number(3);
    vtipoop number(3);
    esanali number(1);
  
  begin
    begin
      select to_number(JAQL77COEF)
        into Corte_cal
        from jaql077
       Where JAQL77COPI = 1
         and JAQL77CORR = 1;
    exception
      when no_data_found then
        Corte_cal := 0;
    end;
  
    for i in cta_vista loop
    
      Titular(i.pgcod, i.sccta, vpepais, vpetdoc, vpendoc, vpetipo);
    
      If vpetipo = 'J' then
        vJAQL79TIPE := 2;
      Else
        vJAQL79TIPE := 1;
      End If;
    
      If i.scstat = 99 then
        feccan := i.scfulm;
      else
        feccan := null;
      end if;
    
      Case
        when (i.Scfval >= pd_fecini And i.Scfval <= pd_fecfin) then
          -- aperturados
          TipoSal := 'AP';
          TipoCli := 1;
          vScfval := i.Scfval;
        when (i.Scfcon >= pd_fecini And i.Scfcon <= pd_fecfin And
             i.Scfcon > i.Scfval) then
          --activados
          TipoSal := 'AC';
          TipoCli := 2;
          vScfval := i.Scfcon;
        else
          TipoSal := null;
          TipoCli := null;
          vScfval := null;
      end case;
    
      Agente(i.Pgcod,
             i.Scmod,
             i.Scsuc,
             i.Scmda,
             i.Scpap,
             i.Sccta,
             i.Scoper,
             i.Scsbop,
             i.Sctope,
             vScfval,
             TipoSal,
             vagente,
             vUbsuc);
    
      Paga_Comision(i.Pgcod, vagente, vPrfGCod, paga_com);
    
      if vagente is not null then
        if i.scstat <> 99 or (i.scstat = 99 and i.Scfulm > pd_fecfin) then
        
          SP_DEPO_CV(i.pgcod,
                     i.scsuc,
                     i.scmod,
                     i.scmda,
                     i.scpap,
                     i.sccta,
                     i.scoper,
                     i.scsbop,
                     i.sctope,
                     vScfval,
                     pd_fecfin,
                     sucori,
                     fcon,
                     ptrmod,
                     ptrnro,
                     nrel,
                     impmov);
        
          if i.scmda <> 0 then
            impmov := impmov * Tcbio;
          end if;
        
          Fecha_Antig_cta(i.pgcod,
                          i.scmod,
                          i.scsuc,
                          i.scmda,
                          i.scpap,
                          i.sccta,
                          i.scoper,
                          i.scsbop,
                          i.sctope,
                          vFecAnt);
        
          If vFecAnt is not null then
            cli_fecini := add_months(last_day(to_date(to_char(pd_fecfin,
                                                              'yyyymm'),
                                                      'yyyymm')) + 1,
                                     -1);
          
            if vFecAnt >= cli_fecini and vFecAnt <= pd_fecfin then
              CliNuevo  := 'S';
              NumCliNue := 1;
            else
              CliNuevo  := 'N';
              NumCliNue := 0;
            end if;
          else
            CliNuevo  := 'N';
            NumCliNue := 0;
          end if;
        
          If ptrmod = 99 and ptrnro = 925 then
            --si es cheque toma coo primer d¿a el de la valorizaci¿n
            Sal_FecIni := fcon;
          Else
            Sal_FecIni := vScfval;
          End If;
        
          Sal_FecFin := vScfval + Corte_cal;
        
          if i.sctope = 2 then
            Proaho := 0;
          else
            Saldo_Pro(i.pgcod,
                      i.Scsuc,
                      i.Sccta,
                      i.Scmda,
                      i.Scpap,
                      i.Scoper,
                      i.Scsbop,
                      i.Sctope,
                      i.scrub,
                      Sal_Fecini,
                      Sal_Fecfin,
                      Proaho);
          end if;
        
          if i.scmda <> 0 then
            Proaho := Proaho * Tcbio;
          end if;
        
          if TipoSal = 'AP' then
            vJAQL79MTAP := Impmov;
            vJAQL79SPAP := Proaho;
            vJAQL79CLAP := NumCliNue;
            vJAQL79MTAC := 0;
            vJAQL79SPAC := 0;
            vJAQL79CLAC := 0;
          else
            vJAQL79MTAP := 0;
            vJAQL79SPAP := 0;
            vJAQL79CLAP := 0;
            vJAQL79MTAC := Impmov;
            vJAQL79SPAC := Proaho;
            vJAQL79CLAC := NumCliNue;
          end if;
        
          Inserta_Detalle(pd_fecpro,
                          vagente,
                          i.pgcod,
                          i.scsuc,
                          i.scmod,
                          i.scmda,
                          i.scpap,
                          i.sccta,
                          i.scoper,
                          i.scsbop,
                          i.sctope,
                          vScfval,
                          Feccan,
                          Tiposal,
                          vJAQL79TIPE,
                          ---
                          Impmov,
                          Proaho,
                          0,
                          0,
                          CliNuevo,
                          Paga_com,
                          0,
                          0,
                          null,
                          0,
                          pd_fecini,
                          pd_fecfin);
        
          if Paga_com = 'S' then
          
            vmodulo := i.scmod;
            vtipoop := i.sctope;
          
            select tp1nro3
              into esanali
              from FST198 a
             Where Trim(a.Tp1desc) = trim(vPrfGCod)
               and Tp1cod = 1
               and Tp1cod1 = 10819
               and Tp1corr1 = 3;
          
            if esanali = 1 and i.sctope = 2 then
              vtipoop := 1;
            end if;
          
            Inserta_Detalle_Acum(vagente,
                                 pd_fecpro,
                                 vjaql79tipe,
                                 vmodulo,
                                 vtipoop,
                                 pd_fecini,
                                 pd_fecfin,
                                 vjaql79mtap,
                                 vjaql79spap,
                                 vjaql79mtac,
                                 vjaql79spac,
                                 0,
                                 0,
                                 vjaql79clap,
                                 vjaql79clac,
                                 vPrfGCod,
                                 vUbsuc,
                                 0);
          end if;
        
        end if;
      end if;
    
    end loop;
  
  end;
  ----------------------------------------------------------------------

  procedure Proceso_DPF(pd_fecini date,
                        pd_fecfin date,
                        pd_fecpro date,
                        Tcbio     number,
                        pn_ctaini number,
                        pn_ctafin number) is
  
    cursor cta_plazof is
      select *
        from fsd010
       where pgcod = 1
         and aomod = 22
         and aocta >= pn_ctaini
         and aocta <= pn_ctafin
            --and aocta in (1153214)
         and aofval between pd_fecini and pd_fecfin
         and aopzo > 30;
  
    transf char(1);
  
    vpepais     fsd001.pepais%type;
    vpetdoc     fsd001.petdoc%type;
    vpendoc     fsd001.pendoc%type;
    vpetipo     fsd001.petipo%type;
    vJAQL79TIPE jaql079.jaql79tipe%type;
    --
    TipoSal char(2);
    TipoCli number(1);
    vScfval fsd011.Scfval%type;
    Feccan  date;
    --
    vagente  fst046.ubuser%type;
    vUbsuc   fst046.ubsuc%type;
    vPrfGCod prfu00.prfgcod%type;
    Paga_com char(1);
    --
    impmov number(17, 2);
    --
    vFecAnt    date;
    cli_fecini date;
    CliNuevo   char(1);
    NumCliNue  number;
    --
    vjaql79mtap number(17, 2);
    vjaql79spap number(17, 2);
    vjaql79mtac number(17, 2);
    vjaql79spac number(17, 2);
    vjaql79clap number(4);
    vjaql79clac number(4);
  
    Capta_DPF number;
  
  begin
    for i in cta_plazof loop
    
      Titular(i.pgcod, i.aocta, vpepais, vpetdoc, vpendoc, vpetipo);
    
      If vpetipo = 'J' then
        vJAQL79TIPE := 2;
      Else
        vJAQL79TIPE := 1;
      End If;
    
      If i.aostat = 99 then
        feccan := i.aofe99;
      else
        feccan := null;
      end if;
    
      If i.aosbop = 0 then
        begin
          select 'S' --apertura por transferencia?
            into transf
            from fsd010
           where pgcod = i.pgcod
             and aocta = i.aocta
             and aomod = 22
             and aofe99 = i.aofval
                --and aoimp < i.aoimp
             and rownum = 1
             and aostat = 99;
          TipoSal := 'TR';
        exception
          when no_data_found then
            -- aperturados
            TipoSal := 'AP';
            TipoCli := 1;
            vScfval := i.aofval;
        end;
      else
        TipoSal := null;
        TipoCli := null;
        vScfval := null;
      end if;
    
      Agente(i.Pgcod,
             i.aomod,
             i.aosuc,
             i.aomda,
             i.aopap,
             i.aocta,
             i.aooper,
             i.aosbop,
             i.aotope,
             vScfval,
             TipoSal,
             vagente,
             vUbsuc);
    
      Paga_Comision(i.Pgcod, vagente, vPrfGCod, paga_com);
    
      if vagente is not null then
        select tp1nro2
          into Capta_DPF
          from FST198
         Where Tp1cod = i.Pgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 3
           and Trim(Tp1desc) = trim(vPrfGCod);
      end if;
    
      if vagente is not null /*and TipoSal = 'AP' /*and Capta_DPF = 1*/
       then
        if i.aostat <> 99 or (i.aostat = 99 and i.aofe99 > pd_fecfin) then
          if i.aomda <> 0 then
            impmov := i.aoimp * Tcbio;
          else
            impmov := i.aoimp;
          end if;
        
          If Capta_DPF <> 1 then
            -- si no es ejecutivo solo paga por capataci¿n de clientes
            impmov := 0;
          end if;
        
          TipoSal := 'AP';
          TipoCli := 1;
          vScfval := i.aofval;
        
          Fecha_Antig_cta(i.pgcod,
                          i.aomod,
                          i.aosuc,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          vFecAnt);
        
          If vFecAnt is not null then
            cli_fecini := add_months(last_day(to_date(to_char(pd_fecfin,
                                                              'yyyymm'),
                                                      'yyyymm')) + 1,
                                     -1);
          
            if vFecAnt >= cli_fecini and vFecAnt <= pd_fecfin then
              CliNuevo  := 'S';
              NumCliNue := 1;
            else
              CliNuevo  := 'N';
              NumCliNue := 0;
            end if;
          else
            CliNuevo  := 'N';
            NumCliNue := 0;
          end if;
        
          Inserta_Detalle(pd_fecpro,
                          vagente,
                          i.pgcod,
                          i.aosuc,
                          i.aomod,
                          i.aomda,
                          i.aopap,
                          i.aocta,
                          i.aooper,
                          i.aosbop,
                          i.aotope,
                          vScfval,
                          Feccan,
                          Tiposal,
                          vJAQL79TIPE,
                          ---
                          Impmov,
                          0,
                          0,
                          0,
                          CliNuevo,
                          Paga_com,
                          0,
                          0,
                          null,
                          i.aopzo,
                          pd_fecini,
                          pd_fecfin);
        
          if Paga_com = 'S' then
          
            vJAQL79MTAP := Impmov;
            vJAQL79SPAP := 0;
            vJAQL79CLAP := NumCliNue;
            vJAQL79MTAC := 0;
            vJAQL79SPAC := 0;
            vJAQL79CLAC := 0;
          
            Inserta_Detalle_Acum(vagente,
                                 pd_fecpro,
                                 vjaql79tipe,
                                 i.aomod,
                                 i.aotope,
                                 pd_fecini,
                                 pd_fecfin,
                                 vjaql79mtap,
                                 vjaql79spap,
                                 vjaql79mtac,
                                 vjaql79spac,
                                 0,
                                 0,
                                 vjaql79clap,
                                 vjaql79clac,
                                 vPrfGCod,
                                 vUbsuc,
                                 0);
          end if;
        
        end if;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------

  procedure Cartera(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    Tcbio     number) is
  
    cursor ejec is
      select distinct hjaql61user vagente
        from hjaql061
       where hjaql61fech <= pd_fecfin --between pd_fecini and pd_fecfin
         and hjaql61esta = 'S'
         and hjaql61fein > pd_fecfin
      --and hjaql61user = 'CZEGARRA'
      union
      select distinct jaql61user
        from jaql061
       where jaql61fech <= pd_fecfin --between pd_fecini and pd_fecfin
         and jaql61esta = 'S'
      --and jaql61user = 'CZEGARRA'
      ;
  
    cursor ctas(vhjaql61user char) is
      select *
        from (select distinct x.*,
                              z.hjaql61pais,
                              z.hjaql61tdoc,
                              z.hjaql61ndoc,
                              z.hjaql61user
                from fsd010 x, fsr008 y, hjaql061 z
              --  from fsd010 x, fsr008 y, hjaql061 z
               where x.pgcod = y.pgcod
                 and x.aocta = y.ctnro
                 and y.pepais = z.hjaql61pais
                 and y.petdoc = z.hjaql61tdoc
                 and y.pendoc = z.hjaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and x.aomod = 22
                 and x.aopzo > 30
                 and z.hjaql61user = vhjaql61user
                 and hjaql61fech <= pd_fecfin --between pd_fecini and pd_fecfin
                 and hjaql61esta = 'S'
                 and hjaql61fein > pd_fecfin
                 and ((aofval between pd_fecini and pd_fecfin) or
                     (aofe99 between pd_fecini and pd_fecfin and
                     aostat = 99 and aofvto between pd_fecini and
                     pd_fecfin))
              --and x.aocta = 442161
              union
              select distinct x.*,
                              z.jaql61pais,
                              z.jaql61tdoc,
                              z.jaql61ndoc,
                              z.jaql61user
                from fsd010 x, fsr008 y, jaql061 z
              --  from fsd010 x, fsr008 y, hjaql061 z
               where x.pgcod = y.pgcod
                 and x.aocta = y.ctnro
                 and y.pepais = z.jaql61pais
                 and y.petdoc = z.jaql61tdoc
                 and y.pendoc = z.jaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and x.aomod = 22
                 and x.aopzo > 30
                 and z.jaql61user = vhjaql61user
                 and z.jaql61esta = 'S'
                 and z.jaql61fech <= pd_fecfin --between pd_fecini and pd_fecfin
                 and ((aofval between pd_fecini and pd_fecfin) or
                     (aofe99 between pd_fecini and pd_fecfin and
                     aostat = 99 and aofvto between pd_fecini and
                     pd_fecfin))
              --and x.aocta = 442161
              )
       order by aocta, aooper desc;
  
    /*    cursor cancel(vaocta number, vaofval date) is
        select *
          from fsd010 a
         where pgcod = 1
           and aocta = vaocta
           and aomod = 22
           and aofe99 = vaofval
           and aofvto between pd_fecini and pd_fecfin
           and aostat = 99
           and not exists (select 1
                  from fsd010 b
                 where b.pgcod = 1
                   and b.aocta = a.aocta
                   and b.aooper = a.aooper
                   and b.aosbop = a.aosbop + 1
                   and aomod = 22
                   and aostat <> 99)
         order by a.aoimp desc;
    */
    vpepais     fsd001.pepais%type;
    vpetdoc     fsd001.petdoc%type;
    vpendoc     fsd001.pendoc%type;
    vpetipo     fsd001.petipo%type;
    vJAQL79TIPE jaql079.jaql79tipe%type;
    --
    vFecAnt    date;
    cli_fecini date;
    CliNuevo   char(1);
    NumCliNue  number;
    --    
  
    transf  char(1);
    TipoSal char(2);
  
    impmov number(17, 2);
    --impmov_can number(17, 2);
    impmov_tot number(17, 2);
  
    vjaql81mtre number(17, 2);
    vjaql81mtca number(17, 2);
    vjaql81au07 number(17, 2);
    vjaql81au08 number(17, 2);
    impcan      number(17, 2);
    vjaql81au03 char(50);
    vjaql81mtap number(17, 2);
  
    reno   char(1);
    feccan date;
  
    vUbsuc   fst046.ubsuc%type;
    vPrfGCod prfu00.prfgcod%type;
    Paga_com char(1);
    --OpeCancel   char(1);
    NumOpe number;
    --OpeCancel_x char(1);
    Sumcancel number(17, 2);
    --SumDifInc   number(17, 2);
    --SumIncNeg   number(17, 2);
    --Operac      number(9);
  
    vctifin char(1);
    subasta char(1);
    captada char(1);
  
  begin
    for i in ejec loop
    
      for j in ctas(i.vagente) loop
      
        vjaql81mtre := 0;
        vjaql81mtca := 0;
        vjaql81au07 := 0;
        impmov_tot  := 0;
        vjaql81au03 := '';
        Sumcancel   := 0;
        vjaql81au08 := 0;
        NumOpe      := 0;
        feccan      := null;
        impcan      := 0;
      
        select ctifin into vctifin from fsd008 where ctnro = j.aocta;
      
        begin
          select 'S'
            into subasta
            from FST198
           Where Tp1cod = 1
             and Tp1cod1 = 10819
             and Tp1corr1 = 6
             and Tp1corr2 = j.aocta
             and Tp1corr3 = j.aooper;
        exception
          when no_data_found then
            subasta := 'N';
        end;
      
        begin
          select 'S'
            into captada
            from jaql081
           where jaql81fepr = pd_fecpro
             and jaql81pgco = j.pgcod
             and jaql81scsu = j.aosuc
             and jaql81scmd = j.aomod
             and jaql81scmo = j.aomda
             and jaql81scpa = j.aopap
             and jaql81scct = j.aocta
             and jaql81scop = j.aooper
             and jaql81scsb = j.aosbop
             and jaql81scto = j.aotope
             and jaql81tipo = 'AP';
        exception
          when no_data_found then
            captada := 'N';
        end;
      
        if vctifin = 'N' and subasta = 'N' and captada = 'N' then
          Titular(j.pgcod, j.aocta, vpepais, vpetdoc, vpendoc, vpetipo);
        
          If vpetipo = 'J' then
            vJAQL79TIPE := 2;
          Else
            vJAQL79TIPE := 1;
          End If;
        
          if j.aomda <> 0 then
            impmov := j.aoimp * Tcbio;
          else
            impmov := j.aoimp;
          end if;
        
          Fecha_Antig_cta(j.pgcod,
                          j.aomod,
                          j.aosuc,
                          j.aomda,
                          j.aopap,
                          j.aocta,
                          j.aooper,
                          j.aosbop,
                          j.aotope,
                          vFecAnt);
        
          If vFecAnt is not null then
            cli_fecini := add_months(last_day(to_date(to_char(pd_fecfin,
                                                              'yyyymm'),
                                                      'yyyymm')) + 1,
                                     -1);
          
            if vFecAnt >= cli_fecini and vFecAnt <= pd_fecfin then
              CliNuevo  := 'S';
              NumCliNue := 1;
            else
              CliNuevo  := 'N';
              NumCliNue := 0;
            end if;
          else
            CliNuevo  := 'N';
            NumCliNue := 0;
          end if;
        
          if j.aofval between pd_fecini and pd_fecfin then
            If j.aosbop > 0 then
              if j.aostat <> 99 or j.aofe99 > pd_fecfin then
                --renovadas
                TipoSal := 'RE';
              end if;
            Else
              -- incremento capital
              begin
                select 'IN', jaqy686mto
                  into TipoSal, impmov
                  from jaqy686
                 where jaqy686pgc = j.pgcod
                   and jaqy686suc = j.aosuc
                   and jaqy686mda = j.aomda
                   and jaqy686pap = j.aopap
                   and jaqy686cta = j.aocta
                   and jaqy686ope = j.aooper
                   and jaqy686sub = j.aosbop
                   and jaqy686top = j.aotope
                   and jaqy686mod = j.aomod;
              exception
                when no_data_found then
                  if j.aostat <> 99 or
                     (j.aostat = 99 and j.aofe99 > pd_fecfin) then
                    TipoSal := 'AP';
                  else
                    TipoSal := 'XX';
                  end if;
              end;
            end if;
          end if;
        
          --canceladas, Cuentas canceladas que aperturaron con incremento ese mismo dia 
          if (j.aofe99 between pd_fecini and pd_fecfin) and
             (j.aofvto between pd_fecini and pd_fecfin) then
            begin
              select 'S' --aperturo otro dpf el mismo d¿a q cancel¿?
                into transf
                from fsd010 can
               where pgcod = j.pgcod
                 and aocta = j.aocta
                 and aomod = 22
                 and aofval = j.aofe99
                 and aosbop = 0
                 and not exists (select 1
                        from jaql081 z
                       where jaql81fepr = pd_fecpro
                         and jaql81pgco = can.pgcod
                         and jaql81scsu = can.aosuc
                         and jaql81scmd = can.aomod
                         and jaql81scmo = can.aomda
                         and jaql81scpa = can.aopap
                         and jaql81scct = can.aocta
                         and jaql81scop = can.aooper
                         and jaql81scsb = can.aosbop
                         and jaql81scto = can.aotope
                         and jaql81tipo = 'AP'); --borrar
            exception
              when no_data_found then
                transf := 'N';
              when too_many_rows then
                transf := 'S';
              when others then
                dbms_output.put_line('aperturo otro dpf el mismo d¿a q cancel¿?');
                dbms_output.put_line(j.aocta);
            end;
          
            begin
              select 'S' -- se cancelo la cta porq ese d¿a renov¿?
                into reno
                from fsd010
               where pgcod = j.pgcod
                 and aocta = j.aocta
                 and aomod = 22
                 and aooper = j.aooper
                 and aosbop = j.aosbop + 1
                 and aofval = j.aofe99;
            exception
              when no_data_found then
                reno := 'N';
              when too_many_rows then
                reno := 'S';
              when others then
                dbms_output.put_line('se cancelo la cta porq ese d¿ea renov¿?');
                dbms_output.put_line(j.aocta);
            end;
          
            If Reno = 'N' then
            
              If transf = 'S' then
                TipoSal := 'CI';
                impcan  := 0;
                begin
                  select 'CI', jaql81au08
                    into TipoSal, impcan
                    from jaql081
                   where jaql81fepr = pd_fecpro
                     and jaql81user = i.vagente
                     and jaql81tipo = 'IN'
                     and jaql81scct = j.aocta
                     and instr(jaql81au03, j.aooper, 1) > 0;
                exception
                  when no_data_found then
                    TipoSal := 'CA';
                  when too_many_rows then
                    select 'CI', sum(nvl(jaql81au08, 0))
                      into TipoSal, impcan
                      from jaql081
                     where jaql81fepr = pd_fecpro
                       and jaql81user = i.vagente
                       and jaql81tipo = 'IN'
                       and jaql81scct = j.aocta
                       and instr(jaql81au03, j.aooper, 1) > 0;
                end;
              Else
                TipoSal := 'CA';
              end if;
            
              If TipoSal = 'CI' and impcan <> 0 then
                TipoSal := 'CA';
              end if;
            
              if TipoSal = 'CA' then
                --if (j.aofvto >= pd_fecini and j.aofvto <= pd_fecfin) then
                --  TipoSal := 'CN';
                --else
                feccan := j.aofe99;
              
                impmov := Monto_Cancelacion(j.Pgcod,
                                            j.aomod,
                                            j.aomda,
                                            j.aopap,
                                            j.aocta,
                                            j.aosuc,
                                            j.aooper,
                                            j.aosbop,
                                            j.aotope,
                                            j.aofe99);
              
                if impmov = 0 then
                  impmov := j.aoimp;
                end if;
              
                if j.aomda <> 0 then
                  impmov := impmov * Tcbio;
                end if;
              
                if impcan <> 0 then
                  impmov := -1 * impcan;
                end if;
                --end if;
              end if;
            else
              TipoSal := 'RC';
            end if;
          
          end if;
        
          if TipoSal in ('RE', 'IN', 'CA' /*, 'AP'*/) then
          
            case
              when TipoSal = 'IN' then
                vjaql81mtre := 0;
                vjaql81mtca := 0;
                vjaql81au07 := impmov;
                vjaql81mtap := 0;
                CliNuevo    := '';
                NumCliNue   := 0;
              when TipoSal = 'RE' then
                vjaql81mtre := impmov;
                vjaql81mtca := 0;
                vjaql81au07 := 0;
                vjaql81mtap := 0;
                CliNuevo    := '';
                NumCliNue   := 0;
              when TipoSal = 'CA' then
                vjaql81mtre := 0;
                vjaql81mtca := impmov;
                vjaql81au07 := 0;
                vjaql81mtap := 0;
                CliNuevo    := '';
                NumCliNue   := 0;
              when TipoSal = 'AP' then
                vjaql81mtre := 0;
                vjaql81mtca := 0;
                vjaql81au07 := 0;
                vjaql81mtap := impmov;
            end case;
          
            Paga_Comision(j.Pgcod, i.vagente, vPrfGCod, paga_com);
            vUbsuc := Sucursal_Eje(j.Pgcod, i.vagente);
          
            Inserta_Detalle(pd_fecpro,
                            i.vagente,
                            j.pgcod,
                            j.aosuc,
                            j.aomod,
                            j.aomda,
                            j.aopap,
                            j.aocta,
                            j.aooper,
                            j.aosbop,
                            j.aotope,
                            j.aofval,
                            feccan,
                            Tiposal,
                            vJAQL79TIPE,
                            ---
                            vjaql81mtap,
                            0,
                            vjaql81mtre,
                            vjaql81mtca,
                            CliNuevo,
                            'S',
                            vjaql81au07,
                            vjaql81au08,
                            vjaql81au03,
                            j.aopzo,
                            pd_fecini,
                            pd_fecfin);
          
            Inserta_Detalle_Acum(i.vagente,
                                 pd_fecpro,
                                 vjaql79tipe,
                                 j.aomod,
                                 j.aotope,
                                 pd_fecini,
                                 pd_fecfin,
                                 vjaql81mtap,
                                 0,
                                 0,
                                 0,
                                 vjaql81mtre,
                                 vjaql81mtca,
                                 0,
                                 0,
                                 vPrfGCod,
                                 vUbsuc,
                                 Sumcancel);
          
          end if;
        end if;
      end loop;
    end loop;
  end;

  ----------------------------------------------------------------------
  procedure Titular(vpgcod  number,
                    vctnro  number,
                    vpepais out number,
                    vpetdoc out number,
                    vpendoc out char,
                    vpetipo out char) is
  begin
    begin
      select Pepais, Petdoc, Pendoc
        into vPepais, vPetdoc, vPendoc
        from fsr008
       where pgcod = vpgcod
         and ctnro = vctnro
         and Ttcod = 1
         and Cttfir = 'T';
    exception
      when others then
        vPepais := 0;
        vPetdoc := 0;
        vPendoc := '';
    end;
  
    begin
      select petipo
        into vpetipo
        from FSD001
       Where Pepais = vPepais
         and Petdoc = vPetdoc
         and Pendoc = vPendoc;
    exception
      when others then
        vpetipo := null;
    end;
  end;

  ----------------------------------------------------------------------
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
        /*        begin
          select Pefalt
            into vFecAnt
            from FSD001
           Where Pepais = vPepais
             and Petdoc = vPetdoc
             and Pendoc = vPendoc;
        exception
          when no_data_found then
            vFecAnt := trunc(sysdate);
        end;*/
      End if;
  End;

  ----------------------------------------------------------------------
  procedure Fecha_Antig_cta(vJAQL106PGC NUMBER,
                            vJAQL106MOD NUMBER,
                            vJAQL106SUC NUMBER,
                            vJAQL106MDA NUMBER,
                            vJAQL106PAP NUMBER,
                            vJAQL106CTA NUMBER,
                            vJAQL106OPE NUMBER,
                            vJAQL106SBO NUMBER,
                            vJAQL106TOP NUMBER,
                            vFecAnt     out date) is
  
  begin
    select min(JAQL106Fhc)
      into vFecAnt
      from jaql106
     Where JAQL106PGC = vJAQL106PGC
       and JAQL106MOD = vJAQL106MOD
       and JAQL106SUC = vJAQL106SUC
       and JAQL106MDA = vJAQL106MDA
       and JAQL106PAP = vJAQL106PAP
       and JAQL106CTA = vJAQL106CTA
       and JAQL106OPE = vJAQL106OPE
       and JAQL106SBO = vJAQL106SBO
       and JAQL106TOP = vJAQL106TOP;
  exception
    when no_data_found then
      vFecAnt := null;
  end;

  ----------------------------------------------------------------------              

  procedure Ejecutivo(vpgcod      number,
                      vpepais     number,
                      vpetdoc     number,
                      vpendoc     char,
                      pd_fecini   date,
                      pd_fecfin   date,
                      vJAQL61USER out char,
                      vUbsuc      out number) is
 lc_ejecutivo char(10);                      
  begin
    begin
      select JAQL61USER
        into lc_ejecutivo
        from jaql061
       Where JAQL61PGCO = vPgcod
         and JAQL61PAIS = vpepais
         and JAQL61TDOC = vpetdoc
         and JAQL61NDOC = vPendoc
         and JAQL61ESTA = 'S'
         and jaql61fech between pd_fecini and pd_fecfin;
    exception
      when no_data_found then
        begin
          select hJAQL61USER
            into lc_ejecutivo
            from (select hJAQL61USER
                    from hjaql061
                   Where hJAQL61PGCO = vPgcod
                     and hJAQL61PAIS = vpepais
                     and hJAQL61TDOC = vpetdoc
                     and hJAQL61NDOC = vPendoc
                     and hjaql61fech <= pd_fecfin --between pd_fecini and pd_fecfin
                     and hjaql61esta = 'S'
                     and hjaql61fein > pd_fecfin
                   order by hjaql61fech desc)
           where rownum = 1;
        exception
          when no_data_found then
            lc_ejecutivo := null;
        end;
    end;
    vJAQL61USER := lc_ejecutivo;
  
    vUbsuc := Sucursal_Eje(vPgcod, lc_ejecutivo);
  
  end;
  ----------------------------------------------------------------------
  procedure Agente(vPgcod      number,
                   vScmod      number,
                   vScsuc      number,
                   vScmda      number,
                   vScpap      number,
                   vSccta      number,
                   vScoper     number,
                   vScsbop     number,
                   vSctope     number,
                   vScfval     date,
                   Tipo        char,
                   vJAQL61USER out char,
                   vUbsuc      out number) is
  
    vagtecod  fst156.agtecod%type;
    lc_agente char(10);
  
  begin
  
    begin
      If Tipo in ('AP', 'TR') then
        begin
          select to_number(P1ndoc)
            into vagtecod
            from fsr012
           Where P1cod = vPgcod
             and P1mod = vScmod
             and P1suc = vScsuc
             and P1mda = vScmda
             and P1pap = vScpap
             and P1cta = vSccta
             and P1oper = vScoper
             and P1sbop = vScsbop
             and P1tope = vSctope
             and Relcod = 77
             and to_number(P1ndoc) <> 0;
        
          begin
            select AgteUsr
              into lc_agente
              from fst156
             where agtecod = vagtecod;
          exception
            when others then
              lc_agente := null;
          end;
          vJAQL61USER := lc_agente;
        
        exception
          when no_data_found then
            vJAQL61USER := null;
        end;
      
      else
      
        begin
          select substr(Trim(Cbietxt1), 1, 10)
            into lc_agente
            from fsd450
           Where Cbieemp = vPgcod
             and Cbiemod = vScmod
             and Cbiesuc = vScsuc
             and Cbiemda = vScmda
             and Cbiepap = vScpap
             and Cbiecta = vSccta
             and Cbieope = vScoper
             and Cbiesub = vScsbop
             and Cbietop = vSctope
             and Cbiefec = vScfval
             and Cbieant = 81;
        exception
          when no_data_found then
            lc_agente := null;
          when too_many_rows then
            select substr(Trim(Cbietxt1), 1, 10)
              into lc_agente
              from (select Cbietxt1
                      from fsd450
                     Where Cbieemp = vPgcod
                       and Cbiemod = vScmod
                       and Cbiesuc = vScsuc
                       and Cbiemda = vScmda
                       and Cbiepap = vScpap
                       and Cbiecta = vSccta
                       and Cbieope = vScoper
                       and Cbiesub = vScsbop
                       and Cbietop = vSctope
                       and Cbiefec = vScfval
                       and Cbieant = 81
                     order by cbierel) a
             where rownum = 1;
        end;
      end if;
      vJAQL61USER := lc_agente;
      vUbsuc := Sucursal_Eje(vPgcod, lc_agente);
    
      if vUbsuc is null then
        vJAQL61USER := null;
      end if;
    
    end;
  end;
  ----------------------------------------------------------------------  
  procedure Saldo_Pro(vpgcod  number,
                      vScsuc  number,
                      vSccta  number,
                      vScmda  number,
                      vScpap  number,
                      vScoper number,
                      vScsbop number,
                      vSctope number,
                      vRubro  number,
                      Fecini  date,
                      Fecfin  date,
                      vscsdo  out number) is
  
    Rrrubr number;
    Totaho number;
    Capaho number;
    Intaho number;
  
  begin
  
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
         and BCFech >= Fecini
         and BCFech <= Fecfin;
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
         and BCFech >= Fecini
         and BCFech <= Fecfin;
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
  
  end;

  ----------------------------------------------------------------------  
  function Sucursal_Eje(vPgcod number, vUbuser char) return number is
  
    vUbsuc   fst046.ubsuc%type;
    vUbuser2 fst046.ubuser%type;
  
  begin
    vUbuser2 := vUbuser;
    begin
      select Ubsuc
        into vUbsuc
        from fst046
       Where Pgcod = vPgcod
         and Ubuser = vUbuser2;
    exception
      when no_data_found then
        vUbsuc := null;
    end;
  
    return vUbsuc;
  end;

  ----------------------------------------------------------------------  
  function Es_Ejecutivo(vPgcod number, vUbuser char) return char is
  
    cursor perfil is
      select Trim(Tpdesc) prfgcod
        from Fst098
       Where Pgcod = vPgcod
         and Tpcod = 7617;
  
    es_ejec  char(1);
    vprfgcod prfu00.prfgcod%type;
  
  begin
  
    for i in perfil loop
    
      vprfgcod := i.prfgcod;
      begin
        select 'S'
          into es_ejec
          from prfu00
         Where Pgcod = vPgcod
           and PrfGCod = vPrfGCod
           and Ubuser = vUbuser;
      exception
        when too_many_rows then
          es_ejec := 'S';
        when no_data_found then
          es_ejec := 'N';
      end;
      if es_ejec = 'S' then
        exit;
      end if;
    end loop;
  
    return es_ejec;
  
  end;

  ----------------------------------------------------------------------  
  procedure Paga_Comision(vPgcod   number,
                          vUbuser  char,
                          vPrfGCod out char,
                          paga_com out char) is
  
    cursor perfil is
      select Trim(Tp1desc) prfgcod
        from FST198
       Where Tp1cod = vPgcod
         and Tp1cod1 = 10819
         and Tp1corr1 = 3;
  
  begin
  
    for i in perfil loop
    
      vprfgcod := i.prfgcod;
    
      begin
        select 'S'
          into paga_com
          from prfu00
         Where Pgcod = vPgcod
           and PrfGCod = vPrfGCod
           and Ubuser = vUbuser;
      
      exception
        when too_many_rows then
          paga_com := 'S';
        when no_data_found then
          paga_com := 'N';
      end;
      if paga_com = 'S' then
        exit;
      end if;
    end loop;
  
  end;

  ----------------------------------------------------------------------  

  Function Monto_Cancelacion(vPgcod  number,
                             vScmod  number,
                             vScmda  number,
                             vScpap  number,
                             vSccta  number,
                             vScsuc  number,
                             vScoper number,
                             vScsbop number,
                             vSctope number,
                             vScfulm date) return number is
  
    Impmov number(17, 2);
  begin
    begin
      select Pp1cap + Pp1int
        into Impmov
        from FSD602
       Where Pgcod = vPgcod
         and Ppmod = vScmod
         and Ppmda = vScmda
         and Pppap = vScpap
         and Ppcta = vSccta
         and Ppsuc = vScsuc
         and Ppoper = vScoper
         and Ppsbop = vScsbop
         and Pptope = vSctope
         and Pptipo = 'M'
         and Pp1fech = vScfulm
         and d602mo = 22
         and d602tr in (300, 310)
         and D602co = 'S';
    exception
      when no_data_found then
        Impmov := 0;
      when others then
        null;
    end;
    return Impmov;
  end;
  ----------------------------------------------------------------------  

  procedure Inserta_Detalle(vjaql81fepr date,
                            vjaql81user char,
                            vjaql81pgco number,
                            vjaql81scsu number,
                            vjaql81scmd number,
                            vjaql81scmo number,
                            vjaql81scpa number,
                            vjaql81scct number,
                            vjaql81scop number,
                            vjaql81scsb number,
                            vjaql81scto number,
                            vjaql81feva date,
                            vjaql81feca date,
                            vjaql81tipo char,
                            vJAQL81TIPE char,
                            ---
                            vjaql81mtap number,
                            vjaql81mtsp number,
                            vjaql81mtre number,
                            vjaql81mtca number,
                            vjaql81clnu char,
                            vjaql81au02 char,
                            vjaql81au07 number,
                            vjaql81au08 number,
                            vjaql81au03 char,
                            vjaql81au04 number,
                            vjaql81fein date,
                            vjaql81fefi date) is
  
    descerror varchar2(250);
  
  begin
  
    insert into jaql081
      (jaql81fepr,
       jaql81user,
       jaql81pgco,
       jaql81scsu,
       jaql81scmd,
       jaql81scmo,
       jaql81scpa,
       jaql81scct,
       jaql81scop,
       jaql81scsb,
       jaql81scto,
       jaql81feva,
       jaql81feca,
       jaql81tipo,
       JAQL81TIPE,
       ---
       jaql81mtap,
       jaql81mtsp,
       jaql81mtre,
       jaql81mtca,
       jaql81clnu,
       ---
       jaql81au01,
       jaql81au02,
       jaql81au07,
       jaql81au08,
       jaql81au03,
       jaql81au04,
       jaql81au10,
       jaql81au11)
    values
      (vjaql81fepr,
       vjaql81user,
       vjaql81pgco,
       vjaql81scsu,
       vjaql81scmd,
       vjaql81scmo,
       vjaql81scpa,
       vjaql81scct,
       vjaql81scop,
       vjaql81scsb,
       vjaql81scto,
       vjaql81feva,
       vjaql81feca,
       vjaql81tipo,
       vJAQL81TIPE,
       ---
       vjaql81mtap,
       vjaql81mtsp,
       vjaql81mtre,
       vjaql81mtca,
       vjaql81clnu,
       ---
       to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'),
       vjaql81au02,
       vjaql81au07,
       vjaql81au08,
       vjaql81au03,
       vjaql81au04,
       vjaql81fein,
       vjaql81fefi);
  
    commit;
  
  exception
    when others then
      descerror := sqlerrm;
      dbms_output.put_line('Inserta detalle');
      dbms_output.put_line(descerror || '-' || vjaql81tipo);
      dbms_output.put_line(vjaql81scct);
  end;

  ----------------------------------------------------------------------  
  procedure Inserta_Detalle_Acum(vjaql79user char,
                                 vjaql79fepr date,
                                 vjaql79tipe number,
                                 vjaql79modu number,
                                 vjaql79tope number,
                                 vjaql79fein date,
                                 vjaql79fefi date,
                                 vjaql79mtap number,
                                 vjaql79spap number,
                                 vjaql79mtac number,
                                 vjaql79spac number,
                                 vjaql79mtre number,
                                 vjaql79mtca number,
                                 vjaql79clap number,
                                 vjaql79clac number,
                                 vPrfGCod    char,
                                 vUbsuc      number,
                                 vjaql79au07 number) is
  begin
    insert into jaql079
      (jaql79user,
       jaql79fepr,
       jaql79tipe,
       jaql79modu,
       jaql79tope,
       jaql79fein,
       jaql79fefi,
       jaql79mtap,
       jaql79spap,
       jaql79mtac,
       jaql79spac,
       jaql79mtre,
       jaql79mtca,
       jaql79au07,
       jaql79clap,
       jaql79clac,
       jaql79au01,
       jaql79au02,
       jaql79au04,
       jaql79au05)
    
    values
      (vjaql79user,
       vjaql79fepr,
       vjaql79tipe,
       vjaql79modu,
       vjaql79tope,
       vjaql79fein,
       vjaql79fefi,
       vjaql79mtap,
       vjaql79spap,
       vjaql79mtac,
       vjaql79spac,
       vjaql79mtre,
       vjaql79mtca,
       vjaql79au07,
       vjaql79clap,
       vjaql79clac,
       vPrfGCod,
       to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'),
       1,
       vUbsuc);
  
    commit;
  
  exception
    when dup_val_on_index then
      update jaql079
         set JAQL79MTAP = JAQL79MTAP + nvl(vJAQL79MTAP, 0),
             JAQL79SPAP = JAQL79SPAP + nvl(vJAQL79SPAP, 0),
             JAQL79MTAC = JAQL79MTAC + nvl(vJAQL79MTAC, 0),
             JAQL79SPAC = JAQL79SPAC + nvl(vJAQL79SPAC, 0),
             JAQL79MTRE = JAQL79MTRE + nvl(vJAQL79MTRE, 0),
             JAQL79MTCA = JAQL79MTCA + nvl(vJAQL79MTCA, 0),
             JAQL79AU07 = JAQL79AU07 + nvl(vJAQL79AU07, 0),
             JAQL79CLAC = JAQL79CLAC + vJAQL79CLAC,
             JAQL79CLAP = JAQL79CLAP + vJAQL79CLAP,
             jaql79au04 = jaql79au04 + 1
       Where JAQL79USER = vJAQL79USER
         and JAQL79FEPR = vJAQL79FEPR
         and JAQL79TIPE = vJAQL79TIPE
         and JAQL79MODU = vJAQL79MODU
         and JAQL79TOPE = vJAQL79TOPE;
    
      commit;
  end;

  ----------------------------------------------------------------------  

  procedure Actualiza_Det_Meta(vjaql79user char,
                               vjaql79fepr date,
                               vjaql79modu number,
                               vjaql79tope number,
                               vjaql79memt char,
                               vjaql79mecl char,
                               vjaql79comt number,
                               vjaql79cocl number) is
  begin
    update jaql079
       set JAQL79MEMT = vJAQL79MEMT,
           JAQL79MECL = vJAQL79MECL,
           JAQL79COMT = vJAQL79COMT,
           JAQL79COCL = vJAQL79COCL
     Where JAQL79USER = vJAQL79USER
       and JAQL79FEPR = vJAQL79FEPR
       and JAQL79MODU = vJAQL79MODU
       and JAQL79TOPE = vJAQL79TOPE
       and JAQL79TIPE = 1;
  
    if sql%notfound then
      update jaql079
         set JAQL79MEMT = vJAQL79MEMT,
             JAQL79MECL = vJAQL79MECL,
             JAQL79COMT = vJAQL79COMT,
             JAQL79COCL = vJAQL79COCL
       Where JAQL79USER = vJAQL79USER
         and JAQL79FEPR = vJAQL79FEPR
         and JAQL79MODU = vJAQL79MODU
         and JAQL79TOPE = vJAQL79TOPE
         and JAQL79TIPE = 2;
    end if;
  
    commit;
  end;

  ----------------------------------------------------------------------  
  procedure Paga_Captacion(vJAQL79USER char,
                           vprfgcod    char,
                           pd_fecini   date,
                           --pd_fecfin   date,
                           pd_fecpro date) is
  
    cursor prod(vTp1corr2x number) is
      select *
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 4
         and Tp1corr2 = vTp1corr2x
         and Tp1imp2 <> 0;
  
    cursor suma(Modulo_Px number, Totope_Px number) is
      select *
        from jaql079
       Where JAQL79FEPR = pd_fecpro
         and JAQL79USER = vJAQL79USER
         and JAQL79MODU = Modulo_Px
         and JAQL79TOPE = Totope_Px;
  
    Salir     char(1);
    vTp1corr2 number(9);
  
    Modulo_M number(3);
    Totope_M number(3);
    Modulo_P number(3);
    Totope_P number(3);
    vTp1Imp1 number;
  
    vUbsuc   fst046.ubsuc%type;
    Meta_Mto number(17, 2);
    Meta_Cli number;
    TotApePF number(17, 2);
    TotProPF number(17, 2);
    TotApePJ number(17, 2);
    TotProPJ number(17, 2);
  
    Meta number(17, 2);
  
    vJAQL79MEMT   char(1);
    PorApe        number(13, 7);
    Porpro        number(13, 7);
    FactPF        number(13, 7);
    FactPJ        number(13, 7);
    JAQL79COMT_PF number(17, 2);
    JAQL79COMT_PJ number(17, 2);
    vJAQL79COMT   number(17, 2);
  
    ComCli      number(13, 7);
    vJAQL79MECL char(1);
    vJAQL79COCL number(17, 2);
  
    vTp1imp2 number;
  
  begin
    Salir     := 'N';
    vTp1corr2 := 0;
  
    While Salir = 'N' loop
    
      Meta_Mto      := 0;
      Meta_Cli      := 0;
      TotApePF      := 0;
      TotProPF      := 0;
      TotApePJ      := 0;
      TotProPJ      := 0;
      JAQL79COMT_PF := 0;
      JAQL79COMT_PJ := 0;
      vJAQL79COMT   := 0;
      vJAQL79COCL   := 0;
    
      vTp1corr2 := vTp1corr2 + 1;
    
      for i in prod(vTp1corr2) loop
        Modulo_M := (i.Tp1nro1 / 1000);
        Totope_M := i.Tp1nro1 - (Modulo_M * 1000);
        Modulo_P := (i.Tp1nro2 / 1000);
        Totope_P := i.Tp1nro2 - (Modulo_P * 1000);
        vTp1Imp1 := i.Tp1imp1;
        vTp1imp2 := i.Tp1imp2;
      
        for j in suma(Modulo_P, Totope_P) loop
          vUbsuc := j.JAQL79AU05;
        
          If i.tp1imp2 in (1, 2) then
            -- si producto se toma en cuenta para saldo
            If Modulo_P = 21 then
              If Totope_P = 2 then
                Meta_Mto := Meta_Mto + j.JAQL79MTAP;
              else
                Meta_Mto := Meta_Mto + j.JAQL79SPAP + j.JAQL79SPAC;
              end if;
            Else
              Meta_Mto := Meta_Mto + j.JAQL79MTAP;
            End If;
          
            If j.JAQL79TIPE = 1 then
              TotApePF := TotApePF + j.JAQL79MTAP + j.JAQL79MTAC;
              TotProPF := TotProPF + j.JAQL79SPAP + j.JAQL79SPAC;
            Else
              TotApePJ := TotApePJ + j.JAQL79MTAP + j.JAQL79MTAC;
              TotProPJ := TotProPJ + j.JAQL79SPAP + j.JAQL79SPAC;
            End If;
          End If;
        
          If i.tp1imp2 in (1, 3) then
            -- si producto se toma en cuenta para num de clientes
            Meta_Cli := Meta_Cli + j.JAQL79CLAP + j.JAQL79CLAC;
          End If;
        
        end loop;
      end loop;
    
      begin
        select 'N'
          into salir
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10819
           and Tp1corr1 = 4
           and Tp1corr2 = vTp1corr2 + 1
           and Tp1imp2 <> 0
           and rownum = 1;
      exception
        when no_data_found then
          salir := 'S';
      end;
    
      -----------------------
      -- Meta por Saldo
      -----------------------
      If vTp1imp2 in (1, 2) then
        begin
          select JAQL76MONT
            into Meta
            from (select JAQL76MONT
                    from jaql076
                   Where JAQL76TIME = 1 -- Saldo
                     and JAQL76SUCU = (case
                           when vTp1Imp1 <> 0 then
                            vUbsuc
                           else
                            JAQL76SUCU
                         end)
                     and JAQL76FEIN <= pd_fecini
                        --and JAQL76FEFI >= pd_fecfin
                     and JAQL76MODU = Modulo_M
                     and JAQL76TOPE = Totope_M
                     and JAQL76PERF = vPrfGCod
                   order by JAQL76FEIN desc)
           where rownum = 1;
        exception
          when no_data_found then
            Meta := 0;
        end;
      
        If Meta_Mto >= Meta then
          vJAQL79MEMT := 'S';
        
          If Modulo_M = 21 and Totope_M <> 2 then
            begin
              select JAQL77COEF
                into PorApe
                from jaql077
               Where JAQL77COPI = 2
                 and JAQL77CORR = 1;
            exception
              when no_data_found then
                PorApe := 0;
            end;
            begin
              select JAQL77COEF
                into Porpro
                from jaql077
               Where JAQL77COPI = 2
                 and JAQL77CORR = 2;
            exception
              when no_data_found then
                Porpro := 0;
            end;
          End If;
        
          begin
            select JAQL77COEF
              into FactPF
              from jaql077
             Where JAQL77COPI = 3 -- Factor calculo comi
               and JAQL77MODU = Modulo_M
               and JAQL77TOPE = Totope_M
               and JAQL77PERF = vPrfGCod
               and JAQL77SUCU = vUbsuc
               and JAQL77TIPE = 1;
          exception
            when no_data_found then
              begin
                select JAQL77COEF
                  into FactPF
                  from jaql077
                 Where JAQL77COPI = 3 -- Factor calculo comi
                   and JAQL77MODU = Modulo_M
                   and JAQL77TOPE = Totope_M
                   and JAQL77PERF = vPrfGCod
                   and JAQL77SUCU = 999
                   and JAQL77TIPE = 1;
              exception
                when no_data_found then
                  FactPF := 0;
              end;
          end;
        
          begin
            select JAQL77COEF
              into FactPJ
              from jaql077
             Where JAQL77COPI = 3 -- Factor calculo comi
               and JAQL77MODU = Modulo_M
               and JAQL77TOPE = Totope_M
               and JAQL77PERF = vPrfGCod
               and JAQL77SUCU = vUbsuc
               and JAQL77TIPE = 2;
          exception
            when no_data_found then
              begin
                select JAQL77COEF
                  into FactPJ
                  from jaql077
                 Where JAQL77COPI = 3 -- Factor calculo comi
                   and JAQL77MODU = Modulo_M
                   and JAQL77TOPE = Totope_M
                   and JAQL77PERF = vPrfGCod
                   and JAQL77SUCU = 999
                   and JAQL77TIPE = 2;
              exception
                when no_data_found then
                  FactPJ := 0;
              end;
          end;
        
          If Modulo_M = 21 and Totope_M <> 2 then
            JAQL79COMT_PF := ((TotApePF * PorApe / 100) +
                             (TotProPF * Porpro / 100)) * (FactPF / 100);
            JAQL79COMT_PJ := ((TotApePJ * PorApe / 100) +
                             (TotProPJ * Porpro / 100)) * (FactPJ / 100);
          Else
            JAQL79COMT_PF := TotApePF * (FactPF / 100);
            JAQL79COMT_PJ := TotApePJ * (FactPJ / 100);
          End if;
        
          vJAQL79COMT := JAQL79COMT_PF + JAQL79COMT_PJ;
        Else
          vJAQL79MEMT := 'N';
          vJAQL79COMT := 0;
        End If;
      End If;
    
      -----------------------
      -- Meta por Clientes
      -----------------------
      If vTp1imp2 in (1, 3) then
        begin
          select JAQL76MONT
            into Meta
            from (select JAQL76MONT
                    from jaql076
                   Where JAQL76TIME = 2 -- clientes
                     and JAQL76SUCU = (case
                           when vTp1Imp1 <> 0 then
                            vUbsuc
                           else
                            JAQL76SUCU
                         end)
                     and JAQL76FEIN <= pd_fecini
                        --and JAQL76FEFI >= pd_fecfin
                     and JAQL76MODU = Modulo_M
                     and JAQL76TOPE = Totope_M
                     and JAQL76PERF = vPrfGCod
                   order by JAQL76FEIN desc)
           where rownum = 1;
        exception
          when no_data_found then
            Meta := 0;
        end;
      
        If Meta_Cli >= Meta then
          vJAQL79MECL := 'S';
          begin
            select JAQL77COEF
              into ComCli
              from jaql077
             Where JAQL77COPI = 4 -- comi cli
               and JAQL77MODU = Modulo_M
               and JAQL77TOPE = Totope_M
               and JAQL77PERF = vPrfGCod;
          exception
            when no_data_found then
              begin
                select JAQL77COEF
                  into ComCli
                  from jaql077
                 Where JAQL77COPI = 4
                   and JAQL77MODU = Modulo_M
                   and JAQL77TOPE = Totope_M
                   and trim(JAQL77PERF) is null;
              exception
                when no_data_found then
                  ComCli := 0;
              end;
          end;
        
          vJAQL79COCL := Meta_Cli * ComCli;
        Else
          vJAQL79MECL := 'N';
          vJAQL79COCL := 0;
        End If;
      End If;
    
      Actualiza_Det_Meta(vjaql79user,
                         pd_fecpro,
                         Modulo_M,
                         Totope_M,
                         vjaql79memt,
                         vjaql79mecl,
                         vjaql79comt,
                         vjaql79cocl);
    
    end loop;
  
  end;
  ----------------------------------------------------------------------  
  procedure Paga_Cartera(vJAQL79USER char,
                         vprfgcod    char,
                         pd_fecpro   date,
                         analista    number,
                         pd_fecini   date,
                         pd_fecfin   date) is
    cursor cartera is
      select *
        from jaql079
       Where JAQL79FEPR = pd_fecpro
         and JAQL79USER = vJAQL79USER;
  
    cursor superv is
      select *
        from jaql078
       Where JAQL78USJE = vJAQL79USER
         and JAQL78ESTA = 'S';
  
    vJAQL80COCA number(17, 2) := 0;
    vJAQL80COCL number(17, 2) := 0;
    vJAQL79MTIN number(17, 2) := 0;
    vJAQL79MTRE number(17, 2) := 0;
    vJAQL79MTCA number(17, 2) := 0;
    vUbsuc      fsd011.scsuc%type;
    TopeCaCl    number(17, 2) := 0;
    vJAQL80COCC number(17, 2) := 0;
    BaseCar     number(14, 7) := 0;
    vJAQL80PAMC jaql080.jaql80pamc%type := 0;
    vJAQL80COMC jaql080.jaql80comc%type := 0;
    vJAQL78USAS jaql078.JAQL78USAS%type;
    vJAQL80NUSP jaql080.JAQL80NUSP%type := 0;
    Comisup     number(14, 7) := 0;
    TopeSup     number(17, 2) := 0;
    vJAQL80COSP jaql080.JAQL80COSP%type := 0;
    TopeTot     number(17, 2) := 0;
    vJAQL80TOCO number(17, 2) := 0;
  
    TotCli    number := 0;
    TipCapCli number;
    MetaCli   number;
    Tiposuc   number;
  
    CaptaCli char(1);
  
    Inserta char(1);
  
  begin
    vJAQL80COCA := 0;
    vJAQL80COCL := 0;
    vJAQL79MTIN := 0;
    vJAQL79MTRE := 0;
    vJAQL79MTCA := 0;
    Inserta     := 'N';
  
    vUbsuc := Sucursal_Eje(1, vJAQL79USER);
  
    for i in cartera loop
      vJAQL80COCA := vJAQL80COCA + nvl(i.JAQL79COMT, 0);
      vJAQL80COCL := vJAQL80COCL + nvl(i.JAQL79COCL, 0);
      If i.JAQL79MODU = 22 then
        vJAQL79MTIN := vJAQL79MTIN + nvl(i.JAQL79AU07, 0);
        vJAQL79MTRE := vJAQL79MTRE + nvl(i.JAQL79MTRE, 0);
        vJAQL79MTCA := vJAQL79MTCA + nvl(i.JAQL79MTCA, 0);
      End If;
      --vUbsuc := i.JAQL79AU05;
    
      begin
        select 'S'
          into CaptaCli
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10819
           and Tp1corr1 = 4
              --and Tp1corr3 = 1
           and Tp1nro2 = (i.jaql79modu * 1000) + i.jaql79tope
           and Tp1imp2 in (1, 3);
      exception
        when no_data_found then
          CaptaCli := 'N';
      end;
      If CaptaCli = 'S' then
        TotCli := TotCli + i.jaql79clap + i.jaql79clac;
      End if;
    
      Inserta := 'S';
    
    end loop;
  
    If Inserta = 'S' or analista = 0 then
      -- si tiene captaciones o cartera o si no es analista
    
      --Tope comision cap+cli
      begin
        select JAQL77MTMA
          into TopeCaCl
          from jaql077
         Where JAQL77COPI = 5
           and JAQL77PERF = vPrfGCod
           and JAQL77SUCU = vUbsuc;
      exception
        when no_data_found then
          begin
            select JAQL77MTMA
              into TopeCaCl
              from jaql077
             Where JAQL77COPI = 5
               and trim(JAQL77PERF) is null
               and JAQL77SUCU = vUbsuc;
          exception
            when no_data_found then
              begin
                select JAQL77MTMA
                  into TopeCaCl
                  from jaql077
                 Where JAQL77COPI = 5
                   and JAQL77PERF = vPrfGCod
                   and JAQL77SUCU = 999;
              exception
                when no_data_found then
                  TopeCaCl := 0;
              end;
          end;
      end;
    
      -- revisa si meta de clientes es por el total o por grupo
      begin
        select tp1nro1
          into TipCapCli
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10819
           and Tp1corr1 = 7
           and Trim(TP1DESC) = Trim(vPrfGCod);
      exception
        when no_data_found then
          TipCapCli := 1;
      end;
    
      -- si es por grupo 
      If TipCapCli = 2 then
      
        begin
          select Tp1corr3
            into Tiposuc
            from FST198
           Where Tp1cod = 1
             and Tp1cod1 = 10819
             and Tp1corr1 = 9
             and Tp1corr2 = vUbsuc;
        exception
          when no_data_found then
            MetaCli := 0;
        end;
      
        begin
          select tp1imp1
            into MetaCli
            from FST198
           Where Tp1cod = 1
             and Tp1cod1 = 10819
             and Tp1corr1 = 8
             and tp1corr3 = Tiposuc
             and Trim(TP1DESC) = Trim(vPrfGCod);
        exception
          when no_data_found then
            MetaCli := 0;
        end;
      
        If TotCli < MetaCli then
          vJAQL80COCL := 0;
        End IF;
      End If;
    
      If vJAQL80COCA + vJAQL80COCL > TopeCaCl then
        vJAQL80COCC := TopeCaCl;
      Else
        vJAQL80COCC := vJAQL80COCA + vJAQL80COCL;
      End If;
    
      --  Base cartera dpf
      begin
        select JAQL77COEF
          into BaseCar
          from jaql077
         Where JAQL77COPI = 6
           and JAQL77PERF = vPrfGCod;
      exception
        when no_data_found then
          begin
            select JAQL77COEF
              into BaseCar
              from jaql077
             Where JAQL77COPI = 6
               and trim(JAQL77PERF) is null;
          exception
            when no_data_found then
              BaseCar := 0;
          end;
      end;
    
      If vJAQL79MTRE + vJAQL79MTCA = 0 then
        vJAQL80PAMC := 0;
      Else
        vJAQL80PAMC := ((vJAQL79MTRE + vJAQL79MTIN) /
                       (vJAQL79MTRE + vJAQL79MTCA)) * 100;
        If vJAQL80PAMC > 999 then
          vJAQL80PAMC := 999;
        End If;
      End If;
    
      -- Comision por cartera dpf
      If vJAQL80PAMC >= BaseCar then
        begin
          select JAQL77COEF
            into vJAQL80COMC
            from jaql077
           Where JAQL77COPI = 7
             and JAQL77PERF = vPrfGCod
             and JAQL77SUCU = vUbsuc;
        exception
          when no_data_found then
            begin
              select JAQL77COEF
                into vJAQL80COMC
                from jaql077
               Where JAQL77COPI = 7
                 and trim(JAQL77PERF) is null
                 and JAQL77SUCU = vUbsuc;
            exception
              when no_data_found then
                begin
                  select JAQL77COEF
                    into vJAQL80COMC
                    from jaql077
                   Where JAQL77COPI = 7
                     and JAQL77PERF = vPrfGCod
                     and JAQL77SUCU = 999;
                exception
                  when no_data_found then
                    vJAQL80COMC := 0;
                end;
            end;
        end;
      End If;
    
      vJAQL80NUSP := 0;
      for j in superv loop
        vJAQL78USAS := j.JAQL78USAS;
        vJAQL80NUSP := vJAQL80NUSP + Supervision(vJAQL78USAS, pd_fecpro);
      end loop;
    
      If vJAQL80NUSP > 0 then
        begin
          select JAQL77COEF
            into ComiSup
            from jaql077
           Where JAQL77COPI = 8
             and JAQL77PERF = vPrfGCod;
        exception
          when no_data_found then
            begin
              select JAQL77COEF
                into ComiSup
                from jaql077
               Where JAQL77COPI = 8
                 and trim(JAQL77PERF) is null;
            exception
              when no_data_found then
                ComiSup := 0;
            End;
        End;
      
        begin
          select JAQL77MTMA
            into TopeSup
            from jaql077
           Where JAQL77COPI = 9
             and JAQL77PERF = vPrfGCod
             and JAQL77SUCU = vUbsuc;
        exception
          when no_data_found then
            begin
              select JAQL77MTMA
                into TopeSup
                from jaql077
               Where JAQL77COPI = 9
                 and trim(JAQL77PERF) is null
                 and JAQL77SUCU = vUbsuc;
            exception
              when no_data_found then
                begin
                  select JAQL77MTMA
                    into TopeSup
                    from jaql077
                   Where JAQL77COPI = 9
                     and JAQL77PERF = vPrfGCod
                     and JAQL77SUCU = 999;
                exception
                  when no_data_found then
                    TopeSup := 0;
                end;
            end;
        end;
      
        If vJAQL80NUSP * ComiSup > TopeSup then
          vJAQL80COSP := TopeSup;
        Else
          vJAQL80COSP := vJAQL80NUSP * ComiSup;
        End If;
      end if;
    
      begin
        select JAQL77MTMA
          into TopeTot
          from jaql077
         Where JAQL77COPI = 10
           and JAQL77PERF = vPrfGCod
           and JAQL77SUCU = vUbsuc;
      exception
        when no_data_found then
          begin
            select JAQL77MTMA
              into TopeTot
              from jaql077
             Where JAQL77COPI = 10
               and trim(JAQL77PERF) is null
               and JAQL77SUCU = vUbsuc;
          exception
            when no_data_found then
              begin
                select JAQL77MTMA
                  into TopeTot
                  from jaql077
                 Where JAQL77COPI = 10
                   and JAQL77PERF = vPrfGCod
                   and JAQL77SUCU = 999;
              exception
                when no_data_found then
                  TopeTot := 0;
              end;
          end;
      end;
    
      If vJAQL80COCC + vJAQL80COMC + vJAQL80COSP > TopeTot then
        vJAQL80TOCO := TopeTot;
      Else
        vJAQL80TOCO := vJAQL80COCC + vJAQL80COMC + vJAQL80COSP;
      End If;
    
      Inserta_Comision(vJAQL79USER,
                       pd_fecpro,
                       vprfgcod,
                       vUbsuc,
                       vJAQL80COCA,
                       vJAQL80COCL,
                       vJAQL80COCC,
                       vJAQL80PAMC,
                       vJAQL80COMC,
                       vJAQL80NUSP,
                       vJAQL80COSP,
                       vJAQL80TOCO,
                       Totcli,
                       pd_fecini,
                       pd_fecfin,
                       analista);
    
    end if;
  
  end;

  ----------------------------------------------------------------------  
  function Supervision(vJAQL79USER char, pd_fecpro date) return number is
  
    cursor prod is
      select trunc(Tp1nro1 / 1000) Modulo_M,
             Tp1nro1 - (trunc(Tp1nro1 / 1000) * 1000) Totope_M,
             Tp1imp2
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 4
         and Tp1corr3 = 1
         and Tp1imp2 <> 0;
  
    Totgru     number := 0;
    cumple     char(1);
    TotCumplio number := 0;
  
    clientes  number;
    vprfgcod  prfu00.prfgcod%type;
    TipCapCli number;
  
  begin
  
    begin
      select b.prfgcod
        into vprfgcod
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and b.ubuser = vJAQL79USER
         and Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 3;
    exception
      when no_data_found then
        vprfgcod := '';
    end;
  
    begin
      select tp1nro1
        into TipCapCli
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10819
         and Tp1corr1 = 7
         and Trim(TP1DESC) = Trim(vPrfGCod);
    exception
      when no_data_found then
        TipCapCli := 1;
    end;
  
    if TipCapCli = 2 then
      begin
        select jaql80cocl
          into clientes
          from jaql080
         where jaql80fepr = pd_fecpro
           and jaql80user = vJAQL79USER;
      exception
        when no_data_found then
          clientes := 0;
      end;
    end if;
  
    for i in prod loop
    
      Totgru := Totgru + 1;
    
      case
        when i.Tp1imp2 = 1 then
          begin
            select 'S'
              into cumple
              from jaql079
             Where JAQL79FEPR = pd_fecpro
               and JAQL79USER = vJAQL79USER
               and JAQL79MODU = i.Modulo_M
               and JAQL79TOPE = i.Totope_M
               and JAQL79MEMT = 'S'
               and JAQL79MECL = 'S';
          exception
            when no_data_found then
              cumple := 'N';
            when too_many_rows then
              cumple := 'S';
          end;
        
        when i.Tp1imp2 = 2 then
          begin
            select 'S'
              into cumple
              from jaql079
             Where JAQL79FEPR = pd_fecpro
               and JAQL79USER = vJAQL79USER
               and JAQL79MODU = i.Modulo_M
               and JAQL79TOPE = i.Totope_M
               and JAQL79MEMT = 'S';
          exception
            when no_data_found then
              cumple := 'N';
            when too_many_rows then
              cumple := 'S';
          end;
        
        when i.Tp1imp2 = 3 then
          begin
            select 'S'
              into cumple
              from jaql079
             Where JAQL79FEPR = pd_fecpro
               and JAQL79USER = vJAQL79USER
               and JAQL79MODU = i.Modulo_M
               and JAQL79TOPE = i.Totope_M
               and JAQL79MECL = 'S';
          exception
            when no_data_found then
              If TipCapCli = 2 then
                cumple := 'S';
              End If;
            when too_many_rows then
              cumple := 'S';
          end;
      end case;
    
      if cumple = 'S' then
        TotCumplio := TotCumplio + 1;
      end if;
    end loop;
  
    --cumplieron en captaciones y num de clie para todos los productos  
    -- si captacion es por grupo tambi¿n debe de cumplir
    If (TotCumplio = Totgru) and (TipCapCli = 2 and clientes > 0) then
      return(1);
    else
      return(0);
    End If;
  
  end;

  ----------------------------------------------------------------------  
  procedure Inserta_Comision(vJAQL80USER char,
                             vJAQL80FEPR date,
                             vJAQL80PERF char,
                             vJAQL80SUCU number,
                             vJAQL80COCA number,
                             vJAQL80COCL number,
                             vJAQL80COCC number,
                             vJAQL80PAMC number,
                             vJAQL80COMC number,
                             vJAQL80NUSP number,
                             vJAQL80COSP number,
                             vJAQL80TOCO number,
                             TotCli      number,
                             vjaql80fein date,
                             vjaql80fefi date,
                             analista    number) is
  begin
    insert into jaql080
      (JAQL80USER,
       JAQL80FEPR,
       JAQL80PERF,
       JAQL80SUCU,
       JAQL80COCA,
       JAQL80COCL,
       JAQL80COCC,
       JAQL80PAMC,
       JAQL80COMC,
       JAQL80NUSP,
       JAQL80COSP,
       JAQL80TOCO,
       JAQL80AU04,
       JAQL80AU01,
       jaql80au10,
       jaql80au11,
       jaql80au05)
    values
      (vJAQL80USER,
       vJAQL80FEPR,
       vJAQL80PERF,
       vJAQL80SUCU,
       vJAQL80COCA,
       vJAQL80COCL,
       vJAQL80COCC,
       vJAQL80PAMC,
       vJAQL80COMC,
       vJAQL80NUSP,
       vJAQL80COSP,
       vJAQL80TOCO,
       TotCli,
       to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'),
       vjaql80fein,
       vjaql80fefi,
       analista);
  
    commit;
  end;

end Productividad_Pasiva;
/

