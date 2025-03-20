create or replace package pq_cr_control_mesacreditos is

  -- Author  : RMONTESR
  -- Created : 20/04/2021 16:22:14
  -- Purpose : paquete para politica informativa mesa de creditos
  function fn_cr_get_nombreregion(pn_region in number) return char;

  function fn_cr_get_etapa(pn_instancia in number) return char;

  procedure sp_cr_buscar_autorizaciones(pn_insta  in numeric,
                                        pd_Pgfape in date,
                                        pv_rpta   out varchar2);

  procedure sp_cr_carga_rdetalleexcep(pc_usuario  in varchar,
                                      pn_region   in number,
                                      pn_zona     in number,
                                      pn_sucursal in number,
                                      pc_dni      in varchar,
                                      pd_fecini   in date,
                                      pd_fecfin   in date);

end pq_cr_control_mesacreditos;
/

create or replace package body pq_cr_control_mesacreditos is

  function fn_cr_get_nombreregion(pn_region in number) return char is
    lc_region char(30);
  begin
    begin
      select trim(tb.tp1desc)
        into lc_region
        from fst198 tb
       where tb.Tp1cod = 1
         and tb.Tp1cod1 = 10872
         and tb.Tp1corr1 = 11
         and tb.tp1nro1 = pn_region
         and rownum <= 1;
    exception
      when others then
        lc_region := '';
    end;
    return lc_region;
  end fn_cr_get_nombreregion;
  -----------------------------------------------------------------------------------------------
  function fn_cr_get_etapa(pn_instancia in number) return char is
    lc_etapa char(30);
  begin
    begin
      select case
               when t1.wftaskcod = 3 THEN
                'Solicitud'
               when t1.wftaskcod = 7 then
                'Evaluacion'
               when t1.wftaskcod = 11 then
                'Aprobacion'
               when t1.wftaskcod = 55 then
                'Desembolso'
             end
        into lc_etapa
        from wfwrkitems t1
       where t1.wfinsprcid = pn_instancia
         and t1.wfitemstsact = 1
         and rownum <= 1;
    exception
      when others then
        lc_etapa := '';
    end;
    return lc_etapa;
  end fn_cr_get_etapa;

  -----------------------------------------------------------------------------------------------
  procedure sp_cr_buscar_autorizaciones(pn_insta  in numeric,
                                        pd_Pgfape in date,
                                        pv_rpta   out varchar2) is

    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1; -- ver si todos o solo el titular

    ln_cuenta       numeric;
    ln_pais_conyuge numeric;
    ln_tdoc_conyuge numeric;
    lc_ndoc_conyuge char(12);
    ln_contador     numeric;
  begin
    pv_rpta := 'N';
    begin
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;

    for i in integrantes(ln_cuenta) loop
      for inst_miembro in (select *
                             from sng001 t3
                            where t3.sng001pais = i.pepais
                              and t3.sng001tdoc = i.petdoc
                              and t3.sng001ndoc = i.pendoc) loop
        begin
          select count(*)
            into ln_contador
            from sng091 t4
           inner join sng065 t5
              on t4.sng091aut = t5.sng062aut
           inner join sng060 t8
              on t8.sng060pqt = t4.sng090pqt
           where t4.sng001inst = inst_miembro.sng001inst
             and t5.sng065res in ('A', 'R')
             and t8.sng060fap between add_months(pd_Pgfape, -6) and
                 pd_Pgfape
             and t4.sng091num in (select tp1nro1
                                    from fst198
                                   where tp1cod1 = 11003
                                     and tp1corr1 = 100);
        exception
          when others then
            ln_contador := 0;
        end;
        exit when ln_contador > 0;
      end loop;
      exit when ln_contador > 0;
      for conyuge in (select *
                        from fsr002 t1
                       where t1.pepais = i.pepais
                         and t1.petdoc = i.petdoc
                         and t1.pendoc = i.pendoc
                         and t1.rpccyg = 66) loop
        ln_pais_conyuge := conyuge.rppais;
        ln_tdoc_conyuge := conyuge.rptdoc;
        lc_ndoc_conyuge := conyuge.rpndoc;
        for inst_conyuge in (select *
                               from sng001 t2
                              where t2.sng001pais = conyuge.rppais
                                and t2.sng001tdoc = conyuge.rptdoc
                                and t2.sng001ndoc = conyuge.rpndoc) loop
          begin
            select count(*)
              into ln_contador
              from sng091 t6
             inner join sng065 t7
                on t6.sng091aut = t7.sng062aut
             inner join sng060 t9
                on t9.sng060pqt = t6.sng090pqt
             where t6.sng001inst = inst_conyuge.sng001inst
               and t7.sng065res in ('A', 'R')
               and t9.sng060fap between add_months(pd_Pgfape, -6) and
                   pd_Pgfape
               and t6.sng091num in (select tp1nro1
                                      from fst198
                                     where tp1cod1 = 11003
                                       and tp1corr1 = 100);
          exception
            when others then
              ln_contador := 0;
          end;
          exit when ln_contador > 0;
        end loop;
        exit when ln_contador > 0;
      end loop;
      exit when ln_contador > 0;
    end loop;
    if ln_contador > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
  end sp_cr_buscar_autorizaciones;

  -------------------------------------------------------------------------------------------
  procedure sp_cr_carga_rdetalleexcep(pc_usuario  in varchar,
                                      pn_region   in number,
                                      pn_zona     in number,
                                      pn_sucursal in number,
                                      pc_dni      in varchar,
                                      pd_fecini   in date,
                                      pd_fecfin   in date) is
    lc_region char(30);
   
  begin
    begin
      delete from aqpb374 x
       where x.aqpb374usr = rpad(trim(pc_usuario), 10, ' ');
      commit;
    end;
    begin
      lc_region := fn_cr_get_nombreregion(pn_region);
    exception
      when others then
        lc_region := '';
    end;
    
    begin
      insert into aqpb374
        (aqpb374usr,
         aqpb374inst,
         aqpb374aut,
         aqpb374ord,
         aqpb374pqt,
         aqpb374suc,
         aqpb374sucdes,
         aqpb374cta,
         aqpb374tdoc,
         aqpb374ndoc,
         aqpb374nomcli,
         aqpb374monto,
         aqpb374codan,
         aqpb374descan,
         aqpb374codaut,
         aqpb374descaut,
         aqpb374etap,
         aqpb374poli,
         aqpb374polinom,
         aqpb374obs,
         aqpb374fecaut,
         aqpb374horaaut,
         aqpb374fecorig,
         aqpb374horaorig,
         aqpb374est,
         aqpb374tonom,
         aqpb374region)

        select pc_usuario,
               t1.sng001inst,
               t1.sng091aut,
               t2.sng065ord,
               t1.sng090pqt,
               t2.sng065suc,
               ta.scnom,
               t4.sng001cta,
               t5.petdoc,
               t5.pendoc,
               trim(t6.pfape1) || ' ' || trim(t6.pfape2) || ' ' ||
               trim(t6.pfnom1) || ' ' || trim(t6.pfnom2),
               t7.xwfmonto1,
               t4.sng001ase,
               t9.ubnom,
               t2.sng065usr,
               t8.ubnom,
               fn_cr_get_etapa(t1.sng001inst), --etapa
               t1.sng091num,
               tc.pae90msg,
               trim(t2.sng065com),
               to_date(t2.sng065now, 'DD/MM/YYYY'),
               to_char(t2.sng065now, 'HH24:MI:SS'),
               to_date(t3.sng060now, 'DD/MM/YYYY'),
               to_char(t3.sng060now, 'HH24:MI:SS'),
               case
                 when t2.sng065res = 'A' THEN
                  'Aprobado'
                 when t2.sng065res = 'R' then
                  'Rechazado'
                 when t2.sng065res = 'P' then
                  'Pendiente'
               end,
               t10.tonom,
               lc_region
          from sng091 t1

         inner join sng065 t2
            on t1.sng091aut = t2.sng062aut
         inner join sng060 t3
            on t3.sng060pqt = t1.sng090pqt
         inner join sng001 t4
            on t4.sng001inst = t1.sng001inst
         inner join fsr008 t5
            on t5.pgcod = 1
           and t5.ctnro = t4.sng001cta
           and t5.cttfir = 'T'
         inner join fsd002 t6
            on t6.pfpais = t5.pepais
           and t6.pftdoc = t5.petdoc
           and t6.pfndoc = t5.pendoc
         inner join xwf700 t7
            on t7.xwfprcins = t4.sng001inst
           and t7.xwfcar3 = '1'
          left join fst746 t8
            on t8.ubuser = t2.sng065usr
          left join fst746 t9
            on t9.ubuser = t4.sng001ase
          left join fst004 t10
            on t10.modulo = t7.xwfmodulo
           and t10.totope = t7.xwftipope
          left join fst001 ta
            on ta.pgcod = 1
           and ta.sucurs = t2.sng065suc
          left join fpae90 tc
            on tc.pae90pol = t1.sng091num

         where t2.sng065res in ('A', 'R')
           and t3.sng060fap between pd_fecini and pd_fecfin
           and t1.sng091num in (select tp1nro1
                                  from fst198
                                 where tp1cod1 = 11003
                                   and tp1corr1 = 100)
           and (rpad(pc_dni,12) = rpad('0',12) or t5.pendoc = rpad(pc_dni,12))
           and (t2.sng065suc = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t2.sng065suc in
               (select oficod
                    from fst811 t11
                   where t11.pgcod = 1
                     and t11.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t2.sng065suc in
               (select oficod
                    from fst811 t12
                   where t12.pgcod = 1
                     and t12.regcod in
                         (select tp1nro2
                            from fst198 t13
                           where t13.tp1cod = 1
                             and t13.tp1cod1 = 10872
                             and t13.tp1corr1 = 11
                             and t13.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_rdetalleexcep;

end pq_cr_control_mesacreditos;
/

