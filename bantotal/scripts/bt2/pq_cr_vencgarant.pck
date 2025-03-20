create or replace package PQ_CR_VENCGARANT is

  -- Author  : CCERPA
  -- Created : 06/03/2017 12:30:45 p.m.
  -- Purpose :

  -- *****************************************************************
  -- Nombre                     : sp_cr_segmentogarantias
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/05/2017
  -- Autor de Creación          : CCERPA 
  -- Uso                        : RETORNA EL SEGEMENTO DE LA INSTANCIA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : ln_instancia
  -- Parámetros de Salida       : segmento
  --                            : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  Procedure sp_cr_segmentogarantias(ln_instancia in number,
                                    segmento     out number);

  -- *****************************************************************
  -- Nombre                     : sp_cr_obtenerubigeo
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/05/2017
  -- Autor de Creación          : CCERPA 
  -- Uso                        : RETORNA LA REGION LA SUCURSAL Y ZONA 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : ln_region,ln_sucursal,ln_zona
  -- Parámetros de Salida       : regionout,sucursalout,zonaout
  --                            : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  Procedure sp_cr_obtenerubigeo(ln_region   in number,
                                ln_sucursal in number,
                                ln_zona     in number,
                                regionout   out varchar,
                                sucursalout out varchar,
                                zonaout     out varchar);
  -- *****************************************************************
  -- Nombre                     : SP_CR_GARANTPORVENC
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 18/05/2017
  -- Autor de Creación          : CCERPA 
  -- Uso                        : ENVIA CORREOS ELECTRONICOS A LOS ANALISTA DE CRIDITOS,
  --                              ANALISTA SENIOR Y GENRETE DE AGENCIA,ALERTANDO EL POSIBLE
  --                              VENCIENTO DE LAS GARANTIAS PERTENECIETES A LA SUCURSAL 
  --                              QUE SE ENCUENTRE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  -- Parámetros de Salida       : 
  --                            : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  procedure SP_CR_GARANTPORVENC;
end PQ_CR_VENCGARANT;
/

create or replace package body PQ_CR_VENCGARANT is

  Procedure sp_cr_segmentogarantias(ln_instancia in number,
                                    segmento     out number) is
  
  begin
    select s.sng021tmod
      into segmento
      from sng021 s
     where s.sng021sol = ln_instancia;
  
  exception
    When others then
      null;
  End sp_cr_segmentogarantias;

  Procedure sp_cr_obtenerubigeo(ln_region   in number,
                                ln_sucursal in number,
                                ln_zona     in number,
                                regionout   out varchar,
                                sucursalout out varchar,
                                zonaout     out varchar) is
  
  begin
    select regnom, scnom, deszon
      into regionout, sucursalout, zonaout
      from regsuc
     where regcod = ln_region
       and sucurs = ln_sucursal
       and codzon = ln_zona;
  
  exception
    When others then
      null;
  End sp_cr_obtenerubigeo;

procedure SP_CR_GARANTPORVENC is
  --lc_CenomEs char(30);
  lv_asunto varchar2(200);
  lv_nombre        char(30);
  lc_direccion     char(50);
  lv_documento     varchar2(12);
  ln_tipodocumento number(3);
  ln_pais          number(3);
  lv_cuerpo        varchar2(800);
  ln_operacion     NUMBER(9);
  ln_cuenta        NUMBER(9);
  ln_sucursal      number(3);
  lv_usuario       varchar2(16);
  --ln_instancia number(17);
  cursor c_garantias_porvencer is
  
    select fin.xwfcuenta,
           fin.ppg002cod,
           fin.ppg002mod,
           fin.ppg002suc,
           fin.ppg002mda,
           fin.ppg002pap,
           fin.ppg002cta,
           fin.ppg002ope,
           fin.ppg002sbo,
           max(fin.ppg002frm),
           fin.ppg002cdat,
           fin.ppg002cor,
           fin.ppg002top,
           max(fin.ppg002dato),
           max(fin.porvencer)
      from (select pr.xwfcuenta,
                   p2.ppg002cod,
                   p2.ppg002mod,
                   p2.ppg002suc,
                   p2.ppg002mda,
                   p2.ppg002pap,
                   p2.ppg002cta,
                   p2.ppg002ope,
                   p2.ppg002sbo,
                   p2.ppg002frm,
                   p2.ppg002cdat,
                   p2.ppg002cor,
                   p2.ppg002top,
                   p2.ppg002dato,
                   (CASE
                     WHEN p2.ppg002top = 40 or p2.ppg002top = 42 THEN
                      (CASE
                        WHEN (select pgfape from fst017 where pgcod = 1) <=
                             add_months(p2.ppg002dato, 12) and
                             add_months(p2.ppg002dato, 11) <=
                             (select pgfape from fst017 where pgcod = 1) THEN
                         add_months(p2.ppg002dato, 12) /*por vencer*/
                        ELSE
                         TO_DATE('01/01/0001', 'dd/mm/yyyy')
                      END)
                     ELSE
                      (Case
                        when ((select pgfape from fst017 where pgcod = 1) <=
                             add_months(p2.ppg002dato, 24) and
                             add_months(p2.ppg002dato, 23) <=
                             (select pgfape from fst017 where pgcod = 1)) then
                         add_months(p2.ppg002dato, 24) /*por vencer*/
                        else
                         to_date('01/01/0001', 'dd/mm/yyyy')
                      end)
                   /*TO_DATE('01/01/0001','dd/mm/yyyy')*/
                   END) as porvencer
              from ppg002 p2
             inner join (select p.ppg000pgc,
                               p.ppg000mod,
                               p.ppg000suc,
                               p.ppg000mda,
                               p.ppg000pap,
                               p.ppg000cta,
                               p.ppg000ope,
                               p.ppg000sbo,
                               p.ppg000top,
                               max(p.ppg000frm) ppg000frm,
                               fs.xwfcuenta
                          from ppg000 p,
                               (select x.xwfprcins,
                                       sn.sng122pgc,
                                       sn.sng122mod,
                                       sn.sng122suc,
                                       sn.sng122mda,
                                       sn.sng122pap,
                                       sn.sng122cta,
                                       sn.sng122oper,
                                       sn.sng122sbop,
                                       sn.sng122tope,
                                       x.xwfcuenta
                                  from (select fs.xwfprcins, fs.xwfcuenta
                                          from fsd010 fsd
                                         inner join (select xw.xwfprcins,
                                                           xw.xwfempresa,
                                                           xw.xwfsucursal,
                                                           xw.xwfmodulo,
                                                           xw.xwfmoneda,
                                                           xw.xwfpapel,
                                                           xw.xwfcuenta,
                                                           xw.xwfoperacion,
                                                           xw.xwfsubope,
                                                           xw.xwftipope
                                                      from jaql964 jaql
                                                     inner join xwf700 xw
                                                        on xw.xwfprcins =
                                                           jaql.jaql964ins
                                                     where xw.xwfmodulo <>
                                                           117and /*ojito*/
                                                     xw.xwfcar3 = '1') fs
                                            on fsd.Pgcod = fs.xwfempresa
                                           and fsd.Aomod = fs.xwfmodulo
                                           and fsd.Aosuc = fs.xwfsucursal
                                           and fsd.Aomda = fs.xwfmoneda
                                           and fsd.Aopap = fs.xwfpapel
                                           and fsd.Aocta = fs.xwfcuenta
                                           and fsd.Aooper = fs.xwfoperacion
                                           and fsd.Aosbop = fs.xwfsubope
                                           and fsd.Aotope = xwftipope
                                         where fsd.Aostat in (0, 61)) x
                                 inner join sng122 sn
                                    on x.xwfprcins = sn.sng122inst) fs ---ojito
                        
                         where p.ppg000pgc = fs.sng122pgc
                           and p.ppg000mod = fs.sng122mod
                           and p.ppg000suc = fs.sng122suc
                           and p.ppg000mda = fs.sng122mda
                           and p.ppg000pap = fs.sng122pap
                           and p.ppg000cta = fs.sng122cta
                           and p.ppg000ope = fs.sng122oper
                           and p.ppg000sbo = fs.sng122sbop
                           and p.ppg000top = fs.sng122tope
                           and p.ppg000top in (10,
                                               15,
                                               20,
                                               25,
                                               30,
                                               40,
                                               42,
                                               45,
                                               47,
                                               50,
                                               55,
                                               60,
                                               65)
                           and p.ppg000tco = 'S'
                         group by p.ppg000pgc,
                                  p.ppg000mod,
                                  p.ppg000suc,
                                  p.ppg000mda,
                                  p.ppg000pap,
                                  p.ppg000cta,
                                  p.ppg000ope,
                                  p.ppg000sbo,
                                  p.ppg000top,
                                  fs.xwfcuenta) pr
                on p2.ppg002cod = pr.ppg000pgc
               and p2.ppg002mod = pr.ppg000mod
               and p2.ppg002suc = pr.ppg000suc
               and p2.ppg002mda = pr.ppg000mda
               and p2.ppg002pap = pr.ppg000pap
               and p2.ppg002cta = pr.ppg000cta
               and p2.ppg002ope = pr.ppg000ope
               and p2.ppg002sbo = pr.ppg000sbo
               and p2.ppg002top = pr.ppg000top
               and p2.ppg002frm = pr.ppg000frm
             where p2.ppg002cdat = 77) fin
     where fin.porvencer <> TO_DATE('01/01/0001', 'dd/mm/yyyy')
       and fin.ppg002suc in (select sucurs from fst001)
     group by fin.xwfcuenta,
              fin.ppg002cod,
              fin.ppg002mod,
              fin.ppg002suc,
              fin.ppg002mda,
              fin.ppg002pap,
              fin.ppg002cta,
              fin.ppg002ope,
              fin.ppg002sbo,
              fin.ppg002cdat,
              fin.ppg002cor,
              fin.ppg002top;

  cursor c_garantias_usuario(ln_sucursal1 NUMBER) is
  
    SELECT fs.ubuser
      FROM FST046 fs,
           (select distinct (prfu00.ubuser) ubu
              from prfu00
             INNER JOIN (select TP1DESC
                          from fst198
                         where tp1cod1 = 11007
                           and tp1corr2 = 2) da
                on prfu00.prfgcod = da.tp1desc) prf
     where fs.ubuser = prf.ubu
       and fs.ubsuc = ln_sucursal1; -- and Rownum=1;

BEGIN
  --989089911
  lv_asunto := 'Garantias por vencer en este mes';

  for i in c_garantias_porvencer loop
    begin
      ---ln_instancia:=0;
    
      select fsr008.petdoc, fsr008.pepais, fsr008.pendoc
        into ln_tipodocumento, ln_pais, lv_documento
        from fsr008
       where fsr008.cttfir = 'T'
         and fsr008.ttcod = 1
         and fsr008.ctnro = i.xwfcuenta; /*(select xwf700.xwfcuenta  from xwf700 where xwf700.xwfcar3='1' and  xwf700.xwfprcins =( select SNG122.SNG122INST  from sng122 WHERE
          sng122.sng122pgc=i.ppg002cod and  sng122.sng122mod=i.ppg002mod and sng122.sng122suc=i.ppg002suc and
          sng122.sng122mda=i.ppg002mda and sng122.sng122pap=i.ppg002pap and sng122.sng122cta=i.ppg002cta and sng122.sng122oper=i.ppg002ope
          and  sng122.sng122sbop=i.ppg002sbo and sng122.sng122tope= i.ppg002top and rownum=1)AND rownum=1);
    */
      select fsd001.penom
        into lv_nombre
        from fsd001
       where fsd001.pepais = ln_pais
         and fsd001.petdoc = ln_tipodocumento
         and fsd001.pendoc = lv_documento;
      select ppg001.ppg001dato,
             ppg001.ppg001cta,
             ppg001.ppg001ope,
             ppg001.ppg001suc
        INTO lc_direccion, ln_cuenta, ln_operacion, ln_sucursal
        from ppg001
       where ppg001.ppg001cod = i.ppg002cod
         and ppg001.ppg001mod = i.ppg002mod
         and ppg001.ppg001suc = i.ppg002suc
         and ppg001.ppg001mda = i.ppg002mda
         and ppg001.ppg001pap = i.ppg002pap
         and ppg001.ppg001cta = i.ppg002cta
         and ppg001.ppg001ope = i.ppg002ope
         and ppg001.ppg001sbo = i.ppg002sbo
         and ppg001.ppg001top = i.ppg002top
         AND Rownum = 1;
    
      /*  */
      /*     ', registra POR VENCER la garantía con cuenta '||TO_CHAR(ln_cuenta)||
      ' operacion '||TO_CHAR(ln_operacion)||', correspondiente a INMUEBLE UBICADO en'
      ||lc_direccion||',por la cual se solicita inicie el proceso de RETASACION de la misma, de acuerdo a lo normado por nuestro reglamento';*/
      --lc_usuario
      for a in c_garantias_usuario(i.ppg002suc) loop
        begin
          lv_usuario := TRIM(a.ubuser);
          lv_cuerpo  := '"Sirva la presente para informarle que nuestro cliente ,' ||
                        trim(lv_nombre) ||
                        ',Registra POR VENCER  la valuación de la garantía con cuenta ' ||
                        TO_CHAR(ln_cuenta) || ' ,operacion ' ||
                        TO_CHAR(ln_operacion) ||
                        ', correspondiente a INMUEBLE UBICADO en ' ||
                        trim(lc_direccion) ||
                        ',por la cual se solicita inicie el proceso de RETASACION de la misma, de acuerdo a lo normado por nuestro reglamento"';
        
          sP_CONCATENA_MAIL('AlertaDeGanrantias',
                            lv_usuario,
                            lv_asunto,
                            lv_cuerpo);
          --    exit;
        end;
      
      end loop;
    
    end;
  end loop;

END SP_CR_GARANTPORVENC;

End PQ_CR_VENCGARANT;
/

