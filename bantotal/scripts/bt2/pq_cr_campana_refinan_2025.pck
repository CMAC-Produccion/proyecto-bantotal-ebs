create or replace package PQ_CR_CAMPANA_REFINAN_2025 is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CAMPANA_REFINAN_2025
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Creditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.02.27
  -- Autor de Creación          : YYAMPI
  -- Uso                        : Rutina de calculo de factor de ajuste
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Parámetros de Salida       :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************
  -------------------------------------------------------------------------

  PROCEDURE SP_CR_AJUSTE(pn_cuenta    in number,
                         pn_operacion in number,
                         pd_fechaini  in date,
                         pn_dias      in number,
                         pn_interes   in number);

-------------------------------------------------------------------------

end PQ_CR_CAMPANA_REFINAN_2025;
/

create or replace package body PQ_CR_CAMPANA_REFINAN_2025 is

  ----------------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_AJUSTE(pn_cuenta    in number,
                         pn_operacion in number,
                         pd_fechaini  in date,
                         pn_dias      in number,
                         pn_interes   in number) is

    -- *****************************************************************
    -- Nombre                     : SP_CR_AJUSTE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2025.02.27
    -- Autor de Creación          : YYAMPI /DCASTRO
    -- Uso                        : RETORNA VALOR FACTOR DE AJUSTE
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_cuenta ( CUENTA )
    --                            : pn_operacion ( OPERACION )
    --                            : pd_fechaini ( FECHA INICIO  )
    --                            : pn_dias ( DIAS )
    --                            : pn_interes ( INTERES )

    -- Parámetros de Salida       : pn_result ( FACTOR RESULTADO)
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    v_cta             number(9);
    v_ope             number(9);
    v_fechaini        date;
    v_fecfin          date;
    v_interes         number;
    ln_interes_cuota  number;
    ln_interes_pagado number;
    ln_cantidad       number;
    v_dias            number;
    pn_cod            number;
    pn_mod            number;
    pn_suc            number;
    pn_mda            number;
    pn_pap            number;
    pn_cta            number(9);
    pn_ope            number(9);
    pn_sbo            number;
    pn_top            number;
    HORA              CHAR(6) := to_char(sysdate, 'HH24MMSS');
    SQL_CREATE        VARCHAR(3000);

  begin

    v_cta      := pn_cuenta;
    v_ope      := pn_operacion;
    v_fechaini := pd_fechaini;
    v_dias     := pn_dias;
    v_interes  := pn_interes;

    --obtener clave del credito
    begin
      select PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE
        into pn_cod,
             pn_mod,
             pn_suc,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in (select modulo from fst111 where dscod = 50)
         and f.aocta = v_cta
         and f.aooper = v_ope
         and f.aostat <> 99;
    exception
      when others then
        pn_cta := 0;
    end;

    if pn_cta <> 0 then

      --valida interes
      begin
        select f.ppint
          into ln_interes_cuota
          from fsd601 f
         where f.pgcod = pn_cod
           and f.ppmod = pn_mod
           and f.ppsuc = pn_suc
           and f.ppmda = pn_mda
           and f.pppap = pn_pap
           and f.ppcta = pn_cta
           and f.ppoper = pn_ope
           and f.ppsbop = pn_sbo
           and f.pptope = pn_top
           and f.ppfpag = v_fechaini;
      exception
        when others then
          ln_interes_cuota := 0;
      end;

      begin
        select sum(f.pp1int)
          into ln_interes_pagado
          from fsd602 f
         where f.pgcod = pn_cod
           and f.ppmod = pn_mod
           and f.ppsuc = pn_suc
           and f.ppmda = pn_mda
           and f.pppap = pn_pap
           and f.ppcta = pn_cta
           and f.ppoper = pn_ope
           and f.ppsbop = pn_sbo
           and f.pptope = pn_top
           and f.ppfpag = v_fechaini
           and f.d602co = 'S';
      exception
        when others then
          ln_interes_pagado := 0;
      end;
      ln_interes_pagado := nvl(ln_interes_pagado, 0);
      --validando que interes ingresado sea menor a interes de la cuota
      IF v_interes <= (ln_interes_cuota - ln_interes_pagado) then

        /*se registra backup*/
        /*crear backups*/
        SQL_CREATE := 'CREATE TABLE operador.camp_fsd601_' || v_cta || '_' ||
                      v_ope || '_' || HORA ||
                      ' AS select f.* from fsd601 f where f.pgcod = 1 and f.ppcta = ' ||
                      v_cta || ' and f.ppoper =	' || v_ope;
        EXECUTE IMMEDIATE SQL_CREATE;

        SQL_CREATE := 'CREATE TABLE operador.camp_fsd602_' || v_cta || '_' ||
                      v_ope || '_' || HORA ||
                      ' AS select f.* from fsd602 f where f.pgcod = 1 and f.ppcta = ' ||
                      v_cta || ' and f.ppoper =	' || v_ope;
        EXECUTE IMMEDIATE SQL_CREATE;

        SQL_CREATE := 'CREATE TABLE operador.camp_fsd611_' || v_cta || '_' ||
                      v_ope || '_' || HORA ||
                      ' AS select f.* from fsd611 f where f.pgcod = 1 and f.ppcta = ' ||
                      v_cta || ' and f.ppoper =	' || v_ope;
        EXECUTE IMMEDIATE SQL_CREATE;

        SQL_CREATE := 'CREATE TABLE operador.camp_fsd612_' || v_cta || '_' ||
                      v_ope || '_' || HORA ||
                      ' AS select f.* from fsd612 f where f.pgcod = 1 and f.ppcta = ' ||
                      v_cta || ' and f.ppoper =	' || v_ope;
        EXECUTE IMMEDIATE SQL_CREATE;

        DBMS_OUTPUT.put_line(SQL_CREATE);
        /*******************/

        --insertando registro para congelamiento de mora, si existe registro pasar a historicos, eliminar registr e insertar nuevo
        begin
          select count(*)
            into ln_cantidad
            from aqpb252 a
           where a.AQPB252EMP = pn_cod
             and a.AQPB252MOD = pn_mod
             and a.AQPB252SUC = pn_suc
             and a.AQPB252MDA = pn_mda
             and a.AQPB252PAP = pn_pap
             and a.AQPB252CTA = pn_cta
             and a.AQPB252OPER = pn_ope
             and a.AQPB252SBOP = pn_sbo
             and a.AQPB252TOP = pn_top;
        exception
          when others then
            ln_cantidad := 0;
        end;

        if ln_cantidad > 0 then
          --pasar a historicos y eliminar
          begin
            insert into aqpb252h
              select *
                from aqpb252 a
               where a.AQPB252EMP = pn_cod
                 and a.AQPB252MOD = pn_mod
                 and a.AQPB252SUC = pn_suc
                 and a.AQPB252MDA = pn_mda
                 and a.AQPB252PAP = pn_pap
                 and a.AQPB252CTA = pn_cta
                 and a.AQPB252OPER = pn_ope
                 and a.AQPB252SBOP = pn_sbo
                 and a.AQPB252TOP = pn_top;
            commit;
          end;

          begin
            delete from aqpb252 a
             where a.AQPB252EMP = pn_cod
               and a.AQPB252MOD = pn_mod
               and a.AQPB252SUC = pn_suc
               and a.AQPB252MDA = pn_mda
               and a.AQPB252PAP = pn_pap
               and a.AQPB252CTA = pn_cta
               and a.AQPB252OPER = pn_ope
               and a.AQPB252SBOP = pn_sbo
               and a.AQPB252TOP = pn_top;
            commit;
          end;

        end if;
        --insertar
        v_fecfin := v_fechaini + v_dias;
        begin
          insert into aqpb252
            (AQPB252EMP,
             AQPB252MOD,
             AQPB252SUC,
             AQPB252MDA,
             AQPB252PAP,
             AQPB252CTA,
             AQPB252OPER,
             AQPB252SBOP,
             AQPB252TOP,
             AQPB252FINI,
             AQPB252FFIN,
             AQPB252EST,
             AQPB252IND)
          values
            (pn_cod,
             pn_mod,
             pn_suc,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top,
             v_fechaini,
             v_fecfin,
             'S',
             '4');
          commit;
          dbms_output.put_line('Se actualizó congelamiento. Cuenta ' ||
                               v_cta || ' Operacion ' || v_ope);
        exception
          when others then
            dbms_output.put_line('NO Se actualizó congelamiento. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;

        ---GENERAR BACKUPS

        --actualiza interes fsd601
        begin
          update fsd601 f
             set f.ppint = f.ppint - v_interes --interes de cuota menos interes a descontar
           where f.pgcod = pn_cod
             and f.ppmod = pn_mod
             and f.ppsuc = pn_suc
             and f.ppmda = pn_mda
             and f.pppap = pn_pap
             and f.ppcta = pn_cta
             and f.ppoper = pn_ope
             and f.ppsbop = pn_sbo
             and f.pptope = pn_top
             and f.ppfpag = v_fechaini;
          commit;
          dbms_output.put_line('Se actualizó interes. Cuenta ' || v_cta ||
                               ' Operacion ' || v_ope);
        exception
          when others then
            dbms_output.put_line('No se actualizó interes. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;

        ---actualiza cronogramas FECHA FIJA
        begin
          update fsd601 f
             set f.pptipo = 'F'
           where f.pgcod = pn_cod
             and f.ppmod = pn_mod
             and f.ppsuc = pn_suc
             and f.ppmda = pn_mda
             and f.pppap = pn_pap
             and f.ppcta = pn_cta
             and f.ppoper = pn_ope
             and f.ppsbop = pn_sbo
             and f.pptope = pn_top;
          commit;
        exception
          when others then
            dbms_output.put_line('No se actualizó FSD601 cuota fija. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;
        begin
          update fsd602 f
             set f.pptipo = 'F'
           where f.pgcod = pn_cod
             and f.ppmod = pn_mod
             and f.ppsuc = pn_suc
             and f.ppmda = pn_mda
             and f.pppap = pn_pap
             and f.ppcta = pn_cta
             and f.ppoper = pn_ope
             and f.ppsbop = pn_sbo
             and f.pptope = pn_top;
          commit;
        exception
          when others then
            dbms_output.put_line('No se actualizó FSD602 cuota fija. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;
        begin
          update fsd611 f
             set f.pptipo = 'F'
           where f.pgcod = pn_cod
             and f.ppmod = pn_mod
             and f.ppsuc = pn_suc
             and f.ppmda = pn_mda
             and f.pppap = pn_pap
             and f.ppcta = pn_cta
             and f.ppoper = pn_ope
             and f.ppsbop = pn_sbo
             and f.pptope = pn_top;
          commit;
        exception
          when others then
            dbms_output.put_line('No se actualizó FSD611 cuota fija. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;
        begin
          update fsd612 f
             set f.pptipo = 'F'
           where f.pgcod = pn_cod
             and f.ppmod = pn_mod
             and f.ppsuc = pn_suc
             and f.ppmda = pn_mda
             and f.pppap = pn_pap
             and f.ppcta = pn_cta
             and f.ppoper = pn_ope
             and f.ppsbop = pn_sbo
             and f.pptope = pn_top;
          commit;
        exception
          when others then
            dbms_output.put_line('No se actualizó FSD612 cuota fija. Cuenta ' ||
                                 v_cta || ' Operacion ' || v_ope);
        end;
      else
        dbms_output.put_line('Interes Ingresado es mayor a interes de la cuota del credito. Cuenta ' ||
                             v_cta || ' Operacion ' || v_ope);
      END IF;

    else
      dbms_output.put_line('cuenta y/o operacion no existe: cuenta ' ||
                           v_cta || ' Operacion ' || v_ope);
    end if;

begin
 insert into AQPB876 values (user,sysdate,'PQ_CR_CAMPANA_REFINAN_2025.SP_CR_AJUSTE',  
                            pn_cuenta||'-'||pn_operacion||'-'|| to_char(pd_fechaini,'RRRR/MM/DD')||'-'||
                            pn_dias||'-'||pn_interes   );
commit;
exception when others then null;  
end;

  END SP_CR_AJUSTE;
  -----------------------------------------------------------------------------------------
end PQ_CR_CAMPANA_REFINAN_2025;
/

