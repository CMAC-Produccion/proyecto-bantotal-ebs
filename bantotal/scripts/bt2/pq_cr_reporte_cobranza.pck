create or replace package pq_cr_reporte_cobranza is
    -- *****************************************************************
    -- Nombre                     : pq_cr_reporte_cobranza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/12/2015 08:54:43 a.m.
    -- Autor de Creación          : MPOSTIGOC
    -- Uso                        : CARGA INFORMACION PARA REPORTE DE COBRANZA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      
  procedure sp_cr_cargadatos;
  ------------------------------------------
  procedure sp_atraso_maximo(pn_ppmod  in number,
                             pn_ppsuc  in number,
                             pn_ppmda  in number,
                             pn_pppap  in number,
                             pn_ppcta  in number,
                             pn_ppoper in number,
                             pd_fecha  in date,
                             atra_max  out number);

  -------------------------------------------
  procedure sp_direc_titular(pais          in number,
                             tipo          in number,
                             documento     in character,
                             direc_negocio out varchar2,
                             dist_negocio  out varchar2,
                             direc_gestion out varchar2,
                             dist_gestion  out varchar2,
                             ref_gestion   out varchar2,
                             tlfn_gestion  out varchar2);
  ---------------------------------------
  PROCEDURE sp_cr_actividad(pais      in number,
                            tipo      in number,
                            documento in character,
                            actividad out varchar2);
  ------------------------------------------------------                            
  procedure sp_avales(instancia  in number,
                      nro_avales out number,
                      aval       out varchar2,
                      direc_aval out varchar2,
                      ref_aval   out varchar2,
                      dist_aval  out varchar2);
  ------------------------------------
  procedure sp_entidades(documento in character, entidades out number);
  ----------------------------------------------------
  procedure sp_cuota_impaga(pn_ppmod  in number,
                            pn_ppsuc  in number,
                            pn_ppmda  in number,
                            pn_pppap  in number,
                            pn_ppcta  in number,
                            pn_ppoper in number,
                            pn_soboper in number,
                            pn_tope in number,
                            cuoimp  out number );
  -------------------------------------------------------
  procedure sp_fecha_ultpago(pn_PGCOD      in number,
                             pn_ppmod      in number,
                             pn_ppsuc      in number,
                             pn_ppmda      in number,
                             pn_pppap      in number,
                             pn_ppcta      in number,
                             pn_ppoper     in number,
                             fecha_ultpago out date);

  --------------------------------------------------------------------
  procedure sp_cuotas_pagadas(pn_PGCOD       in number,
                              pn_ppmod       in number,
                              pn_ppsuc       in number,
                              pn_ppmda       in number,
                              pn_pppap       in number,
                              pn_ppcta       in number,
                              pn_ppoper      in number,
                              cuotas_pagadas out number);
  ------------------------------------------------------------------
  procedure sp_nro_credvig(pais        in number,
                           tipo        in number,
                           documento   in character,
                           nro_credvig out number);
  ------------------------------------------------------------------
  procedure sp_ultreaccion(cuenta      in number,
                           operacion   in number,
                           fech_ultrea out date,
                           ultreacc    out varchar2,
                           usuario     out character);
  -----------------------------------------------------------------
    procedure sp_cr_updatejaqy139(instancia      in number,
                                pais           in number,
                                tipo           in number,
                                documento      in character,
                                pn_ppsuc       in number,
                                pn_ppcta       in number,
                                pn_ppoper      in number,
                                pn_ppmda       in number,
                                pn_ppmod       in number,
                                atra_max       in number,
                                direc_negocio  in varchar2,
                                dist_negocio   in varchar2,
                                direc_gestion  in varchar2,
                                dist_gestion   in varchar2,
                                ref_gestion    in varchar2,
                                tlfn_gestion   in varchar2,
                                actividad      in varchar,
                                nro_avales     in number,
                                aval           in varchar2,
                                direc_aval     in varchar2,
                                ref_aval       in varchar2,
                                dist_aval      in varchar2,
                                entidades      in number,
                                cuoimp         in number,
                                cuotas_pagadas in number,
                                fecha_ultpago  in date,
                                nro_credvig    in number,
                                fech_ultrea    in date,
                                ultreacc       in VARCHAR2,
                                usuario        in Character                       
                                );                         
  -----------------------------------------------------------------
  procedure sp_cr_cargatotal(P_N_INI in NUMBER, P_N_FIN in NUMBER);
  -------------------------------------------------------------------
  procedure sp_cr_job_carga;
  ------------------------------------------------------------------

end pq_cr_reporte_cobranza;
/

create or replace package body pq_cr_reporte_cobranza is
    -- *****************************************************************
    -- Nombre                     : pq_cr_reporte_cobranza
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 29/12/2015 08:54:43 a.m.
    -- Autor de Creación          : MPOSTIGOC
    -- Uso                        : CARGA INFORMACION PARA REPORTE DE COBRANZA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --                            : 
    -- *****************************************************************
      

  -- *****************************************************************
  
  procedure sp_cr_cargadatos is
  -- 2017.06.16 Se agrego campos JAQY139ICV ,JAQY139PEN para penalidad
  -- 2017.07 Se agrego campos BMS
  -- 2017.08.14 se agrego campos BFH
  
  
    cursor inserta is
    
      select JAQl964mod MODULO,
             jaql964suc AGENCIA,
             jaql964nom NOMSUC,
             jaql964mda MONEDA,
             JAQL964PAP PAPEL,
             jaql964cta CUENTA,
             jaql964ope CREDITO,
             j.Jaql964sob SUBOPER,
             j.Jaql964top TIPOER,
             jaql964tit TITULAR,
             jaql964dir DIR_TITU,
             J.JAQL964RED REF_DIR,
             J.JAQL964DIS DIS_DIR,
             jaql964usu ANALISTA,
             jaql964tcc TIPO_CONTABLE,
             jaql964pro TIPO_CREDITO,
             jaql964sao SALDO_CAPITAL,
             jaql964sac * -1 SALDO_CONSOLIDADO,
             jaql964mor Mora,
             j.jaql964dia dias_atraso,
             j.jaql964tel telefono,
             j.jaql964doc documento,
             j.jaql964pai Pais,
             j.jaql964tid tipodoc,
             j.jaql964ins instancia,
             J.Jaql964tcc estado,
             j.jaql964fec FECPROC,
             j.jaql964icv ICV,  -- 2017.06.16
			       j.jaql964pen PENALIDAD,
             j.jaql964sbbp SALDO_BBP,
             j.jaql964ibbp INTERES_BBP,
             j.jaql964spbp SALDO_PBP,
             j.jaql964ipbp INTERES_PBP,
             j.jaql964sbms SALDO_BMS,
             j.jaql964ibms INTERES_BMS,
             j.jaql964sbfh SALDO_BFH, --2019.08.14
             j.jaql964ibfh INTERES_BFH
                          
        from jaql964 j
       where jaql964dia >= 1
         and jaql964est in (0, 61, 21, 22,34)
         and jaql964mod <> 108;
  
    ln_corr number := 1;
  begin
    execute immediate ('truncate table jaqy139');
    COMMIT;
  
    for i in inserta loop
      insert into jaqy139
        (jaqy139corr,
         jaqy139suc,
         JAQY139NSUC,
         jaqy139cta,
         jaqy139ope,
         jaqy139mda,
         jaqy139pap,
         jaqy139mod,
         jaqy139sbop,
         jaqy139top,
         jaqy139usu,
         jaqy139tit,
         jaqy139sac,
         jaqy139scap,
         jaqy139tcred,
         jaqy139mora,
         jaqy139dirleg,
         jaqy139refdir,
         jaqy139disdir,
         JAQY139DIAATR,
         jaqy139tlfn,
         jaqy139doc,
         jaqy139pai,
         jaqy139tid,
         jaqy139ins,
         JAQY139ESTADO,
         JAQY139TCONT,
         jaqy139fproc,
         JAQY139ICV,
		 JAQY139PEN,
         jaqy139sbbp,
         jaqy139ibbp,
         jaqy139spbp,
         jaqy139ipbp,
         jaqy139sbms,
         jaqy139ibms,         
         jaqy139sbfh,
         jaqy139ibfh           
 )
      values
        (ln_corr,
         i.agencia,
         I.NOMSUC,
         i.cuenta,
         i.credito,
         i.moneda,
         i.papel,
         i.modulo,
         i.suboper,
         i.tipoer,
         i.analista,
         i.titular,
         i.saldo_consolidado,
         I.SALDO_CAPITAL,
         i.tipo_credito,
         i.mora,
         i.dir_titu,
         i.ref_dir,
         i.dis_dir,
         i.dias_atraso,
         i.telefono,
         i.documento,
         i.pais,
         i.tipodoc,
         i.instancia,
         i.estado,
         I.TIPO_CONTABLE,
         i.fecproc,
         i.ICV, ---- 2017.06.16
         i.PENALIDAD,
         i.SALDO_BBP,
         i.INTERES_BBP,

         i.SALDO_PBP,
         i.INTERES_PBP,
         
         i.SALDO_BMS, --2019.07.
         i.INTERES_BMS,
         i.SALDO_BFH, --2019.08.14
         i.INTERES_BFH
		 );
    
      ln_corr := ln_corr + 1;
      COMMIT;
    end loop;
  
  end sp_cr_cargadatos;

   -- *****************************************************************
  procedure sp_atraso_maximo(pn_ppmod  in number,
                             pn_ppsuc  in number,
                             pn_ppmda  in number,
                             pn_pppap  in number,
                             pn_ppcta  in number,
                             pn_ppoper in number,
                             pd_fecha  in date,
                             atra_max  out number) is
  
    -- atra_max number;
  begin
  
    begin
      select MAX(PP1FECH - PPFPAG)
        into atra_max
        from FSD602
       WHERE ppmod = pn_ppmod
         and ppsuc = pn_ppsuc
         and ppmda = pn_ppmda
         and pppap = pn_pppap
         and PPCTA = pn_ppcta
         AND PPOPER = pn_ppoper
         and pp1stat = 'T';
    exception
      when others then
        NULL;
      
    end;
  
    if atra_max is null then
      begin
        select pd_fecha - min(ppfpag)
          into atra_max
          from FSD601
         WHERE ppmod = pn_ppmod
           and ppsuc = pn_ppsuc
           and ppmda = pn_ppmda
           and pppap = pn_pppap
           and PPCTA = pn_ppcta
           AND PPOPER = pn_ppoper;
      exception
        when others then
          NULL;
      end;
    end if;
    /*
    update jaqy139 j
       set j.jaqy139atrmax = atra_max
     where j.jaqy139suc = pn_ppsuc
       and j.jaqy139cta = pn_ppcta
       and j.jaqy139ope = pn_ppoper
       and j.jaqy139mda = pn_ppmda
       and j.jaqy139mod = pn_ppmod;*/
  
  end sp_atraso_maximo;

    -- *****************************************************************
  procedure sp_direc_titular(pais          in number,
                             tipo          in number,
                             documento     in character,
                             direc_negocio out varchar2,
                             dist_negocio  out varchar2,
                             direc_gestion out varchar2,
                             dist_gestion  out varchar2,
                             ref_gestion   out varchar2,
                             tlfn_gestion  out varchar2) is
  
    -- direc_negocio varchar2(250);
    cod_distneg number;
    cod_paisneg number;
    -- direc_gestion (250);
    cod_distgest number;
    cod_paisgest number;
    /*  dist_negocio  varchar2(50);
    dist_gestion  varchar2(50);
    ref_gestion   varchar2(250);
    tlfn_gestion  varchar2(50);*/
  
  begin
    begin
    
      select g13.sngc13dir, g13.sngc13dist, g13.sngc13pais
        into direc_negocio, cod_distneg, cod_paisneg
        from sngc13 g13
       where g13.sngc13pais = pais
         and g13.sngc13tdoc = tipo
         and g13.sngc13ndoc = documento
         and g13.docod = 3
         AND G13.SNGC13EST = 'H';
    exception
      when others then
        NULL;
      
    end;
  
    begin
    
      select g13.sngc13dir, G13.SNGC13REF1, g13.sngc13dist, g13.sngc13pais
        into direc_gestion, ref_gestion, cod_distgest, cod_paisgest
        from sngc13 g13
       where g13.sngc13pais = pais
         and g13.sngc13tdoc = tipo
         and g13.sngc13ndoc = documento
         and g13.docod = 6
         AND G13.SNGC13EST = 'H';
    exception
      when others then
        NULL;
    end;
  
    begin
      select F71.FST071DSC
        into dist_negocio
        from fst071 f71
       where f71.fst071pai = cod_paisneg
         and f71.fst071col = cod_distneg;
    exception
      when others then
        NULL;
    end;
  
    begin
      select F71.FST071DSC
        into dist_gestion
        from fst071 f71
       where f71.fst071pai = cod_paisgest
         and f71.fst071col = cod_distgest;
    exception
      when others then
        NULL;
    end;
  
    begin
      select f.dotelfp
        into tlfn_gestion
        from FSR005 f
       WHERE f.pepais = pais
         and f.petdoc = tipo
         and f.pendoc = documento
         AND DOCOD = 6;
    exception
      when others then
        NULL;
      
    end;
  
    /*update jaqy139 j
      set
      
      j.jaqy139dirneg  = direc_negocio,
          j.jaqy139disneg  = dist_negocio,
          j.jaqy139dirgest = direc_gestion,
          j.jaqy139disgest = dist_gestion,
          j.jaqy139refgest = ref_gestion,
          j.jaqy139tlfgest = tlfn_gestion
    where j.jaqy139pai = pais
      and j.jaqy139tid = tipo
      and j.jaqy139doc = documento;
      */
  
  end sp_direc_titular;
  
  
  
    -- *****************************************************************
  PROCEDURE sp_cr_actividad(pais      in number,
                            tipo      in number,
                            documento in character,
                            actividad out varchar2) is
    cod_actividad number;
    -- actividad     varchar2(200);
  begin
    begin
      select s.sngc60acte
        into cod_actividad
        from sngc60 s
       where s.sngc60pais = pais
         and s.sngc60tdoc = tipo
         and s.sngc60ndoc = documento;
    exception
      when others then
        NULL;
    end;
  
    begin
      select f.actnom1
        into actividad
        from fst750 f
       where f.actcod1 = cod_actividad;
    exception
      when others then
        NULL;
    end;
  
    /*update jaqy139 j
      set j.jaqy139activ = actividad
    where j.jaqy139pai = pais
      and j.jaqy139tid = tipo
      and j.jaqy139doc = documento;*/
  
  end sp_cr_actividad;

  -- *****************************************************************
  procedure sp_avales(instancia  in number,
                      nro_avales out number,
                      aval       out varchar2,
                      direc_aval out varchar2,
                      ref_aval   out varchar2,
                      dist_aval  out varchar2) is
  
    /* nro_avales number;
    aval       varchar2(200);
    direc_aval varchar2(200);
    ref_aval   varchar2(200);
    dist_aval  varchar2(200);*/
  begin
  
    begin
      select count(*)
        into nro_avales
        from sng003 s3
       where s3.sng001inst = instancia;
    exception
      when others then
        NULL;
    end;
    begin
      SELECT penom
        into aval
        from fsd001 f1, fsr008 f8, sng003 s3
       where s3.sng001inst = instancia
         and f8.ctnro = s3.sng003cta
         and f8.pepais = f1.pepais
         and f8.petdoc = f1.petdoc
         and f8.pendoc = f1.pendoc
         and f8.ttcod = 1
         and f8.cttfir = 'T'
         and rownum = 1;
    exception
      when others then
        NULL;
      
    end;
  
    begin
      SELECT c13.sngc13dir, c13.sngc13ref1
        into direc_aval, ref_aval
        from SNGC13 c13, fsr008 f8, sng003 s3
       where s3.sng001inst = instancia
         and f8.ctnro = s3.sng003cta
         and f8.pepais = c13.sngc13pais
         and f8.petdoc = c13.sngc13tdoc
         and f8.pendoc = c13.sngc13ndoc
         and f8.ttcod = 1
         and f8.cttfir = 'T'
         and docod = 1
         and c13.sngc13est = 'H'
         and rownum = 1;
    exception
      when others then
        NULL;
    end;
  
    begin
      SELECT f71.fst071dsc
        into dist_aval
        from SNGC13 c13, fsr008 f8, sng003 s3, FST071 F71
       where s3.sng001inst = instancia
         and f8.ctnro = s3.sng003cta
         and f8.pepais = c13.sngc13pais
         and f8.petdoc = c13.sngc13tdoc
         and f8.pendoc = c13.sngc13ndoc
         and f8.ttcod = 1
         and f8.cttfir = 'T'
         and docod = 1
         and c13.sngc13est = 'H'
         and f71.fst071pai = c13.sngc13pais
         and f71.fst071col = c13.sngc13dist
         and rownum = 1;
    exception
      when others then
        NULL;
    end;
    /*
      update jaqy139 j
         set 
         
         j.jaqy139nroaval = nro_avales,
             j.jaqy139aval    = aval,
             j.jaqy139diraval = direc_aval,
             j.jaqy139refaval = ref_aval,
             j.jaqy139disaval = dist_aval
       where j.jaqy139ins = instancia;
    
    */
  end sp_avales;

  
    -- *****************************************************************
  procedure sp_entidades(documento in character, entidades out number) is
    --   entidades number;
  begin
    begin
    
      select n_canent
        into entidades
        from cldrcci, fst098
       where c_docide = trim(documento)
         and d_fecpre = to_date(tpnro)
         and PGCOD = 1
         and tpcod = 7647
         and tpcorr = 12; 
    exception
      when others then
        NULL;
      
    end;
    /*
    UPDATE jaqy139 j
       set
       
        j.jaqy139entid = entidades
     where j.jaqy139doc = documento;*/
  
  end sp_entidades;

  -- *****************************************************************
  ---CUOTA IMPAGA --------------------------
  procedure sp_cuota_impaga(pn_ppmod  in number,
                            pn_ppsuc  in number,
                            pn_ppmda  in number,
                            pn_pppap  in number,
                            pn_ppcta  in number,
                            pn_ppoper in number,
                            pn_soboper in number,
                            pn_tope in number,
                            cuoimp  out number ) is
                            
-- 2017.06.16 Se agrego campos JAQY139ICV ,JAQY139PEN para penalidad
                            
  begin
  
    begin
      select --sum(j.jaql964gas + j.jaql964mor + j.jaql964int + j.jaql964cuo)
        sum(j.jaql964gas + j.jaql964mor + j.jaql964int + j.jaql964cuo + j.jaql964icv + j.jaql964pen) --2017.06.16
        into cuoimp
        from jaql964 j
      
       where j.jaql964cta = pn_ppcta
         and j.jaql964mod = pn_ppmod
         and j.jaql964suc = pn_ppsuc
         and j.jaql964mda = pn_ppmda
         and j.jaql964pap = pn_pppap
         and j.jaql964ope = pn_ppoper
         and j.jaql964sob = pn_soboper
         and j.jaql964top = pn_tope;
    exception
      when others then
        NULL;
      
    end;
  
    /*
    update jaqy139 j
       set 
      
       j.jaqy139cuoimp = cuoimp
     where j.jaqy139suc = pn_ppsuc
       and j.jaqy139cta = pn_ppcta
       and j.jaqy139ope = pn_ppoper
       and j.jaqy139mda = pn_ppmda
       and j.jaqy139pap = pn_pppap
       and j.jaqy139mod = pn_ppmod;*/
  
  end sp_cuota_impaga;
  
    -- *****************************************************************
  procedure sp_fecha_ultpago(pn_PGCOD      in number,
                             pn_ppmod      in number,
                             pn_ppsuc      in number,
                             pn_ppmda      in number,
                             pn_pppap      in number,
                             pn_ppcta      in number,
                             pn_ppoper     in number,
                             fecha_ultpago out date) is
  
    --  fecha_ultpago date;
  
  begin
  
    begin
    
      select max(pp1fech)
        into fecha_ultpago
        from fsd602
       where pgcod = pn_PGCOD
         and ppmod = pn_ppmod
         and ppsuc = pn_ppsuc
         and ppmda = pn_ppmda
         and pppap = pn_pppap
         and ppcta = pn_ppcta
         and ppoper = pn_ppoper
         and pp1stat = 'T';
    exception
      when others then
        NULL;
    end;
    /*
    update jaqy139 j
       set 
       
       j.jaqy139fultpag = fecha_ultpago
     where j.jaqy139suc = pn_ppsuc
       and j.jaqy139cta = pn_ppcta
       and j.jaqy139ope = pn_ppoper
       and j.jaqy139mda = pn_ppmda
       and j.jaqy139pap = pn_pppap
       and j.jaqy139mod = pn_ppmod;*/
  
  end sp_fecha_ultpago;
  
    -- *****************************************************************
  --------------------------------------------------------------------
  procedure sp_cuotas_pagadas(pn_PGCOD       in number,
                              pn_ppmod       in number,
                              pn_ppsuc       in number,
                              pn_ppmda       in number,
                              pn_pppap       in number,
                              pn_ppcta       in number,
                              pn_ppoper      in number,
                              cuotas_pagadas out number) is
  
    -- cuotas_pagadas number;
  begin
  
    begin
    
      select count(*)
        into cuotas_pagadas
        from fsd602
       where pgcod = pn_PGCOD
         and ppmod = pn_ppmod
         and ppsuc = pn_ppsuc
         and ppmda = pn_ppmda
         and pppap = pn_pppap
         and ppcta = pn_ppcta
         and ppoper = pn_ppoper
         and pp1stat = 'T';
    exception
      when others then
        NULL;
    end;
  
    /* update jaqy139 j
      set 
      
      j.jaqy139cuopag = cuotas_pagadas
    where j.jaqy139suc = pn_ppsuc
      and j.jaqy139cta = pn_ppcta
      and j.jaqy139ope = pn_ppoper
      and j.jaqy139mda = pn_ppmda
      and j.jaqy139pap = pn_pppap
      and j.jaqy139mod = pn_ppmod;*/
  
  end sp_cuotas_pagadas;

  ---------------------------------------------------------------------
  procedure sp_nro_credvig(pais        in number,
                           tipo        in number,
                           documento   in character,
                           nro_credvig out number) is
    --  nro_credvig number;
    -- identf varchar2(12);
  
  begin
    --identf := trim(documento);
    begin
      select count(*)
        into nro_credvig
        from jaql964
       where JAQl964PAI = pais
         and JAQl964TID = tipo
         and jaql964doc = documento
         and jaql964est <> 99
         and jaql964est <> 64;
    
    exception
      when others then
        NULL;
      
    end;
    /*
      update jaqy139
         set
        
          JAQY139NROCRE = nro_credvig
       where jaqy139doc = documento;
    */
  end sp_nro_credvig;

  --------------------------------------------------------------------
  procedure sp_ultreaccion(cuenta      in number,
                           operacion   in number,
                           fech_ultrea out date,
                           ultreacc    out varchar2,
                           usuario     out character) is
  
    --fech_ultrea date;
    --ultreacc varchar2(1000);
    correlativo number;
    cod24       number;
    cod25       number;
    cod26       number;
    obs23       varchar2(400);
    dsc26       char(40);
    fechac      date;
    --programa character(10);
    --usuario character(12);
  
  begin
  
    begin
      select max(sng229fecp)
        into fech_ultrea
        from sng229
       where sng229cta = cuenta
         and sng229cob = operacion
         and sng229nrcc = 1;
    exception
      when others then
        NULL;
    end;
  
    begin
    
      select sng229corr, sng224cod, sng225cod, sng229usu
        into correlativo, cod24, cod25, usuario
        from sng229
       where sng229cta = cuenta
         and sng229cob = operacion
         and sng229nrcc = 1
         and sng229fecp = fech_ultrea;
    exception
      when others then
        NULL;
    end;
  
    begin
    
      select sng230obs, sng230fecc, sng226cod, sng230fecp
        INTO obs23, fechac, cod26, fech_ultrea
        from sng230
       where sng229corr = correlativo;
    exception
      when others then
        NULL;
    end;
  
    begin
      select sng226dsc
        into dsc26
        from sng226
       where sng224cod = cod24 -- s29.sng224cod
         and sng225cod = cod25 --s29.sng225cod
         and sng226cod = cod26; --s23.sng226cod;
    exception
      when others then
        NULL;
    end;
  
    ultreacc := concat(concat(dsc26, obs23), fechac);
    /*
    update jaqy139 j set
    
     j.jaqy139fultgest = fech_ultrea,
                         j.jaqy139ultreacc = ultreacc,
                         j.jaqy139usuario =  usuario
                         where j.jaqy139cta = cuenta
                         and j.jaqy139ope = operacion;
    */
  end sp_ultreaccion;

  --------------------------------------------------------------------
  procedure sp_cr_updatejaqy139(instancia      in number,
                                pais           in number,
                                tipo           in number,
                                documento      in character,
                                pn_ppsuc       in number,
                                pn_ppcta       in number,
                                pn_ppoper      in number,
                                pn_ppmda       in number,
                                pn_ppmod       in number,
                                atra_max       in number,
                                direc_negocio  in varchar2,
                                dist_negocio   in varchar2,
                                direc_gestion  in varchar2,
                                dist_gestion   in varchar2,
                                ref_gestion    in varchar2,
                                tlfn_gestion   in varchar2,
                                actividad      in varchar,
                                nro_avales     in number,
                                aval           in varchar2,
                                direc_aval     in varchar2,
                                ref_aval       in varchar2,
                                dist_aval      in varchar2,
                                entidades      in number,
                                cuoimp         in number,
                                cuotas_pagadas in number,
                                fecha_ultpago  in date,
                                nro_credvig    in number,
                                fech_ultrea    in date,
                                ultreacc       in VARCHAR2,
                                usuario        in Character                       
                                ) is
  begin
    begin
      UPDATE JAQY139 j
         set j.jaqy139atrmax   = atra_max,
             j.jaqy139dirneg   = direc_negocio,
             j.jaqy139disneg   = dist_negocio,
             j.jaqy139dirgest  = direc_gestion,
             j.jaqy139disgest  = dist_gestion,
             j.jaqy139refgest  = ref_gestion,
             j.jaqy139tlfgest  = tlfn_gestion,
             j.jaqy139nroaval  = nro_avales,
             j.jaqy139activ    = actividad,
             j.jaqy139aval     = aval,
             j.jaqy139diraval  = direc_aval,
             j.jaqy139refaval  = ref_aval,
             j.jaqy139disaval  = dist_aval,
             j.jaqy139entid    = entidades,
             j.jaqy139cuoimp   = cuoimp,
             j.jaqy139fultpag  = fecha_ultpago,
             j.jaqy139cuopag   = cuotas_pagadas,
             j.JAQY139NROCRE   = nro_credvig,
             j.jaqy139fultgest = fech_ultrea,
             j.jaqy139ultreacc = ultreacc,
             j.jaqy139usuario  = usuario
             
       where j.jaqy139ins = instancia
         and j.jaqy139pai = pais
         and j.jaqy139tid = tipo
         and j.jaqy139doc = documento
         and j.jaqy139suc = pn_ppsuc
         and j.jaqy139cta = pn_ppcta
         and j.jaqy139ope = pn_ppoper
         and j.jaqy139mda = pn_ppmda
         and j.jaqy139mod = pn_ppmod;
    
    exception
      when others then
        NULL;
      
    end;
  
  end sp_cr_updatejaqy139;
  --------------------------------------------------------------------

  procedure sp_cr_cargatotal(P_N_INI in NUMBER, P_N_FIN in NUMBER) is
  
    atra_max       number;
    direc_negocio  varchar2(500);
    dist_negocio   varchar2(200);
    direc_gestion  varchar2(500);
    dist_gestion   varchar2(200);
    ref_gestion    varchar2(500);
    tlfn_gestion   varchar2(50);
    actividad      varchar(300);
    nro_avales     number;
    aval           varchar2(350);
    direc_aval     varchar2(500);
    ref_aval       varchar2(500);
    dist_aval      varchar2(200);
    entidades      number;
    cuoimp         number;
    cuotas_pagadas number;
    fecha_ultpago  date;
    nro_credvig    number;
    fech_ultrea    date;
    ultreacc       VARCHAR2(1500);
    usuario        Character(12);
  
    cursor cobranza is
    
      select j.jaqy139suc,
             j.jaqy139cta,
             j.jaqy139ope,
             j.jaqy139mda,
             j.jaqy139pap,
             j.jaqy139mod,
             j.jaqy139sbop,
             j.jaqy139top,
             j.jaqy139doc,
             j.jaqy139pai,
             j.jaqy139tid,
             j.jaqy139ins,
             j.jaqy139fproc
        from jaqy139 j
       WHERE j.jaqy139corr >= P_N_INI
         and j.jaqy139corr <= P_N_FIN;
  
    /* begin
    pq_cr_reporte_cobranza.sp_cr_cargadatos;*/
  
  begin
    for i in cobranza loop
    
      pq_cr_reporte_cobranza.sp_atraso_maximo(pn_ppmod  => i.jaqy139mod,
                                              pn_ppsuc  => i.jaqy139suc,
                                              pn_ppmda  => i.jaqy139mda,
                                              pn_pppap  => i.jaqy139pap,
                                              pn_ppcta  => i.jaqy139cta,
                                              pn_ppoper => i.jaqy139ope,
                                              pd_fecha  => i.jaqy139fproc,
                                              atra_max  => atra_max); -- out
    
      pq_cr_reporte_cobranza.sp_cuota_impaga(pn_ppmod  => i.jaqy139mod,
                                             pn_ppsuc  => i.jaqy139suc,
                                             pn_ppmda  => i.jaqy139mda,
                                             pn_pppap  => i.jaqy139pap,
                                             pn_ppcta  => i.jaqy139cta,
                                             pn_ppoper => i.jaqy139ope,
                                             pn_soboper => i.jaqy139sbop,
                                             pn_tope => i.jaqy139top,                                         
                                             cuoimp    => cuoimp);
    
      pq_cr_reporte_cobranza.sp_fecha_ultpago(pn_PGCOD      => 1,
                                              pn_ppmod      => i.jaqy139mod,
                                              pn_ppsuc      => i.jaqy139suc,
                                              pn_ppmda      => i.jaqy139mda,
                                              pn_pppap      => i.jaqy139pap,
                                              pn_ppcta      => i.jaqy139cta,
                                              pn_ppoper     => i.jaqy139ope,
                                              fecha_ultpago => fecha_ultpago);
    
      pq_cr_reporte_cobranza.sp_cuotas_pagadas(pn_PGCOD       => 1,
                                               pn_ppmod       => i.jaqy139mod,
                                               pn_ppsuc       => i.jaqy139suc,
                                               pn_ppmda       => i.jaqy139mda,
                                               pn_pppap       => i.jaqy139pap,
                                               pn_ppcta       => i.jaqy139cta,
                                               pn_ppoper      => i.jaqy139ope,
                                               cuotas_pagadas => cuotas_pagadas);
    
      pq_cr_reporte_cobranza.sp_direc_titular(pais          => i.jaqy139pai,
                                              tipo          => i.jaqy139tid,
                                              documento     => i.jaqy139doc,
                                              direc_negocio => direc_negocio,
                                              dist_negocio  => dist_negocio,
                                              direc_gestion => direc_gestion,
                                              dist_gestion  => dist_gestion,
                                              ref_gestion   => ref_gestion,
                                              tlfn_gestion  => tlfn_gestion);
    
      pq_cr_reporte_cobranza.sp_cr_actividad(pais      => i.jaqy139pai,
                                             tipo      => i.jaqy139tid,
                                             documento => i.jaqy139doc,
                                             actividad => actividad);
    
      pq_cr_reporte_cobranza.sp_avales(instancia  => i.jaqy139ins,
                                       nro_avales => nro_avales,
                                       aval       => aval,
                                       direc_aval => direc_aval,
                                       ref_aval   => ref_aval,
                                       dist_aval  => dist_aval);
    
      pq_cr_reporte_cobranza.sp_entidades(documento => i.jaqy139doc,
                                          entidades => entidades);
    
      pq_cr_reporte_cobranza.sp_nro_credvig(pais        => i.jaqy139pai,
                                            tipo        => i.jaqy139tid,
                                            documento   => i.jaqy139doc,
                                            nro_credvig => nro_credvig);
      pq_cr_reporte_cobranza.sp_ultreaccion(cuenta      => i.jaqy139cta,
                                            operacion   => i.jaqy139ope,
                                            fech_ultrea => fech_ultrea,
                                            ultreacc    => ultreacc,
                                            usuario     => usuario);
      pq_cr_reporte_cobranza.sp_cr_updatejaqy139( i.jaqy139ins,      
                                                  i.jaqy139pai,     
                                                  i.jaqy139tid,    
                                                 i.jaqy139doc,      
                                                  i.jaqy139suc  ,     
                                                  i.jaqy139cta   ,    
                                                  i.jaqy139ope  ,   
                                                  i.jaqy139mda    ,  
                                                  i.jaqy139mod      , 
                                                  atra_max       ,
                                                  direc_negocio  ,
                                                  dist_negocio   ,
                                                  direc_gestion  ,
                                                  dist_gestion   ,
                                                  ref_gestion    ,
                                                  tlfn_gestion   ,
                                                  actividad      ,
                                                  nro_avales     ,
                                                  aval           ,
                                                  direc_aval     ,
                                                  ref_aval       ,
                                                  dist_aval      ,
                                                  entidades      ,
                                                  cuoimp         ,
                                                  cuotas_pagadas ,
                                                  fecha_ultpago  ,
                                                  nro_credvig    ,
                                                  fech_ultrea    ,
                                                  ultreacc       ,
                                                  usuario        );
                            commit;
    end loop;
    -- end;
  end sp_cr_cargatotal;

  -------------------------------------------------------------------------------------------
  procedure sp_cr_job_carga is
  
    ln_ini      number;
    ln_fin      number;
    ln_divisor  number := 725;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
    -- ld_finmes   date;
    ln_contador number;
    ln_num      number := 1;
  lc_hostname varchar2(64);
  begin
  
  
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQY139',
                                    degree           => 4,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;
  
    begin
      select ceil(count(*) / ln_divisor) into ln_contador from jaqy139;
      /* where jaql964dia >= 1
      and jaql964est in (0, 61, 21, 22);*/
    end;
  
    ln_ini := 1;
    ln_fin := 725;
    WHILE ln_num <= ln_contador LOOP
    
      lc_variable := 'begin ' ||
                     ' pq_cr_reporte_cobranza.sp_cr_cargatotal(' || ln_ini || ',' ||
                     ln_fin || ' );' || ' End;';
      ln_job      := ln_job + 1;
--      if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                      --  instance  => 2, --24102023
                        instance  => 1,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
        
      end if;                    
    
      ln_ini := ln_fin + 1;
      ln_fin := ln_ini + ln_divisor - 1;
    
      ln_num := ln_num + 1;
      commit;
    END LOOP;
  
  end sp_cr_job_carga;

---------------------------------------------------------------------
end pq_cr_reporte_cobranza;
/

