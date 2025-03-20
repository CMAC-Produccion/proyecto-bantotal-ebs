create or replace package pq_cr_rep_fondos_updates is
-- *****************************************************************
    -- Nombre                     : PAQUETES PARA actualizacion de informacion de plantillas reporte fondos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.12
    -- Autor de Creación          : Ray Montes
    -- Uso                        : Actualizacion de tablas plantillas fondos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    --
    --
    --
    -- *****************************************************************

  -------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb065b(pn_cta       in number,
                                      pn_ope       in number,
                                      pd_fsub      in date,
                                      pv_nsub      in varchar2,
                                      pv_ncer      in varchar2,
                                      pv_ccob      in varchar2,
                                      pv_nact      in varchar2,
                                      pv_tdoc      in varchar2,
                                      pv_ndoc      in varchar2,
                                      pn_pcob      in number,
                                      pn_vpro      in number,
                                      pv_code      in varchar2,
                                      pv_nop       in varchar2,
                                      pn_tneg      in number,
                                      pv_ntra      in varchar2,
                                      pv_nsec      in varchar2,
                                      pv_ttit      in varchar2,
                                      pn_temp      in number,
                                      pn_gesp      in number,
                                      pn_ggen      in number,
                                      pv_ldoc      in varchar2,
                                      pn_sapr      in number,
                                      pd_fbcr      in date,
                                      pn_ppzo      in number,
                                      pd_fdes      in date,
                                      pn_mon       in number,
                                      pn_pgra      in number,
                                      pv_ciiuori   in varchar2,
                                      pv_actnomori in varchar2,
                                      pv_cren      in varchar2,
                                      pv_cobr      in varchar2,
                                      pv_chon      in varchar2,
                                      pv_user      in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb065b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_updte_aqpb067b(pn_cta       in number,
                                 pn_ope       in number,
                                 pv_esf       in varchar2,
                                 pv_csap      in varchar2,
                                 pd_fdes      in date,
                                 pn_mon       in number,
                                 pn_ncuo      in number,
                                 pn_peri      in number,
                                 pn_pcob      in number,
                                 pd_fini      in date,
                                 pd_ffin      in date,
                                 pv_ciiuori   in varchar2,
                                 pv_actnomori in varchar2,
                                 pv_ncer      in varchar2,
                                 pv_ccob      in varchar2,
                                 pv_cren      in varchar2,
                                 pv_cobr      in varchar2,
                                 pv_chon      in varchar2,
                                 pv_codi      in varchar2,
                                 pv_crec      in varchar2,
                                 pv_user      in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb067b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb073b(pn_cta       in number,
                                      pn_ope       in number,
                                      pv_tdoc      in varchar2,
                                      pv_ndoc      in varchar2,
                                      pv_esf       in varchar2,
                                      pv_ccob      in varchar2,
                                      pn_tnro      in number,
                                      pn_mtoe      in number,
                                      pn_pcob      in number,
                                      pd_fdes      in date,
                                      pn_mon       in number,
                                      pv_ciiuori   in varchar2,
                                      pv_actnomori in varchar2,
                                      pn_nven      in number,
                                      
                                      pv_ncer in varchar2,
                                      pv_chon in varchar2,
                                      
                                      pv_ccob2  in varchar2,
                                      pv_conhon in varchar2,
                                      pv_user   in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb073b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb095b(pn_cta  in number,
                                      pn_ope  in number,
                                      pv_ncer in varchar2,
                                      pd_fdes in date,
                                      pn_mon  in number,
                                      
                                      pn_tea   in number,
                                      pn_pgra  in number,
                                      pd_fini  in date,
                                      pd_ffin  in date,
                                      pn_prcof in number,
                                      
                                      pv_ccob in varchar2,
                                      pv_cren in varchar2,
                                      pv_cobr in varchar2,
                                      pv_chon in varchar2,
                                      pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb095b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb379b(pn_cta    in number,
                                      pv_CSOL   in varchar2,
                                      pn_OFON   in number,
                                      pv_NCER   in varchar2,
                                      pn_IDLIN  in number,
                                      pd_FECOF  in date,
                                      pn_MONCOF in number,
                                      pv_CIIU   in varchar2,
                                      pv_AECO   in varchar2,
                                      pd_FINC   in date,
                                      pd_FFIC   in date,
                                      pn_pcob   in number,
                                      
                                      pv_ccob in varchar2,
                                      pv_cren in varchar2,
                                      pv_chon in varchar2,
                                      pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb379b(pn_cta in number, pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb394b(pn_cta    in number,
                                      pn_ope    in number,
                                      pv_tdco   in varchar2,
                                      pv_NDCO   in varchar2,
                                      pv_COCER  in varchar2,
                                      pv_COCOB  in varchar2,
                                      pn_MONCOF in number,
                                      pn_PRCCOF in number,
                                      pn_MONCOB in number,
                                      pv_CIIU   in varchar2,
                                      pv_COSUB  in varchar2,
                                      pn_NIVEC  in number,
                                      pv_NOM    in varchar2,
                                      pv_CREN   in varchar2,
                                      pv_COBR   in varchar2,
                                      pv_CHON   in varchar2,
                                      pv_CODI   in varchar2,
                                      pv_CONSAP in varchar2,
                                      pv_user   in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb394b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb762b(pn_cta    in number,
                                      pn_ope    in number,
                                      pd_frep   in date,
                                      pv_tdoc   in varchar2,
                                      pv_ndoc   in varchar2,
                                      pv_csol   in varchar2,
                                      pv_copa   in varchar2,
                                      pd_fdes   in date,
                                      pd_ffin   in date,
                                      pn_cdes   in number,
                                      pn_plzo   in number,
                                      pn_grci   in number,
                                      pn_sins   in number,
                                      pn_scap   in number,
                                      pn_pcob   in number,
                                      pn_scob   in number,
                                      pd_feco   in date,
                                      pn_mnco   in number,
                                      pv_ciuo   in varchar2,
                                      pv_aeco   in varchar2,
                                      pd_fico   in date,
                                      pd_ffco   in date,
                                      pv_ncer   in varchar2,
                                      pv_ccob   in varchar2,
                                      pv_cren   in varchar2,
                                      pv_cobr   in varchar2,
                                      pv_chon   in varchar2,
                                      pv_codi   in varchar2,
                                      pv_consap in varchar2,
                                      pv_user   in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb762b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpc360b(pn_cta    in number,
                                      pn_ope    in number,
                                      pv_TDOCC  in varchar2,
                                      pv_NDOCC  in varchar2,
                                      pn_MONCOF in number,
                                      pn_PRCCOF in number,
                                      pn_MONCOB in number,
                                      pv_NCER   in varchar2,
                                      pv_NSOL   in varchar2,
                                      pv_CODGAR in varchar2,
                                      pv_CODCOB in varchar2,
                                      pv_NCERCH in varchar2,
                                      pd_FINC   in date,
                                      pd_FFNC   in date,
                                      pv_CERTRN in varchar2,
                                      pv_COBREN in varchar2,
                                      pv_CIUUO  in varchar2,
                                      pv_ACTECO in varchar2,
                                      pv_user   in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpc360b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
  -----------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpc366b(pn_cta    in number,
                                      pn_ope    in number,
                                      pn_moncof in number,
                                      pd_fdes   in date,
                                      pn_prccof in number,
                                      pv_ncer   in varchar2,
                                      pv_nsol   in varchar2,
                                      pv_codgar in varchar2,
                                      pv_codcob in varchar2,
                                      pv_codsub in varchar2,
                                      pv_idcof  in varchar2,
                                      pd_finc   in date,
                                      pd_ffnc   in date,
                                      pv_tdest  in varchar2,
                                      pv_orifon in varchar2,
                                      pv_ncerch in varchar2,
                                      pv_certrn in varchar2,
                                      pv_cobren in varchar2,
                                      pn_perio  in number,
                                      pn_pgra   in number,
                                      pn_ncuo   in number,
                                      pn_tea    in number,
                                      pv_tamemp in varchar2,
                                      pv_user   in varchar2);
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpc366b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2);
end pq_cr_rep_fondos_updates;
/

create or replace package body pq_cr_rep_fondos_updates is
  -------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb065b(pn_cta       in number,
                                      pn_ope       in number,
                                      pd_fsub      in date,
                                      pv_nsub      in varchar2,
                                      pv_ncer      in varchar2,
                                      pv_ccob      in varchar2,
                                      pv_nact      in varchar2,
                                      pv_tdoc      in varchar2,
                                      pv_ndoc      in varchar2,
                                      pn_pcob      in number,
                                      pn_vpro      in number,
                                      pv_code      in varchar2,
                                      pv_nop       in varchar2,
                                      pn_tneg      in number,
                                      pv_ntra      in varchar2,
                                      pv_nsec      in varchar2,
                                      pv_ttit      in varchar2,
                                      pn_temp      in number,
                                      pn_gesp      in number,
                                      pn_ggen      in number,
                                      pv_ldoc      in varchar2,
                                      pn_sapr      in number,
                                      pd_fbcr      in date,
                                      pn_ppzo      in number,
                                      pd_fdes      in date,
                                      pn_mon       in number,
                                      pn_pgra      in number,
                                      pv_ciiuori   in varchar2,
                                      pv_actnomori in varchar2,
                                      pv_cren      in varchar2,
                                      pv_cobr      in varchar2,
                                      pv_chon      in varchar2,
                                      pv_user      in varchar2) is
  begin
    begin
      update aqpb065b
         set AQPB065Bfsub      = pd_fsub,
             AQPB065Bnsub      = pv_nsub,
             AQPB065Bncer      = pv_ncer,
             AQPB065Bccob      = pv_ccob,
             AQPB065Bnact      = pv_nact,
             AQPB065Btdoc      = pv_tdoc,
             AQPB065Bndoc      = pv_ndoc,
             AQPB065Bpcob      = pn_pcob,
             AQPB065Bvpro      = pn_vpro,
             AQPB065Bcode      = pv_code,
             AQPB065Bnop       = pv_nop,
             AQPB065Btneg      = pn_tneg,
             AQPB065Bntra      = pv_ntra,
             AQPB065Bnsec      = pv_nsec,
             AQPB065Bttit      = pv_ttit,
             AQPB065Btemp      = pn_temp,
             AQPB065Bgesp      = pn_gesp,
             AQPB065Bggen      = pn_ggen,
             AQPB065Bldoc      = pv_ldoc,
             AQPB065Bsapr      = pn_sapr,
             AQPB065Bfbcr      = pd_fbcr,
             aqpb065bppzo      = pn_ppzo,
             aqpb065bfdes      = pd_fdes,
             aqpb065bmon       = pn_mon,
             aqpb065bpgra      = pn_pgra,
             aqpb065Bciiuori   = pv_ciiuori,
             aqpb065Bactnomori = pv_actnomori,
             Aqpb065bcren      = pv_cren,
             Aqpb065bcobr      = pv_cobr,
             Aqpb065bchon      = pv_chon,
             
             AQPB065Best = 'U',
             AQPB065Busd = pv_user,
             AQPB065Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB065Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb065bcod = 1
         and aqpb065bcta = pn_cta
         and aqpb065bope = pn_ope
         and aqpb065best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb065b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb065b
         set AQPB065Best = 'D',
             AQPB065Busd = pv_user,
             AQPB065Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB065Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb065bcod = 1
         and aqpb065bcta = pn_cta
         and aqpb065bope = pn_ope
         and aqpb065best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_updte_aqpb067b(pn_cta       in number,
                                 pn_ope       in number,
                                 pv_esf       in varchar2,
                                 pv_csap      in varchar2,
                                 pd_fdes      in date,
                                 pn_mon       in number,
                                 pn_ncuo      in number,
                                 pn_peri      in number,
                                 pn_pcob      in number,
                                 pd_fini      in date,
                                 pd_ffin      in date,
                                 pv_ciiuori   in varchar2,
                                 pv_actnomori in varchar2,
                                 pv_ncer      in varchar2,
                                 pv_ccob      in varchar2,
                                 pv_cren      in varchar2,
                                 pv_cobr      in varchar2,
                                 pv_chon      in varchar2,
                                 pv_codi      in varchar2,
                                 pv_crec      in varchar2,
                                 pv_user      in varchar2) is
  begin
    begin
      update aqpb067b
         set AQPB067Besf  = pv_esf,
             AQPB067Bcsap = pv_csap,
             AQPB067Bfdes = pd_fdes,
             AQPB067Bmon  = pn_mon,
             AQPB067Bncuo = pn_ncuo,
             AQPB067Bperi = pn_peri,
             AQPB067Bpcob = pn_pcob,
             
             aqpb067bfini      = pd_fini,
             aqpb067bffin      = pd_ffin,
             aqpb067Bciiuori   = pv_ciiuori,
             aqpb067Bactnomori = pv_actnomori,
             
             aqpb067bncer = pv_ncer,
             aqpb067bccob = pv_ccob,
             aqpb067bcren = pv_cren,
             aqpb067bcobr = pv_cobr,
             aqpb067bchon = pv_chon,
             aqpb067bcodi = pv_codi,
             aqpb067bcrec = pv_crec,
             
             AQPB067Best = 'U',
             AQPB067Busd = pv_user,
             AQPB067Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB067Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb067bcod = 1
         and aqpb067bcta = pn_cta
         and aqpb067bope = pn_ope
         and aqpb067best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb067b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb067b
         set AQPB067Best = 'D',
             AQPB067Busd = pv_user,
             AQPB067Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB067Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb067bcod = 1
         and aqpb067bcta = pn_cta
         and aqpb067bope = pn_ope
         and aqpb067best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb073b(pn_cta       in number,
                                      pn_ope       in number,
                                      pv_tdoc      in varchar2,
                                      pv_ndoc      in varchar2,
                                      pv_esf       in varchar2,
                                      pv_ccob      in varchar2,
                                      pn_tnro      in number,
                                      pn_mtoe      in number,
                                      pn_pcob      in number,
                                      pd_fdes      in date,
                                      pn_mon       in number,
                                      pv_ciiuori   in varchar2,
                                      pv_actnomori in varchar2,
                                      pn_nven      in number,
                                      pv_ncer      in varchar2,
                                      pv_chon      in varchar2,
                                      pv_ccob2     in varchar2,
                                      pv_conhon    in varchar2,
                                      pv_user      in varchar2) is
  begin
    begin
      update aqpb073b
         set AQPB073Btdoc      = pv_tdoc,
             AQPB073Bndoc      = pv_ndoc,
             AQPB073Besf       = pv_esf,
             AQPB073Bccob      = pv_ccob,
             AQPB073Btnro      = pn_tnro,
             AQPB073Bmtoe      = pn_mtoe,
             AQPB073Bpcob      = pn_pcob,
             aqpb073bfdes      = pd_fdes,
             aqpb073bmon       = pn_mon,
             aqpb073Bciiuori   = pv_ciiuori,
             aqpb073Bactnomori = pv_actnomori,
             aqpb073bnven      = pn_nven,
             
             Aqpb073bncer = pv_ncer,
             Aqpb073bchon = pv_chon,
             
             Aqpb073bccob2  = pv_ccob2,
             aqpb073bconhon = pv_conhon,
             
             AQPB073Best = 'U',
             AQPB073Busd = pv_user,
             AQPB073Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB073Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb073bcod = 1
         and aqpb073bcta = pn_cta
         and aqpb073bope = pn_ope
         and aqpb073best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb073b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb073b
         set AQPB073Best = 'D',
             AQPB073Busd = pv_user,
             AQPB073Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB073Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb073bcod = 1
         and aqpb073bcta = pn_cta
         and aqpb073bope = pn_ope
         and aqpb073best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb095b(pn_cta  in number,
                                      pn_ope  in number,
                                      pv_ncer in varchar2,
                                      pd_fdes in date,
                                      pn_mon  in number,
                                      
                                      pn_tea   in number,
                                      pn_pgra  in number,
                                      pd_fini  in date,
                                      pd_ffin  in date,
                                      pn_prcof in number,
                                      
                                      pv_ccob in varchar2,
                                      pv_cren in varchar2,
                                      pv_cobr in varchar2,
                                      pv_chon in varchar2,
                                      pv_user in varchar2) is
  begin
    begin
      update aqpb095b
         set aqpb095bncer  = pv_ncer,
             AQPB095Bfdes  = pd_fdes,
             aqpb095bmon   = pn_mon,
             aqpb095btea   = pn_tea,
             aqpb095bpgra  = pn_pgra,
             aqpb095bfini  = pd_fini,
             aqpb095bffin  = pd_ffin,
             aqpb095bprcof = pn_prcof,
             Aqpb095bccob  = pv_ccob,
             Aqpb095bcren  = pv_cren,
             Aqpb095bcobr  = pv_cobr,
             Aqpb095bchon  = pv_chon,
             
             AQPB095Best = 'U',
             AQPB095Busd = pv_user,
             AQPB095Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB095Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb095bcod = 1
         and aqpb095bcta = pn_cta
         and aqpb095bope = pn_ope
         and aqpb095best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb095b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb095b
         set aqpb095Best = 'D',
             aqpb095Busd = pv_user,
             aqpb095Bfed = to_char(sysdate, 'DD/MM/YYYY'),
             aqpb095Bhed = to_char(sysdate, 'HH24:MI:SS')
       where aqpb095bcod = 1
         and aqpb095bcta = pn_cta
         and aqpb095bope = pn_ope
         and aqpb095best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb379b(pn_cta    in number,
                                      pv_CSOL   in varchar2,
                                      pn_OFON   in number,
                                      pv_NCER   in varchar2,
                                      pn_IDLIN  in number,
                                      pd_FECOF  in date,
                                      pn_MONCOF in number,
                                      pv_CIIU   in varchar2,
                                      pv_AECO   in varchar2,
                                      pd_FINC   in date,
                                      pd_FFIC   in date,
                                      pn_pcob   in number,
                                      
                                      pv_ccob in varchar2,
                                      pv_cren in varchar2,
                                      pv_chon in varchar2,
                                      pv_user in varchar2) is
  begin
    begin
      update aqpb379b
         set AQPB379BCSOL   = pv_CSOL,
             AQPB379BOFON   = pn_OFON,
             AQPB379BNCER   = pv_NCER,
             AQPB379BIDLIN  = pn_IDLIN,
             AQPB379BFECOF  = pd_FECOF,
             AQPB379BMONCOF = pn_MONCOF,
             AQPB379BCIIU   = pv_CIIU,
             AQPB379BAECO   = pv_AECO,
             AQPB379BFINC   = pd_FINC,
             AQPB379BFFIC   = pd_FFIC,
             aqpb379bpcob   = pn_pcob,
             Aqpb379bccob   = pv_ccob,
             Aqpb379bcren   = pv_cren,
             Aqpb379bchon   = pv_chon,
             
             AQPB379Best  = 'U',
             AQPB379Busu  = pv_user,
             AQPB379Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB379Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb379bcod = 1
         and aqpb379bcta = pn_cta
         and aqpb379best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb379b(pn_cta in number, pv_user in varchar2) is
  begin
    begin
      update aqpb379b
         set aqpb379Best  = 'D',
             aqpb379Busu  = pv_user,
             aqpb379Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             aqpb379Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb379bcod = 1
         and aqpb379bcta = pn_cta
         and aqpb379best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb394b(pn_cta    in number,
                                      pn_ope    in number,
                                      pv_tdco   in varchar2,
                                      pv_NDCO   in varchar2,
                                      pv_COCER  in varchar2,
                                      pv_COCOB  in varchar2,
                                      pn_MONCOF in number,
                                      pn_PRCCOF in number,
                                      pn_MONCOB in number,
                                      pv_CIIU   in varchar2,
                                      pv_COSUB  in varchar2,
                                      pn_NIVEC  in number,
                                      pv_NOM    in varchar2,
                                      pv_CREN   in varchar2,
                                      pv_COBR   in varchar2,
                                      pv_CHON   in varchar2,
                                      pv_CODI   in varchar2,
                                      pv_CONSAP in varchar2,
                                      pv_user   in varchar2) is
  begin
    begin
      update aqpb394b
         set AQPB394BTDCO   = pv_tdco,
             AQPB394BNDCO   = pv_ndco,
             AQPB394BCOCER  = pv_cocer,
             AQPB394BCOCOB  = pv_cocob,
             AQPB394BMONCOF = pn_moncof,
             AQPB394BPRCCOF = pn_PRCCOF,
             AQPB394BMONCOB = pn_MONCOB,
             AQPB394BCIIU   = pv_CIIU,
             AQPB394BCOSUB  = pv_cosub,
             AQPB394BNIVEC  = pn_nivec,
             AQPB394BNOM    = pv_nom,
             AQPB394BCREN   = pv_cren,
             AQPB394BCOBR   = pv_cobr,
             AQPB394BCHON   = pv_chon,
             AQPB394BCODI   = pv_codi,
             AQPB394BCONSAP = pv_consap,
             
             AQPB394Best  = 'U',
             AQPB394Busu  = pv_user,
             AQPB394Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB394Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb394bcod = 1
         and aqpb394bcta = pn_cta
         and aqpb394bope = pn_ope
         and aqpb394best <> 'D';
      commit;
    
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb394b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb394b
         set aqpb394best  = 'D',
             aqpb394busu  = pv_user,
             aqpb394bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             aqpb394bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb394bcod = 1
         and aqpb394bcta = pn_cta
         and aqpb394bope = pn_ope
         and aqpb394best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;

  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpb762b(pn_cta    in number,
                                      pn_ope    in number,
                                      pd_frep   in date,
                                      pv_tdoc   in varchar2,
                                      pv_ndoc   in varchar2,
                                      pv_csol   in varchar2,
                                      pv_copa   in varchar2,
                                      pd_fdes   in date,
                                      pd_ffin   in date,
                                      pn_cdes   in number,
                                      pn_plzo   in number,
                                      pn_grci   in number,
                                      pn_sins   in number,
                                      pn_scap   in number,
                                      pn_pcob   in number,
                                      pn_scob   in number,
                                      pd_feco   in date,
                                      pn_mnco   in number,
                                      pv_ciuo   in varchar2,
                                      pv_aeco   in varchar2,
                                      pd_fico   in date,
                                      pd_ffco   in date,
                                      pv_ncer   in varchar2,
                                      pv_ccob   in varchar2,
                                      pv_cren   in varchar2,
                                      pv_cobr   in varchar2,
                                      pv_chon   in varchar2,
                                      pv_codi   in varchar2,
                                      pv_consap in varchar2,
                                      pv_user   in varchar2) is
  begin
    begin
      update aqpb762b
         set AQPB762BFREP = pd_frep,
             AQPB762BTDOC = pv_tdoc,
             AQPB762BNDOC = pv_ndoc,
             AQPB762BCSOL = pv_csol,
             AQPB762BCOPA = pv_copa,
             AQPB762BFDES = pd_fdes,
             AQPB762BFFIN = pd_ffin,
             AQPB762BCDES = pn_cdes,
             AQPB762BPLZO = pn_plzo,
             AQPB762BGRCI = pn_grci,
             AQPB762BSINS = pn_sins,
             AQPB762BSCAP = pn_scap,
             AQPB762BPCOB = pn_pcob,
             AQPB762BSCOB = pn_scob,
             AQPB762BFECO = pd_feco,
             AQPB762BMNCO = pn_mnco,
             AQPB762BCIUO = pv_ciuo,
             AQPB762BAECO = pv_aeco,
             AQPB762BFICO = pd_fico,
             AQPB762BFFCO = pd_ffco,
             
             AQPB762BNCER   = pv_ncer,
             AQPB762BCCOB   = pv_ccob,
             AQPB762BCREN   = pv_cren,
             AQPB762BCOBR   = pv_cobr,
             AQPB762BCHON   = pv_chon,
             AQPB762BCODI   = pv_codi,
             AQPB762BCONSAP = pv_consap,
             
             AQPB762Best  = 'U',
             AQPB762Busu  = pv_user,
             AQPB762Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB762Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb762bcod = 1
         and aqpb762bccta = pn_cta
         and aqpb762boper = pn_ope
         and aqpb762best <> 'D';
      commit;
    
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpb762b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpb762b
         set AQPB762Best  = 'D',
             AQPB762Busu  = pv_user,
             AQPB762Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPB762Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpb762bcod = 1
         and aqpb762bccta = pn_cta
         and aqpb762boper = pn_ope
         and aqpb762best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpc360b(pn_cta    in number,
                                      pn_ope    in number,
                                      pv_TDOCC  in varchar2,
                                      pv_NDOCC  in varchar2,
                                      pn_MONCOF in number,
                                      pn_PRCCOF in number,
                                      pn_MONCOB in number,
                                      pv_NCER   in varchar2,
                                      pv_NSOL   in varchar2,
                                      pv_CODGAR in varchar2,
                                      pv_CODCOB in varchar2,
                                      pv_NCERCH in varchar2,
                                      pd_FINC   in date,
                                      pd_FFNC   in date,
                                      pv_CERTRN in varchar2,
                                      pv_COBREN in varchar2,
                                      pv_CIUUO  in varchar2,
                                      pv_ACTECO in varchar2,
                                      pv_user   in varchar2) is
  begin
    begin
      update aqpc360b
         set AQPC360BTDOCC  = pv_TDOCC,
             AQPC360BNDOCC  = pv_NDOCC,
             AQPC360BMONCOF = pn_MONCOF,
             AQPC360BPRCCOF = pn_PRCCOF,
             AQPC360BMONCOB = pn_MONCOB,
             AQPC360BNCER   = pv_NCER,
             AQPC360BNSOL   = pv_NSOL,
             AQPC360BCODGAR = pv_CODGAR,
             AQPC360BCODCOB = pv_CODCOB,
             AQPC360BNCERCH = pv_NCERCH,
             AQPC360BFINC   = pd_FINC,
             AQPC360BFFNC   = pd_FFNC,
             AQPC360BCERTRN = pv_CERTRN,
             AQPC360BCOBREN = pv_COBREN,
             AQPC360BCIUUO  = pv_CIUUO,
             AQPC360BACTECO = pv_ACTECO,
             
             AQPc360Best  = 'U',
             AQPc360Busu  = pv_user,
             AQPc360Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPc360Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpc360bcod = 1
         and aqpc360bcta = pn_cta
         and aqpc360bope = pn_ope
         and aqpc360best <> 'D';
      commit;
    
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpc360b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpc360b
         set aqpc360best  = 'D',
             aqpc360busu  = pv_user,
             aqpc360bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             aqpc360bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpc360bcod = 1
         and aqpc360bcta = pn_cta
         and aqpc360bope = pn_ope
         and aqpc360best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
  ------------------------------------------------------------------
  procedure sp_cr_actualizar_aqpc366b(pn_cta    in number,
                                      pn_ope    in number,
                                      pn_moncof in number,
                                      pd_fdes   in date,
                                      pn_prccof in number,
                                      pv_ncer   in varchar2,
                                      pv_nsol   in varchar2,
                                      pv_codgar in varchar2,
                                      pv_codcob in varchar2,
                                      pv_codsub in varchar2,
                                      pv_idcof  in varchar2,
                                      pd_finc   in date,
                                      pd_ffnc   in date,
                                      pv_tdest  in varchar2,
                                      pv_orifon in varchar2,
                                      pv_ncerch in varchar2,
                                      pv_certrn in varchar2,
                                      pv_cobren in varchar2,
                                      pn_perio  in number,
                                      pn_pgra   in number,
                                      pn_ncuo   in number,
                                      pn_tea    in number,
                                      pv_tamemp in varchar2,
                                      pv_user   in varchar2) is
  begin
    begin
      update aqpc366b
         set AQPC366BMONCOF = pn_moncof,
             AQPC366BFDES   = pd_fdes,
             AQPC366BPRCCOF = pn_prccof,
             AQPC366BNCER   = pv_ncer,
             AQPC366BNSOL   = pv_nsol,
             AQPC366BCODGAR = pv_codgar,
             AQPC366BCODCOB = pv_codcob,
             AQPC366BCODSUB = pv_codsub,
             AQPC366BIDCOF  = pv_idcof,
             AQPC366BFINC   = pd_finc,
             AQPC366BFFNC   = pd_ffnc,
             AQPC366BTDEST  = pv_tdest,
             AQPC366BORIFON = pv_orifon,
             AQPC366BNCERCH = pv_ncerch,
             AQPC366BCERTRN = pv_certrn,
             AQPC366BCOBREN = pv_cobren,
             AQPC366BPERIO  = pn_perio,
             AQPC366BPGRA   = pn_pgra,
             AQPC366BNCUO   = pn_ncuo,
             AQPC366BTEA    = pn_tea,
             AQPC366BTAMEMP = pv_tamemp,
             
             AQPc366Best  = 'U',
             AQPc366Busu  = pv_user,
             AQPc366Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPc366Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpc366bcod = 1
         and aqpc366bcta = pn_cta
         and aqpc366bope = pn_ope
         and aqpc366best <> 'D';
      commit;
    
    exception
      when others then
        null;
    end;
  end;
  --------------------------------------------------------------------
  procedure sp_cr_anular_aqpc366b(pn_cta  in number,
                                  pn_ope  in number,
                                  pv_user in varchar2) is
  begin
    begin
      update aqpc366b
         set AQPc366Best  = 'D',
             AQPc366Busu  = pv_user,
             AQPc366Bfedi = to_char(sysdate, 'DD/MM/YYYY'),
             AQPc366Bhedi = to_char(sysdate, 'HH24:MI:SS')
       where aqpc366bcod = 1
         and aqpc366bcta = pn_cta
         and aqpc366bope = pn_ope
         and aqpc366best <> 'D';
      commit;
    exception
      when others then
        null;
    end;
  end;
end pq_cr_rep_fondos_updates;
/

