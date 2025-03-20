create or replace package PQ_CV_MONITOREO_ACF_CC is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_CC
  -- Sistema               : BANTOTAL
  -- Módulo                : AGENTES CORRESPONSALES - PROCESOS MC
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/12/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA para el monitoreo de CC - ACF+
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 10/06/2022
  -- Autor de Creación     : Julio Luna Flores
  -- Descripción Modific.  : Envío de Consultas de Saldos a Unibanca
  -- Fecha de Modificación : 27/06/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos personales de cliente (documento de identidad, nombre completo y fecha de nacimiento)
  -- Fecha de Modificación : 24/11/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de saldo de cliente en índice 50
  -- Fecha de Modificación : 29/05/2023
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Envio de cuenta origen en indice 53
  -- Fecha de Modificación : 17/05/2024
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Correccion envio datos comercio en consulta de saldo
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --// Entrada Principal 
  procedure sp_construirTrama(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2,
                              pn_codcan in varchar2,
                              pc_trmrsp out varchar2,
                              pc_coderr out varchar2,
                              pc_msgerr out varchar2);

  procedure sp_parsearTrama(pn_codcan in varchar2,
                            pc_trmpar in varchar2,
                            pc_coderr out varchar2,
                            pc_msgerr out varchar2);

  procedure sp_logTrama(pn_codcan in char,
                        pc_trmpar in varchar2,
                        pc_obstrm in varchar2,
                        pc_coderr out varchar2,
                        pc_msgerr out varchar2);

  procedure sp_debugErrorres(pn_codcan in char,
                             pc_trmpar in varchar2,
                             pc_obstrm in varchar2,
                             pc_coderr in varchar2,
                             pc_msgerr in varchar2);

  --// Cabecera
  function fn_trama_indice001 return varchar2;
  function fn_trama_indice002 return varchar2;
  function fn_trama_indice003 return varchar2;
  function fn_trama_indice004 return varchar2;
  function fn_trama_indice005 return varchar2;
  function fn_trama_indice006 return varchar2;
  function fn_trama_indice007 return varchar2;
  function fn_trama_indice008 return varchar2;
  function fn_trama_indice009 return varchar2;

  --// Detalle
  function fn_trama_indice010(pn_numtra in number) return varchar2;
  function fn_trama_indice011(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice012(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice013(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice014(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice015(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice016(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice017(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice018(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice019(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice020(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice021(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice022(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice023(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice024(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice025(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice026(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice027(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice028(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice029(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice030(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice031(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice032(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice033(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice034(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice035(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice036(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice037(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice038(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice039(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice040(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice041(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice042(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice043(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice044(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice045(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice046(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice047(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice048(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice049(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice050(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice051(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice052(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice053(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice054(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice055(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice056(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice057(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice058(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice059(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice060(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice061(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice062(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice063(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice064(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice065(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice066(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice067(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice068(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice069(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice070(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice071(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice072(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice073(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice074(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice075(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice076(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice077(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice078(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice079(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice080(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice081(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice082(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice083(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice084(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice085(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice086(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice087(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice088(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice089(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

  function fn_trama_indice090(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;
  function fn_trama_indice091(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2;

end PQ_CV_MONITOREO_ACF_CC;
/

create or replace package body PQ_CV_MONITOREO_ACF_CC is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_CC
  -- Sistema               : BANTOTAL
  -- Módulo                : AGENTES CORRESPONSALES - PROCESOS MC
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/12/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA para el monitoreo de CC - ACF+
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 10/06/2022
  -- Autor de Creación     : Julio Luna Flores
  -- Descripción Modific.  : Envío de Consultas de Saldos a Unibanca
  -- Fecha de Modificación : 27/06/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de datos personales de cliente (documento de identidad, nombre completo y fecha de nacimiento)
  -- Fecha de Modificación : 24/11/2022
  -- Autor de Modificación : Julio Luna Flores
  -- Descripción Modific.  : Envío de saldo de cliente en índice 50
  -- Fecha de Modificación : 29/05/2023
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Envio de cuenta origen en indice 53
  -- Fecha de Modificación : 17/05/2024
  -- Autor de Creación     : Danny Manrique Callata
  -- Descripción Modific.  : Correccion envio datos comercio en consulta de saldo
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --//
  procedure sp_construirTrama(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2,
                              pn_codcan in varchar2,
                              pc_trmrsp out varchar2,
                              pc_coderr out varchar2,
                              pc_msgerr out varchar2) is
  
    lc_trmrsp varchar2(4000);
    --//
    lc_aux031 varchar2(19);
  
    cursor c1 is
      select acf.c_cabdet,
             acf.c_import,
             acf.n_indice,
             acf.n_codigo,
             acf.c_noming,
             acf.c_nomesp,
             acf.c_format,
             acf.c_tipdat,
             acf.n_longit,
             acf.n_decima,
             acf.n_posini,
             acf.n_camiso,
             acf.c_justxt,
             acf.c_jusnum
        from jaql634 acf
       where acf.n_indice <= 1000
       order by acf.n_indice;
  begin
    pc_coderr := '00000';
    pc_msgerr := '';
    --//
    for i in c1 loop
      --//
      case i.n_indice
        when 1 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := rpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 2 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice002, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice002, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 3 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice003, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice003, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 4 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice004, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice004, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 5 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice005, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice005, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 6 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice006, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice006, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 7 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice007, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice007, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 8 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice008, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice008, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 9 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice009, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice009, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 10 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice010(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice010(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 11 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice011(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice011(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 12 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice012(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice012(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 13 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice013(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice013(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 14 then
          --R        
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice014(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice014(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 15 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice015(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice015(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 16 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice016(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice016(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 17 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice017(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice017(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 18 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice018(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice018(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 19 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice019(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice019(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 20 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice020(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice020(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 21 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice021(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice021(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 22 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice022(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice022(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 23 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice023(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice023(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 24 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice024(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice024(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 25 then
          --O
          --//
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice025(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice025(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 26 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice026(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice026(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 27 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice027(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice027(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 28 then
          --S
          --//
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice028(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice028(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 29 then
          --O
          --//
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice029(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice029(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 30 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice030(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice030(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 31 then
          --S
          --//          
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice031(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice031(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 32 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice032(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice032(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 33 then
          --O
          --//          
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 34 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice034(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice034(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 35 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice035(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice035(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 36 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice036(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice036(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 37 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice037(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice037(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 38 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice038(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice038(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 39 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice039(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice039(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 40 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice040(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice040(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 41 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice041(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice041(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 42 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice042(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice042(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 43 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice043(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice043(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 44 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice044(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice044(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 45 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice045(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice045(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 46 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice046(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice046(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 47 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice047(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice047(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 48 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice048(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice048(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 49 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice049(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice049(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 50 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice050(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice050(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 51 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice051(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice051(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 52 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice052(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice052(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 53 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice053(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice053(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 54 then
          --S
          --// aqui esta el problema 
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice054(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice054(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 55 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice055(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice055(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 56 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice056(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice056(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 57 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice057(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice057(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 58 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice058(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice058(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 59 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice059(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice059(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 60 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice060(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice060(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 61 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice061(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice061(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 62 then
          --O
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice062(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice062(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 63 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice063(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice063(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 64 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice064(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice064(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 65 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice065(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice065(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 66 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice066(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice066(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 67 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice067(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice067(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 68 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice068(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice068(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 69 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice069(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice069(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 70 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice070(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice070(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 71 then
          --O
          --//                  
          if i.c_import = 'O' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice071(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'O' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice071(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 72 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice072(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice072(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 73 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice073(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice073(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 74 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice074(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice074(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 75 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice075(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice075(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 76 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice076(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice076(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 77 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice077(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice077(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 78 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice078(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice078(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 79 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice079(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice079(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 80 then
          --S
          --//                  
          if i.c_import = 'S' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice080(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'S' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice080(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 81 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice081(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice081(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 82 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice082(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice082(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 83 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice083(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice083(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 84 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice084(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice084(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 85 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice085(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice085(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 86 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice086(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice086(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 87 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice087(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice087(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 88 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice088(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice088(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 89 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice089(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice089(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 90 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice090(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice090(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 91 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice091(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice091(pn_numtra, pd_fectra,
                                                         pc_hortra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        else
          null;
          --//    
      end case;
      --//
    end loop;
  
    --// Realizar validaciones antes de enviar la trama al ACF
    pc_trmrsp := lc_trmrsp;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_construirTrama;
  --//

  /*******************************************************************************************
  *
  * Inicio de la construccion de la trama CABECERA
  *
  *******************************************************************************************/

  --// R
  function fn_trama_indice001 return varchar2 is
    lc_cmp001 varchar2(100);
  begin
    --//
    lc_cmp001 := 'ByteI';
    return lc_cmp001;
  exception
    when others then
      return '00000';
  end fn_trama_indice001;

  --// R
  function fn_trama_indice002 return varchar2 is
    lc_cmp002 varchar2(100);
  begin
    --//
    lc_cmp002 := 'N';
    return lc_cmp002;
  exception
    when others then
      return '00000';
  end fn_trama_indice002;

  --// R
  function fn_trama_indice003 return varchar2 is
    lc_cmp003 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'DD') into lc_cmp003 from dual;
    return lc_cmp003;
  exception
    when others then
      return '00000';
  end fn_trama_indice003;

  --// R
  function fn_trama_indice004 return varchar2 is
    lc_cmp004 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'MM') into lc_cmp004 from dual;
    return lc_cmp004;
  exception
    when others then
      return '00000';
  end fn_trama_indice004;

  --// R
  function fn_trama_indice005 return varchar2 is
    lc_cmp005 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'YYYY') into lc_cmp005 from dual;
    return lc_cmp005;
  exception
    when others then
      return '00000';
  end fn_trama_indice005;

  --// R
  function fn_trama_indice006 return varchar2 is
    lc_cmp006 varchar2(100);
  begin
    --//
    select to_char(sysdate, 'hh24') into lc_cmp006 from dual;
    return lc_cmp006;
  exception
    when others then
      return '00000';
  end fn_trama_indice006;

  --// R
  function fn_trama_indice007 return varchar2 is
    lc_cmp007 varchar2(100);
  begin
    --//
    select to_char(sysdate, 'mi') into lc_cmp007 from dual;
    return lc_cmp007;
  exception
    when others then
      return '00000';
  end fn_trama_indice007;

  --// R
  function fn_trama_indice008 return varchar2 is
    lc_cmp008 varchar2(100);
  begin
    --//
    lc_cmp008 := '00745';
    return lc_cmp008;
  exception
    when others then
      return '00000';
  end fn_trama_indice008;

  --// R
  function fn_trama_indice009 return varchar2 is
    lc_cmp009 varchar2(100);
  begin
    --//
    lc_cmp009 := '426153';
    return lc_cmp009;
  exception
    when others then
      return '00000';
  end fn_trama_indice009;

  /*******************************************************************************************
  *
  * Inicio de la construccion de la trama DETALLE
  *
  *******************************************************************************************/

  --// R
  function fn_trama_indice010(pn_numtra in number) return varchar2 is
    lc_cmp010 varchar2(100);
  begin
    --//
  
    lc_cmp010 := '7942';
    /*
    select to_char(a1.jaql540comsj)
      into lc_cmp010
      from jaql540 a1
     where a1.jaql540cotra = pn_numtra;
    */
    return lc_cmp010;
  exception
    when others then
      return '00000';
  end fn_trama_indice010;

  --// R
  function fn_trama_indice011(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp011 varchar2(100) := '';
  begin
    --//
    select a.jaql5nutar
      into lc_cmp011
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp011;
  exception
    when others then
      return ' ';
  end fn_trama_indice011;

  --// R
  function fn_trama_indice012(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp012 varchar2(100);
  begin
    --//   modificado el 21/01/2019 , actual a.jaql5cotra
    select lpad(trim(a.jaql5cotra), 6, '0')
      into lc_cmp012
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --jlunaf 10/06/2022 Se añade condicion para transacción de consulta de saldos
    if lc_cmp012 = '930000' then
       lc_cmp012 := '31';
    end if;
    return lc_cmp012;
  exception
    when others then
      return '0';
  end fn_trama_indice012;

  --// S
  function fn_trama_indice013(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp013 varchar2(100);
  begin
    --//
    /* select SUBSTR(a1.jaql539valtr, 3, 4)
     into lc_cmp013
     from jaql539 a1
    where a1.jaql539cotra = pn_numtra
      and a1.jaql539nucam = 3;*/
    lc_cmp013 := '0';
    return lc_cmp013;
  exception
    when others then
      return '0';
  end fn_trama_indice013;

  --// R 
  function fn_trama_indice014(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp014 varchar2(100);
  begin
    --//    
    select decode(a.jaql5comen, '0200', 'N', '0420', 'S')
      into lc_cmp014
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp014;
  exception
    when others then
      return ' ';
  end fn_trama_indice014;

  --// R
  function fn_trama_indice015(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp015 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
    lc_codtra char(6); --jlunaf 10/06/2022
  begin
    --//   
    sp_tipo_cambio(FECHA => pd_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --//
    --jlunaf 10/06/2022 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --jlunaf 10/06/2022 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra <> '930000' then
       select a.jaql6imptr, a.jaql6comot
         into ln_aux004, ln_codmda
         from jaql006 a
        where a.jaql6seint = pn_numtra
          and a.jaql6fetra = pd_fectra
          and a.jaql6hotra = pc_hortra;
    end if;
  
    --Convertir siempre a dolares
    ln_conver := ln_aux004 / ln_tipcam;
    lc_cmp015 := lpad(trim(replace(replace(to_char(ln_conver, '9999999D99'), ',', ''), '.', '')  ),
                      14, '0');
  
    --//               
    return lc_cmp015;
  exception
    when others then
      return '0';
  end fn_trama_indice015;

  --// R
  function fn_trama_indice016(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp016 varchar2(100);
    ln_aux004 number := 0; --jlunaf 10/06/2022
    lc_codtra char(6); --jlunaf 10/06/2022
  begin
    --//
    --jlunaf 10/06/2022 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --jlunaf 10/06/2022 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra <> '930000' then
       select a.jaql6imptr
         into ln_aux004
         from jaql006 a
        where a.jaql6seint = pn_numtra
          and a.jaql6fetra = pd_fectra
          and a.jaql6hotra = pc_hortra;
    end if;
    
    lc_cmp016 := lpad(trim(replace(replace(to_char(ln_aux004, '9999999D99'), ',', ''), '.', '')),
                      14, '0');
  
    return lc_cmp016;
  exception
    when others then
      return '0';
  end fn_trama_indice016;

  --// R
  function fn_trama_indice017(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp017 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
    lc_codtra char(6); --jlunaf 10/06/2022
  begin
    sp_tipo_cambio(FECHA => pd_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --//
    --jlunaf 10/06/2022 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --jlunaf 10/06/2022 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra <> '930000' then
       select a.jaql6imptr, a.jaql6comot
         into ln_aux004, ln_codmda
         from jaql006 a
        where a.jaql6seint = pn_numtra
          and a.jaql6fetra = pd_fectra
          and a.jaql6hotra = pc_hortra;
    end if;
    
    --Convertir siempre a dolares
    ln_conver := ln_aux004 / ln_tipcam;
    lc_cmp017 := lpad(trim(replace(replace(to_char(ln_conver, '9999999D99'), ',', '') , '.', '') ),
                      14, '0');
    --//               
    return lc_cmp017;
  exception
    when others then
      return '00000';
  end fn_trama_indice017;

  --// R
  function fn_trama_indice018(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp018 varchar2(100);
  begin
    lc_cmp018 := to_char(pd_fectra, 'yyyymmdd') ||
                 trim(replace(pc_hortra, ':', ''));
    return lc_cmp018;
  exception
    when others then
      return '00000';
  end fn_trama_indice018;

  --// R
  function fn_trama_indice019(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp019 varchar2(100);
    ln_tipcam number := 0;
  begin
    sp_tipo_cambio(FECHA => pd_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    lc_cmp019 := lpad(replace(replace(to_char(ln_tipcam,'FM90D900'), ',', ''), '.', ''), 11, '0'); --Hlaqui 26/01/2022 - Se agrega formato para mostrar correctamente
    return lc_cmp019;
  exception
    when others then
      return '00000';
  end fn_trama_indice019;

  --// R
  function fn_trama_indice020(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp020 varchar2(100);
  begin
    --//
    select a.jaql5seiso
      into lc_cmp020
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp020;
  exception
    when others then
      return '00000';
  end fn_trama_indice020;

  --// R
  function fn_trama_indice021(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp021 varchar2(100);
  begin
    --//
    lc_cmp021 := trim(replace(pc_hortra, ':', ''));
    return lc_cmp021;
  exception
    when others then
      return '00000';
  end fn_trama_indice021;

  --// R
  function fn_trama_indice022(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp022 varchar2(100);
  begin
    --//
    lc_cmp022 := to_char(pd_fectra, 'yyyymmdd');
    return lc_cmp022;
  exception
    when others then
      return '00000';
  end fn_trama_indice022;

  --// S
  function fn_trama_indice023(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp023 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --// 
    /*
    select b1.jaql540nutra, b1.jaql540feini
      into lc_tracet, ld_fectra
      from jaql540 b1
     where b1.jaql540cotra = pn_numtra;
    --//  
    select EXPDATE
      into lc_cmp023
      from itxn@TXNSWT c1
     where lpad(to_char(trace), 12, '0') = lc_tracet
       and capdate = ld_fectra
       and prcode <> 150001;
    */
    --//      
    lc_cmp023 := '00000';
    return lc_cmp023;
  exception
    when others then
      return '00000';
  end fn_trama_indice023;

  --// R
  function fn_trama_indice024(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp024 varchar2(100);
  begin
    --//
    lc_cmp024 := 'O';
    return lc_cmp024;
  exception
    when others then
      return 'O';
  end fn_trama_indice024;

  --// O
  function fn_trama_indice025(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp025 varchar2(100);
  begin
    --//
    select to_char(a1.pgfape, 'yyyymmdd')
      into lc_cmp025
      from fst017 a1
     where a1.pgcod = 1;
    return lc_cmp025;
  exception
    when others then
      return '00000';
  end fn_trama_indice025;

  --// R
  function fn_trama_indice026(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp026 varchar2(100);
  begin
    --//
    --JAQL6Gineg
    select a.jaql5gineg
      into lc_cmp026
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp026;
  exception
    when others then
      return '00000';
  end fn_trama_indice026;

  --// R  -- Oscar Diaz Yataco
  function fn_trama_indice027(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp027 varchar2(100) := '604';
  begin
    --//
    return lc_cmp027;
  exception
    when others then
      return '00000';
  end fn_trama_indice027;

  --// S
  function fn_trama_indice028(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp028 varchar2(100) := '604';
  begin
    --//
    return lc_cmp028;
  exception
    when others then
      return '00000';
  end fn_trama_indice028;

  --// O
  function fn_trama_indice029(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp029 varchar2(100) := '604';
  begin
    --//
    return lc_cmp029;
  exception
    when others then
      return '00000';
  end fn_trama_indice029;

  --// R
  function fn_trama_indice030(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp030 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --//    
    --Se envia el valor del CHIP debido a que no se tiene ese valor en las transacciones
    lc_cmp030 := '51';
    return lc_cmp030;
  exception
    when others then
      return '00000';
  end fn_trama_indice030;

  --// S
  function fn_trama_indice031(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp031 varchar2(100) := ' ';
  begin
    --// 
    select a.jaql5nutar
      into lc_cmp031
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    return lc_cmp031;
  exception
    when others then
      return '00000';
  end fn_trama_indice031;

  --// R
  function fn_trama_indice032(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp032 varchar2(100);
  begin
    --Se el valor en duro debido a que no se tiene este valor en las transacciones
    lc_cmp032 := '2';
    return lc_cmp032;
  exception
    when others then
      return '00000';
  end fn_trama_indice032;

  --// O
  function fn_trama_indice033(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp033 varchar2(100);
  begin
    --//
    lc_cmp033 := '0';
    return lc_cmp033;
  exception
    when others then
      return '00000';
  end fn_trama_indice033;

  --// R
  function fn_trama_indice034(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp034 varchar2(100) := '';
  begin
    --//
    /*    select nvl(substr(jaql5inadq, -6), '0') into lc_cmp034
    from jaql005 a
    where a.jaql5seint=pn_numtra 
    and a.jaql5fetra= pd_fectra
    and a.jaql5hotra= pc_hortra;        */
    lc_cmp034 := '426153'; --BIN
    return lc_cmp034;
  exception
    when others then
      return '00000';
  end fn_trama_indice034;

  --// R
  function fn_trama_indice035(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp035 varchar2(100);
  begin
    --//Se envía el BIN de la Caja   
    lc_cmp035 := '426153';
    return lc_cmp035;
  exception
    when others then
      return '00000';
  end fn_trama_indice035;

  --// R
  function fn_trama_indice036(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp036 varchar2(100);
  begin
    --//
    select nvl(a.jaql5coaut, '0')
      into lc_cmp036
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    return lc_cmp036;
  exception
    when others then
      return '00000';
  end fn_trama_indice036;

  --// R
  function fn_trama_indice037(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp037 varchar2(100) := ' ';
  begin
    --//
    select nvl(a.jaql5cores, ' ')
      into lc_cmp037
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp037;
  exception
    when others then
      return lc_cmp037;
  end fn_trama_indice037;

  --// O
  function fn_trama_indice038(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp038 varchar2(100) := ' ';
  begin
    select nvl(a.jaql5cores, ' ')
      into lc_cmp038
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    return lc_cmp038;
  exception
    when others then
      return lc_cmp038;
  end fn_trama_indice038;

  --// R
  function fn_trama_indice039(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp039 varchar2(100) := '';
  begin
    --//Se envia el codigo de servicio de las tarjetas CHIP  
    lc_cmp039 := '226';
    return lc_cmp039;
  exception
    when others then
      return lc_cmp039;
  end fn_trama_indice039;

  --// R
  function fn_trama_indice040(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp040 varchar2(100) := ' ';
  begin
    --//    
    select nvl(a.jaql5cisot, ' ')
      into lc_cmp040
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    return lc_cmp040;
  exception
    when others then
      return lc_cmp040;
  end fn_trama_indice040;

  --// R
  function fn_trama_indice041(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp041 varchar2(100) := ' ';
  begin
    --//    
    select nvl(a.jaql5cisoc, ' ')
      into lc_cmp041
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    return lc_cmp041;
  exception
    when others then
      return lc_cmp041;
  end fn_trama_indice041;

  --// R
  function fn_trama_indice042(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp042 varchar2(150) := ' ';
    lc_codtra char(6);
  begin
    --//
    --dmanriquec 17/05/2024 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --dmanriquec 17/05/2024 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra = '930000' then
        select --nvl(trim(b.jaql4nocom), ' ')
               upper(translate(lower(b.jaql4nocom),'áéíóöoúüuñ','aeiooouuun'))
          into lc_cmp042
          from jaql005 a
         inner join jaql009 c
            on c.jaql9cisoc = a.JAQL5Cisoc
         inner join jaql004 b
            on c.jaql4cocom = b.jaql4cocom
         where a.jaql5seint = pn_numtra
           and a.jaql5fetra = pd_fectra
           and a.jaql5hotra = pc_hortra;
    else
        select --nvl(trim(b.jaql4nocom), ' ')
               upper(translate(lower(b.jaql4nocom),'áéíóöoúüuñ','aeiooouuun'))
          into lc_cmp042
          from jaql006 a
         inner join jaql009 c
            on c.jaql9cisoc = a.JAQL6Cisoc
         inner join jaql004 b
            on c.jaql4cocom = b.jaql4cocom
         where a.jaql6seint = pn_numtra
           and a.jaql6fetra = pd_fectra
           and a.jaql6hotra = pc_hortra;
    end if;
    --dmanriquec 17/05/2024 FIN
    return lc_cmp042;
  exception
    when others then
      return lc_cmp042;
  end fn_trama_indice042;

  --// R
  function fn_trama_indice043(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp043 varchar2(100) := ' ';
    lc_codtra char(6);
  begin
    --//
    --dmanriquec 17/05/2024 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --dmanriquec 17/05/2024 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra = '930000' then
        select nvl(trim(d.locnom), ' ')
          into lc_cmp043
          from jaql005 a
         inner join jaql009 c
            on c.jaql9cisoc = a.JAQL5Cisoc
         inner join jaql004 b
            on c.jaql4cocom = b.jaql4cocom
         inner join fst070 d
            on b.jaql4depar = d.depcod
           and b.jaql4provi = d.loccod
         where a.jaql5seint = pn_numtra
           and a.jaql5fetra = pd_fectra
           and a.jaql5hotra = pc_hortra;  
    else
        select nvl(trim(d.locnom), ' ')
          into lc_cmp043
          from jaql006 a
         inner join jaql009 c
            on c.jaql9cisoc = a.JAQL6Cisoc
         inner join jaql004 b
            on c.jaql4cocom = b.jaql4cocom
         inner join fst070 d
            on b.jaql4depar = d.depcod
           and b.jaql4provi = d.loccod
         where a.jaql6seint = pn_numtra
           and a.jaql6fetra = pd_fectra
           and a.jaql6hotra = pc_hortra;
    end if;
    --dmanriquec 17/05/2024 FIN
    return lc_cmp043;
  exception
    when others then
      return lc_cmp043;
  end fn_trama_indice043;

  --// R
  function fn_trama_indice044(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp044 varchar2(100) := '';
  begin
    --//Pais Origen
    lc_cmp044 := 'PERU';
    return lc_cmp044;
  exception
    when others then
      return lc_cmp044;
  end fn_trama_indice044;

  --// O
  function fn_trama_indice045(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp045 varchar2(100) := ' ';
  begin
    --// Unibanca indico que no van ceros sino espacios en blanco 
    lc_cmp045 := '  ';
    return lc_cmp045;
  exception
    when others then
      return lc_cmp045;
  end fn_trama_indice045;

  --// S
  function fn_trama_indice046(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp046 varchar2(100) := '';
  begin
    --// No aplica porque nuestras tarjetas no son nominadas y no lega el TRACK 1
    lc_cmp046 := ' ';
    return lc_cmp046;
  exception
    when others then
      return lc_cmp046;
  end fn_trama_indice046;

  --// S
  function fn_trama_indice047(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp047 varchar2(100) := '';
  begin
    --// No aplica porque nuestras tarjetas no son nominadas y no lega el TRACK 1   
    lc_cmp047 := ' ';
    return lc_cmp047;
  exception
    when others then
      return lc_cmp047;
  end fn_trama_indice047;

  --// R
  function fn_trama_indice048(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp048 varchar2(100) := '';
  begin
    --//Transacciones en Soles    
    lc_cmp048 := '604';
    /*select a1.jaql539valtr
     into lc_cmp048
     from jaql539 a1
    where a1.jaql539cotra = pn_numtra
      and a1.jaql539nucam = 49;*/
    return lc_cmp048;
  exception
    when others then
      return lc_cmp048;
  end fn_trama_indice048;

  --// S
  function fn_trama_indice049(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp049 varchar2(100) := '';
    lc_auxtar varchar2(100) := '';
    lc_codtra char(6); --jlunaf 10/06/2022
  begin
    --// Moneda de la cuenta de la transacción
    
    --jlunaf 10/06/2022 Se obtiene código de transacción
    select trim(a.jaql5cotra)
      into lc_codtra
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --jlunaf 10/06/2022 Se añade condicion para transacción de consulta de saldos (no se genera registro en JAQL006)
    if lc_codtra <> '930000' then
       select decode(a.jaql6mda02, 0, '604', 101, '840')
         into lc_cmp049
         from jaql006 a
        where a.jaql6seint = pn_numtra
          and a.jaql6fetra = pd_fectra
          and a.jaql6hotra = pc_hortra;
    else
       lc_cmp049 := '604';
    end if;
    
    return lc_cmp049;
  exception
    when others then
      return lc_cmp049;
  end fn_trama_indice049;

  --// O
  function fn_trama_indice050(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp050 varchar2(100) := '';
    lc_auxtar varchar2(100);
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    ln_saldo  number;
    ln_tipcam number := 0;
  begin
    --//
    -- jlunaf 24/11/2022 - INICIO - Obtención del saldo sumarizado de todas las cuentas asociadas del tarjeta
    lc_cmp050 := '0';
    ln_saldo  := 0;
    
    -- Obtiene tipo de cambio
    sp_tipo_cambio(FECHA => pd_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    
    -- Obtiene tarjeta habiente para recorrer cuentas asociadas al documento del cliente
    select substr(a.jaql5nutar, 1, 16) into lc_auxtar from jaql005 a where a.jaql5seint = pn_numtra
      and a.jaql5fetra = pd_fectra and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
      
    -- Obtiene saldo sumarizado
    select nvl(sum(case when scmda = 0 then (scsdo / ln_tipcam) else scsdo end), 0) into ln_saldo from fsd011
       where pgcod = 1 and scmod in (21,22) and sccta in 
      (select ctnro from fsr008 where cttfir = 'T' and pepais = ln_codpai and petdoc = ln_tipdoc
          and pendoc = lc_numdoc)
       and scstat = 0;
    lc_cmp050 := lpad(trim(replace(replace(to_char(ln_saldo, '999999999D99'), ',', ''), '.', '')), 14, '0');
    -- jlunaf 27/06/2022 - FIN
    return lc_cmp050;
  exception
    when others then
      return lc_cmp050;
  end fn_trama_indice050;

  --// S dirección del atm 
  function fn_trama_indice051(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp051 varchar2(100) := ' ';
  begin
    --//
    return lc_cmp051;
  exception
    when others then
      return lc_cmp051;
  end fn_trama_indice051;

  --// O
  function fn_trama_indice052(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp052 varchar2(100) := '';
  begin
    --//        
    lc_cmp052 := '0';
    return lc_cmp052;
  exception
    when others then
      return lc_cmp052;
  end fn_trama_indice052;

  --// S
  function fn_trama_indice053(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp053 varchar2(100) := ' ';
    lc_trans varchar2(100) := ' ';
  begin
    lc_cmp053 := ' ';
    --Cuenta Asociada     
    --DManriqueC Se añade validacion para armado de cuenta en transacciones 11 y 12  (Retiros agente)
    select a1.jaql6cttra 
    into lc_trans
        from jaql006 a1
       where a1.jaql6seint = pn_numtra
         and a1.jaql6fetra = pd_fectra
         and a1.jaql6hotra = pc_hortra;
     if lc_trans in (11,12)then
        select lpad(to_char(a1.jaql6cta02), 9, '0') ||
               lpad(to_char(a1.jaql6mod02), 3, '0') ||
               lpad(to_char(a1.jaql6mda02), 3, '0') ||
               lpad(to_char(a1.jaql6sbo02), 2, '0') ||
               lpad(to_char(a1.jaql6top02), 3, '0')
          into lc_cmp053
          from jaql006 a1
         where a1.jaql6seint = pn_numtra
           and a1.jaql6fetra = pd_fectra
           and a1.jaql6hotra = pc_hortra;

      return lc_cmp053;
     else
      return lc_cmp053;
     end if;
    
  exception
    when others then
      return lc_cmp053;
  end fn_trama_indice053;

  --// S
  function fn_trama_indice054(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp054 varchar2(100) := ' ';
  begin
    --// Cuenta Destino de la transferencia 
    /* select lpad(to_char(a1.jaql6cta01), 9, '0') ||
           lpad(to_char(a1.jaql6mod01), 3, '0') ||
           lpad(to_char(a1.jaql6mda01), 3, '0') ||
           lpad(to_char(a1.jaql6sbo01), 2, '0') ||
           lpad(to_char(a1.jaql6top01), 3, '0')
      into lc_cmp054
      from jaql006 a1    
    where a1.jaql6seint=pn_numtra 
    and a1.jaql6fetra= pd_fectra
    and a1.jaql6hotra= pc_hortra;  */
    --//               
    return lc_cmp054;
  exception
    when others then
      return lc_cmp054;
  end fn_trama_indice054;

  --// S
  function fn_trama_indice055(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp055 varchar2(100) := '';
  begin
    --//        
    lc_cmp055 := 'VISA';
    return lc_cmp055;
  exception
    when others then
      return lc_cmp055;
  end fn_trama_indice055;

  --// R
  function fn_trama_indice056(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp056 varchar2(100) := ' ';
  begin
    --//  BIN     
    lc_cmp056 := '426153';
    return lc_cmp056;
  exception
    when others then
      return lc_cmp056;
  end fn_trama_indice056;

  --// S Definir descripciones de los eatados de las tarjetas 
  function fn_trama_indice057(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp057 varchar2(100) := ' ';
    lc_auxtar varchar2(100) := ' ';
  begin
    --//
    /*
    P: Procesada
    A: Activa
    C: Cancelada
    W: Suspendida
    H: Orden de captura
    F: Posible fraude
    T: Solicita cambio de PIN como primera transacción
    */
    --//               
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    --//
    select decode(b1.z0e478est, 'AC', 'A', 'BA', 'C', 'BT', 'W')
      into lc_cmp057
      from z0e478 b1
     where b1.z0e478nro = rpad(trim(lc_auxtar),19,' '); --Hlaqui 26/01/2022 - Se completa a 19 espacios
    --//   
    return lc_cmp057;
  exception
    when others then
      return lc_cmp057;
  end fn_trama_indice057;

  --// O 
  function fn_trama_indice058(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp058 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta number;
  begin
    lc_cmp058 := ' ';
    /*
    -- comentado por indicacion de riesgos/procesos centrales en reunión el viernes 23/03/2019 
    --//            
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(trim(lc_auxtar), 19, ' ')
       and a1.z0e478est = 'AC';    
  
    --// PFEBCO
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.PFEBCO, 'N')
        into lc_cmp058
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp058 := 'N';
    end if;
    --//
    */
    return lc_cmp058;
  exception
    when others then
      return lc_cmp058;
  end fn_trama_indice058;

  --// O
  function fn_trama_indice059(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp059 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp059 := 'T';
    return lc_cmp059;
  exception
    when others then
      return lc_cmp059;
  end fn_trama_indice059;

  --// S
  function fn_trama_indice060(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp060 varchar2(100) := '0';
  begin
    --//        
    lc_cmp060 := '0';
    return lc_cmp060;
  exception
    when others then
      return lc_cmp060;
  end fn_trama_indice060;

  --// R
  function fn_trama_indice061(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp061 varchar2(100) := '0';
  begin
    --//            
    return lc_cmp061;
  exception
    when others then
      return lc_cmp061;
  end fn_trama_indice061;

  --// O
  function fn_trama_indice062(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp062 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp062 := ' ';
    return lc_cmp062;
  exception
    when others then
      return lc_cmp062;
  end fn_trama_indice062;

  --// R
  function fn_trama_indice063(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp063 varchar2(100) := ' ';
    lc_tipdoc char(1);
    lc_numdoc char(12);
    lc_espbla char(1) := ' ';
    ln_numcta numeric;
  begin
    --//        
  
    /*    select a.jaql6cta02 into ln_numcta
    from jaql006 a
    where a.jaql6seint=pn_numtra 
    and a.jaql6fetra= pd_fectra
    and a.jaql6hotra= pc_hortra;            
    
    select decode(to_char(b1.petdoc), '21', '1', '9', '2', '2', '3', '5',
                  '5'),
           trim(b1.pendoc)
      into lc_tipdoc, lc_numdoc
      from fsr008 b1
     where b1.ctnro = ln_numcta;*/
  
    select a.jaql6nutar
      into lc_cmp063
      from jaql006 a
     where a.jaql6seint = pn_numtra
       and a.jaql6fetra = pd_fectra
       and a.jaql6hotra = pc_hortra;
  
    select decode(to_char(b1.z0e478tht), '21', '1', '9', '2', '2', '3', '5',
                  '5'),
           trim(b1.z0e478thd)
      into lc_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_cmp063, 19, ' ');
  
    lc_cmp063 := lc_tipdoc || lpad(trim(lc_numdoc), 12, '0') ||
                 lpad(lc_espbla, 2, ' ');
    dbms_output.put_line('lc_cmp063 : ' || lc_cmp063);
    return lc_cmp063;
  exception
    when others then
      return lc_cmp063;
  end fn_trama_indice063;

  --// S
  function fn_trama_indice064(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp064 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    
    lc_cmp064 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca primer nombre
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfnom1, ' ') into lc_cmp064 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//               
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';       
  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfnom1, ' ')
        into lc_cmp064
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp064 := ' ';
    end if;
    --//
    */
    return lc_cmp064;
  exception
    when others then
      return lc_cmp064;
  end fn_trama_indice064;

  --// S
  function fn_trama_indice065(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp065 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp065 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca segundo nombre
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfnom2, ' ') into lc_cmp065 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
  
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//     
  
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfnom2, ' ')
        into lc_cmp065
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp065 := ' ';
    end if;
    --//
    */
    return lc_cmp065;
  exception
    when others then
      return lc_cmp065;
  end fn_trama_indice065;

  --// S
  function fn_trama_indice066(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp066 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp066 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca primer apellido
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfape1, ' ') into lc_cmp066 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//      
  
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfape1, ' ')
        into lc_cmp066
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp066 := ' ';
    end if;
    --//    
    */    
    return lc_cmp066;
  exception
    when others then
      return lc_cmp066;
  end fn_trama_indice066;

  --// S
  function fn_trama_indice067(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp067 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp067 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca segundo apellido
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(pfape2, ' ') into lc_cmp067 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';      
  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select nvl(b1.pfape2, ' ')
        into lc_cmp067
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp067 := ' ';
    end if;
    --//   
    */
    return lc_cmp067;
  exception
    when others then
      return lc_cmp067;
  end fn_trama_indice067;

  --// S
  function fn_trama_indice068(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp068 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp068 := ' ';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca número de documento
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select nvl(z0e478thd, ' ') into lc_cmp068
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';   
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select b1.pfape2
        into lc_cmp068
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
      lc_cmp068 := lc_numdoc;
    else
      --// 
      lc_cmp068 := ' ';
    end if;
    */
    return lc_cmp068;
  exception
    when others then
      return lc_cmp068;
  end fn_trama_indice068;

  --// O
  function fn_trama_indice069(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp069 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp069 := '0';
    
    -- jlunaf 27/06/2022 - INICIO - Se busca fecha de nacimiento
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    select z0e478thp, z0e478tht, z0e478thd into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 where z0e478nro = rpad(lc_auxtar, 19, ' ');
    select nvl(to_char(pffnac, 'YYYYMMDD'), '0') into lc_cmp069 from fsd002
     where pfpais = ln_codpai and pftdoc = ln_tipdoc and pfndoc = lc_numdoc;
    -- jlunaf 27/06/2022 - FIN
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';  
    --//
    if length(trim(lc_numdoc)) <= 8 then
      select to_char(b1.pffnac, 'YYYYMMDD')
        into lc_cmp069
        from fsd002 b1
       where b1.pfpais = ln_codpai
         and b1.pftdoc = ln_tipdoc
         and b1.pfndoc = lc_numdoc;
    else
      lc_cmp069 := '0';
    end if;    
    --//   
    */     
    return lc_cmp069;
  exception
    when others then
      return lc_cmp069;
  end fn_trama_indice069;

  --// O
  function fn_trama_indice070(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp070 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp070 := ' ';
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';    
    --//
    select nvl(c1.ecnom, ' ')
      into lc_cmp070
      from fsd002 b1, fst009 c1
     where b1.pfpais = ln_codpai
       and b1.pftdoc = ln_tipdoc
       and b1.pfndoc = lc_numdoc
       and b1.pfeciv = c1.eccod;
    --//        
    */
    return lc_cmp070;
  exception
    when others then
      return lc_cmp070;
  end fn_trama_indice070;

  --// O
  function fn_trama_indice071(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp071 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp071 := ' ';
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select a1.z0e478thp, a1.z0e478tht, a1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';    
    --// 
    select nvl(trim(b1.sngc13dir), ' ')
      into lc_cmp071
      from sngc13 b1
     where b1.sngc13pais = ln_codpai
       and b1.sngc13tdoc = ln_tipdoc
       and b1.sngc13ndoc = lc_numdoc
       and b1.sngc13est = 'H'
       and rownum <= 1
     order by docod desc;
  
    --//
    */ 
    return lc_cmp071;
  exception
    when others then
      return lc_cmp071;
  end fn_trama_indice071;

  --// S 72
  function fn_trama_indice072(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp072 varchar2(100) := ' ';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp072 := ' ';
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';   
    --//
    select nvl(substr(pextxt, 1, instr(pextxt, '\', 15) - 1), ' ')
      into lc_cmp072
      from Fsx001 c1
     where c1.pepais = ln_codpai
       and c1.petdoc = ln_tipdoc
       and c1.pendoc = lc_numdoc
       and rownum <= 1
     order by pexren desc;
    --//    
    */
    return lc_cmp072;
  exception
    when others then
      return lc_cmp072;
  end fn_trama_indice072;

  --// S 73
  function fn_trama_indice073(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp073 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp073 := '0';
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';    
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp073
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel = 2
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    */
    return lc_cmp073;
  exception
    when others then
      return lc_cmp073;
  end fn_trama_indice073;

  --// S 74
  function fn_trama_indice074(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp074 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    lc_cmp074 := '0';
    /*
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';      
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp074
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel = 6
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    */
    return lc_cmp074;
  exception
    when others then
      return lc_cmp074;
  end fn_trama_indice074;

  --// S 75
  function fn_trama_indice075(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp075 varchar2(100) := '0';
    --//
    ln_codpai number;
    ln_tipdoc number;
    lc_numdoc char(12);
    lc_auxtar varchar2(100) := ' ';
    ln_numcta numeric;
  begin
    --//        
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//
    select b1.z0e478thp, b1.z0e478tht, b1.z0e478thd
      into ln_codpai, ln_tipdoc, lc_numdoc
      from z0e478 b1
     where b1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and b1.z0e478est = 'AC';
  
    /*select a.jaql6cta02 into ln_numcta
    from jaql006 a
    where a.jaql6seint=pn_numtra 
    and a.jaql6fetra= pd_fectra
    and a.jaql6hotra= pc_hortra;            
    
    select b1.pepais, b1.petdoc, b1.pendoc
           into ln_codpai, ln_tipdoc, lc_numdoc
      from fsr008 b1
     where b1.ctnro = ln_numcta;*/
    --//
    select nvl(d1.dotelfp, '0')
      into lc_cmp075
      from sngc17 c1, fsr005 d1
     where c1.sngc17pais = d1.pepais
       and c1.sngc17tdoc = d1.petdoc
       and c1.sngc17ndoc = d1.pendoc
       and c1.sngc17dcod = d1.docod
       and c1.sngc17corr = d1.doordp
       and c1.sngc16ttel in (1, 5, 3, 4)
       and c1.sngc17ndoc = ln_codpai
       and c1.sngc17tdoc = ln_tipdoc
       and c1.sngc17ndoc = lc_numdoc
       and rownum <= 1
     order by c1.sngc17corr desc;
    --//
    return lc_cmp075;
  exception
    when others then
      return lc_cmp075;
  end fn_trama_indice075;

  --// R 76
  function fn_trama_indice076(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp076 varchar2(100) := ' ';
  begin
    --//        
    select a.jaql5nutar
      into lc_cmp076
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    return lc_cmp076;
  exception
    when others then
      return lc_cmp076;
  end fn_trama_indice076;

  --// I 77
  function fn_trama_indice077(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp077 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp077 := ' ';
    return lc_cmp077;
  exception
    when others then
      return lc_cmp077;
  end fn_trama_indice077;

  --// I 78
  function fn_trama_indice078(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp078 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp078 := ' ';
    return lc_cmp078;
  exception
    when others then
      return lc_cmp078;
  end fn_trama_indice078;

  --// I 79
  function fn_trama_indice079(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp079 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp079 := ' ';
    return lc_cmp079;
  exception
    when others then
      return lc_cmp079;
  end fn_trama_indice079;

  --// S 80
  function fn_trama_indice080(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp080 varchar2(100) := ' ';
    lc_auxtar varchar2(100) := ' ';
  begin
    --//
    select a.jaql5nutar
      into lc_auxtar
      from jaql005 a
     where a.jaql5seint = pn_numtra
       and a.jaql5fetra = pd_fectra
       and a.jaql5hotra = pc_hortra;
    --//        
    select nvl(to_char(a1.Z0E478FAL, 'YYYYMMDD'), ' ')
      into lc_cmp080
      from z0e478 a1
     where a1.z0e478nro = rpad(lc_auxtar, 19, ' ')
       and a1.z0e478est = 'AC';
    --//
    return lc_cmp080;
  exception
    when others then
      return lc_cmp080;
  end fn_trama_indice080;

  --// I 81
  function fn_trama_indice081(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp081 varchar2(100) := '';
  begin
    --//        
    lc_cmp081 := ' ';
    return lc_cmp081;
  exception
    when others then
      return lc_cmp081;
  end fn_trama_indice081;

  --// R 82
  function fn_trama_indice082(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp082 varchar2(100) := '';
  begin
    --//        
    lc_cmp082 := '1';
    return lc_cmp082;
  exception
    when others then
      return lc_cmp082;
  end fn_trama_indice082;

  --// I 83
  function fn_trama_indice083(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp083 varchar2(100) := '';
  begin
    --//        
    lc_cmp083 := '0';
    return lc_cmp083;
  exception
    when others then
      return lc_cmp083;
  end fn_trama_indice083;

  --// I 84
  function fn_trama_indice084(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp084 varchar2(100) := '';
  begin
    --//        
    lc_cmp084 := '0';
    return lc_cmp084;
  exception
    when others then
      return lc_cmp084;
  end fn_trama_indice084;

  --// I 85
  function fn_trama_indice085(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp085 varchar2(100) := '';
  begin
    --//        
    lc_cmp085 := ' ';
    return lc_cmp085;
  exception
    when others then
      return lc_cmp085;
  end fn_trama_indice085;

  --// I 86
  function fn_trama_indice086(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp086 varchar2(100) := '';
  begin
    --//        
    lc_cmp086 := ' ';
    return lc_cmp086;
  exception
    when others then
      return lc_cmp086;
  end fn_trama_indice086;

  --// I 87
  function fn_trama_indice087(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp087 varchar2(100) := '';
  begin
    --//        
    lc_cmp087 := '0';
    return lc_cmp087;
  exception
    when others then
      return lc_cmp087;
  end fn_trama_indice087;

  --// I 88
  function fn_trama_indice088(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp088 varchar2(100) := '';
  begin
    --//        
    lc_cmp088 := ' ';
    return lc_cmp088;
  exception
    when others then
      return lc_cmp088;
  end fn_trama_indice088;

  --// I 89
  function fn_trama_indice089(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp089 varchar2(100) := '';
  begin
    --//        
    lc_cmp089 := '0';
    return lc_cmp089;
  exception
    when others then
      return lc_cmp089;
  end fn_trama_indice089;

  --// I 90
  function fn_trama_indice090(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp090 varchar2(100) := '';
  begin
    --//        
    lc_cmp090 := ' ';
    return lc_cmp090;
  exception
    when others then
      return lc_cmp090;
  end fn_trama_indice090;

  --// R 91
  function fn_trama_indice091(pn_numtra in number,
                              pd_fectra in date,
                              pc_hortra in varchar2) return varchar2 is
    lc_cmp091 varchar2(100) := '';
  begin
    --//        
    lc_cmp091 := 'ByteF';
    return lc_cmp091;
  exception
    when others then
      return lc_cmp091;
  end fn_trama_indice091;

  --//
  procedure sp_parsearTrama(pn_codcan in varchar2,
                            pc_trmpar in varchar2,
                            pc_coderr out varchar2,
                            pc_msgerr out varchar2) is
    --//
    lc_coderr varchar2(5) := '';
    lc_msgerr varchar2(1000) := '';
    lc_trmpar varchar2(4000) := '';
    ln_indice number := 0;
    --//
    cursor c1 is
      select acf.c_cabdet,
             acf.c_import,
             acf.n_indice,
             acf.n_codigo,
             acf.c_noming,
             acf.c_nomesp,
             acf.c_format,
             acf.c_tipdat,
             acf.n_longit,
             acf.n_decima,
             acf.n_posini,
             acf.n_camiso,
             acf.c_justxt,
             acf.c_jusnum
        from jaql634 acf
       where acf.n_indice < 1000
       order by acf.n_indice;
  begin
    lc_coderr := '00000';
    lc_msgerr := '';
    lc_trmpar := '';
    --// Longitud de la trama
    dbms_output.put_line('LONGITUD TRAMA ACF [' || length(pc_trmpar) || ']');
    --//
    for i in c1 loop
      --//
      lc_trmpar := substr(pc_trmpar, i.n_posini, i.n_longit);
      dbms_output.put_line('TRAMA ACF PARSEADA CAMPO[' ||
                           lpad(trim(to_char(i.n_indice)), 2, '0') ||
                           '], IMPORTANCIA [' || i.c_import || ']' ||
                           ', VALOR : [' || lc_trmpar || ']' --||
                           --', LONGITUD : [' || i.n_longit || ']'
                           );
      --//
    /*
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              lc_trmpar := substr(pc_trmpar, i.n_posini, i.n_longit);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              dbms_output.put_line('TRAMA ACF PARSEADA CAMPO[' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   lpad(trim(to_char(i.n_indice)), 2, '0') ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   '], LONGITUD [' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   lpad(trim(to_char(i.n_longit)), 2, '0') ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   '], TIPO DE DATO [' || i.c_tipdat ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   '], IMPORTANCIA [' || i.c_import || ']' ||
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ', VALOR : [' || lc_trmpar || ']');
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              */
    --//
    end loop;
    --//
    pc_coderr := lc_coderr;
    pc_msgerr := lc_msgerr;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_parsearTrama;

  --//
  procedure sp_logTrama(pn_codcan in char,
                        pc_trmpar in varchar2,
                        pc_obstrm in varchar2,
                        pc_coderr out varchar2,
                        pc_msgerr out varchar2) is
  
    --//
    lc_coderr varchar2(5) := '';
    lc_msgerr varchar2(1000) := '';
    --//
    ln_serenv JAQL635.N_SERENV%type;
    lc_canenv JAQL635.C_CANENV%type;
    ld_fecenv JAQL635.D_FECENV%type;
    lc_horenv JAQL635.C_HORENV%type;
    lc_trmenv JAQL635.C_TRMENV%type;
    lc_obsenv JAQL635.C_OBSENV%type;
    lc_auxvc1 JAQL635.C_AUXVC1%type;
    lc_auxvc2 JAQL635.C_AUXVC2%type;
    lc_auxvc3 JAQL635.C_AUXVC3%type;
    ln_auxnu1 JAQL635.N_AUXNU1%type;
    ln_auxnu2 JAQL635.N_AUXNU2%type;
    ln_auxnu3 JAQL635.N_AUXNU3%type;
    ld_auxda1 JAQL635.D_AUXDA1%type;
    ld_auxda2 JAQL635.D_AUXDA2%type;
    ld_auxda3 JAQL635.D_AUXDA3%type;
  
  begin
    --//
    lc_coderr := '00000';
    lc_msgerr := '';
    --//
    ln_serenv := SQ_CV_LOGACF_TRAMASUNIBANCA.NEXTVAL;
    lc_canenv := lpad(to_char(pn_codcan), 10, '0');
    ld_fecenv := trunc(sysdate);
    lc_horenv := to_char(sysdate, 'HH24:mi:ss');
    lc_trmenv := pc_trmpar;
    lc_obsenv := pc_obstrm;
    lc_auxvc1 := '';
    lc_auxvc2 := '';
    lc_auxvc3 := '';
    ln_auxnu1 := 0;
    ln_auxnu2 := 0;
    ln_auxnu3 := 0;
    ld_auxda1 := null;
    ld_auxda2 := null;
    ld_auxda3 := null;
  
    insert into JAQL635
      (N_SERENV,
       C_CANENV,
       D_FECENV,
       C_HORENV,
       C_TRMENV,
       C_OBSENV,
       C_AUXVC1,
       C_AUXVC2,
       C_AUXVC3,
       N_AUXNU1,
       N_AUXNU2,
       N_AUXNU3,
       D_AUXDA1,
       D_AUXDA2,
       D_AUXDA3)
    values
      (ln_serenv,
       lc_canenv,
       ld_fecenv,
       lc_horenv,
       lc_trmenv,
       lc_obsenv,
       lc_auxvc1,
       lc_auxvc2,
       lc_auxvc3,
       ln_auxnu1,
       ln_auxnu2,
       ln_auxnu3,
       ld_auxda1,
       ld_auxda2,
       ld_auxda3);
  
    commit;
    --//
    pc_coderr := lc_coderr;
    pc_msgerr := lc_msgerr;
  exception
    when others then
      pc_coderr := sqlcode;
      pc_msgerr := sqlerrm;
  end sp_logTrama;

  procedure sp_debugErrorres(pn_codcan in char,
                             pc_trmpar in varchar2,
                             pc_obstrm in varchar2,
                             pc_coderr in varchar2,
                             pc_msgerr in varchar2) is
    --//
    ld_fecenv JAQL635A.D_FECENV%type;
    lc_horenv JAQL635A.C_HORENV%type;
  begin
    --//
    ld_fecenv := trunc(sysdate);
    lc_horenv := to_char(sysdate, 'HH24:mi:ss');
    --//
    insert into JAQL635A
      (C_CANENV,
       D_FECENV,
       C_HORENV,
       C_TRMENV,
       C_OBSENV,
       C_CODERR,
       C_MGSERR)
    values
      (pn_codcan,
       ld_fecenv,
       lc_horenv,
       pc_trmpar,
       pc_obstrm,
       pc_coderr,
       pc_msgerr);
    commit;
  exception
    when others then
      null;
  end sp_debugErrorres;

--//
end PQ_CV_MONITOREO_ACF_CC;
/

