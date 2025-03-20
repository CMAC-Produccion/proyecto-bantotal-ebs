create or replace package PQ_CR_TRASLADO_SAAGRIDES is
  -- Autor : Silvia Marquez Avendaño
  -- Fecha : 26/05/202
  -- Paquete Trasado del Rubro de Seguro Agrico a su correspondiente OT

  procedure CARGA_SAGRICOLA (p_fechapro in date) ;
  --Paquete Traslado del Rubro de Seguro de Desesmpleo a su correspondiente  OT
--  procedure CARGA_SDESEMPEO (p_fecha in number) ;
  procedure CARGA_SDESEMPLEO(p_fechapro in date) ;

end PQ_CR_TRASLADO_SAAGRIDES;
/

create or replace package body PQ_CR_TRASLADO_SAAGRIDES is
    -- Nombre                     : PQ_CR_TRASLADO_SAAGRIDES
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/11/2023
    -- Autor de Creación          : SILVIA MARQUEZ
    -- Uso                        : pROCESO DE CARGA DE TABLAS TEMPORALES PARA EL TRASLADO DE COBROS SEGUROS AGRICOLA Y DESEMPLEO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
 


  procedure CARGA_SAGRICOLA (p_fechapro in date) is
    cursor datos(fechaUno date, FechaDos date) is ---, ord1 number) is
       select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro,
            (select xwfoperacion from xwf700  where xwfprcins = x.jaqm65ins and xwfcar3  = '1') ope,
            (select xwfsubope  from xwf700 where xwfprcins = x.jaqm65ins  and xwfcar3  = '1') subope
        from fsh015 f5, fsh016 f6, jaqm65 x,jaqm66 a
       where f5.pgcod = 1
         and f5.hcmod = 30
         and f5.htran = 440
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2514020000020
         and f6.hmodul = 260
         and a.jaqm66cta = f6.hcta
         and a.jaqm66ime = f6.hcimp1
         and a.jaqm66fea between fechauno and fechados
         and x.jaqm65ins =a.jaqm66ins
         and x.jaqm65tim = a.jaqm66ime
         and x.jaqm65ac1 = 'C';
         


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
  Begin

    Execute immediate ('truncate table aqpa563');
    Fecha1 := TRUNC(p_fechapro, 'MM');
    Fecha2 := last_day(p_fechapro);
    For reg in datos(Fecha1, Fecha2) loop
        --,a.tp1nro3) loop

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
                 reg.ope,
                 reg.subope
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
            dni    := ' ';
            nombre := ' ';
            select s.pendoc,
                   trim(d.pfnom1) || ' ' || trim(d.pfape1) || ' ' ||
                   trim(d.pfape2)
              into dni, nombre
              from fsr008 s, fsd002 d
             where s.pgcod = 1
               and s.ctnro = cuenta
               and s.ttcod = 1
               and s.cttfir = 'T'
               and d.pfpais = s.pepais
               and d.pftdoc = s.petdoc
               and d.pfndoc = s.pendoc
               and rownum = 1;
          Exception
            when no_data_found then
              dni    := ' ';
              nombre := ' ';
          End;
          BEgin
            select scnom
              into agencia
              from fst001
             where sucurs = reg.hsucor;
          exception
            when no_data_found then
              agencia := reg.hsucor;
          end;
          Begin
            insert into AQPA563
              (AQPA563cod,
               AQPA563suc,
               AQPA563mda,
               AQPA563pap,
               AQPA563cta,
               AQPA563oper,
               AQPA563sbop,
               AQPA563tope,
               AQPA563mod,
               AQPA563fech,
               AQPA563fpro,
               AQPA563mon,
               AQPA563tsuc,
               AQPA563tmod,
               AQPA563ttran,
               AQPA563trel,
               AQPA563rub,

               AQPA563dni,
               AQPA563hora,
               AQPA563nom,
               AQPA563age,
               AQPA563au6,
               AQPA563fun)
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               oper,--acion,
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
            insert into AQPA563H
              (AQPA563codH,
               AQPA563sucH,
               AQPA563mdaH,
               AQPA563papH,
               AQPA563ctaH,
               AQPA563operH,
               AQPA563sbopH,
               AQPA563topeH,
               AQPA563modH,
               AQPA563fechH,
               AQPA563fproH,
               AQPA563monH,
               AQPA563tsucH,
               AQPA563tmodH,
               AQPA563ttranH,
               AQPA563tNrelH,
               AQPA563rubH,
               AQPA563dniH,
               AQPA563horaH,
               AQPA563nomH,
               AQPA563ageH,
               AQPA563au6H,
               AQPA563funH)
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               oper,
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
        end if;
      commit;
  end loop;
  end CARGA_SAGRICOLA;
  ----SEGURO DESEMPLEO
  procedure CARGA_SDESEMPLEO(p_fechapro in date) is
    cursor datos(fechaUno date, FechaDos date) is ---, ord1 number) is
       select f5.pgcod,
             f5.hcmod,
             f5.hsucor,
             f5.htran,
             f5.hnrel,
             f5.hfcon,
             f5.husing,
             f5.hhora,
             f6.hrubro,
             (select xwfoperacion from xwf700  where xwfprcins = x.jaqm65ins and xwfcar3  = '1') ope,
             (select xwfsubope  from xwf700 where xwfprcins = x.jaqm65ins  and xwfcar3  = '1') subope
        from fsh015 f5, fsh016 f6, jaqm65 x,jaqm66 a
       where f5.pgcod = 1
         and f5.hcmod = 30
         and f5.htran = 441
         and f5.hfcon between fechauno and fechados
         and f5.hccorr = 0
         and f6.pgcod = f5.pgcod
         and f6.hcmod = f5.hcmod
         and f6.hsucor = f5.hsucor
         and f6.htran = f5.htran
         and f6.hnrel = f5.hnrel
         and f6.hfcon = f5.hfcon
         and f6.hrubro = 2514020000022
         and f6.hmodul = 260
         and a.jaqm66cta = f6.hcta
         and a.jaqm66ime = f6.hcimp1
         and a.jaqm66fea between fechauno and fechados
         and x.jaqm65ins =a.jaqm66ins
         and x.jaqm65tim = a.jaqm66ime
         and x.jaqm65ac1 = 'C';


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
  Begin

    Execute immediate ('truncate table aqpa564');
    Fecha1 := TRUNC(p_fechapro, 'MM');
    Fecha2 := last_day(p_fechapro);
    For reg in datos(Fecha1, Fecha2) loop
        --,a.tp1nro3) loop

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
                 reg.ope,
                 reg.subope
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
            dni    := ' ';
            nombre := ' ';
            select s.pendoc,
                   trim(d.pfnom1) || ' ' || trim(d.pfape1) || ' ' ||
                   trim(d.pfape2)
              into dni, nombre
              from fsr008 s, fsd002 d
             where s.pgcod = 1
               and s.ctnro = cuenta
               and s.ttcod = 1
               and s.cttfir = 'T'
               and d.pfpais = s.pepais
               and d.pftdoc = s.petdoc
               and d.pfndoc = s.pendoc
               and rownum = 1;
          Exception
            when no_data_found then
              dni    := ' ';
              nombre := ' ';
          End;
          BEgin
            select scnom
              into agencia
              from fst001
             where sucurs = reg.hsucor;
          exception
            when no_data_found then
              agencia := reg.hsucor;
          end;
          Begin
            insert into AQPA564
              (AQPA564cod,
               AQPA564suc,
               AQPA564mda,
               AQPA564pap,
               AQPA564cta,
               AQPA564oper,
               AQPA564sbop,
               AQPA564tope,
               AQPA564mod,
               AQPA564fech,
               AQPA564fpro,
               AQPA564mon,
               AQPA564tsuc,
               AQPA564tmod,
               AQPA564ttran,
               AQPA564trel,
               AQPA564rub,

               AQPA564dni,
               AQPA564hora,
               AQPA564nom,
               AQPA564age,
               AQPA564au6,
               AQPA564fun)
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               oper,--acion,
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
            insert into AQPA564H
              (AQPA564codH,
               AQPA564sucH,
               AQPA564mdaH,
               AQPA564papH,
               AQPA564ctaH,
               AQPA564operH,
               AQPA564sbopH,
               AQPA564topeH,
               AQPA564modH,
               AQPA564fechH,
               AQPA564fproH,
               AQPA564monH,
               AQPA564tsucH,
               AQPA564tmodH,
               AQPA564ttranH,
               AQPA564tNrelH,
               AQPA564rubH,
               AQPA564dniH,
               AQPA564horaH,
               AQPA564nomH,
               AQPA564ageH,
               AQPA564au6H,
               AQPA564funH)
            values
              (1,
               sucur,
               mda,
               pap,
               cuenta,
               oper,
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
        end if;
      commit;
  end loop;
  end CARGA_SDESEMPLEO;
end PQ_CR_TRASLADO_SAAGRIDES;
/

