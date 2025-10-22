create or replace procedure SP_CR_CORRIGE_REPROG_TRANSCARTERA(cuenta    in number,
                                                              operacion in number,
                                                              tipo      in number) --- tipo de incidencia
-- *****************************************************************
  -- Nombre                     : SP_CR_CORRIGE_REPROG_TRANSCARTERA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 08/02/2024
  -- Autor de Creación          : SILVIA MARQUEZ
  -- Uso                        : INSERTA /ELIMINA SEGUROS  DESPUES DE ERROR EN LA REPROGRAMACION
  --                              POR TRANSFERENCIA DE CARTERA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : CUENTA / OPERACION
  -- Fecha de Modificación      : 14/05/2024
  -- Autor de la Modificación   : SMARQUEZ
  -- Descripción de Modificación: ADICIÓN DE TIPO PARA DIFERENCIAR INCIDENCIAS
  -- Modificación               : SMARQUEZ 12/06/2024 ADICIÓN DE LA OPCION SEGURO VEHICULAR
  -- Modificacion               : SMARQUEZ 14/08/2024 CONTROL DE  ELIMINACION
  -- *****************************************************************

is

  cursor seguros(mod2  in number,
                 cta2  in number,
                 oper2 in number,
                 mda2  in number,
                 suc2  in number,
                 tope2 in number) is
    select PGCOD,
           AOMOD,
           AOSUC,
           AOMDA,
           AOPAP,
           AOCTA,
           AOOPER,
           AOSBOP,
           AOTOPE,
           SGCOD,
           PP001VC,
           PP001IMP,
           PP001PORC,
           PP001PLUS,
           PP001PART,
           PP001VEH,
           PP001INM,
           PP001END,
           PP001STAT,
           PP001CO
      from fpp001
     where pgcod = 1
       and aomod = mod2
       and aocta = cta2
       and aooper = oper2
       and aosbop = 609 --subop2
       and aomda = mda2
       and aotope = tope2;
 cursor dupli (cta in number, ope in number) is
         select a.*
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
             and b.aostat <> 99
           where b.aosbop = (SELECT MAX(AOSBOP)
                               FROM FSD010
                               WHERE b.pgcod = pgcod
                                 and b.aomod = aomod
                                 and b.aosuc = aosuc
                                 and b.aomda = aomda
                                 and b.aopap = aopap
                                 and b.aocta = aocta
                                 and b.aooper = aooper
                                 and b.aosbop = aosbop
                                 and b.aotope = aotope
                                 and b.aostat <> 99)
             and a.aocta = cta
             and a.aooper = ope ;


  cursor VidaC (cta in number, ope in number)is
   select a.*
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
             and b.aostat <> 99
           where b.aosbop = (SELECT MAX(AOSBOP)
                               FROM FSD010
                               WHERE b.pgcod = pgcod
                                 and b.aomod = aomod
                                 and b.aosuc = aosuc
                                 and b.aomda = aomda
                                 and b.aopap = aopap
                                 and b.aocta = aocta
                                 and b.aooper = aooper
                                 and b.aosbop = aosbop
                                 and b.aotope = aotope
                                 and b.aostat <> 99)
             and a.aocta = cta
             and a.aooper = ope
             and a.sgcod in (select sgcod from fst300 where sgsn02 ='1' and sgcod >119)
             ;
  cursor MULTI(cta in number, ope in number)is
   select a.*
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
             and b.aostat <> 99
           where b.aosbop = (SELECT MAX(AOSBOP)
                               FROM FSD010
                               WHERE b.pgcod = pgcod
                                 and b.aomod = aomod
                                 and b.aosuc = aosuc
                                 and b.aomda = aomda
                                 and b.aopap = aopap
                                 and b.aocta = aocta
                                 and b.aooper = aooper
                                 and b.aosbop = aosbop
                                 and b.aotope = aotope
                                 and b.aostat <> 99)
             and a.aocta = cta
             and a.aooper = ope
             and a.sgcod in (select sgcod from fst300 where sgsn02 ='3' and sgcod >165)
             ;

cursor DESGRA(cta in number, ope in number)is
   select a.*
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
             and b.aostat <> 99
           where b.aosbop = (SELECT MAX(AOSBOP)
                               FROM FSD010
                               WHERE b.pgcod = pgcod
                                 and b.aomod = aomod
                                 and b.aosuc = aosuc
                                 and b.aomda = aomda
                                 and b.aopap = aopap
                                 and b.aocta = aocta
                                 and b.aooper = aooper
                                 and b.aosbop = aosbop
                                 and b.aotope = aotope
                                 and b.aostat <> 99)
             and a.aocta = cta
             and a.aooper = ope
             and a.sgcod in (select sgcod from fst300 where sgsn02 ='5')
             ;
  cursor VEHICULAR(cta in number, ope in number)is
   select a.*
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
             and b.aostat <> 99
           where b.aosbop = (SELECT MAX(AOSBOP)
                               FROM FSD010
                               WHERE b.pgcod = pgcod
                                 and b.aomod = aomod
                                 and b.aosuc = aosuc
                                 and b.aomda = aomda
                                 and b.aopap = aopap
                                 and b.aocta = aocta
                                 and b.aooper = aooper
                                 and b.aosbop = aosbop
                                 and b.aotope = aotope
                                 and b.aostat <> 99)
             and a.aocta = cta
             and a.aooper = ope
             and a.sgcod in (select sgcod from fst300 where sgsn02 ='3' and sgcod <= 155)
             ;
cursor dato1(cta in number, ope in number, sbo in number) is
 select * from fsd611
  where ppcta = cta
    and ppoper = ope
    and ppsbop = sbo
  --  and ppfpag > sysdate
    and ppfpag > (select Max(ppfpag)  from fsd602
                    where ppcta = cta
                      and ppoper = ope
                      and ppsbop = sbo
                      and pp1stat ='T'
                      and d602co= 'S' )
    order by ppsbop , ppfpag;
cursor dato2(cta in number, ope in number, sbo in number) is
 select * from fsd611
  where ppcta = cta
    and ppoper = ope
    and ppsbop = sbo
    order by ppsbop , ppfpag;
  sucursal number;
  mod1     number;
  subop    number;
  tope     number;
  mda      number;
  cta1     number;
  oper1    number;

  contador  number;
  contador1 number;
  correl    number:= 0;

  n_cont number;
 --- existe char(1);
  Flag   char(1);
  Fleje  char(1);
begin

    n_cont := 0;
    Flag   := 'N';
    fleje  := 'N';
    select count(*)
      into n_cont
      from fsd010
     where aocta = CUENTA
       and aooper = OPERACION
       and aomod in (select modulo from fst111 where dscod = 50)
       and aostat <> 99;


  IF TIPO = 1 THEN --- TRANSFERENCIA DE CARTERA
    --count(*)=0 output
   if n_cont > 0 then
     Begin
      select aosuc, aomod, aocta, aooper, aosbop, aotope, aomda
        into sucursal, mod1, cta1, oper1, subop, tope, mda
        from fsd010
       where aocta = CUENTA
         and aooper = OPERACION
         and aomod in (select modulo from fst111 where dscod = 50)
         and aostat <> 99
         ;
    exception
      when others then
        sucursal := 0;
    end;

    for a in seguros(mod1, cta1, oper1, mda, sucursal, tope) loop
      contador := 0;
      select count(*)
        into contador
        from fpp001
       where pgcod = a.pgcod
         and aomod = a.aomod
         and aocta = a.aocta
         and aooper = a.aooper
         and aosbop = 609 --subop2
         and aomda = a.aomda
         and aotope = a.aotope;
      if contador <> 0 then
        begin
          insert into fpp001
            (PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE,
             SGCOD,
             PP001VC,
             PP001IMP,
             PP001PORC,
             PP001PLUS,
             PP001PART,
             PP001VEH,
             PP001INM,
             PP001END,
             PP001STAT,
             PP001CO)
          values
            (a.PGCOD,
             a.AOMOD,
             sucursal,
             a.AOMDA,
             a.AOPAP,
             a.AOCTA,
             a.AOOPER,
             subop,
             a.AOTOPE,
             a.SGCOD,
             a.PP001VC,
             a.PP001IMP,
             a.PP001PORC,
             a.PP001PLUS,
             a.PP001PART,
             a.PP001VEH,
             a.PP001INM,
             a.PP001END,
             a.PP001STAT,
             a.PP001CO);
        exception
          when dup_val_on_index then
            dbms_output.put_line('ExisteSeguro ' || ' ' || a.sgcod);
        end;
        commit;

        begin
          insert into fpp001
            (PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE,
             SGCOD,
             PP001VC,
             PP001IMP,
             PP001PORC,
             PP001PLUS,
             PP001PART,
             PP001VEH,
             PP001INM,
             PP001END,
             PP001STAT,
             PP001CO)
          values
            (a.PGCOD,
             a.AOMOD,
             sucursal,
             a.AOMDA,
             a.AOPAP,
             a.AOCTA,
             a.AOOPER,
             a.AOSBOP,
             a.AOTOPE,
             a.SGCOD,
             a.PP001VC,
             a.PP001IMP,
             a.PP001PORC,
             a.PP001PLUS,
             a.PP001PART,
             a.PP001VEH,
             a.PP001INM,
             a.PP001END,
             a.PP001STAT,
             a.PP001CO);
        exception
          when dup_val_on_index then
            dbms_output.put_line('ExisteSeguro 609 ' || ' ' || a.sgcod);
        end;

        dbms_output.put_line('No existen registros para esa cuenta y opeacion  ' || ' ' ||
                             a.AOCTA || ' ' || a.AOOPER);

      end if;

    end loop;

    EXECUTE IMMEDIATE 'create table operador.fpp001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fpp001 where aocta=' ||
                      cuenta ||' and aooper='||operacion;

      delete fpp001
       where aocta = cuenta
         and aooper = operacion
         and aosbop = subop
         and aosuc <> sucursal;
      delete fpp001
       where aocta = cuenta
         and aooper = operacion
         and aosbop = 609
         and aosuc <> sucursal;
      commit;


    else
          dbms_output.put_line('No existen registros para esa cuenta y operacion en la fsd010');
    end if;
  ELSIF TIPO = 2 THEN -----DUPLICADOS
     if n_cont > 0 then
       for r in dupli(cuenta, operacion) loop
          begin
              insert into fpp001
                (PGCOD,
                 AOMOD,
                 AOSUC,
                 AOMDA,
                 AOPAP,
                 AOCTA,
                 AOOPER,
                 AOSBOP,
                 AOTOPE,
                 SGCOD,
                 PP001VC,
                 PP001IMP,
                 PP001PORC,
                 PP001PLUS,
                 PP001PART,
                 PP001VEH,
                 PP001INM,
                 PP001END,
                 PP001STAT,
                 PP001CO)
              values
                 (r.PGCOD,
                 r.AOMOD,
                 r.aosuc,
                 r.AOMDA,
                 r.AOPAP,
                 r.AOCTA,
                 r.AOOPER,
                 609,
                 r.AOTOPE,
                 r.SGCOD,
                 r.PP001VC,
                 r.PP001IMP,
                 r.PP001PORC,
                 r.PP001PLUS,
                 r.PP001PART,
                 r.PP001VEH,
                 r.PP001INM,
                 r.PP001END,
                 r.PP001STAT,
                 r.PP001CO);
        exception
          when dup_val_on_index then
            dbms_output.put_line('ExisteSeguro con la subope 609 ' || ' ' || r.sgcod);
        end;
        commit;
       end loop;
     end if;
  elsif TIPO = 3 THEN ---ELIMINA  VIDA CAJA
    if n_cont > 0 then
       EXECUTE IMMEDIATE 'create table operador.fpp001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fpp001 where aocta=' ||
                      cuenta ||' and aooper='||operacion;
       EXECUTE IMMEDIATE 'create table operador.fsd611_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fsd611 where ppcta=' ||
                      cuenta ||' and ppoper='||operacion;
       for v in Vidac(cuenta, operacion) loop
         select count(*)
           into contador1
           from fpp001
          where pgcod = v.pgcod
            and aomod = v.aomod
            and aocta = v.aocta
            and aooper = v.aooper
            and aosbop = v.aosbop
            and aomda = v.aomda
            and aotope = v.aotope;
            fleje := 'N';
          if contador1 = 3 then
                  for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp11 = ppimp12
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = ppimp13
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set  ppimp13 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje := 'S';
                    end loop;
                    if fleje = 'N' then
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp11 = ppimp12
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope;
                            commit;
                       end loop;
                       for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp12 = ppimp13
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                       end loop;
                       for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set  ppimp13 = 0
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                       end loop;
                    end if;

                    Flag := 'S';

          elsif  contador1 = 2 then

                   for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp11 = ppimp12
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje :='S';
                    end loop;
                    if fleje = 'N' then
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp11 = ppimp12
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                       end loop;
                       for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp12 = 0
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                       end loop;
                    end if;
                    Flag := 'S';

          elsif Contador1 = 1 then

                   for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp11 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje := 'S';
                    end loop;
                    if fleje = 'N' then
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                          update fsd611
                            set ppimp11 = 0
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            ;
                            commit;
                       end loop;
                    end if;
                    Flag := 'S';
          else
            Flag := 'N';
          end if;
          if Flag = 'S' then
            select max(evcorr) + 1
              into correl
              from fsd012
             where pgcod = 1
               and aomod = v.aomod
               and aosuc = v.aosuc
               and aomda = v.aomda
               and aopap = v.aopap
               and aocta = v.aocta
               and aooper = v.aooper
               and aosbop = v.aosbop
               and aotope = v.aotope
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S';
             if correl is null then
                correl := 1;
              end if;
             begin
              insert into fsd012(pgcod,
                                  aomod,
                                  aosuc ,
                                  aomda,
                                  aopap,
                                  aocta,
                                  aooper,
                                  aosbop,
                                  aotope,
                                  evfval,
                                  evtipo,
                                  evcd02,
                                  d012co,
                                  evimp,
                                  evcap,
                                  EVCORR )
                           VALUES (1,
                                  v.aomod,
                                  v.aosuc,
                                  v.aomda,
                                  v.aopap,
                                  v.aocta,
                                  v.aooper,
                                  v.aosbop,
                                  v.aotope,
                                  SYSDATE,
                                  47,
                                  'B',
                                  'S',
                                  v.PP001IMP,
                                  v.sgcod,
                                  correl );
            exception
              when dup_val_on_index then
                null;
            end;
            delete fpp001
             where aocta = v.aocta
               and aooper = v.aooper
               and aosbop >= v.aosbop
               and aosuc = v.aosuc
               and sgcod = v.sgcod;
               commit;
          end if;
       end loop;
    end if;
  elsif TIPO = 4 THEN ---ELIMINA  Multiriesgo
    if n_cont > 0 then
       EXECUTE IMMEDIATE 'create table operador.fpp001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fpp001 where aocta=' ||
                      cuenta ||' and aooper='||operacion;
       EXECUTE IMMEDIATE 'create table operador.fsd611_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fsd611 where ppcta=' ||
                      cuenta ||' and ppoper='||operacion;
       for v in Multi(cuenta, operacion )loop
           contador1 := 0;
           -- Valida si tiene vida caja
             select count(*)
               into contador1
               from fpp001
              where pgcod = v.pgcod
                and aomod = v.aomod
                and aocta = v.aocta
                and aooper = v.aooper
                and aosbop = v.aosbop
                and aomda = v.aomda
                and aotope = v.aotope
                and sgcod in ( select sgcod from fst300 where sgsn02 ='1' and sgcod >119);
                if contador1 = 1 then
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = ppimp13
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp13 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        Fleje :='S';
                    end loop;
                    if fleje ='N' then
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                       update fsd611
                          set ppimp12 = ppimp13
                        where pgcod = a.pgcod
                          and ppmod = a.ppmod
                          and ppsuc = a.ppsuc
                          and ppmda = a.ppmda
                          and pppap = a.pppap
                          and ppcta = a.ppcta
                          and ppoper = a.ppoper
                          and ppsbop = a.ppsbop
                          and pptope = a.pptope
                          and ppfpag = a.ppfpag;
                          commit;
                      end loop;
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                       update fsd611
                          set ppimp13 = 0
                        where pgcod = a.pgcod
                          and ppmod = a.ppmod
                          and ppsuc = a.ppsuc
                          and ppmda = a.ppmda
                          and pppap = a.pppap
                          and ppcta = a.ppcta
                          and ppoper = a.ppoper
                          and ppsbop = a.ppsbop
                          and pptope = a.pptope
                          and ppfpag = a.ppfpag;
                          commit;
                      end loop;
                    end if;
                    Flag := 'S';
          elsif contador1 = 0 then
               for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp11 = ppimp12
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje := 'S';
                     end loop;
                     if fleje = 'N' then
                        for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp11 = ppimp12
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                        end loop;
                        for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp12 = 0
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                         end loop;
                     end if;
                     Flag := 'S';
          else
            Flag := 'N';
          end if;
          if Flag = 'S' then
             select max(evcorr) + 1
              into correl
              from fsd012
             where pgcod = 1
               and aomod = v.aomod
               and aosuc = v.aosuc
               and aomda = v.aomda
               and aopap = v.aopap
               and aocta = v.aocta
               and aooper = v.aooper
               and aosbop = v.aosbop
               and aotope = v.aotope
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S';
              if correl is null then
                correl := 1;
              end if;
              begin
                insert into fsd012(pgcod,
                                  aomod,
                                  aosuc ,
                                  aomda,
                                  aopap,
                                  aocta,
                                  aooper,
                                  aosbop,
                                  aotope,
                                  evfval,
                                  evtipo,
                                  evcd02,
                                  d012co,
                                  evimp,
                                  evcap,
                                  EVCORR )
                           VALUES (1,
                                  v.aomod,
                                  v.aosuc,
                                  v.aomda,
                                  v.aopap,
                                  v.aocta,
                                  v.aooper,
                                  v.aosbop,
                                  v.aotope,
                                  SYSDATE,
                                  47,
                                  'B',
                                  'S',
                                  v.PP001IMP,
                                  v.sgcod,
                                  correl );
              exception
                when dup_val_on_index then
                  null;
              end;
              delete fpp001
               where aocta = v.aocta
                 and aooper = v.aooper
                 and aosbop >= v.aosbop
                 and aosuc = v.aosuc
                 and sgcod = v.sgcod;
              commit;
          end if;
        end loop;
    end if;
  elsif TIPO = 5 THEN ---ELIMINA  Desgravamen
    if n_cont > 0 then
       EXECUTE IMMEDIATE 'create table operador.fpp001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fpp001 where aocta=' ||
                      cuenta ||' and aooper='||operacion;
       EXECUTE IMMEDIATE 'create table operador.fsd611_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fsd611 where ppcta=' ||
                      cuenta ||' and ppoper='||operacion;
       for v in Desgra(cuenta, operacion )loop
           contador1 := 0;
             select count(*)
               into contador1
               from fpp001
              where pgcod = v.pgcod
                and aomod = v.aomod
                and aocta = v.aocta
                and aooper = v.aooper
                and aosbop = v.aosbop
                and aomda = v.aomda
                and aotope = v.aotope;
           if contador1 = 1 then
              for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                 update fsd611
                    set ppimp11 = 0
                  where pgcod = a.pgcod
                    and ppmod = a.ppmod
                    and ppsuc = a.ppsuc
                    and ppmda = a.ppmda
                    and pppap = a.pppap
                    and ppcta = a.ppcta
                    and ppoper = a.ppoper
                    and ppsbop = a.ppsbop
                    and pptope = a.pptope
                    and ppfpag = a.ppfpag;
                    commit;
                    fleje := 'S';
               end loop;
               if  fleje = 'N' then
                 for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                 update fsd611
                    set ppimp11 = 0
                  where pgcod = a.pgcod
                    and ppmod = a.ppmod
                    and ppsuc = a.ppsuc
                    and ppmda = a.ppmda
                    and pppap = a.pppap
                    and ppcta = a.ppcta
                    and ppoper = a.ppoper
                    and ppsbop = a.ppsbop
                    and pptope = a.pptope
                    and ppfpag = a.ppfpag;
                    commit;

                  end loop;
               end if;
               flag := 'S';
           elsif contador1 = 2 then
             for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                 update fsd611
                    set ppimp12 = 0
                  where pgcod = a.pgcod
                    and ppmod = a.ppmod
                    and ppsuc = a.ppsuc
                    and ppmda = a.ppmda
                    and pppap = a.pppap
                    and ppcta = a.ppcta
                    and ppoper = a.ppoper
                    and ppsbop = a.ppsbop
                    and pptope = a.pptope
                    and ppfpag = a.ppfpag;
                    commit;
                    fleje := 'S';
               end loop;
               if fleje = 'N' then
                 for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                   update fsd611
                      set ppimp12 = 0
                    where pgcod = a.pgcod
                      and ppmod = a.ppmod
                      and ppsuc = a.ppsuc
                      and ppmda = a.ppmda
                      and pppap = a.pppap
                      and ppcta = a.ppcta
                      and ppoper = a.ppoper
                      and ppsbop = a.ppsbop
                      and pptope = a.pptope
                      and ppfpag = a.ppfpag;
                      commit;

                 end loop;
               end if;
               flag := 'S';
           elsif  contador1 = 3 then
             for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                 update fsd611
                    set ppimp13 = 0
                  where pgcod = a.pgcod
                    and ppmod = a.ppmod
                    and ppsuc = a.ppsuc
                    and ppmda = a.ppmda
                    and pppap = a.pppap
                    and ppcta = a.ppcta
                    and ppoper = a.ppoper
                    and ppsbop = a.ppsbop
                    and pptope = a.pptope
                    and ppfpag = a.ppfpag;
                    commit;
                    Fleje := 'S';
               end loop;
               if fleje = 'N' then
                  for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                   update fsd611
                      set ppimp13 = 0
                    where pgcod = a.pgcod
                      and ppmod = a.ppmod
                      and ppsuc = a.ppsuc
                      and ppmda = a.ppmda
                      and pppap = a.pppap
                      and ppcta = a.ppcta
                      and ppoper = a.ppoper
                      and ppsbop = a.ppsbop
                      and pptope = a.pptope
                      and ppfpag = a.ppfpag;
                      commit;

                 end loop;
               end if;
               flag := 'S';
           else
             Flag := 'N';
           end if;
           if Flag = 'S' then
              select max(evcorr) + 1
              into correl
              from fsd012
             where pgcod = 1
               and aomod = v.aomod
               and aosuc = v.aosuc
               and aomda = v.aomda
               and aopap = v.aopap
               and aocta = v.aocta
               and aooper = v.aooper
               and aosbop = v.aosbop
               and aotope = v.aotope
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S';
              if correl is null then
                correl := 1;
              end if;
              begin
               insert into fsd012(pgcod,
                                  aomod,
                                  aosuc ,
                                  aomda,
                                  aopap,
                                  aocta,
                                  aooper,
                                  aosbop,
                                  aotope,
                                  evfval,
                                  evtipo,
                                  evcd02,
                                  d012co,
                                  evimp,
                                  evcap,
                                  EVCORR )
                           VALUES (1,
                                  v.aomod,
                                  v.aosuc,
                                  v.aomda,
                                  v.aopap,
                                  v.aocta,
                                  v.aooper,
                                  v.aosbop,
                                  v.aotope,
                                  SYSDATE,
                                  47,
                                  'B',
                                  'S',
                                  v.PP001IMP,
                                  v.sgcod,
                                  correl );

              exception
                when dup_val_on_index then
                  null;
              end;
              delete fpp001
               where aocta = v.aocta
                 and aooper = v.aooper
                 and aosbop >= v.aosbop
                 and aosuc = v.aosuc
                 and sgcod = v.sgcod;
              commit;
          end if;
       end loop;
    end if;
  elsif TIPO = 6 THEN ---ELIMINA VEHICULAR
     if n_cont > 0 then
       EXECUTE IMMEDIATE 'create table operador.fpp001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fpp001 where aocta=' ||
                      cuenta ||' and aooper='||operacion;
       EXECUTE IMMEDIATE 'create table operador.fsd611_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from fsd611 where ppcta=' ||
                      cuenta ||' and ppoper='||operacion;
       for v in VEHICULAR(cuenta, operacion )loop
           contador1 := 0;
             select count(*)
               into contador1
               from fpp001
              where pgcod = v.pgcod
                and aomod = v.aomod
                and aocta = v.aocta
                and aooper = v.aooper
                and aosbop = v.aosbop
                and aomda = v.aomda
                and aotope = v.aotope
                and sgcod in ( select sgcod from fst300 where sgsn02 ='1' and sgcod >119);
          if contador1 = 1 then
               for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = ppimp13
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp13 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje:= 'S';
                    end loop;
                    if fleje = 'N' then
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                       update fsd611
                          set ppimp12 = ppimp13
                        where pgcod = a.pgcod
                          and ppmod = a.ppmod
                          and ppsuc = a.ppsuc
                          and ppmda = a.ppmda
                          and pppap = a.pppap
                          and ppcta = a.ppcta
                          and ppoper = a.ppoper
                          and ppsbop = a.ppsbop
                          and pptope = a.pptope
                          and ppfpag = a.ppfpag;
                          commit;
                      end loop;
                      for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                       update fsd611
                          set ppimp13 = 0
                        where pgcod = a.pgcod
                          and ppmod = a.ppmod
                          and ppsuc = a.ppsuc
                          and ppmda = a.ppmda
                          and pppap = a.pppap
                          and ppcta = a.ppcta
                          and ppoper = a.ppoper
                          and ppsbop = a.ppsbop
                          and pptope = a.pptope
                          and ppfpag = a.ppfpag;
                          commit;
                          fleje:= 'S';
                      end loop;
                    end if;
                    Flag := 'S';
          elsif contador1 = 0 then
               for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp11 = ppimp12
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                    end loop;
                    for a in dato1(v.aocta,v.aooper, v.aosbop) loop
                     update fsd611
                        set ppimp12 = 0
                      where pgcod = a.pgcod
                        and ppmod = a.ppmod
                        and ppsuc = a.ppsuc
                        and ppmda = a.ppmda
                        and pppap = a.pppap
                        and ppcta = a.ppcta
                        and ppoper = a.ppoper
                        and ppsbop = a.ppsbop
                        and pptope = a.pptope
                        and ppfpag = a.ppfpag;
                        commit;
                        fleje:='S';
                     end loop;
                     if Fleje = 'N' then
                       for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp11 = ppimp12
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                        end loop;
                        for a in dato2(v.aocta,v.aooper, v.aosbop) loop
                         update fsd611
                            set ppimp12 = 0
                          where pgcod = a.pgcod
                            and ppmod = a.ppmod
                            and ppsuc = a.ppsuc
                            and ppmda = a.ppmda
                            and pppap = a.pppap
                            and ppcta = a.ppcta
                            and ppoper = a.ppoper
                            and ppsbop = a.ppsbop
                            and pptope = a.pptope
                            and ppfpag = a.ppfpag;
                            commit;
                            fleje:='S';
                        end loop;
                       end if;

                     Flag := 'S';
          else
            Flag := 'N';
          end if;
          if Flag = 'S' then
             select max(evcorr) + 1
              into correl
              from fsd012
             where pgcod = 1
               and aomod = v.aomod
               and aosuc = v.aosuc
               and aomda = v.aomda
               and aopap = v.aopap
               and aocta = v.aocta
               and aooper = v.aooper
               and aosbop = v.aosbop
               and aotope = v.aotope
               and evtipo = 47
               and evcd02 = 'B'
               and d012co = 'S';
              if correl is null then
                correl := 1;
              end if;
              begin
                insert into fsd012(pgcod,
                                  aomod,
                                  aosuc ,
                                  aomda,
                                  aopap,
                                  aocta,
                                  aooper,
                                  aosbop,
                                  aotope,
                                  evfval,
                                  evtipo,
                                  evcd02,
                                  d012co,
                                  evimp,
                                  evcap,
                                  EVCORR )
                           VALUES (1,
                                  v.aomod,
                                  v.aosuc,
                                  v.aomda,
                                  v.aopap,
                                  v.aocta,
                                  v.aooper,
                                  v.aosbop,
                                  v.aotope,
                                  SYSDATE,
                                  47,
                                  'B',
                                  'S',
                                  v.PP001IMP,
                                  v.sgcod,
                                  correl );
              exception
                when dup_val_on_index then
                  null;
              end;
              delete fpp001
               where aocta = v.aocta
                 and aooper = v.aooper
                 and aosbop >= v.aosbop
                 and aosuc = v.aosuc
                 and sgcod = v.sgcod;
              commit;
          end if;
        end loop;
    end if;
    elsif tipo = 7 then
       for v in dupli(cuenta, operacion) loop
          contador1 := 0;
          select count(*)
           into contador1
           from fpp001
          where pgcod = v.pgcod
            and aomod = v.aomod
            and aocta = v.aocta
            and aooper = v.aooper
            and aosbop = v.aosbop
            and aomda = v.aomda
            and aotope = v.aotope;
           if contador1 > 5 then
             delete fpp001
                   where aocta = v.aocta
                     and aomod = v.aomod
                     and aooper = v.aooper
                     and aosbop >= v.aosbop
                     and aosuc = v.aosuc;
              update fsd611
                 set ppimp11 = 0,
                     ppimp12 = 0,
                     ppimp13 = 0,
                     ppimp14 = 0,
                     ppimp15 = 0
               where ppcta = v.aocta
                 and ppmod = v.aomod
                 and ppoper = v.aooper
                 and ppsbop >= v.aosbop;
           end if;

        end loop;
  end if;
  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_CR_CORRIGE_REPROG_TRANSCARTERA',
     cuenta || '-' || operacion|| '-' ||tipo);
  commit;
end SP_CR_CORRIGE_REPROG_TRANSCARTERA;
/
