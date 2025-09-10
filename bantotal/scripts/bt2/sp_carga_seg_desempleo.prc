create or replace procedure "SP_CARGA_SEG_DESEMPLEO"(pfecha in date) is

-- Modificacion : SMARQUEZ 23/12/2024 carga servicio controles de duplicados
-- Modificacion : SMARQUEZ 27/12/2024 modificacion de codigo de producto de DESEMPLEO
-- Modificacion : SMARQUEZ 23/01/2025, modificacion para carga incompleta
-- Modificacion : SMARQUEZ 19/03/2025, modificacion too_many_rows
-- Modificacion : SMARQUEZ 15/04/2025, Verifica Resagados

  CURSOR CUENTAS IS
      select a.*, b.itfcon fechacont, b.ithora hora, c.jaqm66ins ins
      from fsd016 a,
           fsd015 b,
           jaqm66 c      
     where a.pgcod = 1
       and a.itmod =30 
       and a.ittran =441
       and a.rubro = 2514020000022       
    --------   and a.ctnro = 4904312pruebas       
       and b.pgcod = a.pgcod
       and b.itsuc = a.itsuc
       and b.itmod = a.itmod
       and b.ittran = a.ittran
       and b.itnrel = a.itnrel
       and b.itcorr = 0
       and b.itcont ='S'
     --------- SMA.19032
       and c.jaqm66cta = a.CTNRO --SMA.190325
       and c.jaqm66fea = b.ITFCON       
       and c.JAQM66HOR = b.ithora
       ;
    
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
           
      cursor resagados (fecha1 in date)is
       select sccta hcta, scsdo HCIMP1 
         from fsd011 where sccta not in (select aqpa562cta from aqpa562)
          and scrub = 2514020000022
          and scfcon = fecha1;  

      CURSOR datos(cta in number) IS
       select jb.jaqm66per periodo, jc.xwfplazo1 plazo1, jc.xwffec1 fechaxwf, jc.xwfoperacion operacion, jc.xwfmodulo mod1, 
              jc.xwfsucursal suc1, jc.xwfsubope subop1, jc.xwftipope tipo1 ,jc.xwfmoneda mda1,jc.xwfprcins instancia,
               (select jaqm64por  from jaqm64 where jaqm64tad =ja.jaqm65tad and jaqm64cod =  ja.jaqm65cod) CTASA,
                 jb.jaqm66imp saldoasegurado, jb.jaqm66ime costo,ja.jaqm65cod plan1              
                
          from jaqm65 ja, 
               xwf700 jc, jaqm66 jb 
         where ja.jaqm65tad = 2
           and ja.jaqm65ac1 = 'C'
           and ja.jaqm65ins = jc.xwfprcins 
           and jb.jaqm66ins = ja.jaqm65ins           
           and jc.xwfprcins = jb.jaqm66ins -- select * from xwf700 where xwfcuenta = 2484590                  
           and jc.xwfcar3 = '1'
           and jc.xwfprcins = (select max(xwfprcins) from xwf700 where xwfcuenta = cta and xwfprcins = jb.jaqm66ins) ; 

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
  plandes number;
  
  segmento char(1);
  codigocia number;
  
  ln_pgcod number;
  ln_grupo number;
  lc_plan  char(50);
  ln_tip   char(30);
  ln_instancia number;
  tipocuenta char(3);
  fecha date;
  begin

    Execute immediate ('truncate table aqpa562');
    Begin
      select pgfape into fecha
        from fst017 where  pgcod = 1;
    exception
      when no_data_found then
        fecha := trunc(sysdate);
    end;
    
  
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
                where e.pgcod = 1
                  and e.ctnro = a.ctnro
                  and e.ttcod = 1
                  and e.cttfir ='T'
                  and rownum = 1;
      exception
        when no_data_found then
          Begin
             select trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,100))
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )
               into razons,pais,tipodoc,tipodocA, numdoc, direcc
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.pgcod = 1
                and e.ctnro = a.ctnro
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      -- telefono y correo smarquez 17102019
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
       --  if ln_cont = 0 then
            tele := trim(t.fono);
         /* else
            tele := trim(tele)||' '||trim(t.fono);
          end if;
         ln_cont := ln_cont + 1;*/
      end loop;
      if tele is null or tele =' ' then
        tele :=111111111;
      end if;
      lc_telefono := substr(tele,1,15);
       For c in correo(pais,tipodoc,numdoc)loop
        --  if ln_cont1 = 0 then
            mail := trim(c.mail);
          /*else
            mail := substr((trim(mail)||' '||trim(c.mail)),1,50);
          end if;

         ln_cont1 := ln_cont1 + 1;*/
      end loop;
       if lc_correo is null then
         lc_correo:= 'sindato@gmail.com';
       else
         lc_correo := substr(mail,1,50);
       end if;
      begin
        select
        (SELECT trim(substr(A1.AQPA558ACT,1,50)) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = ctnroi
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),         
            (SELECT Trim(substr(A1.AQPA558DGIRO,1,300)) FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = ctnroi
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 ),
             (SELECT A1.AQPA558cod FROM FST198 F1, AQPA558 A1 WHERE F1.TP1COD = 1
            AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = ctnroi
            AND A1.AQPA558COD = trunc(F1.TP1IMP1) and rownum = 1 )
          into ocupacion,
               giro,
               codigo_giro
          from fsd008 
         where pgcod = 1
           and ctnro = a.ctnro;
      exception
        when no_data_found then
           beGIN
              select 
                  (SELECT trim(substr(A1.AQPA558ACT,1,50))
                     FROM FST198 F1, AQPA558 A1 
                    WHERE F1.TP1COD = 1 
                      AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = ctnroi 
                      AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ), 
                  (SELECT Trim(substr(A1.AQPA558DGIRO,1,300))
                     FROM FST198 F1, AQPA558 A1 
                    WHERE F1.TP1COD = 1 
                      AND F1.TP1COD1=10884 
                      AND F1.TP1CORR1 =66 
                      AND F1.TP1NRO1 = ctnroi 
                      AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) ),
                   (SELECT A1.AQPA558cod 
                      FROM FST198 F1, AQPA558 A1 
                     WHERE F1.TP1COD = 1 
                       AND F1.TP1COD1=10884 AND F1.TP1CORR1 =66 AND F1.TP1NRO1 = ctnroi 
                       AND A1.AQPA558COD = TRUNC(F1.TP1IMP1) )
                into ocupacion,
                     giro,
                     codigo_giro
                 from fsd008 
                where pgcod = 1
                  and ctnro = a.ctnro;
            exception
              when no_data_found then
                giro:= null;
                ocupacion:= null;
            end;
      end;

   
    
      Begin
        select jb.jaqm66per, jc.xwfplazo1, jc.xwffec1, jc.xwfoperacion, jc.xwfmodulo, jc.xwfsucursal,
               jc.xwfsubope, jc.xwftipope ,jc.xwfmoneda,jc.xwfprcins,
               (select jaqm64por  from jaqm64 where jaqm64tad =ja.jaqm65tad and jaqm64cod =  ja.jaqm65cod),
                 jb.jaqm66imp, 
                 jb.jaqm66ime,
                 ja.jaqm65cod
          into periodo, plazo1, fechaxwf, operacion, mod1, suc1, subop1,tipo1,mda1, instancia, CTASA, saldoasegurado, costo,plandes
          from jaqm65 ja, xwf700 jc, jaqm66 jb --,
         where ja.jaqm65tad = 2
           and ja.jaqm65ac1 = 'C'   
           and ja.jaqm65ins = a.ins        
           and jb.jaqm66ins = ja.jaqm65ins
           and jb.jaqm66fea = a.fechacont   --sma 19102023       
           and substr(jb.jaqm66hor,1,5) = substr(a.hora,1,5)
           and jc.xwfprcins = jb.jaqm66ins
           and jc.xwfcar3 = '1'
           and jc.xwfcuenta = a.ctnro;
      exception
        when no_data_found then
          periodo :=0;
          plazo1:=0; 
          fechaxwf:=null; 
       --   cuenta:=0; 
          operacion:=0; 
          mod1:=0; 
          suc1:=0; 
          subop1:=0;
          tipo1:=0;
          mda1 :=0;
          instancia:=0;
          saldoasegurado :=0;
          costo :=0;
      end;
      nro_cuotas := 0 ;
      select count(*) into nro_cuotas 
        from fsd601
       where pgcod = 1
         and ppmod =  mod1 
         and ppsuc =  suc1
         and ppmda = mda1
         and pppap = 0
         and ppcta = a.ctnro
         and ppoper = operacion
         and ppsbop = subop1
         and pptope = tipo1;
      
      BEgin
        select to_char(aofval,'yyyymmdd'), to_char(aofvto,'yyyymmdd'), (lpad(aocta,9,'0') || lpad(aooper,9,'0')),
              (select scnom from fst001 where sucurs = aosuc)
         into fechades1,fechavto1, nrocredito, sucursal
         from fsd010 where aocta =  a.ctnro and aooper = operacion and aosbop = subop1 and aomod = mod1;
      Exception
        when no_data_found then
          fechades1:=null;
          fechavto1:= null;
      end;
      
      PAPel := 0;
      funcionario := FN_ANALISTA_CREDITO(MOD1, SUC1, MDA1, PAPel, A.CTNRO, operacion, subop1, tipo1);  
        
      nrocuota := 1;
      --------------------SMA 28092023--------------
      ln_pgcod := 1;
      ln_grupo := pq_cr_tramdesgra.Fn_tipoSBS_Des(ln_pgcod,
                                                  MOD1,
                                                  SUC1,
                                                  MDA1,
                                                  PAPel,
                                                  A.CTNRO,
                                                  operacion,
                                                  subop1,
                                                  tipo1);    
                                                  
       ln_instancia := fn_instancia_credito(MOD1,
                                            SUC1,
                                            MDA1,
                                            PAPel,
                                            A.CTNRO,
                                            operacion,
                                            subop1,
                                            subop1);                                                  

      ----plan
     
      begin
         select trim(substr(wfattsval, instr(wfattsval, ';', 1) + 1, 25))
           into ln_tip
           from wfattsvalues
          where wfattsid = 'TIPO_CREDITO'
            and wfinsprcid = ln_instancia
            and substr(wfattsval, 1, instr(wfattsval, ';', 1) - 1) = ln_grupo;
      exception
        when no_data_found then
          ln_tip := ' ';
      end;
      case
        when ln_grupo in (2, 12, 13) then
          lc_plan := 'PYME'||' '||ln_tip;
          if trim(lc_plan) ='PYME Microempresa' then
            tipocuenta := '016';
          elsif trim(lc_plan) ='PYME Mediana Empresa' then
            tipocuenta := '017';
          elsif trim(lc_plan) ='PYME Pequeña Empresa' then
            tipocuenta := '018';
          end if;
        when ln_grupo = 3 then
          lc_plan := 'CONSUMO'||' '||ln_tip;
           if trim(lc_plan) ='CONSUMO Consumo No Revolvente' then
            tipocuenta := '019';
          elsif trim(lc_plan) ='CONSUMO Consumo Revolvente' then
            tipocuenta := '020';          
          end if;
        when ln_grupo = 4 then
          lc_plan := 'HIPOTECARIO'||' '||ln_tip;
          tipocuenta := '021';     
        else
          null;
      end case;    
      -------------------------------------------------------------
     -- doc     
      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;

      begin
        select trim(substr(sngc13dir,1,300)), -- direccion
               sngc13ugeo/*, -- ubigeo
               sngc13dpto, 
               sngc13prov, 
               sngc13dist*/
           into dirdomi, ubidomi --,  ocudomi,actdomi               
          from sngc13
         where sngc13pais = pais 
           and sngc13tdoc = tipodoc    
           and sngc13ndoc = numdoc
           and sngc13est='H' 
           and docod =1;
      exception
        when no_data_found then
          dirdomi:='0';
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
      select max(aqpa562corr)
        into correlativo
        from aqpa562;
      correlativo := correlativo + 1 ;
      certificado := lpad(a.ctnro,10,'0')||lpad(operacion,10,'0');
      --- segmento persona /codigo servicio
      BEgin
      select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
        into segmento
        from  sngc60 
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = 0;
      exception
        when others then
          segmento := 'I';
      end;   
      if segmento = 'I' then
        codigocia:= 51;
      else
        codigocia :=50;
     end if;
      ----------------------------------------------------
      ocupacion := trim(ocupacion);
      giro :=trim(giro);    
      
      --------------------------------------------------
      
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
                          aqpa562a1,
                          aqpa562a2,
                          aqpa562a6 )
                   values(1,
                          mod1,
                          suc1,
                          mda1,
                          papel,
                          a.ctnro,
                          operacion,
                          subop1,
                          tipo1,
                          pfecha,
                          'A',
                          13,
                          codigocia,
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
                          suc1,
                          sucursal,
                          funcionario,
                          Plandes,
                          1,--'Costo', sacar de la 611
                          COSTO,---prima,---'Prima', sacar de la 611
                          cTasa,
                          0,----'Sobretasa'/*,
                          tipocuenta,-- sma07/11/2023 tipo cuenta                          
                          nrocredito,
                          null, --numero tarjeta
                          fechavto1, --ult pago
                          fechades1, --f afiliacion
                          fechades1,
                          '00:00', --hora
                          fechavto1,
                          null, --f cancelacion
                          saldoasegurado, --a.monto,
                          moneda, ---moneda_cuenta,
                          'N',
                          null,
                          'N',
                           giro, 
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
                          saldoasegurado,
                          saldoasegurado,
                          nro_cuotas,
                          periodo,
                          lc_plan 
                         ); -- dirdomi, ubidomi, actdomi, ocudomi
                         COMMIT;
     exception
       when dup_val_on_index then
         null;
     end ;     
   end loop; 
   For r in resagados(fecha) loop
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
                where e.pgcod = 1
                  and e.ctnro = r.hcta
                  and e.ttcod = 1
                  and e.cttfir ='T'
                  and rownum = 1;
      exception
        when no_data_found then
          Begin
             select trim(d.pjrazs),
                    d.pjpais,
                    d.pjtdoc,
                    decode(d.pjtdoc,9,'002','001'),
                    d.pjndoc,
                    (select trim(substr(sngc13dir,1,100))
                       from sngc13 where sngc13pais = d.pjpais and sngc13tdoc= d.pjtdoc and sngc13ndoc = d.pjndoc and docod = 1   and sngc13est ='H' )
               into razons,pais,tipodoc,tipodocA, numdoc, direcc
               from fsd003 d
               inner join fsr008 e
                       on e.pepais = d.pjpais
                      and e.petdoc = d.pjtdoc
                      and e.pendoc = d.pjndoc
              where e.pgcod = 1
                and e.ctnro = r.hcta
                and e.ttcod = 1
                and e.cttfir ='T';
          exception
            when no_data_found then
              null;
          end;
      end;
      -- telefono y correo 
      lc_telefono := null;
      lc_correo := null;
      tele := null;
      For t in celular(pais,tipodoc,numdoc)loop
         tele := trim(t.fono);     
      end loop;
      if tele is null or tele =' ' then
        tele :=111111111;
      end if;
      lc_telefono := substr(tele,1,15);
      For c in correo(pais,tipodoc,numdoc)loop
         mail := trim(c.mail);      
      end loop;
      if lc_correo is null then
         lc_correo:= 'sindato@gmail.com';
      else
         lc_correo := substr(mail,1,50);
      end if;
     -------
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
      exception
        when no_data_found then
          giro:= null;
          ocupacion:= null;
      end;
      ---direccion
      PAPel := 0;
      nrocuota := 1;
      
      if tipodoc = 9 then
        doctipo := '002';
      else
        doctipo :='001';
      end if;

      begin
        select TRim(sngc13dir), sngc13ugeo
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
      ---------      
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
       
      --- segmento persona /codigo servicio
      BEgin
      select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
        into segmento
        from  sngc60 
       where sngc60pais = pais
         and sngc60tdoc = tipodoc
         and sngc60ndoc = numdoc
         and sngc60corr = 0;
      exception
        when others then
          segmento := 'I';
      end;   
      if segmento = 'I' then
        codigocia:= 51;
      else
        codigocia :=50;
      end if;
      ---------------------------------------------------
      for j in datos(r.hcta) loop
            nro_cuotas := 0 ;
          select count(*) into nro_cuotas 
            from fsd601
           where pgcod = 1
             and ppmod =  j.mod1 
             and ppsuc =  j.suc1
             and ppmda = j.mda1
             and pppap = 0
             and ppcta = r.hcta
             and ppoper = j.operacion
             and ppsbop = j.subop1
             and pptope = j.tipo1;
           BEgin
            select to_char(aofval,'yyyymmdd'), to_char(aofvto,'yyyymmdd'), (lpad(aocta,9,'0') || lpad(aooper,9,'0')),
                  (select scnom from fst001 where sucurs = aosuc)
             into fechades1,fechavto1, nrocredito, sucursal
             from fsd010 where pgcod = 1 and aocta =  r.hcta and aooper = j.operacion and aosbop = j.subop1 and aomod = j.mod1;
          Exception
            when no_data_found then
              fechades1:=null;
              fechavto1:= null;
          end; 
       
          select max(aqpa562corr) into correlativo from aqpa562;
          
          correlativo := correlativo + 1;
          certificado := lpad(r.hcta, 10, '0') || lpad(j.operacion, 10, '0');
          
           select sng001ase
             into funcionario
             from sng001 --Cambiar la tabla para producción
            where sng001inst = j.instancia;

      
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
                          aqpa562a1,
                          aqpa562a2 )   
                   values(1,   
                          j.mod1,   
                          j.suc1,   
                          j.mda1,   
                          papel,    
                          r.hcta,   
                          j.operacion,    
                          j.subop1,   
                          j.tipo1,    
                          fecha,   
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
                          r.hcimp1,---prima,---'Prima', sacar de la 611    
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
                          saldoasegurado,   
                          saldoasegurado,   
                          nro_cuotas ,
                          nro_cuotas   
                         ); -- dirdomi, ubidomi, actdomi, ocudomi   
                         COMMIT;    
     exception    
       when dup_val_on_index then   
         null;    
     end ;    

         
      end loop;
      
      
      
   end loop;
  
end SP_CARGA_SEG_DESEMPLEO;
 /* GOLDENGATE_DDL_REPLICATION */
/
