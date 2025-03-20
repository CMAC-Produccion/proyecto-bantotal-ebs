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
end PQ_AH_SEGUROS_PASIVAS;
/

create or replace package body PQ_AH_SEGUROS_PASIVAS is
  ---------------------------------------------------------------
  -- Proyecto    : 2342 Adecuacion para realizar el Retiro Protegido
  -- Autor       : Silvia Marquez
  -- Fecha       : 25/02/2020
  -- Modificacion: SMARQUEZ 03/02/2025 ACTUALIZACION REPORTE Compilacion de campos correctos
  -- Modificación: SMARQUEZ 03/03/2025 Error en conversión de numero linea 250
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
         and f6.hmodul = 260;
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
                   (select to_number(DOTELFP * 1) from fsr005
                     where PEPAIS = s.pepais and PETDOC = s.petdoc and  PENDOC =s.pendoc
                       and DOTELFp  not in ('null')
                       and length(trim(DOTELFP)) <=10
                       and rownum = 1),
                   (select substr(trim(lower(substr(pextxt,1,(instr(pextxt,'\')-1)))),1,30)from fsx001 where pepais = s.pepais and petdoc = s.petdoc and pendoc = s.pendoc and                      txcod = 0 and pextxt <> 'SI' and pextxt Like '%@%'and rownum = 1),
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
	      dbms_output.put_line('exception:'||cuenta);
          End;
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

end PQ_AH_SEGUROS_PASIVAS;
/

