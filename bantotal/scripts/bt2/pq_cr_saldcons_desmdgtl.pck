create or replace package PQ_CR_SALDCONS_DESMDGTL is

  -- Author  : MPOSTIGOC
  -- Created : 12/08/2022 10:32:48
  -- Purpose : 

  procedure sp_cr_Inicio(ln_Instancia in number,
                         ln_scdigital out number,
                         ln_mnttope   out number,
                         lc_indicador out varchar2);
  -----------------------------------------------------
  procedure sp_logAQPB151(ln_inst   in number,
                          ld_fec    in date,
                          ln_maxdes in number,
                          ln_pgcod  in number,
                          ln_mod    in number,
                          ln_suc    in number,
                          ln_mda    in number,
                          ln_pap    in number,
                          ln_cta    in number,
                          ln_ope    in number,
                          ln_sbop   in number,
                          ln_top    in number,
                          ln_fdes   in date,
                          ln_mntdes in number,
                          ln_tcred  in varchar2);

end PQ_CR_SALDCONS_DESMDGTL;
/

create or replace package body PQ_CR_SALDCONS_DESMDGTL is

  procedure sp_cr_Inicio(ln_Instancia in number,
                         ln_scdigital out number,
                         ln_mnttope   out number,
                         lc_indicador out varchar2) is
  
    cursor creditos is
      select *
        from fsd010 f
       where f.PGCOD = 1
         and f.AOMDA = 0
         and f.AOPAP = 0
         and f.AOCTA in (select r.ctnro
                           from sng001 s, fsr008 r
                          where s.sng001pais = r.pepais
                            and s.sng001tdoc = r.petdoc
                            and s.sng001ndoc = r.pendoc
                            and r.cttfir = 'T'
                            and s.sng001inst = ln_Instancia)
         and f.AOMOD in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 107, 142, 144, 200))
         and f.AOSTAT <> 99;
  
    ln_tipoeval    number;
    ln_modtx       number;
    ln_tx          number;
    ln_saldaux     number(17, 2) := 0.00;
    ln_instcred    number;
    ln_modulo      number;
    ln_tipoper     number;
    ln_tipoevainst number;
    ln_mntmaxinst  number;
    ln_montocap    number;
    ln_reg         number;
    lc_EsAmp       varchar2(5);
    ld_fchsist     date;
    ln_pgcod       number;
    ln_suc         number;
    ln_mod         number;
    ln_mda         number;
    ln_pap         number;
    ln_cta         number;
    ln_ope         number;
    ln_sbop        number;
    ln_tope        number;
  
  begin
  
    ln_scdigital := 0.00;
    lc_indicador := 'N';
  
    begin
      update aqpb151 a
         set a.aqpa151est = 'I'
       where a.aqpb151inst = ln_Instancia;
      commit;
    end;
  
    begin
      select x.xwfmodulo, x.xwftipope
        into ln_modulo, ln_tipoper
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fchsist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng021tmod
        into ln_tipoevainst
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        ln_tipoevainst := 0;
    end;
  
    begin
      select f.tp1imp1
        into ln_mntmaxinst
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10801
         and f.tp1corr1 = 65
         and f.tp1corr2 = ln_modulo
         and f.tp1corr3 = ln_tipoper;
    exception
      when others then
        ln_mntmaxinst := 0;
    end;
  
    begin
      select c.xllcapital
        into ln_montocap
        from xwf700 x, x054023 c
       where x.xwfempresa = c.xllpgcod
         and x.xwfsucursal = c.xllaosuc
         and x.xwfmodulo = c.xllaomod
         and x.xwfmoneda = c.xllaomda
         and x.xwfpapel = c.xllaopap
         and x.xwfcuenta = c.xllaocta
         and x.xwfoperacion = c.xllaooper
         and x.xwfsubope = c.xllaosbop
         and x.xwftipope = c.xllaotop
         and x.xwfcar3 = '1'
         and x.xwfprcins = ln_Instancia;
    exception
      when others then
        ln_montocap := 0;
    end;
  
    begin
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_pgcod,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_tope
        from xwf700 x
       where x.xwfprcins = ln_Instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    Pq_Cr_Saldcons_Desmdgtl.sp_logAQPB151(ln_inst   => ln_Instancia,
                                          ld_fec    => ld_fchsist,
                                          ln_maxdes => ln_mntmaxinst,
                                          ln_pgcod  => ln_pgcod,
                                          ln_mod    => ln_mod,
                                          ln_suc    => ln_suc,
                                          ln_mda    => ln_mda,
                                          ln_pap    => ln_pap,
                                          ln_cta    => ln_cta,
                                          ln_ope    => ln_ope,
                                          ln_sbop   => ln_sbop,
                                          ln_top    => ln_tope,
                                          ln_fdes   => '',
                                          ln_mntdes => ln_montocap,
                                          ln_tcred  => 'CredVuelo');
  
    if ln_tipoevainst = 13 then
    
      for c in creditos loop
        ln_modtx := 0;
        ln_tx    := 0;
      
        ln_instcred := fn_instancia_credito(v_Scmod  => c.aomod,
                                            v_Scsuc  => c.aosuc,
                                            v_Scmda  => c.aomda,
                                            v_Scpap  => c.aopap,
                                            v_Sccta  => c.aocta,
                                            v_Scoper => c.aooper,
                                            v_Scsbop => c.aosbop,
                                            v_Sctope => c.aotope);
      
        pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_emp10  => c.pgcod,
                                                ln_mod10  => c.aomod,
                                                ln_suc10  => c.aosuc,
                                                ln_mda10  => c.aomda,
                                                ln_pap10  => c.aopap,
                                                ln_cta10  => c.aocta,
                                                ln_oper10 => c.aooper,
                                                ln_sbop10 => c.aosbop,
                                                ln_tope10 => c.aotope,
                                                Pc_flag   => lc_EsAmp);
      
        if ln_instcred > 0 and lc_EsAmp = 'N' then
        
          begin
            select s.sng021tmod
              into ln_tipoeval
              from sng021 s
             where s.sng021sol = ln_instcred;
          exception
            when others then
              ln_tipoeval := 0;
            
          end;
        
          if ln_tipoeval = 13 then
          
            begin
              select count(*)
                into ln_reg
                from fsh016 f
               where f.PGCOD = c.pgcod
                 and f.HMODUL = c.aomod
                 and f.HSUCUR = c.aosuc
                 and f.HMDA = c.aomda
                 and f.HPAP = c.aopap
                 and f.HCTA = c.aocta
                 and f.HOPER = c.aooper
                 and f.HSUBOP = c.aosbop
                 and f.HTOPER = c.aotope
                 and f.HFCON = c.aofval
                 and f.hcmod = 489
                 and f.htran in (951, 360);
            exception
              when others then
                ln_reg := 0;
            end;
          
            if ln_reg = 0 then
              begin
                select count(*)
                  into ln_reg
                  from fsd016 f
                 where f.pgcod = c.pgcod
                   and f.modulo = c.aomod
                   and f.itsucd = c.aosuc
                   and f.moneda = c.aomda
                   and f.papel = c.aopap
                   and f.ctnro = c.aocta
                   and f.itoper = c.aooper
                   and f.itsubo = c.aosbop
                   and f.ittope = c.aotope
                   and f.itfval = c.aofval
                   and f.itmod = 489
                   and f.ittran in (951, 360);
              exception
                when others then
                  ln_reg := 0;
              end;
            end if;
          
            if ln_reg > 0 then
            
              begin
                select f.scsdo
                  into ln_saldaux
                  from fsd011 f
                 where f.pgcod = c.pgcod
                   and f.scsuc = c.aosuc
                   and f.scmda = c.aomda
                   and f.scpap = c.aopap
                   and f.sccta = c.aocta
                   and f.scoper = c.aooper
                   and f.scsbop = c.aosbop
                   and f.sctope = c.aotope;
              exception
                when others then
                  ln_saldaux := 0;
              end;
            
              if ln_saldaux < 0 then
                ln_saldaux := ln_saldaux * -1;
              end if;
            
              ln_scdigital := ln_scdigital + ln_saldaux;
            
              Pq_Cr_Saldcons_Desmdgtl.sp_logAQPB151(ln_inst   => ln_Instancia,
                                                    ld_fec    => ld_fchsist,
                                                    ln_maxdes => ln_mntmaxinst,
                                                    ln_pgcod  => c.pgcod,
                                                    ln_mod    => c.aomod,
                                                    ln_suc    => c.aosuc,
                                                    ln_mda    => c.aomda,
                                                    ln_pap    => c.aopap,
                                                    ln_cta    => c.aocta,
                                                    ln_ope    => c.aooper,
                                                    ln_sbop   => c.aosbop,
                                                    ln_top    => c.aotope,
                                                    ln_fdes   => c.aofval,
                                                    ln_mntdes => ln_saldaux,
                                                    ln_tcred  => 'CredVigente');
            
            end if;
          end if;
        
        end if;
      end loop;
    end if;
  
    ln_scdigital := nvl(ln_scdigital, 0) + nvl(ln_montocap, 0);
  
    if ln_mntmaxinst >= ln_scdigital then
      lc_indicador := 'S';
      ln_mnttope   := ln_mntmaxinst;
    else
      lc_indicador := 'N';
      ln_mnttope   := ln_mntmaxinst;
    end if;
  
  end sp_Cr_inicio;
  ---------------------------------------------------
  procedure sp_logAQPB151(ln_inst   in number,
                          ld_fec    in date,
                          ln_maxdes in number,
                          ln_pgcod  in number,
                          ln_mod    in number,
                          ln_suc    in number,
                          ln_mda    in number,
                          ln_pap    in number,
                          ln_cta    in number,
                          ln_ope    in number,
                          ln_sbop   in number,
                          ln_top    in number,
                          ln_fdes   in date,
                          ln_mntdes in number,
                          ln_tcred  in varchar2) is
  
    ln_corr number := 0;
    lc_hora char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpa151corr)
        into ln_corr
        from aqpb151 a
       where a.aqpb151inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        lc_hora := '00:00:00';
    end;
  
    begin
    
      insert into aqpb151
        (aqpa151corr,
         aqpb151inst,
         aqpb151fec,
         aqpb151hora,
         aqpb151maxdes,
         aqpb151pgcod,
         aqpb151mod,
         aqpb151suc,
         aqpb151mda,
         aqpb151pap,
         aqpb151cta,
         aqpb151ope,
         aqpb151sbop,
         aqpb151top,
         aqpb151fdes,
         aqpb151mntdes,
         aqpa151tcred,
         aqpa151est)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fec,
         lc_hora,
         ln_maxdes,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_top,
         ln_fdes,
         ln_mntdes,
         ln_tcred,
         'H');
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_logAQPB151;

end PQ_CR_SALDCONS_DESMDGTL;
/

