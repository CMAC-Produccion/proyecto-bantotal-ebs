create or replace package PQ_AH_PRODUCTIVIDAD is

  -- Author  : MARAUJO
  -- Created : 21/03/2017 09:59:22 a.m.
  -- Purpose : Productividad para ejecutivos de retencion y crecimiento

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   pn_Tcbio  number);

  procedure Capital_Nuevo(pd_fecini date,
                          pd_fecfin date,
                          pd_fecpro date,
                          pn_Tcbio  number,
                          pc_agente char,
                          pn_agtcod number,
                          pc_tipo   char,
                          pn_pgcod  number);

  procedure Activaciones(pd_fecini date,
                         pd_fecfin date,
                         pd_fecpro date,
                         pn_Tcbio  number,
                         pn_pgcod  number,
                         pn_ctaini number,
                         pn_ctafin number);

  procedure Cartera(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    pn_Tcbio  number,
                    pc_agente char,
                    pc_tipo   char,
                    pn_pgcod  number);

  procedure Totales(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    pc_tipo   char,
                    pc_agente char,
                    pn_pgcod  number,
                    pn_sucur  number);

  procedure Comision(pd_fecini date,
                     pd_fecfin date,
                     pd_fecpro date,
                     pc_tipo   char,
                     pc_agente char,
                     pn_pgcod  number);

  procedure Tasa(vpgcod  number,
                 vScsuc  number,
                 vSccta  number,
                 vScmda  number,
                 vScpap  number,
                 vScoper number,
                 vScsbop number,
                 vSctope number,
                 vScmod  number,
                 vSfval  date,
                 vmonto  number,
                 vplazo  number,
                 tasa    out number);

  procedure Saldo_Hist(vpgcod  number,
                       vScsuc  number,
                       vSccta  number,
                       vScmda  number,
                       vScpap  number,
                       vScoper number,
                       vScsbop number,
                       vSctope number,
                       vScmod  number,
                       vSfval  date,
                       vrubro  number,
                       vmonto  out number);

end PQ_AH_PRODUCTIVIDAD;
/

create or replace package body PQ_AH_PRODUCTIVIDAD is

  procedure Inicio(pd_fecini date,
                   pd_fecfin date,
                   pd_fecpro date,
                   pn_Tcbio  number) is
  
    vpgcod number(3) := 1;
  
    cursor eje is
      select j1.jaql732user, j1.jaql732tipo, f3.agtecod, f4.ubsuc
        from fst156 f3, jaql732 j1, fst046 f4
       where f3.agteusr = j1.jaql732user
         and j1.jaql732user = f4.ubuser
         and f4.pgcod = 1;
  
    cursor ctas is
      select pbd1 pn_ctaini, pbh1 pn_ctafin from fsr101 where pbnsec = 611;
  
  begin
    delete from JAQL733
     where JAQL733FEPR = pd_fecpro
       and JAQL733FEIN = pd_fecini
       and JAQL733FEFI = pd_fecfin;
  
    delete from JAQL734
     where JAQL734FEPR = pd_fecpro
       and JAQL734FEIN = pd_fecini
       and JAQL734FEFI = pd_fecfin;
  
    commit;
  
    for i in eje loop
      Capital_Nuevo(pd_fecini,
                    pd_fecfin,
                    pd_fecpro,
                    pn_Tcbio,
                    i.jaql732user,
                    i.agtecod,
                    i.jaql732tipo,
                    vpgcod);
    
      Cartera(pd_fecini,
              pd_fecfin,
              pd_fecpro,
              pn_Tcbio,
              i.jaql732user,
              i.jaql732tipo,
              vpgcod);
    
    end loop;
  
    for j in ctas loop
      Activaciones(pd_fecini,
                   pd_fecfin,
                   pd_fecpro,
                   pn_Tcbio,
                   vpgcod,
                   j.pn_ctaini,
                   j.pn_ctafin);
    end loop;
  
    for i in eje loop
    
      Totales(pd_fecini,
              pd_fecfin,
              pd_fecpro,
              i.jaql732tipo,
              i.jaql732user,
              vpgcod,
              i.ubsuc);
    
      Comision(pd_fecini,
               pd_fecfin,
               pd_fecpro,
               i.jaql732tipo,
               i.jaql732user,
               vpgcod);
    
    end loop;
  
  end;

  -------------------------------------------------------------------------

  procedure Capital_Nuevo(pd_fecini date,
                          pd_fecfin date,
                          pd_fecpro date,
                          pn_Tcbio  number,
                          pc_agente char,
                          pn_agtcod number,
                          pc_tipo   char,
                          pn_pgcod  number) is
    cursor ctas is
      select /*+ NO_CPU_COSTING */
       f1.pgcod,
       scsuc,
       scmda,
       scpap,
       sccta,
       scoper,
       scsbop,
       sctope,
       scmod,
       scfval,
       scpzo,
       scsdo,
       scstat,
       scfulm
        from fsd011 f1, fsr012 f21
       where f1.pgcod = pn_pgcod
         and f1.scmod = 21
         and f1.scmda in (0, 101)
         and f1.scpap = 0
         and f21.p1cod = pn_pgcod
         and f21.p1mod = 21
         and f21.p1mda in (0, 101)
         and f21.p1pap = 0
         and f1.pgcod = f21.p1cod
         and f1.scsuc = f21.p1suc
         and f1.scmda = f21.p1mda
         and f1.scpap = f21.p1pap
         and f1.sccta = f21.p1cta
         and f1.scoper = f21.p1oper
         and f1.scsbop = f21.p1sbop
         and f1.sctope = f21.p1tope
         and f1.scmod = f21.p1mod
         and f21.p1pais = 0
         and f21.p1tdoc = 0
         and to_number(f21.P1ndoc) = pn_agtcod
         and f21.Relcod = 77
         and (f1.Scfval >= pd_fecini and f1.Scfval <= pd_fecfin)
      union
      select f10.pgcod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope,
             aomod,
             aofval,
             aopzo,
             aoimp,
             aostat,
             aofe99
        from fsd010 f10, fsr012 f22
       where f10.pgcod = pn_pgcod
         and f10.aomod = 22
         and f10.aomda in (0, 101)
         and f10.aopap = 0
         and f22.p1cod = pn_pgcod
         and f22.p1mod = 22
         and f22.p1mda in (0, 101)
         and f22.p1pap = 0
         and f10.pgcod = f22.p1cod
         and f10.aosuc = f22.p1suc
         and f10.aomda = f22.p1mda
         and f10.aopap = f22.p1pap
         and f10.aocta = f22.p1cta
         and f10.aooper = f22.p1oper
         and f10.aosbop = f22.p1sbop
         and f10.aotope = f22.p1tope
         and f10.aomod = f22.p1mod
         and f22.p1pais = 0
         and f22.p1tdoc = 0
         and to_number(f22.P1ndoc) = pn_agtcod
         and f22.Relcod = 77
         and (f10.aofval >= pd_fecini and f10.aofval <= pd_fecfin);
  
    vpepais      fsd001.pepais%type;
    vpetdoc      fsd001.petdoc%type;
    vpendoc      fsd001.pendoc%type;
    vpetipo      fsd001.petipo%type;
    vJAQL733TIPE jaql733.jaql733tipe%type;
  
    Feccan date;
  
    sucori number(3);
    fcon   date;
    ptrmod fsd016.itmod%type;
    ptrnro fsd016.ittran%type;
    nrel   fsd016.itnrel%type;
    impmov number(17, 2);
  
    vFecAnt    date;
    cli_fecini date;
    CliNuevo   char(1);
    NumCliNue  number;
    vtasa      number;
  
  begin
    for i in ctas loop
    
      Productividad_pasiva.Titular(i.pgcod,
                                   i.sccta,
                                   vpepais,
                                   vpetdoc,
                                   vpendoc,
                                   vpetipo);
    
      If vpetipo = 'J' then
        vJAQL733TIPE := 2;
      Else
        vJAQL733TIPE := 1;
      End If;
    
      If i.scstat = 99 then
        feccan := i.scfulm;
      else
        feccan := null;
      end if;
    
      if i.scstat <> 99 or (i.scstat = 99 and i.Scfulm > pd_fecfin) then
        if i.scmod = 21 then
          SP_DEPO_CV(i.pgcod,
                     i.scsuc,
                     i.scmod,
                     i.scmda,
                     i.scpap,
                     i.sccta,
                     i.scoper,
                     i.scsbop,
                     i.sctope,
                     i.Scfval,
                     pd_fecfin,
                     sucori,
                     fcon,
                     ptrmod,
                     ptrnro,
                     nrel,
                     impmov);
        else
          impmov := i.scsdo;
        end if;
      
        if i.scmda <> 0 then
          impmov := impmov * pn_Tcbio;
        end if;
      
        Productividad_Pasiva.Fecha_Antig_cta(i.pgcod,
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
            CliNuevo := 'S';
          else
            CliNuevo := 'N';
          end if;
        else
          CliNuevo  := 'N';
          NumCliNue := 0;
        end if;
      
        /*        Tasa(i.pgcod,
        i.Scsuc,
        i.Sccta,
        i.Scmda,
        i.Scpap,
        i.Scoper,
        i.Scsbop,
        i.Sctope,
        i.Scmod,
        i.Scfval,
        i.scsdo,
        i.scpzo,
        vtasa);*/
      
        if ((pc_tipo = 'R' and i.scmod = 22) or
           (pc_tipo = 'C' and i.scmod = 21)) then
        
          begin
            insert into jaql733
              (jaql733fepr,
               jaql733fein,
               jaql733fefi,
               jaql733user,
               jaql733pgco,
               jaql733scsu,
               jaql733scmo,
               jaql733scmd,
               jaql733scpa,
               jaql733scct,
               jaql733scop,
               jaql733scsb,
               jaql733scto,
               jaql733pais,
               jaql733tdoc,
               jaql733ndoc,
               jaql733tipe,
               jaql733feva,
               jaql733feca,
               jaql733tisa,
               jaql733mtap,
               jaql733teaa,
               jaql733ticl)
            values
              (pd_fecpro,
               pd_fecini,
               pd_fecfin,
               pc_agente,
               i.pgcod,
               i.scsuc,
               i.scmod,
               i.scmda,
               i.scpap,
               i.sccta,
               i.scoper,
               i.scsbop,
               i.sctope,
               vpepais,
               vpetdoc,
               vpendoc,
               vjaql733tipe,
               i.scfval,
               feccan,
               'AP',
               impmov,
               vtasa,
               CliNuevo);
          exception
            when others then
              dbms_output.put_line('aperturas : ' || i.sccta || '-' ||
                                   i.scoper || '-' || i.scsbop);
          end;
        else
          If CliNuevo = 'S' then
            impmov := 0;
            begin
              insert into jaql733
                (jaql733fepr,
                 jaql733fein,
                 jaql733fefi,
                 jaql733user,
                 jaql733pgco,
                 jaql733scsu,
                 jaql733scmo,
                 jaql733scmd,
                 jaql733scpa,
                 jaql733scct,
                 jaql733scop,
                 jaql733scsb,
                 jaql733scto,
                 jaql733pais,
                 jaql733tdoc,
                 jaql733ndoc,
                 jaql733tipe,
                 jaql733feva,
                 jaql733feca,
                 jaql733tisa,
                 jaql733mtap,
                 jaql733teaa,
                 jaql733ticl)
              values
                (pd_fecpro,
                 pd_fecini,
                 pd_fecfin,
                 pc_agente,
                 i.pgcod,
                 i.scsuc,
                 i.scmod,
                 i.scmda,
                 i.scpap,
                 i.sccta,
                 i.scoper,
                 i.scsbop,
                 i.sctope,
                 vpepais,
                 vpetdoc,
                 vpendoc,
                 vjaql733tipe,
                 i.scfval,
                 feccan,
                 'AP',
                 impmov,
                 vtasa,
                 CliNuevo);
            exception
              when others then
                dbms_output.put_line('aperturas : ' || i.sccta || '-' ||
                                     i.scoper || '-' || i.scsbop);
            end;
          end if;
        end if;
      end if;
    
    end loop;
    commit;
  end;

  -------------------------------------------------------------------------

  procedure Activaciones(pd_fecini date,
                         pd_fecfin date,
                         pd_fecpro date,
                         pn_Tcbio  number,
                         pn_pgcod  number,
                         pn_ctaini number,
                         pn_ctafin number) is
    cursor ctas is
      select *
        from fsd011
       where pgcod = pn_pgcod
         and scmod = 21
         and scmda in (0, 101)
         and scpap = 0
            --and sccta in (791509)
         and (Scfcon >= pd_fecini and Scfcon <= pd_fecfin)
         and scfcon <> scfval
         and scstat <> 81
         and (scstat <> 99 or (scstat = 99 and scfulm > pd_fecfin))
         and sccta >= pn_ctaini
         and sccta <= pn_ctafin;
  
    vpepais      fsd001.pepais%type;
    vpetdoc      fsd001.petdoc%type;
    vpendoc      fsd001.pendoc%type;
    vpetipo      fsd001.petipo%type;
    vJAQL733TIPE jaql733.jaql733tipe%type;
  
    Feccan date;
  
    sucori number(3);
    fcon   date;
    ptrmod fsd016.itmod%type;
    ptrnro fsd016.ittran%type;
    nrel   fsd016.itnrel%type;
    impmov number(17, 2);
  
    vFecAnt    date;
    cli_fecini date;
    CliNuevo   char(1);
    NumCliNue  number;
    vtasa      number;
    vUbsuc     number(3);
  
    pc_agente char(10);
    es_agente char(1);
  
    tipo char(1);
  
  begin
    for i in ctas loop
    
      Productividad_pasiva.Titular(i.pgcod,
                                   i.sccta,
                                   vpepais,
                                   vpetdoc,
                                   vpendoc,
                                   vpetipo);
    
      If vpetipo = 'J' then
        vJAQL733TIPE := 2;
      Else
        vJAQL733TIPE := 1;
      End If;
    
      If i.scstat = 99 then
        feccan := i.scfulm;
      else
        feccan := null;
      end if;
    
      productividad_pasiva.Agente(i.Pgcod,
                                  i.Scmod,
                                  i.Scsuc,
                                  i.Scmda,
                                  i.Scpap,
                                  i.Sccta,
                                  i.Scoper,
                                  i.Scsbop,
                                  i.Sctope,
                                  i.scfcon,
                                  'AC',
                                  pc_agente,
                                  vUbsuc);
      begin
        select j1.jaql732tipo
          into tipo
          from jaql732 j1
         where j1.jaql732user = pc_agente;
      exception
        when no_data_found then
          tipo := 'N';
      end;
    
      if tipo = 'C' then
      
        begin
          select 'S'
            into es_agente
            from jaql732
           where jaql732user = pc_agente;
        exception
          when no_data_found then
            es_agente := 'N';
        end;
      
        if (i.scstat <> 99 or (i.scstat = 99 and i.Scfulm > pd_fecfin)) and
           pc_agente <> '          ' and es_agente = 'S' then
        
          SP_DEPO_CV(i.pgcod,
                     i.scsuc,
                     i.scmod,
                     i.scmda,
                     i.scpap,
                     i.sccta,
                     i.scoper,
                     i.scsbop,
                     i.sctope,
                     i.scfcon,
                     pd_fecfin,
                     sucori,
                     fcon,
                     ptrmod,
                     ptrnro,
                     nrel,
                     impmov);
        
          if i.scmda <> 0 then
            impmov := impmov * pn_Tcbio;
          end if;
        
          Productividad_Pasiva.Fecha_Antig_cta(i.pgcod,
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
              CliNuevo := 'S';
            else
              CliNuevo := 'N';
            end if;
          else
            CliNuevo  := 'N';
            NumCliNue := 0;
          end if;
        
          /*        Tasa(i.pgcod,
          i.Scsuc,
          i.Sccta,
          i.Scmda,
          i.Scpap,
          i.Scoper,
          i.Scsbop,
          i.Sctope,
          i.Scmod,
          i.Scfcon,
          i.scsdo,
          i.scpzo,
          vtasa);*/
        
          if ((tipo = 'R' and i.scmod = 22) or
             (tipo = 'C' and i.scmod = 21)) then
          
            begin
              insert into jaql733
                (jaql733fepr,
                 jaql733fein,
                 jaql733fefi,
                 jaql733user,
                 jaql733pgco,
                 jaql733scsu,
                 jaql733scmo,
                 jaql733scmd,
                 jaql733scpa,
                 jaql733scct,
                 jaql733scop,
                 jaql733scsb,
                 jaql733scto,
                 jaql733pais,
                 jaql733tdoc,
                 jaql733ndoc,
                 jaql733tipe,
                 jaql733feva,
                 jaql733feca,
                 jaql733tisa,
                 jaql733mtac,
                 jaql733teaa,
                 jaql733ticl)
              values
                (pd_fecpro,
                 pd_fecini,
                 pd_fecfin,
                 pc_agente,
                 i.pgcod,
                 i.scsuc,
                 i.scmod,
                 i.scmda,
                 i.scpap,
                 i.sccta,
                 i.scoper,
                 i.scsbop,
                 i.sctope,
                 vpepais,
                 vpetdoc,
                 vpendoc,
                 vjaql733tipe,
                 i.scfcon,
                 feccan,
                 'AC',
                 impmov,
                 vtasa,
                 CliNuevo);
            exception
              when others then
                dbms_output.put_line('activaciones : ' || i.sccta || '-' ||
                                     i.scoper || '-' || i.scsbop);
            end;
          else
            If CliNuevo = 'S' then
              impmov := 0;
              begin
                insert into jaql733
                  (jaql733fepr,
                   jaql733fein,
                   jaql733fefi,
                   jaql733user,
                   jaql733pgco,
                   jaql733scsu,
                   jaql733scmo,
                   jaql733scmd,
                   jaql733scpa,
                   jaql733scct,
                   jaql733scop,
                   jaql733scsb,
                   jaql733scto,
                   jaql733pais,
                   jaql733tdoc,
                   jaql733ndoc,
                   jaql733tipe,
                   jaql733feva,
                   jaql733feca,
                   jaql733tisa,
                   jaql733mtac,
                   jaql733teaa,
                   jaql733ticl)
                values
                  (pd_fecpro,
                   pd_fecini,
                   pd_fecfin,
                   pc_agente,
                   i.pgcod,
                   i.scsuc,
                   i.scmod,
                   i.scmda,
                   i.scpap,
                   i.sccta,
                   i.scoper,
                   i.scsbop,
                   i.sctope,
                   vpepais,
                   vpetdoc,
                   vpendoc,
                   vjaql733tipe,
                   i.scfcon,
                   feccan,
                   'AC',
                   impmov,
                   vtasa,
                   CliNuevo);
              exception
                when others then
                  dbms_output.put_line('activaciones : ' || i.sccta || '-' ||
                                       i.scoper || '-' || i.scsbop);
              end;
            end if;
          end if;
        
        end if;
      end if;
    
    end loop;
  
    commit;
  end;

  -------------------------------------------------------------------------

  procedure Cartera(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    pn_Tcbio  number,
                    pc_agente char,
                    pc_tipo   char,
                    pn_pgcod  number) is
  
    cursor ctas_dpf is
      select *
        from (select distinct x.*,
                              z.hjaql61pais,
                              z.hjaql61tdoc,
                              z.hjaql61ndoc,
                              z.hjaql61user
                from fsd010 x, fsr008 y, hjaql061 z
               where x.pgcod = y.pgcod
                 and x.pgcod = 1
                 and x.aocta = y.ctnro
                 and y.pepais = z.hjaql61pais
                 and y.petdoc = z.hjaql61tdoc
                 and y.pendoc = z.hjaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and x.aomod = 22
                 and z.hjaql61user = pc_agente
                 and hjaql61fech <= pd_fecfin
                 and hjaql61esta = 'S'
                 and hjaql61fein > pd_fecfin
                 and x.aofval <= pd_fecfin
                 and (aostat <> 99 or (aostat = 99 and aofe99 >= pd_Fecini))
              
              --and x.aocta = 442161
              union
              select distinct x.*,
                              z.jaql61pais,
                              z.jaql61tdoc,
                              z.jaql61ndoc,
                              z.jaql61user
                from fsd010 x, fsr008 y, jaql061 z
               where x.pgcod = y.pgcod
                 and x.pgcod = 1
                 and x.aocta = y.ctnro
                 and y.pepais = z.jaql61pais
                 and y.petdoc = z.jaql61tdoc
                 and y.pendoc = z.jaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and x.aomod = 22
                 and z.jaql61user = pc_agente
                 and z.jaql61esta = 'S'
                 and z.jaql61fech <= pd_fecfin
                 and x.aofval <= pd_fecfin
                 and (aostat <> 99 or (aostat = 99 and aofe99 >= pd_Fecini))
              --and x.aocta = 442161
              );
  
    cursor ctas_aho is
    
      select *
        from (select distinct v.*
                from fsd011 v, fsr008 y, hjaql061 z
               where v.pgcod = y.pgcod
                 and v.pgcod = 1
                 and v.sccta = y.ctnro
                 and y.pepais = z.hjaql61pais
                 and y.petdoc = z.hjaql61tdoc
                 and y.pendoc = z.hjaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and v.scmod = 21
                 and z.hjaql61user = pc_agente
                 and hjaql61fech <= pd_fecfin
                 and hjaql61esta = 'S'
                 and hjaql61fein > pd_fecfin
                 and v.scfval <= pd_fecini
                 and (scstat <> 99 or (scstat = 99 and scfulm >= pd_Fecini))
              --and x.aocta = 442161
              union
              
              select distinct v.*
                from fsd011 v, fsr008 y, jaql061 z
               where v.pgcod = y.pgcod
                 and v.sccta = y.ctnro
                 and y.pepais = z.jaql61pais
                 and y.petdoc = z.jaql61tdoc
                 and y.pendoc = z.jaql61ndoc
                 and y.Ttcod = 1
                 and y.Cttfir = 'T'
                 and v.scmod = 21
                 and z.jaql61user = pc_agente
                 and z.jaql61esta = 'S'
                 and z.jaql61fech <= pd_fecfin
                 and v.scfval <= pd_fecini
                 and (scstat <> 99 or (scstat = 99 and scfulm >= pd_Fecini)));
  
    vctifin char(1);
    subasta char(1);
    captada char(1);
  
    vpepais      fsd001.pepais%type;
    vpetdoc      fsd001.petdoc%type;
    vpendoc      fsd001.pendoc%type;
    vpetipo      fsd001.petipo%type;
    vJAQL733TIPE jaql733.jaql733tipe%type;
    impmov       number;
    CliNuevo     char(1);
    TipoSal      char(2);
    feccan       date;
    salren       number;
    salinc       number;
    salmac       number;
    salnap       number;
    salcan       number;
    vtasat       number;
    vtasaa       number;
  
    impmovo number;
  
  begin
    if pc_tipo = 'R' then
      for i in ctas_dpf loop
        TipoSal := 'NN';
      
        begin
          select 'S'
            into vctifin
            from fsd008
           where pgcod = i.pgcod
             and ctnro = i.aocta
             and seccod in (3, 5);
        exception
          when no_data_found then
            vctifin := 'N';
        end;
      
        begin
          select 'S'
            into subasta
            from jaql478 j2
           Where j2.jaql478cta = i.aocta
             and j2.jaql478ope = i.aooper;
        exception
          when no_data_found then
            subasta := 'N';
          when too_many_rows then
            subasta := 'S';
          when others then
            subasta := 'N';
        end;
      
        begin
          select 'S'
            into captada
            from jaql733
           where jaql733fepr = pd_fecpro
             and jaql733fein = pd_fecini
             and jaql733fefi = pd_fecfin
             and jaql733pgco = i.pgcod
             and jaql733scsu = i.aosuc
             and jaql733scmd = i.aomda
             and jaql733scmo = i.aomod
             and jaql733scpa = i.aopap
             and jaql733scct = i.aocta
             and jaql733scop = i.aooper
             and jaql733scsb = i.aosbop
             and jaql733scto = i.aotope
             and jaql733tisa = 'AP';
        exception
          when too_many_rows then
            captada := 'S';
          when no_data_found then
            captada := 'N';
        end;
      
        if vctifin = 'N' and subasta = 'N' and captada = 'N' then
        
          Productividad_Pasiva.Titular(i.pgcod,
                                       i.aocta,
                                       vpepais,
                                       vpetdoc,
                                       vpendoc,
                                       vpetipo);
        
          If vpetipo = 'J' then
            vJAQL733TIPE := 2;
          Else
            vJAQL733TIPE := 1;
          End If;
        
          if i.aomda <> 0 then
            impmov := i.aoimp * pn_Tcbio;
          else
            impmov := i.aoimp;
          end if;
        
          If i.aostat = 99 then
            feccan := i.aofe99;
          else
            feccan := null;
          end if;
        
          CliNuevo := 'N';
        
          salren := 0;
          salinc := 0;
          salmac := 0;
          salnap := 0;
          salcan := 0;
        
          if i.aostat <> 99 or (i.aostat = 99 and i.aofe99 > pd_fecfin) then
            if i.aofval >= pd_fecini then
              If i.aosbop > 0 then
                --renovadas
                TipoSal := 'RE';
                salren  := impmov;
              else
                --ver si son incrementos
                begin
                
                  select 'IP'
                    into tiposal
                    from fsd010 a, fsr008 y
                   where a.pgcod = y.pgcod
                     and a.aocta = y.ctnro
                     and y.pepais = vpepais
                     and y.petdoc = vpetdoc
                     and y.pendoc = vpendoc
                     and a.pgcod = pn_pgcod
                     and aomod = 22
                     and aofe99 = i.aofval
                        --and aofvto between pd_fecini and pd_fecfin
                     and aostat = 99
                     and y.Ttcod = 1
                     and y.Cttfir = 'T'
                     and not exists (select 1
                            from fsd010 b
                           where b.pgcod = 1
                             and b.aocta = a.aocta
                             and b.aooper = a.aooper
                             and b.aosbop = a.aosbop + 1
                             and aomod = 22
                             and aostat <> 99)
                     and rownum = 1;
                
                  salinc := impmov;
                exception
                  when no_data_found then
                    TipoSal := 'NA';
                    salnap  := impmov;
                    If pc_tipo = 'C' then
                      -- buscar si hubo retiro de ah
                      begin
                        select 'IA'
                          into tiposal
                          from fsh016
                         where pgcod = pn_pgcod
                           and hcmod = 22
                           and htran = 800
                           and hcta = i.aocta
                           and hfcon = i.aofval
                           and hmodul = 21
                           and hcodmo = 1
                           and rownum = 1;
                      
                        salinc := impmov;
                        salnap := 0;
                      exception
                        when no_data_found then
                          null;
                      end;
                    End if;
                end;
              
              end if;
            else
              TipoSal := 'MC';
              salmac  := impmov;
            end if;
          else
            if feccan >= pd_Fecini then
              if feccan < i.aofvto then
                TipoSal := 'CA';
              else
                TipoSal := 'CR';
              end if;
            
              salcan := impmov;
            end if;
          end if;
        
          vtasat := 0;
          vtasaa := 0;
        
          if TipoSal = 'RE' then
          
            Tasa(i.pgcod,
                 0,
                 i.aocta,
                 i.aomda,
                 i.aopap,
                 0,
                 0,
                 i.aotope,
                 i.aomod,
                 i.aofval,
                 i.aoimp,
                 i.aopzo,
                 vtasat);
          
            Tasa(i.pgcod,
                 i.aosuc,
                 i.aocta,
                 i.aomda,
                 i.aopap,
                 i.aooper,
                 i.aosbop,
                 i.aotope,
                 i.aomod,
                 pd_fecpro,
                 i.aoimp,
                 i.aopzo,
                 vtasaa);
          
            if vtasaa = 0 and i.aostat = 99 then
              vtasaa := vtasat;
            end if;
          end if;
        
          if TipoSal <> 'NN' then
          
            begin
              insert into jaql733
                (jaql733fepr,
                 jaql733fein,
                 jaql733fefi,
                 jaql733user,
                 jaql733pgco,
                 jaql733scsu,
                 jaql733scmo,
                 jaql733scmd,
                 jaql733scpa,
                 jaql733scct,
                 jaql733scop,
                 jaql733scsb,
                 jaql733scto,
                 jaql733pais,
                 jaql733tdoc,
                 jaql733ndoc,
                 jaql733tipe,
                 jaql733feva,
                 jaql733feca,
                 jaql733tisa,
                 jaql733mtap,
                 jaql733mtre,
                 jaql733mtin,
                 jaql733mtmc,
                 jaql733mtca,
                 jaql733teat,
                 jaql733teaa,
                 jaql733ticl,
                 jaql733au07)
              values
                (pd_fecpro,
                 pd_fecini,
                 pd_fecfin,
                 pc_agente,
                 i.pgcod,
                 i.aosuc,
                 i.aomod,
                 i.aomda,
                 i.aopap,
                 i.aocta,
                 i.aooper,
                 i.aosbop,
                 i.aotope,
                 vpepais,
                 vpetdoc,
                 vpendoc,
                 vjaql733tipe,
                 i.aofval,
                 feccan,
                 TipoSal,
                 salnap,
                 salren,
                 salinc,
                 salmac,
                 salcan,
                 vtasat,
                 vtasaa,
                 CliNuevo,
                 i.aofvto);
            exception
              when others then
                dbms_output.put_line('cartera dpf : ' || i.aocta || '-' ||
                                     i.aooper);
            end;
          end if;
        
        end if;
      end loop;
    end if;
  
    if pc_tipo = 'C' then
      for i in ctas_aho loop
      
        TipoSal := 'NN';
      
        begin
          select 'S'
            into vctifin
            from fsd008
           where pgcod = i.pgcod
             and ctnro = i.sccta
             and seccod in (3, 5);
        exception
          when no_data_found then
            vctifin := 'N';
        end;
      
        begin
          select 'S'
            into subasta
            from jaql478 j2
           Where j2.jaql478cta = i.sccta
             and j2.jaql478ope = i.scoper
             and j2.jaql478sub = i.scsbop;
        exception
          when no_data_found then
            subasta := 'N';
          when too_many_rows then
            subasta := 'S';
          when others then
            subasta := 'N';
        end;
      
        begin
          select 'S'
            into captada
            from jaql733
           where jaql733fepr = pd_fecpro
             and jaql733pgco = i.pgcod
             and jaql733scsu = i.scsuc
             and jaql733scmd = i.scmda
             and jaql733scmo = i.scmod
             and jaql733scpa = i.scpap
             and jaql733scct = i.sccta
             and jaql733scop = i.scoper
             and jaql733scsb = i.scsbop
             and jaql733scto = i.sctope
             and jaql733tisa = 'AP';
        exception
          when no_data_found then
            captada := 'N';
          when too_many_rows then
            captada := 'S';
        end;
      
        if vctifin = 'N' and subasta = 'N' and captada = 'N' then
        
          Productividad_Pasiva.Titular(i.pgcod,
                                       i.sccta,
                                       vpepais,
                                       vpetdoc,
                                       vpendoc,
                                       vpetipo);
        
          If vpetipo = 'J' then
            vJAQL733TIPE := 2;
          Else
            vJAQL733TIPE := 1;
          End If;
        
          If i.scstat = 99 then
            feccan := i.scfulm;
          else
            feccan := null;
          end if;
        
          CliNuevo := 'N';
        
          Saldo_Hist(i.pgcod,
                     i.scsuc,
                     i.sccta,
                     i.scmda,
                     i.scpap,
                     i.scoper,
                     i.scsbop,
                     i.sctope,
                     i.scmod,
                     pd_fecini - 1,
                     i.scrub,
                     impmovo);
        
          Saldo_Hist(i.pgcod,
                     i.scsuc,
                     i.sccta,
                     i.scmda,
                     i.scpap,
                     i.scoper,
                     i.scsbop,
                     i.sctope,
                     i.scmod,
                     pd_fecfin,
                     i.scrub,
                     impmov);
        
          if i.scmda <> 0 then
            impmovo := impmovo * pn_Tcbio;
            impmov  := impmov * pn_Tcbio;
          end if;
        
          TipoSal := 'MC';
        
          begin
            insert into jaql733
              (jaql733fepr,
               jaql733fein,
               jaql733fefi,
               jaql733user,
               jaql733pgco,
               jaql733scsu,
               jaql733scmo,
               jaql733scmd,
               jaql733scpa,
               jaql733scct,
               jaql733scop,
               jaql733scsb,
               jaql733scto,
               jaql733pais,
               jaql733tdoc,
               jaql733ndoc,
               jaql733tipe,
               jaql733feva,
               jaql733feca,
               jaql733tisa,
               jaql733mtmc,
               jaql733au05,
               jaql733au06,
               jaql733teat,
               jaql733teaa,
               jaql733ticl)
            values
              (pd_fecpro,
               pd_fecini,
               pd_fecfin,
               pc_agente,
               i.pgcod,
               i.scsuc,
               i.scmod,
               i.scmda,
               i.scpap,
               i.sccta,
               i.scoper,
               i.scsbop,
               i.sctope,
               vpepais,
               vpetdoc,
               vpendoc,
               vjaql733tipe,
               i.scfval,
               feccan,
               TipoSal,
               impmov,
               impmovo,
               impmovo - impmov,
               0,
               0,
               CliNuevo);
          exception
            when others then
              dbms_output.put_line('cartera aho : ' || i.sccta || '-' ||
                                   i.scoper);
          end;
        
        end if;
      end loop;
    end if;
    commit;
  
  end;
  -------------------------------------------------------------------------

  procedure Totales(pd_fecini date,
                    pd_fecfin date,
                    pd_fecpro date,
                    pc_tipo   char,
                    pc_agente char,
                    pn_pgcod  number,
                    pn_sucur  number) is
  
    cursor det is
      select *
        from jaql733 j3
       where j3.jaql733fepr = pd_fecpro
         and j3.jaql733fein = pd_fecini
         and j3.jaql733fefi = pd_fecfin
         and j3.jaql733user = pc_agente;
  
    noprod  char(1);
    vperfil char(10);
  
    vjaql734mmca jaql734.jaql734mmca%type := 0;
    vjaql734mmcf jaql734.jaql734mmcf%type := 0;
    vjaql734mcpn jaql734.jaql734mcpn%type := 0;
    vjaql734mmct jaql734.jaql734mmct%type := 0;
    vjaql734remc jaql734.jaql734remc%type := 0;
    vjaql734memc jaql734.jaql734memc%type := 0;
    vjaql734clah jaql734.jaql734clah%type := 0;
    vjaql734clpf jaql734.jaql734clpf%type := 0;
    vjaql734recl jaql734.jaql734recl%type := 0;
    vjaql734mecl jaql734.jaql734mecl%type := 0;
    vjaql734mven jaql734.jaql734mven%type := 0;
    vjaql734mren jaql734.jaql734mren%type := 0;
    vjaql734mbre jaql734.jaql734mbre%type := 0;
    vjaql734tpta jaql734.jaql734tpta%type := 0;
    vjaql734tpme jaql734.jaql734tpme%type := 0;
    vjaql734tpac jaql734.jaql734tpac%type := 0;
    vjaql734gfta jaql734.jaql734gfta%type := 0;
    vjaql734gfme jaql734.jaql734gfme%type := 0;
    vjaql734gfac jaql734.jaql734gfac%type := 0;
    vjaql734megf jaql734.jaql734megf%type := 0;
    vjaql734acgf jaql734.jaql734acgf%type := 0;
    vjaql734regf jaql734.jaql734regf%type := 0;
    /*    vjaql734comc jaql734.jaql734comc%type := 0;
        vjaql734cocl jaql734.jaql734cocl%type := 0;
        vjaql734cogf jaql734.jaql734cogf%type := 0;
        vjaql734cocv jaql734.jaql734cocv%type := 0;
        vjaql734coto jaql734.jaql734coto%type := 0;
    */
  
    vsalpont number(17, 2) := 0;
    vsalpona number(17, 2) := 0;
    vbaseren number := 0;
    vbaseven number := 0;
    vvenreno number := 0;
    vtasaadi number := 0;
  
  begin
  
    begin
      select b.prfgcod
        into vperfil
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and Tp1cod = pn_pgcod
         and Tp1cod1 = 10819
         and Tp1corr1 = 3
         and Tp1nro1 <> 2
         and b.ubuser = pc_agente
         and rownum = 1;
    exception
      when no_data_found then
        vperfil := 'X';
    end;
  
    if vperfil <> 'X' then
    
      begin
        select g1.tp1imp1, g1.tp1imp2
          into vbaseren, vbaseven
          from FST198 g1
         Where tp1cod = pn_pgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 16
           and Tp1corr2 = 1
           and Tp1corr3 = 3;
      exception
        when others then
          vbaseren := 0;
          vbaseven := 0;
      end;
    
      for i in det loop
        begin
          select 'S'
            into noprod
            from fst198
           where tp1cod = pn_pgcod
             and Tp1cod1 = 10819
             and Tp1corr1 = 16
             and Tp1corr2 = 7
             and tp1nro1 = i.jaql733scmo
             and tp1nro2 = i.jaql733scto;
        exception
          when no_data_found then
            noprod := 'N';
        end;
      
        if noprod = 'N' then
          if not (pc_tipo = 'R' and i.jaql733scmo = 21) then
          
            vjaql734mmca := vjaql734mmca + nvl(i.jaql733mtca, 0) +
                            nvl(i.jaql733mtmc, 0) + nvl(i.jaql733au06, 0);
            vjaql734mmcf := vjaql734mmcf + nvl(i.jaql733mtmc, 0) +
                            nvl(i.jaql733mtre, 0) + nvl(i.jaql733mtin, 0);
            vjaql734mcpn := vjaql734mcpn + nvl(i.jaql733mtap, 0) +
                            nvl(i.jaql733mtac, 0);
          end if;
        
          if i.jaql733ticl = 'S' then
            if i.jaql733scmo = 21 then
              vjaql734clah := vjaql734clah + 1;
            else
              vjaql734clpf := vjaql734clpf + 1;
            end if;
          end if;
        
          vjaql734mren := vjaql734mren + nvl(i.jaql733mtre, 0);
        
          If pc_tipo = 'R' and i.jaql733mtre > 0 then
            vsalpont := vsalpont + (i.jaql733mtre * i.jaql733teat);
            vsalpona := vsalpona + (i.jaql733mtre * i.jaql733teaa);
          
            if i.jaql733mtre >= vbaseven then
              vvenreno := vvenreno + i.jaql733mtre;
            end if;
          end if;
        
          If pc_tipo = 'R' and
             (i.jaql733au07 between pd_fecini and pd_fecfin) /*and
                                                                                                                                                                                                                               nvl(i.jaql733mtca, 0) >= vbaseven and i.jaql733tisa = 'CR'*/
           then
            vjaql734mven := vjaql734mven + nvl(i.jaql733mtca, 0) +
                            nvl(i.jaql733mtmc, 0);
          End If;
        
        end if;
      
      end loop;
    
      vjaql734mmct := vjaql734mmcf + vjaql734mcpn;
    
      if vjaql734mmct = 0 and vjaql734mmca = 0 then
        vjaql734remc := 0;
      else
        vjaql734remc := (vjaql734mmct / case
                          when vjaql734mmca = 0 then
                           vjaql734mmct
                          else
                           vjaql734mmca
                        end) * 100;
      end if;
    
      begin
        select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
          into vjaql734memc
          from FST198 g1
         Where tp1cod = pn_pgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 16
           and Tp1corr2 = 2
           and Tp1corr3 = 1;
      exception
        when others then
          vjaql734memc := 0;
      end;
    
      vjaql734recl := vjaql734clah + vjaql734clpf;
    
      begin
        select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
          into vjaql734mecl
          from FST198 g1
         Where tp1cod = pn_pgcod
           and Tp1cod1 = 10819
           and Tp1corr1 = 16
           and Tp1corr2 = 2
           and Tp1corr3 = 2;
      exception
        when others then
          vjaql734mecl := 0;
      end;
    
      If pc_tipo = 'R' and vjaql734mren > 0 then
        vjaql734tpta := vsalpont / vjaql734mren;
        vjaql734tpac := vsalpona / vjaql734mren;
      
        begin
          select g1.tp1imp1
            into vtasaadi
            from FST198 g1
           Where tp1cod = pn_pgcod
             and Tp1cod1 = 10819
             and Tp1corr1 = 16
             and Tp1corr2 = 1
             and Tp1corr3 = 1;
        exception
          when others then
            vtasaadi := 0;
        end;
      
        vjaql734mbre := vvenreno * vbaseren;
        vjaql734tpme := vjaql734tpta + vtasaadi;
      
        vjaql734gfta := (vjaql734mbre * vjaql734tpta) / 100;
        vjaql734gfme := (vjaql734mbre * vjaql734tpme) / 100;
        vjaql734gfac := (vjaql734mbre * vjaql734tpac) / 100;
      
        vjaql734megf := vjaql734gfme - vjaql734gfta;
        vjaql734acgf := vjaql734gfac - vjaql734gfta;
        vjaql734regf := vjaql734megf - vjaql734acgf;
      end if;
    
      insert into jaql734
        (jaql734user,
         jaql734fepr,
         jaql734fein,
         jaql734fefi,
         jaql734sucu,
         jaql734nive,
         jaql734tipo,
         jaql734mmca,
         jaql734mmcf,
         jaql734mcpn,
         jaql734mmct,
         jaql734remc,
         jaql734memc,
         jaql734clah,
         jaql734clpf,
         jaql734recl,
         jaql734mecl,
         jaql734mven,
         jaql734mren,
         jaql734mbre,
         jaql734tpta,
         jaql734tpme,
         jaql734tpac,
         jaql734gfta,
         jaql734gfme,
         jaql734gfac,
         jaql734megf,
         jaql734acgf,
         jaql734regf,
         jaql734au03,
         jaql734au04,
         jaql734au05)
      values
        (pc_agente,
         pd_fecpro,
         pd_fecini,
         pd_fecfin,
         pn_sucur,
         vperfil,
         pc_tipo,
         vjaql734mmca,
         vjaql734mmcf,
         vjaql734mcpn,
         vjaql734mmct,
         vjaql734remc,
         vjaql734memc,
         vjaql734clah,
         vjaql734clpf,
         vjaql734recl,
         vjaql734mecl,
         vjaql734mven,
         vjaql734mren,
         vjaql734mbre,
         vjaql734tpta,
         vjaql734tpme,
         vjaql734tpac,
         vjaql734gfta,
         vjaql734gfme,
         vjaql734gfac,
         vjaql734megf,
         vjaql734acgf,
         vjaql734regf,
         vsalpont * 100,
         vsalpona * 100,
         vvenreno);
    
      commit;
    end if;
  end;

  -------------------------------------------------------------------------

  procedure Comision(pd_fecini date,
                     pd_fecfin date,
                     pd_fecpro date,
                     pc_tipo   char,
                     pc_agente char,
                     pn_pgcod  number) is
  
    cursor tot is
      select *
        from jaql734 j4
       where j4.jaql734fepr = pd_fecpro
         and j4.jaql734fein = pd_fecini
         and j4.jaql734fefi = pd_fecfin
         and j4.jaql734user = pc_agente;
  
    vfactor number;
    vperfil char(10);
    vmedpro number;
    vporcla number;
  
    vjaql734comc jaql734.jaql734comc%type := 0;
    vjaql734cocl jaql734.jaql734cocl%type := 0;
    vjaql734cogf jaql734.jaql734cogf%type := 0;
    vjaql734cocv jaql734.jaql734cocv%type := 0;
    vjaql734coto jaql734.jaql734coto%type := 0;
  
    vcomicl number;
    vtopemc number;
    vtopecl number;
  
    metcum number := 0;
  
    vjaql734comco jaql734.jaql734comc%type := 0;
    vjaql734coclo jaql734.jaql734cocl%type := 0;
  
  begin
    begin
      select g1.tp1imp1 / g1.tp1imp2
        into vfactor
        from FST198 g1
       Where tp1cod = pn_pgcod
         and Tp1cod1 = 10819
         and Tp1corr1 = 16
         and Tp1corr2 = 1
         and Tp1corr3 = 2;
    exception
      when others then
        vfactor := 0;
    end;
  
    begin
      select b.prfgcod
        into vperfil
        from FST198 a, prfu00 b
       Where Trim(a.Tp1desc) = trim(b.prfgcod)
         and Tp1cod = pn_pgcod
         and Tp1cod1 = 10819
         and Tp1corr1 = 3
         and Tp1nro1 <> 2
         and b.ubuser = pc_agente
         and rownum = 1;
    exception
      when no_data_found then
        vperfil := 'X';
    end;
  
    begin
      select g1.tp1imp3
        into vporcla
        from FST198 g1
       Where tp1cod = pn_pgcod
         and Tp1cod1 = 10819
         and Tp1corr1 = 16
         and Tp1corr2 = 2
         and Tp1corr3 = 2;
    exception
      when others then
        vporcla := 0;
    end;
  
    for i in tot loop
      if i.jaql734remc >= i.jaql734memc then
        begin
          select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
            into vtopemc
            from FST198 g1
           Where tp1cod = pn_pgcod
             and Tp1cod1 = 10819
             and Tp1corr1 = 16
             and Tp1corr2 = 5
             and trim(tp1desc) = trim(vperfil);
        exception
          when others then
            vtopemc := 0;
        end;
      
        vmedpro := vtopemc / 2;
      
        vjaql734comc := ((i.jaql734remc - i.jaql734memc) / 100) * vfactor *
                        vmedpro + vmedpro;
      
        if vtopemc < vjaql734comc then
          vjaql734comco := vjaql734comc;
          vjaql734comc  := vtopemc;
        end if;
      
        metcum := metcum + 1;
      
      end if;
    
      if i.jaql734recl >= i.jaql734mecl then
      
        begin
          select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
            into vcomicl
            from FST198 g1
           Where tp1cod = pn_pgcod
             and Tp1cod1 = 10819
             and Tp1corr1 = 16
             and Tp1corr2 = 3
             and trim(tp1desc) = trim(vperfil);
        exception
          when others then
            vcomicl := 0;
        end;
      
        if pc_tipo = 'R' then
          -- validar que ahorros no sea mayor del 70% de la meta
          if i.jaql734clpf < i.jaql734mecl * (1 - vporcla) then
            vcomicl := 0;
          end if;
        end if;
      
        vjaql734cocl := i.jaql734recl * vcomicl;
      
        if vjaql734cocl > 0 then
          metcum := metcum + 1;
        
          begin
            select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
              into vtopecl
              from FST198 g1
             Where tp1cod = pn_pgcod
               and Tp1cod1 = 10819
               and Tp1corr1 = 16
               and Tp1corr2 = 6
               and trim(tp1desc) = trim(vperfil);
          exception
            when others then
              vtopecl := 0;
          end;
        
          if vtopecl < vjaql734cocl then
            vjaql734coclo := vjaql734cocl;
            vjaql734cocl  := vtopecl;
          end if;
        end if;
      end if;
    
      if pc_tipo = 'R' then
        if i.jaql734regf > 0 or i.jaql734mren = 0 then
          begin
            select decode(pc_tipo, 'R', g1.tp1imp1, g1.tp1imp2)
              into vjaql734cogf
              from FST198 g1
             Where tp1cod = pn_pgcod
               and Tp1cod1 = 10819
               and Tp1corr1 = 16
               and Tp1corr2 = 4
               and trim(tp1desc) = trim(vperfil);
          exception
            when others then
              vjaql734cogf := 0;
          end;
        
          metcum := metcum + 1;
        end if;
      end if;
    
    end loop;
  
    if pc_tipo = 'C' then
      vjaql734coto := vjaql734comc + vjaql734cocl + vjaql734cocv;
    else
      --if metcum >= 2 then
      vjaql734coto := vjaql734comc + vjaql734cocl + vjaql734cogf;
      --end if;
    end if;
  
    update jaql734 j4
       set jaql734comc = vjaql734comc,
           jaql734cocl = vjaql734cocl,
           jaql734cogf = vjaql734cogf,
           jaql734cocv = vjaql734cocv,
           jaql734coto = vjaql734coto,
           jaql734au03 = vjaql734comco * 100,
           jaql734au04 = vjaql734coclo * 100
     where j4.jaql734fepr = pd_fecpro
       and j4.jaql734fein = pd_fecini
       and j4.jaql734fefi = pd_fecfin
       and j4.jaql734user = pc_agente;
  
    commit;
  
  exception
    when others then
      null;
    
  end;

  -------------------------------------------------------------------------

  procedure Tasa(vpgcod  number,
                 vScsuc  number,
                 vSccta  number,
                 vScmda  number,
                 vScpap  number,
                 vScoper number,
                 vScsbop number,
                 vSctope number,
                 vScmod  number,
                 vSfval  date,
                 vmonto  number,
                 vplazo  number,
                 tasa    out number) is
  
    petipo   char(1);
    tipo     number(9);
    ctifin   char(1);
    monto    number;
    vmodtcli number(9);
    vpgfape  date;
    vscrub   number(16);
  
  begin
  
    begin
      select pgfape into vpgfape from fst017 where pgcod = vpgcod;
    exception
      when others then
        vpgfape := trunc(sysdate);
    end;
  
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
  
    begin
      select totpiz
        into tipo
        from fst004
       where modulo = vscmod
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
        select distinct ModCodn
          into tipo
          from FST100 -- ModCodN
         Where ModTcli = vmodtcli
           and ModSuc = 0
           and ModCod = tipo;
      exception
        when no_data_found then
          null; -- tipo := 0; 20171025 si no existe para el modificador dejar el de PF
        When others then
          tipo := 0;
      end;
    end if;
  
    if vscmod = 21 then
      if vmonto = 0 then
        -- obtiene saldo de la cuenta
        begin
          select scsdo, scrub
            into monto, vscrub
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
            monto  := vmonto;
            vscrub := 0;
        end;
      
        If vpgfape != vSfval and vscrub <> 0 then
          -- si no es saldo a hoy obtiene saldo del historico
          Saldo_Hist(vpgcod,
                     vscsuc,
                     vsccta,
                     vscmda,
                     vscpap,
                     vscoper,
                     vscsbop,
                     vsctope,
                     vscmod,
                     vSfval,
                     vscrub,
                     monto);
        
          if monto = 0 then
            monto := vmonto;
          end if;
        end if;
      else
        monto := vmonto;
      end if;
    
      begin
        if vscmod = 21 and vsctope = 2 then
          --si es cts filtrar sin vigencia
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
                       and t4.tpvig = 'S'
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
          -- si no encontr? en fsd012 entonces nunca tuvo cambio tasa y busco en la fsd010
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
              monto := vmonto;
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
                           and t3.modulo = vscmod
                           and t3.tpizar = tipo
                           and t3.ctnro = vSccta
                           and t3.moneda = vscmda
                           and t4.tpmto >= monto
                           and t4.tpfdes <= vSfval
                           and t3.tppzo >= vplazo
                           and t4.tpvig = 'S'
                         order by t4.tpfdes desc, t4.tpmto, t3.tppzo)
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
                               and a.tapzo >= vplazo
                               and a.tamto >= monto
                               and a.tafdes <= vSfval
                             order by a.tafdes desc, a.tamto, a.tapzo)
                     where rownum = 1;
                  exception
                    when no_data_found then
                      tasa := 0;
                  end;
              end;
          end;
      end;
    end if;
  end;

  -------------------------------------------------------------------------

  procedure Saldo_Hist(vpgcod  number,
                       vScsuc  number,
                       vSccta  number,
                       vScmda  number,
                       vScpap  number,
                       vScoper number,
                       vScsbop number,
                       vSctope number,
                       vScmod  number,
                       vSfval  date,
                       vrubro  number,
                       vmonto  out number) is
  
  begin
  
    select h1.bcsdmo
      into vmonto
      from fsh012 h1
     where bcemp = vpgcod
       and bcsuc = vScsuc
       and bcmda = vScmda
       and bcpap = vScpap
       and bccta = vSccta
       and bcoper = vScoper
       and bcsbop = vScsbop
       and bctop = vSctope
       and bcmod = vScmod
       and bcfech = vSfval
       and h1.bcrubr = vrubro;
  
  exception
    when no_data_found then
      vmonto := 0;
  end;

end PQ_AH_PRODUCTIVIDAD;
/

