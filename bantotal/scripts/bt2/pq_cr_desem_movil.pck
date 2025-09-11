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
  -- Fecha de Modificación      : 14/07/2025
  -- Autor de la Modificación   : eninah 
  -- Descripción de Modificación: Se agregaron más parametros para el llamado a un nuevo sp_cr_registrar_AQPD163
  -- Fecha de Modificación      : 05/08/2025
  -- Autor de la Modificación   : eninah 
  -- Descripción de Modificación: Se validó el funcionamiento del paquete
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --  AQPA963PGCOD NUMBER(3), AQPA963ITSUC NUMBER(3), AQPA963ITMOD NUMBER(3), AQPA963ITTRAN NUMBER(3), AQPA963ITNREL NUMBER(4), AQPA963ITFCON DATE,

  Procedure sp_cr_registra(pn_pgcod    in number, -- 1
                           pn_itsuc    in number, -- 2
                           pn_itmod    in number, -- 3
                           pn_ittran   in number, -- 4
                           pn_itnrel   in number, -- 5
                           pd_itfcon   in date, -- 6
                           pn_idarc    in number, -- 7
                           pv_ituing   in varchar2, -- 8
                           pv_ithora   in varchar2, -- 9
                           pd_fproc    in date, -- 10 
                           pn_emp      in number, -- 11
                           pn_suc      in number, -- 12
                           pn_mod      in number, -- 13
                           pn_mda      in number, -- 14
                           pn_pap      in number, -- 15
                           pn_cta      in number, -- 16
                           pn_ope      in number, -- 17
                           pn_sbo      in number, -- 18
                           pn_top      in number, -- 19
                           pn_inst     in number, -- 20 instancia
                           pn_pais     in number, -- 21
                           pn_tdoc     in number, -- 22
                           pv_ndoc     in varchar2, -- 23 número de documento
                           pn_esfc     in number, -- 24
                           pv_nomarc   in varchar2, -- 25
                           pv_ruta     in varchar2, -- 26
                           PV_TIPO     IN VARCHAR2, --27
                           pv_modo     in varchar2, -- 28 modo
                           pv_codora   in varchar2, -- 29 codigo oracle
                           pv_codban   in varchar2, -- 30 codigo bantotal
                           pv_codori   in varchar2, -- 31 codigo origen
                           pv_rutcompl in varchar2, -- 32 ruta completa
                           p_c_coderr  out varchar2, -- 33
                           p_c_deserr  out varchar2); --34

  procedure sp_cr_registrar_AQPD167(PGCOD   in number,
                                    ITSUC   in number,
                                    ITMOD   in number,
                                    ITTRAN  in number,
                                    ITNREL  in number,
                                    ITFCON  in date,
                                    IDARC   in number,
                                    INST    in number,
                                    NUMDOC  in varchar2,
                                    RTARCHV in varchar2,
                                    MODO    in varchar2,
                                    CODORA  in varchar2,
                                    CODBANT in varchar2,
                                    ORGN    IN VARCHAR2);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_CR_DESEM_MOVIL;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_DESEM_MOVIL is

  Procedure sp_cr_registra(pn_pgcod    in number, -- 1
                           pn_itsuc    in number, -- 2
                           pn_itmod    in number, -- 3
                           pn_ittran   in number, -- 4
                           pn_itnrel   in number, -- 5
                           pd_itfcon   in date, -- 6
                           pn_idarc    in number, -- 7
                           pv_ituing   in varchar2, -- 8
                           pv_ithora   in varchar2, -- 9
                           pd_fproc    in date, -- 10
                           pn_emp      in number, -- 11
                           pn_suc      in number, -- 12
                           pn_mod      in number, -- 13
                           pn_mda      in number, -- 14
                           pn_pap      in number, -- 15
                           pn_cta      in number, -- 16
                           pn_ope      in number, -- 17  
                           pn_sbo      in number, -- 18
                           pn_top      in number, -- 19
                           pn_inst     in number, -- 20 instancia
                           pn_pais     in number, -- 21
                           pn_tdoc     in number, -- 22
                           pv_ndoc     in varchar2, -- 23 numero de documento
                           pn_esfc     in number, -- 24
                           pv_nomarc   in varchar2, -- 25
                           pv_ruta     in varchar2, -- 26
                           PV_TIPO     IN VARCHAR2, -- 27
                           pv_modo     in varchar2, -- 28 modo
                           pv_codora   in varchar2, -- 29 codigo oracle
                           pv_codban   in varchar2, -- 30 codigo bantotal
                           pv_codori   in varchar2, -- 31 codigo origen
                           pv_rutcompl in varchar2, -- 32 ruta completa
                           p_c_coderr  out varchar2, -- 33
                           p_c_deserr  out varchar2) -- 34 
   is
  
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
    -- Fecha de Modificación      : 03/06/2025
    -- Autor de la Modificación   : eninah 
    -- Descripción de Modificación: Se agregaron más parametros para el llamado a un nuevo SP
    -- Fecha de Modificación      : 05/08/2025
    -- Autor de la Modificación   : eninah 
    -- Descripción de Modificación: Se validó el funcionamiento del paquete
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
  
    begin
      pq_cr_desem_movil.sp_cr_registrar_AQPD167(PGCOD   => pn_pgcod,
                                                ITSUC   => pn_itsuc,
                                                ITMOD   => pn_itmod,
                                                ITTRAN  => pn_ittran,
                                                ITNREL  => pn_itnrel,
                                                ITFCON  => pd_itfcon,
                                                IDARC   => pn_idarc,
                                                INST    => pn_inst,
                                                NUMDOC  => pv_ndoc,
                                                RTARCHV => pv_rutcompl,
                                                MODO    => pv_modo,
                                                CODORA  => pv_codora,
                                                CODBANT => pv_codban,
                                                ORGN    => pv_codori);
    exception
      when others then
        null;
    end;
  
  end sp_cr_registra;

  procedure sp_cr_registrar_AQPD167(PGCOD   in number,
                                    ITSUC   in number,
                                    ITMOD   in number,
                                    ITTRAN  in number,
                                    ITNREL  in number,
                                    ITFCON  in date,
                                    IDARC   in number,
                                    INST    in number,
                                    NUMDOC  in varchar2,
                                    RTARCHV in varchar2,
                                    MODO    in varchar2,
                                    CODORA  in varchar2,
                                    CODBANT in varchar2,
                                    ORGN    IN VARCHAR2) is
  
    codigo_oracle   varchar2(20);
    codigo_bantotal varchar2(30);
    codigo_origen   varchar2(30);
    estado          varchar2(1);
  begin
    codigo_oracle   := trim(CODORA);
    codigo_bantotal := trim(CODBANT);
    codigo_origen   := trim(ORGN);
    estado          := 'P';
    begin
      insert into AQPD167
        (AQPD167PGCOD,
         AQPD167ITSUC,
         AQPD167ITMOD,
         AQPD167ITTRAN,
         AQPD167ITNREL,
         AQPD167ITFCON,
         AQPD167IDARC,
         AQPD167INST,
         AQPD167NUMDOC,
         AQPD167RTARCHV,
         AQPD167MODO,
         AQPD167CODORA,
         AQPD167CODBANT,
         AQPD167CODORI,
         AQPD167EST)
      values
        (PGCOD,
         ITSUC,
         ITMOD,
         ITTRAN,
         ITNREL,
         ITFCON,
         IDARC,
         INST,
         NUMDOC,
         RTARCHV,
         MODO,
         codigo_oracle,
         codigo_bantotal,
         codigo_origen,
         estado);
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_registrar_AQPD167;

end PQ_CR_DESEM_MOVIL;
/
