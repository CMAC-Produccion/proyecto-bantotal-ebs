CREATE OR REPLACE PACKAGE pq_cr_facturacion_generacion is
  -- *****************************************************************
  -- Nombre                       : pq_cr_facturacion_generacion
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Facturación Electrónica
  -- Versión                      : 1.0
  -- Fecha de Creación            : 14/02/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 11/11/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Adición de procesos para reprocesar fechas
  -- Fecha de Modificación        : 08/12/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del algoritmo para generar el DAE  
  -- Fecha de Modificación        : 29/12/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización para obtener el rubro desde la tabla aqpa463 al generar NCE  
  --                              : 26/05/2025 dcastro se modifico fn_acondcionar_rsocial
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_insertar_datos(pd_fecpro    in date,
                                 pd_resultado out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualizar_archivo_txt(pd_fecpro in date,
                                         pd_corr   number,
                                         pd_rpta   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_generacion_archivo_txt(pd_fecpro  in date,
                                         pd_usuario in varchar2,
                                         pd_rpta    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_concepto_monto(pn_pgc       number,
                             pn_mod       number,
                             pn_suc       number,
                             pn_trx       number,
                             pn_rel       number,
                             pn_fecha     date,
                             pn_fecha_con date,
                             pn_tipo      number,
                             pn_tip       aqpa460.aqpa460tcomf%type,
                             pn_ser       aqpa460.aqpa460seri%type,
                             pn_num       aqpa460.aqpa460num%type)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tipo_operacion(pn_pgc   number,
                             pn_mod   number,
                             pn_suc   number,
                             pn_trx   number,
                             pn_rel   number,
                             pn_fecha date,
                             pn_tip   aqpa460.aqpa460tcomf%type,
                             pn_ser   aqpa460.aqpa460seri%type,
                             pn_num   aqpa460.aqpa460num%type)
    return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_ejecucion_archivo_txt(pd_fecpro  in date,
                                        pd_usuario in varchar2,
                                        pd_rpta    out number,
                                        pd_msje    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_capital(pn_pgc       number,
                              pn_mod       number,
                              pn_suc       number,
                              pn_trx       number,
                              pn_rel       number,
                              pn_fecha     date,
                              pn_fecha_con date,
                              pn_tipo      aqpa460.aqpa460tcomf%type,
                              pn_ser       aqpa460.aqpa460seri%type,
                              pn_num       aqpa460.aqpa460num%type)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_acondcionar_rsocial(pc_razon aqpa460.aqpa460rasoc%type)
    return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                          
  procedure sp_cr_facturae_generar(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_tran  in number,
                                   pn_rel   in number,
                                   pn_con   in date,
                                   lc_tipo  out aqpb056.aqpb056tco%type,
                                   lc_serie out aqpb056.aqpb056ser%type,
                                   lc_corre out aqpb056.aqpb056num%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_cr_nota_creditoe_generar(ln_cod   in number,
                                        ln_mod   in number,
                                        ln_suc   in number,
                                        ln_trx   in number,
                                        ln_rel   in number,
                                        ln_fcon  in date,
                                        xn_tipo  out aqpb056.aqpb056tco%type,
                                        xn_serie out aqpb056.aqpb056ser%type,
                                        xn_corre out aqpb056.aqpb056num%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                               
  procedure sp_insertar_libro_ventas(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_actualizar_estado_comp(pd_fecpro in date, pd_corr number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  function fn_evaluar_conceptos(pn_pgc   number,
                                pn_mod   number,
                                pn_suc   number,
                                pn_trx   number,
                                pn_rel   number,
                                pn_fecha date) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  procedure sp_cr_pk_credito(pc_AQPA465PGCOD    in number,
                             pc_AQPA465MOD      in number,
                             pc_AQPA465SUCOREND in number,
                             pc_AQPA465TRAN     in number,
                             pc_AQPA465REL      in number,
                             pc_AQPA465ORD      in number,
                             pd_AQPA465CON      in date,
                             pn_cod             out number,
                             pn_mod             out number,
                             pn_suc             out number,
                             pn_mda             out number,
                             pn_pap             out number,
                             pn_cta             out number,
                             pn_ope             out number,
                             pn_sbo             out number,
                             pn_top             out number,
                             pc_FLAG            out char,
                             pn_rubro           out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  function fn_fecha_desembolso(pc_aqpa463cta in number,
                               pc_aqpa463ope in number) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                        
  procedure sp_cr_facturae_gen_cont(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_tran  in number,
                                    pn_rel   in number,
                                    pn_con   in date,
                                    lc_tipo  out aqpb056.aqpb056tco%type,
                                    lc_serie out aqpb056.aqpb056ser%type,
                                    lc_corre out aqpb056.aqpb056num%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_cr_nota_creditoe_gen_cont(ln_cod   in number,
                                         ln_mod   in number,
                                         ln_suc   in number,
                                         ln_trx   in number,
                                         ln_rel   in number,
                                         ln_fcon  in date,
                                         xn_tipo  out aqpb056.aqpb056tco%type,
                                         xn_serie out aqpb056.aqpb056ser%type,
                                         xn_corre out aqpb056.aqpb056num%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_generar_DAE_his(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_generar_NCE_his(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_registro_Comp(pn_fecha in date, pn_opcion in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_correc_DAE_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_correc_NCE_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_correc_NCE_dia_2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_repro_dia(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_reset_sequence(p_seq in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_recalcular_impt(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_anular_comprob(pn_cod     in number,
                                 pn_fecha   in date,
                                 pn_corr    in number,
                                 pn_usuario in varchar2,
                                 pn_messa   out varchar2,
                                 pn_val     out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  Procedure sp_job_reprocesar_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
  procedure sp_cr_sch_dae_his(pd_fecpro in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
  procedure sp_cr_generar_DAE_his_suc(pn_fecha in date, pn_sucurs number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_generar_NCE_his_prev(pn_fecha in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                
  procedure sp_inserta_lv_ebs(lc_fecha_ini in date, lc_fecha_fin in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                                                                   
  procedure sp_inserta_lvebs_I(lc_serie in varchar2, ln_corr in number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_insertar_lib_ventas_I(pc_serie in varchar2,
                                     pn_corr  in number);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualiza_estado_lv(lc_serie  in varchar2,
                                   ln_corr   in number,
                                   lc_codest in varchar2);
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualiza_EST6566(ld_fecha in date);
  -------------------------------------------------------------------------------
  procedure sp_cr_insertar_datos1(pd_fecpro    in date,
                                   pd_resultado out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                                                                   

end pq_cr_facturacion_generacion;
/
CREATE OR REPLACE PACKAGE BODY pq_cr_facturacion_generacion is
  -- *****************************************************************
  -- Nombre                       : pq_cr_facturacion_generacion
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Facturación Electrónica
  -- Versión                      : 1.0
  -- Fecha de Creación            : 14/02/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Fecha de Modificación        : 11/11/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Adición de procesos para reprocesar fechas
  -- Fecha de Modificación        : 08/12/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización del algoritmo para generar el DAE  
  -- Fecha de Modificación        : 29/12/2020
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Actualización para obtener el rubro desde la tabla aqpa463 al generar NCE  
  --                                07/09/2023 dcastro se modifico sp_insertar_libro_ventas
  --                                26/05/2025 dcastro se modifico fn_acondcionar_rsocial  
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_insertar_datos(pd_fecpro    in date,
                                 pd_resultado out number) is
  
    lc_limite number(18) := 0;
    lc_indice number(18) := 0;
    lc_corr   number := 0;
    --lc_indicador number := 0;
    lc_pgcod     number := 1;
    lc_found_cur boolean := false;
    lc_total     number := 0;
  
    cursor cur_registros is
/*      select distinct t.aqpa460tcomf aqpb052tcomf, --C1: Tipo de documento
                      t.aqpa460seri  aqpb052seri, --C2: Número de serie del documento
                      t.aqpa460num   aqpb052num, --C3: Número correlativo del documento
                      t.aqpa460mone  aqpb052mone, --C4: Tipo de moneda del comprobante
                      --'2101' aqpb052tipope,             
                      nvl(pq_cr_facturacion_generacion.fn_tipo_operacion(t.aqpa460pgc,
                                                                         t.aqpa460mod,
                                                                         t.aqpa460suc,
                                                                         t.aqpa460trx,
                                                                         t.aqpa460rel,
                                                                         t.aqpa460femi,
                                                                         t.aqpa460tcomf,
                                                                         t.aqpa460seri,
                                                                         t.aqpa460num),
                          '0000') aqpb052tipope, --C5: Tipo de operación no gravada
                      t.aqpa460tdocr aqpb052tdoc, --C6: Tipo de documento de identidad del cliente
                      t.aqpa460nruc aqpb052nruc, --C7: Número de documento de Identidad del cliente
                      
                      --replace(t.aqpa460rasoc, 'Ñ', 'N') aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente
                      pq_cr_facturacion_generacion.fn_acondcionar_rsocial(t.aqpa460rasoc) aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     1,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052incuo, --C9: Monto del interés de la cuota
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     2,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052inmor, --C10: Monto del interés moratorio de corresponder
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     3,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052segfac, --C11: Monto total de seguros facturados 
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     4,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052otrcon, --C12: Monto total de otros conceptos facturados
                      0 aqpb052opina, --C13: Total valor de venta - operaciones inafectas
                      0 aqpb052opexa, --C14: Total valor de venta - operaciones exoneradas
                      0 aqpb052impt, --C15: Importe total a pagar 
                      
                      t.aqpa460cmem  aqpb052tdref, --C16: Tipo de documento que se modifica
                      t.aqpa460sdref aqpb052nsref, --C17: Número de serie del documento que se modifica
                      t.aqpa460ndref aqpb052ndref, --C18: Número correlativo del documento que se modifica
                      
                      t.aqpa460fotrc aqpb052fotrc, --C19: Fecha de otorgamiento del crédito/Linea de crédito
                      \*pq_cr_facturacion_generacion.fn_concepto_monto(
                                   t.aqpa460pgc,      
                                   t.aqpa460mod,       
                                   t.aqpa460suc,      
                                   t.aqpa460trx,      
                                   t.aqpa460rel,
                                   t.aqpa460femi,
                                   5
                      ) aqpb052mcred,*\
                      pq_cr_facturacion_generacion.fn_obtener_capital(t.aqpa460pgc,
                                                                      t.aqpa460mod,
                                                                      t.aqpa460suc,
                                                                      t.aqpa460trx,
                                                                      t.aqpa460rel,
                                                                      t.aqpa460femi,
                                                                      t.aqpa460fcone,
                                                                      t.aqpa460tcomf,
                                                                      t.aqpa460seri,
                                                                      t.aqpa460num) aqpb052mcred, --C20: Monto del crédito otorgado (capital)
                      t.aqpa460ncont aqpb052ncon, --C21: Número de contrato
                      
                      '' aqpb052npol, --C22: Número de póliza
                      null aqpb052ficob, --C23: Fecha de inicio de vigencia de cobertura
                      null aqpb052ffcob, --C24: Fecha de término de vigencia de cobertura
                      '' aqpb052tseg, --C25: Tipo de seguro
                      0 aqpb052scob, --C26: Suma asegurada / alcance de cobertura o monto                                                        
                      
                      t.aqpa460pgc   aqpb052pgc,
                      t.aqpa460mod   aqpb052mod,
                      t.aqpa460suc   aqpb052suc,
                      t.aqpa460trx   aqpb052trx,
                      t.aqpa460rel   aqpb052rel,
                      t.aqpa460femi  aqpb052femi,
                      t.aqpa460pgce  aqpb052pgce,
                      t.aqpa460mode  aqpb052mode,
                      t.aqpa460suce  aqpb052suce,
                      t.aqpa460trxe  aqpb052trxe,
                      t.aqpa460rele  aqpb052rele,
                      t.aqpa460fcone aqpb052fcone
      --t.aqpa460ore,
        from aqpa460 t
       where t.aqpa460femi = pd_fecpro
         and t.aqpa460tcomf in ('13', '87', '88')
         and not exists (select 'x'
                from aqpb053 s
               where
              
               s.aqpb053tcomf = t.aqpa460tcomf
            and s.aqpb053seri = t.aqpa460seri
            and s.aqpb053num = t.aqpa460num
            and s.aqpb053est in ('E', 'R') ---Emitido
              )
      
       order by t.aqpa460tcomf, t.aqpa460seri, t.aqpa460num;
*/  
       select 
        aqpb052ttcomf  aqpb052tcomf, 
        aqpb052tseri   aqpb052seri, 
        aqpb052tnum    aqpb052num, 
        aqpb052tmone   aqpb052mone, 
        aqpb052ttipope aqpb052tipope, 
        aqpb052ttdoc   aqpb052tdoc, 
        aqpb052tnruc   aqpb052nruc, 
        aqpb052trasoc  aqpb052rasoc, 
        aqpb052tincuo  aqpb052incuo, 
        aqpb052tinmor  aqpb052inmor, 
        aqpb052tsegfac aqpb052segfac, 
        aqpb052totrcon aqpb052otrcon, 
        aqpb052topina  aqpb052opina, 
        aqpb052topexa  aqpb052opexa, 
        aqpb052timpt   aqpb052impt, 
        aqpb052ttdref  aqpb052tdref, 
        aqpb052tnsref  aqpb052nsref, 
        aqpb052tndref  aqpb052ndref, 
        aqpb052tfotrc  aqpb052fotrc, 
        aqpb052tmcred  aqpb052mcred, 
        aqpb052tncon   aqpb052ncon, 
        aqpb052tnpol   aqpb052npol, 
        aqpb052tficob  aqpb052ficob, 
        aqpb052tffcob  aqpb052ffcob, 
        aqpb052ttseg   aqpb052tseg, 
        aqpb052tscob   aqpb052scob, 
        aqpb052tpgc    aqpb052pgc, 
        aqpb052tmod    aqpb052mod, 
        aqpb052tsuc    aqpb052suc, 
        aqpb052ttrx    aqpb052trx, 
        aqpb052trel    aqpb052rel, 
        aqpb052tfemi   aqpb052femi, 
        aqpb052tcod    aqpb052cod, 
        aqpb052tpgce   aqpb052pgce, 
        aqpb052tmode   aqpb052mode, 
        aqpb052tsuce   aqpb052suce, 
        aqpb052ttrxe   aqpb052trxe, 
        aqpb052trele   aqpb052rele, 
        aqpb052tfcone  aqpb052fcone
        from aqpb052t 
       order by aqpb052ttcomf, aqpb052tseri,aqpb052tnum;
       

  begin
  
    /* 2023.10.17 optimizacion*/
    execute immediate 'truncate table aqpb052t'; ---eliminando fecha de proceso en tabla temporal
    
    insert into aqpb052t
    (
          aqpb052ttcomf, --1
          aqpb052tseri, --2
          aqpb052tnum, --3
          aqpb052tmone, --4
          aqpb052ttipope, --5
          aqpb052ttdoc, --6
          aqpb052tnruc, --7
          aqpb052trasoc, --8
          aqpb052tincuo, --9
          aqpb052tinmor, --10
          aqpb052tsegfac, --11
          aqpb052totrcon, --12
          aqpb052topina, --13
          aqpb052topexa, --14
          aqpb052timpt, --15
          aqpb052ttdref, --16
          aqpb052tnsref, --17
          aqpb052tndref, --18
          aqpb052tfotrc, --19
          aqpb052tmcred, --20
          aqpb052tncon,  --21
          aqpb052tnpol,  --22
          aqpb052tficob, --23
          aqpb052tffcob, --24
          aqpb052ttseg,  --25
          aqpb052tscob,  --26
          aqpb052tpgc,   --27
          aqpb052tmod,   --28
          aqpb052tsuc,   --29
          aqpb052ttrx,   --30
          aqpb052trel,   --31
          aqpb052tfemi,  --32    
---          aqpb052tcod,   
          aqpb052tpgce, --33
          aqpb052tmode,  --34
          aqpb052tsuce,  --35
          aqpb052ttrxe,  --36
          aqpb052trele,  --37
          aqpb052tfcone  --38
       )
    select /*+all_rows*/
    distinct t.aqpa460tcomf aqpb052tcomf, --C1: Tipo de documento --1
                      t.aqpa460seri  aqpb052seri, --C2: Número de serie del documento --2
                      t.aqpa460num   aqpb052num, --C3: Número correlativo del documento --3
                      t.aqpa460mone  aqpb052mone, --C4: Tipo de moneda del comprobante --4
                      --'2101' aqpb052tipope,             
                      nvl(pq_cr_facturacion_generacion.fn_tipo_operacion(t.aqpa460pgc,
                                                                         t.aqpa460mod,
                                                                         t.aqpa460suc,
                                                                         t.aqpa460trx,
                                                                         t.aqpa460rel,
                                                                         t.aqpa460femi,
                                                                         t.aqpa460tcomf,
                                                                         t.aqpa460seri,
                                                                         t.aqpa460num),
                          '0000') aqpb052tipope, --C5: Tipo de operación no gravada  --5
                      t.aqpa460tdocr aqpb052tdoc, --C6: Tipo de documento de identidad del cliente --6
                      t.aqpa460nruc aqpb052nruc, --C7: Número de documento de Identidad del cliente --7
                      
                      --replace(t.aqpa460rasoc, 'Ñ', 'N') aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente
                      pq_cr_facturacion_generacion.fn_acondcionar_rsocial(t.aqpa460rasoc) aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente --8
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     1,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052incuo, --C9: Monto del interés de la cuota --9
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     2,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052inmor, --C10: Monto del interés moratorio de corresponder --10
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     3,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052segfac, --C11: Monto total de seguros facturados --11
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     4,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052otrcon, --C12: Monto total de otros conceptos facturados --12
                      0 aqpb052opina, --C13: Total valor de venta - operaciones inafectas --13
                      0 aqpb052opexa, --C14: Total valor de venta - operaciones exoneradas --14
                      0 aqpb052impt, --C15: Importe total a pagar --15
                      
                      t.aqpa460cmem  aqpb052tdref, --C16: Tipo de documento que se modifica --16
                      t.aqpa460sdref aqpb052nsref, --C17: Número de serie del documento que se modifica--17
                      t.aqpa460ndref aqpb052ndref, --C18: Número correlativo del documento que se modifica --18
                      
                      t.aqpa460fotrc aqpb052fotrc, --C19: Fecha de otorgamiento del crédito/Linea de crédito --19
                      /*pq_cr_facturacion_generacion.fn_concepto_monto(
                                   t.aqpa460pgc,      
                                   t.aqpa460mod,       
                                   t.aqpa460suc,      
                                   t.aqpa460trx,      
                                   t.aqpa460rel,
                                   t.aqpa460femi,
                                   5
                      ) aqpb052mcred,*/
                      pq_cr_facturacion_generacion.fn_obtener_capital(t.aqpa460pgc,
                                                                      t.aqpa460mod,
                                                                      t.aqpa460suc,
                                                                      t.aqpa460trx,
                                                                      t.aqpa460rel,
                                                                      t.aqpa460femi,
                                                                      t.aqpa460fcone,
                                                                      t.aqpa460tcomf,
                                                                      t.aqpa460seri,
                                                                      t.aqpa460num) aqpb052mcred, --C20: Monto del crédito otorgado (capital) --20
                      t.aqpa460ncont aqpb052ncon, --C21: Número de contrato  --21
                      
                      '' aqpb052npol, --C22: Número de póliza --22
                      null aqpb052ficob, --C23: Fecha de inicio de vigencia de cobertura --23
                      null aqpb052ffcob, --C24: Fecha de término de vigencia de cobertura --24
                      '' aqpb052tseg, --C25: Tipo de seguro  --25
                      0 aqpb052scob, --C26: Suma asegurada / alcance de cobertura o monto  --26                                                        
                      
                      t.aqpa460pgc   aqpb052pgc, --27
                      t.aqpa460mod   aqpb052mod, --28
                      t.aqpa460suc   aqpb052suc, --29
                      t.aqpa460trx   aqpb052trx, --30
                      t.aqpa460rel   aqpb052rel, --31
                      t.aqpa460femi  aqpb052femi, --32
                      t.aqpa460pgce  aqpb052pgce, --33
                      t.aqpa460mode  aqpb052mode, --34
                      t.aqpa460suce  aqpb052suce, --35
                      t.aqpa460trxe  aqpb052trxe, --36
                      t.aqpa460rele  aqpb052rele, --37
                      t.aqpa460fcone aqpb052fcone --38
      --t.aqpa460ore,
        from aqpa460 t
       where t.aqpa460femi = pd_fecpro
         and t.aqpa460tcomf in ('13', '87', '88')
         and not exists (select 'x'
                from aqpb053 s
               where
              
               s.aqpb053tcomf = t.aqpa460tcomf
            and s.aqpb053seri = t.aqpa460seri
            and s.aqpb053num = t.aqpa460num
            and s.aqpb053est in ('E', 'R') ---Emitido
              );
      commit;
    /* 2023.10.17 */   
  
    begin
      /*-------Límite por registros---------*/
      select d.tp1nro1
        into lc_limite
        from fst198 d
       where d.tp1cod = 1
         and d.tp1cod1 = 11120
         and d.tp1corr1 = 9
         and d.tp1corr2 = 1
         and d.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    
  
    /*---Seleccionar correlativo maximo---*/
    begin
      sp_correl_sq(p_c_nomseq => 'SEQ_COMPROBANTE_SEE',
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => lc_corr); --out
    exception
      when others then
        null;
    end;
  
    /*---Recorres registros---*/
    for registro in cur_registros loop
    
      lc_found_cur := true;
    
      if lc_indice = lc_limite then
        lc_corr   := lc_corr + 1;
        lc_indice := 1;
      else
        lc_indice := lc_indice + 1;
      end if;
    
      lc_total := registro.aqpb052incuo + registro.aqpb052inmor +
                  registro.aqpb052segfac + registro.aqpb052otrcon;
      begin
        insert into aqpb052
        values
          (registro.aqpb052tcomf, -- aqpb052tcomf              C1: Tipo de documento
           registro.aqpb052seri, -- aqpb052seri      C2: Número de serie del documento
           registro.aqpb052num, -- aqpb052num       C3: Número correlativo del documento
           registro.aqpb052mone, -- aqpb052mone      C4: Tipo de moneda del comprobante
           registro.aqpb052tipope, -- aqpb052tipope    C5: Tipo de operación no gravada
           registro.aqpb052tdoc, -- aqpb052tdoc      C6: Tipo de documento de identidad del cliente
           registro.aqpb052nruc, -- aqpb052nruc      C7: Número de documento de Identidad del cliente
           registro.aqpb052rasoc, -- aqpb052rasoc     C8: Apellidos y nombres,  denominación o razón social del cliente
           registro.aqpb052incuo, -- aqpb052incuo     C9: Monto del interés de la cuota
           registro.aqpb052inmor, -- aqpb052inmor     C10: Monto del interés moratorio de corresponder
           registro.aqpb052segfac, -- aqpb052segfac    C11: Monto total de seguros facturados 
           registro.aqpb052otrcon, -- aqpb052otrcon    C12: Monto total de otros conceptos facturados
           lc_total, -- aqpb052opina     C13: Total valor de venta - operaciones inafectas
           registro.aqpb052opexa, -- aqpb052opexa     C14: Total valor de venta - operaciones exoneradas  
           lc_total, -- aqpb052impt      C15: Importe total a pagar 
           registro.aqpb052tdref, -- aqpb052tdref     C16: Tipo de documento que se modifica
           registro.aqpb052nsref, -- aqpb052nsref     C17: Número de serie del documento que se modifica
           registro.aqpb052ndref, -- aqpb052ndref     C18: Número correlativo del documento que se modifica
           registro.aqpb052fotrc, -- aqpb052fotrc     C19: Fecha de otorgamiento del crédito/Linea de crédito
           registro.aqpb052mcred, -- aqpb052mcred     C20: Monto del crédito otorgado (capital)
           --2011.11,
           registro.aqpb052ncon, -- aqpb052ncon      C21: Número de contrato
           registro.aqpb052npol, -- aqpb052npol      C22: Número de póliza
           registro.aqpb052ficob, -- aqpb052ficob     C23: Fecha de inicio de vigencia de cobertura
           registro.aqpb052ffcob, -- aqpb052ffcob     C24: Fecha de término de vigencia de cobertura
           registro.aqpb052tseg, -- aqpb052tseg      C25: Tipo de seguro
           registro.aqpb052scob, -- aqpb052scob      C26: Suma asegurada / alcance de cobertura o monto                                     
           
           registro.aqpb052pgc, -- aqpb052pgc
           registro.aqpb052mod, -- aqpb052mod
           registro.aqpb052suc, -- aqpb052suc
           registro.aqpb052trx, -- aqpb052trx
           registro.aqpb052rel, -- aqpb052rel
           registro.aqpb052femi, -- aqpb052femi
           lc_corr, -- aqpb052cod
           
           registro.aqpb052pgce, -- aqpb052pgce
           registro.aqpb052mode, -- aqpb052mode
           registro.aqpb052suce, -- aqpb052suce
           registro.aqpb052trxe, -- aqpb052trxe
           registro.aqpb052rele, -- aqpb052rele
           registro.aqpb052fcone); -- aqpb052fcone
      exception
        when others then
          null;
      end;
    
      /*-------------*/
      begin
        insert into aqpb053
        values
          (pd_fecpro,
           lc_corr,
           registro.aqpb052tcomf,
           registro.aqpb052seri,
           registro.aqpb052num,
           'E',
           0,
           '',
           lc_pgcod);
      exception
        when others then
          null;
      end;
    
    end loop;
    commit;
  
    if lc_found_cur then
      pd_resultado := 1;
    else
      pd_resultado := 0;
    end if;
  
    /*exception
    when others then
         pd_resultado := 0;*/
  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualizar_archivo_txt(pd_fecpro in date,
                                         pd_corr   number,
                                         pd_rpta   out number) is
    fhandle   utl_file.file_type;
    lc_nombre varchar2(100);
    lc_ruc    varchar2(15);
    lc_fecha  varchar2(10);
    lc_corr   varchar2(10);
    ---lc_pgcod number := 1;
    lc_fecpro date;
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_generacion_archivo_txt
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Facturación Electrónica
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2020
    -- Autor de Creación          : jrodriguej
    -- Uso                        : Generación de archivo txt
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro ( fecha a procesar )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor cur_pj_documentos(pa_pjfecha date, pa_pjcorr number) is
      select t.aqpb052tcomf,
             t.aqpb052seri,
             t.aqpb052num,
             t.aqpb052mone,
             t.aqpb052tipope,
             t.aqpb052tdoc,
             t.aqpb052nruc,
             t.aqpb052rasoc,
             t.aqpb052incuo,
             t.aqpb052inmor,
             t.aqpb052segfac,
             t.aqpb052otrcon,
             t.aqpb052opina,
             t.aqpb052opexa,
             t.aqpb052impt,
             t.aqpb052tdref,
             t.aqpb052nsref,
             t.aqpb052ndref,
             t.aqpb052femi,
             t.aqpb052mcred,
             t.aqpb052ncon,
             t.aqpb052npol,
             t.aqpb052ficob,
             t.aqpb052ffcob,
             t.aqpb052tseg,
             t.aqpb052scob
        from aqpb052 t, aqpb053 s
      ---aqpa460 t
       where t.aqpb052femi = s.aqpb053fecha
         and t.aqpb052cod = s.aqpb053cod
         and t.aqpb052tcomf = s.aqpb053tcomf
         and t.aqpb052seri = s.aqpb053seri
         and t.aqpb052num = s.aqpb053num
         and
            
             s.aqpb053fecha = pa_pjfecha
         and s.aqpb053cod = pa_pjcorr
         and s.aqpb053est = 'E'
       order by t.aqpb052tcomf, t.aqpb052seri, t.aqpb052num;
  
  begin
  
    lc_fecpro := pd_fecpro;
  
    begin
    
      ---Obtención del RUC
      select trim(to_char(a.tp1desc))
        into lc_ruc
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11120
         and a.tp1corr1 = 1
         and a.tp1corr2 = 6
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
      
    end;
  
  
    lc_fecha := to_char(lc_fecpro, 'yyyymmdd'); -- 28/09/2023 dcastro se modifico despues de excepcion
  
    begin
    
      --Obtención del correlativo
      lc_corr := to_char(pd_corr);
    
      --Nombre archivo: <RUC emisor>-<tipo de archivo>-<Fecha de emisión>-<Identificador del archivo>.<Extensión>
      --Ejemplo: 20100088872-BN-20190502-9821.txt
      lc_nombre := lc_ruc || '-BN-' || lc_fecha || '-' || lc_corr || '.txt';
    
      fhandle := utl_file.fopen('DT_FACT_SEE' -- 'UTL_DIR'     -- File location
                               ,
                                lc_nombre --'test_file.txt'  -- File name
                               ,
                                'w' -- Open mode: w = write.
                                );
    
      for fdoc in cur_pj_documentos(lc_fecpro, lc_corr) loop
        --utl_file.put(fhandle, lc_nombre|| CHR(10));
        utl_file.put_line(fhandle,
                          --utl_file.put(fhandle, 
                          trim(to_char(fdoc.aqpb052tcomf)) || '|' || --C1
                           trim(to_char(fdoc.aqpb052seri)) || '|' || --C2
                           trim(to_char(fdoc.aqpb052num)) || '|' || --C3
                           trim(to_char(fdoc.aqpb052mone)) || '|' || --C4
                           trim(to_char(fdoc.aqpb052tipope)) || '|' || --C5
                           trim(to_char(fdoc.aqpb052tdoc)) || '|' || --C6
                           trim(to_char(fdoc.aqpb052nruc)) || '|' || --C7
                           trim(to_char(fdoc.aqpb052rasoc)) || '|' || --C8
                          
                          --replace(trim(to_char(fdoc.aqpb052incuo, 'FM99999999990.00')),',','.')||'|'||   --C9
                           trim(to_char(fdoc.aqpb052incuo,
                                        'FM99999999990.00')) || '|' || --C9
                           trim(to_char(fdoc.aqpb052inmor,
                                        'FM99999999990.00')) || '|' || --C10
                           trim(to_char(fdoc.aqpb052segfac,
                                        'FM99999999990.00')) || '|' || --C11
                           trim(to_char(fdoc.aqpb052otrcon,
                                        'FM99999999990.00')) || '|' || --C12
                           trim(to_char(fdoc.aqpb052opina,
                                        'FM99999999990.00')) || '|' || --C13
                           trim(to_char(fdoc.aqpb052opexa,
                                        'FM99999999990.00')) || '|' || --C14
                           trim(to_char(fdoc.aqpb052impt, 'FM99999999990.00')) || '|' || --C15
                          
                           trim(to_char(fdoc.aqpb052tdref)) || '|' || --C16
                           trim(to_char(fdoc.aqpb052nsref)) || '|' || --C17
                           trim(to_char(fdoc.aqpb052ndref)) || '|' || --C18
                           trim(to_char(fdoc.aqpb052femi, 'yyyy-mm-dd')) || '|' || --C19
                          
                           trim(to_char(fdoc.aqpb052mcred,
                                        'FM99999999990.00')) || '|' || --C20
                          
                           trim(to_char(fdoc.aqpb052ncon)) || '|' || --C21
                           trim(to_char(fdoc.aqpb052npol)) || '|' || --C22
                           trim(to_char(fdoc.aqpb052ficob, 'yyyy-mm-dd')) || '|' || --C23
                           trim(to_char(fdoc.aqpb052ffcob, 'yyyy-mm-dd')) || '|' || --C24
                           trim(to_char(fdoc.aqpb052tseg)) || '|' || --C25
                           trim(to_char(fdoc.aqpb052scob, 'FM99999999990.00')) --C26
                          );
      
      end loop;
    
      utl_file.fclose(fhandle);
    
      pd_rpta := 1;
    
    exception
      /*when others then
      dbms_output.put_line('ERROR: ' || SQLCODE
                        || ' - ' || SQLERRM);*/
      WHEN NO_DATA_FOUND THEN
        pd_rpta := 0;
        --raise;
    end;
  
    -----=========================================================
  
  exception
    when others then
      pd_rpta := 0;
      --dbms_output.put_line('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
  
  end sp_cr_actualizar_archivo_txt;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_generacion_archivo_txt(pd_fecpro  in date,
                                         pd_usuario in varchar2,
                                         pd_rpta    out number) is
    fhandle   utl_file.file_type;
    lc_nombre varchar2(100);
    lc_ruc    varchar2(15);
    lc_fecha  varchar2(10);
    --lc_cadena varchar2(200);
    lc_corr   varchar2(10);
    lc_pgcod  number := 1;
    lc_fecpro date;
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_generacion_archivo_txt
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Facturación Electrónica
    -- Versión                    : 1.0
    -- Fecha de Creación          : 14/02/2020
    -- Autor de Creación          : jrodriguej
    -- Uso                        : Generación de archivo txt
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro ( fecha a procesar )                            
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor cur_pj_documentos(pa_pjfecha date, pa_pjcorr number) is
      select t.aqpb052tcomf,
             t.aqpb052seri,
             t.aqpb052num,
             t.aqpb052mone,
             t.aqpb052tipope,
             t.aqpb052tdoc,
             t.aqpb052nruc,
             t.aqpb052rasoc,
             t.aqpb052incuo,
             t.aqpb052inmor,
             t.aqpb052segfac,
             t.aqpb052otrcon,
             t.aqpb052opina,
             t.aqpb052opexa,
             t.aqpb052impt,
             t.aqpb052tdref,
             t.aqpb052nsref,
             t.aqpb052ndref,
             --t.aqpb052femi,
             t.aqpb052fotrc,
             t.aqpb052mcred,
             t.aqpb052ncon,
             t.aqpb052npol,
             t.aqpb052ficob,
             t.aqpb052ffcob,
             t.aqpb052tseg,
             t.aqpb052scob
        from aqpb052 t, aqpb053 s
      ---aqpa460 t
       where t.aqpb052femi = s.aqpb053fecha
         and t.aqpb052cod = s.aqpb053cod
         and t.aqpb052tcomf = s.aqpb053tcomf
         and t.aqpb052seri = s.aqpb053seri
         and t.aqpb052num = s.aqpb053num
         and s.aqpb053fecha = pa_pjfecha
         and s.aqpb053cod = pa_pjcorr
         and s.aqpb053est = 'E'
      --trim(t.aqpb052tcomf) in ('01','03','07') and
       order by t.aqpb052tcomf, t.aqpb052seri, t.aqpb052num;
  
    cursor cur_pj_fecha(pa_pjfecha date) is
      select t.aqpb053fecha fecha, t.aqpb053cod correlativo
        from aqpb053 t
       where t.aqpb053fecha = pa_pjfecha
         and t.aqpb053est = 'E'
       group by t.aqpb053fecha, t.aqpb053cod;
  
  begin
  
    lc_fecpro := pd_fecpro;
  
    --pq_cr_facturacion_generacion.sp_cr_insertar_datos(lc_fecpro, lc_rpta);
    -----=========================================================
    -- Simple PLSQL to open a file,
    -- write two lines into the file,
    -- and close the file
  
    begin
    
      ---Obtención del RUC
      select trim(to_char(a.tp1desc))
        into lc_ruc
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11120
         and a.tp1corr1 = 1
         and a.tp1corr2 = 6
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;

    lc_fecha := to_char(lc_fecpro, 'yyyymmdd'); --- 16/08/2023 dcastro se actualizo nombre archivo

  
    begin
    
      ---INICIO: GENERACIÓN TXT
      for fcorr in cur_pj_fecha(lc_fecpro) loop
        ---cur_pj_fecha
        --Obtención del correlativo
        lc_corr := to_char(fcorr.correlativo);
      
        --Nombre archivo: <RUC emisor>-<tipo de archivo>-<Fecha de emisión>-<Identificador del archivo>.<Extensión>
        --Ejemplo: 20100088872-BN-20190502-9821.txt
        lc_nombre := lc_ruc || '-BN-' || lc_fecha || '-' || lc_corr ||
                     '.txt';
      
        begin
          --Insertar archivo en aqpb054
          insert into aqpb054
            (aqpb054pgcod,
             aqpb054fecha,
             aqpb054corr,
             aqpb054arche,
             aqpb054est,
             aqpb054usua,
             aqpb054fcr,
             aqpb054hcr)
          values
            (lc_pgcod, --aqpb054pgcod,
             lc_fecpro, --aqpb054fecha,
             lc_corr, --aqpb054corr,
             lc_nombre,
             'E', --emitido
             trim(pd_usuario), --aqpb054usua,
             to_char(sysdate, 'DD/MM/YYYY'), --aqpb054fcr,
             to_char(sysdate, 'HH24:MI:SS') --aqpb054hcr
             );
        exception
          when others then
            null;
        end;
        commit;
      
        fhandle := utl_file.fopen('DT_FACT_SEE' --'DT_FACT_SEE' -- 'UTL_DIR'     -- File location
                                 ,
                                  lc_nombre --'test_file.txt'  -- File name
                                 ,
                                  'w' -- Open mode: w = write.
                                  );
      
        for fdoc in cur_pj_documentos(lc_fecpro, fcorr.correlativo) loop
          --utl_file.put(fhandle, lc_nombre|| CHR(10));
          utl_file.put_line(fhandle,
                            --utl_file.put(fhandle, 
                            trim(to_char(fdoc.aqpb052tcomf)) || '|' || --C1
                             trim(to_char(fdoc.aqpb052seri)) || '|' || --C2
                             trim(to_char(fdoc.aqpb052num)) || '|' || --C3
                             trim(to_char(fdoc.aqpb052mone)) || '|' || --C4
                             trim(to_char(fdoc.aqpb052tipope)) || '|' || --C5
                             trim(to_char(fdoc.aqpb052tdoc)) || '|' || --C6
                             trim(to_char(fdoc.aqpb052nruc)) || '|' || --C7
                             trim(to_char(fdoc.aqpb052rasoc)) || '|' || --C8
                            
                            --replace(trim(to_char(fdoc.aqpb052incuo, 'FM99999999990.00')),',','.')||'|'||   --C9
                             trim(to_char(fdoc.aqpb052incuo,
                                          'FM99999999990.00')) || '|' || --C9
                             trim(to_char(fdoc.aqpb052inmor,
                                          'FM99999999990.00')) || '|' || --C10
                             trim(to_char(fdoc.aqpb052segfac,
                                          'FM99999999990.00')) || '|' || --C11
                             trim(to_char(fdoc.aqpb052otrcon,
                                          'FM99999999990.00')) || '|' || --C12
                             trim(to_char(fdoc.aqpb052opina,
                                          'FM99999999990.00')) || '|' || --C13
                             trim(to_char(fdoc.aqpb052opexa,
                                          'FM99999999990.00')) || '|' || --C14
                             trim(to_char(fdoc.aqpb052impt,
                                          'FM99999999990.00')) || '|' || --C15
                            
                             trim(to_char(fdoc.aqpb052tdref)) || '|' || --C16
                             trim(to_char(fdoc.aqpb052nsref)) || '|' || --C17
                             trim(to_char(fdoc.aqpb052ndref)) || '|' || --C18
                             trim(to_char(fdoc.aqpb052fotrc, 'yyyy-mm-dd')) || '|' || --C19
                            
                             trim(to_char(fdoc.aqpb052mcred,
                                          'FM99999999990.00')) || '|' || --C20
                            
                             trim(to_char(fdoc.aqpb052ncon)) || '|' || --C21
                             trim(to_char(fdoc.aqpb052npol)) || '|' || --C22
                             trim(to_char(fdoc.aqpb052ficob, 'yyyy-mm-dd')) || '|' || --C23
                             trim(to_char(fdoc.aqpb052ffcob, 'yyyy-mm-dd')) || '|' || --C24
                             trim(to_char(fdoc.aqpb052tseg)) || '|' || --C25
                             trim(to_char(fdoc.aqpb052scob,
                                          'FM99999999990.00')) --C26
                            );
        
        end loop;
      
        utl_file.fclose(fhandle);
      
      end loop;
      ---FIN: GENERACIÓN TXT
    
      pd_rpta := 1;
    
    exception
      WHEN NO_DATA_FOUND THEN
        pd_rpta := 0;
    end;
  
    -----=========================================================
  
  exception
    when others then
      pd_rpta := 0;
      --dbms_output.put_line('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
  
  end sp_cr_generacion_archivo_txt;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_concepto_monto(pn_pgc       number,
                             pn_mod       number,
                             pn_suc       number,
                             pn_trx       number,
                             pn_rel       number,
                             pn_fecha     date,
                             pn_fecha_con date,
                             --pn_ore number,
                             pn_tipo number,
                             
                             pn_tip aqpa460.aqpa460tcomf%type,
                             pn_ser aqpa460.aqpa460seri%type,
                             pn_num aqpa460.aqpa460num%type) return number is
    pn_monto number := 0;
    lx_fecha date;
    ld_fecasi date;
  begin
  
    if pn_tip = '13' then
      lx_fecha := pn_fecha;
    else  --si es nota de credito
      lx_fecha := pn_fecha_con;  
   
      --verificar si nc se realizo dia posterior a comprobante 2023.10.10
      begin
           select AQPA465CON
            into ld_fecasi
            from aqpa465 a  
            where (a.aqpa465serie , a.aqpa465corr) in 
            (select distinct AQPA460SDREF, AQPA460NDREF  from aqpa460 b
            where b.aqpa460seri = pn_ser 
            and b.aqpa460num = pn_num);  
      exception when others then
           ld_fecasi := null;                
      end;
      
      if lx_fecha <> ld_fecasi and ld_fecasi is not null then
        lx_fecha := ld_fecasi;
      end if;
      ---fin verificacion extorno 2023.10.10
    end if;
  
    CASE pn_tipo
    
      WHEN 1 THEN
        --- INTERES COMPENSATORIO: 1
        select  /*+all_rows*/ -- 20231017 se agrego
            nvl(sum(t.hcimp1), 0) --total
          into pn_monto
          from fsh016 t
         where t.pgcod = pn_pgc
           and t.hcmod = pn_mod
           and t.hsucor = pn_suc
           and t.htran = pn_trx
           and t.hnrel = pn_rel
           and t.hfcon = lx_fecha
           and t.hrubro in (select x.rubro
                              from fsd014 x
                             where substr(x.rubro, 1, 4) in ('1418', '1428')
                               and x.pmtit = 1
                               and x.pmcap = 4
                               and x.pmpzo = 8
                               and x.pcnivc = 403)
           and t.hcodmo = 2; ---1428, 1418
    
      WHEN 2 THEN
      
        select /*+all_rows*/ -- 20231017 se agrego 
           nvl(sum(f.total), 0)
          into pn_monto
          from (
                ---- INTERES COPENSATORIO VENCIDO O MORA: 2
                select nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in
                       (select x.rubro
                          from fsd014 x
                         where substr(x.rubro, 1, 4) in ('5114', '5124')
                           and x.pmtit = 5
                           and x.pmcap = 1
                           and x.pmpzo = 4
                           and x.pcnivc = 461)
                   and t.hcodmo = 2 ---5124,5114  
                union all
                ---- PENALIDAD: 2
                select /*+all_rows*/ -- 20231017 se agrego
                 nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in
                       (select x.rubro
                          from fsd014 x
                         where substr(x.rubro, 1, 4) in ('5117', '5127')
                           and x.pmtit = 5
                           and x.pmcap = 1
                           and x.pmpzo = 7
                           and x.pcnivc = 461)
                   and t.hcodmo = 2) f;
      
      WHEN 3 THEN
        select /*+all_rows*/ -- 20231017 se agrego
            nvl(sum(f.total), 0)
          into pn_monto
          from (
                --- DESGRAVAMEN: 3
                select /*+all_rows*/ -- 20231017 se agrego 
                    nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000005', '2524020000005')
                   and t.hcodmo = 2
                union all
                ---- SEGURO FAMILIA: 3
                select /*+all_rows*/ -- 20231017 se agrego 
                     nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000013', '2524020000013')
                   and t.hcodmo = 2
                union all
                ---- MICROSEGURO: 3
                select /*+all_rows*/ -- 20231017 se agrego 
                     nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000008', '2524020000008')
                   and t.hcodmo = 2
                union all
                ---- MOVIGAS: 3
                select  /*+all_rows*/ -- 20231017 se agrego      
                nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000002', '2524020000002')
                   and t.hcodmo = 2
                union all
                ---SEGURO AGRICOLA: 3
                select /*+all_rows*/ -- 20231017 se agrego
                  nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000020', '2524020000020')
                   and t.hcodmo = 2
                union all  
                ---MULTIRIESGO: 3
                select /*+all_rows*/ -- 20231017 se agrego
                   nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000015', '2524020000015')
                   and t.hcodmo = 2
                union all 
                ---DESEMPLEO: 3
                select /*+all_rows*/ -- 20231017 se agrego
                   nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000022', '2524020000022')
                   and t.hcodmo = 2
                union all                                               
                ---- GARANTIA: 3
                select /*+all_rows*/ -- 20231017 se agrego
                nvl(sum(t.hcimp1), 0) total
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = lx_fecha
                   and t.hrubro in ('2514020000007', '2524020000007')
                   and t.hcodmo = 2) f;
      
      ELSE
      
        select /*+all_rows*/ -- 20231017 se agrego
         nvl(sum(t.aqpa460total), 0)
          into pn_monto
          from aqpa460 t, fst198 d
         where t.aqpa460pgc = pn_pgc
           and t.aqpa460mod = pn_mod
           and t.aqpa460suc = pn_suc
           and t.aqpa460trx = pn_trx
           and t.aqpa460rel = pn_rel
           and t.aqpa460femi = pn_fecha
           and t.aqpa460tcomf = pn_tip
           and t.aqpa460seri = pn_ser
           and t.aqpa460num = pn_num
           and d.tp1cod = 1
           and d.tp1cod1 = 11120
           and d.tp1corr1 = 8
           and d.tp1corr2 = pn_tipo
           and d.tp1corr3 <> 0
           and (t.aqpa460ore - 100) in (d.tp1nro1);
      
    END case;
  
    return pn_monto;
  
  end fn_concepto_monto;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_tipo_operacion(pn_pgc   number,
                             pn_mod   number,
                             pn_suc   number,
                             pn_trx   number,
                             pn_rel   number,
                             pn_fecha date,
                             pn_tip   aqpa460.aqpa460tcomf%type,
                             pn_ser   aqpa460.aqpa460seri%type,
                             pn_num   aqpa460.aqpa460num%type)
    return varchar2 is
    --  pn_hord number := 0;
    pn_tipope  varchar2(4);
    pn_ordinal number(2);
    pn_fecape  date;
    lc_cta     number;
    lc_oper    number;
  
  begin
  
    begin
      select f.pgfape into pn_fecape from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
    --------
    --Modulo: 30 - creditos ---> tabla fst004
    --Transacciones: 977-Venta Joya Adjudicada    978-Devolución de Joyas      
  
    Begin
    
      select a.sr171trord
        into pn_ordinal
        from fsr171 a
       where a.st171cpcod = 15
         and a.sr171tremp = pn_pgc --1
         and a.sr171trmod = pn_mod --30
         and a.sr171trnro = pn_trx; --100;   
    
    exception
      when others then
        null;
    end;
  
    ----------
    if pn_fecha = pn_fecape then
      begin
      
        select (case
                 when substr(d.rubro, 5, 2) = '02' then
                  '2100'
                 when substr(d.rubro, 5, 2) = '03' and
                      substr(d.rubro, 12, 2) = '15' then
                  '2101'
                 when substr(d.rubro, 5, 2) = '03' and
                      substr(d.rubro, 12, 2) <> '15' then
                  '2102'
                 when substr(d.rubro, 5, 2) = '04' then
                  '0112'
                 when substr(d.rubro, 5, 2) = '11' then
                  '2100'
                 when substr(d.rubro, 5, 2) = '12' then
                  '2100'
                 when substr(d.rubro, 5, 2) = '13' then
                  '2100'
                 when substr(d.rubro, 5, 2) in
                      ('05', '06', '07', '08', '09', '10') then
                  '2100'
                 else
                  --'0000'  -- 
                  '2100'  -- 
               end)
          into pn_tipope
          from fsd016 d
         where d.pgcod = pn_pgc
           and d.itmod = pn_mod
           and d.itsuc = pn_suc
           and d.ittran = pn_trx
           and d.itnrel = pn_rel
           and d.itord = pn_ordinal;
      
      exception
        when others then
          -- Búsqueda en FSH012
          begin
          
            if pn_tip = '13' then
              select distinct x.aqpa463cta, x.aqpa463ope
                into lc_cta, lc_oper
                from aqpa463 x
               where x.aqpa463serie = pn_ser
                 and x.aqpa463corre = pn_num;
            else
              select distinct x.aqpa464cta, x.aqpa464ope
                into lc_cta, lc_oper
                from aqpa464 x
               where x.aqpa464serie = pn_ser
                 and x.aqpa464nro = pn_num;
            end if;
          
            ---
            select distinct (case
                              when substr(x.scrub, 5, 2) = '02' then
                               '2100'
                              when substr(x.scrub, 5, 2) = '03' and
                                   substr(x.scrub, 12, 2) = '15' then
                               '2101'
                              when substr(x.scrub, 5, 2) = '03' and
                                   substr(x.scrub, 12, 2) <> '15' then
                               '2102'
                              when substr(x.scrub, 5, 2) = '04' then
                               '0112'
                              when substr(x.scrub, 5, 2) = '11' then
                               '2100'
                              when substr(x.scrub, 5, 2) = '12' then
                               '2100'
                              when substr(x.scrub, 5, 2) = '13' then
                               '2100'
                              when substr(x.scrub, 5, 2) in
                                   ('05', '06', '07', '08', '09', '10') then
                               '2100'
                              else
                               --'0000'
                               '2100'  -- 
                            end)
              into pn_tipope
              from fsd011 x
             where x.pgcod = pn_pgc
               and x.SCCTA = lc_cta
               and x.SCOPER = lc_oper
                  ---and x.BCFECH = pn_femi
               and x.SCMOD in (select modulo from fst111 where dscod = 50);
          
          end;
        
      end;
    else
      begin
        --------------------
        select (case
                 when substr(d.hrubro, 5, 2) = '02' then
                  '2100'
                 when substr(d.hrubro, 5, 2) = '03' and
                      substr(d.hrubro, 12, 2) = '15' then
                  '2101'
                 when substr(d.hrubro, 5, 2) = '03' and
                      substr(d.hrubro, 12, 2) <> '15' then
                  '2102'
                 when substr(d.hrubro, 5, 2) = '04' then
                  '0112'
                 when substr(d.hrubro, 5, 2) = '11' then
                  '2100'
                 when substr(d.hrubro, 5, 2) = '12' then
                  '2100'
                 when substr(d.hrubro, 5, 2) = '13' then
                  '2100'
                 when substr(d.hrubro, 5, 2) in
                      ('05', '06', '07', '08', '09', '10') then
                  '2100'
                 else
                  --'0000'
                  '2100'  -- 
               end)
          into pn_tipope
          from fsh016 d
         where d.pgcod = pn_pgc
           and d.hcmod = pn_mod
           and d.hsucor = pn_suc
           and d.htran = pn_trx
           and d.hnrel = pn_rel
           and d.hfcon = pn_fecha
           and d.hcord = pn_ordinal;
      
      exception
        when others then
        
          begin
          
            select (case
                     when substr(d.jaqz659rubro, 5, 2) = '02' then
                      '2100'
                     when substr(d.jaqz659rubro, 5, 2) = '03' and
                          substr(d.jaqz659rubro, 12, 2) = '15' then
                      '2101'
                     when substr(d.jaqz659rubro, 5, 2) = '03' and
                          substr(d.jaqz659rubro, 12, 2) <> '15' then
                      '2102'
                     when substr(d.jaqz659rubro, 5, 2) = '04' then
                      '0112'
                     when substr(d.jaqz659rubro, 5, 2) = '11' then
                      '2100'
                     when substr(d.jaqz659rubro, 5, 2) = '12' then
                      '2100'
                     when substr(d.jaqz659rubro, 5, 2) = '13' then
                      '2100'
                     when substr(d.jaqz659rubro, 5, 2) in
                          ('05', '06', '07', '08', '09', '10') then
                      '2100'
                     else
                      --'0000'
                      '2100'  -- 
                   end)
              into pn_tipope
              from jaqz659 d
             where d.jaqz659pgcod = pn_pgc
               and d.jaqz659itmod = pn_mod
               and d.jaqz659itsuc = pn_suc
               and d.jaqz659ittran = pn_trx
               and d.jaqz659itnrel = pn_rel
               and d.jaqz659fecpr = pn_fecha
               and d.jaqz659itord = pn_ordinal;
          
          exception
            when others then
              -- Búsqueda en FSH012
              begin
              
                if pn_tip = '13' then
                  select distinct x.aqpa463cta, x.aqpa463ope
                    into lc_cta, lc_oper
                    from aqpa463 x
                   where x.aqpa463serie = pn_ser
                     and x.aqpa463corre = pn_num;
                else
                  select distinct x.aqpa464cta, x.aqpa464ope
                    into lc_cta, lc_oper
                    from aqpa464 x
                   where x.aqpa464serie = pn_ser
                     and x.aqpa464nro = pn_num;
                end if;
              
                --dbms_output.put_line('lc_cta : ' || lc_cta);
                --dbms_output.put_line('lc_oper : ' || lc_oper);                
                ---
                select distinct (case
                                  when substr(x.BCRUBR, 5, 2) = '02' then
                                   '2100'
                                  when substr(x.BCRUBR, 5, 2) = '03' and
                                       substr(x.BCRUBR, 12, 2) = '15' then
                                   '2101'
                                  when substr(x.BCRUBR, 5, 2) = '03' and
                                       substr(x.BCRUBR, 12, 2) <> '15' then
                                   '2102'
                                  when substr(x.BCRUBR, 5, 2) = '04' then
                                   '0112'
                                  when substr(x.BCRUBR, 5, 2) = '11' then
                                   '2100'
                                  when substr(x.BCRUBR, 5, 2) = '12' then
                                   '2100'
                                  when substr(x.BCRUBR, 5, 2) = '13' then
                                   '2100'
                                  when substr(x.BCRUBR, 5, 2) in
                                       ('05', '06', '07', '08', '09', '10') then
                                   '2100'
                                  else
                                   --'0000'
                                   '2100'  -- 
                                end)
                  into pn_tipope
                  from fsh012 x
                 where x.BCEMP = pn_pgc
                   and x.BCCTA = lc_cta
                   and x.BCOPER = lc_oper
                   and x.BCFECH = pn_fecha
                   and x.BCMOD in
                       (select modulo from fst111 where dscod = 50);
              
              end;
          end;
        
      end;
    
      ---
    
    end if;
    ---->>>>>>>>>
  
    --05/04/2023    dcastro se asigno valor cuando es 0000
    if pn_tipope = '0000' then
      pn_tipope := '2100';
    end if;
    ---------
  
    return pn_tipope;
  
  end fn_tipo_operacion;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_ejecucion_archivo_txt(pd_fecpro  in date,
                                        pd_usuario in varchar2,
                                        pd_rpta    out number,
                                        pd_msje    out varchar2) is
    l_exst number;
    l_diff number;
    l_date date;
    l_dias number;
    ln_guiap number;
    --l_rpta number;
  
  begin
  
    begin
      select case
               when exists (select 'x'
                       from aqpb053 t
                      where t.aqpb053fecha = pd_fecpro
                        and t.aqpb053est = 'E') then
                0
               else
                1
             end
        into l_exst
        from dual;
    exception
      when others then
        null;
    end;
  
    --Obtener cantidad dias habiles
    begin
      select t.tp1nro1
        into l_dias
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 4;
    exception
      when others then
        null;
    end;
  
    --Verificar fecha //CAMBIAR TABLA
    begin
      select (t.pgfape - pd_fecpro)
        into l_diff
        from fst017 t
       where t.pgcod = 1;
      select t.pgfape into l_date from fst017 t where t.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --Procesar dentro de los 7 días hábiles
    if l_diff >= 0 and l_diff <= l_dias then
    
      --Verificar si hay documentos pendientes de envío
      if l_exst = 1 then
        /* 2023.10.17 se comento
        pq_cr_facturacion_generacion.sp_cr_insertar_datos(pd_fecpro,
                                                          pd_rpta);
                                                         */       
        ---se agrego guia 2023.10.17 si esta habilitada ejecutar proceso optimizado sino el antiguo
        begin
           select d.tp1nro1
          into ln_guiap
          from fst198 d
         where d.tp1cod = 1
           and d.tp1cod1 = 11120
           and d.tp1corr1 = 90
           and d.tp1corr2 = 1
           and d.tp1corr3 = 1;
        exception when others then
          ln_guiap := 0;
        end;
        
        if nvl(ln_guiap,0) = 1 then 
          begin --proceso optimizado
                 pq_cr_facturacion_generacion.sp_cr_insertar_datos(pd_fecpro,
                                                            pd_rpta);
          end;
        else          
          begin
                 pq_cr_facturacion_generacion.sp_cr_insertar_datos1(pd_fecpro,
                                                            pd_rpta);                                            
          
          end;                                                  
        end if;
        
        --23.10.17                                                  
      
      
        --Generar archivo *.txt
        if pd_rpta = 1 then
          pq_cr_facturacion_generacion.sp_cr_generacion_archivo_txt(pd_fecpro,
                                                                    pd_usuario,
                                                                    pd_rpta);
        
          --Verificación de la generación del archivo *.txt
          if pd_rpta = 1 then
            pd_msje := 'El archivo fue generado exitosamente.';
            pd_rpta := 1;
          else
            pd_msje := 'No se ha podido generar el archivo.';
            pd_rpta := 0;
          end if;
        
        else
          pd_msje := 'No hay documentos a procesar en esta fecha.';
          pd_rpta := 0;
        end if;
      
      else
        pd_msje := 'Hay documentos pendientes por reportar.';
        pd_rpta := 0;
      end if;
    
    else
      pd_msje := concat('Fecha a declarar fuera de los ',
                        concat(to_char(l_dias), ' días hábiles.'));
      pd_rpta := 0;
    end if;
  
  end sp_cr_ejecucion_archivo_txt;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_capital(pn_pgc       number,
                              pn_mod       number,
                              pn_suc       number,
                              pn_trx       number,
                              pn_rel       number,
                              pn_fecha     date,
                              pn_fecha_con date,
                              pn_tipo      aqpa460.aqpa460tcomf%type,
                              pn_ser       aqpa460.aqpa460seri%type,
                              pn_num       aqpa460.aqpa460num%type)
    return number is
    ld_cta    number;
    ld_oper   number;
    ld_fecoto date;
    --ld_impt number(17,2);
    ld_impt   number;
    ld_sboMin number;
    lx_fecha  date;
    ld_fecasi date;
  
  begin
  
    if pn_tipo = '13' then
      lx_fecha := pn_fecha;
    else
      lx_fecha := pn_fecha_con;
    end if; 
  
    begin
    
      begin
        select /*+all_rows*/ -- 20231017 se agrego
               distinct to_number(substr(t.aqpa460ncont, 1, 9)),
                        to_number(substr(t.aqpa460ncont, 13, 9))
          into ld_cta, ld_oper
          from aqpa460 t
         where t.aqpa460pgc = pn_pgc
           and t.aqpa460mod = pn_mod
           and t.aqpa460suc = pn_suc
           and t.aqpa460trx = pn_trx
           and t.aqpa460rel = pn_rel
           --and t.aqpa460femi = lx_fecha
           and t.aqpa460tcomf = pn_tipo
           and t.aqpa460seri = pn_ser
           and t.aqpa460num = pn_num;
      exception
             when others then
                    --dbms_output.put_line('ERROR LCTA ' || sqlerrm);
                    ld_cta  := null;
                    ld_oper := null;
      end;
    
      -------- 
    
      begin
        select min(aosbop)
          into ld_sboMin
          from fsd010 a
         where a.aomod <> 419
           and a.aocta = ld_cta
           and a.aooper = ld_oper
           and a.aomod in (select modulo from fst111 where dscod = 50);
      exception
        when others then
          --dbms_output.put_line('ERROR SBOMIN ' || sqlerrm);
          ld_sboMin := 0;
      end;
    
      -------------------           
      ld_fecoto := pq_cr_facturacion_generacion.fn_fecha_desembolso(ld_cta,
                                                                    ld_oper);
      -------------------     
      begin
        select a.aoimp
          into ld_impt
          from fsd010 a
         where a.aomod <> 419
           and a.aocta = ld_cta
           and a.aooper = ld_oper
           and a.aosbop = ld_sboMin
           and a.aofval = ld_fecoto
           and a.aomod in (select modulo from fst111 where dscod = 50)
              --and a.aomod not in (33, 200) --- CASTIGADO Y JUDICIAL NO INCLUIDOS
           and a.aomod not in (select t.tp1nro1
                                 from fst198 t
                                where t.tp1cod = 1
                                  and t.tp1cod1 = 11120
                                  and t.tp1corr1 = 9
                                  and t.tp1corr2 = 3
                                  and t.tp1corr3 > 0);
      exception
        when others then
          null;
      end;
    
    exception
      when others then
      
        ld_impt := 0;
    end;
  
    return ld_impt;
  
  end fn_obtener_capital;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_acondcionar_rsocial(pc_razon aqpa460.aqpa460rasoc%type)
   --  20250425 dcastro se modifico para eliminar espacios en blanco duplicados consecutivos.
    return varchar2 is
  
    lc_razon_res aqpa460.aqpa460rasoc%type;
    lc_razon_resI aqpa460.aqpa460rasoc%type;    
  
    cursor cur_caracteres is
    
      select substr(trim(t.tp1desc), 1, 1) incorrecto,
             substr(trim(t.tp1desc), 3, 1) correcto
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 2
         and t.tp1corr3 > 0;
  
  begin
  
    begin
    
     -- lc_razon_res := UPPER(pc_razon); --20250526 dcastro se comento
     --20250526
     lc_razon_resI :=  REGEXP_REPLACE(UPPER(pc_razon) , ' {2,}', ' ');
     lc_razon_res  :=  lc_razon_resI;
     --20250526 
    
      for p in cur_caracteres loop
        lc_razon_res := replace(lc_razon_res, p.incorrecto, p.correcto);
      end loop;
    
    exception
      when others then
         lc_razon_res := UPPER(pc_razon);
     end;
  
    return lc_razon_res;
  
  end fn_acondcionar_rsocial;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_cr_facturae_generar(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_tran  in number,
                                   pn_rel   in number,
                                   pn_con   in date,
                                   lc_tipo  out aqpb056.aqpb056tco%type,
                                   lc_serie out aqpb056.aqpb056ser%type,
                                   lc_corre out aqpb056.aqpb056num%type) is
  
    ln_emp     number(3);
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
    lc_flg     char(1) := 'N';
    lc_flr     char(1);
    ln_rubro   number;
    pn_ordinal number(2);
    lc_flgc    number;
    lc_exis    char(1);
  
    pc_mod  number;
    pc_suc  number;
    pc_tran number;
    pc_rel  number;
    pc_con  date;
  
    lc_coderr char(100);
    lc_msgerr char(1000);
    ln_flag   number;
    pd_pgfape date;
    lc_fverc  char(1);
  
    lc_flag_dae number;
  
  begin
  
    --1. Verificar fecha
    begin
      select pgfape into pd_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --2. Verificar estado de la comisión
    begin
      select c.tp1nro1
        into ln_flag
        from fst198 c
       where c.tp1cod = 1
         and c.tp1cod1 = 11120
         and c.tp1corr1 = 7
         and c.tp1corr2 = 1;
    exception
      when others then
        null;
      
    end;
  
    -- verificar si se puede generar serie y correlativo DAE
    begin
      select t.tp1nro1
        into lc_flag_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 5;
    exception
      when others then
        null;
    end;
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    -- !Importante
    -- Validar activación del Flag para generar serie y correlativo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    if lc_flag_dae = 1 then
      begin
      
        --validar concepto 
        --11120 1 3 Codigos de conc no considerar 
      
        pc_mod  := pn_mod;
        pc_suc  := pn_suc;
        pc_tran := pn_tran;
        pc_rel  := pn_rel;
        pc_con  := pn_con;
      
        --3. validar concepto
        if pd_pgfape = pc_con then
          -- -- -- -- --
          begin
            SELECT count(*)
              into lc_flgc
              FROM fsd016 H, FSR171 F, FST171 G --, fsx016 x
             WHERE H.pgcod = pn_cod
               and h.itmod = pc_mod
               and h.itsuc = pc_suc
               and h.ittran = pc_tran ---401 --972--
               and h.itnrel = pc_rel
                  --AND H.HFCON = pn_con
                  /*
                  and h.pgcod = x.pgcod
                  and h.itsuc = x.hsucor
                  and h.itmod = x.hcmod
                  and h.ittran = x.htran
                  and h.itnrel = x.hnrel
                  and x.hfcon = pc_con
                  */
                  
                  /*and (H.itmod, H.ittran) IN
                  (SELECT A.TP1NRO1, A.TP1NRO2 ----TRX PROCESO BACH
                     FROM FST198 A
                    WHERE A.TP1COD = 1
                      AND A.TP1COD1 = 11120
                      AND A.TP1CORR1 = 4
                      AND A.TP1NRO1 IS NOT NULL)*/
                  
               AND H.Rubro NOT IN (4212290000007, 4222290000007)
                  
               and h.pgcod = F.SR171TREMP
               AND h.itmod = F.SR171TRMOD
               AND h.ittran = F.SR171TRNRO
               AND h.itord = F.SR171TRORD
               AND f.ST171CPCOD = G.ST171CPCOD
                  ---filtro op no conc
               and f.st171cpcod not in
                   (select d.tp1nro1
                      from fst198 d
                     where d.tp1cod = 1
                       and d.tp1cod1 = 11120
                       and d.tp1corr1 = 1
                       and d.tp1corr2 = 3
                       and d.tp1corr3 >= 1)
                  --- Validando conceptos 
                  /*
                  and (x.txoren - 100) in
                      (select distinct d.tp1nro1
                         from fst198 d
                        where d.tp1cod = 1
                          and d.tp1cod1 = 11120
                          and d.tp1corr1 = 8
                             --and d.tp1corr2 = pn_tipo
                          and d.tp1corr3 <> 0)
                          */
                  --- Validando existencia de transacciones en GP
               and (h.itmod, h.ittran) in
                   (select t.tp1nro1, t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp1 = 1);
          exception
            when others then
              null;
          end;
          -- -- -- -- --
        else
          -- -- -- -- --
          begin
            SELECT count(*)
              into lc_flgc
              FROM FSH016 H, FSR171 F, FST171 G --, fsx016 x
             WHERE H.PGCOD = pn_cod
               and h.hcmod = pc_mod
               and h.hsucor = pc_suc
               and h.htran = pc_tran ---401 --972--
               and h.hnrel = pc_rel
               AND H.HFCON = pc_con
                  /*
                  and H.PGCOD = x.pgcod
                  and h.hcmod = x.hcmod
                  and h.hsucor = x.hsucor
                  and h.htran = x.htran ---401 --972--
                  and h.hnrel = x.hnrel
                  AND H.HFCON = x.hfcon
                  */
               and (H.hcmod, H.htran) IN
                   (SELECT A.TP1NRO1, A.TP1NRO2 ----TRX PROCESO BACH
                      FROM FST198 A
                     WHERE A.TP1COD = 1
                       AND A.TP1COD1 = 11120
                       AND A.TP1CORR1 = 4
                       AND A.TP1NRO1 IS NOT NULL)
               AND H.HRUBRO NOT IN (4212290000007, 4222290000007)
                  
               and h.PGCOD = F.SR171TREMP
               AND h.HCMOD = F.SR171TRMOD
               AND h.HTRAN = F.SR171TRNRO
               AND h.HCORD = F.SR171TRORD
               AND f.ST171CPCOD = G.ST171CPCOD
                  ---filtro op no conc
               and f.st171cpcod not in
                   (select d.tp1nro1
                      from fst198 d
                     where d.tp1cod = 1
                       and d.tp1cod1 = 11120
                       and d.tp1corr1 = 1
                       and d.tp1corr2 = 3
                       and d.tp1corr3 >= 1)
                  --- Validando conceptos 
                  /*
                  and (x.txoren - 100) in
                      (select distinct d.tp1nro1
                         from fst198 d
                        where d.tp1cod = 1
                          and d.tp1cod1 = 11120
                          and d.tp1corr1 = 8
                             --and d.tp1corr2 = pn_tipo
                          and d.tp1corr3 <> 0)
                         */
                  --- Validando existencia de transacciones en GP
               and (h.hcmod, h.htran) in
                   (select t.tp1nro1, t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp1 = 1);
          exception
            when others then
              null;
          end;
          -- -- -- -- --
        end if;
      
        --4. Validación del concepto
      
        if lc_flgc > 0 then
        
          --5. Ordinal
          Begin
          
            select a.sr171trord
              into pn_ordinal
              from fsr171 a
             where a.st171cpcod = 15
               and a.sr171tremp = pn_cod --1
               and a.sr171trmod = pc_mod --30
               and a.sr171trnro = pc_tran; --100;   
          exception
            when others then
              null;
          end;
        
          --6. Rubro
          begin
            pq_cr_facturacion_generacion.sp_cr_pk_credito(pc_aqpa465pgcod    => pn_cod,
                                                          pc_aqpa465mod      => pc_mod,
                                                          pc_aqpa465sucorend => pc_suc,
                                                          pc_aqpa465tran     => pc_tran,
                                                          pc_aqpa465rel      => pc_rel,
                                                          pc_aqpa465ord      => pn_ordinal,
                                                          pd_aqpa465con      => pc_con,
                                                          pn_cod             => ln_emp, ----out
                                                          pn_mod             => ln_mod, ----out
                                                          pn_suc             => ln_suc, ----out
                                                          pn_mda             => ln_mda, ----out
                                                          pn_pap             => ln_pap, ----out
                                                          pn_cta             => ln_cta, ----out
                                                          pn_ope             => ln_ope, ----out
                                                          pn_sbo             => ln_sbo, ----out
                                                          pn_top             => ln_top, ----out
                                                          pc_flag            => lc_flg, ----out
                                                          pn_rubro           => ln_rubro); ----out
          
          end;
        
          --dbms_output.put_line('Rubro: ' || ln_rubro);
        
          if lc_flg = 'S' then
          
            ---ln_flag: Comision 
            -- 4: hipotecario
            -- 3: consumo
          
            begin
              select 'S'
                into lc_flr
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11120
                 and t.tp1corr1 = 1
                 and t.tp1corr2 = 23
                 and t.tp1nro1 <> 0
                 and t.tp1nro1 = ln_rubro;
            exception
              when others then
                lc_flr := 'N';
            end;
          
            if (ln_flag = 0 and lc_flr = 'S') or ln_flag = 1 then
              --if (ln_flag = 0 and ln_rubro in (3, 4)) or ln_flag = 1 then
            
              lc_serie := null;
              lc_corre := null;
            
              -- Validar rubros
              begin
                -- Call the function
                lc_fverc := pq_cr_facturacion_generacion.fn_evaluar_conceptos(pn_pgc   => pn_cod,
                                                                              pn_mod   => pn_mod,
                                                                              pn_suc   => pn_suc,
                                                                              pn_trx   => pc_tran,
                                                                              pn_rel   => pn_rel,
                                                                              pn_fecha => pc_con);
              end;
            
              if lc_fverc = 'S' then
                -- 7. Validación de existencia
                Begin
                  select 'S'
                    into lc_exis
                    from aqpb056 a
                   where a.aqpb056pgc = pn_cod
                     and a.aqpb056mod = pc_mod
                     and a.aqpb056suc = pc_suc
                     and a.aqpb056trx = pc_tran
                     and a.aqpb056rel = pc_rel
                     and a.aqpb056fco = pc_con;
                
                exception
                  when others then
                    lc_exis := 'N';
                end;
              
                -- 8. Si no existe el documento
                if lc_exis = 'N' then
                  -- -- -- -- --
                
                  -- 9. Obtener Serie, Numero            
                  begin
                    pq_cr_facturacion.sp_cr_factura_financiero(pn_rubro       => ln_rubro,
                                                               pc_tipo        => 'MOV', --transaccion
                                                               pc_serie       => lc_serie, ---out
                                                               pc_correlativo => lc_corre); ---out
                  
                    --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
                    --dbms_output.put_line('Serie: ' || lc_serie);
                    --dbms_output.put_line('Número: ' || lc_corre);
                  
                  exception
                    when others then
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := trim(sqlerrm);
                    
                  end;
                
                  -- 10.- Insertar comprobante
                  begin
                    lc_tipo := '13';
                  
                    insert into aqpb056
                      (aqpb056tco,
                       aqpb056ser,
                       aqpb056num,
                       aqpb056fem,
                       aqpb056pgc,
                       aqpb056mod,
                       aqpb056suc,
                       aqpb056trx,
                       aqpb056rel,
                       aqpb056fco)
                    values
                      (lc_tipo,
                       lc_serie,
                       lc_corre,
                       pc_con, ---p.hfcon
                       pn_cod, ---p.pgcod,
                       pc_mod, ---p.hcmod,
                       pc_suc, ---p.hsucor,
                       pc_tran, ---p.htran,
                       pc_rel, ---p.hnrel,
                       pc_con ---p.hfcon
                       );
                    commit;
                  exception
                    when others then
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := trim(sqlerrm);
                    
                      insert into aqpa460E
                        (aqpa460eserie,
                         aqpa460ecorr,
                         aqpa460epgcod,
                         aqpa460emod,
                         aqpa460esucorend,
                         aqpa460etran,
                         aqpa460erel,
                         aqpa460econ,
                         aqpa460etip,
                         Aqpa460eacoe,
                         Aqpa460eamsge)
                      values
                        (null,
                         null,
                         pn_cod,
                         pc_mod,
                         pc_suc,
                         pc_tran,
                         pc_rel,
                         pc_con,
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                  end;
                  ----======
                end if;
              
              end if;
            end if;
          
            --end if;
          
          end if;
        
        end if;
      
      end;
    
    end if;
  
  end sp_cr_facturae_generar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_nota_creditoe_generar(ln_cod   in number,
                                        ln_mod   in number,
                                        ln_suc   in number,
                                        ln_trx   in number,
                                        ln_rel   in number,
                                        ln_fcon  in date,
                                        xn_tipo  out aqpb056.aqpb056tco%type,
                                        xn_serie out aqpb056.aqpb056ser%type,
                                        xn_corre out aqpb056.aqpb056num%type) is
    lc_flag         number;
    pn_NRO_RELACION number(5);
    pd_FECHA_TX     date;
    pn_hcmod2       number(5);
    pn_pgcod        number(5);
    pn_hcmod3       number(5);
    pn_hsucor3      number(5);
    pn_htran3       number(5);
    pn_hnrel3       number(5);
    pn_hfcon3       date;
    --pn_esgrav char(1);
  
    ln_rubro        number;
    lc_serieI       char(4);
    lc_correlativoI char(8);
    lc_comision     char(1);
    --lv_tipocre      varchar2(2);
    lv_codtipo char(2);
    lv_doc_ori char(2);
    ln_flag    number;
    lc_exis    char(1);
    pd_pgfape  date;
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    lc_fverc   char(1);
    lc_trxe    char(1);
  
    lc_flag_dae number;
    lc_flr      char(1);
  
  begin
  
    --1. Verificar fecha
    begin
      select pgfape into pd_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --2. Verificar comisión      
    begin
      select c.tp1nro1
        into ln_flag
        from fst198 c
       where c.tp1cod = 1
         and c.tp1cod1 = 11120
         and c.tp1corr1 = 7
         and c.tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    -- verificar si se puede generar serie y correlativo DAE
    begin
      select t.tp1nro1
        into lc_flag_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 5;
    exception
      when others then
        null;
    end;
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    -- !Importante
    -- Validar activación del Flag para generar serie y correlativo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    if lc_flag_dae = 1 then
      begin
      
        ---2. Veririfcar que la transaccion exista    
        --- Solo se evaluarán operaciones de extorno      
        if pd_pgfape = ln_fcon then
          --diario
          begin
            select count(*)
              into lc_flag
              from fsx015 a, FSR170 b, fsd015 c
             where a.hcmod = b.sr170trmod + 500
               and a.htran = b.sr170trnro
               and a.pgcod = 1
               and a.hcmod > 499
               and a.txcod = 0
                  
                  /*and a.pgcod = c.pgcod
                  and a.hcmod = c.hcmod
                  and a.hsucor = c.hsucor
                  and a.htran = c.htran
                  and a.hnrel = c.hnrel
                  and a.hfcon = c.hfcon  */
               and a.pgcod = c.pgcod
               and a.hcmod = c.itmod
               and a.hsucor = c.itsuc
               and a.htran = c.ittran
               and a.hnrel = c.itnrel
               and a.hfcon = c.itfcon
               and a.pgcod = ln_cod
               and a.hcmod = ln_mod
               and a.hsucor = ln_suc
               and a.htran = ln_trx
               and a.hnrel = ln_rel
               and a.hfcon = ln_fcon
               and (a.hcmod, a.htran) in
                   (select (t.tp1nro1 + 500), t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp1 = 1);
          exception
            when others then
              null;
          end;
        else
          --histórico
          begin
            select count(*)
              into lc_flag
              from fsx015 a, FSR170 b, fsh015 c
             where a.hcmod = b.sr170trmod + 500
               and a.htran = b.sr170trnro
               and a.pgcod = 1
               and a.hcmod > 499
               and a.txcod = 0
                  
               and a.pgcod = c.pgcod
               and a.hcmod = c.hcmod
               and a.hsucor = c.hsucor
               and a.htran = c.htran
               and a.hnrel = c.hnrel
               and a.hfcon = c.hfcon
                  
               and a.pgcod = ln_cod
               and a.hcmod = ln_mod
               and a.hsucor = ln_suc
               and a.htran = ln_trx
               and a.hnrel = ln_rel
               and a.hfcon = ln_fcon
                  
               and (a.hcmod, a.htran) in
                   (select (t.tp1nro1 + 500), t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp1 = 1);
          exception
            when others then
              null;
          end;
        end if;
      
        ----
        begin
        
          if lc_flag > 0 then
          
            ---2. Obtener Nrel
            begin
              select f.txtext as NRO_RELACION
                into pn_NRO_RELACION
                from fsx015 f
               where f.hfcon = ln_fcon
                 and f.hcmod = ln_mod
                 and f.htran = ln_trx
                 and f.hnrel = ln_rel
                 and f.hsucor = ln_suc
                 and f.txcod = 0
                 and f.txreng = 1;
            
            exception
              --mod@abr 20180707
              when too_many_rows then
                begin
                  select f.txtext as NRO_RELACION
                    into pn_NRO_RELACION
                    from fsx015 f
                   where f.hfcon = ln_fcon
                     and f.hcmod = ln_mod
                     and f.htran = ln_trx
                     and f.hnrel = ln_rel
                     and f.hsucor = ln_suc
                     and f.txcod = 0
                     and f.txreng = 1
                     and rownum = 1;
                exception
                  when others then
                    pn_NRO_RELACION := null;
                end;
              when others then
                pn_NRO_RELACION := null;
              
            end;
            ---2. Fin
          
            begin
              if pn_NRO_RELACION is not null then
              
                ----3. Obtener Fecha
                begin
                  select to_date(f.txtext, 'DD/MM/RR') as FECHA_TX
                    into pd_FECHA_TX
                    from fsx015 f
                   where f.hfcon = ln_fcon
                     and f.hcmod = ln_mod
                     and f.htran = ln_trx
                     and f.hnrel = ln_rel
                     and f.hsucor = ln_suc
                     and f.txcod = 0
                     and f.txreng = 2;
                exception
                  when others then
                    pd_FECHA_TX := null;
                end;
                -----3. Fin
              
                pn_hcmod2 := ln_mod - 500;
              
                -- 4. obtener transaccion original
                -- 4.1 Verificar si la transacción tiene una excepcion
                begin
                  select 'S'
                    into lc_trxe
                    from fst198 t
                   where t.tp1cod = 1
                     and t.tp1cod1 = 11120
                     and t.tp1corr1 = 10
                     and t.tp1corr2 = 1
                     and t.tp1corr3 <> 0
                     and t.tp1nro1 = pn_hcmod2 --- mod
                     and t.tp1nro2 = ln_trx -- trax
                     and t.tp1imp3 = 1;
                exception
                  when others then
                    lc_trxe := 'N';
                end;
              
                if lc_trxe = 'N' then
                
                  begin
                  
                    select a.pgcod,
                           a.hcmod,
                           a.hsucor,
                           a.htran,
                           a.hnrel,
                           a.hfcon
                      into pn_pgcod,
                           pn_hcmod3,
                           pn_hsucor3,
                           pn_htran3,
                           pn_hnrel3,
                           pn_hfcon3 --clave de transaccion
                      from fsx016 a
                     where a.hcmod = pn_hcmod2 --30
                       and a.htran = ln_trx --100
                       and a.hfcon = pd_FECHA_TX --to_date('20092017', 'ddmmyyyy')
                       and a.hnrel = pn_NRO_RELACION --164
                       and a.hsucor = ln_suc --mod@abr 20180707
                       and rownum = 1;
                  
                  exception
                    when others then
                      pn_pgcod   := null;
                      pn_hcmod3  := null;
                      pn_hsucor3 := null;
                      pn_htran3  := null;
                      pn_hnrel3  := null;
                      pn_hfcon3  := null;
                    
                  end;
                
                else
                  pn_pgcod   := ln_cod;
                  pn_hcmod3  := pn_hcmod2;
                  pn_hsucor3 := ln_suc;
                  pn_htran3  := ln_trx;
                  pn_hnrel3  := pn_NRO_RELACION;
                  pn_hfcon3  := pd_FECHA_TX;
                
                end if;
                ----4. Fin
              
              end if;
            
            end;
          
            --determinar si el tipo de documento origen consideraba los conceptos de interes y/o seguros
            -- Validar rubros
            begin
              -- Call the function
              lc_fverc := pq_cr_facturacion_generacion.fn_evaluar_conceptos(pn_pgc   => pn_pgcod,
                                                                            pn_mod   => pn_hcmod3,
                                                                            pn_suc   => pn_hsucor3,
                                                                            pn_trx   => pn_htran3,
                                                                            pn_rel   => pn_hnrel3,
                                                                            pn_fecha => pn_hfcon3);
            end;
          
            if lc_fverc = 'S' then
            
              --determinar tipo del documento origen
              begin
                select distinct t.aqpb056tco, t.aqpb056ser, t.aqpb056num
                  into lv_doc_ori, lc_serieI, lc_correlativoI
                  from aqpb056 t
                 where t.aqpb056pgc = pn_pgcod
                   and t.aqpb056mod = pn_hcmod3
                   and t.aqpb056suc = pn_hsucor3
                   and t.aqpb056trx = pn_htran3
                   and t.aqpb056rel = pn_hnrel3
                   and t.aqpb056fco = pn_hfcon3
                   and t.aqpb056tco = '13';
              
              exception
                when no_data_found then
                
                  begin
                    select distinct t.aqpb056htcomf,
                                    t.aqpb056hseri,
                                    t.aqpb056hnum
                      into lv_doc_ori, lc_serieI, lc_correlativoI
                      from aqpb056h t
                     where t.aqpb056hpgc = pn_pgcod
                       and t.aqpb056hmod = pn_hcmod3
                       and t.aqpb056hsuc = pn_hsucor3
                       and t.aqpb056htrx = pn_htran3
                       and t.aqpb056hrel = pn_hnrel3
                       and t.aqpb056hfcon = pn_hfcon3
                       and t.aqpb056htcomf = '13';
                  
                  exception
                    when no_data_found then
                    
                      lv_doc_ori      := null;
                      lc_serieI       := null;
                      lc_correlativoI := null;
                  end;
                
              end;
            
              ---Validar si el tipo de documento 
              ---origen es gravado o no gravado        
            
              if lv_doc_ori is not null then
              
                begin
                
                  lv_codtipo := '13';
                  --lv_tipodocu := substr(lc_serieI, 1, 1);
                  --lv_tipocre := substr(lc_serieI, 2, 1);
                
                  ---determinar el rubro
                  begin
                    --- Si la fecha de la NCE es igual a la fecha del DAE
                    if pn_hfcon3 = pd_pgfape then
                    
                      begin
                        select to_number(substr(m.rubro, 5, 2))
                          into ln_rubro
                          from fsd016 m, fsr171 aa
                         where aa.st171cpcod = 15
                           and aa.sr171tremp = 1 --1
                           and aa.sr171trmod = m.itmod --30
                           and aa.sr171trnro = m.ittran
                           and m.PGCOD = pn_pgcod
                           and m.ITSUC = pn_hsucor3
                           and m.ITMOD = pn_hcmod3
                           and m.ITTRAN = pn_htran3
                           and m.ITNREL = pn_hnrel3
                           and m.ITORD = aa.sr171trord
                           and rownum = 1;
                      exception
                        when others then
                          ln_rubro := null;
                      end;
                    else
                      begin
                        select to_number(substr(m.hrubro, 5, 2))
                          into ln_rubro
                          from fsh016 m, fsr171 aa
                         where aa.st171cpcod = 15
                           and aa.sr171tremp = 1 --1
                           and aa.sr171trmod = m.hcmod --30
                           and aa.sr171trnro = m.htran
                           and m.PGCOD = pn_pgcod
                           and m.hsucor = pn_hsucor3
                           and m.hcmod = pn_hcmod3
                           and m.htran = pn_htran3
                           and m.hnrel = pn_hnrel3
                           and m.hfcon = pn_hfcon3
                           and m.hcord = aa.sr171trord
                           and rownum = 1;
                      exception
                        when others then
                          --ln_rubro := null;
                        
                          begin
                          
                            select distinct x.aqpa463tcre
                              into ln_rubro
                              from aqpa463 x
                             where x.aqpa463pgcod = pn_pgcod
                               and x.aqpa463hcmod = pn_hcmod3
                               and x.aqpa463hsucor = pn_hsucor3
                               and x.aqpa463htran = pn_htran3
                               and x.aqpa463hnrel = pn_hnrel3
                               and x.aqpa463hfcon = pn_hfcon3;
                          
                          exception
                            when others then
                              ln_rubro := null;
                            
                          end;
                      end;
                    end if;
                  
                  end;
                
                  --determinar si es comision
                  begin
                    select 'S'
                      into lc_comision
                      from fst198 h
                     where h.tp1cod = 1
                       and h.tp1cod1 = 11120
                       and h.tp1corr1 = 3
                       and h.tp1corr2 = 1
                       and h.tp1nro1 = pn_hcmod3
                       and h.tp1nro2 = pn_htran3
                       and rownum = 1;
                  exception
                    when others then
                      lc_comision := 'N';
                  end;
                
                  if lc_comision = 'S' then
                    ln_rubro := 1;
                  end if;
                
                  -- b. Determinar si el rubro es considerado
                  begin
                    select 'S'
                      into lc_flr
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 1
                       and t.tp1corr2 = 23
                       and t.tp1nro1 <> 0
                       and t.tp1nro1 = ln_rubro;
                  exception
                    when others then
                      lc_flr := 'N';
                  end;
                
                  ---6. Obtener documentación para los hipotecarios
                  --if (lv_tipocre in ('H', 'F') and ln_flag = 0) or ln_flag = 1 then
                  if (lc_flr = 'S' and ln_flag = 0) or ln_flag = 1 then
                  
                    --Seleccionar tipo de documento    !!3
                    --  lv_tipo_doc := '87';
                  
                    ---8. Obtener la serie y el número
                    begin
                      --if pn_esgrav='N' then
                    
                      -- 9. Verificar si existe
                      Begin
                        select 'S'
                          into lc_exis
                          from aqpb056 a
                         where a.aqpb056pgc = ln_cod
                           and a.aqpb056mod = ln_mod
                           and a.aqpb056suc = ln_suc
                           and a.aqpb056trx = ln_trx
                           and a.aqpb056rel = ln_rel
                           and a.aqpb056fco = ln_fcon;
                      
                      exception
                        when others then
                          lc_exis := 'N';
                      end;
                    
                      --lc_exis := 'N';
                      -- -- -- -- 
                      if lc_exis = 'N' then
                      
                        PQ_CR_FACTURACION.sp_cr_factura_financiero(ln_rubro,
                                                                   'NC',
                                                                   xn_serie,
                                                                   xn_corre);
                      
                        begin
                        
                          ---===========================                                            
                          ---Resultado
                          ---===========================
                          xn_tipo := '87';
                        
                          ---Inserción de la NC
                          insert into aqpb056
                            (aqpb056tco,
                             aqpb056ser,
                             aqpb056num,
                             aqpb056fem,
                             
                             aqpb056pgc,
                             aqpb056mod,
                             aqpb056suc,
                             aqpb056trx,
                             aqpb056rel,
                             aqpb056fco,
                             
                             aqpb056tce,
                             aqpb056see,
                             aqpb056nro,
                             
                             aqpb056pge,
                             aqpb056moe,
                             aqpb056sue,
                             aqpb056tre,
                             aqpb056ree,
                             aqpb056fce)
                          values
                            (xn_tipo,
                             xn_serie,
                             xn_corre,
                             ln_fcon,
                             
                             ln_cod, ---aqpa460pgce,
                             ln_mod, ---aqpa460mode,
                             ln_suc, ---aqpa460suce,
                             ln_trx, ---aqpa460trxe,
                             ln_rel, ---aqpa460rele,
                             ln_fcon, ---aqpa460fcone
                             
                             lv_codtipo,
                             lc_serieI,
                             lc_correlativoI,
                             
                             pn_pgcod, ---p.pgcod,
                             pn_hcmod3, ---p.hcmod,
                             pn_hsucor3, ---p.hsucor,
                             pn_htran3, ---p.htran,
                             pn_hnrel3, ---p.hnrel,
                             pn_hfcon3 ---p.hfcon
                             
                             );
                          commit;
                        
                        exception
                          when others then
                          
                            lc_coderr := sqlcode;
                            lc_msgerr := trim(sqlerrm);
                          
                            insert into aqpa460E
                              (aqpa460eserie,
                               aqpa460ecorr,
                               aqpa460epgcod,
                               aqpa460emod,
                               aqpa460esucorend,
                               aqpa460etran,
                               aqpa460erel,
                               aqpa460econ,
                               aqpa460etip,
                               Aqpa460eacoe,
                               Aqpa460eamsge)
                            values
                              (null,
                               null,
                               ln_cod,
                               ln_mod,
                               ln_suc,
                               ln_trx,
                               ln_rel,
                               ln_fcon,
                               'S',
                               lc_coderr,
                               lc_msgerr);
                            commit;
                          
                        end;
                      
                      end if;
                      -- -- -- --                           
                    
                    end;
                    ---8. Fin
                  
                  end if;
                  ---6. Fin           
                end;
              end if;
            
            end if;
          
          end if;
        end;
        ----    
      
      end;
    
    end if;
  
  end sp_cr_nota_creditoe_generar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_insertar_libro_ventas(pn_fecha in date) is
  
    -- pn_fecha     date; -- <======= 1. VARIABLE DE ENTRADA
    pr_flag      number;
    lc_fecha_fin date;
    lc_fecha_ini date;
    lc_coderr    char(100);
    lc_msgerr    char(1000);
  
    laqpa460item   number;
    laqpa460desc   varchar2(50);
    laqpa460tcomf  varchar2(2);
    laqpa460seri   varchar2(4);
    laqpa460num    number;
    laqpa460tdocr  varchar2(1);
    laqpa460nruc   varchar2(15);
    laqpa460rasoc  varchar2(1500);
    laqpa460fdref  varchar2(10);
    laqpa460mtotal number;
    laqpa460mtimp  number;
    laqpa460mtinf  number;
    laqpa460impt   number;
    laqpa460mone   varchar2(3);
    laqpa460tcam   number;
    laqpa460tcomp  number;
    laqpa460sdref  varchar2(50);
    laqpa460ndref  number;
    laqpa460csuna  varchar2(8);
    ltcam          number(14, 8);
    ltipcam        number(14, 8);
    ld_feccam      date;
    ld_fechaemi    date;
    ld_fecha       date;
    lc_estado      char(1);
  
    lc_minimo   varchar2(50); -- 15.04.2023 dcastro se agrego
    ln_cantitem number;
  
    cursor datos_a(fecha_ini date) is
      select /* +all_rows*/
       aqpa470serie, aqpa470nro, aqpa470total, aqpa470con
        from aqpa470 a
       where a.aqpa470femi >= fecha_ini;
  
    cursor datos_item(fecha_ini date) is
      select /* +all_rows*/
      distinct aqpa470serie, aqpa470nro
        from aqpa470 a
       where a.aqpa470femi >= fecha_ini;
  
    ---select * from aqpa470 a where a.aqpa470femi = fecha_ini;
  
    cursor movimientos_fa(fecini date, fecfin date) is
      select /* +all_rows*/
      distinct a.aqpa465serie,
               a.aqpa465corr,
               a.aqpa465con,
               a.aqpa465pgcod,
               a.aqpa465mod,
               a.aqpa465sucor,
               a.aqpa465tran,
               a.aqpa465rel,
               a.aqpa465est,
               b.aqpa460femi
      /* from AQPA465 a
      where a.aqpa465con >= lc_fecha_ini
        and a.aqpa465con <= lc_fecha_fin*/
        from AQPA465 a, aqpa460 b
       where b.aqpa460seri = a.aqpa465serie
         and b.aqpa460num = a.aqpa465corr
         and a.aqpa465con >= fecini
         and a.aqpa465con <= fecfin
      union
      select /* +all_rows*/
      distinct a.aqpa465serie,
               a.aqpa465corr,
               a.aqpa465con,
               a.aqpa465pgcod,
               a.aqpa465mod,
               a.aqpa465sucor,
               a.aqpa465tran,
               a.aqpa465rel,
               a.aqpa465est,
               b.aqpa460femi
        from AQPA465 a, aqpa460 b
       where b.aqpa460seri = a.aqpa465serie
         and b.aqpa460num = a.aqpa465corr
         and b.aqpa460femi >= fecini
         and b.aqpa460femi <= fecfin -- 20221029 se agrego validacion con aqpa460 y aqpa465
         and a.aqpa465con < fecini;
  
    cursor movimientos_nc(fecini date, fecfin date) is
      select /* +all_rows*/
      distinct a.aqpa466serie,
               a.aqpa466corr,
               a.aqpa466con, --a.aqpa466pgcod , a.aqpa466mod, a.aqpa466sucor, a.aqpa466tran, a.aqpa466rel ,
               b.aqpa460femi,
               aqpa460fcone, /*b.aqpa460fcone,*/
               b.aqpa460pgce,
               b.aqpa460mode,
               b.aqpa460suce,
               b.aqpa460trxe,
               b.aqpa460rele
        from AQPA466 a, aqpa460 b
       where b.aqpa460seri = a.aqpa466serie
         and b.aqpa460num = a.aqpa466corr
         and a.aqpa466con >= fecini
         and a.aqpa466con <= fecfin
      union
      select /* +all_rows*/
      distinct a.aqpa466serie,
               a.aqpa466corr,
               a.aqpa466con, --a.aqpa466pgcod , a.aqpa466mod, a.aqpa466sucor, a.aqpa466tran, a.aqpa466rel ,
               b.aqpa460femi, /*b.aqpa460fcone,*/
               a.aqpa466con aqpa460fcone, /*b.aqpa460fcone,*/
               b.aqpa460pgce,
               b.aqpa460mode,
               b.aqpa460suce,
               b.aqpa460trxe,
               b.aqpa460rele
        from AQPA466 a, aqpa460 b
       where b.aqpa460seri = a.aqpa466serie
         and b.aqpa460num = a.aqpa466corr
         and b.aqpa460femi >= fecini
         and b.aqpa460femi <= fecfin
         and a.aqpa466con < fecini;
  
  begin
  
    --    pn_fecha     := to_date('2022.07.01', 'yyyy.mm.dd'); -- <======= 1. VARIABLE DE ENTRADA
    lc_fecha_fin := pn_fecha - 1;
    lc_fecha_ini := trunc(lc_fecha_fin) -
                    (to_number(to_char(lc_fecha_fin, 'DD')) - 1);
  
    begin
      select t.tp1nro1 -- <======= 2. FLAG para activar el procesamiento del libro de ventas
        into pr_flag
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 2;
    exception
      when others then
        pr_flag := null;
    end;
  
    pr_flag := 1; -- <======= 2. En esta ocasi?n, se fija el valor en 1
  
    if (last_day(lc_fecha_fin) - lc_fecha_fin) = 0 and pr_flag = 1 then
      --if pr_flag = 1 then
    
      --Eliminar datos
    
      delete from AQPA470 t
       where t.aqpa470femi >= lc_fecha_ini
         and t.aqpa470femi <= lc_fecha_fin;
      --20221029 se cambio con fecha de emision
      --t.aqpa470con = lc_fecha_ini;
      commit;
    
      -----*******CARGA MASIVA REGULARIZACION FACTURACION y NOTA DE CREDITO ************************-------------
    
      for i in movimientos_fa(lc_fecha_ini, lc_fecha_fin) loop
        begin
          insert into AQPA470
            (aqpa470serie,
             aqpa470nro,
             aqpa470seri,
             aqpa470num,
             aqpa470pgcod,
             aqpa470mod,
             aqpa470sucor,
             aqpa470tran,
             aqpa470rel,
             aqpa470con,
             aqpa470femi,
             AQPA470LEST,
             aqpa470cord,
             aqpa470subo,
             aqpa470ind,
             aqpa470total,
             aqpa470vvun,
             aqpa470vvuig,
             aqpa470prvit,
             aqpa470mbim,
             aqpa470rubro,
             AQPA470CCOS)
          
            select i.aqpa465serie,
                   i.aqpa465corr,
                   i.aqpa465serie,
                   i.aqpa465corr,
                   i.aqpa465pgcod,
                   i.aqpa465mod,
                   i.aqpa465sucor,
                   i.aqpa465tran,
                   i.aqpa465rel,
                   i.aqpa465con,
                   i.aqpa460femi, ---aqpa465con,---verificar
                   i.aqpa465est,
                   y.hcord,
                   y.hcsubo,
                   y.hcodmo,
                   y.hcimp1,
                   y.hcimp1,
                   y.hcimp1,
                   y.hcimp1,
                   0,
                   y.hrubro,
                   y.hsucur
              from fsh016 Y
             where y.pgcod = i.aqpa465pgcod
               and y.hcmod = i.aqpa465mod
               and y.hsucor = i.aqpa465sucor
               and y.htran = i.aqpa465tran
               and y.hnrel = i.aqpa465rel
               and y.hfcon = i.aqpa465con;
          commit;
        exception
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
        end;
      
      end loop;
      --NC
      for i in movimientos_nc(lc_fecha_ini, lc_fecha_fin) loop
        begin
          insert into AQPA470
            (aqpa470serie,
             aqpa470nro,
             aqpa470seri,
             aqpa470num,
             aqpa470pgcod,
             aqpa470mod,
             aqpa470sucor,
             aqpa470tran,
             aqpa470rel,
             aqpa470con,
             aqpa470femi,
             aqpa470cord,
             aqpa470subo,
             aqpa470ind,
             aqpa470total,
             aqpa470vvun,
             aqpa470vvuig,
             aqpa470prvit,
             aqpa470mbim,
             aqpa470rubro,
             AQPA470CCOS)
          
            select i.aqpa466serie,
                   i.aqpa466corr,
                   i.aqpa466serie,
                   i.aqpa466corr, --x.aqpa466pgcod , x.aqpa466mod, x.aqpa466sucor, x.aqpa466tran, x.aqpa466rel, x.aqpa466con,x.aqpa466con,
                   i.aqpa460pgce,
                   i.aqpa460mode,
                   i.aqpa460suce,
                   i.aqpa460trxe,
                   i.aqpa460rele,
                   i.aqpa460fcone,
                   i.aqpa460femi,
                   y.hcord,
                   y.hcsubo,
                   y.hcodmo,
                   y.hcimp1,
                   y.hcimp1,
                   y.hcimp1,
                   y.hcimp1,
                   0,
                   y.hrubro,
                   y.hsucur
              from fsh016 Y
             where y.pgcod = i.aqpa460pgce
               and y.hcmod = i.aqpa460mode
               and y.hsucor = i.aqpa460suce
               and y.htran = i.aqpa460trxe
               and y.hnrel = i.aqpa460rele
               and y.hfcon = i.aqpa460fcone ---se modifico campo
               and substr(y.hrubro, 1, 4) not in ('1418', '1428');
          commit;
        exception
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
        end;
      
      end loop;
    
      ------****----PASO 2
      ---------------------
      for i in datos_a(lc_fecha_ini) loop
      
        ld_fecha := i.aqpa470con;
      
        begin
          select aqpa460tcomf,
                 aqpa460seri,
                 aqpa460num,
                 aqpa460tdocr,
                 aqpa460nruc,
                 aqpa460rasoc,
                 aqpa460fdref,
                 aqpa460mtotal,
                 aqpa460mtimp,
                 aqpa460mtinf,
                 aqpa460impt,
                 aqpa460mone,
                 aqpa460tcomp,
                 aqpa460sdref,
                 aqpa460ndref,
                 aqpa460csuna,
                 aqpa460femi
            into laqpa460tcomf,
                 laqpa460seri,
                 laqpa460num,
                 laqpa460tdocr,
                 laqpa460nruc,
                 laqpa460rasoc,
                 laqpa460fdref,
                 laqpa460mtotal,
                 laqpa460mtimp,
                 laqpa460mtinf,
                 laqpa460impt,
                 laqpa460mone,
                 laqpa460tcomp,
                 laqpa460sdref,
                 laqpa460ndref,
                 laqpa460csuna,
                 ld_fechaemi
            from aqpa460 b
           where b.aqpa460seri = i.aqpa470serie
             and b.aqpa460num = i.aqpa470nro
             and rownum = 1;
        
        exception
          when others then
            laqpa460tcomf  := null;
            laqpa460seri   := null;
            laqpa460num    := null;
            laqpa460tdocr  := null;
            laqpa460nruc   := null;
            laqpa460rasoc  := null;
            laqpa460fdref  := null;
            laqpa460mtotal := null;
            laqpa460mtimp  := null;
            laqpa460mtinf  := null;
            laqpa460impt   := null;
            laqpa460mone   := null;
            laqpa460tcam   := null;
            laqpa460tcomp  := null;
            laqpa460sdref  := null;
            laqpa460ndref  := null;
            laqpa460csuna  := null;
            ld_fechaemi    := null;
          
        end;
      
        if laqpa460nruc is not null then
          --si es diferente de nulo ACTUALIZA LA DATA 
        
          if i.aqpa470serie in ('FC01', 'BC01', 'FG01', 'FT01') then
          
            begin
              select b.aqpa466est
                into lc_estado
                from aqpa466 b
               where b.aqpa466serie = i.aqpa470serie
                 and b.aqpa466corr = i.aqpa470nro;
            exception
              when others then
                lc_estado := null;
            end;
          
          else
          
            begin
              select b.aqpa465est
                into lc_estado
                from aqpa465 b
               where b.aqpa465serie = i.aqpa470serie
                 and b.aqpa465corr = i.aqpa470nro;
            exception
              when others then
                lc_estado := null;
            end;
          
          end if;
        
          --obtiene valor de estado
          if lc_estado is not null then
            if lc_estado = 'E' then
              lc_estado := 'R';
            end if;
          else
            lc_estado := 'R';
          end if;
        
          --actualizando todos los registros del asiento
          begin
            update aqpa470 b
               set aqpa470tcomf = laqpa460tcomf,
                   aqpa470tdocr = laqpa460tdocr,
                   aqpa470nruc  = laqpa460nruc,
                   aqpa470rasoc = laqpa460rasoc,
                   aqpa470fdref = laqpa460fdref,
                   aqpa470mone  = laqpa460mone,
                   aqpa470tcomp = laqpa460tcomp,
                   aqpa470sdref = laqpa460sdref,
                   aqpa470ndref = laqpa460ndref,
                   aqpa470csuna = laqpa460csuna,
                   --                     aqpa470tcam   = ltipcam,
                   aqpa470mtotal = laqpa460mtotal,
                   aqpa470mtimp  = laqpa460mtimp,
                   aqpa470mtinf  = laqpa460mtinf,
                   aqpa470impt   = laqpa460impt,
                   aqpa470femi   = ld_fechaemi,
                   aqpa470lest   = lc_estado
            --aqpa470flag   = 'S' usado solo para la regularizacion por SUNAT
             where b.aqpa470seri = i.aqpa470serie
               and b.aqpa470num = i.aqpa470nro
               and b.aqpa470nruc is null;
          
            commit;
          
          exception
            when others then
            
              lc_coderr := sqlcode;
              lc_msgerr := trim(sqlerrm);
          end;
        
        end if;
      
        --actualiza por concepto
        begin
          select aqpa460item, aqpa460desc
            into laqpa460item, laqpa460desc
            from aqpa460 b
           where b.aqpa460seri = i.aqpa470serie
             and b.aqpa460num = i.aqpa470nro
             and b.aqpa460total = i.aqpa470total;
        exception
          when others then
            laqpa460item := null;
            laqpa460desc := null;
        end;
      
        --actualizando todos los registros del asiento
        begin
          update aqpa470 b
             set b.aqpa470item = laqpa460item, b.aqpa470desc = laqpa460desc
           where b.aqpa470seri = i.aqpa470serie
             and b.aqpa470num = i.aqpa470nro
             and b.aqpa470total = i.aqpa470total;
          commit;
        exception
          when others then
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
        end;
      
      --   end if;
      
      end loop;
    
      ---20230711 castro se agrego
      for i in datos_item(lc_fecha_ini) loop
      
        ---15.04.2023 dcastro se agrego
        --verificar item
        begin
          select count(*)
            into ln_cantitem
            from aqpa470 a
           where a.aqpa470serie = i.aqpa470serie
             and a.AQPA470NRO = i.AQPA470NRO
             and a.AQPA470ITEM = 1;
        exception
          when others then
            ln_cantitem := 0;
        end;
      
        if ln_cantitem = 0 then
          begin
            select min(a.AQPA470CORD)
              into lc_minimo
              from aqpa470 a
             where a.aqpa470serie = i.aqpa470serie
               and a.AQPA470NRO = i.AQPA470NRO
               and a.aqpa470rubro not like '9%';
          exception
            when others then
              lc_minimo := null;
          end;
        
          begin
            update aqpa470 a
               set a.AQPA470ITEM = 1
             where a.aqpa470serie = i.aqpa470serie
               and a.AQPA470NRO = i.AQPA470NRO
               and a.AQPA470CORD = lc_minimo;
            commit;
          exception
            when others then
              null;
          end;
        
        elsif ln_cantitem > 1 then
        
          begin
            select min(a.AQPA470CORD)
              into lc_minimo
              from aqpa470 a
             where a.aqpa470serie = i.aqpa470serie
               and a.AQPA470NRO = i.AQPA470NRO
               and a.AQPA470ITEM = 1
               and a.aqpa470rubro not like '9%';
          exception
            when others then
              lc_minimo := null;
          end;
          if lc_minimo = null then
            begin
              select min(a.AQPA470CORD)
                into lc_minimo
                from aqpa470 a
               where a.aqpa470serie = i.aqpa470serie
                 and a.AQPA470NRO = i.AQPA470NRO
                 and a.aqpa470rubro not like '9%';
            exception
              when others then
                lc_minimo := null;
            end;
          end if;
        
          begin
            update aqpa470 a
               set a.AQPA470ITEM = null
             where a.aqpa470serie = i.aqpa470serie
               and a.AQPA470NRO = i.AQPA470NRO
               and a.AQPA470ITEM = 1;
          exception
            when others then
              null;
          end;
        
          begin
            update aqpa470 a
               set a.AQPA470ITEM = 1
             where a.aqpa470serie = i.aqpa470serie
               and a.AQPA470NRO = i.AQPA470NRO
               and a.AQPA470CORD = lc_minimo;
            commit;
          exception
            when others then
              null;
          end;
        
        end if;
      
      -----
      end loop;
    
      ---ACTUALIZAR TIPO CAMBIO 08/12/2022
      ld_fecha := lc_fecha_ini;
    
      for i in 1 .. 31 loop
         --obtener TC  se descomento 06/09/2023     
                   begin
                     select max(conversion_date)
                       into ld_feccam
                       from gl_daily_rates@erp f
                      where conversion_type = 1001
                        and from_currency = 'USD'
                        and to_currency = 'PEN'
                        and conversion_date <= ld_fecha;
                     exception when others then
                       null;
                    end;   
                    
                   begin
                     select conversion_rate
                       into ltcam
                       from gl_daily_rates@erp f
                      where conversion_type = 1001
                        and from_currency = 'USD'
                        and to_currency = 'PEN'
                        and conversion_date = ld_feccam;
                   exception
                     when others then
                       ltcam := null;
                   end;
                   ---fin TC   
        
        ltipcam := ltcam;
      
        begin
          update aqpa470 b
             set aqpa470tcam = ltipcam
          -- where b.aqpa470con = ld_fecha
           where b.aqpa470femi = ld_fecha
             and b.aqpa470mone = 'USD';
          commit;
        exception
          when others then
            null;
        end;
      
        begin
          update aqpa470 b
             set aqpa470tcam = 0
          -- where b.aqpa470con = ld_fecha
           where b.aqpa470femi = ld_fecha
             and b.aqpa470mone = 'PEN';
          commit;
        exception
          when others then
            null;
        end;
      
        ld_fecha := lc_fecha_ini + i;
      
      end loop;
      ----fin actualizar tipo cambio  
    
    end if;
  
  end sp_insertar_libro_ventas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_actualizar_estado_comp(pd_fecpro in date, pd_corr number) is
  
    cursor aqpb053_dae is
      select t.aqpb053fecha fproc, -- Fecha
             t.aqpb053cod   corr, -- Correlativo
             t.aqpb053tcomf tcomf, -- Tipo de documento
             t.aqpb053seri  seri, -- Serie
             t.aqpb053num   num, -- Número
             x.aqpb052pgc   pgc,
             x.aqpb052mod   modu,
             x.aqpb052suc   suc,
             x.aqpb052trx   trx,
             x.aqpb052rel   rel,
             x.aqpb052femi  femi
        from aqpb053 t, aqpb052 x
       where t.aqpb053tcomf = x.aqpb052tcomf
         and t.aqpb053seri = x.aqpb052seri
         and t.aqpb053num = x.aqpb052num
         and t.AQPB053FECHA = pd_fecpro
         and t.AQPB053COD = pd_corr
         and t.AQPB053TCOMF = '13'
         and t.AQPB053EST = 'E';
  
    cursor aqpb053_nce is
      select t.aqpb053fecha fproc, -- Fecha
             t.aqpb053cod   corr, -- Correlativo
             t.aqpb053tcomf tcomf, -- Tipo de documento
             t.aqpb053seri  seri, -- Serie
             t.aqpb053num   num, -- Número
             x.aqpb052pgce  pgc,
             x.aqpb052mode  modu,
             x.aqpb052suce  suc,
             x.aqpb052trxe  trx,
             x.aqpb052rele  rel,
             x.aqpb052femi  femi
        from aqpb053 t, aqpb052 x
       where t.aqpb053tcomf = x.aqpb052tcomf
         and t.aqpb053seri = x.aqpb052seri
         and t.aqpb053num = x.aqpb052num
         and t.AQPB053FECHA = pd_fecpro
         and t.AQPB053COD = pd_corr
         and t.AQPB053TCOMF = '87'
         and t.AQPB053EST = 'E';
  
  begin
  
    begin
    
      -- DAE
      --ln_tdoc := '13';
    
      for p in aqpb053_dae loop
      
        update aqpa465 t
           set t.aqpa465est = 'A'
         where t.AQPA465PGCOD = p.pgc
           and t.AQPA465MOD = p.modu
           and t.AQPA465SUCOR = p.suc
           and t.AQPA465TRAN = p.trx
           and t.AQPA465REL = p.rel
           and t.AQPA465CON = p.femi
           and t.AQPA465EST = 'Z';
        commit;
      
      end loop;
    
      -- NCE
      --ln_tdoc := '87';
    
      for p in aqpb053_nce loop
      
        update aqpa466 t
           set t.aqpa466est = 'A'
         where t.aqpa466pgcod = p.pgc
           and t.AQPA466MOD = p.modu
           and t.AQPA466SUCOR = p.suc
           and t.AQPA466TRAN = p.trx
           and t.AQPA466REL = p.rel
           and t.aqpa466con = p.femi
           and t.aqpa466est = 'Z';
        commit;
      
      end loop;
    
      --- PASO FINAL
      update aqpb053 x
         set x.aqpb053est = 'R'
       where x.aqpb053fecha = pd_fecpro
         and x.aqpb053cod = pd_corr
         and x.aqpb053est = 'E';
      commit;
    
    end;
  end sp_cr_actualizar_estado_comp;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
  function fn_evaluar_conceptos(pn_pgc   number,
                                pn_mod   number,
                                pn_suc   number,
                                pn_trx   number,
                                pn_rel   number,
                                pn_fecha date) return char is
  
    --- Penalidad: 5117 o 5127
    --- Interés compensatorio vencido o mora: 5114:  
    --- Interés compensatorio normal: 1418, 1428             FSD014, plan de cuenta, fsd016 módulo: 403
    --- Seguro Desgravamen: 2514020000005, 2524020000005
    --- Seguro garantia: 2514020000007, 2524020000007
    --- Seguro Movigas: 2514020000002, 2524020000002
    --- Microseguro: 2514020000008, 2524020000008
    --- Familia segura: 2514020000013, 2524020000013
    --  MULTIRIESGO    2514020000015, 2524020000015
    -- Seguro AGRICOLA   2514020000020, 2524020000020
    -- Seguro Desempleo  2514020000022, 2524020000022
  
    -- fsd016 - itdbha= 2
    -- fsh016 - hcodmo=2                                
  
    lc_indc  char(1);
    lc_sumc  NUMBER(17, 2);
    lc_fecha date;
  
  begin
  
    select t.Pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    if lc_fecha = pn_fecha then
    
      begin
        --- INTERES COMPENSATORIO
        begin
          select nvl(sum(t.itimp1), 0)
            into lc_sumc
            from fsd016 t
           where t.pgcod = pn_pgc
             and t.itsuc = pn_suc
             and t.itmod = pn_mod
             and t.ittran = pn_trx
             and t.itnrel = pn_rel
             and t.rubro in
                 (select x.rubro
                    from fsd014 x
                   where substr(x.rubro, 1, 4) in ('1418', '1428')
                     and x.pmtit = 1
                     and x.pmcap = 4
                     and x.pmpzo = 8
                     and x.pcnivc = 403)
             and t.itdbha = 2; ---1428, 1418
        exception
          when others then
            null;
        end;
      
        if lc_sumc = 0 then
          begin
            ---- INTERES COPENSATORIO VENCIDO O MORA
            select nvl(sum(t.itimp1), 0)
              into lc_sumc
              from fsd016 t
             where t.pgcod = pn_pgc
               and t.itsuc = pn_suc
               and t.itmod = pn_mod
               and t.ittran = pn_trx
               and t.itnrel = pn_rel
               and t.rubro in
                   (select x.rubro
                      from fsd014 x
                     where substr(x.rubro, 1, 4) in ('5114', '5124')
                       and x.pmtit = 5
                       and x.pmcap = 1
                       and x.pmpzo = 4
                       and x.pcnivc = 461)
               and t.itdbha = 2; ---5124,5114
          exception
            when others then
              null;
          end;
        
          if lc_sumc = 0 then
            begin
              ---- PENALIDAD
              select nvl(sum(t.itimp1), 0)
                into lc_sumc
                from fsd016 t
               where t.pgcod = pn_pgc
                 and t.itsuc = pn_suc
                 and t.itmod = pn_mod
                 and t.ittran = pn_trx
                 and t.itnrel = pn_rel
                 and t.rubro in
                     (select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5117', '5127')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 7
                         and x.pcnivc = 461)
                 and t.itdbha = 2;
            exception
              when others then
                null;
            end;
          
            if lc_sumc = 0 then
              begin
                ---- desgravamen
                select nvl(sum(t.itimp1), 0)
                  into lc_sumc
                  from fsd016 t
                 where t.pgcod = pn_pgc
                   and t.itsuc = pn_suc
                   and t.itmod = pn_mod
                   and t.ittran = pn_trx
                   and t.itnrel = pn_rel
                   and t.rubro in ('2514020000005', '2524020000005')
                   and t.itdbha = 2;
              exception
                when others then
                  null;
              end;
              if lc_sumc = 0 then
                begin
                  ---- seguro familia
                  select nvl(sum(t.itimp1), 0)
                    into lc_sumc
                    from fsd016 t
                   where t.pgcod = pn_pgc
                     and t.itsuc = pn_suc
                     and t.itmod = pn_mod
                     and t.ittran = pn_trx
                     and t.itnrel = pn_rel
                     and t.rubro in ('2514020000013', '2524020000013')
                     and t.itdbha = 2;
                exception
                  when others then
                    null;
                end;
              
                if lc_sumc = 0 then
                  begin
                    ---- MICROSEGURO
                    select nvl(sum(t.itimp1), 0)
                      into lc_sumc
                      from fsd016 t
                     where t.pgcod = pn_pgc
                       and t.itsuc = pn_suc
                       and t.itmod = pn_mod
                       and t.ittran = pn_trx
                       and t.itnrel = pn_rel
                       and t.rubro in ('2514020000008', '2524020000008')
                       and t.itdbha = 2;
                  exception
                    when others then
                      null;
                  end;
                
                  if lc_sumc = 0 then
                    begin
                      ---- MOVIGAS
                      select nvl(sum(t.itimp1), 0)
                        into lc_sumc
                        from fsd016 t
                       where t.pgcod = pn_pgc
                         and t.itsuc = pn_suc
                         and t.itmod = pn_mod
                         and t.ittran = pn_trx
                         and t.itnrel = pn_rel
                         and t.rubro in ('2514020000002', '2524020000002')
                         and t.itdbha = 2;
                    exception
                      when others then
                        null;
                    end;
                  
                    if lc_sumc = 0 then
                      begin
                        ---- GARANTIA
                        select nvl(sum(t.itimp1), 0)
                          into lc_sumc
                          from fsd016 t
                         where t.pgcod = pn_pgc
                           and t.itsuc = pn_suc
                           and t.itmod = pn_mod
                           and t.ittran = pn_trx
                           and t.itnrel = pn_rel
                           and t.rubro in
                               ('2514020000007', '2524020000007')
                           and t.itdbha = 2;
                      exception
                        when others then
                          null;
                      end;
                      
                      --2023
                      if lc_sumc = 0 then
                        
                        begin
                          ---- MULTIRIESGO
                          select nvl(sum(t.itimp1), 0)
                            into lc_sumc
                            from fsd016 t
                           where t.pgcod = pn_pgc
                             and t.itsuc = pn_suc
                             and t.itmod = pn_mod
                             and t.ittran = pn_trx
                             and t.itnrel = pn_rel
                             and t.rubro in
                                 ('2514020000015', '2524020000015')
                             and t.itdbha = 2;
                        exception
                          when others then
                            null;
                        end;
                        
                        if lc_sumc = 0 then
                                
                            begin
                              ---- AGRICOLA   
                              select nvl(sum(t.itimp1), 0)
                                into lc_sumc
                                from fsd016 t
                               where t.pgcod = pn_pgc
                                 and t.itsuc = pn_suc
                                 and t.itmod = pn_mod
                                 and t.ittran = pn_trx
                                 and t.itnrel = pn_rel
                                 and t.rubro in
                                     ('2514020000020', '2524020000020')
                                 and t.itdbha = 2;
                            exception
                              when others then
                                null;
                            end;
                               
                             if lc_sumc = 0 then
                                    
                                begin
                                  ---- DESEMPLEO   
                                  select nvl(sum(t.itimp1), 0)
                                    into lc_sumc
                                    from fsd016 t
                                   where t.pgcod = pn_pgc
                                     and t.itsuc = pn_suc
                                     and t.itmod = pn_mod
                                     and t.ittran = pn_trx
                                     and t.itnrel = pn_rel
                                     and t.rubro in
                                         ('2514020000022', '2514020000022')
                                     and t.itdbha = 2;
                                exception
                                  when others then
                                    null;
                                end;
                                    
                                
                             end if; 
                            
                         end if;
                    
                       end if;
                      --2023
                      
                    
                    end if;
                  
                  end if;
                
                end if;
              
              end if;
            
            end if;
          
          end if;
        
        end if;
      end;
    
    else
    
      begin
        --- INTERES COMPENSATORIO
        begin
          select nvl(sum(t.hcimp1), 0)
            into lc_sumc
            from fsh016 t
           where t.pgcod = pn_pgc
             and t.hcmod = pn_mod
             and t.hsucor = pn_suc
             and t.htran = pn_trx
             and t.hnrel = pn_rel
             and t.hfcon = pn_fecha
             and t.hrubro in
                 (select x.rubro
                    from fsd014 x
                   where substr(x.rubro, 1, 4) in ('1418', '1428')
                     and x.pmtit = 1
                     and x.pmcap = 4
                     and x.pmpzo = 8
                     and x.pcnivc = 403)
             and t.hcodmo = 2; ---1428, 1418
        exception
          when others then
            null;
        end;
      
        if lc_sumc = 0 then
          begin
            ---- INTERES COPENSATORIO VENCIDO O MORA
            select nvl(sum(t.hcimp1), 0)
              into lc_sumc
              from fsh016 t
             where t.pgcod = pn_pgc
               and t.hcmod = pn_mod
               and t.hsucor = pn_suc
               and t.htran = pn_trx
               and t.hnrel = pn_rel
               and t.hfcon = pn_fecha
               and t.hrubro in
                   (select x.rubro
                      from fsd014 x
                     where substr(x.rubro, 1, 4) in ('5114', '5124')
                       and x.pmtit = 5
                       and x.pmcap = 1
                       and x.pmpzo = 4
                       and x.pcnivc = 461)
               and t.hcodmo = 2; ---5124,5114
          exception
            when others then
              null;
          end;
        
          if lc_sumc = 0 then
            begin
              ---- PENALIDAD
              select nvl(sum(t.hcimp1), 0)
                into lc_sumc
                from fsh016 t
               where t.pgcod = pn_pgc
                 and t.hcmod = pn_mod
                 and t.hsucor = pn_suc
                 and t.htran = pn_trx
                 and t.hnrel = pn_rel
                 and t.hfcon = pn_fecha
                 and t.hrubro in
                     (select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5117', '5127')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 7
                         and x.pcnivc = 461)
                 and t.hcodmo = 2;
            exception
              when others then
                null;
            end;
          
            if lc_sumc = 0 then
              begin
                ---- desgravamen
                select nvl(sum(t.hcimp1), 0)
                  into lc_sumc
                  from fsh016 t
                 where t.pgcod = pn_pgc
                   and t.hcmod = pn_mod
                   and t.hsucor = pn_suc
                   and t.htran = pn_trx
                   and t.hnrel = pn_rel
                   and t.hfcon = pn_fecha
                   and t.hrubro in ('2514020000005', '2524020000005')
                   and t.hcodmo = 2;
              exception
                when others then
                  null;
              end;
            
              if lc_sumc = 0 then
                begin
                  ---- seguro familia
                  select nvl(sum(t.hcimp1), 0)
                    into lc_sumc
                    from fsh016 t
                   where t.pgcod = pn_pgc
                     and t.hcmod = pn_mod
                     and t.hsucor = pn_suc
                     and t.htran = pn_trx
                     and t.hnrel = pn_rel
                     and t.hfcon = pn_fecha
                     and t.hrubro in ('2514020000013', '2524020000013')
                     and t.hcodmo = 2;
                exception
                  when others then
                    null;
                end;
                if lc_sumc = 0 then
                  begin
                    ---- MICROSEGURO
                    select nvl(sum(t.hcimp1), 0)
                      into lc_sumc
                      from fsh016 t
                     where t.pgcod = pn_pgc
                       and t.hcmod = pn_mod
                       and t.hsucor = pn_suc
                       and t.htran = pn_trx
                       and t.hnrel = pn_rel
                       and t.hfcon = pn_fecha
                       and t.hrubro in ('2514020000008', '2524020000008')
                       and t.hcodmo = 2;
                  exception
                    when others then
                      null;
                  end;
                
                  if lc_sumc = 0 then
                    begin
                      ---- MOVIGAS
                      select nvl(sum(t.hcimp1), 0)
                        into lc_sumc
                        from fsh016 t
                       where t.pgcod = pn_pgc
                         and t.hcmod = pn_mod
                         and t.hsucor = pn_suc
                         and t.htran = pn_trx
                         and t.hnrel = pn_rel
                         and t.hfcon = pn_fecha
                         and t.hrubro in ('2514020000002', '2524020000002')
                         and t.hcodmo = 2;
                    exception
                      when others then
                        null;
                    end;
                  
                    if lc_sumc = 0 then
                    
                      begin
                        ---- GARANTIA
                        select nvl(sum(t.hcimp1), 0)
                          into lc_sumc
                          from fsh016 t
                         where t.pgcod = pn_pgc
                           and t.hcmod = pn_mod
                           and t.hsucor = pn_suc
                           and t.htran = pn_trx
                           and t.hnrel = pn_rel
                           and t.hfcon = pn_fecha
                           and t.hrubro in
                               ('2514020000007', '2524020000007')
                           and t.hcodmo = 2;
                      exception
                        when others then
                          null;
                      end;
                    
                    end if;
                  
                  end if;
                
                end if;
              
              end if;
            
            end if;
          
          end if;
        
        end if;
      end;
    
    end if;
  
    if lc_sumc > 0 then
      lc_indc := 'S';
    else
      lc_indc := 'N';
    end if;
    --select distinct substr(x.rubro,1,4)  from fsd014 x where substr(x.rubro,1,4) in ('5117','5127');
    --select distinct substr(x.rubro,1,4) from fsd014 x where 
    --x.pmtit=1 and x.pmcap=4 and x.pmpzo=8 and x.pcnivc=403;  
  
    return lc_indc;
  
  end fn_evaluar_conceptos;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                             
  procedure sp_cr_pk_credito(pc_AQPA465PGCOD    in number,
                             pc_AQPA465MOD      in number,
                             pc_AQPA465SUCOREND in number,
                             pc_AQPA465TRAN     in number,
                             pc_AQPA465REL      in number,
                             pc_AQPA465ORD      in number,
                             pd_AQPA465CON      in date,
                             pn_cod             out number,
                             pn_mod             out number,
                             pn_suc             out number,
                             pn_mda             out number,
                             pn_pap             out number,
                             pn_cta             out number,
                             pn_ope             out number,
                             pn_sbo             out number,
                             pn_top             out number,
                             pc_FLAG            out char,
                             pn_rubro           out number) is
  
    ld_fecape date;
  
    lc_flgCom char(1) := 'N';
  
  BEGIN
  
    begin
      select f.pgfape into ld_fecape from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    if pd_AQPA465CON = ld_fecape then
      -- DIARIO
    
      begin
        select a.pgcod,
               a.modulo,
               a.itsucd,
               a.moneda,
               a.papel,
               a.ctnro,
               a.itoper,
               a.itsubo,
               a.ittope,
               to_number(substr(a.rubro, 5, 2))
          into pn_cod,
               pn_mod,
               pn_suc,
               pn_mda,
               pn_pap,
               pn_cta,
               pn_ope,
               pn_sbo,
               pn_top,
               --lc_hipo,
               pn_rubro
          from fsd016 a
         where a.pgcod = pc_AQPA465PGCOD
           and a.itmod = pc_AQPA465MOD
           and a.itsuc = pc_AQPA465SUCOREND
           and a.ittran = pc_AQPA465TRAN
           and a.itnrel = pc_AQPA465REL
           and a.itord = pc_AQPA465ORD;
      exception
        when others then
          null;
      end;
    
      /*if lc_hipo = '04' then  2018.10.03
           pc_FLAG := 'S';
      else
           pc_FLAG := 'N';
      end if;  
      */
      pc_FLAG := 'S';
    
    else
      --HISTORICO
      begin
        select a.pgcod,
               a.hmodul,
               a.hsucur,
               a.hmda,
               a.hpap,
               a.hcta,
               a.hoper,
               a.hsubop,
               a.htoper,
               to_number(substr(a.hrubro, 5, 2)) ---C5: tipo de operacion
          into pn_cod,
               pn_mod,
               pn_suc,
               pn_mda,
               pn_pap,
               pn_cta,
               pn_ope,
               pn_sbo,
               pn_top,
               --lc_hipo,
               pn_rubro
          from fsh016 a
         where a.pgcod = pc_AQPA465PGCOD
           and a.hcmod = pc_AQPA465MOD
           and a.hsucor = pc_AQPA465SUCOREND
           and a.htran = pc_AQPA465TRAN
           and a.hnrel = pc_AQPA465REL
           and a.hfcon = pd_AQPA465CON
           and a.hcord = pc_AQPA465ORD;
      exception
        when others then
          null;
      end;
    
      pc_FLAG := 'S';
    
      --mod@abr 20180705
      if pn_cod is null then
        begin
          select a.jaqz659pgcod,
                 a.jaqz659modulo,
                 a.jaqz659itsucd,
                 a.jaqz659moneda,
                 a.jaqz659papel,
                 a.jaqz659ctnro,
                 a.jaqz659itoper,
                 a.jaqz659itsubo,
                 a.jaqz659ittope,
                 to_number(substr(a.jaqz659rubro, 5, 2))
            into pn_cod,
                 pn_mod,
                 pn_suc,
                 pn_mda,
                 pn_pap,
                 pn_cta,
                 pn_ope,
                 pn_sbo,
                 pn_top,
                 --lc_hipo
                 pn_rubro
            from jaqz659 a
           where a.jaqz659pgcod = pc_AQPA465PGCOD
             and a.jaqz659itmod = pc_AQPA465MOD
             and a.jaqz659itsuc = pc_AQPA465SUCOREND
             and a.jaqz659ittran = pc_AQPA465TRAN
             and a.jaqz659itnrel = pc_AQPA465REL
             and a.jaqz659fecpr = pd_AQPA465CON
             and a.jaqz659itord = pc_AQPA465ORD;
        exception
          when others then
            null;
        end;
      end if;
      --mod@abr 20180705
    
      /* if lc_hipo = '04' then
                pc_FLAG := 'S';
           else
                pc_FLAG := 'N';
           end if;  
      */
    
    end if;
  
    begin
      ----Transacciones comisiones
      select 'S'
        into lc_flgCom
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11120
         and a.tp1corr1 = 3
         and a.tp1nro1 = pc_AQPA465MOD
         and a.tp1nro2 = pc_AQPA465TRAN;
    exception
      when others then
        lc_flgCom := 'N';
    end;
  
    if lc_flgCom = 'S' then
      pn_rubro := 15; --codigo de comision
    
    end if;
  
    ---modulo 30_ creditos corporativos
    --Transacciones: 977-Venta Joya Adjudicada    978-Devolución de Joyas      
    if pc_AQPA465MOD = 30 and pc_AQPA465TRAN in (977, 978) then
      --se agrego 978 24/12/2018
      pn_rubro := 5;
    end if;
  
    pc_FLAG := 'S'; ---por defecto se graban todas 
  
  end sp_cr_pk_credito;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_desembolso(pc_aqpa463cta in number,
                               pc_aqpa463ope in number) return date is
  
    ld_fecdes date;
    ln_sboMin number;
  
  begin
    /* 
    begin
            select f.aofval
              into ld_fecdes
              from fsd010 f
             where PGCOD =  pc_aqpa463pgcod
               and AOMOD =  pc_aqpa463mod
               and AOSUC =  pc_aqpa463suc
               and AOMDA =  pc_aqpa463mda
               and AOPAP =  pc_aqpa463pap
               and AOCTA =  pc_aqpa463cta
               and AOOPER = pc_aqpa463ope
               and AOSBOP = pc_aqpa463sbo 
               and AOTOPE = pc_aqpa463top;  
    exception when others then
         ld_fecdes := null;    
    end;*/
  
    begin
      select min(aosbop)
        into ln_sboMin
        from fsd010 a
       where a.aomod <> 419
         and a.aocta = pc_aqpa463cta
         and a.aooper = pc_aqpa463ope
         and a.aomod in (select modulo from fst111 where dscod = 50);
    exception
      when others then
        ln_sboMin := 0;
    end;
  
    begin
      select min(aofval)
        into ld_fecdes
        from fsd010 a
       where a.aomod <> 419
         and a.aocta = pc_aqpa463cta
         and a.aooper = pc_aqpa463ope
         and a.aosbop = ln_sboMin
         and a.aomod in (select modulo from fst111 where dscod = 50);
    exception
      when others then
        ld_fecdes := null;
    end;
  
    return ld_fecdes;
  
  end fn_fecha_desembolso;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_facturae_gen_cont(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_tran  in number,
                                    pn_rel   in number,
                                    pn_con   in date,
                                    lc_tipo  out aqpb056.aqpb056tco%type,
                                    lc_serie out aqpb056.aqpb056ser%type,
                                    lc_corre out aqpb056.aqpb056num%type) is
  
    ln_emp     number(3);
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
    lc_flg     char(1) := 'N';
    lc_flr     char(1);
    ln_rubro   number;
    pn_ordinal number(2);
    lc_flgc    number;
    lc_exis    char(1);
  
    pc_mod  number;
    pc_suc  number;
    pc_tran number;
    pc_rel  number;
    pc_con  date;
  
    lc_coderr char(100);
    lc_msgerr char(1000);
    ln_flag   number;
    pd_pgfape date;
    lc_fverc  char(1);
  
    lc_flag_dae number;
    ln_ord      number;
  
  begin
  
    --1. Verificar fecha
    begin
      select pgfape into pd_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --2. Verificar estado de la comisión
    begin
      select c.tp1nro1
        into ln_flag
        from fst198 c
       where c.tp1cod = 1
         and c.tp1cod1 = 11120
         and c.tp1corr1 = 7
         and c.tp1corr2 = 1;
    exception
      when others then
        null;
      
    end;
  
    -- verificar si se puede generar serie y correlativo DAE
    begin
      select t.tp1nro1
        into lc_flag_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 5;
    exception
      when others then
        null;
    end;
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    -- !Importante
    -- Validar activación del Flag para generar serie y correlativo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    if lc_flag_dae = 1 then
      begin
      
        --validar concepto 
        --11120 1 3 Codigos de conc no considerar 
      
        pc_mod  := pn_mod;
        pc_suc  := pn_suc;
        pc_tran := pn_tran;
        pc_rel  := pn_rel;
        pc_con  := pn_con;
      
        --3. validar concepto
        if pd_pgfape = pc_con then
          -- -- -- -- --
          begin
            SELECT count(*)
              into lc_flgc
              FROM fsd016 H, FSR171 F, FST171 G
             WHERE H.pgcod = pn_cod
               and h.itmod = pc_mod
               and h.itsuc = pc_suc
               and h.ittran = pc_tran ---401 --972--
               and h.itnrel = pc_rel
                  
               AND H.Rubro NOT IN (4212290000007, 4222290000007)
                  
               and h.pgcod = F.SR171TREMP
               AND h.itmod = F.SR171TRMOD
               AND h.ittran = F.SR171TRNRO
               AND h.itord = F.SR171TRORD
               AND f.ST171CPCOD = G.ST171CPCOD
                  ---filtro op no conc
               and f.st171cpcod not in
                   (select d.tp1nro1
                      from fst198 d
                     where d.tp1cod = 1
                       and d.tp1cod1 = 11120
                       and d.tp1corr1 = 1
                       and d.tp1corr2 = 3
                       and d.tp1corr3 >= 1)
                  --- Validando conceptos 
                  --- Validando existencia de transacciones en GP
               and (h.itmod, h.ittran) in
                   (select t.tp1nro1, t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp2 = 1);
          exception
            when others then
              null;
          end;
          -- -- -- -- --
        else
          -- -- -- -- --
          begin
            SELECT count(*)
              into lc_flgc
              FROM FSH016 H, FSR171 F, FST171 G
             WHERE H.PGCOD = pn_cod
               and h.hcmod = pc_mod
               and h.hsucor = pc_suc
               and h.htran = pc_tran ---401 --972--
               and h.hnrel = pc_rel
               AND H.HFCON = pc_con
                  
               and (H.hcmod, H.htran) IN
                   (SELECT A.TP1NRO1, A.TP1NRO2 ----TRX PROCESO BACH
                      FROM FST198 A
                     WHERE A.TP1COD = 1
                       AND A.TP1COD1 = 11120
                       AND A.TP1CORR1 = 4
                       AND A.TP1NRO1 IS NOT NULL)
               AND H.HRUBRO NOT IN (4212290000007, 4222290000007)
                  
               and h.PGCOD = F.SR171TREMP
               AND h.HCMOD = F.SR171TRMOD
               AND h.HTRAN = F.SR171TRNRO
               AND h.HCORD = F.SR171TRORD
               AND f.ST171CPCOD = G.ST171CPCOD
                  ---filtro op no conc
               and f.st171cpcod not in
                   (select d.tp1nro1
                      from fst198 d
                     where d.tp1cod = 1
                       and d.tp1cod1 = 11120
                       and d.tp1corr1 = 1
                       and d.tp1corr2 = 3
                       and d.tp1corr3 >= 1)
                  
                  --- Validando existencia de transacciones en GP
               and (h.hcmod, h.htran) in
                   (select t.tp1nro1, t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp2 = 1);
          exception
            when others then
              null;
          end;
          -- -- -- -- --
        end if;
      
        --4. Validación del concepto
      
        if lc_flgc > 0 then
        
          --5. Ordinal
          Begin
          
            select a.sr171trord
              into pn_ordinal
              from fsr171 a
             where a.st171cpcod = 15
               and a.sr171tremp = pn_cod --1
               and a.sr171trmod = pc_mod --30
               and a.sr171trnro = pc_tran; --100;   
          exception
            when others then
              null;
          end;
        
          --6. Rubro
          begin
            pq_cr_facturacion_generacion.sp_cr_pk_credito(pc_aqpa465pgcod    => pn_cod,
                                                          pc_aqpa465mod      => pc_mod,
                                                          pc_aqpa465sucorend => pc_suc,
                                                          pc_aqpa465tran     => pc_tran,
                                                          pc_aqpa465rel      => pc_rel,
                                                          pc_aqpa465ord      => pn_ordinal,
                                                          pd_aqpa465con      => pc_con,
                                                          pn_cod             => ln_emp, ----out
                                                          pn_mod             => ln_mod, ----out
                                                          pn_suc             => ln_suc, ----out
                                                          pn_mda             => ln_mda, ----out
                                                          pn_pap             => ln_pap, ----out
                                                          pn_cta             => ln_cta, ----out
                                                          pn_ope             => ln_ope, ----out
                                                          pn_sbo             => ln_sbo, ----out
                                                          pn_top             => ln_top, ----out
                                                          pc_flag            => lc_flg, ----out
                                                          pn_rubro           => ln_rubro); ----out
          
          end;
        
          --dbms_output.put_line('Rubro: ' || ln_rubro);
        
          if lc_flg = 'S' then
          
            ---ln_flag: Comision 
            -- 4: hipotecario
            -- 3: consumo
          
            begin
              select 'S'
                into lc_flr
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11120
                 and t.tp1corr1 = 1
                 and t.tp1corr2 = 23
                 and t.tp1nro1 <> 0
                 and t.tp1nro1 = ln_rubro;
            exception
              when others then
                lc_flr := 'N';
            end;
          
            if (ln_flag = 0 and lc_flr = 'S') or ln_flag = 1 then
              --if (ln_flag = 0 and ln_rubro in (3, 4)) or ln_flag = 1 then
            
              lc_serie := null;
              lc_corre := null;
            
              -- Validar rubros
              begin
                -- Call the function
                lc_fverc := pq_cr_facturacion_generacion.fn_evaluar_conceptos(pn_pgc   => pn_cod,
                                                                              pn_mod   => pn_mod,
                                                                              pn_suc   => pn_suc,
                                                                              pn_trx   => pc_tran,
                                                                              pn_rel   => pn_rel,
                                                                              pn_fecha => pc_con);
              end;
            
              if lc_fverc = 'S' then
                -- 7. Validación de existencia
                Begin
                  select 'S'
                    into lc_exis
                    from aqpb056 a
                   where a.aqpb056pgc = pn_cod
                     and a.aqpb056mod = pc_mod
                     and a.aqpb056suc = pc_suc
                     and a.aqpb056trx = pc_tran
                     and a.aqpb056rel = pc_rel
                     and a.aqpb056fco = pc_con;
                
                exception
                  when others then
                  
                    begin
                    
                      select 'S'
                        into lc_exis
                        from aqpb056h a
                       where a.aqpb056hpgc = pn_cod
                         and a.aqpb056hmod = pc_mod
                         and a.aqpb056hsuc = pc_suc
                         and a.aqpb056htrx = pc_tran
                         and a.aqpb056hrel = pc_rel
                         and a.aqpb056hfcon = pc_con;
                    exception
                      when others then
                        lc_exis := 'N';
                      
                    end;
                  
                end;
              
                -- 8. Si no existe el documento
                if lc_exis = 'N' then
                  -- -- -- -- --
                
                  -- 9. Obtener Serie, Numero            
                  begin
                    pq_cr_facturacion.sp_cr_factura_financiero(pn_rubro       => ln_rubro,
                                                               pc_tipo        => 'MOV', --transaccion
                                                               pc_serie       => lc_serie, ---out
                                                               pc_correlativo => lc_corre); ---out
                  
                    --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
                    --dbms_output.put_line('Serie: ' || lc_serie);
                    --dbms_output.put_line('Número: ' || lc_corre);
                  
                  exception
                    when others then
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := trim(sqlerrm);
                    
                  end;
                
                  -- 10.- Insertar comprobante
                  begin
                    lc_tipo := '13';
                  
                    insert into aqpb056
                      (aqpb056tco,
                       aqpb056ser,
                       aqpb056num,
                       aqpb056fem,
                       aqpb056pgc,
                       aqpb056mod,
                       aqpb056suc,
                       aqpb056trx,
                       aqpb056rel,
                       aqpb056fco)
                    values
                      (lc_tipo,
                       lc_serie,
                       lc_corre,
                       pc_con, ---p.hfcon
                       pn_cod, ---p.pgcod,
                       pc_mod, ---p.hcmod,
                       pc_suc, ---p.hsucor,
                       pc_tran, ---p.htran,
                       pc_rel, ---p.hnrel,
                       pc_con ---p.hfcon
                       );
                    commit;
                  exception
                    when others then
                    
                      lc_coderr := sqlcode;
                      lc_msgerr := trim(sqlerrm);
                    
                      insert into aqpa460E
                        (aqpa460eserie,
                         aqpa460ecorr,
                         aqpa460epgcod,
                         aqpa460emod,
                         aqpa460esucorend,
                         aqpa460etran,
                         aqpa460erel,
                         aqpa460econ,
                         aqpa460etip,
                         Aqpa460eacoe,
                         Aqpa460eamsge)
                      values
                        (null,
                         null,
                         pn_cod,
                         pc_mod,
                         pc_suc,
                         pc_tran,
                         pc_rel,
                         pc_con,
                         'S',
                         lc_coderr,
                         lc_msgerr);
                      commit;
                  end;
                
                  -- Obtener ordinal
                  if pd_pgfape = pc_con then
                    begin
                    
                      SELECT t.itord
                        into ln_ord
                        FROM fsd016 t
                       where t.pgcod = pn_cod
                         and t.itmod = pc_mod
                         and t.itsuc = pc_suc
                         and t.ittran = pc_tran
                         and t.itnrel = pc_rel
                            --and t.hfcon = pc_con
                         and (t.itmod, t.ittran, t.itord) in
                             (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                from fst198 x
                               where x.tp1cod = 1
                                 and x.tp1cod1 = 11120
                                 and x.tp1corr1 = 10
                                 and x.tp1corr2 = 2
                                 and x.tp1corr3 <> 0
                                 and x.tp1imp1 = 1
                              
                              );
                    exception
                    
                      when too_many_rows then
                      
                        begin
                          SELECT t.itord
                            into ln_ord
                            FROM fsd016 t
                           where t.pgcod = pn_cod
                             and t.itmod = pc_mod
                             and t.itsuc = pc_suc
                             and t.ittran = pc_tran
                             and t.itnrel = pc_rel
                                --and t.hfcon = pc_con
                             and (t.itmod, t.ittran, t.itord) in
                                 (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                    from fst198 x
                                   where x.tp1cod = 1
                                     and x.tp1cod1 = 11120
                                     and x.tp1corr1 = 10
                                     and x.tp1corr2 = 2
                                     and x.tp1corr3 <> 0
                                     and x.tp1imp1 = 1
                                  
                                  )
                             and rownum = 1;
                        exception
                          when others then
                            ln_ord := null;
                        end;
                      
                      when others then
                        ln_ord := null;
                    end;
                  else
                    begin
                      SELECT t.hcord
                        into ln_ord
                        FROM fsh016 t
                       where t.pgcod = pn_cod
                         and t.hcmod = pc_mod
                         and t.hsucor = pc_suc
                         and t.htran = pc_tran
                         and t.hnrel = pc_rel
                         and t.hfcon = pc_con
                         and (t.hcmod, t.htran, t.hcord) in
                             (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                from fst198 x
                               where x.tp1cod = 1
                                 and x.tp1cod1 = 11120
                                 and x.tp1corr1 = 10
                                 and x.tp1corr2 = 2
                                 and x.tp1corr3 <> 0
                                 and x.tp1imp1 = 1
                              
                              );
                    exception
                    
                      when too_many_rows then
                      
                        begin
                          SELECT t.hcord
                            into ln_ord
                            FROM fsh016 t
                           where t.pgcod = pn_cod
                             and t.hcmod = pc_mod
                             and t.hsucor = pc_suc
                             and t.htran = pc_tran
                             and t.hnrel = pc_rel
                             and t.hfcon = pc_con
                             and (t.hcmod, t.htran, t.hcord) in
                                 (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                    from fst198 x
                                   where x.tp1cod = 1
                                     and x.tp1cod1 = 11120
                                     and x.tp1corr1 = 10
                                     and x.tp1corr2 = 2
                                     and x.tp1corr3 <> 0
                                     and x.tp1imp1 = 1
                                  
                                  )
                             and rownum = 1;
                        exception
                          when others then
                            ln_ord := null;
                        end;
                      
                      when others then
                        ln_ord := null;
                    end;
                  end if;
                
                  if ln_ord is not null then
                  
                    begin
                      -- Inserción tabla de DLYA
                      insert into jaqn950
                        (jaqn950emp,
                         jaqn950fec,
                         jaqn950suc,
                         jaqn950mod,
                         jaqn950trn,
                         jaqn950rel,
                         jaqn950ord,
                         jaqn950sor,
                         jaqn950num,
                         jaqn950nom,
                         jaqn950cor,
                         --jaqn950tex,
                         jaqn950est,
                         jaqn950ai1,
                         jaqn950ai2,
                         jaqn950ai3,
                         --jaqn950an1,
                         --jaqn950an2,
                         --jaqn950an3,
                         --jaqn950ac1,
                         --jaqn950ac2,
                         --jaqn950ac3,
                         jaqn950af1 --,
                         --jaqn950af2,
                         --jaqn950af3
                         )
                      values
                        (pn_cod, ---p.pgcod,
                         pc_con, ---p.hfcon
                         pc_suc, ---p.hsucor,
                         pc_mod, ---p.hcmod,
                         pc_tran, ---p.htran,
                         pc_rel, ---p.hnrel,
                         ln_ord, --- ordinal
                         1, --- orden
                         'NNNN',
                         'NNNN',
                         1,
                         'S',
                         0,
                         0,
                         0,
                         null --pn_cod
                         );
                    exception
                      when others then
                        null;
                    end;
                    commit;
                    ----======                  
                  
                  end if;
                
                end if;
              
              end if;
            end if;
          
            --end if;
          
          end if;
        
        end if;
      
      end;
    
    end if;
  
  end sp_cr_facturae_gen_cont;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_nota_creditoe_gen_cont(ln_cod   in number,
                                         ln_mod   in number,
                                         ln_suc   in number,
                                         ln_trx   in number,
                                         ln_rel   in number,
                                         ln_fcon  in date,
                                         xn_tipo  out aqpb056.aqpb056tco%type,
                                         xn_serie out aqpb056.aqpb056ser%type,
                                         xn_corre out aqpb056.aqpb056num%type) is
    lc_flag         number;
    pn_NRO_RELACION number(5);
    pd_FECHA_TX     date;
    pn_hcmod2       number(5);
    pn_pgcod        number(5);
    pn_hcmod3       number(5);
    pn_hsucor3      number(5);
    pn_htran3       number(5);
    pn_hnrel3       number(5);
    pn_hfcon3       date;
    --pn_esgrav char(1);
  
    ln_rubro        number;
    lc_serieI       char(4);
    lc_correlativoI char(8);
    lc_comision     char(1);
    --lv_tipocre      varchar2(2);
    lv_codtipo char(2);
    lv_doc_ori char(2);
    ln_flag    number;
    lc_exis    char(1);
    pd_pgfape  date;
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    lc_fverc   char(1);
  
    lc_flag_dae number;
    ln_ord      number;
    lc_flr      char(1);
  
  begin
  
    --1. Verificar fecha
    begin
      select pgfape into pd_pgfape from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --2. Verificar comisión      
    begin
      select c.tp1nro1
        into ln_flag
        from fst198 c
       where c.tp1cod = 1
         and c.tp1cod1 = 11120
         and c.tp1corr1 = 7
         and c.tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    -- verificar si se puede generar serie y correlativo DAE
    begin
      select t.tp1nro1
        into lc_flag_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 5;
    exception
      when others then
        null;
    end;
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    -- !Importante
    -- Validar activación del Flag para generar serie y correlativo
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
    if lc_flag_dae = 1 then
      begin
      
        ---2. Veririfcar que la transaccion exista    
        --- Solo se evaluarán operaciones de extorno      
        if pd_pgfape = ln_fcon then
          --diario
          begin
            select count(*)
              into lc_flag
              from fsx015 a, FSR170 b, fsd015 c
             where a.hcmod = b.sr170trmod + 500
               and a.htran = b.sr170trnro
               and a.pgcod = 1
               and a.hcmod > 499
               and a.txcod = 0
               and a.pgcod = c.pgcod
               and a.hcmod = c.itmod
               and a.hsucor = c.itsuc
               and a.htran = c.ittran
               and a.hnrel = c.itnrel
               and a.hfcon = c.itfcon
               and a.pgcod = ln_cod
               and a.hcmod = ln_mod
               and a.hsucor = ln_suc
               and a.htran = ln_trx
               and a.hnrel = ln_rel
               and a.hfcon = ln_fcon
               and (a.hcmod, a.htran) in
                   (select (t.tp1nro1 + 500), t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp2 = 1);
          exception
            when others then
              null;
          end;
        else
          --histórico
          begin
            select count(*)
              into lc_flag
              from fsx015 a, FSR170 b, fsh015 c
             where a.hcmod = b.sr170trmod + 500
               and a.htran = b.sr170trnro
               and a.pgcod = 1
               and a.hcmod > 499
               and a.txcod = 0
               and a.pgcod = c.pgcod
               and a.hcmod = c.hcmod
               and a.hsucor = c.hsucor
               and a.htran = c.htran
               and a.hnrel = c.hnrel
               and a.hfcon = c.hfcon
               and a.pgcod = ln_cod
               and a.hcmod = ln_mod
               and a.hsucor = ln_suc
               and a.htran = ln_trx
               and a.hnrel = ln_rel
               and a.hfcon = ln_fcon
               and (a.hcmod, a.htran) in
                   (select (t.tp1nro1 + 500), t.tp1nro2
                      from fst198 t
                     where t.tp1cod = 1
                       and t.tp1cod1 = 11120
                       and t.tp1corr1 = 10
                       and t.tp1corr2 = 1
                       and t.tp1corr3 <> 0
                       and t.tp1imp2 = 1);
          exception
            when others then
              null;
          end;
        end if;
      
        ----
        begin
        
          if lc_flag > 0 then
          
            ---2. Obtener Nrel
            begin
              select f.txtext as NRO_RELACION
                into pn_NRO_RELACION
                from fsx015 f
               where f.hfcon = ln_fcon
                 and f.hcmod = ln_mod
                 and f.htran = ln_trx
                 and f.hnrel = ln_rel
                 and f.hsucor = ln_suc
                 and f.txcod = 0
                 and f.txreng = 1;
            
            exception
              --mod@abr 20180707
              when too_many_rows then
                begin
                  select f.txtext as NRO_RELACION
                    into pn_NRO_RELACION
                    from fsx015 f
                   where f.hfcon = ln_fcon
                     and f.hcmod = ln_mod
                     and f.htran = ln_trx
                     and f.hnrel = ln_rel
                     and f.hsucor = ln_suc
                     and f.txcod = 0
                     and f.txreng = 1
                     and rownum = 1;
                exception
                  when others then
                    pn_NRO_RELACION := null;
                end;
              when others then
                pn_NRO_RELACION := null;
              
            end;
            ---2. Fin
          
            begin
              if pn_NRO_RELACION is not null then
              
                ----3. Obtener Fecha
                begin
                  select to_date(f.txtext, 'DD/MM/RR') as FECHA_TX
                    into pd_FECHA_TX
                    from fsx015 f
                   where f.hfcon = ln_fcon
                     and f.hcmod = ln_mod
                     and f.htran = ln_trx
                     and f.hnrel = ln_rel
                     and f.hsucor = ln_suc
                     and f.txcod = 0
                     and f.txreng = 2;
                exception
                  when others then
                    pd_FECHA_TX := null;
                end;
                -----3. Fin
              
                pn_hcmod2 := ln_mod - 500;
              
                ----4. obtener transaccion original
                begin
                
                  select a.pgcod,
                         a.hcmod,
                         a.hsucor,
                         a.htran,
                         a.hnrel,
                         a.hfcon
                    into pn_pgcod,
                         pn_hcmod3,
                         pn_hsucor3,
                         pn_htran3,
                         pn_hnrel3,
                         pn_hfcon3 --clave de transaccion
                    from fsx016 a
                   where a.hcmod = pn_hcmod2 --30
                     and a.htran = ln_trx --100
                     and a.hfcon = pd_FECHA_TX --to_date('20092017', 'ddmmyyyy')
                     and a.hnrel = pn_NRO_RELACION --164
                     and a.hsucor = ln_suc --mod@abr 20180707
                     and rownum = 1;
                
                exception
                  when others then
                    pn_hcmod3  := null;
                    pn_hsucor3 := null;
                    pn_htran3  := null;
                    pn_hnrel3  := null;
                    pn_hfcon3  := null;
                  
                end;
                ----4. Fin
              
              end if;
            
            end;
          
            --determinar si el tipo de documento origen consideraba los conceptos de interes y/o seguros
            -- Validar rubros
            begin
              -- Call the function
              lc_fverc := pq_cr_facturacion_generacion.fn_evaluar_conceptos(pn_pgc   => pn_pgcod,
                                                                            pn_mod   => pn_hcmod3,
                                                                            pn_suc   => pn_hsucor3,
                                                                            pn_trx   => pn_htran3,
                                                                            pn_rel   => pn_hnrel3,
                                                                            pn_fecha => pn_hfcon3);
            end;
          
            if lc_fverc = 'S' then
            
              --determinar tipo del documento origen
              begin
                select distinct t.aqpb056tco, t.aqpb056ser, t.aqpb056num
                  into lv_doc_ori, lc_serieI, lc_correlativoI
                  from aqpb056 t
                 where t.aqpb056pgc = pn_pgcod
                   and t.aqpb056mod = pn_hcmod3
                   and t.aqpb056suc = pn_hsucor3
                   and t.aqpb056trx = pn_htran3
                   and t.aqpb056rel = pn_hnrel3
                   and t.aqpb056fco = pn_hfcon3
                   and t.aqpb056tco = '13';
              exception
                when no_data_found then
                  begin
                    select distinct t.aqpb056htcomf,
                                    t.aqpb056hseri,
                                    t.aqpb056hnum
                      into lv_doc_ori, lc_serieI, lc_correlativoI
                      from aqpb056h t
                     where t.aqpb056hpgc = pn_pgcod
                       and t.aqpb056hmod = pn_hcmod3
                       and t.aqpb056hsuc = pn_hsucor3
                       and t.aqpb056htrx = pn_htran3
                       and t.aqpb056hrel = pn_hnrel3
                       and t.aqpb056hfcon = pn_hfcon3
                       and t.aqpb056htcomf = '13';
                  exception
                    when no_data_found then
                    
                      lv_doc_ori      := null;
                      lc_serieI       := null;
                      lc_correlativoI := null;
                  end;
                
              end;
            
              ---Validar si el tipo de documento 
              ---origen es gravado o no gravado        
            
              if lv_doc_ori is not null then
              
                lv_codtipo := '13';
                --lv_tipodocu := substr(lc_serieI, 1, 1);
                --lv_tipocre := substr(lc_serieI, 2, 1);
              
                ---determinar si es hipotecario
                /*
                if lv_tipocre = 'H' then
                  ln_rubro := 4;
                else
                  ln_rubro := 1;
                end if;*/
                ---determinar el rubro
                begin
                  --- Si la fecha de la NCE es igual a la fecha del DAE
                  if pn_hfcon3 = pd_pgfape then
                  
                    begin
                      select to_number(substr(m.rubro, 5, 2))
                        into ln_rubro
                        from fsd016 m, fsr171 aa
                       where aa.st171cpcod = 15
                         and aa.sr171tremp = 1 --1
                         and aa.sr171trmod = m.itmod --30
                         and aa.sr171trnro = m.ittran
                         and m.PGCOD = pn_pgcod
                         and m.ITSUC = pn_hsucor3
                         and m.ITMOD = pn_hcmod3
                         and m.ITTRAN = pn_htran3
                         and m.ITNREL = pn_hnrel3
                         and m.ITORD = aa.sr171trord
                         and rownum = 1;
                    exception
                      when others then
                        ln_rubro := null;
                    end;
                  else
                  
                    begin
                      select to_number(substr(m.hrubro, 5, 2))
                        into ln_rubro
                        from fsh016 m, fsr171 aa
                       where aa.st171cpcod = 15
                         and aa.sr171tremp = 1 --1
                         and aa.sr171trmod = m.hcmod --30
                         and aa.sr171trnro = m.htran
                         and m.PGCOD = pn_pgcod
                         and m.hsucor = pn_hsucor3
                         and m.hcmod = pn_hcmod3
                         and m.htran = pn_htran3
                         and m.hnrel = pn_hnrel3
                         and m.hfcon = pn_hfcon3
                         and m.hcord = aa.sr171trord
                         and rownum = 1;
                    exception
                      when others then
                        begin
                          select distinct x.aqpa463tcre
                            into ln_rubro
                            from aqpa463 x
                           where x.aqpa463pgcod = pn_pgcod
                             and x.aqpa463hcmod = pn_hcmod3
                             and x.aqpa463hsucor = pn_hsucor3
                             and x.aqpa463htran = pn_htran3
                             and x.aqpa463hnrel = pn_hnrel3
                             and x.aqpa463hfcon = pn_hfcon3;
                        exception
                          when others then
                            ln_rubro := null;
                        end;
                    end;
                  end if;
                
                end;
              
                --determinar si es comision
                begin
                  select 'S'
                    into lc_comision
                    from fst198 h
                   where h.tp1cod = 1
                     and h.tp1cod1 = 11120
                     and h.tp1corr1 = 3
                     and h.tp1corr2 = 1
                     and h.tp1nro1 = pn_hcmod3
                     and h.tp1nro2 = pn_htran3
                     and rownum = 1;
                exception
                  when others then
                    lc_comision := 'N';
                end;
              
                if lc_comision = 'S' then
                  ln_rubro := 1;
                end if;
              
                -- b. Determinar si el rubro es considerado
                begin
                  select 'S'
                    into lc_flr
                    from fst198 t
                   where t.tp1cod = 1
                     and t.tp1cod1 = 11120
                     and t.tp1corr1 = 1
                     and t.tp1corr2 = 23
                     and t.tp1nro1 <> 0
                     and t.tp1nro1 = ln_rubro;
                exception
                  when others then
                    lc_flr := 'N';
                end;
              
                ---6. Obtener documentación para los hipotecarios
                --if (lv_tipocre in ('H', 'F') and ln_flag = 0) or
                if (lc_flr = 'S' and ln_flag = 0) or ln_flag = 1 then
                
                  --Seleccionar tipo de documento    !!3
                
                  ---8. Obtener la serie y el número
                  begin
                    --if pn_esgrav='N' then
                  
                    -- 9. Verificar si existe
                    Begin
                      select 'S'
                        into lc_exis
                        from aqpb056 a
                       where a.aqpb056pgc = ln_cod
                         and a.aqpb056mod = ln_mod
                         and a.aqpb056suc = ln_suc
                         and a.aqpb056trx = ln_trx
                         and a.aqpb056rel = ln_rel
                         and a.aqpb056fco = ln_fcon;
                    
                    exception
                      when others then
                      
                        begin
                        
                          select 'S'
                            into lc_exis
                            from aqpb056h a
                           where a.aqpb056hpgc = ln_cod
                             and a.aqpb056hmod = ln_mod
                             and a.aqpb056hsuc = ln_suc
                             and a.aqpb056htrx = ln_trx
                             and a.aqpb056hrel = ln_rel
                             and a.aqpb056hfcon = ln_fcon;
                        exception
                          when others then
                            lc_exis := 'N';
                          
                        end;
                    end;
                  
                    --lc_exis := 'N';
                    -- -- -- -- 
                    if lc_exis = 'N' then
                    
                      PQ_CR_FACTURACION.sp_cr_factura_financiero(ln_rubro,
                                                                 'NC',
                                                                 xn_serie,
                                                                 xn_corre);
                    
                      begin
                      
                        ---===========================                                            
                        ---Resultado
                        ---===========================
                        xn_tipo := '87';
                      
                        begin
                          ---Inserción de la NC
                          insert into aqpb056
                            (aqpb056tco,
                             aqpb056ser,
                             aqpb056num,
                             aqpb056fem,
                             aqpb056pgc,
                             aqpb056mod,
                             aqpb056suc,
                             aqpb056trx,
                             aqpb056rel,
                             aqpb056fco,
                             aqpb056tce,
                             aqpb056see,
                             aqpb056nro,
                             aqpb056pge,
                             aqpb056moe,
                             aqpb056sue,
                             aqpb056tre,
                             aqpb056ree,
                             aqpb056fce)
                          values
                            (xn_tipo,
                             xn_serie,
                             xn_corre,
                             ln_fcon,
                             
                             ln_cod, ---aqpa460pgce,
                             ln_mod, ---aqpa460mode,
                             ln_suc, ---aqpa460suce,
                             ln_trx, ---aqpa460trxe,
                             ln_rel, ---aqpa460rele,
                             ln_fcon, ---aqpa460fcone
                             
                             lv_codtipo,
                             lc_serieI,
                             lc_correlativoI,
                             
                             pn_pgcod, ---p.pgcod,
                             pn_hcmod3, ---p.hcmod,
                             pn_hsucor3, ---p.hsucor,
                             pn_htran3, ---p.htran,
                             pn_hnrel3, ---p.hnrel,
                             pn_hfcon3 ---p.hfcon                           
                             );
                        exception
                          when others then
                            null;
                        end;
                        commit;
                      
                      exception
                        when others then
                        
                          lc_coderr := sqlcode;
                          lc_msgerr := trim(sqlerrm);
                        
                          begin
                            insert into aqpa460E
                              (aqpa460eserie,
                               aqpa460ecorr,
                               aqpa460epgcod,
                               aqpa460emod,
                               aqpa460esucorend,
                               aqpa460etran,
                               aqpa460erel,
                               aqpa460econ,
                               aqpa460etip,
                               Aqpa460eacoe,
                               Aqpa460eamsge)
                            values
                              (null,
                               null,
                               ln_cod,
                               ln_mod,
                               ln_suc,
                               ln_trx,
                               ln_rel,
                               ln_fcon,
                               'S',
                               lc_coderr,
                               lc_msgerr);
                          exception
                            when others then
                              null;
                          end;
                          commit;
                        
                      end;
                    
                      -- Obtener ordinal
                    
                      if pd_pgfape = ln_fcon then
                      
                        begin
                          SELECT t.itord
                            into ln_ord
                            FROM fsd016 t
                           where t.pgcod = pn_pgcod
                             and t.itmod = pn_hcmod3
                             and t.itsuc = pn_hsucor3
                             and t.ittran = pn_htran3
                             and t.itnrel = pn_hnrel3
                                --and t.hfcon = pc_con
                             and (t.itmod, t.ittran, t.itord) in
                                 (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                    from fst198 x
                                   where x.tp1cod = 1
                                     and x.tp1cod1 = 11120
                                     and x.tp1corr1 = 10
                                     and x.tp1corr2 = 2 --- < Importante!
                                     and x.tp1corr3 <> 0
                                     and x.tp1imp1 = 1);
                        exception
                          when too_many_rows then
                            begin
                              SELECT t.itord
                                into ln_ord
                                FROM fsd016 t
                               where t.pgcod = pn_pgcod
                                 and t.itmod = pn_hcmod3
                                 and t.itsuc = pn_hsucor3
                                 and t.ittran = pn_htran3
                                 and t.itnrel = pn_hnrel3
                                    --and t.hfcon = pc_con
                                 and (t.itmod, t.ittran, t.itord) in
                                     (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                        from fst198 x
                                       where x.tp1cod = 1
                                         and x.tp1cod1 = 11120
                                         and x.tp1corr1 = 10
                                         and x.tp1corr2 = 2 --- < Importante!
                                         and x.tp1corr3 <> 0
                                         and x.tp1imp1 = 1)
                                 and rownum = 1;
                            exception
                              when others then
                                ln_ord := null;
                            end;
                          
                          when others then
                            ln_ord := null;
                        end;
                      else
                        begin
                        
                          SELECT t.hcord
                            into ln_ord
                            FROM fsh016 t
                           where t.pgcod = pn_pgcod
                             and t.hcmod = pn_hcmod3
                             and t.hsucor = pn_hsucor3
                             and t.htran = pn_htran3
                             and t.hnrel = pn_hnrel3
                             and t.hfcon = pn_hfcon3
                             and (t.hcmod, t.htran, t.hcord) in
                                 (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                    from fst198 x
                                   where x.tp1cod = 1
                                     and x.tp1cod1 = 11120
                                     and x.tp1corr1 = 10
                                     and x.tp1corr2 = 2 --- < Importante!
                                     and x.tp1corr3 <> 0
                                     and x.tp1imp1 = 1);
                        exception
                          when too_many_rows then
                          
                            begin
                              SELECT t.hcord
                                into ln_ord
                                FROM fsh016 t
                               where t.pgcod = pn_pgcod
                                 and t.hcmod = pn_hcmod3
                                 and t.hsucor = pn_hsucor3
                                 and t.htran = pn_htran3
                                 and t.hnrel = pn_hnrel3
                                 and t.hfcon = pn_hfcon3
                                 and (t.hcmod, t.htran, t.hcord) in
                                     (select x.tp1nro1, x.tp1nro2, x.tp1nro3
                                        from fst198 x
                                       where x.tp1cod = 1
                                         and x.tp1cod1 = 11120
                                         and x.tp1corr1 = 10
                                         and x.tp1corr2 = 2 --- < Importante!
                                         and x.tp1corr3 <> 0
                                         and x.tp1imp1 = 1
                                      
                                      )
                                 and rownum = 1;
                            exception
                              when others then
                                ln_ord := null;
                            end;
                          
                          when others then
                            ln_ord := null;
                        end;
                      end if;
                    
                      if ln_ord is not null then
                      
                        begin
                          -- Inserción tabla de DLYA
                          insert into jaqn950
                            (jaqn950emp,
                             jaqn950fec,
                             jaqn950suc,
                             jaqn950mod,
                             jaqn950trn,
                             jaqn950rel,
                             jaqn950ord,
                             jaqn950sor,
                             jaqn950num,
                             jaqn950nom,
                             jaqn950cor,
                             --jaqn950tex,
                             jaqn950est,
                             jaqn950ai1,
                             jaqn950ai2,
                             jaqn950ai3,
                             --jaqn950an1,
                             --jaqn950an2,
                             --jaqn950an3,
                             --jaqn950ac1,
                             --jaqn950ac2,
                             --jaqn950ac3,
                             jaqn950af1 --,
                             --jaqn950af2,
                             --jaqn950af3
                             )
                          
                          values
                            (ln_cod, ---p.pgcod,
                             ln_fcon, ---p.hfcon
                             ln_suc, ---p.hsucor,
                             ln_mod, ---p.hcmod,
                             ln_trx, ---p.htran,
                             ln_rel, ---p.hnrel,
                             ln_ord, --- ordinal
                             1, --- orden
                             'NNNN',
                             'NNNN',
                             1,
                             'S',
                             0,
                             0,
                             0,
                             pn_hfcon3 --pn_cod
                             );
                        exception
                          when others then
                            null;
                        end;
                        commit;
                        ----======                  
                      
                      end if;
                    
                    end if;
                    -- -- -- --                           
                  
                  end;
                  ---8. Fin
                
                end if;
                ---6. Fin           
              
              end if;
            
            end if;
          
          end if;
        end;
        ----    
      
      end;
    
    end if;
  
  end sp_cr_nota_creditoe_gen_cont;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Procedimiento para generar DAE's de contingencia con fechas históricas   
  procedure sp_cr_generar_DAE_his(pn_fecha in date) is
  
    lc_serie   char(4);
    lc_dae_cor number;
    lc_tipo    char(2);
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    --pn_fecha date;
  
    cursor dae_pendientes(lc_fecha date) is
    
    -- AQPB056H HISTORICO DAE: VERIFIAR OPERACIONES
      select u.pgcod, u.itsuc, u.itmod, u.ittran, u.itnrel, u.rubro
        from (SELECT distinct h.pgcod  pgcod,
                              h.hsucor itsuc,
                              h.hcmod  itmod,
                              h.htran  ittran,
                              h.hnrel  itnrel,
                              --h. x.itcont,
                              (select to_number(substr(m.hrubro, 5, 2))
                                 from fsh016 m
                                where m.PGCOD = h.PGCOD
                                  and m.hsucor = h.hsucor
                                  and m.hcmod = h.hcmod
                                  and m.htran = h.htran
                                  and m.hnrel = h.hnrel
                                  and m.hfcon = h.hfcon
                                  and m.hcord = a.sr171trord
                                  AND ROWNUM = 1) rubro
                FROM fsh016 H, FSR171 F, FST171 G, fsh015 x, fsr171 a
               WHERE H.pgcod = 1
                    
                 and h.pgcod = x.pgcod
                 and h.hsucor = x.hsucor
                 and h.hcmod = x.hcmod
                 and h.htran = x.htran
                 and h.hnrel = x.hnrel
                 and h.hfcon = x.hfcon
                 and h.hfcon = lc_fecha
                    
                 and a.st171cpcod = 15
                 and a.sr171tremp = 1 --1
                 and a.sr171trmod = h.hcmod --30
                 and a.sr171trnro = h.htran
                    
                 AND H.Hrubro NOT IN (4212290000007, 4222290000007)
                    
                 and h.pgcod = F.SR171TREMP
                 AND h.hcmod = F.SR171TRMOD
                 AND h.htran = F.SR171TRNRO
                 AND h.hcord = F.SR171TRORD
                 AND f.ST171CPCOD = G.ST171CPCOD
                    ---filtro op no conc
                 and f.st171cpcod not in
                     (select d.tp1nro1
                        from fst198 d
                       where d.tp1cod = 1
                         and d.tp1cod1 = 11120
                         and d.tp1corr1 = 1
                         and d.tp1corr2 = 3
                         and d.tp1corr3 >= 1)
                    
                    --- Validando existencia de transacciones en GP
                 and (h.hcmod, h.htran) in
                     (select t.tp1nro1, t.tp1nro2
                        from fst198 t
                       where t.tp1cod = 1
                         and t.tp1cod1 = 11120
                         and t.tp1corr1 = 10
                         and t.tp1corr2 = 1
                         and t.tp1corr3 <> 0
                         and t.tp1imp2 = 1)
                 and (h.hrubro) in
                     (select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('1418', '1428')
                         and x.pmtit = 1
                         and x.pmcap = 4
                         and x.pmpzo = 8
                         and x.pcnivc = 403
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5114', '5124')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 4
                         and x.pcnivc = 461
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5117', '5127')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 7
                         and x.pcnivc = 461
                      union
                      select to_number('2514020000005') rubro
                        from dual
                      union
                      select to_number('2524020000005') rubro
                        from dual
                      union
                      select to_number('2514020000013') rubro
                        from dual
                      union
                      select to_number('2524020000013') rubro
                        from dual
                      union
                      select to_number('2514020000008') rubro
                        from dual
                      union
                      select to_number('2524020000008') rubro
                        from dual
                      union
                      select to_number('2514020000002') rubro
                        from dual
                      union
                      select to_number('2524020000002') rubro
                        from dual
                      union
                      select to_number('2514020000007') rubro
                        from dual
                      union
                      select to_number('2524020000007') rubro
                        from dual
                        --2023
                       union
                        select to_number('2514020000015') rubro
                        from dual 
                       union
                       select to_number('2524020000015') rubro
                        from dual 
                       union
                       select to_number('2514020000020') rubro
                        from dual 
			                 union
                        select to_number('2524020000020') rubro
                        from dual
			                 union
                        select to_number('2514020000022') rubro
                        from dual
			                 union	
                        select to_number('2524020000022') rubro
                        from dual
                        -- 2023                  
                      )
                 and h.hcimp1 > 0
                 and h.hcodmo = 2
                    
                 and (h.pgcod, h.hsucor, h.hcmod, h.htran, h.hnrel, h.HFCON) not in
                     (select g.aqpb056hpgc,
                             g.aqpb056hsuc,
                             g.aqpb056hmod,
                             g.aqpb056htrx,
                             g.aqpb056hrel,
                             g.aqpb056hfemi
                        from aqpb056h g
                       where g.aqpb056hfemi = lc_fecha
                         and g.aqpb056htcomf = '13')) u
       where u.rubro in -- (3, 4) 20211212 dcastro se comento rubro para incluir guia de procesos
             (select c.TP1NRO1
                from fst198 c
               where c.tp1cod = 1
                 and c.tp1cod1 = 11120
                 and c.tp1corr1 = 1
                 and c.tp1corr2 = 23
                 and tp1imp1 = 1)
       order by u.pgcod, u.itmod, u.ittran, u.itsuc, u.itnrel
      
      ;
  
  begin
  
    lc_tipo := '13';
  
    for i in dae_pendientes(pn_fecha) loop
    
      --lc_dae_cor := lc_dae_cor + 1;
    
      -- 1. Obtener Serie y Correlativo            
      begin
        pq_cr_facturacion.sp_cr_Factura_Contingen(pn_rubro       => i.rubro,
                                                  pc_tipo        => 'MOV', --transaccion
                                                  pc_serie       => lc_serie, ---out
                                                  pc_correlativo => lc_dae_cor); ---out
      
        --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
        --dbms_output.put_line('Serie: ' || lc_serie);
        --dbms_output.put_line('Número: ' || lc_corre);
      
      exception
        when others then
        
          lc_coderr := sqlcode;
          lc_msgerr := trim(sqlerrm);
        
      end;
    
      begin
        insert into aqpb056
          (aqpb056tco,
           aqpb056ser,
           aqpb056num,
           aqpb056fem,
           aqpb056pgc,
           aqpb056mod,
           aqpb056suc,
           aqpb056trx,
           aqpb056rel,
           aqpb056fco)
        values
          (lc_tipo,
           lc_serie,
           lc_dae_cor,
           pn_fecha, ---p.hfcon
           i.pgcod, ---p.pgcod,
           i.itmod, ---p.hcmod,
           i.itsuc, ---p.hsucor,
           i.ittran, ---p.htran,
           i.itnrel, ---p.hnrel,
           pn_fecha ---p.hfcon
           );
      exception
        when others then
          null;
      end;
      commit;
    
    end loop;
  
  end sp_cr_generar_DAE_his;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Procedimiento para generar NCE's de contingencia con fechas históricas   
  procedure sp_cr_generar_NCE_his(pn_fecha in date) is
  
    lc_serie   char(4);
    lc_nce_cor number;
    lc_tipo    char(2);
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    --pn_fecha date;
    lv_doc_ori      char(2);
    lc_serieI       char(4);
    lc_correlativoI char(8);
  
    lc_fecha_dae date;
  
    cursor nce_pendientes(lc_fecha date) is
    
    -- AQPB056H HISTORICO NCE: VERIFIAR OPERACIONES
      select ss.pgcod,
             ss.hcmod,
             ss.hsucor,
             ss.htran,
             ss.hnrel,
             ss.hfcon,
             ss.NRO_RELACION,
             ss.FECHA_TX,
             ss.rubro_ref
        from (SELECT y.pgcod,
                     y.hcmod,
                     y.hsucor,
                     y.htran,
                     y.hnrel,
                     y.hfcon,
                     y.NRO_RELACION,
                     y.FECHA_TX,
                     
                     (select to_number(substr(m.hrubro, 5, 2))
                        from fsh016 m
                       where m.pgcod = y.PGCOD
                         and m.hsucor = y.hsucor
                         and m.hcmod = (y.hcmod - 500)
                         and m.htran = y.htran
                         and m.hnrel = y.NRO_RELACION
                         and m.HFCON = y.FECHA_TX
                         and m.hcord = aa.sr171trord
                         and rownum = 1) rubro_ref
              
                FROM (select distinct a.pgcod,
                                      a.hcmod,
                                      a.hsucor,
                                      a.htran,
                                      a.hnrel,
                                      a.hfcon,
                                      (select to_number(max(f.txtext))
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 1) NRO_RELACION,
                                      (select to_date(f.txtext, 'DD/MM/RR')
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 2) FECHA_TX --,
                      --,p.itimp1
                      --,p.rubro
                      
                        from fsx015 a, FSR170 b, fsh015 c, fsh016 p --, fsr171 aa
                       where a.hcmod = b.sr170trmod + 500
                         and a.htran = b.sr170trnro
                         and a.pgcod = 1
                         and a.hcmod > 499
                         and a.txcod = 0
                            
                         and a.pgcod = c.pgcod
                         and a.hcmod = c.hcmod
                         and a.hsucor = c.hsucor
                         and a.htran = c.htran
                         and a.hnrel = c.hnrel
                         and a.hfcon = c.hfcon
                            
                            /*
                            and a.pgcod = 1
                            and a.hcmod = 530
                            and a.hsucor = 2
                            and a.htran = 97
                            and a.hnrel = 4
                            and a.hfcon = '03/09/2020'
                            */
                            
                         and p.pgcod = a.pgcod
                         and p.hsucor = a.hsucor
                         and p.hcmod = (a.hcmod - 500)
                         and p.htran = a.htran
                         and p.hnrel = (select max(f.txtext)
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 1)
                            
                         and p.hfcon = (select to_date(f.txtext, 'DD/MM/RR')
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 2
                                        
                                        )
                            
                         and a.pgcod = 1
                            
                         and a.hfcon >= p.HFCON
                         and a.hfcon = lc_fecha
                            --and p.HFCON >= to_date('2020.11.01', 'yyyy.mm.dd') --Fecha Inicio de DAE
                         and p.HFCON >= lc_fecha_dae
                            
                            --- Validando existencia de transacciones en GP
                         and (a.hcmod, a.htran) in
                             (select (t.tp1nro1 + 500), t.tp1nro2
                                from fst198 t
                               where t.tp1cod = 1
                                 and t.tp1cod1 = 11120
                                 and t.tp1corr1 = 10
                                 and t.tp1corr2 = 1
                                 and t.tp1corr3 <> 0
                                 and t.tp1imp1 = 1)
                            
                            --- validando rubros
                         and (p.hrubro) in
                             (select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('1418', '1428')
                                 and x.pmtit = 1
                                 and x.pmcap = 4
                                 and x.pmpzo = 8
                                 and x.pcnivc = 403
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5114', '5124')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 4
                                 and x.pcnivc = 461
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5117', '5127')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 7
                                 and x.pcnivc = 461
                              union
                              select to_number('2514020000005') rubro
                                from dual
                              union
                              select to_number('2524020000005') rubro
                                from dual
                              union
                              select to_number('2514020000013') rubro
                                from dual
                              union
                              select to_number('2524020000013') rubro
                                from dual
                              union
                              select to_number('2514020000008') rubro
                                from dual
                              union
                              select to_number('2524020000008') rubro
                                from dual
                              union
                              select to_number('2514020000002') rubro
                                from dual
                              union
                              select to_number('2524020000002') rubro
                                from dual
                              union
                              select to_number('2514020000007') rubro
                                from dual
                              union
                              select to_number('2524020000007') rubro
                                from dual
                               --2023
                               union
                                select to_number('2514020000015') rubro
                                from dual 
                               union
                               select to_number('2524020000015') rubro
                                from dual 
                               union
                               select to_number('2514020000020') rubro
                                from dual 
                               union
                                select to_number('2524020000020') rubro
                                from dual
                               union
                                select to_number('2514020000022') rubro
                                from dual
                               union	
                                select to_number('2524020000022') rubro
                                from dual
                                -- 2023 
                              )
                         and p.hcimp1 > 0
                         and p.hcodmo = 2
                            
                         and (a.pgcod, a.hcmod, a.hsucor, a.htran, a.hnrel,
                              a.HFCON
                             --a.hfcon,
                             ) not in
                             (select g.aqpb056hpgc,
                                     g.aqpb056hmod,
                                     g.aqpb056hsuc,
                                     g.aqpb056htrx,
                                     g.aqpb056hrel,
                                     g.aqpb056hfcon
                                from aqpb056h g
                               where g.aqpb056hfemi = lc_fecha
                                 and g.aqpb056htcomf = '87')) y,
                     fsr171 aa
               where aa.st171cpcod = 15
                 and aa.sr171tremp = 1 --1
                 and aa.sr171trmod = (y.hcmod - 500) --30
                 and aa.sr171trnro = y.htran) ss
       where ss.rubro_ref in -- (3, 4) 20211212 dcastro se comento rubro para incluir guia de procesos
             (select c.TP1NRO1
                from fst198 c
               where c.tp1cod = 1
                 and c.tp1cod1 = 11120
                 and c.tp1corr1 = 1
                 and c.tp1corr2 = 23
                 and tp1imp1 = 1)
       order by ss.pgcod, ss.hcmod, ss.hsucor, ss.htran, ss.hnrel, ss.hfcon;
  
  begin
  
    lc_tipo := '87';
  
    -- Fecha inicio del dae
    begin
      select to_date(t.tp1nro1, 'yyyymmdd')
        into lc_fecha_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 7;
    exception
      when others then
        null;
    end;
  
    for i in nce_pendientes(pn_fecha) loop
    
      --determinar tipo del documento origen
    
      --dbms_output.put_line('i.hcmod ' || i.hcmod );
      --dbms_output.put_line('i.hsucor ' || i.hsucor );
      ---dbms_output.put_line('i.htran ' || i.htran );
      --dbms_output.put_line('i.NRO_RELACION ' || i.NRO_RELACION );
      --dbms_output.put_line('i.FECHA_TX ' || i.FECHA_TX );
    
      begin
        select distinct t.aqpb056tco, t.aqpb056ser, t.aqpb056num
          into lv_doc_ori, lc_serieI, lc_correlativoI
          from aqpb056 t
         where t.aqpb056pgc = i.pgcod
           and t.aqpb056mod = (i.hcmod - 500)
           and t.aqpb056suc = i.hsucor
           and t.aqpb056trx = i.htran
           and t.aqpb056rel = i.NRO_RELACION
           and t.aqpb056fco = i.FECHA_TX
           and t.aqpb056tco = '13';
      exception
        when no_data_found then
        
          begin
            select distinct t.aqpb056htcomf, t.aqpb056hseri, t.aqpb056hnum
              into lv_doc_ori, lc_serieI, lc_correlativoI
              from aqpb056h t
             where t.aqpb056hpgc = i.pgcod
               and t.aqpb056hmod = (i.hcmod - 500)
               and t.aqpb056hsuc = i.hsucor
               and t.aqpb056htrx = i.htran
               and t.aqpb056hrel = i.NRO_RELACION
               and t.aqpb056hfcon = i.FECHA_TX
               and t.aqpb056htcomf = '13';
          exception
            when no_data_found then
            
              lv_doc_ori      := null;
              lc_serieI       := null;
              lc_correlativoI := null;
          end;
        
      end;
    
      if lv_doc_ori is not null then
        begin
        
          -- 1. Obtener Serie y Correlativo            
          begin
            pq_cr_facturacion.sp_cr_Factura_Contingen(pn_rubro       => i.rubro_ref,
                                                      pc_tipo        => 'NC', --transaccion
                                                      pc_serie       => lc_serie, ---out
                                                      pc_correlativo => lc_nce_cor); ---out
          
            --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
            --dbms_output.put_line('Serie: ' || lc_serie);
            --dbms_output.put_line('Número: ' || lc_corre);
          
          exception
            when others then
            
              lc_coderr := sqlcode;
              lc_msgerr := trim(sqlerrm);
            
          end;
        
          begin
            insert into aqpb056
              (aqpb056tco,
               aqpb056ser,
               aqpb056num,
               aqpb056fem,
               aqpb056pgc,
               aqpb056mod,
               aqpb056suc,
               aqpb056trx,
               aqpb056rel,
               aqpb056fco,
               aqpb056tce,
               aqpb056see,
               aqpb056nro,
               aqpb056pge,
               aqpb056moe,
               aqpb056sue,
               aqpb056tre,
               aqpb056ree,
               aqpb056fce)
            values
              (lc_tipo,
               lc_serie,
               lc_nce_cor,
               pn_fecha, ---p.hfcon
               i.pgcod, ---p.pgcod,
               i.hcmod, ---p.hcmod,
               i.hsucor, ---p.hsucor,
               i.htran, ---p.htran,
               i.hnrel, ---p.hnrel,
               pn_fecha, ---p.hfcon
               
               lv_doc_ori,
               lc_serieI,
               lc_correlativoI,
               i.pgcod, ---p.pgcod,
               (i.hcmod - 500),
               i.hsucor, ---p.hsucor,
               i.htran, ---p.htran,
               i.NRO_RELACION,
               i.FECHA_TX);
          exception
            when others then
              null;
          end;
          commit;
        end;
      end if;
    end loop;
  
  end sp_cr_generar_NCE_his;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_registro_Comp(pn_fecha in date, pn_opcion in number) is
  
    --lc_serie   char(4);
    --lc_nce_cor number;
    --lc_tipo    char(2);
    --lc_coderr  char(100);
    --lc_msgerr  char(1000);
    --pn_fecha date;
    --lv_doc_ori      char(2);
    --lc_serieI       char(4);
    --lc_correlativoI char(8);
  
  begin
  
    case
      when pn_opcion = 1 then
        --Recuperación
      
        -- PASO 2. Recuperación
        begin
          insert into aqpb056
            (aqpb056tco,
             aqpb056ser,
             aqpb056num,
             aqpb056fem,
             aqpb056pgc,
             aqpb056mod,
             aqpb056suc,
             aqpb056trx,
             aqpb056rel,
             aqpb056fco)
            select t.aqpb056htcomf,
                   t.aqpb056hseri,
                   t.aqpb056hnum,
                   t.aqpb056hfemi,
                   t.aqpb056hpgc,
                   t.aqpb056hmod,
                   t.aqpb056hsuc,
                   t.aqpb056htrx,
                   t.aqpb056hrel,
                   t.aqpb056hfcon
              from aqpb056h t
             where t.aqpb056hfemi = pn_fecha
               and (t.aqpb056htcomf, t.aqpb056hseri, t.aqpb056hnum) not in
                   (select x.aqpa460tcomf, x.aqpa460seri, x.aqpa460num
                      from aqpa460 x
                     where x.aqpa460femi = pn_fecha);
        exception
          when others then
            null;
        end;
      
        commit;
      
      when pn_opcion = 2 then
        --Inserción
      
        -- PASO 4
        begin
          insert into aqpb056h
            (aqpb056htcomf,
             aqpb056hseri,
             aqpb056hnum,
             aqpb056hfemi,
             aqpb056hpgc,
             aqpb056hmod,
             aqpb056hsuc,
             aqpb056htrx,
             aqpb056hrel,
             aqpb056hfcon,
             aqpb056htcomp,
             aqpb056hserie,
             aqpb056hnro,
             aqpb056hpgce,
             aqpb056hmode,
             aqpb056hsuce,
             aqpb056htrxe,
             aqpb056hrele,
             aqpb056hfcone,
             aqpb056hfcr,
             aqpb056hhcr)
            select t.aqpb056tco,
                   t.aqpb056ser,
                   t.aqpb056num,
                   t.aqpb056fem,
                   t.aqpb056pgc,
                   t.aqpb056mod,
                   t.aqpb056suc,
                   t.aqpb056trx,
                   t.aqpb056rel,
                   t.aqpb056fco,
                   t.aqpb056tce,
                   t.aqpb056see,
                   t.aqpb056nro,
                   t.aqpb056pge,
                   t.aqpb056moe,
                   t.aqpb056sue,
                   t.aqpb056tre,
                   t.aqpb056ree,
                   t.aqpb056fce,
                   to_char(sysdate, 'DD/MM/YYYY'), --aqpb056hfcr
                   to_char(sysdate, 'HH24:MI:SS') --aqpb056hhcr
              from aqpb056 t
             where t.aqpb056fem = pn_fecha
               and (t.aqpb056tco, t.aqpb056ser, t.aqpb056num) not in
                   (select x.aqpb056htcomf, x.aqpb056hseri, x.aqpb056hnum
                      from aqpb056h x
                     where x.aqpb056hfemi = pn_fecha);
        exception
          when others then
            null;
        end;
        commit;
      
    end case;
  
  end sp_cr_registro_Comp;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- DIARIO: Procedimiento para registrar correlativos diarios de DAE's faltantes
  procedure sp_cr_correc_DAE_dia is
  
    lc_tipo    aqpb056.aqpb056tco%type;
    lc_serie   aqpb056.aqpb056ser%type;
    lc_corre   aqpb056.aqpb056num%type;
    ln_esta    char(1);
    ln_fecha_s date;
  
    cursor transacciones(pc_fecha date) is
    
      select u.pgcod  pgcod,
             u.itsuc  hsucor,
             u.itmod  hcmod,
             u.ittran htran,
             u.itnrel hnrel,
             pc_fecha hfcon,
             u.rubro  hrubro
        from (SELECT distinct h.pgcod,
                              h.itsuc,
                              h.itmod,
                              h.ittran,
                              h.itnrel,
                              x.itcont,
                              (select to_number(substr(m.rubro, 5, 2))
                                 from fsd016 m
                                where m.PGCOD = h.PGCOD
                                  and m.ITSUC = h.ITSUC
                                  and m.ITMOD = h.ITMOD
                                  and m.ITTRAN = h.ITTRAN
                                  and m.ITNREL = h.ITNREL
                                  and m.ITORD = a.sr171trord
                                  and rownum = 1) rubro
                FROM fsd016 H, FSR171 F, FST171 G, fsd015 x, fsr171 a
               WHERE H.pgcod = 1
                    
                 and h.pgcod = x.pgcod
                 and h.itsuc = x.itsuc
                 and h.itmod = x.itmod
                 and h.ittran = x.ittran
                 and h.itnrel = x.itnrel
                    
                 and a.st171cpcod = 15
                 and a.sr171tremp = 1
                 and a.sr171trmod = h.ITMOD
                 and a.sr171trnro = h.ITTRAN
                    
                 AND H.Rubro NOT IN (4212290000007, 4222290000007)
                    
                 and h.pgcod = F.SR171TREMP
                 AND h.itmod = F.SR171TRMOD
                 AND h.ittran = F.SR171TRNRO
                 AND h.itord = F.SR171TRORD
                 AND f.ST171CPCOD = G.ST171CPCOD
                    ---filtro op no conc
                 and f.st171cpcod not in
                     (select d.tp1nro1
                        from fst198 d
                       where d.tp1cod = 1
                         and d.tp1cod1 = 11120
                         and d.tp1corr1 = 1
                         and d.tp1corr2 = 3
                         and d.tp1corr3 >= 1)
                    
                    --- Validando existencia de transacciones en GP
                 and (h.itmod, h.ittran) in
                     (select t.tp1nro1, t.tp1nro2
                        from fst198 t
                       where t.tp1cod = 1
                         and t.tp1cod1 = 11120
                         and t.tp1corr1 = 10
                         and t.tp1corr2 = 1
                         and t.tp1corr3 <> 0
                         and t.tp1imp2 = 1)
                 and (h.rubro) in
                     (select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('1418', '1428')
                         and x.pmtit = 1
                         and x.pmcap = 4
                         and x.pmpzo = 8
                         and x.pcnivc = 403
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5114', '5124')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 4
                         and x.pcnivc = 461
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5117', '5127')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 7
                         and x.pcnivc = 461
                      union
                      select to_number('2514020000005') rubro
                        from dual
                      union
                      select to_number('2524020000005') rubro
                        from dual
                      union
                      select to_number('2514020000013') rubro
                        from dual
                      union
                      select to_number('2524020000013') rubro
                        from dual
                      union
                      select to_number('2514020000008') rubro
                        from dual
                      union
                      select to_number('2524020000008') rubro
                        from dual
                      union
                      select to_number('2514020000002') rubro
                        from dual
                      union
                      select to_number('2524020000002') rubro
                        from dual
                      union
                      select to_number('2514020000007') rubro
                        from dual
                      union
                      select to_number('2524020000007') rubro
                        from dual
                      
                      )
                 and h.itimp1 > 0
                 and h.itdbha = 2
                 and x.itcont = 'S'
                 and (h.pgcod, h.itsuc, h.itmod, h.ittran, h.itnrel) not in
                     (select g.aqpb056pgc,
                             g.aqpb056suc,
                             g.aqpb056mod,
                             g.aqpb056trx,
                             g.aqpb056rel
                        from aqpb056 g
                       where g.aqpb056fem =
                             (select e.pgfape from fst017 e where e.pgcod = 1)
                         and g.aqpb056tco = '13')) u
       where u.rubro in (3, 4)
      --and u.itcont = 'S'
       order by u.pgcod, u.itmod, u.ittran, u.itsuc, u.itnrel;
  begin
  
    begin
      select t.pgfape into ln_fecha_s from fst017 t where t.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for p in transacciones(ln_fecha_s) loop
    
      begin
        select 'S'
          into ln_esta
          from aqpb056 x
         where x.aqpb056pgc = p.pgcod
           and x.aqpb056mod = p.hcmod
           and x.aqpb056suc = p.hsucor
           and x.aqpb056trx = p.htran
           and x.aqpb056rel = p.hnrel
           and x.aqpb056fco = p.hfcon;
      exception
        when others then
          ln_esta := 'N';
      end;
    
      --dbms_output.put_line('ln_esta: ' || ln_esta);
    
      if ln_esta = 'N' then
      
        delete from jaqn950 g
         where g.jaqn950emp = 1
           and g.jaqn950fec = p.hfcon
           and g.jaqn950suc = p.hsucor
           and g.jaqn950mod = p.hcmod
           and g.jaqn950trn = p.htran
           and g.jaqn950rel = p.hnrel;
        commit;
      
      end if;
    
      --dbms_output.put_line('hcmod: ' || p.hcmod);
      --dbms_output.put_line('hsucor: ' || p.hsucor);
      --dbms_output.put_line('htran: ' || p.htran);
      --dbms_output.put_line('hnrel: ' || p.hnrel);
      --dbms_output.put_line('hfcon: ' || p.hfcon);  
    
      pq_cr_facturacion_generacion.sp_cr_facturae_gen_cont(pn_cod   => p.pgcod,
                                                           pn_mod   => p.hcmod,
                                                           pn_suc   => p.hsucor,
                                                           pn_tran  => p.htran,
                                                           pn_rel   => p.hnrel,
                                                           pn_con   => p.hfcon,
                                                           lc_tipo  => lc_tipo, -- out
                                                           lc_serie => lc_serie, -- out
                                                           lc_corre => lc_corre); -- out                                                               
    
    --dbms_output.put_line('lc_tipo: ' || lc_tipo);
    --dbms_output.put_line('lc_serie: ' || lc_serie);
    --dbms_output.put_line('lc_corre: ' || lc_corre);  
    
    end loop;
  
  end sp_cr_correc_DAE_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- DIARIO: Procedimiento para registrar correlativos diarios de NCE's faltantes
  -- Fecha de anulación es igual a la fecha de operación
  procedure sp_cr_correc_NCE_dia is
  
    ---Generación NCE No Considerados  
    lc_tipo  aqpb056.aqpb056tco%type;
    lc_serie aqpb056.aqpb056ser%type;
    lc_corre aqpb056.aqpb056num%type;
    ln_esta  char(1);
  
    cursor transacciones is
    
      select ss.pgcod        pgcod,
             ss.hcmod        hcmod,
             ss.hsucor       hsucor,
             ss.htran        htran,
             ss.hnrel        hnrel,
             ss.hfcon        hfcon,
             ss.NRO_RELACION,
             ss.FECHA_TX,
             ss.rubro_ref
        from (SELECT y.pgcod,
                     y.hcmod,
                     y.hsucor,
                     y.htran,
                     y.hnrel,
                     y.hfcon,
                     y.NRO_RELACION,
                     y.FECHA_TX,
                     (select to_number(substr(m.rubro, 5, 2))
                        from fsd016 m
                       where m.PGCOD = y.PGCOD
                         and m.ITSUC = y.hsucor
                         and m.ITMOD = (y.hcmod - 500)
                         and m.ITTRAN = y.htran
                         and m.ITNREL = y.NRO_RELACION
                         and m.ITORD = aa.sr171trord
                         and rownum = 1) rubro_ref
                FROM (select distinct a.pgcod,
                                      a.hcmod,
                                      a.hsucor,
                                      a.htran,
                                      a.hnrel,
                                      a.hfcon,
                                      (select to_number(max(f.txtext))
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 1) NRO_RELACION,
                                      (select to_date(f.txtext, 'DD/MM/RR')
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 2) FECHA_TX --,
                      --,p.itimp1
                      --,p.rubro
                      
                        from fsx015 a, FSR170 b, fsd015 c, fsd016 p --, fsr171 aa
                       where a.hcmod = b.sr170trmod + 500
                         and a.htran = b.sr170trnro
                         and a.pgcod = 1
                         and a.hcmod > 499
                         and a.txcod = 0
                         and a.pgcod = c.pgcod
                         and a.hcmod = c.itmod
                         and a.hsucor = c.itsuc
                         and a.htran = c.ittran
                         and a.hnrel = c.itnrel
                         and a.hfcon = c.itfcon
                            
                            ---and aa.st171cpcod = 15
                            --and aa.sr171tremp = 1 --1
                            --and aa.sr171trmod = p.ITMOD --30
                            --and aa.sr171trnro = p.ITTRAN      
                            
                         and p.pgcod = a.pgcod
                         and p.itsuc = a.hsucor
                         and p.itmod = (a.hcmod - 500)
                         and p.ittran = a.htran
                         and p.itnrel = (select to_number(max(f.txtext))
                                           from fsx015 f
                                          where f.hfcon = a.hfcon
                                            and f.hcmod = a.hcmod
                                            and f.htran = a.htran
                                            and f.hnrel = a.hnrel
                                            and f.hsucor = a.hsucor
                                            and f.txcod = 0
                                            and f.txreng = 1)
                            
                         and a.hfcon = (select to_date(f.txtext, 'DD/MM/RR')
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 2
                                        
                                        )
                            
                         and a.pgcod = 1
                            
                            /*
                            and a.hcmod = 530
                            and a.hsucor = 2
                            and a.htran = 397
                            and a.hnrel = 3
                            */
                            
                            --
                         and a.hfcon =
                             (select n.pgfape from fst017 n where n.pgcod = 1)
                            
                            --- Validando existencia de transacciones en GP
                         and (a.hcmod, a.htran) in
                             (select (t.tp1nro1 + 500), t.tp1nro2
                                from fst198 t
                               where t.tp1cod = 1
                                 and t.tp1cod1 = 11120
                                 and t.tp1corr1 = 10
                                 and t.tp1corr2 = 1
                                 and t.tp1corr3 <> 0
                                 and t.tp1imp1 = 1)
                            
                            --- validando rubros
                         and (p.rubro) in
                             (select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('1418', '1428')
                                 and x.pmtit = 1
                                 and x.pmcap = 4
                                 and x.pmpzo = 8
                                 and x.pcnivc = 403
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5114', '5124')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 4
                                 and x.pcnivc = 461
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5117', '5127')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 7
                                 and x.pcnivc = 461
                              union
                              select to_number('2514020000005') rubro
                                from dual
                              union
                              select to_number('2524020000005') rubro
                                from dual
                              union
                              select to_number('2514020000013') rubro
                                from dual
                              union
                              select to_number('2524020000013') rubro
                                from dual
                              union
                              select to_number('2514020000008') rubro
                                from dual
                              union
                              select to_number('2524020000008') rubro
                                from dual
                              union
                              select to_number('2514020000002') rubro
                                from dual
                              union
                              select to_number('2524020000002') rubro
                                from dual
                              union
                              select to_number('2514020000007') rubro
                                from dual
                              union
                              select to_number('2524020000007') rubro
                                from dual
                                                     union
                      select to_number('2514020000015') rubro
                        from dual 
                       union
                      select to_number('2524020000015') rubro
                        from dual 
                       union
                      select to_number('2514020000020') rubro
                        from dual 
			                   union
                      select to_number('2524020000020') rubro
                        from dual
                        union
                      select to_number('2514020000022') rubro
                        from dual
                        union	
                      select to_number('2524020000022') rubro
                        from dual

                              
                              )
                         and p.itimp1 > 0
                         and p.itdbha = 2
                         and c.itcont = 'S'
                            
                         and (a.pgcod, a.hcmod, a.hsucor, a.htran, a.hnrel
                             --a.hfcon,
                             ) not in (select g.aqpb056pgc,
                                              g.aqpb056mod,
                                              g.aqpb056suc,
                                              g.aqpb056trx,
                                              g.aqpb056rel
                                         from aqpb056 g
                                        where g.aqpb056fem =
                                              (select e.pgfape
                                                 from fst017 e
                                                where e.pgcod = 1)
                                          and g.aqpb056tco = '87')) y,
                     fsr171 aa
               where aa.st171cpcod = 15
                 and aa.sr171tremp = 1 --1
                 and aa.sr171trmod = (y.hcmod - 500) --30
                 and aa.sr171trnro = y.htran) ss
       where ss.rubro_ref in (3, 4)
       order by ss.pgcod, ss.hcmod, ss.hsucor, ss.htran, ss.hnrel, ss.hfcon;
  
    -----------------
  begin
    for p in transacciones loop
    
      begin
        select 'S'
          into ln_esta
          from aqpb056 x
         where x.aqpb056pgc = p.pgcod
           and x.aqpb056mod = p.hcmod
           and x.aqpb056suc = p.hsucor
           and x.aqpb056trx = p.htran
           and x.aqpb056rel = p.hnrel
           and x.aqpb056fco = p.hfcon;
      exception
        when others then
          ln_esta := 'N';
      end;
    
      --dbms_output.put_line('ln_esta: ' || ln_esta);
    
      if ln_esta = 'N' then
      
        delete from jaqn950 g
         where g.jaqn950emp = 1
           and g.jaqn950fec = p.hfcon
           and g.jaqn950suc = p.hsucor
           and g.jaqn950mod = p.hcmod
           and g.jaqn950trn = p.htran
           and g.jaqn950rel = p.hnrel;
        commit;
      
      end if;
    
      --dbms_output.put_line('hcmod: ' || p.hcmod);
      --dbms_output.put_line('hsucor: ' || p.hsucor);
      --dbms_output.put_line('htran: ' || p.htran);
      --dbms_output.put_line('hnrel: ' || p.hnrel);
      --dbms_output.put_line('hfcon: ' || p.hfcon);    
    
      pq_cr_facturacion_generacion.sp_cr_nota_creditoe_gen_cont(ln_cod   => p.pgcod,
                                                                ln_mod   => p.hcmod,
                                                                ln_suc   => p.hsucor,
                                                                ln_trx   => p.htran,
                                                                ln_rel   => p.hnrel,
                                                                ln_fcon  => p.hfcon,
                                                                xn_tipo  => lc_tipo, -- out
                                                                xn_serie => lc_serie, -- out
                                                                xn_corre => lc_corre); -- out  
    
    -- dbms_output.put_line('lc_tipo: ' || lc_tipo);
    --dbms_output.put_line('lc_serie: ' || lc_serie);
    --dbms_output.put_line('lc_corre: ' || lc_corre);                                                                                                                            
    
    end loop;
  
  end sp_cr_correc_NCE_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  -- DIARIO: Procedimiento para registrar correlativos diarios de NCE's faltantes
  -- Fecha de anulación es diferente a la fecha de operación  
  procedure sp_cr_correc_NCE_dia_2 is
  
    lc_tipo      aqpb056.aqpb056tco%type;
    lc_serie     aqpb056.aqpb056ser%type;
    lc_corre     aqpb056.aqpb056num%type;
    ln_esta      char(1);
    lc_fecha_dae date;
  
    cursor transacciones is
    
      select ss.pgcod,
             ss.hcmod,
             ss.hsucor,
             ss.htran,
             ss.hnrel,
             ss.hfcon,
             ss.NRO_RELACION,
             ss.FECHA_TX,
             ss.rubro_ref
        from (SELECT y.pgcod,
                     y.hcmod,
                     y.hsucor,
                     y.htran,
                     y.hnrel,
                     y.hfcon,
                     y.NRO_RELACION,
                     y.FECHA_TX,
                     
                     (select to_number(substr(m.HRUBRO, 5, 2))
                        from fsh016 m
                       where m.PGCOD = y.PGCOD
                         and m.HSUCOR = y.hsucor
                         and m.HCMOD = (y.hcmod - 500)
                         and m.HTRAN = y.htran
                         and m.HNREL = y.NRO_RELACION
                         and m.HFCON = y.FECHA_TX
                         and m.HCORD = aa.sr171trord
                         and rownum = 1) rubro_ref
              
                from (select distinct a.pgcod,
                                      a.hcmod,
                                      a.hsucor,
                                      a.htran,
                                      a.hnrel,
                                      a.hfcon,
                                      (select to_number(max(f.txtext))
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 1) NRO_RELACION,
                                      (select to_date(f.txtext, 'DD/MM/RR')
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 2) FECHA_TX
                        from fsx015 a, FSR170 b, fsd015 c, fsh016 p
                       where a.hcmod = b.sr170trmod + 500
                         and a.htran = b.sr170trnro
                         and a.pgcod = 1
                         and a.hcmod > 499
                         and a.txcod = 0
                            
                         and a.pgcod = c.pgcod
                         and a.hcmod = c.itmod
                         and a.hsucor = c.itsuc
                         and a.htran = c.ittran
                         and a.hnrel = c.itnrel
                         and a.hfcon = c.itfcon
                            /* 
                            and a.pgcod = c.pgcod
                                   and a.hcmod = c.hcmod
                                   and a.hsucor = c.hsucor
                                   and a.htran = c.htran
                                   and a.hnrel = c.hnrel
                                   and a.hfcon = c.hfcon
                                   */
                            
                         and p.pgcod = a.pgcod
                         and p.hsucor = a.hsucor
                         and p.hcmod = (a.hcmod - 500)
                         and p.htran = a.htran
                         and p.hnrel = (select max(f.txtext)
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 1)
                            
                         and p.hfcon = (select to_date(f.txtext, 'DD/MM/RR')
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 2)
                            /*   
                            and a.pgcod = 1
                            and a.hcmod = 990
                            and a.hsucor = 902
                            and a.htran = 100
                            and a.hnrel = 6
                            */
                            --
                         and a.hfcon =
                             (select n.pgfape from fst017 n where n.pgcod = 1)
                            
                         and a.hfcon >= p.hfcon --- a: FSX015
                            --and p.HFCON >= to_date('2020.11.01', 'yyyy.mm.dd')
                         and p.HFCON >= lc_fecha_dae
                            
                            --- Validando existencia de transacciones en GP
                         and (a.hcmod, a.htran) in
                             (select (t.tp1nro1 + 500), t.tp1nro2
                                from fst198 t
                               where t.tp1cod = 1
                                 and t.tp1cod1 = 11120
                                 and t.tp1corr1 = 10
                                 and t.tp1corr2 = 1
                                 and t.tp1corr3 <> 0
                                 and t.tp1imp2 = 1)
                            
                            --- validando rubros
                         and (p.hrubro) in
                             (select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('1418', '1428')
                                 and x.pmtit = 1
                                 and x.pmcap = 4
                                 and x.pmpzo = 8
                                 and x.pcnivc = 403
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5114', '5124')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 4
                                 and x.pcnivc = 461
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5117', '5127')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 7
                                 and x.pcnivc = 461
                              union
                              select to_number('2514020000005') rubro
                                from dual
                              union
                              select to_number('2524020000005') rubro
                                from dual
                              union
                              select to_number('2514020000013') rubro
                                from dual
                              union
                              select to_number('2524020000013') rubro
                                from dual
                              union
                              select to_number('2514020000008') rubro
                                from dual
                              union
                              select to_number('2524020000008') rubro
                                from dual
                              union
                              select to_number('2514020000002') rubro
                                from dual
                              union
                              select to_number('2524020000002') rubro
                                from dual
                              union
                              select to_number('2514020000007') rubro
                                from dual
                              union
                              select to_number('2524020000007') rubro
                                from dual
  
                            union
                            select to_number('2514020000015') rubro
                              from dual 
                             union
                            select to_number('2524020000015') rubro
                              from dual 
                             union
                            select to_number('2514020000020') rubro
                              from dual 
                               union
                            select to_number('2524020000020') rubro
                              from dual
                              union
                            select to_number('2514020000022') rubro
                              from dual
                              union	
                            select to_number('2524020000022') rubro
                              from dual
                            ---mod cgdg
                              )
                         and p.hcimp1 > 0
                         and p.hcodmo = 2
                         and c.ITCONT = 'S'
                            
                         and (a.pgcod, a.hcmod, a.hsucor, a.htran, a.hnrel
                             --a.hfcon,
                             ) not in (select g.aqpb056pgc,
                                              g.aqpb056mod,
                                              g.aqpb056suc,
                                              g.aqpb056trx,
                                              g.aqpb056rel
                                         from aqpb056 g
                                        where g.aqpb056fem =
                                              (select e.pgfape
                                                 from fst017 e
                                                where e.pgcod = 1)
                                          and g.aqpb056tco = '87')) y,
                     fsr171 aa
               where aa.st171cpcod = 15
                 and aa.sr171tremp = 1 --1
                 and aa.sr171trmod = (y.hcmod - 500) --30
                 and aa.sr171trnro = y.htran) ss
       where ss.rubro_ref in (3, 4)
       order by ss.pgcod, ss.hcmod, ss.hsucor, ss.htran, ss.hnrel, ss.hfcon;
  
    -----------------
  begin
  
    begin
      select to_date(t.tp1nro1, 'yyyymmdd')
        into lc_fecha_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 7;
    exception
      when others then
        null;
    end;
  
    for p in transacciones loop
    
      begin
        select 'S'
          into ln_esta
          from aqpb056 x
         where x.aqpb056pgc = p.pgcod
           and x.aqpb056mod = p.hcmod
           and x.aqpb056suc = p.hsucor
           and x.aqpb056trx = p.htran
           and x.aqpb056rel = p.hnrel
           and x.aqpb056fco = p.hfcon;
      exception
        when others then
          ln_esta := 'N';
      end;
    
      --dbms_output.put_line('ln_esta: ' || ln_esta);
    
      if ln_esta = 'N' then
      
        delete from jaqn950 g
         where g.jaqn950emp = 1
           and g.jaqn950fec = p.hfcon
           and g.jaqn950suc = p.hsucor
           and g.jaqn950mod = p.hcmod
           and g.jaqn950trn = p.htran
           and g.jaqn950rel = p.hnrel;
        commit;
      
      end if;
    
      --dbms_output.put_line('hcmod: ' || p.hcmod);
      --dbms_output.put_line('hsucor: ' || p.hsucor);
      --dbms_output.put_line('htran: ' || p.htran);
      --dbms_output.put_line('hnrel: ' || p.hnrel);
      --dbms_output.put_line('hfcon: ' || p.hfcon);    
    
      pq_cr_facturacion_generacion.sp_cr_nota_creditoe_gen_cont(ln_cod   => p.pgcod,
                                                                ln_mod   => p.hcmod,
                                                                ln_suc   => p.hsucor,
                                                                ln_trx   => p.htran,
                                                                ln_rel   => p.hnrel,
                                                                ln_fcon  => p.hfcon,
                                                                xn_tipo  => lc_tipo, -- out
                                                                xn_serie => lc_serie, -- out
                                                                xn_corre => lc_corre); -- out  
    
    -- dbms_output.put_line('lc_tipo: ' || lc_tipo);
    --dbms_output.put_line('lc_serie: ' || lc_serie);
    --dbms_output.put_line('lc_corre: ' || lc_corre);                                                                                                                            
    
    end loop;
  
  end sp_cr_correc_NCE_dia_2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_repro_dia(pn_fecha in date) is
    -- Aplicar siempre y cuando la fecha a procesar exista en la tabla jaqz659
    lc_con number;
  
  begin
  
    begin
      select count(*)
        into lc_con
        from jaqz659 t
       where t.jaqz659fecpr = pn_fecha;
    exception
      when others then
        null;
    end;
  
    if lc_con > 0 then
      begin
        --- PASO 1. Generación de Faltantes
        --pq_cr_facturacion_generacion.sp_cr_generar_dae_his(pn_fecha);
      
        pq_cr_facturacion_generacion.sp_cr_sch_dae_his(pn_fecha);
      
        pq_cr_facturacion_generacion.sp_cr_generar_nce_his(pn_fecha);
      
        -- PASO 3. Procesamiento de comprobantes para el DAE
        -- pq_cr_carga_facturacion.sp_cr_proceso_inserta(pn_fecha);
        BEGIN
        
          --execute immediate 'create sequence SEQ_FACTJAQZ_SEE minvalue 500 maxvalue 99999999 start
          --with 500 increment by 1 nocache cycle order';
          pq_cr_facturacion_generacion.sp_cr_reset_sequence(p_seq => 'SEQ_FACTJAQZ_SEE');
        
        end;
      
        begin
          -- Call the procedure
          PQ_CR_CARGA_FACTURACION.sp_cr_sch_inserta_m(pd_fecpro => pn_fecha);
        end;
      
        -- PASO 3.1 Registrode DAE's
        ---pq_cr_factura_electronica.sp_tra_validas_his(pn_fecha);
        begin
          -- Call the procedure
          pq_cr_factura_electronica.sp_cr_sch_dae_m(pd_fecpro => pn_fecha);
        end;
      
        -- PASO 3.2 Registrode NCE's  
        --pq_cr_factura_electronica.sp_cr_nota_credito_com(pn_fecha);
        begin
          -- Call the procedure
          pq_cr_factura_electronica.sp_cr_sch_nce_m(pd_fecpro => pn_fecha);
        end;
      
        -- PASO 4
        begin
          insert into aqpb056h
            (aqpb056htcomf,
             aqpb056hseri,
             aqpb056hnum,
             aqpb056hfemi,
             aqpb056hpgc,
             aqpb056hmod,
             aqpb056hsuc,
             aqpb056htrx,
             aqpb056hrel,
             aqpb056hfcon,
             aqpb056htcomp,
             aqpb056hserie,
             aqpb056hnro,
             aqpb056hpgce,
             aqpb056hmode,
             aqpb056hsuce,
             aqpb056htrxe,
             aqpb056hrele,
             aqpb056hfcone,
             aqpb056hfcr,
             aqpb056hhcr)
            select t.aqpb056tco,
                   t.aqpb056ser,
                   t.aqpb056num,
                   t.aqpb056fem,
                   t.aqpb056pgc,
                   t.aqpb056mod,
                   t.aqpb056suc,
                   t.aqpb056trx,
                   t.aqpb056rel,
                   t.aqpb056fco,
                   t.aqpb056tce,
                   t.aqpb056see,
                   t.aqpb056nro,
                   t.aqpb056pge,
                   t.aqpb056moe,
                   t.aqpb056sue,
                   t.aqpb056tre,
                   t.aqpb056ree,
                   t.aqpb056fce,
                   to_char(sysdate, 'DD/MM/YYYY'), --aqpb056hfcr
                   to_char(sysdate, 'HH24:MI:SS') --aqpb056hhcr
              from aqpb056 t
             where t.aqpb056fem = pn_fecha
               and (t.aqpb056tco, t.aqpb056ser, t.aqpb056num) not in
                   (select x.aqpb056htcomf, x.aqpb056hseri, x.aqpb056hnum
                      from aqpb056h x
                     where x.aqpb056hfemi = pn_fecha);
        exception
          when others then
            null;
        end;
        commit;
      end;
    
    end if;
  
  end sp_cr_repro_dia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_reset_sequence(p_seq in varchar2) is
    l_value number;
  begin
    -- Select the next value of the sequence
  
    execute immediate 'select ' || p_seq || '.nextval from dual'
      INTO l_value;
  
    l_value := l_value - 499;
  
    -- Set a negative increment for the sequence, 
    -- with value = the current value of the sequence
  
    execute immediate 'alter sequence ' || p_seq || ' increment by -' ||
                      l_value || ' minvalue 499';
  
    -- Select once from the sequence, to 
    -- take its current value back to 0
  
    execute immediate 'select ' || p_seq || '.nextval from dual'
      INTO l_value;
  
    -- Set the increment back to 1
  
    execute immediate 'alter sequence ' || p_seq ||
                      ' increment by 1 minvalue 499';
  end sp_cr_reset_sequence;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_recalcular_impt(pn_fecha in date) is
    -- Procedimiento para actualizar importes en documentos tipo 13 y recreación de 
    -- documentos tipo 87
    pn_monto_total_1 number(12, 2);
  
    cursor cursor_aqpa460_13(pr_fecha date) is
      select x.aqpa465serie,
             x.aqpa465corr,
             x.aqpa465pgcod,
             x.aqpa465mod,
             x.aqpa465sucor,
             x.aqpa465tran,
             x.aqpa465rel,
             x.aqpa465con
        from aqpa465 x
       where x.aqpa465con = pr_fecha
         and x.aqpa465serie in ('FF01', 'FH01', 'FS01');
  
  begin
  
    --Paso 1: Registrar NCE FALTANTES EN AQPA460
    begin
      -- Call the procedure
      pq_cr_factura_electronica.sp_cr_sch_nce_m(pd_fecpro => pn_fecha);
    end;
  
    --PASO 1
    for p in cursor_aqpa460_13(pn_fecha) loop
    
      begin
        -- Call the function
        pn_monto_total_1 := pq_cr_factura_electronica.fn_sumatoria_total(pn_pgc   => p.aqpa465pgcod,
                                                                         pn_mod   => p.aqpa465mod,
                                                                         pn_suc   => p.aqpa465sucor,
                                                                         pn_trx   => p.aqpa465tran,
                                                                         pn_rel   => p.aqpa465rel,
                                                                         pn_fecha => p.aqpa465con);
      end;
    
      update aqpa460 t
         set t.aqpa460impt  = pn_monto_total_1,
             t.aqpa460svitm = pn_monto_total_1,
             t.aqpa460spvi  = pn_monto_total_1,
             t.aqpa460mtinf = pn_monto_total_1
       where t.aqpa460tcomf = '13'
         and t.aqpa460seri = p.aqpa465serie
         and t.aqpa460num = p.aqpa465corr
         and t.aqpa460femi = p.aqpa465con
         and t.aqpa460pgc = p.aqpa465pgcod
         and t.aqpa460mod = p.aqpa465mod
         and t.aqpa460suc = p.aqpa465sucor
         and t.aqpa460trx = p.aqpa465tran
         and t.aqpa460rel = p.aqpa465rel;
    
      commit;
    
    end loop;
  
    --- PASO 2
    --- PASO 2.1 Actualización a AQPA466
    update aqpa466 x
       set x.aqpa466pgcod = 500
     where (x.aqpa466serie, x.aqpa466corr) in
           (select distinct t.aqpa460seri, t.aqpa460num
              from aqpa460 t
             where t.aqpa460femi = pn_fecha
               and t.aqpa460tcomf in ('87'));
    commit;
  
    --- PASO 2.2 Depuración de AQPA464 y AQPA460
    delete from aqpa464 x
     where (x.aqpa464serie, x.aqpa464nro) in
           (select distinct t.aqpa460seri, t.aqpa460num
              from aqpa460 t
             where t.aqpa460femi = pn_fecha
               and t.aqpa460tcomf in ('87'));
  
    delete from aqpa460 x
     where x.aqpa460femi = pn_fecha
       and x.aqpa460tcomf in ('87');
    commit;
  
    --- PASO 4, Reprocesar NCE
    begin
      -- Call the procedure
      pq_cr_factura_electronica.sp_cr_sch_nce(pd_fecpro => pn_fecha);
    end;
  
    --- PASO 5
    update aqpa466 x set x.aqpa466pgcod = 1 where x.aqpa466pgcod = 500;
    commit;
  
  end sp_cr_recalcular_impt;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_cr_anular_comprob(pn_cod     in number,
                                 pn_fecha   in date,
                                 pn_corr    in number,
                                 pn_usuario in varchar2,
                                 pn_messa   out varchar2,
                                 pn_val     out varchar2) is
  
    --nAnu1 number;
    nEst  char(1);
    nEva  number;
    nRpta number;
  
  begin
  
    begin
      select x.aqpb054est
        into nEst
        from aqpb054 x
       where x.aqpb054pgcod = pn_cod
         and x.aqpb054fecha = pn_fecha
         and x.aqpb054corr = pn_corr;
    exception
      when others then
        null;
    end;
  
    case
      when nEst = 'E' then
      
        nRpta := 0;
      
        select count(*)
          into nRpta
          from aqpb052 x
         where (x.aqpb052tcomf, x.aqpb052seri, x.aqpb052num) in
               (select t.aqpb053tcomf, t.aqpb053seri, t.aqpb053num
                  from aqpb053 t
                 where t.aqpb053fecha = pn_fecha
                   and t.aqpb053cod = pn_corr
                   and t.aqpb053est = 'E');
      
        delete from aqpb052 x
         where (x.aqpb052tcomf, x.aqpb052seri, x.aqpb052num) in
               (select t.aqpb053tcomf, t.aqpb053seri, t.aqpb053num
                  from aqpb053 t
                 where t.aqpb053fecha = pn_fecha
                   and t.aqpb053cod = pn_corr
                   and t.aqpb053est = 'E');
        commit;
      
        update aqpb053 t
           set t.aqpb053coderror = 1001,
               t.aqpb053desc     = 'Anulación Masiva',
               t.aqpb053est      = 'O'
         where t.aqpb053fecha = pn_fecha
           and t.aqpb053cod = pn_corr
           and t.aqpb053est = 'E';
        commit;
      
        select count(*)
          into nEva
          from aqpb053 x
         where x.aqpb053fecha = pn_fecha
           and x.aqpb053cod = pn_corr
           and x.aqpb053est = 'E';
      
        if nEva = 0 then
        
          update aqpb054 x
             set x.aqpb054est  = 'O',
                 x.aqpb054usue = pn_usuario,
                 x.aqpb054fed  = to_char(sysdate, 'DD/MM/YYYY'), --aqpb056hfcr
                 x.aqpb054hed  = to_char(sysdate, 'HH24:MI:SS')
           where x.aqpb054pgcod = pn_cod
             and x.aqpb054fecha = pn_fecha
             and x.aqpb054corr = pn_corr;
          commit;
        end if;
      
        if nRpta > 0 then
          pn_messa := 'La anulación fue exitosa.';
          pn_val   := 'W';
        else
          pn_messa := 'No se han anulado comprobantes.';
          pn_val   := 'E';
        end if;
      
      when nEst = 'O' then
        pn_messa := 'El comprobante seleccionado no tiene documentos disponibles para anular y/o observar';
        pn_val   := 'E';
      when nEst = 'R' then
        pn_messa := 'El comprobante seleccionado tiene adjuntado un archivo CDR, no puede ser anulado.';
        pn_val   := 'E';
    end case;
  
  end sp_cr_anular_comprob;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- Procedimiento para generar correlativos   
  Procedure sp_job_reprocesar_dia is
  begin
  
    begin
      -- Call the procedure
      pq_cr_facturacion_generacion.sp_cr_correc_dae_dia;
    end;
  
    begin
      -- Call the procedure
      pq_cr_facturacion_generacion.sp_cr_correc_nce_dia;
    end;
  
    begin
      -- Call the procedure
      pq_cr_facturacion_generacion.sp_cr_correc_nce_dia_2;
    end;
  
  end;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  -- **** PROCESO PARA PROCESAR LA GENERACIÓN DE CORR - DAE POR SCHEDULERS
  procedure sp_cr_sch_dae_his(pd_fecpro in date) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    --ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
      --and sucurs < 800
      --or sucurs >= 900
      ;
  
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini        := i.sucurs;
      ln_job        := ln_job + 1;
      lc_prefjob    := 'DAE_HIS_M';
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_facturacion_generacion.sp_cr_generar_DAE_his_suc( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini || ');' ||
                       ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Proc_Dae_H');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);
        end;
      Else
        dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate, -- + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'Proc_Dae_H');
        begin
          dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);
        end;
      End If;
      commit;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('DAEHIS_M', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                lc_hostname);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_Factura_Electronica.fn_cr_verifica_tarea(lc_prefjob,
                                                                  lc_hostname);
    End loop;
  
  end sp_cr_sch_dae_his;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Procedimiento para generar DAE's de contingencia con fechas históricas   
  procedure sp_cr_generar_DAE_his_suc(pn_fecha in date, pn_sucurs number) is
  
    lc_serie   char(4);
    lc_dae_cor number;
    lc_tipo    char(2);
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    --pn_fecha date;
  
    cursor dae_pendientes(lc_fecha date, lc_sucurs number) is
    
    -- AQPB056H HISTORICO DAE: VERIFIAR OPERACIONES
      select u.pgcod, u.itsuc, u.itmod, u.ittran, u.itnrel, u.rubro
        from (SELECT distinct h.pgcod  pgcod,
                              h.hsucor itsuc,
                              h.hcmod  itmod,
                              h.htran  ittran,
                              h.hnrel  itnrel,
                              --h. x.itcont,
                              (select to_number(substr(m.hrubro, 5, 2))
                                 from fsh016 m
                                where m.PGCOD = h.PGCOD
                                  and m.hsucor = h.hsucor
                                  and m.hcmod = h.hcmod
                                  and m.htran = h.htran
                                  and m.hnrel = h.hnrel
                                  and m.hfcon = h.hfcon
                                  and m.hcord = a.sr171trord
                                  AND ROWNUM = 1) rubro
                FROM fsh016 H, FSR171 F, FST171 G, fsh015 x, fsr171 a
               WHERE H.pgcod = 1
                    
                 and h.pgcod = x.pgcod
                 and h.hsucor = x.hsucor
                 and h.hcmod = x.hcmod
                 and h.htran = x.htran
                 and h.hnrel = x.hnrel
                 and h.hfcon = x.hfcon
                 and h.hfcon = lc_fecha
                    
                 and h.hsucor = lc_sucurs
                    
                 and a.st171cpcod = 15
                 and a.sr171tremp = 1 --1
                 and a.sr171trmod = h.hcmod --30
                 and a.sr171trnro = h.htran
                    
                 AND H.Hrubro NOT IN (4212290000007, 4222290000007)
                    
                 and h.pgcod = F.SR171TREMP
                 AND h.hcmod = F.SR171TRMOD
                 AND h.htran = F.SR171TRNRO
                 AND h.hcord = F.SR171TRORD
                 AND f.ST171CPCOD = G.ST171CPCOD
                    ---filtro op no conc
                 and f.st171cpcod not in
                     (select d.tp1nro1
                        from fst198 d
                       where d.tp1cod = 1
                         and d.tp1cod1 = 11120
                         and d.tp1corr1 = 1
                         and d.tp1corr2 = 3
                         and d.tp1corr3 >= 1)
                    
                    --- Validando existencia de transacciones en GP
                 and (h.hcmod, h.htran) in
                     (select t.tp1nro1, t.tp1nro2
                        from fst198 t
                       where t.tp1cod = 1
                         and t.tp1cod1 = 11120
                         and t.tp1corr1 = 10
                         and t.tp1corr2 = 1
                         and t.tp1corr3 <> 0
                         and t.tp1imp2 = 1)
                 and (h.hrubro) in
                     (select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('1418', '1428')
                         and x.pmtit = 1
                         and x.pmcap = 4
                         and x.pmpzo = 8
                         and x.pcnivc = 403
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5114', '5124')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 4
                         and x.pcnivc = 461
                      union
                      select x.rubro
                        from fsd014 x
                       where substr(x.rubro, 1, 4) in ('5117', '5127')
                         and x.pmtit = 5
                         and x.pmcap = 1
                         and x.pmpzo = 7
                         and x.pcnivc = 461
                      union
                      select to_number('2514020000005') rubro
                        from dual
                      union
                      select to_number('2524020000005') rubro
                        from dual
                      union
                      select to_number('2514020000013') rubro
                        from dual
                      union
                      select to_number('2524020000013') rubro
                        from dual
                      union
                      select to_number('2514020000008') rubro
                        from dual
                      union
                      select to_number('2524020000008') rubro
                        from dual
                      union
                      select to_number('2514020000002') rubro
                        from dual
                      union
                      select to_number('2524020000002') rubro
                        from dual
                      union
                      select to_number('2514020000007') rubro
                        from dual
                      union
                      select to_number('2524020000007') rubro
                        from dual
                       --2023
                       union
                        select to_number('2514020000015') rubro
                        from dual 
                       union
                       select to_number('2524020000015') rubro
                        from dual 
                       union
                       select to_number('2514020000020') rubro
                        from dual 
			                 union
                        select to_number('2524020000020') rubro
                        from dual
			                 union
                        select to_number('2514020000022') rubro
                        from dual
			                 union	
                        select to_number('2524020000022') rubro
                        from dual
                        -- 2023   
                        )
                 and h.hcimp1 > 0
                 and h.hcodmo = 2
                 and (h.pgcod, h.hsucor, h.hcmod, h.htran, h.hnrel, h.HFCON) not in
                     (select g.aqpb056hpgc,
                             g.aqpb056hsuc,
                             g.aqpb056hmod,
                             g.aqpb056htrx,
                             g.aqpb056hrel,
                             g.aqpb056hfemi
                        from aqpb056h g
                       where g.aqpb056hfemi = lc_fecha
                         and g.aqpb056htcomf = '13'
                         and g.aqpb056hsuc = lc_sucurs)) u
       where u.rubro in -- (3, 4) 20211212 dcastro se comento rubro para incluir guia de procesos
             (select c.TP1NRO1
                from fst198 c
               where c.tp1cod = 1
                 and c.tp1cod1 = 11120
                 and c.tp1corr1 = 1
                 and c.tp1corr2 = 23
                 and tp1imp1 = 1)
       order by u.pgcod, u.itmod, u.ittran, u.itsuc, u.itnrel
      
      ;
  
  begin
  
    lc_tipo := '13';
  
    for i in dae_pendientes(pn_fecha, pn_sucurs) loop
    
      --lc_dae_cor := lc_dae_cor + 1;
    
      -- 1. Obtener Serie y Correlativo            
      begin
        pq_cr_facturacion.sp_cr_Factura_Contingen(pn_rubro       => i.rubro,
                                                  pc_tipo        => 'MOV', --transaccion
                                                  pc_serie       => lc_serie, ---out
                                                  pc_correlativo => lc_dae_cor); ---out
      
        --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
        --dbms_output.put_line('Serie: ' || lc_serie);
        --dbms_output.put_line('Número: ' || lc_corre);
      
      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := trim(sqlerrm);
      end;
    
      begin
        insert into aqpb056
          (aqpb056tco,
           aqpb056ser,
           aqpb056num,
           aqpb056fem,
           aqpb056pgc,
           aqpb056mod,
           aqpb056suc,
           aqpb056trx,
           aqpb056rel,
           aqpb056fco)
        values
          (lc_tipo,
           lc_serie,
           lc_dae_cor,
           pn_fecha, ---p.hfcon
           i.pgcod, ---p.pgcod,
           i.itmod, ---p.hcmod,
           i.itsuc, ---p.hsucor,
           i.ittran, ---p.htran,
           i.itnrel, ---p.hnrel,
           pn_fecha ---p.hfcon
           );
      exception
        when others then
          null;
      end;
      commit;
    
    end loop;
  
  end sp_cr_generar_DAE_his_suc;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  -- Procedimiento para generar NCE's de contingencia de la fecha anterior a la fecha actual  

  procedure sp_cr_generar_NCE_his_prev(pn_fecha in date) is
  
    lc_serie   char(4);
    lc_nce_cor number;
    lc_tipo    char(2);
    lc_coderr  char(100);
    lc_msgerr  char(1000);
    --pn_fecha date;
    lv_doc_ori      char(2);
    lc_serieI       char(4);
    lc_correlativoI char(8);
    lc_fecha_dae    date;
  
    cursor nce_pendientes(lc_fecha date) is
    
    -- AQPB056 HISTORICO NCE: VERIFIAR OPERACIONES
      select ss.pgcod,
             ss.hcmod,
             ss.hsucor,
             ss.htran,
             ss.hnrel,
             ss.hfcon,
             ss.NRO_RELACION,
             ss.FECHA_TX,
             ss.rubro_ref
        from (SELECT y.pgcod,
                     y.hcmod,
                     y.hsucor,
                     y.htran,
                     y.hnrel,
                     y.hfcon,
                     y.NRO_RELACION,
                     y.FECHA_TX,
                     
                     (select to_number(substr(m.hrubro, 5, 2))
                        from fsh016 m
                       where m.pgcod = y.PGCOD
                         and m.hsucor = y.hsucor
                         and m.hcmod = (y.hcmod - 500)
                         and m.htran = y.htran
                         and m.hnrel = y.NRO_RELACION
                         and m.HFCON = y.FECHA_TX
                         and m.hcord = aa.sr171trord
                         and rownum = 1) rubro_ref
              
                FROM (select distinct a.pgcod,
                                      a.hcmod,
                                      a.hsucor,
                                      a.htran,
                                      a.hnrel,
                                      a.hfcon,
                                      (select max(f.txtext)
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 1) NRO_RELACION,
                                      (select to_date(f.txtext, 'DD/MM/RR')
                                         from fsx015 f
                                        where f.hfcon = a.hfcon
                                          and f.hcmod = a.hcmod
                                          and f.htran = a.htran
                                          and f.hnrel = a.hnrel
                                          and f.hsucor = a.hsucor
                                          and f.txcod = 0
                                          and f.txreng = 2) FECHA_TX --,
                      --,p.itimp1
                      --,p.rubro
                      
                        from fsx015 a, FSR170 b, fsh015 c, fsh016 p --, fsr171 aa
                       where a.hcmod = b.sr170trmod + 500
                         and a.htran = b.sr170trnro
                         and a.pgcod = 1
                         and a.hcmod > 499
                         and a.txcod = 0
                            
                         and a.pgcod = c.pgcod
                         and a.hcmod = c.hcmod
                         and a.hsucor = c.hsucor
                         and a.htran = c.htran
                         and a.hnrel = c.hnrel
                         and a.hfcon = c.hfcon
                         and c.hfcon = lc_fecha
                            ---and aa.st171cpcod = 15
                            --and aa.sr171tremp = 1 --1
                            --and aa.sr171trmod = p.ITMOD --30
                            --and aa.sr171trnro = p.ITTRAN      
                            
                         and p.pgcod = a.pgcod
                         and p.hsucor = a.hsucor
                         and p.hcmod = (a.hcmod - 500)
                         and p.htran = a.htran
                         and p.hnrel = (select max(f.txtext)
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 1)
                            
                         and a.hfcon = (select to_date(f.txtext, 'DD/MM/RR')
                                          from fsx015 f
                                         where f.hfcon = a.hfcon
                                           and f.hcmod = a.hcmod
                                           and f.htran = a.htran
                                           and f.hnrel = a.hnrel
                                           and f.hsucor = a.hsucor
                                           and f.txcod = 0
                                           and f.txreng = 2
                                        
                                        )
                            
                         and a.pgcod = 1
                            
                            --and a.hcmod = 530
                            --and a.hsucor = 2
                            --and a.htran = 397
                            --and a.hnrel = 3
                            
                            --
                         and a.hfcon >= p.HFCON
                         and a.hfcon = lc_fecha
                            --and p.HFCON >= to_date('2020.11.01', 'yyyy.mm.dd')
                         and p.HFCON >= lc_fecha_dae
                            
                            --- Validando existencia de transacciones en GP
                         and (a.hcmod, a.htran) in
                             (select (t.tp1nro1 + 500), t.tp1nro2
                                from fst198 t
                               where t.tp1cod = 1
                                 and t.tp1cod1 = 11120
                                 and t.tp1corr1 = 10
                                 and t.tp1corr2 = 1
                                 and t.tp1corr3 <> 0
                                 and t.tp1imp1 = 1)
                            
                            --- validando rubros
                         and (p.hrubro) in
                             (select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('1418', '1428')
                                 and x.pmtit = 1
                                 and x.pmcap = 4
                                 and x.pmpzo = 8
                                 and x.pcnivc = 403
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5114', '5124')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 4
                                 and x.pcnivc = 461
                              union
                              select x.rubro
                                from fsd014 x
                               where substr(x.rubro, 1, 4) in ('5117', '5127')
                                 and x.pmtit = 5
                                 and x.pmcap = 1
                                 and x.pmpzo = 7
                                 and x.pcnivc = 461
                              union
                              select to_number('2514020000005') rubro
                                from dual
                              union
                              select to_number('2524020000005') rubro
                                from dual
                              union
                              select to_number('2514020000013') rubro
                                from dual
                              union
                              select to_number('2524020000013') rubro
                                from dual
                              union
                              select to_number('2514020000008') rubro
                                from dual
                              union
                              select to_number('2524020000008') rubro
                                from dual
                              union
                              select to_number('2514020000002') rubro
                                from dual
                              union
                              select to_number('2524020000002') rubro
                                from dual
                              union
                              select to_number('2514020000007') rubro
                                from dual
                              union
                              select to_number('2524020000007') rubro
                                from dual
                                --2023
                               union
                                select to_number('2514020000015') rubro
                                from dual 
                               union
                               select to_number('2524020000015') rubro
                                from dual 
                               union
                               select to_number('2514020000020') rubro
                                from dual 
                               union
                                select to_number('2524020000020') rubro
                                from dual
                               union
                                select to_number('2514020000022') rubro
                                from dual
                               union	
                                select to_number('2524020000022') rubro
                                from dual
                                -- 2023  
                                )
                         and p.hcimp1 > 0
                         and p.hcodmo = 2
                         and (a.pgcod, a.hcmod, a.hsucor, a.htran, a.hnrel
                             --a.hfcon,
                             ) not in (select g.aqpb056pgc,
                                              g.aqpb056mod,
                                              g.aqpb056suc,
                                              g.aqpb056trx,
                                              g.aqpb056rel
                                         from aqpb056 g
                                        where g.aqpb056fem = lc_fecha
                                          and g.aqpb056tco = '87')) y,
                     fsr171 aa
               where aa.st171cpcod = 15
                 and aa.sr171tremp = 1 --1
                 and aa.sr171trmod = (y.hcmod - 500) --30
                 and aa.sr171trnro = y.htran) ss
       where ss.rubro_ref in -- (3, 4) 20211212 dcastro se comento rubro para incluir guia de procesos
             (select c.TP1NRO1
                from fst198 c
               where c.tp1cod = 1
                 and c.tp1cod1 = 11120
                 and c.tp1corr1 = 1
                 and c.tp1corr2 = 23
                 and tp1imp1 = 1)
       order by ss.pgcod, ss.hcmod, ss.hsucor, ss.htran, ss.hnrel, ss.hfcon;
  
  begin
  
    lc_tipo := '87';
  
    begin
      select to_date(t.tp1nro1, 'yyyymmdd')
        into lc_fecha_dae
        from fst198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11120
         and t.tp1corr1 = 9
         and t.tp1corr2 = 1
         and t.tp1corr3 = 7;
    exception
      when others then
        null;
    end;
  
    for i in nce_pendientes(pn_fecha) loop
    
      --determinar tipo del documento origen
    
      --dbms_output.put_line('i.hcmod ' || i.hcmod );
      --dbms_output.put_line('i.hsucor ' || i.hsucor );
      ---dbms_output.put_line('i.htran ' || i.htran );
      --dbms_output.put_line('i.NRO_RELACION ' || i.NRO_RELACION );
      --dbms_output.put_line('i.FECHA_TX ' || i.FECHA_TX );
    
      begin
        select distinct t.aqpb056tco, t.aqpb056ser, t.aqpb056num
          into lv_doc_ori, lc_serieI, lc_correlativoI
          from aqpb056 t
         where t.aqpb056pgc = i.pgcod
           and t.aqpb056mod = (i.hcmod - 500)
           and t.aqpb056suc = i.hsucor
           and t.aqpb056trx = i.htran
           and t.aqpb056rel = i.NRO_RELACION
           and t.aqpb056fco = i.FECHA_TX
           and t.aqpb056tco = '13';
      
      exception
        when no_data_found then
        
          begin
            select distinct t.aqpb056htcomf, t.aqpb056hseri, t.aqpb056hnum
              into lv_doc_ori, lc_serieI, lc_correlativoI
              from aqpb056h t
             where t.aqpb056hpgc = i.pgcod
               and t.aqpb056hmod = (i.hcmod - 500)
               and t.aqpb056hsuc = i.hsucor
               and t.aqpb056htrx = i.htran
               and t.aqpb056hrel = i.NRO_RELACION
               and t.aqpb056hfcon = i.FECHA_TX
               and t.aqpb056htcomf = '13';
          
          exception
            when no_data_found then
            
              lv_doc_ori      := null;
              lc_serieI       := null;
              lc_correlativoI := null;
          end;
        
      end;
    
      if lv_doc_ori is not null then
        begin
        
          -- 1. Obtener Serie y Correlativo            
          begin
            pq_cr_facturacion.sp_cr_Factura_Contingen(pn_rubro       => i.rubro_ref,
                                                      pc_tipo        => 'NC', --transaccion
                                                      pc_serie       => lc_serie, ---out
                                                      pc_correlativo => lc_nce_cor); ---out
          
            --dbms_output.put_line('Tipo Documento: ' || lc_tipo);           
            --dbms_output.put_line('Serie: ' || lc_serie);
            --dbms_output.put_line('Número: ' || lc_corre);
          
          exception
            when others then
            
              lc_coderr := sqlcode;
              lc_msgerr := trim(sqlerrm);
            
          end;
        
          begin
            insert into aqpb056
              (aqpb056tco,
               aqpb056ser,
               aqpb056num,
               aqpb056fem,
               aqpb056pgc,
               aqpb056mod,
               aqpb056suc,
               aqpb056trx,
               aqpb056rel,
               aqpb056fco,
               aqpb056tce,
               aqpb056see,
               aqpb056nro,
               aqpb056pge,
               aqpb056moe,
               aqpb056sue,
               aqpb056tre,
               aqpb056ree,
               aqpb056fce)
            values
              (lc_tipo,
               lc_serie,
               lc_nce_cor,
               pn_fecha, ---p.hfcon
               i.pgcod, ---p.pgcod,
               i.hcmod, ---p.hcmod,
               i.hsucor, ---p.hsucor,
               i.htran, ---p.htran,
               i.hnrel, ---p.hnrel,
               pn_fecha, ---p.hfcon             
               lv_doc_ori,
               lc_serieI,
               lc_correlativoI,
               i.pgcod, ---p.pgcod,
               (i.hcmod - 500),
               i.hsucor, ---p.hsucor,
               i.htran, ---p.htran,
               i.NRO_RELACION,
               i.FECHA_TX);
          exception
            when others then
              null;
          end;
          commit;
        end;
      end if;
    end loop;
  
  end sp_cr_generar_NCE_his_prev;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_inserta_lv_ebs(lc_fecha_ini in date, lc_fecha_fin in date) is
    -- *****************************************************************
    -- Nombre                       : sp_inserta_lv_ebs
    -- Sistema                      : BANTOTAL
    -- Módulo                       : se modifico para insertar aqpa470 en xxbol de EBS
    -- Versión                      : 1.0
    -- Fecha de Creación            : 27/05/2022
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 07/09/2023
    -- Autor de Modificación        : dcastro
    --                              : se descomento obtencion de tipo de cambio
    -- *****************************************************************
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
    cursor tabla is
    
      select --/* +all_rows */
       aqpa470serie,
       aqpa470nro,
       aqpa470pgcod,
       aqpa470mod,
       aqpa470sucor,
       aqpa470tran,
       aqpa470rel,
       aqpa470con,
       aqpa470cord,
       aqpa470subo,
       aqpa470ind,
       aqpa470rubro,
       aqpa470ccos,
       aqpa470femi,
       aqpa470tcomf,
       aqpa470seri,
       aqpa470num,
       aqpa470tdocr,
       aqpa470nruc,
       aqpa470rasoc,
       aqpa470fdref,
       aqpa470mtotal,
       aqpa470mtimp,
       aqpa470mtinf,
       aqpa470impt,
       aqpa470mone,
       aqpa470tcam,
       aqpa470tcomp,
       aqpa470sdref,
       aqpa470ndref,
       aqpa470lest,
       aqpa470csuna,
       apaq470imdeb,
       apaq470imhab,
       aqpa470mbim,
       aqpa470prvit,
       aqpa470total,
       aqpa470vvuig,
       aqpa470vvun,
       aqpa470item,
       aqpa470desc,
       aqpa470corr,
       aqpa470flag
        from aqpa470 a
       where a.aqpa470femi >= lc_fecha_ini
         and a.aqpa470femi <= lc_fecha_fin;
  
  begin
  
    --insertando en esquema ebs eliminando data en tabla temporal
    delete from xxbol.aqpa470T@ERP;
    commit;
  
    for i in tabla loop
      insert into xxbol.aqpa470T@ERP
        (aqpa470tserie,
         aqpa470tnro,
         aqpa470tpgcod,
         aqpa470tmod,
         aqpa470tsucor,
         aqpa470ttran,
         aqpa470trel,
         aqpa470tcon,
         aqpa470tcord,
         aqpa470tsubo,
         aqpa470tind,
         aqpa470trubro,
         aqpa470tccos,
         aqpa470tfemi,
         aqpa470ttcomf,
         aqpa470tseri,
         aqpa470tnum,
         aqpa470ttdocr,
         aqpa470tnruc,
         aqpa470trasoc,
         aqpa470tfdref,
         aqpa470tmtotal,
         aqpa470tmtimp,
         aqpa470tmtinf,
         aqpa470timpt,
         aqpa470tmone,
         aqpa470ttcam,
         aqpa470ttcomp,
         aqpa470tsdref,
         aqpa470tndref,
         aqpa470tlest,
         aqpa470tcsuna,
         apaq470imdeb,
         apaq470imhab,
         aqpa470tmbim,
         aqpa470tprvit,
         aqpa470ttotal,
         aqpa470tvvuig,
         aqpa470tvvun,
         aqpa470titem,
         aqpa470tdesc,
         aqpa470tcorr,
         aqpa470tflag)
      values
        (i.aqpa470serie,
         i.aqpa470nro,
         i.aqpa470pgcod,
         i.aqpa470mod,
         i.aqpa470sucor,
         i.aqpa470tran,
         i.aqpa470rel,
         i.aqpa470con,
         i.aqpa470cord,
         i.aqpa470subo,
         i.aqpa470ind,
         i.aqpa470rubro,
         i.aqpa470ccos,
         i.aqpa470femi,
         i.aqpa470tcomf,
         i.aqpa470seri,
         i.aqpa470num,
         i.aqpa470tdocr,
         i.aqpa470nruc,
         i.aqpa470rasoc,
         i.aqpa470fdref,
         i.aqpa470mtotal,
         i.aqpa470mtimp,
         i.aqpa470mtinf,
         i.aqpa470impt,
         i.aqpa470mone,
         i.aqpa470tcam,
         i.aqpa470tcomp,
         i.aqpa470sdref,
         i.aqpa470ndref,
         i.aqpa470lest,
         i.aqpa470csuna,
         i.apaq470imdeb,
         i.apaq470imhab,
         i.aqpa470mbim,
         i.aqpa470prvit,
         i.aqpa470total,
         i.aqpa470vvuig,
         i.aqpa470vvun,
         i.aqpa470item,
         i.aqpa470desc,
         i.aqpa470corr,
         i.aqpa470flag);
    
      commit;
    
    end loop;
  
    ---eliminando registros existentes
  
    delete from xxbol.aqpa470@ERP a
     where a.aqpa470femi >= lc_fecha_ini
       and a.aqpa470femi <= lc_fecha_fin;
    commit;
  
    --insertando de tabla temporal
    insert into xxbol.aqpa470@ERP
      (aqpa470serie,
       aqpa470nro,
       aqpa470pgcod,
       aqpa470mod,
       aqpa470sucor,
       aqpa470tran,
       aqpa470rel,
       aqpa470con,
       aqpa470cord,
       aqpa470subo,
       aqpa470ind,
       aqpa470rubro,
       aqpa470ccos,
       aqpa470femi,
       aqpa470tcomf,
       aqpa470seri,
       aqpa470num,
       aqpa470tdocr,
       aqpa470nruc,
       aqpa470rasoc,
       aqpa470fdref,
       aqpa470mtotal,
       aqpa470mtimp,
       aqpa470mtinf,
       aqpa470impt,
       aqpa470mone,
       aqpa470tcam,
       aqpa470tcomp,
       aqpa470sdref,
       aqpa470ndref,
       aqpa470lest,
       aqpa470csuna,
       apaq470imdeb,
       apaq470imhab,
       aqpa470mbim,
       aqpa470prvit,
       aqpa470total,
       aqpa470vvuig,
       aqpa470vvun,
       aqpa470item,
       aqpa470desc,
       aqpa470corr,
       aqpa470flag)
      select aqpa470tserie,
             aqpa470tnro,
             aqpa470tpgcod,
             aqpa470tmod,
             aqpa470tsucor,
             aqpa470ttran,
             aqpa470trel,
             aqpa470tcon,
             aqpa470tcord,
             aqpa470tsubo,
             aqpa470tind,
             aqpa470trubro,
             aqpa470tccos,
             aqpa470tfemi,
             aqpa470ttcomf,
             aqpa470tseri,
             aqpa470tnum,
             aqpa470ttdocr,
             aqpa470tnruc,
             aqpa470trasoc,
             aqpa470tfdref,
             aqpa470tmtotal,
             aqpa470tmtimp,
             aqpa470tmtinf,
             aqpa470timpt,
             aqpa470tmone,
             aqpa470ttcam,
             aqpa470ttcomp,
             aqpa470tsdref,
             aqpa470tndref,
             aqpa470tlest,
             aqpa470tcsuna,
             apaq470imdeb,
             apaq470imhab,
             aqpa470tmbim,
             aqpa470tprvit,
             aqpa470ttotal,
             aqpa470tvvuig,
             aqpa470tvvun,
             aqpa470titem,
             aqpa470tdesc,
             aqpa470tcorr,
             aqpa470tflag
        from xxbol.aqpa470T@ERP; ---tabla temporal - data del mes de proceso
  
    commit;
  
  end sp_inserta_lv_ebs;

  procedure sp_inserta_lvebs_I(lc_serie in varchar2, ln_corr in number) is
    -- *****************************************************************
    -- Nombre                       : sp_inserta_lvebs_I
    -- Sistema                      : BANTOTAL
    -- Módulo                       : se modifico para insertar aqpa470 en xxbol de EBS InDIVIDUAL
    -- Versión                      : 1.0
    -- Fecha de Creación            : 27/05/2022
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 
    -- Autor de Modificación        : 
    -- *****************************************************************
  
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
    cursor tabla is
      select aqpa470serie,
             aqpa470nro,
             aqpa470pgcod,
             aqpa470mod,
             aqpa470sucor,
             aqpa470tran,
             aqpa470rel,
             aqpa470con,
             aqpa470cord,
             aqpa470subo,
             aqpa470ind,
             aqpa470rubro,
             aqpa470ccos,
             aqpa470femi,
             aqpa470tcomf,
             aqpa470seri,
             aqpa470num,
             aqpa470tdocr,
             aqpa470nruc,
             aqpa470rasoc,
             aqpa470fdref,
             aqpa470mtotal,
             aqpa470mtimp,
             aqpa470mtinf,
             aqpa470impt,
             aqpa470mone,
             aqpa470tcam,
             aqpa470tcomp,
             aqpa470sdref,
             aqpa470ndref,
             aqpa470lest,
             aqpa470csuna,
             apaq470imdeb,
             apaq470imhab,
             aqpa470mbim,
             aqpa470prvit,
             aqpa470total,
             aqpa470vvuig,
             aqpa470vvun,
             aqpa470item,
             aqpa470desc,
             aqpa470corr,
             aqpa470flag
        from aqpa470 a
       where a.aqpa470serie = lc_serie
         and a.aqpa470nro = ln_corr;
  
  begin
  
    -- eliminando comprobante antes de insertar  2023
    delete from xxbol.aqpa470@ERP t
     where t.aqpa470serie = lc_serie
       and t.aqpa470nro = ln_corr;
    commit;
  
    --insertando en esquema ebs
    for i in tabla loop
      insert into xxbol.aqpa470@ERP
        (aqpa470serie,
         aqpa470nro,
         aqpa470pgcod,
         aqpa470mod,
         aqpa470sucor,
         aqpa470tran,
         aqpa470rel,
         aqpa470con,
         aqpa470cord,
         aqpa470subo,
         aqpa470ind,
         aqpa470rubro,
         aqpa470ccos,
         aqpa470femi,
         aqpa470tcomf,
         aqpa470seri,
         aqpa470num,
         aqpa470tdocr,
         aqpa470nruc,
         aqpa470rasoc,
         aqpa470fdref,
         aqpa470mtotal,
         aqpa470mtimp,
         aqpa470mtinf,
         aqpa470impt,
         aqpa470mone,
         aqpa470tcam,
         aqpa470tcomp,
         aqpa470sdref,
         aqpa470ndref,
         aqpa470lest,
         aqpa470csuna,
         apaq470imdeb,
         apaq470imhab,
         aqpa470mbim,
         aqpa470prvit,
         aqpa470total,
         aqpa470vvuig,
         aqpa470vvun,
         aqpa470item,
         aqpa470desc,
         aqpa470corr,
         aqpa470flag)
      values
        (i.aqpa470serie,
         i.aqpa470nro,
         i.aqpa470pgcod,
         i.aqpa470mod,
         i.aqpa470sucor,
         i.aqpa470tran,
         i.aqpa470rel,
         i.aqpa470con,
         i.aqpa470cord,
         i.aqpa470subo,
         i.aqpa470ind,
         i.aqpa470rubro,
         i.aqpa470ccos,
         i.aqpa470femi,
         i.aqpa470tcomf,
         i.aqpa470seri,
         i.aqpa470num,
         i.aqpa470tdocr,
         i.aqpa470nruc,
         i.aqpa470rasoc,
         i.aqpa470fdref,
         i.aqpa470mtotal,
         i.aqpa470mtimp,
         i.aqpa470mtinf,
         i.aqpa470impt,
         i.aqpa470mone,
         i.aqpa470tcam,
         i.aqpa470tcomp,
         i.aqpa470sdref,
         i.aqpa470ndref,
         i.aqpa470lest,
         i.aqpa470csuna,
         i.apaq470imdeb,
         i.apaq470imhab,
         i.aqpa470mbim,
         i.aqpa470prvit,
         i.aqpa470total,
         i.aqpa470vvuig,
         i.aqpa470vvun,
         i.aqpa470item,
         i.aqpa470desc,
         i.aqpa470corr,
         i.aqpa470flag);
    
      commit;
    
    end loop;
  
  end sp_inserta_lvebs_I;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_insertar_lib_ventas_I(pc_serie in varchar2,
                                     pn_corr  in number) is
  
    -- 2023.04.05 dcastro se  elimino condición para cargar directamente el comprobante enviado
  
    -- pn_fecha     date; -- <======= 1. VARIABLE DE ENTRADA
    pr_flag      number;
    lc_fecha_fin date;
    lc_fecha_ini date;
    lc_coderr    char(100);
    lc_msgerr    char(1000);
  
    laqpa460item   number;
    laqpa460desc   varchar2(50);
    laqpa460tcomf  varchar2(2);
    laqpa460seri   varchar2(4);
    laqpa460num    number;
    laqpa460tdocr  varchar2(1);
    laqpa460nruc   varchar2(15);
    laqpa460rasoc  varchar2(1500);
    laqpa460fdref  varchar2(10);
    laqpa460mtotal number;
    laqpa460mtimp  number;
    laqpa460mtinf  number;
    laqpa460impt   number;
    laqpa460mone   varchar2(3);
    laqpa460tcam   number;
    laqpa460tcomp  number;
    laqpa460sdref  varchar2(50);
    laqpa460ndref  number;
    laqpa460csuna  varchar2(8);
    ltcam          number(14, 8);
    ltipcam        number(14, 8);
    ld_feccam      date;
    ld_fechaemi    date;
    ld_fecha       date;
    lc_estado      char(1);
  
    ln_cantitem number; --2023 dcastro
  
    lc_minimo varchar2(50); -- 15.04.2023 dcastro se agrego
  
    cursor datos_a is
      select aqpa470serie,
             aqpa470nro,
             aqpa470total,
             aqpa470con,
             aqpa470femi
        from aqpa470 a
       where a.aqpa470serie = pc_serie
         and a.aqpa470nro = pn_corr;
  
    cursor movimientos_fa is
      select distinct a.aqpa465serie,
                      a.aqpa465corr,
                      a.aqpa465con,
                      a.aqpa465pgcod,
                      a.aqpa465mod,
                      a.aqpa465sucor,
                      a.aqpa465tran,
                      a.aqpa465rel,
                      a.aqpa465est,
                      b.aqpa460femi
        from AQPA465 a, aqpa460 b
       where b.aqpa460seri = a.aqpa465serie
         and b.aqpa460num = a.aqpa465corr
         and a.aqpa465serie = pc_serie
         and a.aqpa465corr = pn_corr;
  
    cursor movimientos_nc is
      select distinct a.aqpa466serie,
                      a.aqpa466corr,
                      aqpa460fcone, --a.aqpa466pgcod , a.aqpa466mod, a.aqpa466sucor, a.aqpa466tran, a.aqpa466rel ,
                      b.aqpa460femi,
                      b.aqpa460pgce,
                      b.aqpa460mode,
                      b.aqpa460suce,
                      b.aqpa460trxe,
                      b.aqpa460rele
        from AQPA466 a, aqpa460 b
       where b.aqpa460seri = a.aqpa466serie
         and b.aqpa460num = a.aqpa466corr
         and a.aqpa466serie = pc_serie
         and a.aqpa466corr = pn_corr;
  
  begin
  
    --Eliminar datos
    delete from AQPA470 t
     where t.aqpa470serie = pc_serie
       and t.aqpa470nro = pn_corr;
    commit;
  
    -----*******CARGA MASIVA REGULARIZACION FACTURACION y NOTA DE CREDITO ************************-------------
  
    for i in movimientos_fa loop
      begin
        insert into AQPA470
          (aqpa470serie,
           aqpa470nro,
           aqpa470seri,
           aqpa470num,
           aqpa470pgcod,
           aqpa470mod,
           aqpa470sucor,
           aqpa470tran,
           aqpa470rel,
           aqpa470con,
           aqpa470femi,
           AQPA470LEST,
           aqpa470cord,
           aqpa470subo,
           aqpa470ind,
           aqpa470total,
           aqpa470vvun,
           aqpa470vvuig,
           aqpa470prvit,
           aqpa470mbim,
           aqpa470rubro,
           AQPA470CCOS)
        
          select i.aqpa465serie,
                 i.aqpa465corr,
                 i.aqpa465serie,
                 i.aqpa465corr,
                 i.aqpa465pgcod,
                 i.aqpa465mod,
                 i.aqpa465sucor,
                 i.aqpa465tran,
                 i.aqpa465rel,
                 i.aqpa465con,
                 i.aqpa460femi, --aqpa465con,
                 i.aqpa465est,
                 y.hcord,
                 y.hcsubo,
                 y.hcodmo,
                 y.hcimp1,
                 y.hcimp1,
                 y.hcimp1,
                 y.hcimp1,
                 0,
                 y.hrubro,
                 y.hsucur
            from fsh016 Y
           where y.pgcod = i.aqpa465pgcod
             and y.hcmod = i.aqpa465mod
             and y.hsucor = i.aqpa465sucor
             and y.htran = i.aqpa465tran
             and y.hnrel = i.aqpa465rel
             and y.hfcon = i.aqpa465con;
        commit;
      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := trim(sqlerrm);
      end;
    
    end loop;
    --NC
    for i in movimientos_nc loop
      begin
        insert into AQPA470
          (aqpa470serie,
           aqpa470nro,
           aqpa470seri,
           aqpa470num,
           aqpa470pgcod,
           aqpa470mod,
           aqpa470sucor,
           aqpa470tran,
           aqpa470rel,
           aqpa470con,
           aqpa470femi,
           aqpa470cord,
           aqpa470subo,
           aqpa470ind,
           aqpa470total,
           aqpa470vvun,
           aqpa470vvuig,
           aqpa470prvit,
           aqpa470mbim,
           aqpa470rubro,
           AQPA470CCOS)
        
          select /*+all_rows*/
           i.aqpa466serie,
           i.aqpa466corr,
           i.aqpa466serie,
           i.aqpa466corr, --x.aqpa466pgcod , x.aqpa466mod, x.aqpa466sucor, x.aqpa466tran, x.aqpa466rel, x.aqpa466con,x.aqpa466con,
           i.aqpa460pgce,
           i.aqpa460mode,
           i.aqpa460suce,
           i.aqpa460trxe,
           i.aqpa460rele,
           i.aqpa460fcone,
           i.aqpa460femi, --aqpa460fcone,
           y.hcord,
           y.hcsubo,
           y.hcodmo,
           y.hcimp1,
           y.hcimp1,
           y.hcimp1,
           y.hcimp1,
           0,
           y.hrubro,
           y.hsucur
            from fsh016 Y
           where y.pgcod = i.aqpa460pgce
             and y.hcmod = i.aqpa460mode
             and y.hsucor = i.aqpa460suce
             and y.htran = i.aqpa460trxe
             and y.hnrel = i.aqpa460rele
             and y.hfcon = i.aqpa460fcone
             and substr(y.hrubro, 1, 4) not in ('1418', '1428');
        commit;
      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := trim(sqlerrm);
      end;
    
    end loop;
  
    ------****----PASO 2
    ---------------------
    for i in datos_a loop
    
      ld_fecha := i.aqpa470femi; --2022/12/16 se cambio por fecha de emision ld_fecha := i.aqpa470con;
    
      begin
        select aqpa460tcomf,
               aqpa460seri,
               aqpa460num,
               aqpa460tdocr,
               aqpa460nruc,
               aqpa460rasoc,
               aqpa460fdref,
               aqpa460mtotal,
               aqpa460mtimp,
               aqpa460mtinf,
               aqpa460impt,
               aqpa460mone,
               aqpa460tcomp,
               aqpa460sdref,
               aqpa460ndref,
               aqpa460csuna,
               aqpa460femi
          into laqpa460tcomf,
               laqpa460seri,
               laqpa460num,
               laqpa460tdocr,
               laqpa460nruc,
               laqpa460rasoc,
               laqpa460fdref,
               laqpa460mtotal,
               laqpa460mtimp,
               laqpa460mtinf,
               laqpa460impt,
               laqpa460mone,
               laqpa460tcomp,
               laqpa460sdref,
               laqpa460ndref,
               laqpa460csuna,
               ld_fechaemi
          from aqpa460 b
         where b.aqpa460seri = i.aqpa470serie
           and b.aqpa460num = i.aqpa470nro
           and rownum = 1;
      
      exception
        when others then
          laqpa460tcomf  := null;
          laqpa460seri   := null;
          laqpa460num    := null;
          laqpa460tdocr  := null;
          laqpa460nruc   := null;
          laqpa460rasoc  := null;
          laqpa460fdref  := null;
          laqpa460mtotal := null;
          laqpa460mtimp  := null;
          laqpa460mtinf  := null;
          laqpa460impt   := null;
          laqpa460mone   := null;
          laqpa460tcam   := null;
          laqpa460tcomp  := null;
          laqpa460sdref  := null;
          laqpa460ndref  := null;
          laqpa460csuna  := null;
          ld_fechaemi    := null;
        
      end;
    
      if laqpa460nruc is not null then
        --si es diferente de nulo ACTUALIZA LA DATA 
      
        if i.aqpa470serie in ('FC01', 'BC01', 'FG01', 'FT01') then
        
          begin
            select b.aqpa466est
              into lc_estado
              from aqpa466 b
             where b.aqpa466serie = i.aqpa470serie
               and b.aqpa466corr = i.aqpa470nro;
          exception
            when others then
              lc_estado := null;
          end;
        
        else
        
          begin
            select b.aqpa465est
              into lc_estado
              from aqpa465 b
             where b.aqpa465serie = i.aqpa470serie
               and b.aqpa465corr = i.aqpa470nro;
          exception
            when others then
              lc_estado := null;
          end;
        
        end if;
      
        --obtiene valor de estado
        if lc_estado is not null then
          if lc_estado = 'E' then
            lc_estado := 'R';
          end if;
        else
          lc_estado := 'R';
        end if;
      
        --actualizando todos los registros del asiento
        begin
          update aqpa470 b
             set aqpa470tcomf = laqpa460tcomf,
                 aqpa470tdocr = laqpa460tdocr,
                 aqpa470nruc  = laqpa460nruc,
                 aqpa470rasoc = laqpa460rasoc,
                 aqpa470fdref = laqpa460fdref,
                 aqpa470mone  = laqpa460mone,
                 aqpa470tcomp = laqpa460tcomp,
                 aqpa470sdref = laqpa460sdref,
                 aqpa470ndref = laqpa460ndref,
                 aqpa470csuna = laqpa460csuna,
                 --                     aqpa470tcam   = ltipcam,
                 aqpa470mtotal = laqpa460mtotal,
                 aqpa470mtimp  = laqpa460mtimp,
                 aqpa470mtinf  = laqpa460mtinf,
                 aqpa470impt   = laqpa460impt,
                 aqpa470femi   = ld_fechaemi,
                 aqpa470lest   = lc_estado
          --aqpa470flag   = 'S' usado solo para la regularizacion por SUNAT
           where b.aqpa470seri = i.aqpa470serie
             and b.aqpa470num = i.aqpa470nro
             and b.aqpa470nruc is null;
        
          commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
        end;
      
      end if;
    
      --actualiza por concepto
      begin
        select aqpa460item, aqpa460desc
          into laqpa460item, laqpa460desc
          from aqpa460 b
         where b.aqpa460seri = i.aqpa470serie
           and b.aqpa460num = i.aqpa470nro
           and b.aqpa460total = i.aqpa470total;
      exception
        when others then
          laqpa460item := null;
          laqpa460desc := null;
      end;
    
      --actualizando todos los registros del asiento
      begin
        update aqpa470 b
           set b.aqpa470item = laqpa460item, b.aqpa470desc = laqpa460desc
         where b.aqpa470seri = i.aqpa470serie
           and b.aqpa470num = i.aqpa470nro
           and b.aqpa470total = i.aqpa470total;
        commit;
      exception
        when others then
          lc_coderr := sqlcode;
          lc_msgerr := trim(sqlerrm);
      end;
    
      --   end if;
    
      ld_fecha := i.aqpa470con; ---ACTUALIZAR TIPO CAMBIO 
    
    end loop;
  
    --for i in 1..31 loop
    --obtener TC       
    begin
      select max(conversion_date)
        into ld_feccam
        from gl_daily_rates@erp f
       where conversion_type = 1001
         and from_currency = 'USD'
         and to_currency = 'PEN'
         and conversion_date <= ld_fecha;
    exception
      when others then
        null;
    end;
  
    begin
      select conversion_rate
        into ltcam
        from gl_daily_rates@erp f
       where conversion_type = 1001
         and from_currency = 'USD'
         and to_currency = 'PEN'
         and conversion_date = ld_feccam;
    exception
      when others then
        ltcam := null;
    end;
    ---fin TC   
  
    ltipcam := ltcam;
  
    begin
      update aqpa470 b
         set aqpa470tcam = ltipcam
       where b.aqpa470serie = pc_serie
         and b.aqpa470nro = pn_corr
         and b.aqpa470mone = 'USD';
      commit;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpa470 b
         set aqpa470tcam = 0
       where b.aqpa470serie = pc_serie
         and b.aqpa470nro = pn_corr
         and b.aqpa470mone = 'PEN';
      commit;
    exception
      when others then
        null;
    end;
  
    ---15.04.2023 dcastro se agrego
    --verificar item
    begin
      select count(*)
        into ln_cantitem
        from aqpa470 a
       where a.aqpa470serie = pc_serie
         and a.AQPA470NRO = pn_corr
         and a.AQPA470ITEM = 1;
    exception
      when others then
        ln_cantitem := 0;
    end;
  
    if ln_cantitem = 0 then
      begin
        select min(a.AQPA470CORD)
          into lc_minimo
          from aqpa470 a
         where a.aqpa470serie = pc_serie
           and a.AQPA470NRO = pn_corr
           and a.aqpa470rubro not like '9%';
      exception
        when others then
          lc_minimo := null;
      end;
    
      begin
        update aqpa470 a
           set a.AQPA470ITEM = 1
         where a.aqpa470serie = pc_serie
           and a.AQPA470NRO = pn_corr
           and a.AQPA470CORD = lc_minimo;
        commit;
      exception
        when others then
          null;
      end;
    
    elsif ln_cantitem > 1 then
    
      begin
        select min(a.AQPA470CORD)
          into lc_minimo
          from aqpa470 a
         where a.aqpa470serie = pc_serie
           and a.AQPA470NRO = pn_corr
           and a.AQPA470ITEM = 1
           and a.aqpa470rubro not like '9%';
      exception
        when others then
          lc_minimo := null;
      end;
      if lc_minimo = null then
        begin
          select min(a.AQPA470CORD)
            into lc_minimo
            from aqpa470 a
           where a.aqpa470serie = pc_serie
             and a.AQPA470NRO = pn_corr
             and a.aqpa470rubro not like '9%';
        exception
          when others then
            lc_minimo := null;
        end;
      end if;
    
      begin
        update aqpa470 a
           set a.AQPA470ITEM = null
         where a.aqpa470serie = pc_serie
           and a.AQPA470NRO = pn_corr
           and a.AQPA470ITEM = 1;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpa470 a
           set a.AQPA470ITEM = 1
         where a.aqpa470serie = pc_serie
           and a.AQPA470NRO = pn_corr
           and a.AQPA470CORD = lc_minimo;
        commit;
      exception
        when others then
          null;
      end;
    
    end if;
  
    -----
  
  end sp_insertar_lib_ventas_I;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualiza_estado_lv(lc_serie  in varchar2,
                                   ln_corr   in number,
                                   lc_codest in varchar2) is
    -- *****************************************************************
    -- Nombre                       : sp_actualiza_est656670
    -- Sistema                      : BANTOTAL
    -- Módulo                       : sp_actualiza_estado actualiza estado aqpa470,aqpa465, aqpa466
    -- Versión                      : 1.0
    -- Fecha de Creación            : 2023/10/01
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 
    -- Autor de Modificación        : 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  begin
  
    begin
      update AQPA470 A
         set a.aqpa470lest = lc_codest
       WHERE A.aqpa470serie = lc_serie
         and A.aqpa470nro = ln_corr; -- 
    exception
      when others then
        null;
    end;
  
    begin
      update aqpa465 a
         set a.aqpa465est = lc_codest
       where aqpa465serie = lc_serie
         and aqpa465corr = ln_corr; -- 
    exception
      when others then
        null;
    end;
  
    begin
      update aqpa466 a
         set a.aqpa466est = lc_codest
       where aqpa466serie = lc_serie
         and aqpa466corr = ln_corr; -- 
    exception
      when others then
        null;
    end;
  
    commit;
    --actualiza en ebs    
    begin
      pq_cr_facturacion_generacion.sp_inserta_lvebs_i(lc_serie => lc_serie,
                                                      ln_corr  => ln_corr);
    exception
      when others then
        null;
    end;
  
  end sp_actualiza_estado_lv;
  -------------------------------------------------------------------------------
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualiza_EST6566(ld_fecha in date) is
    -- *****************************************************************
    -- Nombre                       : sp_actualiza_est6566
    -- Sistema                      : BANTOTAL
    -- Módulo                       : sp_actualiza_estado actualiza aqpa465, aqpa466
    -- Versión                      : 1.0
    -- Fecha de Creación            : 2023/10/01
    -- Autor de Creación            : dcastro
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 
    -- Autor de Modificación        : 
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 cursor listado is

    select distinct AQPA460SERI, AQPA460NUM
     from aqpa465 a , aqpa460 b
    where b.aqpa460seri = a.aqpa465serie
      and b.aqpa460num = a.aqpa465corr 
      and a.aqpa465con >= ld_fecha
      and a.aqpa465est = 'E'
      AND ( A.AQPA465MSGS LIKE '%ya existe y cuenta con CDR%'  OR  A.AQPA465MSGS LIKE '%ya existe pero no cuenta con CDR%')
    UNION
    select distinct AQPA460SERI, AQPA460NUM 
     from aqpa466 a , aqpa460 b
    where b.aqpa460seri = a.aqpa466serie
      and b.aqpa460num = a.aqpa466corr 
      and a.aqpa466con >= ld_fecha
      and a.aqpa466est = 'E'
      AND A.AQPA466MSGS LIKE '%ya existe y cuenta con CDR%';

  lc_codest char(1):= 'A';
  ln_cantidad number := 0;
  
  begin
      
      for i in listado loop 
      
        begin
          update aqpa465 a
             set a.aqpa465est = lc_codest  
           where aqpa465serie = i.AQPA460SERI
             and aqpa465corr  = i.AQPA460NUM; -- 
        exception
          when others then
            null;
        end;
      
        begin
          update aqpa466 a
             set a.aqpa466est = lc_codest
           where aqpa466serie = i.AQPA460SERI
             and aqpa466corr  = i.AQPA460NUM; -- 
        exception
          when others then
            null;
        end;
     
      
        begin
           select count(*) 
             into ln_cantidad
             from AQPA470 A
            WHERE A.aqpa470serie = i.AQPA460SERI
              and A.aqpa470nro   = i.AQPA460NUM;
        exception when others then
           ln_cantidad := 0;    
        end;

        commit;
        
        if ln_cantidad > 0 then
      
            begin
              update AQPA470 A
                 set a.aqpa470lest = lc_codest
               WHERE A.aqpa470serie = i.AQPA460SERI
                 and A.aqpa470nro   = i.AQPA460NUM; -- 
            exception
              when others then
                null;
            end;
             commit;  
            --actualiza en ebs    
            begin
              pq_cr_facturacion_generacion.sp_inserta_lvebs_i(lc_serie => i.AQPA460SERI,
                                                              ln_corr  => i.AQPA460NUM);
            exception
              when others then
                null;
            end;
        
        end if;
      
      end loop;
     
      
  end sp_actualiza_EST6566;
  -------------------------------------------------------------------------------
procedure sp_cr_insertar_datos1(pd_fecpro    in date,
                                 pd_resultado out number) is
  
    lc_limite number(18) := 0;
    lc_indice number(18) := 0;
    lc_corr   number := 0;
    --lc_indicador number := 0;
    lc_pgcod     number := 1;
    lc_found_cur boolean := false;
    lc_total     number := 0;
  
    cursor cur_registros is
      select distinct t.aqpa460tcomf aqpb052tcomf, --C1: Tipo de documento
                      t.aqpa460seri  aqpb052seri, --C2: Número de serie del documento
                      t.aqpa460num   aqpb052num, --C3: Número correlativo del documento
                      t.aqpa460mone  aqpb052mone, --C4: Tipo de moneda del comprobante
                      --'2101' aqpb052tipope,             
                      nvl(pq_cr_facturacion_generacion.fn_tipo_operacion(t.aqpa460pgc,
                                                                         t.aqpa460mod,
                                                                         t.aqpa460suc,
                                                                         t.aqpa460trx,
                                                                         t.aqpa460rel,
                                                                         t.aqpa460femi,
                                                                         t.aqpa460tcomf,
                                                                         t.aqpa460seri,
                                                                         t.aqpa460num),
                          '0000') aqpb052tipope, --C5: Tipo de operación no gravada
                      t.aqpa460tdocr aqpb052tdoc, --C6: Tipo de documento de identidad del cliente
                      t.aqpa460nruc aqpb052nruc, --C7: Número de documento de Identidad del cliente
                      
                      --replace(t.aqpa460rasoc, 'Ñ', 'N') aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente
                      pq_cr_facturacion_generacion.fn_acondcionar_rsocial(t.aqpa460rasoc) aqpb052rasoc, --C8: Apellidos y nombres,  denominación o razón social del cliente
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     1,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052incuo, --C9: Monto del interés de la cuota
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     2,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052inmor, --C10: Monto del interés moratorio de corresponder
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     3,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052segfac, --C11: Monto total de seguros facturados 
                      pq_cr_facturacion_generacion.fn_concepto_monto(t.aqpa460pgc,
                                                                     t.aqpa460mod,
                                                                     t.aqpa460suc,
                                                                     t.aqpa460trx,
                                                                     t.aqpa460rel,
                                                                     t.aqpa460femi,
                                                                     t.aqpa460fcone,
                                                                     4,
                                                                     t.aqpa460tcomf,
                                                                     t.aqpa460seri,
                                                                     t.aqpa460num) aqpb052otrcon, --C12: Monto total de otros conceptos facturados
                      0 aqpb052opina, --C13: Total valor de venta - operaciones inafectas
                      0 aqpb052opexa, --C14: Total valor de venta - operaciones exoneradas
                      0 aqpb052impt, --C15: Importe total a pagar 
                      
                      t.aqpa460cmem  aqpb052tdref, --C16: Tipo de documento que se modifica
                      t.aqpa460sdref aqpb052nsref, --C17: Número de serie del documento que se modifica
                      t.aqpa460ndref aqpb052ndref, --C18: Número correlativo del documento que se modifica
                      
                      t.aqpa460fotrc aqpb052fotrc, --C19: Fecha de otorgamiento del crédito/Linea de crédito
                      /*pq_cr_facturacion_generacion.fn_concepto_monto(
                                   t.aqpa460pgc,      
                                   t.aqpa460mod,       
                                   t.aqpa460suc,      
                                   t.aqpa460trx,      
                                   t.aqpa460rel,
                                   t.aqpa460femi,
                                   5
                      ) aqpb052mcred,*/
                      pq_cr_facturacion_generacion.fn_obtener_capital(t.aqpa460pgc,
                                                                      t.aqpa460mod,
                                                                      t.aqpa460suc,
                                                                      t.aqpa460trx,
                                                                      t.aqpa460rel,
                                                                      t.aqpa460femi,
                                                                      t.aqpa460fcone,
                                                                      t.aqpa460tcomf,
                                                                      t.aqpa460seri,
                                                                      t.aqpa460num) aqpb052mcred, --C20: Monto del crédito otorgado (capital)
                      t.aqpa460ncont aqpb052ncon, --C21: Número de contrato
                      
                      '' aqpb052npol, --C22: Número de póliza
                      null aqpb052ficob, --C23: Fecha de inicio de vigencia de cobertura
                      null aqpb052ffcob, --C24: Fecha de término de vigencia de cobertura
                      '' aqpb052tseg, --C25: Tipo de seguro
                      0 aqpb052scob, --C26: Suma asegurada / alcance de cobertura o monto                                                        
                      
                      t.aqpa460pgc   aqpb052pgc,
                      t.aqpa460mod   aqpb052mod,
                      t.aqpa460suc   aqpb052suc,
                      t.aqpa460trx   aqpb052trx,
                      t.aqpa460rel   aqpb052rel,
                      t.aqpa460femi  aqpb052femi,
                      t.aqpa460pgce  aqpb052pgce,
                      t.aqpa460mode  aqpb052mode,
                      t.aqpa460suce  aqpb052suce,
                      t.aqpa460trxe  aqpb052trxe,
                      t.aqpa460rele  aqpb052rele,
                      t.aqpa460fcone aqpb052fcone
      --t.aqpa460ore,
        from aqpa460 t
       where t.aqpa460femi = pd_fecpro
         and t.aqpa460tcomf in ('13', '87', '88')
         and not exists (select 'x'
                from aqpb053 s
               where
              
               s.aqpb053tcomf = t.aqpa460tcomf
            and s.aqpb053seri = t.aqpa460seri
            and s.aqpb053num = t.aqpa460num
            and s.aqpb053est in ('E', 'R') ---Emitido
              )
      
       order by t.aqpa460tcomf, t.aqpa460seri, t.aqpa460num;
  
  begin
  
    begin
      /*-------Límite por registros---------*/
      select d.tp1nro1
        into lc_limite
        from fst198 d
       where d.tp1cod = 1
         and d.tp1cod1 = 11120
         and d.tp1corr1 = 9
         and d.tp1corr2 = 1
         and d.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    /*---Seleccionar correlativo maximo---*/
    begin
      sp_correl_sq(p_c_nomseq => 'SEQ_COMPROBANTE_SEE',
                   p_c_codusu => 'BANTOTAL',
                   p_n_correl => lc_corr); --out
    exception
      when others then
        null;
    end;
  
    /*---Recorres registros---*/
    for registro in cur_registros loop
    
      lc_found_cur := true;
    
      if lc_indice = lc_limite then
        lc_corr   := lc_corr + 1;
        lc_indice := 1;
      else
        lc_indice := lc_indice + 1;
      end if;
    
      lc_total := registro.aqpb052incuo + registro.aqpb052inmor +
                  registro.aqpb052segfac + registro.aqpb052otrcon;
      begin
        insert into aqpb052
        values
          (registro.aqpb052tcomf, -- aqpb052tcomf              C1: Tipo de documento
           registro.aqpb052seri, -- aqpb052seri      C2: Número de serie del documento
           registro.aqpb052num, -- aqpb052num       C3: Número correlativo del documento
           registro.aqpb052mone, -- aqpb052mone      C4: Tipo de moneda del comprobante
           registro.aqpb052tipope, -- aqpb052tipope    C5: Tipo de operación no gravada
           registro.aqpb052tdoc, -- aqpb052tdoc      C6: Tipo de documento de identidad del cliente
           registro.aqpb052nruc, -- aqpb052nruc      C7: Número de documento de Identidad del cliente
           registro.aqpb052rasoc, -- aqpb052rasoc     C8: Apellidos y nombres,  denominación o razón social del cliente
           registro.aqpb052incuo, -- aqpb052incuo     C9: Monto del interés de la cuota
           registro.aqpb052inmor, -- aqpb052inmor     C10: Monto del interés moratorio de corresponder
           registro.aqpb052segfac, -- aqpb052segfac    C11: Monto total de seguros facturados 
           registro.aqpb052otrcon, -- aqpb052otrcon    C12: Monto total de otros conceptos facturados
           lc_total, -- aqpb052opina     C13: Total valor de venta - operaciones inafectas
           registro.aqpb052opexa, -- aqpb052opexa     C14: Total valor de venta - operaciones exoneradas  
           lc_total, -- aqpb052impt      C15: Importe total a pagar 
           registro.aqpb052tdref, -- aqpb052tdref     C16: Tipo de documento que se modifica
           registro.aqpb052nsref, -- aqpb052nsref     C17: Número de serie del documento que se modifica
           registro.aqpb052ndref, -- aqpb052ndref     C18: Número correlativo del documento que se modifica
           registro.aqpb052fotrc, -- aqpb052fotrc     C19: Fecha de otorgamiento del crédito/Linea de crédito
           registro.aqpb052mcred, -- aqpb052mcred     C20: Monto del crédito otorgado (capital)
           --2011.11,
           registro.aqpb052ncon, -- aqpb052ncon      C21: Número de contrato
           registro.aqpb052npol, -- aqpb052npol      C22: Número de póliza
           registro.aqpb052ficob, -- aqpb052ficob     C23: Fecha de inicio de vigencia de cobertura
           registro.aqpb052ffcob, -- aqpb052ffcob     C24: Fecha de término de vigencia de cobertura
           registro.aqpb052tseg, -- aqpb052tseg      C25: Tipo de seguro
           registro.aqpb052scob, -- aqpb052scob      C26: Suma asegurada / alcance de cobertura o monto                                     
           
           registro.aqpb052pgc, -- aqpb052pgc
           registro.aqpb052mod, -- aqpb052mod
           registro.aqpb052suc, -- aqpb052suc
           registro.aqpb052trx, -- aqpb052trx
           registro.aqpb052rel, -- aqpb052rel
           registro.aqpb052femi, -- aqpb052femi
           lc_corr, -- aqpb052cod
           
           registro.aqpb052pgce, -- aqpb052pgce
           registro.aqpb052mode, -- aqpb052mode
           registro.aqpb052suce, -- aqpb052suce
           registro.aqpb052trxe, -- aqpb052trxe
           registro.aqpb052rele, -- aqpb052rele
           registro.aqpb052fcone); -- aqpb052fcone
      exception
        when others then
          null;
      end;
    
      /*-------------*/
      begin
        insert into aqpb053
        values
          (pd_fecpro,
           lc_corr,
           registro.aqpb052tcomf,
           registro.aqpb052seri,
           registro.aqpb052num,
           'E',
           0,
           '',
           lc_pgcod);
      exception
        when others then
          null;
      end;
    
    end loop;
    commit;
  
    if lc_found_cur then
      pd_resultado := 1;
    else
      pd_resultado := 0;
    end if;
  
    /*exception
    when others then
         pd_resultado := 0;*/
  end sp_cr_insertar_datos1;
  
  
end pq_cr_facturacion_generacion;
/
