create or replace package pq_producto_caja is

  -- Author  : KVALENCIAC
  -- Created : 23/04/2018 05:49:24 p.m.
  -- Purpose :
  procedure sp_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in number,
                             v_pepais  in number,
                             v_petdoc  in number,
                             v_pendoc  in char,
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number,  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             lc_producto out varchar2
                             ) ;
function fn_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type,
                             v_pepais  in fsd001.pepais%type,
                             v_petdoc  in fsd001.petdoc%type,
                             v_pendoc  in fsd001.pendoc%type,
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             ) return varchar2;
function fn_subproducto_regcaja(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type
                             ) return varchar2;
function fn_productoxsub_regcaja(
                                 lv_subproducto  in varchar2
                                 ) return varchar2;

end pq_producto_caja;
/

create or replace package body pq_producto_caja is
--modificaciones rmontes: se agrego rubro 0303 en linea 206

procedure sp_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in number,
                             v_pepais  in number,
                             v_petdoc  in number,
                             v_pendoc  in char,
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number,  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             lc_producto out varchar2
                             ) is
    begin

    begin

      lc_producto:= fn_producto_regcaja(d_fecpro,
                                                           v_pgcod ,
                                                           v_Scmod ,
                                                           v_Scsuc ,
                                                           v_Scmda ,
                                                           v_Scpap ,
                                                           v_Sccta ,
                                                           v_Scoper,
                                                           v_Scsbop,
                                                           v_Sctope,
                                                           v_Rubro,
                                                           v_pepais,
                                                           v_petdoc,
                                                           v_pendoc,
                                                           v_anioseg,
                                                           v_messeg
                                                           );


    exception
      when others then
          lc_producto := null;
    end;
end sp_producto_regcaja;
function fn_producto_regcaja(
                             d_fecpro  in date,
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type,
                             v_pepais  in fsd001.pepais%type,
                             v_petdoc  in fsd001.petdoc%type,
                             v_pendoc  in fsd001.pendoc%type,
                             v_anioseg in number, --año de ultima segmentacion de cliente menor a fecha de proceso
                             v_messeg  in number  --mes de ultima segmentacion de cliente menor a fecha de proceso
                             ) return varchar2 is

    lc_mdnom  fst003.mdnom%type;
    lc_tonom  fst004.tonom%type;

    lv_bcemp  fsh012.bcemp%type;
    lv_bcmod  fsh012.bcmod%type;
    lv_bcsuc  fsh012.bcsuc%type;
    lv_bcmda  fsh012.bcmda%type;
    lv_bcpap  fsh012.bcpap%type;
    lv_bccta  fsh012.bccta%type;
    lv_bcoper fsh012.bcoper%type;
    lv_bcsbop fsh012.bcsbop%type;
    lv_bctop  fsh012.bctop%type;

    lc_inconv  varchar2(1); --indicador de convenio

    lc_segcli jaqy067.jaqy067ncal%type;
    lc_indtra fsd002.pfebco%type;

    lc_producto varchar2(500);

    ln_instconv number;

    ln_aopzo fsd010.aopzo%type;

  begin

    begin

      lc_producto:=fn_subproducto_regcaja(
                                                           v_pgcod ,
                                                           v_Scmod ,
                                                           v_Scsuc ,
                                                           v_Scmda ,
                                                           v_Scpap ,
                                                           v_Sccta ,
                                                           v_Scoper,
                                                           v_Scsbop,
                                                           v_Sctope,
                                                           v_Rubro
                                                           );
      lc_producto:= fn_productoxsub_regcaja(lc_producto);

    exception
      when others then
          lc_producto := null;
    end;
  return lc_producto;
end fn_producto_regcaja;
function fn_subproducto_regcaja(
                             v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             v_Rubro   in fsh012.bcrubr%type
                             ) return varchar2 is

    lc_mdnom  fst003.mdnom%type;
    lc_tonom  fst004.tonom%type;

    lv_bcemp  fsh012.bcemp%type;
    lv_bcmod  fsh012.bcmod%type;
    lv_bcsuc  fsh012.bcsuc%type;
    lv_bcmda  fsh012.bcmda%type;
    lv_bcpap  fsh012.bcpap%type;
    lv_bccta  fsh012.bccta%type;
    lv_bcoper fsh012.bcoper%type;
    lv_bcsbop fsh012.bcsbop%type;
    lv_bctop  fsh012.bctop%type;

    lc_inconv  varchar2(1); --indicador de convenio

    lc_segcli jaqy067.jaqy067ncal%type;
    lc_indtra fsd002.pfebco%type;

    lc_producto varchar2(500);

    ln_instconv number;

    ln_aopzo fsd010.aopzo%type;
    ld_prides fsd010.aofval%type;

  begin

    if v_Scmod in (200,33,65) or v_Sctope=550 then
      --obtener la clave de credito original
      begin
            PQ_DATOS_CREDITO.sp_credito_original(
                                                    v_pgcod,v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,v_Scsbop,v_Sctope,
                                                    lv_bcemp, lv_bcmod, lv_bcsuc, lv_bcmda,lv_bcpap, lv_bccta,  lv_bcoper,  lv_bcsbop,  lv_bctop
                                                  );
      exception
        when others then
            null;
      end;
    end if;


    if lv_bcmod is null then
      lv_bcemp  := v_pgcod ;
      lv_bcmod  := v_Scmod ;
      lv_bcsuc  := v_Scsuc ;
      lv_bcmda  := v_Scmda ;
      lv_bcpap  := v_Scpap ;
      lv_bccta  := v_Sccta ;
      lv_bcoper := v_Scoper;
      lv_bcsbop := v_Scsbop;
      lv_bctop  := v_Sctope;
    end if;

  --verificar si es convenio
  --1. Buscar si esta asociado a un convenio
    begin
      select count(*)
             into ln_instconv
        from fpp102 det
       where
         det.pp102cod = v_pgcod
         and det.pp102hab = 'S'
         and det.pp102cta = v_Sccta
         and det.pp102ope = v_Scoper;
    exception
      when others then
          ln_instconv:=null;
    end;

    lc_inconv:= (case when nvl(ln_instconv,0)>0 then 'S' else 'N' end);
   --2. Buscar por cuenta contable
    if lc_inconv = 'N' then
       lc_inconv:=
                  (case
                       when substr(v_Rubro,7,4) in ('0602','0605','1906') and  substr(v_Rubro,12,2) in ('11','14') then 'S'
                       when substr(v_Rubro,5,9)='030605017' or substr(v_Rubro,5,9)='030305017' then 'S'  --se agrego rubro 0303
                       else 'N'
                  end);
    end if;

  --obtener descripcion de modulo
  begin
    select upper(mdnom)
      into lc_mdnom
      from fst003
      where modulo = lv_bcmod;
  exception
    when others then
        lc_mdnom := null;
  end;

  --obtener descripcion de operacion
  begin
    select upper(tonom)
      into lc_tonom
      from fst004
      where modulo = lv_bcmod
        and totope = lv_bctop;
  exception
    when others then
        lc_tonom := null;
  end;

  --obtener plazo
  begin
    select aopzo
      into ln_aopzo
      from fsd010 d10
      where
          d10.pgcod = lv_bcemp
      and d10.aomod = lv_bcmod
      --and d10.aosuc = lv_bcsuc
      and d10.aomda = lv_bcmda
      and d10.aopap = lv_bcpap
      and d10.aocta = lv_bccta
      and d10.aooper= lv_bcoper
      and d10.aosbop= lv_bcsbop
      and d10.aotope= lv_bctop;
  exception
    when others then
        ln_aopzo := null;
  end;

  --obtener primera fecha de desembolso para crediluz y ecomicro
  begin
    select min(aofval)
      into ld_prides
      from fsd010 d10
      where
          d10.pgcod = lv_bcemp
      and d10.aomod = lv_bcmod
      --and d10.aosuc = lv_bcsuc
      --and d10.aomda = lv_bcmda
      --and d10.aopap = lv_bcpap
      and d10.aocta = lv_bccta
      and d10.aooper= lv_bcoper
      --and d10.aosbop= lv_bcsbop
      and d10.aotope= lv_bctop;
  exception
    when others then
        ld_prides := null;
  end;


  --obtener subproducto
    lc_producto:=
       CASE
         WHEN lv_bcmod = 141 then 'Carta Fianza'
         WHEN lv_bcmod = 142 then 'Honramiento de Carta Fianza'
         WHEN lv_bcmod in (116,117) and lc_tonom like '%SEMILLA%' then 'Línea de Crédito Semilla'
         WHEN lv_bcmod in (116,117) and (lc_tonom like '%TRAB%' and lc_tonom like '%CTS%') then 'Línea de Crédito para Trabajadores'
         WHEN lv_bcmod in (116,117) and (lc_tonom like '%DPF%' or lc_tonom like '%CTS%') then 'Línea de Crédito con DPF/CTS'
         WHEN lv_bcmod in (116,117)
          and (case
                when lc_tonom like '%PRFRNL%' then 1
                when lc_tonom like '%PREFERENCIAL%' then 1
                when lc_tonom like '%PREMIUM PR%' then 1
                when lc_tonom like '%PRFNCIAL%' then 1
                when lc_tonom like '%PRFRENCIAL%' then 1
                when lc_tonom like '%PRFRNCIAL%' then 1
                when lc_tonom like '%PFRCIAL%' then 1
                when lc_tonom like '%PREMIUM%' then 1
                when lc_tonom like '%PRM%' then 1
              end)=1
           then 'Línea de Crédito para Cliente Preferencial'
         WHEN lv_bcmod in (116,117) and lc_tonom like '%SEGURO%' then 'Línea de Crédito para Seguro'
         WHEN lv_bcmod in (116,117) then 'Línea de Crédito'
         WHEN lc_tonom like '%CREDIPUNTUALITO%'  then 'CrediPuntualito'
         WHEN lc_tonom like '%MICROPYMEA%' and lc_tonom not like '%MICR%PUNT%' then 'Micropymes A'
         WHEN lc_tonom like '%MICROPYMEB%' and lc_tonom not like '%MICR%PUNT%' then 'Micropymes B'
         WHEN lc_tonom like '%MICROPYMEC%' and lc_tonom not like '%MICR%PUNT%' then 'Micropymes C'
         WHEN lc_tonom like '%MICROPYME%' and lc_tonom not like '%MICR%PUNT%' then 'Micropymes'
         WHEN lc_tonom like '%MICR%PUNT%' then 'Micropymes Puntualito'
         WHEN lc_tonom like '%MUJER%' then 'Zonas Rurales: Supérate Mujer'
         WHEN lc_tonom like '%PECUARIO%' and lc_tonom not like '%AGRO%' then 'Zonas Rurales: Pecuario'
         WHEN lc_tonom like '%ARR%' then 'Arroz'
         WHEN lc_tonom like '%PAPA%' then 'Papa'
         WHEN lc_tonom like '%MAIZ%' then 'Maiz Cusqueño'
         WHEN lv_bcmod = 104 and lv_bctop in (160,161,162,165,166,167) then 'Monocultivos'
         WHEN lc_tonom like '%AGRI%' or lc_tonom like '%AGRÍ%' or lc_tonom like '%ARR%' or lc_tonom like '%PAPA%'
              or (lv_bcmod = 104 and lv_bctop in (160,161,162,165,166,167))
              or lc_tonom like '%AGRC%'
           then 'Zonas Rurales: Agrícola'
         WHEN lc_tonom like '%GANADERO%' then 'Ganadero'
         WHEN lc_tonom like '%COSECHANDO%' then 'Cosechando'
         WHEN lc_tonom like '%AGROPECUARIO%' or lc_mdnom like '%AGROPECUARIO%' then 'Agropecuario'
         WHEN lc_tonom like '%MICROCONSUMO%' then 'Microconsumo'
         WHEN lc_tonom like '%CAJA%CONSTRU%' then 'Caja Construye'
         WHEN lv_bcmod = 112 and lv_bctop =40 then 'Movitaxi'
         WHEN ((lv_bcmod = 112 ) or lc_tonom like '%VEHICULAR%') and lc_tonom like '%TRABAJADOR%' then 'Vehicular para Trabajadores'
         WHEN ((lv_bcmod = 112 ) or lc_tonom like '%VEHICULAR%') then 'Vehicular'
         WHEN lc_tonom like '%CREDIOFICIOA%' then 'Credi Oficios A'
         WHEN lc_tonom like '%CREDIOFICIOB%' then 'Credi Oficios B'
         WHEN lc_tonom like '%CREDIOFICIOC%' then 'Credi Oficios C'
         WHEN lc_tonom like '%CRE%OF%' then 'Credi Oficios'
         WHEN lv_bcmod = 113 and lc_tonom like '%CONVERSION%' then 'Movigas Conversión'
         WHEN lv_bcmod = 113 and lc_tonom like '%COMPRA%' then 'Movigas Compra'
         WHEN lv_bcmod = 113 then 'MOVIGAS'
         WHEN lv_bcmod = 103 and lv_bctop =40 then 'Mi Baño'
         WHEN (lv_bcmod = 105 or lc_tonom like '%PARALELO%') then 'Paralelo'
         WHEN lv_bcmod = 108 then 'Prendario'
         WHEN lc_tonom like '%ADMINISTRATIVO%' then 'Administrativo'
         WHEN lc_tonom like '%ECOMICRO%' and ld_prides>to_date('20170420','rrrrmmdd')  then 'Ecomicro'
         WHEN lc_tonom like 'CRE%LUZ%' or lc_tonom like '%ECOMICRO%' then 'Crediluz'
         WHEN lv_bcmod = 107 or (lc_inconv='S' and substr(v_Rubro,5,2)='03') then 'Convenio con Descuento por Planilla'
         WHEN lc_tonom like '%QUINTUPLICA%'and ld_prides>=to_date('20170301','rrrrmmdd') then 'Quintuplica tu Sueldo'
         WHEN (substr(v_Rubro,5,2)='03' or lv_bcmod = 106) and lc_tonom like '%TRABAJAD%' then 'Personal Directo para Trabajadores'
         WHEN substr(v_Rubro,5,2)='03' or lv_bcmod = 106 or (lv_bcmod = 115 and lc_tonom like '%CONSU%') then 'Personal Directo'
         WHEN (lv_bcmod = 111 AND lc_tonom not like '%TECHO%PROPIO%') OR lc_tonom like '%MI%VIVIENDA%' then 'Mi Vivienda'
         WHEN lc_tonom like '%TECHO%PROPIO%' then 'Techo Propio'
         --2018.04.19 nuevo producto semento mype. Módulo: 110 de préstamos para vivienda, Tipo de Operación: 138 a 151
         WHEN lv_bcmod = 110 and lc_tonom like '%AGUA%' then 'Agua Mas'
         WHEN (substr(v_Rubro,5,2)='04' or lv_bcmod = 110 or lc_tonom like '%HIPOTECARIO%')and lc_tonom like '%TRAB%' then 'Hipotecario Caja para Trabajadores'
         WHEN substr(v_Rubro,5,2)='04' or lv_bcmod = 110 or lc_tonom like '%HIPOTECARIO%' then 'Hipotecario Caja para Clientes'
         WHEN lv_bcmod = 109 and lc_tonom like '%CONVENIO A%' then 'Convenio Pymes A'
         WHEN lv_bcmod = 109 and lc_tonom like '%CONVENIO B%' then 'Convenio Pymes B'
         WHEN lv_bcmod = 109 and lc_tonom like '%CONVENIO C%' then 'Convenio Pymes C'
         WHEN lv_bcmod = 109 or ( substr(v_Rubro,5,2) in ('12','02','13') and lc_inconv='S') then 'Convenio Pymes'
         WHEN lv_bcmod = 101 and lv_bctop =300 then 'Instituciones Financieras'
         WHEN lc_tonom like '%PAGA%DIARIO%' then 'Paga Diario'
         WHEN (lc_mdnom like '%CAPITAL%TRABAJO%') OR (lc_tonom like '%CAPTRA%') OR
                 (lc_tonom like '%-CT-%' and lc_tonom not like '%ACT%F%') OR (lc_tonom like '%CAPITAL%TRABAJO%') OR
                 (lc_tonom LIKE '%CAP%TRA%') OR (lc_tonom LIKE '%CAPTRA%')  OR
                 (lc_tonom like '% CT %' and (lc_tonom not like '%CTS%' or lc_mdnom not like '%CTS%')) OR
                 (lc_tonom like '% CT' and (lc_tonom not like '%CTS%' or lc_mdnom not like '%CTS%')) OR
                 (lc_tonom like '% CT_%' and (lc_tonom not like '%CTS%' or lc_mdnom not like '%CTS%')) OR
                 (upper(replace(lc_tonom,'_','-')) like '%-CT-%') OR
                 (lv_bcmod in (116,117)And lc_tonom not like '%SEGURO%' And
                 (lv_bcmod in (116,117) And lc_tonom not like '%CONSUMO%') And
                 (lv_bcmod in (116,117) And lc_tonom not like '%DPF%') And
                 (lv_bcmod in (116,117) And lc_tonom not like '%CTS%'))
             THEN 'Capital de Trabajo'
         WHEN (lc_mdnom like '%ACT%FIJO%' And lc_tonom not like '%LOC%COM%') OR
              (lc_tonom  like '%ACT%F%' And lc_tonom not like '%LOC%COM%' And (lc_tonom not like '%CAPTRAB%')) OR
              (lc_mdnom like '%ACTIVO%FIJO%' And lc_tonom not like '%LOC%COM%') OR
              (lc_tonom  like '% AF %') OR (lc_tonom like '% AF%') OR
              (lc_tonom like '%-AF-%') OR
              (upper(replace(lc_tonom,'_','-'))  like '%-AF-%')
             THEN 'Activo Fijo Maquinaria y Equipo'
         WHEN (lc_mdnom like 'LOC%COM%') OR (lc_tonom  like '% LC %') OR
              (lc_tonom  like '%LOC%C%') OR (lc_tonom  like '%-LC-%') OR
              (upper(replace(lc_tonom,'_','-')) like '%-LC-%')
              OR (lc_tonom  like '%L COMER%')
              OR (lc_tonom  like '% LC')
             THEN 'Local Comercial-Vivienda Productiva'
         WHEN substr(v_Rubro,5,2) not in ('03','04') and v_Rubro is not null
              and ln_aopzo>0 and ln_aopzo/30<=18
             THEN 'Capital de Trabajo'
         WHEN substr(v_Rubro,5,2) not in ('03','04') and v_Rubro is not null
              and  ln_aopzo/30>18
              THEN 'Activo Fijo Maquinaria y Equipo'
         WHEN lv_bcmod = 115 THEN 'Campaña'
         ELSE 'Otros'
       END;

  return lc_producto;

end fn_subproducto_regcaja;
function fn_productoxsub_regcaja(
                                 lv_subproducto  in varchar2
                                 ) return varchar2 is

  lc_producto varchar2(500);
  begin

    lc_producto:=
       CASE
         WHEN lv_subproducto in ('Carta Fianza','Honramiento de Carta Fianza') then 'Carta Fianza'
         WHEN lv_subproducto in ('Línea de Crédito para Seguro') then 'Línea de Crédito'
         WHEN lv_subproducto in ('Línea de Crédito para Trabajadores') then 'Personal Directo para Trabajadores'
         WHEN lv_subproducto in ('Micropymes A','Micropymes B','Micropymes C') then 'Micropymes'
         WHEN lv_subproducto in ('Monocultivos') then 'Zonas Rurales: Agrícola'
         WHEN lv_subproducto in ('Arroz','Papa','Maiz Cusqueño') then 'Agropecuario'
         WHEN lv_subproducto in ('Credi Oficios A','Credi Oficios B','Credi Oficios C') then 'Credi Oficios'
         WHEN lv_subproducto in ('Movigas Conversión','Movigas Compra') then 'Movigas'
         WHEN lv_subproducto in ('Convenio Pymes A','Convenio Pymes B','Convenio Pymes C') then 'Convenio Pymes'
         WHEN lv_subproducto in ('Mi Vivienda', 'Techo Propio') then 'Hipotecario Caja para Clientes'
         WHEN lv_subproducto in ('Campaña') then 'Otros'
         ELSE lv_subproducto
       END;

  return lc_producto;

end fn_productoxsub_regcaja;
end pq_producto_caja;
/

