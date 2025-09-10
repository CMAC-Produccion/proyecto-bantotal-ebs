CREATE OR REPLACE PACKAGE PQ_CR_DESEM_MOVIL is
  -- *****************************************************************
  -- Nombre                     : Pq PARA DESEMBOLSO MOVIL - CANALES - CALLCENTER
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.04.24
  -- Autor de Creación          : CMAC-GCARRANZAS
  -- Uso                        :
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
  -- Descripción de Modificación:
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --  AQPA963PGCOD NUMBER(3), AQPA963ITSUC NUMBER(3), AQPA963ITMOD NUMBER(3), AQPA963ITTRAN NUMBER(3), AQPA963ITNREL NUMBER(4), AQPA963ITFCON DATE,

  Procedure sp_cr_registra(pn_pgcod   in number,
                           pn_itsuc   in number,
                           pn_itmod   in number,
                           pn_ittran  in number,
                           pn_itnrel  in number,
                           pd_itfcon  in date,
                           pn_idarc   in number,
                           pv_ituing  in varchar2,
                           pv_ithora  in varchar2,
                           pd_fproc   in date,
                           pn_emp     in number,
                           pn_suc     in number,
                           pn_mod     in number,
                           pn_mda     in number,
                           pn_pap     in number,
                           pn_cta     in number,
                           pn_ope     in number,
                           pn_sbo     in number,
                           pn_top     in number,
                           pn_inst    in number,
                           pn_pais    in number,
                           pn_tdoc    in number,
                           pv_ndoc    in varchar2,
                           pn_esfc    in number,
                           pv_nomarc  in varchar2,
                           pv_ruta    in varchar2,
                           PV_TIPO    IN VARCHAR2,
                           p_c_coderr out varchar2,
                           p_c_deserr out varchar2);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_DESEM_MOVIL;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_DESEM_MOVIL is

  Procedure sp_cr_registra(pn_pgcod   in number,
                           pn_itsuc   in number,
                           pn_itmod   in number,
                           pn_ittran  in number,
                           pn_itnrel  in number,
                           pd_itfcon  in date,
                           pn_idarc   in number,
                           pv_ituing  in varchar2,
                           pv_ithora  in varchar2,
                           pd_fproc   in date,
                           pn_emp     in number,
                           pn_suc     in number,
                           pn_mod     in number,
                           pn_mda     in number,
                           pn_pap     in number,
                           pn_cta     in number,
                           pn_ope     in number,
                           pn_sbo     in number,
                           pn_top     in number,
                           pn_inst    in number,
                           pn_pais    in number,
                           pn_tdoc    in number,
                           pv_ndoc    in varchar2,
                           pn_esfc    in number,
                           pv_nomarc  in varchar2,
                           pv_ruta    in varchar2,
                           PV_TIPO    IN VARCHAR2,
                           p_c_coderr out varchar2,
                           p_c_deserr out varchar2) is
  
    -- ******************************************************************************************************
    -- Nombre                     :
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     :
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2020.04.24
    -- Autor de Creaci¿n          : GCARRANZAS
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : PÚBLICO
    -- Par¿metros de Entrada      :
    -- Par¿metros de Salida       :
    -- Fecha de Modificaci¿n      :
    -- Autor de la Modificaci¿n   :
    -- Descripci¿n de Modificaci¿n:
    --
    -- ********************************************************************************************************
  
    l_bfile   BFILE;
    l_blob    BLOB;
    lv_nomrep varchar2(30);
  begin
  
    lv_nomrep := pv_ruta;
    --lv_nomrep := 'DTPUMP_PR_EMAIL_DIG';
  
    begin
      insert into AQPA963
        (aqpa963pgcod,
         aqpa963itsuc,
         aqpa963itmod,
         aqpa963ittran,
         aqpa963itnrel,
         aqpa963itfcon,
         aqpa963idarc,
         aqpa963ituing,
         aqpa963ithora,
         aqpa963fproc,
         aqpa963emp,
         aqpa963suc,
         aqpa963mod,
         aqpa963mda,
         aqpa963pap,
         aqpa963cta,
         aqpa963ope,
         aqpa963sbo,
         aqpa963top,
         aqpa963inst,
         aqpa963pais,
         aqpa963tdoc,
         aqpa963ndoc,
         aqpa963esfc,
         aqpa963nomarc,
         aqpa963arc,
         AQPA963CA1)
      values
        (pn_pgcod,
         pn_itsuc,
         pn_itmod,
         pn_ittran,
         pn_itnrel,
         pd_itfcon,
         pn_idarc,
         pv_ituing,
         pv_ithora,
         pd_fproc,
         pn_emp,
         pn_suc,
         pn_mod,
         pn_mda,
         pn_pap,
         pn_cta,
         pn_ope,
         pn_sbo,
         pn_top,
         pn_inst,
         pn_pais,
         pn_tdoc,
         pv_ndoc,
         pn_esfc,
         pv_nomarc,
         EMPTY_BLOB(),
         PV_TIPO) RETURN aqpa963arc INTO l_blob;
    
      l_bfile := BFILENAME(lv_nomrep, pv_nomarc);
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
  
  end sp_cr_registra;

end PQ_CR_DESEM_MOVIL;
/

