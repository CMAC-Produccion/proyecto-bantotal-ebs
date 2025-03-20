create or replace package PQ_CR_TASACAMPANIA_CVD is

  -- Author  : MPOSTIGOC
  -- Created : 22/04/2020 7:17:04 p. m.
  -- Purpose : 

  procedure sp_cr_ObtTasa_Aprobado(ld_FchCargaData in date);
  ------------------------------------------------------------------
  procedure sp_cr_ObtTasa_PreAproba(ld_FchCargaData in date);
  --------------------------------------------
  procedure sp_cr_PizaPreA(lc_digito in varchar2);
  -----------------------------------------------
  procedure sp_cr_PizarrAdic(lc_digito in varchar2);
  ----------------------------------------------
  procedure sp_cr_PizaParalelo(lc_digito in varchar2);
  -----------------------------------------------------
  procedure sp_cr_PizarrReactiva(lc_digito in varchar2);
  ----------------------------------------------
  procedure sp_cr_PizaPreA_N_14(lc_digito in varchar2);
  -----------------------------------------
  procedure sp_cr_PizaPreA_N_13(lc_digito in varchar2);
  -------------------------------------------
  procedure sp_cr_Pizarr_F(lc_digito in varchar2);
  ---------------------------------------------
  procedure sp_cr_Pizarr_A(lc_digito in varchar2);
  ------------------------------------------------
  procedure sp_cr_PizaAprob(lc_digito in varchar2);
  ---------------------------------------
  procedure sp_cr_PizaAprob_Adic(lc_digito in varchar2);
  ------------------------------------
  procedure sp_cr_updatetasas_PreAp;
  --------------------------------------------
  procedure sp_cr_updatetasas_Aprob;
  ---------------------------------------
  Procedure sp_cr_carga_job_PreAp;
  ------------------------------------
  Procedure sp_cr_job_Pizz_N_14;
  -------------------------------------------
  Procedure sp_cr_job_Pizz_N_13;
  ------------------------------------------
  Procedure sp_cr_job_Pizz_F;
  -----------------------------------------
  Procedure sp_cr_job_Pizz_A;
  ---------------------------------------------
  Procedure sp_cr_carga_job_Adicional;
  --------------------------------------------
  Procedure sp_cr_carga_job_Paralelo;
  -----------------------------------
  Procedure sp_cr_carga_job_Reactiva;
  --------------------------------------------
  Procedure sp_cr_carga_job_Aprob;
  ----------------------------------
  Procedure sp_cr_carga_job_Aprob_Adic;
  ----------------------------------------
  procedure sp_cr_QuitaPizarra(ln_Corr in number, ld_FchCorr in date);
  -----------------------------------------------------------------------
  PROCEDURE SP_CR_TASACAMPANIA_JOBS(P_RESCOD OUT VARCHAR);
  -----------------------------------------------------------------------

end PQ_CR_TASACAMPANIA_CVD;
/

create or replace package body PQ_CR_TASACAMPANIA_CVD is
  --------------------------------------------------------------
  -- actualiza la tasa para ampliaciones y renovaciones para aprobados

  procedure sp_cr_ObtTasa_Aprobado(ld_FchCargaData in date) is
  
    cursor listado is
      select j.aqpa372pgcod ln_pgcod,
             j.aqpa372mod   ln_mod,
             j.aqpa372suc   ln_suc,
             j.aqpa372mda   ln_mda,
             j.aqpa372pap   ln_pap,
             j.aqpa372cta   ln_cta,
             j.aqpa372ope   ln_ope,
             j.aqpa372sbop  ln_sbop,
             j.aqpa372tope  ln_tope
        from AQPA372 j
       where j.AQPA372fc = ld_FchCargaData
         and trim(j.aqpa372ds) in ('AMPLIACION', 'RENOVACION');
  
    ln_tasa number(14, 8) := 0.00;
  begin
  
    for l in listado loop
    
      ln_tasa := pq_cr_cuotamora.bt_tasa_interes(p_emp       => l.ln_pgcod,
                                                 p_modulo    => l.ln_mod,
                                                 p_cod_age   => l.ln_suc,
                                                 p_moneda    => l.ln_mda,
                                                 p_papel     => l.ln_pap,
                                                 p_cuenta    => l.ln_cta,
                                                 p_operacion => l.ln_ope,
                                                 p_subtipo   => l.ln_sbop,
                                                 p_tipo      => l.ln_tope);
    
      begin
        update aqpa372 a
           set a.aqpa372ta = ln_tasa
         where a.aqpa372pgcod = l.ln_pgcod
           and a.aqpa372mod = l.ln_mod
           and a.aqpa372suc = l.ln_suc
           and a.aqpa372mda = l.ln_mda
           and a.aqpa372pap = l.ln_pap
           and a.aqpa372cta = l.ln_cta
           and a.aqpa372ope = l.ln_ope
           and a.aqpa372sbop = l.ln_sbop
           and a.aqpa372tope = l.ln_tope
           and trim(a.aqpa372ds) in ('AMPLIACION', 'RENOVACION');
        commit;
      end;
    
    end loop;
  
  end sp_cr_ObtTasa_Aprobado;
  ---------------------------------------------------------------------------------  
  -- actualiza la tasa para ampliaciones y renovaciones para preaprobados

  procedure sp_cr_ObtTasa_PreAproba(ld_FchCargaData in date) is
  
    cursor listado is
      select j.aqpa372pgcod ln_pgcod,
             j.aqpa372mod   ln_mod,
             j.aqpa372suc   ln_suc,
             j.aqpa372mda   ln_mda,
             j.aqpa372pap   ln_pap,
             j.aqpa372cta   ln_cta,
             j.aqpa372ope   ln_ope,
             j.aqpa372sbop  ln_sbop,
             j.aqpa372tope  ln_tope
        from AQPA372 j
       where j.AQPA372fc = ld_FchCargaData
         and trim(j.aqpa372ds) in ('AMPLIACION', 'RENOVACION');
    --  and j.aqpa372ind = 'P'; --Pre aprobados
  
    ln_tasa number(14, 8) := 0.00;
  
  begin
  
    for l in listado loop
    
      ln_tasa := pq_cr_cuotamora.bt_tasa_interes(p_emp       => l.ln_pgcod,
                                                 p_modulo    => l.ln_mod,
                                                 p_cod_age   => l.ln_suc,
                                                 p_moneda    => l.ln_mda,
                                                 p_papel     => l.ln_pap,
                                                 p_cuenta    => l.ln_cta,
                                                 p_operacion => l.ln_ope,
                                                 p_subtipo   => l.ln_sbop,
                                                 p_tipo      => l.ln_tope);
    
      begin
        update aqpa372 a
           set a.aqpa372ta = ln_tasa
         where a.aqpa372pgcod = l.ln_pgcod
           and a.aqpa372mod = l.ln_mod
           and a.aqpa372suc = l.ln_suc
           and a.aqpa372mda = l.ln_mda
           and a.aqpa372pap = l.ln_pap
           and a.aqpa372cta = l.ln_cta
           and a.aqpa372ope = l.ln_ope
           and a.aqpa372sbop = l.ln_sbop
           and a.aqpa372tope = l.ln_tope
           and trim(a.aqpa372ds) in ('AMPLIACION', 'RENOVACION');
        commit;
      end;
    
    end loop;
  
  end sp_cr_ObtTasa_PreAproba;
  -----------------------------------------------------------------
  -- Pizarras para PreAprobados, para Renovacion y Ampliacion

  procedure sp_cr_PizaPreA(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
         and a.jaqz697mto = q.aqpa372im
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
         and a.jaqz697mto = q.aqpa372im
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo, -- mpostigoc 10.09.2020
                      q.aqpa372ta  Tasa
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
         and a.jaqz697mto = q.aqpa372im
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch697 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.jaqz697fep) into ld_MaxFch697 from jaqz697 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch697, 'MM'), 1)
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch697, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch697 is not null then
    
      for l in listado_027(ld_MaxFch697) loop
      
        ln_nroreg027 := 0;
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch697,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          
          else
            insert into aqpa373
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               l.modulo,
               ln_Pp028DefN,
               l.cuenta,
               l.moneda,
               l.papel,
               ld_MaxFch697,
               l.monto,
               1,
               vTpfinv,
               'S');
            commit;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch697;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch697,
                 vFechahasta);
            end;
            commit;
          else
            insert into aqpa374
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               j.modulo,
               ln_Pp028DefN,
               j.cuenta,
               j.moneda,
               j.papel,
               ld_MaxFch697,
               vFechahasta);
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
            -- and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch697,
                 t.monto,
                 t.plazo,
                 -- 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch697,
                     t.monto,
                     t.plazo,
                     --99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch697
                   and f.tpmto = t.monto
                   and f.tppzo = t.plazo;
                --and f.tppzo = 99999;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizaPreA;
  ------------------------------------------------------------------
  -- Carga de PIzarras para Adicionales
  procedure sp_cr_PizarrAdic(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.aqpa372im Monto
      --q.AQPA372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'ADICIONAL'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'ADICIONAL'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'ADICIONAL'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
      
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1) + 4 --mpostigoc 12.10.2020
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
            --and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 t.plazo,
                 -- 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     t.plazo,
                     --99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                      -- and f.tppzo = 99999;
                   and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizarrAdic;
  ----------------------------------------------------------------------
  -- Carga de PIzarras para Paralelos
  procedure sp_cr_PizaParalelo(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.aqpa372im Monto
      --q.AQPA372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'PARALELO'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'PARALELO'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'PARALELO'
         and q.aqpa372stc = 'N'
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
      
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1) + 4 --mpostigoc 12.10.2020
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
            -- and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 t.plazo,
                 --99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     t.plazo,
                     --99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                      -- and f.tppzo = 99999;
                   and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizaParalelo;
  --------------------------------------------------------------------------
  -- Carga de PIzarras para Reactiva
  procedure sp_cr_PizarrReactiva(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch372 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'REACTIVA'
            -- and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'REACTIVA'
            -- and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and trim(q.aqpa372ds) = 'REACTIVA'
            -- and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1)
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
                  --  and f.tppzo = t.plazo; -- mpostigoc 10.09.2020
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 --  t.plazo,
                 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     --  t.plazo,
                     99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                   and f.tppzo = 99999;
                -- and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizarrReactiva;
  ------------------------------------------------------------------------
  -- Pizarras para PreAprobados, para Renovacion y Ampliacion

  procedure sp_cr_PizaPreA_N_14(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            -- and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 14 -- Dependiente
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            -- and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 14
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo, -- mpostigoc 10.09.2020
                      q.aqpa372ta  Tasa
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            -- and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 14
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch697 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.jaqz697fep) into ld_MaxFch697 from jaqz697 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch697, 'MM'), 1)
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch697, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch697 is not null then
    
      for l in listado_027(ld_MaxFch697) loop
      
        ln_nroreg027 := 0;
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch697,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          
          else
            insert into aqpa373
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               l.modulo,
               ln_Pp028DefN,
               l.cuenta,
               l.moneda,
               l.papel,
               ld_MaxFch697,
               l.monto,
               1,
               vTpfinv,
               'S');
            commit;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch697;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch697,
                 vFechahasta);
            end;
            commit;
          else
            insert into aqpa374
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               j.modulo,
               ln_Pp028DefN,
               j.cuenta,
               j.moneda,
               j.papel,
               ld_MaxFch697,
               vFechahasta);
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 20.09.2020
            --and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch697,
                 t.monto,
                 t.plazo,
                 -- 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch697,
                     t.monto,
                     t.plazo,
                     --99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch697
                   and f.tpmto = t.monto
                   and f.tppzo = t.plazo;
                -- and f.tppzo = 99999;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    end if;
  end sp_cr_PizaPreA_N_14;
  -----------------------------------------------------
  -- Pizarras para Flujo express modelo de evaluacion independiente

  procedure sp_cr_PizaPreA_N_13(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            --  and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 13 --Independiete
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            -- and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 13 --Independiete
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch697 date) is
    
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo, -- mpostigoc 10.09.2020
                      q.aqpa372ta  Tasa
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697sba = q.aqpa372sbop
         and a.jaqz697toa = q.aqpa372tope
         and a.jaqz697fep = q.aqpa372fc
            --  and a.jaqz697mto = q.aqpa372im
         and a.jaqz697au5 = q.aqpa372stc
         and a.jaqz697au5 = 'N'
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697moe = 13 --Independiete
         and trim(a.jaqz697des) in ('RENOVACION', 'AMPLIACION')
            --  and q.aqpa372ind = 'P' -- Preaprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch697 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.jaqz697fep) into ld_MaxFch697 from jaqz697 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch697, 'MM'), 1) + 4 --mpostigoc 12.10.20
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch697, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch697, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch697 is not null then
    
      for l in listado_027(ld_MaxFch697) loop
      
        ln_nroreg027 := 0;
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch697,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          
          else
            insert into aqpa373
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               l.modulo,
               ln_Pp028DefN,
               l.cuenta,
               l.moneda,
               l.papel,
               ld_MaxFch697,
               l.monto,
               1,
               vTpfinv,
               'S');
            commit;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch697;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch697,
                 vFechahasta);
            end;
            commit;
          else
            insert into aqpa374
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               j.modulo,
               ln_Pp028DefN,
               j.cuenta,
               j.moneda,
               j.papel,
               ld_MaxFch697,
               vFechahasta);
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch697) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch697
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 20.09.2020
            --and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch697,
                 t.monto,
                 t.plazo,
                 -- 99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch697,
                     t.monto,
                     t.plazo,
                     --99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 10.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch697
                   and f.tpmto = t.monto
                   and f.tppzo = t.plazo;
                -- and f.tppzo = 99999;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    end if;
  end sp_cr_PizaPreA_N_13;

  --------------------------------------------------------------
  -- Carga de PIzarras para estado de registro en F
  procedure sp_cr_Pizarr_F(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch372 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'F'
            -- and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'F'
            -- and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'F'
            --  and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1) + 4
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 20.09.2020
            -- and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 t.plazo,
                 --99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     t.plazo,
                     -- 99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 20.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                      --   and f.tppzo = 99999;
                   and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_Pizarr_F;

  -----------------------------------------------------------------
  -- Carga de PIzarras para estado de registro en A

  procedure sp_cr_Pizarr_A(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch372 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'A'
            -- and q.aqpa372ct = 453852;
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch372 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'A'
            --and q.aqpa372ct = 453852;
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch372 date) is
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372plz Plazo,
                      q.aqpa372ta  Tasa
        from aqpa372 q
       where q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and q.aqpa372fc = ld_MaxFch372
         and q.aqpa372stc = 'A'
            --  and q.aqpa372ct = 453852;
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch372 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa372fc) into ld_MaxFch372 from aqpa372 a;
      exception
        when others then
          null;
      end;
    
      begin
        /*SELECT LAST_DAY(ld_MaxFch697) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch372, 'MM'), 1) + 4
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch372, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch372, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch372 is not null then
    
      for l in listado_027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch372,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch372) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch372;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
          
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch372,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch372) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch372
               and f.tpmto = t.monto
               and f.tppzo = t.plazo; -- mpostigoc 20.09.2020
            -- and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
          
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch372,
                 t.monto,
                 t.plazo,
                 --99999,
                 t.tasa);
              commit;
            exception
              when others then
                begin
                  insert into aqpa375
                    (pgcod,
                     modulo,
                     tpizar,
                     ctnro,
                     moneda,
                     papel,
                     tpfdes,
                     tpmto,
                     tppzo,
                     tptasa)
                  values
                    (1,
                     t.modulo,
                     ln_Pp028DefN,
                     t.cuenta,
                     t.moneda,
                     t.papel,
                     ld_MaxFch372,
                     t.monto,
                     t.plazo,
                     -- 99999,
                     t.tasa);
                  commit;
                end;
            end;
          else
            if ln_nroregr27 = 1 then
              -- mpostigoc 20.09.2020
              begin
                update fsr027 f
                   set f.tptasa = t.tasa
                 where f.pgcod = 1
                   and f.modulo = t.modulo
                   and f.tpizar = ln_Pp028DefN
                   and f.ctnro = t.cuenta
                   and f.moneda = t.moneda
                   and f.papel = t.papel
                   and f.tpfdes = ld_MaxFch372
                   and f.tpmto = t.monto
                      --   and f.tppzo = 99999;
                   and f.tppzo = t.plazo;
                commit;
              end;
            end if;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_Pizarr_A;
  ------------------------------------------------------------------
  procedure sp_cr_PizaAprob(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch861 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
            -- and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch861 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
            --and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch861 date) is
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto,
                      q.aqpa372ta tasa
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('RENOVACION', 'AMPLIACION')
            --and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch861 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa861fep) into ld_MaxFch861 from aqpa861 a;
      exception
        when others then
          null;
      end;
    
      begin
        /* SELECT LAST_DAY(ld_MaxFch861) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch861, 'MM'), 1)
          INTO vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch861, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch861, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch861, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch861 is not null then
    
      for l in listado_027(ld_MaxFch861) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch861
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
          
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch861,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch861,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch861) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch861;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch861,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch861,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch861) loop
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch861
               and f.tpmto = t.monto
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch861,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          else
            begin
              insert into aqpa375
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch861,
                 t.monto,
                 99999,
                 t.tasa);
            end;
            commit;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizaAprob;
  ------------------------------------------------------------------
  procedure sp_cr_PizaAprob_Adic(lc_digito in varchar2) is
  
    cursor listado_027(ld_MaxFch861 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel,
                      q.AQPA372im Monto
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('ADICIONAL')
            -- and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_327(ld_MaxFch861 date) is
    
      select distinct q.AQPA372mo Modulo,
                      q.AQPA372ct Cuenta,
                      q.AQPA372tp TipoOperacion,
                      q.AQPA372mn Moneda,
                      q.AQPA372pp Papel
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('ADICIONAL')
            -- and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    cursor listado_r027(ld_MaxFch861 date) is
    
      select distinct q.AQPA372mo  Modulo,
                      q.AQPA372ct  Cuenta,
                      q.AQPA372tp  TipoOperacion,
                      q.AQPA372mn  Moneda,
                      q.AQPA372pp  Papel,
                      q.AQPA372im  Monto,
                      q.aqpa372ta  Tasa,
                      q.aqpa372plz plazo
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and trim(q.aqpa372ds) in ('ADICIONAL')
            --and q.aqpa372ind = 'A' -- Aprobados
         and to_char(substr(trim(q.aqpa372cta), -1, 1)) = lc_digito;
  
    vTpfinv      number;
    ln_Pp028DefN number;
    ln_Pp028Mod  number;
    ln_Pp028Top  number;
    ln_Pp028Mda  number;
    ln_Pp028Pap  number;
    ln_Pp028Emp  number;
    ln_dia       varchar2(2);
    ln_mes       varchar2(2);
    ln_anio      varchar2(4);
    ld_FchInv    number;
    ld_MaxFch861 date;
    vFechahasta  date;
    ln_nroreg027 number := 0;
    ln_nroreg327 number := 0;
    ln_nroregr27 number := 0;
  
  begin
  
    --Obteniendo datos inciales del credito.
  
    begin
    
      begin
        select max(a.aqpa861fep) into ld_MaxFch861 from aqpa861 a;
      exception
        when others then
          null;
      end;
    
      begin
        /* SELECT LAST_DAY(ld_MaxFch861) into vFechahasta FROM DUAL;
        exception
          when others then
            null;*/
        SELECT ADD_MONTHS(TRUNC(ld_MaxFch861, 'MM'), 1)
          into vFechahasta
          FROM DUAL;
      end;
    
      begin
        select to_char(ld_MaxFch861, 'DD') into ln_dia from dual;
      end;
      begin
        select to_char(ld_MaxFch861, 'MM') into ln_mes from dual;
      end;
      begin
        select to_char(ld_MaxFch861, 'YYYY') into ln_anio from dual;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    --fin de carga de datros inciales.
  
    if ld_MaxFch861 is not null then
    
      for l in listado_027(ld_MaxFch861) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = l.modulo
             and Pp028Top = l.tipooperacion
             and Pp028Mda = l.moneda
             and Pp028Pap = l.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg027
              from fsd027 f
             where f.pgcod = 1
               and f.modulo = l.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = l.cuenta
               and f.moneda = l.moneda
               and f.papel = l.papel
               and f.tpfdes = ld_MaxFch861
               and f.tpmto = l.monto;
          exception
            when others then
              ln_nroreg027 := 0;
          end;
        
          if ln_nroreg027 = 0 then
            begin
              insert into fsd027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch861,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          else
            begin
              insert into aqpa373
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tpttas,
                 tpfinv,
                 tpvig)
              values
                (1,
                 l.modulo,
                 ln_Pp028DefN,
                 l.cuenta,
                 l.moneda,
                 l.papel,
                 ld_MaxFch861,
                 l.monto,
                 1,
                 vTpfinv,
                 'S');
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for j in listado_327(ld_MaxFch861) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = j.modulo
             and Pp028Top = j.tipooperacion
             and Pp028Mda = j.moneda
             and Pp028Pap = j.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroreg327
              from fsd327 f
             where f.vt1pgcod = 1
               and f.vt1mod = j.modulo
               and f.vt1tpiz = ln_Pp028DefN
               and f.vt1ctnr = j.cuenta
               and f.vt1mon = j.moneda
               and f.vt1pap = j.papel
               and f.vt1tpfd = ld_MaxFch861;
          exception
            when others then
              ln_nroreg327 := 0;
          end;
        
          if ln_nroreg327 = 0 then
            begin
              insert into fsd327
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch861,
                 vFechahasta);
            end;
            commit;
          else
            begin
              insert into aqpa374
                (vt1pgcod,
                 vt1mod,
                 vt1tpiz,
                 vt1ctnr,
                 vt1mon,
                 vt1pap,
                 vt1tpfd,
                 vt1fchven)
              values
                (1,
                 j.modulo,
                 ln_Pp028DefN,
                 j.cuenta,
                 j.moneda,
                 j.papel,
                 ld_MaxFch861,
                 vFechahasta);
            end;
            commit;
          end if;
        end if;
      end loop;
    
      for t in listado_r027(ld_MaxFch861) loop
      
        begin
          select Pp028DefN,
                 Pp028Mod,
                 Pp028Top,
                 Pp028Mda,
                 Pp028Pap,
                 Pp028Emp
            into ln_Pp028DefN,
                 ln_Pp028Mod,
                 ln_Pp028Top,
                 ln_Pp028Mda,
                 ln_Pp028Pap,
                 ln_Pp028Emp
            from FPP028
           Where Pp028Emp = 1
             and Pp028Mod = t.modulo
             and Pp028Top = t.tipooperacion
             and Pp028Mda = t.moneda
             and Pp028Pap = t.papel
             and Pp017Par = 17;
        exception
          when others then
            null;
        end;
      
        if ln_Pp028DefN is not null then
        
          begin
            select count(*)
              into ln_nroregr27
              from fsr027 f
             where f.pgcod = 1
               and f.modulo = t.modulo
               and f.tpizar = ln_Pp028DefN
               and f.ctnro = t.cuenta
               and f.moneda = t.moneda
               and f.papel = t.papel
               and f.tpfdes = ld_MaxFch861
               and f.tpmto = t.monto
               and f.tppzo = 99999;
          exception
            when others then
              ln_nroregr27 := 0;
          end;
        
          if ln_nroregr27 = 0 then
            begin
              insert into fsr027
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch861,
                 t.monto,
                 t.plazo,
                 t.tasa);
            end;
            commit;
          else
            begin
              insert into aqpa375
                (pgcod,
                 modulo,
                 tpizar,
                 ctnro,
                 moneda,
                 papel,
                 tpfdes,
                 tpmto,
                 tppzo,
                 tptasa)
              values
                (1,
                 t.modulo,
                 ln_Pp028DefN,
                 t.cuenta,
                 t.moneda,
                 t.papel,
                 ld_MaxFch861,
                 t.monto,
                 t.plazo,
                 t.tasa);
            end;
            commit;
          end if;
        end if;
      end loop;
    
    end if;
  end sp_cr_PizaAprob_Adic;

  -------------------------------------
  -- actualiza estado para preaprobados

  procedure sp_cr_updatetasas_PreAp is
  
    cursor Lista_ActVign(ld_MaxFch697 date) is
      select distinct q.AQPA372ct ln_cuenta,
                      q.AQPA372mo ln_modulo,
                      q.AQPA372tp ln_tipooper,
                      q.AQPA372mn ln_moneda,
                      q.AQPA372pp ln_papel
        from jaqz697 a, aqpa372 q
       where a.jaqz697sua = q.aqpa372suc
         and a.jaqz697maa = q.aqpa372mda
         and a.jaqz697caa = q.aqpa372cta
         and a.jaqz697opa = q.aqpa372ope
         and a.jaqz697moa = q.aqpa372mod
         and a.jaqz697toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.jaqz697fep = ld_MaxFch697
         and a.jaqz697des in ('RENOVACION', 'AMPLIACION', 'ADICIONAL');
    --  and q.aqpa372ind in ('P'); -- Preaprobados
  
    ln_pizarra   number;
    ld_MaxFech   date;
    ld_MaxFch697 date;
  
  begin
  
    begin
      select max(a.jaqz697fep) into ld_MaxFch697 from jaqz697 a;
    exception
      when others then
        null;
    end;
  
    if ld_MaxFch697 is not null then
    
      for l in Lista_ActVign(ld_MaxFch697) loop
      
        begin
          select f.pp028defn
            into ln_pizarra
            from fpp028 f
           where f.pp017par = 17
             and f.pp028emp = 1
             and f.pp028mod = l.ln_modulo
             and f.pp028top = l.ln_tipooper
             and f.pp028mda = l.ln_moneda
             and f.pp028pap = l.ln_papel;
        exception
          when others then
            null;
        end;
      
        begin
          select max(g.tpfdes)
            into ld_MaxFech
            from fsd027 g
           where g.pgcod = 1
             and g.modulo = l.ln_modulo
             and g.tpizar = ln_pizarra
             and g.ctnro = l.ln_cuenta
             and g.moneda = l.ln_moneda
             and g.papel = l.ln_papel;
        exception
          when others then
            null;
        end;
      
        if ln_pizarra is not null and ld_MaxFech is not null then
        
          begin
            update fsd027 g
               set g.tpvig = 'N'
             where g.pgcod = 1
               and g.modulo = l.ln_modulo
               and g.tpizar = ln_pizarra
               and g.ctnro = l.ln_cuenta
               and g.moneda = l.ln_moneda
               and g.papel = l.ln_papel
               and g.tpfdes < ld_MaxFech;
          end;
        
          begin
            update fsd027 g
               set g.tpvig = 'S'
             where g.pgcod = 1
               and g.modulo = l.ln_modulo
               and g.tpizar = ln_pizarra
               and g.ctnro = l.ln_cuenta
               and g.moneda = l.ln_moneda
               and g.papel = l.ln_papel
               and g.tpfdes = ld_MaxFech;
          end;
        
        end if;
        commit;
      end loop;
    end if;
  
  end sp_cr_updatetasas_PreAp;
  ------------------------------------------------------
  -- actualiza estado de pizarras para aprobados

  procedure sp_cr_updatetasas_Aprob is
  
    cursor Lista_ActVign(ld_MaxFch861 date) is
      select distinct q.AQPA372ct ln_cuenta,
                      q.AQPA372mo ln_modulo,
                      q.AQPA372tp ln_tipooper,
                      q.AQPA372mn ln_moneda,
                      q.AQPA372pp ln_papel
        from AQPA861 a, aqpa372 q
       where a.AQPA861sua = q.aqpa372suc
         and a.AQPA861maa = q.aqpa372mda
         and a.AQPA861caa = q.aqpa372cta
         and a.AQPA861opa = q.aqpa372ope
         and a.AQPA861moa = q.aqpa372mod
         and a.AQPA861toa = q.aqpa372tope
         and q.aqpa372pgcod = 1
         and q.aqpa372mda in (0, 101)
         and q.aqpa372pap = 0
         and a.AQPA861fep = ld_MaxFch861
         and a.AQPA861des in ('RENOVACION', 'AMPLIACION', 'ADICIONAL');
    -- and q.aqpa372ind in ('A'); -- Aprobados
  
    ln_pizarra   number;
    ld_MaxFech   date;
    ld_MaxFch861 date;
  
  begin
  
    begin
      select max(a.AQPA861fep) into ld_MaxFch861 from AQPA861 a;
    exception
      when others then
        null;
    end;
  
    if ld_MaxFch861 is not null then
    
      for l in Lista_ActVign(ld_MaxFch861) loop
      
        begin
          select f.pp028defn
            into ln_pizarra
            from fpp028 f
           where f.pp017par = 17
             and f.pp028emp = 1
             and f.pp028mod = l.ln_modulo
             and f.pp028top = l.ln_tipooper
             and f.pp028mda = l.ln_moneda
             and f.pp028pap = l.ln_papel;
        exception
          when others then
            null;
        end;
      
        begin
          select max(g.tpfdes)
            into ld_MaxFech
            from fsd027 g
           where g.pgcod = 1
             and g.modulo = l.ln_modulo
             and g.tpizar = ln_pizarra
             and g.ctnro = l.ln_cuenta
             and g.moneda = l.ln_moneda
             and g.papel = l.ln_papel;
        exception
          when others then
            null;
        end;
      
        if ln_pizarra is not null and ld_MaxFech is not null then
        
          begin
            update fsd027 g
               set g.tpvig = 'N'
             where g.pgcod = 1
               and g.modulo = l.ln_modulo
               and g.tpizar = ln_pizarra
               and g.ctnro = l.ln_cuenta
               and g.moneda = l.ln_moneda
               and g.papel = l.ln_papel
               and g.tpfdes < ld_MaxFech;
          end;
        
          begin
            update fsd027 g
               set g.tpvig = 'S'
             where g.pgcod = 1
               and g.modulo = l.ln_modulo
               and g.tpizar = ln_pizarra
               and g.ctnro = l.ln_cuenta
               and g.moneda = l.ln_moneda
               and g.papel = l.ln_papel
               and g.tpfdes = ld_MaxFech;
          end;
        
        end if;
        commit;
      end loop;
    end if;
  
  end sp_cr_updatetasas_Aprob;
  ------------------------------------------------
  Procedure sp_cr_carga_job_PreAp is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaPreA(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_PreAp;
  --------------------------------------------------------
  Procedure sp_cr_job_Pizz_N_14 is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaPreA_N_14(''' || x ||
                     ''');' || ' End; '; --mpostigocc 21.10.2020
    
      ln_job := ln_job + 1;
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_job_Pizz_N_14;
  --------------------------------------------------------
  Procedure sp_cr_job_Pizz_N_13 is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaPreA_N_13(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_job_Pizz_N_13;

  ---------------------------------------------------
  Procedure sp_cr_job_Pizz_F is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_Pizarr_F(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_job_Pizz_F;
  ---------------------------------------------------
  Procedure sp_cr_job_Pizz_A is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_Pizarr_A(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_job_Pizz_A;

  ---------------------------------------------------
  Procedure sp_cr_carga_job_Adicional is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizarrAdic(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_Adicional;
  ---------------------------------------------------
  Procedure sp_cr_carga_job_Paralelo is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaParalelo(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_Paralelo;
  ---------------------------------------------------
  Procedure sp_cr_carga_job_Reactiva is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizarrReactiva(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_Reactiva;

  ------------------------------------------------
  Procedure sp_cr_carga_job_Aprob is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaAprob(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_Aprob;
  ------------------------------------------------------------------
  Procedure sp_cr_carga_job_Aprob_Adic is
  
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --ln_cont     number(2) := 0;
    -- lc_fecpro char(10);
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for x in 0 .. 9 loop
    
      lc_variable := ' begin ' ||
                     'PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaAprob_Adic(''' || x ||
                     ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      commit;
    
    end loop;
  
  end sp_cr_carga_job_Aprob_Adic;
  ---------------------------------------------------------------
  procedure sp_cr_QuitaPizarra(ln_Corr in number, ld_FchCorr in date) is
  
    cursor listado is
    /*select a.*
                                                                                                                                                                                                                                        from jaqz697 j, aqpa372 a
                                                                                                                                                                                                                                       where j.jaqz697fep = ld_FchCorr
                                                                                                                                                                                                                                         and j.jaqz697cor = ln_Corr
                                                                                                                                                                                                                                         and j.jaqz697fep = a.aqpa372fc
                                                                                                                                                                                                                                         and j.jaqz697suc = a.aqpa372su
                                                                                                                                                                                                                                         and j.jaqz697mda = a.aqpa372mn
                                                                                                                                                                                                                                         and j.jaqz697cta = a.aqpa372ct
                                                                                                                                                                                                                                         and j.jaqz697mod = a.aqpa372mo
                                                                                                                                                                                                                                         and j.jaqz697top = a.aqpa372tp
                                                                                                                                                                                                                                         and j.jaqz697mto = a.aqpa372im;*/
    
      select *
        from aqpa372 a
       where a.aqpa372cor697 = ln_Corr
         and a.aqpa372fec697 = ld_FchCorr;
  
    ln_pizarra   number;
    ld_FchSist   date;
    ld_FchFinVig date;
    ln_NroReg    number;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    end;
  
    ld_FchFinVig := ld_FchSist - 1;
  
    for l in listado loop
    
      begin
        select f.pp028defn
          into ln_pizarra
          from fpp028 f
         where f.pp017par = 17
           and f.pp028emp = 1
           and f.pp028mod = l.aqpa372mo
           and f.pp028top = l.aqpa372tp
           and f.pp028mda = l.aqpa372mn
           and f.pp028pap = l.aqpa372pp;
      exception
        when others then
          ln_pizarra := 0;
      end;
    
      if ln_pizarra > 0 then
      
        begin
          select count(*)
            into ln_NroReg
            from fsd027 f
           where f.pgcod = 1
             and f.modulo = l.aqpa372mo
             and f.tpizar = ln_pizarra
             and f.ctnro = l.aqpa372ct
             and f.moneda = l.aqpa372mn
             and f.papel = l.aqpa372pp
             and f.tpfdes = l.aqpa372fc
             and f.tpvig = 'S';
        end;
      
        update fsd027 f
           set f.tpvig = 'N'
         where f.pgcod = 1
           and f.modulo = l.aqpa372mo
           and f.tpizar = ln_pizarra
           and f.ctnro = l.aqpa372ct
           and f.moneda = l.aqpa372mn
           and f.papel = l.aqpa372pp
           and f.tpfdes = l.aqpa372fc
              -- and f.tpmto = l.aqpa372im
           and f.tpvig = 'S';
      
        if ln_NroReg <= 1 then
          update fsd327 g
             set g.vt1fchven = ld_FchFinVig
           where g.vt1pgcod = 1
             and g.vt1mod = l.aqpa372mo
             and g.vt1tpiz = ln_pizarra
             and g.vt1ctnr = l.aqpa372ct
             and g.vt1mon = l.aqpa372mn
             and g.vt1pap = l.aqpa372pp
             and g.vt1tpfd = l.aqpa372fc;
        end if;
        commit;
      
      end if;
    
    end loop;
  end;
  ----------------------------------------------------------------------------  

  PROCEDURE SP_CR_TASACAMPANIA_JOBS(P_RESCOD OUT VARCHAR) IS
  
    ln_JOBS NUMBER(9);
  
  BEGIN
    P_RESCOD := 'INI';
    ---***
    BEGIN
      --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_N_13 - INI: '||CURRENT_TIMESTAMP);
      -- CALL THE PROCEDURE
      PQ_CR_TASACAMPANIA_CVD.SP_CR_JOB_PIZZ_N_13;
    END;
    ---***
    ln_JOBS := 1;
    WHILE (ln_JOBS > 0) LOOP
      SELECT COUNT(*)
        INTO ln_JOBS
        FROM dba_jobs x
       WHERE x.what LIKE '%PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaPreA_N_13%';
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_N_13 - FIN: '||CURRENT_TIMESTAMP);
    ---***
    --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_N_14 - INI: '||CURRENT_TIMESTAMP);
    BEGIN
      -- CALL THE PROCEDURE
      PQ_CR_TASACAMPANIA_CVD.SP_CR_JOB_PIZZ_N_14;
    END;
    ---***
    ln_JOBS := 1;
    WHILE (ln_JOBS > 0) LOOP
      SELECT COUNT(*)
        INTO ln_JOBS
        FROM dba_jobs x
       WHERE x.what LIKE '%PQ_CR_TASACAMPANIA_CVD.sp_cr_PizaPreA_N_14%';
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_N_14 - FIN: '||CURRENT_TIMESTAMP);
    ---***
    --DBMS_OUTPUT.PUT_LINE('SP_CR_CARGA_JOB_ADICIONAL - INI: '||CURRENT_TIMESTAMP);
    BEGIN
      -- CALL THE PROCEDURE
      PQ_CR_TASACAMPANIA_CVD.SP_CR_CARGA_JOB_ADICIONAL;
    END;
    ---***
    ln_JOBS := 1;
    WHILE (ln_JOBS > 0) LOOP
      SELECT COUNT(*)
        INTO ln_JOBS
        FROM dba_jobs x
       WHERE x.what LIKE '%PQ_CR_TASACAMPANIA_CVD.sp_cr_PizarrAdic%';
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('SP_CR_CARGA_JOB_ADICIONAL - FIN: '||CURRENT_TIMESTAMP);
    ---***
    BEGIN
      --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_F - INI: ' || CURRENT_TIMESTAMP);
      -- CALL THE PROCEDURE
      PQ_CR_TASACAMPANIA_CVD.SP_CR_JOB_PIZZ_F;
    END;
    ---***
    ln_JOBS := 1;
    WHILE (ln_JOBS > 0) LOOP
      SELECT COUNT(*)
        INTO ln_JOBS
        FROM dba_jobs x
       WHERE x.what LIKE '%PQ_CR_TASACAMPANIA_CVD.sp_cr_Pizarr_F%';
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_F - FIN: ' || CURRENT_TIMESTAMP);
    ---***
    BEGIN
      --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_A - INI: ' || CURRENT_TIMESTAMP);
      -- Call the procedure
      PQ_CR_TASACAMPANIA_CVD.SP_CR_JOB_PIZZ_A;
    END;
    ---***
    ln_JOBS := 1;
    WHILE (ln_JOBS > 0) LOOP
      SELECT COUNT(*)
        INTO ln_JOBS
        FROM dba_jobs x
       WHERE x.what LIKE '%PQ_CR_TASACAMPANIA_CVD.sp_cr_Pizarr_A%';
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('SP_CR_JOB_PIZZ_A - FIN: ' || CURRENT_TIMESTAMP);
    ---***
    P_RESCOD := 'FIN';
  EXCEPTION
    WHEN OTHERS THEN
      P_RESCOD := 'ERR';
  END SP_CR_TASACAMPANIA_JOBS;
  ----------------------------------------------------------------------------  

end PQ_CR_TASACAMPANIA_CVD;
/

