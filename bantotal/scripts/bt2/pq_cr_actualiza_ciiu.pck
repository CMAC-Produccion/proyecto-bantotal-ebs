create or replace package PQ_CR_ACTUALIZA_CIIU is

  -- Author  : MPOSTIGOC
  -- Created : 23/03/2023 11:11:46
  -- Purpose : 

  procedure sp_cr_CiiuActual(ln_pais     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             ln_codciiu  out number,
                             lc_descciiu out varchar2);
  --------------------------------------------------------
  procedure sp_cr_UpdateCIIU(ln_pais        in number,
                             ln_tdoc        in number,
                             lc_ndoc        in varchar2,
                             lc_user        in varchar2,
                             ln_codAciiu    in number,
                             lc_descAciiu   in varchar2,
                             lc_Codsesion   in varchar2,
                             ln_Coddivision in number,
                             ln_CodGrupo    in number,
                             ln_CodClase    in number, -- Cod Nuevo CIIU
                             lc_DescClase   in varchar2 -- Desc Nuevo CIIU                          
                             );

  ----------------------------------------------------------------------------
  procedure sp_cr_VerfActCIIU(ln_pais       in number,
                              ln_tdoc       in number,
                              lc_ndoc       in varchar2,
                              lc_VerActCIIU out varchar2);
  -------------------------------------------------------
  procedure sp_cr_reporteCIUU(lc_Usuario  in varchar2,
                              ln_region   in number,
                              ln_zona     in number,
                              ln_sucursal in number,
                              lc_Analista in varchar2);
  --------------------------------------------------------
  procedure sp_Cr_LogReporte(lc_user   in varchar2,
                             ln_reg    in number,
                             ln_zon    in number,
                             ln_suc    in number,
                             lc_anls   in varchar2,
                             lc_dni    in varchar2,
                             lc_nomcl  in varchar2,
                             lc_inda   in varchar2,
                             ld_fact   in date,
                             ln_ciiua  in number,
                             lc_ciiuad in varchar2,
                             ln_ciiun  in number,
                             lc_ciiund in varchar2);

end PQ_CR_ACTUALIZA_CIIU;
/

create or replace package body PQ_CR_ACTUALIZA_CIIU is

  procedure sp_cr_CiiuActual(ln_pais     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             ln_codciiu  out number,
                             lc_descciiu out varchar2) is
  
    lv_petipo varchar2(5);
  
  begin
  
    lv_petipo   := pq_client_ciiu.fn_petipo(ln_pais,
                                            ln_tdoc,
                                            rpad(lc_ndoc, 12, ' '));
    ln_codciiu  := 0;
    lc_descciiu := null;
  
    If lv_petipo = 'F' Then
      Begin
        Select c60.sngc60acte
          Into ln_codciiu
          From sngc60 c60
         Where c60.sngc60pais = ln_pais
           And c60.sngc60tdoc = ln_tdoc
           And c60.sngc60ndoc = rpad(lc_ndoc, 12, ' ')
           And c60.sngc60corr = 0;
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select e001.expnins --
          Into ln_codciiu
          From fse001 e001
         Where e001.d511pais = ln_pais
           And e001.d511tdoc = ln_tdoc
           And e001.d511ndoc = rpad(lc_ndoc, 12, ' ');
      Exception
        when others then
          ln_codciiu := 0;
      End;
    End If;
  
    begin
      select f.actnom1
        into lc_descciiu
        from fst750 f
       where f.actcod1 = ln_codciiu;
    exception
      when others then
        null;
    end;
  
  end sp_cr_CiiuActual;
  ----------------------------------------------------------------
  procedure sp_cr_UpdateCIIU(ln_pais        in number,
                             ln_tdoc        in number,
                             lc_ndoc        in varchar2,
                             lc_user        in varchar2,
                             ln_codAciiu    in number,
                             lc_descAciiu   in varchar2,
                             lc_Codsesion   in varchar2,
                             ln_Coddivision in number,
                             ln_CodGrupo    in number,
                             ln_CodClase    in number, -- Cod Nuevo CIIU
                             lc_DescClase   in varchar2 -- Desc Nuevo CIIU                          
                             ) is
  
    ld_fech date;
    ln_corr number;
    lc_hora char(8);
  
  begin
  
    begin
      update aqpc290 a
         set a.aqpc290est = 'I'
       where a.aqpc290pais = ln_pais
         and a.aqpc290tdoc = ln_tdoc
         and a.aqpc290ndoc = lc_ndoc;
      commit;
    end;
  
    begin
      select f.pgfape into ld_fech from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_corr
        from aqpc290 a
       where a.aqpc290pais = ln_pais
         and a.aqpc290tdoc = ln_tdoc
         and a.aqpc290ndoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpc290
        (aqpc290corr,
         aqpc290pais,
         aqpc290tdoc,
         aqpc290ndoc,
         aqpc290fecha,
         aqpc290user,
         aqpc290hora,
         aqpc290ciiua,
         aqpc290ciiuda,
         aqpc290ciiun,
         aqpc290ciiudn,
         aqpc290cgrp,
         aqpc290cdvs,
         aqpc290csesi,
         aqpc290est)
      values
        (ln_corr + 1,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ld_fech,
         lc_user,
         lc_hora,
         ln_codAciiu,
         lc_descAciiu,
         ln_CodClase,
         lc_DescClase,
         ln_CodGrupo,
         ln_Coddivision,
         lc_Codsesion,
         'H');
      commit;
    exception
      when others then
        null;
    end;
  
  end;
  ----------------------------------------------------------------------------
  procedure sp_cr_VerfActCIIU(ln_pais       in number,
                              ln_tdoc       in number,
                              lc_ndoc       in varchar2,
                              lc_VerActCIIU out varchar2) is
  
    ln_CantReg number;
  
  begin
  
    begin
      select count(*)
        into ln_CantReg
        from aqpc290 a
       where a.aqpc290pais = ln_pais
         and a.aqpc290tdoc = ln_tdoc
         and a.aqpc290ndoc = lc_ndoc
         and a.aqpc290est = 'H';
    exception
      when others then
        ln_CantReg := 0;
    end;
  
    if ln_CantReg > 0 then
      lc_VerActCIIU := 'S';
    else
      lc_VerActCIIU := 'N';
    end if;
  
  end sp_cr_VerfActCIIU;
  ---------------------------------------------------------------
  procedure sp_cr_reporteCIUU(lc_Usuario  in varchar2,
                              ln_region   in number,
                              ln_zona     in number,
                              ln_sucursal in number,
                              lc_Analista in varchar2) is
  
    cursor PorRegion is
      select distinct r.regcod,
                      r.codzon,
                      r.sucurs,
                      f.aocta,
                      s.sng001ase,
                      (select q.pendoc
                         from fsr008 q
                        where q.pgcod = 1
                          and q.ctnro = f.aocta
                          and q.cttfir = 'T') DNI,
                      (select e.penom
                         from fsr008 w, fsd001 e
                        where w.pepais = e.pepais
                          and w.petdoc = e.petdoc
                          and w.pendoc = e.pendoc
                          and w.pgcod = 1
                          and w.ctnro = f.aocta
                          and w.cttfir = 'T') Nomb_Cliente
        from fsd010 f, xwf700 x, sng001 s, regsuc r
       where f.pgcod = x.xwfempresa
         and f.aomod = x.xwfmodulo
         and f.aosuc = x.xwfsucursal
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and f.aosbop = x.xwfsubope
         and f.aotope = x.xwftipope
         and x.xwfprcins = s.sng001inst
         and x.xwfcar3 = '1'
         and f.aosuc = r.sucurs
         and r.regcod = ln_region
         and (f.aomod in (select t.modulo from fst111 t where t.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aostat <> 99;
  
    cursor PorZona is
      select distinct r.regcod,
                      r.codzon,
                      r.sucurs,
                      f.aocta,
                      s.sng001ase,
                      (select q.pendoc
                         from fsr008 q
                        where q.pgcod = 1
                          and q.ctnro = f.aocta
                          and q.cttfir = 'T') DNI,
                      (select e.penom
                         from fsr008 w, fsd001 e
                        where w.pepais = e.pepais
                          and w.petdoc = e.petdoc
                          and w.pendoc = e.pendoc
                          and w.pgcod = 1
                          and w.ctnro = f.aocta
                          and w.cttfir = 'T') Nomb_Cliente
        from fsd010 f, xwf700 x, sng001 s, regsuc r
       where f.pgcod = x.xwfempresa
         and f.aomod = x.xwfmodulo
         and f.aosuc = x.xwfsucursal
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and f.aosbop = x.xwfsubope
         and f.aotope = x.xwftipope
         and x.xwfprcins = s.sng001inst
         and x.xwfcar3 = '1'
         and f.aosuc = r.sucurs
         and r.regcod = ln_region
         and r.codzon = ln_Zona
         and (f.aomod in (select t.modulo from fst111 t where t.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aostat <> 99;
  
    cursor PorSucursal is
      select distinct r.regcod,
                      r.codzon,
                      r.sucurs,
                      f.aocta,
                      s.sng001ase,
                      (select q.pendoc
                         from fsr008 q
                        where q.pgcod = 1
                          and q.ctnro = f.aocta
                          and q.cttfir = 'T') DNI,
                      (select e.penom
                         from fsr008 w, fsd001 e
                        where w.pepais = e.pepais
                          and w.petdoc = e.petdoc
                          and w.pendoc = e.pendoc
                          and w.pgcod = 1
                          and w.ctnro = f.aocta
                          and w.cttfir = 'T') Nomb_Cliente
        from fsd010 f, xwf700 x, sng001 s, regsuc r
       where f.pgcod = x.xwfempresa
         and f.aomod = x.xwfmodulo
         and f.aosuc = x.xwfsucursal
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and f.aosbop = x.xwfsubope
         and f.aotope = x.xwftipope
         and x.xwfprcins = s.sng001inst
         and x.xwfcar3 = '1'
         and f.aosuc = r.sucurs
         and r.regcod = ln_region
         and r.codzon = ln_Zona
         and r.sucurs = ln_sucursal
         and (f.aomod in (select t.modulo from fst111 t where t.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aostat <> 99;
  
    cursor PorAnalista is
      select distinct r.regcod,
                      r.codzon,
                      r.sucurs,
                      f.aocta,
                      s.sng001ase,
                      (select q.pendoc
                         from fsr008 q
                        where q.pgcod = 1
                          and q.ctnro = f.aocta
                          and q.cttfir = 'T') DNI,
                      (select e.penom
                         from fsr008 w, fsd001 e
                        where w.pepais = e.pepais
                          and w.petdoc = e.petdoc
                          and w.pendoc = e.pendoc
                          and w.pgcod = 1
                          and w.ctnro = f.aocta
                          and w.cttfir = 'T') Nomb_Cliente
        from fsd010 f, xwf700 x, sng001 s, regsuc r
       where f.pgcod = x.xwfempresa
         and f.aomod = x.xwfmodulo
         and f.aosuc = x.xwfsucursal
         and f.aomda = x.xwfmoneda
         and f.aopap = x.xwfpapel
         and f.aocta = x.xwfcuenta
         and f.aooper = x.xwfoperacion
         and f.aosbop = x.xwfsubope
         and f.aotope = x.xwftipope
         and x.xwfprcins = s.sng001inst
         and x.xwfcar3 = '1'
         and f.aosuc = r.sucurs
         and r.regcod = ln_region
         and r.codzon = ln_Zona
         and r.sucurs = ln_sucursal
         and s.sng001ase = rpad(lc_Analista, 10, ' ')
         and (f.aomod in (select t.modulo from fst111 t where t.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aostat <> 99;
    -- and f.aocta = 2283124;
  
    ln_pais       number;
    ln_tdoc       number;
    lc_ndoc       varchar2(12);
    lc_EstaUPD    varchar2(5);
    ln_CiiuAnt    number;
    lc_CiiuAntDes varchar2(60);
    ln_CiiuNew    number;
    lc_CiiuNewDes varchar2(60);
    ld_FechUpd    date;
    lc_ndoc2      varchar2(12);
  
  begin
  
    begin
      delete aqpc291 a where a.aqpc291user = lc_Usuario;
      commit;
    end;
  
    if ln_region > 0 and ln_zona = 0 and ln_sucursal = 0 and
       lc_analista is null then
      for r in PorRegion loop
      
        begin
          begin
            select f.pepais, f.petdoc, f.pendoc
              into ln_pais, ln_tdoc, lc_ndoc
              from fsr008 f
             where f.pgcod = 1
               and f.ctnro = r.aocta
               and f.cttfir = 'T';
          exception
            when others then
              null;
          end;
        
          lc_ndoc2 := trim(lc_ndoc);
        
          pq_cr_actualiza_ciiu.sp_cr_VerfActCIIU(ln_pais       => ln_pais,
                                                 ln_tdoc       => ln_tdoc,
                                                 lc_ndoc       => lc_ndoc2,
                                                 lc_VerActCIIU => lc_EstaUPD);
        
          if lc_EstaUPD = 'S' then
            begin
              select a.aqpc290fecha,
                     a.aqpc290ciiua,
                     a.aqpc290ciiuda,
                     a.aqpc290ciiun,
                     a.aqpc290ciiudn
                into ld_FechUpd,
                     ln_CiiuAnt,
                     lc_CiiuAntDes,
                     ln_CiiuNew,
                     lc_CiiuNewDes
                from aqpc290 a
               where a.aqpc290pais = ln_pais
                 and a.aqpc290tdoc = ln_tdoc
                 and a.aqpc290ndoc = lc_ndoc2
                 and a.aqpc290est = 'H';
            exception
              when others then
                null;
            end;
          end if;
        end;
      
        pq_cr_actualiza_ciiu.sp_Cr_LogReporte(lc_user   => lc_Usuario,
                                              ln_reg    => r.regcod,
                                              ln_zon    => r.codzon,
                                              ln_suc    => r.sucurs,
                                              lc_anls   => r.sng001ase,
                                              lc_dni    => r.dni,
                                              lc_nomcl  => r.nomb_cliente,
                                              lc_inda   => lc_EstaUPD,
                                              ld_fact   => ld_FechUpd,
                                              ln_ciiua  => ln_CiiuAnt,
                                              lc_ciiuad => lc_CiiuAntDes,
                                              ln_ciiun  => ln_CiiuNew,
                                              lc_ciiund => lc_CiiuNewDes);
      
      end loop;
    else
      if ln_region > 0 and ln_zona > 0 and ln_sucursal = 0 and
         lc_analista is null then
        for r in PorZona loop
        
          begin
            begin
              select f.pepais, f.petdoc, f.pendoc
                into ln_pais, ln_tdoc, lc_ndoc
                from fsr008 f
               where f.pgcod = 1
                 and f.ctnro = r.aocta
                 and f.cttfir = 'T';
            exception
              when others then
                null;
            end;
          
            lc_ndoc2 := trim(lc_ndoc);
          
            pq_cr_actualiza_ciiu.sp_cr_VerfActCIIU(ln_pais       => ln_pais,
                                                   ln_tdoc       => ln_tdoc,
                                                   lc_ndoc       => lc_ndoc2,
                                                   lc_VerActCIIU => lc_EstaUPD);
          
            if lc_EstaUPD = 'S' then
            
              begin
                select a.aqpc290fecha,
                       a.aqpc290ciiua,
                       a.aqpc290ciiuda,
                       a.aqpc290ciiun,
                       a.aqpc290ciiudn
                  into ld_FechUpd,
                       ln_CiiuAnt,
                       lc_CiiuAntDes,
                       ln_CiiuNew,
                       lc_CiiuNewDes
                  from aqpc290 a
                 where a.aqpc290pais = ln_pais
                   and a.aqpc290tdoc = ln_tdoc
                   and a.aqpc290ndoc = lc_ndoc2
                   and a.aqpc290est = 'H';
              exception
                when others then
                  null;
              end;
            end if;
          end;
        
          pq_cr_actualiza_ciiu.sp_Cr_LogReporte(lc_user   => lc_Usuario,
                                                ln_reg    => r.regcod,
                                                ln_zon    => r.codzon,
                                                ln_suc    => r.sucurs,
                                                lc_anls   => r.sng001ase,
                                                lc_dni    => r.dni,
                                                lc_nomcl  => r.nomb_cliente,
                                                lc_inda   => lc_EstaUPD,
                                                ld_fact   => ld_FechUpd,
                                                ln_ciiua  => ln_CiiuAnt,
                                                lc_ciiuad => lc_CiiuAntDes,
                                                ln_ciiun  => ln_CiiuNew,
                                                lc_ciiund => lc_CiiuNewDes);
        
        end loop;
      else
        if ln_region > 0 and ln_zona > 0 and ln_sucursal > 0 and
           lc_analista is null then
        
          for r in PorSucursal loop
          
            begin
              begin
                select f.pepais, f.petdoc, f.pendoc
                  into ln_pais, ln_tdoc, lc_ndoc
                  from fsr008 f
                 where f.pgcod = 1
                   and f.ctnro = r.aocta
                   and f.cttfir = 'T';
              exception
                when others then
                  null;
              end;
            
              lc_ndoc2 := trim(lc_ndoc);
            
              pq_cr_actualiza_ciiu.sp_cr_VerfActCIIU(ln_pais       => ln_pais,
                                                     ln_tdoc       => ln_tdoc,
                                                     lc_ndoc       => lc_ndoc2,
                                                     lc_VerActCIIU => lc_EstaUPD);
            
              if lc_EstaUPD = 'S' then
              
                begin
                  select a.aqpc290fecha,
                         a.aqpc290ciiua,
                         a.aqpc290ciiuda,
                         a.aqpc290ciiun,
                         a.aqpc290ciiudn
                    into ld_FechUpd,
                         ln_CiiuAnt,
                         lc_CiiuAntDes,
                         ln_CiiuNew,
                         lc_CiiuNewDes
                    from aqpc290 a
                   where a.aqpc290pais = ln_pais
                     and a.aqpc290tdoc = ln_tdoc
                     and a.aqpc290ndoc = lc_ndoc2
                     and a.aqpc290est = 'H';
                exception
                  when others then
                    null;
                end;
              
              end if;
            end;
          
            pq_cr_actualiza_ciiu.sp_Cr_LogReporte(lc_user   => lc_Usuario,
                                                  ln_reg    => r.regcod,
                                                  ln_zon    => r.codzon,
                                                  ln_suc    => r.sucurs,
                                                  lc_anls   => r.sng001ase,
                                                  lc_dni    => r.dni,
                                                  lc_nomcl  => r.nomb_cliente,
                                                  lc_inda   => lc_EstaUPD,
                                                  ld_fact   => ld_FechUpd,
                                                  ln_ciiua  => ln_CiiuAnt,
                                                  lc_ciiuad => lc_CiiuAntDes,
                                                  ln_ciiun  => ln_CiiuNew,
                                                  lc_ciiund => lc_CiiuNewDes);
          
          end loop;
        else
          if ln_region > 0 and ln_zona > 0 and ln_sucursal > 0 and
             lc_analista is not null then
          
            for r in PorAnalista loop
            
              begin
                begin
                  select f.pepais, f.petdoc, f.pendoc
                    into ln_pais, ln_tdoc, lc_ndoc
                    from fsr008 f
                   where f.pgcod = 1
                     and f.ctnro = r.aocta
                     and f.cttfir = 'T';
                exception
                  when others then
                    null;
                end;
              
                lc_ndoc2 := trim(lc_ndoc);
              
                pq_cr_actualiza_ciiu.sp_cr_VerfActCIIU(ln_pais       => ln_pais,
                                                       ln_tdoc       => ln_tdoc,
                                                       lc_ndoc       => lc_ndoc2,
                                                       lc_VerActCIIU => lc_EstaUPD);
              
                if lc_EstaUPD = 'S' then
                
                  begin
                    select a.aqpc290fecha,
                           a.aqpc290ciiua,
                           a.aqpc290ciiuda,
                           a.aqpc290ciiun,
                           a.aqpc290ciiudn
                      into ld_FechUpd,
                           ln_CiiuAnt,
                           lc_CiiuAntDes,
                           ln_CiiuNew,
                           lc_CiiuNewDes
                      from aqpc290 a
                     where a.aqpc290pais = ln_pais
                       and a.aqpc290tdoc = ln_tdoc
                       and a.aqpc290ndoc = lc_ndoc2
                       and a.aqpc290est = 'H';
                  exception
                    when others then
                      null;
                  end;
                end if;
              end;
            
              pq_cr_actualiza_ciiu.sp_Cr_LogReporte(lc_user   => lc_Usuario,
                                                    ln_reg    => r.regcod,
                                                    ln_zon    => r.codzon,
                                                    ln_suc    => r.sucurs,
                                                    lc_anls   => r.sng001ase,
                                                    lc_dni    => r.dni,
                                                    lc_nomcl  => r.nomb_cliente,
                                                    lc_inda   => lc_EstaUPD,
                                                    ld_fact   => ld_FechUpd,
                                                    ln_ciiua  => ln_CiiuAnt,
                                                    lc_ciiuad => lc_CiiuAntDes,
                                                    ln_ciiun  => ln_CiiuNew,
                                                    lc_ciiund => lc_CiiuNewDes);
            
            end loop;
          end if;
        end if;
      end if;
    end if;
  
  end sp_cr_reporteCIUU;
  ------------------------------------------------------------
  procedure sp_Cr_LogReporte(lc_user   in varchar2,
                             ln_reg    in number,
                             ln_zon    in number,
                             ln_suc    in number,
                             lc_anls   in varchar2,
                             lc_dni    in varchar2,
                             lc_nomcl  in varchar2,
                             lc_inda   in varchar2,
                             ld_fact   in date,
                             ln_ciiua  in number,
                             lc_ciiuad in varchar2,
                             ln_ciiun  in number,
                             lc_ciiund in varchar2) is
    ln_corr number := 0;
  
  begin
  
    begin
      select max(a.aqpc291corr)
        into ln_corr
        from aqpc291 a
       where a.aqpc291user = lc_user;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      insert into aqpc291
        (aqpc291corr,
         aqpc291user,
         aqpc291reg,
         aqpc291zon,
         aqpc291suc,
         aqpc291anls,
         aqpc291dni,
         aqpc291nomcl,
         aqpc291inda,
         aqpc291fact,
         aqpc291ciiua,
         aqpc291ciiuad,
         aqpc291ciiun,
         aqpc291ciiund)
      values
        (ln_corr + 1,
         lc_user,
         ln_reg,
         ln_zon,
         ln_suc,
         lc_anls,
         lc_dni,
         lc_nomcl,
         lc_inda,
         ld_fact,
         ln_ciiua,
         lc_ciiuad,
         ln_ciiun,
         lc_ciiund);
      commit;
    exception
      when others then
        null;
    end;
  end sp_Cr_LogReporte;
  -------------------------------------------------------------
end PQ_CR_ACTUALIZA_CIIU;
/

