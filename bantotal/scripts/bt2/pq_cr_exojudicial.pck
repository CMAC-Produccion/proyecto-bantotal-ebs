create or replace package pq_cr_exojudicial is


  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para el Módulo de Autonomías de los créditos Judiciales
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 26/12/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- ***************************************************************************************************************************
procedure sp_extornatransac ( vn_Pgcod in number,
                              vn_ppmod in number,
                              vn_ppsuc in number,
                              vn_ppmda in number,
                              vn_pppap in number,
                              vn_ppcta in number,
                              vn_ppoper in number,
                              vn_ppsbop in number,
                              vn_pptope in number);

procedure sp_es_exonerado (vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   ln_Indicador out number,
                                   ln_monto out number);

procedure sp_actualizac     ( vn_Pgcod in number,
                              vn_ppmod in number,
                              vn_ppsuc in number,
                              vn_ppmda in number,
                              vn_pppap in number,
                              vn_ppcta in number,
                              vn_ppoper in number,
                              vn_ppsbop in number,
                              vn_pptope in number,
                              vn_pgfape in date);

procedure sp_tieneajustetasa (vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   ln_Indicador out number);
procedure sp_ultimacuota ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_monto out number);
procedure sp_Esexcepcionado       (vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vn_ppfpag in date,
                                   vn_tipo in number,
                                   ln_Indicador out number);
procedure sp_tipoarmada (vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   ln_existe out number,
                                   ln_tipo out number);

procedure sp_ajustetasa (  vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           ln_tasa out number,
                           ln_Indicador out number);
procedure sp_validahora       (
                                   vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vd_pgfape in date,
                                   vn_Itcod  in number,
                                   vn_Itsuc  in number,
                                   vn_Itmod  in number,
                                   vn_Ittran in number,
                                   vn_Itnrel in number,
                                   vn_Itfcon in date,
                                   lc_mensaje out varchar);
procedure sp_es_exoneradoAQPB408 ( vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vn_ppfpag in date,
                                   ln_Indicador out number);
procedure sp_valida       (        vn_codigo in number,
                                   vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   lc_mensaje out varchar);
procedure sp_inserta      (       vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vd_pgfape  in date,
                                   vc_usuario in  varchar,
                                   lc_mensaje out varchar);
procedure sp_validamonto ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_Indicador out number,
                                vn_montoexo out number,
                                vn_montoutlcuo out number);
procedure sp_plazo ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                 vn_tipo out number,
                                vn_plazo out number);
procedure sp_extorna      (
                                   vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vc_usuario in varchar,
                                   vd_pgfape  in date);
procedure sp_extorna2      (
                                   vn_Pgcod in number,
                                   vn_ppmod in number,
                                   vn_ppsuc in number,
                                   vn_ppmda in number,
                                   vn_pppap in number,
                                   vn_ppcta in number,
                                   vn_ppoper in number,
                                   vn_ppsbop in number,
                                   vn_pptope in number,
                                   vc_usuario in varchar,
                                   vd_pgfape  in date);
procedure sp_conteoref ( vn_Pgcod in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_contador out number) ;

end pq_cr_exojudicial;
/

create or replace package body pq_cr_exojudicial is

procedure sp_extornatransac( vn_Pgcod in number,
                             vn_ppmod in number,
                             vn_ppsuc in number,
                             vn_ppmda in number,
                             vn_pppap in number,
                             vn_ppcta in number,
                             vn_ppoper in number,
                             vn_ppsbop in number,
                             vn_pptope in number) is
begin


     update JAQN8J set  JAQN8JEST ='A'
      where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST ='C';--C solo se coloca al regsitro que está contabilizado

      update JAQN8I set  JAQN8IEST ='A'
      where JAQN8IEMP = vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST ='C';--C solo se coloca al regsitro que está contabilizado

end  sp_extornatransac;
--valida si es exonerado de última cuota
procedure sp_es_exonerado (vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           ln_Indicador out number,
                           ln_monto out number)

is
begin
  ln_Indicador:=0;
  begin
      select 1,JAQN8JTEX into ln_Indicador,ln_monto
      from JAQN8J
      where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST ='G';--G esta en estado de exoneración
   exception
      when others then
        ln_Indicador :=0;
   end;
end  sp_es_exonerado;

procedure sp_actualizac( vn_Pgcod in number,
                             vn_ppmod in number,
                             vn_ppsuc in number,
                             vn_ppmda in number,
                             vn_pppap in number,
                             vn_ppcta in number,
                             vn_ppoper in number,
                             vn_ppsbop in number,
                             vn_pptope in number,
                             vn_pgfape in date) is
begin

     update JAQN8J set JAQN8JEST ='C',JAQN8JAF2 =vn_pgfape
      where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST ='G';--C solo se coloca al regsitro que está contabilizado

      update JAQN8I set JAQN8IEST ='C',JAQN8IAF2 =vn_pgfape
      where JAQN8IEMP = vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST ='G';--C solo se coloca al regsitro que está contabilizado

end  sp_actualizac;

procedure sp_tieneajustetasa (vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           ln_Indicador out number)

is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from JAQN8I
      where JAQN8IEMP = vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST ='G';--G esta en estado de exoneración
   exception
      when others then
        ln_Indicador :=0;
   end;
end  sp_tieneajustetasa;

procedure sp_ultimacuota ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_monto out number)
is
ln_Pp1nump number;
ln_Ppcap number;
ln_Ppint number;
ln_IntMor number;
ln_Icv number;
ln_Seguro1 number;
ln_Seguro2 number;
ln_Seguro3 number;
ln_Seguro4 number;
ln_Seguro5 number;
ln_penalidad number;
ln_modulo number;
ln_ittope number;
ln_itsucd number;
ln_moneda number;
ln_papel number;
ln_ctnro number;
ln_itoper number;
ln_itsubope number;
ln_total number;
ld_Ppfpag date;
begin
  --obtengo la máxima cuota o última cuota
  begin
        select max(ppfpag)
        into ld_ppfpag
        from FSD601 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción
        Where PgCod  = vn_Pgcod
          and Ppmod  = vn_ppmod
          and Ppsuc  = vn_ppsuc
          and Ppmda  = vn_ppmda
          and Pppap  = vn_pppap
          and Ppcta  = vn_ppcta
          and Ppoper = vn_ppoper
          and Ppsbop = vn_ppsbop
          and Pptope = vn_pptope;
   EXCEPTION
       when others then
          ld_ppfpag:= null ;
   end;
   Begin
       select
           Ppcap,  --capital
           Ppint   --interes compensatorio
           into
           ln_Ppcap,
           ln_Ppint
        from FSD601 -- --> FSD601: cronograma de pago se debe sacar de aca porque cuando se apga adelantado los montos en le fSD602 del interes se vuelve cero
        where PgCod  = vn_Pgcod
          and Ppmod  = vn_ppmod
          and Ppsuc  = vn_ppsuc
          and Ppmda  = vn_ppmda
          and Pppap  = vn_pppap
          and Ppcta  = vn_ppcta
          and Ppoper = vn_ppoper
          and Ppsbop = vn_ppsbop
          and Pptope = vn_pptope
          and ppfpag = ld_ppfpag;
        EXCEPTION
        when others then
           ln_Ppcap:= 0;
           ln_Ppint:=0;
        end;
        --obtengo seguros
      ln_Seguro1 :=0;
      ln_Seguro2 :=0;
      ln_Seguro3 :=0;
      ln_Seguro4 :=0;
      ln_Seguro5 :=0;
       begin
      select  --Pp1imp2,  -- Interes Moratorio
              --Pp1imp3, --obtengo ICV
              Ppimp11, --seguro
              Ppimp12, --seguro
              Ppimp13, --seguro
              Ppimp14, --seguro
              Ppimp15 --seguro
       into
              --ln_IntMor,
              --ln_Icv,
              ln_Seguro1,
              ln_Seguro2,
              ln_Seguro3,
              ln_Seguro4,
              ln_Seguro5
      from FSD611
      where PgCod = vn_Pgcod
      and Ppmod   = vn_ppmod
      and Ppsuc   = vn_ppsuc
      and Ppmda   = vn_ppmda
      and Pppap   = vn_pppap
      and Ppcta   = vn_ppcta
      and Ppoper  = vn_ppoper
      and Ppsbop  = vn_ppsbop
      and Pptope  = vn_pptope
      and ppfpag  = ld_ppfpag;
      EXCEPTION
      when others then
       -- ln_IntMor :=0;
       -- ln_Icv :=0;
        ln_Seguro1:=0;
        ln_Seguro2 :=0;
        ln_Seguro3:=0;
        ln_Seguro4:=0;
        ln_Seguro5:=0;
      end;
      ln_total:=  ln_Ppcap + ln_Ppint + ln_Seguro1 + ln_Seguro2 + ln_Seguro3 + ln_Seguro4 + ln_Seguro5;
      vn_monto := ln_total;
end sp_ultimacuota;

procedure sp_Esexcepcionado (vn_Pgcod in number,
                         vn_ppmod in number,
                         vn_ppsuc in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_ppsbop in number,
                         vn_pptope in number,
                         vn_ppfpag in date,
                         vn_tipo in number,
                         ln_Indicador out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPD224
      where AQPD224COD = vn_Pgcod
       and AQPD224MOD = vn_ppmod
       and AQPD224SUC = vn_ppsuc
       and AQPD224MDA = vn_ppmda
       and AQPD224PAP = vn_pppap
       and AQPD224CTA = vn_ppcta
       and AQPD224OPE = vn_ppoper
       and AQPD224SBO = vn_ppsbop
       and AQPD224TPO = vn_pptope
       and AQPD224EST = 'A'
       and AQPD224TIPE = vn_tipo;
   exception
      when others then
        ln_Indicador :=0;
   end;
end  sp_Esexcepcionado;

procedure sp_tipoarmada (  vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           ln_existe out number,
                           ln_tipo out number)

is
begin
  ln_tipo:=0;
  ln_existe:=0;
  begin
      select count(*) into ln_existe
      from JAQN8J
     where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST = 'G';--G esta en estado de exoneración
   exception
      when others then
        ln_existe :=0;
   end;
   if (ln_existe>0) then
      begin
          select JAQN8JTIP into ln_tipo
          from JAQN8J
         where JAQN8JEMP = vn_Pgcod
           and JAQN8JMOD = vn_ppmod
           and JAQN8JSUC = vn_ppsuc
           and JAQN8JMDA = vn_ppmda
           and JAQN8JPAP = vn_pppap
           and JAQN8JCTA = vn_ppcta
           and JAQN8JOPE = vn_ppoper
           and JAQN8JSBO = vn_ppsbop
           and JAQN8JTOP = vn_pptope
           and JAQN8JEST = 'G';--G esta en estado de exoneración
       exception
          when others then
            ln_tipo :=0;
       end;
    End if;
end  sp_tipoarmada;

procedure sp_ajustetasa (  vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           ln_tasa out number,
                           ln_Indicador out number)

is
begin
  ln_Indicador:=0;
  begin
      select 1,jaqn8itaa into ln_Indicador,ln_tasa
      from JAQN8I
      where JAQN8IEMP = vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST ='G';--G esta en estado de exoneración
   exception
      when others then
        ln_Indicador :=0;
        ln_tasa:=0;
   end;
end  sp_ajustetasa;


procedure sp_validahora ( vn_Pgcod in number,
                      vn_ppmod in number,
                      vn_ppsuc in number,
                      vn_ppmda in number,
                      vn_pppap in number,
                      vn_ppcta in number,
                      vn_ppoper in number,
                      vn_ppsbop in number,
                      vn_pptope in number,
                      vd_pgfape in date,
                      vn_Itcod  in number,
                      vn_Itsuc  in number,
                      vn_Itmod  in number,
                      vn_Ittran in number,
                      vn_Itnrel in number,
                      vn_Itfcon in date,
                      lc_mensaje out varchar)
is

ln_Indicador number(1);
lc_horaa varchar(10);
ld_fechaj date;
lc_horaj varchar(10);
ld_fechainia date;
ln_horaa number(2);
ln_horaj number(2);
ln_mina number(2);
ln_minj number(2);
ln_sega number(2);
ln_segj number(2);
ln_existe number(1);
ln_existej number(1);
ld_fechajj date;
lc_horajj varchar(10);
ln_horajj number(2);
ln_minjj number(2);
ln_segjj number(2);
ln_jaqn8jcor number(3);
ln_jaqn8icor number(3);
lc_estadoi char (1);
lc_estadoj char (1);
begin
  lc_mensaje:='';
  --busco hora y fecha de la transacción
   begin
     select hfcon,hhing into  ld_fechainia, lc_horaa
     from fsh115
     where pgcod  = vn_Itcod
       and hsucor = vn_Itsuc
       and hcmod  = vn_Itmod
       and htran  = vn_Ittran
       and hnrel  = vn_Itnrel
       and hfcon  = vn_Itfcon;
     exception
        when others then
          lc_horaa:=null;
          ld_fechainia:=null;
     end;
  --tabla de las tasas
  begin
   select max(jaqn8icor) into ln_jaqn8icor
      from jaqn8i
      where jaqn8iEMP = vn_Pgcod
       and jaqn8iMOD = vn_ppmod
       and jaqn8iSUC = vn_ppsuc
       and jaqn8iMDA = vn_ppmda
       and jaqn8iPAP = vn_pppap
       and jaqn8iCTA = vn_ppcta
       and jaqn8iOPE = vn_ppoper
       and jaqn8iSBO = vn_ppsbop
       and jaqn8iTOP = vn_pptope
       and jaqn8ifec=vd_pgfape;
   exception
      when others then
        ln_jaqn8icor :=0;
   end;
   if ( ln_jaqn8icor > 0 ) then
     begin
      select 1,jaqn8ifec,jaqn8ihum,jaqn8iEST into ln_existe,ld_fechaj,lc_horaj,lc_estadoi
      from jaqn8i
      where jaqn8iEMP = vn_Pgcod
       and jaqn8iMOD = vn_ppmod
       and jaqn8iSUC = vn_ppsuc
       and jaqn8iMDA = vn_ppmda
       and jaqn8iPAP = vn_pppap
       and jaqn8iCTA = vn_ppcta
       and jaqn8iOPE = vn_ppoper
       and jaqn8iSBO = vn_ppsbop
       and jaqn8iTOP = vn_pptope
       and jaqn8icor = ln_jaqn8icor
       and jaqn8ifec=vd_pgfape;
      exception
      when others then
        ln_existe :=0;
        lc_horaj:='';
      end;
   end if;
   if ( ln_existe = 1 ) then
        ln_horaa := to_number(substr(lc_horaa,1,2));
        ln_horaj := to_number(substr(lc_horaj,1,2));
        ln_mina := to_number(substr(lc_horaa,4,2));
        ln_minj := to_number(substr(lc_horaj,4,2));
        ln_sega := to_number(substr(lc_horaa,7,2));
        ln_segj := to_number(substr(lc_horaj,7,2));
        if (lc_estadoi='G' or lc_estadoi='R') then
           if ( ld_fechaj >ld_fechainia) then
              ln_Indicador:=2;
           else
              if ( ld_fechaj = ld_fechainia ) then
                if ( ln_horaj > ln_horaa ) then
                  ln_Indicador:=2;
                else
                  if ( ln_horaj = ln_horaa and ln_minj > ln_mina ) then
                     ln_Indicador:=2;
                  end if;
                  if ( ln_horaj = ln_horaa and ln_minj = ln_mina and ln_segj > ln_sega ) then
                     ln_Indicador:=2;
                  end if;
                end if;
              end if;
            end if;
          end if;
     end if;
   --tabla de las exoneraciones saldos
   begin
   select max(jaqn8jcor) into ln_jaqn8jcor
      from jaqn8j
      where jaqn8jEMP = vn_Pgcod
       and jaqn8jMOD = vn_ppmod
       and jaqn8jSUC = vn_ppsuc
       and jaqn8jMDA = vn_ppmda
       and jaqn8jPAP = vn_pppap
       and jaqn8jCTA = vn_ppcta
       and jaqn8jOPE = vn_ppoper
       and jaqn8jSBO = vn_ppsbop
       and jaqn8jTOP = vn_pptope
       and jaqn8jfec=vd_pgfape;
   exception
      when others then
        ln_jaqn8jcor :=0;
   end;
   if ( ln_jaqn8jcor > 0) then
       begin
       select 1,jaqn8jfec,jaqn8jhum,jaqn8jEST into ln_existej,ld_fechajj,lc_horajj,lc_estadoj
          from jaqn8j
          where jaqn8jEMP = vn_Pgcod
           and jaqn8jMOD = vn_ppmod
           and jaqn8jSUC = vn_ppsuc
           and jaqn8jMDA = vn_ppmda
           and jaqn8jPAP = vn_pppap
           and jaqn8jCTA = vn_ppcta
           and jaqn8jOPE = vn_ppoper
           and jaqn8jSBO = vn_ppsbop
           and jaqn8jTOP = vn_pptope
           and jaqn8jcor = ln_jaqn8jcor
           and jaqn8jfec=vd_pgfape;
       exception
          when others then
            ln_existej :=0;
            lc_horajj:='';
       end;
    end if;
    if ( ln_existej = 1 ) then
       ln_horaa := to_number(substr(lc_horaa,1,2));
       ln_horajj := to_number(substr(lc_horajj,1,2));
       ln_mina := to_number(substr(lc_horaa,4,2));
       ln_minjj := to_number(substr(lc_horajj,4,2));
       ln_sega := to_number(substr(lc_horaa,7,2));
       ln_segjj := to_number(substr(lc_horajj,7,2));
       if (lc_estadoj='G' or lc_estadoj='R') then
         if ( ld_fechajj >ld_fechainia) then
            ln_Indicador:=5;
         else

            if ( ld_fechajj = ld_fechainia ) then
              if ( ln_horaj > ln_horaa ) then
                ln_Indicador:=5;
              else
                if ( ln_horajj = ln_horaa and ln_minjj > ln_mina ) then
                   ln_Indicador:=5;
                end if;
                if ( ln_horajj = ln_horaa and ln_minjj = ln_mina and ln_segjj > ln_sega ) then
                   ln_Indicador:=5;
                end if;
               end if;
             end if;
           end if;
         end if;
      end if;
   lc_mensaje:='';
   if (lc_estadoi='R' or lc_estadoj='R') then
     ln_Indicador:=1;
   end if;
   case ln_Indicador
     when 1 then lc_mensaje:='La exoneración ha sido rechazada no puede Confirmar.';
     when 2 then lc_mensaje:='Debe volver a iniciar el proceso de la transacción ya que ha generado un rechazo o tiene una exoneración posterior a la ejecución de la TR.';
     when 3 then lc_mensaje:='La exoneración ha sido rechazada no puede contabilizar.';
     when 5 then lc_mensaje:='Debe volver a iniciar el proceso de la transacción ya que ha generado un rechazo o tiene una exoneración posterior a la ejecución de la TR.';
     else  lc_mensaje:='';
   end case;
end  sp_validahora;
procedure sp_es_exoneradoAQPB408 ( vn_Pgcod in number,
                           vn_ppmod in number,
                           vn_ppsuc in number,
                           vn_ppmda in number,
                           vn_pppap in number,
                           vn_ppcta in number,
                           vn_ppoper in number,
                           vn_ppsbop in number,
                           vn_pptope in number,
                           vn_ppfpag in date,
                           ln_Indicador out number)

is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPB408
      where AQPB408COD  = vn_Pgcod
        and AQPB408MOD  = vn_ppmod
        and AQPB408SUC  = vn_ppsuc
        and AQPB408MDA  = vn_ppmda
        and AQPB408PAP  = vn_pppap
        and AQPB408CTA  = vn_ppcta
        and AQPB408OPE  = vn_ppoper
        and AQPB408SBO  = vn_ppsbop
        and AQPB408TPO  = vn_pptope
        and AQPB408EST  = 'C'
        and AQPB408TIP like ('REFINANCIA_JUD_PAQPD238_TAQPD24%');
   exception
      when others then
        ln_Indicador :=0;
   end;
end  sp_es_exoneradoAQPB408;
procedure sp_valida (    vn_codigo in number,
                         vn_Pgcod in number,
                         vn_ppmod in number,
                         vn_ppsuc in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_ppsbop in number,
                         vn_pptope in number,
                         lc_mensaje out varchar)
is

ln_Indicador number(1);
lc_horaa varchar(10);
ld_fechaj date;
lc_horaj varchar(10);
ld_fechainia date;
ln_horaa number(2);
ln_horaj number(2);
ln_mina number(2);
ln_minj number(2);
ln_sega number(2);
ln_segj number(2);
ln_existe number(1);
begin
  lc_mensaje:='';
  --solo valida con la tabla de saldos JAQN8J
  begin
       select 1,jaqn8jfec,jaqn8jhum into ln_existe,ld_fechaj,lc_horaj
          from jaqn8j
          where jaqn8jEMP = vn_Pgcod
           and jaqn8jMOD = vn_ppmod
           and jaqn8jSUC = vn_ppsuc
           and jaqn8jMDA = vn_ppmda
           and jaqn8jPAP = vn_pppap
           and jaqn8jCTA = vn_ppcta
           and jaqn8jOPE = vn_ppoper
           and jaqn8jSBO = vn_ppsbop
           and jaqn8jTOP = vn_pptope
           and jaqn8jest = 'G';
       exception
          when others then
            ln_existe :=0;
            lc_horaj:='';
            ln_Indicador:=1;
  end;

  if ( ln_existe = 1 ) then
     --busco hora y fecha de acuerdo de pago
     begin
       select aqpa806hori,aqpa806feci into lc_horaa, ld_fechainia
         from aqpa806 a
       where a.aqpa806pgc = vn_Pgcod
         and a.aqpa806mod = vn_ppmod
         and a.aqpa806suc = vn_ppsuc
         and a.aqpa806mda = vn_ppmda
         and a.aqpa806pap = vn_pppap
         and a.aqpa806cta = vn_ppcta
         and a.aqpa806ope = vn_ppoper
         and a.aqpa806sbo = vn_ppsbop
         and a.aqpa806tpo = vn_pptope
         and a.aqpa806est ='P';  --en proceso
     exception
        when others then
          lc_horaa:=null;
          ld_fechainia:=null;
     end;
     if ( ld_fechaj >ld_fechainia) then
        ln_Indicador:=2;
     else
        ln_horaa := to_number(substr(lc_horaa,1,2));
        ln_horaj := to_number(substr(lc_horaj,1,2));
        ln_mina := to_number(substr(lc_horaa,4,2));
        ln_minj := to_number(substr(lc_horaj,4,2));
        ln_sega := to_number(substr(lc_horaa,7,2));
        ln_segj := to_number(substr(lc_horaj,7,2));
        if ( ld_fechaj = ld_fechainia ) then
          if ( ln_horaj > ln_horaa ) then
            ln_Indicador:=2;
          else
            if ( ln_horaj = ln_horaa and ln_minj > ln_mina ) then
               ln_Indicador:=2;
            end if;
            if ( ln_horaj = ln_horaa and ln_minj = ln_mina and ln_segj > ln_sega ) then
               ln_Indicador:=2;
            end if;
          end if;
        end if;
     end if;
   else
     ln_Indicador:=1;
   end if;
   lc_mensaje:='';
   case ln_Indicador
     when 1 then lc_mensaje:='La exoneración ha sido rechazada no puede Confirmar.';
     when 2 then lc_mensaje:='Debe volver a iniciar el proceso del Acuerdo de Pago ya que ha generado una exoneración posterior a la ejecución del Acuerdo.';
     else  lc_mensaje:='';
   end case;
   if (ln_Indicador<4) then
     update aqpa806 set aqpa806menex=lc_mensaje
     where aqpa806cod=vn_codigo;
     commit;
   end if;
end  sp_valida;
procedure sp_inserta (   vn_Pgcod in number,
                         vn_ppmod in number,
                         vn_ppsuc in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_ppsbop in number,
                         vn_pptope in number,
                         vd_pgfape  in date,
                         vc_usuario in  varchar,
                         lc_mensaje out varchar)
is
lc_hora varchar(8);
begin
   lc_mensaje:='';
   lc_hora:=substr(current_timestamp,10,8);
   update JAQN8J set JAQN8JEST='C',JAQN8Jfec=vd_pgfape
     where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST = 'G';
   commit;
   insert into aqpd225
      (AQPD225COD,
       AQPD225MOD,
       AQPD225SUC,
       AQPD225MDA,
       AQPD225PAP,
       AQPD225CTA,
       AQPD225OPE,
       AQPD225SBO,
       AQPD225TPO,
       AQPD225EST,
       AQPD225USUACT,
       AQPD225FECACT,
       AQPD225HORACT,
       AQPD225TIP)
    values
       (vn_Pgcod,
       vn_ppmod,
       vn_ppsuc,
       vn_ppmda,
       vn_pppap,
       vn_ppcta,
       vn_ppoper,
       vn_ppsbop,
       vn_pptope,
       'C',
       vc_usuario,--fecha de actualización
       vd_pgfape,--usuario de actualización
       lc_hora ,
       'Exoneración Ultima cuota estado 64-JAQN8J');--tipo
    commit;
end  sp_inserta;
procedure sp_validamonto ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_Indicador out number,
                                vn_montoexo out number,
                                vn_montoutlcuo out number)
is
ln_montoexo number(18,2):=0;
ln_ultimacuota number(18,2):=0;
ln_cod number(17):=0;
begin
  begin
      select JAQN8JTEX into ln_montoexo
      from JAQN8J
      where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST='G';
   exception
      when others then
        ln_montoexo :=0;
   end;
   begin
     select aqpa806cod into ln_cod
     from aqpa806 a
     where a.aqpa806pgc = vn_Pgcod
     and a.aqpa806mod = vn_ppmod
     and a.aqpa806suc = vn_ppsuc
     and a.aqpa806mda = vn_ppmda
     and a.aqpa806pap = vn_pppap
     and a.aqpa806cta = vn_ppcta
     and a.aqpa806ope = vn_ppoper
     and a.aqpa806sbo = vn_ppsbop
     and a.aqpa806tpo = vn_pptope
     and a.aqpa806est ='P';  --en proceso
   exception
      when others then
        ln_cod :=0;
   end;
   begin
     select aqpa807cuoval into ln_ultimacuota
     from aqpa807
     where aqpa806cod = ln_cod
     and aqpa807cuonro in ( select max(aqpa807cuonro)
                             from aqpa807
                             where aqpa806cod = ln_cod);
   exception
      when others then
        ln_ultimacuota :=0;
   end;
   vn_montoexo:=ln_montoexo;
   vn_montoutlcuo:=ln_ultimacuota;
   if ( ln_ultimacuota <> ln_montoexo ) then
      vn_Indicador:=1;  --devuelve 1 si el monto a exonerar es mayor a la ultima cuota del cronograma
   else
      vn_Indicador:=0;
   end if;
end sp_validamonto;
procedure sp_plazo ( vn_Pgcod in number,
                                vn_ppmod in number,
                                vn_ppsuc in number,
                                vn_ppmda in number,
                                vn_pppap in number,
                                vn_ppcta in number,
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_tipo out number,
                                vn_plazo out number)
is
ln_cod number(17):=0;
ld_fechaini date;
ln_cuofpg date;
ln_Indicador number;
ln_tipo number;
begin
   begin
     select aqpa806cod,aqpa806feci into ln_cod, ld_fechaini
     from aqpa806 a
     where a.aqpa806pgc = vn_Pgcod
     and a.aqpa806mod = vn_ppmod
     and a.aqpa806suc = vn_ppsuc
     and a.aqpa806mda = vn_ppmda
     and a.aqpa806pap = vn_pppap
     and a.aqpa806cta = vn_ppcta
     and a.aqpa806ope = vn_ppoper
     and a.aqpa806sbo = vn_ppsbop
     and a.aqpa806tpo = vn_pptope
     and a.aqpa806est ='P';  --en proceso
   exception
      when others then
        ln_cod :=0;
        ld_fechaini:=null;
   end;
   --falta obtener la fecha de la ultima cuota
   begin
     select  aqpa807cuofpg into ln_cuofpg
     from aqpa807
     where aqpa807cuonro in (select max(aqpa807cuonro) from aqpa807 where aqpa806cod=ln_cod)
     and aqpa806cod=ln_cod;
   exception
      when others then
        ln_cuofpg :=null;
   end;
   vn_plazo := ln_cuofpg - ld_fechaini;
   Begin
   select 1,JAQN8JTIP into ln_Indicador,ln_tipo
      from JAQN8J
      where JAQN8JEMP = vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST='G';
   exception
      when others then
        ln_tipo :=0;
   end;
   vn_tipo:=ln_tipo;
end sp_plazo;
procedure sp_extorna (   vn_Pgcod in number,
                         vn_ppmod in number,
                         vn_ppsuc in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_ppsbop in number,
                         vn_pptope in number,
                         vc_usuario in varchar,
                         vd_pgfape  in date)
is

begin

   update aqpa806 set aqpa806est='I',aqpa806fecactr=vd_pgfape,aqpa806usuactr=vc_usuario
     where aqpa806pgc = vn_Pgcod
       and aqpa806mod = vn_ppmod
       and aqpa806suc = vn_ppsuc
       and aqpa806mda = vn_ppmda
       and aqpa806pap = vn_pppap
       and aqpa806cta = vn_ppcta
       and aqpa806ope = vn_ppoper
       and aqpa806sbo = vn_ppsbop
       and aqpa806tpo = vn_pptope
       and aqpa806est = 'S';
   update JAQN8J set JAQN8JEST='A',JAQN8Jfec=vd_pgfape
      where JAQN8JEMP= vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST = 'C';
   update aqpd225 set AQPD225EST='A', AQPD225FECEXT=vd_pgfape
   where AQPD225COD= vn_Pgcod
     and AQPD225MOD= vn_ppmod
     and AQPD225SUC= vn_ppsuc
     and AQPD225MDA= vn_ppmda
     and AQPD225PAP= vn_pppap
     and AQPD225CTA= vn_ppcta
     and AQPD225OPE= vn_ppoper
     and AQPD225SBO= vn_ppsbop
     and AQPD225TPO= vn_pptope
     and AQPD225EST= 'C';
    commit;
end  sp_extorna;
--extorno para la transacción 300/400
procedure sp_extorna2 (  vn_Pgcod in number,
                         vn_ppmod in number,
                         vn_ppsuc in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_ppsbop in number,
                         vn_pptope in number,
                         vc_usuario in varchar,
                         vd_pgfape  in date)
is

begin

   update aqpa806 set aqpa806est='I',aqpa806fecactr=vd_pgfape,aqpa806usuactr=vc_usuario
     where aqpa806pgc = vn_Pgcod
       and aqpa806mod = vn_ppmod
       and aqpa806suc = vn_ppsuc
       and aqpa806mda = vn_ppmda
       and aqpa806pap = vn_pppap
       and aqpa806cta = vn_ppcta
       and aqpa806ope = vn_ppoper
       and aqpa806sbo = vn_ppsbop
       and aqpa806tpo = vn_pptope
       and aqpa806est = 'S';
   update JAQN8J set JAQN8JEST='A',JAQN8Jfec=vd_pgfape
      where JAQN8JEMP= vn_Pgcod
       and JAQN8JMOD = vn_ppmod
       and JAQN8JSUC = vn_ppsuc
       and JAQN8JMDA = vn_ppmda
       and JAQN8JPAP = vn_pppap
       and JAQN8JCTA = vn_ppcta
       and JAQN8JOPE = vn_ppoper
       and JAQN8JSBO = vn_ppsbop
       and JAQN8JTOP = vn_pptope
       and JAQN8JEST = 'C';
   update JAQN8I set JAQN8IEST='A',JAQN8Ifec=vd_pgfape
      where JAQN8IEMP= vn_Pgcod
       and JAQN8IMOD = vn_ppmod
       and JAQN8ISUC = vn_ppsuc
       and JAQN8IMDA = vn_ppmda
       and JAQN8IPAP = vn_pppap
       and JAQN8ICTA = vn_ppcta
       and JAQN8IOPE = vn_ppoper
       and JAQN8ISBO = vn_ppsbop
       and JAQN8ITOP = vn_pptope
       and JAQN8IEST = 'C';
   update aqpd225 set AQPD225EST='A', AQPD225FECEXT=vd_pgfape
   where AQPD225COD= vn_Pgcod
     and AQPD225MOD= vn_ppmod
     and AQPD225SUC= vn_ppsuc
     and AQPD225MDA= vn_ppmda
     and AQPD225PAP= vn_pppap
     and AQPD225CTA= vn_ppcta
     and AQPD225OPE= vn_ppoper
     and AQPD225SBO= vn_ppsbop
     and AQPD225TPO= vn_pptope
     and AQPD225EST= 'C';
    commit;
end  sp_extorna2;
procedure sp_conteoref ( vn_Pgcod in number,
                         vn_ppmda in number,
                         vn_pppap in number,
                         vn_ppcta in number,
                         vn_ppoper in number,
                         vn_contador out number)
is
begin
  begin
   select count(*) into vn_contador
   from (select h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON --into ln_continua,ln_PGCODH,ln_HCMOD,ln_HSUCOR,ln_HTRAN,ln_HNREL,ld_HFCON
            from fsh016 h
            inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
          where h.PGCOD = vn_Pgcod
            and h.HMDA = vn_ppmda
            and h.HPAP = vn_pppap
            and h.HCTA = vn_ppcta
            and h.HOPER= vn_ppoper
            and h.HCMOD= 300
            and h.HTRAN= 403
            and s.hccorr= 0
            group by h.PGCOD,h.HCMOD,h.HSUCOR,h.HTRAN,h.HNREL,h.HFCON);
   exception
     when no_data_found then
       vn_contador:=0;
  end;
end  sp_conteoref;
end pq_cr_exojudicial;
/

