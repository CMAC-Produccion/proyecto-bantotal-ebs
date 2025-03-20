create or replace package pq_cr_automatizacion_ccsueldo is

  -- Author  : RMONTESR
  -- Created : 15/06/2022 17:40:52
  -- Purpose : Procedimientos automatizacion carga base cuenta sueldo

  procedure sp_cr_cerrar_instancia(LN_INS NUMBER);
  -----------------------------------------------------------------------
  procedure sp_cr_cerrar_instancias_suc(ln_suc number);
  -----------------------------------------------------------------------
  Function fn_cr_verifica_tarea2(pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number;
  -----------------------------------------------------------------------
  procedure sp_cr_job_cerrar_instancia(pn_usuario in varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_automatizacion_base;
  -----------------------------------------------------------------------

  procedure sp_cr_enviocorreo;

  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              );
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2, -- De
                            p_c_recipiente in varchar2, -- Para
                            subject        in varchar2, -- Subject
                            fecha_proceso  in date, -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port          in NUMBER, -- Puerto
                            host          in varchar2, -- Host
                            --------------------                            
                            v_header in varchar2, -- Cabecera
                            rawdata  in clob -- Detalle Excel
                            );
  -----------------------------------------------------------------------
end pq_cr_automatizacion_ccsueldo;
/

create or replace package body pq_cr_automatizacion_ccsueldo is

  procedure SP_CR_CERRAR_INSTANCIA(LN_INS NUMBER) IS
    LN_ID  NUMBER(10);
    N_CONT NUMBER;
  BEGIN
  
    SELECT COUNT(*)
      INTO N_CONT
      FROM WFWRKITEMS A
     WHERE A.WFINSPRCID = LN_INS
       AND A.WFITEMSTSACT = 1;
  
    IF (N_CONT = 1) THEN
      SELECT A.WFITEMID
        INTO LN_ID
        FROM WFWRKITEMS A
       WHERE A.WFINSPRCID = LN_INS
         AND A.WFITEMSTSACT = 1;
    
      EXECUTE IMMEDIATE 'create table operador.wfworklist_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfworklist ' ||
                        'where wfwrklstitemid =' || LN_ID;
      EXECUTE IMMEDIATE 'create table operador.wfwrkitems_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfwrkitems ' ||
                        'where wfinsprcid =' || LN_INS ||
                        ' and wfitemstsact=1';
      EXECUTE IMMEDIATE 'create table operador.wfinstprc_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfinstprc ' ||
                        'where wfinsprcid =' || LN_INS;
    
      DELETE FROM WFWORKLIST C WHERE C.WFWRKLSTITEMID = LN_ID;
    
      UPDATE WFWRKITEMS A
         SET WFSTSCOD = 'B', WFITEMSTSACT = 0, WFITEMEND = SYSDATE
       WHERE A.WFINSPRCID = LN_INS
         AND A.WFITEMSTSACT = 1;
    
      UPDATE WFINSTPRC B
         SET WFINSPRCSTA = 'B', WFINSPRCOSTA = 0, WFINSPRCEND = SYSDATE
       WHERE B.WFINSPRCID = LN_INS;
    
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se procesó instancia:' || LN_INS);
    ELSE
      DBMS_OUTPUT.PUT_LINE('La Instancia :' || LN_INS || ' considera ' ||
                           N_CONT ||
                           ' registro(s) en la tabla wfwrkitems.' ||
                           CHR(13) ||
                           'No se realizaron el delete y updates.');
    END IF;
    insert into AQPC353
    values
      (user, sysdate, 'SP_CR_CERRAR_INSTANCIA', LN_INS,0,0);
    commit;
  END SP_CR_CERRAR_INSTANCIA;
  ----------------------------------------------------------------------------
  procedure SP_CR_CERRAR_INSTANCIAS_suc(ln_suc in number) is
  begin
    for i in (select *
                from xwf700 x
               where x.xwfempresa = 1
                 and x.xwfsucursal = ln_suc
                 and x.xwfcar3 = '1'
                 and (x.xwfmodulo, x.xwftipope) in
                     (SELECT tp1nro1, tp1nro2
                        FROM FST198
                       where tp1cod = 1
                         and tp1cod1 = 11164
                         and tp1corr1 = 1
                         and tp1corr2 = 4)
                 and x.XWFPRCINS in
                     (select wfinsprcid
                        from wfwrkitems wf
                       where wf.wfinsprcid = x.xwfprcins
                         and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and wf.wfiteminit =
                             (select max(wfiteminit)
                                from wfwrkitems w
                               where w.wfinsprcid = x.xwfprcins
                                 and w.WFSTSCOD not in
                                     ('C', 'D', 'B', 'E', 'T')
                                 and w.wfitemstsact = 1
                                    --and wftaskcod = 11
                                 and w.wfiteminit >=
                                     to_date('2013.07.01', 'yyyy.mm.dd'))
                            --and wftaskcod = 11
                         and wf.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))) loop
      begin
        pq_cr_automatizacion_ccsueldo.SP_CR_CERRAR_INSTANCIA(i.xwfprcins);
      exception
        when others then
          null;
      end;
    end loop;
  end SP_CR_CERRAR_INSTANCIAS_suc;
  ----------------------------------------------------------------------------
  Function fn_cr_verifica_tarea2(pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number is
    --
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
  begin
  
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
  
    begin
    
      lc_pac_nombre := trim(pn_paquete) || '.' || trim(pn_proceso);
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    exception
      when others then
        null;
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea2;
  ----------------------------------------------------------------------------
  procedure sp_cr_job_cerrar_instancia(pn_usuario in varchar2) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
  
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
  
    x number;
  
    lb_njobs number(3);
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
      --or sucurs >= 900
      ;
  
  begin
  
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
    begin
      select x.tp1imp1
        into lb_njobs
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11164
         and x.TP1CORR1 = 1
         and x.tp1corr2 = 3
         and x.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'CRINS' || lc_user;
    lc_paquete    := 'pq_cr_automatizacion_ccsueldo';
    lc_proceso    := 'sp_cr_cerrar_instancias_suc';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    for i in sucursal loop
      ln_ini := i.sucurs;
      ln_job := ln_job + 1;
      --lc_prefjob    := 'REA_REP_1';
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_automatizacion_ccsueldo.sp_cr_cerrar_instancias_suc( ' ||
                       ln_ini || ' );' || ' End;';
    
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
      --('REA_REP_1', ln_ini, lc_variable);
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_automatizacion_ccsueldo.fn_cr_verifica_tarea2(lc_paquete,
                                                                     lc_proceso,
                                                                     pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_automatizacion_ccsueldo.fn_cr_verifica_tarea2(lc_paquete,
                                                                       lc_proceso,
                                                                       pn_usuario);
    End loop;
  
  end sp_cr_job_cerrar_instancia;
  ----------------------------------------------------------------------------
  procedure sp_cr_automatizacion_base is
  begin
    --cerrar instancias
    begin
      pq_cr_automatizacion_ccsueldo.sp_cr_job_cerrar_instancia('BANTPROD');
    exception
      when others then
        null;
    end;
  
    --generar nueva base
    pq_cr_adelantosueldo.sp_cr_job_cargaaqpb606; -- se solicito verificar la finalizacion de jobs, este proc ya cuenta con eso
    pq_cr_adelantosueldo.sp_cr_cargaaqpb607;
  
    --enviar correo 
    begin
      pq_cr_automatizacion_ccsueldo.sp_cr_enviocorreo;
    exception
      when others then
        null;
    end;
  end;
  -------------------------------------------------------------------------------
  procedure sp_cr_enviocorreo is
  
    cursor correos is
      SELECT *
        FROM FST198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 1
         and tp1corr2 = 1;
  
    fecha_proceso DATE;
    --------------------           
  
    flg_hdata char(1);
  
    --------------------          
    subject varchar2(1000);
    --------------------              
    v_header  varchar2(10000); -- Cabecera
    v_wstring clob;
    data      varchar2(32000);
  
    --------------------
  
    remitente varchar(80);
  
    ----------------------
    contador number := 0;
  
    ----------------------   
    ld_fechamax       date;
    lc_td_activa      varchar2(2);
    lc_acceso_app     varchar2(2);
    lc_acceso_app_ope varchar2(2);
    lc_autori_dp      varchar2(2);
    lc_correo         varchar2(70);
    lv_to             varchar2(200);
    ---------------
    lc_null_contac char(1);
    ln_cont_contac number;
  begin
    begin
      select max(aqpb607fecc) into ld_fechamax from aqpb607;
    exception
      when others then
        ld_fechamax := null;
    end;
    begin
      SELECT trim(tp1desc)
        into lc_null_contac
        FROM FST198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1corr3 > 0;
    exception
      when others then
        lc_null_contac := 'N';
    end;
    remitente := 'notificaciones@cajaarequipa.pe';
  
    ---------------------------------------------------------------------------------
  
    for i in (select *
                from (SELECT aqpb607paid,
                             a.aqpb607tipd,
                             a.aqpb607numd,
                             a.aqpb607tipoc,
                             b.pfape1,
                             b.pfape2,
                             b.pfnom1,
                             b.pfnom2,
                             a.monto_tot,
                             a.oferta1,
                             a.nrocuotas1,
                             a.oferta2,
                             a.nrocuotas2,
                             a.oferta3,
                             a.nrocuotas3,
                             c.dotelfp,
                             d.pextxt,
                             b.pfebco,
                             f.wfusremail,
                             ROW_NUMBER() OVER(PARTITION BY a.aqpb607numd ORDER BY d.pexren, c.docod, c.doordp) AS row_num
                        FROM (select aqpb607paid,
                                     aqpb607tipd,
                                     aqpb607numd,
                                     aqpb607tipoc,
                                     max(aqpb607mntprop) monto_tot,
                                     max(oferta1) oferta1,
                                     max(nrocuotas1) nrocuotas1,
                                     max(oferta2) oferta2,
                                     max(nrocuotas2) nrocuotas2,
                                     max(oferta3) oferta3,
                                     max(nrocuotas3) nrocuotas3
                                from (select aqpb607paid,
                                             aqpb607tipd,
                                             aqpb607numd,
                                             aqpb607mntprop,
                                             aqpb607tipoc,
                                             aqpb607mond    oferta1,
                                             aqpb607nroc    nrocuotas1,
                                             0              oferta2,
                                             0              nrocuotas2,
                                             0              oferta3,
                                             0              nrocuotas3
                                        from (select m.aqpb607paid,
                                                     m.aqpb607tipd,
                                                     m.aqpb607numd,
                                                     m.aqpb607mntprop,
                                                     m.aqpb607mond,
                                                     m.aqpb607nroc,
                                                     m.aqpb607tipoc,
                                                     ROW_NUMBER() OVER(PARTITION BY m.aqpb607numd ORDER BY m.aqpb607mond) AS row_num
                                                from aqpb607 m
                                               where m.aqpb607fecc = ld_fechamax
                                                 and m.aqpb607est = 'H')
                                       where row_num = 1
                                      union all
                                      select aqpb607paid,
                                             aqpb607tipd,
                                             aqpb607numd,
                                             aqpb607mntprop,
                                             aqpb607tipoc,
                                             0              oferta1,
                                             0              nrocuotas1,
                                             aqpb607mond    oferta2,
                                             aqpb607nroc    nrocuotas2,
                                             0              oferta3,
                                             0              nrocuotas3
                                        from (select m.aqpb607paid,
                                                     m.aqpb607tipd,
                                                     m.aqpb607numd,
                                                     m.aqpb607mntprop,
                                                     m.aqpb607mond,
                                                     m.aqpb607nroc,
                                                     m.aqpb607tipoc,
                                                     ROW_NUMBER() OVER(PARTITION BY m.aqpb607numd ORDER BY m.aqpb607mond) AS row_num
                                                from aqpb607 m
                                               where m.aqpb607fecc = ld_fechamax
                                                 and m.aqpb607est = 'H')
                                       where row_num = 2
                                      union all
                                      select aqpb607paid,
                                             aqpb607tipd,
                                             aqpb607numd,
                                             aqpb607mntprop,
                                             aqpb607tipoc,
                                             0              oferta1,
                                             0              nrocuotas1,
                                             0              oferta2,
                                             0              nrocuotas2,
                                             aqpb607mond    oferta3,
                                             aqpb607nroc    nrocuotas3
                                        from (select m.aqpb607paid,
                                                     m.aqpb607tipd,
                                                     m.aqpb607numd,
                                                     m.aqpb607mntprop,
                                                     m.aqpb607mond,
                                                     m.aqpb607nroc,
                                                     m.aqpb607tipoc,
                                                     ROW_NUMBER() OVER(PARTITION BY m.aqpb607numd ORDER BY m.aqpb607mond) AS row_num
                                                from aqpb607 m
                                               where m.aqpb607fecc = ld_fechamax
                                                 and m.aqpb607est = 'H')
                                       where row_num = 3)
                               group by aqpb607paid,
                                        aqpb607tipd,
                                        aqpb607numd,
                                        aqpb607tipoc) a
                        join fsd002 b
                          on a.aqpb607paid = b.PFPAIS
                         and a.aqpb607tipd = b.PFTDOC
                         and rpad(a.aqpb607numd, 12) = b.PFNDOC
                        left join fsr005 c
                          on a.aqpb607paid = c.pepais
                         and a.aqpb607tipd = c.petdoc
                         and rpad(a.aqpb607numd, 12) = c.pendoc
                        left join fsx001 d
                          on a.aqpb607paid = d.pepais
                         and a.aqpb607tipd = d.petdoc
                         and rpad(a.aqpb607numd, 12) = d.pendoc
                        left join jaqn002 e
                          on b.pfpais = e.jaqn002pai
                         and b.pftdoc = e.jaqn002tdo
                         and b.pfndoc = e.jaqn002ndo
                        left join wfusers f
                          on e.jaqn002usr = f.wfusrcod)
               where row_num = 1) loop
      contador          := contador + 1;
      lc_td_activa      := 'NO';
      lc_acceso_app     := 'NO';
      lc_acceso_app_ope := 'NO';
      lc_autori_dp      := 'NO';
      begin
        select 'SI'
          into lc_td_activa
          from z0e478 e
        --left join jaqz205 f on e.z0e478nro = f.jaqz205nutar
         where e.z0e478thp = i.aqpb607paid
           and e.z0e478tht = i.aqpb607tipd
           and e.z0e478thd = rpad(i.aqpb607numd, 12)
           and e.z0e463cod = 1;
      exception
        when others then
          lc_td_activa := 'NO';
      end;
      begin
        select 'SI'
          into lc_acceso_app
          from z0e478 e
          join jaqz205 f
            on e.z0e478nro = f.jaqz205nutar
         where e.z0e478thp = i.aqpb607paid
           and e.z0e478tht = i.aqpb607tipd
           and e.z0e478thd = rpad(i.aqpb607numd, 12)
           and e.z0e463cod = 1;
      exception
        when others then
          lc_acceso_app := 'NO';
      end;
      begin
        select 'SI'
          into lc_acceso_app_ope
          from z0e478 e
          join jaqz205 f
            on e.z0e478nro = f.jaqz205nutar
         where e.z0e478thp = i.aqpb607paid
           and e.z0e478tht = i.aqpb607tipd
           and e.z0e478thd = rpad(i.aqpb607numd, 12)
           and e.z0e463cod = 1
           and f.jaqz205estok in (1, 2);
      exception
        when others then
          lc_acceso_app_ope := 'NO';
      end;
    
      ln_cont_contac := 0;
      if lc_null_contac = 'S' then
        begin
          select count(*)
            into ln_cont_contac
            from aqpa106 x
           where x.aqpa106pai = i.aqpb607paid
             and x.aqpa106tpo = i.aqpb607tipd
             and x.aqpa106num = rpad(i.aqpb607numd, 12);
        exception
          when others then
            ln_cont_contac := 0;
        end;
        if ln_cont_contac = 0 then
          lc_autori_dp := 'SI';
        else
          begin
            select 'SI'
              into lc_autori_dp
              from aqpa106 x
             where x.aqpa106pai = i.aqpb607paid
               and x.aqpa106tpo = i.aqpb607tipd
               and x.aqpa106num = rpad(i.aqpb607numd, 12)
               and x.aqpa106est in (SELECT trim(tp1desc)
                                      FROM FST198
                                     where tp1cod = 1
                                       and tp1cod1 = 11164
                                       and tp1corr1 = 1
                                       and tp1corr2 = 6
                                       and tp1corr3 > 0)
               and rownum = 1;
          exception
            when others then
              lc_autori_dp := 'NO';
          end;
        end if;
      else
        begin
          select 'SI'
            into lc_autori_dp
            from aqpa106 x
           where x.aqpa106pai = i.aqpb607paid
             and x.aqpa106tpo = i.aqpb607tipd
             and x.aqpa106num = rpad(i.aqpb607numd, 12)
             and x.aqpa106est in (SELECT trim(tp1desc)
                                    FROM FST198
                                   where tp1cod = 1
                                     and tp1cod1 = 11164
                                     and tp1corr1 = 1
                                     and tp1corr2 = 6
                                     and tp1corr3 > 0)
             and rownum = 1;
        exception
          when others then
            lc_autori_dp := 'NO';
        end;
      end if;
      if i.pfebco = 'S' then
        lc_correo := i.wfusremail;
      else
        if instr(i.pextxt, '\') = 0 then
          lc_correo := i.pextxt;
        else
          lc_correo := substr(i.pextxt, 1, instr(i.pextxt, '\') - 1);
        end if;
      end if;
      --replace(''''||to_char(i.aqpb607numd,'00000000'),' ', '')
      data      := to_char(i.aqpb607numd, '00000000') || chr(9) || i.pfape1 ||
                   chr(9) || i.pfape2 || chr(9) || i.pfnom1 || chr(9) ||
                   i.pfnom2 || chr(9) || i.dotelfp || chr(9) || lc_correo ||
                   chr(9) || to_char(i.monto_tot, '999999999999.99') ||
                   chr(9) || to_char(i.oferta1, '999999999999.99') ||
                   chr(9) || i.nrocuotas1 || chr(9) ||
                   to_char(i.oferta2, '999999999999.99') || chr(9) ||
                   i.nrocuotas2 || chr(9) ||
                   to_char(i.oferta3, '999999999999.99') || chr(9) ||
                   i.nrocuotas3 || chr(9) || i.aqpb607tipoc || chr(9) ||
                   lc_acceso_app || chr(9) || lc_td_activa || chr(9) ||
                   lc_acceso_app_ope || chr(9) || lc_autori_dp || chr(9) ||
                   chr(2) || utl_tcp.crlf;
      v_wstring := v_wstring || to_clob(data);
    end loop;
  
    ---------------------------------------------------------------------------------            
    flg_hdata := 'S';
    subject   := 'Automatizacion carga base cuenta sueldo'; --'Extorno Intereses devengados '||to_char(fechaFinMesAnte, 'yyyy/mm/dd');
    ------------------------------------------------------------------------------
    v_header := 'MIME-Version: 1.0' || utl_tcp.crlf -- Use MIME mail standard
                || 'Content-Type: multipart/mixed;' || utl_tcp.crlf ||
                ' boundary=-----SECBOUND' || utl_tcp.crlf || utl_tcp.crlf ||
                '-------SECBOUND' || utl_tcp.crlf ||
                'Content-Type: text/plain;' || utl_tcp.crlf ||
                'Content-Transfer_Encoding: 8bit' || --8bit
                utl_tcp.crlf || utl_tcp.crlf || 'Estimados,' || CHR(13) ||
                'Buenos días' || CHR(13) ||
                'Se adjunta el listado de carga base cuenta sueldo.' ||
                CHR(13) || CHR(13) || CHR(13) || '   ' || utl_tcp.crlf --Message Body                           
                || '-------SECBOUND' || utl_tcp.crlf ||
                'Content-Type: text/plain; charset=iso-8859-1' ||
                utl_tcp.crlf || ' name=RELACION_TRABCESE_' ||
                to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf --xls
                || 'Content-Transfer_Encoding: 8bit' || --8bit
                utl_tcp.crlf || 'Content-Disposition: attachment;' ||
                utl_tcp.crlf ||
                ' filename=Listado_carga_base_cuenta_sueldo_' ||
                to_char(ld_fechamax, 'DDMMRRRR') || '.xls' || utl_tcp.crlf ||
                utl_tcp.crlf;
    ------------------------------------------------------------------------------                       
    v_header := v_header || 'DNI' || chr(9) || 'APELLIDOS' || chr(9) || ' ' ||
                chr(9) || 'NOMBRES' || chr(9) || ' ' || chr(9) ||
                'TELEFONO' || chr(9) || 'CORREO' || chr(9) || 'MONTO TOTAL' ||
                chr(9) || 'OFERTA 1' || chr(9) || 'NRO DE CUOTAS' || chr(9) ||
                'OFERTA 2' || chr(9) || 'NRO DE CUOTAS' || chr(9) ||
                'OFERTA 3' || chr(9) || 'NUMERO DE CUOTAS' || chr(9) ||
                'TIPO DE OPERACION' || chr(9) || 'TIENE APP' || chr(9) ||
                'TD ACTIVA' || chr(9) || 'APP CON ACCESO A OPERACIONES' ||
                chr(9) || 'CONTACTABLE' || chr(9);
  
    -------------------------------------------------------------------------------
  
    if v_wstring is not null then
      For k in correos loop
        lv_to := lv_to || trim(k.tp1desc) || '@cajaarequipa.pe' || ';';
      End loop;
    
      sp_cr_config_mail(remitente, --de
                        lv_to, --'rmontesr@cajaarequipa.pe;dcastro@cajaarequipa.pe;apachecoh@cajaarequipa.pe',--trim(corr.tp1desc) || '@cajaarequipa.pe', --para
                        subject, -- asunto
                        fecha_proceso, -- 
                        --------------------                           
                        v_header, -- Cabecera
                        v_wstring -- Detalle Excel
                        );
    end if;
    v_wstring := '';
  
  end;
  -----------------------------------------------------------------------
  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject
                              -------------------------                            
                              fecha_proceso in date, -- Fecha de proceso
                              --------------------                           
                              v_header in varchar2, -- Cabecera
                              rawdata  in clob -- Detalle Excel
                              ) is
    --Cursor
    cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;
    -- Variables
    c_smtp_server VARCHAR2(30);
    port          number;
    host          VARCHAR2(100);
    -- 
    lc_hostname varchar2(64);
    lv_smtp     varchar2(30);
    lv_host     varchar2(30);
    ln_port     number(9);
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      WHEN NO_DATA_FOUND then
        lc_hostname := '';
    end;
  
    For i in c_host loop
      lv_host := upper(TRIM(substr(i.tp1desc, 1, instr(i.tp1desc, '/') - 1)));
      lv_smtp := TRIM(substr(i.tp1desc,
                             instr(i.tp1desc, '/') + 1,
                             length(trim(i.tp1desc))));
      ln_port := i.tp1nro3;
    
      if upper(lc_hostname) = lv_host then
      
        Exit;
      End if;
    End loop;
  
    c_smtp_server := lv_smtp; --'10.0.200.68';
    port          := ln_port; --2530;
  
    host := lv_host;
  
    sp_cr_mail_root(p_c_de, --de
                    p_c_recipiente, --para
                    subject, --subject
                    fecha_proceso, --fecha de procesamiento
                    -------------------------
                    c_smtp_server, -- ip del servidor
                    port, -- puerto del servidor
                    host, -- host del servidor
                    -------------------------                            
                    v_header, -- Cabecera
                    rawdata -- Detalle Excel
                    );
  end;
  -----------------------------------------------------------------------
  procedure sp_cr_mail_root(p_c_de         in varchar2, -- De
                            p_c_recipiente in varchar2, -- Para
                            subject        in varchar2, -- Subject
                            fecha_proceso  in date, -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port          in NUMBER, -- Puerto
                            host          in varchar2, -- Host
                            --------------------                            
                            v_header in varchar2, -- Cabecera
                            rawdata  in clob -- Detalle Excel
                            ) is
  
    cursor correosCopias is
      SELECT *
        FROM FST198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 1
         and tp1corr2 = 2; --para los correos de copias
  
    auxiliar    varchar2(32000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
  
    lv_destinos varchar2(200);
  
    v_Subject  VARCHAR2(80);
    V_Conexion utl_smtp.Connection;
  
    msg        varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2(100);
    v_found    number;
  
    l_n_offset NUMBER := 630;
  begin
  
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  
    -- IF UPPER(VHOST_NAME) IN ('BTRAC1051','BTRAC1052',host) then 
    -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101',host) then
    -- IF UPPER(VHOST_NAME) IN  ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051') then
    v_From      := p_c_de;
    v_Recipient := P_C_RECIPIENTE;
    v_Subject   := subject;
  
    SELECT count(*)
      into v_found
      FROM systabrep.hostnames
     where habilitado = 'S'
       and upper(host_name) = UPPER(vhost_name);
  
    For k in correosCopias loop
      lv_destinos := lv_destinos || trim(k.tp1desc) || '@cajaarequipa.pe' || ';';
    End loop;
    if lv_destinos is not null then
      lv_destinos := substr(lv_destinos, 1, length(lv_destinos) - 1);
    End If;
  
    if v_found = 1 then
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, Port);
      msg        := 'Date: ' ||
                    to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'CC:' ||
                    lv_destinos || utl_tcp.crlf || 'To: ' || v_Recipient ||
                    utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
      utl_smtp.Mail(V_Conexion, v_From);
    
      --utl_smtp.Rcpt(V_Conexion, v_Recipient);
      For u in (SELECT *
                  FROM FST198
                 where tp1cod = 1
                   and tp1cod1 = 11164
                   and tp1corr1 = 1
                   and tp1corr2 = 1) loop
        --enviar a los copias
        utl_smtp.Rcpt(V_Conexion, trim(u.tp1desc) || '@cajaarequipa.pe');
      End loop;
    
      For m in CorreosCopias loop
        --enviar a los copias
        utl_smtp.Rcpt(V_Conexion, trim(m.tp1desc) || '@cajaarequipa.pe');
      End loop;
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      --Se escribe el contenido del mensaje 
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
      FOR loop_att IN 0 .. TRUNC(DBMS_LOB.getlength(rawdata) / l_n_offset) LOOP
        auxiliar := DBMS_LOB.substr(rawdata,
                                    l_n_offset,
                                    loop_att * l_n_offset + 1);
        UTL_SMTP.write_data(V_Conexion, auxiliar);
      END LOOP;
    
      --UTL_smtp.write_raw_data(V_Conexion, UTL_ENCODE.base64_encode(rawdata));
      --datas := (CAST(rawdata as long raw);
      --UTL_smtp.write_raw_data(V_Conexion, rawData);
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    end if;
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000,
                              'Unable to send mail: ' || p_c_msgerr);
  end;
  -----------------------------------------------------------------------
end pq_cr_automatizacion_ccsueldo;
/

