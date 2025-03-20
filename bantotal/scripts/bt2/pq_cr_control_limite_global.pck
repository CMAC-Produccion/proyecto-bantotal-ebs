create or replace package pq_cr_control_limite_global is

  -- Author  : RMONTESR
  -- Created : 3/09/2021 16:51:18
  -- Purpose : procedimiento para control de limite global

  procedure sp_cr_guardar_patr(pn_pgcod   in number,
                               pn_usuario in varchar2,
                               pn_fecha   in date,
                               pn_monto   in number,
                               pn_corr    out number,
                               pn_flag    out varchar2);

  procedure sp_cr_guardar_prc(pn_pgcod   in number,
                              pn_usuario in varchar2,
                              pn_fecha   in date,
                              pn_prc     in number,
                              pn_corr    out number,
                              pn_flag    out varchar2);
                              
  procedure sp_cr_guardar_sdotf(pn_pgcod   in number,
                              pn_usuario in varchar2,
                              pn_fecha   in date,
                              pn_sdo     in number,
                              pn_corr    out number,
                              pn_flag    out varchar2);

  procedure sp_cr_saldo_trab(pn_insta in numeric, pv_rpta out varchar2);

end pq_cr_control_limite_global;
/

create or replace package body pq_cr_control_limite_global is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_guardar_patr(pn_pgcod   in number,
                               pn_usuario in varchar2,
                               pn_fecha   in date,
                               pn_monto   in number,
                               pn_corr    out number,
                               pn_flag    out varchar2) is

  begin

    pn_flag := 'N';
    begin

      pn_flag := 'S';

      update aqpb387 set aqpb387est = 'N' where aqpb387est = 'S';
      commit;

      --- Obtener el correlativo
      select nvl(max(t.aqpb387cor), 0) + 1 into pn_corr from aqpb387 t;

      insert into aqpb387
        (aqpb387cod,
         aqpb387fec,
         aqpb387cor,
         aqpb387mon,
         aqpb387est,
         aqpb387usr,
         aqpb387fcr,
         aqpb387hcr)
      values
        (pn_pgcod,
         pn_fecha,
         pn_corr,
         pn_monto,
         'S', -- actual
         rpad(pn_usuario, 10),
         to_char(sysdate, 'DD/MM/YYYY'),
         to_char(sysdate, 'HH24:MI:SS'));
      commit;

    end;

  end sp_cr_guardar_patr;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_guardar_prc(pn_pgcod   in number,
                              pn_usuario in varchar2,
                              pn_fecha   in date,
                              pn_prc     in number,
                              pn_corr    out number,
                              pn_flag    out varchar2) is

  begin

    pn_flag := 'N';
    begin

      pn_flag := 'S';

      update aqpb387a set aqpb387aest = 'N' where aqpb387aest = 'S';
      commit;

      --- Obtener el correlativo
      select nvl(max(t.aqpb387acor), 0) + 1 into pn_corr from aqpb387a t;

      insert into aqpb387a
        (aqpb387acod,
         aqpb387afec,
         aqpb387acor,
         aqpb387aprc,
         aqpb387aest,
         aqpb387ausr,
         aqpb387afcr,
         aqpb387ahcr)
      values
        (pn_pgcod,
         pn_fecha,
         pn_corr,
         pn_prc,
         'S', -- actual
         rpad(pn_usuario, 10),
         to_char(sysdate, 'DD/MM/YYYY'),
         to_char(sysdate, 'HH24:MI:SS'));
      commit;

    end;

  end sp_cr_guardar_prc;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_guardar_sdotf(pn_pgcod   in number,
                              pn_usuario in varchar2,
                              pn_fecha   in date,
                              pn_sdo     in number,
                              pn_corr    out number,
                              pn_flag    out varchar2) is

  begin

    pn_flag := 'N';
    begin

      pn_flag := 'S';

      update aqpb387b set aqpb387best = 'N' where aqpb387best = 'S';
      commit;

      --- Obtener el correlativo
      select nvl(max(t.aqpb387bcor), 0) + 1 into pn_corr from aqpb387b t;

      insert into aqpb387b
        (aqpb387bcod,
         aqpb387bfec,
         aqpb387bcor,
         aqpb387bsdotf,
         aqpb387best,
         aqpb387busr,
         aqpb387bfcr,
         aqpb387bhcr)
      values
        (pn_pgcod,
         pn_fecha,
         pn_corr,
         pn_sdo,
         'S', -- actual
         rpad(pn_usuario, 10),
         to_char(sysdate, 'DD/MM/YYYY'),
         to_char(sysdate, 'HH24:MI:SS'));
      commit;

    end;

  end sp_cr_guardar_sdotf;
  -------------------------------------------------------------------------------------
  procedure sp_cr_saldo_trab(pn_insta in numeric, pv_rpta out varchar2) is
    saldo_actual     number;
    saldo_credi_t    number;
    saldo_envuelo_t  number;
    saldo_credi_f    number;
    saldo_envuelo_f  number;
    patrimonio_efec  number;
    porcentaje_patri number;
    es_traba         number;
  begin
    saldo_actual     := 0;
    patrimonio_efec  := 0;
    porcentaje_patri := 0;
    begin
      select count(*)
        into es_traba
        from sng001 r
       inner join fsd002 m
          on m.pfpais = r.sng001pais
         and m.pftdoc = r.sng001tdoc
         and m.pfndoc = r.sng001ndoc
       where r.sng001inst = pn_insta
         and m.pfebco = 'S';
    exception
      when others then
        es_traba := 0;
    end;
    if es_traba > 0 then
      begin
        select t1.aqpb387mon
          into patrimonio_efec
          from aqpb387 t1
         where t1.aqpb387cod = 1
           and t1.aqpb387est = 'S';
      exception
        when others then
          patrimonio_efec := 0;
      end;
      begin
        select t1.aqpb387aprc
          into porcentaje_patri
          from aqpb387a t1
         where t1.aqpb387acod = 1
           and t1.aqpb387aest = 'S';
      exception
        when others then
          porcentaje_patri := 0;
      end;
      begin
        select t1.aqpb387bsdotf
          into saldo_credi_t
          from aqpb387b t1
         where t1.aqpb387bcod = 1
           and t1.aqpb387best = 'S';
      exception
        when others then
          saldo_credi_t := 0;
      end;
      /*begin
        select sum(scsdo)
          into saldo_credi_t
          from fsd011 a
         where a.pgcod = 1
           and a.scstat <> 99
           and a.sccta in (select ta.ctnro
                             from fsr008 ta
                            where (ta.pepais, ta.petdoc, ta.pendoc) in
                                  (select tb.pfpais, tb.pftdoc, tb.pfndoc
                                     from fsd002 tb
                                    where tb.pfebco = 'S')
                            union all select tc.ctnro
                  from fsr008 tc
                 where (tc.pepais, tc.petdoc, tc.pendoc) in
                       (select td.rppais, td.rptdoc, td.rpndoc
                          from fsr002 td
                         where (td.pepais, td.petdoc, td.pendoc) in
                               (select te.pfpais, te.pftdoc, te.pfndoc
                                  from fsd002 te
                                 where te.pfebco = 'S')
                           and td.rpccyg in (63, 66, 91, 68, 69, 70, 71, 75)))
           and (a.scmod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 33, 200)) or
               a.scmod = 117);
      exception
        when others then
          saldo_credi_t := 0;
      end;*/
      /*begin
        select sum(scsdo)
          into saldo_credi_f
          from fsd011 a
         where a.pgcod = 1
           and a.scstat <> 99
           and a.sccta in
               (select tc.ctnro
                  from fsr008 tc
                 where (tc.pepais, tc.petdoc, tc.pendoc) in
                       (select td.rppais, td.rptdoc, td.rpndoc
                          from fsr002 td
                         where (td.pepais, td.petdoc, td.pendoc) in
                               (select te.pfpais, te.pftdoc, te.pfndoc
                                  from fsd002 te
                                 where te.pfebco = 'S')
                           and td.rpccyg in (63, 66, 91, 68, 69, 70, 71, 75)))
           and (a.scmod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 33, 200)) or
               a.scmod = 117);
      exception
        when others then
          saldo_credi_f := 0;
      end;*/
      begin
        select sum(x.xwfmonto1)
          into saldo_envuelo_t
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfcuenta in
               (select ta.ctnro
                  from fsr008 ta
                 where (ta.pepais, ta.petdoc, ta.pendoc) in
                       (select tb.pfpais, tb.pftdoc, tb.pfndoc
                          from fsd002 tb
                         where tb.pfebco = 'S')
                         union all
                         select ta.ctnro
                  from fsr008 ta
                 where (ta.pepais, ta.petdoc, ta.pendoc) in
                       (select td.rppais, td.rptdoc, td.rpndoc
                          from fsr002 td
                         where (td.pepais, td.petdoc, td.pendoc) in
                               (select te.pfpais, te.pftdoc, te.pfndoc
                                  from fsd002 te
                                 where te.pfebco = 'S')
                           and td.rpccyg in (63, 66, 91, 68, 69, 70, 71, 75)))
           and x.xwfcar3 = '1'
           and (x.xwfmodulo in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (29, 33, 200)) or
               x.xwfmodulo = 117)
           and x.XWFPRCINS in
               (select wfinsprcid
                  from wfwrkitems wf
                 where wf.wfinsprcid = x.xwfprcins
                   and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                   and wf.wfiteminit =
                       (select max(wfiteminit)
                          from wfwrkitems w
                         where w.wfinsprcid = x.xwfprcins
                           and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                           and w.wfitemstsact = 1
                           --and wftaskcod = 11
                           and w.wfiteminit >=
                               to_date('2013.07.01', 'yyyy.mm.dd'))
                   and wftaskcod = 11
                   and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'));
      exception
        when others then
          saldo_envuelo_t := 0;
      end;
      /*begin
        select sum(x.xwfmonto1)
          into saldo_envuelo_f
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfcuenta in
               (select ta.ctnro
                  from fsr008 ta
                 where (ta.pepais, ta.petdoc, ta.pendoc) in
                       (select td.rppais, td.rptdoc, td.rpndoc
                          from fsr002 td
                         where (td.pepais, td.petdoc, td.pendoc) in
                               (select te.pfpais, te.pftdoc, te.pfndoc
                                  from fsd002 te
                                 where te.pfebco = 'S')
                           and td.rpccyg in (63, 66, 91, 68, 69, 70, 71, 75)))
           and x.xwfcar3 = '1'
           and (x.xwfmodulo in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (29, 33, 200)) or
               x.xwfmodulo = 117)
           and x.XWFPRCINS in
               (select wfinsprcid
                  from wfwrkitems wf
                 where wf.wfinsprcid = x.xwfprcins
                   and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                   and wf.wfiteminit =
                       (select max(wfiteminit)
                          from wfwrkitems w
                         where w.wfinsprcid = x.xwfprcins
                           and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                           and w.wfitemstsact = 1
                           --and wftaskcod = 11
                           and w.wfiteminit >=
                               to_date('2013.07.01', 'yyyy.mm.dd'))
                   and wftaskcod = 11
                   and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'));
      exception
        when others then
          saldo_envuelo_f := 0;
      end;*/
      --saldo_actual := saldo_credi_t*-1 +  saldo_envuelo_t;
      saldo_actual := saldo_credi_t +  saldo_envuelo_t;

      if saldo_actual > patrimonio_efec * porcentaje_patri / 100 then
        pv_rpta := 'S';
      else
        pv_rpta := 'N';
      end if;
    else
      pv_rpta := 'Z';
    end if;
    begin
       insert into aqpb387h
        (aqpb387hfec,
        aqpb387hinst,
        aqpb387hprc,
        aqpb387hpatef,
        aqpb387hprcpat,
        aqpb387hcred,
        aqpb387hcredvue,
        aqpb387hcredtot,
        aqpb387husr,
        aqpb387hfcr,
        aqpb387hhcr)
      values
        (sysdate,
         pn_insta,
         porcentaje_patri,
         patrimonio_efec,
         patrimonio_efec * porcentaje_patri / 100,
         saldo_credi_t,
         saldo_envuelo_t,
         saldo_actual,
         pv_rpta,
         to_char(sysdate, 'DD/MM/YYYY'),
         to_char(sysdate, 'HH24:MI:SS'));
      commit;
    end;
  end sp_cr_saldo_trab;

end pq_cr_control_limite_global;
/

