create or replace package pq_cr_exposicion_sobend is

    procedure sp_cr_cuota_imp(p_in_pgcod in number,
                           p_in_sucur in number,
                           p_in_mda in number,
                           p_in_pap in number,
                           p_in_cta in number,
                           p_in_oper in number,
                           p_in_tope in number,
                           p_in_mod in number,
                           P_D_FECHA in date,
                           P_N_MONCUO out number);

    procedure sp_cr_cuota_exp(p_d_fectra in date,
                          p_c_tippas in varchar2,
                          p_n_monsal in number,
                          p_n_moncuo out number);

    procedure sp_cr_datos_evaluacion(p_n_pais in number,
                                     p_n_tipdoc in number,
                                     p_c_numdoc in varchar2,                                     
                                     p_n_tipcli in number,
                                     p_n_numeva in number,
                                     p_n_soles out number,
                                     p_n_dolares out number,
                                     p_n_egfsol out number,
                                     p_n_egfdol out number,
                                     p_n_patsol out number,
                                     p_n_patdol out number,
                                     p_n_patsol1 out number,
                                     p_n_patdol1 out number,
                                     p_n_vensol out number,
                                     p_n_vendol out number,
                                     p_n_resnsol out number,
                                     p_n_resndol out number);

    procedure sp_cr_calificacion_sbs(p_c_tipdoc in number,
                                    p_c_numdoc in varchar2,
                                    p_n_califi out number);

    procedure sp_cr_tipo_cliente_cmac(p_n_salcap3 in number,
                                      p_n_salcap5 in number,
                                      p_n_salcap2 in number,
                                      p_n_salcap7 in number,
                                      p_n_salcap4 in number,
                                      p_v_tipcli out varchar2);

    procedure sp_cr_tipo_credito_cmac(p_n_salcap3 in number,
                                      p_n_salcap5 in number,
                                      p_n_salcap2 in number,
                                      p_n_salcap7 in number,
                                      p_n_salcap4 in number,
                                      p_v_tipcre out varchar2);

    procedure sp_cr_nivel_sobend(p_n_ratdet in number,
                                 p_n_nument in number,
                                 p_n_calsbs in number,
                                 p_c_tippro in char,
                                 p_n_deutot in number,
                                 p_n_patrim in number,
                                 p_n_monmax in number,
                                 p_n_ingnet in number,
                                 p_c_tipsbs in char,
                                 p_c_sececo in char,
                                 p_n_subpeq in char,
                                 p_c_nivsob out char);

    procedure sp_cr_tipdoc_sbs(p_c_tipdoc in number,
                           p_c_numdoc in varchar2,
                           p_c_tdosbs out varchar2);

    procedure sp_cr_tipo_credito_sbs(p_c_tipdoc in varchar2,
                                           p_c_numdoc in varchar2,
                                           p_c_tippas in varchar2,
                                           p_c_tpcsbs out varchar2);

end pq_cr_exposicion_sobend;
/

create or replace package body pq_cr_exposicion_sobend is

  procedure sp_cr_cuota_imp(P_IN_PGCOD in Number,
                           P_IN_SUCUR in Number,
                           P_IN_MDA in Number,
                           P_IN_PAP in Number,
                           P_IN_CTA in Number,
                           P_IN_OPER in Number,
                           P_IN_TOPE in Number,
                           P_IN_MOD in Number,
                           P_D_FECHA in date,
                           P_N_MONCUO out Number) is
  ld_ppfpag date;
  ln_pppzo fsd601.pppzo%type;

  begin

      select min(c.ppfpag)
      into ld_ppfpag
      from fsd601 c
      left outer join fsd602 d on
      c.pgcod = d.pgcod
      and c.ppmod = d.ppmod
      and c.ppsuc = d.ppsuc
      and c.ppmda = d.ppmda
      and c.pppap = d.pppap
      and c.ppcta = d.ppcta
      and c.ppoper = d.ppoper
      and c.ppsbop = d.ppsbop
      and c.pptope = d.pptope
      and c.ppfpag = d.ppfpag
      where c.ppcta = P_IN_CTA
      and c.ppmod = P_IN_MOD
      and c.PGCOD = P_IN_PGCOD
      and c.PPSUC = P_IN_SUCUR
      and c.PPMDA = P_IN_MDA
      and c.PPPAP = P_IN_PAP
      and c.PPOPER = P_IN_OPER
      and c.PPTOPE = P_IN_TOPE
      and c.d601co = 'S'
      and ( d.pgcod is null or d.PP1Fech > P_D_FECHA );

      select ppcap + ppint + ppintmex + ppicap + ppiint
      into P_N_MONCUO
      from fsd601 c
      where c.ppcta = P_IN_CTA
      and c.ppmod = P_IN_MOD
      and c.PGCOD = P_IN_PGCOD
      and c.PPSUC = P_IN_SUCUR
      and c.PPMDA = P_IN_MDA
      and c.PPPAP = P_IN_PAP
      and c.PPOPER = P_IN_OPER
      and c.PPTOPE = P_IN_TOPE
      and c.d601co = 'S'
      and c.ppfpag = ld_ppfpag;

      select max(o.aoperiod)
      into ln_pppzo
      from fsd010 o
      where o.pgcod = P_IN_PGCOD
      and o.aosuc = P_IN_SUCUR
      and o.aomda = P_IN_MDA
      and o.aopap = P_IN_PAP
      and o.aocta = P_IN_CTA
      and o.aooper = P_IN_OPER
      and o.aotope = P_IN_TOPE
      and o.aomod = P_IN_MOD
      and o.aostat <> 99;

      if ln_pppzo is not null and ln_pppzo <> 0 then
         P_N_MONCUO := P_N_MONCUO/(ln_pppzo/30);
      end if;

      exception when others then
        P_N_MONCUO := null;

  end;

  procedure sp_cr_cuota_exp(p_d_fectra in date,
                          p_c_tippas in varchar2,
                          p_n_monsal in number,
                          p_n_moncuo out number) is

  begin

      p_n_moncuo := PQ_CR_JAQL157_SOBEND.fn_cr_cuota_sf(p_d_fectra,
                                                        p_c_tippas,
                                                        p_n_monsal);

  exception when others then
      p_n_moncuo := null;
  end;


  procedure sp_cr_datos_evaluacion(P_N_PAIS in number,
                                     P_N_TIPDOC in number,
                                     P_C_NUMDOC in varchar2,
                                     p_n_tipcli in number,
                                     p_n_numeva in number,
                                     p_n_soles out number,
                                     p_n_dolares out number,
                                     p_n_egfsol out number,
                                     p_n_egfdol out number,
                                     p_n_patsol out number,
                                     p_n_patdol out number,
                                     p_n_patsol1 out number,
                                     p_n_patdol1 out number,
                                     p_n_vensol out number,
                                     p_n_vendol out number,
                                     p_n_resnsol out number,
                                     p_n_resndol out number) IS

  begin

    -- Evaluación Financiera Pyme
    if p_n_tipcli = 13 then

      select
      SUM(nvl(n_brfsol, 0)) +
      SUM(nvl(n_brfsol1, 0))+
      SUM(nvl(n_brfsol2, 0))+
      SUM(nvl(n_brfsol3, 0)) n_soles,
      SUM(nvl(n_brfdol, 0)) +
      SUM(nvl(n_brfdol1, 0))+
      SUM(nvl(n_brfdol2, 0))+
      SUM(nvl(n_brfdol3, 0)) n_dolares,
      SUM(nvl(n_egfsol, 0)),
      SUM(nvl(n_egfdol, 0)),
      SUM(nvl(n_patsol, 0)),
      SUM(nvl(n_patdol, 0)),
      SUM(nvl(n_patsol1, 0)),
      SUM(nvl(n_patdol1, 0)),
      SUM(nvl(n_vensol, 0)),
      SUM(nvl(n_vendol, 0)),
      SUM(nvl(n_resnsol, 0)),
      SUM(nvl(n_resndol, 0))
      into
      p_n_soles,
      p_n_dolares,
      p_n_egfsol,
      p_n_egfdol,
      p_n_patsol,
      p_n_patdol,
      p_n_patsol1,
      p_n_patdol1,
      p_n_vensol,
      p_n_vendol,
      p_n_resnsol,
      p_n_resndol
      from (select distinct
      Case when g.sng026cod = 1 Then NVL(g.sng023mto, 0) end n_brfsol,
      Case when g.sng026cod = 501 Then NVL(g.sng023mto, 0) end n_brfdol,
      Case when g.sng026cod = 2 Then NVL(g.sng023mto, 0) end n_brfsol1,
      Case when g.sng026cod = 502 Then NVL(g.sng023mto, 0) end n_brfdol1,
      Case when g.sng026cod = 3 Then NVL(g.sng023mto, 0) end n_brfsol2,
      Case when g.sng026cod = 503 Then NVL(g.sng023mto, 0) end n_brfdol2,
      Case when g.sng026cod = 4 Then NVL(g.sng023mto, 0) end n_brfsol3,
      Case when g.sng026cod = 504 Then NVL(g.sng023mto, 0) end n_brfdol3,
      Case when g.sng026cod = 21 Then NVL(g.sng023mto, 0) end n_egfsol,
      Case when g.sng026cod = 521 Then NVL(g.sng023mto, 0) end n_egfdol,
      Case when g.sng026cod = 25 Then NVL(g.sng023mto, 0) end n_patsol1,
      Case when g.sng026cod = 525 Then NVL(g.sng023mto, 0) end n_patdol1,
      Case when g.sng026cod = 70 Then NVL(g.sng023mto, 0) end n_patsol,
      Case when g.sng026cod = 570 Then NVL(g.sng023mto, 0) end n_patdol,
      Case when g.sng026cod = 73 Then NVL(g.sng023mto, 0) end n_vensol,
      Case when g.sng026cod = 573 Then NVL(g.sng023mto, 0) end n_vendol,
      Case when g.sng026cod = 40 Then NVL(g.sng023mto, 0) end n_resnsol,
      Case when g.sng026cod = 540 Then NVL(g.sng023mto, 0) end n_resndol
      from sng023 g , sng021 h, xwf700 x
      where x.xwfprcins = h.sng021sol
      and g.sng021eval = h.sng021eval
      and h.sng021pdoc = P_N_PAIS
      and h.sng021tdoc = P_N_TIPDOC
      and trim(h.sng021ndoc) = P_C_NUMDOC
      and h.sng021eval = p_n_numeva);

    end if;

    -- Evaluación Financiera Consumo
    if p_n_tipcli = 14 then
      select
      SUM(nvl(n_brfsol, 0)) +
      SUM(nvl(n_brfsol1, 0))+
      SUM(nvl(n_brfsol2, 0))+
      SUM(nvl(n_brfsol3, 0)) n_soles,
      SUM(nvl(n_brfdol, 0)) +
      SUM(nvl(n_brfdol1, 0))+
      SUM(nvl(n_brfdol2, 0))+
      SUM(nvl(n_brfdol3, 0)) n_dolares,
      SUM(nvl(n_egfsol, 0)),
      SUM(nvl(n_egfdol, 0)),
      SUM(nvl(n_patsol, 0)),
      SUM(nvl(n_patdol, 0)),
      SUM(nvl(n_patsol1, 0)),
      SUM(nvl(n_patdol1, 0)),
      SUM(nvl(n_vensol, 0)),
      SUM(nvl(n_vendol, 0)),
      SUM(nvl(n_resnsol, 0)),
      SUM(nvl(n_resndol, 0))
      into
      p_n_soles,
      p_n_dolares,
      p_n_egfsol,
      p_n_egfdol,
      p_n_patsol,
      p_n_patdol,
      p_n_patsol1,
      p_n_patdol1,
      p_n_vensol,
      p_n_vendol,
      p_n_resnsol,
      p_n_resndol
      from (select distinct
      Case when g.sng026cod = 1 Then NVL(g.sng023mto, 0) end n_brfsol,
      Case when g.sng026cod = 501 Then NVL(g.sng023mto, 0) end n_brfdol,
      Case when g.sng026cod = 2 Then NVL(g.sng023mto, 0) end n_brfsol1,
      Case when g.sng026cod = 502 Then NVL(g.sng023mto, 0) end n_brfdol1,
      Case when g.sng026cod = 3 Then NVL(g.sng023mto, 0) end n_brfsol2,
      Case when g.sng026cod = 503 Then NVL(g.sng023mto, 0) end n_brfdol2,
      Case when g.sng026cod = 4 Then NVL(g.sng023mto, 0) end n_brfsol3,
      Case when g.sng026cod = 504 Then NVL(g.sng023mto, 0) end n_brfdol3,
      Case when g.sng026cod = 21 Then NVL(g.sng023mto, 0) end n_egfsol,
      Case when g.sng026cod = 521 Then NVL(g.sng023mto, 0) end n_egfdol,
      Case when g.sng026cod = 25 Then NVL(g.sng023mto, 0) end n_patsol1,
      Case when g.sng026cod = 525 Then NVL(g.sng023mto, 0) end n_patdol1,
      Case when g.sng026cod = 70 Then NVL(g.sng023mto, 0) end n_patsol,
      Case when g.sng026cod = 570 Then NVL(g.sng023mto, 0) end n_patdol,
      Case when g.sng026cod = 73 Then NVL(g.sng023mto, 0) end n_vensol,
      Case when g.sng026cod = 573 Then NVL(g.sng023mto, 0) end n_vendol,
      Case when g.sng026cod = 27 Then NVL(g.sng023mto, 0) end n_resnsol,
      Case when g.sng026cod = 527 Then NVL(g.sng023mto, 0) end n_resndol
      from sng023 g , sng021 h, xwf700 x
      where x.xwfprcins = h.sng021sol
      and g.sng021eval = h.sng021eval
      and h.sng021pdoc = P_N_PAIS
      and h.sng021tdoc = P_N_TIPDOC
      and trim(h.sng021ndoc) = P_C_NUMDOC
      and h.sng021eval = p_n_numeva);

    end If;

  exception
    when others then
    p_n_soles   := 0;
    p_n_dolares := 0;
    p_n_egfsol  := 0;
    p_n_egfdol  := 0;
    p_n_patsol  := 0;
    p_n_patdol  := 0;
    p_n_patsol1 := 0;
    p_n_patdol1 := 0;
    p_n_vensol  := 0;
    p_n_vendol  := 0;

  end;
  
  procedure sp_cr_calificacion_sbs(p_c_tipdoc in number,
                                   p_c_numdoc in varchar2,
                                   p_n_califi out number) is
  begin
       
    p_n_califi := PQ_CR_JAQL157_SOBEND.fn_cr_calificacion_sbs(p_c_tipdoc,
                                                              p_c_numdoc,
                                                              0);
  
  exception
    when others then
      p_n_califi := -1;
  end;

  procedure sp_cr_tipo_cliente_cmac(p_n_salcap3 in number,
                                      p_n_salcap5 in number,
                                      p_n_salcap2 in number,
                                      p_n_salcap7 in number,
                                      p_n_salcap4 in number,
                                      p_v_tipcli out varchar2) is
  begin
  
    p_v_tipcli := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_cliente_cmac(p_n_salcap3,
                                                               p_n_salcap5,
                                                               p_n_salcap2,
                                                               p_n_salcap7,
                                                               p_n_salcap4);
  
  exception
    when others then
      p_v_tipcli := -1;  
  end;
  
  procedure sp_cr_tipo_credito_cmac(p_n_salcap3 in number,
                                      p_n_salcap5 in number,
                                      p_n_salcap2 in number,
                                      p_n_salcap7 in number,
                                      p_n_salcap4 in number,
                                      p_v_tipcre out varchar2) is
  begin
  
    p_v_tipcre := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_credito_cmac(p_n_salcap3,
                                                               p_n_salcap5,
                                                               p_n_salcap2,
                                                               p_n_salcap7,
                                                               p_n_salcap4);
  
  exception
    when others then
      p_v_tipcre := -1;  
  end;  
  
  procedure sp_cr_nivel_sobend(p_n_ratdet in number,
                                 p_n_nument in number,
                                 p_n_calsbs in number,
                                 p_c_tippro in char,
                                 p_n_deutot in number,
                                 p_n_patrim in number,
                                 p_n_monmax in number,
                                 p_n_ingnet in number,
                                 p_c_tipsbs in char,
                                 p_c_sececo in char,
                                 p_n_subpeq in char,
                                 p_c_nivsob out char) is
  begin

    p_c_nivsob := PQ_CR_JAQL157_SOBEND.fn_cr_nivel_sobend(p_n_ratdet,
                                                             p_n_nument,
                                                             p_n_calsbs,
                                                             p_c_tippro,
                                                             p_n_deutot,
                                                             p_n_patrim,
                                                             p_n_monmax,
                                                             p_n_ingnet,
                                                             p_c_tipsbs,
                                                             p_c_sececo,
                                                             p_n_subpeq);

  exception
    when others then
      p_c_nivsob := '-';
  end;                               

  procedure sp_cr_tipdoc_sbs(p_c_tipdoc in number,
                           p_c_numdoc in varchar2,
                           p_c_tdosbs out varchar2) is
  begin
  
    p_c_tdosbs := PQ_CR_JAQL157_SOBEND.fn_cr_tipdoc_sbs(p_c_tipdoc,
                                                       p_c_numdoc);    
  
  exception
    when others then
      p_c_tdosbs := '-';  
  end;

  procedure sp_cr_tipo_credito_sbs(p_c_tipdoc in varchar2,
                                           p_c_numdoc in varchar2,
                                           p_c_tippas in varchar2,
                                           p_c_tpcsbs out varchar2) is
  begin
  
    p_c_tpcsbs := PQ_CR_JAQL157_SOBEND.fn_cr_tipo_credito_sbs(p_c_tipdoc,
                                           p_c_numdoc,
                                           p_c_tippas);  
  
  exception
    when others then
      p_c_tpcsbs := '-';
  end;
         
end pq_cr_exposicion_sobend;
/

