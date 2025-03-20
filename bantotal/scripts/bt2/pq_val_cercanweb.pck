CREATE OR REPLACE PACKAGE "PQ_VAL_CERCANWEB" IS

  -- *****************************************************************
  -- Nombre                     : PQ_VAL_CERCANWEB
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.08.03
  -- Autor de Creación          : Waldir Wong Calle
  -- Uso                        : Valida Creditos Vigentes y Avales Vigentes
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.06.10
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega nuevos procedimientos para validar Creditos Vigentes, Avales Vigentes y Creditos Castigados
  -- Fecha de Modificación      : 2024.06.14
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega procedimientos para validar validar Creditos Vigentes, Avales Vigentes y Creditos Castigados con data historica
  -- Fecha de Modificación      : 2024.11.05
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega funcion para validar CNA no impresos por ventanilla
  -- Fecha de Modificación      : 2024.12.27
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega asiento al filto para validar CNA no impresos
  -- Fecha de Modificación      : 06/02/2025
  -- Autor de Modificación      : Danny Manrique Callata
  -- Descripción Modificación   : Se añade la fecha de contabilizacion en la busqueda del historico
  -- Fecha de Modificación      : 2025.02.17
  -- Autor de Modificación      : Renzo Cuadros Salazar
  -- Descripción Modificación   : Se agrega procedimiento para validar CNA por documento
  -- *****************************************************************
  
  procedure sp_cr_ValTotalCreCan(pn_pgcod  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_mda in number,
                                 pn_mod in number,
                                 pn_coderr out number,
                                 lv_flgCan out varchar2);
  
  procedure sp_cr_val_estado(pn_pgcod   in number,
                               pn_cuenta  in number,
                               pn_modulo  in number,
                               pn_opera   in number,
                               pn_sucur   in number,
                               pn_moneda  in number,
                               pn_papel   in number,
                               pn_tope    in number,
                               pd_fecgui  in date,
                               pv_Flag    out varchar2,
                               pd_fecha99 out date,
                               pv_estado  out number);                               

  procedure sp_cr_ValTotalAval99(pn_pgcod  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_mda in number,
                               pn_mod in number,
                               pn_coderr out number,
                               lv_flgCan out varchar2);

  procedure sp_cr_envio_alerta_garantia(p_n_pgcod IN NUMBER,
                                        p_n_scmod IN NUMBER,
                                        p_n_scsuc IN NUMBER,
                                        p_n_scmda IN NUMBER,
                                        p_n_scpap IN NUMBER,
                                        p_n_sccta IN NUMBER,
                                        p_n_scoper IN NUMBER,
                                        p_n_scsbop IN NUMBER,
                                        p_n_sctope IN NUMBER,
                                        p_c_coderr OUT VARCHAR2,
                                        p_c_msgerr OUT VARCHAR2
                                       );
  -- rcuadros 2024.06.10                                     
  PROCEDURE sp_cr_Todos_Crd99_CNA(pn_pgcod IN NUMBER,
                                  pn_aomod IN NUMBER,
                                  pn_aosuc IN NUMBER,
                                  pn_aomda IN NUMBER,
                                  pn_aopap IN NUMBER,
                                  pn_aocta IN NUMBER,
                                  pn_aooper IN NUMBER,
                                  pn_aosbop IN NUMBER,
                                  pn_aotope IN NUMBER,
                                  pn_coderr OUT NUMBER,
                                  pc_flgCan OUT VARCHAR2
                                 );
  -- rcuadros 2024.06.10
  PROCEDURE sp_cr_Todos_Aval99_CNA(pn_pgcod IN NUMBER,
                                   pn_aomod IN NUMBER,
                                   pn_aosuc IN NUMBER,
                                   pn_aomda IN NUMBER,
                                   pn_aopap IN NUMBER,
                                   pn_aocta IN NUMBER,
                                   pn_aooper IN NUMBER,
                                   pn_aosbop IN NUMBER,
                                   pn_aotope IN NUMBER,
                                   pn_coderr OUT NUMBER,
                                   pc_flgCan OUT VARCHAR2
                                  );
  -- rcuadros 2024.06.10
  PROCEDURE sp_cr_es_castig_judic_venta(pn_pais IN NUMBER,
                                        pn_tdoc IN NUMBER,
                                        pn_ndoc IN VARCHAR2,
                                        pn_coderr OUT NUMBER,
                                        pc_msjerr OUT VARCHAR2
                                       );
  -- rcuadros 2024.06.14
  PROCEDURE sp_cr_todos_Crd99_CNA_pbproc(pn_pgcod IN NUMBER,
                                         pn_hcmod IN NUMBER,
                                         pn_hsucor IN NUMBER,
                                         pn_htran IN NUMBER,
                                         pn_hnrel IN NUMBER,
                                         pn_feccan IN DATE,
                                         pn_coderr OUT NUMBER,
                                         pc_flgCan OUT VARCHAR2
                                        );
  -- rcuadros 2024.06.14
  PROCEDURE sp_cr_todos_Aval99_CNA_pbproc(pn_pgcod IN NUMBER,
                                          pn_hcmod IN NUMBER,
                                          pn_hsucor IN NUMBER,
                                          pn_htran IN NUMBER,
                                          pn_hnrel IN NUMBER,
                                          pn_feccan IN DATE,
                                          pn_coderr OUT NUMBER,
                                          pc_flgCan OUT VARCHAR2
                                         );
  -- rcuadros 2024.11.05
  PROCEDURE sp_cr_valida_CNA_impreso(pn_hcmod IN NUMBER,
                                     pn_hsucor IN NUMBER,
                                     pn_htran IN NUMBER,
                                     pn_hnrel IN NUMBER,
                                     pd_feccan IN DATE,
                                     pn_pgcod IN NUMBER,
                                     pn_aomod IN NUMBER,
                                     pn_aosuc IN NUMBER,
                                     pn_aomda IN NUMBER,
                                     pn_aopap IN NUMBER,
                                     pn_aocta IN NUMBER,
                                     pn_aooper IN NUMBER,
                                     pn_aosbop IN NUMBER,
                                     pn_aotope IN NUMBER,
                                     pn_coderr OUT NUMBER,
                                     pc_flgVal OUT VARCHAR2
                                    );
  -- rcuadros 2025.02.17
  PROCEDURE sp_cr_corresponde_cna(pn_pepais IN NUMBER,
                                  pn_petdoc IN NUMBER,
                                  pc_pendoc IN VARCHAR2,
                                  pc_flgcna OUT VARCHAR2,
                                  pc_coderr OUT NUMBER,
                                  pc_msgerr OUT VARCHAR2
                                 );
END PQ_VAL_CERCANWEB;
 /* GOLDENGATE_DDL_REPLICATION */
/

CREATE OR REPLACE PACKAGE BODY "PQ_VAL_CERCANWEB" IS

procedure sp_cr_ValTotalCreCan(pn_pgcod  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_mda in number,
                               pn_mod in number,
                               pn_coderr out number,
                               lv_flgCan out varchar2) is

    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;

    CURSOR lst_crd(n_nrocta number) IS
      select d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aotope,
             d.aosbop,
             d.aostat
        from fsd010 d
       where d.aocta = n_nrocta
         and d.aomod in (select t111.modulo
                           from fst111 t111
                          where t111.Dscod = 50
                            and t111.Modulo != 116)
         and d.aosbop = (select max(d1.AOSBOP)
                           from fsd010 d1
                          where d1.PGCOD = d.pgcod
                            and d1.AOMOD = d.aomod
                            and d1.AOMDA = d.aomda
                            and d1.AOPAP = d.aopap
                            and d1.AOCTA = d.aocta
                            and d1.AOSUC = d.aosuc
                            and d1.AOOPER = d.aooper
                            and d1.AOTOPE = d.aotope)
       order by d.PGCOD,
                d.AOMOD,
                d.AOMDA,
                d.AOPAP,
                d.AOCTA,
                d.AOSUC,
                d.AOOPER,
                d.AOSBOP;

    my_errm VARCHAR2(32000);

    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
    ln_aocta  number(9);
    /*ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);*/

    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);

    --ln_sld_011  number;
    ld_fecguia  date;
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  BEGIN
    ln_aocta := pn_cta;
    --ld_fecguia := PQ_CR_VALI_CRED_CANC.fn_get_FecGuia();
    /*ln_pgcod := pn_pgcod;
    ln_aomod := pn_mod;
    ln_aosuc := pn_suc;
    ln_aomda := pn_mda;
    ln_aopap := pn_pap;
    ln_aocta := pn_cta;
    ln_aooper := pn_ope;
    ln_aosbop := pn_sop;
    ln_aotope := pn_top;*/

    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
    
    begin
       select d.Aofe99 into ld_fecguia
         from fsd010 d
        where d.pgcod = pn_pgcod
          and d.aocta = pn_cta
          and d.aomod = pn_mod
          and d.aooper = pn_ope
          and d.aomda = pn_mda
          and d.Aostat = 99;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
    
    /*begin
       select aofe99 into ld_fecguia
          from fsd010 d
         where d.Pgcod = pn_pgcod
           and d.aocta = pn_cta
           and d.aomod =  pn_mod
           and d.Aooper = pn_ope;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;*/
    lv_flgCan := 'N';

    --Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;

          sp_cr_val_estado(T_pgcod,
                           T_aocta,
                           T_aomod,
                           T_aooper,
                           T_aosuc,
                           T_aomda,
                           T_aopap,
                           T_aotope,
                           ld_fecguia,
                           lv_flagCanc,
                           ld_fec99,
                           ln_estadoC);

          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;

    --Todos los creditos cancelados
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)

    --lv_flgCan(&flag99) = 'N'o tiene obligaciones
    --lv_flgCan(&flag99) = 'S'i tiene obligaciones

    --activar flag de todos los creditos cancelados
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;

  END sp_cr_ValTotalCreCan;

  procedure sp_cr_val_estado(pn_pgcod   in number,
                             pn_cuenta  in number,
                             pn_modulo  in number,
                             pn_opera   in number,
                             pn_sucur   in number,
                             pn_moneda  in number,
                             pn_papel   in number,
                             pn_tope    in number,
                             pd_fecgui  in date,
                             pv_Flag    out varchar2,
                             pd_fecha99 out date,
                             pv_estado  out number) is
    my_errm VARCHAR2(32000);
  
    ln_PGCOD  NUMBER(3);
    ln_AOMOD  NUMBER(3);
    ln_AOSUC  NUMBER(3);
    ln_AOMDA  NUMBER(4);
    ln_AOPAP  NUMBER(4);
    ln_AOCTA  NUMBER(9);
    ln_AOOPER NUMBER(9);
    ln_AOSBOP NUMBER(3);
    ln_AOTOPE NUMBER(3);
  
    ln_saldo011 number;
    ln_saldo175 number;
    ln_ConEst   number;
  
  BEGIN
    begin
      select Aostat,
             aofe99,
             PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE
        into pv_estado,
             pd_fecha99,
             ln_PGCOD,
             ln_AOMOD,
             ln_AOSUC,
             ln_AOMDA,
             ln_AOPAP,
             ln_AOCTA,
             ln_AOOPER,
             ln_AOSBOP,
             ln_AOTOPE
        from fsd010 a
       where Pgcod = pn_pgcod
         and Aocta = pn_cuenta
         and Aomod = pn_modulo
         and Aooper = pn_opera 
         and Aofe99 <= pd_fecgui -- Verifica la fecha de cancelación sea menor a la fecha del CNA 
         and Aosuc = pn_sucur
         and Aomda = pn_moneda
         and Aopap = pn_papel
         and Aotope = pn_tope;
      --and rownum = 1
      --order by Aosbop desc;
    EXCEPTION
      when too_many_rows then
        begin
          select Aostat,
                 aofe99,
                 PGCOD,
                 AOMOD,
                 AOSUC,
                 AOMDA,
                 AOPAP,
                 AOCTA,
                 AOOPER,
                 AOSBOP,
                 AOTOPE
            into pv_estado,
                 pd_fecha99,
                 ln_PGCOD,
                 ln_AOMOD,
                 ln_AOSUC,
                 ln_AOMDA,
                 ln_AOPAP,
                 ln_AOCTA,
                 ln_AOOPER,
                 ln_AOSBOP,
                 ln_AOTOPE
            from fsd010 a
           where Pgcod = pn_pgcod
             and Aocta = pn_cuenta
             and Aomod = pn_modulo
             and Aooper = pn_opera
             and Aosuc = pn_sucur
             and Aomda = pn_moneda
             and Aopap = pn_papel
             and Aotope = pn_tope
             and Aofe99 <= pd_fecgui -- Verifica la fecha de cancelación sea menor a la fecha del CNA
             and aosbop = (select max(b.Aosbop)
                             from fsd010 b
                            where b.Pgcod = pn_pgcod
                              and b.Aosuc = pn_sucur
                              and b.Aomod = pn_modulo
                              and b.Aomda = pn_moneda
                              and b.Aopap = pn_papel
                              and b.Aocta = pn_cuenta
                              and b.Aooper = pn_opera
                              and b.Aotope = pn_tope);
        EXCEPTION
          when others then
            my_errm := SQLERRM;
            null;
        end;
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    begin
      SELECT COUNT(tpnro)
        INTO ln_ConEst
        FROM fst098
       WHERE pgcod = 1
         AND tpcod = 7750
         AND tpcorr >= 91
         AND tpcorr <= 100
         AND tpimp = 1
         AND tpnro = pv_estado;
    EXCEPTION
      when others then
        ln_ConEst := 0;
        my_errm   := SQLERRM;
    end;
  
    if ln_ConEst > 0 then
      ln_saldo011 := PQ_CR_VALI_CRED_CANC.fn_get_saldo_fsd011(ln_PGCOD,
                                         ln_AOMOD,
                                         ln_AOSUC,
                                         ln_AOMDA,
                                         ln_AOPAP,
                                         ln_AOCTA,
                                         ln_AOOPER,
                                         ln_AOSBOP,
                                         ln_AOTOPE);
      if ln_saldo011 > 0 or ln_saldo011 is null then
        ln_saldo175 := PQ_CR_VALI_CRED_CANC.fn_get_saldo_JAQL175(ln_PGCOD,
                                            ln_AOMOD,
                                            ln_AOSUC,
                                            ln_AOMDA,
                                            ln_AOPAP,
                                            ln_AOCTA,
                                            ln_AOOPER,
                                            ln_AOSBOP,
                                            ln_AOTOPE,
                                            pv_estado);
      end if;
    end if;
  
    if pv_estado = 99 then
      pv_Flag := 'S';
    else
      if ln_saldo011 = 0 or ln_saldo175 = 0 then
        pv_Flag := 'S';
      else
        pv_Flag := 'N';
      end if;
    end if;
    --cancelado 'S'
    --pendiente 'N'
  END sp_cr_val_estado;

procedure sp_cr_ValTotalAval99(pn_pgcod  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_mda in number,
                               pn_mod in number,
                               pn_coderr out number,
                               lv_flgCan out varchar2) is
  
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) aosbop,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
    ln_aocta  number(9);
    /*ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);*/
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    --pn_contador number;
    --ln_sld_011  number;
    ld_fecguia  date;
  
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  
  BEGIN
    lv_flgCan   := 'N';
    pn_coderr   := 0;
    ln_aocta := pn_cta;
    --pn_contador := 0;
  
    --ld_fecguia := pd_feccan;
    /*ln_pgcod := pn_pgcod;
    ln_aomod := pn_mod;
    ln_aosuc := pn_suc;
    ln_aomda := pn_mda;
    ln_aopap := pn_pap;
    ln_aocta := pn_cta;
    ln_aooper := pn_ope;
    ln_aosbop := pn_sop;
    ln_aotope := pn_top;*/
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        null;
        my_errm := SQLERRM;
    end;
    
    begin
       select d.Aofe99 into ld_fecguia
         from fsd010 d
        where d.pgcod = pn_pgcod
          and d.aocta = pn_cta
          and d.aomod = pn_mod
          and d.aooper = pn_ope
          and d.aomda = pn_mda
          and d.Aostat = 99;
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
  
    lv_flgCan := 'N';
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          sp_cr_val_estado(T_pgcod,
                           T_aocta,
                           T_aomod,
                           T_aooper,
                           T_aosuc,
                           T_aomda,
                           T_aopap,
                           T_aotope,
                           ld_fecguia,
                           lv_flagCanc,
                           ld_fec99,
                           ln_estadoC);
        
          if lv_flagCanc = 'N' then
            lv_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN lv_flgCan = 'S';
      END LOOP;
      EXIT WHEN lv_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --lv_flgCan(&flagAval) = 'N'o tiene obligaciones
    --lv_flgCan(&flagAval) = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if lv_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_ValTotalAval99;
  
  procedure sp_cr_envio_alerta_garantia(p_n_pgcod IN NUMBER,
                                        p_n_scmod IN NUMBER,
                                        p_n_scsuc IN NUMBER,
                                        p_n_scmda IN NUMBER,
                                        p_n_scpap IN NUMBER,
                                        p_n_sccta IN NUMBER,
                                        p_n_scoper IN NUMBER,
                                        p_n_scsbop IN NUMBER,
                                        p_n_sctope IN NUMBER,
                                        p_c_coderr OUT VARCHAR2,
                                        p_c_msgerr OUT VARCHAR2
                                        ) IS
    -- VARIABLES --
    lc_emisor   VARCHAR2(40) := 'notificaciones@cajaarequipa.pe';
    lc_asunto   VARCHAR2(100) := 'Alerta de Emisión de CNA con glosa de garantía';
    lc_mensaje  LONG := ' ';
    lc_grtasc   LONG := ' ';
    lc_destino  VARCHAR2(250) := ' ';
    lc_destcpy  VARCHAR2(250) := ' ';
    lc_coderr   VARCHAR2(5) := '0';
    lc_msgerr   VARCHAR2(250) := ' ';
    ln_inst     NUMBER(10) := 0;
    ln_pgcodg   NUMBER(3) := 0;
    ln_modg     NUMBER(3) := 0;
    ln_sucg     NUMBER(3) := 0;
    ln_mdag     NUMBER(4) := 0;
    ln_papg     NUMBER(4) := 0;
    ln_ctag     NUMBER(9) := 0;
    ln_operg    NUMBER(9) := 0;
    ln_sbopg    NUMBER(3) := 0;
    ln_topeg    NUMBER(3) := 0;
    ld_fecha    DATE := SYSDATE();
    lc_hora     VARCHAR2(9) := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
    lc_nomtopeg VARCHAR2(30) := ' ';
    lc_nomsucg  VARCHAR2(30) := ' ';
    lc_nomregg  VARCHAR2(20) := ' ';
    lc_usuario  VARCHAR2(10) := ' ';
    lc_nomusu   VARCHAR2(30) := ' ';
    lc_integr   LONG := ' ';
    lc_exstgrtn VARCHAR2(1);
    ln_nulo     NUMBER(3) := 0;
    ln_alerta   NUMBER(9) := 0;
    ln_dept     NUMBER(5) := 0;
    lc_nomcli   VARCHAR2(30) := ' ';
    ln_pais     NUMBER(3) := 0;
    ln_tdoc     NUMBER(2) := 0;
    lc_ndoc     VARCHAR2(12) := ' ';
    ln_filas    NUMBER(9) := 0;
    ln_cant     NUMBER(9) := 0;
    lc_dominio  VARCHAR2(30) := ' ';
    -- obtener lista de integrantes de la garantia --
    cursor LST1 is
      select b.penom, b.pendoc
        from fsr008 a, fsd001 b
       where a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and a.pgcod = p_n_pgcod
         and a.ctnro = ln_ctag;
    -- obtener lista de destinarios --
    cursor LST2 is
      select tp1nro1, tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 111154
         and tp1corr1 = 1
         and tp1corr2 = 0
         and tp1corr3 > 0;
    -- obtener lista de destinarios copia --
    cursor LST3 is
      select tp1nro1, tp1desc
        from fst198
       where tp1cod = 1
         and tp1cod1 = 111154
         and tp1corr1 = 2
         and tp1corr2 = 0
         and tp1corr3 > 0;
    -- obtener lista de garantias del cliente --
    cursor LST4 is
      select sng122pgc,
             sng122mod,
             sng122suc,
             sng122mda,
             sng122pap,
             sng122cta,
             sng122oper,
             sng122sbop,
             sng122tope
        from sng122
       where sng122inst = ln_inst;
  BEGIN
    -- 1 = activado / 0 = desactivado --
    BEGIN
      select tpnro
        into ln_alerta
        from fst098
       where pgcod = 1
         and tpcod = 7753
         and tpcorr = 2;
    EXCEPTION
      WHEN OTHERS THEN
        ln_alerta := 0;
    END;
    
    IF ln_alerta = 1 THEN
      -- obtener credito y instancia del cliente --
      BEGIN
        select xwfprcins
          into ln_inst
          from xwf700
         where xwfempresa   = p_n_pgcod
           and xwfmodulo    = p_n_scmod
           and xwfsucursal  = p_n_scsuc
           and xwfmoneda    = p_n_scmda
           and xwfpapel     = p_n_scpap
           and xwfcuenta    = p_n_sccta
           and xwfoperacion = p_n_scoper
           and xwfsubope    = p_n_scsbop
           and xwftipope    = p_n_sctope
           and xwfcar3      = '1';
        -- obtener documento del cliente titular --
        BEGIN
          select pepais, petdoc, pendoc
            into ln_pais, ln_tdoc, lc_ndoc
            from fsr008
           where pgcod = p_n_pgcod
             and ctnro = p_n_sccta
             and cttfir = 'T';
          -- obtener nombre cliente titular --
          BEGIN
            select trim(penom)
              into lc_nomcli
              from fsd001
             where pepais = ln_pais
               and petdoc = ln_tdoc
               and pendoc = lc_ndoc;
          EXCEPTION
            WHEN OTHERS THEN
              lc_nomcli := ' ';
          END;
        EXCEPTION
          WHEN OTHERS THEN
            lc_ndoc := ' ';
        END;
        -- obtener analista --
        BEGIN
          select b.ubuser, b.ubnom
            into lc_usuario, lc_nomusu
            from sng001 a, fst746 b
           where a.sng001ase = b.ubuser
             and a.sng001inst = ln_inst;
        EXCEPTION
          WHEN OTHERS THEN
            lc_usuario := ' ';
            lc_nomusu  := ' ';
        END;
        -- obtener cantidad de filas --
        BEGIN
          select count(*) into ln_filas from sng122 where sng122inst = ln_inst;
        EXCEPTION
          WHEN OTHERS THEN
            ln_filas := 0;
        END;
      EXCEPTION
        WHEN OTHERS THEN
          -- graba log --
          dbms_output.put_line(sqlerrm);
          lc_coderr := to_char(sqlcode);
          lc_msgerr := substr(trim(sqlerrm), 11, 250);
      END;
      
      -- validar si el cliente tiene una garantia asociada --
      PQ_CR_VALI_CRED_CANC.SP_CR_VAL_TIPOPE_GR_2(p_n_pgcod,
                                                 p_n_scmod,
                                                 p_n_scsuc,
                                                 p_n_scmda,
                                                 p_n_scpap,
                                                 p_n_sccta,
                                                 p_n_scoper,
                                                 p_n_scsbop,
                                                 p_n_sctope,
                                                 lc_exstgrtn,
                                                 ln_nulo);
      IF lc_exstgrtn = 'S' THEN
        -- obtener garantia del cliente --
        FOR J IN LST4 LOOP
          ln_cant   := ln_cant + 1;
          ln_pgcodg := 0;
          ln_modg   := 0;
          ln_sucg   := 0;
          ln_mdag   := 0;
          ln_papg   := 0;
          ln_ctag   := 0;
          ln_operg  := 0;
          ln_sbopg  := 0;
          ln_topeg  := 0;
        
          ln_pgcodg := J.SNG122PGC;
          ln_modg   := J.SNG122MOD;
          ln_sucg   := J.SNG122SUC;
          ln_mdag   := J.SNG122MDA;
          ln_papg   := J.SNG122PAP;
          ln_ctag   := J.SNG122CTA;
          ln_operg  := J.SNG122OPER;
          ln_sbopg  := J.SNG122SBOP;
          ln_topeg  := J.SNG122TOPE;
          -- obtener nombre tipo operacion garantia --
          BEGIN
            select trim(tonom)
              into lc_nomtopeg
              from fst004
             where modulo = ln_modg
               and totope = ln_topeg;
          EXCEPTION
            WHEN OTHERS THEN
              lc_nomtopeg := ' ';
          END;
          -- obtener nombre sucursal garantia --
          BEGIN
            select trim(scnom)
              into lc_nomsucg
              from fst001
             where pgcod = ln_pgcodg
               and sucurs = ln_sucg;
          EXCEPTION
            WHEN OTHERS THEN
              lc_nomsucg := ' ';
          END;
          -- obtener codigo de region garantia --
          BEGIN
            select to_number(scdept)
              into ln_dept
              from fst001
             where sucurs = ln_sucg;
            -- obtener nombre region garantia --
            BEGIN
              select trim(depnom)
                into lc_nomregg
                from fst068
               where depcod = ln_dept;
            EXCEPTION
              WHEN OTHERS THEN
                lc_nomregg := ' ';
            END;
          EXCEPTION
            WHEN OTHERS THEN
              ln_dept := 0;
          END;
          -- obtener integrantes de la garantia --
          FOR X IN LST1 LOOP
            lc_integr := TRIM(lc_integr) || '<li>Cliente: ' || X.PENOM ||
                      '</li><li>DNI: ' || X.PENDOC || '</li>';
          END LOOP;
          -- obtener garantias asociadas --
          lc_grtasc := lc_grtasc || '<ul>
                               <li>Cuenta: ' || ln_ctag ||
                    '</li>
                               <li>Operacion: ' || ln_operg ||
                    '</li>
                               <li>Tipo de Operación: ' ||
                    ln_topeg || '' || ' - ' || '' || lc_nomtopeg ||
                    '</li>
                               <li>Sucursal: ' ||
                    lc_nomsucg || '</li>
                               <li>Región: ' || lc_nomregg ||
                    '</li>
                               <li>Analista: ' ||
                    lc_usuario || '' || ' - ' || '' || lc_nomusu ||
                    '</li>
                             </ul>';
          -- arma mensaje --
          lc_mensaje := '<html>
                        <head><style type="text/css"></style></head>
                        <body>
                          <p>Estimado.</p>
                          <p>Se realizó la emisión del Certificado de No Adeudo con glosa de garantía del crédito:</p>
                          <p>Cliente Titular: ' || lc_ndoc ||
                     ' - ' || lc_nomcli ||
                     '.</p>
                          <p>Cuenta: ' || p_n_sccta ||
                     ' y Operación: ' || p_n_scoper || '.</p>
                          <p>Datos de la garantía(s) asociada:</p>
                          ' || lc_grtasc || '
                          <p>Integrantes:</p>
                          <ul>
                            ' || lc_integr || '
                          </ul>
                        </body>
                      </html>';
          -- obtener correo destinatario --
          lc_destino := ' ';
          FOR I IN LST2 LOOP
            IF lc_destino = ' ' THEN
              -- obtener dominio --
              lc_dominio := ' ';
              BEGIN
                select trim(tp1desc)
                  into lc_dominio
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 111154
                   and tp1corr1 = 3
                   and tp1corr2 = 0
                   and tp1corr3 = I.tp1nro1;
                lc_destino := trim(lc_destino) || trim(I.tp1desc) || lc_dominio;
              EXCEPTION
                WHEN OTHERS THEN
                  lc_dominio := ' ';
              END;
            ELSE
              -- obtener dominio --
              lc_dominio := ' ';
              BEGIN
                select trim(tp1desc)
                  into lc_dominio
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 111154
                   and tp1corr1 = 3
                   and tp1corr2 = 0
                   and tp1corr3 = I.tp1nro1;
                lc_destino := trim(lc_destino) || ';' || trim(I.tp1desc) || lc_dominio;
              EXCEPTION
                WHEN OTHERS THEN
                  lc_dominio := ' ';
              END;
            END IF;
          END LOOP;
          -- obtener correo destinatario copia --
          lc_destcpy := ' ';
          FOR E IN LST3 LOOP
            IF lc_destcpy = ' ' THEN
              -- obtener dominio --
              lc_dominio := ' ';
              BEGIN
                select trim(tp1desc)
                  into lc_dominio
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 111154
                   and tp1corr1 = 3
                   and tp1corr2 = 0
                   and tp1corr3 = E.tp1nro1;
                lc_destcpy := trim(lc_destcpy) || trim(E.tp1desc) || lc_dominio;
              EXCEPTION
                WHEN OTHERS THEN
                  lc_dominio := ' ';
              END;
            ELSE
              -- obtener dominio --
              lc_dominio := ' ';
              BEGIN
                select trim(tp1desc)
                  into lc_dominio
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 111154
                   and tp1corr1 = 3
                   and tp1corr2 = 0
                   and tp1corr3 = E.tp1nro1;
                lc_destcpy := trim(lc_destcpy) || ';' || trim(E.tp1desc) || lc_dominio;
              EXCEPTION
                WHEN OTHERS THEN
                  lc_dominio := ' ';
              END;
            END IF;
          END LOOP;
          -- graba log ok--
          
          IF ln_cant = ln_filas THEN
            -- envia correo --
            PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => lc_destino,
                                             p_DestinatariosCC   => lc_destcpy,
                                             p_DestinatariosBcc  => ' ',
                                             p_Mensaje           => lc_mensaje,
                                             p_Remitente         => lc_emisor,
                                             p_Asunto            => lc_asunto,
                                             p_TipoMensaje       => 'HTML',
                                             p_Directorio        => ' ',
                                             p_ArchivosAdjuntos  => ' ',
                                             p_c_coderr          => lc_coderr,
                                             p_c_deserr          => lc_msgerr);
                                             
            IF lc_msgerr IS NOT NULL THEN
              -- actualiza log --
              lc_coderr := '00001';
              lc_msgerr := lc_msgerr;
              p_c_coderr := lc_coderr;
              p_c_msgerr := lc_msgerr;
            ELSE
              -- actualiza log ok--
              lc_coderr := '00000';
              lc_msgerr := 'ALERTA DE EMISIÓN DE CNA CON GLOSA DE GARANTÍA ENVIADA';
              p_c_coderr := lc_coderr;
              p_c_msgerr := lc_msgerr;
              
              UPDATE JAQL845W SET JAQL845WDETALE = lc_msgerr 
              WHERE JAQL845WPGCOD = p_n_pgcod
                AND JAQL845WMOD = p_n_scmod
                AND JAQL845WSUC = p_n_scsuc
                AND JAQL845WMDA = p_n_scmda
                AND JAQL845WPAP = p_n_scpap
                AND JAQL845WCTA = p_n_sccta
                AND JAQL845WOPE = p_n_scoper
                AND JAQL845WSOP = p_n_scsbop
                AND JAQL845WTOP = p_n_sctope;
              COMMIT;
              
            END IF;
          END IF;
        END LOOP;
      ELSE
        -- graba log --
        BEGIN
          lc_coderr := '00001';
          lc_msgerr := 'EL CLIENTE NO TIENE UNA GARANTIA ASOCIADA';
          p_c_coderr := lc_coderr;
          p_c_msgerr := lc_msgerr;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    ELSE
      BEGIN
        -- graba log --
        lc_coderr := '00001';
        lc_msgerr := 'ESTA DESACTIVADO LA ALERTA CNA';
        p_c_coderr := lc_coderr;
        p_c_msgerr := lc_msgerr;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- graba log --
      lc_coderr := to_char(sqlcode);
      lc_msgerr := substr(trim(sqlerrm), 11, 250);
      
  END sp_cr_envio_alerta_garantia;
  
  -- rcuadros 2024.06.10
  PROCEDURE sp_cr_Todos_Crd99_CNA(pn_pgcod IN NUMBER,
                                  pn_aomod IN NUMBER,
                                  pn_aosuc IN NUMBER,
                                  pn_aomda IN NUMBER,
                                  pn_aopap IN NUMBER,
                                  pn_aocta IN NUMBER,
                                  pn_aooper IN NUMBER,
                                  pn_aosbop IN NUMBER,
                                  pn_aotope IN NUMBER,
                                  pn_coderr OUT NUMBER,
                                  pc_flgCan OUT VARCHAR2
                                 ) IS

    CURSOR lst_ctn(c_pais NUMBER, c_tdoc NUMBER, c_ndoc VARCHAR2) IS
      SELECT b.ctnro
        FROM fsr008 b
       WHERE b.cttfir = 'T'
         AND b.pepais = c_pais
         AND b.petdoc = c_tdoc
         AND b.pendoc = c_ndoc;
  
    CURSOR lst_crd(n_nrocta NUMBER) IS
      SELECT d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aotope,
             d.aosbop,
             d.aostat
        FROM fsd010 d
       WHERE d.aocta = n_nrocta
         AND d.aomod IN (SELECT t111.modulo
                           FROM fst111 t111
                          WHERE t111.Dscod = 50
                            AND t111.Modulo != 116)
         and d.aosbop = (SELECT MAX(d1.AOSBOP)
                           FROM fsd010 d1
                          WHERE d1.pgcod = d.pgcod
                            AND d1.aomod = d.aomod
                            AND d1.aomda = d.aomda
                            AND d1.aopap = d.aopap
                            AND d1.aocta = d.aocta
                            AND d1.aosuc = d.aosuc
                            AND d1.aooper = d.aooper
                            AND d1.aotope = d.aotope)
       ORDER BY d.pgcod,
                d.aomod,
                d.aomda,
                d.aopap,
                d.aocta,
                d.aosuc,
                d.aooper,
                d.aosbop;
  
    my_errm VARCHAR2(32000);
  
    ln_pais NUMBER;
    ln_tdoc NUMBER;
    ln_ndoc VARCHAR2(12);
  
    ln_pgcod  NUMBER(3);
    ln_aomod  NUMBER(3);
    ln_aosuc  NUMBER(3);
    ln_aomda  NUMBER(4);
    ln_aopap  NUMBER(4);
    ln_aocta  NUMBER(9);
    ln_aooper NUMBER(9);
    ln_aosbop NUMBER(3);
    ln_aotope NUMBER(3);
  
    T_pgcod  NUMBER(3);
    T_aomod  NUMBER(3);
    T_aosuc  NUMBER(3);
    T_aomda  NUMBER(4);
    T_aopap  NUMBER(4);
    T_aocta  NUMBER(9);
    T_aooper NUMBER(9);
    T_aosbop NUMBER(3);
    T_aotope NUMBER(3);
    T_aostat NUMBER(3);
  
    ld_fecguia  DATE;
    lv_flagCanc VARCHAR2(5);
    ld_fec99    DATE;
    ln_estadoC  NUMBER;
  BEGIN    
    ln_pgcod := pn_pgcod;
    ln_aomod := pn_aomod;
    ln_aosuc := pn_aosuc;
    ln_aomda := pn_aomda;
    ln_aopap := pn_aopap;
    ln_aocta := pn_aocta;
    ln_aooper := pn_aooper;
    ln_aosbop := pn_aosbop;
    ln_aotope := pn_aotope;
    
    BEGIN
       SELECT d.aofe99 INTO ld_fecguia
         FROM fsd010 d
        WHERE d.pgcod = pn_pgcod
          AND d.aomod = pn_aomod
          AND d.aosuc = pn_aosuc
          AND d.aomda = pn_aomda
          AND d.aopap = pn_aopap
          AND d.aocta = pn_aocta
          AND d.aooper = pn_aooper
          AND d.aosbop = pn_aosbop
          AND d.aotope = pn_aotope
          AND d.aostat = 99;
    EXCEPTION
      WHEN OTHERS THEN
        my_errm := SQLERRM;
    END;
    
    -- Obtenemos documento del cliente
    BEGIN
      SELECT b.pepais, b.petdoc, b.pendoc
        INTO ln_pais, ln_tdoc, ln_ndoc
        FROM fsr008 b
       WHERE b.cttfir = 'T'
         AND b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      WHEN OTHERS THEN
        my_errm := SQLERRM;
    END;
        
    pc_flgCan := 'N'; -- Inicializamos en 'N': Si tiene Creditos Vigentes
    
    -- Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        BEGIN
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
          
          IF T_pgcod <> ln_pgcod OR T_aomod <> ln_aomod OR
            T_aosuc <> ln_aosuc OR T_aocta <> ln_aocta OR
            T_aomda <> ln_aomda OR T_aopap <> ln_aopap OR
            T_aooper <> ln_aooper OR T_aosbop <> ln_aosbop OR
            T_aotope <> ln_aotope THEN
            PQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          ELSE
            lv_flagCanc := 'S';
          END IF;
          
          IF lv_flagCanc = 'N' THEN
            pc_flgCan := 'S';
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            my_errm := SQLERRM;
        END;
        EXIT WHEN pc_flgCan = 'S';
      END LOOP;
      EXIT WHEN pc_flgCan = 'S';
    END LOOP;
    
    pn_coderr := 0; -- Inicializamos en 0: Si tiene Creditos Vigentes
    
    IF pc_flgCan = 'N' THEN
      pn_coderr := 1;
    END IF;    
    -- pc_flgCan = 'S': Si tiene Creditos Vigentes
    -- pc_flgCan = 'N': No tiene Creditos Vigentes
    
    -- pn_coderr = 0: Si tiene Creditos Vigentes
    -- pn_coderr = 1: No tiene Creditos Vigentes    
  END sp_cr_Todos_Crd99_CNA;
  
  -- rcuadros 2024.06.10
  PROCEDURE sp_cr_Todos_Aval99_CNA(pn_pgcod IN NUMBER,
                                   pn_aomod IN NUMBER,
                                   pn_aosuc IN NUMBER,
                                   pn_aomda IN NUMBER,
                                   pn_aopap IN NUMBER,
                                   pn_aocta IN NUMBER,
                                   pn_aooper IN NUMBER,
                                   pn_aosbop IN NUMBER,
                                   pn_aotope IN NUMBER,
                                   pn_coderr OUT NUMBER,
                                   pc_flgCan OUT VARCHAR2
                                  ) IS
  
    CURSOR lst_ctn(c_pais NUMBER, c_tdoc NUMBER, c_ndoc VARCHAR2) IS
      SELECT b.ctnro
        FROM fsr008 b
       WHERE b.cttfir = 'T'
         AND b.pepais = c_pais
         AND b.petdoc = c_tdoc
         AND b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta NUMBER) IS
      SELECT f.pgcod,
             f.aomod,
             f.aosuc,
             f.aomda,
             f.aopap,
             f.aocta,
             f.aooper,
             MAX(f.aosbop) aosbop,
             f.AOTOPE,
             f.Aostat
        FROM Fsd010 f
       WHERE (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) IN
             (SELECT XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                FROM XWF700
               WHERE XWFCar3 = '1'
                 AND XWFPRCINS IN
                     (SELECT SNG001Inst FROM SNG003 WHERE SNG003Cta = c_cta))
       GROUP BY f.pgcod,
                f.aomod,
                f.aosuc,
                f.aomda,
                f.aopap,
                f.aocta,
                f.aooper,
                f.aotope,
                f.Aostat;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta NUMBER;
    ln_pais   NUMBER;
    ln_tdoc   NUMBER;
    ln_ndoc   VARCHAR2(12);
  
    ln_pgcod  NUMBER(3);
    ln_aomod  NUMBER(3);
    ln_aosuc  NUMBER(3);
    ln_aomda  NUMBER(4);
    ln_aopap  NUMBER(4);
    ln_aocta  NUMBER(9);
    ln_aooper NUMBER(9);
    ln_aosbop NUMBER(3);
    ln_aotope NUMBER(3);
  
    T_pgcod  NUMBER(3);
    T_aomod  NUMBER(3);
    T_aosuc  NUMBER(3);
    T_aomda  NUMBER(4);
    T_aopap  NUMBER(4);
    T_aocta  NUMBER(9);
    T_aooper NUMBER(9);
    T_aosbop NUMBER(3);
    T_aotope NUMBER(3);
    T_aostat NUMBER(3);
  
    pn_contador NUMBER;
    ln_sld_011  NUMBER;
    ld_fecguia  DATE;
  
    lv_flagCanc VARCHAR2(5);
    ld_fec99    DATE;
    ln_estadoC  NUMBER;
  
  BEGIN
    pc_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
    ---
    ln_pgcod := pn_pgcod;
    ln_aomod := pn_aomod;
    ln_aosuc := pn_aosuc;
    ln_aomda := pn_aomda;
    ln_aopap := pn_aopap;
    ln_aocta := pn_aocta;
    ln_aooper := pn_aooper;
    ln_aosbop := pn_aosbop;
    ln_aotope := pn_aotope;
    
    BEGIN
       SELECT d.aofe99 INTO ld_fecguia
         FROM fsd010 d
        WHERE d.pgcod = pn_pgcod
          AND d.aomod = pn_aomod
          AND d.aosuc = pn_aosuc
          AND d.aomda = pn_aomda
          AND d.aopap = pn_aopap
          AND d.aocta = pn_aocta
          AND d.aooper = pn_aooper
          AND d.aosbop = pn_aosbop
          AND d.aotope = pn_aotope
          AND d.aostat = 99;
    EXCEPTION
      WHEN OTHERS THEN
        my_errm := SQLERRM;
    END;
    
    -- Obtenemos el documento del cliente
    BEGIN
      SELECT b.pepais, b.petdoc, b.pendoc
        INTO ln_pais, ln_tdoc, ln_ndoc
        FROM fsr008 b
       WHERE b.cttfir = 'T'
         AND b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        my_errm := SQLERRM;
    END;
    
    -- Contamos los creditos
    pc_flgCan := 'N'; -- Inicializamos en 'N': Si tiene Avales Vigentes
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        BEGIN
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
                
          IF T_pgcod <> ln_pgcod OR T_aomod <> ln_aomod OR
            T_aosuc <> ln_aosuc OR T_aocta <> ln_aocta OR
            T_aomda <> ln_aomda OR T_aopap <> ln_aopap OR
            T_aooper <> ln_aooper OR T_aosbop <> ln_aosbop OR
            T_aotope <> ln_aotope THEN
            PQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          ELSE
            lv_flagCanc := 'S';
          END IF;

          IF lv_flagCanc = 'N' THEN
            pc_flgCan := 'S';
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            my_errm := SQLERRM;
        END;
        EXIT WHEN pc_flgCan = 'S';
      END LOOP;
      EXIT WHEN pc_flgCan = 'S';
    END LOOP;
    
    pn_coderr := 0; -- Inicializamos en 0: Si tiene Avales Vigentes
    
    IF pc_flgCan = 'N' THEN
      pn_coderr := 1;
    END IF;    
    -- pc_flgCan = 'S': Si tiene Avales Vigentes
    -- pc_flgCan = 'N': No tiene Avales Vigentes
        
    -- pn_coderr = 0: Si tiene Avales Vigentes
    -- pn_coderr = 1: No tiene Avales Vigentes    
  END sp_cr_Todos_Aval99_CNA;
  
  -- rcuadros 2024.06.10
  PROCEDURE sp_cr_es_castig_judic_venta(pn_pais IN NUMBER,     -- Pais del documento
                                        pn_tdoc IN NUMBER,     -- Tipo del documento
                                        pn_ndoc IN VARCHAR2,   -- Numero de documento
                                        pn_coderr OUT NUMBER,  -- Codigo de error
                                        pc_msjerr OUT VARCHAR2 -- Mensaje de error
                                       ) IS
    my_errm VARCHAR2(32000);
  
    l_pais NUMBER(5);
    l_tdoc NUMBER(5);
    l_ndoc CHARACTER(12);
  
    ln_coderr NUMBER;
    lv_merror VARCHAR2(5);
  
    ln_coderrAval NUMBER;
    lv_flgCanAval VARCHAR2(5);
  
    CURSOR lst_cuentas(pais NUMBER, tdoc NUMBER, doc VARCHAR2) IS
      SELECT Ctnro NroCta
        FROM fsr008
       WHERE Cttfir = 'T'
         AND Pepais = pais
         AND Petdoc = tdoc
         AND Pendoc = rpad(doc, 12, ' ');
  BEGIN
    -- Cursor de cuentas
    FOR i IN lst_cuentas(pn_pais, pn_tdoc, pn_ndoc) LOOP
      BEGIN
        SELECT 'S'
          INTO lv_merror
          FROM fsd010
         WHERE aomod IN (200, 33, 65)
           AND aocta = i.NroCta
           AND rownum = 1;
      EXCEPTION
        WHEN OTHERS THEN
          lv_merror := 'N';
      END;
      
      BEGIN
        SELECT 'S'
          INTO lv_flgCanAval
          FROM fsd010 f, xwf700 x, sng003 s
         WHERE aomod IN (200, 33, 65)
           AND f.pgcod = x.xwfempresa
           AND f.aomda = x.xwfmoneda
           AND f.aopap = x.xwfpapel
           AND f.aocta = x.xwfcuenta
           AND f.aooper = x.xwfoperacion
           AND x.xwfprcins = s.sng001inst
           AND x.xwfcar3 = '1'
           AND s.sng003cta = i.NroCta
           AND rownum = 1;
      EXCEPTION
        WHEN OTHERS THEN
          lv_flgCanAval := 'N';
      END;
    
      IF lv_merror = 'N' AND lv_flgCanAval = 'N' THEN
        pn_coderr := 1;
        pc_msjerr := 'S';
      ELSE
        pn_coderr := 0;
        pc_msjerr := 'N';
        RETURN;
      END IF;
    END LOOP;    
    -- pc_msjerr = 'N': Si tiene Creditos Castigados
    -- pc_msjerr = 'S': No tiene Creditos Castigados 

    -- pn_coderr = 0: Si tiene Creditos Castigados
    -- pn_coderr = 1: No tiene Creditos Castigados
  END sp_cr_es_castig_judic_venta;
  
  -- rcuadros 2024.06.14
  procedure sp_cr_todos_Crd99_CNA_pbproc(pn_pgcod IN NUMBER,
                                         pn_hcmod IN NUMBER,
                                         pn_hsucor IN NUMBER,
                                         pn_htran IN NUMBER,
                                         pn_hnrel IN NUMBER,
                                         pn_feccan IN DATE,
                                         pn_coderr OUT NUMBER,
                                         pc_flgCan OUT VARCHAR2
                                        ) IS

    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd(n_nrocta number) IS
      select d.pgcod,
             d.aomod,
             d.aosuc,
             d.aomda,
             d.aopap,
             d.aocta,
             d.aooper,
             d.aotope,
             d.aosbop,
             d.aostat
        from fsd010 d
       where d.aocta = n_nrocta
         and d.aomod in (select t111.modulo
                           from fst111 t111
                          where t111.Dscod = 50
                            and t111.Modulo != 116)
         and d.aosbop = (select max(d1.AOSBOP)
                           from fsd010 d1
                          where d1.PGCOD = d.pgcod
                            and d1.AOMOD = d.aomod
                            and d1.AOMDA = d.aomda
                            and d1.AOPAP = d.aopap
                            and d1.AOCTA = d.aocta
                            and d1.AOSUC = d.aosuc
                            and d1.AOOPER = d.aooper
                            and d1.AOTOPE = d.aotope)
       order by d.PGCOD,
                d.AOMOD,
                d.AOMDA,
                d.AOPAP,
                d.AOCTA,
                d.AOSUC,
                d.AOOPER,
                d.AOSBOP;
  
    my_errm VARCHAR2(32000);
  
    ln_pais number;
    ln_tdoc number;
    ln_ndoc varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    ln_sld_011  number;
    ld_fecguia  date;
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  BEGIN
    --ld_fecguia := fn_get_FecGuia();
    ld_fecguia := pQ_CR_VALI_CRED_CANC.fn_get_FecGuia();
  
    --obtenermos la clave del credito
    begin
      /*
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
         */
         
          SELECT DISTINCT b.PGCOD,
                          b.HMODUL,
                          b.HSUCUR,
                          b.HMDA,
                          b.HPAP,
                          b.HCTA,
                          b.HOPER,
                          b.HSUBOP,
                          b.HTOPER
          INTO ln_pgcod,
               ln_aomod,
               ln_aosuc,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          FROM fsh015 a
          INNER JOIN fsh016 b 
                  ON b.PGCOD = a.PGCOD 
                  AND b.HCMOD = a.HCMOD 
                  AND b.HSUCOR = a.HSUCOR 
                  AND b.HTRAN = a.HTRAN 
                  AND b.HNREL = a.HNREL 
                  AND b.HFCON = a.HFCON 
          INNER JOIN fsd010 c 
                  ON c.PGCOD = b.PGCOD 
                  AND c.AOMOD = b.HMODUL 
                  AND c.AOSUC = b.HSUCUR 
                  AND c.AOMDA = b.HMDA 
                  AND c.AOPAP = b.HPAP 
                  AND c.AOCTA = b.HCTA 
                  AND c.AOOPER = b.HOPER 
                  AND c.AOSBOP = b.HSUBOP 
                  AND c.AOTOPE = b.HTOPER 
                  AND c.AOFE99 = b.HFCON 
          WHERE a.PGCOD = pn_pgcod
            AND a.HCMOD = pn_hcmod
            AND a.HSUCOR = pn_hsucor
            AND a.HTRAN = pn_htran
            AND a.HNREL = pn_hnrel
            AND a.HFCON = pn_feccan;-- Dmanriquec - Se añade validación por la fecha mas
           
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY; -- VERIFICAR
    EXCEPTION
      when others then
        my_errm := SQLERRM;
    end;
  
    /*    ln_pais := 604;
    ln_tdoc := 21; 
    ln_ndoc := rpad('29555982',12,' ');--'29278775    ';*/
  
    pc_flgCan := 'N';
  
    --Comprobar creditos
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      FOR j IN lst_crd(i.ctnro) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          --apachecoh 2022.09.28 modificacion
          if T_pgcod <> ln_pgcod or T_aomod <> ln_aomod or
             T_aosuc <> ln_aosuc or T_aocta <> ln_aocta or
             T_aomda <> ln_aomda or T_aopap <> ln_aopap or
             T_aooper <> ln_aooper or T_aosbop <> ln_aosbop or
             T_aotope <> ln_aotope then
            pQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          else
            lv_flagCanc := 'S';
          end if;
          --apachecoh 2022.09.28 modificacion
        
          if lv_flagCanc = 'N' then
            pc_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN pc_flgCan = 'S';
      END LOOP;
      EXIT WHEN pc_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flag99 = 'N'o tiene obligaciones
    --        = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if pc_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_todos_Crd99_CNA_pbproc;
  
  -- rcuadros 2024.06.14
  PROCEDURE sp_cr_todos_Aval99_CNA_pbproc(pn_pgcod IN NUMBER,
                                          pn_hcmod IN NUMBER,
                                          pn_hsucor IN NUMBER,
                                          pn_htran IN NUMBER,
                                          pn_hnrel IN NUMBER,
                                          pn_feccan IN DATE,
                                          pn_coderr OUT NUMBER,
                                          pc_flgCan OUT VARCHAR2
                                         ) IS
                                         
    CURSOR lst_ctn(c_pais number, c_tdoc number, c_ndoc varchar2) IS
      select b.ctnro
        from fsr008 b
       where b.cttfir = 'T'
         and b.pepais = c_pais
         and b.petdoc = c_tdoc
         and b.pendoc = c_ndoc;
  
    CURSOR lst_crd_Aval(c_cta number) IS
      select f.PGCOD,
             f.AOMOD,
             f.AOSUC,
             f.AOMDA,
             f.AOPAP,
             f.AOCTA,
             f.AOOPER,
             max(f.AOSBOP) aosbop,
             f.AOTOPE,
             f.Aostat
        from Fsd010 f
       Where (Pgcod, Aomod, Aosuc, Aomda, Aopap, Aocta, Aooper, Aosbop,
              Aotope) in
             (select XWfEmpresa,
                     XWfModulo,
                     XWfSucursal,
                     XWfMoneda,
                     XWfPapel,
                     XWfCuenta,
                     XWfOperacion,
                     XWfSubope,
                     XWfTipOpe
                from XWF700
               Where XWFCar3 = '1'
                 and XWFPRCINS in
                     (select SNG001Inst from SNG003 Where SNG003Cta = c_cta))
       group by f.PGCOD,
                f.AOMOD,
                f.AOSUC,
                f.AOMDA,
                f.AOPAP,
                f.AOCTA,
                f.AOOPER,
                f.AOTOPE,
                f.Aostat;
  
    my_errm   VARCHAR2(32000);
    ln_TmpCta number;
    ln_pais   number;
    ln_tdoc   number;
    ln_ndoc   varchar2(12);
  
    ln_pgcod  number(3);
    ln_aomod  number(3);
    ln_aosuc  number(3);
    ln_aomda  number(4);
    ln_aopap  number(4);
    ln_aocta  number(9);
    ln_aooper number(9);
    ln_aosbop number(3);
    ln_aotope number(3);
  
    T_pgcod  number(3);
    T_aomod  number(3);
    T_aosuc  number(3);
    T_aomda  number(4);
    T_aopap  number(4);
    T_aocta  number(9);
    T_aooper number(9);
    T_aosbop number(3);
    T_aotope number(3);
    T_aostat number(3);
  
    pn_contador number;
    ln_sld_011  number;
    ld_fecguia  date;
  
    lv_flagCanc varchar2(5);
    ld_fec99    date;
    ln_estadoC  number;
  
  BEGIN
    pc_flgCan   := 'N';
    pn_coderr   := 0;
    pn_contador := 0;
  
    --ld_fecguia := fn_get_FecGuia();
    ld_fecguia := pQ_CR_VALI_CRED_CANC.fn_get_FecGuia();
    --obtenermos la clave del credito
    begin
      /*
      select distinct b.pgcod,
                      b.modulo,
                      b.itsucd,
                      b.moneda,
                      b.papel,
                      b.ctnro,
                      b.itoper,
                      b.itsubo,
                      b.ittope
        into ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope
        from fsd016 b, fsd015 a, fsd010 c
       where b.pgcod = a.pgcod
         and b.itsuc = a.itsuc
         and b.itmod = a.itmod
         and b.ittran = a.ittran
         and b.itnrel = a.itnrel
         and b.itfval = a.itfcon
         and b.pgcod = c.pgcod
         and b.modulo = c.aomod
         and b.itsucd = c.aosuc
         and b.moneda = c.aomda
         and b.papel = c.aopap
         and b.ctnro = c.aocta
         and b.itoper = c.aooper
         and b.itsubo = c.aosbop
         and b.ittope = c.aotope
         and a.pgcod = pn_pgcod
         and a.itsuc = pn_itsuc
         and a.itmod = pn_itmod
         and a.ittran = pn_ittran
         and a.itnrel = pn_itnrel;
         */
         
          SELECT DISTINCT b.PGCOD,
                          b.HMODUL,
                          b.HSUCUR,
                          b.HMDA,
                          b.HPAP,
                          b.HCTA,
                          b.HOPER,
                          b.HSUBOP,
                          b.HTOPER
          INTO ln_pgcod,
               ln_aomod,
               ln_aosuc,
               ln_aomda,
               ln_aopap,
               ln_aocta,
               ln_aooper,
               ln_aosbop,
               ln_aotope
          FROM fsh015 a
          INNER JOIN fsh016 b 
                  ON b.PGCOD = a.PGCOD 
                  AND b.HCMOD = a.HCMOD 
                  AND b.HSUCOR = a.HSUCOR 
                  AND b.HTRAN = a.HTRAN 
                  AND b.HNREL = a.HNREL 
                  AND b.HFCON = a.HFCON 
          INNER JOIN fsd010 c 
                  ON c.PGCOD = b.PGCOD 
                  AND c.AOMOD = b.HMODUL 
                  AND c.AOSUC = b.HSUCUR 
                  AND c.AOMDA = b.HMDA 
                  AND c.AOPAP = b.HPAP 
                  AND c.AOCTA = b.HCTA 
                  AND c.AOOPER = b.HOPER 
                  AND c.AOSBOP = b.HSUBOP 
                  AND c.AOTOPE = b.HTOPER 
                  AND c.AOFE99 = b.HFCON 
          WHERE a.PGCOD = pn_pgcod
            AND a.HCMOD = pn_hcmod
            AND a.HSUCOR = pn_hsucor
            AND a.HTRAN = pn_htran
            AND a.HNREL = pn_hnrel
            AND a.HFCON = pn_feccan;-- Dmanriquec - Se añade validación por la fecha mas
                     
    EXCEPTION
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --Obtener documento del cliente
    begin
      select b.pepais, b.petdoc, b.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 b
       where b.cttfir = 'T'
         and b.ctnro = ln_aocta OFFSET 0 ROWS
       FETCH NEXT 1 ROWS ONLY;
    EXCEPTION
      when others then
        null;
        my_errm := SQLERRM;
    end;
    /*
    ln_pais := 604;
    ln_tdoc := 21;
    ln_ndoc := '07930090    ';
    */
    --Contar creditos
  
    pc_flgCan := 'N';
  
    FOR i IN lst_ctn(ln_pais, ln_tdoc, ln_ndoc) LOOP
      ln_TmpCta := i.ctnro;
      FOR j IN lst_crd_Aval(ln_TmpCta) LOOP
        begin
          T_aocta  := j.aocta;
          T_aooper := j.aooper;
          T_aostat := j.aostat;
          T_pgcod  := j.pgcod;
          T_aomod  := j.aomod;
          T_aosuc  := j.aosuc;
          T_aomda  := j.aomda;
          T_aopap  := j.aopap;
          T_aotope := j.aotope;
          T_aosbop := j.aosbop;
        
          --apachecoh 2022.09.28 modificacion
          if T_pgcod <> ln_pgcod or T_aomod <> ln_aomod or
             T_aosuc <> ln_aosuc or T_aocta <> ln_aocta or
             T_aomda <> ln_aomda or T_aopap <> ln_aopap or
             T_aooper <> ln_aooper or T_aosbop <> ln_aosbop or
             T_aotope <> ln_aotope then
            pQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(T_pgcod,
                               T_aocta,
                               T_aomod,
                               T_aooper,
                               T_aosuc,
                               T_aomda,
                               T_aopap,
                               T_aotope,
                               ld_fecguia,
                               lv_flagCanc,
                               ld_fec99,
                               ln_estadoC);
          else
            lv_flagCanc := 'S';
          end if;
          --apachecoh 2022.09.28 modificacion
        
          if lv_flagCanc = 'N' then
            pc_flgCan := 'S';
          end if;
        EXCEPTION
          when others then
            my_errm := SQLERRM;
        end;
        EXIT WHEN pc_flgCan = 'S';
      END LOOP;
      EXIT WHEN pc_flgCan = 'S';
    END LOOP;
  
    --Todos los creditos cancelados 
    --CodErr = 0 - si tiene creditos pendientes
    --CodErr = 1 - no tiene obligaciones (creditos pendientes)
  
    --&flagAval = 'N'o tiene obligaciones
    --          = 'S'i tiene obligaciones
  
    --activar flag de todos los creditos cancelados        
    pn_coderr := 0;
    if pc_flgCan = 'N' then
      pn_coderr := 1;
    End if;
  
  END sp_cr_todos_Aval99_CNA_pbproc;
  
    -- rcuadros 2024.06.14
  PROCEDURE sp_cr_valida_CNA_impreso (
      pn_hcmod IN NUMBER,
      pn_hsucor IN NUMBER,
      pn_htran IN NUMBER,
      pn_hnrel IN NUMBER,
      pd_feccan IN DATE,
      pn_pgcod IN NUMBER,
      pn_aomod IN NUMBER,
      pn_aosuc IN NUMBER,
      pn_aomda IN NUMBER,
      pn_aopap IN NUMBER,
      pn_aocta IN NUMBER,
      pn_aooper IN NUMBER,
      pn_aosbop IN NUMBER,
      pn_aotope IN NUMBER,
      pn_coderr OUT NUMBER,
      pc_flgVal OUT VARCHAR2
  ) IS

  BEGIN
      pn_coderr := 0;
      pc_flgVal := 'N';
      
      BEGIN
        SELECT 1
          INTO pn_coderr
          FROM AQPB608
           WHERE AQPB608ITSUC = pn_hsucor
           AND AQPB608ITMOD = pn_hcmod
           AND AQPB608ITTRAN = pn_htran
           AND AQPB608ITNREL = pn_hnrel
           AND AQPB608ITFCON = pd_feccan
           AND AQPB608PGCODC = pn_pgcod
           AND AQPB608MODC = pn_aomod
           AND AQPB608SUCC = pn_aosuc
           AND AQPB608MONC = pn_aomda
           AND AQPB608PAPC = pn_aopap
           AND AQPB608CTAC = pn_aocta
           AND AQPB608OPEC = pn_aooper
           AND AQPB608SOPEC = pn_aosbop
           AND AQPB608TOPEC = pn_aotope
           AND AQPB608TIPOCON = 'CNA'
           AND AQPB608PGCODC <> 9
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          pn_coderr := 0;
      END;

      IF pn_coderr = 1 THEN
        BEGIN
          SELECT 1
            INTO pn_coderr
            FROM AQPB608
           WHERE AQPB608ITSUC = pn_hsucor
             AND AQPB608ITMOD = pn_hcmod
             AND AQPB608ITTRAN = pn_htran
             AND AQPB608ITNREL = pn_hnrel
             AND AQPB608ITFCON = pd_feccan            
             AND AQPB608PGCODC = pn_pgcod
             AND AQPB608MODC = pn_aomod
             AND AQPB608SUCC = pn_aosuc
             AND AQPB608MONC = pn_aomda
             AND AQPB608PAPC = pn_aopap
             AND AQPB608CTAC = pn_aocta
             AND AQPB608OPEC = pn_aooper
             AND AQPB608SOPEC = pn_aosbop
             AND AQPB608TOPEC = pn_aotope
             AND AQPB608TIPOCON = 'CNA'
             AND AQPB608FIMPCNA = 'N'
             AND AQPB608PGCODC <> 9
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            pn_coderr := 0;
        END;

        IF pn_coderr = 1 THEN
          pc_flgVal := 'S';
        ELSE
          pc_flgVal := 'N';
        END IF;

      ELSE
        pc_flgVal := 'S';
      END IF;
  END sp_cr_valida_CNA_impreso;

  -- rcuadros 2025.02.17
  PROCEDURE sp_cr_corresponde_cna(
      pn_pepais IN NUMBER,
      pn_petdoc IN NUMBER,
      pc_pendoc IN VARCHAR2,
      pc_flgcna OUT VARCHAR2,
      pc_coderr OUT NUMBER,
      pc_msgerr OUT VARCHAR2
  ) IS
      TYPE T_CUENTAS IS TABLE OF FSR008.CTNRO%TYPE;
      v_cuentas T_CUENTAS;

      CURSOR c1_cuentas IS
          SELECT CTNRO
          FROM FSR008
          WHERE CTTFIR = 'T'
          AND PEPAIS = pn_pepais
          AND PETDOC = pn_petdoc
          AND PENDOC = RPAD(pc_pendoc, 12, ' ');
      
      CURSOR c2_creditos(n_nrocta NUMBER) IS
          SELECT d.PGCOD, d.AOMOD, d.AOSUC, d.AOMDA, d.AOPAP, d.AOCTA, d.AOOPER, d.AOTOPE, d.AOSBOP, d.AOSTAT
          FROM FSD010 d
          WHERE d.AOCTA = N_NROCTA
          AND d.AOMOD IN (SELECT t111.MODULO FROM FST111 t111 WHERE t111.DSCOD = 50 AND t111.MODULO != 116)
          AND d.AOSBOP = (SELECT MAX(d1.AOSBOP) FROM FSD010 d1 WHERE d1.PGCOD = d.PGCOD AND d1.AOMOD = d.AOMOD AND d1.AOMDA = d.AOMDA AND d1.AOPAP = d.AOPAP AND d1.AOCTA = d.AOCTA AND d1.AOSUC = d.AOSUC AND d1.AOOPER = d.AOOPER AND d1.AOTOPE = d.AOTOPE)
          ORDER BY d.PGCOD, d.AOMOD, d.AOMDA, d.AOPAP, d.AOCTA, d.AOSUC, d.AOOPER, d.AOSBOP;
       
      CURSOR c3_creditos_avales(c_cta NUMBER) IS
          SELECT f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, MAX(f.AOSBOP) AS AOSBOP, f.AOTOPE, f.AOSTAT
          FROM FSD010 f
          WHERE (PGCOD, AOMOD, AOSUC, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP, AOTOPE) IN
              (SELECT XWFEMPRESA, XWFMODULO, XWFSUCURSAL, XWFMONEDA, XWFPAPEL, XWFCUENTA, XWFOPERACION, XWFSUBOPE, XWFTIPOPE
               FROM XWF700 WHERE XWFCAR3 = '1' AND XWFPRCINS IN (SELECT SNG001INST FROM SNG003 WHERE SNG003CTA = c_cta))
          GROUP BY f.PGCOD, f.AOMOD, f.AOSUC, f.AOMDA, f.AOPAP, f.AOCTA, f.AOOPER, f.AOTOPE, f.AOSTAT;

      ld_fecgui DATE := PQ_CR_VALI_CRED_CANC.fn_get_FecGuia();
      lc_cancel CHAR(1);
      ld_fecha99 DATE;
      ln_estado NUMBER;
      lc_flgc01 CHAR(1) := 'N';
      lc_flgc02 CHAR(1) := 'N';
      lc_flgcre CHAR(1) := 'N';
      lc_flgava CHAR(1) := 'N';
      lc_flgcas CHAR(1) := 'S';

  BEGIN
      pc_coderr := '00000';
      pc_msgerr := '';
      pc_flgcna := 'N';
      
      -- Obtenemos todas las cuentas en una sola consulta
      OPEN c1_cuentas;
      FETCH c1_cuentas BULK COLLECT INTO v_cuentas;
      CLOSE c1_cuentas;

      -- Validacion de creditos vigentes
      FOR i IN 1 .. v_cuentas.COUNT LOOP
          FOR j IN c2_creditos(v_cuentas(i)) LOOP
              PQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(j.PGCOD, j.AOCTA, j.AOMOD, j.AOOPER, j.AOSUC, j.AOMDA, j.AOPAP, j.AOTOPE, ld_fecgui, lc_cancel, ld_fecha99, ln_estado);
              DBMS_OUTPUT.PUT_LINE('PGCOD: ' || j.PGCOD || ', AOMOD: ' || j.AOMOD || ', AOSUC: ' || j.AOSUC || ', AOMDA: ' || j.AOMDA || ', AOPAP: ' || j.AOPAP || ', AOCTA: ' || j.AOCTA || ', AOOPER: ' || j.AOOPER || ', AOTOPE: ' || j.AOTOPE || ', AOFE99: ' || ld_fecha99 || ', AOSTAT: ' || ln_estado || ', CANCELADO: ' || lc_cancel);

              IF lc_cancel = 'N' THEN
                  lc_flgcre := 'S';
                  EXIT; -- Sale del bucle de creditos
              END IF;
          END LOOP;
          EXIT WHEN lc_flgcre = 'S'; -- Sale del bucle de cuentas
      END LOOP;

      DBMS_OUTPUT.PUT_LINE('¿Tiene creditos vigentes?: ' || lc_flgcre);

      -- Si no tiene creditos vigentes, validamos avales
      IF lc_flgcre = 'N' THEN
          FOR i IN 1 .. v_cuentas.COUNT LOOP
              FOR j IN c3_creditos_avales(v_cuentas(i)) LOOP
                  PQ_CR_VALI_CRED_CANC.sp_cr_val_estado_2(j.PGCOD, j.AOCTA, j.AOMOD, j.AOOPER, j.AOSUC, j.AOMDA, j.AOPAP, j.AOTOPE, ld_fecgui, lc_cancel, ld_fecha99, ln_estado);
                  DBMS_OUTPUT.PUT_LINE('PGCOD: ' || j.PGCOD || ', AOMOD: ' || j.AOMOD || ', AOSUC: ' || j.AOSUC || ', AOMDA: ' || j.AOMDA || ', AOPAP: ' || j.AOPAP || ', AOCTA: ' || j.AOCTA || ', AOOPER: ' || j.AOOPER || ', AOTOPE: ' || j.AOTOPE || ', AOFE99: ' || ld_fecha99 || ', AOSTAT: ' || ln_estado || ', CANCELADO: ' || lc_cancel);

                  IF lc_cancel = 'N' THEN
                      lc_flgava := 'S';
                      EXIT;
                  END IF;
              END LOOP;
              EXIT WHEN lc_flgava = 'S';
          END LOOP;
      END IF;

      DBMS_OUTPUT.PUT_LINE('¿Tiene avales vigentes?: ' || lc_flgava);

      -- Validacion de creditos castigados en la FSD010 y luego en la XWF700, SNG003
      IF lc_flgava = 'N' THEN
          FOR i IN 1 .. v_cuentas.COUNT LOOP
              BEGIN
                SELECT 'S'
                  INTO lc_flgc01
                  FROM FSD010
                 WHERE AOMOD IN (200, 33, 65)
                   AND AOCTA = v_cuentas(i)
                   AND ROWNUM = 1;
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      lc_flgc01 := 'N';
              END;

              BEGIN
                SELECT 'S'
                  INTO lc_flgc02
                  FROM FSD010 f, XWF700 x, SNG003 s
                 WHERE f.AOMOD IN (200, 33, 65)
                   AND f.PGCOD = x.XWFEMPRESA
                   AND f.AOMDA = x.XWFMONEDA
                   AND f.AOPAP = x.XWFPAPEL
                   AND f.AOCTA = x.XWFCUENTA
                   AND f.AOOPER = x.XWFOPERACION
                   AND x.XWFPRCINS = s.SNG001INST
                   AND x.XWFCAR3 = '1'
                   AND s.SNG003CTA = v_cuentas(i)
                   AND ROWNUM = 1;
              EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      lc_flgc02 := 'N';
              END;

              -- Si encuentra creditos castigados, marcamos en S y salimos del bucle
              IF lc_flgc01 = 'S' OR lc_flgc02 = 'S' THEN
                lc_flgcas := 'S';
                EXIT;
              ELSE
                lc_flgcas := 'N';
                EXIT;                
              END IF;
          END LOOP;
      END IF;

      DBMS_OUTPUT.PUT_LINE('¿Tiene creditos castigados?: ' || lc_flgcas);

      -- Establecemos el flag de si corresponde CNA o no
      pc_flgcna := CASE
          WHEN lc_flgcre = 'N' AND lc_flgava = 'N' AND lc_flgcas = 'N' THEN 'S'
          ELSE 'N'
      END;

      DBMS_OUTPUT.PUT_LINE('¿Corresponde entregar CNA?: ' || pc_flgcna);
  EXCEPTION
      WHEN OTHERS THEN
          pc_coderr := '31902';
          pc_msgerr := SUBSTR(SQLERRM, 1, 200);
  END sp_cr_corresponde_cna;
  
END PQ_VAL_CERCANWEB;
 /* GOLDENGATE_DDL_REPLICATION */
/

