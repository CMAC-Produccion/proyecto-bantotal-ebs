create or replace procedure SP_CR_INSERTA_DESMPLEO(p_cuenta    in number,
                                                   p_fecha     in date,
                                                   p_tipo      in number) --- tipo de incidencia
  -- *****************************************************************
  -- Nombre                     : SP_CR_INSERTA_DESMPLEO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/02/2025
  -- Autor de Creación          : SILVIA MARQUEZ
  -- Uso                        : INSERTA REGISTRO EN LA TABLA AQPA562
  --                              PARA SU POSTERIOR PROCESAMIENTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : CUENTA / FECHA /TIPO 1 REGNORMAL 2/REGINCONCLUSO
  -- *****************************************************************
is
    cursor uno is
     select  a.hcta, a.HCIMP1
          from fsh016 a,
               fsh015 b
         where a.pgcod = 1
           and a.hcmod = 30
           and a.htran = 441
           and a.hrubro = 2514020000022
           and a.hcta = p_cuenta
           and a.hfcon = p_fecha
           and b.pgcod = a.pgcod
           and b.hsucor = a.hsucor
           and b.hcmod = a.hcmod
           and b.htran = a.htran
           and b.hnrel = a.hnrel
           and b.hfcon = a.hfcon
           and b.hccorr = 0;--- order by a.hcta

   CURSOR datos(cta in number) IS
   select jb.jaqm66per periodo, jc.xwfplazo1 plazo1, jc.xwffec1 fechaxwf, jc.xwfoperacion operacion, jc.xwfmodulo mod1,
          jc.xwfsucursal suc1, jc.xwfsubope subop1, jc.xwftipope tipo1 ,jc.xwfmoneda mda1,jc.xwfprcins instancia,
               (select jaqm64por  from jaqm64 where jaqm64tad =ja.jaqm65tad and jaqm64cod =  ja.jaqm65cod) CTASA,
                 jb.jaqm66imp saldoasegurado, jb.jaqm66ime costo,ja.jaqm65cod plan1
          from jaqm65 ja, xwf700 jc, jaqm66 jb --,
         where ja.jaqm65tad = 2
           and ja.jaqm65ac1 = 'C'
           and jb.jaqm66ins = ja.jaqm65ins
           and jc.xwfprcins = jb.jaqm66ins
           and jc.xwfcar3 = '1'
           and jc.xwfcuenta = cta;

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

   CURSOR CUENTAS IS         
     select sccta hcta, scsdo HCIMP1 
       from fsd011 where sccta = p_cuenta 
        and scrub = 2514020000022;

   CURSOR datos1(cta in number, importe in number) IS
   select jb.jaqm66per periodo, jc.xwfplazo1 plazo1, jc.xwffec1 fechaxwf, jc.xwfoperacion operacion, jc.xwfmodulo mod1, 
          jc.xwfsucursal suc1, jc.xwfsubope subop1, jc.xwftipope tipo1 ,jc.xwfmoneda mda1,jc.xwfprcins instancia,
          (select jaqm64por  from jaqm64 where jaqm64tad =ja.jaqm65tad and jaqm64cod =  ja.jaqm65cod) CTASA,
            jb.jaqm66imp saldoasegurado, jb.jaqm66ime costo,ja.jaqm65cod plan1  
          from jaqm65 ja, 
               xwf700 jc, 
               jaqm66 jb 
         where ja.jaqm65tad = 2
           and ja.jaqm65tim = importe
           and jb.jaqm66ins = ja.jaqm65ins
           and jb.JAQM66IME = ja.jaqm65tim 
           and ja.jaqm65ins = jc.xwfprcins                      
           and jc.xwfprcins = jb.jaqm66ins
           and jc.xwfcar3 = '1'
           and jc.xwfprcins =(select xwfprcins from xwf700 where xwfcuenta = p_cuenta and xwfcar3 = '1');
    
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
  dIRECCION_neg char(300);
  ubigeo_neg char(8);
  tasa number(10,6):=0;
  costo number(17,2):=0;
  nrocuota number:= 0;

  dirdomi char(300);
  ubidomi char(8);
  actdomi char(300);
  ocudomi char(50);
  v_num1 number;
  v_num2 number;
  v_char1 char(200);
  v_char2 char(10);
  v_resul number:= 0;
  tipo_via char(1);
  direccion1 char(300);
  USO char(1);
  tipoconstruccion char(1);
  Nro_Piso char(10);
  Nro_Sotano char(10);
  A_Fabrica char(10);
  A_Constru char(10);
  contenido char(1000);
  codigo_giro number:=0;
  saldoasegurado number(17,2):= 0;
  papel number:=0;
  periodo number:=0;
  plazo1 number;
  fechaxwf date;
  mod1 number;
  suc1 number;
  subop1 number;
  tipo1 number;
  mda1 number;
  instancia number;
  CTASA number(10,6);
  fechades date;
  fechavto date;
  fechades1 varchar2(8);
  fechavto1 varchar2(8);
  nrocredito char(30);
  moneda varchar2(3);
  nro_cuotas  number;
  segmento char(1);
  codigocia number;
  plan1 number;
begin
  if p_tipo = 1 then
    For a in uno loop
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
        --- dbms_output.put_line(a.hcta);
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
             from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' ),
          (select trim(sngc13ugeo)
             from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' )

          into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
           from fsd002 d
           inner join fsr008 e
                   on e.pepais = d.pfpais
                  and e.petdoc = d.pftdoc
                  and e.pendoc = d.pfndoc
                where e.ctnro = a.hcta
                  and e.ttcod = 1
                  and e.cttfir ='T';
      --     dbms_output.put_line( apepat||';'|| apemat||';'|| nombres||';'|| sexo||';'||ecivil||';'||fechanac||';'||pais||';'||tipodoc||';'||tipodocA||';'|| numdoc||';'|| direcc||';'||ubigeo );
      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,299))
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )
               into razons,pais,tipodoc,tipodocA, numdoc, direcc
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.hcta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      --- segmento persona /codigo servicio
      BEgin
      select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
        into segmento
        from  sngc60
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = 0  ;
      exception
        when others then
          segmento := 'I';
      end;
      if segmento = 'I' then
        codigocia:= 51;
      else
        codigocia :=50;
     end if;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := trim(tele)||' '||trim(t.fono);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);

   --    dbms_output.put_line( lc_telefono);

       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||' '||trim(c.mail)),1,50);
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
 --       dbms_output.put_line( ocupacion||';'|| giro||';'|| codigo_giro);
      exception
        when no_data_found then
          giro:= null;
          ocupacion:= null;
      end;
      PAPel := 0;
  --    funcionario := FN_ANALISTA_CREDITO(MOD1, SUC1, MDA1, PAPel, a.hcta, operacion, subop1, tipo1);
      nrocuota := 1;
     -- costo :=  (a.itimp1*100)/ctasa;
      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;

      begin
        select TRim(sngc13dir), -- direccion
               sngc13ugeo
           into dirdomi, ubidomi --,  ocudomi,actdomi
          from sngc13
         where sngc13pais = pais
           and sngc13tdoc = tipodoc
           and sngc13ndoc = numdoc
           and sngc13est='H'
           and docod =1;
      exception
        when no_data_found then
          dirdomi:= direcc;
          ubidomi :='0';
      end;

      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      if v_num2 = 0 then
        select instr(v_char1,'-') into v_num2 from dual;
      end if;
      if v_num2 = 0 then
        v_num2 := 4;
      end if;
      select substr(trim(substr(v_char1,1,v_num2)),1,10) into v_char2 from dual;
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

       for j in datos(a.hcta) loop
            nro_cuotas := 0 ;
          select count(*) into nro_cuotas
            from fsd601
           where pgcod = 1
             and ppmod =  j.mod1
             and ppsuc =  j.suc1
             and ppmda = j.mda1
             and pppap = 0
             and ppcta = a.hcta
             and ppoper = j.operacion
             and ppsbop = j.subop1
             and pptope = j.tipo1;
           BEgin
            select to_char(aofval,'yyyymmdd'), to_char(aofvto,'yyyymmdd'), (lpad(aocta,9,'0') || lpad(aooper,9,'0')),
                  (select scnom from fst001 where sucurs = aosuc)
             into fechades1,fechavto1, nrocredito, sucursal
             from fsd010 where pgcod = 1 and aocta =  a.hcta and aooper = j.operacion and aosbop = j.subop1 and aomod = j.mod1;
          Exception
            when no_data_found then
              fechades1:=null;
              fechavto1:= null;
          end;

          select max(aqpa562corr) into correlativo from aqpa562;

          correlativo := correlativo + 1;
          certificado := lpad(a.hcta, 10, '0') ||
                         lpad(j.operacion, 10, '0');

           select sng001ase
             into funcionario
             from sng001 --Cambiar la tabla para producción
            where sng001inst = j.instancia;


           dbms_output.put_line (1||';'||j.mod1||';'||j.suc1||';'||j.mda1||';'||papel||';'||a.hcta||';'||j.operacion||';'||j.subop1||';'||j.tipo1||';'||p_fecha||';'||'A'||';'||13||';'||codigocia||';'||correlativo||';'||trim(apepat)||';'||trim(apemat)||';'||trim(nombres)||';'||trim(razons)||';'||numdoc||';'||doctipo||';'||trim(lc_correo)||';'||ecivil||';'||sexo||';'||fechanac||';'|| trim(lc_telefono)||';'||trim(ocupacion)||';'||ubigeo||';'||trim(direcc)||';'||certificado||';'||certificado||';'||j.suc1||';'||trim(sucursal)||';'||funcionario||';'||j.plan1||';'||1||';'||a.hcimp1||';'|| j.cTasa||';'||0||';'||'016'||';'||nrocredito||';'||' '||';'||fechavto1||';'|| fechades1||';'||  fechades1||';'||'00:00'||';'||fechavto1||';'||' '||';'|| j.saldoasegurado||';'||'001'||';'||'N'||';'||' '||';'||'N'||';'||'L'||';'||';'||trim(codigo_giro)||';'||trim(giro)||';'||trim(dirdomi)||';'||v_char2||';'||';'||';'||';'||';'||trim(ubidomi)||';'||';'||';'||000||';'||';'||Nro_Piso||';'||Nro_Sotano||';'||trim(A_Fabrica)||';'||trim(contenido)||';'||';'||';'||';'||j.saldoasegurado||';'||';'||j.saldoasegurado||';'||pais||';'||';'||nro_cuotas||';'||nro_cuotas||';'||'N');
      
          begin
            insert into aqpa562(aqpa562cod,
                                aqpa562mod,
                                aqpa562suc,
                                aqpa562mda,
                                aqpa562pap,
                                aqpa562cta,
                                aqpa562ope,
                                aqpa562sbo,
                                aqpa562tip,
                                aqpa562fec,
                                aqpa562mov,
                                aqpa562canal,
                                aqpa562cpro,
                                aqpa562corr,
                                aqpa562apat,
                                aqpa562amat,
                                aqpa562nom,
                                aqpa562rsoc,
                                aqpa562ndo,
                                aqpa562tdo,
                                aqpa562mail,
                                aqpa562eciv,
                                aqpa562sexo,
                                aqpa562fnac,
                                aqpa562cel ,
                                aqpa562ocup,
                                aqpa562ubig,
                                aqpa562dire,
                                aqpa562ncert,
                                aqpa562nsol,
                                aqpa562cage,
                                aqpa562ades,
                                aqpa562func,
                                aqpa562plan,
                                aqpa562cost,
                                aqpa562prim,
                                aqpa562tasa,
                                aqpa562stas,
                                aqpa562tcta,
                                aqpa562ncred,
                                aqpa562ntar,
                                aqpa562finpa,
                                aqpa562fafil,
                                aqpa562fdes,
                                aqpa562hdes,
                                aqpa562fven,
                                aqpa562fcan,
                                aqpa562cimp ,
                                aqpa562mone,
                                aqpa562ctmov,
                                aqpa562cant ,
                                aqpa562hlegal,
                                --aqpa562dcneg,---act
                                aqpa562dgneg,--giro
                                aqpa562ddir, --dir
                                aqpa562dubige,--ubigeo
                                aqpa562dtinm, --tipo inmueble
                                aqpa562dnum ,--numero
                                aqpa562pai,
                                aqpa562cseg,
                                aqpa562a3,
                                aqpa562dnpiso,
                                aqpa562dnsota,
                                aqpa562dfabri,
                                aqpa562dcont,
                                aqpa562dmate,
                                aqpa562dtedi,
                                aqpa562dcneg,
                                aqpa562dsase ,
                                aqpa562dsacon,
                                aqpa562a1 )
                         values(1,
                                j.mod1,
                                j.suc1,
                                j.mda1,
                                papel,
                                a.hcta,
                                j.operacion,
                                j.subop1,
                                j.tipo1,
                                p_fecha,
                                'A',
                                13,
                                codigocia,--50,51
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
                                fechanac, --fecha nacimiento
                                lc_telefono,
                                ocupacion,--ocudomi,--OCUPACION,
                                ubigeo,
                                direcc,
                                certificado,
                                certificado, --numero solicitud
                                j.suc1,
                                sucursal,
                                funcionario,
                                j.plan1,---'Plan',
                                1,--'Costo', sacar de la 611
                                a.hcimp1,---prima,---'Prima', sacar de la 611
                                j.cTasa,
                                0,----'Sobretasa'/*,
                                '016',
                                nrocredito,
                                null, --numero tarjeta
                                fechavto1, --ult pago
                                fechades1, --f afiliacion
                                fechades1,
                                '00:00', --hora
                                fechavto1,
                                null, --f cancelacion
                                j.saldoasegurado, --a.monto,
                                moneda, ---moneda_cuenta,
                                'N',
                                null,
                                'N',
                                 giro, --actdomi,--Giro,
                                 dirdomi,--direccion_neg,
                                 ubidomi, --ubigeo_neg,
                                 'L',  --tipoinmueble
                                 v_char2,--numero inm
                                pais,
                                000,--seguro
                                'N',
                                Nro_Piso,
                                Nro_Sotano,
                                A_Fabrica,
                                contenido,  -- caracterista del bien  A_Constru,
                                TIPOCONSTRUCCION,
                                uso,
                                codigo_giro,
                                j.saldoasegurado,
                                j.saldoasegurado,
                                nro_cuotas
                               ); -- dirdomi, ubidomi, actdomi, ocudomi
                               COMMIT;
           exception
             when dup_val_on_index then
               null;
           end ;
     end loop;
   end loop;
  end if;
  if p_tipo = 2 then
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
         certificado := null;
         --pfecha := '27/11/2024';
      --   dbms_output.put_line(a.hcta);
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
          (select trim(substr(sngc13dir,1,299))
             from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' ),
          (select trim(sngc13ugeo)
             from sngc13 where sngc13pais = d.pfpais and sngc13tdoc= d.pftdoc and sngc13ndoc = d.pfndoc and docod = 1   and sngc13est ='H' )

          into apepat, apemat, nombres, sexo,ecivil,fechanac,pais,tipodoc,tipodocA, numdoc, direcc,ubigeo
           from fsd002 d
           inner join fsr008 e
                   on e.pepais = d.pfpais
                  and e.petdoc = d.pftdoc
                  and e.pendoc = d.pfndoc
                where e.ctnro = a.hcta
                  and e.ttcod = 1
                  and e.cttfir ='T';
      --     dbms_output.put_line( apepat||';'|| apemat||';'|| nombres||';'|| sexo||';'||ecivil||';'||fechanac||';'||pais||';'||tipodoc||';'||tipodocA||';'|| numdoc||';'|| direcc||';'||ubigeo );       
      exception
        when no_data_found then
          Begin
             select Trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,299))
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )
               into razons,pais,tipodoc,tipodocA, numdoc, direcc
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.ctnro = a.hcta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      --- segmento persona /codigo servicio
      BEgin
      select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
        into segmento
        from  sngc60 
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = ( select max(sngc60corr)                             
                              from  sngc60 
                             where sngc60pais = pais
                               and sngc60tdoc = tipodoc
                               and sngc60ndoc = numdoc)  ;
      exception
        when others then
          segmento := 'I';
      end;   
      if segmento = 'I' then
        codigocia:= 51;
      else
        codigocia :=50;
     end if;
      
      --------------------------------------------------
      
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         if ln_cont = 0 then
            tele := trim(t.fono);
          else
            tele := trim(tele)||' '||trim(t.fono);
          end if;
         ln_cont := ln_cont + 1;
      end loop;
      lc_telefono := substr(tele,1,50);
      
   --    dbms_output.put_line( lc_telefono);
      
       For c in correo(pais,tipodoc,numdoc)loop
          if ln_cont1 = 0 then
            mail := trim(c.mail);
          else
            mail := substr((trim(mail)||' '||trim(c.mail)),1,50);
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
     --  dbms_output.put_line( ocupacion||';'|| giro||';'|| codigo_giro);      
           
      exception
        when no_data_found then
          giro:= null;
          ocupacion:= null;
      end;
  
 
     
    
      
      PAPel := 0;
  --    funcionario := FN_ANALISTA_CREDITO(MOD1, SUC1, MDA1, PAPel, a.hcta, operacion, subop1, tipo1);  
      
 
      nrocuota := 1;
     -- costo :=  (a.itimp1*100)/ctasa;

      
      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;

      begin
        select TRim(sngc13dir), -- direccion
               sngc13ugeo
           into dirdomi, ubidomi --,  ocudomi,actdomi               
          from sngc13
         where sngc13pais = pais 
           and sngc13tdoc = tipodoc    
           and sngc13ndoc = numdoc
           and sngc13est='H' 
           and docod =1;
      exception
        when no_data_found then
          dirdomi:= direcc;
          ubidomi :='0';
      end;
      
      select REGEXP_INSTR( dirdomi,'[0-9]') into v_num1 from dual;
      select trim( substr(dirdomi,v_num1)) into v_char1 from dual;
      select instr(v_char1,' ') into v_num2 from dual;
      if v_num2 = 0 then
        select instr(v_char1,'-') into v_num2 from dual;
      end if;
      if v_num2 = 0 then
        v_num2 := 4;
      end if; 
      select substr(trim(substr(v_char1,1,v_num2)),1,10) into v_char2 from dual;
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
      
       for j in datos(a.hcta) loop
            nro_cuotas := 0 ;
          select count(*) into nro_cuotas 
            from fsd601
           where pgcod = 1
             and ppmod =  j.mod1 
             and ppsuc =  j.suc1
             and ppmda = j.mda1
             and pppap = 0
             and ppcta = a.hcta
             and ppoper = j.operacion
             and ppsbop = j.subop1
             and pptope = j.tipo1;
           BEgin
            select to_char(aofval,'yyyymmdd'), to_char(aofvto,'yyyymmdd'), (lpad(aocta,9,'0') || lpad(aooper,9,'0')),
                  (select scnom from fst001 where sucurs = aosuc)
             into fechades1,fechavto1, nrocredito, sucursal
             from fsd010 where pgcod = 1 and aocta =  a.hcta and aooper = j.operacion and aosbop = j.subop1 and aomod = j.mod1;
          Exception
            when no_data_found then
              fechades1:=null;
              fechavto1:= null;
          end; 
       
          select max(aqpa562corr) into correlativo from aqpa562;
          
          correlativo := correlativo + 1;
          certificado := lpad(a.hcta, 10, '0') ||
                         lpad(j.operacion, 10, '0');
          
           select sng001ase
             into funcionario
             from sng001 --Cambiar la tabla para producción
            where sng001inst = j.instancia;

      
           dbms_output.put_line (1||';'||j.mod1||';'||j.suc1||';'||j.mda1||';'||papel||';'||a.hcta||';'||j.operacion||';'||j.subop1||';'||j.tipo1||';'||p_fecha||';'||'A'||';'||13||';'||codigocia||';'||correlativo||';'||apepat||';'||apemat||';'||nombres||';'||razons||';'||numdoc||';'||doctipo||';'||lc_correo||';'||ecivil||';'||sexo||';'||fechanac||';'|| lc_telefono||';'||ocupacion||';'||ubigeo||';'||direcc||';'||certificado||';'||certificado||';'||j.suc1||';'||sucursal||';'||funcionario||';'||j.plan1||';'||1||';'||a.hcimp1||';'|| j.cTasa||';'||0||';'||'016'||';'||nrocredito||';'||null||';'||fechavto1||';'|| fechades1||';'||  fechades1||';'||'00:00'||';'||fechavto1||';'||null||';'|| j.saldoasegurado||';'||'001'||';'||'N'||';'||null||';'||'N'||';'||'L'||';'||';'||codigo_giro||';'||giro||';'|| dirdomi||';'||v_char2||';'||';'||';'||';'||';'||ubidomi||';'||';'||';'||000||';'||';'||Nro_Piso||';'||Nro_Sotano||';'||A_Fabrica||';'||contenido||';'||';'||';'||';'||j.saldoasegurado||';'||';'||j.saldoasegurado||';'||pais||';'||';'||nro_cuotas||';'||nro_cuotas||';'||'N');      

          begin
            insert into aqpa562(aqpa562cod,
                                aqpa562mod,
                                aqpa562suc,
                                aqpa562mda,
                                aqpa562pap,
                                aqpa562cta,
                                aqpa562ope,
                                aqpa562sbo,
                                aqpa562tip,
                                aqpa562fec,
                                aqpa562mov,
                                aqpa562canal,
                                aqpa562cpro,
                                aqpa562corr,
                                aqpa562apat,
                                aqpa562amat,
                                aqpa562nom,
                                aqpa562rsoc,
                                aqpa562ndo,
                                aqpa562tdo,
                                aqpa562mail,
                                aqpa562eciv,
                                aqpa562sexo,
                                aqpa562fnac,
                                aqpa562cel ,
                                aqpa562ocup,
                                aqpa562ubig,
                                aqpa562dire,
                                aqpa562ncert,
                                aqpa562nsol,
                                aqpa562cage,
                                aqpa562ades,
                                aqpa562func,
                                aqpa562plan,
                                aqpa562cost,
                                aqpa562prim,
                                aqpa562tasa,
                                aqpa562stas,
                                aqpa562tcta,
                                aqpa562ncred,
                                aqpa562ntar,
                                aqpa562finpa,
                                aqpa562fafil,
                                aqpa562fdes,
                                aqpa562hdes,
                                aqpa562fven,
                                aqpa562fcan,
                                aqpa562cimp ,
                                aqpa562mone,
                                aqpa562ctmov,
                                aqpa562cant ,
                                aqpa562hlegal,
                                --aqpa562dcneg,---act
                                aqpa562dgneg,--giro
                                aqpa562ddir, --dir
                                aqpa562dubige,--ubigeo
                                aqpa562dtinm, --tipo inmueble
                                aqpa562dnum ,--numero
                                aqpa562pai,
                                aqpa562cseg,
                                aqpa562a3,
                                aqpa562dnpiso,
                                aqpa562dnsota,
                                aqpa562dfabri,
                                aqpa562dcont,
                                aqpa562dmate,
                                aqpa562dtedi,
                                aqpa562dcneg,
                                aqpa562dsase ,
                                aqpa562dsacon,
                                aqpa562a1 )
                         values(1,
                                j.mod1,
                                j.suc1,
                                j.mda1,
                                papel,
                                a.hcta,
                                j.operacion,
                                j.subop1,
                                j.tipo1,
                                p_fecha,
                                'A',
                                13,
                                codigocia,--50,51
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
                                fechanac, --fecha nacimiento
                                lc_telefono,
                                ocupacion,--ocudomi,--OCUPACION,
                                ubigeo,
                                direcc,
                                certificado,
                                certificado, --numero solicitud
                                j.suc1,
                                sucursal,
                                funcionario,
                                j.plan1,---'Plan',
                                1,--'Costo', sacar de la 611
                                a.hcimp1,---prima,---'Prima', sacar de la 611
                                j.cTasa,
                                0,----'Sobretasa'/*,
                                '016',
                                nrocredito,
                                null, --numero tarjeta
                                fechavto1, --ult pago
                                fechades1, --f afiliacion
                                fechades1,
                                '00:00', --hora
                                fechavto1,
                                null, --f cancelacion
                                j.saldoasegurado, --a.monto,
                                moneda, ---moneda_cuenta,
                                'N',
                                null,
                                'N',
                                 giro, --actdomi,--Giro,
                                 dirdomi,--direccion_neg,
                                 ubidomi, --ubigeo_neg,
                                 'L',  --tipoinmueble
                                 v_char2,--numero inm
                                pais,
                                000,--seguro
                                'N',
                                Nro_Piso,
                                Nro_Sotano,
                                A_Fabrica,
                                contenido,  -- caracterista del bien  A_Constru,
                                TIPOCONSTRUCCION,
                                uso,
                                codigo_giro,
                                j.saldoasegurado,
                                j.saldoasegurado,
                                nro_cuotas
                               ); -- dirdomi, ubidomi, actdomi, ocudomi
                               COMMIT;
           exception
             when dup_val_on_index then
               null;
           end ;      
     end loop;    
    end loop; 
  end if;
  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_CR_INSERTA_DESMPLEO',
     p_cuenta || '-' ||p_fecha || '-' ||p_tipo);
  commit;
end;
/

