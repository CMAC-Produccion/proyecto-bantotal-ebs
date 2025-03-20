create or replace package PQ_CR_VAR_SEGMENTACION_CONG_RP is

  -- Author  : APACHECOH
  -- Created : 15/02/2023 13:00:57
  -- Purpose : 
  procedure sp_cr_clave_credito(ve_instancia in int,
                                vo_pgcod     out xwf700.xwfempresa%type,
                                vo_aomod     out xwf700.xwfmodulo%type,
                                vo_aosuc     out xwf700.xwfsucursal%type,
                                vo_aomda     out xwf700.xwfmoneda%type,
                                vo_aopap     out xwf700.xwfpapel%type,
                                vo_aocta     out xwf700.xwfcuenta%type,
                                vo_aooper    out xwf700.xwfoperacion%type,
                                vo_aosbop    out xwf700.xwfsubope%type,
                                vo_aotope    out xwf700.xwftipope%type,
                                vo_rpta      out varchar2);

  procedure sp_cr_variables_cong(vi_npais    in number,
                                 vi_ntdoc    in number,
                                 vi_vndoc    in varchar2,
                                 vi_tiposegm in number,
                                 vo_datraso  out number,
                                 vo_califi   out number,
                                 vo_califi2  out number);

  procedure sp_cr_variables_cong(vi_instancia in number,
                                 vi_tiposegm  in number,
                                 vo_datraso   out number,
                                 vo_califi    out number,
                                 vo_califi2   out number);

  procedure sp_cr_calif_micro(vi_npais  in number,
                              vi_ntdoc  in number,
                              vi_vndoc  in varchar2,
                              vo_califi out number);

  /*procedure sp_cr_calificacion_cong_o(vi_instancia in number,
  vo_califi    out number);*/

  function fn_equivalenviaDoc(p_tdoc in number) return varchar2;

end PQ_CR_VAR_SEGMENTACION_CONG_RP;
/

create or replace package body PQ_CR_VAR_SEGMENTACION_CONG_RP is

  procedure sp_cr_clave_credito(ve_instancia in int,
                                vo_pgcod     out xwf700.xwfempresa%type,
                                vo_aomod     out xwf700.xwfmodulo%type,
                                vo_aosuc     out xwf700.xwfsucursal%type,
                                vo_aomda     out xwf700.xwfmoneda%type,
                                vo_aopap     out xwf700.xwfpapel%type,
                                vo_aocta     out xwf700.xwfcuenta%type,
                                vo_aooper    out xwf700.xwfoperacion%type,
                                vo_aosbop    out xwf700.xwfsubope%type,
                                vo_aotope    out xwf700.xwftipope%type,
                                vo_rpta      out varchar2) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2021.12.20
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Hallar la clave del crédito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_instancia ( Instancia )
    -- Parámetros de Salida       : vo_rpta ( Resultado S/N )    
    --                              vo_pgcod ( Codigo Empresa )
    --                              vo_aomod ( Modulo )
    --                              vo_aosuc ( Sucursal )
    --                              vo_aomda ( Moneda )
    --                              vo_aopap ( Papel )
    --                              vo_aocta ( Cuenta )
    --                              vo_aooper ( Operacion )
    --                              vo_aosbop ( Sub Operacion )
    --                              vo_aotope ( Tipo Operacion )
    -- ******************************************************************
  BEGIN
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vo_pgcod,
             vo_aomod,
             vo_aosuc,
             vo_aomda,
             vo_aopap,
             vo_aocta,
             vo_aooper,
             vo_aosbop,
             vo_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
      vo_rpta := 'S';
    EXCEPTION
      when others then
        vo_rpta := 'N';
    END;
  END;

  procedure sp_cr_variables_cong(vi_npais    in number,
                                 vi_ntdoc    in number,
                                 vi_vndoc    in varchar2,
                                 vi_tiposegm in number,
                                 vo_datraso  out number,
                                 vo_califi   out number,
                                 vo_califi2  out number) is
  
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.15
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor para obtener el valor de dias atraso / calificacion congelado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_npais ( Pais )
    --                            : vi_ntdoc ( Tipo de documento )
    --                            : vi_vndoc ( Numero de documento )
    -- Parámetros de Salida       : vo_datraso ( Dias de Atraso )   
    --                            : vo_califi ( Calificacion 6 )    
    --                            : vo_califi2 ( Calificacion 12 )      
    -- ******************************************************************
    pn_cod  xwf700.xwfempresa%type;
    pn_mod  xwf700.xwfmodulo%type;
    pn_suc  xwf700.xwfsucursal%type;
    pn_mda  xwf700.xwfmoneda%type;
    pn_pap  xwf700.xwfpapel%type;
    pn_cta  xwf700.xwfcuenta%type;
    pn_oper xwf700.xwfoperacion%type;
    pn_sbop xwf700.xwfsubope%type;
    pn_tope xwf700.xwftipope%type;
    pv_rpta varchar2(2);
  
    ln_pais number(5);
    ln_tdoc number(5);
    lv_ndoc varchar2(12);
  
    lv_variable varchar2(30);
  
    ln_codsegmento number(10);
    ld_feafecta    date;
    lo_datraso     number(17,6);
  begin
    /*begin
      pQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(vi_instancia,
                                                 ln_codsegmento);
    exception
      when others then
        ln_codsegmento := 0;
    end;*/
    --Obtener la fecha de corte de afectación acorde a guía
    begin
      select to_date(tp1desc, 'dd/mm/rrrr')
        into ld_feafecta
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10823
         and tp1corr1 = 55
         and tp1corr2 = 4
         and tp1corr3 = 1;
    exception
      when others then
        ld_feafecta := to_date('30/11/2022', 'dd/mm/rrrr');
    end;
    --Obtener los dias de atraso
    vo_datraso := 0;
    vo_califi  := 0;
    vo_califi2 := 0;
    If vi_tiposegm = 3 then
      --&TipSeg = 'MICRO'
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ673VAR2, 12)), '999999.999999')
          into vo_datraso
          from jaqz673
         where jaqz673pais = vi_npais
           and jaqz673tdoc = vi_ntdoc
           and jaqz673ndoc = rpad(vi_vndoc, 12, ' ')
           and jaqz673fech = ld_feafecta; --micro mensual
      exception
        when others then
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ673VAR4, 18)), '999999.999999')
          into vo_califi
          from jaqz673
         where jaqz673pais = vi_npais
           and jaqz673tdoc = vi_ntdoc
           and jaqz673ndoc = rpad(vi_vndoc, 12, ' ')
           and jaqz673fech = ld_feafecta; --micro mensual
      exception
        when others then
          begin
             PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_calif_micro(vi_npais,vi_ntdoc,vi_vndoc,vo_califi);
          exception when others then
             vo_califi := -1;
          end;
      end;
    End If;
    If vi_tiposegm = 1 then
      --&TipSeg = 'PYME'  
      begin
        select TO_NUMBER(TRIM(SUBSTR(AQPC187VAR5, 14)), '999999.999999')
          into vo_datraso
          from aqpc187
         where aqpc187pais = vi_npais
           and aqpc187tdoc = vi_ntdoc
           and aqpc187ndoc = rpad(vi_vndoc, 12, ' ')
           and aqpc187fech = ld_feafecta; --pyme mensual 
      exception
        when others then
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(AQPC187VAR3, 20)), '999999.999999')
          into vo_califi
          from aqpc187
         where aqpc187pais = vi_npais
           and aqpc187tdoc = vi_ntdoc
           and aqpc187ndoc = rpad(vi_vndoc, 12, ' ')
           and aqpc187fech = ld_feafecta; --pyme mensual 
      exception
        when others then
          vo_califi := -1;
      end;
    End If;
    If vi_tiposegm = 2 then
      --&TipSeg = 'CONSUMO'
      begin
        select TO_NUMBER(SUBSTR(TRIM(JAQZ680VAR2), 16), '999999.999999')
          into vo_datraso
          from jaqz680
         where jaqz680pais = vi_npais
           and jaqz680tdoc = vi_ntdoc
           and jaqz680ndoc = rpad(vi_vndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual               
      exception
        when others then
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ680VAR13, 15)), '999999.999999')
          into vo_califi
          from jaqz680
         where jaqz680pais = vi_npais
           and jaqz680tdoc = vi_ntdoc
           and jaqz680ndoc = rpad(vi_vndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual 
      exception
        when others then
          vo_califi := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ680VAR14, 16)), '999999.99')
          into vo_califi2
          from jaqz680
         where jaqz680pais = vi_npais
           and jaqz680tdoc = vi_ntdoc
           and jaqz680ndoc = rpad(vi_vndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual 
      exception
        when others then
          vo_califi2 := -1;
      end;
    End If;
  end sp_cr_variables_cong;

  procedure sp_cr_variables_cong(vi_instancia in number,
                                 vi_tiposegm  in number,
                                 vo_datraso   out number,
                                 vo_califi    out number,
                                 vo_califi2   out number) is
  
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.15
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor para obtener el valor de dias atraso / calificacion congelado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_instancia ( Instancia )
    -- Parámetros de Salida       : vo_datraso ( Dias de Atraso )   
    --                            : vo_califi ( Calificacion 6 )    
    --                            : vo_califi2 ( Calificacion 12 )      
    -- ******************************************************************
    pn_cod  xwf700.xwfempresa%type;
    pn_mod  xwf700.xwfmodulo%type;
    pn_suc  xwf700.xwfsucursal%type;
    pn_mda  xwf700.xwfmoneda%type;
    pn_pap  xwf700.xwfpapel%type;
    pn_cta  xwf700.xwfcuenta%type;
    pn_oper xwf700.xwfoperacion%type;
    pn_sbop xwf700.xwfsubope%type;
    pn_tope xwf700.xwftipope%type;
    pv_rpta varchar2(2);
  
    ln_pais number(5);
    ln_tdoc number(5);
    lv_ndoc varchar2(12);
  
    lv_variable varchar2(30);
  
    ln_codsegmento number(10);
    ld_feafecta    date;
  begin
    /*begin
      pQ_CR_VERIFICASEGMENTO.sp_cr_SegmntoActual(vi_instancia,
                                                 ln_codsegmento);
    exception
      when others then
        ln_codsegmento := 0;
    end;*/
    /*begin
      PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_clave_credito(vi_instancia,
                                                         vo_pgcod     => pn_cod,
                                                         vo_aomod     => pn_mod,
                                                         vo_aosuc     => pn_suc,
                                                         vo_aomda     => pn_mda,
                                                         vo_aopap     => pn_pap,
                                                         vo_aocta     => pn_cta,
                                                         vo_aooper    => pn_oper,
                                                         vo_aosbop    => pn_sbop,
                                                         vo_aotope    => pn_tope,
                                                         vo_rpta      => pv_rpta);
    
    exception
      when others then
        null;
    end;*/
    --Obtener el documento a partir de la instancia
    begin
      select sng001pais, sng001tdoc, sng001ndoc
        into ln_pais, ln_tdoc, lv_ndoc
        from sng001
       where sng001inst = vi_instancia
         and rownum = 1;
    exception
      when others then
        null;
    end;
    --Obtener la fecha de corte de afectación acorde a guía
    begin
      select to_date(tp1desc, 'dd/mm/rrrr')
        into ld_feafecta
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10823
         and tp1corr1 = 55
         and tp1corr2 = 4
         and tp1corr3 = 1;
    exception
      when others then
        ld_feafecta := to_date('30/11/2022', 'dd/mm/rrrr');
    end;
    --Obtener los dias de atraso
    vo_datraso := 0;
    vo_califi  := 0;
    vo_califi2 := 0;
    If vi_tiposegm = 3 then
      --&TipSeg = 'MICRO'
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ673VAR2, 12)), '999999.999999')
          into vo_datraso
          from jaqz673
         where jaqz673pais = ln_pais
           and jaqz673tdoc = ln_tdoc
           and jaqz673ndoc = rpad(lv_ndoc, 12, ' ')
           and jaqz673fech = ld_feafecta; --micro mensual
      exception
        when others then         
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ673VAR4, 18)), '999999.999999')
          into vo_califi
          from jaqz673
         where jaqz673pais = ln_pais
           and jaqz673tdoc = ln_tdoc
           and jaqz673ndoc = rpad(lv_ndoc, 12, ' ')
           and jaqz673fech = ld_feafecta; --micro mensual
      exception
        when others then
          begin
             PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_calif_micro(ln_pais,ln_tdoc,ln_tdoc,vo_califi);
          exception when others then
             vo_califi := -1;
          end;
      end;
    End If;
    If vi_tiposegm = 1 then
      --&TipSeg = 'PYME'  
      begin
        select TO_NUMBER(TRIM(SUBSTR(AQPC187VAR5, 14)), '999999.999999')
          into vo_datraso
          from aqpc187
         where aqpc187pais = ln_pais
           and aqpc187tdoc = ln_tdoc
           and aqpc187ndoc = rpad(lv_ndoc, 12, ' ')
           and aqpc187fech = ld_feafecta; --pyme mensual 
      exception
        when others then
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(AQPC187VAR3, 20)), '999999.999999')
          into vo_califi
          from aqpc187
         where aqpc187pais = ln_pais
           and aqpc187tdoc = ln_tdoc
           and aqpc187ndoc = rpad(lv_ndoc, 12, ' ')
           and aqpc187fech = ld_feafecta; --pyme mensual 
      exception
        when others then
          vo_califi := -1;
      end;
    End If;
    If vi_tiposegm = 2 then
      --&TipSeg = 'CONSUMO'
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ680VAR2, 16)), '999999.999999')
          into vo_datraso
          from jaqz680
         where jaqz680pais = ln_pais
           and jaqz680tdoc = ln_tdoc
           and jaqz680ndoc = rpad(lv_ndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual               
      exception
        when others then
          vo_datraso := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ680VAR13, 15)), '999999.999999')
          into vo_califi
          from jaqz680
         where jaqz680pais = ln_pais
           and jaqz680tdoc = ln_tdoc
           and jaqz680ndoc = rpad(lv_ndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual 
      exception
        when others then
          vo_califi := -1;
      end;
      begin
        select TO_NUMBER(TRIM(SUBSTR(JAQZ680VAR14, 16)), '999999.99')
          into vo_califi2
          from jaqz680
         where jaqz680pais = ln_pais
           and jaqz680tdoc = ln_tdoc
           and jaqz680ndoc = rpad(lv_ndoc, 12, ' ')
           and jaqz680fech = ld_feafecta; --consumo mensual 
      exception
        when others then
          vo_califi2 := -1;
      end;
    End If;
  end sp_cr_variables_cong;

  /*procedure sp_cr_calificacion_cong_o(vi_instancia in number,
                                      vo_califi    out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.15
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Resolutor para obtener la calificacion congelada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_instancia ( Instancia )
    -- Parámetros de Salida       : vo_califi ( Porcentaje de calificacion )
    -- ******************************************************************
    pn_cod  xwf700.xwfempresa%type;
    pn_mod  xwf700.xwfmodulo%type;
    pn_suc  xwf700.xwfsucursal%type;
    pn_mda  xwf700.xwfmoneda%type;
    pn_pap  xwf700.xwfpapel%type;
    pn_cta  xwf700.xwfcuenta%type;
    pn_oper xwf700.xwfoperacion%type;
    pn_sbop xwf700.xwfsubope%type;
    pn_tope xwf700.xwftipope%type;    
    pv_rpta varchar2(2);
  
    ln_pais number(5);
    ln_tdoc number(5);   
    lv_ndoc varchar2(12);
    
    pn_tdoc number(5);
    
    ld_feafecta date;
    ln_suma number(17,2);
  begin
    begin
      PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_clave_credito(vi_instancia,
                                                         vo_pgcod     => pn_cod,
                                                         vo_aomod     => pn_mod,
                                                         vo_aosuc     => pn_suc,
                                                         vo_aomda     => pn_mda,
                                                         vo_aopap     => pn_pap,
                                                         vo_aocta     => pn_cta,
                                                         vo_aooper    => pn_oper,
                                                         vo_aosbop    => pn_sbop,
                                                         vo_aotope    => pn_tope,
                                                         vo_rpta      => pv_rpta);
    
    exception
      when others then
        null;
    end;
    --Obtener la fecha de corte de afectación acorde a guía
    begin
      select to_date(tp1desc, 'dd/mm/rrrr')
        into ld_feafecta
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10823
         and tp1corr1 = 55
         and tp1corr2 = 4
         and tp1corr3 = 1;
    exception
      when others then
        ld_feafecta := to_date('30/11/2022', 'dd/mm/rrrr');
    end;
    --buscar la calificacion normal del titular
    pn_tdoc := PQ_CR_VAR_SEGMENTACION_CONG_RP.fn_equivalenviaDoc(ln_tdoc);
    if ln_tdoc <> 9 then
      begin
        select N_CALIF0
          into vo_califi
          from cldrcci
         where d_fecpre = ld_feafecta
           and c_tdocid = pn_tdoc
           and c_docide = lv_ndoc;
      exception
        when others then
          vo_califi := 100;
      end;
      if vo_califi = 0 then
        begin
          select N_CALIF0 + N_CALIF1 + N_CALIF2 + N_CALIF3 + N_CALIF4
            into ln_suma
            from cldrcci
           where d_fecpre = ld_feafecta
             and c_tdocid = pn_tdoc
             and c_docide = lv_ndoc;
        exception
          when others then
            ln_suma := 0;
        end;
        if ln_suma = 0 then
          vo_califi := 100;
        end if;
      end if;
    else
      if ln_tdoc = 9 then
        begin
          select N_CALIF0
            into vo_califi
            from cldrcci
           where d_fecpre = ld_feafecta
             and c_tdoctr = pn_tdoc
             and c_doctri = lv_ndoc;
        exception
          when others then
            vo_califi := 100;
        end;
        if vo_califi = 0 then
          begin
            select N_CALIF0 + N_CALIF1 + N_CALIF2 + N_CALIF3 + N_CALIF4
              into ln_suma
              from cldrcci
             where d_fecpre = ld_feafecta
               and c_tdoctr = lv_ndoc
               and c_doctri = lv_ndoc;
          exception
            when others then
              ln_suma := 0;
          end;
          if ln_suma = 0 then
            vo_califi := 100;
          end if;
        end if;
      end if;
    end if;
  end sp_cr_calificacion_cong_o;*/

  procedure sp_cr_calif_micro(vi_npais  in number,
                              vi_ntdoc  in number,
                              vi_vndoc  in varchar2,
                              vo_califi out number) is
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.02.20
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtener la calificación de micro
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_npais ( Pais )
    --                            : vi_ntdoc ( Tipo de documento )
    --                            : vi_vndoc ( Numero de documento )
    -- Parámetros de Salida       : vo_califi ( Calificacion )         
    -- ******************************************************************
  
    DocSbs_Cyg   number(10);
    DocSbsCyg    char(1);
    DocSbs       number(10);
    DocSbsTit    char(1);
    lc_tiper_Cyg char(1);
  
    fecNum_rcc number(9);
    MesRcc     number(9);
    ln_Rpccyg  number(2);
    lc_tiper   char(1);
    fec_rcc    date;
    ln_paiC    number(3);
    ln_tdoC    number(2);
    lc_ndoC    char(12);
    lc_ndoc2   char(12);
    pn_cal     number(10, 2);
  begin
    --*******CALIFICACION_RCC********--------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = vi_ntdoc;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
    begin
      select tpnro
        into fecNum_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fecNum_rcc := null;
    end;
    fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
    end;
    --vinculo conyugue
    begin
      select a.tp1corr3
        into ln_Rpccyg
        from fst198 a
       where a.tp1cod = 1 --mod@abr 20190502 
         and a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 1;
    exception
      when no_data_found then
        ln_Rpccyg := null;
    end;
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = vi_npais
         and a.petdoc = vi_ntdoc
         and a.pendoc = rpad(vi_vndoc,12,' ');
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    pn_cal := 100.00;
    begin
      lc_ndoc2 := rpad(vi_vndoc,12,' ');
      pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsTit,
                                                         lc_ndoc2,
                                                         fec_rcc,
                                                         MesRcc,
                                                         lc_tiper);
    exception when others then
        pn_cal := -1;
    end;                                                   
    --evalua conyugue si la calificacion es normal para el titular
  
    begin
      select a.rppais, a.rptdoc, a.rpndoc
        into ln_paiC, ln_tdoC, lc_ndoC
        from fsr002 a
       where a.pepais = vi_npais
         and a.petdoc = vi_ntdoc
         and a.pendoc = rpad(vi_vndoc,12,' ')
         and a.rpccyg = ln_Rpccyg
         and rownum = 1;
    exception
      when no_data_found then
        ln_paiC := null;
        ln_tdoC := null;
        lc_ndoC := null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs_Cyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdoC;
    exception
      when no_data_found then
        DocSbs_Cyg := null;
    end;
    DocSbsCyg := Trim(to_char(DocSbs_Cyg));
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper_Cyg
        from fsd001 a
       where a.pepais = ln_paiC
         and a.petdoc = ln_tdoC
         and a.pendoc = lc_ndoC;
    exception
      when no_data_found then
        lc_tiper_Cyg := null;
    end;
  
    if pn_cal = 100.00 and lc_ndoC is not null then
      if lc_ndoC is null then
        begin
          insert into jaqz082_aux
            (jaqz082ndo, JAQZ082TPO)
          values
            (vi_vndoc, 'CYG');
          commit;
        exception
          when others then
            null;
        end;
      end if;
      begin
        pn_cal := pq_cr_segm_mens_nuev.Fn_calificacion_RCC(DocSbsCyg,
                                                           lc_ndoC,
                                                           fec_rcc,
                                                           MesRcc,
                                                           lc_tiper_Cyg);
      exception
        when others then
          pn_cal := -1;
      end;
    end if;
    vo_califi := pn_cal; --apachecoh 2023.02.20
  
  end sp_cr_calif_micro;

  function fn_equivalenviaDoc(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
    resp  number(5);
    respc varchar2(1);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end fn_equivalenviaDoc;

end PQ_CR_VAR_SEGMENTACION_CONG_RP;
/

