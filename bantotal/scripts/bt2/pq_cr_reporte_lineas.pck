create or replace package pq_cr_reporte_lineas is

  type tp_nomvar is table of varchar2(30) index by binary_integer;
  type tp_valvar is table of varchar2(30) index by binary_integer;
  type tp_regla is record(
    RNG49COD FRNG51.RNG49COD%type,
    RNG50GRP FRNG51.RNG50GRP%type,
    RNG51COD FRNG51.RNG51COD%type,
    RNG68COD FRNG51.RNG68COD%type,
    RNG51OPE FRNG51.RNG51OPE%type,
    RNG51VAL FRNG51.RNG51VAL%type,
    RNG68ATR FRNG68.RNG68ATR%type,
    RNG68TDA FRNG68.RNG68TDA%type,
    RNG50Ret FRNG50.RNG50RET%type);
  type tb_reglas is table of tp_regla index by binary_integer;
  Procedure sp_cr_carga0(pd_Fecpro in date);
  Procedure Sp_cr_carga(pd_Fecpro date);
  procedure Sp_cr_historico(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flg    out char);
  Procedure Sp_cr_capital(pn_cta    in number,
                          pd_Fecpro in date,
                          pn_meses  out number);
  Procedure Sp_cr_segmentacion(pn_cta    in number,
                               pd_fecpro in date,
                               pn_ins    in number,
                               pn_seg    out number,
                               pc_flg    out char,
                               pn_segOri out number);
  Procedure Sp_Carga_Variables(pd_fecpro in date /*,P_C_DIGITO in number*/);
  procedure sp_cr_RNG1701(P_D_FECPRO in date);
  procedure sp_cr_cargar_variables(P_D_FECPRO IN DATE,
                                   PN_EMP     IN JAQZ689.JAQZ689EMP%type,
                                   PN_MOD     IN JAQZ689.JAQZ689MOD%type,
                                   PN_SUC     IN JAQZ689.JAQZ689SUC%type,
                                   PN_MDA     IN JAQZ689.JAQZ689MDA%type,
                                   PN_PAP     IN JAQZ689.JAQZ689PAP%type,
                                   PN_CTA     IN JAQZ689.JAQZ689CTA%type,
                                   PN_OPE     IN JAQZ689.JAQZ689OPE%type,
                                   PN_SBO     IN JAQZ689.JAQZ689SBO%type,
                                   PN_TOP     IN JAQZ689.JAQZ689TOP%type,
                                   p_a_nomvar out pq_cr_reporte_lineas.tp_nomvar,
                                   p_a_valvar out pq_cr_reporte_lineas.tp_valvar,
                                   p_n_var    out number);
  procedure sp_cr_evalua_clientes_1(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  IN pq_cr_reporte_lineas.tp_nomvar,
                                    P_A_VALVAR  IN pq_cr_reporte_lineas.tp_valvar,
                                    P_N_VAR     IN number,
                                    P_A_REGLAS  in pq_cr_reporte_lineas.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2);
  Procedure Sp_cr_fallecido(pn_ins in number, pc_flg out char);
  Procedure Sp_cr_TipoOper(pn_ins in number, pc_flg out char);
  Procedure Sp_Cr_Variables(pn_ins    in number,
                            pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_vgt    out char,
                            pn_mec    out number,
                            pn_cal    out number,
                            pn_vto    out number,
                            pn_cap    out number,
                            pc_seg    out char,
                            pn_segAct out number,
                            pn_segOri out number);
  Procedure Sp_Segmento_Des(pn_ins in number, pn_seg out number);
  Procedure Sp_Carga_Variables_1703(pd_fecpro in date);
  procedure sp_cr_RNG1703(P_D_FECPRO in date);
  procedure sp_cr_cargar_variables_1703(P_D_FECPRO IN DATE,
                                        PN_EMP     IN JAQZ689.JAQZ689EMP%type,
                                        PN_MOD     IN JAQZ689.JAQZ689MOD%type,
                                        PN_SUC     IN JAQZ689.JAQZ689SUC%type,
                                        PN_MDA     IN JAQZ689.JAQZ689MDA%type,
                                        PN_PAP     IN JAQZ689.JAQZ689PAP%type,
                                        PN_CTA     IN JAQZ689.JAQZ689CTA%type,
                                        PN_OPE     IN JAQZ689.JAQZ689OPE%type,
                                        PN_SBO     IN JAQZ689.JAQZ689SBO%type,
                                        PN_TOP     IN JAQZ689.JAQZ689TOP%type,
                                        p_a_nomvar out pq_cr_reporte_lineas.tp_nomvar,
                                        p_a_valvar out pq_cr_reporte_lineas.tp_valvar,
                                        p_n_var    out number);
  procedure sp_cr_evalua_clientes_1_1703(P_N_REGLA   IN NUMBER,
                                         P_A_NOMVAR  IN pq_cr_reporte_lineas.tp_nomvar,
                                         P_A_VALVAR  IN pq_cr_reporte_lineas.tp_valvar,
                                         P_N_VAR     IN number,
                                         P_A_REGLAS  in pq_cr_reporte_lineas.tb_reglas,
                                         P_N_REG     in number,
                                         p_c_retorno out varchar2);

end pq_cr_reporte_lineas;
/

create or replace package body pq_cr_reporte_lineas is

  Procedure sp_cr_carga0(pd_Fecpro in date) is
  
  begin
  
    execute immediate ('truncate table jaqz688');
    execute immediate ('truncate table jaqz688_AUX');
  
    insert into jaqz688_aux
      (jaqz688emp,
       jaqz688mod,
       jaqz688suc,
       jaqz688mda,
       jaqz688pap,
       jaqz688cta,
       jaqz688ope,
       jaqz688sbo,
       jaqz688top,
       jaqz688fed,
       jaqz688fvt,
       jaqz688est,
       jaqz688fep,
       JAQZ688AX0,
       JAQZ688AX3)
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aofval,
             a.aofvto,
             a.aostat,
             pd_Fecpro,
             fn_instancia_credito(v_Scmod  => a.aomod,
                                  v_Scsuc  => a.aosuc,
                                  v_Scmda  => a.aomda,
                                  v_Scpap  => a.aopap,
                                  v_Sccta  => a.aocta,
                                  v_Scoper => a.aooper,
                                  v_Scsbop => a.aosbop,
                                  v_Sctope => a.aotope),
             nvl((select 'S'
                   from jaqz090 b
                  where b.jaqz090emp = a.pgcod
                    and b.jaqz090mod = a.aomod
                    and b.jaqz090suc = a.aosuc
                    and b.jaqz090mda = a.aomda
                    and b.jaqz090pap = a.aopap
                    and b.jaqz090cta = a.aocta
                    and b.jaqz090ope = a.aooper
                    and b.jaqz090sbo = a.aosbop
                    and b.jaqz090top = a.aotope
                    and b.jaqz090cmo = 3
                    and rownum = 1),
                 'N')
      
        from fsd010 a
       where pgcod = 1
         and aomod = 117
         and aostat = 0
         and aotope not in (10, 12, 13, 14, 15, 16, 17, 18, 25, 117, 118)
         and aocta <> 999999999
      
      ;
  
    commit;
    insert into jaqz688
      (jaqz688emp,
       jaqz688mod,
       jaqz688suc,
       jaqz688mda,
       jaqz688pap,
       jaqz688cta,
       jaqz688ope,
       jaqz688sbo,
       jaqz688top,
       jaqz688fed,
       jaqz688fvt,
       jaqz688est,
       jaqz688fep,
       JAQZ688AX0)
      select jaqz688emp,
             jaqz688mod,
             jaqz688suc,
             jaqz688mda,
             jaqz688pap,
             jaqz688cta,
             jaqz688ope,
             jaqz688sbo,
             jaqz688top,
             jaqz688fed,
             jaqz688fvt,
             jaqz688est,
             jaqz688fep,
             JAQZ688AX0
      
        from jaqz688_aux a
       where a.jaqz688ax3 = 'N';
  
    commit;
  
    --PASO 2
    begin
      -- Call the procedure
      pq_cr_reporte_lineas.sp_carga_variables(pd_Fecpro);
    end;
  
    --PASO 3
    begin
      -- Call the procedure
      pq_cr_reporte_lineas.sp_cr_rng1701(pd_Fecpro);
    end;
  
    --PASO 4
    begin
      -- Call the procedure
      pq_cr_reporte_lineas.sp_carga_variables_1703(pd_Fecpro);
    end;
  
    --PASO 5
    begin
      -- Call the procedure
      pq_cr_reporte_lineas.sp_cr_rng1703(pd_Fecpro);
    end;
  
  end sp_cr_carga0;

  Procedure Sp_cr_carga(pd_Fecpro date) is
  
    cursor creditos is
      select *
        from jaqz688 a
      --where a.jaqz688cta = 2411222
      --  and a.jaqz688ope = 6516812
      ;
  
    lc_flg       char(1) := 'N';
    ld_fvto      date;
    ln_instancia number(10);
    lc_flgCons   char(1);
    ln_meses     number(9);
    ld_feceva    date;
    ld_fecevaM   date;
    lc_flgeva    char(1);
    ld_fecMax    date;
    lc_flgMax    char(1);
    lc_flgVto    char(1);
    lc_fecCapi   char(1);
    ln_seg       number(5);
    lc_flgSeg    char(1);
    lc_pen       char(1);
    lv_despen    varchar(200);
    lv_var1      varchar(100);
    ln_promedio  number(17, 2);
  begin
    execute immediate ('truncate table jaqz690');
    for i in creditos loop
      lc_flg     := 'N';
      lc_flgCons := 'N';
      lc_flgeva  := 'N';
      ld_fecMax  := null;
      ld_feceva  := null;
      ld_fecevaM := null;
      ld_fvto    := null;
      lc_flgMax  := 'N';
      lc_flgVto  := 'N';
      lc_fecCapi := 'N';
      ln_seg     := null;
      lc_flgSeg  := 'N';
      lc_pen     := 'N';
      lv_despen  := null;
      lv_var1    := null;
      --valida monto de utilizacion
      pq_Cr_reporte_lineas.Sp_cr_historico(i.jaqz688emp,
                                           i.jaqz688mod,
                                           i.jaqz688suc,
                                           i.jaqz688mda,
                                           i.jaqz688pap,
                                           i.jaqz688cta,
                                           i.jaqz688ope,
                                           i.jaqz688sbo,
                                           i.jaqz688top,
                                           pd_Fecpro,
                                           lc_flg);
    
      if lc_flg = 'N' then
        --validacion cumple monto utilizacion
      
        --verificacion de fecha de vencimiento y fecha de evaluacion
        begin
          select a.aofvto
            into ld_fvto
            from fsd010 a
           where a.pgcod = i.jaqz688emp
             and a.aomod = i.jaqz688mod
             and a.aosuc = i.jaqz688suc
             and a.aomda = i.jaqz688mda
             and a.aopap = i.jaqz688pap
             and a.aocta = i.jaqz688cta
             and a.aooper = i.jaqz688ope
             and a.aosbop = i.jaqz688sbo
             and a.aotope = i.jaqz688top;
        exception
          when others then
            null;
        end;
      
        begin
          select a.xwfprcins
            into ln_instancia
            from xwf700 a
           where a.xwfempresa = i.jaqz688emp
             and a.xwfmodulo = i.jaqz688mod
             and a.xwfsucursal = i.jaqz688suc
             and a.xwfmoneda = i.jaqz688mda
             and a.xwfpapel = i.jaqz688pap
             and a.xwfcuenta = i.jaqz688cta
             and a.xwfoperacion = i.jaqz688ope
             and a.xwfsubope = i.jaqz688sbo
             and a.xwftipope = i.jaqz688top
             and a.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select 'S'
            into lc_flgCons
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 14
             and a.tp1corr2 = 1
             and a.tp1nro1 = i.jaqz688top
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
        --meses maximos
        begin
          select tp1nro1
            into ln_meses
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 11
             and a.tp1corr2 = 1;
        exception
          when others then
            null;
        end;
      
        begin
          select SNG120FPag
            into ld_feceva
            from sng120 a
           where a.sng120ins = ln_instancia
             and a.sng120tsk = 'EVALUACION';
        exception
          when others then
            null;
        end;
      
        ld_fecevaM := add_months(ld_feceva, ln_meses);
        ld_fecMax  := add_months(pd_fecpro, 2);
      
        if ld_fecevaM > ld_fecMax then
          --valida fecha de evaluacion
          lc_flgMax := 'S';
        end if;
      
        if ld_fvto > ld_fecMax then
          --valida fecha de vencimiento
          lc_flgVto := 'S';
        end if;
      
        if lc_flgMax = 'S' or lc_flgCons = 'S' then
          --valida fecha de evaluacion o si la linea es consumo
          lc_flgeva := 'S';
        end if;
      
        if lc_flgeva = 'S' and lc_flgVto = 'S' then
          --validacion cumple fecha de vencimiento y evaluacion
        
          --pq_cr_reporte_lineas.Sp_cr_capital(i.jaqz688cta,
          --                                   pd_fecpro,
          --                                   lc_fecCapi);
        
          --if lc_fecCapi = 'N' then
          --validacion cumple capital de trabajo
          --pq_Cr_reporte_lineas.Sp_cr_segmentacion(i.jaqz688cta,
          --                                        pd_fecpro,
          --                                        ln_seg,
          --                                        lc_flgSeg);
          if lc_flgSeg = 'N' then
            --validacion cumple segmentacion
          
            begin
              select a.jaqz688ppen, a.jaqz688dpe, b.jaqz689VAR1
                into lc_pen, lv_despen, lv_var1
                from JAQZ688_PEN a, jaqz689 b
               where a.jaqz688pemp = i.jaqz688emp
                 and a.jaqz688pmod = i.jaqz688mod
                 and a.jaqz688psuc = i.jaqz688suc
                 and a.jaqz688pmda = i.jaqz688mda
                 and a.jaqz688ppap = i.jaqz688pap
                 and a.jaqz688pcta = i.jaqz688cta
                 and a.jaqz688pope = i.jaqz688ope
                 and a.jaqz688psbo = i.jaqz688sbo
                 and a.jaqz688ptop = i.jaqz688top
                 and a.jaqz688pemp = b.jaqz689emp
                 and a.jaqz688pmod = b.jaqz689mod
                 and a.jaqz688psuc = b.jaqz689suc
                 and a.jaqz688pmda = b.jaqz689mda
                 and a.jaqz688ppap = b.jaqz689pap
                 and a.jaqz688pcta = b.jaqz689cta
                 and a.jaqz688pope = b.jaqz689ope
                 and a.jaqz688psbo = b.jaqz689sbo
                 and a.jaqz688ptop = b.jaqz689top;
            exception
              when others then
                lc_pen := 'N';
            end;
          
            ln_promedio := to_number(substr(trim(lv_var1),
                                            10,
                                            length(trim(lv_var1))),
                                     '999999999999.99');
          
            if nvl(lc_pen, 'N') = 'N' then
              insert into jaqz690
                (jaqz690emp,
                 jaqz690mod,
                 jaqz690suc,
                 jaqz690mda,
                 jaqz690pap,
                 jaqz690cta,
                 jaqz690ope,
                 jaqz690sbo,
                 jaqz690top,
                 jaqz690fev,
                 jaqz690fvt,
                 jaqz690est,
                 jaqz690fep,
                 jaqz690ins,
                 jaqz690mor,
                 jaqz690seg)
              values
                (i.jaqz688emp,
                 i.jaqz688mod,
                 i.jaqz688suc,
                 i.jaqz688mda,
                 i.jaqz688pap,
                 i.jaqz688cta,
                 i.jaqz688ope,
                 i.jaqz688sbo,
                 i.jaqz688top,
                 ld_feceva,
                 ld_fvto,
                 i.jaqz688est,
                 pd_Fecpro,
                 i.jaqz688ax0,
                 ln_promedio,
                 ln_seg);
            
              commit;
            end if;
          
          end if;
          --end if;
        
        end if;
      
      end if;
    
    end loop;
  
  end Sp_cr_carga;

  procedure Sp_cr_historico(pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_flg    out char) is
  
    cursor usos is
    
      select a.r1cod,
             a.r1mod,
             a.r1suc,
             a.r1mda,
             a.r1pap,
             a.r1cta,
             a.r1oper,
             a.r1sbop,
             a.r1tope
        from fsr011 a
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116;
    ln_sdo  number(17, 2) := 0;
    lc_flgH char(1) := 'N';
    lc_flgD char(1) := 'N';
    lc_flgN char(1) := 'N';
  
    ld_mes1 date := add_months(pd_Fecpro, -1);
    ld_mes2 date := add_months(pd_Fecpro, -2);
    ld_mes3 date := add_months(pd_Fecpro, -3);
    ln_mto1 number(17, 2);
    ln_mto2 number(17, 2);
    ln_mto3 number(17, 2);
  begin
  
    for i in usos loop
    
      begin
        select a.bcsdmn
          into ln_mto1
          from fsh012 a
         where a.bcemp = i.r1cod
           and a.bcmod = i.r1mod
           and a.bcsuc = i.r1suc
           and a.bcmda = i.r1mda
           and a.bcpap = i.r1pap
           and a.bccta = i.r1cta
           and a.bcoper = i.r1oper
           and a.bcsbop = i.r1sbop
           and a.bctop = i.r1tope
           and a.bcfech = ld_mes1;
      exception
        when others then
          null;
      end;
    
      if nvl(ln_mto1, 0) = 0 then
        begin
          select a.bcsdmn
            into ln_mto2
            from fsh012 a
           where a.bcemp = i.r1cod
             and a.bcmod = i.r1mod
             and a.bcsuc = i.r1suc
             and a.bcmda = i.r1mda
             and a.bcpap = i.r1pap
             and a.bccta = i.r1cta
             and a.bcoper = i.r1oper
             and a.bcsbop = i.r1sbop
             and a.bctop = i.r1tope
             and a.bcfech = ld_mes2;
        exception
          when others then
            null;
        end;
      
        if nvl(ln_mto2, 0) = 0 then
          begin
            select a.bcsdmn
              into ln_mto3
              from fsh012 a
             where a.bcemp = i.r1cod
               and a.bcmod = i.r1mod
               and a.bcsuc = i.r1suc
               and a.bcmda = i.r1mda
               and a.bcpap = i.r1pap
               and a.bccta = i.r1cta
               and a.bcoper = i.r1oper
               and a.bcsbop = i.r1sbop
               and a.bctop = i.r1tope
               and a.bcfech = ld_mes3;
          exception
            when others then
              null;
          end;
        end if;
      
      end if;
      ln_sdo := (nvl(ln_mto1, 0) + nvl(ln_mto2, 0) + nvl(ln_mto3, 0));
      if ln_sdo <> 0 then
        exit;
      end if;
    
    end loop;
  
    if ln_sdo <> 0 then
      lc_flgH := 'S';
    end if;
  
    begin
      select 'S'
        into lc_flgD
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flgN
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if (lc_flgH = 'N' and lc_flgD = 'N') or nvl(lc_flgN, 'N') = 'N' then
      pc_flg := 'N';
    else
      pc_flg := 'S';
    end if;
  
  end Sp_cr_historico;

  Procedure Sp_cr_capital(pn_cta    in number,
                          pd_Fecpro in date,
                          pn_meses  out number) is
  
    cursor clientes is
      select a.pepais, a.petdoc, a.pendoc
        from fsr008 a
       where a.ctnro = pn_cta
         and a.cttfir = 'T';
  
    cursor cuentas(cn_pai in number, cn_tdo in number, cc_ndo in char) is
      select a.ctnro
        from fsr008 a
       where a.pepais = cn_pai
         and a.petdoc = cn_tdo
         and a.pendoc = cc_ndo
         and a.cttfir = 'T';
    ld_feccap date;
    ld_fecfin date;
    ld_fecant date;
  
  begin
  
    for i in clientes loop
      for j in cuentas(i.pepais, i.petdoc, i.pendoc) loop
        begin
          select max(aofval)
            into ld_feccap
            from fsd010 a
           where a.pgcod = 1
             and a.aocta = j.ctnro
             and a.aomod in (select tp1nro1
                               from fst198 a
                              where a.tp1cod = 1
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 2000
                                and a.tp1corr2 = 1);
        exception
          when others then
            null;
        end;
        if ld_fecfin is null then
          ld_fecfin := ld_feccap;
        else
          if ld_feccap > ld_fecant then
            ld_fecfin := ld_feccap;
          end if;
        end if;
        ld_fecant := ld_feccap;
      
      end loop;
    end loop;
  
    if ld_fecfin is not null then
      pn_meses := pd_fecpro - ld_fecfin;
    else
      pn_meses := 999;
    end if;
  
  end Sp_cr_capital;

  Procedure Sp_cr_segmentacion(pn_cta    in number,
                               pd_fecpro in date,
                               pn_ins    in number,
                               pn_seg    out number,
                               pc_flg    out char,
                               pn_segOri out number) is
  
    cursor fechas(cd_fecpro in date) is
      select fec_his
        from (select add_months(cd_fecpro, -1) fec_his
                from dual
              union
              select add_months(cd_fecpro, -2) fec_his
                from dual
              union
              select add_months(cd_fecpro, -3) fec_his
                from dual
              union
              select add_months(cd_fecpro, -4) fec_his
                from dual
              union
              select add_months(cd_fecpro, -5) fec_his
                from dual
              union
              select add_months(cd_fecpro, -6) fec_his
                from dual)
       order by fec_his desc;
  
    ln_pai    number(3);
    ln_tdo    number(3);
    lc_ndo    char(12);
    ln_seg    number(5);
    ln_segori number(5);
    lc_segOk  char(1);
    ln_segAct number(5);
    ld_Fecpro date;
    ld_FecAux date;
  
    LD_FECuLT date; --mod@abr 20200124
  
  begin
  
    ld_FecAux := last_day(pd_fecpro);
  
    if ld_FecAux = pd_fecpro then
      ld_Fecpro := pd_fecpro;
    else
      --ld_Fecpro := add_months(last_day(pd_fecpro), -1);
      ld_Fecpro :=  /*add_months(*/
       last_day(pd_fecpro); /*, -1)*/
    end if;
  
    begin
      select a.pepais, a.petdoc, a.pendoc
        into ln_pai, ln_tdo, lc_ndo
        from fsr008 a
       where a.pgcod = 1
         and a.ctnro = pn_cta
         and a.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    pq_cr_reporte_lineas.Sp_Segmento_Des(pn_ins, ln_segori);
  
    if ln_segori is not null then
      for i in fechas(ld_Fecpro) loop
        lc_segOk := 'N';
        begin
          select a.jaqy066calf
            into ln_seg
            from jaqy066 a
           where a.jaqy066paic = ln_pai
             and a.jaqy066tdoc = ln_tdo
             and a.jaqy066tndoc = lc_ndo
             and a.jaqy066fecp = i.fec_his;
        exception
          when others then
            null;
        end;
      
        begin
          select 'S'
            into lc_segOk
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 2000
             and a.tp1corr2 = 2
             and a.tp1nro1 = ln_segori
             and a.tp1nro2 = ln_seg;
        exception
          when others then
            lc_segOk := 'N';
        end;
      
        if lc_segOk = 'N' then
          pc_flg := 'S';
          exit;
        end if;
      
      end loop;
    else
      pc_flg := 'N';
    end if;
  
    if pc_flg is null then
      pc_flg := 'N';
    end if;
  
    if to_char(ld_FecAux, 'dd') = to_char(pd_fecpro, 'dd') then
      LD_FECuLT := pd_fecpro;
    else
    
      LD_FECuLT := add_months(last_day(pd_fecpro), -1);
    end if;
  
    begin
      select a.jaqy066calf
        into ln_segAct
        from jaqy066 a
       where a.jaqy066paic = ln_pai
         and a.jaqy066tdoc = ln_tdo
         and a.jaqy066tndoc = lc_ndo
         and a.jaqy066fecp = LD_FECuLT;
    exception
      when others then
        null;
    end;
  
    pn_segOri := ln_segori;
    pn_seg    := ln_segAct;
  
  end Sp_cr_segmentacion;

  Procedure Sp_Carga_Variables(pd_fecpro in date /*,P_C_DIGITO in number*/) is
  
    cursor creditos is
      select a.jaqz688emp pn_emp,
             a.jaqz688mod pn_mod,
             a.jaqz688suc pn_suc,
             a.jaqz688mda pn_mda,
             a.jaqz688pap pn_pap,
             a.jaqz688cta pn_cta,
             a.jaqz688ope pn_ope,
             a.jaqz688sbo pn_sbo,
             a.jaqz688top pn_top,
             a.jaqz688ax0 pn_ins
        from jaqz688 a
      --where a.jaqz688cta = 77340
      --and a.jaqz688ope = 2477112
      ;
  
    --lc_coderr varchar2(300);
    lc_hora char(8);
  
    ---
    lc_EsJudicial   varchar2(1);
    lc_Paralelo     char(1);
    ln_empP         number(3);
    ln_modP         number(3);
    ln_sucP         number(3);
    ln_mdaP         number(4);
    ln_papP         number(4);
    ln_ctaP         number(9);
    ln_opeP         number(9);
    ln_sboP         number(3);
    ln_topP         number(3);
    ln_promAtr      number(10, 2);
    ln_diaMax       number(10);
    lc_CalRCC       varchar2(1) := 'N';
    lc_ListaNegra   varchar2(1);
    ln_contBloqueos number(10);
    ln_Bloqueo_Vig  number(1);
    lc_BloqMora     varchar2(1);
    ln_pai          number(3);
    ln_tdo          number(2);
    lc_ndo          char(12);
    lc_Flag_Ex      char(1);
    lc_jaqz689VAR1  varchar2(100);
    lc_jaqz689VAR2  varchar2(100);
    lc_jaqz689VAR3  varchar2(100);
    lc_jaqz689VAR4  varchar2(100);
    lc_jaqz689VAR5  varchar2(100);
    lc_jaqz689VAR6  varchar2(100);
    lc_jaqz689VAR7  varchar2(100);
    lc_jaqz689VAR8  varchar2(100);
    lc_jaqz689VAR9  varchar2(100);
    lc_jaqz689VAR10 varchar2(100);
    lc_jaqz689VAR11 varchar2(100);
    lc_jaqz689VAR12 varchar2(100);
    ln_cal          number(5);
    lc_aplica       char(1);
    lc_EsJudicialF  varchar2(1);
    lc_segmentac    varchar2(30);
    ln_refinanc     number(6);
    lc_flgRefin     varchar2(1);
    lc_flgFall      varchar2(1);
    lc_tope         varchar2(1);
  begin
    /*update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/ --mod@abr 20171115
  
    begin
    
      --mod@abr 20171115
      execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
      Execute immediate ('Truncate table JAQZ689');
      --mod@abr 20171115
    
      for i in creditos loop
        lc_aplica      := 'N';
        lc_flgRefin    := 'N';
        lc_CalRCC      := 'N';
        lc_EsJudicialF := 'N';
        lc_ListaNegra  := 'N';
        lc_flgFall     := 'N';
        lc_tope        := 'N';
      
        begin
          select 'S'
            into lc_aplica
            from fst198
           where tp1cod = 1
             and Tp1cod1 = 10823
             and Tp1corr1 = 9
             and Tp1corr2 = 1
             and tp1nro1 = i.pn_top;
        exception
          when others then
            lc_aplica := 'N';
        end;
      
        if lc_aplica = 'N' then
        
          lc_Paralelo := 'N';
        
          begin
            select XWfEmpresa,
                   XWfModulo,
                   XWfSucursal,
                   XWfMoneda,
                   XWfPapel,
                   XWfCuenta,
                   XWfOperacion,
                   XWfSubope,
                   XWfTipOpe
              into ln_empP,
                   ln_modP,
                   ln_sucP,
                   ln_mdaP,
                   ln_papP,
                   ln_ctaP,
                   ln_opeP,
                   ln_sboP,
                   ln_topP
              from xwf700
             where XWFPRCINS = i.pn_ins
               and XWFCar3 <> '1';
          exception
            when others then
              null;
          end;
        
          Begin
            select 'S'
              into lc_Paralelo
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 20001
               and Tp1corr1 = 1
               and Tp1corr2 = 1211
               and Tp1corr3 = i.pn_top
               and Tp1nro1 = ln_topP;
          exception
            when others then
              lc_Paralelo := 'N';
          end;
        
          begin
            select pepais, petdoc, pendoc
              into ln_pai, ln_tdo, lc_ndo
              from fsr008 a
             where ctnro = i.pn_cta
               and cttfir = 'T';
          exception
            when no_data_found then
              begin
                select pepais, petdoc, pendoc
                  into ln_pai, ln_tdo, lc_ndo
                  from fsr008 a
                 where ctnro = i.pn_cta;
              exception
                when no_data_found then
                  null;
                
              end;
            
          end;
          --Segmentacion
          pq_cr_resolutor_sbs.sp_cr_segmentacion(pn_ins  => i.pn_ins,
                                                 pc_segm => lc_segmentac);
        
          --Refinanciado
          pQ_CR_CONTREFINLINEA.sp_cr_verifrefinanciado(ln_Instancia => i.pn_ins,
                                                       ln_respuesta => ln_refinanc);
        
          --fALLECIDO
          pq_cr_reporte_lineas.Sp_cr_fallecido(i.pn_ins, lc_flgFall);
        
          --tipo de operacion
          pq_cr_reporte_lineas.Sp_cr_TipoOper(i.pn_ins, lc_tope);
        
          if ln_refinanc = 0 then
            pQ_CR_CONTREFINLINEA.sp_cr_rccrefinanciado(ln_Instancia => i.pn_ins,
                                                       ln_respuesta => ln_refinanc);
          end if;
          if ln_refinanc = 0 then
            lc_flgRefin := 'N';
          else
            lc_flgRefin := 'S';
          end if;
        
          --DIAS DE ATRASO
          pq_cr_relcrediticia.sp_diasatrasolineas(i.pn_emp,
                                                  i.pn_mod,
                                                  i.pn_suc,
                                                  i.pn_mda,
                                                  i.pn_pap,
                                                  i.pn_cta,
                                                  i.pn_ope,
                                                  i.pn_sbo,
                                                  i.pn_top,
                                                  pd_fecpro,
                                                  i.pn_ins,
                                                  ln_promAtr);
        
          --Mora Maxima 
          pq_cr_relcrediticia.sp_moramaxcuotas(i.pn_cta,
                                               pd_fecpro,
                                               ln_diaMax);
        
          --Judicial
          pq_cr_relcrediticia.sp_judicast(i.pn_cta,
                                          i.pn_ins,
                                          lc_EsJudicial);
          if lc_EsJudicial <> 'S' then
            lc_EsJudicialF := 'N';
          else
            lc_EsJudicialF := 'S';
          end if;
        
          --Calificacion RCC
          lc_CalRCC := 'N';
          pq_cr_relcrediticia.sp_calificacion_rcc(i.pn_cta,
                                                  i.pn_emp,
                                                  i.pn_mod,
                                                  i.pn_suc,
                                                  i.pn_mda,
                                                  i.pn_pap,
                                                  i.pn_cta,
                                                  i.pn_ope,
                                                  i.pn_sbo,
                                                  i.pn_top,
                                                  lc_CalRCC);
        
          --paralelo
          if lc_Paralelo = 'S' and lc_CalRCC = 'N' then
            pq_cr_relcrediticia.sp_calificacion_rcc(ln_ctaP,
                                                    ln_empP,
                                                    ln_modP,
                                                    ln_sucP,
                                                    ln_mdaP,
                                                    ln_papP,
                                                    ln_ctaP,
                                                    ln_opeP,
                                                    ln_sboP,
                                                    ln_topP,
                                                    lc_CalRCC);
          
          end if;
        
          --Lista Negra
          pq_cr_relcrediticia.sp_listas_negras(i.pn_cta, lc_ListaNegra);
        
          --Numero de bloqueos
          pq_cr_relcrediticia.sp_conteo_bloqueos(ln_pai,
                                                 ln_tdo,
                                                 lc_ndo,
                                                 1,
                                                 ln_contBloqueos);
        
          --Bloqueo vigente
          pq_cr_relcrediticia.sp_bloqueo_vigente(ln_pai,
                                                 ln_tdo,
                                                 lc_ndo,
                                                 pd_fecpro,
                                                 i.pn_cta,
                                                 i.pn_ope,
                                                 ln_Bloqueo_Vig);
        
          lc_BloqMora := 'N';
          if ln_Bloqueo_Vig = 0 then
          
            pq_cr_relcrediticia.sp_bloqueomora(ln_pai,
                                               ln_tdo,
                                               lc_ndo,
                                               lc_BloqMora,
                                               lc_Flag_Ex);
          end if;
        
          if ln_promAtr = 0 then
            lc_jaqz689VAR1 := 'PROM_ATR=0.00';
          else
            case
              when ln_promAtr < 1 and ln_promAtr > 0 then
                lc_jaqz689VAR1 := 'PROM_ATR=' || '0' ||
                                  TRIM(TO_CHAR(ln_promAtr));
              else
                lc_jaqz689VAR1 := 'PROM_ATR=' || TRIM(TO_CHAR(ln_promAtr));
            end case;
          end if;
          lc_jaqz689VAR2  := 'MOR_MAX' || '=' || trim(to_char(ln_diaMax));
          lc_jaqz689VAR3  := 'JUD_CAST' || '=' || trim(lc_EsJudicialF);
          lc_jaqz689VAR4  := 'CAL_RCC_LIN' || '=' || trim(lc_CalRCC);
          lc_jaqz689VAR5  := 'LIST_NG' || '=' || trim(lc_ListaNegra);
          lc_jaqz689VAR6  := 'CANT_BLOQ' || '=' ||
                             trim(to_char(ln_contBloqueos));
          lc_jaqz689VAR7  := 'BLOQ_VIG' || '=' ||
                             trim(to_char(ln_Bloqueo_Vig));
          lc_jaqz689VAR8  := 'BLOQ_MOR' || '=' || trim(lc_BloqMora);
          lc_jaqz689VAR9  := 'SEGMENTACION_WF' || '=' || trim(lc_segmentac);
          lc_jaqz689VAR10 := 'EVAREFINAN' || '=' || trim(lc_flgRefin);
          lc_jaqz689VAR11 := 'FALLECIDO' || '=' || trim(lc_flgFall);
          lc_jaqz689VAR12 := 'GUIA_TIPOPER' || '=' || trim(lc_tope);
        
          ln_cal  := 0;
          lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
        
          begin
            insert into jaqz689
              (jaqz689FECH,
               jaqz689EMP,
               jaqz689MOD,
               jaqz689SUC,
               jaqz689MDA,
               jaqz689PAP,
               jaqz689CTA,
               jaqz689OPE,
               jaqz689SBO,
               jaqz689TOP,
               jaqz689HORA,
               jaqz689CCAL,
               jaqz689VAR1,
               jaqz689VAR2,
               jaqz689VAR3,
               jaqz689VAR4,
               jaqz689VAR5,
               jaqz689VAR6,
               jaqz689VAR7,
               jaqz689VAR8,
               jaqz689VAR9,
               jaqz689VAR10,
               jaqz689VAR11,
               jaqz689VAR12)
            values
              (pd_fecpro,
               i.pn_emp,
               i.pn_mod,
               i.pn_suc,
               i.pn_mda,
               i.pn_pap,
               i.pn_cta,
               i.pn_ope,
               i.pn_sbo,
               i.pn_top,
               lc_hora,
               ln_cal,
               lc_jaqz689VAR1,
               lc_jaqz689VAR2,
               lc_jaqz689VAR3,
               lc_jaqz689VAR4,
               lc_jaqz689VAR5,
               lc_jaqz689VAR6,
               lc_jaqz689VAR7,
               lc_jaqz689VAR8,
               lc_jaqz689VAR9,
               lc_jaqz689VAR10,
               lc_jaqz689VAR11,
               lc_jaqz689VAR12);
          
            commit;
          exception
            when others then
              null;
            
          end;
        
        end if;
      
      end loop;
      /* update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 =  P_C_DIGITO
         and g.c_codage = 'L1';
      commit; */ --mod@abr 20171115
    
    end;
  
  EXCEPTION
    when others then
      null;
      --lc_coderr := substr(sqlerrm, 1, 200);
    /*update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/ --mod@abr 20171115
  
  end Sp_Carga_Variables;

  procedure sp_cr_RNG1701(P_D_FECPRO in date /*, 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             P_C_DIGITO in varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             PC_USR in varchar2*/) IS
  
    cursor c_clientes /*(p_fecpro date)*/
    is
      select /*+all_rows index_ss(l)*/
       l.jaqz688emp,
       l.jaqz688mod,
       l.jaqz688suc,
       l.jaqz688mda,
       l.jaqz688pap,
       l.jaqz688cta,
       l.jaqz688ope,
       l.jaqz688sbo,
       l.jaqz688top
        from jaqz688 l;
  
    cursor c_reglas is
    
      select /*+ALL_ROWS*/
       g.RNG50ORD,
       t.RNG49COD,
       t.RNG50GRP,
       t.RNG51COD,
       t.RNG68COD,
       t.RNG51OPE,
       t.RNG51VAL,
       a.RNG68ATR,
       a.RNG68TDA,
       g.RNG50Ret
        from FRNG50 g
       inner join frng51 t
          on g.rng49cod = t.rng49cod
         and g.rng50grp = t.rng50grp
       inner join frng68 a
          on t.rng49cod = a.rng49cod
         and t.rng68cod = a.rng68cod
      --          where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
       where t.RNG49Cod = 1701
       order by g.RNG49COD, g.RNG50ORD, t.RNG50GRP, t.RNG51COD;
  
    Regla         frng51.rng49cod%type;
    SegmentoRegla frng50.rng50ret%type;
    la_nomvar     pq_cr_reporte_lineas.tp_nomvar;
    la_valvar     pq_cr_reporte_lineas.tp_valvar;
    la_nomnul     pq_cr_reporte_lineas.tp_nomvar;
    la_valnul     pq_cr_reporte_lineas.tp_valvar;
    ln_var        number(3) := 0;
  
    l_JAQZ688PDPE JAQZ688_PEN.JAQZ688DPE%type;
    l_JAQZ688PPEN JAQZ688_PEN.JAQZ688PPEN%type;
    l_JAQZ688Pemp JAQZ688_PEN.JAQZ688PEMP%type;
    l_JAQZ688Pmod JAQZ688_PEN.JAQZ688PMOD%type;
    l_JAQZ688Psuc JAQZ688_PEN.JAQZ688PSUC%type;
    l_JAQZ688Pmda JAQZ688_PEN.JAQZ688PMDA%type;
    l_JAQZ688Ppap JAQZ688_PEN.JAQZ688PPAP%type;
    l_JAQZ688Pcta JAQZ688_PEN.JAQZ688PCTA%type;
    l_JAQZ688Pope JAQZ688_PEN.JAQZ688POPE%type;
    l_JAQZ688Psbo JAQZ688_PEN.JAQZ688PSBO%type;
    l_JAQZ688Ptop JAQZ688_PEN.JAQZ688PTOP%type;
  
    TYPE tp_emp IS TABLE OF JAQZ689.JAQZ689emp%type INDEX BY BINARY_INTEGER;
    TYPE tp_mod IS TABLE OF JAQZ689.JAQZ689mod%type INDEX BY BINARY_INTEGER;
    TYPE tp_suc IS TABLE OF JAQZ689.JAQZ689suc%type INDEX BY BINARY_INTEGER;
    TYPE tp_mda IS TABLE OF JAQZ689.JAQZ689mda%type INDEX BY BINARY_INTEGER;
    TYPE tp_pap IS TABLE OF JAQZ689.JAQZ689pap%type INDEX BY BINARY_INTEGER;
    TYPE tp_cta IS TABLE OF JAQZ689.JAQZ689cta%type INDEX BY BINARY_INTEGER;
    TYPE tp_ope IS TABLE OF JAQZ689.JAQZ689ope%type INDEX BY BINARY_INTEGER;
    TYPE tp_sbo IS TABLE OF JAQZ689.JAQZ689sbo%type INDEX BY BINARY_INTEGER;
    TYPE tp_top IS TABLE OF JAQZ689.JAQZ689top%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ689emp tp_emp;
    la_JAQZ689mod tp_mod;
    la_JAQZ689suc tp_suc;
    la_JAQZ689mda tp_mda;
    la_JAQZ689pap tp_pap;
    la_JAQZ689cta tp_cta;
    la_JAQZ689ope tp_ope;
    la_JAQZ689sbo tp_sbo;
    la_JAQZ689top tp_top;
  
    la_reglas pq_cr_reporte_lineas.tb_reglas;
    ln_reg    number(5);
    lc_aplica char(1);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
    execute immediate ('truncate table JAQZ688_PEN');
    Regla := 1701;
  
    -- Cargar reglas
    ln_reg := 0;
    for r in c_reglas loop
      ln_reg := ln_reg + 1;
      la_reglas(ln_reg).RNG49COD := r.rng49cod;
      la_reglas(ln_reg).RNG50GRP := r.rng50grp;
      la_reglas(ln_reg).RNG51COD := r.rng51cod;
      la_reglas(ln_reg).RNG68COD := r.rng68cod;
      la_reglas(ln_reg).RNG51OPE := r.rng51ope;
      la_reglas(ln_reg).RNG51VAL := r.rng51val;
      la_reglas(ln_reg).RNG68ATR := r.rng68atr;
      la_reglas(ln_reg).RNG68TDA := r.rng68tda;
      la_reglas(ln_reg).RNG50Ret := r.rng50ret;
    end loop;
  
    OPEN c_clientes /*(P_D_FECPRO)*/
    ; -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ689emp,
           la_JAQZ689mod,
           la_JAQZ689suc,
           la_JAQZ689mda,
           la_JAQZ689pap,
           la_JAQZ689cta,
           la_JAQZ689ope,
           la_JAQZ689sbo,
           la_JAQZ689top;
  
    IF la_JAQZ689cta.count > 0 THEN
      FOR c IN la_JAQZ689cta.FIRST .. la_JAQZ689cta.LAST LOOP
        lc_aplica := 'N';
        begin
          select 'S'
            into lc_aplica
            from fst198
           where Tp1cod = 1 --mod@abr 20170601 optimizacion 
             and Tp1cod1 = 10823
             and Tp1corr1 = 9
             and Tp1corr2 = 1
             and tp1nro1 = la_JAQZ689top(c);
        exception
          when others then
            lc_aplica := 'N';
        end;
        l_JAQZ688Pemp := la_JAQZ689emp(c);
        l_JAQZ688Pmod := la_JAQZ689mod(c);
        l_JAQZ688Psuc := la_JAQZ689suc(c);
        l_JAQZ688Pmda := la_JAQZ689mda(c);
        l_JAQZ688Ppap := la_JAQZ689pap(c);
        l_JAQZ688Pcta := la_JAQZ689cta(c);
        l_JAQZ688Pope := la_JAQZ689ope(c);
        l_JAQZ688Psbo := la_JAQZ689sbo(c);
        l_JAQZ688Ptop := la_JAQZ689top(c);
        if lc_aplica = 'N' then
          la_nomvar := la_nomnul;
          la_valvar := la_valnul;
          PQ_CR_REPORTE_LINEAS.sp_cr_cargar_variables(p_d_fecpro => P_D_FECPRO,
                                                      pn_emp     => la_JAQZ689emp(c),
                                                      pn_mod     => la_JAQZ689mod(c),
                                                      pn_suc     => la_JAQZ689suc(c),
                                                      pn_mda     => la_JAQZ689mda(c),
                                                      pn_pap     => la_JAQZ689pap(c),
                                                      pn_cta     => la_JAQZ689cta(c),
                                                      pn_ope     => la_JAQZ689ope(c),
                                                      pn_sbo     => la_JAQZ689sbo(c),
                                                      pn_top     => la_JAQZ689top(c),
                                                      p_a_nomvar => la_nomvar,
                                                      p_a_valvar => la_valvar,
                                                      p_n_var    => ln_var);
        
          SegmentoRegla := null;
          PQ_CR_REPORTE_LINEAS.sp_cr_evalua_clientes_1(P_N_REGLA   => Regla,
                                                       P_A_NOMVAR  => la_nomvar,
                                                       P_A_VALVAR  => la_valvar,
                                                       P_N_VAR     => ln_var,
                                                       P_A_REGLAS  => la_reglas,
                                                       P_N_REG     => ln_reg,
                                                       p_c_retorno => SegmentoRegla);
        
          l_JAQZ688PDPE := Trim(SegmentoRegla);
          If substr(Trim(SegmentoRegla), 1, 1) = '0' then
            l_JAQZ688PPEN := 'N';
          else
            l_JAQZ688PPEN := 'S';
          end if;
        
          insert into JAQZ688_PEN
            (JAQZ688PEMP,
             JAQZ688PMOD,
             JAQZ688PSUC,
             JAQZ688PMDA,
             JAQZ688PPAP,
             JAQZ688PCTA,
             JAQZ688POPE,
             JAQZ688PSBO,
             JAQZ688PTOP,
             JAQZ688PFEP,
             JAQZ688PPEN,
             JAQZ688DPE)
          VALUES
            (l_JAQZ688Pemp,
             l_JAQZ688Pmod,
             l_JAQZ688Psuc,
             l_JAQZ688Pmda,
             l_JAQZ688Ppap,
             l_JAQZ688Pcta,
             l_JAQZ688Pope,
             l_JAQZ688Psbo,
             l_JAQZ688Ptop,
             P_D_FECPRO,
             l_JAQZ688PPEN,
             l_JAQZ688PDPE);
        
          commit;
        else
          l_JAQZ688PDPE := '0;SIN RESTRICCION';
          l_JAQZ688PPEN := 'N';
          insert into JAQZ688_PEN
            (JAQZ688PEMP,
             JAQZ688PMOD,
             JAQZ688PSUC,
             JAQZ688PMDA,
             JAQZ688PPAP,
             JAQZ688PCTA,
             JAQZ688POPE,
             JAQZ688PSBO,
             JAQZ688PTOP,
             JAQZ688PFEP,
             JAQZ688PPEN,
             JAQZ688DPE)
          VALUES
            (l_JAQZ688Pemp,
             l_JAQZ688Pmod,
             l_JAQZ688Psuc,
             l_JAQZ688Pmda,
             l_JAQZ688Ppap,
             l_JAQZ688Pcta,
             l_JAQZ688Pope,
             l_JAQZ688Psbo,
             l_JAQZ688Ptop,
             P_D_FECPRO,
             l_JAQZ688PPEN,
             l_JAQZ688PDPE);
        
          commit;
        end if;
      END LOOP; -- clientes
    END IF;
  
  end sp_cr_RNG1701;

  procedure sp_cr_cargar_variables(P_D_FECPRO IN DATE,
                                   PN_EMP     IN JAQZ689.JAQZ689EMP%type,
                                   PN_MOD     IN JAQZ689.JAQZ689MOD%type,
                                   PN_SUC     IN JAQZ689.JAQZ689SUC%type,
                                   PN_MDA     IN JAQZ689.JAQZ689MDA%type,
                                   PN_PAP     IN JAQZ689.JAQZ689PAP%type,
                                   PN_CTA     IN JAQZ689.JAQZ689CTA%type,
                                   PN_OPE     IN JAQZ689.JAQZ689OPE%type,
                                   PN_SBO     IN JAQZ689.JAQZ689SBO%type,
                                   PN_TOP     IN JAQZ689.JAQZ689TOP%type,
                                   p_a_nomvar out pq_cr_reporte_lineas.tp_nomvar,
                                   p_a_valvar out pq_cr_reporte_lineas.tp_valvar,
                                   p_n_var    out number) is
  
    cursor c_cliente is
      select JAQZ689fech,
             JAQZ689EMP,
             JAQZ689MOD,
             JAQZ689SUC,
             JAQZ689MDA,
             JAQZ689pap,
             JAQZ689cta,
             JAQZ689ope,
             JAQZ689sbo,
             JAQZ689top,
             JAQZ689var1,
             JAQZ689var2,
             JAQZ689var3,
             JAQZ689var4,
             JAQZ689var5,
             JAQZ689var6,
             JAQZ689var7,
             JAQZ689var8,
             JAQZ689var9,
             JAQZ689var10,
             JAQZ689var11,
             JAQZ689var12,
             JAQZ689var13,
             JAQZ689var14,
             JAQZ689var15,
             JAQZ689var16,
             JAQZ689var17,
             JAQZ689var18,
             JAQZ689var19,
             JAQZ689var20,
             JAQZ689var21,
             JAQZ689var22,
             JAQZ689var23,
             JAQZ689var24,
             JAQZ689var25,
             JAQZ689var26,
             JAQZ689var27,
             JAQZ689var28,
             JAQZ689var29,
             JAQZ689var30,
             JAQZ689var31,
             JAQZ689var32,
             JAQZ689var33,
             JAQZ689var34,
             JAQZ689var35,
             JAQZ689var36,
             JAQZ689var37,
             JAQZ689var38,
             JAQZ689var39,
             JAQZ689var40
        from JAQZ689 A
       where A.JAQZ689FECH = P_D_FECPRO
         and A.JAQZ689EMP = PN_EMP
         and A.JAQZ689MOD = PN_MOD
         and A.JAQZ689SUC = PN_SUC
         and A.JAQZ689MDA = PN_MDA
         and a.JAQZ689pap = PN_PAP
         and a.JAQZ689cta = PN_CTA
         and a.JAQZ689ope = PN_OPE
         and a.JAQZ689sbo = PN_SBO
         and a.JAQZ689top = PN_TOP;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.JAQZ689var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.JAQZ689var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.JAQZ689var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.JAQZ689var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.JAQZ689var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.JAQZ689var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.JAQZ689var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.JAQZ689var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.JAQZ689var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.JAQZ689var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.JAQZ689var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.JAQZ689var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.JAQZ689var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.JAQZ689var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.JAQZ689var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.JAQZ689var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.JAQZ689var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.JAQZ689var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.JAQZ689var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.JAQZ689var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.JAQZ689var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.JAQZ689var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.JAQZ689var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.JAQZ689var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.JAQZ689var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.JAQZ689var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.JAQZ689var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.JAQZ689var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.JAQZ689var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.JAQZ689var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.JAQZ689var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.JAQZ689var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.JAQZ689var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.JAQZ689var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.JAQZ689var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.JAQZ689var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.JAQZ689var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.JAQZ689var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.JAQZ689var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.JAQZ689var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.JAQZ689var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.JAQZ689var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.JAQZ689var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.JAQZ689var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables;

  procedure sp_cr_evalua_clientes_1(P_N_REGLA   IN NUMBER,
                                    P_A_NOMVAR  IN pq_cr_reporte_lineas.tp_nomvar,
                                    P_A_VALVAR  IN pq_cr_reporte_lineas.tp_valvar,
                                    P_N_VAR     IN number,
                                    P_A_REGLAS  in pq_cr_reporte_lineas.tb_reglas,
                                    P_N_REG     in number,
                                    p_c_retorno out varchar2) IS
  
    cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
      select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
        from FRNG67
       where RNG49Cod = p_RNG49Cod
         and RNG50Grp = p_RNG50Grp
         and RNG51COD = p_RNG51COD
       order by RNG67COR;
  
    ExisteGrupo   char(1) := null;
    ResReglaGrupo char(1) := null;
    ResReglaLista char(1) := null;
    Regla         frng51.rng49cod%type;
    --Regla2 frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      pq_cr_reporte_lineas.tp_nomvar;
    la_valvar      pq_cr_reporte_lineas.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    --SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_reporte_lineas.tb_reglas;
    ln_reg     number(5);
    ln_ind     number(5);
  
  BEGIN
  
    Regla     := nvl(P_N_REGLA, 0);
    la_nomvar := p_a_nomvar;
    la_valvar := p_a_valvar;
    ln_var    := nvl(p_n_var, 0);
    la_reglas := P_A_REGLAS;
    ln_reg    := nvl(P_N_REG, 0);
  
    For reg in 1 .. ln_reg loop
      If la_reglas(reg).RNG49COD = Regla then
        l_RNG50Ret  := la_reglas(reg).RNG50Ret;
        l_RNG50Grp  := la_reglas(reg).RNG50GRP;
        ExisteGrupo := 'S';
        ln_ind      := reg;
        Exit;
      End If;
    End loop;
  
    If ExisteGrupo = 'S' then
      --existe grupo
    
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then
          --evaluar cambio de grupo
          --Msg('Diferente grupo')
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then
            --Retorno Default (Condición ELSE)
            --Msg('Retorno Default (Condición ELSE)')
            p_c_retorno := la_reglas(ln_ind).RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)                         
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            --se cumple la regla para el grupo anterior
            --Msg('grupo cumplido')
            p_c_retorno := l_RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)
            Exit;
          Else
            --evaluar el siguiente grupo de la regla
            --Msg('cambio de grupo')
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
            --Msg('grupo : '+Str(RNG50Grp))
            ResReglaGrupo := 'S';
            --Do 'Limpiar VExpresion'
          End If;
        End If;
      
        -- Encontrar valor resuelto de atributo
        lc_valResuelto := '0';
        For i in 1 .. ln_var loop
          If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
            lc_valResuelto := trim(la_valvar(i));
            Exit;
          End If;
        End loop;
      
        -- Resolver Regla anidada Nivel 2
        --                If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
        --If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
      
        --Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
        --Msg('rutina regla anidada ' + Str(&Regla2))
        --SegmentoRegla2 := null;
        --PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS( P_N_REGLA => Regla2,
        --                                                     P_A_NOMVAR => la_nomvar,
        --                                                     P_A_VALVAR => la_valvar, 
        --                                                    P_N_VAR => ln_var,
        --                                                    P_A_REGLAS => la_reglas,
        --                                                    P_N_REG => ln_reg,
        --                                                    p_c_retorno => SegmentoRegla2);
        --lc_valResuelto := Trim(SegmentoRegla2);
      
        -- End If;
      
        -- Evaluacion de condiciones
        l_RNG51Val := nvl(trim(la_reglas(ln_ind).RNG51VAL), '0');
      
        if lc_valResuelto = '100' then
          lc_valResuelto := '100.00';
        end if;
        if l_RNG51Val = '100' then
          l_RNG51Val := '100.00';
        end if;
      
        l_RNG51OPE := trim(la_reglas(ln_ind).RNG51OPE);
        Case l_RNG51OPE
          When '>=' then
            --Msg('es mayor igual que ' + l_RNG51Val)
            --Msg(ValResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            --Msg('es mayor que ' + l_RNG51Val)
            --Msg(lc_lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            --Msg('es menor igual que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              --to_number(lc_valResuelto) > to_number(l_RNG51Val)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            --Msg('es menor que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
              --to_number(lc_valResuelto) >= to_number(reg.RNG51VAL)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '=' then
            --Msg('es igual que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)                 
            If lc_valResuelto <> l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When 'EN' then
            ResReglaLista := 'N';
            -- valores de evaluacion lista
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'N' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When 'NE' then
            ResReglaLista := 'N';
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('NO esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'S' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          Else
            ResReglaGrupo := 'N'; --faltan variaciones de like y not like
        
        End Case;
      
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1;

  Procedure Sp_cr_fallecido(pn_ins in number, pc_flg out char) is
    ln_pai number(3);
    ln_tdo number(2);
    ln_ndo char(12);
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(3);
    ln_pap number(3);
    ln_cta number(3);
    ln_ope number(3);
    ln_sbo number(3);
    ln_top number(3);
    lc_flg char(1);
  
    cursor clientes(cn_cta in number) is
      select pepais, petdoc, pendoc
        from fsr008
       where pgcod = 1
         and ctnro = cn_cta
         and Ttcod = 1;
  
  begin
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, ln_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    lc_flg := 'N';
    for i in clientes(ln_cta) loop
      begin
        select 'S'
          into lc_flg
          from jaqz090 a
         where a.jaqz090pai = i.pepais
           and a.jaqz090tdo = i.petdoc
           and a.jaqz090ndo = i.pendoc
           and JAQZ090CVA = 56
           and JAQZ090MOT = 'FALLECIDO'
           and rownum = 1;
      exception
        when others then
          lc_flg := 'N';
      end;
    
      if nvl(lc_flg, 'N') = 'N' then
        begin
          select 'S'
            into lc_flg
            from fsd002 a
           where a.pfpais = i.pepais
             and a.pftdoc = i.petdoc
             and a.pfndoc = i.pendoc
             and (Pfffal is not null)
             and (Pfffal <> to_date('01/01/0001', 'dd/mm/yyyy'))
             and rownum = 1;
        exception
          when others then
            lc_flg := 'N';
        end;
      end if;
    
      if lc_flg = 'S' then
        exit;
      end if;
    
    end loop;
  
    pc_flg := lc_flg;
  
  end Sp_cr_fallecido;

  Procedure Sp_cr_TipoOper(pn_ins in number, pc_flg out char) is
  
    ln_top number(3);
    lc_flg char(1);
  
  begin
  
    begin
      select a.xwftipope
        into ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.tp1corr1 = 9
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_top
         and rownum = 1;
    exception
      when others then
        lc_flg := 'N';
    end;
  
    pc_flg := lc_flg;
  
  end Sp_cr_TipoOper;

  Procedure Sp_Cr_Variables(pn_ins    in number,
                            pn_emp    in number,
                            pn_mod    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pn_top    in number,
                            pd_fecpro in date,
                            pc_vgt    out char,
                            pn_mec    out number,
                            pn_cal    out number,
                            pn_vto    out number,
                            pn_cap    out number,
                            pc_seg    out char,
                            pn_segAct out number,
                            pn_segOri out number) is
  
    cursor lineas is
      select *
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat = 99;
  
    cursor instancias(cn_cta in number) is
      select sng001inst,
             b.xwfempresa,
             b.xwfmodulo,
             b.xwfsucursal,
             b.xwfmoneda,
             b.xwfpapel,
             b.xwfcuenta,
             b.xwfoperacion,
             b.xwfsubope,
             b.xwftipope
        from sng001 a, xwf700 b
       where a.sng001cta = cn_cta
         and a.sng001inst = b.xwfprcins
         and b.xwfcar3 = '1';
  
    lc_flg       char(1) := 'N';
    ln_meses     number(10) := 0;
    ln_mesesAnt  number(10) := 0;
    ln_mesesTot  number(10) := 0;
    lc_flgNU     char(1) := 'S';
    ld_feceva    date;
    lc_flgCont   char(1) := 'N';
    ln_modelo    number(4);
    ld_fecMax    date;
    ln_max       number(9);
    ln_pai       number(3);
    ln_tdo       number(2);
    lc_ndo       char(12);
    ld_fecPanel  date;
    ln_dias      number(10) := 0;
    ln_Indicador number(1);
    ld_FecAuxPy  date;
    ld_fvto      date;
    ln_diasVto   number(10) := 0;
    ln_diasCap   number(10);
    ln_segAct    number(5);
    lc_flgSeg    char(1);
    ln_segOri    number(5);
  
  begin
  
    --116_vigente
    begin
      select 'S'
        into lc_flg
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat = 0
         and rownum = 1;
    
    exception
      when others then
        lc_flg := 'N';
    end;
  
    --meses_canc
    for i in lineas loop
      ln_meses := pd_Fecpro - i.aofe99;
    
      if ln_meses > ln_mesesAnt then
        ln_mesesTot := ln_meses;
      else
        ln_mesesTot := ln_mesesAnt;
      end if;
      ln_mesesAnt := ln_meses;
    end loop;
  
    lc_flgNU := 'S';
    begin
      select 'N'
        into lc_flgNU
        from fsr011 a, fsd010 b
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 46
         and a.r1mod = 116
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and rownum = 1;
    
    exception
      when others then
        lc_flgNU := 'S';
    end;
  
    if lc_flgNU = 'S' or nvl(ln_mesesTot, 0) = 0 then
      --linea no usada
      ln_mesesTot := 999;
    end if;
  
    --califica evaluacion
  
    for i in instancias(pn_cta) loop
      lc_flgCont := 'N';
      begin
        select 'S'
          into lc_flgCont
          from fsd010 c
         where c.pgcod = i.xwfempresa
           and c.aomod = i.xwfmodulo
           and c.aosuc = i.xwfsucursal
           and c.aomda = i.xwfmoneda
           and c.aopap = i.xwfpapel
           and c.aocta = i.xwfcuenta
           and c.aooper = i.xwfoperacion
           and c.aosbop = i.xwfsubope
           and c.aotope = i.xwftipope
           and rownum = 1;
      
      exception
        when others then
          lc_flgCont := 'N';
      end;
    
      if lc_flgCont = 'N' then
        lc_flgCont := 'S';
        begin
          select 'N'
            into lc_flgCont
            from sng120 a
           where a.sng120ins = i.sng001inst
             and a.sng120tsk = 'SOLICITUD'
             and rownum = 1;
        exception
          when others then
            lc_flgCont := 'S';
        end;
      end if;
    
      if lc_flgCont = 'S' then
        begin
          select a.sng021tmod
            into ln_modelo
            from sng021 a
           where a.sng021sol = i.sng001inst;
        exception
          when others then
            null;
        end;
      
        if ln_modelo = 13 then
        
          begin
            select a.SNG120FPag
              into ld_fecEva
              from sng120 a
             where a.sng120ins = i.sng001inst
               and a.sng120tsk = 'EVALUACION';
          exception
            when others then
              null;
          end;
        
        else
          begin
            select a.SNG120FVal
              into ld_fecEva
              from sng120 a
             where a.sng120ins = i.sng001inst
               and a.sng120tsk = 'EVALUACION';
          exception
            when others then
              null;
          end;
        end if;
      
      end if;
    
      If ld_fecMax is null then
        ld_fecMax := ld_fecEva;
      Else
        If ld_fecEva > ld_fecMax then
          ld_fecMax := ld_fecEva;
        End If;
      end if;
    
    end loop;
  
    begin
      select Tp1nro1
        into ln_max
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 11
         and Tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    ln_Indicador := 0;
  
    begin
      select 1
        into ln_Indicador
        from fst198 a
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 14
         and Tp1corr2 = 1
         and Tp1nro1 = pn_top
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqz515fee
        into ld_fecPanel
        from jaqz515 a
       where a.jaqz515pai = ln_pai
         and a.jaqz515tdo = ln_tdo
         and a.jaqz515ndo = lc_ndo;
    
    exception
      when others then
        null;
    end;
  
    if ld_fecPanel > ld_fecMax then
      ld_fecMax := ld_fecPanel;
    end if;
  
    ld_FecAuxPy := add_months(ld_fecMax, ln_max);
    ln_dias     := ld_FecAuxPy - pd_Fecpro;
  
    --fecha de vencimiento
    begin
      select a.aofvto
        into ld_fvto
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    ln_diasVto := ld_fvto - pd_Fecpro;
  
    --capital de trabajo
    ln_diasCap := 0;
    pq_Cr_reporte_lineas.Sp_cr_capital(pn_cta    => pn_cta,
                                       pd_Fecpro => pd_fecpro,
                                       pn_meses  => ln_diasCap);
  
    --segmentacion                                   
    lc_flgSeg := 'N';
    ln_segAct := 0;
    ln_segOri := 0;
    pq_Cr_reporte_lineas.Sp_cr_segmentacion(pn_cta    => pn_cta,
                                            pd_fecpro => pd_fecpro,
                                            pn_ins    => pn_ins,
                                            pn_seg    => ln_segAct,
                                            pc_flg    => lc_flgSeg,
                                            pn_segOri => ln_segOri);
  
    pc_vgt    := nvl(lc_flg, 'N');
    pn_mec    := nvl(ln_mesesTot, 999);
    pn_cal    := nvl(ln_dias, 0);
    pn_vto    := nvl(ln_diasVto, 0);
    pn_cap    := nvl(ln_diasCap, 0);
    pc_seg    := nvl(lc_flgSeg, 'N');
    pn_segAct := ln_segAct;
    pn_segOri := ln_segOri;
  
  end Sp_Cr_Variables;

  Procedure Sp_Segmento_Des(pn_ins in number, pn_seg out number) is
    lc_segmentacion char(30);
  
  begin
    begin
      select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
        into lc_segmentacion
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 380
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
            into lc_segmentacion
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 380
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 1
             and n.pae70nro =
                 (select max(aa.pae70nro)
                    from fpae70 aa
                   where aa.pae70ins = pn_ins
                     and aa.pae51eva = v.pae51eva) --mod@abr 20200124
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    begin
      select a.jaqy067ccal
        into pn_seg
        from jaqy067 a
       where trim(a.jaqy067ncal) = trim(lc_segmentacion) --mod@abr 20200124
         and a.jaqy067ccal >= 30; --mod@abr 20200124
    exception
      when others then
        null;
    end;
  
  end Sp_Segmento_Des;

  Procedure Sp_Carga_Variables_1703(pd_fecpro in date) is
  
    cursor creditos is
      select a.jaqz688emp pn_emp,
             a.jaqz688mod pn_mod,
             a.jaqz688suc pn_suc,
             a.jaqz688mda pn_mda,
             a.jaqz688pap pn_pap,
             a.jaqz688cta pn_cta,
             a.jaqz688ope pn_ope,
             a.jaqz688sbo pn_sbo,
             a.jaqz688top pn_top,
             a.jaqz688ax0 pn_ins
        from jaqz688 a
      --where a.jaqz688cta = 77340
      --and a.jaqz688ope = 2477112
      ;
  
    --lc_coderr varchar2(300);
    lc_hora        char(8);
    ln_cal         number(5);
    lc_jaqz691VAR1 varchar2(100);
    lc_jaqz691VAR2 varchar2(100);
    lc_jaqz691VAR3 varchar2(100);
    lc_jaqz691VAR4 varchar2(100);
    lc_jaqz691VAR5 varchar2(100);
    lc_jaqz691VAR6 varchar2(100);
  
    pc_vgt    char(1);
    pn_mec    number(10);
    pn_cal    number(10);
    pn_vto    number(10);
    pn_cap    number(10);
    pc_seg    char(1);
    pn_segAct number(5);
    pn_segOri number(5);
  
  begin
    /*update tab_jobs g
         set g.d_fecini = sysdate
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/ --mod@abr 20171115
  
    begin
    
      --mod@abr 20171115
      execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
      Execute immediate ('Truncate table JAQZ691');
      --mod@abr 20171115
    
      for i in creditos loop
        pq_Cr_reporte_lineas.Sp_Cr_Variables(i.pn_ins,
                                             i.pn_emp,
                                             i.pn_mod,
                                             i.pn_suc,
                                             i.pn_mda,
                                             i.pn_pap,
                                             i.pn_cta,
                                             i.pn_ope,
                                             i.pn_sbo,
                                             i.pn_top,
                                             pd_fecpro,
                                             pc_vgt,
                                             pn_mec,
                                             pn_cal,
                                             pn_vto,
                                             pn_cap,
                                             pc_seg,
                                             pn_segAct,
                                             pn_segOri);
      
        lc_jaqz691VAR1 := '116_VIGENTE' || '=' || trim(pc_vgt);
        lc_jaqz691VAR2 := 'MESES_CANC' || '=' || trim(to_char(pn_mec));
        lc_jaqz691VAR3 := 'CALIFICA_EVAL' || '=' || trim(to_char(pn_cal));
        lc_jaqz691VAR4 := 'LINEA_VIG' || '=' || trim(to_char(pn_vto));
        lc_jaqz691VAR5 := 'CAP_TRAB_DESEMB' || '=' || trim(to_char(pn_cap));
        lc_jaqz691VAR6 := 'BAJO_SEGMENT' || '=' || trim(pc_seg);
      
        ln_cal  := 0;
        lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
      
        begin
          insert into JAQZ691
            (JAQZ691FECH,
             JAQZ691EMP,
             JAQZ691MOD,
             JAQZ691SUC,
             JAQZ691MDA,
             JAQZ691PAP,
             JAQZ691CTA,
             JAQZ691OPE,
             JAQZ691SBO,
             JAQZ691TOP,
             JAQZ691HORA,
             JAQZ691CCAL,
             JAQZ691VAR1,
             JAQZ691VAR2,
             JAQZ691VAR3,
             JAQZ691VAR4,
             JAQZ691VAR5,
             JAQZ691VAR6)
          values
            (pd_fecpro,
             i.pn_emp,
             i.pn_mod,
             i.pn_suc,
             i.pn_mda,
             i.pn_pap,
             i.pn_cta,
             i.pn_ope,
             i.pn_sbo,
             i.pn_top,
             lc_hora,
             ln_cal,
             lc_jaqz691VAR1,
             lc_jaqz691VAR2,
             lc_jaqz691VAR3,
             lc_jaqz691VAR4,
             lc_jaqz691VAR5,
             lc_jaqz691VAR6);
        
          commit;
        exception
          when others then
            null;
          
        end;
      
      end loop;
      /* update tab_jobs g
         set g.d_fecfin = sysdate
       where g.n_numer1 =  P_C_DIGITO
         and g.c_codage = 'L1';
      commit; */ --mod@abr 20171115
    
    end;
  
  EXCEPTION
    when others then
      null;
      --lc_coderr := substr(sqlerrm, 1, 200);
    /*update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = P_C_DIGITO
         and g.c_codage = 'L1';
    commit;*/ --mod@abr 20171115
  
  end Sp_Carga_Variables_1703;

  procedure sp_cr_RNG1703(P_D_FECPRO in date) IS
  
    cursor c_clientes /*(p_fecpro date)*/
    is
      select /*+all_rows index_ss(l)*/
       l.jaqz688emp,
       l.jaqz688mod,
       l.jaqz688suc,
       l.jaqz688mda,
       l.jaqz688pap,
       l.jaqz688cta,
       l.jaqz688ope,
       l.jaqz688sbo,
       l.jaqz688top
        from jaqz688 l;
  
    cursor c_reglas is
    
      select /*+ALL_ROWS*/
       g.RNG50ORD,
       t.RNG49COD,
       t.RNG50GRP,
       t.RNG51COD,
       t.RNG68COD,
       t.RNG51OPE,
       t.RNG51VAL,
       a.RNG68ATR,
       a.RNG68TDA,
       g.RNG50Ret
        from FRNG50 g
       inner join frng51 t
          on g.rng49cod = t.rng49cod
         and g.rng50grp = t.rng50grp
       inner join frng68 a
          on t.rng49cod = a.rng49cod
         and t.rng68cod = a.rng68cod
      --          where t.RNG49Cod in (1611, 1612, 1613, 1614, 1617)
       where t.RNG49Cod = 1703
       order by g.RNG49COD, g.RNG50ORD, t.RNG50GRP, t.RNG51COD;
  
    Regla         frng51.rng49cod%type;
    SegmentoRegla frng50.rng50ret%type;
    la_nomvar     pq_cr_reporte_lineas.tp_nomvar;
    la_valvar     pq_cr_reporte_lineas.tp_valvar;
    la_nomnul     pq_cr_reporte_lineas.tp_nomvar;
    la_valnul     pq_cr_reporte_lineas.tp_valvar;
    ln_var        number(3) := 0;
  
    l_JAQZ688PDPE JAQZ688_PEN.JAQZ688DPE%type;
    l_JAQZ688PPEN JAQZ688_PEN.JAQZ688PPEN%type;
    l_JAQZ688Pemp JAQZ688_PEN.JAQZ688PEMP%type;
    l_JAQZ688Pmod JAQZ688_PEN.JAQZ688PMOD%type;
    l_JAQZ688Psuc JAQZ688_PEN.JAQZ688PSUC%type;
    l_JAQZ688Pmda JAQZ688_PEN.JAQZ688PMDA%type;
    l_JAQZ688Ppap JAQZ688_PEN.JAQZ688PPAP%type;
    l_JAQZ688Pcta JAQZ688_PEN.JAQZ688PCTA%type;
    l_JAQZ688Pope JAQZ688_PEN.JAQZ688POPE%type;
    l_JAQZ688Psbo JAQZ688_PEN.JAQZ688PSBO%type;
    l_JAQZ688Ptop JAQZ688_PEN.JAQZ688PTOP%type;
  
    TYPE tp_emp IS TABLE OF JAQZ689.JAQZ689emp%type INDEX BY BINARY_INTEGER;
    TYPE tp_mod IS TABLE OF JAQZ689.JAQZ689mod%type INDEX BY BINARY_INTEGER;
    TYPE tp_suc IS TABLE OF JAQZ689.JAQZ689suc%type INDEX BY BINARY_INTEGER;
    TYPE tp_mda IS TABLE OF JAQZ689.JAQZ689mda%type INDEX BY BINARY_INTEGER;
    TYPE tp_pap IS TABLE OF JAQZ689.JAQZ689pap%type INDEX BY BINARY_INTEGER;
    TYPE tp_cta IS TABLE OF JAQZ689.JAQZ689cta%type INDEX BY BINARY_INTEGER;
    TYPE tp_ope IS TABLE OF JAQZ689.JAQZ689ope%type INDEX BY BINARY_INTEGER;
    TYPE tp_sbo IS TABLE OF JAQZ689.JAQZ689sbo%type INDEX BY BINARY_INTEGER;
    TYPE tp_top IS TABLE OF JAQZ689.JAQZ689top%type INDEX BY BINARY_INTEGER;
  
    la_JAQZ689emp tp_emp;
    la_JAQZ689mod tp_mod;
    la_JAQZ689suc tp_suc;
    la_JAQZ689mda tp_mda;
    la_JAQZ689pap tp_pap;
    la_JAQZ689cta tp_cta;
    la_JAQZ689ope tp_ope;
    la_JAQZ689sbo tp_sbo;
    la_JAQZ689top tp_top;
  
    la_reglas pq_cr_reporte_lineas.tb_reglas;
    ln_reg    number(5);
  
  BEGIN
  
    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    execute immediate 'ALTER SESSION SET OPTIMIZER_MODE=ALL_ROWS'; --jflor 2014.01.17  
    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE'; --jflor 2014.05.05
    execute immediate ('truncate table JAQZ692');
    Regla := 1703;
  
    -- Cargar reglas
    ln_reg := 0;
    for r in c_reglas loop
      ln_reg := ln_reg + 1;
      la_reglas(ln_reg).RNG49COD := r.rng49cod;
      la_reglas(ln_reg).RNG50GRP := r.rng50grp;
      la_reglas(ln_reg).RNG51COD := r.rng51cod;
      la_reglas(ln_reg).RNG68COD := r.rng68cod;
      la_reglas(ln_reg).RNG51OPE := r.rng51ope;
      la_reglas(ln_reg).RNG51VAL := r.rng51val;
      la_reglas(ln_reg).RNG68ATR := r.rng68atr;
      la_reglas(ln_reg).RNG68TDA := r.rng68tda;
      la_reglas(ln_reg).RNG50Ret := r.rng50ret;
    end loop;
  
    OPEN c_clientes /*(P_D_FECPRO)*/
    ; -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_JAQZ689emp,
           la_JAQZ689mod,
           la_JAQZ689suc,
           la_JAQZ689mda,
           la_JAQZ689pap,
           la_JAQZ689cta,
           la_JAQZ689ope,
           la_JAQZ689sbo,
           la_JAQZ689top;
  
    IF la_JAQZ689cta.count > 0 THEN
      FOR c IN la_JAQZ689cta.FIRST .. la_JAQZ689cta.LAST LOOP
      
        l_JAQZ688Pemp := la_JAQZ689emp(c);
        l_JAQZ688Pmod := la_JAQZ689mod(c);
        l_JAQZ688Psuc := la_JAQZ689suc(c);
        l_JAQZ688Pmda := la_JAQZ689mda(c);
        l_JAQZ688Ppap := la_JAQZ689pap(c);
        l_JAQZ688Pcta := la_JAQZ689cta(c);
        l_JAQZ688Pope := la_JAQZ689ope(c);
        l_JAQZ688Psbo := la_JAQZ689sbo(c);
        l_JAQZ688Ptop := la_JAQZ689top(c);
      
        la_nomvar := la_nomnul;
        la_valvar := la_valnul;
        PQ_CR_REPORTE_LINEAS.sp_cr_cargar_variables_1703(p_d_fecpro => P_D_FECPRO,
                                                         pn_emp     => la_JAQZ689emp(c),
                                                         pn_mod     => la_JAQZ689mod(c),
                                                         pn_suc     => la_JAQZ689suc(c),
                                                         pn_mda     => la_JAQZ689mda(c),
                                                         pn_pap     => la_JAQZ689pap(c),
                                                         pn_cta     => la_JAQZ689cta(c),
                                                         pn_ope     => la_JAQZ689ope(c),
                                                         pn_sbo     => la_JAQZ689sbo(c),
                                                         pn_top     => la_JAQZ689top(c),
                                                         p_a_nomvar => la_nomvar,
                                                         p_a_valvar => la_valvar,
                                                         p_n_var    => ln_var);
      
        SegmentoRegla := null;
        PQ_CR_REPORTE_LINEAS.sp_cr_evalua_clientes_1_1703(P_N_REGLA   => Regla,
                                                          P_A_NOMVAR  => la_nomvar,
                                                          P_A_VALVAR  => la_valvar,
                                                          P_N_VAR     => ln_var,
                                                          P_A_REGLAS  => la_reglas,
                                                          P_N_REG     => ln_reg,
                                                          p_c_retorno => SegmentoRegla);
      
        l_JAQZ688PDPE := Trim(SegmentoRegla);
        If substr(Trim(SegmentoRegla), 1, 1) = '0' then
          l_JAQZ688PPEN := 'N';
        else
          l_JAQZ688PPEN := 'S';
        end if;
      
        insert into JAQZ692
          (jaqz692PEMP,
           jaqz692PMOD,
           jaqz692PSUC,
           jaqz692PMDA,
           jaqz692PPAP,
           jaqz692PCTA,
           jaqz692POPE,
           jaqz692PSBO,
           jaqz692PTOP,
           jaqz692PFEP,
           jaqz692PPEN,
           jaqz692DPE)
        VALUES
          (l_JAQZ688Pemp,
           l_JAQZ688Pmod,
           l_JAQZ688Psuc,
           l_JAQZ688Pmda,
           l_JAQZ688Ppap,
           l_JAQZ688Pcta,
           l_JAQZ688Pope,
           l_JAQZ688Psbo,
           l_JAQZ688Ptop,
           P_D_FECPRO,
           l_JAQZ688PPEN,
           l_JAQZ688PDPE);
      
        commit;
      
      END LOOP; -- clientes
    END IF;
  
  end sp_cr_RNG1703;

  procedure sp_cr_cargar_variables_1703(P_D_FECPRO IN DATE,
                                        PN_EMP     IN JAQZ689.JAQZ689EMP%type,
                                        PN_MOD     IN JAQZ689.JAQZ689MOD%type,
                                        PN_SUC     IN JAQZ689.JAQZ689SUC%type,
                                        PN_MDA     IN JAQZ689.JAQZ689MDA%type,
                                        PN_PAP     IN JAQZ689.JAQZ689PAP%type,
                                        PN_CTA     IN JAQZ689.JAQZ689CTA%type,
                                        PN_OPE     IN JAQZ689.JAQZ689OPE%type,
                                        PN_SBO     IN JAQZ689.JAQZ689SBO%type,
                                        PN_TOP     IN JAQZ689.JAQZ689TOP%type,
                                        p_a_nomvar out pq_cr_reporte_lineas.tp_nomvar,
                                        p_a_valvar out pq_cr_reporte_lineas.tp_valvar,
                                        p_n_var    out number) is
  
    cursor c_cliente is
      select jaqz691fech,
             jaqz691EMP,
             jaqz691MOD,
             jaqz691SUC,
             jaqz691MDA,
             jaqz691pap,
             jaqz691cta,
             jaqz691ope,
             jaqz691sbo,
             jaqz691top,
             jaqz691var1,
             jaqz691var2,
             jaqz691var3,
             jaqz691var4,
             jaqz691var5,
             jaqz691var6,
             jaqz691var7,
             jaqz691var8,
             jaqz691var9,
             jaqz691var10,
             jaqz691var11,
             jaqz691var12,
             jaqz691var13,
             jaqz691var14,
             jaqz691var15,
             jaqz691var16,
             jaqz691var17,
             jaqz691var18,
             jaqz691var19,
             jaqz691var20,
             jaqz691var21,
             jaqz691var22,
             jaqz691var23,
             jaqz691var24,
             jaqz691var25,
             jaqz691var26,
             jaqz691var27,
             jaqz691var28,
             jaqz691var29,
             jaqz691var30,
             jaqz691var31,
             jaqz691var32,
             jaqz691var33,
             jaqz691var34,
             jaqz691var35,
             jaqz691var36,
             jaqz691var37,
             jaqz691var38,
             jaqz691var39,
             jaqz691var40
        from jaqz691 A
       where A.jaqz691FECH = P_D_FECPRO
         and A.jaqz691EMP = PN_EMP
         and A.jaqz691MOD = PN_MOD
         and A.jaqz691SUC = PN_SUC
         and A.jaqz691MDA = PN_MDA
         and a.jaqz691pap = PN_PAP
         and a.jaqz691cta = PN_CTA
         and a.jaqz691ope = PN_OPE
         and a.jaqz691sbo = PN_SBO
         and a.jaqz691top = PN_TOP;
    ln_tmpnum number(3);
  
  begin
  
    for cli in c_cliente loop
      -- Cargando Variables Resuletas
      if trim(cli.jaqz691var1) is not null then
        p_n_var := 1;
        ln_tmpnum := instr(cli.jaqz691var1, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var1, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var1, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var2) is not null then
        p_n_var := 2;
        ln_tmpnum := instr(cli.jaqz691var2, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var2, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var2, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var3) is not null then
        p_n_var := 3;
        ln_tmpnum := instr(cli.jaqz691var3, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var3, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var3, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var4) is not null then
        p_n_var := 4;
        ln_tmpnum := instr(cli.jaqz691var4, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var4, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var4, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var5) is not null then
        p_n_var := 5;
        ln_tmpnum := instr(cli.jaqz691var5, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var5, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var5, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var6) is not null then
        p_n_var := 6;
        ln_tmpnum := instr(cli.jaqz691var6, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var6, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var6, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var7) is not null then
        p_n_var := 7;
        ln_tmpnum := instr(cli.jaqz691var7, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var7, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var7, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var8) is not null then
        p_n_var := 8;
        ln_tmpnum := instr(cli.jaqz691var8, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var8, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var8, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var9) is not null then
        p_n_var := 9;
        ln_tmpnum := instr(cli.jaqz691var9, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var9, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var9, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var10) is not null then
        p_n_var := 10;
        ln_tmpnum := instr(cli.jaqz691var10, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var10, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var10, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var11) is not null then
        p_n_var := 11;
        ln_tmpnum := instr(cli.jaqz691var11, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var11, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var11, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var12) is not null then
        p_n_var := 12;
        ln_tmpnum := instr(cli.jaqz691var12, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var12, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var12, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var13) is not null then
        p_n_var := 13;
        ln_tmpnum := instr(cli.jaqz691var13, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var13, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var13, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var14) is not null then
        p_n_var := 14;
        ln_tmpnum := instr(cli.jaqz691var14, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var14, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var14, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var15) is not null then
        p_n_var := 15;
        ln_tmpnum := instr(cli.jaqz691var15, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var15, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var15, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var16) is not null then
        p_n_var := 16;
        ln_tmpnum := instr(cli.jaqz691var16, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var16, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var16, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var17) is not null then
        p_n_var := 17;
        ln_tmpnum := instr(cli.jaqz691var17, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var17, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var17, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var18) is not null then
        p_n_var := 18;
        ln_tmpnum := instr(cli.jaqz691var18, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var18, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var18, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var19) is not null then
        p_n_var := 19;
        ln_tmpnum := instr(cli.jaqz691var19, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var19, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var19, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var20) is not null then
        p_n_var := 20;
        ln_tmpnum := instr(cli.jaqz691var20, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var20, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var20, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var21) is not null then
        p_n_var := 21;
        ln_tmpnum := instr(cli.jaqz691var21, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var21, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var21, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var22) is not null then
        p_n_var := 22;
        ln_tmpnum := instr(cli.jaqz691var22, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var22, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var22, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var23) is not null then
        p_n_var := 23;
        ln_tmpnum := instr(cli.jaqz691var23, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var23, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var23, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var24) is not null then
        p_n_var := 24;
        ln_tmpnum := instr(cli.jaqz691var24, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var24, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var24, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var25) is not null then
        p_n_var := 25;
        ln_tmpnum := instr(cli.jaqz691var25, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var25, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var25, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var26) is not null then
        p_n_var := 26;
        ln_tmpnum := instr(cli.jaqz691var26, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var26, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var26, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var27) is not null then
        p_n_var := 27;
        ln_tmpnum := instr(cli.jaqz691var27, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var27, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var27, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var28) is not null then
        p_n_var := 28;
        ln_tmpnum := instr(cli.jaqz691var28, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var28, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var28, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var29) is not null then
        p_n_var := 29;
        ln_tmpnum := instr(cli.jaqz691var29, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var29, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var29, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var30) is not null then
        p_n_var := 30;
        ln_tmpnum := instr(cli.jaqz691var30, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var30, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var30, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var31) is not null then
        p_n_var := 31;
        ln_tmpnum := instr(cli.jaqz691var31, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var31, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var31, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var32) is not null then
        p_n_var := 32;
        ln_tmpnum := instr(cli.jaqz691var32, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var32, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var32, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var33) is not null then
        p_n_var := 33;
        ln_tmpnum := instr(cli.jaqz691var33, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var33, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var33, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var34) is not null then
        p_n_var := 34;
        ln_tmpnum := instr(cli.jaqz691var34, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var34, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var34, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var35) is not null then
        p_n_var := 35;
        ln_tmpnum := instr(cli.jaqz691var35, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var35, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var35, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var36) is not null then
        p_n_var := 36;
        ln_tmpnum := instr(cli.jaqz691var36, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var36, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var36, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var37) is not null then
        p_n_var := 37;
        ln_tmpnum := instr(cli.jaqz691var37, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var37, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var37, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var38) is not null then
        p_n_var := 38;
        ln_tmpnum := instr(cli.jaqz691var38, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var38, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var38, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var39) is not null then
        p_n_var := 39;
        ln_tmpnum := instr(cli.jaqz691var39, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var39, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var39, ln_tmpnum + 1);
      end if;
    
      if trim(cli.jaqz691var40) is not null then
        p_n_var := 40;
        ln_tmpnum := instr(cli.jaqz691var40, '=');
        p_a_nomvar(p_n_var) := substr(cli.jaqz691var40, 1, ln_tmpnum - 1);
        p_a_valvar(p_n_var) := substr(cli.jaqz691var40, ln_tmpnum + 1);
      end if;
    
    end loop;
  
  end sp_cr_cargar_variables_1703;

  procedure sp_cr_evalua_clientes_1_1703(P_N_REGLA   IN NUMBER,
                                         P_A_NOMVAR  IN pq_cr_reporte_lineas.tp_nomvar,
                                         P_A_VALVAR  IN pq_cr_reporte_lineas.tp_valvar,
                                         P_N_VAR     IN number,
                                         P_A_REGLAS  in pq_cr_reporte_lineas.tb_reglas,
                                         P_N_REG     in number,
                                         p_c_retorno out varchar2) IS
  
    cursor c_lista(p_RNG49Cod number, p_RNG50Grp number, p_RNG51COD number) is
      select RNG49Cod, RNG50Grp, RNG51COD, RNG67COR, RNG67VAL
        from FRNG67
       where RNG49Cod = p_RNG49Cod
         and RNG50Grp = p_RNG50Grp
         and RNG51COD = p_RNG51COD
       order by RNG67COR;
  
    ExisteGrupo   char(1) := null;
    ResReglaGrupo char(1) := null;
    ResReglaLista char(1) := null;
    Regla         frng51.rng49cod%type;
    --Regla2 frng51.rng49cod%type;
    l_RNG50Grp     frng51.rng50grp%type;
    l_RNG50Ret     frng50.rng50ret%type;
    la_nomvar      pq_cr_reporte_lineas.tp_nomvar;
    la_valvar      pq_cr_reporte_lineas.tp_valvar;
    ln_var         number(3) := 0;
    lc_valResuelto varchar2(30);
    i              number(5);
    ln_NumTmp1     number(10, 2);
    ln_NumTmp2     number(10, 2);
    --l_RNG68Tda frng68.rng68tda%type;
    --SegmentoRegla2 frng51.rng51val%type;
    l_RNG51Val varchar2(30);
    l_RNG67val varchar2(30);
    l_RNG51OPE varchar2(2);
    la_reglas  pq_cr_reporte_lineas.tb_reglas;
    ln_reg     number(5);
    ln_ind     number(5);
  
  BEGIN
  
    Regla     := nvl(P_N_REGLA, 0);
    la_nomvar := p_a_nomvar;
    la_valvar := p_a_valvar;
    ln_var    := nvl(p_n_var, 0);
    la_reglas := P_A_REGLAS;
    ln_reg    := nvl(P_N_REG, 0);
  
    For reg in 1 .. ln_reg loop
      If la_reglas(reg).RNG49COD = Regla then
        l_RNG50Ret  := la_reglas(reg).RNG50Ret;
        l_RNG50Grp  := la_reglas(reg).RNG50GRP;
        ExisteGrupo := 'S';
        ln_ind      := reg;
        Exit;
      End If;
    End loop;
  
    If ExisteGrupo = 'S' then
      --existe grupo
    
      -- Evaluando Variables
      ResReglaGrupo := 'S';
    
      WHILE la_reglas(ln_ind).RNG49COD = Regla LOOP
      
        If la_reglas(ln_ind).RNG50GRP <> l_RNG50Grp then
          --evaluar cambio de grupo
          --Msg('Diferente grupo')
          If ResReglaGrupo = 'N' And la_reglas(ln_ind).RNG50GRP = 999 then
            --Retorno Default (Condición ELSE)
            --Msg('Retorno Default (Condición ELSE)')
            p_c_retorno := la_reglas(ln_ind).RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)                         
            Exit;
          End If;
        
          If ResReglaGrupo = 'S' then
            --se cumple la regla para el grupo anterior
            --Msg('grupo cumplido')
            p_c_retorno := l_RNG50Ret;
            --ResReglaGrupo := 'S'; 
            --Msg(p_c_retorno)
            Exit;
          Else
            --evaluar el siguiente grupo de la regla
            --Msg('cambio de grupo')
            l_RNG50Grp := la_reglas(ln_ind).RNG50GRP;
            l_RNG50Ret := la_reglas(ln_ind).RNG50Ret;
            --Msg('grupo : '+Str(RNG50Grp))
            ResReglaGrupo := 'S';
            --Do 'Limpiar VExpresion'
          End If;
        End If;
      
        -- Encontrar valor resuelto de atributo
        lc_valResuelto := '0';
        For i in 1 .. ln_var loop
          If la_nomvar(i) = trim(la_reglas(ln_ind).RNG68ATR) then
            lc_valResuelto := trim(la_valvar(i));
            Exit;
          End If;
        End loop;
      
        -- Resolver Regla anidada Nivel 2
        --                If la_reglas(ln_ind).RNG68ATR in ('EXP1612','EXP1613','EXP1614','EXP1617') then
        --If la_reglas(ln_ind).RNG68ATR = 'EXP1621' then
      
        --Regla2 := to_number(substr(la_reglas(ln_ind).RNG68ATR,4,4));
        --Msg('rutina regla anidada ' + Str(&Regla2))
        --SegmentoRegla2 := null;
        --PQ_CR_SEGMENTACION_CLIENTES.sp_cr_evalua_clientes_2_NS( P_N_REGLA => Regla2,
        --                                                     P_A_NOMVAR => la_nomvar,
        --                                                     P_A_VALVAR => la_valvar, 
        --                                                    P_N_VAR => ln_var,
        --                                                    P_A_REGLAS => la_reglas,
        --                                                    P_N_REG => ln_reg,
        --                                                    p_c_retorno => SegmentoRegla2);
        --lc_valResuelto := Trim(SegmentoRegla2);
      
        -- End If;
      
        -- Evaluacion de condiciones
        l_RNG51Val := nvl(trim(la_reglas(ln_ind).RNG51VAL), '0');
      
        if lc_valResuelto = '100' then
          lc_valResuelto := '100.00';
        end if;
        if l_RNG51Val = '100' then
          l_RNG51Val := '100.00';
        end if;
      
        l_RNG51OPE := trim(la_reglas(ln_ind).RNG51OPE);
        Case l_RNG51OPE
          When '>=' then
            --Msg('es mayor igual que ' + l_RNG51Val)
            --Msg(ValResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 < ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '>' then
            --Msg('es mayor que ' + l_RNG51Val)
            --Msg(lc_lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 <= ln_NumTmp2 then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<=' then
            --Msg('es menor igual que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 > ln_NumTmp2 then
              --to_number(lc_valResuelto) > to_number(l_RNG51Val)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '<' then
            --Msg('es menor que ' + l_RNG51Val)
            --Msg(lc_valResuelto)
            ln_NumTmp1 := to_number(lc_valResuelto);
            ln_NumTmp2 := to_number(l_RNG51Val);
            If ln_NumTmp1 >= ln_NumTmp2 then
              --to_number(lc_valResuelto) >= to_number(reg.RNG51VAL)
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When '=' then
            --Msg('es igual que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)                 
            If lc_valResuelto <> l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When '<>' then
            --Msg('es diferente que ' + VeRNG51VAL(j))
            --Msg(ValResuelto)
          
            If lc_valResuelto = l_RNG51Val then
              --Msg('no cumple ' + VeRNG68ATR(j))
              ResReglaGrupo := 'N';
            End If;
          
          When 'EN' then
            ResReglaLista := 'N';
            -- valores de evaluacion lista
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'N' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          When 'NE' then
            ResReglaLista := 'N';
            For lis in c_lista(la_reglas (ln_ind).RNG49COD,
                               l_RNG50Grp,
                               la_reglas (ln_ind).RNG51COD) loop
              --Msg('NO esta EN ' + MVaLista(i, 4)) 
              l_RNG67val := trim(lis.rng67val);
              If lc_valResuelto = l_RNG67val then
                ResReglaLista := 'S';
                Exit;
              End If;
            End Loop;
            --Msg(lc_valResuelto)
            If ResReglaLista = 'S' then
              --Msg('no cumple ' + reg.RNG68ATR)
              ResReglaGrupo := 'N';
            End If;
          
          Else
            ResReglaGrupo := 'N'; --faltan variaciones de like y not like
        
        End Case;
      
        --END IF; -- regla evaluada
        ln_ind := ln_ind + 1;
      
      END LOOP; -- reglas
    
    End If; -- existe grupo
  
  END sp_cr_evalua_clientes_1_1703;

end pq_cr_reporte_lineas;
/

