create or replace package pq_ah_apert_cta is

    -- ******************************************************************************************************
    -- Nombre                     : sp_ap_registra
    -- Sistema                    : BANTOTAL
    -- Módulo                     :
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2025.08.28
    -- Autor de Creación          : SGAMERO
    -- Uso                        : Grabar contrato y cartilla de apertura de cuenta
    -- Estado                     : Activo
    -- Acceso                     : PÚBLICO
    -- ********************************************************************************************************
  
  procedure sp_ah_registra(pn_corr in number, pd_fec in date, pc_hor in character, pc_can in number,
    pn_pais in number, pn_tdoc in number, pv_ndoc in character, pv_tarc in varchar2, pv_ctal in varchar2,
    pn_pgcod in number, pn_suc in number, pn_mod in number,pn_mda in number, pn_pap in number, pn_cta in number,
    pn_ope in number, pn_sbo in number, pn_top in number, pv_narc in varchar2, pv_rbd in varchar2, pv_rfl in varchar2,
    p_c_coderr out varchar2, p_c_deserr out varchar2);

end pq_ah_apert_cta;
/
create or replace package body pq_ah_apert_cta is

  Procedure sp_ah_registra( pn_corr in number,
                           pd_fec in date,
                           pc_hor in character,
                           pc_can in number,
                           pn_pais in number,
                           pn_tdoc in number,
                           pv_ndoc in character,
                           pv_tarc in varchar2,
                           pv_ctal in varchar2,
                           pn_pgcod in number,
                           pn_suc in number,
                           pn_mod in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pv_narc in varchar2,
                           pv_rbd in varchar2,
                           pv_rfl in varchar2,
                           p_c_coderr  out varchar2,
                           p_c_deserr  out varchar2)
   is
  
    -- ******************************************************************************************************
    -- Nombre                     : sp_ap_registra
    -- Sistema                    : BANTOTAL
    -- Módulo                     :
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2025.08.28
    -- Autor de Creación          : SGAMERO
    -- Uso                        : Grabar contrato y cartilla de apertura de cuenta
    -- Estado                     : Activo
    -- Acceso                     : PÚBLICO
    -- ********************************************************************************************************
  
    l_bfile   BFILE;
    l_blob    BLOB;
    lv_nomrep varchar2(30);
  begin
  
    lv_nomrep := pv_rbd;
    --lv_nomrep := 'DTPUMP_PR_EMAIL_DIG';
  
    begin
      insert into AQPD570
        (aqpd570id,
         aqpd570idcorr,
         aqpd570fecreg,
         aqpd570horreg,
         aqpd570canal,
         aqpd570paidoc,
         aqpd570tipdoc,
         aqpd570numdoc,
         aqpd570tiparc,
         aqpd570ctalng,
         aqpd570ctaemp,
         aqpd570ctasuc,
         aqpd570ctamod,
         aqpd570ctamda,
         aqpd570ctapap,
         aqpd570ctanro,
         aqpd570ctaope,
         aqpd570ctasbo,
         aqpd570ctatop,
         aqpd570nomarc,
         aqpd570ruarbd,
         aqpd570ruarfl,
         aqpd570arc)
      values
        (SQ_CN_AQPD570.NEXTVAL,
         pn_corr,
         pd_fec,
         pc_hor,
         pc_can,
         pn_pais,
         pn_tdoc,
         pv_ndoc,
         pv_tarc,
         pv_ctal,
         pn_pgcod,
         pn_suc,
         pn_mod,
         pn_mda,
         pn_pap,
         pn_cta,
         pn_ope,
         pn_sbo,
         pn_top,
         pv_narc,
         pv_rbd,
         pv_rfl,
         EMPTY_BLOB()) 
         RETURN aqpd570arc INTO l_blob;
    
      l_bfile := BFILENAME(lv_nomrep, pv_narc);
      DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
      DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
      DBMS_LOB.fileclose(l_bfile);
      COMMIT;
    
      p_c_coderr := '000';
      p_c_deserr := '';
    exception
      when others then
        p_c_coderr := '001';
        p_c_deserr := sqlerrm;
    end;
  
  end sp_ah_registra; 
  
end pq_ah_apert_cta;
/
