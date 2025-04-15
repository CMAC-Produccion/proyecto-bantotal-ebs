create or replace package pq_cr_rep_reactivacofide is

  -- *****************************************************************
  -- Nombre                       : pq_cr_rep_reactivacofide
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 28/04/2023
  -- Autor de Creación            : rmontesr
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para llenar tablas reporte reactiva cofide
  -- Fecha de Modificación        : 30/01/2024
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Modificacion calculo principal cobrado
  -- Fecha de Modificación        : 11/03/2025
  -- Autor de Modificación        : Mhuamania
  -- Descripción de Modificación  : Modificacion en las tablas aqpc362 y aqpc362h
  --
  -- *****************************************************************

  ----------------------------------------------------------------
  function fn_get_val_reactiva(pn_cta   in number,
                               pn_ope   in number,
                               pd_fecha in date,
                               pn_stat  in number)
    return type_table_val_reacti;
  ----------------------------------------------------------------

  procedure sp_cr_genera_data(pd_fecpro  in date,
                              pn_modcta  in number,
                              pn_usuario in varchar2);
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_reactcofide(pd_fecpro  in date,
                                  pn_usuario in varchar2);
end pq_cr_rep_reactivacofide;
/
create or replace package body pq_cr_rep_reactivacofide is
  -------------------------------------------------------------------------
  function fn_get_val_reactiva(pn_cta   in number,
                               pn_ope   in number,
                               pd_fecha in date,
                               pn_stat  in number)
    return type_table_val_reacti is
    t_resp       type_table_val_reacti;
    ln_intsus    number(17, 2);
    ln_intdev    number(17, 2);
    ln_pricob    number(17, 2);
    ln_intcob    number(17, 2);
    lc_calcre    varchar2(20);
    ld_fecha_ini date;
    ln_year      number;
    ld_fecly     date;
    ln_saldo_aa  number(17, 2);
    ln_capneg    number(17, 2);
    ln_nanios    number;
    ln_conta     number;
  begin
    ln_intdev := 0;
    --fecha 1er dia de mes
    ld_fecha_ini := trunc(pd_fecha) -
                    (to_number(to_char(pd_fecha, 'DD')) - 1);
    --año anterior
    ln_year  := extract(year from pd_fecha) - 1;
    ld_fecly := to_date('31/12/' || ln_year, 'dd/mm/yyyy');
    begin
      select tp1nro1
        into ln_nanios
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 13
         and tp1corr2 = 1
         and tp1corr2 = 1;
    exception
      when others then
        ln_nanios := 5;
    end;
    ln_conta := 0;
    begin
      select sum(h12.bcsdmn)
        into ln_saldo_aa
        from fsh012 h12
       where h12.bcfech = ld_fecly --fecha
         and h12.bcrubr like '51_4%'
         and h12.bcprod <> 99
         and h12.bcemp = 1
         and h12.bccta = pn_cta
         and h12.bcoper = pn_ope;
    exception
      when others then
        ln_saldo_aa := 0;
    end;
    while ln_nanios > 1 loop
      ln_intdev := ln_intdev + nvl(ln_saldo_aa, 0);
      ln_year   := ln_year - 1;
      ld_fecly  := to_date('31/12/' || ln_year, 'dd/mm/yyyy');
      ln_nanios := ln_nanios - 1;
      ln_conta  := ln_conta + 1;
      if (ln_conta > 10) then
        exit;
      end if;
      begin
        select sum(h12.bcsdmn)
          into ln_saldo_aa
          from fsh012 h12
         where h12.bcfech = ld_fecly --fecha
           and h12.bcrubr like '51_4%'
           and h12.bcprod <> 99
           and h12.bcemp = 1
           and h12.bccta = pn_cta
           and h12.bcoper = pn_ope;
      exception
        when others then
          ln_saldo_aa := 0;
      end;
    end loop;
    begin
      select sum(h12.bcsdmn)
        into ln_saldo_aa
        from fsh012 h12
       where h12.bcfech = pd_fecha --fecha
         and h12.bcrubr like '51_4%'
         and h12.bcprod <> 99
         and h12.bcemp = 1
         and h12.bccta = pn_cta
         and h12.bcoper = pn_ope;
    exception
      when others then
        ln_saldo_aa := 0;
    end;
    ln_intdev := ln_intdev + nvl(ln_saldo_aa, 0);
    ln_capneg := 0;
    if pn_stat = 99 then
      begin
        select sum(pc.pp1int) interes_cobrado,
               sum(pc.pp1cap) principal_cobrado
          into ln_intcob, ln_pricob
          from fsd602 pc
         where pc.pgcod = 1 --c.bcemp
           and pc.ppcta = pn_cta --cuenta
           and pc.ppoper = pn_ope --operacion               
           and pc.pp1fech >= ld_fecha_ini --fecha inicio de mes
           and pc.pp1fech <= pd_fecha --fecha fin de mes
           and pc.d602co = 'S'
           AND (pc.D602MO, pc.D602TR) in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 3
                   and x.tp1corr3 > 0);
      
      exception
        when others then
          ln_intcob := 0;
          ln_pricob := 0;
      end;
      begin
        select sum(pc.pp1cap)
          into ln_capneg
          from fsd602 pc
         where pc.pgcod = 1 --c.bcemp
           and pc.ppcta = pn_cta --cuenta
           and pc.ppoper = pn_ope --operacion               
              --and pc.pp1fech >= ld_fecha_ini --fecha inicio de mes
           and pc.pp1fech <= pd_fecha --fecha fin de mes
           and pc.d602co = 'S'
           and pc.pp1cap < 0
           AND (pc.D602MO, pc.D602TR) in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 3
                   and x.tp1corr3 > 0);
      
      exception
        when others then
          ln_capneg := 0;
      end;
      ln_pricob := ln_pricob + ln_capneg;
    else
      begin
        select sum(case
                     when pc.pp1cap < 0 then
                      pc.pp1int + pc.pp1cap
                     else
                      pc.pp1int
                   end) interes_cobrado,
               sum(case
                     when pc.pp1cap < 0 then
                      0
                     else
                      pc.pp1cap
                   end) principal_cobrado
          into ln_intcob, ln_pricob
          from fsd602 pc
         where pc.pgcod = 1 --c.bcemp
           and pc.ppcta = pn_cta --cuenta
           and pc.ppoper = pn_ope --operacion               
           and pc.pp1fech >= ld_fecha_ini --fecha inicio de mes
           and pc.pp1fech <= pd_fecha --fecha fin de mes
           and pc.d602co = 'S'
           AND (pc.D602MO, pc.D602TR) in
               (select x.tp1nro1, x.tp1nro2
                  from fst198 x
                 where x.TP1COD = 1
                   and x.TP1COD1 = 11144
                   and x.TP1CORR1 = 1
                   and x.tp1corr2 = 3
                   and x.tp1corr3 > 0);
      
      exception
        when others then
          ln_intcob := 0;
          ln_pricob := 0;
      end;
    end if;
    begin
      select sum(case
                   when REGEXP_LIKE(h12.bcrubr, '^81.40[1-4]') then
                    h12.bcsdmn
                 end) interes_suspenso
        into ln_intsus
        from fsh012 h12
       where h12.bcfech = pd_fecha --fecha
         and h12.bcrubr like '81_4%'
         and h12.bcprod <> 99
         and h12.bcemp = 1
         and h12.bccta = pn_cta
         and h12.bcoper = pn_ope;
    exception
      when others then
        ln_intsus := 0;
    end;
  
    begin
      select catcateg
        into lc_calcre
        from fsd212 cc
       where cc.pgcod = 1
         and cc.catcta = pn_cta
         and cc.catcod = 4
         and cc.catfchdes = pd_fecha
         and rownum = 1;
    
    exception
      when others then
        lc_calcre := '0-Normal      ';
    end;
    if ln_pricob < 0 then
      ln_pricob := 0;
    end if;
    begin
      select type_val_reacti(ln_intdev,
                             ln_pricob,
                             ln_intcob,
                             ln_intsus * -1,
                             nvl(trim(lc_calcre), '0-Normal      '))
        bulk collect
        into t_resp
        from dual;
    exception
      when others then
        null;
    end;
    return t_resp;
  end;
  ------------------------------------------------------------------------
  
  procedure sp_cr_genera_data(pd_fecpro  in date,
                              pn_modcta  in number,
                              pn_usuario in varchar2) is
    ld_fecha date;
    ld_fecma date;
  begin
    ld_fecma := trunc(pd_fecpro) - (to_number(to_char(pd_fecpro, 'DD')));
    -- Fecha actual
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    begin
      insert into aqpc362
        (aqpc362usur,
         aqpc362fproc,
         aqpc362cta,
         aqpc362ope,
         aqpc362cban,
         aqpc362ncer,
         aqpc362ndoc,
         aqpc362sdoins,
         aqpc362intdev,
         aqpc362pricob,
         aqpc362intcob,
         aqpc362intsus,
         aqpc362fpago,
         aqpc362fdepo,
         aqpc362clacre,--MHUAMANI 30/12/2024
         aqpc362fcre,
         aqpc362hcre,
         aqpc362emp,
         aqpc362suc,
         aqpc362mod,
         aqpc362mda,
         aqpc362pap,
         aqpc362sbop,
         aqpc362top,
         aqpc362ncre,
         aqpc362tcre)
        select pn_usuario,
               pd_fecpro,
               a.aqpb065haocta,
               a.aqpb065haooper,
               '0803',
               a.aqpb065hncer,
               a.aqpb065hndoc,
               a.aqpb065hsdoins,
               case
                 when substr(b.v_clacre, 1, 1) = '3' or
                      substr(b.v_clacre, 1, 1) = '4' then
                  0
                 else
                  nvl(b.v_intdev, 0)
               end,
               nvl(b.v_pricob, 0),
               nvl(b.v_intcob, 0),
               nvl(b.v_intsus, 0),
               a.aqpb065hfe99,
               null,
               b.v_clacre,
               to_char(sysdate, 'DD/MM/YYYY'),
               to_char(sysdate, 'HH24:MI:SS'),
               a.aqpb065hpgcod,
               a.aqpb065haosuc,
               a.aqpb065haomod,
               a.aqpb065haomda,
               a.aqpb065haopap,
               a.aqpb065haosbop,
               a.aqpb065haotope,
               a.aqpb065HNCRE,
               a.aqpb065HTCRE
          from aqpb065h a
          left join table(pq_cr_rep_reactivacofide.fn_get_val_reactiva(a.aqpb065haocta, a.aqpb065haooper, pd_fecpro, a.aqpb065hstat)) b
            on 1 = 1
         where a.aqpb065husur = 'BANTPROD'
           and a.aqpb065hfproc = pd_fecpro
           and mod(a.aqpb065haocta, 40) = pn_modcta
           and (a.aqpb065hchonr <> 'S' or a.aqpb065hfhonr > pd_fecpro) --q no sea honrado
              -- and (a.aqpb065hstat <> 99 or a.aqpb065hfe99 > ld_fecma)
           and a.aqpb065hnact <> '0';
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_genera_data;
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    delete from aqpc362h t
     where t.aqpc362husur = pn_usuario
       and t.aqpc362hfproc = pn_fcorte;
    commit;
  
    begin
    
      insert into aqpc362h
        (aqpc362husur,
         aqpc362hfproc,
         aqpc362hcta,
         aqpc362hope,
         aqpc362hcban,
         aqpc362hncer,
         aqpc362hndoc,
         aqpc362hsdoins,
         aqpc362hintdev,
         aqpc362hpricob,
         aqpc362hintcob,
         aqpc362hintsus,
         aqpc362hfpago,
         aqpc362hfdepo,
         aqpc362hclacre,
         aqpc362hfcre,--MHUAMANI 30/12/2024
         aqpc362hhcre,
         aqpc362hemp,
         aqpc362hsuc,
         aqpc362hmod,
         aqpc362hmda,
         aqpc362hpap,
         aqpc362hsbop,
         aqpc362htop,
         aqpc362hncre,
         aqpc362htcre
         )
        select aqpc362usur,
               aqpc362fproc,
               aqpc362cta,
               aqpc362ope,
               aqpc362cban,
               aqpc362ncer,
               aqpc362ndoc,
               aqpc362sdoins,
               aqpc362intdev,
               aqpc362pricob,
               aqpc362intcob,
               aqpc362intsus,
               aqpc362fpago,
               aqpc362fdepo, 
               aqpc362clacre,
               aqpc362fcre,
               aqpc362hcre,
               aqpc362emp,
               aqpc362suc,
               aqpc362mod,
               aqpc362mda,
               aqpc362pap,
               aqpc362sbop,
               aqpc362top,
               aqpc362ncre,
               aqpc362tcre
          from aqpc362
         where aqpc362usur = pn_usuario;
    
      commit;
    
    exception
      when others then
      
        lc_coderr := sqlcode;
        lc_msgerr := trim(sqlerrm);
      
    end;
  end sp_guardar_historico;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_reactcofide(pd_fecpro  in date,
                                  pn_usuario in varchar2) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
    x             number;
    lb_njobs      number(3);
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800;
  
  begin
  
    begin
      delete from aqpc362 x
       where x.aqpc362usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
    exception
      when others then
        null;
    end;
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception
      when others then
        null;
    end;
  
    select x.tp1nro1
      into lb_njobs
      from fst198 x
     where x.TP1COD = 1
       and x.TP1COD1 = 11144
       and x.TP1CORR1 = 10
       and x.tp1corr2 = 2
       and x.tp1corr3 = 3;
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'RCOFI' || lc_user;
    lc_paquete    := 'pq_cr_rep_reactivacofide';
    lc_proceso    := 'sp_cr_genera_data';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in 0 .. 39 loop
      ln_ini        := i;
      ln_job        := ln_job + 1;
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_rep_reactivacofide.sp_cr_genera_data( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
                        force     => false);
      
      Else
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      End If;
      commit;
    
      SELECT count(*)
        INTO x
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
      while x = lb_njobs loop
        --- Parametrizar              BANTPROD
        SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
           AND x.what LIKE '%' || trim(pn_usuario) || '%';
      
      end loop;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob) --VARCHAR(10),NUMBER,VARCHAR(500)
      VALUES
      
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                            lc_hostname,
                                                            lc_paquete,
                                                            lc_proceso,
                                                            pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                              lc_hostname,
                                                              lc_paquete,
                                                              lc_proceso,
                                                              pn_usuario);
    End loop;
  
    -- Registro de histórico   
    pq_cr_rep_reactivacofide.sp_guardar_historico(pn_usuario, pd_fecpro);
  
  end sp_cr_sch_reactcofide;
end pq_cr_rep_reactivacofide;
/
