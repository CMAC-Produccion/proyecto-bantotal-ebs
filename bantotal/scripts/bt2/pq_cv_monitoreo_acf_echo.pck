create or replace package PQ_CV_MONITOREO_ACF_ECHO is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_ATMS
  -- Sistema               : BANTOTAL
  -- Módulo                : CAJA AREQUIPA CAJEROS AUTOMATICOS
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/12/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA para el monitoreo de ATMs - ACF+
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Creación     : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --// Entrada Principal 
  procedure sp_construirTrama(pn_numtra in number,
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
  function fn_trama_indice011(pn_numtra in number) return varchar2;
  function fn_trama_indice012(pn_numtra in number) return varchar2;
  function fn_trama_indice013(pn_numtra in number) return varchar2;
  function fn_trama_indice014(pn_numtra in number) return varchar2;
  function fn_trama_indice015(pn_numtra in number) return varchar2;
  function fn_trama_indice016(pn_numtra in number) return varchar2;
  function fn_trama_indice017(pn_numtra in number) return varchar2;
  function fn_trama_indice018(pn_numtra in number) return varchar2;
  function fn_trama_indice019(pn_numtra in number) return varchar2;

  function fn_trama_indice020(pn_numtra in number) return varchar2;
  function fn_trama_indice021(pn_numtra in number) return varchar2;
  function fn_trama_indice022(pn_numtra in number) return varchar2;
  function fn_trama_indice023(pn_numtra in number) return varchar2;
  function fn_trama_indice024(pn_numtra in number) return varchar2;
  function fn_trama_indice025(pn_numtra in number) return varchar2;
  function fn_trama_indice026(pn_numtra in number) return varchar2;
  function fn_trama_indice027(pn_numtra in number) return varchar2;
  function fn_trama_indice028(pn_numtra in number) return varchar2;
  function fn_trama_indice029(pn_numtra in number) return varchar2;

  function fn_trama_indice030(pn_numtra in number) return varchar2;
  function fn_trama_indice031(pn_numtra in number) return varchar2;
  function fn_trama_indice032(pn_numtra in number) return varchar2;
  function fn_trama_indice033(pn_numtra in number) return varchar2;
  function fn_trama_indice034(pn_numtra in number) return varchar2;
  function fn_trama_indice035(pn_numtra in number) return varchar2;
  function fn_trama_indice036(pn_numtra in number) return varchar2;
  function fn_trama_indice037(pn_numtra in number) return varchar2;
  function fn_trama_indice038(pn_numtra in number) return varchar2;
  function fn_trama_indice039(pn_numtra in number) return varchar2;

  function fn_trama_indice040(pn_numtra in number) return varchar2;
  function fn_trama_indice041(pn_numtra in number) return varchar2;
  function fn_trama_indice042(pn_numtra in number) return varchar2;
  function fn_trama_indice043(pn_numtra in number) return varchar2;
  function fn_trama_indice044(pn_numtra in number) return varchar2;
  function fn_trama_indice045(pn_numtra in number) return varchar2;
  function fn_trama_indice046(pn_numtra in number) return varchar2;
  function fn_trama_indice047(pn_numtra in number) return varchar2;
  function fn_trama_indice048(pn_numtra in number) return varchar2;
  function fn_trama_indice049(pn_numtra in number) return varchar2;

  function fn_trama_indice050(pn_numtra in number) return varchar2;
  function fn_trama_indice051(pn_numtra in number) return varchar2;
  function fn_trama_indice052(pn_numtra in number) return varchar2;
  function fn_trama_indice053(pn_numtra in number) return varchar2;
  function fn_trama_indice054(pn_numtra in number) return varchar2;
  function fn_trama_indice055(pn_numtra in number) return varchar2;
  function fn_trama_indice056(pn_numtra in number) return varchar2;
  function fn_trama_indice057(pn_numtra in number) return varchar2;
  function fn_trama_indice058(pn_numtra in number) return varchar2;
  function fn_trama_indice059(pn_numtra in number) return varchar2;

  function fn_trama_indice060(pn_numtra in number) return varchar2;
  function fn_trama_indice061(pn_numtra in number) return varchar2;
  function fn_trama_indice062(pn_numtra in number) return varchar2;
  function fn_trama_indice063(pn_numtra in number) return varchar2;
  function fn_trama_indice064(pn_numtra in number) return varchar2;
  function fn_trama_indice065(pn_numtra in number) return varchar2;
  function fn_trama_indice066(pn_numtra in number) return varchar2;
  function fn_trama_indice067(pn_numtra in number) return varchar2;
  function fn_trama_indice068(pn_numtra in number) return varchar2;
  function fn_trama_indice069(pn_numtra in number) return varchar2;

  function fn_trama_indice070(pn_numtra in number) return varchar2;
  function fn_trama_indice071(pn_numtra in number) return varchar2;
  function fn_trama_indice072(pn_numtra in number) return varchar2;
  function fn_trama_indice073(pn_numtra in number) return varchar2;
  function fn_trama_indice074(pn_numtra in number) return varchar2;
  function fn_trama_indice075(pn_numtra in number) return varchar2;
  function fn_trama_indice076(pn_numtra in number) return varchar2;
  function fn_trama_indice077(pn_numtra in number) return varchar2;
  function fn_trama_indice078(pn_numtra in number) return varchar2;
  function fn_trama_indice079(pn_numtra in number) return varchar2;

  function fn_trama_indice080(pn_numtra in number) return varchar2;
  function fn_trama_indice081(pn_numtra in number) return varchar2;
  function fn_trama_indice082(pn_numtra in number) return varchar2;
  function fn_trama_indice083(pn_numtra in number) return varchar2;
  function fn_trama_indice084(pn_numtra in number) return varchar2;
  function fn_trama_indice085(pn_numtra in number) return varchar2;
  function fn_trama_indice086(pn_numtra in number) return varchar2;
  function fn_trama_indice087(pn_numtra in number) return varchar2;
  function fn_trama_indice088(pn_numtra in number) return varchar2;
  function fn_trama_indice089(pn_numtra in number) return varchar2;

  function fn_trama_indice090(pn_numtra in number) return varchar2;
  function fn_trama_indice091(pn_numtra in number) return varchar2;

end PQ_CV_MONITOREO_ACF_ECHO;
/

create or replace package body PQ_CV_MONITOREO_ACF_ECHO is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CV_MONITOREO_ACF_ATMS
  -- Sistema               : BANTOTAL
  -- Módulo                : CAJA AREQUIPA CAJEROS AUTOMATICOS
  -- Versión               : 1.0
  -- Fecha de Creación     : 12/12/2018
  -- Autor de Creación     : JPINTO
  -- Uso                   : Construccion de la trama a enviar a UNIBANCA ECHO - ACF+
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 
  -- Autor de Creación     : 
  -- Descripción Modific.  : 
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------

  --//
  procedure sp_construirTrama(pn_numtra in number,
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
       where acf.n_indice > 1000
       order by acf.n_indice;
  begin
    pc_coderr := '00000';
    pc_msgerr := '';
    --//
    for i in c1 loop
      --//
      case i.n_indice
        when 1001 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := rpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lpad(STR1 => fn_trama_indice001, LEN => i.n_longit,
                              PAD => i.c_jusnum);
          end if;
        when 1002 then
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
        when 1003 then
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
        when 1004 then
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
        when 1005 then
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
        when 1006 then
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
        when 1007 then
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
        when 1008 then
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
        when 1009 then
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
        when 1010 then
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
        
        when 1011 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice011(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice011(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1012 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice012(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice012(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1013 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice013(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice013(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1014 then
          --R        
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice014(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice014(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1015 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice015(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice015(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1016 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice016(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice016(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1017 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice017(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice017(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1018 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice018(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice018(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1019 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice019(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice019(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1020 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice020(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice020(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1021 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice021(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice021(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1022 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice022(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice022(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1023 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice023(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice023(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1024 then
          --R
          --//
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice024(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice024(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1025 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice025(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice025(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1026 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice026(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice026(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1027 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice027(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice027(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1028 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice028(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice028(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1029 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice029(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice029(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1030 then
          --I
          --//
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice030(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice030(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1031 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice031(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice031(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1032 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice032(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice032(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1033 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice033(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1034 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice034(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice034(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1035 then
          --R
          --//          
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice035(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice035(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1036 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice036(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice036(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1037 then
          --I
          --//          
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice037(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice037(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1038 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice038(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice038(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1039 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice039(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice039(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1040 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice040(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice040(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1041 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice041(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice041(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1042 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice042(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice042(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1043 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice043(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice043(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1044 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice044(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice044(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1045 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice045(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice045(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1046 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice046(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice046(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1047 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice047(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice047(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1048 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice048(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice048(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1049 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice049(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice049(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1050 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice050(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice050(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1051 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice051(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice051(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1052 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice052(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice052(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1053 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice053(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice053(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1054 then
          --I
          --// aqui esta el problema 
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice054(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice054(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1055 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice055(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice055(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1056 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice056(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice056(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1057 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice057(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice057(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1058 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice058(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice058(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1059 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice059(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice059(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1060 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice060(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice060(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1061 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice061(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice061(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1062 then
          --I
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice062(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice062(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1063 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice063(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice063(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1064 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice064(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice064(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1065 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice065(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice065(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1066 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice066(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice066(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1067 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice067(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice067(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1068 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice068(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice068(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1069 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice069(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice069(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1070 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice070(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice070(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1071 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice071(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice071(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1072 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice072(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice072(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1073 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice073(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice073(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1074 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice074(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice074(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1075 then
          --S
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice075(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice075(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1076 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice076(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice076(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1077 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice077(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice077(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1078 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice078(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice078(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1079 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice079(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice079(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1080 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice080(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice080(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        
        when 1081 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice081(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice081(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1082 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice082(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice082(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1083 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice083(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice083(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1084 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice084(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice084(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1085 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice085(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice085(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1086 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice086(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice086(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1087 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice087(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice087(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1088 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice088(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice088(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1089 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice089(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice089(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1090 then
          --I
          --//                  
          if i.c_import = 'I' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice090(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'I' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice090(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_jusnum);
          end if;
        when 1091 then
          --R
          --//                  
          if i.c_import = 'R' and i.c_tipdat = 'A' then
            lc_trmrsp := lc_trmrsp ||
                         rpad(STR1 => fn_trama_indice091(pn_numtra),
                              LEN => i.n_longit, PAD => i.c_justxt);
          elsif i.c_import = 'R' and i.c_tipdat = 'N' then
            lc_trmrsp := lc_trmrsp ||
                         lpad(STR1 => fn_trama_indice091(pn_numtra),
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
  
    lc_cmp010 := '7940';
    return lc_cmp010;
  exception
    when others then
      return '00000';
  end fn_trama_indice010;

  --// R
  function fn_trama_indice011(pn_numtra in number) return varchar2 is
    lc_cmp011 varchar2(100) := '';
  begin
    --//
    lc_cmp011 := '4261530000000000';
    return lc_cmp011;
  exception
    when others then
      return ' ';
  end fn_trama_indice011;

  --// R
  function fn_trama_indice012(pn_numtra in number) return varchar2 is
    lc_cmp012 varchar2(100);
  begin
    --//
    select a1.jaql539valtr
      into lc_cmp012
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 3;
    return lc_cmp012;
  exception
    when others then
      return '0';
  end fn_trama_indice012;

  --// S
  function fn_trama_indice013(pn_numtra in number) return varchar2 is
    lc_cmp013 varchar2(100);
  begin
    --//
    select SUBSTR(a1.jaql539valtr, 3, 4)
      into lc_cmp013
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 3;
    return lc_cmp013;
  exception
    when others then
      return '0';
  end fn_trama_indice013;

  --// R 
  function fn_trama_indice014(pn_numtra in number) return varchar2 is
    lc_cmp014 varchar2(100);
  begin
    --//
    lc_cmp014 := 'N';
    return lc_cmp014;
  exception
    when others then
      return ' ';
  end fn_trama_indice014;

  --// R
  function fn_trama_indice015(pn_numtra in number) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp015 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
  begin
    --//
    select b1.jaql540feini
      into ld_fectra
      from jaql540 b1
     where b1.jaql540cotra = pn_numtra;
    --//  
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --//    
    select to_number(a1.jaql539valtr) / 100, a1.jaql539valtr
      into ln_aux004, lc_aux004
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 4;
    --//
    select to_number(a1.jaql539valtr)
      into ln_codmda
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 49;
  
    if ln_codmda = 604 then
      ln_conver := ln_aux004 / ln_tipcam;
      lc_cmp015 := lpad(trim(replace(to_char(ln_conver), ',', '')), 14, '0');
    else
      lc_cmp015 := lc_aux004;
    end if;
    --//               
    return lc_cmp015;
  exception
    when others then
      return '0';
  end fn_trama_indice015;

  --// R
  function fn_trama_indice016(pn_numtra in number) return varchar2 is
    lc_cmp016 varchar2(100);
  begin
    --//
    select a1.jaql539valtr
      into lc_cmp016
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 4;
    return lc_cmp016;
  exception
    when others then
      return '0';
  end fn_trama_indice016;

  --// R
  function fn_trama_indice017(pn_numtra in number) return varchar2 is
    lc_aux004 varchar2(100);
    ln_aux004 number := 0;
    ln_conver number(14, 2) := 0.0;
    lc_cmp017 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
    ln_codmda number;
  begin
    --//
    select b1.jaql540feini
      into ld_fectra
      from jaql540 b1
     where b1.jaql540cotra = pn_numtra;
    --//  
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
    --//    
    select to_number(a1.jaql539valtr) / 100, a1.jaql539valtr
      into ln_aux004, lc_aux004
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 4;
    --//
    select to_number(a1.jaql539valtr)
      into ln_codmda
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 49;
  
    if ln_codmda = 604 then
      ln_conver := ln_aux004 / ln_tipcam;
      lc_cmp017 := lpad(trim(replace(to_char(ln_conver), ',', '')), 14, '0');
    else
      lc_cmp017 := lc_aux004;
    end if;
    --//               
    return lc_cmp017;
  exception
    when others then
      return '00000';
  end fn_trama_indice017;

  --// R
  function fn_trama_indice018(pn_numtra in number) return varchar2 is
    lc_cmp018 varchar2(100);
    ld_fecaut varchar2(10); -- Fecha del HOST AUTORIZADOR
    lc_horaut varchar2(10); -- Hora del HOST AUTORIZADOR
  begin
    --//
    select to_char(sysdate, 'HH24miss'),
           to_char(trunc(sysdate), 'yyyymmdd')
      into lc_horaut, ld_fecaut
      from dual;
    --//
    lc_cmp018 := trim(ld_fecaut) || trim(lc_horaut);
    return lc_cmp018;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      return '0';
  end fn_trama_indice018;

  --// R
  function fn_trama_indice019(pn_numtra in number) return varchar2 is
    lc_cmp019 varchar2(100);
    ln_tipcam number := 0;
    ld_fectra date;
  begin
    --//
    select b1.jaql540feini
      into ld_fectra
      from jaql540 b1
     where b1.jaql540cotra = pn_numtra;
    --//  
    sp_tipo_cambio(FECHA => ld_fectra, monori => 0, mondes => 101,
                   tipo => 500, tc => ln_tipcam);
  
    lc_cmp019 := lpad(replace(to_char(ln_tipcam), ',', ''), 11, '0');
    return lc_cmp019;
  exception
    when others then
      return '00000';
  end fn_trama_indice019;

  --// R
  function fn_trama_indice020(pn_numtra in number) return varchar2 is
    lc_cmp020 varchar2(100);
  begin
    --//
    lc_cmp020 := '0';
    return lc_cmp020;
  exception
    when others then
      return '00000';
  end fn_trama_indice020;

  --// R
  function fn_trama_indice021(pn_numtra in number) return varchar2 is
    lc_cmp021 varchar2(100);
  begin
    --//
    select to_char(sysdate, 'HH24miss') into lc_cmp021 from dual a1;
    return lc_cmp021;
  exception
    when others then
      return '00000';
  end fn_trama_indice021;

  --// R
  function fn_trama_indice022(pn_numtra in number) return varchar2 is
    lc_cmp022 varchar2(100);
  begin
    --//
    select to_char(trunc(sysdate), 'yyyymmdd') into lc_cmp022 from dual a1;
    return lc_cmp022;
  exception
    when others then
      return '00000';
  end fn_trama_indice022;

  --// I
  function fn_trama_indice023(pn_numtra in number) return varchar2 is
    lc_cmp023 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --// 
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
    --//      
    return lc_cmp023;
  exception
    when others then
      return '0';
  end fn_trama_indice023;

  --// R
  function fn_trama_indice024(pn_numtra in number) return varchar2 is
    lc_cmp024 varchar2(100);
  begin
    --//
    lc_cmp024 := 'O';
    return lc_cmp024;
  exception
    when others then
      return ' ';
  end fn_trama_indice024;

  --// I
  function fn_trama_indice025(pn_numtra in number) return varchar2 is
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
      return '0';
  end fn_trama_indice025;

  --// I
  function fn_trama_indice026(pn_numtra in number) return varchar2 is
    lc_cmp026 varchar2(100);
  begin
    --//
    select a1.jaql539valtr
      into lc_cmp026
      from jaql539 a1
     where a1.jaql539cotra = pn_numtra
       and a1.jaql539nucam = 18;
    return lc_cmp026;
  exception
    when others then
      return '0';
  end fn_trama_indice026;

  --// I
  function fn_trama_indice027(pn_numtra in number) return varchar2 is
    lc_cmp027 varchar2(100) := '0';
  begin
    --//
    return lc_cmp027;
  exception
    when others then
      return '0';
  end fn_trama_indice027;

  --// I
  function fn_trama_indice028(pn_numtra in number) return varchar2 is
    lc_cmp028 varchar2(100) := '0';
  begin
    --//
    return lc_cmp028;
  exception
    when others then
      return '0';
  end fn_trama_indice028;

  --// I
  function fn_trama_indice029(pn_numtra in number) return varchar2 is
    lc_cmp029 varchar2(100) := '0';
  begin
    --//
    return lc_cmp029;
  exception
    when others then
      return '0';
  end fn_trama_indice029;

  --// I
  function fn_trama_indice030(pn_numtra in number) return varchar2 is
    lc_cmp030 varchar2(100);
    lc_tracet varchar2(100);
    ld_fectra date;
  begin
    --//
    lc_cmp030 := ' ';
    --//      
    return lc_cmp030;
  exception
    when others then
      return ' ';
  end fn_trama_indice030;

  --// I
  function fn_trama_indice031(pn_numtra in number) return varchar2 is
    lc_cmp031 varchar2(100) := ' ';
  begin
    lc_cmp031 := ' ';
    --//
    return lc_cmp031;
  exception
    when others then
      return ' ';
  end fn_trama_indice031;

  --// I
  function fn_trama_indice032(pn_numtra in number) return varchar2 is
    lc_cmp032 varchar2(100) := '0';
  begin
    --//
    lc_cmp032 := '0';
    return lc_cmp032;
  exception
    when others then
      return '0';
  end fn_trama_indice032;

  --// I
  function fn_trama_indice033(pn_numtra in number) return varchar2 is
    lc_cmp033 varchar2(100);
  begin
    --//
    lc_cmp033 := '0';
    return lc_cmp033;
  exception
    when others then
      return '0';
  end fn_trama_indice033;

  --// I
  function fn_trama_indice034(pn_numtra in number) return varchar2 is
    lc_cmp034 varchar2(100) := '0';
  begin
    --//
    lc_cmp034 := '0';
    return lc_cmp034;
  exception
    when others then
      return '0';
  end fn_trama_indice034;

  --// R
  function fn_trama_indice035(pn_numtra in number) return varchar2 is
    lc_cmp035 varchar2(100) := '0';
  begin
    --//
    lc_cmp035 := '426153';
    return lc_cmp035;
  exception
    when others then
      return '0';
  end fn_trama_indice035;

  --// I
  function fn_trama_indice036(pn_numtra in number) return varchar2 is
    lc_cmp036 varchar2(100) := ' ';
  begin
    --//
    lc_cmp036 := ' ';
    return lc_cmp036;
  exception
    when others then
      return ' ';
  end fn_trama_indice036;

  --// I
  function fn_trama_indice037(pn_numtra in number) return varchar2 is
    lc_cmp037 varchar2(100) := ' ';
  begin
    --//
    lc_cmp037 := ' ';
    return lc_cmp037;
  exception
    when others then
      lc_cmp037 := ' ';
      return lc_cmp037;
  end fn_trama_indice037;

  --// I
  function fn_trama_indice038(pn_numtra in number) return varchar2 is
    lc_cmp038 varchar2(100) := ' ';
  begin
    --//
    lc_cmp038 := ' ';
    return lc_cmp038;
  exception
    when others then
      return lc_cmp038;
  end fn_trama_indice038;

  --// I
  function fn_trama_indice039(pn_numtra in number) return varchar2 is
    lc_cmp039 varchar2(100) := '0';
  begin
    --//    
    lc_cmp039 := '0';
    return lc_cmp039;
  exception
    when others then
      return lc_cmp039;
  end fn_trama_indice039;

  --// I
  function fn_trama_indice040(pn_numtra in number) return varchar2 is
    lc_cmp040 varchar2(100) := ' ';
  begin
    --//    
    lc_cmp040 := ' ';
    return lc_cmp040;
  exception
    when others then
      return lc_cmp040;
  end fn_trama_indice040;

  --// I
  function fn_trama_indice041(pn_numtra in number) return varchar2 is
    lc_cmp041 varchar2(100) := ' ';
  begin
    --//    
    lc_cmp041 := ' ';
    return lc_cmp041;
  exception
    when others then
      return lc_cmp041;
  end fn_trama_indice041;

  --// I
  function fn_trama_indice042(pn_numtra in number) return varchar2 is
    lc_cmp042 varchar2(100) := ' ';
  begin
    --//
    lc_cmp042 := ' ';
    return lc_cmp042;
  exception
    when others then
      return lc_cmp042;
  end fn_trama_indice042;

  --// I
  function fn_trama_indice043(pn_numtra in number) return varchar2 is
    lc_cmp043 varchar2(100) := ' ';
  begin
    --//
    lc_cmp043 := ' ';
    return lc_cmp043;
  exception
    when others then
      return lc_cmp043;
  end fn_trama_indice043;

  --// R
  function fn_trama_indice044(pn_numtra in number) return varchar2 is
    lc_cmp044 varchar2(100) := '';
  begin
    --//
    lc_cmp044 := 'PE';
    return lc_cmp044;
  exception
    when others then
      return lc_cmp044;
  end fn_trama_indice044;

  --// I
  function fn_trama_indice045(pn_numtra in number) return varchar2 is
    lc_cmp045 varchar2(100) := '0';
  begin
    --// Unibanca indico que no van ceros sino espacios en blanco 
    lc_cmp045 := ' ';
    return lc_cmp045;
  exception
    when others then
      return lc_cmp045;
  end fn_trama_indice045;

  --// I
  function fn_trama_indice046(pn_numtra in number) return varchar2 is
    lc_cmp046 varchar2(100) := ' ';
  begin
    lc_cmp046 := ' ';
    return lc_cmp046;
  exception
    when others then
      return lc_cmp046;
  end fn_trama_indice046;

  --// I
  function fn_trama_indice047(pn_numtra in number) return varchar2 is
    lc_cmp047 varchar2(100) := ' ';
  begin
    lc_cmp047 := ' ';
    return lc_cmp047;
  exception
    when others then
      return lc_cmp047;
  end fn_trama_indice047;

  --// I
  function fn_trama_indice048(pn_numtra in number) return varchar2 is
    lc_cmp048 varchar2(100) := '0';
  begin
    --//    
    lc_cmp048 := '0';
    return lc_cmp048;
  exception
    when others then
      return lc_cmp048;
  end fn_trama_indice048;

  --// I
  function fn_trama_indice049(pn_numtra in number) return varchar2 is
    lc_cmp049 varchar2(100) := '0';
  begin
    lc_cmp049 := '0';
    return lc_cmp049;
  exception
    when others then
      return lc_cmp049;
  end fn_trama_indice049;

  --// I
  function fn_trama_indice050(pn_numtra in number) return varchar2 is
    lc_cmp050 varchar2(100) := '0';
  begin
    --//        
    lc_cmp050 := '0';
    return lc_cmp050;
  exception
    when others then
      return lc_cmp050;
  end fn_trama_indice050;

  --// I
  function fn_trama_indice051(pn_numtra in number) return varchar2 is
    lc_cmp051 varchar2(100) := ' ';
  begin
    --//
    lc_cmp051 := ' ';
    return lc_cmp051;
  exception
    when others then
      return lc_cmp051;
  end fn_trama_indice051;

  --// I
  function fn_trama_indice052(pn_numtra in number) return varchar2 is
    lc_cmp052 varchar2(100) := '0';
  begin
    --//        
    lc_cmp052 := '0';
    return lc_cmp052;
  exception
    when others then
      return lc_cmp052;
  end fn_trama_indice052;

  --// I
  function fn_trama_indice053(pn_numtra in number) return varchar2 is
    lc_cmp053 varchar2(100) := ' ';
  begin
    lc_cmp053 := ' ';
    return lc_cmp053;
  exception
    when others then
      return lc_cmp053;
  end fn_trama_indice053;

  --// I
  function fn_trama_indice054(pn_numtra in number) return varchar2 is
    lc_cmp054 varchar2(100) := ' ';
  begin
    lc_cmp054 := ' ';
    return lc_cmp054;
  exception
    when others then
      return lc_cmp054;
  end fn_trama_indice054;

  --// I
  function fn_trama_indice055(pn_numtra in number) return varchar2 is
    lc_cmp055 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp055 := ' ';
    return lc_cmp055;
  exception
    when others then
      return lc_cmp055;
  end fn_trama_indice055;

  --// R
  function fn_trama_indice056(pn_numtra in number) return varchar2 is
    lc_cmp056 varchar2(100) := ' ';
  begin
    lc_cmp056 := '426153';
    return lc_cmp056;
  exception
    when others then
      return lc_cmp056;
  end fn_trama_indice056;

  --// I
  function fn_trama_indice057(pn_numtra in number) return varchar2 is
    lc_cmp057 varchar2(100) := ' ';
  begin
    lc_cmp057 := ' ';
    return lc_cmp057;
  exception
    when others then
      return lc_cmp057;
  end fn_trama_indice057;

  --// I
  function fn_trama_indice058(pn_numtra in number) return varchar2 is
    lc_cmp058 varchar2(100) := ' ';
  begin
    lc_cmp058 := ' ';
    return lc_cmp058;
  exception
    when others then
      lc_cmp058 := ' ';
      return lc_cmp058;
  end fn_trama_indice058;

  --// I
  function fn_trama_indice059(pn_numtra in number) return varchar2 is
    lc_cmp059 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp059 := ' ';
    return lc_cmp059;
  exception
    when others then
      return lc_cmp059;
  end fn_trama_indice059;

  --// I
  function fn_trama_indice060(pn_numtra in number) return varchar2 is
    lc_cmp060 varchar2(100) := '0';
  begin
    --//        
    lc_cmp060 := '0';
    return lc_cmp060;
  exception
    when others then
      return lc_cmp060;
  end fn_trama_indice060;

  --// I
  function fn_trama_indice061(pn_numtra in number) return varchar2 is
    lc_cmp061 varchar2(100) := '0';
  begin
    lc_cmp061 := '0';
    return lc_cmp061;
  exception
    when others then
      return lc_cmp061;
  end fn_trama_indice061;

  --// I
  function fn_trama_indice062(pn_numtra in number) return varchar2 is
    lc_cmp062 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp062 := ' ';
    return lc_cmp062;
  exception
    when others then
      return lc_cmp062;
  end fn_trama_indice062;

  --// I
  function fn_trama_indice063(pn_numtra in number) return varchar2 is
    lc_cmp063 varchar2(100) := ' ';
  begin
    lc_cmp063 := ' ';
    return lc_cmp063;
  exception
    when others then
      return lc_cmp063;
  end fn_trama_indice063;

  --// I
  function fn_trama_indice064(pn_numtra in number) return varchar2 is
    lc_cmp064 varchar2(100) := ' ';
  begin
    lc_cmp064 := ' ';
    return lc_cmp064;
  exception
    when others then
      return lc_cmp064;
  end fn_trama_indice064;

  --// I
  function fn_trama_indice065(pn_numtra in number) return varchar2 is
    lc_cmp065 varchar2(100) := ' ';
  begin
    lc_cmp065 := ' ';
    return lc_cmp065;
  exception
    when others then
      return lc_cmp065;
  end fn_trama_indice065;

  --// I
  function fn_trama_indice066(pn_numtra in number) return varchar2 is
    lc_cmp066 varchar2(100) := ' ';
  begin
    lc_cmp066 := ' ';
    return lc_cmp066;
  exception
    when others then
      return lc_cmp066;
  end fn_trama_indice066;

  --// I
  function fn_trama_indice067(pn_numtra in number) return varchar2 is
    lc_cmp067 varchar2(100) := ' ';
  begin
    lc_cmp067 := ' ';
    return lc_cmp067;
  exception
    when others then
      return lc_cmp067;
  end fn_trama_indice067;

  --// I
  function fn_trama_indice068(pn_numtra in number) return varchar2 is
    lc_cmp068 varchar2(100) := '';
  begin
    lc_cmp068 := ' ';
    return lc_cmp068;
  exception
    when others then
      lc_cmp068 := ' ';
      return lc_cmp068;
  end fn_trama_indice068;

  --// I
  function fn_trama_indice069(pn_numtra in number) return varchar2 is
    lc_cmp069 varchar2(100) := '0';
  begin
    lc_cmp069 := '0';
    return lc_cmp069;
  exception
    when others then
      return lc_cmp069;
  end fn_trama_indice069;

  --// I
  function fn_trama_indice070(pn_numtra in number) return varchar2 is
    lc_cmp070 varchar2(100) := ' ';
  begin
    lc_cmp070 := ' ';
    return lc_cmp070;
  exception
    when others then
      return lc_cmp070;
  end fn_trama_indice070;

  --// I
  function fn_trama_indice071(pn_numtra in number) return varchar2 is
    lc_cmp071 varchar2(100) := ' ';
  begin
    lc_cmp071 := ' ';
    return lc_cmp071;
  exception
    when others then
      return lc_cmp071;
  end fn_trama_indice071;

  --// I
  function fn_trama_indice072(pn_numtra in number) return varchar2 is
    lc_cmp072 varchar2(100) := ' ';
  begin
    lc_cmp072 := ' ';
    return lc_cmp072;
  exception
    when others then
      return lc_cmp072;
  end fn_trama_indice072;

  --// I
  function fn_trama_indice073(pn_numtra in number) return varchar2 is
    lc_cmp073 varchar2(100) := '0';
  begin
    lc_cmp073 := '0';
    return lc_cmp073;
  exception
    when others then
      return lc_cmp073;
  end fn_trama_indice073;

  --// I
  function fn_trama_indice074(pn_numtra in number) return varchar2 is
    lc_cmp074 varchar2(100) := '0';
  begin
    lc_cmp074 := '0';
    return lc_cmp074;
  exception
    when others then
      return lc_cmp074;
  end fn_trama_indice074;

  --// I
  function fn_trama_indice075(pn_numtra in number) return varchar2 is
    lc_cmp075 varchar2(100) := '0';
  begin
    lc_cmp075 := '0';
    return lc_cmp075;
  exception
    when others then
      return lc_cmp075;
  end fn_trama_indice075;

  --// R
  function fn_trama_indice076(pn_numtra in number) return varchar2 is
    lc_cmp076 varchar2(100) := ' ';
  begin
    lc_cmp076 := '4261530000000000';
    return lc_cmp076;
  exception
    when others then
      return lc_cmp076;
  end fn_trama_indice076;

  --// I
  function fn_trama_indice077(pn_numtra in number) return varchar2 is
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
  function fn_trama_indice078(pn_numtra in number) return varchar2 is
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
  function fn_trama_indice079(pn_numtra in number) return varchar2 is
    lc_cmp079 varchar2(100) := ' ';
  begin
    --//        
    lc_cmp079 := ' ';
    return lc_cmp079;
  exception
    when others then
      return lc_cmp079;
  end fn_trama_indice079;

  --// I
  function fn_trama_indice080(pn_numtra in number) return varchar2 is
    lc_cmp080 varchar2(100) := ' ';
  begin
    lc_cmp080 := ' ';
    return lc_cmp080;
  exception
    when others then
      return lc_cmp080;
  end fn_trama_indice080;

  --// I
  function fn_trama_indice081(pn_numtra in number) return varchar2 is
    lc_cmp081 varchar2(100) := '';
  begin
    --//        
    lc_cmp081 := ' ';
    return lc_cmp081;
  exception
    when others then
      return lc_cmp081;
  end fn_trama_indice081;

  --// R
  function fn_trama_indice082(pn_numtra in number) return varchar2 is
    lc_cmp082 varchar2(100) := '';
  begin
    --//        
    lc_cmp082 := '1';
    return lc_cmp082;
  exception
    when others then
      return lc_cmp082;
  end fn_trama_indice082;

  --// I
  function fn_trama_indice083(pn_numtra in number) return varchar2 is
    lc_cmp083 varchar2(100) := '';
  begin
    --//        
    lc_cmp083 := '0';
    return lc_cmp083;
  exception
    when others then
      return lc_cmp083;
  end fn_trama_indice083;

  --// I
  function fn_trama_indice084(pn_numtra in number) return varchar2 is
    lc_cmp084 varchar2(100) := '';
  begin
    --//        
    lc_cmp084 := '0';
    return lc_cmp084;
  exception
    when others then
      return lc_cmp084;
  end fn_trama_indice084;

  --// I
  function fn_trama_indice085(pn_numtra in number) return varchar2 is
    lc_cmp085 varchar2(100) := '';
  begin
    --//        
    lc_cmp085 := ' ';
    return lc_cmp085;
  exception
    when others then
      return lc_cmp085;
  end fn_trama_indice085;

  --// I
  function fn_trama_indice086(pn_numtra in number) return varchar2 is
    lc_cmp086 varchar2(100) := '';
  begin
    --//        
    lc_cmp086 := ' ';
    return lc_cmp086;
  exception
    when others then
      return lc_cmp086;
  end fn_trama_indice086;

  --// I
  function fn_trama_indice087(pn_numtra in number) return varchar2 is
    lc_cmp087 varchar2(100) := '';
  begin
    --//        
    lc_cmp087 := '0';
    return lc_cmp087;
  exception
    when others then
      return lc_cmp087;
  end fn_trama_indice087;

  --// I
  function fn_trama_indice088(pn_numtra in number) return varchar2 is
    lc_cmp088 varchar2(100) := '';
  begin
    --//        
    lc_cmp088 := ' ';
    return lc_cmp088;
  exception
    when others then
      return lc_cmp088;
  end fn_trama_indice088;

  --// I
  function fn_trama_indice089(pn_numtra in number) return varchar2 is
    lc_cmp089 varchar2(100) := '';
  begin
    --//        
    lc_cmp089 := '0';
    return lc_cmp089;
  exception
    when others then
      return lc_cmp089;
  end fn_trama_indice089;

  --// I
  function fn_trama_indice090(pn_numtra in number) return varchar2 is
    lc_cmp090 varchar2(100) := '';
  begin
    --//        
    lc_cmp090 := ' ';
    return lc_cmp090;
  exception
    when others then
      return lc_cmp090;
  end fn_trama_indice090;

  --// R
  function fn_trama_indice091(pn_numtra in number) return varchar2 is
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
       where acf.n_indice > 1000
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
                           lpad(trim(to_char(i.n_indice)), 4, '0') ||
                           '], IMPORTANCIA [' || i.c_import ||
                           '], LONGITUD [' ||
                           lpad(trim(to_char(i.n_longit)), 2, '0') || ']' ||
                           ', VALOR : [' || lc_trmpar || ']');
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
end PQ_CV_MONITOREO_ACF_ECHO;
/

