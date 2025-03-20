create or replace package PQ_CR_CUOTAMORA_COND is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CUOTAMORA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2016.10.12
  -- Autor de Creación          : ABERNEDO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  type detalle_cuota_rec is record(
    n_emp    number(3),
    n_mod    number(3),
    n_suc    number(3),
    n_mda    number(4),
    n_pap    number(4),
    n_cta    number(9),
    n_ope    number(9),
    n_sbo    number(3),
    n_top    number(3),
    n_cuota  number(3),
    d_fecuo  date,
    n_capit  number(17, 2),
    n_inter  number(17, 2),
    n_segur  number(17, 2),
    n_icv    number(17, 2),
    n_intmor number(17, 2),
    n_monto  number(17, 2),
    n_diatr  number(5),
    n_cuot   number(5),
    d_feult  date,
    d_fvto   date);
  type detalle_cuota_cur is REF CURSOR return detalle_cuota_rec;
  Function BT_Tasa_Interes(P_Emp       in number,
                           P_Modulo    in number,
                           P_Cod_Age   in number,
                           P_Moneda    in number,
                           p_Papel     in number,
                           P_Cuenta    in number,
                           P_Operacion in number,
                           P_SubTipo   in number,
                           P_Tipo      in number) return number;
  Function BT_Tasa_Mora(P_Emp       in number,
                        P_Modulo    in number,
                        P_Cod_Age   in number,
                        P_Moneda    in number,
                        p_Papel     in number,
                        P_Cuenta    in number,
                        P_Operacion in number,
                        P_SubTipo   in number,
                        P_Tipo      in number) return number;
  Function Fn_DetalleCuota(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_d602cd in number,
                           pn_d602mo in number,
                           pn_d602su in number,
                           pn_d602tr in number,
                           pn_d602re in number,
                           pd_fecpro in date)
    return PQ_CR_CUOTAMORA_COND.detalle_cuota_cur;

  Function fn_monto_capital(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number,
                            pd_fec in date,
                            pn_cap in number,
                            pn_int in number) return number;

  Function fn_monto_inter(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pn_cap in number,
                          pn_int in number) return number;

  Function fn_monto_seguro(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fec in date,
                           pn_cap in number,
                           pn_int in number) return number;

  Function fn_monto_icv(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pn_cap    in number,
                        pn_int    in number,
                        pd_fecpro in date) return number;

  Function fn_monto_intmor(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           pn_cap    in number,
                           pn_int    in number,
                           pd_fecpro in date) return number;

  Function fn_monto_cuota(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fec    in date,
                          pn_cap    in number,
                          pn_int    in number,
                          pd_fecpro in date) return number;

  Procedure Sp_PagoAdelantado(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pd_fec  in date,
                              pn_tint in number, --mod@abr 20171011
                              pn_tmor in number, --mod@abr 20171011
                              --pd_fecpro in date, --mod@abr 20171011
                              pn_capIN   in number, --mod@abr 20171011
                              pn_intIN   in number, --mod@abr 20171011 
                              pn_cap     out number,
                              pn_int     out number,
                              pn_segT    out number,
                              pn_morT    out number,
                              pn_icvT    out number,
                              pd_fecpago out date);

  Procedure Fn_cr_MismoDia(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_num  in number,
                           pd_fec  in date,
                           pc_flgD out char,
                           pd_fecP out date);

  Procedure Sp_cr_CalculoParciales(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecP   in date, --fecha de vcto de cuota
                                   pd_fec    in date, -- fecha de pago de la cuota
                                   pn_tint   in number, -- tasa de icv 
                                   pn_tmor   in number, -- tasa moratoria
                                   pn_dia    in number, --dias de atraso
                                   pn_cap    in number, --capital de la cuota
                                   pn_int    in number, --interes de la cuota
                                   pn_capP   in number, --capital pagado
                                   pn_intP   in number, --interes pagado
                                   pn_icvA   in number, --icv que debe
                                   pn_morA   in number, --mora que debe
                                   ln_icvDif out number,
                                   ln_morDif out number);
end PQ_CR_CUOTAMORA_COND;
/

create or replace package body PQ_CR_CUOTAMORA_COND is

  Function BT_Tasa_Interes(P_Emp       in number,
                           P_Modulo    in number,
                           P_Cod_Age   in number,
                           P_Moneda    in number,
                           p_Papel     in number,
                           P_Cuenta    in number,
                           P_Operacion in number,
                           P_SubTipo   in number,
                           P_Tipo      in number) return number is
    -- *****************************************************************
    -- Nombre                     : BT_Tasa_Interes
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
  
    pn_Tasa_Interes fsd012.evtasa%type;
  begin
  
    begin
      select nvl(d_012.evtasa, 0)
        into pn_Tasa_Interes
        from fsd012 d_012
       where d_012.pgcod = P_Emp
         and d_012.aomod = P_Modulo
         and d_012.aosuc = P_Cod_Age
         and d_012.aomda = P_Moneda
         and d_012.aopap = p_Papel
         and d_012.aocta = P_Cuenta
         and d_012.aooper = P_Operacion
         and d_012.aosbop = P_SubTipo
         and d_012.aotope = P_Tipo
         and d_012.evtipo = 3
         and d_012.evcorr = (select max(d_012a.evcorr)
                               from fsd012 d_012a
                              where d_012a.pgcod = P_Emp
                                and d_012a.aomod = P_Modulo
                                and d_012a.aosuc = P_Cod_Age
                                and d_012a.aomda = P_Moneda
                                and d_012a.aopap = p_Papel
                                and d_012a.aocta = P_Cuenta
                                and d_012a.aooper = P_Operacion
                                and d_012a.aosbop = P_SubTipo
                                and d_012a.aotope = P_Tipo
                                and d_012a.evtipo = 3
                                and d_012a.d012co = 'S')
         and d_012.d012co = 'S';
    exception
      when no_data_found then
        pn_Tasa_Interes := -1;
    end;
    if pn_Tasa_Interes = -1 then
      begin
        select nvl(d_010.aotasa, 0)
          into pn_Tasa_Interes
          from fsd010 d_010
         where d_010.pgcod = P_Emp
           and d_010.aomod = P_Modulo
           and d_010.aosuc = P_Cod_Age
           and d_010.aomda = P_Moneda
           and d_010.aopap = p_Papel
           and d_010.aocta = P_Cuenta
           and d_010.aooper = P_Operacion
           and d_010.aosbop = P_SubTipo
           and d_010.aotope = P_Tipo
           and d_010.aostat <> 99;
      exception
        when no_data_found then
          pn_Tasa_Interes := -1;
      end;
    end if;
  
    if pn_Tasa_Interes = -1 then
      begin
        select nvl(d_010.aotasa, 0)
          into pn_Tasa_Interes
          from fsd010 d_010
         where d_010.pgcod = P_Emp
           and d_010.aomod = P_Modulo
           and d_010.aosuc = P_Cod_Age
           and d_010.aomda = P_Moneda
           and d_010.aopap = p_Papel
           and d_010.aocta = P_Cuenta
           and d_010.aooper = P_Operacion
           and d_010.aosbop = P_SubTipo
           and d_010.aotope = P_Tipo
        --and d_010.aostat <> 99
        ;
      exception
        when no_data_found then
          pn_Tasa_Interes := -1;
      end;
    end if;
  
    if pn_Tasa_Interes = -1 then
      pn_Tasa_Interes := 0;
    end if;
    return pn_Tasa_Interes;
  end BT_Tasa_Interes;

  Function BT_Tasa_Mora(P_Emp       in number,
                        P_Modulo    in number,
                        P_Cod_Age   in number,
                        P_Moneda    in number,
                        p_Papel     in number,
                        P_Cuenta    in number,
                        P_Operacion in number,
                        P_SubTipo   in number,
                        P_Tipo      in number) return number is
    -- *****************************************************************
    -- Nombre                     : BT_Tasa_Mora
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    pn_Tasa_Mora fsd012.evtasa%type;
  begin
  
    begin
      select nvl(d_012.evtasa, 0)
        into pn_Tasa_Mora
        from fsd012 d_012
       where d_012.pgcod = P_Emp
         and d_012.aomod = P_Modulo
         and d_012.aosuc = P_Cod_Age
         and d_012.aomda = P_Moneda
         and d_012.aopap = p_Papel
         and d_012.aocta = P_Cuenta
         and d_012.aooper = P_Operacion
         and d_012.aosbop = P_SubTipo
         and d_012.aotope = P_Tipo
         and d_012.evtipo = 4
         and d_012.evcorr = (select max(d_012a.evcorr)
                               from fsd012 d_012a
                              where d_012a.pgcod = P_Emp
                                and d_012a.aomod = P_Modulo
                                and d_012a.aosuc = P_Cod_Age
                                and d_012a.aomda = P_Moneda
                                and d_012a.aopap = p_Papel
                                and d_012a.aocta = P_Cuenta
                                and d_012a.aooper = P_Operacion
                                and d_012a.aosbop = P_SubTipo
                                and d_012a.aotope = P_Tipo
                                and d_012a.evtipo = 4
                                and d_012a.d012co = 'S')
         and d_012.d012co = 'S';
    exception
      when no_data_found then
        pn_Tasa_Mora := -1;
    end;
    if pn_Tasa_Mora = -1 then
      begin
        select nvl(d_010.aotmor, 0)
          into pn_Tasa_Mora
          from fsd010 d_010
         where d_010.pgcod = P_Emp
           and d_010.aomod = P_Modulo
           and d_010.aosuc = P_Cod_Age
           and d_010.aomda = P_Moneda
           and d_010.aopap = p_Papel
           and d_010.aocta = P_Cuenta
           and d_010.aooper = P_Operacion
           and d_010.aosbop = P_SubTipo
           and d_010.aotope = P_Tipo
           and d_010.aostat <> 99;
      exception
        when no_data_found then
          pn_Tasa_Mora := -1;
      end;
    end if;
  
    if pn_Tasa_Mora = -1 then
      begin
        select nvl(d_010.aotmor, 0)
          into pn_Tasa_Mora
          from fsd010 d_010
         where d_010.pgcod = P_Emp
           and d_010.aomod = P_Modulo
           and d_010.aosuc = P_Cod_Age
           and d_010.aomda = P_Moneda
           and d_010.aopap = p_Papel
           and d_010.aocta = P_Cuenta
           and d_010.aooper = P_Operacion
           and d_010.aosbop = P_SubTipo
           and d_010.aotope = P_Tipo
        --and d_010.aostat <> 99
        ;
      exception
        when no_data_found then
          pn_Tasa_Mora := -1;
      end;
    end if;
  
    if pn_Tasa_Mora = -1 then
      pn_Tasa_Mora := 0;
    end if;
    return pn_Tasa_Mora;
  end BT_Tasa_Mora;

  Function Fn_DetalleCuota(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_d602cd in number,
                           pn_d602mo in number,
                           pn_d602su in number,
                           pn_d602tr in number,
                           pn_d602re in number,
                           pd_fecpro in date)
    return PQ_CR_CUOTAMORA_COND.detalle_cuota_cur is
    -- *****************************************************************
    -- Nombre                     : Fn_DetalleCuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    curref PQ_CR_CUOTAMORA_COND.detalle_cuota_cur;
  
  begin
  
    open curref for
    
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             (select count(*)
                from fsd601 aa
               where aa.pgcod = a.pgcod
                 and aa.ppmod = a.ppmod
                 and aa.ppsuc = a.ppsuc
                 and aa.ppmda = a.ppmda
                 and aa.pppap = a.pppap
                 and aa.ppcta = a.ppcta
                 and aa.ppoper = a.ppoper
                 and aa.ppsbop = a.ppsbop
                 and aa.pptope = a.pptope
                 and aa.d601co = 'S'
                 and aa.ppfpag <= a.ppfpag),
             a.ppfpag,
             PQ_CR_CUOTAMORA_COND.fn_monto_capital(a.pgcod,
                                                   a.ppmod,
                                                   a.ppsuc,
                                                   a.ppmda,
                                                   a.pppap,
                                                   a.ppcta,
                                                   a.ppoper,
                                                   a.ppsbop,
                                                   a.pptope,
                                                   a.ppfpag,
                                                   a.ppcap,
                                                   a.ppint),
             
             PQ_CR_CUOTAMORA_COND.fn_monto_inter(a.pgcod,
                                                 a.ppmod,
                                                 a.ppsuc,
                                                 a.ppmda,
                                                 a.pppap,
                                                 a.ppcta,
                                                 a.ppoper,
                                                 a.ppsbop,
                                                 a.pptope,
                                                 a.ppfpag,
                                                 a.ppcap,
                                                 a.ppint),
             
             PQ_CR_CUOTAMORA_COND.fn_monto_seguro(a.pgcod,
                                                  a.ppmod,
                                                  a.ppsuc,
                                                  a.ppmda,
                                                  a.pppap,
                                                  a.ppcta,
                                                  a.ppoper,
                                                  a.ppsbop,
                                                  a.pptope,
                                                  a.ppfpag,
                                                  a.ppcap,
                                                  a.ppint),
             
             PQ_CR_CUOTAMORA_COND.fn_monto_icv(a.pgcod,
                                               a.ppmod,
                                               a.ppsuc,
                                               a.ppmda,
                                               a.pppap,
                                               a.ppcta,
                                               a.ppoper,
                                               a.ppsbop,
                                               a.pptope,
                                               a.ppfpag,
                                               a.ppcap,
                                               a.ppint,
                                               pd_fecpro),
             
             PQ_CR_CUOTAMORA_COND.fn_monto_intmor(a.pgcod,
                                                  a.ppmod,
                                                  a.ppsuc,
                                                  a.ppmda,
                                                  a.pppap,
                                                  a.ppcta,
                                                  a.ppoper,
                                                  a.ppsbop,
                                                  a.pptope,
                                                  a.ppfpag,
                                                  a.ppcap,
                                                  a.ppint,
                                                  pd_fecpro),
             
             PQ_CR_CUOTAMORA_COND.fn_monto_cuota(a.pgcod,
                                                 a.ppmod,
                                                 a.ppsuc,
                                                 a.ppmda,
                                                 a.pppap,
                                                 a.ppcta,
                                                 a.ppoper,
                                                 a.ppsbop,
                                                 a.pptope,
                                                 a.ppfpag,
                                                 a.ppcap,
                                                 a.ppint,
                                                 pd_fecpro),
             pd_fecpro - a.ppfpag, --dias mora
             (select count(*)
                from fsd601 aa
               where aa.pgcod = a.pgcod
                 and aa.ppmod = a.ppmod
                 and aa.ppsuc = a.ppsuc
                 and aa.ppmda = a.ppmda
                 and aa.pppap = a.pppap
                 and aa.ppcta = a.ppcta
                 and aa.ppoper = a.ppoper
                 and aa.ppsbop = a. ppsbop
                 and aa.pptope = a.pptope
                 and aa.d601co = 'S'
              --and aa.ppfpag <= a.ppfpag mod@abr 20161130
              ),
             (select max(o.pp1fech)
                from fsd602 o
               where o.pgcod = a.pgcod
                 and o.ppmod = a.ppmod
                 and o.ppsuc = a.ppsuc
                 and o.ppmda = a.ppmda
                 and o.pppap = a.pppap
                 and o.ppcta = a.ppcta
                 and o.ppoper = a.ppoper
                 and o.ppsbop = a.ppsbop
                 and o.pptope = a.pptope
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0
                 and o.pp1fech <= pd_fecpro),
             (select aofvto
                from fsd010 h
               where h.pgcod = a.pgcod
                 and h.aomod = a.ppmod
                 and h.aosuc = a.ppsuc
                 and h.aomda = a.ppmda
                 and h.aopap = a.pppap
                 and h.aocta = a.ppcta
                 and h.aooper = a.ppoper
                 and h.aosbop = a.ppsbop
                 and h.aotope = a.pptope)
      
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d601co = 'S'
         and a.ppfpag <= pd_fecpro
         and not exists
       (select b.ppmod,
                     b.ppsuc,
                     b.ppmda,
                     b.pppap,
                     b.ppcta,
                     b.ppoper,
                     b.ppsbop,
                     b.pptope,
                     b.ppfpag
                from fsd602 b
               where b.pgcod = a.pgcod
                 and b.ppmod = a.ppmod
                 and b.ppsuc = a.ppsuc
                 and b.ppmda = a.ppmda
                 and b.pppap = a.pppap
                 and b.ppcta = a.ppcta
                 and b.ppoper = a.ppoper
                 and b.ppsbop = a.ppsbop
                 and b.pptope = a.pptope
                 and b.ppfpag = a.ppfpag
                 and b.ppfpag <= pd_fecpro --mod@abr 20181012
                 and b.d602co = 'S'
                 and b.pp1stat = 'T'
                 and (b.d602cd, b.d602mo, b.d602su, b.d602tr, b.d602re, b.d602fc) not in
                     (select dd.d602cd,
                             dd.d602mo,
                             dd.d602su,
                             dd.d602tr,
                             dd.d602re,
                             dd.d602fc
                        from fsd602 dd
                       where dd.d602cd = pn_d602cd
                         and dd.d602mo = pn_d602mo
                         and dd.d602su = pn_d602su
                         and dd.d602tr = pn_d602tr
                         and dd.d602re = pn_d602re
                         and dd.d602fc = pd_fecpro)
                    --b.d602mo, b.d602tr, ) not in (select 30, 111 from dual) --mod@abr 20181012                    
                 and (b.pp1cap + b.pp1int) <> 0)
       order by a.ppfpag;
  
    return curref;
  
  end Fn_DetalleCuota;

  Function fn_monto_capital(pn_emp in number,
                            pn_mod in number,
                            pn_suc in number,
                            pn_mda in number,
                            pn_pap in number,
                            pn_cta in number,
                            pn_ope in number,
                            pn_sbo in number,
                            pn_top in number,
                            pd_fec in date,
                            pn_cap in number,
                            pn_int in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
  
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ld_fecpago  date;
  begin
    --tasa de interes
    ln_tasint := PQ_CR_CUOTAMORA_COND.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);
    --tasa de mora                                                    
    ln_tasmor := PQ_CR_CUOTAMORA_COND.BT_Tasa_Mora(pn_emp,
                                                   pn_mod,
                                                   pn_suc,
                                                   pn_mda,
                                                   pn_pap,
                                                   pn_cta,
                                                   pn_ope,
                                                   pn_sbo,
                                                   pn_top);
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    --dbms_output.put_line(ln_capTotal);
    return ln_capTotal;
  
  end fn_monto_capital;

  Function fn_monto_inter(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pd_fec in date,
                          pn_cap in number,
                          pn_int in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_intTotal number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ld_fecpago  date;
  begin
    --tasa de interes
    ln_tasint := PQ_CR_CUOTAMORA_COND.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);
    --tasa de mora                                                    
    ln_tasmor := PQ_CR_CUOTAMORA_COND.BT_Tasa_Mora(pn_emp,
                                                   pn_mod,
                                                   pn_suc,
                                                   pn_mda,
                                                   pn_pap,
                                                   pn_cta,
                                                   pn_ope,
                                                   pn_sbo,
                                                   pn_top);
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
  
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
  
    --dbms_output.put_line(ln_intTotal);
  
    return ln_intTotal;
  end fn_monto_inter;

  Function fn_monto_seguro(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fec in date,
                           pn_cap in number,
                           pn_int in number) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_seg      number(17, 2);
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_segTotal number(17, 2);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ld_fecpago  date;
  
  begin
  
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
    --seguros
    begin
      select a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14
        into ln_seg
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec;
    exception
      when others then
        null;
    end;
  
    ln_segTotal := nvl(ln_seg, 0) - nvl(ln_segA, 0);
  
    --dbms_output.put_line(ln_segTotal);
  
    return ln_segTotal;
  end fn_monto_seguro;

  Function fn_monto_icv(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pn_cap    in number,
                        pn_int    in number,
                        pd_fecpro in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_com      number(17, 2);
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_dia      number(5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ln_icvTotal number(17, 2); --mod@abr 20171011
    ld_fecpago  date;
  begin
    --tasa de interes
    ln_tasint := PQ_CR_CUOTAMORA_COND.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);
    --tasa de mora                                                    
    ln_tasmor := PQ_CR_CUOTAMORA_COND.BT_Tasa_Mora(pn_emp,
                                                   pn_mod,
                                                   pn_suc,
                                                   pn_mda,
                                                   pn_pap,
                                                   pn_cta,
                                                   pn_ope,
                                                   pn_sbo,
                                                   pn_top);
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
    --dias de atraso
    if ld_fecpago is not null then
      ln_dia := pd_fecpro - ld_fecpago;
    else
      ln_dia := pd_fecpro - pd_fec;
    end if;
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
  
    --interes compensatorio
    ln_com := round((Power(1 + (ln_tasint / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
  
    ln_icvTotal := nvl(ln_com, 0) + nvl(ln_icvA, 0); --mod@abr 20171011
  
    --dbms_output.put_line(ln_icvTotal);
  
    return ln_icvTotal;
  end fn_monto_icv;

  Function fn_monto_intmor(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fec    in date,
                           pn_cap    in number,
                           pn_int    in number,
                           pd_fecpro in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_mor      number(17, 2);
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_dia      number(5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ln_morTotal number(17, 2); --mod@abr 20171011
    ld_fecpago  date;
  begin
    --tasa de interes
    ln_tasint := PQ_CR_CUOTAMORA_COND.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);
    --tasa de mora                                                    
    ln_tasmor := PQ_CR_CUOTAMORA_COND.BT_Tasa_Mora(pn_emp,
                                                   pn_mod,
                                                   pn_suc,
                                                   pn_mda,
                                                   pn_pap,
                                                   pn_cta,
                                                   pn_ope,
                                                   pn_sbo,
                                                   pn_top);
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
    --dias de atraso
    if ld_fecpago is not null then
      ln_dia := pd_fecpro - ld_fecpago;
    else
      ln_dia := pd_fecpro - pd_fec;
    end if;
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
  
    --interes moratorio
    ln_mor := round((Power(1 + (ln_tasmor / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
  
    ln_morTotal := nvl(ln_mor, 0) + nvl(ln_morA, 0); --mod@abr 20171011
  
    --dbms_output.put_line(ln_morTotal);
  
    return ln_morTotal;
  end fn_monto_intmor;

  Function fn_monto_cuota(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pd_fec    in date,
                          pn_cap    in number,
                          pn_int    in number,
                          pd_fecpro in date) return number is
    -- *****************************************************************
    -- Nombre                     : fn_monto_cuota
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.12
    -- Autor de Creación          : Abernedo
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   : 
    -- Descripción de Modificación:   
    -- *****************************************************************
    ln_com      number(17, 2);
    ln_mor      number(17, 2);
    ln_tasint   number(10, 5);
    ln_tasmor   number(10, 5);
    ln_mto      number(17, 2);
    ln_seg      number(17, 2);
    ln_dia      number(5);
    ln_capA     number(17, 2);
    ln_intA     number(17, 2);
    ln_segA     number(17, 2);
    ln_capTotal number(17, 2);
    ln_intTotal number(17, 2);
    ln_segTotal number(17, 2);
    ln_morA     number(17, 2);
    ln_icvA     number(17, 2);
    ln_morTotal number(17, 2); --mod@abr 20171011
    ln_icvTotal number(17, 2); --mod@abr 20171011
    ld_fecpago  date;
  begin
    --tasa de interes
    ln_tasint := PQ_CR_CUOTAMORA_COND.BT_Tasa_Interes(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top);
    --tasa de mora                                                    
    ln_tasmor := PQ_CR_CUOTAMORA_COND.BT_Tasa_Mora(pn_emp,
                                                   pn_mod,
                                                   pn_suc,
                                                   pn_mda,
                                                   pn_pap,
                                                   pn_cta,
                                                   pn_ope,
                                                   pn_sbo,
                                                   pn_top);
    --pagos adelantado
    PQ_CR_CUOTAMORA_COND.Sp_PagoAdelantado(pn_emp,
                                           pn_mod,
                                           pn_suc,
                                           pn_mda,
                                           pn_pap,
                                           pn_cta,
                                           pn_ope,
                                           pn_sbo,
                                           pn_top,
                                           pd_fec,
                                           ln_tasint,
                                           ln_tasmor, /*pd_fecpro,*/
                                           pn_cap,
                                           pn_int,
                                           ln_capA,
                                           ln_intA,
                                           ln_segA,
                                           ln_morA,
                                           ln_icvA,
                                           ld_fecpago);
    --dias de atraso
    if ld_fecpago is not null then
      ln_dia := pd_fecpro - ld_fecpago;
    else
      ln_dia := pd_fecpro - pd_fec;
    end if;
  
    --seguros
    begin
      select a.ppimp11 + a.ppimp12 + a.ppimp13 + a.ppimp14
        into ln_seg
        from fsd611 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec;
    exception
      when others then
        null;
    end;
  
    ln_capTotal := nvl(pn_cap, 0) - nvl(ln_capA, 0);
    ln_intTotal := nvl(pn_int, 0) - nvl(ln_intA, 0);
    ln_segTotal := nvl(ln_seg, 0) - nvl(ln_segA, 0);
    --interes compensatorio
    ln_com := round((Power(1 + (ln_tasint / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
    --interes moratorio
    ln_mor := round((Power(1 + (ln_tasmor / 100), (ln_dia / 360)) - 1) *
                    (ln_capTotal + ln_intTotal),
                    2);
  
    ln_morTotal := nvl(ln_mor, 0) + nvl(ln_morA, 0); --mod@abr 20171011
    ln_icvTotal := nvl(ln_com, 0) + nvl(ln_icvA, 0); --mod@abr 20171011
  
    ln_mto := nvl(ln_segTotal, 0) + nvl(ln_icvTotal, 0) +
              nvl(ln_morTotal, 0) + nvl(ln_capTotal, 0) +
              nvl(ln_intTotal, 0); --mod@abr 20171011
  
    --dbms_output.put_line(ln_mto);
    --dbms_output.put_line(ln_capTotal);
    --dbms_output.put_line(ln_intTotal);
    --dbms_output.put_line(ln_segTotal);
    --dbms_output.put_line(ln_morTotal);
    --dbms_output.put_line(ln_icvTotal);
  
    return ln_mto;
  end fn_monto_cuota;

  Procedure Sp_PagoAdelantado(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pd_fec  in date,
                              pn_tint in number, --mod@abr 20171011
                              pn_tmor in number, --mod@abr 20171011
                              --pd_fecpro in date, --mod@abr 20171011    
                              pn_capIN   in number, --mod@abr 20171011
                              pn_intIN   in number, --mod@abr 20171011
                              pn_cap     out number,
                              pn_int     out number,
                              pn_segT    out number,
                              pn_morT    out number,
                              pn_icvT    out number,
                              pd_fecpago out date) is
    ln_seg      number(18, 2);
    ln_mor      number(18, 2);
    ln_icv      number(18, 2);
    ln_dia      number;
    ln_cap      number(17, 2);
    ln_int      number(17, 2);
    ln_morDif   number(18, 2);
    ln_icvDif   number(18, 2);
    ld_fecmax   date;
    ln_morDif_A number(18, 2) := 0;
    ln_icvDif_A number(18, 2) := 0;
    ld_fecaux   date := to_date('01.01.0001', 'dd.mm.yyyy');
    --lc_flg_ICV char(1):='N';
    --lc_flg_MOR char(1):='N';
    --ln_mor_AUX number(18,2);
    --ln_icv_AUX number(18,2);
    --lc_flgB char(1) := 'N';
    lc_flgPar char(1);
    ld_fecPar date;
    --lc_flgOk char(1):='N';
    ln_cont number(5) := 0;
  
    cursor calendario is
      select *
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
  begin
    begin
      select sum(a.pp1cap), sum(a.pp1int)
        into pn_cap, pn_int
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    pn_segT := 0;
    pn_morT := 0;
    pn_icvT := 0;
  
    if pn_cap is not null then
      for i in calendario loop
        
        
        begin
          select sum(a.pp1imp11 + a.pp1imp12 + a.pp1imp13 + a.pp1imp14)
            into ln_seg
            from fsd612 a
           where a.pgcod = i.pgcod
             and a.ppmod = i.ppmod
             and a.ppsuc = i.ppsuc
             and a.ppmda = i.ppmda
             and a.pppap = i.pppap
             and a.ppcta = i.ppcta
             and a.ppoper = i.ppoper
             and a.ppsbop = i.ppsbop
             and a.pptope = i.pptope
             and a.ppfpag = i.ppfpag
             and a.pp1nump = i.pp1nump;
        exception
          when others then
            null;
          
        end;
      
        --mod@abr 20171011
        --dias de atraso
        if i.pp1fech > pd_fec then
          begin
            select max(a.pp1fech)
              into ld_fecmax
              from fsd602 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.ppfpag = pd_fec
               and a.pp1fech > pd_fec
               and a.pp1fech < i.pp1fech
               and a.pp1stat = 'P'
               and a.d602co = 'S';
          exception
            when others then
              null;
          end;
          if ld_fecmax is null then
            ld_fecmax := i.ppfpag;
          end if;
        
          ln_dia := i.pp1fech - ld_fecmax;
        
          --calculo capital e interes
          begin
            select sum(a.pp1cap), sum(a.pp1int)
              into ln_cap, ln_int
              from fsd602 a
             where a.pgcod = i.pgcod
               and a.ppmod = i.ppmod
               and a.ppsuc = i.ppsuc
               and a.ppmda = i.ppmda
               and a.pppap = i.pppap
               and a.ppcta = i.ppcta
               and a.ppoper = i.ppoper
               and a.ppsbop = i.ppsbop
               and a.pptope = i.pptope
               and a.ppfpag = i.ppfpag
               and a.pp1fech < i.pp1fech
               and a.pp1stat = 'P'
               and a.d602co = 'S';
          exception
            when others then
              null;
          end;
        
          --Verifica si esta cuota forma parte de parciales en el mismo dia
          PQ_CR_CUOTAMORA_COND.Fn_cr_MismoDia(pn_emp  => i.pgcod,
                                              pn_mod  => i.ppmod,
                                              pn_suc  => i.ppsuc,
                                              pn_mda  => i.ppmda,
                                              pn_pap  => i.pppap,
                                              pn_cta  => i.ppcta,
                                              pn_ope  => i.ppoper,
                                              pn_sbo  => i.ppsbop,
                                              pn_top  => i.pptope,
                                              pn_num  => i.pp1nump,
                                              pd_fec  => i.pp1fech,
                                              pc_flgD => lc_flgPar,
                                              pd_fecP => ld_fecPar);
          if lc_flgPar = 'S' then
            ln_cont := ln_cont + 1;
          end if;
          if lc_flgPar = 'S' and ln_cont = 1 then
            PQ_CR_CUOTAMORA_COND.Sp_cr_CalculoParciales(pn_emp    => i.pgcod,
                                                        pn_mod    => i.ppmod,
                                                        pn_suc    => i.ppsuc,
                                                        pn_mda    => i.ppmda,
                                                        pn_pap    => i.pppap,
                                                        pn_cta    => i.ppcta,
                                                        pn_ope    => i.ppoper,
                                                        pn_sbo    => i.ppsbop,
                                                        pn_top    => i.pptope,
                                                        pd_fecP   => i.ppfpag,
                                                        pd_fec    => ld_fecPar,
                                                        pn_tint   => pn_tint,
                                                        pn_tmor   => pn_tmor,
                                                        pn_dia    => ln_dia,
                                                        pn_cap    => pn_capIN,
                                                        pn_int    => pn_intIN,
                                                        pn_capP   => ln_cap,
                                                        pn_intP   => ln_int,
                                                        pn_icvA   => ln_icvDif_A,
                                                        pn_morA   => ln_morDif_A,
                                                        ln_icvDif => ln_icvDif,
                                                        ln_morDif => ln_morDif);
          
            ln_morDif_A := ln_morDif;
            ln_icvDif_A := ln_icvDif;
          end if;
        
          if lc_flgPar = 'N' then
          
            begin
              select sum(a.pp1imp2), sum(a.pp1imp3)
                into ln_mor, ln_icv
                from fsd612 a
               where a.pgcod = i.pgcod
                 and a.ppmod = i.ppmod
                 and a.ppsuc = i.ppsuc
                 and a.ppmda = i.ppmda
                 and a.pppap = i.pppap
                 and a.ppcta = i.ppcta
                 and a.ppoper = i.ppoper
                 and a.ppsbop = i.ppsbop
                 and a.pptope = i.pptope
                 and a.ppfpag = i.ppfpag
                 and a.pp1nump = i.pp1nump;
            exception
              when others then
                null;
              
            end;
          
            --interes compensatorio
            ln_icvDif := (round((Power(1 + (pn_tint / 100), (ln_dia / 360)) - 1) *
                                ((pn_capIN - nvl(ln_cap, 0)) +
                                (pn_intIN - nvl(ln_int, 0))),
                                2) + ln_icvDif_A) - nvl(ln_icv, 0);
          
            --interes moratorio
            ln_morDif := (round((Power(1 + (pn_tmor / 100), (ln_dia / 360)) - 1) *
                                ((pn_capIN - nvl(ln_cap, 0)) +
                                (pn_intIN - nvl(ln_int, 0))),
                                2) + ln_morDif_A) - nvl(ln_mor, 0);

            ln_morDif_A := ln_morDif;
            ln_icvDif_A := ln_icvDif;
          end if;
        end if;
      
        --mod@abr 20171011
      
        pn_segT   := pn_segT + nvl(ln_seg, 0);
        pn_morT   := ln_morDif_A; --pn_morT+nvl(ln_morDif,0);
        pn_icvT   := ln_icvDif_A; --pn_icvT+nvl(ln_icvDif,0);
        ld_fecaux := i.pp1fech;
      end loop;
      
      
     
    end if;
  
    pn_cap := nvl(pn_cap, 0);
    pn_int := nvl(pn_int, 0);
  
    begin
      select max(a.pp1fech)
        into pd_fecpago
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    --MOD@ABR 20171011
    if pd_fecpago <= pd_fec then
      pd_fecpago := null;
    end if;
    --MOD@ABR 20171011
  
  end Sp_PagoAdelantado;

  Procedure Fn_cr_MismoDia(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_ope  in number,
                           pn_sbo  in number,
                           pn_top  in number,
                           pn_num  in number,
                           pd_fec  in date,
                           pc_flgD out char,
                           pd_fecP out date) is
  
    ln_numD    number(9);
    ld_fecha   date;
    ld_fecauxD date;
   -- ld_fecult  date;
  
  begin
  
    pc_flgD  := 'N';
    ld_fecha := pd_fec;
    pd_fecP  := ld_fecha;
    begin
      select min(a.pp1nump)
        into ln_numD
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.d602co = 'S'
         and a.pp1stat = 'P'
         and a.pp1nump > pn_num;
    exception
      when others then
        null;
    end;
  
    if ln_numD is not null then
      begin
        select a.pp1fech
          into ld_fecauxD
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d602co = 'S'
           and a.pp1stat = 'P'
           and a.pp1nump = ln_numD;
      exception
        when others then
          null;
      end;
    
      if ld_fecauxD = pd_fec then
        pc_flgD := 'S';
      end if;
    end if;
  
    --mod@abr 20181115
    /*if pc_flgD = 'N' then
      begin
        select a.pp1fech
          into ld_fecult
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.d602co = 'S'
           and a.pp1stat = 'P'
           and a.pp1nump = pn_num;
      exception
        when others then
          null;
      end;
    end if;
  
    if ld_fecult = pd_fec then
      pc_flgD := 'S';
    end if;*/
    --mod@abr 20181115
  end Fn_cr_MismoDia;

  Procedure Sp_cr_CalculoParciales(pn_emp    in number,
                                   pn_mod    in number,
                                   pn_suc    in number,
                                   pn_mda    in number,
                                   pn_pap    in number,
                                   pn_cta    in number,
                                   pn_ope    in number,
                                   pn_sbo    in number,
                                   pn_top    in number,
                                   pd_fecP   in date, --fecha de vcto de cuota
                                   pd_fec    in date, -- fecha de pago de la cuota
                                   pn_tint   in number, -- tasa de icv 
                                   pn_tmor   in number, -- tasa moratoria
                                   pn_dia    in number, --dias de atraso
                                   pn_cap    in number, --capital de la cuota
                                   pn_int    in number, --interes de la cuota
                                   pn_capP   in number, --capital pagado
                                   pn_intP   in number, --interes pagado
                                   pn_icvA   in number, --icv que debe
                                   pn_morA   in number, --mora que debe
                                   ln_icvDif out number,
                                   ln_morDif out number) is
  
    ln_mor number(17, 2);
    ln_icv number(17, 2);
  
  begin
    begin
      select sum(a.pp1imp2), sum(a.pp1imp3)
        into ln_mor, ln_icv
        from fsd612 a, fsd602 b
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fecP
         and a.pgcod = b.pgcod
         and a.ppmod = b.ppmod
         and a.ppsuc = b.ppsuc
         and a.ppmda = b.ppmda
         and a.pppap = b.pppap
         and a.ppcta = b.ppcta
         and a.ppoper = b.ppoper
         and a.ppsbop = b.ppsbop
         and a.pptope = b.pptope
         and a.ppfpag = b.ppfpag
         and b.pp1fech = pd_fec
         and a.pp1nump = b.pp1nump
         and b.d602co = 'S'
         and b.pp1stat = 'P';
    exception
      when others then
        null;
      
    end;
  
    --interes compensatorio
    ln_icvDif := (round((Power(1 + (pn_tint / 100), (pn_dia / 360)) - 1) *
                        ((pn_cap - nvl(pn_capP, 0)) +
                        (pn_int - nvl(pn_intP, 0))),
                        2) + pn_icvA) - nvl(ln_icv, 0);
    --interes moratorio
    ln_morDif := (round((Power(1 + (pn_tmor / 100), (pn_dia / 360)) - 1) *
                        ((pn_cap - nvl(pn_capP, 0)) +
                        (pn_int - nvl(pn_intP, 0))),
                        2) + pn_morA) - nvl(ln_mor, 0);
  
  end Sp_cr_CalculoParciales;

end PQ_CR_CUOTAMORA_COND;
/

