create or replace package PQ_AH_JAQL551 is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_AH_AHSOMSG
  -- Sistema               : SORFY
  -- Módulo                : TODOS LOS CANALES
  -- Versión               : 1.0
  -- Fecha de Creación     : 08/08/2011
  -- Autor de Creación     : Juan Andres Quintanilla Calderon
  -- Uso                   : Almacena los datos de bonificaciones de creditos y clientes del analista
  -- Estado                : Activo
  -- Acceso                : Público
  --                       :
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------
  Function fn_cr_asesor_clasi
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_saldo
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_tipo
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_anual_saldo
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_mes_saldo
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_anual_clie
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_mes_clie
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_capital_nuevo
  (
    P_IN_usuario IN char,
    P_IN_Fecha   IN Date,
    P_IN_tipcam IN number,
    P_IN_tipase IN char,
    P_IN_clase IN char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cred_metas
  (
    P_IN_meta   char,
    P_IN_tipase char,
    P_IN_tipage char
  ) return Number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_clie_metas
  (
    P_IN_Tipase IN char,
    P_IN_tipage IN char,
    P_IN_met    IN char
  ) return Number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_mora_metas
  (
    P_IN_Tipase IN char,
    P_IN_tipage IN char,
    P_IN_met    IN char
  ) return Number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia(P_IN_agen in number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia_metas
  (
    P_IN_agen  in number,
    P_IN_Fecha in date
  ) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_cali(P_IN_cliente IN Number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_credito_cali(P_IN_monto IN Number) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contmes_anterior(P_IN_USER IN char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contdias_anterior(P_IN_USER IN char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior
  (
    P_IN_Usuario IN char,
    P_IN_Fecha   IN date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior
  (
    P_IN_usuario IN char,
    P_IN_Fecha   IN date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipocambio(P_IN_Fecha date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_capital
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_judiciales
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    Function fn_cr_saldo_castigo
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Nrocli_acutal(P_IN_usuario char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Nrocli_nuevo(P_IN_usuario char,
                              P_IN_fecha date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codage(P_IN_usuario char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codase(P_IN_usuario char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_trasase
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_trasase_otor
  (
    P_IN_usuario char,
    P_IN_fecha date
  ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_otorgado
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_recibido
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_otorgado
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_recibido
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_ant_metas
  (
    P_IN_Usuario IN char,
    P_IN_Fecha   IN date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_otor_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_rec_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_act_metas(P_IN_usuario char /*, P_IN_fecha date*/)
    return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_otor_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_rec_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_ant_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_cli_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_sal_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crecimiento_mensual
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_creci_men_cli
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_mensual_metas
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_men_cli_metas
  (
    P_IN_Cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_men_mra_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_Tipase  IN char,
    P_IN_tipage  IN char,
    P_IN_met     IN char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_anual_saldo
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_mes_saldo
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_anual_saldo
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_meta    char,
    P_IN_tipase  char,
    P_IN_tipage  char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_men_saldo
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_meta    char,
    P_IN_tipase  char,
    P_IN_tipage  char
  ) return number;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_anual_cliente
  (
    P_IN_cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_men_cliente
  (
    P_IN_cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_anual_cliente
  (
    P_IN_cliente in number,
    P_IN_Usuario in char,
    P_IN_fecha   in date,
    P_IN_Tipase  in char,
    P_IN_tipage  in char,
    P_IN_met     in char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_men_cliente
  (
    P_IN_cliente in number,
    P_IN_usuario in char,
    P_IN_fecha   in date,
    P_IN_Tipase  in char,
    P_IN_tipage  in char,
    P_IN_met     in char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_cliente_nuevo
  (
    P_IN_Salcap  IN number,
    P_IN_clasase IN char,
    P_IN_Tipage  IN char
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_porcentaje_mora
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mora
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_dias_mora
  (
    P_IN_fecha In date,
    P_IN_PGCOD In number,
    P_IN_SCSUC In number,
    P_IN_SCMDA In number,
    P_IN_SCPAP In number,
    P_IN_SCCTA In number,
    P_IN_SCOPER In number,
    P_IN_SCSBOP In number,
    P_IN_SCTOPE In number,
    P_IN_SCMOD In number
  ) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    */
  Procedure sp_cr_bonificacion_analista(P_IN_Fecha IN date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_bonificacion_metas(P_IN_Fecha IN Date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_actualiza_bono(P_IN_Fecha Date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_act_bono_metas(P_IN_Fecha Date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_iniciar_productividad(P_IN_Fecha Date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_AH_JAQL551;
/

create or replace package body PQ_AH_JAQL551 is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  ---------------------------------------
  -- PRODUCTIVIDAD DE ANALISTAS DE CREDITOS --
  ---------------------------------------
  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_clasi
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_CLASI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta clasificacion de analista
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Asesor: Codigo de asesor,
    --                              P_IN_Fecha: Fecha de proceso
    -- Parámetros de Salida       : ln_salase: devuelve el saldo de asesor de acuerdo al tipo de clasificacion que pertenece
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_tipase  char(1); -- tipo de asesor C = consumo convenio y P = credito pyme
    ln_tipcam  fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    ln_salpyme number(18, 2);
    ln_salcons number(18, 2);

  begin

    begin
      -- Prestamo Consumo

      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_salcons
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD = 107
         and h.dscod = 50
         and s.SNG001ASE = P_IN_Asesor;

      If ln_salcons is null
      then
        ln_salcons := 0;
      End If;

      -- prestamos pymes

      select

       sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_salpyme
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD <> 107
         and h.dscod = 50
         and s.SNG001ASE = P_IN_Asesor;

      If ln_salcons > ln_salpyme
      then
        lc_tipase := 'C';
      end If;

      If ln_salpyme >= ln_salcons
      then
        lc_tipase := 'P';
      End If;

    End;

    return lc_tipase;

  end fn_cr_asesor_clasi;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_saldo
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el saldo de analista de acuerdo al
    --                              tipo C = consumo y P = pymes
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Asesor: Codigo de asesor,
    --                              P_IN_Fecha: Fecha de proceso
    -- Parámetros de Salida       : ln_salase: Saldo de asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam  fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    ln_salpyme number(18, 2);
    ln_salcons number(18, 2);
    ln_salase  number(18, 2);

  begin

    begin
      -- Prestamo Consumo

      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_salcons
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD = 107
         and h.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_Asesor;

      If ln_salcons is null
      then
        ln_salcons := 0;
      End If;

      -- prestamos pymes

      select

       sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_salpyme
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD <> 107
         and h.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_Asesor;

      If ln_salcons > ln_salpyme
      then
        ln_salase := ln_salcons;
      end If;

      If ln_salpyme >= ln_salcons
      then
        ln_salase := ln_salpyme;
      End If;

    End;

    return ln_salase;

  end fn_cr_asesor_saldo;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_asesor_tipo
  (
    P_IN_Asesor IN char,
    P_IN_Fecha  IN date
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_ASESOR_TIPO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el tipo de meta analista de acuerdo al
    --                              tipo C = consumo y P = pymes y al tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Asesor: Codigo de asesor,
    --                              P_IN_Fecha: Fecha de proceso
    -- Parámetros de Salida       : lc_tipoase: tipo de meta = I,II,III,IV,V,VI
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_clasase char(1) := pq_ah_jaql551.fn_cr_asesor_clasi(P_IN_Asesor,
                                                           P_IN_Fecha);
    ln_codage  number(10) := pq_ah_jaql551.fn_cr_codage(P_IN_Asesor);
    lc_clasage char(2) := pq_ah_jaql551.fn_cr_tipo_agencia_metas(ln_codage,
                                                                 P_IN_Fecha);
    ln_tipcam  fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    ln_asemto  number(18, 2);
    ln_asecon  number(18,2);
    lc_tipoase char(3);

  Begin

    IF lc_clasase = 'C' Then

       select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_asecon
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD = 107
         and h.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_Asesor;

       Select jaql577tipo
       into lc_tipoase
       from jaql577
       where ln_asecon >= jaql577smin
       and ln_asecon <= jaql577smax
       and jaql577emp = lc_clasase
       and jaql577tage = lc_clasage;

    Else

      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_asemto
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fsr008 d on x.XWFCUENTA = d.CTNRO
                          and x.XWFEMPRESA = d.PGCOD
       inner join fst111 h on f.SCMOD = h.modulo
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and d.TTCOD = 1
         and d.CTTFIR = 'T'
         and f.SCMOD <> 107
         and h.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_Asesor;

      select jaql577tipo
        into lc_tipoase
        from jaql577
       where ln_asemto >= jaql577smin
         and ln_asemto <= jaql577smax
         and jaql577emp = lc_clasase
         and jaql577tage = lc_clasage;

    End If;

    return lc_tipoase;

  end fn_cr_asesor_tipo;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_anual_saldo
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_PLUS_ANUAL_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el plus anual de analista de acuerdo al
    --                              tipo C = consumo y P = pymes y tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_tipase: clase de asesor C/P,
    --                              P_IN_tipage: Tipo de Agencia
    --                                           E=Especifica
    --                                           N=Nueva
    --                                           O=Otras
    -- Parámetros de Salida       :ln_plus: Saldo anual plus
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_plus jaql581.jaql581sdoa%type;

  Begin

    Select jaql581sdoa
      into ln_plus
      from jaql581
     Where jaql581cage = P_IN_tipage
       and jaql581tase = P_IN_tipase
       and jaql581est = 'S';

    return ln_plus;

  end fn_cr_plus_anual_saldo;
  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Function fn_cr_plus_mes_saldo
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_PLUS_MES_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el plus mensual de analista de acuerdo al
    --                              tipo C = consumo y P = pymes y tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_tipase: clase de asesor C/P,
    --                              P_IN_tipage: Tipo de Agencia
    --                                           E=Especifica/N=Nueva/O=Otras
    -- Parámetros de Salida       :ln_plus: Saldo mensual plus
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_plus jaql581.jaql581sdom%type;

  Begin

    Select jaql581sdom
      into ln_plus
      from jaql581
     Where jaql581cage = P_IN_tipage
       and jaql581tase = P_IN_tipase
       and jaql581est = 'S';

    return ln_plus;

  end fn_cr_plus_mes_saldo;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_anual_clie
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_PLUS_ANUAL_CLIE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el plus anual de analista de acuerdo al
    --                              tipo C = consumo y P = pymes y tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_tipase: clase de asesor C/P,
    --                              P_IN_tipage: Tipo de Agencia
    --                                           E=Especifica/N=Nueva/O=Otras
    -- Parámetros de Salida       :ln_plus: cliente anual plus
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_plus jaql581.jaql581clia%type;

  Begin

    Select jaql581clia
      into ln_plus
      from jaql581
     Where jaql581cage = P_IN_tipage
       and jaql581tase = P_IN_tipase
       and jaql581est = 'S';

    return ln_plus;

  end fn_cr_plus_anual_clie;

  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_plus_mes_clie
  (
    P_IN_tipase char,
    P_IN_tipage char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_PLUS_MES_CLIE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta el plus mes de analista de acuerdo al
    --                              tipo C = consumo y P = pymes y tipo de agencia
    -- Estado                     :
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_tipase: clase de asesor C/P,
    --                              P_IN_tipage: Tipo de Agencia
    --                                           E=Especifica/N=Nueva/O=Otras
    -- Parámetros de Salida       :ln_plus: cliente mensual plus
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_plus jaql581.jaql581clim%type;

  Begin

    Select jaql581clim
      into ln_plus
      from jaql581
     Where jaql581cage = P_IN_tipage
       and jaql581tase = P_IN_tipase
       and jaql581est = 'S';

    return ln_plus;

  end fn_cr_plus_mes_clie;
  --- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_capital_nuevo
  (
    P_IN_usuario IN char,
    P_IN_Fecha   IN Date,
    P_IN_tipcam IN number,
    P_IN_tipase IN char,
    P_IN_clase IN char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CAPITAL_NUEVO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el capital de todos los clientes
    --                              nuevos del analista.
    -- Estado                     : Activo

    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_usuario: Codigo de asesor,
    --                             P_IN_Fecha: fecha proceso,
    --                             P_IN_tipcam: tipo de cambio
    -- Parámetros de Salida       :ln_Capnue: Capital de clientes nuevos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ld_fecini date;
    x number(10);
    ln_saldcre jaql572.jaql572sant%type := 0;
    ln_bono jaql582.jaql582plus%type;


cursor cur_13 is
    Select (decode(f.SCMDA, 101, f.SCSDO * P_IN_tipcam, f.SCSDO) * -1) saldo
    From fsd011 f
    inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         --and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_usuario
         and s.SNG001TPCR = 1
         and f.SCFVAL Between ld_Fecini and P_IN_fecha;

Begin

select TRUNC(P_IN_fecha, 'MM') into ld_Fecini from dual;

For x in cur_13 loop
   ln_bono := pq_ah_jaql551.fn_pago_plus_cliente_nuevo(x.saldo, P_IN_tipase,P_IN_clase);
   ln_saldcre := ln_saldcre + ln_bono;

END LOOP;

     Return nvl(ln_saldcre,0);

End fn_cr_capital_nuevo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cred_metas
  (
    P_IN_meta   char,
    P_IN_tipase char,
    P_IN_tipage char
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CRED_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de creditos que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtasdo: meta del saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_mtasdo jaql583.jaql583mtsa%type;

  begin

    If P_IN_tipase = 'P'
    then

      select jaql579sado
        into ln_mtasdo
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_tipase
         and jaql579tip = P_IN_meta
         and jaql579est = 'S';

    Else


      select jaql579sado
        into ln_mtasdo
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_tipase
         and jaql579tip = P_IN_meta
         and jaql579est = 'S';
    End If;

    return ln_mtasdo;

  end fn_cr_cred_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_clie_metas
  (
    P_IN_Tipase IN char,
    P_IN_tipage IN char,
    P_IN_met    IN char
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIE_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de clientes que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtacli: meta del cliente
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_mtacli jaql583.jaql583mtcl%type;

  Begin

    If P_IN_Tipase = 'P'
    then

      select jaql579clie
        into ln_mtacli
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_Tipase
         and jaql579tip = P_IN_met
         and jaql579est = 'S';

    Else

      select jaql579clie
        into ln_mtacli
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_Tipase
         and jaql579tip = P_IN_met
         and jaql579est = 'S';
    End If;

    return ln_mtacli;

  End fn_cr_clie_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_mora_metas
  (
    P_IN_Tipase IN char,
    P_IN_tipage IN char,
    P_IN_met    IN char
  ) return Number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_MORA_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve la meta de mora que corresponde al analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :P_IN_meta: tipo de meta: I,II,III,IV,V,VI
    --                             P_IN_tipase: tipo de asesor: C=Consumo/P=Pymes,
    --                             P_IN_tipage: tipo de agencia: E=Especifica/N=nueva/O=otros
    -- Parámetros de Salida       :ln_mtamra: meta de la mora
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_mtamra jaql583.jaql583mtmr%type;

  Begin
    If P_IN_Tipase = 'P'
    then

      select jaql579mra
        into ln_mtamra
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_Tipase
         and jaql579tip = P_IN_met
         and jaql579est = 'S';

    Else

      select jaql579mra
        into ln_mtamra
        from jaql579
       where jaql579tage = P_IN_tipage
         and jaql579tase = P_IN_Tipase
         and jaql579tip = P_IN_met
         and jaql579est = 'S';
    End If;

    return ln_mtamra;

  End fn_cr_mora_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia(P_IN_agen in number) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TIPO_AGENCIA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el tipo de agencia de mantenimiento de cartera
    --                              Otras agencias / Lima metropolitana
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_agen: codigo de agencia del asesor o analista
    -- Parámetros de Salida       : lc_tipage: tipo de agencia E/N/O
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_tipage number(2);
    ln_conage number(3);

  begin

    begin

      -- otras agencias
      select count(*)
        into ln_conage
        from fst001 f
       where SCCIUD <> 1501
         and SUCURS = P_IN_agen;

      If ln_conage > 0
      then
        lc_tipage := 1;
      End If;

      -- lima metropolitana

      select count(*)
        into ln_conage
        from fst001 f
       where SCCIUD = 1501
         and SUCURS = P_IN_agen;

      If ln_conage > 0
      then
        lc_tipage := 2;
      End If;

    exception
      when no_data_found then
        lc_tipage := 'N';
    End;

    return lc_tipage;

  end fn_cr_tipo_agencia;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipo_agencia_metas
  (
    P_IN_agen  in number,
    P_IN_Fecha in date
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_AGENCIA_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Tipo de agencias por plus de metas
    --                              E=especifica
    --                              N=nuevas
    --                              O=otras
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_agen: Codigo de Agencia
    --                              P_IN_Fecha: fecha del proceso
    -- Parámetros de Salida       : lc_tipage: devuelve el tipo de agencia
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_tipage char(2) := 'X';
    ln_conage number(3);
    ln_conmes number(10);

  begin

    begin

      -- Nuevas

      Select Months_between(P_IN_Fecha, scax2)
        into ln_conmes
        from fst601
       where fst601suc = P_IN_agen and nvl(SCAX1,'N') <> 'S'
         and pgcod = 1;
     exception
      when no_data_found then
        lc_tipage := 'X';
     End;

      If ln_conmes <= 12 then
        lc_tipage := 'N';
      End If;

      If lc_tipage = 'X' then

      begin
        -- agencia especifica
        select count(*)
          into ln_conage
          from fst001
         where SCCIUD in (401, 2101, 1803, 1801, 2111)
           and sucurs = P_IN_agen;
      exception
      when no_data_found then
        lc_tipage := 'X';
      End;

        If ln_conage > 0
        then
          lc_tipage := 'E';
        End If;

      End If;

      -- otras
      If lc_tipage = 'X'
      then
        lc_tipage := 'O';
      End If;



    return lc_tipage;

  end fn_cr_tipo_agencia_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_cali(P_IN_cliente IN Number) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_CALI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : consulta la calificacion del asesor en cuanto a clientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: Numero de clientes del asesor
    -- Parámetros de Salida       : lc_calcli: calificacion de cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcli char(2);

  begin
    begin
      select trim(t.jaql570tipo)
        into lc_calcli
        from jaql570 t
       where jaql570AGe = 1
         and P_IN_cliente >= t.jaql570clmi
         and P_IN_cliente <= t.jaql570clma
         and jaql570est = 'S';

    exception
      when no_data_found then
        lc_calcli := ' ';
    end;

    return lc_calcli;

  end fn_cr_cliente_cali;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_credito_cali(P_IN_monto IN Number) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CREDITO_CALI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : califica el saldo que tiene el asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_monto: saldo actual del asesor
    -- Parámetros de Salida       : lc_calcre: calificacion del credito de
    --                              acuerdo al monto del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    lc_calcre char(2);

  begin

    begin
      Select trim(f.jaql571tipo)
        into lc_calcre
        from jaql571 f
       where jaql571AGe = 1
         and P_IN_Monto >= f.jaql571sdmi
         and P_IN_Monto <= f.jaql571sdma
         and jaql571est = 'S';

    exception
      when no_data_found then
        lc_calcre := ' ';
    end;

    return lc_calcre;

  end fn_cr_credito_cali;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contmes_anterior(P_IN_USER IN char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CONTMES_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Consulta los meses de antiguedad del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_USER: Codigo de asesor
    -- Parámetros de Salida       : ln_mesant: Devuelve la cantidad de meses
    --                              de antiguedad
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_mesant number(10);
    ld_fecha  date;

  begin

    select g.pgfbce into ld_fecha from fst017 g where g.pgcod = 1;

    Begin
      select round((ld_fecha - max(prfufecalt)) / 30)
        into ln_mesant
        from prfu00
       where ubuser = P_IN_USER
         and (prfgcod = 'ANA01' or prfgcod = 'ANASEN');

    exception
      when no_data_found then
        ln_mesant := 0;
    end;

    if ln_mesant is null
    then
      ln_mesant := 0;
    end if;

    return nvl(ln_mesant,0);

  end fn_cr_contmes_anterior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_contdias_anterior(P_IN_USER IN char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CONTDIAS_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el numero de dias de antiguedad del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_USER: Codigo de asesor
    -- Parámetros de Salida       : ln_diasant: dias de antiguedad del asesor.
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_diasant number(10);
    ld_fecha   date;

  begin
    select g.pgfbce into ld_fecha from fst017 g where g.pgcod = 1;
    Begin
      select round((ld_fecha - max(prfufecalt)))
        into ln_diasant
        from prfu00
       where ubuser = P_IN_USER
         and (prfgcod = 'ANA01' or prfgcod = 'ANASEN');

    exception
      when no_data_found then
        ln_diasant := 0;
    End;

    If ln_diasant is null
    then
      ln_diasant := 0;
    End If;

    return nvl(ln_diasant,0);

  end fn_cr_contdias_anterior;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_anterior
  (
    P_IN_Usuario IN char,
    P_IN_Fecha   IN date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha proceso
    -- Parámetros de Salida       : ln_salant: saldo anterior del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_salant number(18, 2);
    ld_fecfin date;

  begin

    select last_day(add_months(trunc(P_IN_Fecha), -1))
      into ld_fecfin
      from dual;

    Begin
      -- Saldo del Mes Anterior

      select trunc(jaql572scre, 2)
        into ln_Salant
        from jaql572
       where jaql572usu = P_IN_usuario
         and jaql572fpro = ld_fecfin;

    exception
      when others then
        ln_Salant := 0;
    end;

    return ln_salant;

  end fn_cr_saldo_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_nrocli_anterior
  (
    P_IN_usuario IN char,
    P_IN_Fecha   IN date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_NROCLI_ANTERIOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes anterior
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: Codigo de asesor
    --                              P_IN_Fecha: fecha del proceso
    -- Parámetros de Salida       : ln_nrocli: numero de clientes.
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_nrocli number(10);
    ld_fecfin date;

  Begin

    select last_day(add_months(trunc(P_IN_Fecha), -1))
      into ld_fecfin
      from dual;

    Begin
      select jaql572ncli
        into ln_nrocli
        from jaql572
       where jaql572usu = P_IN_usuario
         and jaql572fpro = ld_fecfin;

    exception
      when no_data_found then
        ln_nrocli := 0;
    end;

    return ln_nrocli;

  end fn_cr_nrocli_anterior;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_tipocambio(P_IN_fecha in date) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TIPOCAMBIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve del tipo de cambio actual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_tipcam: tipo de cambio actual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam fsh005.COTCBI%type;

  begin

    select cotcbi
      into ln_tipcam
      from fsh005
     where moneda = 101
       and rownum = 1
       and cofdes <= P_IN_fecha
     order by cofdes desc;

    return ln_tipcam;

  Exception
    when no_data_found then
      ln_tipcam := 0;
      return ln_tipcam;

  End fn_cr_tipocambio;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_capital
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_CAPITAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo capital del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       : ln_SalCap: saldo capital del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_SalCap fsd011.SCSDO%type;
    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

  begin
    begin

      -- Saldo Capital
      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_SalCap
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_usuario;

    exception
      when others then
        ln_SalCap := 0;
    end;

    If ln_SalCap is null
    then
      ln_SalCap := 0;
    End If;

    return ln_SalCap;

  End fn_cr_saldo_capital;
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_judiciales
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_JUDICIALES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el saldo judicial del analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       : ln_Saljuto: saldo judicial total del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_Saljua  fsd011.SCSDO%type;
    ln_Saljut  fsd011.SCSDO%type;
    ln_Saljuto fsd011.SCSDO%type;
    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    ld_fecini date;
    ln_codase number(3);

begin


    ld_fecini := pq_ah_jaql551.fn_cr_trasase_otor(P_IN_usuario, P_IN_Fecha);

    select ubsuc
    into ln_codase
    from fst046
    where ubuser = P_IN_usuario;

    begin

    --saldo judicial misma Agencia

     select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
      into ln_Saljua
      from fsd011 f
      inner join fsr011 p on f.PGCOD = p.R2COD
                and f.SCSUC = p.R2SUC
                and f.SCMDA = p.R2MDA
                and f.SCPAP = p.R2PAP
                and f.SCCTA = p.R2CTA
                and f.SCOPER = p.R2OPER
                and f.SCSBOP = p.R2SBOP
                and f.SCTOPE = p.R2TOPE
                and f.SCMOD = p.R2MOD
      inner join xwf700 x on p.R1COD = x.XWFEMPRESA
                and p.R2SUC = x.XWFSUCURSAL
                and p.R2MDA = x.XWFMONEDA
                and p.R2PAP = x.XWFPAPEL
                and p.R2CTA = x.XWFCUENTA
                and p.R2OPER = x.XWFOPERACION
                and p.R2SBOP = x.XWFSUBOPE
                and p.R2TOPE = x.XWFTIPOPE
                and p.R2MOD = x.XWFMODULO
      inner join jaql166 y on p.R2COD = y.jaql166pgcod
                    and p.R2SUC = y.jaql166scsuc
                    and p.R2MDA = y.jaql166scmda
                    and p.R2PAP = y.jaql166scpap
                    and p.R2CTA = y.jaql166sccta
                    and p.R2OPER = y.jaql166scope
                    and p.R2SBOP = y.jaql166scsbo
                    and p.R2TOPE = y.jaql166sctop
                    and p.R2MOD  = y.jaql166scmod
      inner join sng001 s on x.XWFPRCINS = s.SNG001INST
      inner join fst111 c on f.SCMOD = c.modulo
      --inner join fst198 g on f.PGCOD = g.tp1cod
      where x.xwfcar3 = '1'
      and f.SCSTAT <> 99
      and c.dscod = 50
/*      and g.tp1cod1 = 10852
      and g.tp1corr1 = 2
      and g.tp1corr2 = 5
      and g.tp1corr3 = 1*/
      and f.SCMOD in (200)
      and p.RELCOD in 34
      and f.SCSUC = ln_codase
      and y.jaql166nrpag = 0
      and s.SNG001ASE = P_IN_usuario;

    Exception when no_data_found then
        ln_Saljua := 0;
    End;

    If ln_Saljua is null then
       ln_Saljua := 0;
    End If;


    begin

      -- Saldo Judicial

      select case
      when Trunc(months_between( P_IN_Fecha, ld_fecini)) > 6 then
           sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
      end case
      into ln_Saljut
      from fsd011 f
      inner join fsr011 p on f.PGCOD = p.R2COD
                and f.SCSUC = p.R2SUC
                and f.SCMDA = p.R2MDA
                and f.SCPAP = p.R2PAP
                and f.SCCTA = p.R2CTA
                and f.SCOPER = p.R2OPER
                and f.SCSBOP = p.R2SBOP
                and f.SCTOPE = p.R2TOPE
                and f.SCMOD = p.R2MOD
      inner join xwf700 x on p.R2COD = x.XWFEMPRESA
                and p.R2SUC = x.XWFSUCURSAL
                and p.R2MDA = x.XWFMONEDA
                and p.R2PAP = x.XWFPAPEL
                and p.R2CTA = x.XWFCUENTA
                and p.R2OPER = x.XWFOPERACION
                and p.R2SBOP = x.XWFSUBOPE
                and p.R2TOPE = x.XWFTIPOPE
                and p.R2MOD = x.XWFMODULO
      inner join jaql166 y on p.R2COD = y.jaql166pgcod
                and p.R2SUC = y.jaql166scsuc
                and p.R2MDA = y.jaql166scmda
                and p.R2PAP = y.jaql166scpap
                and p.R2CTA = y.jaql166sccta
                and p.R2OPER = y.jaql166scope
                and p.R2SBOP = y.jaql166scsbo
                and p.R2TOPE = y.jaql166sctop
                and p.R2MOD  = y.jaql166scmod
      inner join sng001 s on x.XWFPRCINS = s.SNG001INST
      inner join fst111 c on f.SCMOD = c.modulo
      where x.xwfcar3 = '1'
      and f.SCSTAT <> 99
      and c.dscod = 50
      and f.SCMOD = 200
      and p.RELCOD = 34
      and f.SCSUC <> ln_codase
      and y.jaql166nrpag = 0
      and s.SNG001ASE = P_IN_usuario;

    exception when others then
        ln_Saljut := 0;
    end;

    if ln_Saljut is null then
       ln_Saljut := 0;
    End If;

    ln_Saljuto := ln_Saljut + ln_Saljua;

    return nvl(ln_Saljuto,0);

  End fn_cr_saldo_judiciales;

   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_castigo
  (
    P_IN_usuario char,
    P_IN_Fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_CASTIGO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo castigado del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       : ln_Salcast: saldo castigado del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_Salcast fsd011.SCSDO%type;
    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

  begin
    begin

      -- Saldo Castigado
      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
      into ln_Salcast
      from fsd011 f
      inner join fsr011 p on f.PGCOD = p.R2COD
                and f.SCSUC = p.R2SUC
                and f.SCMDA = p.R2MDA
                and f.SCPAP = p.R2PAP
                and f.SCCTA = p.R2CTA
                and f.SCOPER = p.R2OPER
                and f.SCSBOP = p.R2SBOP
                and f.SCTOPE = p.R2TOPE
                and f.SCMOD = p.R2MOD
      inner join xwf700 x on p.R2COD = x.XWFEMPRESA
                and p.R2SUC = x.XWFSUCURSAL
                and p.R2MDA = x.XWFMONEDA
                and p.R2PAP = x.XWFPAPEL
                and p.R2CTA = x.XWFCUENTA
                and p.R2OPER = x.XWFOPERACION
                and p.R2SBOP = x.XWFSUBOPE
                and p.R2TOPE = x.XWFTIPOPE
                and p.R2MOD = x.XWFMODULO
      inner join jaql166 y on p.R2COD = y.jaql166pgcod
                    and p.R2SUC = y.jaql166scsuc
                    and p.R2MDA = y.jaql166scmda
                    and p.R2PAP = y.jaql166scpap
                    and p.R2CTA = y.jaql166sccta
                    and p.R2OPER = y.jaql166scope
                    and p.R2SBOP = y.jaql166scsbo
                    and p.R2TOPE = y.jaql166sctop
                    and p.R2MOD  = y.jaql166scmod
      inner join sng001 s on x.XWFPRCINS = s.SNG001INST
      inner join fst111 c on f.SCMOD = c.modulo
      where x.xwfcar3 = '1'
      and f.SCSTAT <> 99
      and c.dscod = 50
      and f.SCMOD = 33
      and p.RELCOD = 33
      and y.jaql166nrpag = 0
      and y.jaql166scfvl between add_months(P_IN_Fecha,-12) and P_IN_Fecha
      and s.SNG001ASE = P_IN_usuario;

    exception when others then
        ln_Salcast := 0;
    end;

    return nvl(ln_Salcast,0);

  End fn_cr_saldo_castigo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Nrocli_acutal(P_IN_usuario char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_NROCLI_ACTUAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes actual
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: Codigo de asesor
    -- Parámetros de Salida       : ln_NroClia: numero de clientes actuales del asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_NroClia number(10);

  begin
    begin

      -- Numero de clientes actual
      select count(distinct to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                   to_char(s.SNG001NDOC))
        into ln_NroClia
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         --and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
         and s.SNG001ASE = P_IN_usuario;

    exception
      when others then
        ln_NroClia := 0;
    end;

    If ln_NroClia is null
    then
      ln_NroClia := 0;
    End If;

    return ln_NroClia;

  End fn_cr_Nrocli_acutal;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_Nrocli_nuevo(P_IN_usuario char,
                              P_IN_fecha date) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_NROCLI_NUEVO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clinetes nuevos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_NroClia: numero de clientes nuevos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_NroClia number(10);
    ld_Fecini date;

  begin

    select TRUNC(P_IN_fecha, 'MM') into ld_Fecini from dual;

    begin

      -- Numero de clientes nuevos
      select count(distinct to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                   to_char(s.SNG001NDOC))
        into ln_NroClia
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and s.SNG001ASE = P_IN_usuario
         and s.SNG001TPCR = 1
         and f.SCFVAL Between ld_Fecini and P_IN_fecha;

    exception
      when others then
        ln_NroClia := 0;
    end;

    If ln_NroClia is null
    then
      ln_NroClia := 0;
    End If;

    return ln_NroClia;

  End fn_cr_Nrocli_nuevo;

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codage(P_IN_usuario char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CODAGE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el codigo de agencia del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor
    -- Parámetros de Salida       : ln_codage: codigo de agencia
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codage number(10);

  begin

    -- Verifica si el asesor tiene codigo
    begin
      select ubsuc into ln_codage from fst046 where ubuser = P_IN_usuario;

    exception
      when others then
        ln_codage := 0;

    end;

    return ln_codage;

  end fn_cr_codage;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_codase(P_IN_usuario char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CODASE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el codigo de asesor del analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de usuario
    -- Parámetros de Salida       : ln_codase: codigo de asesor
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number(10);

  begin

    -- Verifica si el asesor tiene codigo
    begin
      select sngas2cod
        into ln_codase
        from sngas2
       where sngas2usr = P_IN_usuario;

    exception
      when others then
        ln_codase := 0;

    End;

    If ln_codase is null
    then
      ln_codase := 0;
    End If;

    return ln_codase;

  end fn_cr_codase;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_trasase
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return char is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TRASASE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve si el asesor ha sido trasladado durante el mes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : lc_aseafir: devuelve 'S' o 'N' si el asesor tuvo traslados durante el mes
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase  number(10) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_fecant  date;
    ln_asetra  number(10);
    lc_aseafir char(1);

  begin

    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    -- verifica si el asesor tiene traslados Otorgados / Recibidos en el mes

    Select count(s.SNG095ASAN)
      into ln_asetra
      From sng095 s
     Where s.SNG095ASAN = ln_codase
        or s.SNG095ASNU = ln_codase
       and s.SNG095FEC between ld_fecant and P_IN_fecha;

    If ln_asetra > 0
    then
      lc_aseafir := 'S';
    Else
      lc_aseafir := 'N';
    End If;

    return lc_aseafir;

  End fn_cr_trasase;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_trasase_otor
  (
    P_IN_usuario char,
    P_IN_fecha date
  ) return date is
    -- *****************************************************************
    -- Nombre                     : FN_CR_TRASASE_OTOR
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve la fecha de los traslados otorgados
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ld_fecant: traslados otorgados
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase  number(10) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_fecant  date;

  begin



    -- verifica si el asesor tiene traslados Otorgados
    begin
    Select max(SNG095FEC)
      into ld_fecant
      From sng095 s
     Where s.SNG095ASAN = ln_codase
     and s.SNG095FEC between trunc(add_months(P_IN_fecha,-6),'MM') and P_IN_fecha ;

    exception when no_data_found then
        ld_fecant := '01/01/0001';
    end;

    return ld_fecant;

  End fn_cr_trasase_otor;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_otorgado
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_OTORGADO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el valor en saldos otorgados
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_TraOtor: saldo en traslados otorgados
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_TraOtor number(18, 2);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    ln_tipcam  number(10) := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo otorgado

      Begin

        select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
          into ln_TraOtor
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASAN = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_TraOtor := 0;
      End;

    Else

      ln_TraOtor := 0;

    End If;

    If ln_TraOtor is null
    then
      ln_TraOtor := 0;
    End If;

    return ln_TraOtor;
  End fn_cr_saldo_otorgado;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_recibido
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_RECIBIDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo de traslados recibidos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_TraRecb: saldos en traslados recibidos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_TraRecb number(18, 2);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    ln_tipcam  number(10) := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo Recibido

      Begin

        select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
          into ln_TraRecb
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASNU = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_TraRecb := 0;
      End;

    Else

      ln_TraRecb := 0;

    End If;

    If ln_TraRecb is null
    then
      ln_TraRecb := 0;
    End if;

    return ln_TraRecb;

  end fn_cr_saldo_recibido;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_otorgado
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_OTORGADO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el numero de clientes otorgados
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_CliOtor: numero de clientes otorgados
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_CliOtor number(10);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo otorgado

      Begin

        select count(distinct
                     to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                     to_char(s.SNG001NDOC))
          into ln_CliOtor
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASAN = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_CliOtor := 0;
      End;

    Else

      ln_CliOtor := 0;

    End If;

    If ln_CliOtor is null
    then
      ln_CliOtor := 0;
    End If;

    return ln_CliOtor;

  End fn_cr_cliente_otorgado;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_recibido
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_RECIBIDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes recibidos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_CliRecb: numero de clientes recibidos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_CliRecb number(18, 2);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo recibido

      Begin

        select count(distinct
                     to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                     to_char(s.SNG001NDOC))
          into ln_CliRecb
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASNU = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_CliRecb := 0;
      End;

    Else

      ln_CliRecb := 0;

    End If;

    If ln_CliRecb is null
    then
      ln_CliRecb := 0;
    End if;

    return ln_CliRecb;

  End fn_cr_cliente_recibido;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_ant_metas
  (
    P_IN_Usuario IN char,
    P_IN_Fecha   IN date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_ANT_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo anterior de las metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_Metant: saldo anterior de metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_Metant number(18, 2);
    ld_fecfin date;

  begin

    select last_day(add_months(trunc(P_IN_Fecha), -1))
      into ld_fecfin
      from dual;

    Begin
      -- Saldo del Mes Anterior

      select jaql583sdo
        into ln_Metant
        from jaql583
       where jaql583usu = P_IN_usuario
         and jaql583fpro = ld_fecfin;

    exception
      when others then
        ln_Metant := 0;
    end;

    return ln_Metant;

  end fn_cr_saldo_ant_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_otor_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_OTOR_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : devuelve el saldo otorgado de metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_MetOtor: saldo otorgado metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_MetOtor number(10);
    ln_codase  number(10) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    ln_tipcam  number(10) := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

  begin

    ld_Fecant := TRUNC(P_IN_fecha, 'MM');

    -- Saldo otorgado

    begin
      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_MetOtor
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       /*inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE*/
       inner join fst017 g on f.PGCOD = g.pgcod
       inner join sng095 j on x.XWFPRCINS = j.SNG095INST
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and j.SNG095ASAN = ln_codase
         and j.SNG095FEC between ld_Fecant and P_IN_fecha;

    exception
      when others then
        ln_MetOtor := 0;

    End;

    If ln_MetOtor is null
    then
      ln_MetOtor := 0;
    End If;

    return ln_MetOtor;

  End fn_cr_saldo_otor_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_rec_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_REC_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo recibido de metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_MetRecb: saldo recibido de metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_MetRecb number(18, 2);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    ln_tipcam  number(10) := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo Recibido

      Begin

        select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
          into ln_MetRecb
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASNU = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_MetRecb := 0;
      End;

    Else

      ln_MetRecb := 0;

    End If;

    If ln_MetRecb is null
    then
      ln_MetRecb := 0;
    End if;

    return ln_MetRecb;

  end fn_cr_saldo_rec_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_act_metas(P_IN_usuario char) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLI_ACT_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor
    -- Parámetros de Salida       : ln_Climet: numero de clientes metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_Climet number(10);

  begin

    begin

      -- Numero de clientes actual
      select count(distinct to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                   to_char(s.SNG001NDOC))
        into ln_Climet
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and s.SNG001ASE = P_IN_usuario;

    exception
      when others then
        ln_Climet := 0;
    end;

    If ln_Climet is null
    then
      ln_Climet := 0;
    End If;

    return ln_Climet;

  end fn_cr_cli_act_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_otor_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLI_OTOR_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes otorgados
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_Clmetor: numero de clientes otorgados metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_Clmetor number(10);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo otorgado

      Begin

        select count(distinct
                     to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                     to_char(s.SNG001NDOC))
          into ln_Clmetor
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASAN = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_Clmetor := 0;
      End;

    Else

      ln_Clmetor := 0;

    End If;

    If ln_Clmetor is null
    then
      ln_Clmetor := 0;
    End If;

    return ln_Clmetor;

  end fn_cr_cli_otor_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_rec_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLI_REC_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve numero de clientes recibido metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_CliRecb: Numero de clientes recibidos
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_CliRecb number(18, 2);
    ln_codase  number(4) := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_Fecant  date;
    lc_asetra  char(1) := pq_ah_jaql551.fn_cr_trasase(P_IN_usuario,
                                                      P_IN_fecha);

  begin
    select TRUNC(P_IN_fecha, 'MM') into ld_Fecant from dual;

    If lc_asetra = 'S'
    Then

      -- Saldo recibido

      Begin

        select count(distinct
                     to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                     to_char(s.SNG001NDOC))
          into ln_CliRecb
          from fsd011 f
         inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                            and f.SCSUC = x.XWFSUCURSAL
                            and f.SCMDA = x.XWFMONEDA
                            and f.SCPAP = x.XWFPAPEL
                            and f.SCCTA = x.XWFCUENTA
                            and f.SCOPER = x.XWFOPERACION
                            and f.SCSBOP = x.XWFSUBOPE
                            and f.SCTOPE = x.XWFTIPOPE
                            and f.SCMOD = x.XWFMODULO
         inner join sng001 s on x.XWFPRCINS = s.SNG001INST
         inner join fst111 c on f.SCMOD = c.modulo
         /*inner join fst046 t on f.PGCOD = t.pgcod
                            and t.ubuser = s.SNG001ASE*/
         inner join fst017 g on f.PGCOD = g.pgcod
         inner join sng095 j on x.XWFPRCINS = j.SNG095INST
         where x.xwfcar3 = '1'
           and f.SCSTAT <> 99
           and c.dscod = 50
           and j.SNG095ASNU = ln_codase
           and j.SNG095FEC between ld_Fecant and P_IN_fecha;

      Exception
        when others then
          ln_CliRecb := 0;
      End;

    Else

      ln_CliRecb := 0;

    End If;

    If ln_CliRecb is null
    then
      ln_CliRecb := 0;
    End if;

    return ln_CliRecb;

  end fn_cr_cli_rec_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cli_ant_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLI_ANT_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de clientes anterior metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_nrocli: numero de clientes anterior
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_nrocli number(10);
    ld_fecfin date;

  Begin

    select last_day(add_months(trunc(P_IN_Fecha), -1))
      into ld_fecfin
      from dual;

    Begin
      select jaql583ncl
        into ln_nrocli
        from jaql583
       where jaql583usu = P_IN_usuario
         and jaql583fpro = ld_fecfin;

    exception
      when no_data_found then
        ln_nrocli := 0;
    end;

    return ln_nrocli;
  end fn_cr_cli_ant_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_MES_BASE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_salfinal: Saldo de mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ln_salfinal number(18, 2);
    ld_fecfin date;
    ld_fecini date;
    ld_fecotor date;

  Begin

    ld_fecini := last_day(to_date('12' || '/' ||to_char(P_IN_fecha + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
    ld_fecfin := last_day(add_months(P_IN_fecha,-1));

    Begin
    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase
    and sng095fec > ld_fecini
    and sng095fec < ld_fecfin;

    Exception when others then
       ld_fecotor := null;
    End;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
    End if;


    Begin
      select max(jaql583sdo)
        into ln_salfinal
        from jaql583 g
       where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583fpro = last_day(jaql583fpro);

    exception
      when no_data_found then
        ln_salfinal := 0;
    end;

    If ln_salfinal is null
    then
      ln_salfinal := 0;
    End If;

    return ln_salfinal;

  end fn_cr_saldo_mes_base;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_cliente_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ln_clifinal number(18, 2);
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;

  Begin

    ld_fecini := last_day(to_date('12' || '/' ||to_char(P_IN_fecha + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
    ld_fecfin := last_day(add_months(P_IN_fecha,-1));
    Begin
    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase
    and sng095fec > ld_fecini
    and sng095fec < ld_fecfin ;

    Exception When others then
       ld_fecotor := null;
    End;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
    End if;

    Begin
      select max(jaql583ncl)
        into ln_clifinal
        from jaql583 g
       where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583fpro = last_day(jaql583fpro);

    exception
      when no_data_found then
        ln_clifinal := 0;
    end;

    If ln_clifinal is null
    then
      ln_clifinal := 0;
    End If;

    return ln_clifinal;

  end fn_cr_cliente_mes_base;

   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_cli_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return date is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ld_clifec date;
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;

  Begin

    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
    Else
       ld_fecini := last_day(to_date('12' || '/' ||to_char(P_IN_fecha + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
       ld_fecfin := last_day(add_months(P_IN_fecha,-1));
    End if;

    Begin
      select max(jaql583fpro)
        into ld_clifec
        from jaql583 g
       where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583sant = (select max(jaql583sant) from jaql583 where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin);


    exception
      when no_data_found then
        ld_clifec := '01/01/2012';
    end;

    If ld_clifec is null
    then
      ld_clifec := '01/01/2012';
    End If;

    return ld_clifec;

  end fn_cr_fecha_cli_mes_base;


   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_fecha_sal_mes_base
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return date is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CLIENTE_MES_BASE
    -- Sistema                    : SORFY
    -- Módulo                     : Ahorros
    -- Versión                    : 1.0
    -- Fecha de Creación          : 07/12/2011
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el nro de clientes del mes base de productividad
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_clifinal: Cliente mes base
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_codase number := pq_ah_jaql551.fn_cr_codase(P_IN_usuario);
    ln_fecsal date;
    ld_fecotor date;
    ld_fecfin   date;
    ld_fecini   date;

  Begin

    select max(sng095fec)
    into ld_fecotor
    from sng095 where sng095asan = ln_codase;

    If ld_fecotor is not null then
       ld_fecini := ld_fecotor;
    Else
       ld_fecini := last_day(to_date('12' || '/' ||to_char(P_IN_fecha + numtoyminterval(-1, 'YEAR'),'YYYY'),'MM/YYYY'));
       ld_fecfin := last_day(add_months(P_IN_fecha,-1));
    End if;

    Begin
      select max(jaql583fpro)
        into ln_fecsal
        from jaql583 g
       where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin
         and jaql583fpro = last_day(jaql583fpro)
         and jaql583sant = (select max(jaql583sant) from jaql583 where jaql583usu = P_IN_usuario
         and jaql583fpro between ld_fecini and ld_fecfin);

    exception
      when no_data_found then
        ln_fecsal := '01/01/2012';
    end;

    If ln_fecsal is null
    then
      ln_fecsal := '01/01/2012';
    End If;

    return ln_fecsal;

  end fn_cr_fecha_sal_mes_base;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crecimiento_mensual
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CRECIMIENTO_MENSUAL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento mensual del Asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_cremen: Crecimiento mensual del asesor en saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_SalCap  number(18, 2);
    ln_TraOtor number(18, 2);
    ln_TraRecb number(18, 2);
    ln_Salant  number(18, 2);
    ln_cremen  number(18, 2);

  begin
    ln_SalCap  := pq_ah_jaql551.fn_cr_saldo_capital(P_IN_usuario,
                                                    P_IN_Fecha); -- saldo capital
    ln_TraOtor := pq_ah_jaql551.fn_cr_saldo_otorgado(P_IN_usuario,
                                                     P_IN_fecha); -- saldo traslado anterior
    ln_TraRecb := pq_ah_jaql551.fn_cr_saldo_recibido(P_IN_usuario,
                                                     P_IN_fecha); -- saldo traslado recibido
    ln_Salant  := pq_ah_jaql551.fn_cr_saldo_anterior(P_IN_usuario,
                                                     P_IN_fecha); -- saldo anterior
    --crecimiento mensual
    begin
      ln_cremen := (ln_SalCap + ln_TraOtor - ln_TraRecb) - ln_Salant;

    exception
      when others then
        ln_cremen := 0;
    end;

    if ln_cremen is null
    then
      ln_cremen := 0;
    End if;

    return ln_cremen;

  end fn_cr_crecimiento_mensual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_creci_men_cli
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CRECI_MEN_CLI
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento mensual de clientes de mantenimiento de cartera
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_crecli: crecimiento en clientes
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_Nrocli  number(10);
    ln_CliOtor number(10);
    ln_CliRecb number(10);
    ln_Cliant  number(10);
    ln_crecli  number(10);

  begin
    ln_Nrocli  := pq_ah_jaql551.fn_cr_Nrocli_acutal(P_IN_usuario); -- Clientes actuales
    ln_CliOtor := pq_ah_jaql551.fn_cr_cliente_otorgado(P_IN_usuario,
                                                       P_IN_fecha); -- Clientes traslado anterior
    ln_CliRecb := pq_ah_jaql551.fn_cr_cliente_recibido(P_IN_usuario,
                                                       P_IN_fecha); -- Clientes traslado recibido
    ln_Cliant  := pq_ah_jaql551.fn_cr_nrocli_anterior(P_IN_usuario,
                                                      P_IN_fecha); -- Clinetes anterior
    --crecimiento mensual
    begin
      ln_crecli := (ln_Nrocli + ln_CliOtor - ln_CliRecb) - ln_Cliant;

    exception
      when others then
        ln_crecli := 0;
    end;

    if ln_crecli is null
    then
      ln_crecli := 0;
    End if;

    return ln_crecli;

  end fn_cr_creci_men_cli;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_mensual_metas
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CREC_MENSUAL_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/08/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento mensual saldos de metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha del proceso
    -- Parámetros de Salida       : ln_cremen: Crecimiento en saldos metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_SalCap  number(18, 2) := P_IN_saldo;
    ln_TraOtor number(18, 2);
    ln_TraRecb number(18, 2);
    ln_Salant  number(18, 2);
    ln_cremen  number(18, 2);

  begin

    --ln_SalCap  := pq_ah_jaql551.fn_cr_saldo_cap_metas(P_IN_usuario); -- saldo capital
    ln_TraOtor := pq_ah_jaql551.fn_cr_saldo_otor_metas(P_IN_usuario,
                                                       P_IN_fecha); -- saldo traslado anterior
    ln_TraRecb := pq_ah_jaql551.fn_cr_saldo_rec_metas(P_IN_usuario,
                                                      P_IN_fecha); -- saldo traslado recibido
    ln_Salant  := pq_ah_jaql551.fn_cr_saldo_ant_metas(P_IN_usuario,
                                                      P_IN_fecha); -- saldo anterior
    --crecimiento mensual
    begin
      ln_cremen := (ln_SalCap + ln_TraOtor - ln_TraRecb) - ln_Salant;

    exception
      when others then
        ln_cremen := 0;
    end;

    if ln_cremen is null
    then
      ln_cremen := 0;
    End if;

    return ln_cremen;

  end fn_cr_crec_mensual_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_men_cli_metas
  (
    P_IN_Cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CREC_MEN_CLI_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/08/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento mensual de clientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Cliente: Nro de clientes,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_creclie: crecimiento clientes metas
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_cliCap  number(10) := P_IN_Cliente;
    ln_cliOtor number(10);
    ln_cliRecb number(10);
    ln_cliant  number(10);
    ln_creclie number(10);

  begin
    --ln_cliCap  := pq_ah_jaql551.fn_cr_cli_act_metas(P_IN_usuario); -- Numero de clientes
    ln_cliOtor := pq_ah_jaql551.fn_cr_cli_otor_metas(P_IN_usuario,
                                                     P_IN_fecha); -- Clientes traslados otorgados
    ln_cliRecb := pq_ah_jaql551.fn_cr_cli_rec_metas(P_IN_usuario,
                                                    P_IN_fecha); -- clientes traslados recibidos
    ln_cliant  := pq_ah_jaql551.fn_cr_cli_ant_metas(P_IN_usuario,
                                                    P_IN_fecha); -- numero de clientes anterior
    --crecimiento mensual
    begin
      ln_creclie := (ln_cliCap + ln_cliOtor - ln_cliRecb) - ln_cliant;

    exception
      when others then
        ln_creclie := 0;
    end;

    if ln_creclie is null
    then
      ln_creclie := 0;
    End if;

    return ln_creclie;

  end fn_cr_crec_men_cli_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_crec_men_mra_metas
  (
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_Tipase  IN char,
    P_IN_tipage  IN char,
    P_IN_met     IN char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_CREC_MEN_MRA_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento mensual de mora metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso,
    --                              P_IN_Tipase: Tipo de asesor,
    --                              P_IN_tipage: Tipo de agencia,
    --                              P_IN_met: Tipo de meta
    -- Parámetros de Salida       : ln_bonmra: Bonificacion de mora
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_metamra number(18, 2);
    ln_mora    number(18, 2);
    ln_bonmra  number(18, 2);

  begin
    ln_metamra := pq_ah_jaql551.fn_cr_mora_metas(P_IN_Tipase,
                                                 P_IN_tipage,
                                                 P_IN_met); -- meta mora
    ln_mora    := pq_ah_jaql551.fn_cr_saldo_mora(P_IN_usuario, P_IN_fecha); -- saldo mora

   --crecimiento mensual mora

    If ln_mora <= ln_metamra
    then

      Begin

        select jaql580.jaql580mra
          into ln_bonmra
          from jaql580
         where jaql580tase = 'P';

      Exception
        when others then

          ln_bonmra := 0;

      End;

    End If;

    if ln_bonmra is null
    then
      ln_bonmra := 0;
    End if;

    return ln_bonmra;

  end fn_cr_crec_men_mra_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_anual_saldo
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CREC_PLUS_ANUAL_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/08/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el plus anual de saldo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_saldo: Saldo de asesor,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_creanual: crecimiento de saldo anual plus
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_SalCap   number(18, 2) := P_IN_saldo;
    ln_TraOtor  number(18, 2);
    ln_TraRecb  number(18, 2);
    ln_Salmes   number(18, 2);
    ln_creanual number(18, 2);

  begin
    --ln_SalCap  := pq_ah_jaql551.fn_cr_saldo_capital(P_IN_usuario,
    --                                              P_IN_Fecha); -- saldo capital
    ln_TraOtor := pq_ah_jaql551.fn_cr_saldo_otorgado(P_IN_usuario,
                                                     P_IN_fecha); -- saldo traslado anterior
    ln_TraRecb := pq_ah_jaql551.fn_cr_saldo_recibido(P_IN_usuario,
                                                     P_IN_fecha); -- saldo traslado recibido
    ln_Salmes  := pq_ah_jaql551.fn_cr_saldo_mes_base(P_IN_usuario,
                                                     P_IN_fecha); -- saldo anterior
    --crecimiento mensual



   ln_creanual := (ln_SalCap + ln_TraOtor - ln_TraRecb) - ln_Salmes;



    if ln_creanual is null
    then
      ln_creanual := 0;
    End if;

    return ln_creanual;

  end fn_crec_plus_anual_saldo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_mes_saldo
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CREC_PLUS_MES_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento de plus mensual saldo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_saldo: Saldo de asesor,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_cremetas: crecimiento mensual de plus de saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_SalCap   number(18, 2) := P_IN_Saldo;
    ln_TraOtor  number(18, 2);
    ln_TraRecb  number(18, 2);
    ln_Salant   number(18, 2);
    ln_cremetas number(18, 2);

  begin
    -- ln_SalCap  := pq_ah_jaql551.fn_cr_saldo_cap_metas(P_IN_usuario,
    --P_IN_Fecha); -- saldo capital
    ln_TraOtor := pq_ah_jaql551.fn_cr_saldo_otor_metas(P_IN_usuario,
                                                       P_IN_fecha); -- saldo traslado anterior
    ln_TraRecb := pq_ah_jaql551.fn_cr_saldo_rec_metas(P_IN_usuario,
                                                      P_IN_fecha); -- saldo traslado recibido
    ln_Salant  := pq_ah_jaql551.fn_cr_saldo_ant_metas(P_IN_usuario,
                                                      P_IN_fecha); -- saldo anterior
    --crecimiento mensual

    ln_cremetas := (ln_SalCap + ln_TraOtor - ln_TraRecb) - ln_Salant;

    if ln_cremetas is null
    then
      ln_cremetas := 0;
    End if;

    return ln_cremetas;

  end fn_crec_plus_mes_saldo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_anual_saldo
  (
    P_IN_saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_meta    char,
    P_IN_tipase  char,
    P_IN_tipage  char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_PAGO_PLUS_ANUAL_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el pago de plus anual de saldo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_saldo: Saldo de asesor,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso,
    --                              P_IN_meta: tipo de meta,
    --                              P_IN_tipase: tipo de asesor,
    --                              P_IN_tipage: tipo de agencia
    -- Parámetros de Salida       : ln_plus: pago por plus anual
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_paganu    number(18, 2);
    ln_crecanual number(18, 2);
    ln_meta      number(18, 2);
    ln_plus      number(3, 2);

  begin

    ln_crecanual := pq_ah_jaql551.fn_crec_plus_anual_saldo(P_IN_Saldo,
                                                           P_IN_usuario,
                                                           P_IN_fecha);
    ln_meta      := pq_ah_jaql551.fn_cr_cred_metas(P_IN_meta,
                                                   P_IN_tipase,
                                                   P_IN_tipage);
    ln_plus      := pq_ah_jaql551.fn_cr_plus_anual_saldo(P_IN_tipase,
                                                         P_IN_tipage);

    --pago por plus anual

    IF ln_crecanual > ln_meta THen

    ln_paganu := (ln_crecanual - ln_meta) * ln_plus/100;

    Else

    ln_paganu := 0;

    End If;

    If ln_paganu is null
    then
      ln_paganu := 0;
    End if;

    return ln_paganu;

  end fn_pago_plus_anual_saldo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_men_saldo
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date,
    P_IN_meta    char,
    P_IN_tipase  char,
    P_IN_tipage  char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_PAGO_PLUS_MEN_SALDO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el pago plus mensual de saldo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_saldo: Saldo de asesor,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso,
    --                              P_IN_meta: tipo de meta,
    --                              P_IN_tipase: tipo de asesor,
    --                              P_IN_tipage: tipo de agencia
    -- Parámetros de Salida       : ln_pagmen: pago mensual de plus de saldo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_plus   number(10);
    ln_cremen number(18, 2);
    ln_meta   number(18, 2);
    ln_creanu number(10);
    ln_pagmen number(10);

  begin

    ln_creanu := pq_ah_jaql551.fn_crec_plus_anual_saldo(P_IN_Saldo,
                                                        P_IN_usuario,
                                                        P_IN_Fecha); -- crecimiento anual plus
    ln_meta   := pq_ah_jaql551.fn_cr_cred_metas(P_IN_meta,
                                                P_IN_tipase,
                                                P_IN_tipage); -- metas plus
    ln_cremen := pq_ah_jaql551.fn_crec_plus_mes_saldo(P_IN_Saldo,
                                                      P_IN_usuario,
                                                      P_IN_fecha); -- crecimiento mensual plus
    ln_plus   := pq_ah_jaql551.fn_cr_plus_mes_saldo(P_IN_tipase,
                                                    P_IN_tipage); -- plus

    --crecimiento mensual

    If ln_creanu > ln_meta then

    ln_pagmen := ((ln_creanu - ln_meta) - (ln_cremen - ln_meta)) *
                   ln_plus/100;
    Else

    ln_pagmen := 0;

    End If;

    if ln_pagmen is null
    then
      ln_pagmen := 0;
    End if;

    return ln_pagmen;

  end fn_pago_plus_men_saldo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_anual_cliente
  (
    P_IN_cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CREC_PLUS_ANUAL_CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento anual de clientes
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: nro de clientes ,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_cremen: crecimiento de plus anual cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_cliCap  number(10) := P_IN_cliente;
    ln_cliOtor number(10);
    ln_cliRecb number(10);
    ln_climes  number(10);
    ln_cremen  number(10);

  begin
    --ln_SalCap  := pq_ah_jaql551.fn_cr_saldo_capital(P_IN_usuario,
    --                                                P_IN_Fecha); -- saldo capital
    ln_cliOtor := pq_ah_jaql551.fn_cr_cli_otor_metas(P_IN_usuario,
                                                     P_IN_fecha); -- saldo traslado anterior
    ln_cliRecb := pq_ah_jaql551.fn_cr_cli_rec_metas(P_IN_usuario,
                                                    P_IN_fecha); -- saldo traslado recibido
    ln_climes  := pq_ah_jaql551.fn_cr_cliente_mes_base(P_IN_usuario,
                                                    P_IN_fecha); -- saldo anterior
    --crecimiento mensual
    ln_cremen := (ln_cliCap + ln_cliOtor - ln_cliRecb) - ln_climes;

    If ln_cremen is null
    then
      ln_cremen := 0;
    End if;

    return ln_cremen;

  end fn_crec_plus_anual_cliente;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_crec_plus_men_cliente
  (
    P_IN_cliente number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CREC_PLUS_MEN_CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el crecimiento plus mensual de cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: nro de clientes ,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_cremen: crecimiento mensual cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_cliact  number(10) := P_IN_cliente;
    ln_cliOtor number(10);
    ln_cliRecb number(10);
    ln_cliant  number(10);
    ln_cremen  number(10);

  begin
    -- ln_cliact  := --pq_ah_jaql551.fn_cr_cli_act_metas(P_IN_usuario); -- Clientes Actuales
    ln_cliOtor := pq_ah_jaql551.fn_cr_cli_otor_metas(P_IN_usuario,
                                                     P_IN_fecha); -- Clientes Otorgados
    ln_cliRecb := pq_ah_jaql551.fn_cr_cli_rec_metas(P_IN_usuario,
                                                    P_IN_fecha); -- Clientes recibidos
    ln_cliant  := pq_ah_jaql551.fn_cr_cli_ant_metas(P_IN_usuario,
                                                    P_IN_fecha); -- CLientes antesriores
    --crecimiento mensual

    ln_cremen := (ln_cliact + ln_cliOtor - ln_cliRecb) - ln_cliant;

    if ln_cremen is null
    then
      ln_cremen := 0;
    End if;

    return ln_cremen;

  end fn_crec_plus_men_cliente;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_anual_cliente
  (
    P_IN_cliente in number,
    P_IN_Usuario in char,
    P_IN_fecha   in date,
    P_IN_Tipase  in char,
    P_IN_tipage  in char,
    P_IN_met     in char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_PAGO_PLUS_ANUAL_CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el plus de pago anual de cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: nro de clientes ,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso,
    --                              P_IN_Tipase: Tipo de asesor,
    --                              P_IN_tipage: tipo de agencia,
    --                              P_IN_met: tipo de meta
    -- Parámetros de Salida       : ln_plus: pago de plus anual cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_paganu    number(10);
    ln_crecanual number(10);
    ln_meta      number(10);
    ln_plus      number(10);

  Begin

    ln_crecanual := pq_ah_jaql551.fn_crec_plus_anual_cliente(P_IN_cliente,
                                                             P_IN_Usuario,
                                                             P_IN_fecha);

    ln_meta := pq_ah_jaql551.fn_cr_clie_metas(P_IN_Tipase,
                                              P_IN_tipage,
                                              P_IN_met);
    ln_plus := pq_ah_jaql551.fn_cr_plus_anual_clie(P_IN_Tipase, P_IN_tipage);

    --pago por plus anual

    If ln_crecanual > ln_meta then

    ln_paganu := (ln_crecanual - ln_meta) * ln_plus;

    Else

    ln_paganu := 0;

    End if;

    if ln_paganu is null
    then
      ln_paganu := 0;
    End if;

    return ln_paganu;

  end fn_pago_plus_anual_cliente;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_men_cliente
  (
    P_IN_cliente in number,
    P_IN_usuario in char,
    P_IN_fecha   in date,
    P_IN_Tipase  in char,
    P_IN_tipage  in char,
    P_IN_met     in char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_PAGO_PLUS_MEN_CLIENTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el pago de plus mensual de cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_cliente: nro de clientes ,
    --                              P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso,
    --                              P_IN_Tipase: Tipo de asesor,
    --                              P_IN_tipage: tipo de agencia,
    --                              P_IN_met: tipo de meta
    -- Parámetros de Salida       : ln_plus: pago por plus mensual de cliente
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_pagmen    number(10);
    ln_crecanual number(10);
    ln_cremen    number(10);
    ln_meta      number(10);
    ln_plus      number(10);

  Begin

    ln_crecanual := pq_ah_jaql551.fn_crec_plus_anual_cliente(P_IN_cliente,
                                                             P_IN_usuario,
                                                             P_IN_fecha);
    ln_cremen    := pq_ah_jaql551.fn_crec_plus_men_cliente(P_IN_cliente,
                                                           P_IN_usuario,
                                                           P_IN_fecha);
    ln_meta      := pq_ah_jaql551.fn_cr_clie_metas(P_IN_Tipase,
                                                   P_IN_tipage,
                                                   P_IN_met);
    ln_plus      := pq_ah_jaql551.fn_cr_plus_mes_clie(P_IN_Tipase,
                                                      P_IN_tipage);

    --pago por plus anual

    If ln_crecanual > ln_meta then

    ln_pagmen := ((ln_crecanual - ln_meta) - (ln_cremen - ln_meta)) *
                   ln_plus;

    Else

    ln_pagmen := 0;

    End If;

    if ln_pagmen is null
    then
      ln_pagmen := 0;
    End if;

    return ln_pagmen;

  end fn_pago_plus_men_cliente;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_pago_plus_cliente_nuevo
  (
    P_IN_Salcap  IN number,
    P_IN_clasase IN char,
    P_IN_Tipage  IN char
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_PAGO_PLUS_CLIENTE_NUEVO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el pago de plus cliente nuevo
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Salcap: Saldo capital de asesor,
    --                              P_IN_clasase: tipo de asesor,
    --                              P_IN_Tipage: tipo de agencia
    -- Parámetros de Salida       : ln_Plusbo: pago por plus de cliente nuevo
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_Plusbo number(18, 2);

  Begin

    select jaql582plus
      into ln_Plusbo
      from jaql582
     where jaql582tage = P_IN_Tipage
       and jaql582tase = P_IN_clasase
       and P_IN_Salcap >= jaql582smin
       and P_IN_Salcap <= jaql582smax;

    return ln_Plusbo;

  end fn_pago_plus_cliente_nuevo;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_porcentaje_mora
  (
    P_IN_Saldo   number,
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_PORCENTAJE_MORA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el porcentaje de mora del asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Saldo: Saldo de asesor,
    --                              P_IN_usuario: Codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_pormora: porcentaje de mora
    -- Fecha de Modif icación     :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_captot  number(18,2) := P_IN_Saldo; --pq_ah_jaql551.fn_cr_saldo_capital(P_IN_usuario, P_IN_Fecha);
    ln_capsak  number(18,2) := pq_ah_jaql551.fn_cr_saldo_mora(P_IN_usuario,
                                                            P_IN_fecha);
    --ln_saljud jaql583.jaql583sdju%type := pq_ah_jaql551.fn_cr_saldo_judiciales(P_IN_usuario, P_IN_Fecha);
    --ln_salcas jaql583.jaql583sdca%type := pq_ah_jaql551.fn_cr_saldo_castigo(P_IN_usuario, P_IN_Fecha);
    --ln_capmor number(18,2);
    ln_pormora jaql583.jaql583pmra%type;

  Begin

    If ln_captot is not null Or ln_captot >= 0  Then

      --ln_capmor := ln_capsak + ln_salcas + ln_saljud;
      ln_pormora := (ln_capsak / ln_captot) * 100;

    End if;

    return nvl(ln_pormora,0);

  End fn_cr_porcentaje_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_saldo_mora
  (
    P_IN_usuario char,
    P_IN_fecha   date
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_SALDO_MORA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el saldo de mora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_usuario: codigo de asesor,
    --                              P_IN_fecha: fecha de proceso
    -- Parámetros de Salida       : ln_capsak: capital de saldo en mora
    -- Fecha de Modif icación     :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
    ln_capsak jaql583.jaql583sdm%type;
    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);
    ln_sadjud jaql583.jaql583sdju%type := pq_ah_jaql551.fn_cr_saldo_judiciales(P_IN_usuario, P_IN_fecha);
    ln_sadcas jaql583.jaql583sdca%type := pq_ah_jaql551.fn_cr_saldo_castigo(P_IN_usuario, P_IN_fecha);

  Begin
    Begin

      -- Saldo de credito

      select sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1)
        into ln_capsak
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 l on f.SCMOD = l.modulo
       where l.dscod = 50
         and x.XWFCAR3 = '1'
         and f.SCSTAT <> 99
         and pq_ah_jaql551.fn_cr_dias_mora(P_IN_fecha,
                                           f.PGCOD,
                                           f.SCSUC,
                                           f.SCMDA,
                                           f.SCPAP,
                                           f.SCCTA,
                                           f.SCOPER,
                                           f.SCSBOP,
                                           f.SCTOPE,
                                           f.SCMOD) > 15
         and s.SNG001ASE = P_IN_usuario;

      ln_capsak := ln_capsak + ln_sadjud + ln_sadcas;

      return nvl(ln_capsak,0);
    end;

  End fn_cr_saldo_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Function fn_cr_dias_mora
  (
    P_IN_fecha in date,
    P_IN_PGCOD in number,
    P_IN_SCSUC in number,
    P_IN_SCMDA in number,
    P_IN_SCPAP in number,
    P_IN_SCCTA in number,
    P_IN_SCOPER in number,
    P_IN_SCSBOP in number,
    P_IN_SCTOPE in number,
    P_IN_SCMOD in number
  ) return number is
    -- *****************************************************************
    -- Nombre                     : FN_CR_DIAS_MORA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Devuelve el numero de dias mora
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_fecha: fecha de proceso,
    --                              P_IN_PGCOD: codigo de empresa,
    --                              P_IN_SCSUC: sucursal,
    --                              P_IN_SCMDA: moneda,
    --                              P_IN_SCPAP: papel,
    --                              P_IN_SCCTA: cuenta,
    --                              P_IN_SCOPER: operacion,
    --                              P_IN_SCSBOP: sub-operacion,
    --                              P_IN_SCTOPE: tipo de operacion,
    --                              P_IN_SCMOD: modulo
    -- Parámetros de Salida       : ln_diamora: numero de dias mora del credito
    -- Fecha de Modif icación     :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_diamora number(10);

  Begin
    Begin
      select P_IN_Fecha - min(f.ppfpag)
        into ln_diamora
        from fsd601 f
       where not exists (select 1
                from fsd602 t
               where t.PGCOD = f.PGCOD
                 and t.PPMOD = f.PPMOD
                 and t.PPSUC = f.PPSUC
                 and t.PPMDA = f.PPMDA
                 and t.PPPAP = f.PPPAP
                 and t.PPCTA = f.PPCTA
                 and t.PPOPER = f.PPOPER
                 and t.PPSBOP = f.PPSBOP
                 and t.PPTOPE = f.PPTOPE
                 and t.PPFPAG = f.PPFPAG
                 and t.pp1stat = 'T'
                 and t.d602co = 'S')
         and  f.PGCOD = P_IN_PGCOD
         and  f.PPSUC = P_IN_SCSUC
         and  f.PPMDA = P_IN_SCMDA
         and  f.PPPAP = P_IN_SCPAP
         and  f.PPCTA = P_IN_SCCTA
         and  f.PPOPER = P_IN_SCOPER
         and  f.PPSBOP = P_IN_SCSBOP
         and  f.PPTOPE = P_IN_SCTOPE
         and  f.PPMOD = P_IN_SCMOD
         and f.ppfpag <= P_IN_fecha
         and f.d601co = 'S';
    exception
      when no_data_found then
        ln_diamora := 0;
      when self_is_null then
        ln_diamora := 0;
      when others then
        ln_diamora := 0;
    end;

    If ln_diamora is null
    then
      ln_diamora := 0;
    End If;

    return ln_diamora;

  end fn_cr_dias_mora;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_bonificacion_analista(P_IN_Fecha Date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_BONIFICACION_ANALISTA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Realiza el proceso de bonificacion de asesores
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

    cursor cur_01 is --Definicion del cur_01 para bonificaciones
      select s.sng001ase,
             pq_ah_jaql551.fn_cr_contmes_anterior(s.SNG001ASE),
             pq_ah_jaql551.fn_cr_contdias_anterior(s.SNG001ASE),
             P_IN_Fecha,
             sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1),
             count(distinct to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                   to_char(s.SNG001NDOC)),
             1,
             t.ubsuc,
             pq_ah_jaql551.fn_cr_cliente_cali(count(distinct
                                                    to_char(s.SNG001PAIS) ||
                                                    to_char(s.SNG001TDOC) ||
                                                    to_char(s.SNG001NDOC))),
             pq_ah_jaql551.fn_cr_credito_cali(sum(decode(f.SCMDA,
                                                         101,
                                                         f.SCSDO * ln_tipcam,
                                                         f.SCSDO) * -1)),
             pq_ah_jaql551.fn_cr_saldo_anterior(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_nrocli_anterior(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_crecimiento_mensual(s.sng001ase,
                                                     P_IN_fecha),
             pq_ah_jaql551.fn_cr_tipo_agencia(t.ubsuc),
             pq_ah_jaql551.fn_cr_saldo_otorgado(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_saldo_recibido(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_creci_men_cli(s.sng001ase, P_IN_fecha),
             pq_ah_jaql551.fn_cr_cliente_recibido(s.sng001ase, P_IN_fecha),
             pq_ah_jaql551.fn_cr_cliente_otorgado(s.sng001ase, P_IN_fecha),
             'S'
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
       group by s.sng001ase,
                t.ubsuc,
                g.pgfape;

    -- defincion de tipos

    Type tp_JAQL572USU is table of jaql572.jaql572usu%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572MANT is table of jaql572.jaql572mant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572DANT is table of jaql572.jaql572dant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572FPRO is table of jaql572.jaql572fpro%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572SCRE is table of jaql572.jaql572scre%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572NCLI is table of jaql572.jaql572ncli%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572COD is table of jaql572.jaql572cod%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572AGEN is table of jaql572.jaql572agen%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572CCLI is table of jaql572.jaql572ccli%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572CSAL is table of jaql572.jaql572csal%type INDEX BY PLS_INTEGER;
    type tp_JAQL572SANT is table of jaql572.jaql572sant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572NCL is table of jaql572.jaql572ncl%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572CME is table of jaql572.jaql572cme%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572TAGE is table of jaql572.jaql572tage%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572SOTO is table of jaql572.jaql572soto%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572SREC is table of jaql572.jaql572srec%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572CMCL is table of jaql572.jaql572cmcl%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572CREC is table of jaql572.jaql572crec%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572COTO is table of jaql572.jaql572coto%type INDEX BY PLS_INTEGER;
    Type tp_JAQL572EST  is table of jaql572.jaql572est%type INDEX BY PLS_INTEGER;

    JAQL572USU  tp_JAQl572USU;
    JAQL572MANT tp_JAQL572MANT;
    JAQL572DANT tp_JAQL572DANT;
    JAQL572FPRO tp_JAQL572FPRO;
    JAQL572SCRE tp_JAQL572SCRE;
    JAQL572NCLI tp_JAQL572NCLI;
    JAQL572COD  tp_JAQL572COD;
    JAQL572AGEN tp_JAQL572AGEN;
    JAQL572CCLI tp_JAQL572CCLI;
    JAQL572CSAL tp_JAQL572CSAL;
    JAQL572SANT tp_JAQL572SANT;
    JAQL572NCL  tp_JAQL572NCL;
    JAQL572CME  tp_JAQL572CME;
    JAQL572TAGE tp_JAQL572TAGE;
    JAQL572SOTO tp_JAQL572SOTO;
    JAQL572SREC tp_JAQL572SREC;
    JAQL572CMCL tp_JAQL572CMCL;
    JAQL572CREC tp_JAQL572CREC;
    JAQL572COTO tp_JAQL572COTO;
    JAQL572EST  tp_JAQL572EST;

  Begin

    open cur_01;
    Loop
      fetch cur_01 bulk collect
        into JAQL572USU, JAQL572MANT, JAQL572DANT, JAQL572FPRO, JAQL572SCRE, JAQL572NCLI, JAQL572COD, JAQL572AGEN, JAQL572CCLI, JAQL572CSAL, JAQL572SANT, JAQL572NCL, JAQL572CME, JAQL572TAGE, JAQL572SOTO, JAQL572SREC, JAQL572CMCL, JAQL572CREC, JAQL572COTO, JAQL572EST limit 10000;

      If JAQL572USU.count > 0
      Then
        Forall x in JAQL572USU.first .. JAQL572USU.last

          INSERT INTO JAQL572
            (JAQL572USU,
             JAQL572MANT,
             JAQL572DANT,
             JAQL572FPRO,
             JAQL572SCRE,
             JAQL572NCLI,
             JAQL572COD,
             JAQL572AGEN,
             JAQL572CCLI,
             JAQL572CSAL,
             JAQL572SANT,
             JAQL572NCL,
             JAQL572CME,
             JAQL572TAGE,
             JAQL572SOTO,
             JAQL572SREC,
             JAQL572CMCL,
             JAQL572CREC,
             JAQL572COTO,
             JAQL572EST)
          Values
            (JAQL572USU(x),
             JAQL572MANT(x),
             JAQL572DANT(x),
             JAQL572FPRO(x),
             JAQL572SCRE(x),
             JAQL572NCLI(x),
             JAQL572COD(x),
             JAQL572AGEN(x),
             JAQL572CCLI(x),
             JAQL572CSAL(x),
             JAQL572SANT(x),
             JAQL572NCL(x),
             JAQL572CME(x),
             JAQL572TAGE(x),
             JAQL572SOTO(x),
             JAQL572SREC(x),
             JAQL572CMCL(x),
             JAQL572CREC(x),
             JAQL572COTO(x),
             JAQL572EST(x));
      End If;
      Exit When cur_01%notfound;
    End loop;
    close cur_01;
    commit;
    pq_ah_jaql551.sp_cr_actualiza_bono(P_IN_Fecha);

  End sp_cr_bonificacion_analista;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_bonificacion_metas(P_IN_Fecha IN Date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_BONIFICACION_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Inserta bonificaciones por meta pero por asesor
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

    cursor cur_01 is --Definicion del cur_01 para bonificaciones metas
      Select s.SNG001ASE,
             P_IN_Fecha,
             pq_ah_jaql551.fn_cr_contmes_anterior(s.SNG001ASE), --JAQL583MANT
             pq_ah_jaql551.fn_cr_contdias_anterior(s.SNG001ASE), --JAQL583DANT
             sum(decode(f.SCMDA, 101, f.SCSDO * ln_tipcam, f.SCSDO) * -1), --JAQL583SDO
             count(distinct to_char(s.SNG001PAIS) || to_char(s.SNG001TDOC) ||
                   to_char(s.SNG001NDOC)), --JAQL583NCL
             l.jaql584smra, --JAQL583SDM
             l.jaql584pmra, --JAQL583PMRA
             pq_ah_jaql551.fn_cr_saldo_otor_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583SOTO
             pq_ah_jaql551.fn_cr_saldo_rec_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583SREC
             pq_ah_jaql551.fn_cr_cli_otor_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583COT
             pq_ah_jaql551.fn_cr_cli_rec_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583CREC
             1, --JAQL583PCOD
             l.jaql584age, --JAQL583AGE
             l.jaql584ease, --JAQL583TUSU
             l.jaql584aget, --JAQL583TAGE
             l.jaql584met, --JAQL583TMET
             pq_ah_jaql551.fn_cr_crec_mensual_metas(l.jaql584sald,
                                                    s.SNG001ASE,
                                                    P_IN_Fecha), --JAQL583CRSA
             pq_ah_jaql551.fn_cr_crec_men_cli_metas(count(distinct
                                                          to_char(s.SNG001PAIS) ||
                                                          to_char(s.SNG001TDOC) ||
                                                          to_char(s.SNG001NDOC)),
                                                    s.SNG001ASE,
                                                    P_IN_Fecha), --JAQL583CRCL
             pq_ah_jaql551.fn_cr_crec_men_mra_metas(s.SNG001ASE,
                                                    P_IN_Fecha,
                                                    l.jaql584ease,
                                                    l.jaql584aget,
                                                    l.jaql584met), --JAQL583CRMA
             pq_ah_jaql551.fn_crec_plus_anual_saldo(l.jaql584sald,
                                                    s.SNG001ASE,
                                                    P_IN_Fecha), --JAQL583CRAN
             pq_ah_jaql551.fn_crec_plus_mes_saldo(l.jaql584sald,
                                                  s.SNG001ASE,
                                                  P_IN_Fecha), --JAQL583CRME
             pq_ah_jaql551.fn_crec_plus_anual_cliente(count(distinct
                                                            to_char(s.SNG001PAIS) ||
                                                            to_char(s.SNG001TDOC) ||
                                                            to_char(s.SNG001NDOC)),
                                                      s.SNG001ASE,
                                                      P_IN_Fecha), -- JAQL583CRCA
             pq_ah_jaql551.fn_crec_plus_men_cliente(count(distinct
                                                          to_char(s.SNG001PAIS) ||
                                                          to_char(s.SNG001TDOC) ||
                                                          to_char(s.SNG001NDOC)),
                                                    s.SNG001ASE,
                                                    P_IN_Fecha), -- JAQL583CRCM
             pq_ah_jaql551.fn_cr_saldo_ant_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583SANT
             pq_ah_jaql551.fn_cr_cli_ant_metas(s.SNG001ASE, P_IN_Fecha), --JAQL583CANT
             pq_ah_jaql551.fn_cr_saldo_mes_base(s.SNG001ASE, P_IN_Fecha), --JAQL583SMAX
             pq_ah_jaql551.fn_cr_cliente_mes_base(s.SNG001ASE, P_IN_Fecha), --JAQL583CMAX

             pq_ah_jaql551.fn_cr_cred_metas(l.jaql584met,
                                            l.jaql584ease,
                                            l.jaql584aget), -- JAQL583MTSA
             pq_ah_jaql551.fn_cr_clie_metas(l.jaql584ease,
                                            l.jaql584aget,
                                            l.jaql584met), -- JAQL583MTCL
             pq_ah_jaql551.fn_cr_mora_metas(l.jaql584ease,
                                            l.jaql584aget,
                                            l.jaql584met), -- JAQL583MTMR
             pq_ah_jaql551.fn_cr_Nrocli_nuevo(s.SNG001ASE, P_IN_Fecha),
             l.jaql584sdjud,
             l.jaql584sdcas,
             l.jaql584sdcn,
             pq_ah_jaql551.fn_cr_fecha_sal_mes_base(s.SNG001ASE, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_fecha_cli_mes_base(s.SNG001ASE, P_IN_Fecha),
             'S'
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.XWFEMPRESA
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join jaql584 l on l.jaql584ase = s.SNG001ASE
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
       group by s.sng001ase,
                t.ubsuc,
                g.pgfape,
                l.jaql584sald,
                l.jaql584age,
                l.jaql584ease,
                l.jaql584aget,
                l.jaql584met,
                l.jaql584smra,
                l.jaql584pmra,
                l.jaql584sdjud,
                l.jaql584sdcas,
                l.jaql584sdcn;

    -- defincion de tipos

    Type tp_JAQL583USU is table of jaql583.jaql583usu%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583FPRO is table of jaql583.jaql583fpro%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583MANT is table of jaql583.jaql583mant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583DANT is table of jaql583.jaql583dant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SDO is table of jaql583.jaql583sdo%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583NCL is table of jaql583.jaql583ncl%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SDM is table of jaql583.jaql583sdm%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583PMRA is table of jaql583.jaql583pmra%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SOTO is table of jaql583.jaql583soto%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SREC is table of jaql583.jaql583srec%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583COT is table of jaql583.jaql583cot%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CREC is table of jaql583.jaql583crec%type INDEX BY PLS_INTEGER;
    type tp_JAQL583PCOD is table of jaql583.jaql583pcod%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583AGE is table of jaql583.jaql583age%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583TUSU is table of jaql583.jaql583tusu%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583TAGE is table of jaql583.jaql583tage%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583TMET is table of jaql583.jaql583tmet%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRSA is table of jaql583.jaql583crsa%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRCL is table of jaql583.jaql583crcl%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRMA is Table of jaql583.jaql583crma%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRAN is table of jaql583.jaql583cran%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRME is table of jaql583.jaql583crme%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRCA is table of jaql583.jaql583crca%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CRCM is table of jaql583.jaql583crcm%type INDEX BY PLS_INTEGER;
    /*Type tp_JAQL583PPLA is table of jaql583.jaql583ppla%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583PPLM is table of jaql583.jaql583pplm%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583PPCA is table of jaql583.jaql583ppca%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583PPCM is table of jaql583.jaql583ppcm%type INDEX BY PLS_INTEGER;*/
    Type tp_JAQL583SANT is table of jaql583.jaql583sant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CANT is table of jaql583.jaql583cant%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SMAX is table of jaql583.jaql583smax%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583CMAX is table of jaql583.jaql583cmax%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583MTSA is table of jaql583.jaql583mtsa%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583MTCL is table of jaql583.jaql583mtcl%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583MTMR is table of jaql583.jaql583mtmr%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583NCN  is table of jaql583.jaql583ncn%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SDJU is table of jaql583.jaql583sdju%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SDCA is table of jaql583.jaql583sdca%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583SDCN is table of jaql583.jaql583sdcn%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583FSMAX is table of jaql583.jaql583fsmax%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583FCMAX is table of jaql583.jaql583fcmax%type INDEX BY PLS_INTEGER;
    Type tp_JAQL583EST is table of jaql583.jaql583est%type INDEX BY PLS_INTEGER;

    JAQL583USU  tp_JAQL583USU;
    JAQL583FPRO tp_JAQL583FPRO;
    JAQL583MANT tp_JAQL583MANT;
    JAQL583DANT tp_JAQL583DANT;
    JAQL583SDO  tp_JAQL583SDO;
    JAQL583NCL  tp_JAQL583NCL;
    JAQL583SDM  tp_JAQL583SDM;
    JAQL583PMRA tp_JAQL583PMRA;
    JAQL583SOTO tp_JAQL583SOTO;
    JAQL583SREC tp_JAQL583SREC;
    JAQL583COT  tp_JAQL583COT;
    JAQL583CREC tp_JAQL583CREC;
    JAQL583PCOD tp_JAQL583PCOD;
    JAQL583AGE  tp_JAQL583AGE;
    JAQL583TUSU tp_JAQL583TUSU;
    JAQL583TAGE tp_JAQL583TAGE;
    JAQL583TMET tp_JAQL583TMET;
    JAQL583CRSA tp_JAQL583CRSA;
    JAQL583CRCL tp_JAQL583CRCL;
    JAQL583CRMA tp_JAQL583CRMA;
    JAQL583CRAN tp_JAQL583CRAN;
    JAQL583CRME tp_JAQL583CRME;
    JAQL583CRCA tp_JAQL583CRCA;
    JAQL583CRCM tp_JAQL583CRCM;
    /*JAQL583PPLA tp_JAQL583PPLA;
    JAQL583PPLM tp_JAQL583PPLM;
    JAQL583PPCA tp_JAQL583PPCA;
    JAQL583PPCM tp_JAQL583PPCM;*/
    JAQL583SANT tp_JAQL583SANT;
    JAQL583CANT tp_JAQL583CANT;
    JAQL583SMAX tp_JAQL583SMAX;
    JAQL583CMAX tp_JAQL583CMAX;
    JAQL583MTSA tp_JAQL583MTSA;
    JAQL583MTCL tp_JAQL583MTCL;
    JAQL583MTMR tp_JAQL583MTMR;
    JAQL583NCN  tp_JAQL583NCN;
    JAQL583SDJU tp_JAQL583SDJU;
    JAQL583SDCA tp_JAQL583SDCA;
    JAQL583SDCN tp_JAQL583SDCN;
    JAQL583FSMAX tp_JAQL583FSMAX;
    JAQL583FCMAX tp_JAQL583FCMAX;
    JAQL583EST  tp_JAQL583EST;
  Begin

    --EXECUTE IMMEDIATE ('DELETE FROM JAQL583 WHERE JAQL583FPRO = P_IN_Fecha');
    pq_ah_jaql551.sp_cr_iniciar_productividad(P_IN_Fecha);

    open cur_01;
    Loop
      fetch cur_01 bulk collect
        into JAQL583USU, JAQL583FPRO, JAQL583MANT, JAQL583DANT, JAQL583SDO,
             JAQL583NCL, JAQL583SDM, JAQL583PMRA, JAQL583SOTO, JAQL583SREC,
             JAQL583COT, JAQL583CREC, JAQL583PCOD, JAQL583AGE, JAQL583TUSU,
             JAQL583TAGE, JAQL583TMET, JAQL583CRSA, JAQL583CRCL, JAQL583CRMA,
             JAQL583CRAN, JAQL583CRME, JAQL583CRCA, JAQL583CRCM, /*JAQL583PPLA, JAQL583PPLM, JAQL583PPCA, JAQL583PPCM,*/
             JAQL583SANT, JAQL583CANT, JAQL583SMAX, JAQL583CMAX, JAQL583MTSA,
             JAQL583MTCL, JAQL583MTMR, JAQL583NCN, JAQL583SDJU, JAQL583SDCA,
             JAQL583SDCN, JAQL583FSMAX, JAQL583FCMAX, JAQL583EST limit 10000;

      If JAQL583USU.count > 0
      Then
        Forall x in JAQL583USU.first .. JAQL583USU.last

          INSERT INTO JAQL583
            (JAQL583USU,
             JAQL583FPRO,
             JAQL583MANT,
             JAQL583DANT,
             JAQL583SDO,
             JAQL583NCL,
             JAQL583SDM,
             JAQL583PMRA,
             JAQL583SOTO,
             JAQL583SREC,
             JAQL583COT,
             JAQL583CREC,
             JAQL583PCOD,
             JAQL583AGE,
             JAQL583TUSU,
             JAQL583TAGE,
             JAQL583TMET,
             JAQL583CRSA,
             JAQL583CRCL,
             JAQL583CRMA,
             JAQL583CRAN,
             JAQL583CRME,
             JAQL583CRCA,
             JAQL583CRCM,
             /*JAQL583PPLA,
                           JAQL583PPLM,
                           JAQL583PPCA,
                           JAQL583PPCM,*/
             JAQL583SANT,
             JAQL583CANT,
             JAQL583SMAX,
             JAQL583CMAX,
             JAQL583MTSA,
             JAQL583MTCL,
             JAQL583MTMR,
             JAQL583NCN,
             JAQL583SDJU,
             JAQL583SDCA,
             JAQL583SDCN,
             JAQL583FSMAX,
             JAQL583FCMAX,
             JAQL583EST)
          Values
            (JAQL583USU(x),
             JAQL583FPRO(x),
             JAQL583MANT(x),
             JAQL583DANT(x),
             JAQL583SDO(x),
             JAQL583NCL(x),
             JAQL583SDM(x),
             JAQL583PMRA(x),
             JAQL583SOTO(x),
             JAQL583SREC(x),
             JAQL583COT(x),
             JAQL583CREC(x),
             JAQL583PCOD(x),
             JAQL583AGE(x),
             JAQL583TUSU(x),
             JAQL583TAGE(x),
             JAQL583TMET(x),
             JAQL583CRSA(x),
             JAQL583CRCL(x),
             JAQL583CRMA(x),
             JAQL583CRAN(x),
             JAQL583CRME(x),
             JAQL583CRCA(x),
             JAQL583CRCM(x),
             /* JAQL583PPLA(x),
                           JAQL583PPLM(x),
                           JAQL583PPCA(x),
                           JAQL583PPCM(x),*/
             JAQL583SANT(x),
             JAQL583CANT(x),
             JAQL583SMAX(x),
             JAQL583CMAX(x),
             JAQL583MTSA(x),
             JAQL583MTCL(x),
             JAQL583MTMR(x),
             JAQL583NCN(x),
             JAQL583SDJU(x),
             JAQL583SDCA(x),
             JAQL583SDCN(x),
             JAQL583FSMAX(x),
             JAQL583FCMAX(x),
             JAQL583EST(x));

      End If;
      Exit When cur_01%notfound;
    End loop;
    close cur_01;
    commit;

    pq_ah_jaql551.sp_cr_act_bono_metas(P_IN_Fecha);

  end sp_cr_bonificacion_metas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_actualiza_bono(P_IN_Fecha Date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_ACTUALIZA_BONO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Actualiza los bonos por asesor de acuerdo a su crecimiento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_bonocli jaql572.jaql572bcli%type := 0;
    ln_bonosal jaql572.jaql572bsal%type := 0;
    lc_asesor  jaql572.jaql572usu%type;
    lc_asesor1 jaql572.jaql572usu%type;

    cursor cur_02 is -- actualizar saldos

      Select h.jaql571bono,
             j.jaql572usu
        from jaql571 h,
             jaql572 j
       where h.jaql571tipo = j.jaql572csal
         and h.jaql571age = j.jaql572tage
         and j.jaql572fpro = P_IN_Fecha;

    cursor cur_03 is -- actualizar cliente

      Select g.jaql570bono,
             j.jaql572usu
        from jaql570 g,
             jaql572 j
       where g.jaql570tipo = j.jaql572ccli
         and g.jaql570age = j.jaql572tage
         and j.jaql572fpro = P_IN_Fecha;

    --actualizacion de bonos saldos
  begin
    OPEN cur_02;
    FETCH cur_02
      INTO ln_bonosal, lc_asesor;
    WHILE cur_02%found
    LOOP
      UPDATE JAQL572
         SET JAQL572BSAL = ln_bonosal
       WHERE JAQL572FPRO = P_IN_Fecha
         and JAQL572USU = lc_asesor
         and JAQL572CME > 0;

      FETCH cur_02
        INTO ln_bonosal, lc_asesor;
    END LOOP;
    CLOSE cur_02;
    COMMIT;

    --actualizacion de bonos clientes

    OPEN cur_03;
    FETCH cur_03
      INTO ln_bonocli, lc_asesor1;
    WHILE cur_03%found
    LOOP
      UPDATE JAQL572
         SET JAQL572BCLI = ln_bonocli
       WHERE JAQL572FPRO = P_IN_Fecha
         and JAQL572USU = lc_asesor1
         and JAQL572CMCL > 0;

      FETCH cur_03
        INTO ln_bonocli, lc_asesor1;
    END LOOP;
    CLOSE cur_03;
    COMMIT;

  End sp_cr_actualiza_bono;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_act_bono_metas(P_IN_Fecha Date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_ACT_BONO_METAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Actualiza bonos de asesor por metas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_bonocli jaql583.JAQL583BCLI%type := 0;
    ln_bonosal jaql583.JAQL583BSAL%type := 0;
    ln_bonomra jaql583.jaql583bmra%type := 0;
    ln_pagsala jaql583.jaql583ppla%type := 0;
    ln_pagsalm jaql583.jaql583pplm%type := 0;
    ln_pagclia jaql583.jaql583ppca%type := 0;
    ln_pagclim jaql583.jaql583ppcm%type := 0;
    ln_pagcne  jaql583.jaql583ppcn%type := 0;
    lc_asesor  jaql583.jaql583usu%type := 0;
    lc_asesor1 jaql583.jaql583usu%type := 0;
    lc_asesor2 jaql583.jaql583usu%type := 0;
    lc_asesor3 jaql583.jaql583usu%type := 0;
    lc_asesor4 jaql583.jaql583usu%type := 0;
    lc_asesor5 jaql583.jaql583usu%type := 0;
    lc_asesor6 jaql583.jaql583usu%type := 0;
    lc_asesor7 jaql583.jaql583usu%type := 0;
    ln_tipcam fsh005.cotcbi%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

    ln_castmra jaql583.jaql583cmra%type := 0;
    lc_asesor8 jaql583.jaql583usu%type := 0;


    cursor cur_02 is -- actualizar saldos

      select nvl(j.jaql580sdo, 0),
             w.jaql583usu
        from jaql580 j,
             jaql583 w
       where j.jaql580tase = w.jaql583tusu
         and w.jaql583fpro = P_IN_Fecha;

    cursor cur_03 is -- actualizar cliente

      Select nvl(j.jaql580cli, 0),
             w.jaql583usu
        from jaql580 j,
             jaql583 w
       where j.jaql580tase = w.jaql583tusu
         and w.jaql583fpro = P_IN_Fecha;

    cursor cur_04 is -- actualizar mora

      select nvl(j.jaql580mra, 0),
             w.jaql583usu
        from jaql580 j,
             jaql583 w
       where j.jaql580tase = w.jaql583tusu
         and w.jaql583fpro = P_IN_Fecha;

    cursor cur_05 is --actualizar plus de saldo anual

      select nvl(pq_ah_jaql551.fn_pago_plus_anual_saldo(t.jaql583sdo,
                                                        t.jaql583usu,
                                                        P_IN_Fecha,
                                                        t.jaql583tmet,
                                                        t.jaql583tusu,
                                                        t.jaql583tage),
                 0),
             t.jaql583usu
        from jaql583 t
       where t.jaql583fpro = P_IN_Fecha;

    cursor cur_06 is --actualizar plus de saldo mensual

      select nvl(pq_ah_jaql551.fn_pago_plus_men_saldo(t.jaql583sdo,
                                                      t.jaql583usu,
                                                      P_IN_Fecha,
                                                      t.jaql583tmet,
                                                      t.jaql583tusu,
                                                      t.jaql583tage),
                 0),
             t.jaql583usu
        from jaql583 t
       where t.jaql583fpro = P_IN_Fecha;

    cursor cur_07 is --actualizar plus de cliente anual

     select nvl(pq_ah_jaql551.fn_pago_plus_anual_cliente(t.jaql583ncl,
                                                         t.jaql583usu,
                                                         P_IN_Fecha,
                                                         t.jaql583tusu,
                                                         t.jaql583tage,
                                                         t.jaql583tmet),
                 0),
             t.jaql583usu
        from jaql583 t
       where t.jaql583fpro = P_IN_Fecha;

    cursor cur_08 is --actualizar plus de cliente mensual

      select nvl(pq_ah_jaql551.fn_pago_plus_men_cliente(t.jaql583ncl,
                                                        t.jaql583usu,
                                                        P_IN_Fecha,
                                                        t.jaql583tusu,
                                                        t.jaql583tage,
                                                        t.jaql583tmet),
                 0),
             t.jaql583usu
        from jaql583 t
       where t.jaql583fpro = P_IN_Fecha;

    -- Actualizar plus clientes nuevos

    cursor cur_09 is
    select pq_ah_jaql551.fn_cr_capital_nuevo(k.jaql583usu,
                                             P_IN_Fecha,
                                             ln_tipcam,
                                             k.jaql583tusu,
                                             k.jaql583tage),
         k.jaql583usu
    from jaql583 k
    where k.jaql583bcli > 0
         and k.jaql583crca > 0
         and k.jaql583ncn > 0
      and k.jaql583fpro = P_IN_Fecha;


  cursor cur_10 is  -- Castigo Mora
     select t.jaql583usu,
            w.jaql595cas
       from jaql595 w, jaql583 t
       where w.jaql595ase = t.jaql583tusu
       and w.jaql595tiag  = t.jaql583tage
       and w.jaql595cla   = t.jaql583tmet
       and t.jaql583fpro  = P_IN_Fecha
       and t.jaql583pmra >= w.jaql595min
       and t.jaql583pmra <= w.jaql595max
       and t.jaql583mtmr < t.jaql583pmra;

    --actualizacion de bonos metas
  BEGIN
    OPEN cur_02;
    FETCH cur_02
      INTO ln_bonosal, lc_asesor;
    WHILE cur_02%found
    LOOP
      UPDATE JAQL583 b
         SET b.jaql583bsal = ln_bonosal
       WHERE b.jaql583fpro = P_IN_Fecha
         AND b.jaql583usu = lc_asesor
         and b.jaql583crsa >= b.jaql583mtsa;

      FETCH cur_02
        INTO ln_bonosal, lc_asesor;
    END LOOP;
    CLOSE cur_02;
    COMMIT;

    --- actualizacion de bonos clientes

    OPEN cur_03;
    FETCH cur_03
      INTO ln_bonocli, lc_asesor1;
    WHILE cur_03%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583bcli = ln_bonocli
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor1
         and t.jaql583crcl >= t.jaql583mtcl;

      FETCH cur_03
        INTO ln_bonocli, lc_asesor1;
    END LOOP;
    CLOSE cur_03;
    COMMIT;

    -- actualizacion de bonos mora

    OPEN cur_04;
    FETCH cur_04
      INTO ln_bonomra, lc_asesor2;
    WHILE cur_04%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583bmra = ln_bonomra
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor2
         and t.jaql583pmra <= t.jaql583mtmr;

      FETCH cur_04
        INTO ln_bonomra, lc_asesor2;
    END LOOP;
    CLOSE cur_04;
    COMMIT;

    ---pago por plus de saldos

    OPEN cur_05;
    FETCH cur_05
      INTO ln_pagsala, lc_asesor3;
    WHILE cur_05%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583ppla = ln_pagsala
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor3
         and t.jaql583cran >= t.jaql583mtsa;

      FETCH cur_05
        INTO ln_pagsala, lc_asesor3;
    END LOOP;
    CLOSE cur_05;
    COMMIT;

    OPEN cur_06;
    FETCH cur_06
      INTO ln_pagsalm, lc_asesor4;
    WHILE cur_06%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583pplm = ln_pagsalm
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor4
         and t.jaql583crme >= t.jaql583mtsa;

      FETCH cur_06
        INTO ln_pagsalm, lc_asesor4;
    END LOOP;
    CLOSE cur_06;
    COMMIT;

    --pago por plus de clientes anual

    OPEN cur_07;
    FETCH cur_07
      INTO ln_pagclia, lc_asesor5;
    WHILE cur_07%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583ppca = ln_pagclia
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor5
         AND t.jaql583crcm > 0
         AND t.jaql583crca > 0;

      FETCH cur_07
        INTO ln_pagclia, lc_asesor5;
    END LOOP;
    CLOSE cur_07;
    COMMIT;


    --pago por plus cliente mensual

    OPEN cur_08;
    FETCH cur_08
      INTO ln_pagclim, lc_asesor6;
    WHILE cur_08%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583ppcm = ln_pagclim
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor6
         and t.jaql583crcm <= t.jaql583mtcl;

      FETCH cur_08
        INTO ln_pagclim, lc_asesor6;
    END LOOP;
    CLOSE cur_08;
    COMMIT;

    --clientes nuevos

    OPEN cur_09;
    FETCH cur_09
      INTO ln_pagcne, lc_asesor7;
    WHILE cur_09%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583ppcn = ln_pagcne
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu = lc_asesor7;
/*         and t.jaql583bcli > 0
         and t.jaql583crca > 0
         and t.jaql583ncn > 0;*/

      FETCH cur_09
        INTO ln_pagcne, lc_asesor7;
    END LOOP;
    CLOSE cur_09;
    COMMIT;

    OPEN cur_10;
    FETCH cur_10
      INTO lc_asesor8, ln_castmra;
    WHILE cur_10%found
    LOOP
      UPDATE JAQL583 t
         SET t.jaql583cmra = ln_castmra
       WHERE t.jaql583fpro = P_IN_Fecha
         AND t.jaql583usu  = lc_asesor8;

      FETCH cur_10
        INTO lc_asesor8, ln_castmra;
    END LOOP;
    CLOSE cur_10;
    COMMIT;


  End sp_cr_act_bono_metas;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_cr_iniciar_productividad(P_IN_Fecha Date) is
    -- *****************************************************************
    -- Nombre                     : SP_CR_INICIAR_PRODUCTIVIDAD
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/07/2012
    -- Autor de Creación          : Juan Andres Quintanilla Calderon
    -- Uso                        : Inicia la productividad con las funciones mas pesadas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : P_IN_Fecha: fecha de proceso
    -- Parámetros de Salida       :
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************

    ln_tipcam fsh005.COTCBI%type := pq_ah_jaql551.fn_cr_tipocambio(P_IN_Fecha);

  BEGIN

    EXECUTE IMMEDIATE ('TRUNCATE TABLE JAQL584');

    INSERT INTO JAQL584
      (JAQL584ASE,
       JAQL584FPR,
       JAQL584AGE,
       JAQL584SALD,
       JAQL584EASE,
       JAQL584AGET,
       JAQL584MET,
       JAQL584SMRA,
       JAQL584PMRA,
       --JAQL584SDCN,
       JAQL584SDJUD,
       JAQL584SDCAS)
      Select s.sng001ase,
             P_IN_Fecha,
             t.ubsuc,
             sum(decode(f.SCMDA,
                                                            101,
                                                            f.SCSDO *
                                                            ln_tipcam,
                                                            f.SCSDO) * -1),
             --pq_ah_jaql551.fn_cr_asesor_saldo(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_asesor_clasi(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_tipo_agencia_metas(t.ubsuc, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_asesor_tipo(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_saldo_mora(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_porcentaje_mora(sum(decode(f.SCMDA,
                                                            101,
                                                            f.SCSDO *
                                                            ln_tipcam,
                                                            f.SCSDO) * -1),
                                                 s.sng001ase,
                                                 P_IN_fecha),
             pq_ah_jaql551.fn_cr_saldo_judiciales(s.sng001ase, P_IN_Fecha),
             pq_ah_jaql551.fn_cr_saldo_castigo(s.sng001ase, P_IN_Fecha)
        from fsd011 f
       inner join xwf700 x on f.PGCOD = x.xwfempresa
                          and f.SCSUC = x.XWFSUCURSAL
                          and f.SCMDA = x.XWFMONEDA
                          and f.SCPAP = x.XWFPAPEL
                          and f.SCCTA = x.XWFCUENTA
                          and f.SCOPER = x.XWFOPERACION
                          and f.SCSBOP = x.XWFSUBOPE
                          and f.SCTOPE = x.XWFTIPOPE
                          and f.SCMOD = x.XWFMODULO
       inner join sng001 s on x.XWFPRCINS = s.SNG001INST
       inner join fst111 c on f.SCMOD = c.modulo
       inner join fst046 t on f.PGCOD = t.pgcod
                          and t.ubuser = s.SNG001ASE
       inner join fst017 g on f.PGCOD = g.pgcod
       where x.xwfcar3 = '1'
         and f.SCSTAT <> 99
         and c.dscod = 50
         and (x.XWFMODULO not in (108, 33, 200) and (x.XWFMODULO <> 106 Or x.XWFTIPOPE <> 30))
       group by t.ubsuc,
                g.pgfape,
                s.sng001ase;

    commit;

  End sp_cr_iniciar_productividad;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END PQ_AH_JAQL551;
/

