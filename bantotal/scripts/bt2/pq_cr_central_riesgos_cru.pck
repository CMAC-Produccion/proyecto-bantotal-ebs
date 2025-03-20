create or replace package pq_cr_central_riesgos_CRU is

  -- Author  : RMONTESR
  -- Created : 18/04/2022 12:26:35
  -- Purpose : Paquete con procedimientos para la central de riesgo unificada

  ---------------------------------------------------------------
  procedure sp_cr_deuda_repro_cru(pc_user   in varchar2,
                                  pv_codsbs in varchar2,
                                  pv_rpta   out varchar2);
  ---------------------------------------------------------------

end pq_cr_central_riesgos_CRU;
/

create or replace package body pq_cr_central_riesgos_CRU is

  ----------------------------------------------------------------
  procedure sp_cr_deuda_repro_cru(pc_user   in varchar2,
                                  pv_codsbs in varchar2,
                                  pv_rpta   out varchar2) is
  
    ld_fecha      date;
    ln_saldo0     number;
    ln_saldo1     number;
    ln_saldo2     number;
    ln_saldo3     number;
    ln_saldo4     number;
    ln_saldo5     number;
    ln_saldo6     number;
    ln_prcdis1    number;
    ln_prcdis2    number;
    ln_prcdis3    number;
    ln_prcdis4    number;
    ln_prcdis5    number;
    ln_prcdis6    number;
    ln_porcentaje number;
    lc_pagul6     char(1);
    lc_cuenta     varchar2(15);
    lc_descuenta  varchar2(40);
    lc_cali       varchar2(4);
    lc_descali    varchar2(30);
    ln_diasatr    number;
  begin
    begin
      delete aqpb400
       WHERE aqpb400usur = rpad(pc_user, 10)
         and aqpb400codsbs = pv_CODSBS;
      commit;
    end;
    begin
      select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                     substr(tpnro, 5, 4),
                     'dd/mm/yyyy')
        into ld_fecha
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
    begin
      SELECT tp1imp1
        into ln_porcentaje
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10884
         AND TP1CORR1 = 53;
    exception
      when no_data_found then
        ln_porcentaje := 0;
    end;
    begin
      for reg in (SELECT distinct c_codemp, c_cretip, cretip_desc, empresa
                    FROM (select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = ld_fecha
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -1)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -2)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -3)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -4)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -5)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104'
                          UNION
                          select  c_codemp,
                                          c_cretip,
                                          NVL(b.tp1desc, 'Sin Descripcion') as cretip_desc,
                                          c.tp1desc empresa
                            from CLDRCCS a
                            left join fst198 b
                              on b.tp1cod = 1
                             and b.tp1cod1 = 10832
                             and b.tp1corr1 = 6
                             and b.tp1corr2 = to_number(a.c_cretip)
                             and b.tp1corr3 = 0
                            left join fst198 c
                              on c.Tp1cod = 1
                             AND c.Tp1cod1 = 10849
                             AND c.Tp1corr1 = 10
                             AND c.Tp1nro1 = a.c_codemp
                           Where C_CODSBS = pv_codsbs
                             and D_FECPRE = add_months(ld_fecha, -6)
                                --and d_fecpre >= add_months(ld_fecha, -6)
                             and c_cuenta like '81_937%' -- tiene deuda reprogramada
                             and c_codemp <> '00104')) loop
        begin
          select a.c_cuenta, b.pcnomr, a.c_calvig, c.Tp1desc, a.n_diaatr
            into lc_cuenta, lc_descuenta, lc_cali, lc_descali, ln_diasatr
            from CLDRCCS a
            left join fsd014 b
              on b.rubro = (to_number(a.c_cuenta) / 10)
            left join fst198 c
              on c.tp1cod = 1
             and c.tp1cod1 = 10832
             and c.tp1corr1 = 5
             and c.tp1corr2 = to_number(a.c_calvig)
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = ld_fecha
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip
             and rownum = 1;
        exception
          when others then
            lc_cuenta    := '';
            lc_descuenta := '';
            lc_cali      := '';
            lc_descali   := '';
            ln_diasatr   := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo0
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = ld_fecha
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo0 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo1
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -1)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo1 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo2
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -2)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo2 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo3
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -3)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo3 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo4
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -4)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo4 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo5
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -5)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo5 := 0;
        end;
        begin
          select sum(a.n_Salcap)
            into ln_saldo6
            from CLDRCCS a
           Where C_CODSBS = pv_codsbs
             and D_FECPRE = add_months(ld_fecha, -6)
             and c_cuenta like '81_937%' -- tiene deuda reprogramada
             and c_codemp = reg.c_codemp
             and c_cretip = reg.c_cretip;
        exception
          when no_data_found then
            ln_saldo6 := 0;
        end;
        if ln_saldo0 is null then
          ln_saldo0 := 0;
        end if;
        if ln_saldo1 is null then
          ln_saldo1 := 0;
        end if;
        if ln_saldo2 is null then
          ln_saldo2 := 0;
        end if;
        if ln_saldo3 is null then
          ln_saldo3 := 0;
        end if;
        if ln_saldo4 is null then
          ln_saldo4 := 0;
        end if;
        if ln_saldo5 is null then
          ln_saldo5 := 0;
        end if;
        if ln_saldo6 is null then
          ln_saldo6 := 0;
        end if;
        if ln_saldo1 > 0 then
          ln_prcdis1 := round((ln_saldo0 - ln_saldo1) * 100 / ln_saldo1,4);
          if(ln_prcdis1 >100) then
              ln_prcdis1 := 100;
          end if;
          if(ln_prcdis1 <-100) then
              ln_prcdis1 := -100;
          end if;
        else
          ln_prcdis1 := 100;
        end if;
        if ln_saldo2 > 0 then
          ln_prcdis2 := round((ln_saldo1 - ln_saldo2) * 100 / ln_saldo2,4);
          if(ln_prcdis2 >100) then
              ln_prcdis2 := 100;
          end if;
          if(ln_prcdis2 <-100) then
              ln_prcdis2 := -100;
          end if;
        else
          ln_prcdis2 := 100;
        end if;
        if ln_saldo3 > 0 then
          ln_prcdis3 := round((ln_saldo2 - ln_saldo3) * 100 / ln_saldo3,4);
          if(ln_prcdis3 >100) then
              ln_prcdis3 := 100;
          end if;
          if(ln_prcdis3 <-100) then
              ln_prcdis3 := -100;
          end if;
        else
          ln_prcdis3 := 100;
        end if;
        if ln_saldo4 > 0 then
          ln_prcdis4 := round((ln_saldo3 - ln_saldo4) * 100 / ln_saldo4,4);
          if(ln_prcdis4 >100) then
              ln_prcdis4 := 100;
          end if;
          if(ln_prcdis4 <-100) then
              ln_prcdis4 := -100;
          end if;
        else
          ln_prcdis4 := 100;
        end if;
        if ln_saldo5 > 0 then
          ln_prcdis5 := round((ln_saldo4 - ln_saldo5) * 100 / ln_saldo5,4);
          if(ln_prcdis5 >100) then
              ln_prcdis5 := 100;
          end if;
          if(ln_prcdis5 <-100) then
              ln_prcdis5 := -100;
          end if;
        else
          ln_prcdis5 := 100;
        end if;
        if ln_saldo6 > 0 then
          ln_prcdis6 := round((ln_saldo5 - ln_saldo6) * 100 / ln_saldo6,4);
          if(ln_prcdis6 >100) then
              ln_prcdis6 := 100;
          end if;
          if(ln_prcdis6 <-100) then
              ln_prcdis6 := -100;
          end if;
        else
          ln_prcdis6 := 100;
        end if;
        if ln_saldo0 = 0 or ln_saldo1 = 0 or ln_saldo2 = 0 or ln_saldo3 = 0 or
           ln_saldo4 = 0 or ln_saldo5 = 0 then
          lc_pagul6 := 'S';
        else
          if ln_prcdis1 < ln_porcentaje * -1 or
             ln_prcdis2 < ln_porcentaje * -1 or
             ln_prcdis3 < ln_porcentaje * -1 or
             ln_prcdis4 < ln_porcentaje * -1 or
             ln_prcdis5 < ln_porcentaje * -1 or
             ln_prcdis6 < ln_porcentaje * -1 then
            lc_pagul6 := 'S';
          else
            lc_pagul6 := 'N';
          end if;
        end if;
        begin
          insert into aqpb400
            (aqpb400usur,
             aqpb400codsbs,
             aqpb400fproc,
             aqpb400fcr,
             aqpb400hcr,
             aqpb400codemp,
             aqpb400desemp,
             aqpb400cretip,
             aqpb400tidesc,
             aqpb400ctac,
             aqpb400desc,
             aqpb400diaatr,
             aqpb400calvig,
             aqpb400descde,
             aqpb400descal,
             aqpb400saldo0,
             aqpb400saldo1,
             aqpb400saldo2,
             aqpb400saldo3,
             aqpb400saldo4,
             aqpb400saldo5,
             aqpb400saldo6,
             aqpb400prcbase,
             aqpb400prdis1,
             aqpb400prdis2,
             aqpb400prdis3,
             aqpb400prdis4,
             aqpb400prdis5,
             aqpb400prdis6,
             aqpb400pagul6)
          values
            (rpad(pc_user, 10),
             pv_codsbs,
             sysdate,
             to_char(sysdate, 'DD/MM/YYYY'),
             to_char(sysdate, 'HH24:MI:SS'),
             reg.c_codemp,
             reg.empresa,
             reg.c_cretip,
             reg.cretip_desc,
             lc_cuenta, --cuenta
             lc_descuenta, --desccuenta
             ln_diasatr, --dias atraso
             lc_cali, --calif vigente
             'CREDITO REPROGRAMADO', --descripcion defecto
             lc_descali, --desc calif vigente
             ln_saldo0,
             ln_saldo1,
             ln_saldo2,
             ln_saldo3,
             ln_saldo4,
             ln_saldo5,
             ln_saldo6,
             ln_porcentaje,
             ln_prcdis1,
             ln_prcdis2,
             ln_prcdis3,
             ln_prcdis4,
             ln_prcdis5,
             ln_prcdis6,
             lc_pagul6 --eval
             );
        exception
          when dup_val_on_index then
            null;
        end;
      end loop;
      commit;
    end;
    pv_rpta := 'S';
  
  end sp_cr_deuda_repro_cru;
  ---------------------------------------------------------------------------
end pq_cr_central_riesgos_CRU;
/

