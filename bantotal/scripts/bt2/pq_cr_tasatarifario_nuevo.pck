create or replace package PQ_CR_TASATARIFARIO_NUEVO is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_TASATARIFARIO_NUEVO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.10.21
  -- Autor de Creación          : YYAMPI
  -- Uso                        : procedimientos de calculo de la nueva tasa - potencialidad
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 2023.07.07 YYAMPI SE MODIFICO SP_CR_TASA_POTEN_LINEA, SP_CR_TASA_POTEN_LINEA2 Y SP_CR_TPOTEN_CAMP 
  --                              2024.03.05 yyampi se agrego SP_CR_FACTOR_SCORE, SP_CR_TASA_POTEN_LINEA4
  --                              2024.03.08 dcastro se agrego factor score    
  --                              2025.01.27 yyampi se modifico el SP_CR_FACTOR_SCORE
  -- *****************************************************************
  Procedure Sp_cr_Inicio(pn_ins    in number,
                         pd_fecpro in date,
                         pn_tasa   out number);

  Procedure SP_CR_TASA_POTEN(pn_instancia in number,
                             pd_fecha     in date,
                             pn_tasaf     out number);

  Procedure SP_CR_TASA_POTEN_LINEA(pd_fecha  in date,
                                   pn_pais   in number,
                                   pn_tipdoc in number,
                                   pn_numdoc in char,
                                   pn_modulo in number,
                                   pn_moneda in number,
                                   pn_papel  in number,
                                   pn_sucur  in number,
                                   pn_tipope in number,
                                   pn_monto  in number,
                                   pn_frecu  in number,
                                   pn_cuotas in number,
                                   pn_tasaf  out number,
                                   pn_cuotaf out number,
                                   pc_coderr out char,
                                   pv_deserr out varchar);

  Procedure Sp_cr_Inicio_linea(pn_mod    in number, --
                               pn_suc    in number, --
                               pn_mda    in number, --
                               pn_pap    in number, --
                               pn_top    in number, --
                               pn_mto    in number, --
                               pn_pzo    in number, --
                               pd_fecpro in date, --fecha de proceso
                               pn_tasa   out number);
  -----------------------------------------------------
  -- mpostigoc 22.12.2022  
  -- Procedimiento que calcula la potencialidad del cliente

  Procedure Sp_cr_TPOTEN_CAMP(LN_SNG001PAIS in NUMBER,
                              LN_SNG001TDOC in NUMBER,
                              LC_SNG001NDOC in varchar2,
                              LN_XWFMONTO1  in number,
                              LN_XWFPLAZO1  in number,
                              LN_XWFTIPOPE  in number,
                              LN_XWFMODULO  in number,
                              ln_moneda     in number,
                              ln_papel      in number,
                              ln_sucursal   in number,
                              pd_fecha      in date,
                              pn_tasaf      out number);
  ----------------------------------------------------------
  -- Private type declarations
  Procedure sp_cr_tasatarf(LN_XWFMONTO1 in number,
                           LN_XWFPLAZO1 in number,
                           LN_XWFTIPOPE in number,
                           LN_XWFMODULO in number,
                           ln_moneda    in number,
                           ln_papel     in number,
                           ln_sucursal  in number,
                           pd_fecpro    in date,
                           pn_tasa      out number);

  -----------------------------------------------------------

  Procedure SP_CR_TASA_POTEN_LINEA2(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_plazo  in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar);
  --------------------------------------------------------------

  PROCEDURE SP_CR_FACTOR_SCORE(pd_fecpro in date,
                               pn_pgpais in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_modulo in number,
                               pn_tipope in number,
                               pv_score  out varchar,
                               pn_result out number);

  --------------------------------------------------------------
  Procedure SP_CR_TASA_POTEN_LINEA3(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_frecu  in number,
                                    pn_cuotas in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pn_tasao  out number,
                                    pn_curpot out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar);

  ------------------------------------------------------------                                  

  Procedure SP_CR_TASA_POTEN_LINEA4(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_frecu  in number,
                                    pn_cuotas in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pn_tasao  out number,
                                    pn_curpot out number,
                                    pv_score  out varchar2,
                                    pn_ajusc  out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar);

--------------------------------------------------------------------------

end PQ_CR_TASATARIFARIO_NUEVO;
/

create or replace package body PQ_CR_TASATARIFARIO_NUEVO is

  -- Private type declarations
  Procedure Sp_cr_Inicio(pn_ins    in number,
                         pd_fecpro in date,
                         pn_tasa   out number) is
    -- *****************************************************************
    -- Nombre                     : Sp_cr_Inicio
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.20
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ln_mto   number(17, 2);
    ln_pzo   number(5);
    ln_defn  number(17, 2);
    ln_cont  number(5) := 0;
    ln_tas   number(10, 6);
    ln_mtt   number(17, 2);
    ln_fde   date;
    ln_tat   number(7, 4);
    ln_cont2 number(5) := 0;
    ln_tvmpo number(7, 4);
    ln_porc  number(4) := 100;
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
  begin
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope,
             a.xwfmonto1,
             a.xwfplazo1
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_mto,
             ln_pzo
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    --obtiene pizarra
    begin
      select Pp028DefN
        into ln_defn
        from fpp028
       where Pp010Prd = 1
         and Pp017Par = 17
         and Pp028Mod = ln_mod
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp028Top = ln_top;
    exception
      when others then
        null;
    end;
  
    for i in tasa(ln_defn,
                  ln_mod,
                  ln_mda,
                  ln_pap,
                  ln_mto,
                  ln_pzo,
                  pd_fecpro) loop
    
      ln_tas  := i.Tatasa;
      ln_mtt  := i.Tamto;
      ln_fde  := i.Tafdes;
      ln_tat  := i.Tatol;
      ln_cont := ln_cont + 1;
    
      if ln_cont > 0 then
        exit;
      end if;
    
    end loop;
  
    for j in region(ln_suc) loop
      for k in tasa_esp(ln_mod,
                        ln_defn,
                        ln_pap,
                        ln_mda,
                        ln_mtt, --MOD@ABR 20171018
                        j.regcod,
                        pd_fecpro) loop
      
        ln_tvmpo := k.TvMPorc - ln_porc;
        ln_cont2 := ln_cont2 + 1;
      
        if ln_cont2 > 0 then
          exit;
        end if;
      
      end loop;
    end loop;
  
    pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
  
  end Sp_cr_Inicio;

  ------------------------------------------------------------------------------
  Procedure SP_CR_TASA_POTEN(pn_instancia in number,
                             pd_fecha     in date,
                             pn_tasaf     out number) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA_POTEN
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.20
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( INSTANCIA DEL CREDITO )
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : 
    --                            : 
    -- Parámetros de Salida       : pn_tasaf ( TASA OBTENIDA )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2023.07.07 YYAMPI SE TOMA LA ULTIMA FECHA DE LAS CURVAS POTENCIALIDAD
    --  
    -- *****************************************************************
  
    LN_XWFMONTO1  NUMBER(17, 2) := 0;
    LN_XWFPLAZO1  NUMBER(5) := 0;
    LN_XWFTIPOPE  NUMBER(3) := 0;
    LN_XWFMODULO  NUMBER(3) := 0;
    LN_SNG001PAIS NUMBER(3) := 0;
    LN_SNG001TDOC NUMBER(3) := 0;
    LC_SNG001NDOC CHAR(12) := '';
    ln_monto      NUMBER(17, 2) := 0;
    ld_fecfinmes  date;
    ln_poten      number(5) := 0;
    ln_plazo      number(5) := 0;
    ln_jaqn31cur  number(10, 6) := 0;
    ln_tasaO      number(10, 6) := 0;
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*CALCULO DE DATOS DE CLIENTE*/
    BEGIN
      select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
        INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
        from SNG001 T
       WHERE T.SNG001INST = pn_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        LN_SNG001PAIS := 0;
        LN_SNG001TDOC := 0;
        LC_SNG001NDOC := '';
      
    END;
  
    /*CALCULO DE DATOS DE CREDITO*/
    BEGIN
      select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
        INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
        from XWF700 T
       WHERE T.XWFPRCINS = pn_instancia
         AND T.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        LN_XWFMONTO1 := 0;
        LN_XWFPLAZO1 := 0;
        LN_XWFTIPOPE := 0;
        LN_XWFMODULO := 0;
      
    END;
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124     
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi)
                             --into ln_jaqn31cur
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    --retorna tasa final 
    begin
      pq_cr_tasatarifario_nuevo.Sp_cr_Inicio(pn_ins    => pn_instancia,
                                             pd_fecpro => pd_fecha,
                                             pn_tasa   => ln_tasaO);
    
      pn_tasaf := ln_tasaO + ln_jaqn31cur;
    
    exception
      when others then
        pn_tasaf := 0;
    end;
  
  END Sp_cr_TASA_POTEN;

  ----------------------------------------------------------------------------------

  Procedure SP_CR_TASA_POTEN_LINEA(pd_fecha  in date,
                                   pn_pais   in number,
                                   pn_tipdoc in number,
                                   pn_numdoc in char,
                                   pn_modulo in number,
                                   pn_moneda in number,
                                   pn_papel  in number,
                                   pn_sucur  in number,
                                   pn_tipope in number,
                                   pn_monto  in number,
                                   pn_frecu  in number,
                                   pn_cuotas in number,
                                   pn_tasaf  out number,
                                   pn_cuotaf out number,
                                   pc_coderr out char,
                                   pv_deserr out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA_POTEN_LINEA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA + POTENCIALIDAD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais  (PAIS)
    --                            : pn_tipdoc  (TIPO DE DOCUMENTO)
    --                            : pn_numdoc  (NUMERO DE DOCUMENTO)
    --                            : pn_modulo  (MODULO )
    --                            : pn_moneda  (MONEDA)
    --                            : pn_papel  (PAPEL)
    --                            : pn_sucur  (SUCURSAL)
    --                            : pn_tipope  (TIPO DE OPERACION)                       
    --                            : pn_plazo  (PLAZO)
    --                            : pn_monto  (MONTO)
    --
    -- Parámetros de Salida       : pn_tasaf out  (TASA OBTENIDA)
    --                            : pc_coderr out  (CODIGO DEL ERROR)
    --                            : pv_deserr out (DESCRIPCION ERROR)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 12/03/2024 yyampi se agrego el calculo de score en el calculo de la tasa 
    --  
    -- *****************************************************************                       
  
    LN_XWFMONTO1   NUMBER(17, 2) := 0;
    LN_XWFPLAZO1   NUMBER(5) := 0;
    LN_XWFTIPOPE   NUMBER(3) := 0;
    LN_XWFMODULO   NUMBER(3) := 0;
    LN_XWFSUCURSAL NUMBER(3) := 0;
    LN_XWFMONEDA   NUMBER(3) := 0;
    LN_XWFPAPEL    NUMBER(3) := 0;
  
    LN_SNG001PAIS NUMBER(3) := 0;
    LN_SNG001TDOC NUMBER(3) := 0;
    LC_SNG001NDOC CHAR(12) := '';
    ln_monto      NUMBER(17, 2) := 0;
    ld_fecfinmes  date;
    ln_poten      number(5) := 0;
    ln_plazo      number(5) := 0;
    ln_jaqn31cur  number(10, 6) := 0;
    ln_tasaO      number(10, 6) := 0;
  
    lv_score varchar2(15) := '';
    ln_score number(10, 6) := 0;
  
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*CALCULO DE DATOS DE CLIENTE*/
    /*BEGIN 
     select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
     INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
       from SNG001 T
      WHERE T.SNG001INST = pn_instancia
        ;
    EXCEPTION WHEN OTHERS THEN
      LN_SNG001PAIS :=0;
      LN_SNG001TDOC :=0;
      LC_SNG001NDOC :='';
      
    END;*/
  
    /*CALCULO DE DATOS DE CREDITO*/
    /*BEGIN 
     select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
     INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
       from XWF700 T
      WHERE T.XWFPRCINS = pn_instancia
        AND T.XWFCAR3 = '1';
    EXCEPTION WHEN OTHERS THEN
      LN_XWFMONTO1 :=0;
      LN_XWFPLAZO1 :=0;
      LN_XWFTIPOPE :=0;
      LN_XWFMODULO :=0;     
    END;*/
  
    /*Seteo de variables*/
    begin
      LN_SNG001PAIS  := pn_pais;
      LN_SNG001TDOC  := pn_tipdoc;
      LC_SNG001NDOC  := pn_numdoc;
      LN_XWFMONTO1   := pn_monto;
      LN_XWFPLAZO1   := pn_frecu * pn_cuotas; --pn_plazo;
      LN_XWFTIPOPE   := pn_tipope;
      LN_XWFMODULO   := pn_modulo;
      LN_XWFSUCURSAL := pn_sucur;
      LN_XWFMONEDA   := pn_moneda;
      LN_XWFPAPEL    := pn_papel;
    exception
      when others then
        pc_coderr := '00005';
    end;
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
    
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
              --into ln_monto
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00001'; --  
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124
              --into ln_plazo
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00002'; -- 
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      /*select j.jaqn31cur
       into ln_jaqn31cur
       from jaqn31 j
      where j.jaqn31mod = LN_XWFMODULO --
        and j.jaqn31top = LN_XWFTIPOPE
        and j.jaqn31tcu = 500 + ln_poten
        and j.JAQN31MTO = ln_monto
        and j.jaqn31pla = ln_plazo;*/
    
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi) /* 07/07/2023 yyampi se considero la ultima fecha de parametrizacion*/
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00003'; --  
    END;
  
    --calculo de score     --12/03/2024 yyampi
    begin
      SP_CR_FACTOR_SCORE(pd_fecpro => pd_fecha,
                         pn_pgpais => LN_SNG001PAIS,
                         pn_tipdoc => LN_SNG001TDOC,
                         pc_numdoc => LC_SNG001NDOC,
                         pn_modulo => LN_XWFMODULO,
                         pn_tipope => LN_XWFTIPOPE,
                         pv_score  => lv_score,
                         pn_result => ln_score);
    
    exception
      when others then
        lv_score  := 0;
        ln_score  := 0;
        pc_coderr := '00007'; --  
    
    end; --12/03/2024 yyampi
  
    --retorna tasa final 
    begin
    
      pq_cr_tasatarifario_nuevo.Sp_cr_Inicio_linea(pn_mod    => LN_XWFMODULO,
                                                   pn_suc    => LN_XWFSUCURSAL,
                                                   pn_mda    => LN_XWFMONEDA,
                                                   pn_pap    => LN_XWFPAPEL,
                                                   pn_top    => LN_XWFTIPOPE,
                                                   pn_mto    => LN_XWFMONTO1,
                                                   pn_pzo    => LN_XWFPLAZO1,
                                                   pd_fecpro => pd_fecha,
                                                   pn_tasa   => ln_tasaO);
    
      pn_tasaf  := ln_tasaO + ln_jaqn31cur + ln_score; --12/03/2024 yyampi
      pc_coderr := '00000';
    
    exception
      when others then
        pn_tasaf  := 0;
        pc_coderr := '00004';
    end;
  
    /*calcula cuota*/
    begin
      pn_cuotaf := round((LN_XWFMONTO1 *
                         ((power((1 + (pn_tasaf / 100)), (1 / 12))) - 1)) /
                         (1 - power((1 + ((power((1 + (pn_tasaf / 100)),
                                                 (1 / 12))) - 1)),
                                    -pn_cuotas)),
                         2);
      pc_coderr := '00000';
    exception
      when others then
        pn_cuotaf := 0;
        pc_coderr := '00006';
    end;
  
    /*codificacion de errores*/
    if pc_coderr = '00000' then
      pv_deserr := 'Ok';
    else
      if pc_coderr = '00001' then
        pv_deserr := 'Error en el monto';
      else
        if pc_coderr = '00002' then
          pv_deserr := 'Error en el plazo';
        else
          if pc_coderr = '00003' then
            pv_deserr := 'Error en la curva potencial';
          else
            if pc_coderr = '00004' then
              pv_deserr := 'Error en calculo de tasa';
            else
              if pc_coderr = '00005' then
                pv_deserr := 'Error en parametros de entrada';
              else
                if pc_coderr = '00006' then
                  pv_deserr := 'Error en calculo de cuota';
                else
                  if pc_coderr = '00007' then
                    --12/03/2024 yyampi
                    pv_deserr := 'Error en calculo de score'; --12/03/2024 yyampi
                  end if; --12/03/2024 yyampi
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      --pv_deserr := 'Error en el calculo';   
    end if;
  
  END SP_CR_TASA_POTEN_LINEA;
  -------------------------------------------------------------------------------------
  Procedure Sp_cr_Inicio_linea(pn_mod    in number, --
                               pn_suc    in number, --
                               pn_mda    in number, --
                               pn_pap    in number, --
                               pn_top    in number, --
                               pn_mto    in number, --
                               pn_pzo    in number, --
                               pd_fecpro in date, --fecha de proceso
                               pn_tasa   out number) is
    -- *****************************************************************
    -- Nombre                     : Sp_cr_Inicio_linea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                            : pn_mod ( MODULO )
    --                            : pn_suc  (SUCURSAL)
    --                            : pn_mda  (MONEDA)
    --                            : pn_pap  (PAPEL)
    --                            : pn_top  (TIPO DE OPERACION )
    --                            : pn_mto  (MONTO)
    --                            : pn_pzo  (PLAZO)
    --                            : pd_fecpro  (FECHA DE PROCESO)
    --                            : pn_tasa  (TASA)                       
    --                            : 
    --                            : 
    --
    -- Parámetros de Salida       : pn_tasa  (TASA)  
    --                            : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ln_mto   number(17, 2);
    ln_pzo   number(5);
    ln_defn  number(17, 2);
    ln_cont  number(5) := 0;
    ln_tas   number(10, 6);
    ln_mtt   number(17, 2);
    ln_fde   date;
    ln_tat   number(7, 4);
    ln_cont2 number(5) := 0;
    ln_tvmpo number(7, 4);
    ln_porc  number(4) := 100;
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
  begin
    /*begin
        select a.xwfempresa,
               a.xwfmodulo,
               a.xwfsucursal,
               a.xwfmoneda,
               a.xwfpapel,
               a.xwfcuenta,
               a.xwfoperacion,
               a.xwfsubope,
               a.xwftipope,
               a.xwfmonto1,
               a.xwfplazo1
          into ln_emp,
               ln_mod, --
               ln_suc, --
               ln_mda, --
               ln_pap, --
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top, --
               ln_mto, --
               ln_pzo  --
          from xwf700 a
         where a.xwfprcins = pn_ins
           and a.xwfcar3   = '1';
    exception
      when others then null;
    end;*/
  
    /*seteo de variables*/
    ln_mod := pn_mod;
    ln_suc := pn_suc;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_top := pn_top;
    ln_mto := pn_mto;
    ln_pzo := pn_pzo;
  
    --obtiene pizarra
    begin
      select Pp028DefN
        into ln_defn
        from fpp028
       where Pp010Prd = 1
         and Pp017Par = 17
         and Pp028Mod = ln_mod
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp028Top = ln_top;
    exception
      when others then
        null;
    end;
  
    for i in tasa(ln_defn,
                  ln_mod,
                  ln_mda,
                  ln_pap,
                  ln_mto,
                  ln_pzo,
                  pd_fecpro) loop
    
      ln_tas  := i.Tatasa;
      ln_mtt  := i.Tamto;
      ln_fde  := i.Tafdes;
      ln_tat  := i.Tatol;
      ln_cont := ln_cont + 1;
    
      if ln_cont > 0 then
        exit;
      end if;
    
    end loop;
  
    for j in region(ln_suc) loop
      for k in tasa_esp(ln_mod,
                        ln_defn,
                        ln_pap,
                        ln_mda,
                        ln_mtt, --MOD@ABR 20171018
                        j.regcod,
                        pd_fecpro) loop
      
        ln_tvmpo := k.TvMPorc - ln_porc;
        ln_cont2 := ln_cont2 + 1;
      
        if ln_cont2 > 0 then
          exit;
        end if;
      
      end loop;
    end loop;
  
    pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
  
  end Sp_cr_Inicio_linea;
  ---------------------------------------------------------------------------------------
  Procedure Sp_cr_TPOTEN_CAMP(LN_SNG001PAIS in NUMBER,
                              LN_SNG001TDOC in NUMBER,
                              LC_SNG001NDOC in varchar2,
                              LN_XWFMONTO1  in number,
                              LN_XWFPLAZO1  in number,
                              LN_XWFTIPOPE  in number,
                              LN_XWFMODULO  in number,
                              ln_moneda     in number,
                              ln_papel      in number,
                              ln_sucursal   in number,
                              pd_fecha      in date,
                              pn_tasaf      out number) is
  
    -- *****************************************************************
    -- Nombre                     : Sp_cr_TPOTEN_CAMP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.12.22  
    -- Autor de Creación          : MPOSTIGOC
    -- Uso                        : CALCULA EL VALOR DE La potencialidad por cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_instancia ( INSTANCIA DEL CREDITO )
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : 
    --                            : 
    -- Parámetros de Salida       : pn_tasaf ( TASA OBTENIDA )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2023.07.07 YYAMPI SE TOMA LA ULTIMA FECHA DE LAS CURVAS POTENCIALIDAD
    --                              2024.03.08 dcastro se agrego factor score Sp_cr_TPOTEN_CAMP
    --  
    -- *****************************************************************
  
    ln_monto     NUMBER(17, 2) := 0;
    ld_fecfinmes date;
    ln_poten     number(5) := 0;
    ln_plazo     number(5) := 0;
    ln_jaqn31cur number(10, 6) := 0;
    ln_tasaO     number(10, 6) := 0;
    lv_score     varchar2(15) := '';
    ln_score     number(10, 6) := 0;
  
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*  \*CALCULO DE DATOS DE CLIENTE*\
    BEGIN
      select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
        INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
        from SNG001 T
       WHERE T.SNG001INST = pn_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        LN_SNG001PAIS := 0;
        LN_SNG001TDOC := 0;
        LC_SNG001NDOC := '';
      
    END;*/
  
    /*CALCULO DE DATOS DE CREDITO*/
    /*   BEGIN
      select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
        INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
        from XWF700 T
       WHERE T.XWFPRCINS = pn_instancia
         AND T.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        LN_XWFMONTO1 := 0;
        LN_XWFPLAZO1 := 0;
        LN_XWFTIPOPE := 0;
        LN_XWFMODULO := 0;
      
    END;*/
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
              --into ln_monto
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124
              --into ln_plazo
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      /*select j.jaqn31cur
       into ln_jaqn31cur
       from jaqn31 j
      where j.jaqn31mod = LN_XWFMODULO --
        and j.jaqn31top = LN_XWFTIPOPE
        and j.jaqn31tcu = 500 + ln_poten
        and j.JAQN31MTO = ln_monto
        and j.jaqn31pla = ln_plazo;*/
    
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi) /* 07/07/2023 yyampi se considero la ultima fecha de parametrizacion*/
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    -- pn_tasaf := nvl(ln_jaqn31cur, 0);
  
    /* 2024.03.08 dcastro agregar factor score*/
    --retorna score
    begin
      SP_CR_FACTOR_SCORE(pd_fecpro => pd_fecha,
                         pn_pgpais => LN_SNG001PAIS,
                         pn_tipdoc => LN_SNG001TDOC,
                         pc_numdoc => LC_SNG001NDOC,
                         pn_modulo => LN_XWFMODULO,
                         pn_tipope => LN_XWFTIPOPE,
                         pv_score  => lv_score,
                         pn_result => ln_score);
    
    exception
      when others then
        ln_score := 0; --  
    end;
    /* 2024.03.08 dcastro agregar factor score*/
  
    --retorna tasa final 
    begin
      pq_cr_tasatarifario_nuevo.sp_cr_tasatarf(LN_XWFMONTO1 => LN_XWFMONTO1,
                                               LN_XWFPLAZO1 => LN_XWFPLAZO1,
                                               LN_XWFTIPOPE => LN_XWFTIPOPE,
                                               LN_XWFMODULO => LN_XWFMODULO,
                                               ln_moneda    => ln_moneda,
                                               ln_papel     => ln_papel,
                                               ln_sucursal  => ln_sucursal,
                                               pd_fecpro    => pd_fecha,
                                               pn_tasa      => ln_tasaO);
    
      pn_tasaf := ln_tasaO + nvl(ln_jaqn31cur, 0) + ln_score;
    
    exception
      when others then
        pn_tasaf := 0;
    end;
  
  END Sp_cr_TPOTEN_CAMP;
  ---------------------------------------------------------
  -- Private type declarations
  Procedure sp_cr_tasatarf(LN_XWFMONTO1 in number,
                           LN_XWFPLAZO1 in number,
                           LN_XWFTIPOPE in number,
                           LN_XWFMODULO in number,
                           ln_moneda    in number,
                           ln_papel     in number,
                           ln_sucursal  in number,
                           pd_fecpro    in date,
                           pn_tasa      out number) is
    -- *****************************************************************
    -- Nombre                     : Sp_cr_Inicio
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.20
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_poten ( VALOR DE POTENCIAL UN VALOR ENTRE 1 Y 5 )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
  
    ln_defn  number(17, 2);
    ln_cont  number(5) := 0;
    ln_tas   number(10, 6);
    ln_mtt   number(17, 2);
    ln_fde   date;
    ln_tat   number(7, 4);
    ln_cont2 number(5) := 0;
    ln_tvmpo number(7, 4);
    ln_porc  number(4) := 100;
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
  begin
  
    --obtiene pizarra
    begin
      select Pp028DefN
        into ln_defn
        from fpp028
       where Pp010Prd = 1
         and Pp017Par = 17
         and Pp028Mod = LN_XWFMODULO
         and Pp028Mda = ln_moneda
         and Pp028Pap = ln_papel
         and Pp028Top = LN_XWFTIPOPE;
    exception
      when others then
        null;
    end;
  
    for i in tasa(ln_defn,
                  LN_XWFMODULO,
                  ln_moneda,
                  ln_papel,
                  LN_XWFMONTO1,
                  LN_XWFPLAZO1,
                  pd_fecpro) loop
    
      ln_tas  := i.Tatasa;
      ln_mtt  := i.Tamto;
      ln_fde  := i.Tafdes;
      ln_tat  := i.Tatol;
      ln_cont := ln_cont + 1;
    
      if ln_cont > 0 then
        exit;
      end if;
    
    end loop;
  
    for j in region(ln_sucursal) loop
      for k in tasa_esp(LN_XWFMODULO,
                        ln_defn,
                        ln_papel,
                        ln_moneda,
                        ln_mtt, --MOD@ABR 20171018
                        j.regcod,
                        pd_fecpro) loop
      
        ln_tvmpo := k.TvMPorc - ln_porc;
        ln_cont2 := ln_cont2 + 1;
      
        if ln_cont2 > 0 then
          exit;
        end if;
      
      end loop;
    end loop;
  
    pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
  
  end sp_cr_tasatarf;
  --------------------------------------------------------------------- 

  Procedure SP_CR_TASA_POTEN_LINEA2(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_plazo  in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA_POTEN_LINEA2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.07.07
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA + POTENCIALIDAD POR PLAZO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais  (PAIS)
    --                            : pn_tipdoc  (TIPO DE DOCUMENTO)
    --                            : pn_numdoc  (NUMERO DE DOCUMENTO)
    --                            : pn_modulo  (MODULO )
    --                            : pn_moneda  (MONEDA)
    --                            : pn_papel  (PAPEL)
    --                            : pn_sucur  (SUCURSAL)
    --                            : pn_tipope  (TIPO DE OPERACION)                       
    --                            : pn_plazo  (PLAZO)
    --                            : pn_monto  (MONTO)
    --
    -- Parámetros de Salida       : pn_tasaf out  (TASA OBTENIDA)
    --                            : pc_coderr out  (CODIGO DEL ERROR)
    --                            : pv_deserr out (DESCRIPCION ERROR)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2023.07.07 YYAMPI SE TOMA LA ULTIMA FECHA DE LAS CURVAS POTENCIALIDAD
    --  
    -- *****************************************************************                       
  
    LN_XWFMONTO1   NUMBER(17, 2) := 0;
    LN_XWFPLAZO1   NUMBER(5) := 0;
    LN_XWFTIPOPE   NUMBER(3) := 0;
    LN_XWFMODULO   NUMBER(3) := 0;
    LN_XWFSUCURSAL NUMBER(3) := 0;
    LN_XWFMONEDA   NUMBER(3) := 0;
    LN_XWFPAPEL    NUMBER(3) := 0;
  
    LN_SNG001PAIS NUMBER(3) := 0;
    LN_SNG001TDOC NUMBER(3) := 0;
    LC_SNG001NDOC CHAR(12) := '';
    ln_monto      NUMBER(17, 2) := 0;
    ld_fecfinmes  date;
    ln_poten      number(5) := 0;
    ln_plazo      number(5) := 0;
    ln_jaqn31cur  number(10, 6) := 0;
    ln_tasaO      number(10, 6) := 0;
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*CALCULO DE DATOS DE CLIENTE*/
    /*BEGIN 
     select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
     INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
       from SNG001 T
      WHERE T.SNG001INST = pn_instancia
        ;
    EXCEPTION WHEN OTHERS THEN
      LN_SNG001PAIS :=0;
      LN_SNG001TDOC :=0;
      LC_SNG001NDOC :='';
      
    END;*/
  
    /*CALCULO DE DATOS DE CREDITO*/
    /*BEGIN 
     select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
     INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
       from XWF700 T
      WHERE T.XWFPRCINS = pn_instancia
        AND T.XWFCAR3 = '1';
    EXCEPTION WHEN OTHERS THEN
      LN_XWFMONTO1 :=0;
      LN_XWFPLAZO1 :=0;
      LN_XWFTIPOPE :=0;
      LN_XWFMODULO :=0;     
    END;*/
  
    /*Seteo de variables*/
    begin
      LN_SNG001PAIS  := pn_pais;
      LN_SNG001TDOC  := pn_tipdoc;
      LC_SNG001NDOC  := pn_numdoc;
      LN_XWFMONTO1   := pn_monto;
      LN_XWFPLAZO1   := pn_plazo; --pn_frecu * pn_cuotas; --pn_plazo;
      LN_XWFTIPOPE   := pn_tipope;
      LN_XWFMODULO   := pn_modulo;
      LN_XWFSUCURSAL := pn_sucur;
      LN_XWFMONEDA   := pn_moneda;
      LN_XWFPAPEL    := pn_papel;
    exception
      when others then
        pc_coderr := '00005';
    end;
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
    
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
              --into ln_monto
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00001'; --  
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124
              --into ln_plazo
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00002'; -- 
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      /*select j.jaqn31cur
       into ln_jaqn31cur
       from jaqn31 j
      where j.jaqn31mod = LN_XWFMODULO --
        and j.jaqn31top = LN_XWFTIPOPE
        and j.jaqn31tcu = 500 + ln_poten
        and j.JAQN31MTO = ln_monto
        and j.jaqn31pla = ln_plazo;*/
    
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi) /* 07/07/2023 yyampi se considero la ultima fecha de parametrizacion*/
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00003'; --  
    END;
  
    --retorna tasa final 
    begin
    
      pq_cr_tasatarifario_nuevo.Sp_cr_Inicio_linea(pn_mod    => LN_XWFMODULO,
                                                   pn_suc    => LN_XWFSUCURSAL,
                                                   pn_mda    => LN_XWFMONEDA,
                                                   pn_pap    => LN_XWFPAPEL,
                                                   pn_top    => LN_XWFTIPOPE,
                                                   pn_mto    => LN_XWFMONTO1,
                                                   pn_pzo    => LN_XWFPLAZO1,
                                                   pd_fecpro => pd_fecha,
                                                   pn_tasa   => ln_tasaO);
    
      pn_tasaf  := ln_tasaO + ln_jaqn31cur;
      pc_coderr := '00000';
    
    exception
      when others then
        pn_tasaf  := 0;
        pc_coderr := '00004';
    end;
  
    /*calcula cuota*/
    begin
      pn_cuotaf := 0; /*round((LN_XWFMONTO1 *
                                                                             ((power((1 + (pn_tasaf / 100)), (1 / 12))) - 1)) /
                                                                             (1 - power((1 + ((power((1 + (pn_tasaf / 100)),
                                                                                                     (1 / 12))) - 1)),
                                                                                        -pn_cuotas)),
                                                                             2);*/
      pc_coderr := '00000';
    exception
      when others then
        pn_cuotaf := 0;
        pc_coderr := '00006';
    end;
  
    /*codificacion de errores*/
    if pc_coderr = '00000' then
      pv_deserr := 'Ok';
    else
      if pc_coderr = '00001' then
        pv_deserr := 'Error en el monto';
      else
        if pc_coderr = '00002' then
          pv_deserr := 'Error en el plazo';
        else
          if pc_coderr = '00003' then
            pv_deserr := 'Error en la curva potencial';
          else
            if pc_coderr = '00004' then
              pv_deserr := 'Error en calculo de tasa';
            else
              if pc_coderr = '00005' then
                pv_deserr := 'Error en parametros de entrada';
              else
                if pc_coderr = '00006' then
                  pv_deserr := 'Error en calculo de cuota';
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      --pv_deserr := 'Error en el calculo';   
    end if;
  
  END SP_CR_TASA_POTEN_LINEA2;
  ------------------------------------------------------------------------------- 

  Procedure SP_CR_TASA_POTEN_LINEA3(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_frecu  in number,
                                    pn_cuotas in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pn_tasao  out number,
                                    pn_curpot out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA_POTEN_LINEA3
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA + POTENCIALIDAD
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais  (PAIS)
    --                            : pn_tipdoc  (TIPO DE DOCUMENTO)
    --                            : pn_numdoc  (NUMERO DE DOCUMENTO)
    --                            : pn_modulo  (MODULO )
    --                            : pn_moneda  (MONEDA)
    --                            : pn_papel  (PAPEL)
    --                            : pn_sucur  (SUCURSAL)
    --                            : pn_tipope  (TIPO DE OPERACION)                       
    --                            : pn_plazo  (PLAZO)
    --                            : pn_monto  (MONTO)
    --
    -- Parámetros de Salida       : pn_tasaf out  (TASA OBTENIDA)
    --                              pn_cuotaf (CUOTA FINAL)
    --                              pn_tasao  (TASA ORIGEN)
    --                              pn_curpot (CURVA POTENCIALIDAD)                               
    --                            : pc_coderr out  (CODIGO DEL ERROR)
    --                            : pv_deserr out (DESCRIPCION ERROR)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************                       
  
    LN_XWFMONTO1   NUMBER(17, 2) := 0;
    LN_XWFPLAZO1   NUMBER(5) := 0;
    LN_XWFTIPOPE   NUMBER(3) := 0;
    LN_XWFMODULO   NUMBER(3) := 0;
    LN_XWFSUCURSAL NUMBER(3) := 0;
    LN_XWFMONEDA   NUMBER(3) := 0;
    LN_XWFPAPEL    NUMBER(3) := 0;
  
    LN_SNG001PAIS NUMBER(3) := 0;
    LN_SNG001TDOC NUMBER(3) := 0;
    LC_SNG001NDOC CHAR(12) := '';
    ln_monto      NUMBER(17, 2) := 0;
    ld_fecfinmes  date;
    ln_poten      number(5) := 0;
    ln_plazo      number(5) := 0;
    ln_jaqn31cur  number(10, 6) := 0;
    ln_tasaO      number(10, 6) := 0;
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*CALCULO DE DATOS DE CLIENTE*/
    /*BEGIN 
     select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
     INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
       from SNG001 T
      WHERE T.SNG001INST = pn_instancia
        ;
    EXCEPTION WHEN OTHERS THEN
      LN_SNG001PAIS :=0;
      LN_SNG001TDOC :=0;
      LC_SNG001NDOC :='';
      
    END;*/
  
    /*CALCULO DE DATOS DE CREDITO*/
    /*BEGIN 
     select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
     INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
       from XWF700 T
      WHERE T.XWFPRCINS = pn_instancia
        AND T.XWFCAR3 = '1';
    EXCEPTION WHEN OTHERS THEN
      LN_XWFMONTO1 :=0;
      LN_XWFPLAZO1 :=0;
      LN_XWFTIPOPE :=0;
      LN_XWFMODULO :=0;     
    END;*/
  
    /*Seteo de variables*/
    begin
      LN_SNG001PAIS  := pn_pais;
      LN_SNG001TDOC  := pn_tipdoc;
      LC_SNG001NDOC  := pn_numdoc;
      LN_XWFMONTO1   := pn_monto;
      LN_XWFPLAZO1   := pn_frecu * pn_cuotas; --pn_plazo;
      LN_XWFTIPOPE   := pn_tipope;
      LN_XWFMODULO   := pn_modulo;
      LN_XWFSUCURSAL := pn_sucur;
      LN_XWFMONEDA   := pn_moneda;
      LN_XWFPAPEL    := pn_papel;
    exception
      when others then
        pc_coderr := '00005';
    end;
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
    
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
              --into ln_monto
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00001'; --  
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124
              --into ln_plazo
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00002'; -- 
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      /*select j.jaqn31cur
       into ln_jaqn31cur
       from jaqn31 j
      where j.jaqn31mod = LN_XWFMODULO --
        and j.jaqn31top = LN_XWFTIPOPE
        and j.jaqn31tcu = 500 + ln_poten
        and j.JAQN31MTO = ln_monto
        and j.jaqn31pla = ln_plazo;*/
    
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi) /* 07/07/2023 yyampi se considero la ultima fecha de parametrizacion*/
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00003'; --  
    END;
  
    --retorna tasa final 
    begin
    
      pq_cr_tasatarifario_nuevo.Sp_cr_Inicio_linea(pn_mod    => LN_XWFMODULO,
                                                   pn_suc    => LN_XWFSUCURSAL,
                                                   pn_mda    => LN_XWFMONEDA,
                                                   pn_pap    => LN_XWFPAPEL,
                                                   pn_top    => LN_XWFTIPOPE,
                                                   pn_mto    => LN_XWFMONTO1,
                                                   pn_pzo    => LN_XWFPLAZO1,
                                                   pd_fecpro => pd_fecha,
                                                   pn_tasa   => ln_tasaO);
    
      pn_tasaf  := ln_tasaO + ln_jaqn31cur;
      pc_coderr := '00000';
      pn_tasao  := ln_tasaO; --se agrego 
      pn_curpot := ln_jaqn31cur; --se agrego 
    
    exception
      when others then
        pn_tasaf  := 0;
        pc_coderr := '00004';
    end;
  
    /*calcula cuota*/
    begin
      pn_cuotaf := round((LN_XWFMONTO1 *
                         ((power((1 + (pn_tasaf / 100)), (1 / 12))) - 1)) /
                         (1 - power((1 + ((power((1 + (pn_tasaf / 100)),
                                                 (1 / 12))) - 1)),
                                    -pn_cuotas)),
                         2);
      pc_coderr := '00000';
    exception
      when others then
        pn_cuotaf := 0;
        pc_coderr := '00006';
    end;
  
    /*codificacion de errores*/
    if pc_coderr = '00000' then
      pv_deserr := 'Ok';
    else
      if pc_coderr = '00001' then
        pv_deserr := 'Error en el monto';
      else
        if pc_coderr = '00002' then
          pv_deserr := 'Error en el plazo';
        else
          if pc_coderr = '00003' then
            pv_deserr := 'Error en la curva potencial';
          else
            if pc_coderr = '00004' then
              pv_deserr := 'Error en calculo de tasa';
            else
              if pc_coderr = '00005' then
                pv_deserr := 'Error en parametros de entrada';
              else
                if pc_coderr = '00006' then
                  pv_deserr := 'Error en calculo de cuota';
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      --pv_deserr := 'Error en el calculo';   
    end if;
  
  END SP_CR_TASA_POTEN_LINEA3;

  -------------------------------------------------------------------------------

  PROCEDURE SP_CR_FACTOR_SCORE(pd_fecpro in date,
                               pn_pgpais in number,
                               pn_tipdoc in number,
                               pc_numdoc in char,
                               pn_modulo in number,
                               pn_tipope in number,
                               pv_score  out varchar,
                               pn_result out number) is
  
    -- *****************************************************************
    -- Nombre                     : FACTOR_SCORE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.02.23
    -- Autor de Creación          : YYAMPI
    -- Uso                        : RETORNA VALOR FACTOR DE AJUSTE SCORE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecpro ( FECHA DE PROCESO )
    --                            : pn_pgpais ( PAIS CLIENTE )
    --                            : pn_tipdoc ( TIPO DE DOCUMENTO  )
    --                            : pc_numdoc ( NUMERO DE DOCUMENTO )
    --                            : pn_modulo ( MODULO )
    --                            : pn_tipope ( TIPO DE OPERACION )
    --
    -- Parámetros de Salida       : pn_result ( FACTOR RESULTADO)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 2024.01.27 YYAMPI Se limpio la variable de numero de documento
    --  
    -- *****************************************************************
    lc_score      varchar2(15);
    ln_probal     number;
    lc_SegmRiesgo varchar2(15);
    ln_PDCal      number;
    lc_tabla      varchar2(15);
    ld_fchscore   date;
    lc_scoreabr   varchar2(15);
    lc_NewScore   varchar2(30);
  
  begin
  
    --obteniendo score de riesgos
    begin
      PQ_CR_SCORE_RCC.sp_cr_scoreDNI_II(ln_inst       => 0, -- VE - Nro de Instancia, si no hay, enviar 0
                                        ln_tdoc       => pn_tipdoc, -- VE - tipo de documento
                                        lc_ndoc       => trim(pc_numdoc), -- VE - nro de documento --2025.01.27 yyampi se limpia la variable 
                                        lc_prgm       => 'TARIFARIO', -- VE - Nombre del Programa para identificarlo en la tabla log AQPB166
                                        lc_user       => 'TASA', -- VE - Usuario
                                        lc_score      => lc_score, -- VS - Score Riesgo F
                                        ln_probal     => ln_probal, -- VS - Probabilidad
                                        lc_SegmRiesgo => lc_SegmRiesgo, -- VS - Segmentacion Riesgo
                                        ln_PDCal      => ln_PDCal, -- VS - PD
                                        lc_tabla      => lc_tabla, -- VS - Tabla Score JAQL640 o JAQL639
                                        ld_fchscore   => ld_fchscore, -- VS - Fecha del Score
                                        lc_scoreabr   => lc_scoreabr, -- VS - Score Abreviado F
                                        lc_NewScore   => lc_NewScore); -- VS - Nuevo Score MEMO16 POTENCIAL
    
      lc_scoreabr := nvl(lc_scoreabr, 0);
      pv_score    := lc_scoreabr;
    exception
      when others then
        pv_score := '0';
    end;
  
    --obteniendo el porcentaje
    begin
      select a.aqpb282por
        into pn_result
        from AQPB282 a
       where a.aqpb282mod = pn_modulo
         and a.aqpb282top = pn_tipope
         and a.aqpb282sco = lc_scoreabr
         and a.aqpb282tip = 'S'
         and a.aqpb282est = 'S';
    exception
      when others then
        pn_result := 0.000;
    end;
  
  exception
    when others then
      pn_result := 0.000;
    
  end SP_CR_FACTOR_SCORE;

  -------------------------------------------------------------------------------
  Procedure SP_CR_TASA_POTEN_LINEA4(pd_fecha  in date,
                                    pn_pais   in number,
                                    pn_tipdoc in number,
                                    pn_numdoc in char,
                                    pn_modulo in number,
                                    pn_moneda in number,
                                    pn_papel  in number,
                                    pn_sucur  in number,
                                    pn_tipope in number,
                                    pn_monto  in number,
                                    pn_frecu  in number,
                                    pn_cuotas in number,
                                    pn_tasaf  out number,
                                    pn_cuotaf out number,
                                    pn_tasao  out number,
                                    pn_curpot out number,
                                    pv_score  out varchar2,
                                    pn_ajusc  out number,
                                    pc_coderr out char,
                                    pv_deserr out varchar) is
  
    -- *****************************************************************
    -- Nombre                     : SP_CR_TASA_POTEN_LINEA4
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.10.21
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL VALOR DE LA TASA + POTENCIALIDAD + SCORE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --                            : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais  (PAIS)
    --                            : pn_tipdoc  (TIPO DE DOCUMENTO)
    --                            : pn_numdoc  (NUMERO DE DOCUMENTO)
    --                            : pn_modulo  (MODULO )
    --                            : pn_moneda  (MONEDA)
    --                            : pn_papel  (PAPEL)
    --                            : pn_sucur  (SUCURSAL)
    --                            : pn_tipope  (TIPO DE OPERACION)                       
    --                            : pn_plazo  (PLAZO)
    --                            : pn_monto  (MONTO)
    --
    -- Parámetros de Salida       : pn_tasaf out  (TASA OBTENIDA)
    --                              pn_cuotaf (CUOTA FINAL)
    --                              pn_tasao  (TASA ORIGEN)
    --                              pn_curpot (CURVA POTENCIALIDAD)                               
    --                            : pc_coderr out  (CODIGO DEL ERROR)
    --                            : pv_deserr out (DESCRIPCION ERROR)
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************                       
  
    LN_XWFMONTO1   NUMBER(17, 2) := 0;
    LN_XWFPLAZO1   NUMBER(5) := 0;
    LN_XWFTIPOPE   NUMBER(3) := 0;
    LN_XWFMODULO   NUMBER(3) := 0;
    LN_XWFSUCURSAL NUMBER(3) := 0;
    LN_XWFMONEDA   NUMBER(3) := 0;
    LN_XWFPAPEL    NUMBER(3) := 0;
  
    LN_SNG001PAIS NUMBER(3) := 0;
    LN_SNG001TDOC NUMBER(3) := 0;
    LC_SNG001NDOC CHAR(12) := '';
    ln_monto      NUMBER(17, 2) := 0;
    ld_fecfinmes  date;
    ln_poten      number(5) := 0;
    ln_plazo      number(5) := 0;
    ln_jaqn31cur  number(10, 6) := 0;
    ln_tasaO      number(10, 6) := 0;
    lv_score      varchar2(15) := '';
    ln_score      number(10, 6) := 0;
  BEGIN
  
    /*CALCULO DE FIN DE MES ANTERIOR*/
    BEGIN
      ld_fecfinmes := LAST_DAY(ADD_MONTHS(pd_fecha, -1));
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    /*CALCULO DE DATOS DE CLIENTE*/
    /*BEGIN 
     select T.SNG001PAIS, T.SNG001TDOC, T.SNG001NDOC
     INTO LN_SNG001PAIS, LN_SNG001TDOC, LC_SNG001NDOC
       from SNG001 T
      WHERE T.SNG001INST = pn_instancia
        ;
    EXCEPTION WHEN OTHERS THEN
      LN_SNG001PAIS :=0;
      LN_SNG001TDOC :=0;
      LC_SNG001NDOC :='';
      
    END;*/
  
    /*CALCULO DE DATOS DE CREDITO*/
    /*BEGIN 
     select T.XWFMONTO1, T.XWFPLAZO1, T.XWFTIPOPE, T.XWFMODULO
     INTO LN_XWFMONTO1, LN_XWFPLAZO1, LN_XWFTIPOPE, LN_XWFMODULO
       from XWF700 T
      WHERE T.XWFPRCINS = pn_instancia
        AND T.XWFCAR3 = '1';
    EXCEPTION WHEN OTHERS THEN
      LN_XWFMONTO1 :=0;
      LN_XWFPLAZO1 :=0;
      LN_XWFTIPOPE :=0;
      LN_XWFMODULO :=0;     
    END;*/
  
    /*Seteo de variables*/
    begin
      LN_SNG001PAIS  := pn_pais;
      LN_SNG001TDOC  := pn_tipdoc;
      LC_SNG001NDOC  := pn_numdoc;
      LN_XWFMONTO1   := pn_monto;
      LN_XWFPLAZO1   := pn_frecu * pn_cuotas; --pn_plazo;
      LN_XWFTIPOPE   := pn_tipope;
      LN_XWFMODULO   := pn_modulo;
      LN_XWFSUCURSAL := pn_sucur;
      LN_XWFMONEDA   := pn_moneda;
      LN_XWFPAPEL    := pn_papel;
    exception
      when others then
        pc_coderr := '00005';
    end;
  
    /*CALCULO DE POTENCIALIDAD*/
    BEGIN
    
      PQ_CR_POTENCIAL_PYME.sp_potencial_cliente(pd_fecha => ld_fecfinmes,
                                                pn_pais  => LN_SNG001PAIS,
                                                pn_tdoc  => LN_SNG001TDOC,
                                                pc_ndoc  => LC_SNG001NDOC,
                                                pn_poten => ln_poten);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        ln_poten := 5; --muy bajo 
    END;
  
    ---maximo monto menor o igual al monto evaluado
    BEGIN
      select min(j.jaqn31mto)
        into ln_monto
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO >= LN_XWFMONTO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi)
              --into ln_monto
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.JAQN31MTO >= LN_XWFMONTO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00001'; --  
    END;
  
    ---maximo plazo menor  o igual al plazo evaluado
    BEGIN
      select min(j.jaqn31pla) ---1124
        into ln_plazo
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.jaqn31pla >= LN_XWFPLAZO1
         and j.jaqn31fvi in
             (select max(f.jaqn31fvi) ---1124
              --into ln_plazo
                from jaqn31 f
               where f.jaqn31mod = LN_XWFMODULO --
                 and f.jaqn31top = LN_XWFTIPOPE
                 and f.jaqn31tcu = 500 + ln_poten
                 and f.jaqn31pla >= LN_XWFPLAZO1);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00002'; -- 
    END;
  
    -- retorna valor pontencialidad
    BEGIN
      /*select j.jaqn31cur
       into ln_jaqn31cur
       from jaqn31 j
      where j.jaqn31mod = LN_XWFMODULO --
        and j.jaqn31top = LN_XWFTIPOPE
        and j.jaqn31tcu = 500 + ln_poten
        and j.JAQN31MTO = ln_monto
        and j.jaqn31pla = ln_plazo;*/
    
      select j.jaqn31cur
        into ln_jaqn31cur
        from jaqn31 j
       where j.jaqn31mod = LN_XWFMODULO --
         and j.jaqn31top = LN_XWFTIPOPE
         and j.jaqn31tcu = 500 + ln_poten
         and j.JAQN31MTO = ln_monto
         and j.jaqn31pla = ln_plazo
         and j.jaqn31fvi in (select max(f.jaqn31fvi) /* 07/07/2023 yyampi se considero la ultima fecha de parametrizacion*/
                               from jaqn31 f
                              where f.jaqn31mod = LN_XWFMODULO --
                                and f.jaqn31top = LN_XWFTIPOPE
                                and f.jaqn31tcu = 500 + ln_poten
                                and f.JAQN31MTO = ln_monto
                                and f.jaqn31pla = ln_plazo);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
        pc_coderr := '00003'; --  
    END;
  
    --retorna score
    begin
      SP_CR_FACTOR_SCORE(pd_fecpro => pd_fecha,
                         pn_pgpais => LN_SNG001PAIS,
                         pn_tipdoc => LN_SNG001TDOC,
                         pc_numdoc => LC_SNG001NDOC,
                         pn_modulo => LN_XWFMODULO,
                         pn_tipope => LN_XWFTIPOPE,
                         pv_score  => lv_score,
                         pn_result => ln_score);
    
      pv_score := lv_score;
      pn_ajusc := ln_score;
    
    exception
      when others then
        pv_score  := 0;
        pn_ajusc  := 0;
        pc_coderr := '00007'; --  
    
    end;
  
    --retorna tasa final 
    begin
    
      pq_cr_tasatarifario_nuevo.Sp_cr_Inicio_linea(pn_mod    => LN_XWFMODULO,
                                                   pn_suc    => LN_XWFSUCURSAL,
                                                   pn_mda    => LN_XWFMONEDA,
                                                   pn_pap    => LN_XWFPAPEL,
                                                   pn_top    => LN_XWFTIPOPE,
                                                   pn_mto    => LN_XWFMONTO1,
                                                   pn_pzo    => LN_XWFPLAZO1,
                                                   pd_fecpro => pd_fecha,
                                                   pn_tasa   => ln_tasaO);
    
      pn_tasaf  := ln_tasaO + ln_jaqn31cur + ln_score;
      pc_coderr := '00000';
      pn_tasao  := ln_tasaO; --se agrego 
      pn_curpot := ln_jaqn31cur; --se agrego 
    
    exception
      when others then
        pn_tasaf  := 0;
        pc_coderr := '00004';
    end;
  
    /*calcula cuota*/
    begin
      pn_cuotaf := round((LN_XWFMONTO1 *
                         ((power((1 + (pn_tasaf / 100)), (1 / 12))) - 1)) /
                         (1 - power((1 + ((power((1 + (pn_tasaf / 100)),
                                                 (1 / 12))) - 1)),
                                    -pn_cuotas)),
                         2);
      pc_coderr := '00000';
    exception
      when others then
        pn_cuotaf := 0;
        pc_coderr := '00006';
    end;
  
    /*codificacion de errores*/
    if pc_coderr = '00000' then
      pv_deserr := 'Ok';
    else
      if pc_coderr = '00001' then
        pv_deserr := 'Error en el monto';
      else
        if pc_coderr = '00002' then
          pv_deserr := 'Error en el plazo';
        else
          if pc_coderr = '00003' then
            pv_deserr := 'Error en la curva potencial';
          else
            if pc_coderr = '00004' then
              pv_deserr := 'Error en calculo de tasa';
            else
              if pc_coderr = '00005' then
                pv_deserr := 'Error en parametros de entrada';
              else
                if pc_coderr = '00006' then
                  pv_deserr := 'Error en calculo de cuota';
                else
                  if pc_coderr = '00007' then
                    pv_deserr := 'Error en score';
                  end if;
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
      --pv_deserr := 'Error en el calculo';   
    end if;
  
  END SP_CR_TASA_POTEN_LINEA4;

-------------------------------------------------------------------------------

end PQ_CR_TASATARIFARIO_NUEVO;
/

