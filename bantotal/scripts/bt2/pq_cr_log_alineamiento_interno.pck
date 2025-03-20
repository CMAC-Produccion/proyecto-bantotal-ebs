create or replace package PQ_CR_LOG_ALINEAMIENTO_INTERNO is

  -- Author  : APACHECOH
  -- Created : 7/11/2022 11:56:01
  -- Purpose : 
  procedure sp_cr_busqueda_creditos(pn_cta    in number,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pv_ndoc   in varchar2,
                                    pv_usur   in varchar2,
                                    pn_coderr out number,
                                    pv_msgerr out varchar2);

  procedure sp_cr_actualizar_vinculo(pn_cod    in number,
                                     pn_suc    in number,
                                     pn_mod    in number,
                                     pn_mda    in number,
                                     pn_pap    in number,
                                     pn_cta    in number,
                                     pn_oper   in number,
                                     pn_sbop   in number,
                                     pn_tope   in number,
                                     pv_vinc   in varchar2,
                                     pv_usur   in varchar2,
                                     pn_coderr out number,
                                     pv_msgerr out varchar2);

  procedure sp_cr_limpiar_vinculacion(pn_pais   in number,
                                      pn_tdoc   in number,
                                      pv_ndoc   in varchar2,
                                      pv_usur   in varchar2,
                                      pn_coderr out number,
                                      pv_msgerr out varchar2);

  procedure sp_cr_aceptar_vinculo(pn_cod    in number,
                                  pn_suc    in number,
                                  pn_mod    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_tope   in number,
                                  pn_mora   in number,
                                  pn_pena   in number,
                                  pn_icv    in number,
                                  pv_usur   in varchar2,
                                  pn_coderr out number,
                                  pv_msgerr out varchar2);

  procedure sp_cr_grabar_vinculacion(pn_pais   in number,
                                     pn_tdoc   in number,
                                     pv_ndoc   in varchar2,
                                     pv_usur   in varchar2,
                                     pn_coderr out number,
                                     pv_msgerr out varchar2);

  procedure sp_cr_mora_exo(pn_cod    in number,
                           pn_suc    in number,
                           pn_mod    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_tope   in number,
                           pd_fini   in date,
                           pn_coderr out number,
                           pv_msgerr out varchar2);

  procedure sp_cr_anular_mora_exo(pn_pais   in number,
                                  pn_tdoc   in number,
                                  pv_ndoc   in varchar2,
                                  pn_coderr out number,
                                  pv_msgerr out varchar2);
                                  
  procedure sp_cr_anular_exoneracionmora ;
  procedure sp_cr_reponer_exoneracion(pn_instancia in number);

end PQ_CR_LOG_ALINEAMIENTO_INTERNO;
/

create or replace package body PQ_CR_LOG_ALINEAMIENTO_INTERNO is

  procedure sp_cr_busqueda_creditos(pn_cta    in number,
                                    pn_pais   in number,
                                    pn_tdoc   in number,
                                    pv_ndoc   in varchar2,
                                    pv_usur   in varchar2,
                                    pn_coderr out number,
                                    pv_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_busqueda_creditos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.11.07
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Busca creditos vigentes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_cta ( Cuenta )
    --                              pn_pais ( Pais )
    --                              pn_tdoc ( Tipo Doc )
    --                              pv_ndoc ( Documento )
    --                              pv_usur ( Usuario )
    -- Parámetros de Salida       : pn_coderr ( Cod Error )
    --                            : pv_msgerr ( Mensaje Error ) 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    my_errm VARCHAR2(300);
    ln_pais NUMBER(4);
    ln_tdoc NUMBER(2);
    lv_ndoc VARCHAR2(12);
    fl_soli VARCHAR2(2);
    fl_tasa NUMBER(2);
    ld_fech DATE;
    lv_prin VARCHAR2(2);
    ln_tasa NUMBER(10, 6);
    ln_sald NUMBER(17, 2);
    --clave del credito principal
    ln_pgcod  number(3);
    ln_aosuc  number(3);
    ln_aomod  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
    CURSOR CUENTA_CLIENTE(v_docum VARCHAR2) IS
      select ctnro
        from fsr008 a
       where a.pgcod = 1
         and a.pendoc = rpad(v_docum, 12, ' ')
         and a.cttfir = 'T';
    CURSOR CREDITOS_CLIENTE(n_cuenta NUMBER) IS
      select aqpb299emp as PGCOD,
             aqpb299mod as AOMOD,
             aqpb299suc as AOSUC,
             aqpb299mda as AOMDA,
             aqpb299pap as AOPAP,
             aqpb299cta as AOCTA,
             aqpb299oper as AOOPER,
             aqpb299sbop as AOSBOP,
             aqpb299top as AOTOPE
           from aqpb299 
      where aqpb299emp = 1
        and aqpb299cta = n_cuenta;      
      /*select pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope
        from fsd010 a
       where a.pgcod = 1
         and a.aocta = n_cuenta
         and (a.aomod IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50) or
             a.aomod = 117)
         and a.aostat <> 99;*/
  begin
    pn_coderr := 1;
    --Fecha de Sistema
    begin
      select pgfape into ld_fech from fst017 where pgcod = 1;
    exception
      when others then
        ld_fech := to_date('01/01/2000', 'dd/mm/YYYY');
    end;
  
    --Tipo de busqueda
    if trim(pv_ndoc) is not null and pn_pais > 0 then
      ln_pais := pn_pais;
      ln_tdoc := pn_tdoc;
      lv_ndoc := pv_ndoc;
      begin
        select aqpb299emp,
               aqpb299mod,
               aqpb299suc,
               aqpb299mda,
               aqpb299pap,
               aqpb299cta,
               aqpb299oper,
               aqpb299sbop,
               aqpb299top
          into ln_pgcod,
               ln_aomod,
               ln_aosuc,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          from aqpb299 b
         where b.aqpb299pais = ln_pais
           and b.aqpb299tdoc = ln_tdoc
           and b.aqpb299doc = rpad(lv_ndoc, 12, ' ')
           and b.aqpb299ancla = 'ancla'
           and rownum = 1
         order by aqpb299emp,
                  aqpb299mod,
                  aqpb299suc,
                  aqpb299mda,
                  aqpb299pap,
                  aqpb299cta,
                  aqpb299oper,
                  aqpb299sbop,
                  aqpb299top;
      exception
        when others then
          --DBMS_OUTPUT.put_line('Error: ' || sqlerrm);
          pn_coderr := 0;
      end;
    else
      begin
        select pepais, petdoc, trim(pendoc)
          into ln_pais, ln_tdoc, lv_ndoc
          from fsr008 a
         where a.pgcod = 1
           and a.ctnro = pn_cta
           and a.cttfir = 'T';
      exception
        when others then
          pn_coderr := 0;
      end;
      begin
        select aqpb299emp,
               aqpb299mod,
               aqpb299suc,
               aqpb299mda,
               aqpb299pap,
               aqpb299cta,
               aqpb299oper,
               aqpb299sbop,
               aqpb299top
          into ln_pgcod,
               ln_aomod,
               ln_aosuc,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          from aqpb299 b
         where b.aqpb299pais = ln_pais
           and b.aqpb299tdoc = ln_tdoc
           and b.aqpb299doc = rpad(lv_ndoc, 12, ' ')
           and b.aqpb299ancla = 'ancla'
           and rownum = 1
         order by aqpb299emp,
                  aqpb299mod,
                  aqpb299suc,
                  aqpb299mda,
                  aqpb299pap,
                  aqpb299cta,
                  aqpb299oper,
                  aqpb299sbop,
                  aqpb299top;
      exception
        when others then
          pn_coderr := 0;
      end;
    end if;
    --Existe en tabla de Riesgos    
    if pn_coderr = 0 then
      pv_msgerr := 'Cliente no encontrado en tabla de Riesgos.';
      return;
    end if;
    --Ampliaciones
    begin
      pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_pgcod,
                                              ln_aomod,
                                              ln_aosuc,
                                              ln_aomda,
                                              ln_aopap,
                                              ln_aocta,
                                              ln_aooper,
                                              ln_aosbop,
                                              ln_aotope,
                                              fl_soli);
    exception
      when others then
        pn_coderr := 0;
    end;
    if pn_coderr = 0 or fl_soli = 'S' then
      pv_msgerr := 'Credito ancla tiene una solicitud en proceso.';
      return;
    end if;
    --Refinanciaciones
    begin
      pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod,
                                              ln_aomod,
                                              ln_aosuc,
                                              ln_aomda,
                                              ln_aopap,
                                              ln_aocta,
                                              ln_aooper,
                                              fl_soli);
    exception
      when others then
        pn_coderr := 0;
    end;
    if pn_coderr = 0 or fl_soli = 'S' then
      pv_msgerr := 'Credito ancla tiene una solicitud en proceso.';
      return;
    end if;
    --          
    begin
      select count(*)
        into pn_coderr
                from fsd010 a
               where a.pgcod = ln_pgcod
                 and a.aosuc = ln_aosuc
                 and a.aomod = ln_aomod
                 and a.aomda = ln_aomda
                 and a.aopap = ln_aopap
                 and a.aocta = ln_aocta
                 and a.aooper = ln_aooper
                 and a.aosbop = ln_aosbop
                 and a.aotope = ln_aotope
                 and (a.aomod IN
                     (SELECT MODULO FROM FST111 WHERE DSCOD = 50) or
                     a.aomod = 117)
                 and a.aostat <> 99;     
    exception
      when others then
        pn_coderr := 0;
    end;    
    --Existe en credito principal en la fsd010 
    if pn_coderr = 0 then
      pv_msgerr := 'Credito ancla se encuentra cancelado.';
      return;
    end if;
    --Limpieza de estado
    begin
      delete from aqpb934
       where aqpb934aux1 = 0
         and aqpb934pais = ln_pais
         and aqpb934tdoc = ln_tdoc
         and aqpb934ndoc = lv_ndoc;
      /*update aqpb934
        set aqpb934est = 'I'
      where aqpb934acep <> 'G'
        and aqpb934ndoc = lv_ndoc;*/
    exception
      when others then
        null;
    end;
    --Busqueda de creditos
    for I in CUENTA_CLIENTE(lv_ndoc) loop
      for J IN CREDITOS_CLIENTE(I.CTNRO) LOOP
        fl_soli := 'S';
        --Identificar si credito es el principal
        if ln_pgcod = J.PGCOD 
          and ln_aomod = J.AOMOD 
          and ln_aosuc = J.AOSUC 
          and ln_aomda = J.AOMDA 
          and ln_aopap = J.AOPAP
          and ln_aocta = J.AOCTA
          and ln_aooper = J.AOOPER 
          and ln_aosbop = J.AOSBOP 
          and ln_aotope = J.AOTOPE then           
           lv_prin := 'S';
        else            
           lv_prin := 'N';
        end if;
        --Obtener tasa
        begin
          select evtasa
            into ln_tasa
            from fsd012 c
           where c.pgcod = J.PGCOD
             and c.aomod = J.AOMOD
             and c.aosuc = J.AOSUC
             and c.aomda = J.AOMDA
             and c.aopap = J.AOPAP
             and c.aocta = J.AOCTA
             and c.aooper = J.AOOPER
             and c.aosbop = J.AOSBOP
             and c.aotope = J.AOTOPE
             and c.evtipo = 3
             and c.d012co = 'S'
             and c.evfval = (select max(evfval)
                               from fsd012 d
                              where d.pgcod = J.PGCOD
                                and d.aomod = J.AOMOD
                                and d.aosuc = J.AOSUC
                                and d.aomda = J.AOMDA
                                and d.aopap = J.AOPAP
                                and d.aocta = J.AOCTA
                                and d.aooper = J.AOOPER
                                and d.aosbop = J.AOSBOP
                                and d.aotope = J.AOTOPE
                                and d.evtipo = 3
                                and d.d012co = 'S');
        exception
          when others then
            begin
              select aotasa
                into ln_tasa
                from fsd010 a
               where a.pgcod = J.PGCOD
                 and a.aomod = J.AOMOD
                 and a.aosuc = J.AOSUC
                 and a.aomda = J.AOMDA
                 and a.aopap = J.AOPAP
                 and a.aocta = J.AOCTA
                 and a.aooper = J.AOOPER
                 and a.aosbop = J.AOSBOP
                 and a.aotope = J.AOTOPE;
            exception
              when others then
                ln_tasa := 0;
            end;
        end;
        --Obtener saldo
        begin
          select abs(scsdo)
            into ln_sald
            from fsd011 b
           where b.pgcod = J.PGCOD
             and b.scmod = J.AOMOD
             and b.scsuc = J.AOSUC
             and b.scmda = J.AOMDA
             and b.scpap = J.AOPAP
             and b.sccta = J.AOCTA
             and b.scoper = J.AOOPER
             and b.scsbop = J.AOSBOP
             and b.sctope = J.AOTOPE;
        exception
          when others then
            ln_sald := 0;
        end;
        --Ampliaciones
        begin
          pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_pgcod,
                                                  ln_aomod,
                                                  ln_aosuc,
                                                  ln_aomda,
                                                  ln_aopap,
                                                  ln_aocta,
                                                  ln_aooper,
                                                  ln_aosbop,
                                                  ln_aotope,
                                                  fl_soli);
        exception
          when others then
            fl_soli := 'N';
        end;
        --Refinanciaciones
        begin
          pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod,
                                                  ln_aomod,
                                                  ln_aosuc,
                                                  ln_aomda,
                                                  ln_aopap,
                                                  ln_aocta,
                                                  ln_aooper,
                                                  fl_soli);
        exception
          when others then
            fl_soli := 'N';
        end;
        if fl_soli = 'N' then
          --insercion
          begin
            insert into aqpb934
              (AQPB934FECH,
               AQPB934HORC,
               AQPB934USUR,
               AQPB934PAIS,
               AQPB934TDOC,
               AQPB934NDOC,
               AQPB934COD,
               AQPB934MOD,
               AQPB934SUC,
               AQPB934MDA,
               AQPB934PAP,
               AQPB934CTA,
               AQPB934OPER,
               AQPB934SBOP,
               AQPB934TOP,
               AQPB934TASA,
               AQPB934SDO,
               AQPB934EST,
               AQPB934PRIN,
               AQPB934VIN,
               AQPB934AUX1)
            values
              (ld_fech,
               to_char(sysdate, 'HH24:MI:SS'),
               pv_usur,
               ln_pais,
               ln_tdoc,
               lv_ndoc,
               J.PGCOD,
               J.AOMOD,
               J.AOSUC,
               J.AOMDA,
               J.AOPAP,
               J.AOCTA,
               J.AOOPER,
               J.AOSBOP,
               J.AOTOPE,
               ln_tasa,
               ln_sald,
               'H',
               lv_prin,
               'V',
               0);
            commit;
          exception
            when others then
              null;
          end;
        end if;
      end loop;
    end loop;
  end sp_cr_busqueda_creditos;

  procedure sp_cr_limpiar_vinculacion(pn_pais   in number,
                                      pn_tdoc   in number,
                                      pv_ndoc   in varchar2,
                                      pv_usur   in varchar2,
                                      pn_coderr out number,
                                      pv_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_grabar_vinculacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.11.08
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Actualizar vinculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pais ( Pais )
    --                              pn_tdoc ( Tipo de Dcoumento )
    --                              pv_ndoc ( Documento )
    --                              pv_usur ( Usuario que ejecuta )
    -- Parámetros de Salida       : pn_coderr ( Cod Error )
    --                            : pv_msgerr ( Mensaje Error ) 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
    my_errm VARCHAR2(300);
    lv_ndoc VARCHAR2(15);
  begin
    pn_coderr := 1;
    --Limpieza de estado
    begin
      update aqpb934
         set aqpb934est = 'I'
       where aqpb934pais = pn_pais
         and aqpb934tdoc = pn_tdoc
         and aqpb934ndoc = pv_ndoc
         and aqpb934aux1 = 1;
    exception
      when others then
        null;
    end;
  
    --Limpieza de estado gestionado
    begin
      update aqpb934
         set aqpb934est = 'I', aqpb934acep = 'C'
       where aqpb934pais = pn_pais
         and aqpb934tdoc = pn_tdoc
         and aqpb934ndoc = pv_ndoc
         and aqpb934acep = 'G'
         and aqpb934aux1 = 2;
    exception
      when others then
        null;
    end;
  end sp_cr_limpiar_vinculacion;

  procedure sp_cr_actualizar_vinculo(pn_cod    in number,
                                     pn_suc    in number,
                                     pn_mod    in number,
                                     pn_mda    in number,
                                     pn_pap    in number,
                                     pn_cta    in number,
                                     pn_oper   in number,
                                     pn_sbop   in number,
                                     pn_tope   in number,
                                     pv_vinc   in varchar2,
                                     pv_usur   in varchar2,
                                     pn_coderr out number,
                                     pv_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualizar_vinculo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.11.08
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Actualizar vinculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_cod ( Codigo Empresa )
    --                              pn_mod ( Modulo )
    --                              pn_suc ( Sucursal )
    --                              pn_mda ( Moneda )
    --                              pn_pap ( Papel )
    --                              pn_cta ( Cuenta )
    --                              pn_oper ( Operacion )
    --                              pn_sbop ( Sub Operacion )
    --                              pn_tope ( Tipo Operacion )
    --                              pv_vinc ( Vinculo )
    --                              pv_usur ( Usuario que ejecuta )
    -- Parámetros de Salida       : pn_coderr ( Cod Error )
    --                            : pv_msgerr ( Mensaje Error ) 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
    my_errm VARCHAR2(300);
  begin
    pn_coderr := 1;
    --Identificar si credito es el principal   
    begin
      update aqpb934
         set aqpb934vin  = pv_vinc,
             aqpb934horv = to_char(sysdate, 'HH24:MI:SS'),
             aqpb934tivi = SYSDATE,
             aqpb934usuv = pv_usur,
             aqpb934aux1 = 1
       where aqpb934cod = pn_cod
         and aqpb934mod = pn_mod
         and aqpb934suc = pn_suc
         and aqpb934mda = pn_mda
         and aqpb934pap = pn_pap
         and aqpb934cta = pn_cta
         and aqpb934oper = pn_oper
         and aqpb934sbop = pn_sbop
         and aqpb934top = pn_tope
         and aqpb934est = 'H'
         and aqpb934aux1 = 0;
      commit;
    exception
      when others then
        pn_coderr := 0;
        pv_msgerr := 'Error al actualizar vinculos.';
    end;
  end sp_cr_actualizar_vinculo;

  procedure sp_cr_aceptar_vinculo(pn_cod    in number,
                                  pn_suc    in number,
                                  pn_mod    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_tope   in number,
                                  pn_mora   in number,
                                  pn_pena   in number,
                                  pn_icv    in number,
                                  pv_usur   in varchar2,
                                  pn_coderr out number,
                                  pv_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_actualizar_vinculo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.11.08
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Actualizar vinculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_cod ( Codigo Empresa )
    --                              pn_mod ( Modulo )
    --                              pn_suc ( Sucursal )
    --                              pn_mda ( Moneda )
    --                              pn_pap ( Papel )
    --                              pn_cta ( Cuenta )
    --                              pn_oper ( Operacion )
    --                              pn_sbop ( Sub Operacion )
    --                              pn_tope ( Tipo Operacion )
    --                              pv_vinc ( Vinculo )
    --                              pv_usur ( Usuario que ejecuta )
    -- Parámetros de Salida       : pn_coderr ( Cod Error )
    --                            : pv_msgerr ( Mensaje Error ) 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
    my_errm VARCHAR2(300);
    lv_ndoc VARCHAR2(15);
    ln_tasp NUMBER(10, 6);
    ln_mod  NUMBER(5);
    ln_suc  NUMBER(4);
    ln_mda  NUMBER(4);
    ln_pap  NUMBER(4);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_top  NUMBER(5);
    ln_sbo  NUMBER(4);
  begin
    pn_coderr := 1;
    begin
      update aqpb934
         set aqpb934mora = pn_mora,
             aqpb934icv  = pn_icv,
             aqpb934pena = pn_pena
       where aqpb934cod = pn_cod
         and aqpb934mod = pn_mod
         and aqpb934suc = pn_suc
         and aqpb934mda = pn_mda
         and aqpb934pap = pn_pap
         and aqpb934cta = pn_cta
         and aqpb934oper = pn_oper
         and aqpb934sbop = pn_sbop
         and aqpb934top = pn_tope
         and aqpb934est = 'H'
         and aqpb934vin = 'V'
         and aqpb934aux1 = 1;
      commit;
    exception
      when others then
        pn_coderr := 0;
        pv_msgerr := 'Error al actualizar vinculos.';
    end;
  end sp_cr_aceptar_vinculo;

  procedure sp_cr_grabar_vinculacion(pn_pais   in number,
                                     pn_tdoc   in number,
                                     pv_ndoc   in varchar2,
                                     pv_usur   in varchar2,
                                     pn_coderr out number,
                                     pv_msgerr out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_grabar_vinculacion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.11.08
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Actualizar vinculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pais ( Pais )
    --                              pn_tdoc ( Tipo de Dcoumento )
    --                              pv_ndoc ( Documento )
    --                              pv_usur ( Usuario que ejecuta )
    -- Parámetros de Salida       : pn_coderr ( Cod Error )
    --                            : pv_msgerr ( Mensaje Error ) 
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación: 
    -- *****************************************************************
    my_errm VARCHAR2(300);
    lv_ndoc VARCHAR2(15);
    ln_mod  NUMBER(5);
    ln_suc  NUMBER(4);
    ln_mda  NUMBER(4);
    ln_pap  NUMBER(4);
    ln_cta  NUMBER(9);
    ln_ope  NUMBER(9);
    ln_top  NUMBER(5);
    ln_sbo  NUMBER(4);
  begin
    pn_coderr := 1;
  
    begin
    
      PQ_CR_TASA_ALINEAMIENTO.sp_cr_inserttasaxcuenta(pn_pais,
                                                      pn_tdoc,
                                                      pv_ndoc,
                                                      pv_msgerr);
    
      update aqpb934
         set aqpb934acep = 'G',
             aqpb934hora = to_char(sysdate, 'HH24:MI:SS'),
             aqpb934tiac = SYSDATE,
             aqpb934usua = pv_usur,
             aqpb934aux1 = 2
       where aqpb934pais = pn_pais
         and aqpb934tdoc = pn_tdoc
         and aqpb934ndoc = pv_ndoc
         and aqpb934est = 'H'
         and aqpb934vin = 'V'
         and aqpb934aux1 = 1;
      commit;
    exception
      when others then
        pn_coderr := 0;
        pv_msgerr := 'Error al grabar vinculación.';
    end;
  end sp_cr_grabar_vinculacion;
  -----------------------------------------
  procedure sp_cr_mora_exo(pn_cod    in number,
                           pn_suc    in number,
                           pn_mod    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_tope   in number,
                           pd_fini   in date,
                           pn_coderr out number,
                           pv_msgerr out varchar2) is
    ld_ffin date;
  begin
    pn_coderr := 1;
  
    --agregar en guia
    begin
      select pd_fini + tp1nro1
        into ld_ffin
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11164
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 1;
    
    exception
      when others then
        null;
    end;
    begin
      insert into aqpb252
        (AQPB252EMP,
         AQPB252MOD,
         AQPB252SUC,
         AQPB252MDA,
         AQPB252PAP,
         AQPB252CTA,
         AQPB252OPER,
         AQPB252SBOP,
         AQPB252TOP,
         AQPB252FINI,
         AQPB252FFIN,
         AQPB252EST,
         AQPB252IND)
      values
        (pn_cod,
         pn_mod,
         pn_suc,
         pn_mda,
         pn_pap,
         pn_cta,
         pn_oper,
         pn_sbop,
         pn_tope,
         pd_fini,
         ld_ffin,
         'S',
         '3');
      commit;
    exception
      when others then
        pn_coderr := 2;
        pv_msgerr := 'No se pudo insertar';
    end;
  
  end sp_cr_mora_exo;
  --------------------------------------------------------------------
  procedure sp_cr_anular_mora_exo(pn_pais   in number,
                                  pn_tdoc   in number,
                                  pv_ndoc   in varchar2,
                                  pn_coderr out number,
                                  pv_msgerr out varchar2) is
  begin
    begin
      for k in (select a.ctnro
                  from fsr008 a
                 where a.pepais = pn_pais
                   and a.petdoc = pn_tdoc
                   and a.pendoc = rpad(pv_ndoc, 12)
                   and a.cttfir = 'T') loop
        begin
          delete aqpb252
           where aqpb252emp = 1
             and aqpb252cta = k.ctnro;
          commit;
        exception
          when others then
            null;
        end;
      end loop;
    exception
      when others then
        null;
    end;
  end sp_cr_anular_mora_exo;
  ------------------------------------------------------------

  procedure sp_cr_anular_exoneracionmora is
  begin
    for i in (select *
                from xwf700 x
               where x.xwfempresa = 1
                    -- and x.xwfsucursal = ln_suc
                 and x.xwfcar3 = '1'
                 and (x.xwfmodulo, x.xwftipope) in
                     (SELECT tp1nro2, tp1nro3
                        FROM fst198
                       where tp1cod1 = 10899
                         and tp1corr1 = 901
                         and tp1corr2 = 1)
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
        update aqpb252
           set AQPB252EST = 'N'
         where aqpb252emp = 1
           and aqpb252cta = i.xwfcuenta;
        commit;
      exception
        when others then
          null;
      end;
    end loop;
  end sp_cr_anular_exoneracionmora;
  --------------------------------------------------------------------------
  procedure sp_cr_reponer_exoneracion(pn_instancia in number) is
    ln_cuenta number;
  begin
    begin
      select xwfcuenta
        into ln_cuenta
        from xwf700 x
       where x.xwfempresa = 1
            
         and x.xwfcar3 = '1'
         and x.xwfprcins = pn_instancia;
    exception
      when others then
        null;
    end;
    begin
      update aqpb252
         set AQPB252EST = 'S'
       where aqpb252emp = 1
         and aqpb252cta = ln_cuenta;
         commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_reponer_exoneracion;

end PQ_CR_LOG_ALINEAMIENTO_INTERNO;
/

