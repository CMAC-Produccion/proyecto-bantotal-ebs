create or replace package pq_cr_rpte_garantiascovid19 is

  -- Author  : RMONTESR
  -- Created : 19/02/2021 15:39:23
  -- Purpose : Reporte Garantias covid19
  function fn_get_nrocuotas(pn_cod in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number) return number;
  procedure sp_cr_carga_aqpb367(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date);

end pq_cr_rpte_garantiascovid19;
/

create or replace package body pq_cr_rpte_garantiascovid19 is
  -------------------------------------------------------------
  function fn_get_nrocuotas(pn_cod in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number) return number is
  
    ln_nrocuotas number;
  
  begin
  
    begin
    
      select count(*)
        into ln_nrocuotas
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat in ('T') ---- P: PARCIAL, T: TOTAL, solo considerar pagos totales  01.02.2021 jrodriguej
         and (t.d602mo, t.d602tr) not in
             (select x.tpnro, x.tpimp
                from fst098 x
               where x.pgcod=1 
               and x.tpcod=7749 
               and x.tpnro>0)
         and t.d602co = 'S';
    
    exception
      when others then
        ln_nrocuotas := 0;
    end;
  
    return ln_nrocuotas;
  
  end fn_get_nrocuotas;
  ------------------------------------------------------------
  procedure sp_cr_carga_aqpb367(pc_usuario  in varchar,
                                pn_region   in number,
                                pn_zona     in number,
                                pn_sucursal in number,
                                pd_fecini   in date,
                                pd_fecfin   in date) is
  begin
    begin
      delete from aqpb367 x where x.aqpb367usr = rpad(trim(pc_usuario),10,' ');
      commit;
    end;
    begin
      insert into aqpb367
        (AQPB367usr,
         AQPB367emp,
         AQPB367mod,
         AQPB367suc,
         AQPB367mda,
         AQPB367pap,
         AQPB367cta,
         AQPB367ope,
         AQPB367sbo,
         AQPB367top,
         AQPB367empg,
         AQPB367modg,
         AQPB367sucg,
         AQPB367mdag,
         AQPB367papg,
         AQPB367ctag,
         AQPB367opeg,
         AQPB367sbog,
         AQPB367topg,
         AQPB367estg,
         AQPB367estgde,
         AQPB367faltg,
         AQPB367mtoog,
         AQPB367mtoag,
         AQPB367sdocap,
         AQPB367estc,
         AQPB367estcde,
         AQPB367nrocp,
         AQPB367itcod,
         AQPB367itmod,
         AQPB367itsuc,
         AQPB367ittran,
         AQPB367itnrel,
         AQPB367itfcon,
         AQPB367ithor,
         AQPB367itucnf,
         AQPB367usuact,
         AQPB367fecact,
         aqpb367sucdes,
         aqpb367sucgdes)
      
        select pc_usuario,
               t1.aqpa841emp,
               t1.aqpa841mod,
               t1.aqpa841suc,
               t1.aqpa841mda,
               t1.aqpa841pap,
               t1.aqpa841cta,
               t1.aqpa841ope,
               t1.aqpa841sbo,
               t1.aqpa841top,
               t1.aqpa841empg,
               t1.aqpa841modg,
               t1.aqpa841sucg,
               t1.aqpa841mdag,
               t1.aqpa841papg,
               t1.aqpa841ctag,
               t1.aqpa841opeg,
               t1.aqpa841sbog,
               t1.aqpa841topg,
               t2.scstat,
               t4.cenom,
               t1.aqpa841itfcon,
               t1.aqpa841mtoa,
               t2.scsdo,
               case when t3.scsdo<0 then t3.scsdo*-1 else t3.scsdo end,
               t3.scstat,
               t5.cenom,
               fn_get_nrocuotas(t1.aqpa841emp,
                                t1.aqpa841mod,
                                t1.aqpa841suc,
                                t1.aqpa841mda,
                                t1.aqpa841pap,
                                t1.aqpa841cta,
                                t1.aqpa841ope,
                                t1.aqpa841sbo,
                                t1.aqpa841top), --nro cuotas pagadas
               t1.aqpa841itcod,
               t1.aqpa841itmod,
               t1.aqpa841itsuc,
               t1.aqpa841ittran,
               t1.aqpa841itnrel,
               t1.aqpa841itfcon,
               t1.aqpa841ithor,
               t1.aqpa841itucnf,
               t1.aqpa841usuact,
               t1.aqpa841fecact,
               ta.scnom,
               tb.scnom
          from aqpa841 t1
         inner join fsd011 t2
            on t1.aqpa841empg = t2.pgcod
           and t1.AQPA841SUCG = t2.scsuc
           and t1.AQPA841MODG = t2.scmod
           and t1.AQPA841MDAG = t2.scmda
           and t1.AQPA841PAPG = t2.scpap
           and t1.AQPA841CTAG = t2.sccta
           and t1.AQPA841OPEG = t2.scoper
           and t1.AQPA841SBOG = t2.scsbop
           and t1.AQPA841TOPG = t2.sctope
         inner join fsd011 t3
            on t1.aqpa841emp = t3.pgcod
           and t1.AQPA841SUC = t3.scsuc
           and t1.AQPA841MOD = t3.scmod
           and t1.AQPA841MDA = t3.scmda
           and t1.AQPA841PAP = t3.scpap
           and t1.AQPA841CTA = t3.sccta
           and t1.AQPA841OPE = t3.scoper
           and t1.AQPA841SBO = t3.scsbop
           and t1.AQPA841TOP = t3.sctope
          left join fst026 t4
            on t4.cecod = t2.scstat
          left join fst026 t5
            on t5.cecod = t3.scstat
          left join fst001 ta
            on ta.pgcod = t1.aqpa841emp
           and ta.sucurs = t1.aqpa841suc
          left join fst001 tb
            on tb.pgcod = t1.aqpa841empg
           and tb.sucurs = t1.aqpa841sucg
         where t2.scstat <> 99
           and t1.aqpa841itfcon between pd_fecini and pd_fecfin
           and t3.scmod in (select modulo from fst111 where dscod = 50)
           and (t1.aqpa841sucg = pn_sucursal or
               (pn_sucursal = 0 and pn_zona <> 0 and
               t1.aqpa841sucg in
               (select oficod
                    from fst811 t6
                   where t6.pgcod = 1
                     and t6.regcod = pn_zona)) or
               (pn_sucursal = 0 and pn_zona = 0 and
               t1.aqpa841sucg in
               (select oficod
                    from fst811 t7
                   where t7.pgcod = 1
                     and t7.regcod in
                         (select tp1nro2
                            from fst198 t8
                           where t8.tp1cod = 1
                             and t8.tp1cod1 = 10872
                             and t8.tp1corr1 = 11
                             and t8.tp1nro1 = pn_region))));
      commit;
    end;
  end sp_cr_carga_aqpb367;

end pq_cr_rpte_garantiascovid19;
/

