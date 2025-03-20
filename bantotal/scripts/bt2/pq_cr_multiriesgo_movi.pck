create or replace package PQ_CR_MULTIRIESGO_MOVI is


-- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE SEGURO MULTIRIESGO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/11/2022 17:57:33
    -- Autor de Creación          : SILVIA MARQUEZ
    -- Uso                        : egistra, Afiliaciones,Cancelaciones,Cobros Diarios
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Author         : SMARQUEZ
    -- Created        : 26/12/2023
    -- Purpose        : mODIFICACION PARA ADICION DE EXCEPCIONES DE TOO_MANY_ROWS Y ERROR DE TAMAÑO DE DATOS
    -- Author         : SMARQUEZ
    -- Created        : 17/04/2024
    -- Purpose        : Manejo de Excepciones con too_many_rows
    -- Author         : SMARQUEZ
    -- Created        : 27/08/2024
    -- Purpose        : Manejo de Excepciones con too_many_rows
    -- *****************************************************************

   PROCEDURE SP_AFILIACION(p_fechapro in date);

   PROCEDURE SP_SEGUROMULTI(ln_pgcod     in number,
                            ln_modulo    in number,
                            ln_sucursal  in number,
                            ln_moneda    in number,
                            ln_papel     in number,
                            ln_cuenta    in number,
                            ln_operacion in number,
                            ln_suboper   in number,
                            ln_tope      in number,
                            ln_codseg    in number,
                            ln_costo    out number,
                            ln_prima    out number);

  PROCEDURE SP_COBRO(p_fechapro in date);

  PROCEDURE SP_MULTI_TRAMA_ALTAS(P_FECHA IN DATE);

  PROCEDURE SP_MULTI_TRAMA_COBROS(P_FECHA IN DATE);

  PROCEDURE SP_MULTIGARANTIA_TRAMA_ALTAS(P_FECHA IN DATE);

  PROCEDURE SP_MULTIGARANTIA_TRAMA_COBROS(P_FECHA IN DATE);

end PQ_CR_MULTIRIESGO_MOVI;
/

create or replace package body PQ_CR_MULTIRIESGO_MOVI is

-- *****************************************************************
    -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE SEGURO MULTIRIESGO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 15/11/2022 17:57:33
    -- Autor de Creación          : SILVIA MARQUEZ
    -- Uso                        : egistra, Afiliaciones,Cancelaciones,Cobros Diarios
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Author                     : SMARQUEZ
    -- Created                    : 07/12/2023
    -- Purpose                    : mODIFICACION PARA ADICION DE EXCEPCIONES DE TOO_MANY_ROWS
    -- Author                     : SMARQUEZ
    -- Created                    : 25/01/2024
    -- Purpose                    : CREACION NUEVOS PROCESOS PARA LAS TRAMAS DE MULTIRIESGO
    -- Author                     : SMARQUEZ
    -- Created                    : 17/04/2024
    -- Purpose                    : Manejo de Excepciones con too_many_rows
    -- Modificacion               : SMARQUEZ 12/07/2024 Adicion contro para ORA 1422
    -- Modificacion               : SMARQUEZ 13/01/2025 Modificacion too many rows linea 2792   
    -- *****************************************************************
PROCEDURE SP_AFILIACION(p_fechapro in date)is
CURSOR CUENTAS IS
        select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                b.aoimp monto
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
             and b.aofval = p_fechapro; --'01/09/2022'

CURSOR bajas IS
        select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                to_char(b.aofe99,'yyyymmdd') fechacance,
                b.aoimp monto
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
             and b.aofe99  = p_fechapro
             and b.aostat = 99 ;
  cursor celular (pais number,tdoc number,ndoc char) is
      select trim(dotelfp) fono
        from fsr005
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and docod = 1
         and rownum = 1;

    cursor correo (pais number,tdoc number,ndoc char) is
      select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
        from fsx001
       where pepais = pais
         and petdoc = tdoc
         and pendoc = ndoc
         and txcod = 0 --x_08.txcod = 0
         and pextxt <> 'SI'
         and pextxt Like '%@%'
         and rownum = 1;

lc_telefono   char(50);
tele varchar2(50);
lc_correo     char(50);
apepat char(50);
apemat char(50);
nombres char(50);
sexo char(1);
ecivil char(1);
fechanac varchar2(8);
pais number;
tipodoc number;
tipodocA CHAR(3);
numdoc char(12);
direcc char(100);
RAZONS CHAR(150);
mail char(200);
telefono char(50);
ubigeo char(10);
GIRO char(300);
OCUPACION char(50);
sucursal char(30);
funcionario char(10);
INSTANCIA number;
operacion number(9);
ln_cont number:= 0;
ln_cont1 number:=0;

correlativo number(17):=0;
certificado char(30);
doctipo char(3);
contador number;
prima number(17,2):=0;
dIRECCION_neg char(300);
ubigeo_neg char(8);
tasa number(10,6):=0;
costo number(17,2):=0;
nrocuota number:= 0;
CTASA CHAR(20);
dirdomi char(100);
ubidomi char(8);
actdomi char(300);
ocudomi char(50);
v_num1 number;
v_num2 number;
v_char1 char(200);
v_char2 char(20);
v_char22 char(10);
v_resul number:= 0;
tipo_via char(1);
direccion1 char(100);
USO char(1);
tipoconstruccion char(1);
Nro_Piso char(10);
Nro_Sotano char(10);
A_Fabrica char(10);
A_Constru char(10);
contenido char(1000);
codigo_giro number:=0;
saldoasegurado number(17,2):= 0;
imp11 number:= 0;
imp12 number:= 0;
imp13 number:= 0;
imp14 number := 0;
minFecha date;

begin

  Execute immediate ('truncate table aqpa555');

  For a in cuentas loop
       apepat := NULL;
       apemat := NULL;
       nombres := NULL;
       sexo:= NULL;
       ecivil:= NULL;
       fechanac:= NULL;
       tipodoc:= NULL;
       numdoc:= NULL;
       direcc := NULL;
       razons := null;
       telefono := null;
       mail:= null;
       ubigeo := null;
       giro := null;
       ocupacion := null;
       sucursal := null;
       funcionario :=null;
       INSTANCIA :=0;
       certificado := null;
    Begin
       select  trim(d.pfape1),
               trim(d.pfape2),
               trim(d.pfnom1)||' '||trim(d.pfnom2),
               d.pfcant,
               Decode(d.pfeciv,1, 'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
              to_char(d.pffnac,'yyyymmdd'),
              d.pfpais,
              d.pftdoc,
              Decode(d.pftdoc,21,'001','000'),
              d.pfndoc,
        (select substr(trim(sngc13dir),1,100)
           from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' ),
        (select trim(sngc13ugeo)
           from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' )

        into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
         from fsd002 d
         inner join fsr008 e
                 on e.pepais = d.pfpais
                and e.petdoc = d.pftdoc
                and e.pendoc = d.pfndoc
              where e.pgcod = 1
                and e.ctnro = a.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
    exception
      when no_data_found then
        Begin
           select TRIM(d.pjrazs),
                  d.pjpais,
                  d.pjtdoc,
                  decode(d.pjtdoc,9,'002','001'),
                  d.pjndoc,
                  (select substr(trim(sngc13dir),1,50)
                     from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' ),
                  (select trim(sngc13ugeo)
                     from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )

             into razons,pais,tipodoc,tipodocA, numdoc, direcc, ubigeo
             from fsd003 d
             inner join fsr008 e
                     on e.pepais = d.pjpais
                    and e.petdoc = d.pjtdoc
                    and e.pendoc = d.pjndoc
            where e.pgcod =1
              and e.ctnro = a.aocta
              and e.ttcod = 1
              and e.cttfir ='T';
        exception
          when no_data_found then
            null;

          when others then
           null;
        end;
    end;
    -- telefono y correo smarquez 17102019
    lc_telefono := null;
    lc_correo := null;
    tele := null;
    For t in celular(pais,tipodoc,numdoc)loop
       if ln_cont = 0 then
          tele := trim(t.fono);
        else
          tele := substr(tele,1,50);
          tele := trim(tele)||' '||trim(t.fono);
        end if;
       ln_cont := ln_cont + 1;
    end loop;
    lc_telefono := substr(tele,1,50);
     For c in correo(pais,tipodoc,numdoc)loop
        if ln_cont1 = 0 then
          mail := trim(c.mail);
        else
          mail := substr((trim(mail)||' '||trim(c.mail)),1,50);
        end if;

       ln_cont1 := ln_cont1 + 1;
    end loop;
     lc_correo := substr(mail,1,50);
    begin
      select
          (SELECT substr(trim(A1.AQPA558ACT),1,50) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
          (SELECT nvl(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
           (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) )
        into ocupacion,
             giro,
             codigo_giro
        from SNGC60
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = (select max(sngc60corr)
                             from SNGC60
                            where sngc60pais = pais
                              and sngc60tdoc = tipodoc
                              and sngc60ndoc = numdoc );
    exception
      when no_data_found then
        beGIN
          select
              (SELECT substr(trim(A1.AQPA558ACT),1,50) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
              AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
              AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
              (SELECT nvl(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
              AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
              AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
               (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
              AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
              AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) )
            into ocupacion,
                 giro,
                 codigo_giro
            from SNGC60
           where sngc60rute = numdoc
             and sngc60corr = (select max(sngc60corr)
                                 from SNGC60
                                where sngc60rute = numdoc);
        exception
          when no_data_found then
            giro:= null;
            ocupacion:= null;
          when too_many_rows then
           beGIN
            select
                (SELECT substr(trim(A1.AQPA558ACT),1,50) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
                (SELECT nvl(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
                 (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) )
              into ocupacion,
                   giro,
                   codigo_giro
              from SNGC60
             where sngc60rute = numdoc
               and sngc60corr = (select max(sngc60corr)
                                   from SNGC60
                                  where sngc60rute = numdoc)
               and rownum = 1;
          exception
            when no_data_found then
              giro:= null;
              ocupacion:= null;
          end;

        end;
      when too_many_rows then
        begin
         select
          (SELECT substr(trim(A1.AQPA558ACT),1,50) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
          (SELECT nvl(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
           (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
          AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
          AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) )
        into ocupacion,
             giro,
             codigo_giro
        from SNGC60
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = (select max(sngc60corr)
                             from SNGC60
                            where sngc60pais = pais
                              and sngc60tdoc = tipodoc
                              and sngc60ndoc = numdoc )
         and rownum = 1;
       exception
          when no_data_found then
            giro:= null;
            ocupacion:= null;
        end;
    end;

    bEGIN
      sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog
        INTO INSTANCIA, operacion, saldoasegurado
        FROM XWF700 n inner join sng122 m
                      on m.sng122inst = n.xwfprcins
         WHERE xwfempresa = 1
           and xwfmodulo = a.aomod
           and xwfmoneda = a.aomda
           and xwfpapel = a.aopap
           AND xwfcuenta = a.AOCTA
           AND xwfoperacion = a.AOOPER
           and xwftipope = a.aotope
           AND xwfcar3 ='1';
    EXCEPTION
      WHEN OTHERS then
         NULL;
    END;

   funcionario  := FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE);
   if funcionario is null then
    Begin
      select sng001ase
        into funcionario
        from sng001 --Cambiar la tabla para producción
       where sng001inst = instancia;
    Exception
      when no_data_found then
        funcionario := 'NOASESORES';
    end;
   end if;

    select TRIM(TP1DESC)
      into CTASA
     from fst198 where tp1cod = 1 and tp1cod1 = 11138
    and tp1corr1 = 9
    and tp1corr2 = 1
    and tp1corr3 = 1;-- '0.028
    tasa := to_number(trim(CTASA),'9.999');
--- prima     ***********************
    select count(*)
      into contador
      from fpp001 where  pgcod = a.pgcod
             and aomod = a.aomod
             and aosuc = a.aosuc
             and aomda = a.aomda
             and aopap = a.aopap
             and aocta = a.aocta
             and aooper = a.aooper
             and aosbop = a.aosbop
             and aotope = a.aotope ;

     Select min(ppfpag)
        into minFecha
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

    Begin
      imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
      Select ppimp11,ppimp12, ppimp13,ppimp14
        into imp11,imp12, imp13,imp14
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope
         and ppfpag > minFecha
         and rownum = 1;
    exception
      when no_data_found then
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
    end;
    if contador = 2 then
      prima := imp11;
    elsif contador = 3 then
      prima:= imp12;
    elsif contador = 4 then
      prima := imp13;
    else
      prima:= imp11;
   end if;
   /*
    prima2 :=(a.aoimp * tasa)/100;
    if prima2 < 5.1 and saldoasegurado <= 20000 then
      prima2 := 5.1;
    end if;
    if prima2 < 6.1 and (saldoasegurado >= 20001 and saldoasegurado <=30000) then
      prima2 := 6.1;
    end if;
    if prima2 < 8.1 and (saldoasegurado >= 30001  and saldoasegurado <=600000) then
      prima2 := 8.1;
    end if;
    if prima2 >*/
 -----------------------------------------------------------------------------

    select count(*)
      into nrocuota
      from fsd611
     where pgcod = a.pgcod
       and ppmod = a.aomod
       and ppsuc = a.aosuc
       and ppmda = a.aomda
       and pppap = a.aopap
       and ppcta = a.aocta
       and ppoper = a.aooper
       and ppsbop = a.aosbop
       and pptope = a.aotope;

    if nrocuota  is null or nrocuota = 0 then
      nrocuota := 1;
    end if;

   ---- costo :=  prima * nrocuota;

    Begin
    if tipodoc = 9 then
      doctipo := '002';
    else
      doctipo :='001';
    end if;

    begin
      select
        substr(trim(t_dire.ppg001dato),1,50), -- direccion
        t_adic.ppg008cip,-- ubigeo

        (SELECT substr(A1.AQPA558ACT,1,50) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 )aCTIVIDAD, --ocupacion
        (SELECT substr(trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 )GIRO --, -- giro
        into dirdomi, ubidomi,  ocudomi,actdomi
        from
        sng122 w,
        ppg008 t_adic,
        fst071 t_dist,
        fst070 t_prov,
        fst068 t_dept,
        ppg001 t_dire,
        fsd008 t_ctte,
        fst750 t_ciiu,
        fst752 t_grup
       /* ppg003 t_nume,
        ppg003 t_nume1,
        ppg003 t_nume2,
        ppg003 t_nume3 */
      where W.SNG122CTA =  a.aocta --CUENTA
        and w.sng122oper = operacion --OPERACION
        AND W.SNG122INST = INSTANCIA
        and t_adic.ppg008pgc(+) = w.sng122pgc
        and t_adic.ppg008mod(+) = w.sng122mod
        and t_adic.ppg008suc(+) = w.sng122suc
        and t_adic.ppg008mda(+) = w.sng122mda
        and t_adic.ppg008pap(+) = w.sng122pap
        and t_adic.ppg008cta(+) = w.sng122cta
        and t_adic.ppg008ope(+) = w.sng122oper
        and t_adic.ppg008sbo(+) = w.sng122sbop
        and t_adic.ppg008top(+) = w.sng122tope
        --and t_adic.ppg008corr(+) = w.sng122corr
        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
        and t_adic.ppg008cdat(+) = 58
        and t_dept.pais(+) = 604
        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1)
        and t_prov.pais(+) = 604
        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1)
        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071pai(+) = 604
        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)
        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071col(+) = t_adic.ppg008cip

        and t_dire.ppg001cod(+) = w.sng122pgc
        and t_dire.ppg001mod(+) = w.sng122mod
        and t_dire.ppg001suc(+) = w.sng122suc
        and t_dire.ppg001mda(+) = w.sng122mda
        and t_dire.ppg001pap(+) = w.sng122pap
        and t_dire.ppg001cta(+) = w.sng122cta
        and t_dire.ppg001ope(+) = w.sng122oper
        and t_dire.ppg001sbo(+) = w.sng122sbop
        and t_dire.ppg001top(+) = w.sng122tope
        --and t_dire.ppg003cor(+) = w.sng122corr
        --and t_dire.ppg003frm(+) = 0---t_cgar.ppg000frm
        and t_dire.ppg001cdat(+) = 41
        and t_ctte.pgcod(+)= 1
        and t_ctte.ctnro(+) =  W.SNG122CTA
        and t_ciiu.actcod1(+) = t_ctte.ctnroi
        and t_grup.actcod3(+) = t_ciiu.actcod3
        ;
    exception
       when no_data_found then
         dirdomi := direcc;
         ubidomi := null;
         actdomi := null;
         ocudomi := null;
       when too_many_rows then
         dbms_output.put_line(a.aocta||' '||operacion||' '||instancia);

    end;
    select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
    select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
    select instr(v_char1,' ') into v_num2 from dual;
    select trim(substr(v_char1,1,v_num2)) into v_char2 from dual;
    direccion1 := upper(dirdomi);

    select REGEXP_INSTR( direccion1,'JR|JIRON') into v_resul from dual;
    if v_resul <> 0 then
      tipo_via :='J';
    else
      select REGEXP_INSTR( direccion1,'C|CALLE') into v_resul from dual;
      if v_resul <> 0 then
        tipo_via :='C';
      else
        select REGEXP_INSTR( direccion1,'AV|AVENIDA') into v_resul from dual;
        if v_resul <> 0 THEN
          tipo_via :='A';
        else
          select REGEXP_INSTR( direccion1,'URB|URBANIZACION') into v_resul from dual;
          if v_resul <> 0 THEN
            tipo_via :='A';
          else
            tipo_via := 'O';
          end if;
        end if;
      end if;
    end if;
    Begin
      select decode( trim(ppg008desc),'VIVIENDA','1','OFICINA','1','TALLER','1', 'NAVE INDUSTRIAL O GRANDES ALMA','4','CENTRO DE SALUD','4','CENTRO EDUCATIVO','4','5')
        into uso
        from ppg008
       where ppg008pgc(+) = 1
         and ppg008mod(+) = 70
         and ppg008cta(+) = a.aocta
         and ppg008ope(+) = OPERACION
         and ppg008cdat(+) = 120;
    exception
        when no_Data_found then
          USO := '0';
        when too_many_rows then
           select decode( trim(ppg008desc),'VIVIENDA','1','OFICINA','1','TALLER','1', 'NAVE INDUSTRIAL O GRANDES ALMA','4','CENTRO DE SALUD','4','CENTRO EDUCATIVO','4','5')
        into uso
        from ppg008
       where ppg008pgc(+) = 1
         and ppg008mod(+) = 70
         and ppg008cta(+) = a.aocta
         and ppg008ope(+) = OPERACION
         and ppg008cdat(+) = 120
         and rownum = 1;
    end;
    Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='0';
        when too_many_rows then
           select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;

     Begin
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='00';
      when too_many_rows then
         select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='00';
      when too_many_rows then
         select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
        A_Fabrica :='00';
      when too_many_rows then
        select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70
         and rownum = 1;
    end;
    Begin
      select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76;
    exception
       when no_data_found then
          A_Constru :='00';
       when too_many_rows then
          select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76
         and rownum = 1;
    end;
     Begin
      select ppg006dato
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;
    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
         select ppg006dato
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;
    end;

    if dirdomi is null or dirdomi =' ' then
      dirdomi:= direcc;
    end if;

    If ubidomi  is null or ubidomi = ' ' then
      ubidomi := trim(ubigeo);
    end if;

    v_char22 := substr(v_char2,1,10);

    correlativo := correlativo + 1 ;
    certificado := lpad(a.aocta,10,'0')||lpad(a.aooper,10,'0');
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        --aqpa555dcneg,---act
                        aqpa555dgneg,--giro
                        aqpa555ddir, --dir
                        aqpa555dubige,--ubigeo
                        aqpa555dtinm, --tipo inmueble
                        aqpa555dnum ,--numero
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsase,
                        aqpa555dsacon   )
                 values(a.pgcod,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fechapro,
                        'A',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        a.Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
   begin
      insert into aqpa555h(aqpa555hcod,
                        aqpa555hmod,
                        aqpa555hsuc,
                        aqpa555hmda,
                        aqpa555hpap,
                        aqpa555hcta,
                        aqpa555hope,
                        aqpa555hsbo,
                        aqpa555htip,
                        aqpa555hfec,
                        aqpa555hmov,
                        aqpa555hcanal,
                        aqpa555hcpro,
                        aqpa555hcorr,
                        aqpa555hapat,
                        aqpa555hamat,
                        aqpa555hnom,
                        aqpa555hrsoc,
                        aqpa555hndo,
                        aqpa555htdo,
                        aqpa555hmail,
                        aqpa555heciv,
                        aqpa555hsexo,
                        aqpa555hfnac,
                        aqpa555hcel ,
                        aqpa555hocup,
                        aqpa555hubig,
                        aqpa555hdire,
                        aqpa555hncert,
                        aqpa555hnsol,
                        aqpa555hcage,
                        aqpa555hades,
                        aqpa555hfunc,
                        aqpa555hplan,
                        aqpa555hcost,
                        aqpa555hprim,
                        aqpa555htasa,
                        aqpa555hstas,
                        aqpa555htcta,
                        aqpa555hncred,
                        aqpa555hntar,
                        aqpa555hfinpa,
                        aqpa555hfafil,
                        aqpa555hfdes,
                        aqpa555hhdes,
                        aqpa555hfven,
                        aqpa555hfcan,
                        aqpa555hcimp ,
                        aqpa555hmone,
                        aqpa555hctmov,
                        aqpa555hcant ,
                        aqpa555hhlegal,
                        --aqpa555hdcneg,---act
                        aqpa555hdgneg,--giro
                        aqpa555hddir, --dir
                        aqpa555hdubige,--ubigeo
                        aqpa555hdtinm, --tipo inmueble
                        aqpa555hdnum ,--numero
                        aqpa555hpai,
                        aqpa555hcseg,
                        aqpa555ha3,
                        aqpa555hdnpiso,
                        aqpa555hdnsota,
                        aqpa555hdfabri,
                        aqpa555hdcont,
                        aqpa555hdmate,
                        aqpa555hdtedi,
                        aqpa555hdcneg,
                        aqpa555hdsase,
                        aqpa555hdsacon   )
                 values(a.pgcod,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fechapro,
                        'A',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        a.Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
 end loop;
 select max(aqpa555corr)
   into correlativo
   from aqpa555;

 For b in bajas loop
       apepat := NULL;
       apemat := NULL;
       nombres := NULL;
       sexo:= NULL;
       ecivil:= NULL;
       fechanac:= NULL;
       tipodoc:= NULL;
       numdoc:= NULL;
       direcc := NULL;
       razons := null;
       telefono := null;
       mail:= null;
       ubigeo := null;
       giro := null;
       ocupacion := null;
       sucursal := null;
       funcionario :=null;
       INSTANCIA :=0;
       certificado := null;
    Begin
       select  trim(d.pfape1),
               trim(d.pfape2),
               trim(d.pfnom1)||' '||trim(d.pfnom2),
               d.pfcant,
               Decode(d.pfeciv,1, 'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
              to_char(d.pffnac,'yyyymmdd'),
              d.pfpais,
              d.pftdoc,
              Decode(d.pftdoc,21,'001','000'),
              d.pfndoc,
        (select substr(trim(sngc13dir),1,50)
           from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' ),
        (select trim(sngc13ugeo)
           from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' )

        into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
         from fsd002 d
         inner join fsr008 e
                 on e.pepais = d.pfpais
                and e.petdoc = d.pftdoc
                and e.pendoc = d.pfndoc
              where e.ctnro = b.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
    exception
      when no_data_found then
        Begin
           select trim(d.pjrazs),
                  d.pjpais,
                  d.pjtdoc,
                  decode(d.pjtdoc,9,'002','001'),
                  d.pjndoc,
                  (select substr(trim(sngc13dir),1,50)
                     from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )
             into razons,pais,tipodoc,tipodocA, numdoc, direcc
             from fsd003 d
             inner join fsr008 e
                     on e.pepais = d.pjpais
                    and e.petdoc = d.pjtdoc
                    and e.pendoc = d.pjndoc
            where e.ctnro = b.aocta
              and e.ttcod = 1
              and e.cttfir ='T';
        exception
          when no_data_found then
            null;
          when others then
            null;
        end;
    end;
    -- telefono y correo smarquez 17102019
    lc_telefono := null;
    lc_correo := null;

    For t in celular(pais,tipodoc,numdoc)loop
       if ln_cont = 0 then
          tele := trim(t.fono);
        else
          tele := substr((trim(tele)||' '||trim(t.fono)),1,50);
        end if;
       ln_cont := ln_cont + 1;
    end loop;
    lc_telefono := substr(tele,1,50);
     For c in correo(pais,tipodoc,numdoc)loop
        if ln_cont1 = 0 then
          mail := trim(c.mail);
        else
          mail := trim(mail)||' '||trim(c.mail);
        end if;

       ln_cont1 := ln_cont1 + 1;
    end loop;
     lc_correo := substr(mail,1,50);
     ---- adicion
    if lc_correo is null then
       lc_correo := 'sindato@gmail.com';
    end if;
    begin
      select
           (SELECT NVL(substr(trim(A1.AQPA558ACT),1,50),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) ),

            (SELECT  NVL(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) )
        into ocupacion,
             giro,
             codigo_giro
        from SNGC60
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = (select max(sngc60corr)
                             from SNGC60
                            where sngc60pais = pais
                              and sngc60tdoc = tipodoc
                              and sngc60ndoc = numdoc );
    exception
      when no_data_found then
        begin
           select
              (SELECT substr(trim(A1.AQPA558ACT),1,50) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) ),
                --  (select actnom1 from  fst750 where actcod1 = sngc60acte) ,
                --  sngc60acte,
                  (SELECT substr(Trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) ),
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) )
                into ocupacion,
                     giro,
                     codigo_giro
                from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc);

        exception
          when no_data_found then
            giro:= null;
            ocupacion:= null;
        end;

    end;

    bEGIN
      sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog
        INTO INSTANCIA, operacion, saldoasegurado
        FROM XWF700 n inner join sng122 m
                      on m.sng122inst = n.xwfprcins
         WHERE xwfempresa = 1
           and xwfmodulo = b.aomod
           and xwfmoneda = b.aomda
           and xwfpapel = b.aopap
           AND xwfcuenta = b.AOCTA
           AND xwfoperacion = b.AOOPER
           and xwftipope = b.aotope
           AND xwfcar3 ='1';
    EXCEPTION
      WHEN OTHERS then
         NULL;
    END;

    funcionario := FN_ANALISTA_CREDITO(b.AOMOD, b.AOSUC, b.AOMDA, b.AOPAP, b.AOCTA, b.AOOPER, b.AOSBOP, b.AOTOPE);

    Begin
      select substr(trim(t_dava.sngc13dir),1,50), -- direccion
             t_dava.sngc13ugeo,
       --t_dist.fst071dsc Distrito_1, --distrito
       --t_prov.locnom Provincia_1,-- huancayo
       --t_dept.depnom Dpto_1, ---junin
       -- case when sng122corr = 1 then t_ciiu.actcod1 else null end CIIU,
       case when w.sng122corr = 1 then t_ciiu.actnom1 else null end Actividad, -- Giro
       case when w.sng122corr = 1 then t_grup.actnom3 else null end Grupo_Activ/* ,--- OCUPACION
         t_nume.ppg003dato Nro_Piso,
       t_nume1.ppg003dato Nro_Sótano,
       t_nume2.ppg003dato A_Fabrica,
       t_nume3.ppg003dato A_Constru,
       t_adic1.ppg008desc Uso,
       t_adic2.ppg008desc Tipo_Const */
      INTO DIRECCION_neg, ubigeo_neg,--- DISTRITO, PROVINCIA, DEPARTAMENTO,
           GIRO, OCUPACION--, NROPISO, NROSOTANO, AFABRICA, ACONSTRU, USO, TIPOCONST
      from
          fst071 t_dist,
          fst070 t_prov,
          fst068 t_dept,
          fsr008 t_aval,
          sngc13 t_dava,
          fsd008 t_ctte,
          fst750 t_ciiu,
          fst752 t_grup,
          sng122 w,
        /*  ppg003 t_nume,
          ppg003 t_nume1,
          ppg003 t_nume2,
          ppg003 t_nume3,*/
          ppg008 t_adic1,
          ppg008 t_adic2,
          ppg008 t_adic

    where  W.SNG122CTA = b.aocta --CUENTA
          and w.sng122oper = b.aooper --OPERACION
          AND W.SNG122INST = INSTANCIA
          and t_aval.ctnro(+) = W.SNG122CTA
          and t_aval.ttcod(+) = 1
          and t_aval.cttfir(+) = 'T'
          and t_dava.sngc13pais(+) = t_aval.pepais
          and t_dava.sngc13tdoc(+) = t_aval.petdoc
          and t_dava.sngc13ndoc(+) = t_aval.pendoc
          and t_dava.docod(+) = 1
          and t_dava.sngc13est(+) = 'H'
          and t_dava.sngc13corr(+) = 1
          and t_dept.pais(+) = 604
          and t_dept.depcod(+) = t_dava.sngc13dpto
          and t_prov.pais(+) = 604
          and t_prov.depcod(+) = t_dava.sngc13dpto
          and t_prov.loccod(+) = t_dava.sngc13prov
          and t_dist.fst071pai(+) = 604
          and t_dist.fst071dpt(+) = t_dava.sngc13dpto
          and t_dist.fst071loc(+) = t_dava.sngc13prov
          and t_dist.fst071col(+) = t_dava.sngc13dist

          and t_ctte.pgcod(+)= 1
          and t_ctte.ctnro(+) =  W.SNG122CTA
          and t_ciiu.actcod1(+) = t_ctte.ctnroi
          and t_grup.actcod3(+) = t_ciiu.actcod3

           and t_adic.ppg008pgc(+) = w.sng122pgc
          and t_adic.ppg008mod(+) = w.sng122mod
          and t_adic.ppg008suc(+) = w.sng122suc
          and t_adic.ppg008mda(+) = w.sng122mda
          and t_adic.ppg008pap(+) = w.sng122pap
          and t_adic.ppg008cta(+) = w.sng122cta
          and t_adic.ppg008ope(+) = w.sng122oper
          and t_adic.ppg008sbo(+) = w.sng122sbop
          and t_adic.ppg008top(+) = w.sng122tope
          and t_adic.ppg008corr(+) = w.sng122corr
    --      and t_adic.ppg008frm(+) = t_cgar.ppg000frm
          and t_adic.ppg008cdat(+) = 58

          and t_adic1.ppg008pgc(+) = w.sng122pgc
          and t_adic1.ppg008mod(+) = w.sng122mod
          and t_adic1.ppg008suc(+) = w.sng122suc
          and t_adic1.ppg008mda(+) = w.sng122mda
          and t_adic1.ppg008pap(+) = w.sng122pap
          and t_adic1.ppg008cta(+) = w.sng122cta
          and t_adic1.ppg008ope(+) = w.sng122oper
          and t_adic1.ppg008sbo(+) = w.sng122sbop
          and t_adic1.ppg008top(+) = w.sng122tope
          and t_adic1.ppg008corr(+) = w.sng122corr
       --   and t_adic1.ppg008frm(+) = t_cgar.ppg000frm
          and t_adic1.ppg008cdat(+) = 120

          and t_adic2.ppg008pgc(+) = w.sng122pgc
          and t_adic2.ppg008mod(+) = w.sng122mod
          and t_adic2.ppg008suc(+) = w.sng122suc
          and t_adic2.ppg008mda(+) = w.sng122mda
          and t_adic2.ppg008pap(+) = w.sng122pap
          and t_adic2.ppg008cta(+) = w.sng122cta
          and t_adic2.ppg008ope(+) = w.sng122oper
          and t_adic2.ppg008sbo(+) = w.sng122sbop
          and t_adic2.ppg008top(+) = w.sng122tope
          and t_adic2.ppg008corr(+) = w.sng122corr
        --  and t_adic2.ppg008frm(+) = t_cgar.ppg000frm
          and t_adic2.ppg008cdat(+) = 105;

    exception
      when no_data_found then
        DIRECCION_neg := direcc;
    end;
    select TRIM(TP1DESC)
      into CTASA
     from fst198 where tp1cod = 1 and tp1cod1 = 11138
    and tp1corr1 = 9
    and tp1corr2 = 1
    and tp1corr3 = 1;-- '0.028
    tasa := to_number(trim(CTASA),'9.999');
    prima :=(b.aoimp * tasa)/100;
    if prima < 8.1 then
      prima := 8.1;
    end if;

    select count(*)
      into nrocuota
      from fsd611
     where pgcod = b.pgcod
       and ppmod = b.aomod
       and ppsuc = b.aosuc
       and ppmda = b.aomda
       and pppap = b.aopap
       and ppcta = b.aocta
       and ppoper = b.aooper
       and ppsbop = b.aosbop
       and pptope = b.aotope;

    if nrocuota  is null or nrocuota = 0 then
      nrocuota := 1;
    end if;

    costo :=  prima * nrocuota;

    Begin
    if tipodoc = 9 then
      doctipo := '002';
    else
      doctipo :='001';
    end if;
    Begin
      select decode( trim(ppg008desc),'VIVIENDA','1','OFICINA','1','TALLER','1', 'NAVE INDUSTRIAL O GRANDES ALMA','4','CENTRO DE SALUD','4','CENTRO EDUCATIVO','4','5')
        INTO USO
        from ppg008
       where ppg008pgc(+) = 1
         and ppg008mod(+) = 70
         and ppg008cta(+) = b.aocta
         and ppg008ope(+) = OPERACION
         and ppg008cdat(+) = 120;
    exception
        when no_Data_found then
          USO := '0';
        when too_many_rows then
         select decode( trim(ppg008desc),'VIVIENDA','1','OFICINA','1','TALLER','1', 'NAVE INDUSTRIAL O GRANDES ALMA','4','CENTRO DE SALUD','4','CENTRO EDUCATIVO','4','5')
        INTO USO
        from ppg008
       where ppg008pgc(+) = 1
         and ppg008mod(+) = 70
         and ppg008cta(+) = b.aocta
         and ppg008ope(+) = OPERACION
         and ppg008cdat(+) = 120
         and rownum = 1;
    end;
    Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = b.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='0';
         when too_many_rows then
            select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = b.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;

    Begin
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='00';
      when too_many_rows then
       select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='00';
      when too_many_rows then
        select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;
    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
         A_Fabrica :='00';
       when too_many_rows then
         select ppg003dato
          into A_Fabrica
          from ppg003
         where ppg003cod(+) = 1
           and ppg003mod(+) = 70
           and ppg003cta(+) = b.aocta
           and ppg003ope(+) =OPERACION
           and ppg003cdat(+) = 70
           and rownum = 1;
    end;
    Begin
      select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76;
    exception
    when no_data_found then
      A_Constru :='00';
       when too_many_rows then
         select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = b.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76
         and rownum = 1;
    end;

    Begin
      select ppg006dato
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = b.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;

    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
        select ppg006dato
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = b.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;

    end;
    if direccion_neg is null or direccion_neg =' ' then
      direccion_neg:= direcc;
    end if;

    If ubigeo_neg  is null or ubigeo_neg = ' ' then
      ubigeo_neg := trim(ubigeo);
    end if;

    correlativo := correlativo + 1 ;
    certificado := lpad(b.aocta,10,'0')||lpad(b.aooper,10,'0');
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        aqpa555dgneg,
                        aqpa555ddir,
                        aqpa555dubige,
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsacon,
                        aqpa555dsase
                        )
                 values(b.pgcod,
                        b.aomod,
                        b.aosuc,
                        b.aomda,
                        b.aopap,
                        b.aocta,
                        b.aooper,
                        b.aosbop,
                        b.aotope,
                        p_fechapro,
                        'B',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        b.aosuc,
                        b.sucursal,
                        funcionario,
                        1,---'Plan',
                        1,--'Costo', sacar de la 611
                        prima,---'Prima', sacar de la 611
                        b.Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        b.nrocredito,
                        null, --numero tarjeta
                        b.fechavto, --ult pago
                        b.fechadesem, --f afiliacion
                        b.fechadesem,
                        'hora',
                        b.fechavto,
                        b.fechacance,-- null, --f cancelacion
                        b.monto,
                        b.moneda_cuenta,
                        'N',
                        null,
                        'N',
                        Giro, ---   ocupacion,
                        direccion_neg,
                        ubigeo_neg,
                        pais,
                        b.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        tipoconstruccion,
                        uso,
                        codigo_giro,
                        saldoasegurado,
                        b.monto
                       );
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
   BEGIN
     insert into AQPA555H(AQPA555Hcod,
                        AQPA555Hmod,
                        AQPA555Hsuc,
                        AQPA555Hmda,
                        AQPA555Hpap,
                        AQPA555Hcta,
                        AQPA555Hope,
                        AQPA555Hsbo,
                        AQPA555Htip,
                        AQPA555Hfec,
                        AQPA555Hmov,
                        AQPA555Hcanal,
                        AQPA555Hcpro,
                        AQPA555Hcorr,
                        AQPA555Hapat,
                        AQPA555Hamat,
                        AQPA555Hnom,
                        AQPA555Hrsoc,
                        AQPA555Hndo,
                        AQPA555Htdo,
                        AQPA555Hmail,
                        AQPA555Heciv,
                        AQPA555Hsexo,
                        AQPA555Hfnac,
                        AQPA555Hcel ,
                        AQPA555Hocup,
                        AQPA555Hubig,
                        AQPA555Hdire,
                        AQPA555Hncert,
                        AQPA555Hnsol,
                        AQPA555Hcage,
                        AQPA555Hades,
                        AQPA555Hfunc,
                        AQPA555Hplan,
                        AQPA555Hcost,
                        AQPA555Hprim,
                        AQPA555Htasa,
                        AQPA555Hstas,
                        AQPA555Htcta,
                        AQPA555Hncred,
                        AQPA555Hntar,
                        AQPA555Hfinpa,
                        AQPA555Hfafil,
                        AQPA555Hfdes,
                        AQPA555Hhdes,
                        AQPA555Hfven,
                        AQPA555Hfcan,
                        AQPA555Hcimp ,
                        AQPA555Hmone,
                        AQPA555Hctmov,
                        AQPA555Hcant ,
                        AQPA555Hhlegal,
                        AQPA555Hdgneg,
                        AQPA555Hddir,
                        AQPA555Hdubige,
                        AQPA555Hpai,
                        AQPA555Hcseg,
                        AQPA555Ha3,
                        AQPA555Hdnpiso,
                        AQPA555Hdnsota,
                        AQPA555Hdfabri,
                        AQPA555Hdcont,
                        AQPA555Hdmate,
                        AQPA555Hdtedi,
                        AQPA555Hdcneg,
                        AQPA555Hdsacon,
                        AQPA555Hdsase
                        )
                 values(b.pgcod,
                        b.aomod,
                        b.aosuc,
                        b.aomda,
                        b.aopap,
                        b.aocta,
                        b.aooper,
                        b.aosbop,
                        b.aotope,
                        p_fechapro,
                        'B',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        b.aosuc,
                        b.sucursal,
                        funcionario,
                        1,---'Plan',
                        1,--'Costo', sacar de la 611
                        prima,---'Prima', sacar de la 611
                        b.Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        b.nrocredito,
                        null, --numero tarjeta
                        b.fechavto, --ult pago
                        b.fechadesem, --f afiliacion
                        b.fechadesem,
                        'hora',
                        b.fechavto,
                        b.fechacance,-- null, --f cancelacion
                        b.monto,
                        b.moneda_cuenta,
                        'N',
                        null,
                        'N',
                        Giro, ---   ocupacion,
                        direccion_neg,
                        ubigeo_neg,
                        pais,
                        b.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        tipoconstruccion,
                        uso,
                        codigo_giro,
                        saldoasegurado,
                        b.monto
                       );
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

 end loop;

end SP_AFILIACION;
PROCEDURE SP_SEGUROMULTI(ln_pgcod     in number,
                          ln_modulo    in number,
                          ln_sucursal  in number,
                          ln_moneda    in number,
                          ln_papel     in number,
                          ln_cuenta    in number,
                          ln_operacion in number,
                          ln_suboper   in number,
                          ln_tope      in number,
                          ln_codseg    in number,
                          ln_costo    out number,
                          ln_prima    out number)is



    cursor segurosxcuenta is
        select *
          from fpp001 a
          where a.pgcod  = ln_pgcod
            and a.aomod  = ln_modulo
            and a.aosuc  = ln_sucursal
            and a.aomda  = ln_moneda
            and a.aopap  = ln_papel
            and a.aocta  = ln_cuenta
            and a.aooper = ln_operacion
            and a.aosbop = ln_suboper
            and a.aotope = ln_tope;
    --Seguro - guia especial de proceso -- El seguro esta definido por el parametro recibido.
    cursor moduloxseguro(seguro number) is
    select tp1nro1
      from fst198
     where tp1cod = 1
       and tp1cod1 = 10875
       and tp1corr1 = 9
       and tp1corr2 = 1
       and tp1nro1 = seguro
       and tp1corr3 > 0;

    temp number;
    temp2 number;
    monto1 number := 0;
    monto2 number := 0;
    monto3 number := 0;
    monto4 number := 0;
    monto5 number := 0;
    lc_ctdseg number:=0;
    nrocuotas number:=0;
    lc_monto number(17,2):=0;
    posicion number:=0;
    begin
       --Aqui encuentro la cantidad de seguros.
       begin
          select
                 count (*)
          into
                 lc_ctdseg
          from fpp001 a
          where a.pgcod  = ln_pgcod
            and a.aomod  = ln_modulo
            and a.aosuc  = ln_sucursal
            and a.aomda  = ln_moneda
            and a.aopap  = ln_papel
            and a.aocta  = ln_cuenta
            and a.aooper = ln_operacion
            and a.aosbop = ln_suboper
            and a.aotope = ln_tope;
       end;
       -- Aqui encuentro posición del Seguro.
       begin
           temp := 0;
           temp2:= 0;
           lc_monto:=0;
           if lc_ctdseg>0 then
               for job in segurosxcuenta loop
                     temp := temp + 1;
                     for job2 in moduloxseguro(ln_codseg) loop
                         if job.sgcod = job2.tp1nro1 then
                            lc_monto := job.pp001imp;
                            temp2 := temp;
                            exit;
                         end if;
                     end loop;
               end loop;
           else
                temp2 := 1;
           end if;
           posicion := temp2;
           if lc_monto = 0 then --20190104 sma
              select count(*)
                   into nrocuotas
                   from fsd611
                  where pgcod = ln_pgcod
                    and ppmod = ln_modulo
                    and ppsuc = ln_sucursal
                    and ppmda = ln_moneda
                    and pppap = ln_papel
                    and ppcta = ln_cuenta
                    and ppoper = ln_operacion
                    and ppsbop = ln_suboper
                    and pptope = ln_tope;
             Begin
                 select ppimp11, ppimp12, ppimp13,ppimp14, ppimp15
                   into monto1, monto2, monto3, monto4, monto5
                   from fsd611
                  where pgcod = ln_pgcod
                    and ppmod = ln_modulo
                    and ppsuc = ln_sucursal
                    and ppmda = ln_moneda
                    and pppap = ln_papel
                    and ppcta = ln_cuenta
                    and ppoper = ln_operacion
                    and ppsbop = ln_suboper
                    and pptope = ln_tope
                    and ppfpag = ( select min(ppfpag) from fsd611 f6
                                    where pgcod = ln_pgcod
                                      and ppmod = ln_modulo
                                      and ppsuc = ln_sucursal
                                      and ppmda = ln_moneda
                                      and pppap = ln_papel
                                      and ppcta = ln_cuenta
                                      and ppoper = ln_operacion
                                      and ppsbop = ln_suboper
                                      and pptope = ln_tope);
              if posicion = 1 then
                ln_prima := monto1;
                ln_costo := monto1 * nrocuotas;
              end if;
              if posicion = 2 then
                ln_prima := monto2;
                ln_costo := monto2 * nrocuotas;
              end if;
              if posicion = 3 then
                ln_prima := monto3;
                ln_costo := monto3 * nrocuotas;
              end if;
              if posicion = 4 then
                ln_prima := monto4;
                ln_costo := monto4 * nrocuotas;
              end if;
              if posicion = 5 then
                ln_prima := monto5;
                ln_costo := monto5 * nrocuotas;
              end if;
             exception
               when no_data_found then
                 ln_prima := 0;
             End;
           end if;
       end;
end SP_SEGUROMULTI;
PROCEDURE SP_COBRO(p_fechapro in date)is
cursor cobro is
  select f6.*
    from fsd015 f5,
         fsd016 f6,
         FPP001 F1
   where f5.pgcod = f6.pgcod
     and f5.itsuc = f6.itsuc
     and f5.itmod = f6.itmod
     and f5.ittran = f6.ittran
     and f5.itnrel = f6.itnrel
     and f5.itcorr = 0
     and f5.itcont = 'S'
     and f6.rubro = 2514020000007
     and f6.itmod <> 99
     and f6.ittran <> 993
     AND F1.PGCOD = 1
     AND F1.AOCTA = F6.CTNRO
     AND F1.AOOPER = F6.ITOPER
     AND F1.SGCOD IN (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9);

cursor Pagos (cta in number, oper in number,modu in number,tran in number, rel in number, suc in number) is
  select *
    from fsd602
   where pgcod = 1
     and ppcta = cta
     and ppoper = oper
     and d602cd = 1
     and d602mo = modu
     and d602su = suc
     and d602tr = tran
     and d602re = rel
     and d602fc = p_fechapro
     and d602co ='S';
ln_correl   number:= 0;
lc_numcert  varchar2(20);
ln_numerocuota number:= 0;
ln_pais number;
ln_tdoc number;
lc_numdoc char(12);
lc_numcre VARCHAR2(30);
Begin
   Execute immediate ('truncate table aqpa557');
  For c in cobro loop
    ln_correl := ln_correl +1 ;
     BEgin
        Select pepais, petdoc, pendoc
         into ln_pais, ln_tdoc, lc_numdoc
         from fsr008
        where pgcod = 1
          and ctnro = c.ctnro
          and ttcod = 1
          and cttfir = 'T';
      exception
        when no_data_found then
          ln_pais := 0;
          ln_tdoc := 0;
          lc_numdoc:= null;
      end;
    lc_numcert := null;
    For p in pagos (c.ctnro,c.itoper,c.itmod,c.ittran,c.itnrel,c.itsuc)loop
      lc_numcert :=  lpad(p.ppcta,10,'0') || lpad(p.ppoper,10,'0');
      lc_numcre := to_char(LPAD(P.PPCTA,  9, '0') ||
                           LPAD(P.PPOPER, 9, '0') ||
                           LPAD(P.PPSBOP, 3, '0'));
      Begin
       select count(*)
         into ln_numerocuota
         from fsd601
        where pgcod  = p.pgcod
          and ppmod = p.ppmod
          and ppsuc = p.ppsuc
          and ppmda = p.ppmda
          and pppap = p.pppap
          and ppcta = p.ppcta
          and ppoper = p.ppoper
          and ppsbop = p.ppsbop
          and pptope = p.pptope
          and ppfpag = p.ppfpag;
      exception
        when no_data_found then
          ln_numerocuota := 0;
      end;



      begin
      insert into aqpa557(aqpa557cod,
                          aqpa557mod,
                          aqpa557suc,
                          aqpa557mda,
                          aqpa557pap,
                          aqpa557cta,
                          aqpa557ope,
                          aqpa557sbo,
                          aqpa557tip,
                          aqpa557fep,
                          aqpa557canal,
                          aqpa557cprod,
                          aqpa557corr ,
                          aqpa557cert,
                          aqpa557ncuo,
                          aqpa557ndoc,
                          aqpa557tdoc,
                          aqpa557tcta,
                          aqpa557ncre,
                          aqpa557prim,
                          aqpa557fech,
                          aqpa557pais,
                          aqpa557a3 )
                   values(p.pgcod,
                          p.ppmod,
                          p.ppsuc,
                          p.ppmda,
                          p.pppap,
                          p.ppcta,
                          p.ppoper,
                          p.ppsbop,
                          p.pptope,
                          p_fechapro,
                          13,
                          48,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          c.itimp1,
                          p_fechapro,
                          ln_pais,
                          'N');
        commit;
      exception
        when dup_val_on_index then
          null;
      end;
      --- adicion SMA 20231226
      begin
      insert into aqpa557H(aqpa557Hcod,
                          aqpa557Hmod,
                          aqpa557Hsuc,
                          aqpa557Hmda,
                          aqpa557Hpap,
                          aqpa557Hcta,
                          aqpa557Hope,
                          aqpa557Hsbo,
                          aqpa557Htip,
                          aqpa557Hfep,
                          aqpa557Hcanal,
                          aqpa557Hcprod,
                          aqpa557Hcorr ,
                          aqpa557Hcert,
                          aqpa557Hncuo,
                          aqpa557Hndoc,
                          aqpa557Htdoc,
                          aqpa557Htcta,
                          aqpa557Hncre,
                          aqpa557Hprim,
                          aqpa557Hfech,
                          aqpa557Hpais,
                          aqpa557Ha3 )
                   values(p.pgcod,
                          p.ppmod,
                          p.ppsuc,
                          p.ppmda,
                          p.pppap,
                          p.ppcta,
                          p.ppoper,
                          p.ppsbop,
                          p.pptope,
                          p_fechapro,
                          13,
                          48,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          c.itimp1,
                          p_fechapro,
                          ln_pais,
                          'N');
        commit;
      exception
        when dup_val_on_index then
          null;
      end;

    end loop;
  end loop;
end SP_COBRO;
PROCEDURE SP_MULTI_TRAMA_ALTAS(P_FECHA IN DATE) IS
   CURSOR CUENTAS (fecha_uno date, fecha_dos date) IS

      select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                b.aoimp monto,
                b.aoperiod periodo
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
             and b.AOFVAL  between Fecha_uno and fecha_dos
--             and b.aocta = 3922359
             order by b.aofval,b.aocta,b.aooper;


    cursor celular (pais number,tdoc number,ndoc char) is
        select trim(dotelfp) fono
          from fsr005
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and docod = 1;

      cursor correo (pais number,tdoc number,ndoc char) is
        select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
          from fsx001
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and txcod = 0 --x_08.txcod = 0
           and pextxt <> 'SI'
           and pextxt Like '%@%';

      CURSOR BAJAS (fecha_uno date, fecha_dos date) IS
      select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                to_char(b.aofe99,'yyyymmdd') fechacan,
                b.aoimp monto,
                b.aoperiod periodo
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
             and b.aofe99  between Fecha_uno and fecha_dos
             and b.aostat = 99
             order by b.aofval;

  lc_telefono   char(50);
  tele varchar2(50);
  lc_correo     char(50);
  apepat char(50);
  apemat char(50);
  nombres char(50);
  sexo char(1);
  ecivil char(1);
  fechanac varchar2(8);
  pais number;
  tipodoc number;
  tipodocA CHAR(3);
  numdoc char(12);
  direcc char(100);-- antes 200
  RAZONS CHAR(150);
  mail char(200);
  telefono char(50);
  ubigeo char(10);
  GIRO char(300);
  OCUPACION char(50);
  sucursal char(30);
  funcionario char(10);
  operacion number(9);
  ln_cont number:= 0;
  ln_cont1 number:=0;

  correlativo number(17):=0;
  certificado char(30);
  doctipo char(3);

  prima number(17,2):=0;
  tasa number(10,6):=0;

  dirdomi char(300);
  ubidomi char(8);
  actdomi char(300);
  ocudomi char(50);
  v_num1 number;
  v_num2 number;
  v_char1 char(200);
  v_char2 char(50);
  v_resul number:= 0;
  tipo_via char(1);
  direccion1 char(300);
  USO char(1);
  tipoconstruccion char(1);
  Nro_Piso char(10);
  Nro_Sotano char(10);
  A_Fabrica char(10);
  A_Constru char(10);
  contenido char(50);
  codigo_giro number:=0;
  saldoasegurado number(17,2):= 0;
  periodo number:=0;
  instancia number;
  fechavto date;
  nrocredito char(30);
  moneda varchar2(3);
  nro_cuotas  number;
  contador number;
  minFecha date;
  imp11 number(17,2);
  imp12 number(17,2);
  imp13 number(17,2);
  imp14 number(17,2);
  fecha1vto char(20);
  fecha1des char(20);
  contador1 number:= 0;
  plazo number;
  fecha1 date;
  fecha2 date;
  v_char22 char(10);
  Equivalencia char(30);
  tipo number;
  descripcion char(40);
  tipoope number;
  nombrecod char(50);
  monedagar char(5);
  BajaSeg   char(1);
  dseg      char(2);
  codigoseguro number(3);
  begin
   fecha1 := TRUNC(p_fecha, 'MM');
   fecha2 := last_day(p_fecha);

   Execute immediate ('truncate table aqpa555');

    For a in cuentas(fecha1,fecha2) loop
      contador1 := contador1 + 1;
         apepat := NULL;
         apemat := NULL;
         nombres := NULL;
         sexo:= NULL;
         ecivil:= NULL;
         fechanac:= NULL;
         tipodoc:= NULL;
         numdoc:= NULL;
         direcc := NULL;
         razons := null;
         telefono := null;
         mail:= null;
         ubigeo := null;
         giro := null;
         ocupacion := null;
         sucursal := null;
         funcionario :=null;
         certificado := null;

      Begin
         select trim(d.pfape1),
                trim(d.pfape2),
                trim(d.pfnom1) || ' ' || trim(d.pfnom2),
                d.pfcant,
                Decode(d.pfeciv,1,'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
                to_char(d.pffnac, 'yyyymmdd'),
                d.pfpais,
                d.pftdoc,
                Decode(d.pftdoc, 21, '001', '000'),
                d.pfndoc,
                (select substr(sngc13dir,1,100)
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc = d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est = 'H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                         from sngc13
                                        where sngc13pais = d.pfpais
                                          and sngc13tdoc = d.pftdoc
                                          and sngc13ndoc = d.pfndoc
                                          and docod = 1
                                          and sngc13est = 'H')
                                          ),
                (select trim(lpad(sngc13ugeo,6,'0'))
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc = d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est = 'H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                         from sngc13
                                        where sngc13pais = d.pfpais
                                          and sngc13tdoc = d.pftdoc
                                          and sngc13ndoc = d.pfndoc
                                          and docod = 1
                                          and sngc13est = 'H')
                    )

           into apepat,
                apemat,
                nombres,
                sexo,
                ecivil,
                fechanac,
                pais,
                tipodoc,
                tipodocA,
                numdoc,
                direcc,
                ubigeo
           from fsd002 d
          inner join fsr008 e
             on e.pepais = d.pfpais
            and e.petdoc = d.pftdoc
            and e.pendoc = d.pfndoc
          where e.ctnro = a.aocta
            and e.ttcod = 1
            and e.cttfir = 'T';

      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select substr(trim(sngc13dir),1,100)
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H') ),
                  (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc = d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est = 'H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H'))
               into razons,pais,tipodoc,tipodocA, numdoc, direcc, ubigeo
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      bEGIN
      sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog, m.sng122tope,decode(m.sng122mda,101,'Dolar','Soles')
        INTO INSTANCIA, operacion, saldoasegurado, tipoope,monedagar
        FROM XWF700 n inner join sng122 m
                      on m.sng122inst = n.xwfprcins
         WHERE xwfempresa = 1
           and xwfmodulo = a.aomod
           and xwfmoneda = a.aomda
           and xwfpapel = a.aopap
           AND xwfcuenta = a.AOCTA
           AND xwfoperacion = a.AOOPER
           and xwftipope = a.aotope
           AND xwfcar3 ='1'
           and rownum = 1;

    EXCEPTION
      when no_data_found then
        operacion := 0;
      WHEN too_many_rows then

          sELECT n.xwfprcins ,n.xwfoperacion, n.xwfmonto1
            INTO INSTANCIA, operacion, saldoasegurado
            FROM XWF700 n
           WHERE xwfempresa = 1
             and xwfmodulo = a.aomod
             and xwfmoneda = a.aomda
             and xwfpapel = a.aopap
             AND xwfcuenta = a.AOCTA
             AND xwfoperacion = a.AOOPER
             and xwftipope = a.aotope
             and xwfsubope  = a.aosbop
             AND xwfcar3 ='1'
             and rownum = 1;

    END;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := substr((trim(tele)||'-'||trim(t.fono)),1,50);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);

   --    dbms_output.put_line( lc_telefono);

       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||'-'||trim(c.mail)),1,50);
          end if;

         ln_cont1 := ln_cont1 + 1;
      end loop;
       lc_correo := substr(mail,1,50);
       if lc_correo is null then
         lc_correo := 'sindato@gmail.com';
       end if;
   --     dbms_output.put_line( lc_correo);
      begin
        select
        (SELECT NVL(substr(trim(A1.AQPA558ACT),1,50),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
            (SELECT NVL(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )
          into ocupacion,
               giro,
               codigo_giro
          from SNGC60
         where sngc60pais = pais
           and sngc60tdoc = tipodoc
           and sngc60ndoc = numdoc
           and rownum = 1;
    ---   dbms_output.put_line( ocupacion||';giro'|| giro||';fingiro'|| codigo_giro);

      exception
        when no_data_found then
          begin
            select --- sngc60acte ,
              (SELECT substr(trim(A1.AQPA558ACT),1,50)
                FROM FST198 F1, AQPA558 A1
               WHERE F1.TP1COD = 1
                 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                 AND A1.AQPA558COD = trunc(F1.TP1IMP1) ) a,
                  (SELECT substr(Trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) ) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
                ---   dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
          exception
            when no_Data_found then
              BEgin
               select --- sngc60acte ,
              (select SNGC07dsc from SNGC07 where  sngc07cod  = sngc60acte ) a,
                  (SELECT substr(Trim(A1.AQPA558act),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) ) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
---dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
            exception
            when too_many_rows then
      --        dbms_output.put_line('duplicado 1 ********************************'||' '||a.aocta||' '||a.aooper);
                    null;
            when no_data_found then
              null;
            end;
          end;
       when too_many_rows then null;
         --dbms_output.put_line('duplicado 2********************************'||' '||a.aocta||' '||a.aooper);
       null;
     end;

     if giro is null then
       giro:= actdomi;

     end if;


      nro_cuotas := 0 ;
      select count(*) into nro_cuotas
        from fsd601
       where pgcod = 1
         and ppmod = a.aomod -- mod1
         and ppsuc = a.aosuc -- suc1
         and ppmda = a.aomda --mda1
         and pppap = 0
         and ppcta = a.aocta
         and ppoper = a.aooper -- operacion
         and ppsbop = a.aosbop ---subop1
         and pptope = a.aotope; --tipo1;

      --    fechades1:= a.aofval;
      --    fechavto1:= a.aofvto;

       funcionario := FN_ANALISTA_CREDITO(a.aomod, a.aosuc, a.aomda, a.aopap, a.aocta, a.aooper, a.aosbop, a.aotope);
       if funcionario is null then
           Begin

              select jaql964usu
                into funcionario
                from jaql964
               where jaql964cta =a.aocta
                 and jaql964ope = a.aooper
                 and jaql964mod = a.aomod
                 and jaql964sob = a.aosbop
                 and jaql964top = a.aotope
                 and rownum = 1;
            exception
              when no_data_found then
                funcionario:= 'S/ANALISTA';
            end;
        end if;
 --- prima     ***********************
    select count(*)
      into contador
      from fpp001
     where pgcod = a.pgcod
       and aomod = a.aomod
       and aosuc = a.aosuc
       and aomda = a.aomda
       and aopap = a.aopap
       and aocta = a.aocta
       and aooper = a.aooper
       and aosbop = a.aosbop
       and aotope = a.aotope;

     Select min(ppfpag)
        into minFecha
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

      Select count(*)
        into plazo
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

    Begin
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
      Select ppimp11,ppimp12, ppimp13,ppimp14
        into imp11,imp12, imp13,imp14
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope
         and ppfpag= minFecha ---a.aofvto
         and rownum = 1;
    exception
      when no_data_found then
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
    end;
    ----- validacion ---------sma07032024
    Begin  ---Vida Caja
      select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap and rownum = 1),'1','VC','3','MV','4','SF','5','DG'),evcap
        into BajaSeg,dseg, codigoseguro
        from fsd012
       where pgcod = 1
         and aomod = a.aomod
         and aosuc = a.aosuc
         and aomda = a.aomda
         and aopap = a.aopap
         and aocta = a.aocta
         and aooper = a.aooper
         and aosbop = a.aosbop
         and aotope = a.aotope
         and evfval between fecha1 and fecha2
         and evtipo = 47
         and evcd02 = 'B'
         and d012co = 'S'
         and evcap in (select TP1NRO1 from fst198 where tp1cod = 1 and tp1cod1 =10875 and  tp1corr1 = 4 and tp1corr2 = 1 AND TP1NRO2 = 1 AND TP1NRO1 BETWEEN 120 AND 128) ---sma 13.01.25
         and evcorr = (select max(evcorr)
                          from fsd012
                         where pgcod = 1
                           and aomod = a.aomod
                           and aosuc = a.aosuc
                           and aomda = a.aomda
                           and aopap = a.aopap
                           and aocta = a.aocta
                           and aooper = a.aooper
                           and aosbop = a.aosbop
                           and aotope = a.aotope
                           and evfval between fecha1 and fecha2
                           and evcap in (select TP1NRO1 from fst198 where tp1cod = 1 and tp1cod1 =10875 and  tp1corr1 = 4 and tp1corr2 = 1 AND TP1NRO2 = 1 AND TP1NRO1 BETWEEN 120 AND 128)--13.01.25
                           and evtipo = 47
                           and evcd02 = 'B'
                           and d012co = 'S')
       ;
    exception
       when no_data_found then
         Begin
           select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = jaqa750seg and rownum = 1),'1','VC','3','MV','4','SF','5','DG'),jaqa750seg
             into BajaSeg,dseg,codigoseguro
             from jaqa750
            where jaqa750emp = a.pgcod
              and jaqa750mod = a.aomod
              and jaqa750suc = a.aosuc
              and jaqa750mda = a.aomda
              and jaqa750pap = a.aopap
              and jaqa750cta = a.aocta
              and jaqa750ope = a.aooper
              and jaqa750sbo = a.aosbop
              and jaqa750top = a.aotope
              and jaqa750seg in (select TP1NRO1 from fst198 where tp1cod = 1 and tp1cod1 =10875 and  tp1corr1 = 4 and tp1corr2 = 1 AND TP1NRO2 = 1 AND TP1NRO1 BETWEEN 120 AND 128)
              and jaqa750fec between fecha1 and fecha2;
         exception
           when no_data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
      when too_many_rows then
         BEgin
            select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap and rownum = 1),'1','VC','3','MV','4','SF','5','DG'),evcap
              into BajaSeg,dseg, codigoseguro
              from fsd012
             where pgcod = 1
               and aomod = a.aomod
               and aosuc = a.aosuc
               and aomda = a.aomda
               and aopap = a.aopap
               and aocta = a.aocta
               and aooper = a.aooper
               and aosbop = a.aosbop
               and aotope = a.aotope
               and evfval  between fecha1 and fecha2
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S'
               and evcap in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875  and tp1corr1 = 4 and tp1nro2 =1 )
               and evcorr =  (select max(evcorr)
                                from fsd012
                               where pgcod = 1
                                 and aomod = a.aomod
                                 and aosuc = a.aosuc
                                 and aomda = a.aomda
                                 and aopap = a.aopap
                                 and aocta = a.aocta
                                 and aooper = a.aooper
                                 and aosbop = a.aosbop
                                 and aotope = a.aotope
                                 and evcap in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875  and tp1corr1 = 4 and tp1nro2 =1 )
                                 and evfval between fecha1 and fecha2
                                 and evtipo = 47
                                 and evcd02 = 'B'
                                 and d012co = 'S')
                  and rownum = 1;
                  
         exception
           when no_Data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
    end;
    if BajaSeg = 'S' and dseg ='VC' then
       contador := contador + 1;
    end if;
    --------------------------
    if contador = 2 then
      prima := imp11;
    elsif contador = 3 then
      prima:= imp12;
    elsif contador = 4 then
      prima := imp13;
    else
      prima:= imp11;
   end if;
   --------------------------

      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;
     begin
      select
        trim(t_dire.ppg001dato), -- direccion
        trim(lpad(t_adic.ppg008cip,6,'0')),-- ubigeo
        (SELECT substr(A1.AQPA558ACT,1,50) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1)aCTIVIDAD, --ocupacion
        (SELECT trim(A1.AQPA558DGIRO) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1 )GIRO --, -- giro
        into dirdomi, ubidomi,  ocudomi,actdomi
        from
        sng122 w,
        ppg008 t_adic,
        fst071 t_dist,
        fst070 t_prov,
        fst068 t_dept,
        ppg001 t_dire,
        fsd008 t_ctte,
        fst750 t_ciiu,
        fst752 t_grup
      where W.SNG122CTA =  a.aocta --CUENTA
        and w.sng122oper = operacion --OPERACION
        AND W.SNG122INST = INSTANCIA
        and t_adic.ppg008pgc(+) = w.sng122pgc
        and t_adic.ppg008mod(+) = w.sng122mod
        and t_adic.ppg008suc(+) = w.sng122suc
        and t_adic.ppg008mda(+) = w.sng122mda
        and t_adic.ppg008pap(+) = w.sng122pap
        and t_adic.ppg008cta(+) = w.sng122cta
        and t_adic.ppg008ope(+) = w.sng122oper
        and t_adic.ppg008sbo(+) = w.sng122sbop
        and t_adic.ppg008top(+) = w.sng122tope
        --and t_adic.ppg008corr(+) = w.sng122corr
        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
        and t_adic.ppg008cdat(+) = 58
        and t_dept.pais(+) = 604
        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1)
        and t_prov.pais(+) = 604
        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1)
        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071pai(+) = 604
        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)
        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071col(+) = t_adic.ppg008cip

        and t_dire.ppg001cod(+) = w.sng122pgc
        and t_dire.ppg001mod(+) = w.sng122mod
        and t_dire.ppg001suc(+) = w.sng122suc
        and t_dire.ppg001mda(+) = w.sng122mda
        and t_dire.ppg001pap(+) = w.sng122pap
        and t_dire.ppg001cta(+) = w.sng122cta
        and t_dire.ppg001ope(+) = w.sng122oper
        and t_dire.ppg001sbo(+) = w.sng122sbop
        and t_dire.ppg001top(+) = w.sng122tope
        --and t_dire.ppg003cor(+) = w.sng122corr
        --and t_dire.ppg003frm(+) = 0---t_cgar.ppg000frm
        and t_dire.ppg001cdat(+) = 41
        and t_ctte.pgcod(+)= 1
        and t_ctte.ctnro(+) =  W.SNG122CTA
        and t_ciiu.actcod1(+) = t_ctte.ctnroi
        and t_grup.actcod3(+) = t_ciiu.actcod3
        ;
    exception
       when no_data_found then
         dirdomi := direcc;
         ubidomi := null;
         actdomi := null;
         ocudomi := null;
       when too_many_rows then
         null;
         ---dupli         dbms_output.put_line(a.aocta||' '||operacion||' '||instancia);
    end;
--dbms_output.put_line(dirdomi);
      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      select trim(substr(v_char1,1,v_num2)) into v_char2 from dual;
      direccion1 := upper(dirdomi);
--dbms_output.put_line( direccion1||';'||v_char2);
      select REGEXP_INSTR( direccion1,'JR|JIRON') into v_resul from dual;
      if v_resul <> 0 then
        tipo_via :='J';
      else
        select REGEXP_INSTR( direccion1,'C|CALLE') into v_resul from dual;
        if v_resul <> 0 then
          tipo_via :='C';
        else
          select REGEXP_INSTR( direccion1,'AV|AVENIDA') into v_resul from dual;
          if v_resul <> 0 THEN
            tipo_via :='A';
          else
            select REGEXP_INSTR( direccion1,'URB|URBANIZACION') into v_resul from dual;
            if v_resul <> 0 THEN
              tipo_via :='A';
            else
              tipo_via := 'O';
            end if;
          end if;
        end if;
      end if;


      USO := '0';
      TIPOCONSTRUCCION :='0';
      Nro_Piso :='0';
      Nro_Sotano :='00';
      A_Fabrica :='00';
      A_Constru :='00';
      contenido := '0';
      ----contenido
  Begin
      select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;
    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
         select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;
    end;
     if dirdomi is null or dirdomi =' ' then
        dirdomi:= direcc;
      end if;

      If ubidomi  is null or ubidomi = ' ' then
        ubidomi := trim(ubigeo);
      end if;
      if a.aomda = 0 then
        moneda := '001';
      else
        moneda := '002';
      end if;
      select max(aqpa555corr)
        into correlativo
        from aqpa555;
      correlativo := correlativo + 1 ;
      certificado := lpad(a.aocta,10,'0')||lpad(a.aooper,10,'0');
      fecha1vto := to_char(a.aofvto,'yyyymmdd');
      fecha1des := to_char(a.aofval,'yyyymmdd');
------- Material 2024.02.15 SMA ---------------------
Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='L';
        when too_many_rows then
           select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;
     Begin ---pisos
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='1';
      when too_many_rows then
         select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
 Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='00';
      when too_many_rows then
         select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) = OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
        A_Fabrica :='0';
      when too_many_rows then
        select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70
         and rownum = 1;
    end;
 -- TIPO EQUIVALENCIA DE LA GARANTIA
     descripcion:= null;
     tipo:= 0;
     Equivalencia := null;
      begin
        select substr(ppg008desc,1,40) , PPG008CIP,
          decode(PPG008CIP,10,'Mobiliario',20,'Maquinaria',30,'Existencias',40,'Inmuebles y Existencias','No Asegurable')
          into descripcion, tipo, Equivalencia
          from  ppg008
          where PPG008Pgc = 1
            and PPG008Mod = 70
            and PPG008CdAt = 59
            and PPG008Cta = a.aocta
            and PPG008Ope = operacion
            and PPG008CIP in (10,20,30,40,50,60,70,80)
            and rownum = 1;
               -- &ppg008cip = PPG008CIP
       exception
        when no_data_found then
           descripcion:= null;

       end;

    begin
      select  ppg018desc
        into nombrecod
        from ppg018
       where ppg018mod = 70
         and ppg018mda  =  a.aomda
         and ppg018top  = tipoope;
    exception
      when no_data_found then
        nombrecod := null;
        tipoope := 0;
    end;
     if a.tasa = 0 then
     tasa := 0.028000;
   else
     tasa := a.tasa;
   end if;
   ------Insertamos a la tabla -----
   Begin

    v_char22 := substr(v_char2,1,10);
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        --aqpa555dcneg,---act
                        aqpa555dgneg,--giro
                        aqpa555ddir, --dir
                        aqpa555dubige,--ubigeo
                        aqpa555dtinm, --tipo inmueble
                        aqpa555dnum ,--numero
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsase,
                        aqpa555dsacon,
                        aqpa555a1, --periodo
                        aqpa555a2, --plazo
                        aqpa555a4,
                        aqpa555a6,
                        aqpa555a7,
                        aqpa555a8   )
                 values(555,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'A',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado,
                        a.periodo,
                        plazo,
                        descripcion,
                        nombrecod,
                        equivalencia,
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

   begin
      insert into aqpa555h(aqpa555hcod,
                        aqpa555hmod,
                        aqpa555hsuc,
                        aqpa555hmda,
                        aqpa555hpap,
                        aqpa555hcta,
                        aqpa555hope,
                        aqpa555hsbo,
                        aqpa555htip,
                        aqpa555hfec,
                        aqpa555hmov,
                        aqpa555hcanal,
                        aqpa555hcpro,
                        aqpa555hcorr,
                        aqpa555hapat,
                        aqpa555hamat,
                        aqpa555hnom,
                        aqpa555hrsoc,
                        aqpa555hndo,
                        aqpa555htdo,
                        aqpa555hmail,
                        aqpa555heciv,
                        aqpa555hsexo,
                        aqpa555hfnac,
                        aqpa555hcel ,
                        aqpa555hocup,
                        aqpa555hubig,
                        aqpa555hdire,
                        aqpa555hncert,
                        aqpa555hnsol,
                        aqpa555hcage,
                        aqpa555hades,
                        aqpa555hfunc,
                        aqpa555hplan,
                        aqpa555hcost,
                        aqpa555hprim,
                        aqpa555htasa,
                        aqpa555hstas,
                        aqpa555htcta,
                        aqpa555hncred,
                        aqpa555hntar,
                        aqpa555hfinpa,
                        aqpa555hfafil,
                        aqpa555hfdes,
                        aqpa555hhdes,
                        aqpa555hfven,
                        aqpa555hfcan,
                        aqpa555hcimp ,
                        aqpa555hmone,
                        aqpa555hctmov,
                        aqpa555hcant ,
                        aqpa555hhlegal,
                        --aqpa555hdcneg,---act
                        aqpa555hdgneg,--giro
                        aqpa555hddir, --dir
                        aqpa555hdubige,--ubigeo
                        aqpa555hdtinm, --tipo inmueble
                        aqpa555hdnum ,--numero
                        aqpa555hpai,
                        aqpa555hcseg,
                        aqpa555ha3,
                        aqpa555hdnpiso,
                        aqpa555hdnsota,
                        aqpa555hdfabri,
                        aqpa555hdcont,
                        aqpa555hdmate,
                        aqpa555hdtedi,
                        aqpa555hdcneg,
                        aqpa555hdsase,
                        aqpa555hdsacon,
                        aqpa555ha1,--periodo
                        aqpa555ha2,--plazo
                        aqpa555ha4,--descripcion
                        aqpa555ha6,--nombrecod
                        aqpa555ha7,--equivalencia
                        aqpa555ha8  ) --moneda garantia
                 values(555,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'A',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado,
                        a.periodo,
                        plazo,
                        descripcion,
                        nombrecod,
                        equivalencia,
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

    end loop;---ALTAS
  -----------------------------BAJAS------------------------------------------------------
  For a in BAJAS(fecha1,fecha2) loop
      contador1 := contador1 + 1;
         apepat := NULL;
         apemat := NULL;
         nombres := NULL;
         sexo:= NULL;
         ecivil:= NULL;
         fechanac:= NULL;
         tipodoc:= NULL;
         numdoc:= NULL;
         direcc := NULL;
         razons := null;
         telefono := null;
         mail:= null;
         ubigeo := null;
         giro := null;
         ocupacion := null;
         sucursal := null;
         funcionario :=null;
         certificado := null;

      Begin
         select trim(d.pfape1),
                trim(d.pfape2),
                trim(d.pfnom1) || ' ' || trim(d.pfnom2),
                d.pfcant,
                Decode(d.pfeciv,1,'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
                to_char(d.pffnac, 'yyyymmdd'),
                d.pfpais,
                d.pftdoc,
                Decode(d.pftdoc, 21, '001', '000'),
                d.pfndoc,
                (select substr(sngc13dir,1,100)
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc = d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est = 'H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                         from sngc13
                                        where sngc13pais = d.pfpais
                                          and sngc13tdoc = d.pftdoc
                                          and sngc13ndoc = d.pfndoc
                                          and docod = 1
                                          and sngc13est = 'H')
                                          ),
                (select trim(lpad(sngc13ugeo,6,'0'))
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc = d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est = 'H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                         from sngc13
                                        where sngc13pais = d.pfpais
                                          and sngc13tdoc = d.pftdoc
                                          and sngc13ndoc = d.pfndoc
                                          and docod = 1
                                          and sngc13est = 'H')
                    )

           into apepat,
                apemat,
                nombres,
                sexo,
                ecivil,
                fechanac,
                pais,
                tipodoc,
                tipodocA,
                numdoc,
                direcc,
                ubigeo
           from fsd002 d
          inner join fsr008 e
             on e.pepais = d.pfpais
            and e.petdoc = d.pftdoc
            and e.pendoc = d.pfndoc
          where e.ctnro = a.aocta
            and e.ttcod = 1
            and e.cttfir = 'T';

      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select substr(trim(sngc13dir),1,100)
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H') ),
                  (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc = d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est = 'H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H'))
               into razons,pais,tipodoc,tipodocA, numdoc, direcc, ubigeo
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      bEGIN
      sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog, m.sng122tope,decode(m.sng122mda,101,'Dolar','Soles')
        INTO INSTANCIA, operacion, saldoasegurado, tipoope,monedagar
        FROM XWF700 n inner join sng122 m
                      on m.sng122inst = n.xwfprcins
         WHERE xwfempresa = 1
           and xwfmodulo = a.aomod
           and xwfmoneda = a.aomda
           and xwfpapel = a.aopap
           AND xwfcuenta = a.AOCTA
           AND xwfoperacion = a.AOOPER
           and xwftipope = a.aotope
           AND xwfcar3 ='1'
           and rownum = 1;

    EXCEPTION
      when no_data_found then
         INSTANCIA:= 0;
         operacion := 0;
         saldoasegurado := 0;
      WHEN OTHERS then
       sELECT n.xwfprcins ,n.xwfoperacion, n.xwfmonto1
         INTO INSTANCIA, operacion, saldoasegurado
         FROM XWF700 n
         WHERE n.xwfempresa = 1
           and n.xwfmodulo = a.aomod
           and n.xwfmoneda = a.aomda
           and n.xwfpapel = a.aopap
           AND n.xwfcuenta = a.AOCTA
           AND n.xwfoperacion = a.AOOPER
           and n.xwftipope = a.aotope
           and n.xwfsubope  = a.aosbop
           AND n.xwfcar3 ='1'
           and rownum = 1;
    END;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := substr((trim(tele)||'-'||trim(t.fono)),1,50);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);

   --    dbms_output.put_line( lc_telefono);

       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||'-'||trim(c.mail)),1,50);
          end if;

         ln_cont1 := ln_cont1 + 1;
      end loop;
       lc_correo := substr(mail,1,50);
       if lc_correo is null then
         lc_correo := 'sindato@gmail.com';
       end if;
   --     dbms_output.put_line( lc_correo);
      begin
        select
        (SELECT NVL(substr(trim(A1.AQPA558ACT),1,50),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
            (SELECT NVL(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )
          into ocupacion,
               giro,
               codigo_giro
          from SNGC60
         where sngc60pais = pais
           and sngc60tdoc = tipodoc
           and sngc60ndoc = numdoc
           and rownum = 1;
    ---   dbms_output.put_line( ocupacion||';giro'|| giro||';fingiro'|| codigo_giro);

      exception
        when no_data_found then
          begin
            select --- sngc60acte ,
              (SELECT substr(trim(A1.AQPA558ACT),1,50)
                FROM FST198 F1, AQPA558 A1
               WHERE F1.TP1COD = 1
                 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                 AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ) a,
                  (SELECT substr(Trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
                ---   dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
          exception
            when no_Data_found then
              BEgin
               select --- sngc60acte ,
              (select SNGC07dsc from SNGC07 where  sngc07cod  = sngc60acte ) a,
                  (SELECT substr(Trim(A1.AQPA558act),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) ) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
---dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
            exception
            when too_many_rows then
      --        dbms_output.put_line('duplicado 1 ********************************'||' '||a.aocta||' '||a.aooper);
                    null;
            when no_data_found then
              null;
            end;
          end;
       when too_many_rows then null;
         --dbms_output.put_line('duplicado 2********************************'||' '||a.aocta||' '||a.aooper);
       null;
     end;

     if giro is null then
       giro:= actdomi;

     end if;


      nro_cuotas := 0 ;
      select count(*) into nro_cuotas
        from fsd601
       where pgcod = 1
         and ppmod = a.aomod -- mod1
         and ppsuc = a.aosuc -- suc1
         and ppmda = a.aomda --mda1
         and pppap = 0
         and ppcta = a.aocta
         and ppoper = a.aooper -- operacion
         and ppsbop = a.aosbop ---subop1
         and pptope = a.aotope; --tipo1;

      --    fechades1:= a.aofval;
      --    fechavto1:= a.aofvto;

       funcionario := FN_ANALISTA_CREDITO(a.aomod, a.aosuc, a.aomda, a.aopap, a.aocta, a.aooper, a.aosbop, a.aotope);
       if funcionario is null then
           Begin

              select jaql964usu
                into funcionario
                from jaql964
               where jaql964cta =a.aocta
                 and jaql964ope = a.aooper
                 and jaql964mod = a.aomod
                 and jaql964sob = a.aosbop
                 and jaql964top = a.aotope
                 and rownum = 1;
            exception
              when no_data_found then
                funcionario:= 'S/ANALISTA';
            end;
        end if;
 --- prima     ***********************
    select count(*)
      into contador
      from fpp001 where  pgcod = a.pgcod
             and aomod = a.aomod
             and aosuc = a.aosuc
             and aomda = a.aomda
             and aopap = a.aopap
             and aocta = a.aocta
             and aooper = a.aooper
             and aosbop = a.aosbop
             and aotope = a.aotope ;

     Select min(ppfpag)
        into minFecha
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

      Select count(*)
        into plazo
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

    Begin
      imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
      Select ppimp11,ppimp12, ppimp13,ppimp14
        into imp11,imp12, imp13,imp14
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope
         and ppfpag= minFecha; ---a.aofvto
      --   and rownum = 1;
    exception
      when no_data_found then
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
    end;
    if contador = 2 then
      prima := imp11;
    elsif contador = 3 then
      prima:= imp12;
    elsif contador = 4 then
      prima := imp13;
    else
      prima:= imp11;
   end if;
   --------------------------

      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;
     begin
      select
        trim(t_dire.ppg001dato), -- direccion
        trim(lpad(t_adic.ppg008cip,6,'0')),-- ubigeo
        (SELECT substr(A1.AQPA558ACT,1,50) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1 )aCTIVIDAD, --ocupacion
        (SELECT trim(A1.AQPA558DGIRO) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1 )GIRO --, -- giro
        into dirdomi, ubidomi,  ocudomi,actdomi
        from
        sng122 w,
        ppg008 t_adic,
        fst071 t_dist,
        fst070 t_prov,
        fst068 t_dept,
        ppg001 t_dire,
        fsd008 t_ctte,
        fst750 t_ciiu,
        fst752 t_grup
      where W.SNG122CTA =  a.aocta --CUENTA
        and w.sng122oper = operacion --OPERACION
        AND W.SNG122INST = INSTANCIA
        and t_adic.ppg008pgc(+) = w.sng122pgc
        and t_adic.ppg008mod(+) = w.sng122mod
        and t_adic.ppg008suc(+) = w.sng122suc
        and t_adic.ppg008mda(+) = w.sng122mda
        and t_adic.ppg008pap(+) = w.sng122pap
        and t_adic.ppg008cta(+) = w.sng122cta
        and t_adic.ppg008ope(+) = w.sng122oper
        and t_adic.ppg008sbo(+) = w.sng122sbop
        and t_adic.ppg008top(+) = w.sng122tope
        --and t_adic.ppg008corr(+) = w.sng122corr
        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
        and t_adic.ppg008cdat(+) = 58
        and t_dept.pais(+) = 604
        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1)
        and t_prov.pais(+) = 604
        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1)
        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071pai(+) = 604
        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)
        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071col(+) = t_adic.ppg008cip

        and t_dire.ppg001cod(+) = w.sng122pgc
        and t_dire.ppg001mod(+) = w.sng122mod
        and t_dire.ppg001suc(+) = w.sng122suc
        and t_dire.ppg001mda(+) = w.sng122mda
        and t_dire.ppg001pap(+) = w.sng122pap
        and t_dire.ppg001cta(+) = w.sng122cta
        and t_dire.ppg001ope(+) = w.sng122oper
        and t_dire.ppg001sbo(+) = w.sng122sbop
        and t_dire.ppg001top(+) = w.sng122tope
        --and t_dire.ppg003cor(+) = w.sng122corr
        --and t_dire.ppg003frm(+) = 0---t_cgar.ppg000frm
        and t_dire.ppg001cdat(+) = 41
        and t_ctte.pgcod(+)= 1
        and t_ctte.ctnro(+) =  W.SNG122CTA
        and t_ciiu.actcod1(+) = t_ctte.ctnroi
        and t_grup.actcod3(+) = t_ciiu.actcod3
        ;
    exception
       when no_data_found then
         dirdomi := direcc;
         ubidomi := null;
         actdomi := null;
         ocudomi := null;
       when too_many_rows then
         null;
         ---dupli         dbms_output.put_line(a.aocta||' '||operacion||' '||instancia);
    end;
--dbms_output.put_line(dirdomi);
      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      select trim(substr(v_char1,1,v_num2)) into v_char2 from dual;
      direccion1 := upper(dirdomi);
--dbms_output.put_line( direccion1||';'||v_char2);
      select REGEXP_INSTR( direccion1,'JR|JIRON') into v_resul from dual;
      if v_resul <> 0 then
        tipo_via :='J';
      else
        select REGEXP_INSTR( direccion1,'C|CALLE') into v_resul from dual;
        if v_resul <> 0 then
          tipo_via :='C';
        else
          select REGEXP_INSTR( direccion1,'AV|AVENIDA') into v_resul from dual;
          if v_resul <> 0 THEN
            tipo_via :='A';
          else
            select REGEXP_INSTR( direccion1,'URB|URBANIZACION') into v_resul from dual;
            if v_resul <> 0 THEN
              tipo_via :='A';
            else
              tipo_via := 'O';
            end if;
          end if;
        end if;
      end if;


      USO := '0';
      TIPOCONSTRUCCION :='0';
      Nro_Piso :='0';
      Nro_Sotano :='00';
      A_Fabrica :='00';
      A_Constru :='00';
      contenido := '0';
      ----contenido
  Begin
      select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;
    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
         select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;
    end;
     if dirdomi is null or dirdomi =' ' then
        dirdomi:= direcc;
      end if;

      If ubidomi  is null or ubidomi = ' ' then
        ubidomi := trim(ubigeo);
      end if;
      if a.aomda = 0 then
        moneda := '001';
      else
        moneda := '002';
      end if;
      select max(aqpa555corr)
        into correlativo
        from aqpa555;
      correlativo := correlativo + 1 ;
      certificado := lpad(a.aocta,10,'0')||lpad(a.aooper,10,'0');
      fecha1vto := to_char(a.aofvto,'yyyymmdd');
      fecha1des := to_char(a.aofval,'yyyymmdd');
------- Material 2024.02.15 SMA ---------------------
Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='L';
        when too_many_rows then
           select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;
     Begin ---pisos
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='1';
      when too_many_rows then
         select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
 Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='00';
      when too_many_rows then
         select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) = OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
        A_Fabrica :='0';
      when too_many_rows then
        select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70
         and rownum = 1;
    end;
 -- TIPO EQUIVALENCIA DE LA GARANTIA
      descripcion:= null;
     tipo:= 0;
     Equivalencia := null;
      begin
        select substr(ppg008desc,1,40) , PPG008CIP,
          decode(PPG008CIP,10,'Mobiliario',20,'Maquinaria',30,'Existencias',40,'Inmuebles y Existencias','No Asegurable')
          into descripcion, tipo, Equivalencia
          from  ppg008
          where PPG008Pgc = 1
            and PPG008Mod = 70
            and PPG008CdAt = 59
            and PPG008Cta = a.aocta
            and PPG008Ope = operacion
            and PPG008CIP in (10,20,30,40,50,60,70,80)
            and rownum = 1;
               -- &ppg008cip = PPG008CIP
       exception
        when no_data_found then
           descripcion:= null;

       end;

    begin
      select  ppg018desc
        into nombrecod
        from ppg018
       where ppg018mod = 70
         and ppg018mda  =  a.aomda
         and ppg018top  = tipoope;
    exception
      when no_data_found then
        nombrecod := null;
        tipoope := 0;
    end;
    if a.tasa = 0 then
       tasa := 0.028000;
     else
       tasa := a.tasa;
     end if;

   Begin

    v_char22 := substr(v_char2,1,10);
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        --aqpa555dcneg,---act
                        aqpa555dgneg,--giro
                        aqpa555ddir, --dir
                        aqpa555dubige,--ubigeo
                        aqpa555dtinm, --tipo inmueble
                        aqpa555dnum ,--numero
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsase,
                        aqpa555dsacon,
                        aqpa555a1,
                        aqpa555a2,
                        aqpa555a4,
                        aqpa555a6,
                        aqpa555a7,
                        aqpa555a8)
                 values(444,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'B',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        a.fechacan, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado,
                        a.periodo,
                        plazo,
                        descripcion,
                        nombrecod,
                        equivalencia,
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

   begin
      insert into aqpa555h(aqpa555hcod,
                        aqpa555hmod,
                        aqpa555hsuc,
                        aqpa555hmda,
                        aqpa555hpap,
                        aqpa555hcta,
                        aqpa555hope,
                        aqpa555hsbo,
                        aqpa555htip,
                        aqpa555hfec,
                        aqpa555hmov,
                        aqpa555hcanal,
                        aqpa555hcpro,
                        aqpa555hcorr,
                        aqpa555hapat,
                        aqpa555hamat,
                        aqpa555hnom,
                        aqpa555hrsoc,
                        aqpa555hndo,
                        aqpa555htdo,
                        aqpa555hmail,
                        aqpa555heciv,
                        aqpa555hsexo,
                        aqpa555hfnac,
                        aqpa555hcel ,
                        aqpa555hocup,
                        aqpa555hubig,
                        aqpa555hdire,
                        aqpa555hncert,
                        aqpa555hnsol,
                        aqpa555hcage,
                        aqpa555hades,
                        aqpa555hfunc,
                        aqpa555hplan,
                        aqpa555hcost,
                        aqpa555hprim,
                        aqpa555htasa,
                        aqpa555hstas,
                        aqpa555htcta,
                        aqpa555hncred,
                        aqpa555hntar,
                        aqpa555hfinpa,
                        aqpa555hfafil,
                        aqpa555hfdes,
                        aqpa555hhdes,
                        aqpa555hfven,
                        aqpa555hfcan,
                        aqpa555hcimp ,
                        aqpa555hmone,
                        aqpa555hctmov,
                        aqpa555hcant ,
                        aqpa555hhlegal,
                        --aqpa555hdcneg,---act
                        aqpa555hdgneg,--giro
                        aqpa555hddir, --dir
                        aqpa555hdubige,--ubigeo
                        aqpa555hdtinm, --tipo inmueble
                        aqpa555hdnum ,--numero
                        aqpa555hpai,
                        aqpa555hcseg,
                        aqpa555ha3,
                        aqpa555hdnpiso,
                        aqpa555hdnsota,
                        aqpa555hdfabri,
                        aqpa555hdcont,
                        aqpa555hdmate,
                        aqpa555hdtedi,
                        aqpa555hdcneg,
                        aqpa555hdsase,
                        aqpa555hdsacon,
                        aqpa555ha1,
                        aqpa555ha2,
                        aqpa555ha4,
                        aqpa555ha6,
                        aqpa555ha7,
                        aqpa555ha8  )
                 values(444,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'B',
                        13,
                        48,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        a.fechacan, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        saldoasegurado,
                        a.periodo,
                        plazo,
                        descripcion,
                        nombrecod,
                        equivalencia,
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

  end loop; -- Bajas
END SP_MULTI_TRAMA_ALTAS;

PROCEDURE SP_MULTI_TRAMA_COBROS(P_FECHA IN DATE) IS
  cursor pago (fecha1 in date, fecha2 in date)is
  select b.*,a.sgcod seguro,c.ppfpag fpago--,c.ppimp11 once,c.ppimp12 doce,c.ppimp13 trece, c.ppimp14 catorce
  from fpp001 a,
       fsd010 b,
       fsd602 c
 where b.pgcod = a.pgcod
   and b.aomod = a.aomod
   and b.aosuc = a.aosuc
   and b.aomda = a.aomda
   and b.aopap = a.aopap
   and b.aocta = a.aocta
   and b.aooper = a.aooper
   and b.aosbop = a.aosbop
   and b.aotope = a.aotope
   and b.AOFVAL > '01/07/2023'
--   and b.aostat <> 99
   and a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
--   and a.aocta = 31742
--   and a.aooper = 16063414
   and c.pgcod = b.pgcod
   and c.PPSUC = b.aosuc
   and c.PPMDA = b.aomda
   and c.PPPAP = b.aopap
   and c.PPCTA = b.aocta
   and c.PPOPER = b.aooper
   and c.PPSBOP = b.aosbop
   and c.PPTOPE = b.aotope
   and c.ppfpag  between fecha1 and fecha2;
--   and c.ppimp11 <> 0;
 /* select b.*,a.sgcod seguro,c.ppfpag fpago,c.ppimp11 once,c.ppimp12 doce,c.ppimp13 trece, c.ppimp14 catorce
  from fpp001 a,
       fsd010 b,
       fsd611 c
 where b.pgcod = a.pgcod
   and b.aomod = a.aomod
   and b.aosuc = a.aosuc
   and b.aomda = a.aomda
   and b.aopap = a.aopap
   and b.aocta = a.aocta
   and b.aooper = a.aooper
   and b.aosbop = a.aosbop
   and b.aotope = a.aotope
   and a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
   and b.AOFVAL > '01/07/2023'
   and b.aostat <> 99
   and c.pgcod = b.pgcod
   and c.PPSUC = b.aosuc
   and c.PPMDA = b.aomda
   and c.PPPAP = b.aopap
   and c.PPCTA = b.aocta
   and c.PPOPER = b.aooper
   and c.PPSBOP = b.aosbop
   and c.PPTOPE = b.aotope
   and c.ppfpag  between fecha1 and fecha2
   and c.ppimp11 <> 0;*/

cursor cuota2 (fechaini in date, fechafin in date, cta in number, oper in number, sub in number) is
 select m.*
    from fsd602 m --, fsd612 n
   where m.pgcod = 1
     and m.ppcta = cta
     and m.ppoper = oper
     and m.ppsbop = sub
     and m.ppfpag between fechaini and fechafin
     and pp1stat  ='T'
     and m.d602cd = 1
     and m.d602co ='S';

ln_correl   number:= 0;
lc_numcert  varchar2(20);
ln_numerocuota number:= 0;
ln_pais number;
ln_tdoc number;
lc_numdoc char(12);
lc_numcre VARCHAR2(30);
fecha1 date;
contador number;
prima number(17,2);
imp11 number(17,2);
imp12 number(17,2);
imp13 number(17,2);
imp14 number(17,2);
imp15 number(17,2);
--suboper number;
once number(17,2);
doce number(17,2);
trece number(17,2);
catorce number(17,2);
quince number(17,2);
fechaUno date;
fechaDos date;
verifica number;

BajaSeg char(1);
dseg char(2);
codigoseguro number;
FlagExiste char(1);
Begin
  fechaUno := TRUNC(p_fecha, 'MM');
  fechaDos := last_day(p_fecha);

  Execute immediate ('truncate table aqpa557');

  For c in pago (fechaUno,fechaDos) loop
    ln_correl := ln_correl +1 ;
     -- datos cliente
     BEgin
        Select pepais, petdoc, pendoc
         into ln_pais, ln_tdoc, lc_numdoc
         from fsr008
        where pgcod = 1
          and ctnro = c.aocta
          and ttcod = 1
          and cttfir = 'T';
      exception
        when no_data_found then
          ln_pais := 0;
          ln_tdoc := 0;
          lc_numdoc:= null;
      end;
      lc_numcert := null;
      --- nro cuotas
      Begin
           select count(*)
             into ln_numerocuota
             from fsd601 x, fsd611 y
            where x.pgcod  = c.pgcod
              and x.ppmod = c.aomod
              and x.ppsuc = c.aosuc
              and x.ppmda = c.aomda
              and x.pppap = c.aopap
              and x.ppcta = c.aocta
              and x.ppoper = c.aooper
              and x.ppsbop = c.aosbop
              and x.pptope = c.aotope
              and x.ppfpag = c.fpago
              and y.pgcod = x.pgcod
              and y.ppmod =  x.ppmod
              and y.ppsuc = x.ppsuc
              and y.ppmda = x.ppmda
              and y.pppap = x.pppap
              and y.ppcta = x.ppcta
              and y.ppoper = x.ppoper
              and y.ppsbop = x.ppsbop
              and y.pptope = x.pptope
              and y.ppfpag <= x.ppfpag;
          exception
            when no_data_found then
              ln_numerocuota := 0;
          end;
      -- cantidad de seguros
        select count(*)
          into contador
          from fpp001
         where pgcod = c.pgcod
           and aomod = c.aomod
           and aosuc = c.aosuc
           and aomda = c.aomda
           and aopap = c.aopap
           and aocta = c.aocta
           and aooper = c.aooper
           and aosbop = c.aosbop---suboper
           and aotope = c.aotope ;
          -- Existe desgravamen--
        BEgin
          select distinct 'S'
            into FlagExiste
            from fpp001
           where pgcod = c.pgcod
             and aomod = c.aomod
             and aosuc = c.aosuc
             and aomda = c.aomda
             and aopap = c.aopap
             and aocta = c.aocta
             and aooper = c.aooper
             and aosbop = c.aosbop---suboper
             and aotope = c.aotope
             and sgcod  in (select h.sgcod from fst300 h where h.sgsn02 = '5'  );
         exception
           when no_data_found then
             FlagExiste := 'N';
         end;
      -------------------------------
          Begin
           select yy.ppimp11, yy.ppimp12, yy.ppimp13, yy.ppimp14, yy.ppimp15
             into once, doce,trece, catorce,quince
             from fsd601 x, fsd611 yy
            where x.pgcod  = c.pgcod
              and x.ppmod = c.aomod
              and x.ppsuc = c.aosuc
              and x.ppmda = c.aomda
              and x.pppap = c.aopap
              and x.ppcta = c.aocta
              and x.ppoper = c.aooper
              and x.ppsbop = c.aosbop
              and x.pptope = c.aotope
              and x.ppfpag = c.fpago
              and yy.pgcod = x.pgcod
              and yy.ppmod =  x.ppmod
              and yy.ppsuc = x.ppsuc
              and yy.ppmda = x.ppmda
              and yy.pppap = x.pppap
              and yy.ppcta = x.ppcta
              and yy.ppoper = x.ppoper
              and yy.ppsbop = x.ppsbop
              and yy.pptope = x.pptope
              and yy.ppfpag = x.ppfpag;
          exception
            when no_data_found then
              once := 0;
              doce := 0;
              trece := 0;
              catorce := 0;
              quince := 0;
          end;
         ----- validacion ---------
    Begin
      select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
        into BajaSeg,dseg, codigoseguro
        from fsd012
       where pgcod = 1
         and aomod = c.aomod
         and aosuc = c.aosuc
         and aomda = c.aomda
         and aopap = c.aopap
         and aocta = c.aocta
         and aooper = c.aooper
         and aosbop = c.aosbop
         and aotope = c.aotope
         and evfval  between fechaUno and fechaDOS
         and evtipo = 47
         and evcd02 = 'B'
         and d012co = 'S';
    exception
       when no_data_found then
         Begin
           select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = jaqa750seg),'1','VC','3','MV','4','SF','5','DG'),jaqa750seg
             into BajaSeg,dseg,codigoseguro
             from jaqa750
            where jaqa750emp = c.pgcod
              and jaqa750mod = c.aomod
              and jaqa750suc = c.aosuc
              and jaqa750mda = c.aomda
              and jaqa750pap = c.aopap
              and jaqa750cta = c.aocta
              and jaqa750ope = c.aooper
              and jaqa750sbo = c.aosbop
              and jaqa750top = c.aotope
              and jaqa750fec between fechaUno and fechaDOS;
         exception
           when no_data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
       when too_many_rows then
         BEgin
            select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
              into BajaSeg,dseg, codigoseguro
              from fsd012
             where pgcod = 1
               and aomod = c.aomod
               and aosuc = c.aosuc
               and aomda = c.aomda
               and aopap = c.aopap
               and aocta = c.aocta
               and aooper = c.aooper
               and aosbop = c.aosbop
               and aotope = c.aotope
               and evfval between fechaUno and fechaDOS
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S'
               and evcap in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875  and tp1corr1 = 4 and tp1nro2 =1 );
         exception
           when no_Data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
    end;
    if BajaSeg = 'S' and dseg ='VC' then
       contador := contador + 1;
    end if;
    --------------------------


        if contador = 2 then
          if FlagExiste = 'S' then
            prima := once;
          else
            prima := doce;
          end if;
        elsif contador = 3 then
            if FlagExiste = 'S' then
              prima:= doce;
            else
              prima:= trece;
            end if;
        elsif contador = 4 then
           if FlagExiste = 'S' then
              prima := trece;
           else
              prima := catorce;
           end if;
        end if;
 --

      ---Valida Pago
        For p in cuota2 (fechauno, fechados,c.aocta, c.aooper, c.aosbop )loop
          lc_numcert :=  lpad(c.aocta,10,'0') || lpad(c.aooper,10,'0');
          lc_numcre :=  lpad(c.aocta, 9, '0') || lpad(c.aomod, 3, '0') || lpad(c.aomda, 3, '0') || lpad(c.aooper, 9, '0') ||lpad(c.aotope, 3, '0'); --- to_char(LPAD(P.PPCTA,  9, '0') ||LPAD(P.PPOPER, 9, '0') ||LPAD(P.PPSBOP, 3, '0'));
          fecha1 := c.fpago;
          Begin
           select sum(y.pp1imp11), sum(y.pp1imp12),sum(y.pp1imp13), sum(y.pp1imp14),sum(y.pp1imp15)
             into imp11,imp12,imp13,imp14,imp15
             from fsd612 y
            where y.pgcod = p.pgcod
              and y.ppmod =  p.ppmod
              and y.ppsuc = p.ppsuc
              and y.ppmda = p.ppmda
              and y.pppap = p.pppap
              and y.ppcta = p.ppcta
              and y.ppoper = p.ppoper
              and y.ppsbop = p.ppsbop
              and y.pptope = p.pptope
              and y.ppfpag = p.ppfpag
              and y.pptipo = p.pptipo
              and y.pp1nump = p.pp1nump ;
          exception
            when no_data_found then
              imp11 := 0;
              imp12 := 0;imp13 := 0;imp14 := 0;imp15:= 0;
          end;
           if contador = 2 then
             if FlagExiste = 'S' then  --Existe desgravamen
               if prima = imp11 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             else ---No existe desgravamen
               if prima = imp12 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             end if;
          elsif contador = 3 then
            if FlagExiste = 'S' then
               if prima = imp12 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             else
               if prima = imp13 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             end if;
          elsif contador = 4 then
            if FlagExiste = 'S' then
               if prima = imp13 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
            else
              if prima = imp14 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
            end if;
          elsif contador = 1 then
            if FlagExiste = 'S' then
               verifica := 1;
            else
              if prima = imp11 then
                verifica := 0;
               else
                 verifica := 1;
               end if;
            end if;
          end if;
     ---------------------------------------
    begin
      insert into aqpa557(aqpa557cod,
                          aqpa557mod,
                          aqpa557suc,
                          aqpa557mda,
                          aqpa557pap,
                          aqpa557cta,
                          aqpa557ope,
                          aqpa557sbo,
                          aqpa557tip,
                          aqpa557fep,
                          aqpa557canal,
                          aqpa557cprod,
                          aqpa557corr ,
                          aqpa557cert,
                          aqpa557ncuo,
                          aqpa557ndoc,
                          aqpa557tdoc,
                          aqpa557tcta,
                          aqpa557ncre,
                          aqpa557prim,
                          aqpa557fech,
                          aqpa557pais,
                          aqpa557a3,
                          aqpa557a1 )
                   values(777,
                          c.aomod,
                          c.aosuc,
                          c.aomda,
                          c.aopap,
                          c.aocta,
                          c.aooper,
                          c.aosbop,
                          c.aotope,
                          p_fecha,
                          13,
                          48,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          prima,
                          c.fpago,
                          ln_pais,
                          'N',
                          verifica);
        commit;
      exception
        when dup_val_on_index then
          null;
      end;
      --- adicion SMA 20231226
      begin
      insert into aqpa557H(aqpa557Hcod,
                          aqpa557Hmod,
                          aqpa557Hsuc,
                          aqpa557Hmda,
                          aqpa557Hpap,
                          aqpa557Hcta,
                          aqpa557Hope,
                          aqpa557Hsbo,
                          aqpa557Htip,
                          aqpa557Hfep,
                          aqpa557Hcanal,
                          aqpa557Hcprod,
                          aqpa557Hcorr ,
                          aqpa557Hcert,
                          aqpa557Hncuo,
                          aqpa557Hndoc,
                          aqpa557Htdoc,
                          aqpa557Htcta,
                          aqpa557Hncre,
                          aqpa557Hprim,
                          aqpa557Hfech,
                          aqpa557Hpais,
                          aqpa557Ha3,
                          aqpa557ha1 )
                   values(777,
                          c.aomod,
                          c.aosuc,
                          c.aomda,
                          c.aopap,
                          c.aocta,
                          c.aooper,
                          c.aosbop,
                          c.aotope,
                          p_fecha,
                          13,
                          48,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          prima,
                          c.fpago,
                          ln_pais,
                          'N',
                          verifica);
        commit;
      exception
        when dup_val_on_index then
          null;
      end;

      end loop;
    end loop;
END SP_MULTI_TRAMA_COBROS;

PROCEDURE SP_MULTIGARANTIA_TRAMA_ALTAS(P_FECHA IN DATE) IS

CURSOR CUENTAS (fechaini in date,fechafin in date) IS
      select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                b.aoimp monto,
                b.aoperiod periodo
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 10875
                                and tp1corr1 =10)
             and b.AOFVAL  between fechaini and fechafin
             order by b.aofval,b.aocta,b.aooper;


    cursor celular (pais number,tdoc number,ndoc char) is
        select trim(dotelfp) fono
          from fsr005
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and docod = 1;

      cursor correo (pais number,tdoc number,ndoc char) is
        select trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))) mail
          from fsx001
         where pepais = pais
           and petdoc = tdoc
           and pendoc = ndoc
           and txcod = 0 --x_08.txcod = 0
           and pextxt <> 'SI'
           and pextxt Like '%@%';
      Cursor garantia(inst in number) is
          select sng122cta cuenta,sng122oper operacion
            from sng122
           where sng122inst= inst;

  CURSOR BAJASG (fechaini in date,fechafin in date) IS
      select b.*, a.sgcod seguro, a.pp001porc tasa,
               (select cenom from fst026  where cecod = b.aostat) estado,
               (select scnom from fst001 where sucurs = a.aosuc) sucursal,
               (substr(lpad(a.aocta, 9, '0') || lpad(a.aomod, 3, '0') || lpad(a.aomda, 3, '0') || lpad(a.aooper, 9, '0') ||lpad(a.aotope, 3, '0'), 1, 30))  nrocredito,
               decode(a.aomda, '0', '001', '002') moneda_cuenta,     --moneda
                to_char(b.aofvto,'yyyymmdd') fechavto,
                to_char(b.aofval,'yyyymmdd') fechadesem,
                to_char(b.aofe99,'yyyymmdd') fechacan,
                b.aoimp monto,
                b.aoperiod periodo
           from fpp001 a
          inner join fsd010 b
              on b.pgcod = a.pgcod
             and b.aomod = a.aomod
             and b.aosuc = a.aosuc
             and b.aomda = a.aomda
             and b.aopap = a.aopap
             and b.aocta = a.aocta
             and b.aooper = a.aooper
             and b.aosbop = a.aosbop
             and b.aotope = a.aotope
           where a.sgcod in (select tp1nro1
                               from fst198
                              where tp1cod = 1
                                and tp1cod1 = 10875
                                and tp1corr1 =10)
             and b.aofe99  between fechaini and fechafin
             and b.aostat = 99
         --   and b.AOCTA = 3503596  --4198879  --
          --  and b.aooper = 16238734 ---16030465
             order by b.aofval      ;


  lc_telefono   char(50);
  tele varchar2(1000);
  lc_correo     char(50);
  apepat char(50);
  apemat char(50);
  nombres char(50);
  sexo char(1);
  ecivil char(1);
  fechanac varchar2(8);
  pais number;
  tipodoc number;
  tipodocA CHAR(3);
  numdoc char(12);
  direcc char(100);
  RAZONS CHAR(150);
  mail char(200);
  telefono char(50);
  ubigeo char(10);
  GIRO char(300);
  OCUPACION char(50);
  sucursal char(30);
  funcionario char(10);
  operacion number(9);
  ln_cont number:= 0;
  ln_cont1 number:=0;

  correlativo number(17):=0;
  certificado char(30);
  doctipo char(3);

  prima number(17,2):=0;
  --dIRECCION_neg char(300);
 -- ubigeo_neg char(8);
  tasa number(10,6):=0;
 -- costo number(17,2):=0;
 -- nrocuota number:= 0;

  dirdomi char(300);
  ubidomi char(8);
  actdomi char(300);
  ocudomi char(50);
  v_num1 number;
  v_num2 number;
  v_char1 char(200);
  v_char2 char(50);
  v_resul number:= 0;
  tipo_via char(1);
  direccion1 char(300);
  USO char(1);
  tipoconstruccion char(1);
  Nro_Piso char(10);
  Nro_Sotano char(10);
  A_Fabrica char(10);
  A_Constru char(10);
  contenido char(50);
  codigo_giro number:=0;
  saldoasegurado number(17,2):= 0;
---  papel number:=0;
  periodo number:=0;
 -- plazo1 number;
 -- fechaxwf date;
 -- mod1 number;
  --suc1 number;
  --subop1 number;
  --tipo1 number;
  mda1 number;
  instancia number;
 -- CTASA number(10,6):= 0.028000;
 -- fechades date;
  fechavto date;
 -- fechades1 varchar2(8);
 -- fechavto1 varchar2(8);
  nrocredito char(30);
  moneda varchar2(3);
  nro_cuotas  number;
  contador number;
  minFecha date;
  imp11 number(17,2);
  imp12 number(17,2);
  imp13 number(17,2);
  imp14 number(17,2);
  fecha1vto char(20);
  fecha1des char(20);
  contador1 number:= 0;
  plazo number;
  Mto_Edif2 number (17,2);
  Mto_Edif number(17,2);
  fechauno date;
  tipcambio number(10,6);
  fecha1 date;
  fecha2 date;
  v_char22 varchar2(10);
  Equivalencia char(30);
  tipo number;
  descripcion char(40);
  tipoope number;
  nombrecod char(50);
  monedagar char(5);
  BajaSeg char(1);
  dseg    char(2);
  codigoseguro number(3);
  begin
   fecha1 := TRUNC(p_fecha, 'MM');
   fecha2 := last_day(p_fecha);
   Execute immediate ('truncate table aqpa555');

    For a in cuentas(fecha1,fecha2) loop
      contador1 := contador1 + 1;
         apepat := NULL;
         apemat := NULL;
         nombres := NULL;
         sexo:= NULL;
         ecivil:= NULL;
         fechanac:= NULL;
         tipodoc:= NULL;
         numdoc:= NULL;
         direcc := NULL;
         razons := null;
         telefono := null;
         mail:= null;
         ubigeo := null;
         giro := null;
         ocupacion := null;
         sucursal := null;
         funcionario :=null;
         certificado := null;

      Begin
         select  trim(d.pfape1),
                 trim(d.pfape2),
                 trim(d.pfnom1)||' '||trim(d.pfnom2),
                 d.pfcant,
                 Decode(d.pfeciv,1, 'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
                 to_char(d.pffnac,'yyyymmdd'),
                 d.pfpais,
                 d.pftdoc,
                 Decode(d.pftdoc,21,'001','000'),
                 d.pfndoc,
                (select trim(substr(sngc13dir,1,100))
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc= d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est ='H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                               from sngc13
                                              where sngc13pais = d.pfpais
                                                and sngc13tdoc = d.pftdoc
                                                and sngc13ndoc = d.pfndoc
                                                and docod = 1
                                                and sngc13est = 'H')
                     ),
                    (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pfpais
                        and sngc13tdoc= d.pftdoc
                        and sngc13ndoc = d.pfndoc
                        and docod = 1
                        and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                                   from sngc13
                                                  where sngc13pais = d.pfpais
                                                    and sngc13tdoc = d.pftdoc
                                                    and sngc13ndoc = d.pfndoc
                                                    and docod = 1
                                                    and sngc13est = 'H')
                        )
          into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
           from fsd002 d
           inner join fsr008 e
                   on e.pepais = d.pfpais
                  and e.petdoc = d.pftdoc
                  and e.pendoc = d.pfndoc
                where e.ctnro = a.aocta
                  and e.ttcod = 1
                  and e.cttfir ='T';

      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,100))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc= d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H')),
                  (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc = d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est = 'H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H'))
               into razons,pais,tipodoc,tipodocA, numdoc, direcc, ubigeo
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      bEGIN
        sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog, m.sng122tope, decode(m.sng122mda,101,'Dolar','Soles')
          INTO INSTANCIA, operacion, saldoasegurado, tipoope, monedagar
          FROM XWF700 n inner join sng122 m
                        on m.sng122inst = n.xwfprcins
           WHERE n.xwfempresa = 1
             and n.xwfmodulo = a.aomod
             and n.xwfmoneda = a.aomda
             and n.xwfpapel = a.aopap
             AND n.xwfcuenta = a.AOCTA
             AND n.xwfoperacion = a.AOOPER
             and n.xwftipope = a.aotope
             AND n.xwfcar3 ='1'
             and n.xwfsubope = a.aosbop
             and m.sng122pri = (select max(sng122pri)
                                  from sng122
                                 where sng122inst =  n.xwfprcins
                                   and sng122mod = 70 ) ;

    EXCEPTION
      when no_data_found then
        Begin
         sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog
          INTO INSTANCIA, operacion, saldoasegurado
          FROM XWF700 n inner join sng122 m
                        on m.sng122inst = n.xwfprcins
           WHERE n.xwfempresa = 1
             and n.xwfmodulo = a.aomod
             and n.xwfmoneda = a.aomda
             and n.xwfpapel = a.aopap
             AND n.xwfcuenta = a.AOCTA
             AND n.xwfoperacion = a.AOOPER
             and n.xwftipope = a.aotope
             AND n.xwfcar3 ='1'
             and n.xwfsubope = a.aosbop
             and m.sng122pri = (select max(sng122pri)
                                  from sng122
                                 where sng122inst =  n.xwfprcins
                                   and sng122mod = 70 )
             and rownum = 1 ;
        exception
          when no_data_found  then
             INSTANCIA :=0;
             operacion :=0;
             saldoasegurado := 0;
        end;
      WHEN OTHERS then
         sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog
          INTO INSTANCIA, operacion, saldoasegurado
          FROM XWF700 n inner join sng122 m
                        on m.sng122inst = n.xwfprcins
           WHERE n.xwfempresa = 1
             and n.xwfmodulo = a.aomod
             and n.xwfmoneda = a.aomda
             and n.xwfpapel = a.aopap
             AND n.xwfcuenta = a.AOCTA
             AND n.xwfoperacion = a.AOOPER
             and n.xwftipope = a.aotope
             AND n.xwfcar3 ='1'
             and n.xwfsubope = a.aosbop
             and m.sng122pri = (select max(sng122pri)
                                  from sng122
                                 where sng122inst =  n.xwfprcins
                                   and sng122mod = 70 )
             and rownum = 1 ;
    END;
    -----
         Begin ---pisos
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='1';
      when too_many_rows then
         select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
 Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='0';
      when too_many_rows then
         select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) = OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
        A_Fabrica :='00';
      when too_many_rows then
        select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70
         and rownum = 1;
    end;
    Begin
      select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76;
    exception
       when no_data_found then
          A_Constru :='0';
       when too_many_rows then
          select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76
         and rownum = 1;
    end;
    Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='L';
        when too_many_rows then
           select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := substr((trim(tele)||'-'||trim(t.fono)),1,50);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);

   --    dbms_output.put_line( lc_telefono);

       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||'-'||trim(c.mail)),1,50);
          end if;

         ln_cont1 := ln_cont1 + 1;
      end loop;
       lc_correo := substr(mail,1,50);
       if lc_correo is null then
         lc_correo := 'sindato@gmail.com';
       end if;
   --     dbms_output.put_line( lc_correo);
      begin
        select
        (SELECT NVL(substr(trim(A1.AQPA558ACT),1,50),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
            (SELECT NVL(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )
          into ocupacion,
               giro,
               codigo_giro
          from SNGC60
         where sngc60pais = pais
           and sngc60tdoc = tipodoc
           and sngc60ndoc = numdoc
           and rownum = 1;
    ---   dbms_output.put_line( ocupacion||';giro'|| giro||';fingiro'|| codigo_giro);

      exception
        when no_data_found then
          begin
            select --- sngc60acte ,
              (SELECT substr(trim(A1.AQPA558ACT),1,50)
                FROM FST198 F1, AQPA558 A1
               WHERE F1.TP1COD = 1
                 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                 AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ) a,
                  (SELECT substr(Trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
                ---   dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
          exception
            when no_Data_found then
              BEgin
               select --- sngc60acte ,
              (select SNGC07dsc from SNGC07 where  sngc07cod  = sngc60acte ) a,
                  (SELECT substr(Trim(A1.AQPA558act),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
---dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
            exception
            when too_many_rows then
      --        dbms_output.put_line('duplicado 1 ********************************'||' '||a.aocta||' '||a.aooper);
                    null;
            when no_data_found then
              null;
            end;
          end;
       when too_many_rows then null;
         --dbms_output.put_line('duplicado 2********************************'||' '||a.aocta||' '||a.aooper);
       null;
     end;

     if giro is null then
       giro:= actdomi;

     end if;


      nro_cuotas := 0 ;
      select count(*) into nro_cuotas
        from fsd601
       where pgcod = 1
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper --operacion
         and ppsbop = a.aosbop --subop1
         and pptope = a.aotope; ---tipo1;
  --     dbms_output.put_line(nro_cuotas);


    funcionario := FN_ANALISTA_CREDITO(a.aomod, a.aosuc, a.aomda, a.aopap, a.aocta, a.aooper, a.aosbop, a.aotope);

    if funcionario is null then
           Begin

              select jaql964usu
                into funcionario
                from jaql964
               where jaql964cta =a.aocta
                 and jaql964ope = a.aooper
                 and jaql964mod = a.aomod
                 and jaql964sob = a.aosbop
                 and jaql964top = a.aotope
                 and rownum = 1;
            exception
              when no_data_found then
                funcionario:= 'S/ANALISTA';
            end;
    end if;
 --- prima     ***********************
    select count(*)
      into contador
      from fpp001 where  pgcod = a.pgcod
             and aomod = a.aomod
             and aosuc = a.aosuc
             and aomda = a.aomda
             and aopap = a.aopap
             and aocta = a.aocta
             and aooper = a.aooper
             and aosbop = a.aosbop
             and aotope = a.aotope ;

     Select min(ppfpag)
        into minFecha
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

      Select count(*)
        into plazo
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

    Begin
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
      Select ppimp11,ppimp12, ppimp13,ppimp14
        into imp11,imp12, imp13,imp14
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope
         and ppfpag= minFecha; ---a.aofvto
      --   and rownum = 1;
    exception
      when no_data_found then
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
    end;
       ----- validacion  ---------
    Begin
      select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
        into BajaSeg,dseg, codigoseguro
        from fsd012
       where pgcod = 1
         and aomod = a.aomod
         and aosuc = a.aosuc
         and aomda = a.aomda
         and aopap = a.aopap
         and aocta = a.aocta
         and aooper = a.aooper
         and aosbop = a.aosbop
         and aotope = a.aotope
         and evfval between fecha1 and fecha2
         and evtipo = 47
         and evcd02 = 'B'
         and d012co = 'S';
    exception
       when no_data_found then
         Begin
           select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = jaqa750seg),'1','VC','3','MV','4','SF','5','DG'),jaqa750seg
             into BajaSeg,dseg,codigoseguro
             from jaqa750
            where jaqa750emp = a.pgcod
              and jaqa750mod = a.aomod
              and jaqa750suc = a.aosuc
              and jaqa750mda = a.aomda
              and jaqa750pap = a.aopap
              and jaqa750cta = a.aocta
              and jaqa750ope = a.aooper
              and jaqa750sbo = a.aosbop
              and jaqa750top = a.aotope
              and jaqa750fec between fecha1 and fecha2;
         exception
           when no_data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
      when too_many_rows then
        Begin
          select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
            into BajaSeg,dseg, codigoseguro
            from fsd012
           where pgcod = 1
             and aomod = a.aomod
             and aosuc = a.aosuc
             and aomda = a.aomda
             and aopap = a.aopap
             and aocta = a.aocta
             and aooper = a.aooper
             and aosbop = a.aosbop
             and aotope = a.aotope
             and evfval between fecha1 and fecha2
             and evtipo = 47
             and evcd02 = 'B'
             and d012co = 'S'
             and evcap in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875  and tp1corr1 = 4 and tp1nro2 =1 );
        exception
           when no_data_found then
             BajaSeg := 'N';
             dseg    :='00';
        end;
    end;
    if BajaSeg = 'S' and dseg ='VC' then
       contador := contador + 1;
    end if;
    --------------------------
    if contador = 2 then
      prima := imp11;
    elsif contador = 3 then
      prima:= imp12;
    elsif contador = 4 then
      prima := imp13;
    else
      prima:= imp11;
   end if;
   --------------------------

      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;
     begin
      select
        trim(t_dire.ppg001dato), -- direccion
        trim(lpad(t_adic.ppg008cip,6,'0')),-- ubigeo
        (SELECT substr(A1.AQPA558ACT,1,50) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1 )aCTIVIDAD, --ocupacion
        (SELECT trim(A1.AQPA558DGIRO) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1 )GIRO --, -- giro
        into dirdomi, ubidomi,  ocudomi,actdomi
        from
        sng122 w,
        ppg008 t_adic,
        fst071 t_dist,
        fst070 t_prov,
        fst068 t_dept,
        ppg001 t_dire,
        fsd008 t_ctte,
        fst750 t_ciiu,
        fst752 t_grup
      where W.SNG122CTA =  a.aocta --CUENTA
        and w.sng122oper = operacion --OPERACION
        AND W.SNG122INST = INSTANCIA
        and t_adic.ppg008pgc(+) = w.sng122pgc
        and t_adic.ppg008mod(+) = w.sng122mod
        and t_adic.ppg008suc(+) = w.sng122suc
        and t_adic.ppg008mda(+) = w.sng122mda
        and t_adic.ppg008pap(+) = w.sng122pap
        and t_adic.ppg008cta(+) = w.sng122cta
        and t_adic.ppg008ope(+) = w.sng122oper
        and t_adic.ppg008sbo(+) = w.sng122sbop
        and t_adic.ppg008top(+) = w.sng122tope
        --and t_adic.ppg008corr(+) = w.sng122corr
        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
        and t_adic.ppg008cdat(+) = 58
        and t_dept.pais(+) = 604
        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1)
        and t_prov.pais(+) = 604
        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1)
        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071pai(+) = 604
        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)
        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071col(+) = t_adic.ppg008cip

        and t_dire.ppg001cod(+) = w.sng122pgc
        and t_dire.ppg001mod(+) = w.sng122mod
        and t_dire.ppg001suc(+) = w.sng122suc
        and t_dire.ppg001mda(+) = w.sng122mda
        and t_dire.ppg001pap(+) = w.sng122pap
        and t_dire.ppg001cta(+) = w.sng122cta
        and t_dire.ppg001ope(+) = w.sng122oper
        and t_dire.ppg001sbo(+) = w.sng122sbop
        and t_dire.ppg001top(+) = w.sng122tope
        --and t_dire.ppg003cor(+) = w.sng122corr
        --and t_dire.ppg003frm(+) = 0---t_cgar.ppg000frm
        and t_dire.ppg001cdat(+) = 41
        and t_ctte.pgcod(+)= 1
        and t_ctte.ctnro(+) =  W.SNG122CTA
        and t_ciiu.actcod1(+) = t_ctte.ctnroi
        and t_grup.actcod3(+) = t_ciiu.actcod3
        ;
    exception
       when no_data_found then
         dirdomi := direcc;
         ubidomi := null;
         actdomi := null;
         ocudomi := null;
       when too_many_rows then
         null;
         ---dupli         dbms_output.put_line(a.aocta||' '||operacion||' '||instancia);
    end;
--dbms_output.put_line(dirdomi);
      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      select trim(substr(v_char1,1,v_num2)) into v_char2 from dual;
      direccion1 := upper(dirdomi);
--dbms_output.put_line( direccion1||';'||v_char2);
      select REGEXP_INSTR( direccion1,'JR|JIRON') into v_resul from dual;
      if v_resul <> 0 then
        tipo_via :='J';
      else
        select REGEXP_INSTR( direccion1,'C|CALLE') into v_resul from dual;
        if v_resul <> 0 then
          tipo_via :='C';
        else
          select REGEXP_INSTR( direccion1,'AV|AVENIDA') into v_resul from dual;
          if v_resul <> 0 THEN
            tipo_via :='A';
          else
            select REGEXP_INSTR( direccion1,'URB|URBANIZACION') into v_resul from dual;
            if v_resul <> 0 THEN
              tipo_via :='A';
            else
              tipo_via := 'O';
            end if;
          end if;
        end if;
      end if;


      USO := '0';

      contenido := '0';
      ----contenido
  Begin
      select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;
    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
         select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;
    end;

     -- TIPO EQUIVALENCIA DE LA GARANTIA
     descripcion:= null;
     tipo:= 0;
     Equivalencia := null;
      begin
        select substr(ppg008desc,1,40) , PPG008CIP,
          decode(PPG008CIP,10,'Mobiliario',20,'Maquinaria',30,'Existencias',40,'Inmuebles y Existencias','No Asegurable')
          into descripcion, tipo, Equivalencia
          from  ppg008
          where PPG008Pgc = 1
            and PPG008Mod = 70
            and PPG008CdAt = 59
            and PPG008Cta = a.aocta
            and PPG008Ope = operacion
            and PPG008CIP in (10,20,30,40,50,60,70,80)
            and rownum = 1;
               -- &ppg008cip = PPG008CIP
       exception
        when no_data_found then
           descripcion:= null;

       end;

    begin
      select  ppg018desc
        into nombrecod
        from ppg018
       where ppg018mod = 70
         and ppg018mda  =  a.aomda
         and ppg018top  = tipoope;
    exception
      when no_data_found then
        nombrecod := null;
        tipoope := 0;
    end;

     if dirdomi is null or dirdomi =' ' then
        dirdomi:= direcc;
      end if;

      If ubidomi  is null or ubidomi = ' ' then
        ubidomi := trim(ubigeo);
      end if;
      if mda1 = 0 then
        moneda := '001';
      else
        moneda := '002';
      end if;
      select max(aqpa562corr)
        into correlativo
        from aqpa562;
      correlativo := correlativo + 1 ;
      certificado := lpad(a.aocta,10,'0')||lpad(operacion,10,'0');
      fecha1vto := to_char(a.aofvto,'yyyymmdd');
      fecha1des := to_char(a.aofval,'yyyymmdd');


       --carga de las garantias para sumar montos edificacion
     Mto_Edif2 := 0;
     Mto_Edif := 0;
     moneda := a.aomda;
     For g in garantia(instancia) loop


         if moneda = 0 then
            select last_day(add_months(P_FECHA, -1))--,pgfape,add_months(pgfape, -1)
              into fechauno --, fecha1, fecha2
              from dual;
              --tipo cambio
              Select cotcbi
               Into tipcambio
               From (
                       select u.cotcbi
                         From fsh005 u
                        Where moneda=101
                          And cofdes <= fechauno
                     Order by cofdes desc
                    )
              Where rownum = 1;

             BEgin
                select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta --- pn_cta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                    and ppg004frm = (select max(ppg004frm)
                                       from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67);
                  -- AND PPG004CDAT = 67 ;
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                       ---AND PPG004CDAT = 67) ;
             end;
         else
             BEgin
                select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                    and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta =g.cuenta
                                       and ppg004ope = g.operacion);
    --               AND PPG004CDAT = 67
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                      --- AND PPG004CDAT = 67) ;
             end;
         end if;
         Mto_Edif := Mto_Edif + Mto_Edif2;
    end loop;

    if a.tasa = 0 then
     tasa := 0.028000;
    else
     tasa := a.tasa;
    end if;
    Begin

    v_char22 := substr(v_char2,1,10);
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        --aqpa555dcneg,---act
                        aqpa555dgneg,--giro
                        aqpa555ddir, --dir
                        aqpa555dubige,--ubigeo
                        aqpa555dtinm, --tipo inmueble
                        aqpa555dnum ,--numero
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsase,
                        aqpa555dsaedi,
                        aqpa555dsacon,
                        aqpa555a1, --periodo
                        aqpa555a2,--plazo
                       /* aqpa555a4, --descripcion
                        aqpa555a6, --nombrecod
                        aqpa555a7, --equivalencia */
                        aqpa555a8  --moneda garantia
                           )
                 values(888,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'A',
                        13,
                        49,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        Mto_Edif, --monto edificacion
                        saldoasegurado,
                        a.aoperiod,
                        plazo,
                       /* descripcion,
                        nombrecod,
                        equivalencia,*/
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
   begin
      insert into aqpa555h(aqpa555hcod,
                        aqpa555hmod,
                        aqpa555hsuc,
                        aqpa555hmda,
                        aqpa555hpap,
                        aqpa555hcta,
                        aqpa555hope,
                        aqpa555hsbo,
                        aqpa555htip,
                        aqpa555hfec,
                        aqpa555hmov,
                        aqpa555hcanal,
                        aqpa555hcpro,
                        aqpa555hcorr,
                        aqpa555hapat,
                        aqpa555hamat,
                        aqpa555hnom,
                        aqpa555hrsoc,
                        aqpa555hndo,
                        aqpa555htdo,
                        aqpa555hmail,
                        aqpa555heciv,
                        aqpa555hsexo,
                        aqpa555hfnac,
                        aqpa555hcel ,
                        aqpa555hocup,
                        aqpa555hubig,
                        aqpa555hdire,
                        aqpa555hncert,
                        aqpa555hnsol,
                        aqpa555hcage,
                        aqpa555hades,
                        aqpa555hfunc,
                        aqpa555hplan,
                        aqpa555hcost,
                        aqpa555hprim,
                        aqpa555htasa,
                        aqpa555hstas,
                        aqpa555htcta,
                        aqpa555hncred,
                        aqpa555hntar,
                        aqpa555hfinpa,
                        aqpa555hfafil,
                        aqpa555hfdes,
                        aqpa555hhdes,
                        aqpa555hfven,
                        aqpa555hfcan,
                        aqpa555hcimp ,
                        aqpa555hmone,
                        aqpa555hctmov,
                        aqpa555hcant ,
                        aqpa555hhlegal,
                        --aqpa555hdcneg,---act
                        aqpa555hdgneg,--giro
                        aqpa555hddir, --dir
                        aqpa555hdubige,--ubigeo
                        aqpa555hdtinm, --tipo inmueble
                        aqpa555hdnum ,--numero
                        aqpa555hpai,
                        aqpa555hcseg,
                        aqpa555ha3,
                        aqpa555hdnpiso,
                        aqpa555hdnsota,
                        aqpa555hdfabri,
                        aqpa555hdcont,
                        aqpa555hdmate,
                        aqpa555hdtedi,
                        aqpa555hdcneg,
                        aqpa555hdsase,
                        aqpa555hdsaedi,
                        aqpa555hdsacon,
                        aqpa555ha1, --periodo
                        aqpa555ha2, --plazo
                    /*    aqpa555ha4, --descripcion
                        aqpa555ha6, --nombrecod
                        aqpa555ha7, --equivalencia*/
                        aqpa555ha8 --moneda garantia
                        )---nro cuotas
                 values(888,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'A',
                        13,
                        49,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        null, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        Mto_Edif, --monto edificacion
                        saldoasegurado,
                        a.aoperiod,
                        plazo,
                   /*     descripcion,
                        nombrecod,
                        equivalencia,*/
                        monedagar
                        ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;

---si
  end loop;
  -----BAJAS GARANTIAS -----------------
  For a in BAJASG(fecha1,fecha2) loop
      contador1 := contador1 + 1;
         apepat := NULL;
         apemat := NULL;
         nombres := NULL;
         sexo:= NULL;
         ecivil:= NULL;
         fechanac:= NULL;
         tipodoc:= NULL;
         numdoc:= NULL;
         direcc := NULL;
         razons := null;
         telefono := null;
         mail:= null;
         ubigeo := null;
         giro := null;
         ocupacion := null;
         sucursal := null;
         funcionario :=null;
         certificado := null;

      Begin
         select  trim(d.pfape1),
                 trim(d.pfape2),
                 trim(d.pfnom1)||' '||trim(d.pfnom2),
                 d.pfcant,
                 Decode(d.pfeciv,1, 'C',2,'D',3,'U',4,'S',5,'V',6,'X'),
                 to_char(d.pffnac,'yyyymmdd'),
                 d.pfpais,
                 d.pftdoc,
                 Decode(d.pftdoc,21,'001','000'),
                 d.pfndoc,
                (select trim(substr(sngc13dir,1,100))
                   from sngc13
                  where sngc13pais = d.pfpais
                    and sngc13tdoc= d.pftdoc
                    and sngc13ndoc = d.pfndoc
                    and docod = 1
                    and sngc13est ='H'
                    and SNGC13CORR = (select max(SNGC13CORR)
                                               from sngc13
                                              where sngc13pais = d.pfpais
                                                and sngc13tdoc = d.pftdoc
                                                and sngc13ndoc = d.pfndoc
                                                and docod = 1
                                                and sngc13est = 'H')
                     ),
                    (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pfpais
                        and sngc13tdoc= d.pftdoc
                        and sngc13ndoc = d.pfndoc
                        and docod = 1
                        and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                                   from sngc13
                                                  where sngc13pais = d.pfpais
                                                    and sngc13tdoc = d.pftdoc
                                                    and sngc13ndoc = d.pfndoc
                                                    and docod = 1
                                                    and sngc13est = 'H')
                        )
          into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
           from fsd002 d
           inner join fsr008 e
                   on e.pepais = d.pfpais
                  and e.petdoc = d.pftdoc
                  and e.pendoc = d.pfndoc
                where e.ctnro = a.aocta
                  and e.ttcod = 1
                  and e.cttfir ='T';

      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,100))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc= d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est ='H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H')),
                  (select trim(lpad(sngc13ugeo,6,'0'))
                       from sngc13
                      where sngc13pais = d.pjpais
                        and sngc13tdoc = d.pjtdoc
                        and sngc13ndoc = d.pjndoc
                        and docod = 1
                        and sngc13est = 'H'
                        and SNGC13CORR = (select max(SNGC13CORR)
                                             from sngc13
                                            where sngc13pais = d.pjpais
                                              and sngc13tdoc = d.pjtdoc
                                              and sngc13ndoc = d.pjndoc
                                              and docod = 1
                                              and sngc13est = 'H'))
               into razons,pais,tipodoc,tipodocA, numdoc, direcc, ubigeo
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.aocta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      bEGIN
        sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog, m.sng122tope, decode(m.sng122mda,101,'Dolar','Soles')
          INTO INSTANCIA, operacion, saldoasegurado, tipoope, monedagar
          FROM XWF700 n inner join sng122 m
                        on m.sng122inst = n.xwfprcins
           WHERE n.xwfempresa = 1
             and n.xwfmodulo = a.aomod
             and n.xwfmoneda = a.aomda
             and n.xwfpapel = a.aopap
             AND n.xwfcuenta = a.AOCTA
             AND n.xwfoperacion = a.AOOPER
             and n.xwftipope = a.aotope
             AND n.xwfcar3 ='1'
             and n.xwfsubope = a.aosbop
             and m.sng122pri = (select max(sng122pri)
                                  from sng122
                                 where sng122inst =  n.xwfprcins
                                   and sng122mod = 70 ) ;

    EXCEPTION
      WHEN OTHERS then
         sELECT n.xwfprcins ,m.sng122oper, m.sng122sdog
          INTO INSTANCIA, operacion, saldoasegurado
          FROM XWF700 n inner join sng122 m
                        on m.sng122inst = n.xwfprcins
           WHERE n.xwfempresa = 1
             and n.xwfmodulo = a.aomod
             and n.xwfmoneda = a.aomda
             and n.xwfpapel = a.aopap
             AND n.xwfcuenta = a.AOCTA
             AND n.xwfoperacion = a.AOOPER
             and n.xwftipope = a.aotope
             AND n.xwfcar3 ='1'
             and n.xwfsubope = a.aosbop
             and m.sng122pri = (select max(sng122pri)
                                  from sng122
                                 where sng122inst =  n.xwfprcins
                                   and sng122mod = 70 )
             and rownum = 1 ;
    END;
    -----
         Begin ---pisos
      select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84;
    exception
      when no_data_found then
        Nro_Piso :='1';
      when too_many_rows then
         select ppg003dato
        into Nro_Piso
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 84
         and rownum = 1;

    end;
 Begin
      select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75;
    exception
      when no_data_found then
        Nro_Sotano :='0';
      when too_many_rows then
         select ppg003dato
        into Nro_Sotano
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 75
         and rownum = 1;

    end;
    Begin
      select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) = OPERACION
         and ppg003cdat(+) = 70;
    exception
      when no_data_found then
        A_Fabrica :='00';
      when too_many_rows then
        select ppg003dato
        into A_Fabrica
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 70
         and rownum = 1;
    end;
    Begin
      select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76;
    exception
       when no_data_found then
          A_Constru :='0';
       when too_many_rows then
          select ppg003dato
        into A_Constru
        from ppg003
       where ppg003cod(+) = 1
         and ppg003mod(+) = 70
         and ppg003cta(+) = a.aocta
         and ppg003ope(+) =OPERACION
         and ppg003cdat(+) = 76
         and rownum = 1;
    end;
    Begin
       select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105;
     exception
        when no_data_found then
          TIPOCONSTRUCCION :='L';
        when too_many_rows then
           select decode(trim(ppg008desc),'Mamposteria','C',
                                      'Entramados de Madera','M',
                                      'Porticos Conc. Arm. con Plac','L',
                                      'Portico de Acero Arriostrado','E',
                                      'Porticos de concreto Armado','L',
                                      'Adobe y quincha','Q',
                                      'Estruct. Industriales/Comerc','E','O')
         INTO TIPOCONSTRUCCION
         from ppg008
        where ppg008pgc(+) = 1
          and ppg008mod(+) = 70
          and ppg008cta(+) = a.aocta
          and ppg008ope(+) = OPERACION
          and ppg008cdat(+) = 105
          and rownum = 1;
     end;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := substr((trim(tele)||'-'||trim(t.fono)),1,50);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);

   --    dbms_output.put_line( lc_telefono);

       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||'-'||trim(c.mail)),1,50);
          end if;

         ln_cont1 := ln_cont1 + 1;
      end loop;
       lc_correo := substr(mail,1,50);
       if lc_correo is null then
         lc_correo := 'sindato@gmail.com';
       end if;
   --     dbms_output.put_line( lc_correo);
      begin
        select
        (SELECT NVL(substr(trim(A1.AQPA558ACT),1,50),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
            (SELECT NVL(substr(Trim(A1.AQPA558DGIRO),1,300),'OTROS') FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )
          into ocupacion,
               giro,
               codigo_giro
          from SNGC60
         where sngc60pais = pais
           and sngc60tdoc = tipodoc
           and sngc60ndoc = numdoc
           and rownum = 1;
    ---   dbms_output.put_line( ocupacion||';giro'|| giro||';fingiro'|| codigo_giro);

      exception
        when no_data_found then
          begin
            select --- sngc60acte ,
              (SELECT substr(trim(A1.AQPA558ACT),1,50)
                FROM FST198 F1, AQPA558 A1
               WHERE F1.TP1COD = 1
                 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                 AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ) a,
                  (SELECT substr(Trim(A1.AQPA558DGIRO),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1)c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
                ---   dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
          exception
            when no_Data_found then
              BEgin
               select --- sngc60acte ,
              (select SNGC07dsc from SNGC07 where  sngc07cod  = sngc60acte ) a,
                  (SELECT substr(Trim(A1.AQPA558act),1,300) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1) b,
                   (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
                  AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = sngc60acte
                  AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1)c
                into ocupacion, giro, codigo_giro
                  from SNGC60
               where sngc60rute = numdoc
                 and sngc60aux2 = (select max(sngc60aux2) from    SNGC60 where sngc60rute = numdoc)
                 and rownum = 1;
---dbms_output.put_line( 'dos'||' '||ocupacion||';giro'|| giro||';fingiro'|| codigo_giro||' '||tipodoc);
            exception
            when too_many_rows then
      --        dbms_output.put_line('duplicado 1 ********************************'||' '||a.aocta||' '||a.aooper);
                    null;
            when no_data_found then
              null;
            end;
          end;
       when too_many_rows then null;
         --dbms_output.put_line('duplicado 2********************************'||' '||a.aocta||' '||a.aooper);
       null;
     end;

     if giro is null then
       giro:= actdomi;

     end if;


      nro_cuotas := 0 ;
      select count(*) into nro_cuotas
        from fsd601
       where pgcod = 1
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper --operacion
         and ppsbop = a.aosbop --subop1
         and pptope = a.aotope; ---tipo1;
  --     dbms_output.put_line(nro_cuotas);


    funcionario := FN_ANALISTA_CREDITO(a.aomod, a.aosuc, a.aomda, a.aopap, a.aocta, a.aooper, a.aosbop, a.aotope);

    if funcionario is null then
           Begin

              select jaql964usu
                into funcionario
                from jaql964
               where jaql964cta =a.aocta
                 and jaql964ope = a.aooper
                 and jaql964mod = a.aomod
                 and jaql964sob = a.aosbop
                 and jaql964top = a.aotope
                 and rownum = 1;
            exception
              when no_data_found then
                funcionario:= 'S/ANALISTA';
            end;
    end if;
 --- prima     ***********************
    select count(*)
      into contador
      from fpp001 where  pgcod = a.pgcod
             and aomod = a.aomod
             and aosuc = a.aosuc
             and aomda = a.aomda
             and aopap = a.aopap
             and aocta = a.aocta
             and aooper = a.aooper
             and aosbop = a.aosbop
             and aotope = a.aotope ;

     Select min(ppfpag)
        into minFecha
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

      Select count(*)
        into plazo
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope;

    Begin
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
      Select ppimp11,ppimp12, ppimp13,ppimp14
        into imp11,imp12, imp13,imp14
        from fsd611
       where pgcod  = a.pgcod
         and ppmod = a.aomod
         and ppsuc = a.aosuc
         and ppmda = a.aomda
         and pppap = a.aopap
         and ppcta = a.aocta
         and ppoper = a.aooper
         and ppsbop = a.aosbop
         and pptope = a.aotope
         and ppfpag= minFecha; ---a.aofvto
      --   and rownum = 1;
    exception
      when no_data_found then
         imp11:= 0;
         imp12:= 0;
         imp13:= 0;
         imp14 := 0;
    end;
    if contador = 2 then
      prima := imp11;
    elsif contador = 3 then
      prima:= imp12;
    elsif contador = 4 then
      prima := imp13;
    else
      prima:= imp11;
   end if;
   --------------------------

      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;
     begin
      select
        trim(t_dire.ppg001dato), -- direccion
        trim(lpad(t_adic.ppg008cip,6,'0')), --ubigeo
        (SELECT substr(A1.AQPA558ACT,1,50) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1)aCTIVIDAD, --ocupacion
        (SELECT trim(A1.AQPA558DGIRO) FROM FST198 F1, AQPA558 A1
        WHERE F1.TP1COD = 1 AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = t_ctte.ctnroi AND
        A1.AQPA558COD = F1.TP1IMP1 and rownum = 1)GIRO --, -- giro
        into dirdomi, ubidomi,  ocudomi,actdomi
        from
        sng122 w,
        ppg008 t_adic,
        fst071 t_dist,
        fst070 t_prov,
        fst068 t_dept,
        ppg001 t_dire,
        fsd008 t_ctte,
        fst750 t_ciiu,
        fst752 t_grup
      where W.SNG122CTA =  a.aocta --CUENTA
        and w.sng122oper = operacion --OPERACION
        AND W.SNG122INST = INSTANCIA
        and t_adic.ppg008pgc(+) = w.sng122pgc
        and t_adic.ppg008mod(+) = w.sng122mod
        and t_adic.ppg008suc(+) = w.sng122suc
        and t_adic.ppg008mda(+) = w.sng122mda
        and t_adic.ppg008pap(+) = w.sng122pap
        and t_adic.ppg008cta(+) = w.sng122cta
        and t_adic.ppg008ope(+) = w.sng122oper
        and t_adic.ppg008sbo(+) = w.sng122sbop
        and t_adic.ppg008top(+) = w.sng122tope
        --and t_adic.ppg008corr(+) = w.sng122corr
        and t_adic.ppg008frm(+) = 0---t_cgar.ppg000frm el ppg000
        and t_adic.ppg008cdat(+) = 58
        and t_dept.pais(+) = 604
        and t_dept.depcod(+) =substr(t_adic.ppg008cip,1,1)
        and t_prov.pais(+) = 604
        and t_prov.depcod(+) = substr(t_adic.ppg008cip,1,1)
        and t_prov.loccod(+) =substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071pai(+) = 604
        and t_dist.fst071dpt(+) = substr(t_adic.ppg008cip,1,1)
        and t_dist.fst071loc(+) = substr(t_adic.ppg008cip,1,3)
        and t_dist.fst071col(+) = t_adic.ppg008cip

        and t_dire.ppg001cod(+) = w.sng122pgc
        and t_dire.ppg001mod(+) = w.sng122mod
        and t_dire.ppg001suc(+) = w.sng122suc
        and t_dire.ppg001mda(+) = w.sng122mda
        and t_dire.ppg001pap(+) = w.sng122pap
        and t_dire.ppg001cta(+) = w.sng122cta
        and t_dire.ppg001ope(+) = w.sng122oper
        and t_dire.ppg001sbo(+) = w.sng122sbop
        and t_dire.ppg001top(+) = w.sng122tope
        --and t_dire.ppg003cor(+) = w.sng122corr
        --and t_dire.ppg003frm(+) = 0---t_cgar.ppg000frm
        and t_dire.ppg001cdat(+) = 41
        and t_ctte.pgcod(+)= 1
        and t_ctte.ctnro(+) =  W.SNG122CTA
        and t_ciiu.actcod1(+) = t_ctte.ctnroi
        and t_grup.actcod3(+) = t_ciiu.actcod3
        ;
    exception
       when no_data_found then
         dirdomi := direcc;
         ubidomi := null;
         actdomi := null;
         ocudomi := null;
       when too_many_rows then
         null;
         ---dupli         dbms_output.put_line(a.aocta||' '||operacion||' '||instancia);
    end;
--dbms_output.put_line(dirdomi);
      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      select trim(substr(v_char1,1,v_num2)) into v_char2 from dual;
      direccion1 := upper(dirdomi);
--dbms_output.put_line( direccion1||';'||v_char2);
      select REGEXP_INSTR( direccion1,'JR|JIRON') into v_resul from dual;
      if v_resul <> 0 then
        tipo_via :='J';
      else
        select REGEXP_INSTR( direccion1,'C|CALLE') into v_resul from dual;
        if v_resul <> 0 then
          tipo_via :='C';
        else
          select REGEXP_INSTR( direccion1,'AV|AVENIDA') into v_resul from dual;
          if v_resul <> 0 THEN
            tipo_via :='A';
          else
            select REGEXP_INSTR( direccion1,'URB|URBANIZACION') into v_resul from dual;
            if v_resul <> 0 THEN
              tipo_via :='A';
            else
              tipo_via := 'O';
            end if;
          end if;
        end if;
      end if;


      USO := '0';

      contenido := '0';
      ----contenido
  Begin
      select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88;
    exception
      when no_data_found then
        contenido := '0';
      when too_many_rows then
         select substr(replace(replace(ppg006dato, chr(13),'-'),chr(10),''),1,50)
        into contenido
        from ppg006
       where ppg006cod = 1
          and ppg006mod  = 70
          and ppg006cta = a.aocta
          and ppg006ope = OPERACION
          and ppg006cdat = 88
          and rownum = 1;
    end;

     -- TIPO EQUIVALENCIA DE LA GARANTIA
     descripcion:= null;
     tipo:= 0;
     Equivalencia := null;
      begin
        select substr(ppg008desc,1,40) , PPG008CIP,
          decode(PPG008CIP,10,'Mobiliario',20,'Maquinaria',30,'Existencias',40,'Inmuebles y Existencias','No Asegurable')
          into descripcion, tipo, Equivalencia
          from  ppg008
          where PPG008Pgc = 1
            and PPG008Mod = 70
            and PPG008CdAt = 59
            and PPG008Cta = a.aocta
            and PPG008Ope = operacion
            and PPG008CIP in (10,20,30,40,50,60,70,80)
            and rownum = 1;
               -- &ppg008cip = PPG008CIP
       exception
        when no_data_found then
           descripcion:= null;

       end;

    begin
      select  ppg018desc
        into nombrecod
        from ppg018
       where ppg018mod = 70
         and ppg018mda  =  a.aomda
         and ppg018top  = tipoope;
    exception
      when no_data_found then
        nombrecod := null;
        tipoope := 0;
    end;

     if dirdomi is null or dirdomi =' ' then
        dirdomi:= direcc;
      end if;

      If ubidomi  is null or ubidomi = ' ' then
        ubidomi := trim(ubigeo);
      end if;
      if mda1 = 0 then
        moneda := '001';
      else
        moneda := '002';
      end if;
      select max(aqpa562corr)
        into correlativo
        from aqpa562;
      correlativo := correlativo + 1 ;
      certificado := lpad(a.aocta,10,'0')||lpad(operacion,10,'0');
      fecha1vto := to_char(a.aofvto,'yyyymmdd');
      fecha1des := to_char(a.aofval,'yyyymmdd');


       --carga de las garantias para sumar montos edificacion
     Mto_Edif2 := 0;
     Mto_Edif := 0;
     moneda := a.aomda;
     For g in garantia(instancia) loop


         if moneda = 0 then
            select last_day(add_months(P_FECHA, -1))--,pgfape,add_months(pgfape, -1)
              into fechauno --, fecha1, fecha2
              from dual;
              --tipo cambio
              Select cotcbi
               Into tipcambio
               From (
                       select u.cotcbi
                         From fsh005 u
                        Where moneda=101
                          And cofdes <= fechauno
                     Order by cofdes desc
                    )
              Where rownum = 1;

             BEgin
                select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta --- pn_cta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                    and ppg004frm = (select max(ppg004frm)
                                       from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67);
                  -- AND PPG004CDAT = 67 ;
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO * tipcambio-- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                       ---AND PPG004CDAT = 67) ;
             end;
         else
             BEgin
                select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                    and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta =g.cuenta
                                       and ppg004ope = g.operacion);
    --               AND PPG004CDAT = 67
             exception
               when no_data_found then
                 Mto_Edif2 := 0;
               when too_many_rows then
                  select ppg004DATO -- MONTO EDIFICACION
                  into Mto_Edif2
                  from ppg004
                 where ppg004cOD = 1
                   and ppg004mod  = 70  --AND ppg008cip =30
                   and ppg004cta = g.cuenta
                   and ppg004ope = g.operacion
                   and ppg004cdat = 67
                   and ppg004frm = (select max(ppg004frm)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta--pn_cta
                                        and ppg004ope = g.operacion
                                        and ppg004cdat = 67)
                   and ppg004top = (select max(ppg004top)
                                      from ppg004
                                     where ppg004cOD = 1
                                       and ppg004mod  = 70  --AND ppg008cip =30
                                       and ppg004cta = g.cuenta
                                       and ppg004ope = g.operacion);
                                      --- AND PPG004CDAT = 67) ;
             end;
         end if;
         Mto_Edif := Mto_Edif + Mto_Edif2;
    end loop;

    if a.tasa = 0 then
     tasa := 0.028000;
    else
     tasa := a.tasa;
    end if;
    Begin

    v_char22 := substr(v_char2,1,10);
    insert into aqpa555(aqpa555cod,
                        aqpa555mod,
                        aqpa555suc,
                        aqpa555mda,
                        aqpa555pap,
                        aqpa555cta,
                        aqpa555ope,
                        aqpa555sbo,
                        aqpa555tip,
                        aqpa555fec,
                        aqpa555mov,
                        aqpa555canal,
                        aqpa555cpro,
                        aqpa555corr,
                        aqpa555apat,
                        aqpa555amat,
                        aqpa555nom,
                        aqpa555rsoc,
                        aqpa555ndo,
                        aqpa555tdo,
                        aqpa555mail,
                        aqpa555eciv,
                        aqpa555sexo,
                        aqpa555fnac,
                        aqpa555cel ,
                        aqpa555ocup,
                        aqpa555ubig,
                        aqpa555dire,
                        aqpa555ncert,
                        aqpa555nsol,
                        aqpa555cage,
                        aqpa555ades,
                        aqpa555func,
                        aqpa555plan,
                        aqpa555cost,
                        aqpa555prim,
                        aqpa555tasa,
                        aqpa555stas,
                        aqpa555tcta,
                        aqpa555ncred,
                        aqpa555ntar,
                        aqpa555finpa,
                        aqpa555fafil,
                        aqpa555fdes,
                        aqpa555hdes,
                        aqpa555fven,
                        aqpa555fcan,
                        aqpa555cimp ,
                        aqpa555mone,
                        aqpa555ctmov,
                        aqpa555cant ,
                        aqpa555hlegal,
                        --aqpa555dcneg,---act
                        aqpa555dgneg,--giro
                        aqpa555ddir, --dir
                        aqpa555dubige,--ubigeo
                        aqpa555dtinm, --tipo inmueble
                        aqpa555dnum ,--numero
                        aqpa555pai,
                        aqpa555cseg,
                        aqpa555a3,
                        aqpa555dnpiso,
                        aqpa555dnsota,
                        aqpa555dfabri,
                        aqpa555dcont,
                        aqpa555dmate,
                        aqpa555dtedi,
                        aqpa555dcneg,
                        aqpa555dsase,
                        aqpa555dsaedi,
                        aqpa555dsacon,
                        aqpa555a1, --periodo
                        aqpa555a2, --plazo
                       /* aqpa555a4, --descripcion
                        aqpa555a6, --nombrecod
                        aqpa555a7, --equivalencia*/
                        aqpa555a8  --monedagar
                           )
                 values(222,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'B',
                        13,
                        49,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        a.fechacan, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        Mto_Edif, --monto edificacion
                        saldoasegurado,
                        a.aoperiod,
                        plazo,
                     /*   descripcion,
                        nombrecod,
                        Equivalencia,*/
                        monedagar
                       ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
   begin
      insert into aqpa555h(aqpa555hcod,
                        aqpa555hmod,
                        aqpa555hsuc,
                        aqpa555hmda,
                        aqpa555hpap,
                        aqpa555hcta,
                        aqpa555hope,
                        aqpa555hsbo,
                        aqpa555htip,
                        aqpa555hfec,
                        aqpa555hmov,
                        aqpa555hcanal,
                        aqpa555hcpro,
                        aqpa555hcorr,
                        aqpa555hapat,
                        aqpa555hamat,
                        aqpa555hnom,
                        aqpa555hrsoc,
                        aqpa555hndo,
                        aqpa555htdo,
                        aqpa555hmail,
                        aqpa555heciv,
                        aqpa555hsexo,
                        aqpa555hfnac,
                        aqpa555hcel ,
                        aqpa555hocup,
                        aqpa555hubig,
                        aqpa555hdire,
                        aqpa555hncert,
                        aqpa555hnsol,
                        aqpa555hcage,
                        aqpa555hades,
                        aqpa555hfunc,
                        aqpa555hplan,
                        aqpa555hcost,
                        aqpa555hprim,
                        aqpa555htasa,
                        aqpa555hstas,
                        aqpa555htcta,
                        aqpa555hncred,
                        aqpa555hntar,
                        aqpa555hfinpa,
                        aqpa555hfafil,
                        aqpa555hfdes,
                        aqpa555hhdes,
                        aqpa555hfven,
                        aqpa555hfcan,
                        aqpa555hcimp ,
                        aqpa555hmone,
                        aqpa555hctmov,
                        aqpa555hcant ,
                        aqpa555hhlegal,
                        --aqpa555hdcneg,---act
                        aqpa555hdgneg,--giro
                        aqpa555hddir, --dir
                        aqpa555hdubige,--ubigeo
                        aqpa555hdtinm, --tipo inmueble
                        aqpa555hdnum ,--numero
                        aqpa555hpai,
                        aqpa555hcseg,
                        aqpa555ha3,
                        aqpa555hdnpiso,
                        aqpa555hdnsota,
                        aqpa555hdfabri,
                        aqpa555hdcont,
                        aqpa555hdmate,
                        aqpa555hdtedi,
                        aqpa555hdcneg,
                        aqpa555hdsase,
                        aqpa555hdsaedi,
                        aqpa555hdsacon,
                        aqpa555ha1, --periodo
                        aqpa555ha2,
                  /*      aqpa555ha4,
                        aqpa555ha6,
                        aqpa555ha7,*/
                        aqpa555ha8)---nro cuotas
                 values(222,
                        a.aomod,
                        a.aosuc,
                        a.aomda,
                        a.aopap,
                        a.aocta,
                        a.aooper,
                        a.aosbop,
                        a.aotope,
                        p_fecha,
                        'B',
                        13,
                        49,
                        correlativo,
                        apepat,
                        apemat,
                        nombres,
                        razons,
                        numdoc,
                        doctipo,
                        lc_correo,
                        ecivil,
                        sexo,
                        fechanac,
                        lc_telefono,
                        ocupacion,--ocudomi,--OCUPACION,
                        ubigeo,
                        direcc,
                        certificado,
                        certificado, --numero solicitud
                        a.aosuc,
                        a.sucursal,
                        funcionario,
                        '00001',---'Plan de la compañia',
                        1,---costo,--'Costo = 1 plan de costo compañia',
                        prima,---'Prima', sacar de la 611
                        Tasa,
                        0,----'Sobretasa'/*,
                        '002',
                        a.nrocredito,
                        null, --numero tarjeta
                        a.fechavto, --ult pago
                        a.fechadesem, --f afiliacion
                        a.fechadesem,
                        'hora',
                        a.fechavto,
                        a.fechacan, --f cancelacion
                        a.monto,
                        a.moneda_cuenta,
                        'N',
                        null,
                        'N',
                         giro, --actdomi,--Giro,
                       --  ocudomi,--ocupacion,
                         dirdomi,--direccion_neg,
                         ubidomi, --ubigeo_neg,
                         'L',  --tipoinmueble
                         v_char22,--numero inm
                        pais,
                        a.seguro,
                        'N',
                        Nro_Piso,
                        Nro_Sotano,
                        A_Fabrica,
                        contenido,  -- caracterista del bien  A_Constru,
                        TIPOCONSTRUCCION,
                        uso,
                        codigo_giro,
                        a.monto, ---saldoasegurado,
                        Mto_Edif, --monto edificacion
                        saldoasegurado,
                        a.aoperiod,
                        plazo,
                     /*   descripcion,
                        nombrecod,
                        Equivalencia,*/
                        monedagar
                        ); -- dirdomi, ubidomi, actdomi, ocudomi
                       COMMIT;
   exception
     when dup_val_on_index then
       null;
   end ;
  end loop;---BAJAS
END SP_MULTIGARANTIA_TRAMA_ALTAS;

PROCEDURE SP_MULTIGARANTIA_TRAMA_COBROS(P_FECHA IN DATE) IS
 cursor pago (fecha1 in date, fecha2 in date)is
  select b.*,a.sgcod seguro,c.ppfpag fpago--,c.ppimp11 once,c.ppimp12 doce,c.ppimp13 trece, c.ppimp14 catorce
  from fpp001 a,
       fsd010 b,
       fsd602 c
 where b.pgcod = a.pgcod
   and b.aomod = a.aomod
   and b.aosuc = a.aosuc
   and b.aomda = a.aomda
   and b.aopap = a.aopap
   and b.aocta = a.aocta
   and b.aooper = a.aooper
   and b.aosbop = a.aosbop
   and b.aotope = a.aotope
   and b.AOFVAL > '01/07/2023'
--   and b.aostat <> 99
   and a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =10)
   and c.pgcod = b.pgcod
   and c.PPSUC = b.aosuc
   and c.PPMDA = b.aomda
   and c.PPPAP = b.aopap
   and c.PPCTA = b.aocta
   and c.PPOPER = b.aooper
   and c.PPSBOP = b.aosbop
   and c.PPTOPE = b.aotope
   and c.ppfpag  between fecha1 and fecha2;
--   and c.ppimp11 <> 0;
 /* select b.*,a.sgcod seguro,c.ppfpag fpago,c.ppimp11 once,c.ppimp12 doce,c.ppimp13 trece, c.ppimp14 catorce
  from fpp001 a,
       fsd010 b,
       fsd611 c
 where b.pgcod = a.pgcod
   and b.aomod = a.aomod
   and b.aosuc = a.aosuc
   and b.aomda = a.aomda
   and b.aopap = a.aopap
   and b.aocta = a.aocta
   and b.aooper = a.aooper
   and b.aosbop = a.aosbop
   and b.aotope = a.aotope
   and a.sgcod in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 = 10875 and tp1corr1 =9)
   and b.AOFVAL > '01/07/2023'
   and b.aostat <> 99
   and c.pgcod = b.pgcod
   and c.PPSUC = b.aosuc
   and c.PPMDA = b.aomda
   and c.PPPAP = b.aopap
   and c.PPCTA = b.aocta
   and c.PPOPER = b.aooper
   and c.PPSBOP = b.aosbop
   and c.PPTOPE = b.aotope
   and c.ppfpag  between fecha1 and fecha2
   and c.ppimp11 <> 0;*/

cursor cuota2 (fechaini in date, fechafin in date, cta in number, oper in number, sub in number) is
 select m.*
    from fsd602 m --, fsd612 n
   where m.pgcod = 1
     and m.ppcta = cta
     and m.ppoper = oper
     and m.ppsbop = sub
     and m.ppfpag between fechaini and fechafin
     and pp1stat  ='T'
     and m.d602cd = 1
     and m.d602co ='S';

ln_correl   number:= 0;
lc_numcert  varchar2(20);
ln_numerocuota number:= 0;
ln_pais number;
ln_tdoc number;
lc_numdoc char(12);
lc_numcre VARCHAR2(30);
fecha1 date;
contador number;
prima number(17,2);
imp11 number(17,2);
imp12 number(17,2);
imp13 number(17,2);
imp14 number(17,2);
imp15 number(17,2);
--suboper number;
once number(17,2);
doce number(17,2);
trece number(17,2);
catorce number(17,2);
quince number(17,2);
fechaUno date;
fechaDos date;
verifica number;

BajaSeg char(1);
dseg char(2);
codigoseguro number;
FlagExiste char(1);
Begin
  fechaUno := TRUNC(p_fecha, 'MM');
  fechaDos := last_day(p_fecha);

  Execute immediate ('truncate table aqpa557');

  For c in pago (fechaUno,fechaDos) loop
    ln_correl := ln_correl +1 ;
     -- datos cliente
     BEgin
        Select pepais, petdoc, pendoc
         into ln_pais, ln_tdoc, lc_numdoc
         from fsr008
        where pgcod = 1
          and ctnro = c.aocta
          and ttcod = 1
          and cttfir = 'T';
      exception
        when no_data_found then
          ln_pais := 0;
          ln_tdoc := 0;
          lc_numdoc:= null;
      end;
      lc_numcert := null;
      --- nro cuotas
      Begin
           select count(*)
             into ln_numerocuota
             from fsd601 x, fsd611 y
            where x.pgcod  = c.pgcod
              and x.ppmod = c.aomod
              and x.ppsuc = c.aosuc
              and x.ppmda = c.aomda
              and x.pppap = c.aopap
              and x.ppcta = c.aocta
              and x.ppoper = c.aooper
              and x.ppsbop = c.aosbop
              and x.pptope = c.aotope
              and x.ppfpag = c.fpago
              and y.pgcod = x.pgcod
              and y.ppmod =  x.ppmod
              and y.ppsuc = x.ppsuc
              and y.ppmda = x.ppmda
              and y.pppap = x.pppap
              and y.ppcta = x.ppcta
              and y.ppoper = x.ppoper
              and y.ppsbop = x.ppsbop
              and y.pptope = x.pptope
              and y.ppfpag <= x.ppfpag;
          exception
            when no_data_found then
              ln_numerocuota := 0;
          end;
      -- cantidad de seguros
      select count(*)
        into contador
        from fpp001
       where pgcod = c.pgcod
         and aomod = c.aomod
         and aosuc = c.aosuc
         and aomda = c.aomda
         and aopap = c.aopap
         and aocta = c.aocta
         and aooper = c.aooper
         and aosbop = c.aosbop---suboper
         and aotope = c.aotope ;
      -- Existe desgravamen--
      BEgin
        select distinct 'S'
          into FlagExiste
          from fpp001
         where pgcod = c.pgcod
           and aomod = c.aomod
           and aosuc = c.aosuc
           and aomda = c.aomda
           and aopap = c.aopap
           and aocta = c.aocta
           and aooper = c.aooper
           and aosbop = c.aosbop---suboper
           and aotope = c.aotope
           and sgcod  in (select h.sgcod from fst300 h where h.sgsn02 = '5'  );
       exception
         when no_data_found then
           FlagExiste := 'N';
       end;
      -------------------------------

          Begin
           select yy.ppimp11, yy.ppimp12, yy.ppimp13, yy.ppimp14, yy.ppimp15
             into once, doce,trece, catorce,quince
             from fsd601 x, fsd611 yy
            where x.pgcod  = c.pgcod
              and x.ppmod = c.aomod
              and x.ppsuc = c.aosuc
              and x.ppmda = c.aomda
              and x.pppap = c.aopap
              and x.ppcta = c.aocta
              and x.ppoper = c.aooper
              and x.ppsbop = c.aosbop
              and x.pptope = c.aotope
              and x.ppfpag = c.fpago
              and yy.pgcod = x.pgcod
              and yy.ppmod =  x.ppmod
              and yy.ppsuc = x.ppsuc
              and yy.ppmda = x.ppmda
              and yy.pppap = x.pppap
              and yy.ppcta = x.ppcta
              and yy.ppoper = x.ppoper
              and yy.ppsbop = x.ppsbop
              and yy.pptope = x.pptope
              and yy.ppfpag = x.ppfpag;
          exception
            when no_data_found then
              once := 0;
              doce := 0;
              trece := 0;
              catorce := 0;
              quince := 0;
          end;
    ----- validacion ---------
    Begin
      select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
        into BajaSeg,dseg, codigoseguro
        from fsd012
       where pgcod = 1
         and aomod = c.aomod
         and aosuc = c.aosuc
         and aomda = c.aomda
         and aopap = c.aopap
         and aocta = c.aocta
         and aooper = c.aooper
         and aosbop = c.aosbop
         and aotope = c.aotope
         and evfval between fechaUno and fechaDos
         and evtipo = 47
         and evcd02 = 'B'
         and d012co = 'S';
    exception
       when no_data_found then
         Begin
           select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = jaqa750seg),'1','VC','3','MV','4','SF','5','DG'),jaqa750seg
             into BajaSeg,dseg,codigoseguro
             from jaqa750
            where jaqa750emp = c.pgcod
              and jaqa750mod = c.aomod
              and jaqa750suc = c.aosuc
              and jaqa750mda = c.aomda
              and jaqa750pap = c.aopap
              and jaqa750cta = c.aocta
              and jaqa750ope = c.aooper
              and jaqa750sbo = c.aosbop
              and jaqa750top = c.aotope
              and jaqa750fec between fechaUno and fechaDos;
         exception
           when no_data_found then
             BajaSeg := 'N';
             dseg    :='00';
         end;
       when too_many_rows then
         Begin
            select distinct 'S', decode ((select sgsn02  from fst300 where sgcod = evcap),'1','VC','3','MV','4','SF','5','DG'),evcap
              into BajaSeg,dseg, codigoseguro
              from fsd012
             where pgcod = 1
               and aomod = c.aomod
               and aosuc = c.aosuc
               and aomda = c.aomda
               and aopap = c.aopap
               and aocta = c.aocta
               and aooper = c.aooper
               and aosbop = c.aosbop
               and aotope = c.aotope
               and evfval between fechaUno and fechaDos
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S'
                and evcap in (select tp1nro1 from fst198 where tp1cod = 1 and tp1cod1 =10875  and tp1corr1 = 4 and tp1nro2 =1 );
          exception
             when no_data_found then
               BajaSeg := 'N';
               dseg    :='00';
         end;
    end;
    if BajaSeg = 'S' and dseg ='VC' then
       contador := contador + 1;
    end if;
    --------------------------

        if contador = 2 then
          if FlagExiste = 'S' then
            prima := once;
          else
            prima := doce;
          end if;
        elsif contador = 3 then
            if FlagExiste = 'S' then
              prima:= doce;
            else
              prima:= trece;
            end if;
        elsif contador = 4 then
           if FlagExiste = 'S' then
              prima := trece;
           else
              prima := catorce;
           end if;
        elsif contador = 1 then
           if FlagExiste = 'S' then
               prima := 0;
           else
              prima:= once;
           end if;
        end if;

      ---Valida Pago
        For p in cuota2 (fechauno, fechados,c.aocta, c.aooper, c.aosbop )loop
          lc_numcert :=  lpad(c.aocta,10,'0') || lpad(c.aooper,10,'0');
          lc_numcre :=  lpad(c.aocta, 9, '0') || lpad(c.aomod, 3, '0') || lpad(c.aomda, 3, '0') || lpad(c.aooper, 9, '0') ||lpad(c.aotope, 3, '0'); --- to_char(LPAD(P.PPCTA,  9, '0') ||LPAD(P.PPOPER, 9, '0') ||LPAD(P.PPSBOP, 3, '0'));
          fecha1 := c.fpago;
          Begin
           select sum(y.pp1imp11), sum(y.pp1imp12),sum(y.pp1imp13), sum(y.pp1imp14),sum(y.pp1imp15)
             into imp11,imp12,imp13,imp14,imp15
             from fsd612 y
            where y.pgcod = p.pgcod
              and y.ppmod = p.ppmod
              and y.ppsuc = p.ppsuc
              and y.ppmda = p.ppmda
              and y.pppap = p.pppap
              and y.ppcta = p.ppcta
              and y.ppoper = p.ppoper
              and y.ppsbop = p.ppsbop
              and y.pptope = p.pptope
              and y.ppfpag = p.ppfpag
              and y.pptipo = p.pptipo
              and y.pp1nump = p.pp1nump ;
          exception
            when no_data_found then
              imp11 := 0;
              imp12 := 0;imp13 := 0;imp14 := 0;imp15:= 0;
          end;
           if contador = 2 then
             if FlagExiste = 'S' then  --Existe desgravamen
               if prima = imp11 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             else ---No existe desgravamen
               if prima = imp12 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             end if;
          elsif contador = 3 then
            if FlagExiste = 'S' then
               if prima = imp12 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             else
               if prima = imp13 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
             end if;
          elsif contador = 4 then
            if FlagExiste = 'S' then
               if prima = imp13 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
            else
              if prima = imp14 then
                 verifica := 0;
               else
                 verifica := 1;
               end if;
            end if;
          elsif contador = 1 then
            if FlagExiste = 'S' then
               verifica := 1;
            else
              if prima = imp11 then
                verifica := 0;
               else
                 verifica := 1;
               end if;
            end if;
          end if;
       -------------------------------------------------------
           begin
      insert into aqpa557(aqpa557cod,
                          aqpa557mod,
                          aqpa557suc,
                          aqpa557mda,
                          aqpa557pap,
                          aqpa557cta,
                          aqpa557ope,
                          aqpa557sbo,
                          aqpa557tip,
                          aqpa557fep,
                          aqpa557canal,
                          aqpa557cprod,
                          aqpa557corr ,
                          aqpa557cert,
                          aqpa557ncuo,
                          aqpa557ndoc,
                          aqpa557tdoc,
                          aqpa557tcta,
                          aqpa557ncre,
                          aqpa557prim,
                          aqpa557fech,
                          aqpa557pais,
                          aqpa557a3,
                          aqpa557a1 )
                   values(999,
                          c.aomod,
                          c.aosuc,
                          c.aomda,
                          c.aopap,
                          c.aocta,
                          c.aooper,
                          c.aosbop,
                          c.aotope,
                          p_fecha,
                          13,
                          49,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          prima,
                          c.fpago,
                          ln_pais,
                          'N',
                          verifica);
        commit;
      exception
        when dup_val_on_index then
          null;
      end;

      begin
      insert into aqpa557H(aqpa557Hcod,
                          aqpa557Hmod,
                          aqpa557Hsuc,
                          aqpa557Hmda,
                          aqpa557Hpap,
                          aqpa557Hcta,
                          aqpa557Hope,
                          aqpa557Hsbo,
                          aqpa557Htip,
                          aqpa557Hfep,
                          aqpa557Hcanal,
                          aqpa557Hcprod,
                          aqpa557Hcorr ,
                          aqpa557Hcert,
                          aqpa557Hncuo,
                          aqpa557Hndoc,
                          aqpa557Htdoc,
                          aqpa557Htcta,
                          aqpa557Hncre,
                          aqpa557Hprim,
                          aqpa557Hfech,
                          aqpa557Hpais,
                          aqpa557Ha3,
                          aqpa557ha1 )
                   values(999,
                          c.aomod,
                          c.aosuc,
                          c.aomda,
                          c.aopap,
                          c.aocta,
                          c.aooper,
                          c.aosbop,
                          c.aotope,
                          p_fecha,
                          13,
                          49,
                          ln_correl,
                          lc_numcert,
                          ln_numerocuota,
                          lc_numdoc,
                          ln_tdoc,
                          '002',
                          lc_numcre,
                          prima,
                          c.fpago,
                          ln_pais,
                          'N',
                          verifica);
        commit;
      exception
        when dup_val_on_index then
          null;
      end;

    end loop;
  end loop;
END SP_MULTIGARANTIA_TRAMA_COBROS;

end PQ_CR_MULTIRIESGO_MOVI;
/

