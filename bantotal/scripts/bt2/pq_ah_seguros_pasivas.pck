create or replace package PQ_AH_SEGUROS_PASIVAS is
  procedure Carga_SRetiroSeguro(p_fechapro in date);

  Procedure SP_MARCA_CUENTAS_CAMPANIA(P_N_PGCOD  IN number,
                                      P_N_SCSUC  IN number,
                                      P_N_SCMDA  IN number,
                                      P_N_SCPAP  IN number,
                                      P_N_SCCTA  IN number,
                                      P_N_SCOPER IN number,
                                      P_N_SCSBOP IN number,
                                      P_N_SCTOPE IN number,
                                      P_N_SCMOD  IN number,
                                      P_N_PAIS   IN number,
                                      P_N_TDOC   IN number,
                                      P_C_NDOC   IN varchar2,
                                      P_D_FERE   IN date,
                                      P_C_TIPO   IN varchar2,
                                      P_C_RPTA   OUT varchar2);

  Procedure SP_IDENTIFICA_REGALO(P_N_PGCOD  IN number,
                                 P_N_SCSUC  IN number,
                                 P_N_SCMDA  IN number,
                                 P_N_SCPAP  IN number,
                                 P_N_SCCTA  IN number,
                                 P_N_SCOPER IN number,
                                 P_N_SCSBOP IN number,
                                 P_N_SCTOPE IN number,
                                 P_N_SCMOD  IN number,
                                 P_D_FECPRO IN date,
                                 P_N_IMPO   OUT number);

  Procedure SP_HAY_PENDIENTES(P_N_PEND OUT number);

  Procedure SP_ACTUALIZA_PAGO(P_N_PGCOD  IN number,
                              P_N_SCSUC  IN number,
                              P_N_SCMDA  IN number,
                              P_N_SCPAP  IN number,
                              P_N_SCCTA  IN number,
                              P_N_SCOPER IN number,
                              P_N_SCSBOP IN number,
                              P_N_SCTOPE IN number,
                              P_N_SCMOD  IN number,
                              P_V_ESTA   IN varchar2,
                              P_V_OBSER  IN varchar2);
  procedure REPORTE_RetiroSeguro(p_fechaini in date,
                                 p_fechafin in date);
  
end PQ_AH_SEGUROS_PASIVAS;
/
create or replace package body PQ_AH_SEGUROS_PASIVAS is
  ---------------------------------------------------------------
  -- Proyecto    : 2342 Adecuacion para realizar el Retiro Protegido
  -- Autor       : Silvia Marquez
  -- Fecha       : 25/02/2020
  -- Modificacion: SMARQUEZ 03/02/2025 ACTUALIZACION REPORTE Compilacion de campos correctos
  -- Modificación: SMARQUEZ 03/03/2025 Error en conversión de numero linea 250
  -- Nuevo       : SMARQUEZ  18/03/2025 nuevo reporte
  -- Modificacion: SMARQUEZ 03/04/2025 Extraccion de telefono y correo fuera del query para 
  --               recuperar datos
  -- Modificacion: SMARQUEZ 29/05/2025 Modificacion persona juridica
  
  ---------------------------------------------------------------
  procedure Carga_SRetiroSeguro(p_fechapro in date) is
    cursor tran is
      select distinct tp1nro1, tp1nro2 --, tp1nro3
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10884
         and tp1corr1 = 38
         and tp1corr2 = 1;

    cursor datos(fechaUno date, FechaDos date, mod1 number, trans1 number) is ---, ord1 number) is

      select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro
        from fsh015 f5, fsh016 f6
       where f5.pgcod = 1
         and f5.hcmod = mod1
         and f5.htran = trans1
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2514020000017
         and f6.hmodul = 260
         
      
      --  and f6.hcord = ord1
      union
      select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro
        from fsh015 f5, fsh016 f6
       where f5.pgcod = 1
         and f5.hcmod = mod1
         and f5.htran = trans1
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2524020000017
         and f6.hmodul = 260

         ;
    --       and f6.hcord = ord1;
    cursor integrantes (cta in number) is

    select trim(s.pendoc) dni,
                   trim(d.pfnom1) nombre,
                   trim(d.pfape1) apepa ,
                   trim(d.pfape2) apema,
                   (select TDNOM from FST014   WHERE TDOCUM = s.petdoc) tipdoc,
                   d.pffnac fenac,
                   decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S') estadoc,
                   d.pfcant sexo,
                   (select to_number(DOTELFP * 1) from fsr005
                     where PEPAIS = s.pepais and PETDOC = s.petdoc and  PENDOC =s.pendoc
                       and DOTELFp  not in ('null')
                       and length(trim(DOTELFP)) <=10
                       and rownum = 1) telefono,
                   (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = s.pepais and petdoc = s.petdoc and pendoc = s.pendoc and txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1) correo,
                    substr(e.sngc13dir,1,100) direc,
                   (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto) depto,-- depto
                   (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov) prov,--prov
                   (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist ) distrito
        --      into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, telefono1, correo1, direccion1,depto1,prov1,dist1
              from fsr008 s, fsd002 d, sngc13 e
             where s.pgcod = 1
               and s.ctnro = cta
               and s.ttcod = 1
               and s.cttfir <> 'T'
               and d.pfpais = s.pepais
               and d.pftdoc = s.petdoc
               and d.pfndoc = s.pendoc
               and e.sngc13pais = d.pfpais
               and e.sngc13tdoc = d.pftdoc
               and e.sngc13ndoc = d.pfndoc
               and e.docod = 1
               and e.sngc13est = 'H'
               and e.SNGC13CORR = (select max(SNGC13CORR)
                                   from sngc13
                                  where sngc13pais = d.pfpais
                                    and sngc13tdoc = d.pftdoc
                                    and sngc13ndoc = d.pfndoc
                                    and docod = 1
                                    and sngc13est = 'H');

    Fecha1    date;
    Fecha2    date;
    modulo    number;
    tipoper   number;
    sucur     number;
    mda       number;
    pap       number;
    cuenta    number;
    oper      number;
    subop     number;
    rubro     number;
    operacion number;
    importe   number;
    agencia   char(30);
    dni       char(12);
    nombre    char(100);
    verif     char(1) := 'N';
    anio char(4);
    mes char(2);
    dia char(2);
    montoa    number(17,2);
    ----------------------------
    region    char(30);
    moneda    char(10);
    voucher   CHAR(30);
    dni1      char(12);
    nombre1   char(30);
    apepat1   char(30);
    apemat1   char(30);
    tipodoc1  char(30);
    fechnac1  date;
    ecivil1    char(1);
    sexo1     char(1);
    telefono1 number(10);
    correo1   char(30);
    direccion1 char(100);
    depto1     char(30);
    prov1      char(30);
    dist1      char(30);
    ---dos
    dni2      char(12);
    nombre2   char(30);
    apepat2   char(30);
    apemat2   char(30);
    tipodoc2  char(30);
    fechnac2  date;
    ecivil2   char(1);
    sexo2     char(1);
    telefono2 number(10);
    correo2   char(30);
    direccion2 char(100);
    depto2     char(30);
    prov2      char(30);
    dist2      char(30);
    contador   number:=0;
    ---- tres
    dni3      char(12);
    nombre3   char(30);
    apepat3   char(30);
    apemat3   char(30);
    tipodoc3  char(30);
    fechnac3  date;
    ecivil3   char(1);
    sexo3     char(1);
    telefono3 number(10);
    correo3   char(30);
    direccion3 char(100);
    depto3     char(30);
    prov3     char(30);
    dist3      char(30);
    tipopersona number;

  begin
    delete jaqz588;
    commit;
    Fecha1 := TRUNC(p_fechapro, 'MM');
    Fecha2 := last_day(p_fechapro);
    For a in tran loop
      For reg in datos(Fecha1, Fecha2, a.tp1nro1, a.tp1nro2) loop
        --,a.tp1nro3) loop
         rubro := 0;
         operacion := 0;
         importe := 0;
         modulo := 0;
         tipoper := 0;
         sucur := 0;
         mda := 0;
         pap := 0;
         cuenta := 0;
         oper := 0;
         subop  := 0;
        Begin
          Select hrubro,
                 hoper,
                 hcimp1,
                 hmodul,
                 htoper,
                 hsucur,
                 hmda,
                 hpap,
                 hcta,
                 hoper,
                 hsubop
            into rubro,
                 operacion,
                 importe,
                 modulo,
                 tipoper,
                 sucur,
                 mda,
                 pap,
                 cuenta,
                 oper,
                 subop
            from fsh016
           where pgcod = reg.pgcod
             and hcmod = reg.hcmod
             and hsucor = reg.hsucor
             and htran = reg.htran
             and hnrel = reg.hnrel
             and hfcon = reg.hfcon
             and hrubro = reg.hrubro
             and hmodul = 260;
          verif := 'S';
        Exception
          when no_data_found then
            verif := 'N';
        end;
        tipopersona := 0;
        Begin
          select petdoc 
           into tipopersona
           from fsr008
            where ctnro = cuenta
             and cttfir ='T';
        exception
          when others then
            tipopersona := 0;
        end;

        if verif = 'S' then
          if tipopersona <> 9 then
              Begin
                dni1:=null;
                nombre1 := null;
                apepat1 :=null;
                apemat1 :=null;
                tipodoc1 :=null;
                fechnac1 :=null;
                ecivil1 :=null;
                sexo1 :=null;
                telefono1 := null;
                correo1 :=null;
                direccion1 :=null;
                depto1 :=null;
                prov1 :=null;
                dist1 :=null;
                select trim(s.pendoc),
                       trim(d.pfnom1),
                       trim(d.pfape1),
                       trim(d.pfape2),
                       (select TDNOM from FST014   WHERE TDOCUM = s.petdoc),
                       d.pffnac,
                       decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                       d.pfcant,
                       (select to_number(DOTELFP * 1) from fsr005
                         where PEPAIS = s.pepais and PETDOC = s.petdoc and  PENDOC =s.pendoc
                           and DOTELFp  not in ('null')
                           and length(trim(DOTELFP)) <=10
                           and rownum = 1),
                       (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = s.pepais and petdoc = s.petdoc and pendoc = s.pendoc and txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1),
                        substr(e.sngc13dir,1,100),
                       (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                       (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                       (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
                  into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, telefono1, correo1, direccion1,depto1,prov1,dist1
                  from fsr008 s, fsd002 d, sngc13 e
                 where s.pgcod = 1
                   and s.ctnro = cuenta
                   and s.ttcod = 1
                   and s.cttfir = 'T'
                   and d.pfpais = s.pepais
                   and d.pftdoc = s.petdoc
                   and d.pfndoc = s.pendoc
                   and e.sngc13pais = d.pfpais
                   and e.sngc13tdoc = d.pftdoc
                   and e.sngc13ndoc = d.pfndoc
                   and e.docod = 1
                   and e.sngc13est = 'H'
                   and e.SNGC13CORR = (select max(SNGC13CORR)
                                       from sngc13
                                      where sngc13pais = d.pfpais
                                        and sngc13tdoc = d.pftdoc
                                        and sngc13ndoc = d.pfndoc
                                        and docod = 1
                                        and sngc13est = 'H')
                   and rownum = 1;
              Exception
                when no_data_found then
                  dni    := ' ';
                  nombre := ' ';
                when others then
                  dbms_output.put_line(cuenta);
              End;
          else
            Begin
            dni1:=null;
            nombre1 := null;
            apepat1 :=null;
            apemat1 :=null;
            tipodoc1 :=null;
            fechnac1 :=null;
            ecivil1 :=null;
            sexo1 :=null;
            telefono1 := null;
            correo1 :=null;
            direccion1 :=null;
            depto1 :=null;
            prov1 :=null;
            dist1 :=null;
            select trim(o.pfndo1),
                   trim(d.pfnom1),
                   trim(d.pfape1),
                   trim(d.pfape2),
                   (select TDNOM from FST014   WHERE TDOCUM = o.pftdo1),
                   d.pffnac,
                   decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                   d.pfcant,
                   (select to_number(DOTELFP * 1) from fsr005
                     where PEPAIS = s.pepais and PETDOC = s.petdoc and  PENDOC =s.pendoc
                       and DOTELFp  not in ('null')
                       and length(trim(DOTELFP)) <=10
                       and rownum = 1),
                   (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = s.pepais and petdoc = s.petdoc and pendoc = s.pendoc and txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1),
                    substr(e.sngc13dir,1,100),
                   (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                   (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                   (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
              into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, telefono1, correo1, direccion1,depto1,prov1,dist1
              from fsr008 s, fsr003 o,fsd002 d, sngc13 e
             where s.pgcod = 1
               and s.ctnro = cuenta
               and s.ttcod = 1
               and s.cttfir = 'T'
               and o.pjpais = s.pepais
               and o.pjtdoc = s.petdoc
               and o.pjndoc = s.pendoc
               and o.vicod = 7
               and d.pfpais = o.pfpai1
               and d.pftdoc = o.pftdo1
               and d.pfndoc = o.pfndo1               
               and e.sngc13pais = d.pfpais
               and e.sngc13tdoc = d.pftdoc
               and e.sngc13ndoc = d.pfndoc
               and e.docod = 1
               and e.sngc13est = 'H'
               and e.SNGC13CORR = (select max(SNGC13CORR)
                                   from sngc13
                                  where sngc13pais = d.pfpais
                                    and sngc13tdoc = d.pftdoc
                                    and sngc13ndoc = d.pfndoc
                                    and docod = 1
                                    and sngc13est = 'H')
               and rownum = 1;
          Exception
            when no_data_found then
              dni    := ' ';
              nombre := ' ';
            when others then
              dbms_output.put_line(cuenta);
          End;
          end if;
          dni2:=null;
          nombre2 := null;
          apepat2 :=null;
          apemat2 :=null;
          tipodoc2 :=null;
          fechnac2 :=null;
          ecivil2 :=null;
          sexo2 :=null;
          telefono2 := null;
          correo2 :=null;
          direccion2 :=null;
          depto2 :=null;
          prov2 :=null;
          dist2 :=null;
          dni3:=null;
          nombre3 := null;
          apepat3 :=null;
          apemat3 :=null;
          tipodoc3 :=null;
          fechnac3 :=null;
          ecivil3 :=null;
          sexo3 :=null;
          telefono3 := null;
          correo3 :=null;
          direccion3 :=null;
          depto3 :=null;
          prov3 :=null;
          dist3 :=null;
          contador := 0;

          for k in integrantes(cuenta) loop
            if contador = 0 then
              dni2     := k.dni;
              nombre2   := k.nombre;
              apepat2   := k.apepa;
              apemat2   := k.apema;
              tipodoc2  := k.tipdoc;
              fechnac2  := k.fenac;
              ecivil2   := k.estadoc;
              sexo2     := k.sexo;
              telefono2 := k.telefono;
              correo2   := k.correo;
              direccion2 := k.direc;
              depto2     := k.depto;
              prov2      := k.prov;
              dist2      := k.distrito;
              contador := contador + 1;
             else
               if contador = 1 then
                  dni3     := k.dni;
                  nombre3   := k.nombre;
                  apepat3   := k.apepa;
                  apemat3   := k.apema;
                  tipodoc3  := k.tipdoc;
                  fechnac3  := k.fenac;
                  ecivil3   := k.estadoc;
                  sexo3     := k.sexo;
                  telefono3 := k.telefono;
                  correo3   := k.correo;
                  direccion3 := k.direc;
                  depto3     := k.depto;
                  prov3      := k.prov;
                  dist3      := k.distrito;
                  contador := contador + 1;
               else
                 exit;
               end if;
             end if;

          end loop;
          ---------------SMA 30102024-----------------
          agencia := null;
          region  := null;
          BEgin
            select A.scnom, substr(trim(B.JAQN92NOM),1,30)
              into agencia, region
              from fst001 A, JAQN92 B, JAQN93 C
             where A.sucurs = reg.hsucor
               AND C.JAQN93IDS = A.SUCURS
               AND C.JAQN93IDR = B.JAQN92IDR
               ;
          exception
            when no_data_found then
              agencia := reg.hsucor;
          end;

          if mda = 0 then
            moneda := 'SOLES';
          else
            moneda := 'DOLARES';
          end if;
          voucher := null;
          anio:= null;
          mes := null;
          dia := null;
          select substr(EXTRACT(YEAR FROM TRUNC(reg.hfcon)),3,4) into anio from dual;
          Select EXTRACT(MONTH FROM TRUNC(reg.hfcon))into mes from dual;
          Select EXTRACT(DAY FROM TRUNC(reg.hfcon)) into dia from dual;

          voucher:= trim(anio)||lpad(trim(mes),2,'0')||lpad(trim(dia),2,'0')||lpad(reg.hsucor,3,'0')||LPAD(reg.hcmod,3,'0')||reg.htran||lpad(reg.hnREL,4,'0');
          Begin
            select tp1nro2
              into montoa
              from fst198
             where tp1cod = 1
               and tp1cod1 =10884
               and tp1corr1 = 82
               and tp1corr2 = 0
               and TP1IMP1 = importe;
          exception
            when no_data_found then
              montoa:= 500;
          end;
          ---------------------------------------------------
          Begin
            insert into jaqz588
              (jaqz588cod,
               jaqz588suc,
               jaqz588mda,
               jaqz588pap,
               jaqz588cta,
               jaqz588oper,
               jaqz588sbop,
               jaqz588tope,
               jaqz588mod,
               jaqz588fech,
               jaqz588fpro,
               jaqz588mon,
               jaqz588tsuc,
               jaqz588tmod,
               jaqz588ttran,
               jaqz588trel,
               jaqz588rub,

               jaqz588dni,
               jaqz588hora,
               jaqz588nom,
               jaqz588age,
               jaqz588au6,
               jaqz588fun)
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               operacion,
               subop,
               tipoper,
               modulo,
               reg.hfcon,
               p_fechapro,
               importe,
               reg.hsucor,
               reg.hcmod,
               reg.htran,
               reg.hnrel,
               rubro,
               dni,
               reg.hhora,
               nombre,
               agencia,
               'N',
               reg.husing);
          exception
            when dup_val_on_index then
              null;
          end;
          Begin
            insert into jaqz588H
              (jaqz588codH,
               jaqz588sucH,
               jaqz588mdaH,
               jaqz588papH,
               jaqz588ctaH,
               jaqz588operH,
               jaqz588sbopH,
               jaqz588topeH,
               jaqz588modH,
               jaqz588fechH,
               jaqz588fproH,
               jaqz588monH,
               jaqz588tsucH,
               jaqz588tmodH,
               jaqz588ttranH,
               jaqz588tNrelH,
               jaqz588rubH,
               jaqz588dniH,
               jaqz588horaH,
               jaqz588nomH,
               jaqz588ageH,
               jaqz588au6H,
               jaqz588funH,
               jaqz588hreg,
               JAQZ588HCTA,
               JAQZ588HFPAG,
               jaqz588hmdades,
               JAQZ588HNROV,
               JAQZ588HMTOA,
               JAQZ588HMOTI,
               JAQZ588HTIPOP1,
               JAQZ588HTIPOD1,
               JAQZ588HNDOC1,
               JAQZ588HAPEPA1,
               JAQZ588HAPEMA1,
               JAQZ588HNOM1,
               JAQZ588HFNAC1,
               JAQZ588HSEXO1,
               jaqz588hdir1,
               jaqz588hdepto1,
               jaqz588hprov1,
               jaqz588hdis1,
               jaqz588htel1,
               jaqz588heciv1,
               jaqz588hcorr1,
               JAQZ588HTIPOP2,
               JAQZ588HTIPOD2,
               JAQZ588HNDOC2,
               JAQZ588HAPEPA2,
               JAQZ588HAPEMA2,
               JAQZ588HNOM2,
               JAQZ588HFNAC2,
               JAQZ588HSEXO2,
               jaqz588hdir2,
               jaqz588hdepto2,
               jaqz588hprov2,
               jaqz588hdis2,
               jaqz588htel2,
               jaqz588heciv2,
               jaqz588hcorr2,
               JAQZ588HTIPOP3,
               JAQZ588HTIPOD3,
               JAQZ588HNDOC3,
               JAQZ588HAPEPA3,
               JAQZ588HAPEMA3,
               JAQZ588HNOM3,
               JAQZ588HFNAC3,
               JAQZ588HSEXO3,
               jaqz588hdir3,
               jaqz588hdepto3,
               jaqz588hprov3,
               jaqz588hdis3,
               jaqz588htel3,
               jaqz588heciv3,
               jaqz588hcorr3 )
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               operacion,
               subop,
               tipoper,
               modulo,
               reg.hfcon,
               p_fechapro,
               importe,
               reg.hsucor,
               reg.hcmod,
               reg.htran,
               reg.hnrel,
               rubro,
               dni,
               reg.hhora,
               nombre,
               agencia,
               'N',
               reg.husing,
               region,
               cuenta,
               'EFECTIVO',
               moneda,
               voucher,
               montoa,--MONTO ASEGURADO
               '',--MOTIVO
               'NATURAL',
               tipodoc1,--
               dni1,
               apepat1,
               apemat1,
               nombre1,
               fechnac1,
               sexo1,-- ecivil,
               direccion1,
               depto1,
               prov1,
               dist1,
               telefono1,
               ecivil1,
               correo1 ,
               'NATURAL',
               tipodoc2,--
               dni2,
               apepat2,
               apemat2,
               nombre2,
               fechnac2,
               sexo2,-- ecivil,
               direccion2,
               depto2,
               prov2,
               dist2,
               telefono2,
               ecivil2,
               correo2,
               'NATURAL',
               tipodoc3,--
               dni3,
               apepat3,
               apemat3,
               nombre3,
               fechnac3,
               sexo3,-- ecivil,
               direccion3,
               depto3,
               prov3,
               dist3,
               telefono3,
               ecivil3,
               correo3);
          exception
            when dup_val_on_index then
              null;
          end;
        end if;
      end loop;
      commit;
    end loop;

  end Carga_SRetiroSeguro;

  --------------------------------------------------------------------------
  Procedure SP_MARCA_CUENTAS_CAMPANIA(P_N_PGCOD  IN number,
                                      P_N_SCSUC  IN number,
                                      P_N_SCMDA  IN number,
                                      P_N_SCPAP  IN number,
                                      P_N_SCCTA  IN number,
                                      P_N_SCOPER IN number,
                                      P_N_SCSBOP IN number,
                                      P_N_SCTOPE IN number,
                                      P_N_SCMOD  IN number,
                                      P_N_PAIS   IN number,
                                      P_N_TDOC   IN number,
                                      P_C_NDOC   IN varchar2,
                                      P_D_FERE   IN date,
                                      P_C_TIPO   IN varchar2,
                                      P_C_RPTA   OUT varchar2) is
    ---------------------------------------------------------------
    -- Proyecto: Campaña cliente de mi cliente
    -- Autor   : maraujo
    -- Fecha   : 07/04/2021
    ---------------------------------------------------------------

    v_importe number(12, 2) := 2.5;
    v_ndoc char(12) := P_C_NDOC;
    v_tipo char(1):= P_C_TIPO;

  begin

    P_C_RPTA := 'OK';

    insert into jaql747
      (jaql747pgco,
       jaql747scsu,
       jaql747scmd,
       jaql747scpa,
       jaql747scct,
       jaql747scop,
       jaql747scsb,
       jaql747scto,
       jaql747scmo,
       jaql747pais,
       jaql747tdoc,
       jaql747ndoc,
       jaql747fere,
       jaql747tipo,
       jaql747impo,
       jaql747esta)
    values
      (P_N_PGCOD,
       P_N_SCSUC,
       P_N_SCMDA,
       P_N_SCPAP,
       P_N_SCCTA,
       P_N_SCOPER,
       P_N_SCSBOP,
       P_N_SCTOPE,
       P_N_SCMOD,
       P_N_PAIS,
       P_N_TDOC,
       v_ndoc,
       P_D_FERE,
       v_TIPO,
       v_importe,
       'N');

       commit;
  exception
    when others then
      P_C_RPTA := substr(sqlerrm, 1, 100);

  end SP_MARCA_CUENTAS_CAMPANIA;
  ------------------------------------------------------------------
  Procedure SP_IDENTIFICA_REGALO(P_N_PGCOD  IN number,
                                 P_N_SCSUC  IN number,
                                 P_N_SCMDA  IN number,
                                 P_N_SCPAP  IN number,
                                 P_N_SCCTA  IN number,
                                 P_N_SCOPER IN number,
                                 P_N_SCSBOP IN number,
                                 P_N_SCTOPE IN number,
                                 P_N_SCMOD  IN number,
                                 P_D_FECPRO IN date,
                                 P_N_IMPO   OUT number) is
    ---------------------------------------------------------------
    -- Proyecto: Campaña cliente de mi cliente
    -- Autor   : maraujo
    -- Fecha   : 07/04/2021
    ---------------------------------------------------------------

    v_tipcam number;

  Begin
    select distinct jaql747impo
      into p_n_impo
      from jaql747
     where jaql747pgco = P_N_PGCOD
       and jaql747scsu = P_N_SCSUC
       and jaql747scmo = P_N_SCMOD
       and jaql747scmd = P_N_SCMDA
       and jaql747scpa = P_N_SCPAP
       and jaql747scct = P_N_SCCTA
       and jaql747scop = P_N_SCOPER
       and jaql747scsb = P_N_SCSBOP
       and jaql747scto = decode(P_N_SCMOD,22,jaql747scto,P_N_SCTOPE)
       and jaql747tipo in ('S', 'A')
       and jaql747esta = 'I';

    If P_N_SCMDA <> 0 then
      sp_tipo_cambio(P_D_FECPRO, 0, 101, 500, v_tipcam);
      p_n_impo := p_n_impo / v_tipcam;
    end if;

  exception
    when no_data_found then
      p_n_impo := 0;
    when others then
      p_n_impo := -99;
  End;

  ------------------------------------------------------------------
  Procedure SP_HAY_PENDIENTES(P_N_PEND OUT number) is
    ---------------------------------------------------------------
    -- Proyecto: Campaña cliente de mi cliente
    -- Autor   : maraujo
    -- Fecha   : 07/04/2021
    ---------------------------------------------------------------

  Begin
    select count(*)
      into P_N_PEND
      from jaql747
     where jaql747tipo in ('S', 'A')
       and jaql747esta = 'I';

  exception
    when no_data_found then
      P_N_PEND := 0;
    when others then
      P_N_PEND := 0;
  End;

  ------------------------------------------------------------------
  Procedure SP_ACTUALIZA_PAGO(P_N_PGCOD  IN number,
                              P_N_SCSUC  IN number,
                              P_N_SCMDA  IN number,
                              P_N_SCPAP  IN number,
                              P_N_SCCTA  IN number,
                              P_N_SCOPER IN number,
                              P_N_SCSBOP IN number,
                              P_N_SCTOPE IN number,
                              P_N_SCMOD  IN number,
                              P_V_ESTA   IN varchar2,
                              P_V_OBSER  IN varchar2) is
    ---------------------------------------------------------------
    -- Proyecto: Campaña cliente de mi cliente
    -- Autor   : maraujo
    -- Fecha   : 07/04/2021
    ---------------------------------------------------------------
  Begin
    update jaql747
       set jaql747esta = P_V_ESTA, jaql747obse = P_V_OBSER
     where jaql747pgco = P_N_PGCOD
       and jaql747scsu = P_N_SCSUC
       and jaql747scmo = P_N_SCMOD
       and jaql747scmd = P_N_SCMDA
       and jaql747scpa = P_N_SCPAP
       and jaql747scct = P_N_SCCTA
       and jaql747scop = P_N_SCOPER
       and jaql747scsb = P_N_SCSBOP
       and jaql747scto = decode(P_N_SCMOD,22,jaql747scto,P_N_SCTOPE)
       and jaql747tipo in ('S', 'A')
       and jaql747esta = 'I';
       commit;
  exception
    when others then
      null;
  End;
  ----------------------------------------------------------------
  -- REPORTE CON NUEVOS CAMPOS Y CONSULTA SIN EL PROCESO DE COBRO
  -- SMARQUEZ 18/03/2025
  -----------------------------------------------------------------

  procedure REPORTE_RetiroSeguro(p_fechaini in date,
                                 p_fechafin in date) is
    cursor tran is
      select distinct tp1nro1, tp1nro2 --, tp1nro3
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10884
         and tp1corr1 = 38
         and tp1corr2 = 1;

    cursor datos(fechaUno date, FechaDos date, mod1 number, trans1 number) is
      select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro
        from fsh015 f5, fsh016 f6
       where f5.pgcod = 1
         and f5.hcmod = mod1
         and f5.htran = trans1
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2514020000017
         and f6.hmodul = 260
      union
      select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro
        from fsh015 f5, fsh016 f6
       where f5.pgcod = 1
         and f5.hcmod = mod1
         and f5.htran = trans1
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2524020000017
         and f6.hmodul = 260
         ;

    cursor integrantes (cta in number) is
    select trim(s.pendoc) dni,
                   trim(d.pfnom1) nombre,
                   trim(d.pfape1) apepa ,
                   trim(d.pfape2) apema,
                   (select TDNOM from FST014   WHERE TDOCUM = s.petdoc) tipdoc,
                   d.pffnac fenac,
                   decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S') estadoc,
                   d.pfcant sexo,
                    (select to_number(DOTELFP * 1) from fsr005
                     where PEPAIS = s.pepais and PETDOC = s.petdoc and  PENDOC =s.pendoc
                       and DOTELFp  not in ('null')
                       and length(trim(DOTELFP)) <=10
                       and rownum = 1) telefono,
                   (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = s.pepais and petdoc = s.petdoc and pendoc = s.pendoc and txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1) correo,
                    substr(e.sngc13dir,1,100) direc,
                   (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto) depto,-- depto
                   (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov) prov,--prov
                   (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist ) distrito
      --      into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, telefono1, correo1, direccion1,depto1,prov1,dist1
              from fsr008 s, fsd002 d, sngc13 e
             where s.pgcod = 1
               and s.ctnro = cta
               and s.ttcod = 1
               and s.cttfir <> 'T'
               and d.pfpais = s.pepais
               and d.pftdoc = s.petdoc
               and d.pfndoc = s.pendoc
               and e.sngc13pais = d.pfpais
               and e.sngc13tdoc = d.pftdoc
               and e.sngc13ndoc = d.pfndoc
               and e.docod = 1
               and e.sngc13est = 'H'
               and e.SNGC13CORR = (select max(SNGC13CORR)
                                   from sngc13
                                  where sngc13pais = d.pfpais
                                    and sngc13tdoc = d.pftdoc
                                    and sngc13ndoc = d.pfndoc
                                    and docod = 1
                                    and sngc13est = 'H');

    cursor datosDia(fechaUno date, mod1 number, trans1 number) is
      select f5.pgcod,
             f5.itmod,
             f5.itsuc,
             f5.ittran,
             f5.itnrel,
             f5.itfcon,
             f5.ituing,
             f5.ithora,
             f6.rubro
        from fsd015 f5, fsd016 f6
       where f5.pgcod = 1
         and f5.itmod = mod1
         and f5.ittran = trans1
         and f5.itfcon = fechauno
         and f5.itcorr = 0
         and f6.pgcod = f5.pgcod
         and f6.itmod = f5.itmod
         and f6.itsuc = f5.itsuc
         and f6.ittran = f5.ittran
         and f6.itnrel = f5.itnrel   -- and f6.itfcon = f5.itfcon
         and f6.rubro = 2514020000017
         and f6.modulo = 260
         

       union
          select f5.pgcod,
             f5.itmod,
             f5.itsuc,
             f5.ittran,
             f5.itnrel,
             f5.itfcon,
             f5.ituing,
             f5.ithora,
             f6.rubro
        from fsd015 f5, fsd016 f6
       where f5.pgcod = 1
         and f5.itmod = mod1
         and f5.ittran = trans1
         and f5.itfcon = fechauno
         and f5.itcorr = 0
         and f6.pgcod = f5.pgcod
         and f6.itmod = f5.itmod
         and f6.itsuc = f5.itsuc
         and f6.ittran = f5.ittran
         and f6.itnrel = f5.itnrel    -- and f6.itfcon = f5.itfcon
         and f6.rubro = 2524020000017
         and f6.modulo = 260;
    -------------------------
    cursor integra_juridica (pais in number,tdoc in number,ndoc in character) is
            select trim(d.pfndoc) dni,
                   trim(d.pfnom1) nombre,
                   trim(d.pfape1) apepa ,
                   trim(d.pfape2) apema,
                   (select TDNOM from FST014   WHERE TDOCUM = d.pftdoc) tipdoc,
                   d.pffnac fenac,
                   decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S') estadoc,
                   d.pfcant sexo,
                   (select to_number(DOTELFP * 1) from fsr005
                     where PEPAIS = d.pfpais and PETDOC = d.pftdoc and  PENDOC = d.pfndoc
                       and DOTELFp  not in ('null')
                       and length(trim(DOTELFP)) <=10
                       and rownum = 1) telefono,
                   (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = d.pfpais and petdoc = d.pftdoc and pendoc = d.pfndoc and txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1) correo,
                    substr(e.sngc13dir,1,100) direc,
                   (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto) depto,-- depto
                   (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov) prov,--prov
                   (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist ) distrito
        --      into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, telefono1, correo1, direccion1,depto1,prov1,dist1
              from  fsd002 d, sngc13 e
             where d.pfpais = pais
               and d.pftdoc = tdoc
               and d.pfndoc = ndoc           
               and e.sngc13pais = d.pfpais
               and e.sngc13tdoc = d.pftdoc
               and e.sngc13ndoc = d.pfndoc              
               and e.docod = 1
               and e.sngc13est = 'H'
               and e.SNGC13CORR = (select max(SNGC13CORR)
                                   from sngc13
                                  where sngc13pais = d.pfpais
                                    and sngc13tdoc = d.pftdoc
                                    and sngc13ndoc = d.pfndoc
                                    and docod = 1
                                    and sngc13est = 'H');

     cursor juridica (dni in character, doc in character) is
         select f3.*
           from FSR003 f3
          Where f3.Pjpais = 604
            and f3.Pjtdoc = 9
            and f3.Pjndoc = dni
            and f3.VICOD = 7
            and f3.pfndo1 <> doc;


    Fecha1    date;
    Fecha2    date;
    modulo    number;
    tipoper   number;
    sucur     number;
    mda       number;
    pap       number;
    cuenta    number;
    oper      number;
    subop     number;
    rubro     number;
    operacion number;
    importe   number;
    agencia   char(30);
    dni       char(12);
    nombre    char(100);
    verif     char(1) := 'N';
    anio char(4);
    mes char(2);
    dia char(2);
    montoa    number(17,2);
    ----------------------------
    region    char(30);
    moneda    char(10);
    voucher   CHAR(30);
    dni1      char(12);
    nombre1   char(30);
    apepat1   char(30);
    apemat1   char(30);
    tipodoc1  char(30);
    fechnac1  date;
    ecivil1    char(1);
    sexo1     char(1);
    telefono1 number(10);
    correo1   char(30);
    direccion1 char(100);
    depto1     char(30);
    prov1      char(30);
    dist1      char(30);
    ---dos
    dni2      char(12);
    nombre2   char(30);
    apepat2   char(30);
    apemat2   char(30);
    tipodoc2  char(30);
    fechnac2  date;
    ecivil2   char(1);
    sexo2     char(1);
    telefono2 number(10);
    correo2   char(30);
    direccion2 char(100);
    depto2     char(30);
    prov2      char(30);
    dist2      char(30);
    contador   number:=0;
    ---- tres
    dni3      char(12);
    nombre3   char(30);
    apepat3   char(30);
    apemat3   char(30);
    tipodoc3  char(30);
    fechnac3  date;
    ecivil3   char(1);
    sexo3     char(1);
    telefono3 number(10);
    correo3   char(30);
    direccion3 char(100);
    depto3     char(30);
    prov3     char(30);
    dist3      char(30);
-------
    tipocuenta char(20);
    documentoj char(12);
    fecha      date;
    pais     number;
    tipodoc  number;
  begin
    delete aqpa571;
    commit;
    Fecha1 := p_fechaini; --TRUNC(p_fechapro, 'MM');
    Fecha2 := p_fechafin; --last_day(p_fechapro);
    For a in tran loop
      For reg in datos(Fecha1, Fecha2, a.tp1nro1, a.tp1nro2) loop
         pais := 0;
         tipodoc := 0;
         rubro := 0;
         operacion := 0;
         importe := 0;
         modulo := 0;
         tipoper := 0;
         sucur := 0;
         mda := 0;
         pap := 0;
         cuenta := 0;
         oper := 0;
         subop  := 0;
        Begin
          Select hrubro,
                 hoper,
                 hcimp1,
                 hmodul,
                 htoper,
                 hsucur,
                 hmda,
                 hpap,
                 hcta,
                 hoper,
                 hsubop
            into rubro,
                 operacion,
                 importe,
                 modulo,
                 tipoper,
                 sucur,
                 mda,
                 pap,
                 cuenta,
                 oper,
                 subop
            from fsh016
           where pgcod = reg.pgcod
             and hcmod = reg.hcmod
             and hsucor = reg.hsucor
             and htran = reg.htran
             and hnrel = reg.hnrel
             and hfcon = reg.hfcon
             and hrubro = reg.hrubro
             and hmodul = 260;
          verif := 'S';
        Exception
          when no_data_found then
            verif := 'N';
        end;
      ----------------Quien ejecutó el retiro---------------------------------
        Begin
          
           select JAQZ153DPA2,JAQZ153DTP2, JAQZ153DNU2, (select penom from fsd001  where pepais =JAQZ153DPA2
                                   and petdoc =JAQZ153DTP2 and pendoc =  JAQZ153DNU2
                                   and rownum = 1)                                     
             into pais,tipodoc, dni, nombre
             from JAQZ153D
            where JAQZ153DPGC = 1
              and JAQZ153DSUC= reg.hsucor
              and JAQZ153DMOD = reg.hcmod
              and JAQZ153DTRX = reg.htran
              and JAQZ153DREL = reg.hnrel
              and JAQZ153DFEC = reg.hfcon
              and JAQZ153DCTA = cuenta
              and rownum = 1;

        Exception
          when no_data_found then
            dni := null; ---dni1;
            nombre:= null;--substr((trim(apepat1)||' '||trim(apemat1)||' '||trim(nombre1)),1,100) ;
        end;

        ---------------------------------------------------

        if verif = 'S' then
          Begin
            dni1:=null;
            nombre1 := null;
            apepat1 :=null;
            apemat1 :=null;
            tipodoc1 :=null;
            fechnac1 :=null;
            ecivil1 :=null;
            sexo1 :=null;
            telefono1 := null;
            correo1 :=null;
            direccion1 :=null;
            depto1 :=null;
            prov1 :=null;
            dist1 :=null;
            select trim(s.pendoc),
                   trim(d.pfnom1),
                   trim(d.pfape1),
                   trim(d.pfape2),
                   (select TDNOM from FST014   WHERE TDOCUM = s.petdoc),
                   d.pffnac,
                   decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                   d.pfcant,
                   substr(e.sngc13dir,1,100),
                   (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                   (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                   (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
              into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, --telefono1, correo1, 
                   direccion1,depto1,prov1,dist1
              from fsr008 s, fsd002 d, sngc13 e
             where s.pgcod = 1
               and s.ctnro = cuenta
               and s.ttcod = 1
               and s.cttfir = 'T'
               and d.pfpais = s.pepais
               and d.pftdoc = s.petdoc
               and d.pfndoc = s.pendoc
               and e.sngc13pais = d.pfpais
               and e.sngc13tdoc = d.pftdoc
               and e.sngc13ndoc = d.pfndoc
               and e.docod = 1
               and e.sngc13est = 'H'
               and e.SNGC13CORR = (select max(SNGC13CORR)
                                   from sngc13
                                  where sngc13pais = d.pfpais
                                    and sngc13tdoc = d.pftdoc
                                    and sngc13ndoc = d.pfndoc
                                    and docod = 1
                                    and sngc13est = 'H')
               and rownum = 1;
          Exception
            when no_data_found then
              Begin  
                
                select trim(d.pfndoc),
                       trim(d.pfnom1),
                       trim(d.pfape1),
                       trim(d.pfape2),
                       (select TDNOM from FST014   WHERE TDOCUM = d.pftdoc),
                       d.pffnac,
                       decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                       d.pfcant,
                       substr(e.sngc13dir,1,100),
                       (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                       (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                       (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
                  into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, --telefono1, correo1, 
                       direccion1,depto1,prov1,dist1                  
                  from fsd002 d, sngc13 e
                 where d.pfpais = pais
                   and d.pftdoc = tipodoc
                   and d.pfndoc = dni
                   and e.sngc13pais = d.pfpais
                   and e.sngc13tdoc = d.pftdoc
                   and e.sngc13ndoc = d.pfndoc
                   and e.docod = 1
                   and e.sngc13est = 'H'
                   and e.SNGC13CORR = (select max(SNGC13CORR)
                                       from sngc13
                                      where sngc13pais = pais
                                        and sngc13tdoc = tipodoc
                                        and sngc13ndoc = dni
                                        and docod = 1
                                        and sngc13est = 'H')
                   and rownum = 1;
              
              exception
                when no_Data_found then
                  dni1    := ' ';
                  nombre1 := ' ';
              end;
          End;
          ---TELEFONO
          BEGIN
            select to_number(DOTELFP * 1) 
              into telefono1 ---, correo1,
              from fsr005 f5, fsr008 f8
             where f8.pgcod = 1
               and f8.ctnro = cuenta
               and f8.ttcod = 1
               and f8.cttfir = 'T'
               and f5.PEPAIS = f8.pepais 
               and f5.PETDOC = f8.petdoc 
               and f5.PENDOC = f8.pendoc
               and f5.DOTELFP  not in ('null')
               and length(trim(f5.DOTELFP)) <=10
               and rownum = 1;
          EXCEPTION
            WHEN no_Data_found then
              telefono1:= 0;
            WHEN others then
              telefono1:= 0;
          END ;  

          --CORREO
          BEGIN
           select substr(trim(lower(substr(fs.pextxt,1,(instr(fs.pextxt,'\')-1)))),1,30)
             into correo1
             from fsx001 fs, fsr008 fr
            where fr.pgcod = 1
              and fr.ctnro = cuenta
              and fr.ttcod = 1
              and fr.cttfir = 'T'
              and fs.pepais = fr.pepais 
              and fs.petdoc = fr.petdoc 
              and fs.pendoc = fr.pendoc 
              and fs.txcod = 0 
              and fs.pextxt <> 'SI' 
              and fs.pextxt Like '%@%'
              and rownum = 1;
          EXCEPTION
            when no_Data_found then
              correo1 := null;
          END ;  
          ------
          tipocuenta := null;
          dni2:=null;
          nombre2 := null;
          apepat2 :=null;
          apemat2 :=null;
          tipodoc2 :=null;
          fechnac2 :=null;
          ecivil2 :=null;
          sexo2 :=null;
          telefono2 := null;
          correo2 :=null;
          direccion2 :=null;
          depto2 :=null;
          prov2 :=null;
          dist2 :=null;
          dni3:=null;
          nombre3 := null;
          apepat3 :=null;
          apemat3 :=null;
          tipodoc3 :=null;
          fechnac3 :=null;
          ecivil3 :=null;
          sexo3 :=null;
          telefono3 := null;
          correo3 :=null;
          direccion3 :=null;
          depto3 :=null;
          prov3 :=null;
          dist3 :=null;
          contador := 0;
        BEgin
         select 'Mancomunada'
           into tipocuenta
           from FSR130
          Where Pgcod = 1
            and Ctnro = cuenta
            and CtFacCor between 500 and 511
            and pfndo2  <> dni1
            and rownum = 1;
        exception
          when no_data_found then
            Begin
                  select 'juridica', f3.pjndoc
                    into tipocuenta, documentoj
                    from FSR003 f3,
                         fsr008 f8
                    Where f8.ctnro = cuenta
                      and f8.pepais = 604
                      and f8.petdoc = 9
                      and f3.Pjpais = f8.Pepais
                      and f3.Pjtdoc = f8.Petdoc
                      and f3.Pjndoc = f8.pendoc
                      and rownum = 1;
            exception
            when no_data_found then
              tipocuenta:= 'Individual';
            end;
        end;
        if tipocuenta = 'Mancomunada' then
          for k in integrantes(cuenta) loop
            if contador = 0 then
              dni2     := k.dni;
              nombre2   := k.nombre;
              apepat2   := k.apepa;
              apemat2   := k.apema;
              tipodoc2  := k.tipdoc;
              fechnac2  := k.fenac;
              ecivil2   := k.estadoc;
              sexo2     := k.sexo;
              telefono2 := k.telefono;
              correo2   := k.correo;
              direccion2 := k.direc;
              depto2     := k.depto;
              prov2      := k.prov;
              dist2      := k.distrito;
              contador := contador + 1;
             else
               if contador = 1 then
                  dni3     := k.dni;
                  nombre3   := k.nombre;
                  apepat3   := k.apepa;
                  apemat3   := k.apema;
                  tipodoc3  := k.tipdoc;
                  fechnac3  := k.fenac;
                  ecivil3   := k.estadoc;
                  sexo3     := k.sexo;
                  telefono3 := k.telefono;
                  correo3   := k.correo;
                  direccion3 := k.direc;
                  depto3     := k.depto;
                  prov3      := k.prov;
                  dist3      := k.distrito;
                  contador := contador + 1;
               else
                 exit;
               end if;
             end if;
          end loop;
        else --u
          -------------------sma 19022025--------------
          if tipocuenta ='juridica' then -- j
            For j in juridica(documentoj,dni1) loop
              contador := 0;
              if dni1 is not  null then
                
                    For h in integra_juridica(j.pfpai1,j.pftdo1,j.pfndo1) loop
                      if contador = 0 then
                        dni2     := h.dni;
                        nombre2   := h.nombre;
                        apepat2   := h.apepa;
                        apemat2   := h.apema;
                        tipodoc2  := h.tipdoc;
                        fechnac2  := h.fenac;
                        ecivil2   := h.estadoc;
                        sexo2     := h.sexo;
                        telefono2 := h.telefono;
                        correo2   := h.correo;
                        direccion2 := h.direc;
                        depto2     := h.depto;
                        prov2      := h.prov;
                        dist2      := h.distrito;
                        contador := contador + 1;
                     else
                       if contador = 1 then
                          dni3     := h.dni;
                          nombre3   := h.nombre;
                          apepat3   := h.apepa;
                          apemat3   := h.apema;
                          tipodoc3  := h.tipdoc;
                          fechnac3  := h.fenac;
                          ecivil3   := h.estadoc;
                          sexo3     := h.sexo;
                          telefono3 := h.telefono;
                          correo3   := h.correo;
                          direccion3 := h.direc;
                          depto3     := h.depto;
                          prov3      := h.prov;
                          dist3      := h.distrito;
                          contador := contador + 1;
                       end if;
                     end if;
                  end loop;
              else --ai no hay resultado con dni1
                For h in integra_juridica(j.pfpai1,j.pftdo1,j.pfndo1) loop
                  if contador = 0 then
                      dni1      := h.dni;
                      nombre1   := h.nombre;
                      apepat1   := h.apepa;
                      apemat1   := h.apema;
                      tipodoc1  := h.tipdoc;
                      fechnac1  := h.fenac;
                      ecivil1   := h.estadoc;
                      sexo1     := h.sexo;
                      telefono1 := h.telefono;
                      correo1   := h.correo;
                      direccion1 := h.direc;
                      depto1     := h.depto;
                      prov1      := h.prov;
                      dist1      := h.distrito;
                      contador := contador + 1;
                  else
                    if contador = 1 then
                      dni2     := h.dni;
                      nombre2   := h.nombre;
                      apepat2   := h.apepa;
                      apemat2   := h.apema;
                      tipodoc2  := h.tipdoc;
                      fechnac2  := h.fenac;
                      ecivil2   := h.estadoc;
                      sexo2     := h.sexo;
                      telefono2 := h.telefono;
                      correo2   := h.correo;
                      direccion2 := h.direc;
                      depto2     := h.depto;
                      prov2      := h.prov;
                      dist2      := h.distrito;
                      contador := contador + 1;
                     else
                       if contador = 2 then
                          dni3     := h.dni;
                          nombre3   := h.nombre;
                          apepat3   := h.apepa;
                          apemat3   := h.apema;
                          tipodoc3  := h.tipdoc;
                          fechnac3  := h.fenac;
                          ecivil3   := h.estadoc;
                          sexo3     := h.sexo;
                          telefono3 := h.telefono;
                          correo3   := h.correo;
                          direccion3 := h.direc;
                          depto3     := h.depto;
                          prov3      := h.prov;
                          dist3      := h.distrito;
                          contador := contador + 1;
                       end if;
                     end if;
                 end if;
               end loop;
              end if;
            end loop;
          end if;---fj
        end if;--fu
          agencia := null;
          region  := null;
          BEgin
            select A.scnom, substr(trim(B.JAQN92NOM),1,30)
              into agencia, region
              from fst001 A, JAQN92 B, JAQN93 C
             where A.sucurs = reg.hsucor
               AND C.JAQN93IDS = A.SUCURS
               AND C.JAQN93IDR = B.JAQN92IDR
               ;
          exception
            when no_data_found then
              agencia := reg.hsucor;
          end;

          if mda = 0 then
            moneda := 'SOLES';
          else
            moneda := 'DOLARES';
          end if;
          voucher := null;
          anio:= null;
          mes := null;
          dia := null;
          select substr(EXTRACT(YEAR FROM TRUNC(reg.hfcon)),3,4) into anio from dual;
          Select EXTRACT(MONTH FROM TRUNC(reg.hfcon))into mes from dual;
          Select EXTRACT(DAY FROM TRUNC(reg.hfcon)) into dia from dual;

          voucher:= trim(anio)||lpad(trim(mes),2,'0')||lpad(trim(dia),2,'0')||lpad(reg.hsucor,3,'0')||LPAD(reg.hcmod,3,'0')||reg.htran||lpad(reg.hnREL,4,'0');
          Begin
            select tp1nro2
              into montoa
              from fst198
             where tp1cod = 1
               and tp1cod1 =10884
               and tp1corr1 = 82
               and tp1corr2 = 0
               and TP1IMP1 = importe;
          exception
            when no_data_found then
              montoa:= 500;
          end;
          if dni is null then
            dni := dni1;
            nombre:= substr((trim(apepat1)||' '||trim(apemat1)||' '||trim(nombre1)),1,100) ;
          end if;
          Begin
            insert into aqpa571
              (aqpa571cod,
               aqpa571suc,
               aqpa571mda,
               aqpa571pap,
               aqpa571cta,
               aqpa571oper,
               aqpa571sbop,
               aqpa571tope,
               aqpa571mod,
               aqpa571fech,
               aqpa571fpro,
               aqpa571mon,
               aqpa571tsuc,
               aqpa571tmod,
               aqpa571ttran,
               aqpa571tNrel,
               aqpa571rub,
               aqpa571dni,
               aqpa571Hora,
               aqpa571nom,
               aqpa571age,
               aqpa571au6,
               aqpa571fun,
               aqpa571reg,
               aqpa571FPAG,
               aqpa571mdad,
               aqpa571NROV,
               aqpa571MTOA,
               aqpa571MOTI,
               aqpa571TIPOP1,
               aqpa571TIPOD1,
               aqpa571NDOC1,
               aqpa571APEPA1,
               aqpa571APEMA1,
               aqpa571NOM1,
               aqpa571FNAC1,
               aqpa571SEXO1,
               aqpa571dir1,
               aqpa571depto1,
               aqpa571prov1,
               aqpa571dis1,
               aqpa571tel1,
               aqpa571eciv1,
               aqpa571corr1,
               aqpa571TIPOP2,
               aqpa571TIPOD2,
               aqpa571NDOC2,
               aqpa571APEPA2,
               aqpa571APEMA2,
               aqpa571NOM2,
               aqpa571FNAC2,
               aqpa571SEXO2,
               aqpa571dir2,
               aqpa571depto2,
               aqpa571prov2,
               aqpa571dis2,
               aqpa571tel2,
               aqpa571eciv2,
               aqpa571corr2,
               aqpa571TIPOP3,
               aqpa571TIPOD3,
               aqpa571NDOC3,
               aqpa571APEPA3,
               aqpa571APEMA3,
               aqpa571NOM3,
               aqpa571FNAC3,
               aqpa571SEXO3,
               aqpa571dir3,
               aqpa571depto3,
               aqpa571prov3,
               aqpa571dis3,
               aqpa571tel3,
               aqpa571eciv3,
               aqpa571corr3 )
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               operacion,
               subop,
               tipoper,
               modulo,
               reg.hfcon,
               sysdate,
               importe,
               reg.hsucor,
               reg.hcmod,
               reg.htran,
               reg.hnrel,
               rubro,
               dni,
               reg.hhora,
               nombre,
               agencia,
               'N',
               reg.husing,
               region,
               'EFECTIVO',
               moneda,
               voucher,
               montoa,--MONTO ASEGURADO
               '',--MOTIVO
               'NATURAL',
               tipodoc1,--
               dni1,
               apepat1,
               apemat1,
               nombre1,
               fechnac1,
               sexo1,-- ecivil,
               direccion1,
               depto1,
               prov1,
               dist1,
               telefono1,
               ecivil1,
               correo1 ,
               'NATURAL',
               tipodoc2,--
               dni2,
               apepat2,
               apemat2,
               nombre2,
               fechnac2,
               sexo2,-- ecivil,
               direccion2,
               depto2,
               prov2,
               dist2,
               telefono2,
               ecivil2,
               correo2,
               'NATURAL',
               tipodoc3,--
               dni3,
               apepat3,
               apemat3,
               nombre3,
               fechnac3,
               sexo3,-- ecivil,
               direccion3,
               depto3,
               prov3,
               dist3,
               telefono3,
               ecivil3,
               correo3);
          exception
            when dup_val_on_index then
              null;
          end;
        end if;

      end loop;
      commit;
    end loop;
    Begin
     Select pgfape into fecha from fst017 where pgcod = 1;
    exception
      when no_data_found then
        fecha := sysdate;
    end;
    -----Consultas del dia
    if Fecha2 = fecha then
        For a in tran loop
          For reg in datosDia( Fecha2, a.tp1nro1, a.tp1nro2) loop

             rubro := 0;
             operacion := 0;
             importe := 0;
             modulo := 0;
             tipoper := 0;
             sucur := 0;
             mda := 0;
             pap := 0;
             cuenta := 0;
             oper := 0;
             subop  := 0;
            Begin
              Select rubro ,
                     itoper ,
                     itimp1 ,
                     modulo ,
                     ittope  ,
                     itsuc ,
                     moneda ,
                     papel ,
                     ctnro ,
                     itoper,
                     itsubo
                into rubro,
                     operacion,
                     importe,
                     modulo,
                     tipoper,
                     sucur,
                     mda,
                     pap,
                     cuenta,
                     oper,
                     subop
                from fsd016
               where pgcod = reg.pgcod
                 and itmod = reg.itmod
                 and itsuc = reg.itsuc
                 and ittran = reg.ittran
                 and itnrel = reg.itnrel ---     and itfcon = reg.itfcon
                 and rubro = reg.rubro
                 and modulo = 260;
              verif := 'S';
            Exception
              when no_data_found then
                verif := 'N';
            end;
             ----------------Quien ejecutó el retiro---------------------------------
                Begin
                  select JAQZ153DPA2,JAQZ153DTP2, JAQZ153DNU2, (select penom from fsd001  where pepais =JAQZ153DPA2
                                           and petdoc =JAQZ153DTP2 and pendoc =  JAQZ153DNU2
                                           and rownum = 1)    
                     into pais,tipodoc, dni, nombre
                     from JAQZ153D
                    where JAQZ153DPGC = 1
                      and JAQZ153DSUC= reg.itsuc
                      and JAQZ153DMOD = reg.itmod
                      and JAQZ153DTRX = reg.ittran
                      and JAQZ153DREL = reg.itnrel
                      and JAQZ153DFEC = reg.itfcon
                      and JAQZ153DCTA = cuenta;

                Exception
                  when no_data_found then
                    dni := null; --dni1;
                    nombre := null; --substr((trim(apepat1)||' '||trim(apemat1)||' '||trim(nombre)),1,100);
                              
                end;
            --------------------------------------------------------------------------

            if verif = 'S' then
          
                dni1:=null;
                nombre1 := null;
                apepat1 :=null;
                apemat1 :=null;
                tipodoc1 :=null;
                fechnac1 :=null;
                ecivil1 :=null;
                sexo1 :=null;
                telefono1 := null;
                correo1 :=null;
                direccion1 :=null;
                depto1 :=null;
                prov1 :=null;
                dist1 :=null;
              Begin
                select trim(s.pendoc),
                       trim(d.pfnom1),
                       trim(d.pfape1),
                       trim(d.pfape2),
                       (select TDNOM from FST014   WHERE TDOCUM = s.petdoc),
                       d.pffnac,
                       decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                       d.pfcant,
                        substr(e.sngc13dir,1,100),
                       (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                       (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                       (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
                  into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, direccion1,depto1,prov1,dist1
                  from fsr008 s, fsd002 d, sngc13 e
                 where s.pgcod = 1
                   and s.ctnro = cuenta
                   and s.ttcod = 1
                   and s.cttfir = 'T'
                   and d.pfpais = s.pepais
                   and d.pftdoc = s.petdoc
                   and d.pfndoc = s.pendoc
                   and e.sngc13pais = d.pfpais
                   and e.sngc13tdoc = d.pftdoc
                   and e.sngc13ndoc = d.pfndoc
                   and e.docod = 1
                   and e.sngc13est = 'H'
                   and e.SNGC13CORR = (select max(SNGC13CORR)
                                       from sngc13
                                      where sngc13pais = d.pfpais
                                        and sngc13tdoc = d.pftdoc
                                        and sngc13ndoc = d.pfndoc
                                        and docod = 1
                                        and sngc13est = 'H')
                   and rownum = 1;
              Exception
                when no_data_found then
                  Begin
                    select trim(d.pfndoc),
                           trim(d.pfnom1),
                           trim(d.pfape1),
                           trim(d.pfape2),
                           (select TDNOM from FST014   WHERE TDOCUM = d.pftdoc),
                           d.pffnac,
                           decode(d.pfeciv,'1','C','2','D','3','C','4','S','5','V','6','S'),
                           d.pfcant,
                            substr(e.sngc13dir,1,100),
                           (select depnom from fst068 where pais =604 and depcod =e.sngc13dpto ),-- depto
                           (select LOCNOM from fst070 where pais =604 and depcod = e.sngc13dpto and LOCCOD=e.sngc13prov ),--prov
                           (select fst071dsc from fst071 where fst071pai = 604 and fst071dpt = e.sngc13dpto and fst071loc = e.sngc13prov and fst071col = e.sngc13dist )
                      into dni1,nombre1, apepat1,apemat1,tipodoc1,fechnac1, ecivil1,sexo1, direccion1,depto1,prov1,dist1
                      from fsd002 d, sngc13 e
                     where d.pfpais = pais
                       and d.pftdoc = tipodoc
                       and d.pfndoc = dni
                       and e.sngc13pais = d.pfpais
                       and e.sngc13tdoc = d.pftdoc
                       and e.sngc13ndoc = d.pfndoc
                       and e.docod = 1
                       and e.sngc13est = 'H'
                       and e.SNGC13CORR = (select max(SNGC13CORR)
                                           from sngc13
                                          where sngc13pais = pais
                                            and sngc13tdoc = tipodoc
                                            and sngc13ndoc = dni
                                            and docod = 1
                                            and sngc13est = 'H')
                       and rownum = 1;
                    
                  exception
                    when no_Data_found then
                      dni1    := ' ';
                      nombre1 := ' ';
                  end;    
              End;
              
              ---TELEFONO
              BEGIN
                select to_number(DOTELFP * 1) 
                  into telefono1 ---, correo1,
                  from fsr005 f5, fsr008 f8
                 where f8.pgcod = 1
                   and f8.ctnro = cuenta
                   and f8.ttcod = 1
                   and f8.cttfir = 'T'
                   and f5.PEPAIS = f8.pepais 
                   and f5.PETDOC = f8.petdoc 
                   and f5.PENDOC = f8.pendoc
                   and f5.DOTELFP  not in ('null')
                   and length(trim(f5.DOTELFP)) <=10
                   and rownum = 1;
              EXCEPTION
                WHEN no_Data_found then
                  telefono1:= 0;
                WHEN others then
                  telefono1:= 0;
              END ;  

              --CORREO
              BEGIN
               select substr(trim(lower(substr(fs.pextxt,1,(instr(fs.pextxt,'\')-1)))),1,30)
                 into correo1
                 from fsx001 fs, fsr008 fr
                where fr.pgcod = 1
                  and fr.ctnro = cuenta
                  and fr.ttcod = 1
                  and fr.cttfir = 'T'
                  and fs.pepais = fr.pepais 
                  and fs.petdoc = fr.petdoc 
                  and fs.pendoc = fr.pendoc 
                  and fs.txcod = 0 
                  and fs.pextxt <> 'SI' 
                  and fs.pextxt Like '%@%'
                  and rownum = 1;
              EXCEPTION
                when no_Data_found then
                  correo1 := null;
              END ;  
              tipocuenta := null;
              dni2:=null;
              nombre2 := null;
              apepat2 :=null;
              apemat2 :=null;
              tipodoc2 :=null;
              fechnac2 :=null;
              ecivil2 :=null;
              sexo2 :=null;
              telefono2 := null;
              correo2 :=null;
              direccion2 :=null;
              depto2 :=null;
              prov2 :=null;
              dist2 :=null;
              dni3:=null;
              nombre3 := null;
              apepat3 :=null;
              apemat3 :=null;
              tipodoc3 :=null;
              fechnac3 :=null;
              ecivil3 :=null;
              sexo3 :=null;
              telefono3 := null;
              correo3 :=null;
              direccion3 :=null;
              depto3 :=null;
              prov3 :=null;
              dist3 :=null;
              contador := 0;
            BEgin
             select 'Mancomunada'
               into tipocuenta
               from FSR130
              Where Pgcod = 1
                and Ctnro = cuenta
                and CtFacCor between 500 and 511
                and pfndo2  <> dni1
                and rownum = 1;
            exception
              when no_data_found then
                Begin
                      select 'juridica', f3.pjndoc
                        into tipocuenta, documentoj
                        from FSR003 f3,
                             fsr008 f8
                        Where f8.ctnro = cuenta
                          and f8.pepais = 604
                          and f8.petdoc = 9
                          and f3.Pjpais = f8.Pepais
                          and f3.Pjtdoc = f8.Petdoc
                          and f3.Pjndoc = f8.pendoc
                          and rownum = 1;
                exception
                when no_data_found then
                  tipocuenta:= 'Individual';
                end;
            end;
            if tipocuenta = 'Mancomunada' then
              for k in integrantes(cuenta) loop
                if contador = 0 then
                  dni2     := k.dni;
                  nombre2   := k.nombre;
                  apepat2   := k.apepa;
                  apemat2   := k.apema;
                  tipodoc2  := k.tipdoc;
                  fechnac2  := k.fenac;
                  ecivil2   := k.estadoc;
                  sexo2     := k.sexo;
                  telefono2 := k.telefono;
                  correo2   := k.correo;
                  direccion2 := k.direc;
                  depto2     := k.depto;
                  prov2      := k.prov;
                  dist2      := k.distrito;
                  contador := contador + 1;
                 else
                   if contador = 1 then
                      dni3     := k.dni;
                      nombre3   := k.nombre;
                      apepat3   := k.apepa;
                      apemat3   := k.apema;
                      tipodoc3  := k.tipdoc;
                      fechnac3  := k.fenac;
                      ecivil3   := k.estadoc;
                      sexo3     := k.sexo;
                      telefono3 := k.telefono;
                      correo3   := k.correo;
                      direccion3 := k.direc;
                      depto3     := k.depto;
                      prov3      := k.prov;
                      dist3      := k.distrito;
                      contador := contador + 1;
                   else
                     exit;
                   end if;
                 end if;
              end loop;
            else --u

              if tipocuenta ='juridica' then -- j
                For j in juridica(documentoj, dni1) loop
                  contador := 0;
                  if dni1 is not null then
                    For h in integra_juridica(j.pfpai1,j.pftdo1,j.pfndo1) loop
                      if contador = 0 then
                        dni2     := h.dni;
                        nombre2   := h.nombre;
                        apepat2   := h.apepa;
                        apemat2   := h.apema;
                        tipodoc2  := h.tipdoc;
                        fechnac2  := h.fenac;
                        ecivil2   := h.estadoc;
                        sexo2     := h.sexo;
                        telefono2 := h.telefono;
                        correo2   := h.correo;
                        direccion2 := h.direc;
                        depto2     := h.depto;
                        prov2      := h.prov;
                        dist2      := h.distrito;
                        contador := contador + 1;
                     else
                       if contador = 1 then
                          dni3     := h.dni;
                          nombre3   := h.nombre;
                          apepat3   := h.apepa;
                          apemat3   := h.apema;
                          tipodoc3  := h.tipdoc;
                          fechnac3  := h.fenac;
                          ecivil3   := h.estadoc;
                          sexo3     := h.sexo;
                          telefono3 := h.telefono;
                          correo3   := h.correo;
                          direccion3 := h.direc;
                          depto3     := h.depto;
                          prov3      := h.prov;
                          dist3      := h.distrito;
                          contador := contador + 1;
                       end if;
                     end if;
                    end loop;
                  else --ai no hay resultado con dni1
                    For h in integra_juridica(j.pfpai1,j.pftdo1,j.pfndo1) loop
                      if contador = 0 then
                          dni1      := h.dni;
                          nombre1   := h.nombre;
                          apepat1   := h.apepa;
                          apemat1   := h.apema;
                          tipodoc1  := h.tipdoc;
                          fechnac1  := h.fenac;
                          ecivil1   := h.estadoc;
                          sexo1     := h.sexo;
                          telefono1 := h.telefono;
                          correo1   := h.correo;
                          direccion1 := h.direc;
                          depto1     := h.depto;
                          prov1      := h.prov;
                          dist1      := h.distrito;
                          contador := contador + 1;
                      else
                        if contador = 1 then
                          dni2     := h.dni;
                          nombre2   := h.nombre;
                          apepat2   := h.apepa;
                          apemat2   := h.apema;
                          tipodoc2  := h.tipdoc;
                          fechnac2  := h.fenac;
                          ecivil2   := h.estadoc;
                          sexo2     := h.sexo;
                          telefono2 := h.telefono;
                          correo2   := h.correo;
                          direccion2 := h.direc;
                          depto2     := h.depto;
                          prov2      := h.prov;
                          dist2      := h.distrito;
                          contador := contador + 1;
                         else
                           if contador = 2 then
                              dni3     := h.dni;
                              nombre3   := h.nombre;
                              apepat3   := h.apepa;
                              apemat3   := h.apema;
                              tipodoc3  := h.tipdoc;
                              fechnac3  := h.fenac;
                              ecivil3   := h.estadoc;
                              sexo3     := h.sexo;
                              telefono3 := h.telefono;
                              correo3   := h.correo;
                              direccion3 := h.direc;
                              depto3     := h.depto;
                              prov3      := h.prov;
                              dist3      := h.distrito;
                              contador := contador + 1;
                           end if;
                         end if;
                     end if;
                   end loop;
                  end if;
                end loop;
              end if;---fj
            end if;--fu
              agencia := null;
              region  := null;
              BEgin
                select A.scnom, substr(trim(B.JAQN92NOM),1,30)
                  into agencia, region
                  from fst001 A, JAQN92 B, JAQN93 C
                 where A.sucurs = reg.itsuc
                   AND C.JAQN93IDS = A.SUCURS
                   AND C.JAQN93IDR = B.JAQN92IDR
                   ;
              exception
                when no_data_found then
                  agencia := reg.itsuc;
              end;

              if mda = 0 then
                moneda := 'SOLES';
              else
                moneda := 'DOLARES';
              end if;
              voucher := null;
              anio:= null;
              mes := null;
              dia := null;
              select substr(EXTRACT(YEAR FROM TRUNC(fecha)),3,4) into anio from dual;
              Select EXTRACT(MONTH FROM TRUNC(fecha))into mes from dual;
              Select EXTRACT(DAY FROM TRUNC(fecha)) into dia from dual;

              voucher:= trim(anio)||lpad(trim(mes),2,'0')||lpad(trim(dia),2,'0')||lpad(reg.itsuc,3,'0')||LPAD(reg.itmod,3,'0')||reg.ittran||lpad(reg.itnREL,4,'0');
              Begin
                select tp1nro2
                  into montoa
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 =10884
                   and tp1corr1 = 82
                   and tp1corr2 = 0
                   and TP1IMP1 = importe;
              exception
                when no_data_found then
                  montoa:= 500;
              end;
              if dni is null then
                dni := dni1;
                nombre:= substr((trim(apepat1)||' '||trim(apemat1)||' '||trim(nombre1)),1,100) ;
              end if;              
              Begin
                insert into aqpa571
                  (aqpa571cod,
                   aqpa571suc,
                   aqpa571mda,
                   aqpa571pap,
                   aqpa571cta,
                   aqpa571oper,
                   aqpa571sbop,
                   aqpa571tope,
                   aqpa571mod,
                   aqpa571fech,
                   aqpa571fpro,
                   aqpa571mon,
                   aqpa571tsuc,
                   aqpa571tmod,
                   aqpa571ttran,
                   aqpa571tNrel,
                   aqpa571rub,
                   aqpa571dni,
                   aqpa571Hora,
                   aqpa571nom,
                   aqpa571age,
                   aqpa571au6,
                   aqpa571fun,
                   aqpa571reg,
                   aqpa571FPAG,
                   aqpa571mdad,
                   aqpa571NROV,
                   aqpa571MTOA,
                   aqpa571MOTI,
                   aqpa571TIPOP1,
                   aqpa571TIPOD1,
                   aqpa571NDOC1,
                   aqpa571APEPA1,
                   aqpa571APEMA1,
                   aqpa571NOM1,
                   aqpa571FNAC1,
                   aqpa571SEXO1,
                   aqpa571dir1,
                   aqpa571depto1,
                   aqpa571prov1,
                   aqpa571dis1,
                   aqpa571tel1,
                   aqpa571eciv1,
                   aqpa571corr1,
                   aqpa571TIPOP2,
                   aqpa571TIPOD2,
                   aqpa571NDOC2,
                   aqpa571APEPA2,
                   aqpa571APEMA2,
                   aqpa571NOM2,
                   aqpa571FNAC2,
                   aqpa571SEXO2,
                   aqpa571dir2,
                   aqpa571depto2,
                   aqpa571prov2,
                   aqpa571dis2,
                   aqpa571tel2,
                   aqpa571eciv2,
                   aqpa571corr2,
                   aqpa571TIPOP3,
                   aqpa571TIPOD3,
                   aqpa571NDOC3,
                   aqpa571APEPA3,
                   aqpa571APEMA3,
                   aqpa571NOM3,
                   aqpa571FNAC3,
                   aqpa571SEXO3,
                   aqpa571dir3,
                   aqpa571depto3,
                   aqpa571prov3,
                   aqpa571dis3,
                   aqpa571tel3,
                   aqpa571eciv3,
                   aqpa571corr3 )
                values
                  (1,
                   sucur,
                   mda,
                   pap,
                   cuenta,
                   operacion,
                   subop,
                   tipoper,
                   modulo,
                   fecha,
                   sysdate,
                   importe,
                   reg.itsuc,
                   reg.itmod,
                   reg.ittran,
                   reg.itnrel,
                   rubro,
                   dni,
                   reg.ithora,
                   nombre,
                   agencia,
                   'N',
                   reg.ituing,
                   region,
                   'EFECTIVO',
                   moneda,
                   voucher,
                   montoa,--MONTO ASEGURADO
                   '',--MOTIVO
                   'NATURAL',
                   tipodoc1,--
                   dni1,
                   apepat1,
                   apemat1,
                   nombre1,
                   fechnac1,
                   sexo1,-- ecivil,
                   direccion1,
                   depto1,
                   prov1,
                   dist1,
                   telefono1,
                   ecivil1,
                   correo1 ,
                   'NATURAL',
                   tipodoc2,--
                   dni2,
                   apepat2,
                   apemat2,
                   nombre2,
                   fechnac2,
                   sexo2,-- ecivil,
                   direccion2,
                   depto2,
                   prov2,
                   dist2,
                   telefono2,
                   ecivil2,
                   correo2,
                   'NATURAL',
                   tipodoc3,--
                   dni3,
                   apepat3,
                   apemat3,
                   nombre3,
                   fechnac3,
                   sexo3,-- ecivil,
                   direccion3,
                   depto3,
                   prov3,
                   dist3,
                   telefono3,
                   ecivil3,
                   correo3);
              exception
                when dup_val_on_index then
                  null;
              end;
            end if;

          end loop;
          commit;
        end loop;
    end if;
  end REPORTE_RetiroSeguro;
end PQ_AH_SEGUROS_PASIVAS;
/
