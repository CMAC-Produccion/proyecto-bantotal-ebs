create or replace package pq_cr_repro_faeturismo is

  -- Author  : RMONTESR
  -- Created : 15/03/2023 16:47:02
  -- Purpose : PAquete RTE Repro Fae Turismo

  procedure sp_cr_Inicio(ln_pgcodt in number,
                         ln_suct   in number,
                         ln_modt   in number,
                         ln_ttran  in number,
                         ln_relt   in number,
                         ln_ordt   in number,
                         ln_sbort  in number);
  ---------------------------------------------
  procedure sp_cr_validar_fecha(ln_inst in number, lc_rpta out varchar2);

end pq_cr_repro_faeturismo;
/

create or replace package body pq_cr_repro_faeturismo is

  procedure sp_cr_Inicio(ln_pgcodt in number,
                         ln_suct   in number,
                         ln_modt   in number,
                         ln_ttran  in number,
                         ln_relt   in number,
                         ln_ordt   in number,
                         ln_sbort  in number) is
  
    ld_fchsist date;
    --actual
    pn_empa number;
    pn_moda number;
    pn_suca number;
    pn_mdaa number;
    pn_papa number;
    pn_ctaa number;
    pn_opea number;
    pn_sboa number;
    pn_topa number;
    --anterior
    pn_emp       number;
    pn_mod       number;
    pn_suc       number;
    pn_mda       number;
    pn_pap       number;
    pn_cta       number;
    pn_ope       number;
    pn_sbo       number;
    pn_top       number;
    ln_Instancia number;
  
    ld_itfcon date;
    lc_ithor  char(8);
    lc_ituser char(10);
  
    ln_cuotas   number;
    ln_tea      number;
    ln_gracia   number;
    ln_tdoc     number;
    lc_ndoc     varchar(12);
    ld_fini     date;
    ld_ffin     date;
    lc_ncliente varchar2(50);
  
    ln_comision number;
    lv_tfondo   varchar2(50);
    ln_capital  number;
    ln_porce    number;
    lv_mensaje  varchar2(50);
    ld_fecN     date;
  
    ln_cuotasa number;
    ld_ffinr   date;
    ld_ppago   date;
    ln_dgracia number;
    ln_tasa    number;
    ln_montor  number;
  
  begin
    begin
      select F.PGCOD,
             F.MODULO,
             F.ITSUCD,
             F.MONEDA,
             F.PAPEL,
             F.CTNRO,
             F.ITOPER,
             F.ITSUBO,
             F.ITTOPE
        into pn_empa,
             pn_moda,
             pn_suca,
             pn_mdaa,
             pn_papa,
             pn_ctaa,
             pn_opea,
             pn_sboa,
             pn_topa
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt
         and f.itsbor = ln_sbort;
    exception
      when others then
        null;
    end;
    if pn_topa = 355 then
      begin
        select m.itfcon, m.ithora, m.itucnf
          into ld_itfcon, lc_ithor, lc_ituser
          from fsd015 m
         where m.pgcod = ln_pgcodt
           and m.itsuc = ln_suct
           and m.itmod = ln_modt
           and m.ittran = ln_ttran
           and m.itnrel = ln_relt
           and rownum = 1;
      exception
        when others then
          null;
      end;
      begin
        ln_Instancia := fn_instancia_credito(v_Scmod  => pn_moda,
                                             v_Scsuc  => pn_suca,
                                             v_Scmda  => pn_mdaa,
                                             v_Scpap  => pn_papa,
                                             v_Sccta  => pn_ctaa,
                                             v_Scoper => pn_opea,
                                             v_Scsbop => pn_sboa,
                                             v_Sctope => pn_topa);
      exception
        when others then
          null;
      end;
    
      begin
        select t9.xwfempresa,
               t9.xwfsucursal,
               t9.xwfmodulo,
               t9.xwfmoneda,
               t9.xwfpapel,
               t9.xwfcuenta,
               t9.xwfoperacion,
               t9.xwfsubope,
               t9.xwftipope
          into pn_emp,
               pn_suc,
               pn_mod,
               pn_mda,
               pn_pap,
               pn_cta,
               pn_ope,
               pn_sbo,
               pn_top
          from xwf700 t9
         where t9.xwfprcins = ln_instancia
           and t9.xwfcar3 = 'S'
           and rownum = 1;
      exception
        when others then
          null;
      end;
      ln_montor := 0;
      begin
        select t9.xwfmonto1
          into ln_montor
          from xwf700 t9
         where t9.xwfprcins = ln_instancia
           and t9.xwfcar3 = '1'
           and rownum = 1;
      exception
        when others then
          null;
      end;
    
      /*obtener la primera cuota con capital e interes */
    
      begin
        select min(ppfpag)
          into ld_fecN --fecha1
          from fsd601
         where pgcod = pn_empa
           and ppmod = pn_moda
           and ppcta = pn_ctaa
           and ppoper = pn_opea
           and ppsbop = pn_sboa
           and pptope = pn_topa
           and ppcap > 0;
      exception
        when others then
          ld_fecN := null;
      end;
    
      begin
        select pgfape into ld_fchsist from fst017 where pgcod = 1;
      exception
        when others then
          null;
      end;
      ln_cuotas := 0;
      ln_tea    := 0;
      begin
        select case
                 when t2.aoperiod = 0 then
                  0
                 else
                  floor(t2.aopzo / t2.aoperiod)
               end, --periodo
               t2.aotasa
          into ln_cuotas, ln_tea
          from fsd010 t2
         where pgcod = pn_emp
           and aomod = pn_mod
           and aosuc = pn_suc
           and aomda = pn_mda
           and aopap = pn_pap
           and aocta = pn_cta
           and aooper = pn_ope
           and aosbop = pn_sbo
           and aotope = pn_top;
      exception
        when others then
          null;
      end;
    
      ln_tasa := 0;
      begin
        select t2.aotasa
          into ln_tasa
          from fsd010 t2
         where pgcod = pn_empa
           and aomod = pn_moda
           and aosuc = pn_suca
           and aomda = pn_mdaa
           and aopap = pn_papa
           and aocta = pn_ctaa
           and aooper = pn_opea
           and aosbop = pn_sboa
           and aotope = pn_topa;
      exception
        when others then
          null;
      end;
      -- cuotas origen
      begin
      
        SELECT
        
         count(*)
          into ln_cuotas
          FROM FSD601 t
         where t.pgcod = pn_emp
           and t.ppmod = pn_mod
           and t.ppsuc = pn_suc
           and t.ppmda = pn_mda
           and t.pppap = pn_pap
           and t.ppcta = pn_cta
           and t.ppoper = pn_ope
           and t.ppsbop = pn_sbo
           and t.pptope = pn_top
           and t.d601co = 'S';
      exception
        when others then
          ln_cuotas := 0;
      end;
    
      -- cuotas actual
      ln_cuotasa := 0;
      begin
      
        SELECT count(*)
          into ln_cuotasa
          FROM FSD601 t
         where t.pgcod = pn_empa
           and t.ppmod = pn_moda
           and t.ppsuc = pn_suca
           and t.ppmda = pn_mdaa
           and t.pppap = pn_papa
           and t.ppcta = pn_ctaa
           and t.ppoper = pn_opea
           and t.ppsbop = pn_sboa
           and t.pptope = pn_topa
           and t.d601co = 'S';
      exception
        when others then
          ln_cuotasa := 0;
      end;
      begin
        select case
                 when t1.aqpb762btdoc = 'DNI/LE' then
                  21
                 else
                  9
               end,
               t1.aqpb762bndoc,
               t1.aqpb762bfico,
               t1.aqpb762bffco,
               t1.aqpb762bgrci --pgracia
          into ln_tdoc, lc_ndoc, ld_fini, ld_ffin, ln_gracia
          from aqpb762b t1
         where t1.aqpb762bccta = pn_cta
           and t1.aqpb762boper = pn_ope
           and t1.aqpb762best <> 'D';
      exception
        when others then
          null;
      end;
      if ln_tdoc = 21 then
        begin
          select trim(t1.pfape1) || ' ' || trim(t1.pfape2) || ', ' ||
                 trim(pfnom1) || ' ' || trim(pfnom2)
            into lc_ncliente
            from fsd002 t1
           where t1.pfpais = 604
             and t1.pftdoc = ln_tdoc
             and t1.pfndoc = rpad(lc_ndoc, 12);
        exception
          when others then
            null;
        end;
      else
        begin
          select trim(t1.pjrazs)
            into lc_ncliente
            from fsd003 t1
           where t1.pjpais = 604
             and t1.pjtdoc = ln_tdoc
             and t1.pjndoc = rpad(lc_ndoc, 12);
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        -- Call the procedure
        pq_cr_rpgflujo_fondo_hs.sp_calcular_comision(ve_instancia   => ln_instancia,
                                                     ve_pgcod       => pn_emp,
                                                     ve_scmod       => pn_mod,
                                                     ve_scsuc       => pn_suc,
                                                     ve_scmda       => pn_mda,
                                                     ve_scpap       => pn_pap,
                                                     ve_sccta       => pn_cta,
                                                     ve_scoper      => pn_ope,
                                                     ve_scsbop      => pn_sbo,
                                                     ve_sctope      => pn_top,
                                                     ve_MtoCom      => ln_comision,
                                                     ve_TpFndo      => lv_tfondo,
                                                     ve_capitalc    => ln_capital,
                                                     ve_porcentajec => ln_porce,
                                                     msg            => lv_mensaje);
      exception
        when others then
          null;
      end;
    
      
    
      begin
        -- Call the procedure
        pq_cr_fae_turismo.sp_cr_dias_gracia(pn_instancia => ln_Instancia,
                                            pn_result    => ln_dgracia);
      exception
        when others then
          null;
      end;
    
      begin
        select min(a.ppfpag), max(a.ppfpag)
          into ld_ppago, ld_ffinr
          from fsd601 a
         where a.pgcod = pn_empa
           and a.ppmod = pn_moda
           and a.ppsuc = pn_suca
           and a.ppmda = pn_mdaa
           and a.pppap = pn_papa
           and a.ppcta = pn_ctaa
           and a.ppoper = pn_opea
           and a.ppsbop = pn_sboa
           and a.pptope = pn_topa
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        insert into aqpb435
          (aqpb435emp,
           aqpb435mod,
           aqpb435suc,
           aqpb435mda,
           aqpb435pap,
           aqpb435cta,
           aqpb435ope,
           aqpb435sbo,
           aqpb435top,
           aqpb435fecr,
           aqpb435tip,
           aqpb435est,
           aqpb435itcod,
           aqpb435itmod,
           aqpb435itsuc,
           aqpb435ittran,
           aqpb435itnrel,
           aqpb435itfcon,
           aqpb435ithor,
           aqpb435itucnf,
           aqpb435fecext,
           aqpb435aux01,
           aqpb435aux02,
           aqpb435tipfon,
           aqpb435fcomca,
           aqpb435fcompo,
           aqpb435fcommt,
           aqpb435mtofgr,
           aqpb435fitcod,
           aqpb435fitmod,
           aqpb435fitsuc,
           aqpb435fittra,
           aqpb435fitnre,
           aqpb435fitfco,
           aqpb435fithor,
           aqpb435fitucn,
           aqpb435fest,
           aqpb435petdoc,
           aqpb435pendoc,
           aqpb435penom,
           aqpb435nrcsap,
           aqpb435finicr,
           aqpb435ffpgra,
           aqpb435ffcr,
           aqpb435nrcuin,
           aqpb435nrpgra,
           aqpb435tasocr,
           aqpb435mntrpr,
           aqpb435ffcrpr,
           aqpb435fpp,
           aqpb435tscrpr,
           aqpb435frepro,
           aqpb435nupzot,
           aqpb435nmsgra)
        values
          (pn_emp,
           pn_mod,
           pn_suc,
           pn_mda,
           pn_pap,
           pn_cta,
           pn_ope,
           pn_sbo,
           pn_top,
           ld_fchsist,
           1, --tip por defecto 1
           'C', --est
           ln_pgcodt,
           ln_modt,
           ln_suct,
           ln_ttran,
           ln_relt,
           ld_itfcon, --itfcon
           lc_ithor, --ithor
           lc_ituser, --itucnf
           null, --fecext
           0, --aux01
           0, --aux02
           'FAETURISMO',
           ln_capital, --fcomca
           ln_porce, --fcompo
           ln_comision,
           0, --mtofgra
           0, --fitcod
           0, --fitmod
           0, --fitsuc
           0, --fittra
           0, --fitnre
           null, --fitfco
           '', --fithor
           '', --fitucn
           '', --fest
           ln_tdoc, --tdoc
           lc_ndoc,
           lc_ncliente, --nombre cliente
           '', --csap
           ld_fini,
           ld_fecN, --fpgra
           ld_ffin,
           ln_cuotas,
           ln_gracia,
           ln_tea,
           ln_montor, --mtnrpr
           ld_ffinr, --ffcrpr
           ld_ppago, --fpp
           ln_tasa, --tscrpr
           ld_fchsist, --frepro
           ln_cuotasa, --nupzot
           ln_dgracia / 30); --nmsgra
        commit;
      exception
        when others then
          null;
      end;
      begin
        -- Call the procedure
        pq_cr_rpgflujo_fondo_hs.sp_actualizacmr(v_pgcod  => pn_emp,
                                                v_scmod  => pn_mod,
                                                v_scsuc  => pn_suc,
                                                v_scmda  => pn_mda,
                                                v_scpap  => pn_pap,
                                                v_sccta  => pn_cta,
                                                v_scoper => pn_ope,
                                                v_scsbop => pn_sbo,
                                                v_sctope => pn_top,
                                                pgfape   => ld_fchsist, -- Fecha del sistema
                                                v_nombre => 'FAETURISMO'); -- Envias d texto `FAETURISMO¿
      exception
        when others then
          null;
      end;
    end if;
  end sp_cr_Inicio;
  ---------------------------------------------
  procedure sp_cr_validar_fecha(ln_inst in number, lc_rpta out varchar2) is
    ld_feclim  date;
    ld_fchsist date;
    ln_cuenta  number;
  begin
    begin
      select t9.xwfcuenta
        into ln_cuenta
        from xwf700 t9
       where t9.xwfprcins = ln_inst
         and t9.xwfcar3 <> '1'
         and rownum = 1;
    exception
      when others then
        null;
    end;
    begin
      select to_date(tp1desc, 'YYYYMMDD')
        into ld_feclim
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    begin
      select pgfape into ld_fchsist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
    if ld_fchsist > ld_feclim then
      lc_rpta := 'N';
    else
      lc_rpta := 'S';
    end if;
  end sp_cr_validar_fecha;
end pq_cr_repro_faeturismo;
/

