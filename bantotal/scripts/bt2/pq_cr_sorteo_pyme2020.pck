create or replace package PQ_CR_SORTEO_PYME2020 is

  -- *****************************************************************
  -- Nombre                     :PROCESO DE REGULARIZACION CUPONES - CAMPAÑA NAVIDAD 2017
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : 
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 23/11/2023
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego dos procedimientos para el sorteo de gratificaciones PRY6678
  -- Fecha de Modificación      : 11/11/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego dos procedimientos para el sorteo de Navidad 2024
  -- Fecha de Modificación      : 19/12/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el proceso para excluir cred con garantia DPF/CTS
  -- Fecha de Modificación      : 28/12/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se puso nvl para instancia
  -- Fecha de Modificación      : 04/02/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego el proceso sp_cr_ValidEnLinea

  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -------------------------------------------------------------------------                                 
  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2);
  -----------------------------------------------------------------------------                                 
  procedure sp_cr_VerifGradoConsagui(ln_NroCuenta    in number,
                                     lc_FlafFamiliar out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_buscadesembolso(lc_digito  in varchar2,
                                  pc_uing    IN VARCHAR2,
                                  ld_FecIni  in date,
                                  ld_FecIFin in date);
  -------------------------------------------------------------
  procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2);
  ---------------------------------------------------------------------

  procedure sp_cr_nroopcionesdes(P_N_CODCAl in number,
                                 ln_opcion  out number,
                                 FlagCl     out varchar2);
  ---------------------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2);
  ------------------------------------------------------------------
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number,
                          lc_TipDesem   IN VARCHAR2);
  --------------------------------------------------------------
  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           FlgIncl  out varchar2);

  -----------------------------------------------------------------------------
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char;
  -----------------------------------------------------------------------------
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number;
  --------------------------------------------------------------
  procedure sp_cr_buscadesembCons(lc_digito  in varchar2,
                                  pc_uing    IN VARCHAR2,
                                  ld_FecIni  in date,
                                  ld_FecIFin in date);
  ----------------------------------------------------------------
  procedure sp_cr_verifpagos(ln_406pgc      in number,
                             ln_406mod      in number,
                             ln_406suc      in number,
                             ln_406mda      in number,
                             ln_406pap      in number,
                             ln_406cta      in number,
                             ln_406ope      in number,
                             ln_406sbo      in number,
                             ln_406top      in number,
                             ld_fchcorte    in date,
                             ln_verifpago   out varchar2,
                             ln_PagoPuntual out varchar2);
  ---------------------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date);
  ---------------------------------------------------------------------
  Procedure sp_cr_Job_Desembolso(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date);

  -------------------------------------------------------------------------
  Procedure sp_cr_Job_DesemCons(pc_uing     in varchar2,
                                pd_fechaIni in date,
                                pd_fechaFin in date);
  ------------------------------------------------------------
  procedure sp_cr_ValidaAdicional(ld_FecFin in date);
  -----------------------------------------------------------
  procedure sp_cr_DesembConsGratif(lc_digito  in varchar2,
                                   pc_uing    IN VARCHAR2,
                                   ld_FecIni  in date,
                                   ld_FecIFin in date);
  --------------------------------------------------------------
  Procedure sp_cr_Job_DesemConsGratf(pc_uing     in varchar2,
                                     pd_fechaIni in date,
                                     pd_fechaFin in date);
  ----------------------------------------------------------------------
  procedure sp_cr_Nav24Pagos(lc_digito in varchar2);
  ----------------------------------------------------------------------
  procedure sp_cr_LogAQPB184(ln_pais   in number,
                             ln_tdoc   in number,
                             lc_ndoc   in varchar2,
                             lc_nomb   in varchar2,
                             lc_ncred  in varchar2,
                             ln_pgcod  in number,
                             ln_mod    in number,
                             ln_suc    in number,
                             ln_mda    in number,
                             ln_pap    in number,
                             ln_cta    in number,
                             ln_ope    in number,
                             ln_sbo    in number,
                             ln_top    in number,
                             ln_ins    in number,
                             lc_asesr  in varchar2,
                             ld_fdes   in date,
                             ld_fcalnd in date,
                             ld_fpago  in date,
                             ln_opcns  in number,
                             ln_zona   in number,
                             ln_reg    in number,
                             lc_dpto   in varchar2,
                             lc_tcred  in varchar2,
                             lc_dir    in varchar2,
                             ln_pgtx   in number,
                             ln_suctx  in number,
                             ln_modtx  in number,
                             ln_tx     in number,
                             ln_reltx  in number,
                             ln_ordtx  in number,
                             ln_fchtx  in date);
  ------------------------------------------------------------------------------------------------
  procedure sp_Cr_ValidEnLinea(ln_pgcodt  in number,
                               ln_suct    in number,
                               ln_modt    in number,
                               ln_ttran   in number,
                               ln_relt    in number,
                               ln_ordt    in number,
                               lv_PCancel out varchar2);
end PQ_CR_SORTEO_PYME2020;
/* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body PQ_CR_SORTEO_PYME2020 is
  -- *****************************************************************
  -- Nombre                     : PROCESO DE REGULARIZACION CUPONES RETOMA TU CHAMBA PYME 2020
  -- Sistema                    : BANTOTAL
  -- Módulo                     : 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.08.16
  -- Autor de Creación          : MPOSTIGOC 
  -- Uso                        : GENERACION DE DATA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ----------------------------------------------------------------------------
  procedure sp_cr_buscadesembolso(lc_digito  in varchar2,
                                  pc_uing    IN VARCHAR2,
                                  ld_FecIni  in date,
                                  ld_FecIFin in date) is
  
    Cursor data1 is
      select distinct f.aomod JAQL406Mod,
                      f.aosuc JAQL406Suc,
                      f.aomda JAQL406Mda,
                      f.aocta JAQL406Cta,
                      f.aooper JAQL406Ope,
                      f.aosbop JAQL406Sbo,
                      f.aotope JAQL406Top,
                      g.htran JAQL406TTRAN,
                      g.hcmod JAQL406TMOD,
                      g.hnrel JAQL406TNREL,
                      g.hcord JAQL406TORD,
                      g.hsucor JAQL406TSUC,
                      g.hcsubo JAQL406TSBOR,
                      f.pgcod JAQL406PGC,
                      f.aopap JAQL406PAP,
                      lpad(trim(to_char(f.aocta)), 9, '0') ||
                      lpad(trim(to_char(f.aomda)), 3, '0') ||
                      lpad(trim(to_char(f.aooper)), 9, '0') CREDITO,
                      (select r2.regcod
                         from fst810 r2, fst811 r
                        where r2.pgcod = r.pgcod
                          and r2.regcod = r.regcod
                          and r.pgcod = 1
                          and r.oficod = f.aosuc
                          and r2.regcod < 100) REGION,
                      F.AOFVAL FECH_OPERACION
        from fsd010 f, fsh016 g, fsh015 d
       where f.pgcod = 1
         and f.aomod in
             (select j.modulo
                from fst111 j
               where j.dscod = 50
                 and j.modulo not in (29, 33, 108, 142, 144, 200))
         and f.aofval between ld_FecIni and ld_FecIFin
         and f.pgcod = g.pgcod
         and f.aomod = g.hmodul
         and f.aosuc = g.hsucur
         and f.aomda = g.hmda
         and f.aopap = g.hpap
         and f.aocta = g.hcta
         and f.aooper = g.hoper
         and f.aosbop = g.hsubop
         and f.aotope = g.htoper
         and f.aofval = g.hfcon
         and g.pgcod = d.pgcod
         and g.hcmod = d.hcmod
         and g.hsucor = d.hsucor
         and g.htran = d.htran
         and g.hnrel = d.hnrel
         and g.hfcon = d.hfcon
         and d.hccorr <> 99
         and f.aoimp > = 1000
         and to_char(substr(trim(f.aocta), -1, 1)) = lc_digito;
    --  and f.aocta = 701130;
  
    ln_sbop number(3);
    ln_tope number(3);
    ln_cta  NUMBER(9);
    ln_mod  NUMBER(4);
    ln_mda  NUMBER(3);
    ln_oper NUMBER(9);
    ln_suc  number(3);
  
    ln_ttran   number;
    ln_tmod    number;
    ln_tnrel   number;
    ln_tord    number;
    ln_tsuc    number;
    ln_tsbor   number;
    ln_pgcod   number;
    ln_papel   number;
    ln_nrocred varchar2(21);
    ln_region  number;
  
    P_D_FECHA  date;
    lc_Est     char(1);
    lc_Ant     char(1);
    ln_Atr     NUMBER(10);
    lc_Tip     char(1);
    lc_EXCUP   char(5);
    ld_fecha   date;
    FlgInc     char(1);
    p_c_numdoc varchar2(12);
    ln_tdoc    number(2);
    lc_tndoc   char(12);
    ln_opcion  number(5) := 1;
  
    ln_scstat  number(2);
    lc_docsbs  char(1);
    ln_calific number(10);
    ln_NUMP    NUMBER(9);
    ln_CUPNUM  NUMBER(10);
    --P_N_CODCAl        number;
    FlagCl     varchar2(2) := 'S';
    flag_exist varchar2(2);
    --P_C_DESCAL        varchar2(40);
    i                 number := 1;
    Fecha_operacion   date;
    P_N_PAIS          number;
    lc_flgtrabajador  varchar2(2) := 'N';
    lc_FlagFamiliar   varchar2(2) := 'N';
    lc_TipDesem       varchar2(2) := 'N';
    ln_Instancia      number;
    lc_VerifPago      varchar2(2) := 'S';
    ln_ModEval        number;
    ln_tipoSoli       number;
    lc_PagoPuntual    varchar2(2) := 'N';
    ln_OpcionDesemb   number := 0;
    ln_OpcionPagoPunt number := 0;
    ln_TieneSeg       number := 0;
    CuponAdicSeg      number := 0;
  
  BEGIN
  
    For j in data1 loop
    
      ln_mod          := j.jaql406mod;
      ln_suc          := j.jaql406suc;
      ln_mda          := j.jaql406mda;
      ln_cta          := j.jaql406cta;
      ln_oper         := j.jaql406ope;
      ln_sbop         := j.jaql406sbo;
      ln_tope         := j.jaql406top;
      ln_ttran        := j.JAQL406TTRAN;
      ln_tmod         := j.JAQL406TMOD;
      ln_tnrel        := j.JAQL406TNREL;
      ln_tord         := j.JAQL406TORD;
      ln_tsuc         := j.JAQL406TSUC;
      ln_tsbor        := j.JAQL406TSBOR;
      ln_pgcod        := j.JAQL406PGC;
      ln_papel        := j.JAQL406PAP;
      ln_nrocred      := j.CREDITO;
      ln_region       := j.region;
      Fecha_operacion := j.FECH_OPERACION;
    
      PQ_CR_SORTEO_PYME2020.sp_cr_ChekTrabajador(j.jaql406cta,
                                                 lc_flgtrabajador);
    
      if lc_flgtrabajador = 'N' then
      
        PQ_CR_SORTEO_PYME2020.sp_cr_VerifGradoConsagui(j.jaql406cta,
                                                       lc_FlagFamiliar);
      
        IF lc_FlagFamiliar = 'N' then
        
          begin
            -- Estado del credito 
            select f.aostat
              into ln_scstat
              from fsd010 f
             where f.pgcod = ln_pgcod
               and f.aomod = ln_mod
               and f.aosuc = ln_suc
               and f.aomda = ln_mda
               and f.aopap = ln_papel
               and f.aocta = ln_cta
               and f.aooper = ln_oper
               and f.aosbop = ln_sbop
               and f.aotope = ln_tope
               and f.aofval = Fecha_operacion;
          exception
            when others then
              ln_scstat := 0;
          end;
        
          PQ_CR_SORTEO_PYME2020.sp_Excepciones(ln_mod,
                                               ln_suc,
                                               ln_mda,
                                               ln_cta,
                                               ln_oper,
                                               ln_sbop,
                                               ln_tope,
                                               --  ln_scstat,
                                               FlgInc);
        
          pq_cr_sorteo_pyme2020.sp_cr_verifpagos(ln_406pgc      => ln_pgcod,
                                                 ln_406mod      => ln_mod,
                                                 ln_406suc      => ln_suc,
                                                 ln_406mda      => ln_mda,
                                                 ln_406pap      => ln_papel,
                                                 ln_406cta      => ln_cta,
                                                 ln_406ope      => ln_oper,
                                                 ln_406sbo      => ln_sbop,
                                                 ln_406top      => ln_tope,
                                                 ld_fchcorte    => ld_FecIFin,
                                                 ln_verifpago   => lc_VerifPago,
                                                 ln_PagoPuntual => lc_PagoPuntual);
        
          If FlgInc <> 'N' and lc_VerifPago = 'S' then
          
            begin
            
              select PETDOC, PENDOC, PEPAIS
                into ln_tdoc, lc_tndoc, P_N_PAIS
                from fsr008 f
               where PGCOD = 1
                 and CTNRO = ln_cta
                 AND f.cttfir = 'T';
            exception
              when others then
                null;
              
            end;
            p_c_numdoc := trim(lc_tndoc);
          
            begin
              select pgfape - 1 into P_D_FECHA from fst017 where pgcod = 1;
            exception
              when others then
                null;
              
            end;
          
            ln_Instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                                 v_Scsuc  => ln_suc,
                                                 v_Scmda  => ln_mda,
                                                 v_Scpap  => 0,
                                                 v_Sccta  => ln_cta,
                                                 v_Scoper => ln_oper,
                                                 v_Scsbop => ln_sbop,
                                                 v_Sctope => ln_tope);
          
            begin
              select s.sng001ori
                into ln_tipoSoli
                from sng001 s
               where s.sng001inst = ln_Instancia;
            exception
              when others then
                ln_tipoSoli := 99;
            end;
          
            if ln_tipoSoli in (0, 4, 7, 11, 15) then
            
              begin
                select s.sng021tmod
                  into ln_ModEval
                  from sng021 s
                 where s.sng021sol = ln_Instancia;
              exception
                when others then
                  null;
              end;
            
              if ln_ModEval = 13 then
                lc_TipDesem := 'P';
              else
                if ln_ModEval = 14 then
                  lc_TipDesem := 'C';
                end if;
              end if;
            
              /* PQ_CR_SORTEO_PYME2020.sp_cr_SegmntLinea(ln_Instancia,
                                                      P_N_CODCAl,
                                                      P_C_DESCAL);
              
              PQ_CR_SORTEO_PYME2020.sp_cr_nroopcionesdes(P_N_CODCAl,
                                                         ln_opcion,
                                                         FlagCl);*/
              ln_OpcionDesemb := 1;
            
              if lc_PagoPuntual = 'S' then
                ln_OpcionPagoPunt := 1;
              else
                ln_OpcionPagoPunt := 0;
              end if;
            
              begin
                -- Seguros
                begin
                  select count(*)
                    into ln_TieneSeg
                    from fpp001 f
                   where f.pgcod = 1
                     and f.aomod = ln_mod
                     and f.aosuc = ln_suc
                     and f.aomda = ln_mda
                     and f.aopap = 0
                     and f.aocta = ln_cta
                     and f.aooper = ln_oper
                     and f.aosbop = ln_sbop
                     and f.aotope = ln_tope
                     and f.sgcod not in
                         (select g.sgcod
                            from fst300 g
                           where g.sgtxt like '%Desgr%');
                exception
                  when others then
                    null;
                end;
              
                if ln_TieneSeg > 0 then
                  CuponAdicSeg := +1;
                end if;
              
              end;
            
              ln_opcion := nvl(ln_OpcionDesemb, 0) +
                           nvl(ln_OpcionPagoPunt, 0) + nvl(CuponAdicSeg, 0);
            
              ln_opcion := nvl(ln_opcion, 0);
            
              If ln_opcion <> 0 and FlagCl <> 'N' then
              
                -- lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
              
                Begin
                  -- Tipo de DOC para la RCC
                  select to_char(a.tp1corr3)
                    into lc_docsbs
                    from fst198 a
                   where a.tp1cod = 1
                     and a.tp1cod1 = 11111
                     and a.tp1corr1 = 1
                     and a.tp1corr2 = 3
                     and a.tp1nro1 = ln_tdoc;
                exception
                  when others then
                    lc_docsbs := '0';
                End;
              
                ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
              
                If FlgInc <> 'N' and ln_calific = 1 then
                
                  lc_Est   := 'S';
                  lc_Ant   := 'N';
                  lc_EXCUP := 'C';
                  ln_Atr   := 0;
                
                  ln_NUMP   := 0;
                  ln_CUPNUM := 1;
                
                  begin
                    select pgfape
                      into ld_fecha
                      from fst017
                     where pgcod = 1;
                  exception
                    when others then
                      null;
                    
                  end;
                
                  lc_Tip := 'D';
                
                  PQ_CR_SORTEO_PYME2020.sp_cr_verificajaql406(j.jaql406pgc,
                                                              j.JAQL406Mod,
                                                              j.JAQL406Suc,
                                                              j.JAQL406Mda,
                                                              j.JAQL406pap,
                                                              j.JAQL406Cta,
                                                              j.JAQL406Ope,
                                                              j.JAQL406Sbo,
                                                              j.JAQL406Top,
                                                              Fecha_operacion,
                                                              j.JAQL406tsbor,
                                                              j.JAQL406tord,
                                                              j.JAQL406tnrel,
                                                              j.JAQL406ttran,
                                                              j.JAQL406tmod,
                                                              j.JAQL406tsuc,
                                                              flag_exist);
                  if flag_exist <> 'S' then
                  
                    while i <= ln_opcion loop
                      PQ_CR_SORTEO_PYME2020.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                          j.JAQL406pgc,
                                                          j.JAQL406Mod,
                                                          j.JAQL406Suc,
                                                          j.JAQL406Mda,
                                                          j.JAQL406pap,
                                                          j.JAQL406Cta,
                                                          j.JAQL406Ope,
                                                          j.JAQL406Sbo,
                                                          j.JAQL406Top,
                                                          ln_nrocred,
                                                          ld_fecha,
                                                          Fecha_operacion,
                                                          lc_Est,
                                                          UPPER(pc_uing),
                                                          j.JAQL406Suc,
                                                          j.region,
                                                          lc_Ant,
                                                          ln_Atr,
                                                          ln_calific,
                                                          lc_Tip,
                                                          lc_EXCUP,
                                                          j.JAQL406tsbor,
                                                          j.JAQL406tord,
                                                          j.JAQL406tnrel,
                                                          j.JAQL406ttran,
                                                          j.JAQL406tmod,
                                                          j.JAQL406tsuc,
                                                          Fecha_operacion,
                                                          ln_NUMP,
                                                          ln_CUPNUM,
                                                          ln_opcion,
                                                          lc_TipDesem);
                      i := i + 1;
                    
                    end loop;
                  
                    i := 1;
                  
                  End IF;
                
                End If;
              End If;
            End If;
          End If;
        End If;
      end if;
    End loop;
  
  end sp_cr_buscadesembolso;
  -------------------------------------------------------------------------
  procedure sp_cr_SegmntLinea(ln_Instancia in number,
                              P_N_CODCAl   out number,
                              P_C_DESCAL   out varchar2) is
  
    lc_Usuario       char(30);
    ln_SegLinea      number;
    ln_pae70nro      number;
    P_N_PAIS         number;
    p_n_tipdoc       number;
    p_c_numdoc       char(12);
    lc_UltSegmnLinea varchar2(30);
  
  begin
  
    begin
      select wfitemusrcod
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wftaskcod = 3
         and w.wfiteminit =
             (select max(r.wfiteminit)
                from wfwrkitems r
               where r.wfinsprcid = w.wfinsprcid
                 and r.wftaskcod = w.wftaskcod);
    exception
      when others then
        lc_Usuario := null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into P_N_PAIS, p_n_tipdoc, p_c_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia
         and s.sng001emp = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select b.segcod
        into ln_SegLinea
        from sngc60 a, sngc07 b
       where a.sngc60pais = P_N_PAIS
         and a.sngc60tdoc = p_n_tipdoc
         and a.sngc60ndoc = p_c_numdoc
         and a.sngc60ocup = b.sngc07cod;
    exception
      when too_many_rows then
        begin
          select b.segcod
            into ln_SegLinea
            from sngc60 a, sngc07 b
           where a.sngc60pais = P_N_PAIS
             and a.sngc60tdoc = p_n_tipdoc
             and a.sngc60ndoc = p_c_numdoc
             and a.sngc60ocup = b.sngc07cod
             and a.sngc60corr =
                 (select max(a.sngc60corr)
                    from sngc60 a, sngc07 b
                   where a.sngc60pais = P_N_PAIS
                     and a.sngc60tdoc = p_n_tipdoc
                     and a.sngc60ndoc = p_c_numdoc
                     and a.sngc60ocup = b.sngc07cod);
        
        end;
      when no_data_found then
        null;
    end;
  
    if p_n_tipdoc = 9 then
      ln_SegLinea := 1;
    end if;
  
    begin
      select max(f.pae70nro)
        into ln_pae70nro
        from fpae70 f
       where f.pae70ins = ln_Instancia
         and f.pae70usr = lc_Usuario
         and f.pae51eva = 1
         and f.pae70nro = (select max(g.pae70nro)
                             from fpae70 g
                            where g.pae70ins = f.pae70ins
                              and g.pae70usr = f.pae70usr
                              and g.pae51eva = f.pae51eva);
    exception
      when others then
        null;
    end;
  
    ln_pae70nro := nvl(ln_pae70nro, 0);
  
    if ln_pae70nro = 0 then
      begin
        select max(f.pae70nro)
          into ln_pae70nro
          from fpae70 f
         where f.pae70ins = ln_Instancia
           and f.pae51eva = 4
           and f.pae70nro = (select max(g.pae70nro)
                               from fpae70 g
                              where g.pae70ins = f.pae70ins
                                and g.pae70usr = f.pae70usr
                                and g.pae51eva = f.pae51eva);
      exception
        when others then
          null;
      end;
    end if;
  
    if ln_SegLinea = 1 then
      begin
        select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                              '[0-9]',
                                                              '')),
                                              ':',
                                              '')),
                                     '/',
                                     '')),
                            '.',
                            ''))
          into lc_UltSegmnLinea
          from fpae71 h
         where h.pae51eva = 1
           and h.pae70nro = ln_pae70nro
           and h.pae71ite = 380; --PYME
      exception
        when others then
          null;
      end;
    else
      if ln_SegLinea = 2 then
      
        begin
          select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(h.pae71val,
                                                                '[0-9]',
                                                                '')),
                                                ':',
                                                '')),
                                       '/',
                                       '')),
                              '.',
                              ''))
            into lc_UltSegmnLinea
            from fpae71 h
           where h.pae51eva = 1
             and h.pae70nro = ln_pae70nro
             and h.pae71ite = 443; -- CONSUMO
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
    /* begin
      select tp1nro1, tp1desc
        into P_N_CODCAl, P_C_DESCAL
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10823
         and Tp1corr1 = 2
         and Tp1corr2 = 7
         and tp1nro1 >= 22
         and trim(tp1desc) = TRIM(lc_UltSegmnLinea);
    exception
      when others then
        null;
    end;*/
  
    begin
      select c.jaqy067ccal, c.jaqy067ncal
        into P_N_CODCAl, P_C_DESCAL
        from jaqy067 c
       where trim(c.jaqy067ncal) = TRIM(lc_UltSegmnLinea)
         and c.jaqy067ccal >= 22;
    exception
      when no_data_found then
        If P_N_CODCAl = 0 then
          P_C_DESCAL := 'SIN CALIFICACION';
        Else
          P_C_DESCAL := 'NO DEFINIDA';
        End If;
    end;
  
  end sp_cr_SegmntLinea;

  ---------------------------------------------------------------------------
  procedure sp_cr_ChekTrabajador(ln_cta           in number,
                                 lc_flgtrabajador out varchar2) is
  
    -- lc_flgtrabajador :='N';
  
  begin
    lc_flgtrabajador := 'N';
    begin
      select 'S'
        into lc_flgtrabajador
        from fsd002 d, fsr008 s
       where d.pfebco = 'S'
         and d.pfpais = s.pepais
         and d.pftdoc = s.petdoc
         and d.pfndoc = s.pendoc
         and s.cttfir = 'T'
         and s.ctnro = ln_cta;
    exception
      when others then
        lc_flgtrabajador := 'N';
      
    end;
  
  end sp_cr_ChekTrabajador;
  ---------------------------------------------------------------------
  procedure sp_cr_VerifGradoConsagui(ln_NroCuenta    in number,
                                     lc_FlafFamiliar out varchar2) is
  
    ln_pais   number;
    ln_tipdoc number;
    ln_nrodoc varchar2(12);
  
  begin
    lc_FlafFamiliar := 'N';
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tipdoc, ln_nrodoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_NroCuenta
         and f.cttfir = 'T';
    exception
      when others then
        ln_pais   := 0;
        ln_tipdoc := 0;
        ln_nrodoc := null;
    end;
  
    --- Verificamos el Grados de Consaguinidad 1er y 2do Grado
    begin
      select 'S'
        into lc_FlafFamiliar
        from fsr002 f, FSD002 d
       WHERE f.rppais = ln_pais
         and f.rptdoc = ln_tipdoc
         and f.rpndoc = ln_nrodoc
         and f.rpccyg in (select tp1nro3
                            from fst198
                           where tp1cod = 1
                             and tp1cod1 = 10871
                             and tp1corr1 = 7
                             and tp1corr2 = 151
                             and tp1corr3 > 0)
         and d.pfpais = f.pepais
         and d.pftdoc = f.petdoc
         and d.pfndoc = f.pendoc
         and d.pfebco = 'S';
    exception
      when others then
        lc_FlafFamiliar := 'N';
    end;
  
    if lc_FlafFamiliar = 'N' then
    
      begin
        select 'S'
          into lc_FlafFamiliar
          from fsr002 f, FSD002 d
         WHERE f.pepais = ln_pais
           and f.petdoc = ln_tipdoc
           and f.pendoc = ln_nrodoc
           and f.rpccyg in (select tp1nro3
                              from fst198
                             where tp1cod = 1
                               and tp1cod1 = 10871
                               and tp1corr1 = 7
                               and tp1corr2 = 151
                               and tp1corr3 > 0)
           and d.pfpais = f.rppais
           and d.pftdoc = f.rptdoc
           and d.pfndoc = f.rpndoc
           and d.pfebco = 'S';
      exception
        when others then
          lc_FlafFamiliar := 'N';
      end;
    end if;
  
  end sp_cr_VerifGradoConsagui;

  --------------------------------------------------------------------------

  procedure sp_cr_nroopcionesdes(P_N_CODCAl in number,
                                 ln_opcion  out number,
                                 FlagCl     out varchar2) is
  
  begin
    FlagCl := 'N';
    begin
    
      select Tp1nro3, 'S'
        into ln_opcion, FlagCl
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and Tp1corr2 = 7
         and Tp1nro2 = P_N_CODCAl;
    exception
      when others then
        ln_opcion := 0;
      
    end;
  
  end sp_cr_nroopcionesdes;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_Excepciones(modulo   in number,
                           ln_suc1  in number,
                           ln_mda1  in number,
                           ln_cta1  in number,
                           ln_oper1 in number,
                           ln_sbop1 in number,
                           ittope   in number,
                           FlgIncl  out varchar2) is
  
    --ln_rcta number(9);
  
    ln_modulo    number;
    ln_cta       number;
    ln_oper      number;
    ln_sboper    number;
    ln_sucur     number;
    ln_mda       number;
    ln_tipoer    number;
    ln_instancia number;
    ln_TipSolic  number := 0;
  
  Begin
  
    FlgIncl := 'S';
  
    sp_cr_instancia(ln_Scmod     => modulo,
                    ln_Scsuc     => ln_suc1,
                    ln_Scmda     => ln_mda1,
                    ln_Scpap     => 0,
                    ln_Sccta     => ln_cta1,
                    ln_Scoper    => ln_oper1,
                    ln_Scsbop    => ln_sbop1,
                    ln_Sctope    => ittope,
                    ln_instancia => ln_instancia);
  
    begin
      select s.sng001ori
        into ln_TipSolic
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipSolic in (3, 13, 14, 16) then
      FlgIncl := 'N';
    else
      FlgIncl := 'S';
    end if;
  
    If FlgIncl = 'S' then
      --créditos con garantía de plazo fijo o cts
      if modulo = 116 then
      
        begin
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modulo,
                 ln_cta,
                 ln_oper,
                 ln_sboper,
                 ln_sucur,
                 ln_mda,
                 ln_tipoer
            from fsr011 f
           where f.r1cod = 1
             and f.r1mod = modulo
             and f.r1suc = ln_suc1
             and f.r1mda = ln_mda1
             and f.r1pap = 0
             and f.r1cta = ln_cta1
             and f.r1oper = ln_oper1
             and f.r1sbop = ln_sbop1
             and f.r1tope = ittope
             and f.relcod = 46;
        exception
          when others then
            null;
          
        end;
      
        if ln_modulo > 0 then
        
          begin
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = 1
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucur
               and a.r1mda = ln_mda
               and a.r1pap = 0
               and a.r1cta = ln_cta
               and a.r1oper = ln_oper
               and a.r1sbop = ln_sboper
               and a.r1tope = ln_tipoer
               and b.r2cta = a.r2cta
               and b.r2oper = a.r2oper
               and b.r2sbop = a.r2sbop
               and b.relcod in (2, 25)
               and a.r011co = 'S'
               and b.r011co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              -- ln_rcta := 0;
              FlgIncl := 'S';
            
          end;
        end if;
      
      else
        if modulo <> 116 then
        
          begin
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = 1
               and a.r1mod = modulo
               and a.r1suc = ln_suc1
               and a.r1mda = ln_mda1
               and a.r1pap = 0
               and a.r1cta = ln_cta1
               and a.r1oper = ln_oper1
               and a.r1sbop = ln_sbop1
               and a.r1tope = ittope
               and b.r2cta = a.r2cta
               and b.r2oper = a.r2oper
               and b.r2sbop = a.r2sbop
               and b.relcod in (2, 25)
               and a.r011co = 'S'
               and b.r011co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    end if;
  
  end sp_Excepciones;
  ---------------------------------------------------------------------------------------------
  procedure sp_cr_verificajaql406(ln_pgcod     in number,
                                  ln_modulo    in number,
                                  ln_sucursal  in number,
                                  ln_moneda    in number,
                                  ln_papel     in number,
                                  ln_cuenta    in number,
                                  ln_operacion in number,
                                  ln_subope    in number,
                                  ln_tope      in number,
                                  pd_fecha     in date,
                                  JAQL406tsbor in number,
                                  JAQL406tord  in number,
                                  JAQL406tnrel in number,
                                  JAQL406ttran in number,
                                  JAQL406tmod  in number,
                                  JAQL406tsuc  in number,
                                  flag_exist   out varchar2) is
  
  begin
    begin
      select 'S'
        INTO flag_exist
        from jaql406 j
       where j.JAQL406PGC = ln_pgcod
         and j.JAQL406MOD = ln_modulo
         and j.JAQL406SUC = ln_sucursal
         and j.JAQL406MDA = ln_moneda
         and j.JAQL406PAp = ln_papel
         and j.JAQL406CTA = ln_cuenta
         and j.JAQL406OPE = ln_operacion
         and j.JAQL406SBO = ln_subope
         and j.JAQL406TOP = ln_tope
         and j.JAQL406Fcta = pd_fecha
         and j.jaql406tsbor = JAQL406tsbor
         and j.jaql406tord = JAQL406tord
         and j.jaql406tnrel = JAQL406tnrel
         and j.jaql406ttran = JAQL406ttran
         and j.jaql406tmod = JAQL406tmod
         and j.jaql406tsuc = JAQL406tsuc
         and j.jaql406excup = 'C'
         and rownum = 1;
    
    exception
      when others then
        flag_exist := 'N';
    end;
  
  end sp_cr_verificajaql406;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_inserta(nro_cupon     in number,
                          ln_pgcod      in number,
                          ln_modulo     in number,
                          ln_sucursal   in number,
                          ln_moneda     in number,
                          ln_papel      in number,
                          ln_cuenta     in number,
                          ln_operacion  in number,
                          ln_subope     in number,
                          ln_tope       in number,
                          ln_nrocred    in varchar2,
                          ld_fecha1     in date,
                          pd_fecha      in date,
                          lc_Est        in varchar2,
                          lc_usuario    in varchar2,
                          ln_sucusuario in number,
                          lc_region     in number,
                          lc_Ant        in varchar2,
                          ln_Atr        in varchar2,
                          ln_calific    in number,
                          lc_Tip        in varchar2,
                          lc_EXCUP      in varchar2,
                          JAQL406tsbor  in number,
                          JAQL406tord   in number,
                          JAQL406tnrel  in number,
                          JAQL406ttran  in number,
                          JAQL406tmod   in number,
                          JAQL406tsuc   in number,
                          ld_fecha2     in date,
                          ln_NUMP       in number,
                          ln_CUPNUM     in number,
                          ln_opcion     in number,
                          lc_TipDesem   IN VARCHAR2) is
  begin
  
    begin
      insert into JAQL406
        (JAQL406Cup,
         JAQL406PGC,
         JAQL406Mod,
         JAQL406Suc,
         JAQL406Mda,
         JAQL406PAP,
         JAQL406Cta,
         JAQL406Ope,
         JAQL406Sbo,
         JAQL406Top,
         JAQL406CRE,
         JAQL406FEC,
         JAQL406FOP,
         JAQL406EST,
         JAQL406USR,
         JAQL406AGE,
         JAQL406DPT,
         JAQL406ANT,
         JAQL406ATR,
         JAQL406CAL,
         JAQL406TIP,
         JAQL406EXCUP,
         JAQL406TSBOR,
         JAQL406TORD,
         JAQL406TNREL,
         JAQL406TTRAN,
         JAQL406TMOD,
         JAQL406TSUC,
         JAQL406FCTA,
         JAQL406NUMP,
         JAQL406CUPNUM,
         JAQL406OPC,
         jaql406TipCredPC)
      values
        (nro_cupon,
         ln_pgcod,
         ln_modulo,
         ln_sucursal,
         ln_moneda,
         ln_papel,
         ln_cuenta,
         ln_operacion,
         ln_subope,
         ln_tope,
         ln_nrocred,
         ld_fecha1,
         pd_fecha,
         lc_Est,
         lc_usuario,
         ln_sucusuario,
         lc_region,
         lc_Ant,
         ln_Atr,
         ln_calific,
         lc_Tip,
         lc_EXCUP,
         JAQL406tsbor,
         JAQL406tord,
         JAQL406tnrel,
         JAQL406ttran,
         JAQL406tmod,
         JAQL406tsuc,
         ld_fecha2,
         ln_NUMP,
         ln_CUPNUM,
         ln_opcion,
         lc_TipDesem);
    exception
      when others then
        null;
    End;
    COMMIT;
  
  end sp_cr_inserta;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_Tipo_Doc_SBS(ln_tdoc in number, lc_tndoc in char) return char is
  
    C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      If ln_tdoc = 2 then
        C_TDOCID := '2';
      End If;
    
      If ln_tdoc = 4 then
        C_TDOCID := '3';
      End If;
    
      If ln_tdoc = 15 then
        C_TDOCID := '4';
      End If;
    
      If ln_tdoc = 5 then
        C_TDOCID := '5';
      End If;
    
      If ln_tdoc = 6 then
        C_TDOCID := '8';
      End If;
    End;
    return C_TDOCID;
  end fn_Tipo_Doc_SBS;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_Calif_SBS_Cliente(lc_docsbs in char, lc_tndoc in char)
    return number is
  
    ln_FchSBS DATE;
  
    JAQY774Cal number(10);
    ln_cal0    number(5, 2);
    ln_cal1    number(5, 2);
    ln_cal2    number(5, 2);
    ln_cal3    number(5, 2);
    ln_cal4    number(5, 2);
  
    PNDOC  char(12);
    PNDOC1 varchar2(12);
  
  Begin
    Begin
      Begin
      
        begin
          select to_date(Tpnro, 'DD/MM/YYYY')
            into ln_FchSBS
            from FST098
           Where Pgcod = 1
             and Tpcod = 7647
             and Tpcorr = 12;
        exception
          when others then
            null;
        end;
      
        PNDOC  := rpad(lc_tndoc, 12, ' ');
        PNDOC1 := trim(PNDOC);
      
        begin
          select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
          
            into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
            from CLDRCCI
           where D_FECPRE = ln_FchSBS
             and C_TDOCID = lc_docsbs
             and C_DOCIDE = PNDOC1; --trim(PNDOC); --lc_tndoc;
        exception
          when too_many_rows then
            begin
              select N_CALIF0, N_CALIF1, N_CALIF2, N_CALIF3, N_CALIF4
                into ln_cal0, ln_cal1, ln_cal2, ln_cal3, ln_cal4
                from CLDRCCI
               where D_FECPRE = ln_FchSBS
                 and C_TDOCID = lc_docsbs
                 and C_DOCIDE = PNDOC
                 and C_PERSON = 1
                 and N_CALIF0 <> 0
                 and rownum = 1;
            exception
              when no_data_found then
                ln_cal0 := 0;
                ln_cal1 := 0;
                ln_cal2 := 0;
                ln_cal3 := 0;
                ln_cal4 := 0;
            end;
          when no_data_found then
            ln_cal0 := 0;
            ln_cal1 := 0;
            ln_cal2 := 0;
            ln_cal3 := 0;
            ln_cal4 := 0;
        end;
      end;
    
      If ln_cal0 > 0 and ln_cal1 = 0 and ln_cal2 = 0 and ln_cal3 = 0 and
         ln_cal4 = 0 then
        JAQY774Cal := 1;
      else
        if ln_cal0 = 0 and ln_cal1 = 0 and ln_cal2 = 0 and ln_cal3 = 0 and
           ln_cal4 = 0 then
          JAQY774Cal := 1;
        End If;
      End If;
    
    End;
  
    return JAQY774Cal;
  
  end fn_Calif_SBS_Cliente;
  ----------------------------------------------------------------------------
  procedure sp_cr_buscadesembCons(lc_digito  in varchar2,
                                  pc_uing    IN VARCHAR2,
                                  ld_FecIni  in date,
                                  ld_FecIFin in date) is
  
    Cursor data1 is
      select distinct f.aomod JAQL406Mod,
                      f.aosuc JAQL406Suc,
                      f.aomda JAQL406Mda,
                      f.aocta JAQL406Cta,
                      f.aooper JAQL406Ope,
                      f.aosbop JAQL406Sbo,
                      f.aotope JAQL406Top,
                      g.htran JAQL406TTRAN,
                      g.hcmod JAQL406TMOD,
                      g.hnrel JAQL406TNREL,
                      g.hcord JAQL406TORD,
                      g.hsucor JAQL406TSUC,
                      g.hcsubo JAQL406TSBOR,
                      f.pgcod JAQL406PGC,
                      f.aopap JAQL406PAP,
                      lpad(trim(to_char(f.aocta)), 9, '0') ||
                      lpad(trim(to_char(f.aomda)), 3, '0') ||
                      lpad(trim(to_char(f.aooper)), 9, '0') CREDITO,
                      (select r2.regcod
                         from fst810 r2, fst811 r
                        where r2.pgcod = r.pgcod
                          and r2.regcod = r.regcod
                          and r.pgcod = 1
                          and r.oficod = f.aosuc
                          and r2.regcod < 100) REGION,
                      F.AOFVAL FECH_OPERACION
        from fsd010 f, fsh016 g, fsh015 d
       where f.pgcod = 1
         and (f.aomod, f.aotope) in
             (select tp1nro2, tp1nro3
                from FST198
               Where Tp1cod = 1
                 and Tp1cod1 = 10871
                 and Tp1corr1 = 8
                 and tp1corr3 > 1
                 and tp1imp1 = 2)
         and f.aofval between ld_FecIni and ld_FecIFin
         and f.pgcod = g.pgcod
         and f.aomod = g.hmodul
         and f.aosuc = g.hsucur
         and f.aomda = g.hmda
         and f.aopap = g.hpap
         and f.aocta = g.hcta
         and f.aooper = g.hoper
         and f.aosbop = g.hsubop
         and f.aotope = g.htoper
         and f.aofval = g.hfcon
         and g.pgcod = d.pgcod
         and g.hcmod = d.hcmod
         and g.hsucor = d.hsucor
         and g.htran = d.htran
         and g.hnrel = d.hnrel
         and g.hfcon = d.hfcon
         and d.hccorr <> 99
         and to_char(substr(trim(f.aocta), -1, 1)) = lc_digito;
    --and f.aocta = 2050000;
  
    ln_sbop number(3);
    ln_tope number(3);
    ln_cta  NUMBER(9);
    ln_mod  NUMBER(4);
    ln_mda  NUMBER(3);
    ln_oper NUMBER(9);
    ln_suc  number(3);
  
    ln_ttran   number;
    ln_tmod    number;
    ln_tnrel   number;
    ln_tord    number;
    ln_tsuc    number;
    ln_tsbor   number;
    ln_pgcod   number;
    ln_papel   number;
    ln_nrocred varchar2(21);
    ln_region  number;
  
    P_D_FECHA  date;
    lc_Est     char(1);
    lc_Ant     char(1);
    ln_Atr     NUMBER(10);
    lc_Tip     char(1);
    lc_EXCUP   char(5);
    ld_fecha   date;
    FlgInc     varchar2(1);
    p_c_numdoc varchar2(12);
    ln_tdoc    number(2);
    lc_tndoc   char(12);
    ln_opcion  number(5);
  
    ln_scstat        number(2);
    lc_docsbs        char(1);
    ln_calific       number(10);
    ln_NUMP          NUMBER(9);
    ln_CUPNUM        NUMBER(10);
    P_N_CODCAl       number;
    FlagCl           varchar2(2);
    flag_exist       varchar2(2);
    P_C_DESCAL       varchar2(40);
    i                number := 1;
    Fecha_operacion  date;
    P_N_PAIS         number;
    lc_flgtrabajador varchar2(2) := 'N';
    lc_FlagFamiliar  varchar2(2) := 'N';
    lc_TipDesem      varchar2(2) := 'C';
    ln_Instancia     number;
    lc_VerifPago     varchar2(2) := 'S';
    lc_pagopuntual   varchar2(2) := 'N';
  
  BEGIN
  
    For j in data1 loop
    
      ln_mod          := j.jaql406mod;
      ln_suc          := j.jaql406suc;
      ln_mda          := j.jaql406mda;
      ln_cta          := j.jaql406cta;
      ln_oper         := j.jaql406ope;
      ln_sbop         := j.jaql406sbo;
      ln_tope         := j.jaql406top;
      ln_ttran        := j.JAQL406TTRAN;
      ln_tmod         := j.JAQL406TMOD;
      ln_tnrel        := j.JAQL406TNREL;
      ln_tord         := j.JAQL406TORD;
      ln_tsuc         := j.JAQL406TSUC;
      ln_tsbor        := j.JAQL406TSBOR;
      ln_pgcod        := j.JAQL406PGC;
      ln_papel        := j.JAQL406PAP;
      ln_nrocred      := j.CREDITO;
      ln_region       := j.region;
      Fecha_operacion := j.FECH_OPERACION;
    
      PQ_CR_SORTEO_PYME2020.sp_cr_ChekTrabajador(j.jaql406cta,
                                                 lc_flgtrabajador);
    
      if lc_flgtrabajador = 'N' then
      
        PQ_CR_SORTEO_PYME2020.sp_cr_VerifGradoConsagui(j.jaql406cta,
                                                       lc_FlagFamiliar);
      
        IF lc_FlagFamiliar = 'N' then
        
          begin
            -- Estado del credito 
            select f.aostat
              into ln_scstat
              from fsd010 f
             where f.pgcod = ln_pgcod
               and f.aomod = ln_mod
               and f.aosuc = ln_suc
               and f.aomda = ln_mda
               and f.aopap = ln_papel
               and f.aocta = ln_cta
               and f.aooper = ln_oper
               and f.aosbop = ln_sbop
               and f.aotope = ln_tope
               and f.aofval = Fecha_operacion;
          exception
            when others then
              ln_scstat := 0;
          end;
        
          PQ_CR_SORTEO_PYME2020.sp_Excepciones(ln_mod,
                                               ln_suc,
                                               ln_mda,
                                               ln_cta,
                                               ln_oper,
                                               ln_sbop,
                                               ln_tope,
                                               -- ln_scstat,
                                               FlgInc);
        
          pq_cr_sorteo_pyme2020.sp_cr_verifpagos(ln_406pgc      => ln_pgcod,
                                                 ln_406mod      => ln_mod,
                                                 ln_406suc      => ln_suc,
                                                 ln_406mda      => ln_mda,
                                                 ln_406pap      => ln_papel,
                                                 ln_406cta      => ln_cta,
                                                 ln_406ope      => ln_oper,
                                                 ln_406sbo      => ln_sbop,
                                                 ln_406top      => ln_tope,
                                                 ld_fchcorte    => ld_FecIFin,
                                                 ln_verifpago   => lc_VerifPago,
                                                 ln_PagoPuntual => lc_pagopuntual);
        
          If FlgInc <> 'N' and lc_VerifPago = 'S' then
          
            begin
            
              select PETDOC, PENDOC, PEPAIS
                into ln_tdoc, lc_tndoc, P_N_PAIS
                from fsr008 f
               where PGCOD = 1
                 and CTNRO = ln_cta
                 AND f.cttfir = 'T';
            exception
              when others then
                null;
              
            end;
            p_c_numdoc := trim(lc_tndoc);
          
            begin
              select pgfape - 1 into P_D_FECHA from fst017 where pgcod = 1;
            exception
              when others then
                null;
              
            end;
          
            ln_Instancia := fn_instancia_credito(v_Scmod  => ln_mod,
                                                 v_Scsuc  => ln_suc,
                                                 v_Scmda  => ln_mda,
                                                 v_Scpap  => 0,
                                                 v_Sccta  => ln_cta,
                                                 v_Scoper => ln_oper,
                                                 v_Scsbop => ln_sbop,
                                                 v_Sctope => ln_tope);
          
            PQ_CR_SORTEO_PYME2020.sp_cr_SegmntLinea(ln_Instancia,
                                                    P_N_CODCAl,
                                                    P_C_DESCAL);
          
            PQ_CR_SORTEO_PYME2020.sp_cr_nroopcionesdes(P_N_CODCAl,
                                                       ln_opcion,
                                                       FlagCl);
          
            If ln_opcion <> 0 and FlagCl <> 'N' then
            
              -- lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
            
              Begin
                -- Tipo de DOC para la RCC
                select to_char(a.tp1corr3)
                  into lc_docsbs
                  from fst198 a
                 where a.tp1cod = 1
                   and a.tp1cod1 = 11111
                   and a.tp1corr1 = 1
                   and a.tp1corr2 = 3
                   and a.tp1nro1 = ln_tdoc;
              exception
                when others then
                  lc_docsbs := '0';
              End;
            
              ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
            
              If FlgInc <> 'N' and ln_calific = 1 then
              
                lc_Est   := 'S';
                lc_Ant   := 'N';
                lc_EXCUP := 'C';
                ln_Atr   := 0;
              
                ln_NUMP   := 0;
                ln_CUPNUM := 1;
              
                begin
                  select pgfape into ld_fecha from fst017 where pgcod = 1;
                exception
                  when others then
                    null;
                  
                end;
              
                lc_Tip := 'D';
              
                PQ_CR_SORTEO_PYME2020.sp_cr_verificajaql406(j.jaql406pgc,
                                                            j.JAQL406Mod,
                                                            j.JAQL406Suc,
                                                            j.JAQL406Mda,
                                                            j.JAQL406pap,
                                                            j.JAQL406Cta,
                                                            j.JAQL406Ope,
                                                            j.JAQL406Sbo,
                                                            j.JAQL406Top,
                                                            Fecha_operacion,
                                                            j.JAQL406tsbor,
                                                            j.JAQL406tord,
                                                            j.JAQL406tnrel,
                                                            j.JAQL406ttran,
                                                            j.JAQL406tmod,
                                                            j.JAQL406tsuc,
                                                            flag_exist);
                if flag_exist <> 'S' then
                
                  while i <= ln_opcion loop
                    PQ_CR_SORTEO_PYME2020.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                        j.JAQL406pgc,
                                                        j.JAQL406Mod,
                                                        j.JAQL406Suc,
                                                        j.JAQL406Mda,
                                                        j.JAQL406pap,
                                                        j.JAQL406Cta,
                                                        j.JAQL406Ope,
                                                        j.JAQL406Sbo,
                                                        j.JAQL406Top,
                                                        ln_nrocred,
                                                        ld_fecha,
                                                        Fecha_operacion,
                                                        lc_Est,
                                                        UPPER(pc_uing),
                                                        j.JAQL406Suc,
                                                        j.region,
                                                        lc_Ant,
                                                        ln_Atr,
                                                        ln_calific,
                                                        lc_Tip,
                                                        lc_EXCUP,
                                                        j.JAQL406tsbor,
                                                        j.JAQL406tord,
                                                        j.JAQL406tnrel,
                                                        j.JAQL406ttran,
                                                        j.JAQL406tmod,
                                                        j.JAQL406tsuc,
                                                        Fecha_operacion,
                                                        ln_NUMP,
                                                        ln_CUPNUM,
                                                        ln_opcion,
                                                        lc_TipDesem);
                    i := i + 1;
                  
                  end loop;
                
                  i := 1;
                
                End IF;
              
              End If;
            End If;
          End If;
        End If;
      End If;
    End loop;
  
  end sp_cr_buscadesembCons;
  ---------------------------------------------------------------------
  procedure sp_cr_verifpagos(ln_406pgc      in number,
                             ln_406mod      in number,
                             ln_406suc      in number,
                             ln_406mda      in number,
                             ln_406pap      in number,
                             ln_406cta      in number,
                             ln_406ope      in number,
                             ln_406sbo      in number,
                             ln_406top      in number,
                             ld_fchcorte    in date,
                             ln_verifpago   out varchar2,
                             ln_PagoPuntual out varchar2) is
  
    ln_f601   number := 0;
    ln_f602   number := 0;
    ln_f602AD number := 0;
  
  begin
  
    ln_verifpago   := 'S';
    ln_PagoPuntual := 'N';
  
    begin
      select count(*)
        into ln_f601
        from fsd601 f
       where f.pgcod = ln_406pgc
         and f.ppmod = ln_406mod
         and f.ppsuc = ln_406suc
         and f.ppmda = ln_406mda
         and f.pppap = ln_406pap
         and f.ppcta = ln_406cta
         and f.ppoper = ln_406ope
         and f.ppsbop = ln_406sbo
         and f.pptope = ln_406top
         and f.ppfpag <= ld_fchcorte
         and (f.ppcap + f.ppint) > 0
         and f.d601co = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_f602
        from fsd602 f
       where f.pgcod = ln_406pgc
         and f.ppmod = ln_406mod
         and f.ppsuc = ln_406suc
         and f.ppmda = ln_406mda
         and f.pppap = ln_406pap
         and f.ppcta = ln_406cta
         and f.ppoper = ln_406ope
         and f.ppsbop = ln_406sbo
         and f.pptope = ln_406top
         and f.ppfpag <= ld_fchcorte
         and f.pp1stat = 'T'
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_f602AD
        from fsd602 f
       where f.pgcod = ln_406pgc
         and f.ppmod = ln_406mod
         and f.ppsuc = ln_406suc
         and f.ppmda = ln_406mda
         and f.pppap = ln_406pap
         and f.ppcta = ln_406cta
         and f.ppoper = ln_406ope
         and f.ppsbop = ln_406sbo
         and f.pptope = ln_406top
         and f.ppfpag <= ld_fchcorte
         and (f.d602fc - f.ppfpag) <= 0
         and f.pp1stat = 'T'
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_f601 <> ln_f602 then
      ln_verifpago   := 'N';
      ln_PagoPuntual := 'N';
    else
      if ln_f601 = ln_f602 then
        ln_verifpago := 'S';
        if ln_f602AD = ln_f602 then
          ln_PagoPuntual := 'S';
        else
          ln_PagoPuntual := 'N';
        end if;
      end if;
    end if;
  
  end;
  ---------------------------------------------------------------------
  Procedure sp_cr_cargaCuoIm_job(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date) is
  
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
                     ' PQ_CR_SORTEO_PYME2020.sp_cr_buscaPagos(''' || x || '''' || ',' || '''' ||
                     pc_uing || '''' || ',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
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
  
  end sp_cr_cargaCuoIm_job;
  -------------------------------------------------------------------------------------------
  Procedure sp_cr_Job_Desembolso(pc_uing     in varchar2,
                                 pd_fechaIni in date,
                                 pd_fechaFin in date) is
  
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
                     'PQ_CR_SORTEO_PYME2020.sp_cr_buscadesembolso(''' || x || '''' || ',' || '''' ||
                     pc_uing || '''' || ',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
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
  
  end sp_cr_Job_Desembolso;
  ----------------------------------------------------------------------
  Procedure sp_cr_Job_DesemCons(pc_uing     in varchar2,
                                pd_fechaIni in date,
                                pd_fechaFin in date) is
  
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
                     'PQ_CR_SORTEO_PYME2020.sp_cr_buscadesembcons(''' || x || '''' || ',' || '''' ||
                     pc_uing || '''' || ',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
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
  
  end sp_cr_Job_DesemCons;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_ValidaAdicional(ld_FecFin in date) is
  
    cursor creditos is
      select distinct j.jaql406pgc,
                      j.jaql406mod,
                      j.jaql406suc,
                      j.jaql406mda,
                      j.jaql406pap,
                      j.jaql406cta,
                      j.jaql406ope,
                      j.jaql406sbo,
                      j.jaql406top,
                      j.jaql406fop,
                      j.jaql406tord,
                      j.jaql406tnrel,
                      j.jaql406ttran,
                      j.jaql406tmod,
                      j.jaql406tsuc,
                      j.jaql406cre,
                      j.jaql406fec,
                      J.JAQL406DPT,
                      j.JAQL406tsbor,
                      J.JAQL406TIPCREDPC
        from jaql406 j
       where j.jaql406fec = (select max(l.jaql406fec) from jaql406 l);
  
    ln_TieneSeg   number := 0;
    ld_MaxFchPago date;
    ln_DiasPago   number;
    CuponAdic     number := 0;
    ln_pgTx       number;
    /*ln_modtx          number;
    ln_suctx          number;
    ln_tx             number;
    ln_reltx          number;
    ld_fctx           date;*/
    ln_DesemCtaAhorro number;
    ln_pgAh           number;
    /* ln_SucAh          number;
    ln_mdaAh          number;
    ln_papAh          number;
    ln_ctaAh          number;
    ln_opeAh          number;
    ln_subAh          number;
    ln_topeAh         number;*/
    ln_AhoAct number;
    i         number;
  
  begin
  
    for c in creditos loop
      ln_TieneSeg       := 0;
      ld_MaxFchPago     := null;
      ln_DiasPago       := 0;
      CuponAdic         := 0;
      ln_pgTx           := 0;
      ln_DesemCtaAhorro := 0;
      ln_pgAh           := 0;
      ln_AhoAct         := 0;
      i                 := 1;
    
      -- Valida Pagos  
      /*
            begin
              select max(f.ppfpag)
                into ld_MaxFchPago
                from fsd601 f
               where f.pgcod = c.jaql406pgc
                 and f.ppmod = c.jaql406suc
                 and f.ppsuc = c.jaql406suc
                 and f.ppmda = c.jaql406mda
                 and f.pppap = c.jaql406pap
                 and f.ppcta = c.jaql406cta
                 and f.ppoper = c.jaql406ope
                 and f.ppsbop = c.jaql406sbo
                 and f.pptope = c.jaql406top
                 and f.ppfpag <= ld_FecFin;
            exception
              when others then
                null;
            end;
          
            if ld_MaxFchPago is not null then
            
              begin
                select g.pp1fech - g.ppfpag
                  into ln_DiasPago
                  from fsd602 g
                 where g.pgcod = c.jaql406pgc
                   and g.ppmod = c.jaql406mod
                   and g.ppsuc = c.jaql406suc
                   and g.ppmda = c.jaql406mda
                   and g.pppap = c.jaql406pap
                   and g.ppcta = c.jaql406cta
                   and g.ppoper = c.jaql406ope
                   and g.ppsbop = c.jaql406sbo
                   and g.pptope = c.jaql406top
                   and g.ppfpag = ld_MaxFchPago
                   and g.pp1stat = 'T'
                   and g.d602co = 'S';
              exception
                when others then
                  ln_DiasPago := 0;
              end;
              if ln_DiasPago <= 0 then
                CuponAdic := CuponAdic + 1;
              else
                if ln_DiasPago < 0 then
                  CuponAdic := CuponAdic + 3;
                end if;
              end if;
      
      end if;*/
    
      begin
        -- Seguros
        begin
          select count(*)
            into ln_TieneSeg
            from fpp001 f
           where f.pgcod = c.jaql406pgc
             and f.aomod = c.jaql406mod
             and f.aosuc = c.jaql406suc
             and f.aomda = c.jaql406mda
             and f.aopap = c.jaql406pap
             and f.aocta = c.jaql406cta
             and f.aooper = c.jaql406ope
             and f.aosbop = c.jaql406sbo
             and f.aotope = c.jaql406top
             and f.sgcod not in
                 (select g.sgcod from fst300 g where g.sgtxt like '%esgrav%');
        exception
          when others then
            null;
        end;
      
        if ln_TieneSeg > 0 then
          CuponAdic := CuponAdic + 1;
        end if;
      
      end;
    
      -- Tx de Desembolso Digital
      /*
      begin
        begin
          select f.pgcod, f.hcmod, f.hsucor, f.htran, f.hnrel, f.hfcon
            into ln_pgTx, ln_modtx, ln_suctx, ln_tx, ln_reltx, ld_fctx
            from fsh016 f
           where f.pgcod = c.jaql406pgc
             and f.hmodul = c.jaql406mod
             and f.hsucur = c.jaql406suc
             and f.hmda = c.jaql406mda
             and f.hpap = c.jaql406pap
             and f.hcta = c.jaql406cta
             and f.hoper = c.jaql406ope
             and f.hsubop = c.jaql406sbo
             and f.htoper = c.jaql406top
             and f.hfcon = c.jaql406fop;
        exception
          when others then
            null;
        end;
      
        if ln_modtx = 489 and ln_tx = 951 then
          CuponAdic := CuponAdic + 1;
        end if;
      
        begin
          -- Desembolso a Cuenta de Ahorros
          select count(*)
            into ln_DesemCtaAhorro
            from fsh016 f
           where f.pgcod = ln_pgTx
             and f.hcmod = ln_modtx
             and f.hsucor = ln_suctx
             and f.htran = ln_tx
             and f.hnrel = ln_reltx
             and f.hfcon = ld_fctx
             and f.hcord = 81;
        end;
      
        if ln_DesemCtaAhorro > 0 then
        
          begin
            select f.pgcod,
                   f.hsucur,
                   f.hmda,
                   f.hpap,
                   f.hcta,
                   f.hoper,
                   f.hsubop,
                   f.htoper
              into ln_pgAh,
                   ln_SucAh,
                   ln_mdaAh,
                   ln_papAh,
                   ln_ctaAh,
                   ln_opeAh,
                   ln_subAh,
                   ln_topeAh
              from fsh016 f
             where f.pgcod = ln_pgTx
               and f.hcmod = ln_modtx
               and f.hsucor = ln_suctx
               and f.htran = ln_tx
               and f.hnrel = ln_reltx
               and f.hfcon = ld_fctx
               and f.hcord = 81;
          exception
            when others then
              null;
          end;
        
          begin
            select count(*)
              into ln_AhoAct
              from fsd011 f
             where f.pgcod = ln_pgAh
               and f.scsuc = ln_SucAh
               and f.scmda = ln_mdaAh
               and f.scpap = ln_papAh
               and f.sccta = ln_ctaAh
               and f.scoper = ln_opeAh
               and f.scsbop = ln_subAh
               and f.sctope = ln_topeAh
               and f.scstat = 0;
          end;
        
          if ln_AhoAct > 0 then
            CuponAdic := CuponAdic + 1;
          end if;
        end if;
      
      end;*/
    
      if CuponAdic > 0 then
        while i <= CuponAdic loop
          PQ_CR_SORTEO_PYME2020.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                              c.JAQL406pgc,
                                              c.JAQL406Mod,
                                              c.JAQL406Suc,
                                              c.JAQL406Mda,
                                              c.JAQL406pap,
                                              c.JAQL406Cta,
                                              c.JAQL406Ope,
                                              c.JAQL406Sbo,
                                              c.JAQL406Top,
                                              c.jaql406cre,
                                              c.jaql406fec,
                                              c.jaql406fop,
                                              'S',
                                              'ADICIONAL',
                                              C.JAQL406Suc,
                                              c.jaql406dpt,
                                              'N',
                                              0,
                                              1,
                                              'D',
                                              'C',
                                              c.JAQL406tsbor,
                                              c.JAQL406tord,
                                              c.JAQL406tnrel,
                                              c.JAQL406ttran,
                                              c.JAQL406tmod,
                                              c.JAQL406tsuc,
                                              c.jaql406fop,
                                              1,
                                              1,
                                              CuponAdic,
                                              c.jaql406tipcredpc);
          i := i + 1;
        
        end loop;
      
      end if;
    
    end loop;
  end sp_cr_ValidaAdicional;
  ----------------------------------------------------------------------------
  procedure sp_cr_DesembConsGratif(lc_digito  in varchar2,
                                   pc_uing    IN VARCHAR2,
                                   ld_FecIni  in date,
                                   ld_FecIFin in date) is
  
    Cursor data1 is
      select distinct f.aomod JAQL406Mod,
                      f.aosuc JAQL406Suc,
                      f.aomda JAQL406Mda,
                      f.aocta JAQL406Cta,
                      f.aooper JAQL406Ope,
                      f.aosbop JAQL406Sbo,
                      f.aotope JAQL406Top,
                      f.pgcod JAQL406PGC,
                      f.aopap JAQL406PAP,
                      lpad(trim(to_char(f.aocta)), 9, '0') ||
                      lpad(trim(to_char(f.aomda)), 3, '0') ||
                      lpad(trim(to_char(f.aooper)), 9, '0') CREDITO,
                      F.AOFVAL FECH_OPERACION
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod, f.aotope) in
             (select g.tp1nro2, g.tp1nro3
                from fst198 g
               where g.tp1cod = 1
                 and g.tp1cod1 = 10899
                 and g.tp1corr1 = 126
                 and g.tp1corr3 > 0)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aofval between ld_FecIni and ld_FecIFin
         and to_char(substr(trim(f.aocta), -1, 1)) = lc_digito
         and f.aostat = 0;
  
    ln_sbop          number(3);
    ln_tope          number(3);
    ln_cta           NUMBER(9);
    ln_mod           NUMBER(4);
    ln_mda           NUMBER(3);
    ln_oper          NUMBER(9);
    ln_suc           number(3);
    ln_ttran         number;
    ln_tmod          number;
    ln_tnrel         number;
    ln_tsuc          number;
    ln_pgcod         number;
    ln_papel         number;
    ln_nrocred       varchar2(21);
    ln_region        number;
    lc_Est           char(1);
    lc_Ant           char(1);
    ln_Atr           NUMBER(10);
    lc_Tip           char(1);
    lc_EXCUP         char(5);
    ld_fecha         date;
    p_c_numdoc       varchar2(12);
    ln_tdoc          number(2);
    lc_tndoc         char(12);
    ln_opcion        number(5);
    ln_calific       number(10);
    ln_NUMP          NUMBER(9);
    ln_CUPNUM        NUMBER(10);
    flag_exist       varchar2(2);
    i                number := 1;
    Fecha_operacion  date;
    P_N_PAIS         number;
    lc_flgtrabajador varchar2(2) := 'N';
    lc_TipDesem      varchar2(2) := 'C';
    ln_Instancia     number;
  
  BEGIN
  
    For j in data1 loop
    
      begin
        ln_Instancia := fn_instancia_credito(v_Scmod  => j.jaql406mod,
                                             v_Scsuc  => j.jaql406suc,
                                             v_Scmda  => j.jaql406mda,
                                             v_Scpap  => 0,
                                             v_Sccta  => j.jaql406cta,
                                             v_Scoper => j.jaql406ope,
                                             v_Scsbop => j.jaql406sbo,
                                             v_Sctope => j.jaql406top);
      exception
        when others then
          null;
      end;
    
      begin
        select x.xwftmod, x.xwftsuc, x.xwfttran, x.xwfnrel
          into ln_tmod, ln_tsuc, ln_ttran, ln_tnrel
          from xwf070 x
         where x.xwfprcin = ln_instancia
           and x.xwfcont = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select r.regcod
          into ln_region
          from regsuc r
         where r.sucurs = j.jaql406suc;
      exception
        when others then
          null;
      end;
    
      ln_mod          := j.jaql406mod;
      ln_suc          := j.jaql406suc;
      ln_mda          := j.jaql406mda;
      ln_cta          := j.jaql406cta;
      ln_oper         := j.jaql406ope;
      ln_sbop         := j.jaql406sbo;
      ln_tope         := j.jaql406top;
      ln_pgcod        := j.JAQL406PGC;
      ln_papel        := j.JAQL406PAP;
      ln_nrocred      := j.CREDITO;
      Fecha_operacion := j.FECH_OPERACION;
    
      PQ_CR_SORTEO_PYME2020.sp_cr_ChekTrabajador(j.jaql406cta,
                                                 lc_flgtrabajador);
    
      if lc_flgtrabajador = 'N' then
      
        /*PQ_CR_SORTEO_PYME2020.sp_cr_VerifGradoConsagui(j.jaql406cta,
        lc_FlagFamiliar);*/
      
        -- IF lc_FlagFamiliar = 'N' then
      
        /*     begin
          -- Estado del credito 
          select f.aostat
            into ln_scstat
            from fsd010 f
           where f.pgcod = ln_pgcod
             and f.aomod = ln_mod
             and f.aosuc = ln_suc
             and f.aomda = ln_mda
             and f.aopap = ln_papel
             and f.aocta = ln_cta
             and f.aooper = ln_oper
             and f.aosbop = ln_sbop
             and f.aotope = ln_tope
             and f.aofval = Fecha_operacion;
        exception
          when others then
            ln_scstat := 0;
        end;*/
      
        /*  PQ_CR_SORTEO_PYME2020.sp_Excepciones(ln_mod,
        ln_suc,
        ln_mda,
        ln_cta,
        ln_oper,
        ln_sbop,
        ln_tope,
        ln_scstat,
        FlgInc);*/
      
        /*  pq_cr_sorteo_pyme2020.sp_cr_verifpagos(ln_406pgc      => ln_pgcod,
        ln_406mod      => ln_mod,
        ln_406suc      => ln_suc,
        ln_406mda      => ln_mda,
        ln_406pap      => ln_papel,
        ln_406cta      => ln_cta,
        ln_406ope      => ln_oper,
        ln_406sbo      => ln_sbop,
        ln_406top      => ln_tope,
        ld_fchcorte    => ld_FecIFin,
        ln_verifpago   => lc_VerifPago,
        ln_PagoPuntual => lc_pagopuntual);*/
      
        -- If FlgInc <> 'N' and lc_VerifPago = 'S' then
      
        begin
        
          select PETDOC, PENDOC, PEPAIS
            into ln_tdoc, lc_tndoc, P_N_PAIS
            from fsr008 f
           where PGCOD = 1
             and CTNRO = ln_cta
             AND f.cttfir = 'T';
        exception
          when others then
            null;
          
        end;
        p_c_numdoc := trim(lc_tndoc);
      
        /*  begin
          select pgfape - 1 into P_D_FECHA from fst017 where pgcod = 1;
        exception
          when others then
            null;
          
        end;*/
      
        /*  PQ_CR_SORTEO_PYME2020.sp_cr_SegmntLinea(ln_Instancia,
                                                P_N_CODCAl,
                                                P_C_DESCAL);
        
        PQ_CR_SORTEO_PYME2020.sp_cr_nroopcionesdes(P_N_CODCAl,
                                                   ln_opcion,
                                                   FlagCl);*/
      
        ln_opcion := 1;
      
        -- If ln_opcion <> 0 and FlagCl <> 'N' then
      
        -- lc_docsbs  := fn_Tipo_Doc_SBS(ln_tdoc, lc_tndoc);
      
        /* Begin
          -- Tipo de DOC para la RCC
          select to_char(a.tp1corr3)
            into lc_docsbs
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and a.tp1nro1 = ln_tdoc;
        exception
          when others then
            lc_docsbs := '0';
        End;*/
      
        -- ln_calific := fn_Calif_SBS_Cliente(lc_docsbs, lc_tndoc);
      
        --   If FlgInc <> 'N' and ln_calific = 1 then
      
        lc_Est    := 'S';
        lc_Ant    := 'N';
        lc_EXCUP  := 'C';
        ln_Atr    := 0;
        ln_NUMP   := 0;
        ln_CUPNUM := 1;
      
        begin
          select pgfape into ld_fecha from fst017 where pgcod = 1;
        exception
          when others then
            null;
          
        end;
      
        lc_Tip := 'D';
      
        PQ_CR_SORTEO_PYME2020.sp_cr_verificajaql406(j.jaql406pgc,
                                                    j.JAQL406Mod,
                                                    j.JAQL406Suc,
                                                    j.JAQL406Mda,
                                                    j.JAQL406pap,
                                                    j.JAQL406Cta,
                                                    j.JAQL406Ope,
                                                    j.JAQL406Sbo,
                                                    j.JAQL406Top,
                                                    Fecha_operacion,
                                                    1,
                                                    10,
                                                    ln_tnrel,
                                                    ln_ttran,
                                                    ln_tmod,
                                                    ln_tsuc,
                                                    flag_exist);
        if flag_exist <> 'S' then
        
          while i <= ln_opcion loop
            PQ_CR_SORTEO_PYME2020.sp_cr_inserta(SQ_CR_JAQL406_2.NEXTVAL,
                                                j.JAQL406pgc,
                                                j.JAQL406Mod,
                                                j.JAQL406Suc,
                                                j.JAQL406Mda,
                                                j.JAQL406pap,
                                                j.JAQL406Cta,
                                                j.JAQL406Ope,
                                                j.JAQL406Sbo,
                                                j.JAQL406Top,
                                                ln_nrocred,
                                                ld_fecha,
                                                Fecha_operacion,
                                                lc_Est,
                                                UPPER(pc_uing),
                                                j.JAQL406Suc,
                                                ln_region,
                                                lc_Ant,
                                                ln_Atr,
                                                ln_calific,
                                                lc_Tip,
                                                lc_EXCUP,
                                                1,
                                                10,
                                                ln_tnrel,
                                                ln_ttran,
                                                ln_tmod,
                                                ln_tsuc,
                                                Fecha_operacion,
                                                ln_NUMP,
                                                ln_CUPNUM,
                                                ln_opcion,
                                                lc_TipDesem);
            i := i + 1;
          
          end loop;
        
          i := 1;
        
        End IF;
      
      End If;
    End loop;
  
  end sp_cr_DesembConsGratif;
  ---------------------------------------------------------------------------
  Procedure sp_cr_Job_DesemConsGratf(pc_uing     in varchar2,
                                     pd_fechaIni in date,
                                     pd_fechaFin in date) is
  
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
                     'PQ_CR_SORTEO_PYME2020.sp_cr_DesembConsGratif(''' || x || '''' || ',' || '''' ||
                     pc_uing || '''' || ',' || '''' || pd_fechaIni || '''' || ',' || '''' ||
                     pd_fechaFin || ''');' || ' End; ';
    
      ln_job := ln_job + 1;
    
      --if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
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
  
  end sp_cr_Job_DesemConsGratf;
  --------------------------------------------------------------------------------
  procedure sp_cr_Nav24Pagos(lc_digito in varchar2) is
  
    cursor creditos(ld_FchIniD date, ld_FchFinD date) is
      select f.*,
             lpad(trim(to_char(f.aocta)), 9, '0') ||
             lpad(trim(to_char(f.aomda)), 3, '0') ||
             lpad(trim(to_char(f.aooper)), 9, '0') ln_NroCred
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aofval between ld_FchIniD and ld_FchFinD
         and f.aostat = 0
            -- and f.aocta = 4401934;
         and to_char(substr(trim(f.aocta), -1, 1)) = lc_digito;
  
    cursor pagos(ln_pgcod     number,
                 ln_mod       number,
                 ln_suc       number,
                 ln_mda       number,
                 ln_pap       number,
                 ln_cta       number,
                 ln_ope       number,
                 ln_sbop      number,
                 ln_tope      number,
                 ld_FchIniPag date,
                 ld_FchFinPag date) is
      select f.pp1fech - f.ppfpag DiasPago, f.*
        from fsd602 f
       where f.pgcod = ln_pgcod
         and f.ppmod = ln_mod
         and f.ppsuc = ln_suc
         and f.ppmda = ln_mda
         and f.pppap = ln_pap
         and f.ppcta = ln_cta
         and f.ppoper = ln_ope
         and f.ppsbop = ln_sbop
         and f.pptope = ln_tope
         and f.ppfpag between ld_FchIniPag and ld_FchFinPag
         and f.pp1fech - f.ppfpag <= 0
         and f.pp1stat = 'T'
         and f.d602co = 'S'
         and f.pp1cap > 0;
  
    ld_FchIniDes    date;
    ld_FchFinDes    date;
    ld_FchIniPag    date;
    ld_FchFinPag    date;
    lc_EsTrabajador varchar2(5) := 'N';
    lc_EsFamiliar   varchar2(5) := 'N';
    lc_Exceptuar    varchar2(5) := 'N';
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_tdocRCC      number;
    ln_Calificacion number;
    ln_OpcPDia      number;
    ln_OpcPAntes    number;
    ln_Opciones     number := 0;
    i               number := 1;
    lc_NombreCli    varchar2(200);
    ln_Instancia    number;
    lc_Analista     varchar2(10);
    ln_region       number;
    ln_zona         number;
    lc_dpto         varchar2(100);
    lc_TipoCred     varchar2(50);
    lc_DirecLgl     varchar2(200);
    ln_EstaInsrt    number := 0;
    ln_pgcodtx      number;
    ln_modtx        number;
    ln_suctx        number;
    ln_tx           number;
    ln_nreltx       number;
    ld_fchtx        date;
  
  begin
  
    begin
      select to_date(f.tp1nro3, 'YYYY/MM/DD'),
             to_Date(f.tp1imp1, 'YYYY/MM/DD')
        into ld_FchIniDes, ld_FchFinDes
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 139
         and f.tp1corr2 = 1
         and f.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_date(f.tp1nro3, 'YYYY/MM/DD'),
             to_Date(f.tp1imp1, 'YYYY/MM/DD')
        into ld_FchIniPag, ld_FchFinPag
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 139
         and f.tp1corr2 = 1
         and f.tp1corr3 = 2;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tp1nro3
        into ln_OpcPAntes
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 139
         and f.tp1corr2 = 1
         and f.tp1corr3 = 3;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tp1nro3
        into ln_OpcPDia
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 139
         and f.tp1corr2 = 1
         and f.tp1corr3 = 4;
    exception
      when others then
        null;
    end;
  
    for c in creditos(ld_FchIniDes, ld_FchFinDes) loop
    
      ln_Opciones  := 0;
      ln_pais      := null;
      ln_tdoc      := null;
      lc_ndoc      := null;
      lc_NombreCli := null;
      ln_Instancia := null;
      lc_Analista  := null;
      lc_TipoCred  := null;
      ln_EstaInsrt := 0;
    
      begin
        select f.pepais, f.petdoc, f.pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008 f
         where f.pgcod = 1
           and f.ctnro = c.aocta
           and f.cttfir = 'T';
      exception
        when others then
          null;
      end;
    
      begin
        select tp1nro2
          into ln_tdocRCC
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11111
           and tp1corr1 = 1
           and tp1corr2 = 5
           and tp1nro1 = ln_tdoc;
      exception
        when others then
          null;
      end;
    
      Pq_Cr_Sorteo_Pyme2020.sp_cr_ChekTrabajador(ln_cta           => c.aocta,
                                                 lc_flgtrabajador => lc_EsTrabajador);
    
      PQ_CR_SORTEO_PYME2020.sp_cr_VerifGradoConsagui(ln_NroCuenta    => c.aocta,
                                                     lc_FlafFamiliar => lc_EsFamiliar);
    
      Pq_Cr_Sorteo_Pyme2020.sp_Excepciones(modulo   => c.aomod,
                                           ln_suc1  => c.aosuc,
                                           ln_mda1  => c.aomda,
                                           ln_cta1  => c.aocta,
                                           ln_oper1 => c.aooper,
                                           ln_sbop1 => c.aosbop,
                                           ittope   => c.aotope,
                                           FlgIncl  => lc_Exceptuar);
    
      ln_Calificacion := Pq_Cr_Sorteo_Pyme2020.fn_Calif_SBS_Cliente(lc_docsbs => ln_tdocRCC,
                                                                    lc_tndoc  => lc_ndoc);
    
      if lc_EsTrabajador = 'N' and lc_EsFamiliar = 'N' and
         lc_Exceptuar = 'S' and ln_Calificacion = 1 then
      
        for p in pagos(c.pgcod, c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope, ld_FchIniPag, ld_FchFinPag) loop
        
          if p.diaspago < 0 then
            ln_Opciones := ln_OpcPAntes;
          else
            if p.diaspago = 0 then
              ln_Opciones := ln_OpcPDia;
            end if;
          end if;
        
          begin
            select replace(f.penom, '-', '')
              into lc_NombreCli
              from fsd001 f
             where f.pepais = ln_pais
               and f.petdoc = ln_tdoc
               and f.pendoc = lc_ndoc;
          exception
            when others then
              null;
          end;
        
          begin
            select r.regcod, r.codzon, r.dpto
              into ln_region, ln_zona, lc_dpto
              from regsuc r
             where r.sucurs = c.aosuc;
          exception
            when others then
              null;
          end;
        
          begin
            sp_cr_instancia(ln_Scmod     => c.aomod,
                            ln_Scsuc     => c.aosuc,
                            ln_Scmda     => c.aomda,
                            ln_Scpap     => c.aopap,
                            ln_Sccta     => c.aocta,
                            ln_Scoper    => c.aooper,
                            ln_Scsbop    => c.aosbop,
                            ln_Sctope    => c.aotope,
                            ln_instancia => ln_Instancia);
          end;
        
          begin
            select s.sngc13dir
              into lc_DirecLgl
              from sngc13 s
             where s.sngc13pais = ln_pais
               and s.sngc13tdoc = ln_tdoc
               and s.sngc13ndoc = lc_ndoc
               and s.docod = 1
               and s.sngc13est = 'H';
          exception
            when others then
              null;
          end;
        
          if ln_Instancia > 0 then
          
            begin
              select s.sng001ase
                into lc_Analista
                from sng001 s
               where s.sng001inst = ln_Instancia;
            exception
              when others then
                null;
            end;
          
            begin
              select w.wfattsval
                into lc_TipoCred
                from wfattsvalues w
               where w.wfinsprcid = ln_Instancia
                 and w.wfattsid = 'TIPO_CREDITO';
            exception
              when others then
                null;
            end;
          end if;
        
          begin
            select count(*)
              into ln_EstaInsrt
              from aqpb184 a
             where a.aqpb184pgcod = c.pgcod
               and a.aqpb184mod = c.aomod
               and a.aqpb184suc = c.aosuc
               and a.aqpb184mda = c.aomda
               and a.aqpb184pap = c.aopap
               and a.aqpb184cta = c.aocta
               and a.aqpb184ope = c.aooper
               and a.aqpb184sbo = c.aosbop
               and a.aqpb184top = c.aotope
               and a.aqpb184fcalnd = p.ppfpag
               and a.aqpb184fpago = p.pp1fech;
          exception
            when others then
              null;
          end;
        
          if ln_EstaInsrt = 0 then
          
            begin
              select x.xwfpgcod,
                     x.xwftmod,
                     x.xwftsuc,
                     x.xwfttran,
                     x.xwfnrel,
                     x.xwffcon
                into ln_pgcodtx,
                     ln_modtx,
                     ln_suctx,
                     ln_tx,
                     ln_nreltx,
                     ld_fchtx
                from xwf070 x
               where x.xwfprcin = ln_Instancia
                 and x.xwfcont = 'S';
            exception
              when others then
                null;
            end;
          
            while i <= ln_Opciones loop
            
              Pq_Cr_Sorteo_Pyme2020.sp_cr_LogAQPB184(ln_pais   => ln_pais,
                                                     ln_tdoc   => ln_tdoc,
                                                     lc_ndoc   => trim(lc_ndoc),
                                                     lc_nomb   => trim(lc_NombreCli),
                                                     lc_ncred  => c.ln_NroCred,
                                                     ln_pgcod  => c.pgcod,
                                                     ln_mod    => c.aomod,
                                                     ln_suc    => c.aosuc,
                                                     ln_mda    => c.aomda,
                                                     ln_pap    => c.aopap,
                                                     ln_cta    => c.aocta,
                                                     ln_ope    => c.aooper,
                                                     ln_sbo    => c.aosbop,
                                                     ln_top    => c.aotope,
                                                     ln_ins    => ln_Instancia,
                                                     lc_asesr  => trim(lc_Analista),
                                                     ld_fdes   => c.aofval,
                                                     ld_fcalnd => p.ppfpag,
                                                     ld_fpago  => p.pp1fech,
                                                     ln_opcns  => ln_Opciones,
                                                     ln_zona   => ln_zona,
                                                     ln_reg    => ln_region,
                                                     lc_dpto   => lc_dpto,
                                                     lc_tcred  => trim(lc_TipoCred),
                                                     lc_dir    => trim(lc_DirecLgl),
                                                     ln_pgtx   => ln_pgcodtx,
                                                     ln_suctx  => ln_suctx,
                                                     ln_modtx  => ln_modtx,
                                                     ln_tx     => ln_tx,
                                                     ln_reltx  => ln_nreltx,
                                                     ln_ordtx  => 10,
                                                     ln_fchtx  => ld_fchtx);
              i := i + 1;
            end loop;
            i := 1;
          end if;
        end loop;
      end if;
    end loop;
  
  end sp_cr_Nav24Pagos;
  -----------------------------------------------------------------------------------
  procedure sp_cr_LogAQPB184(ln_pais   in number,
                             ln_tdoc   in number,
                             lc_ndoc   in varchar2,
                             lc_nomb   in varchar2,
                             lc_ncred  in varchar2,
                             ln_pgcod  in number,
                             ln_mod    in number,
                             ln_suc    in number,
                             ln_mda    in number,
                             ln_pap    in number,
                             ln_cta    in number,
                             ln_ope    in number,
                             ln_sbo    in number,
                             ln_top    in number,
                             ln_ins    in number,
                             lc_asesr  in varchar2,
                             ld_fdes   in date,
                             ld_fcalnd in date,
                             ld_fpago  in date,
                             ln_opcns  in number,
                             ln_zona   in number,
                             ln_reg    in number,
                             lc_dpto   in varchar2,
                             lc_tcred  in varchar2,
                             lc_dir    in varchar2,
                             ln_pgtx   in number,
                             ln_suctx  in number,
                             ln_modtx  in number,
                             ln_tx     in number,
                             ln_reltx  in number,
                             ln_ordtx  in number,
                             ln_fchtx  in date) is
  
    ln_cor     number := 0;
    lc_hora    varchar2(10) := '00:00:00';
    ld_FchSist date;
  
  begin
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb184cor)
        into ln_cor
        from aqpb184 a
       where a.aqpb184fchcar = ld_FchSist;
    exception
      when others then
        null;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb184
        (aqpb184cor,
         aqpb184fchcar,
         aqpb184hora,
         aqpb184pais,
         aqpb184tdoc,
         aqpb184ndoc,
         aqpb184nomb,
         aqpb184ncred,
         aqpb184pgcod,
         aqpb184mod,
         aqpb184suc,
         aqpb184mda,
         aqpb184pap,
         aqpb184cta,
         aqpb184ope,
         aqpb184sbo,
         aqpb184top,
         aqpb184ins,
         aqpb184asesr,
         aqpb184fdes,
         aqpb184fcalnd,
         aqpb184fpago,
         aqpb184opcns,
         aqpb184zona,
         aqpb184reg,
         aqpb184dpto,
         aqpb184tcred,
         aqpb184dir,
         aqpb184pgtx,
         aqpb184suctx,
         aqpb184modtx,
         aqpb184tx,
         aqpb184reltx,
         aqpb184ordtx,
         aqpb184fchtx)
      values
        (ln_cor + 1,
         ld_FchSist,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         lc_nomb,
         lc_ncred,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbo,
         ln_top,
         nvl(ln_ins, 0),
         lc_asesr,
         ld_fdes,
         ld_fcalnd,
         ld_fpago,
         ln_opcns,
         ln_zona,
         ln_reg,
         lc_dpto,
         lc_tcred,
         lc_dir,
         ln_pgtx,
         ln_suctx,
         ln_modtx,
         ln_tx,
         ln_reltx,
         ln_ordtx,
         ln_fchtx);
    
    end;
  
  end sp_cr_LogAQPB184;
  ---------------------------------------------------------------------------------
  procedure sp_Cr_ValidEnLinea(ln_pgcodt  in number,
                               ln_suct    in number,
                               ln_modt    in number,
                               ln_ttran   in number,
                               ln_relt    in number,
                               ln_ordt    in number,
                               lv_PCancel out varchar2) is
  
    ln_pgcod        number;
    ln_mod          number;
    ln_suc          number;
    ln_mda          number;
    ln_pap          number;
    ln_cta          number;
    ln_ope          number;
    ln_subope       number;
    ln_tope         number;
    ld_FechVal      date;
    lc_EsTrabajador varchar2(5) := 'N';
    lc_EsFamiliar   varchar2(5) := 'N';
    lc_Exceptuar    varchar2(5) := 'N';
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_tdocRCC      number;
    ln_Calificacion number;
    --ln_OpcPDia      number;
    --ln_OpcPAntes    number;
    --ln_Opciones     number := 0;
    lc_NombreCli varchar2(200);
    ln_Instancia number;
    lc_Analista  varchar2(10);
    ln_region    number;
    ln_zona      number;
    lc_dpto      varchar2(100);
    lc_TipoCred  varchar2(50);
    lc_DirecLgl  varchar2(200);
    ln_EstaInsrt number := 0;
    ld_FchNac    date;
    ln_edad      number;
    lv_EdadOk    varchar2(5) := 'N';
    ln_NroCred   varchar2(25);
    ln_NroHijos  number;
    ln_MntDesemb number(17, 2);
    ln_ModEva    number := 0;
    ln_pgcod117  number;
    ln_mod117    number;
    ln_suc117    number;
    ln_mda117    number;
    ln_pap117    number;
    ln_cta117    number;
    ln_ope117    number;
    ln_subope117 number;
    ln_tope117   number;
    ln_DesembHoy number;
  
  begin
  
    lv_PCancel   := 'N';
    ln_DesembHoy := 1;
  
    begin
      select f.pgcod,
             f.modulo,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo,
             f.ittope,
             f.itfval
        into ln_pgcod,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_subope,
             ln_tope,
             ld_FechVal
        from fsd016 f
       where f.pgcod = ln_pgcodt
         and f.itsuc = ln_suct
         and f.itmod = ln_modt
         and f.ittran = ln_ttran
         and f.itnrel = ln_relt
         and f.itord = ln_ordt;
    exception
      when others then
        null;
    end;
  
    if ln_modt = 116 then
    
      begin
        select f.r2cod,
               f.r2mod,
               f.r2suc,
               f.r2mda,
               f.r2pap,
               f.r2cta,
               f.r2oper,
               f.r2sbop,
               f.r2tope
          into ln_pgcod117,
               ln_mod117,
               ln_suc117,
               ln_mda117,
               ln_pap117,
               ln_cta117,
               ln_ope117,
               ln_subope117,
               ln_tope117
          from fsr011 f
         where f.r1cod = ln_pgcod
           and f.r1mod = ln_mod
           and f.r1suc = ln_suc
           and f.r1mda = ln_mda
           and f.r1pap = ln_pap
           and f.r1cta = ln_cta
           and f.r1oper = ln_ope
           and f.r1sbop = ln_subope
           and f.r1tope = ln_tope
           and f.relcod = 46;
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_DesembHoy
          from fsd010 f
         where f.pgcod = ln_pgcod117
           and f.aomod = ln_mod117
           and f.aosuc = ln_suc117
           and f.aomda = ln_mda117
           and f.aopap = ln_pap117
           and f.aocta = ln_cta117
           and f.aooper = ln_ope117
           and f.aosbop = ln_subope117
           and f.aotope = ln_tope117
           and f.aofval = ld_FechVal;
      exception
        when others then
          null;
      end;
    
    end if;
  
    ln_NroCred := lpad(trim(to_char(ln_cta)), 9, '0') ||
                  lpad(trim(to_char(ln_mda)), 3, '0') ||
                  lpad(trim(to_char(ln_ope)), 9, '0');
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cta
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    begin
      sp_cr_instancia(ln_Scmod     => ln_mod,
                      ln_Scsuc     => ln_suc,
                      ln_Scmda     => ln_mda,
                      ln_Scpap     => ln_pap,
                      ln_Sccta     => ln_cta,
                      ln_Scoper    => ln_ope,
                      ln_Scsbop    => ln_subope,
                      ln_Sctope    => ln_tope,
                      ln_instancia => ln_Instancia);
    end;
  
    begin
      select s.sng021tmod
        into ln_ModEva
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_ModEva = 13 then
    
      Pq_Cr_Sorteo_Pyme2020.sp_cr_ChekTrabajador(ln_cta           => ln_cta,
                                                 lc_flgtrabajador => lc_EsTrabajador);
    
      PQ_CR_SORTEO_PYME2020.sp_cr_VerifGradoConsagui(ln_NroCuenta    => ln_cta,
                                                     lc_FlafFamiliar => lc_EsFamiliar);
    
      Pq_Cr_Sorteo_Pyme2020.sp_Excepciones(modulo   => ln_mod,
                                           ln_suc1  => ln_suc,
                                           ln_mda1  => ln_mda,
                                           ln_cta1  => ln_cta,
                                           ln_oper1 => ln_ope,
                                           ln_sbop1 => ln_subope,
                                           ittope   => ln_tope,
                                           FlgIncl  => lc_Exceptuar);
    
      ln_Calificacion := Pq_Cr_Sorteo_Pyme2020.fn_Calif_SBS_Cliente(lc_docsbs => ln_tdocRCC,
                                                                    
                                                                    lc_tndoc => lc_ndoc);
    
      begin
        select f.pffnac
          into ld_FchNac
          from fsd002 f
         where f.pfpais = ln_pais
           and f.pftdoc = ln_tdoc
           and f.pfndoc = lc_ndoc;
      exception
        when others then
          null;
      end;
    
      begin
        select floor(months_between(ld_FechVal, ld_FchNac) / 12)
          into ln_edad
          from dual;
      end;
    
      if ln_edad >= 25 and ln_edad <= 55 then
        lv_EdadOk := 'S';
      end if;
    
      begin
        select f.pfxchij
          into ln_NroHijos
          from fse002 f
         where f.pfxpais = ln_pais
           and f.pfxtdoc = ln_tdoc
           and f.pfxndoc = lc_ndoc;
      exception
        when others then
          ln_NroHijos := 0;
      end;
    
      begin
        select x.xllcapital
          into ln_MntDesemb
          from x054023 x
         where x.xllpgcod = ln_pgcod
           and x.xllaomod = ln_mod
           and x.xllaosuc = ln_suc
           and x.xllaomda = ln_mda
           and x.xllaopap = ln_pap
           and x.xllaocta = ln_cta
           and x.xllaooper = ln_ope
           and x.xllaosbop = ln_subope
           and x.xllaotop = ln_tope;
      exception
        when others then
          ln_MntDesemb := 0.00;
      end;
    
      if lc_EsTrabajador = 'N' and lc_EsFamiliar = 'N' and
         lc_Exceptuar = 'S' and ln_Calificacion = 1 and lv_EdadOk = 'S' and
         ln_NroHijos > 0 and ln_MntDesemb >= 1000 and ln_DesembHoy = 1 then
      
        lv_PCancel := 'S';
      
        begin
          select replace(f.penom, '-', '')
            into lc_NombreCli
            from fsd001 f
           where f.pepais = ln_pais
             and f.petdoc = ln_tdoc
             and f.pendoc = lc_ndoc;
        exception
          when others then
            null;
        end;
      
        begin
          select r.regcod, r.codzon, r.dpto
            into ln_region, ln_zona, lc_dpto
            from regsuc r
           where r.sucurs = ln_suc;
        exception
          when others then
            null;
        end;
      
        begin
          select s.sngc13dir
            into lc_DirecLgl
            from sngc13 s
           where s.sngc13pais = ln_pais
             and s.sngc13tdoc = ln_tdoc
             and s.sngc13ndoc = lc_ndoc
             and s.docod = 1
             and s.sngc13est = 'H';
        exception
          when others then
            null;
        end;
      
        if ln_Instancia > 0 then
        
          begin
            select s.sng001ase
              into lc_Analista
              from sng001 s
             where s.sng001inst = ln_Instancia;
          exception
            when others then
              null;
          end;
        
          begin
            select w.wfattsval
              into lc_TipoCred
              from wfattsvalues w
             where w.wfinsprcid = ln_Instancia
               and w.wfattsid = 'TIPO_CREDITO';
          exception
            when others then
              null;
          end;
        end if;
      
        begin
          select count(*)
            into ln_EstaInsrt
            from aqpb184 a
           where a.aqpb184pgcod = ln_pgcod
             and a.aqpb184mod = ln_mod
             and a.aqpb184suc = ln_suc
             and a.aqpb184mda = ln_mda
             and a.aqpb184pap = ln_pap
             and a.aqpb184cta = ln_cta
             and a.aqpb184ope = ln_ope
             and a.aqpb184sbo = ln_subope
             and a.aqpb184top = ln_tope;
        exception
          when others then
            null;
        end;
      
        if ln_EstaInsrt = 0 then
        
          lv_PCancel := 'S';
        
          Pq_Cr_Sorteo_Pyme2020.sp_cr_LogAQPB184(ln_pais   => ln_pais,
                                                 ln_tdoc   => ln_tdoc,
                                                 lc_ndoc   => trim(lc_ndoc),
                                                 lc_nomb   => trim(lc_NombreCli),
                                                 lc_ncred  => ln_NroCred,
                                                 ln_pgcod  => ln_pgcod,
                                                 ln_mod    => ln_mod,
                                                 ln_suc    => ln_suc,
                                                 ln_mda    => ln_mda,
                                                 ln_pap    => ln_pap,
                                                 ln_cta    => ln_cta,
                                                 ln_ope    => ln_ope,
                                                 ln_sbo    => ln_subope,
                                                 ln_top    => ln_tope,
                                                 ln_ins    => ln_Instancia,
                                                 lc_asesr  => trim(lc_Analista),
                                                 ld_fdes   => ld_FechVal,
                                                 ld_fcalnd => ld_FechVal,
                                                 ld_fpago  => ld_FechVal,
                                                 ln_opcns  => 0,
                                                 ln_zona   => ln_zona,
                                                 ln_reg    => ln_region,
                                                 lc_dpto   => lc_dpto,
                                                 lc_tcred  => trim(lc_TipoCred),
                                                 lc_dir    => trim(lc_DirecLgl),
                                                 ln_pgtx   => ln_pgcodt,
                                                 ln_suctx  => ln_suct,
                                                 ln_modtx  => ln_modt,
                                                 ln_tx     => ln_ttran,
                                                 ln_reltx  => ln_relt,
                                                 ln_ordtx  => ln_ordt,
                                                 ln_fchtx  => ld_FechVal);
          --i := i + 1;
          -- end loop;
          -- i := 1;
        end if;
      end if;
    end if;
  
  end sp_Cr_ValidEnLinea;
  -----------------------------------------------------------------------------------
end PQ_CR_SORTEO_PYME2020;
/* GOLDENGATE_DDL_REPLICATION */
/

