create or replace package PQ_CR_FIMPULSO_PERU is

  -- Author  : RMONTESR
  -- Created : 18/05/2023 10:22:26
  -- Purpose : Procedimientos Fondo Impulso Peru
  -- Modified by: RMONTESR
  -- Modified : 02/01/2024
  -- Purpose : Se agrego funcionalidad para dar de baja a creditos cancelados
  -- Modified by: RMONTESR
  -- Modified : 08/01/2024
  -- Purpose : Se modifico proceso que obtiene calve del credits aqpc364
  -- Modified by: AANGLES
  -- Modified : 26/03/2024
  -- Purpose : Se modifico el proceso update_aqpc364 y update_aqpc363
  -----------------------------------------------------------------
  procedure sp_cr_anular_reg(pd_fcar in date,
                             pn_pais in number,
                             pn_tdoc in number,
                             pv_ndoc in varchar2,
                             pn_cta  in number,
                             pv_user in varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_update_aqpc363(pc out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_anular_reg_t1(pd_fcar in date,
                                pn_pais in number,
                                pn_tdoc in number,
                                pv_ndoc in varchar2,
                                pn_cta  in number,
                                pn_ope  in number,
                                pv_user in varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_update_aqpc364(ld_MaxInsr364 in varchar2,
                                 lc_MaxHora364 in varchar2,
                                 pc            out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_cerrar_instancia(LN_INS NUMBER);
  -----------------------------------------------------------------------
  procedure sp_cr_cerrar_instancias_suc(ln_suc number);
  -----------------------------------------------------------------------
  Function fn_cr_verifica_tarea2(pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number;
  -----------------------------------------------------------------------
  procedure sp_cr_job_cerrar_instancia(pn_usuario in varchar2);
  -----------------------------------------------------------------
  procedure sp_cr_anular_cancelados(pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbop in number,
                                    pn_tope in number,
                                    pv_rpta out varchar2);

end PQ_CR_FIMPULSO_PERU;
/

create or replace package body PQ_CR_FIMPULSO_PERU is

  procedure sp_cr_anular_reg(pd_fcar in date,
                             pn_pais in number,
                             pn_tdoc in number,
                             pv_ndoc in varchar2,
                             pn_cta  in number,
                             pv_user in varchar2) is
  begin
    begin
      update aqpc363
         set aqpc363est  = 'N',
             aqpc363fedi = to_char(sysdate, 'DD/MM/YYYY'),
             aqpc363hedi = to_char(sysdate, 'HH24:MI:SS'),
             aqpc363uedi = rpad(pv_user, 10)
       where 1 = 1
            --AND aqpc363fcar = pd_fcar
         and aqpc363pais = pn_pais
         and aqpc363tdoc = pn_tdoc
         and aqpc363ndoc = rpad(pv_ndoc, 12)
            --and aqpc363cta1 = pn_cta;
         and aqpc363est = 'S';
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_anular_reg;
  ------------------------------------------------------------------------------
  procedure sp_cr_update_aqpc363(pc out varchar2) is
  begin
    update aqpc363 t
       set t.aqpc363ncli =
           (select trim(pfape1) || ' ' || trim(pfape2) || ', ' ||
                   trim(pfnom1) || ' ' || trim(pfnom2) as ncli
              from fsd002 m
             where m.pfpais = t.aqpc363pais
               and m.pftdoc = t.aqpc363tdoc
               and m.pfndoc = t.aqpc363ndoc)
     where aqpc363est = 'S'
       and exists (select 1
              from fsd002 m
             where m.pfpais = t.aqpc363pais
               and m.pftdoc = t.aqpc363tdoc
               and m.pfndoc = t.aqpc363ndoc);
    commit;
  end sp_cr_update_aqpc363;
  ------------------------------------------------------------------------------
  procedure sp_cr_anular_reg_t1(pd_fcar in date,
                                pn_pais in number,
                                pn_tdoc in number,
                                pv_ndoc in varchar2,
                                pn_cta  in number,
                                pn_ope  in number,
                                pv_user in varchar2) is
  begin
    begin
      update aqpc364
         set aqpc364est  = 'N',
             aqpc364fedi = to_char(sysdate, 'DD/MM/YYYY'),
             aqpc364hedi = to_char(sysdate, 'HH24:MI:SS'),
             aqpc364uedi = rpad(pv_user, 10)
       where 1 = 1
            --AND aqpc364fcar = pd_fcar
         and aqpc364pais = pn_pais
         and aqpc364tdoc = pn_tdoc
         and aqpc364ndoc = rpad(pv_ndoc, 12)
         and aqpc364ctacc = pn_cta
         and aqpc364opecc = pn_ope;
      commit;
    exception
      when others then
        null;
    end;
  end sp_cr_anular_reg_t1;
  ------------------------------------------------------------------------------
  procedure sp_cr_update_aqpc364(ld_MaxInsr364 in varchar2,
                                 lc_MaxHora364 in varchar2,
                                 pc            out varchar2) is
  
    cursor registros is
    
      select *
        from aqpc364 a
       where a.aqpc364fcre = ld_MaxInsr364
         and a.aqpc364hcre = lc_MaxHora364
         and a.aqpc364est = 'S';
  
    ln_pgcod    number;
    ln_mod      number;
    ln_suc      number;
    ln_mda      number;
    ln_pap      number;
    ln_sbop     number;
    ln_tope     number;
    ln_sald     number(17, 2) := 0.00;
    lc_reg      varchar2(45);
    lc_zona     varchar2(45);
    lc_agen     varchar2(45);
    lc_analista varchar2(12);
    ln_nrotelf  varchar2(20);
    lc_ndoc     char(12);
    --  ld_MaxInsr364 date;
    --   lc_MaxHora364 varchar2(10);
    lc_ncli    varchar2(80);
    lc_ncliAux varchar2(110);
  
  begin
  
    /*   begin
      select max(a.aqpc364fcre) into ld_MaxInsr364 from aqpc364 a;
    exception
      when others then
        null;
    end;
    
    if ld_MaxInsr364 is not null then
      begin
        select max(a.aqpc364hcre)
          into lc_MaxHora364
          from aqpc364 a
         where a.aqpc364fcre = ld_MaxInsr364;
      exception
        when others then
          null;
      end;
    end if;*/
  
    for r in registros loop
      ln_nrotelf  := null;
      ln_pgcod    := 0;
      ln_mod      := 0;
      ln_suc      := 0;
      ln_mda      := 0;
      ln_pap      := 0;
      ln_sbop     := 0;
      ln_tope     := 0;
      ln_sald     := 0;
      lc_reg      := '';
      lc_zona     := '';
      lc_agen     := '';
      lc_analista := '';
    
      begin
        -- Nombre del cliente
        select trim(pfape1) || ' ' || trim(pfape2) || ', ' || trim(pfnom1) || ' ' ||
               trim(pfnom2)
          into lc_ncliAux
          from fsd002 m
         where m.pfpais = r.aqpc364pais
           and m.pftdoc = r.aqpc364tdoc
           and m.pfndoc = r.aqpc364ndoc;
      exception
        when others then
          null;
      end;
    
      lc_ncli := substr(lc_ncliAux, 0, 80);
    
      begin
        select f.PGCOD,
               f.AOMOD,
               f.AOSUC,
               f.AOMDA,
               f.AOPAP,
               f.AOSBOP,
               f.AOTOPE
          into ln_pgcod, ln_mod, ln_suc, ln_mda, ln_pap, ln_sbop, ln_tope
          from fsd010 f
         where f.PGCOD = 1
           and (f.AOMOD in
               (select g.modulo
                   from fst111 g
                  where g.dscod = 50
                    and g.modulo not in (29, 33, 142, 144, 200)) or
               f.AOMOD = 117)
           and f.AOMDA in (0, 101)
           and f.AOPAP = 0
           and f.AOSTAT <> 99
           and f.AOCTA = r.aqpc364ctacc
           and f.AOOPER = r.aqpc364opecc;
      exception
        when others then
          null;
      end;
    
      begin
        select f.scsdo
          into ln_sald
          from fsd011 f
         where f.PGCOD = ln_pgcod
           and f.SCMOD = ln_mod
           and f.SCSUC = ln_suc
           and f.SCMDA = ln_mda
           and f.SCPAP = ln_pap
           and f.SCCTA = r.aqpc364ctacc
           and f.SCOPER = r.aqpc364opecc
           and f.SCSBOP = ln_sbop
           and f.SCTOPE = ln_tope;
      exception
        when others then
          null;
      end;
    
      if ln_sald < 0 then
        ln_sald := ln_sald * -1;
      end if;
    
      begin
      
        select upper(r.regnom), upper(r.deszon), upper(r.scnom)
          into lc_reg, lc_zona, lc_agen
          from regsuc r
         where r.sucurs = ln_suc;
      exception
        when others then
          null;
      end;
    
      lc_analista := fn_analista_credito(v_Scmod  => ln_mod,
                                         v_Scsuc  => ln_suc,
                                         v_Scmda  => ln_mda,
                                         v_Scpap  => ln_pap,
                                         v_Sccta  => r.aqpc364ctacc,
                                         v_Scoper => r.aqpc364opecc,
                                         v_Scsbop => ln_sbop,
                                         v_Sctope => ln_tope);
      lc_ndoc     := trim(r.aqpc364ndoc);
    
      begin
        select f.dotelfp
          into ln_nrotelf
          from fsr005 f
         where f.pepais = r.aqpc364pais
           and f.petdoc = r.aqpc364tdoc
           and f.pendoc = rpad(lc_ndoc, 12, ' ');
      exception
        when others then
          null;
      end;
      if ln_pgcod > 0 then
        begin
          update aqpc364 a
             set a.aqpc364ncli   = lc_ncli,
                 a.aqpc364cta1   = r.aqpc364ctacc,
                 a.aqpc364empcc  = ln_pgcod,
                 a.aqpc364modcc  = ln_mod,
                 a.aqpc364succc  = ln_suc,
                 a.aqpc364mdacc  = ln_mda,
                 a.aqpc364papcc  = ln_pap,
                 a.aqpc364sbocc  = ln_sbop,
                 a.aqpc364topecc = ln_tope,
                 a.aqpc364sdocc  = ln_sald,
                 a.aqpc364reg    = lc_reg,
                 a.aqpc364zona   = lc_zona,
                 a.aqpc364age    = lc_agen,
                 a.aqpc364anlst  = lc_analista,
                 a.aqpc364ncel   = ln_nrotelf
           where a.aqpc364ctacc = r.aqpc364ctacc
             and a.aqpc364opecc = r.aqpc364opecc
             and a.aqpc364fcre = ld_MaxInsr364
             and a.aqpc364hcre = lc_MaxHora364
             and a.aqpc364est = 'S';
          commit;
        exception
          when others then
            null;
        end;
      end if;
    end loop;
  
    --cambiamos a estado N los casos q no encuentre valor en la fsd010
    begin
      update aqpc364 t
         set aqpc364est = 'N'
       where t.aqpc364est = 'S'
         and t.aqpc364empcc = 0
         and t.aqpc364fcre = ld_MaxInsr364
         and t.aqpc364hcre = lc_MaxHora364;
      commit;
    exception
      when others then
        null;
    end;
    pc := 'Fin carga';
  end sp_cr_update_aqpc364;
  -------------------------------------------------------------------
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
      (user, sysdate, 'SP_CR_CERRAR_INSTANCIA', LN_INS, 101, 360);
    commit;
  END SP_CR_CERRAR_INSTANCIA;
  ----------------------------------------------------------------------------
  procedure SP_CR_CERRAR_INSTANCIAS_suc(ln_suc in number) is
  
    cursor instancias is
      select *
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfsucursal = ln_suc
         and x.xwfcar3 = '1'
         and x.xwfmodulo = 101
         and x.xwftipope = 360
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
                    --and wftaskcod = 11
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'));
  
  begin
  
    for i in instancias loop
      -- MPOSTIGOC 10.07.2023
      begin
        update jaqy800 j
           set j.jaqy800vinc = 'N'
         where j.jaqy800ins in
               (select s.sng001inst
                  from sng001 s, sng001 d
                 where s.sng001pais = d.sng001pais
                   and s.sng001tdoc = d.sng001tdoc
                   and s.sng001ndoc = d.sng001ndoc
                   and d.sng001inst = i.xwfprcins)
           and j.jaqy800vinc = 'S';
        commit;
      end;
    
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
    ld_fec589  date;
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    char(12);
    ln_dias    number;
    ld_factual date;
    cursor instancias is
      select *
        from xwf700 x
       where x.xwfempresa = 1
            --and x.xwfsucursal = ln_suc
         and x.xwfcar3 = '1'
         and x.xwfmodulo = 101
         and x.xwftipope = 360
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
                    --and wftaskcod = 11
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'));
  
  begin
  
    for i in instancias loop
      begin
        select pepais, petdoc, pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008
         where pgcod = 1
           and ctnro = i.xwfcuenta
           and cttfir = 'T';
      exception
        when others then
          null;
      end;
      begin
        select pgfape into ld_factual from fst017 where pgcod = 1;
      exception
        when others then
          null;
      end;
      begin
        select aqpc589fecpro
          into ld_fec589
          from aqpc589
         where aqpc589estpro = 'A'
           and aqpc589esthab = 'H'
           and aqpc589pais = ln_pais
           and aqpc589ptdc = ln_tdoc
           and rpad(aqpc589dni, 12) = lc_ndoc
           and rownum = 1;
      exception
        when others then
          ld_fec589 := ld_factual;
      end;
      begin
        select tp1nro1
          into ln_dias
          from fst198
         where tp1cod1 = 11161
           and tp1corr1 = 50
           and tp1corr2 = 3
           and tp1corr3 = 1;
      exception
        when others then
          null;
      end;
    
      if ld_factual - ld_fec589 > ln_dias then
        begin
          update jaqy800 j
             set j.jaqy800vinc = 'N'
           where j.jaqy800ins in
                 (select s.sng001inst
                    from sng001 s, sng001 d
                   where s.sng001pais = d.sng001pais
                     and s.sng001tdoc = d.sng001tdoc
                     and s.sng001ndoc = d.sng001ndoc
                     and d.sng001inst = i.xwfprcins)
             and j.jaqy800vinc = 'S';
          commit;
        exception
          when others then
            null;
        end;
      
        begin
          pq_cr_automatizacion_ccsueldo.SP_CR_CERRAR_INSTANCIA(i.xwfprcins);
        exception
          when others then
            null;
        end;
      end if;
    end loop;
  
  end sp_cr_job_cerrar_instancia;
  -----------------------------------------------------------------
  procedure sp_cr_anular_cancelados(pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbop in number,
                                    pn_tope in number,
                                    pv_rpta out varchar2) is
    lc_cancel    char(1);
    lc_fondo     char(2);
    ln_guia_canc number;
    ln_guia_fond number;
  begin
    lc_cancel := 'S';
    lc_fondo  := 'NN';
    begin
      select tp1nro1
        into ln_guia_canc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 14
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_guia_canc := 0;
    end;
    begin
      select tp1nro1
        into ln_guia_fond
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 14
         and tp1corr2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        ln_guia_fond := 0;
    end;
    if ln_guia_canc = 1 then
      --cuando valor de guia es 1 se hace comprobacion 
      begin
        select 'N'
          into lc_cancel
          from fsd010
         where pgcod = pn_emp
           and aomod = pn_mod
           and aosuc = pn_suc
           and aomda = pn_mda
           and aopap = pn_pap
           and aocta = pn_cta
           and aooper = pn_ope
           and aosbop = pn_sbop
           and aotope = pn_tope
           and aostat <> 99
           and rownum = 1;
      exception
        when others then
          lc_cancel := 'S';
      end;
    else
      lc_cancel := 'N';
    end if;
    if lc_cancel = 'S' then
      begin
        update aqpc364
           set aqpc364est = 'N'
         where aqpc364est = 'S'
           and aqpc364ctacc = pn_cta
           and aqpc364opecc = pn_ope;
        commit;
        pv_rpta := 'C';
      exception
        when others then
          null;
      end;
    else
      if ln_guia_fond = 1 then
        --cuando valor en guia es 1 se hace la validacion 
        --Fondo reactiva  aqpb065b      FR
        begin
          select 'FR'
            into lc_fondo
            from aqpb065b
           where aqpb065best <> 'D'
             and aqpb065bcta = pn_cta
             and aqpb065bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --Fondo fae mype  aqpb067b      FF
        begin
          select 'FF'
            into lc_fondo
            from aqpb067b
           where aqpb067best <> 'D'
             and aqpb067bcta = pn_cta
             and aqpb067bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --Fondo crecer    aqpb073b      FC
        begin
          select 'FC'
            into lc_fondo
            from aqpb073b
           where aqpb073best <> 'D'
             and aqpb073bcta = pn_cta
             and aqpb073bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --Fondo covid     aqpb095b      FV
        begin
          select 'FV'
            into lc_fondo
            from aqpb095b
           where aqpb095best <> 'D'
             and aqpb095bcta = pn_cta
             and aqpb095bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --Fondo fae agro  aqpb379b      FA
        begin
          select 'FA'
            into lc_fondo
            from fsd010 t, fsr011 p, aqpb379b g
           where p.r1cod = g.aqpb379bcod
             and p.r2cta = g.aqpb379bcta
             and g.aqpb379best <> 'D'
             and p.r1tope in (1, 20, 550)
             and p.r2tope in (1, 20, 550)
             and p.relcod = 46
             and p.r1cod = t.pgcod
             and p.r1mod = t.aomod
             and p.r1mda = t.aomda
             and p.r1pap = t.aopap
             and p.r1cta = t.aocta
             and p.r1oper = t.aooper
             and p.r1sbop = t.aosbop
             and p.r1tope = t.aotope
             and t.aocta = pn_cta
             and t.aooper = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --fondo pae mype  aqpb394b      PM
        begin
          select 'PM'
            into lc_fondo
            from aqpb394b
           where aqpb394best <> 'D'
             and aqpb394bcta = pn_cta
             and aqpb394bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --fondo fae turismo   aqpb762b  FT
        begin
          select 'FT'
            into lc_fondo
            from aqpb762b
           where aqpb762best <> 'D'
             and aqpb762bccta = pn_cta
             and aqpb762boper = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
        --fondo fae textil    aqpc360c  FX
        begin
          select 'FX'
            into lc_fondo
            from aqpc360b
           where aqpc360best <> 'D'
             and aqpc360bcta = pn_cta
             and aqpc360bope = pn_ope
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
        if lc_fondo <> 'NN' then
          begin
            update aqpc364
               set aqpc364est = 'N'
             where aqpc364est = 'S'
               and aqpc364ctacc = pn_cta
               and aqpc364opecc = pn_ope;
            commit;
            pv_rpta := lc_fondo;
          exception
            when others then
              null;
          end;
        else
          pv_rpta := 'N';
        end if;
      else
        pv_rpta := 'N';
      end if;
    end if;
  end sp_cr_anular_cancelados;
  --------------------------------------------------------------------------------
end PQ_CR_FIMPULSO_PERU;
/

