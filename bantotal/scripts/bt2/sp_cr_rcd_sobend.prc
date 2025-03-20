CREATE OR REPLACE PROCEDURE SP_CR_RCD_SOBEND(P_D_FECHA IN DATE,
                                             P_N_CODRES OUT NUMBER,
                                             P_C_RESULTADO OUT VARCHAR2)
IS

ln_indpro jaql411.jaql411reg%type;

    type cur_rec is record(
      p_jaql154cta jaql154.jaql154cta%type,
      p_jaql157sob jaql157.jaql157sob%type
    );

    TYPE cur_01 IS TABLE OF cur_rec;

    lv_cur_01 cur_01;

    cursor cur_sob is
                    select distinct
                    a.jaql154cta,
                    (case
                           when c.jaql157sob in ('N','I') then '0'
                           when c.jaql157sob in ('S','E') then '1'
                           else '9'
                     end) jaql157sob
                    from jaql154 a inner join jaql157 c
                    on a.jaql154pai = c.jaql157pai and a.jaql154tdo = c.jaql157tdo and a.jaql154ndo = c.jaql157ndo
                    where c.jaql157ani = to_number(to_char(P_D_FECHA,'yyyy'))
                    and c.jaql157mes = to_number(to_char(P_D_FECHA,'mm'))
                    and a.jaql154ani = to_number(to_char(P_D_FECHA,'yyyy'))
                    and a.jaql154mes = to_number(to_char(P_D_FECHA,'mm'));

BEGIN

      begin
        select jaql411reg
        into ln_indpro
        from jaql411
        where jaql411fch = P_D_FECHA
        and jaql411rgi = 0;
      exception
      when no_data_found then
        ln_indpro := null;
      when others then
        ln_indpro := -1;
      end;

      if (ln_indpro = 0) then

        OPEN cur_sob;
        LOOP

          FETCH cur_sob BULK COLLECT
          INTO lv_cur_01 LIMIT 100;
          EXIT WHEN lv_cur_01.COUNT = 0;

            FOR i IN 1 .. lv_cur_01.COUNT LOOP

                begin

                  delete from fsx008
                  where PGCOD = 1
                  and CTNRO = lv_cur_01(i).p_jaql154cta
                  and TXCOD = 208
                  and CTXREN = 14;

                  insert into fsx008
                    (
                         PGCOD,
                         CTNRO,
                         TXCOD,
                         CTXREN,
                         CTXTXT,
                         CTXUSU,
                         CTXFCH
                    )
                  values
                    (
                         1,
                         lv_cur_01(i).p_jaql154cta,
                         208,
                         14,
                         lv_cur_01(i).p_jaql157sob,
                         'BANTOTAL',
                         P_D_FECHA
                    );
                exception
                when DUP_VAL_ON_INDEX then
                  begin
                    update fsx008
                    set
                           CTXTXT = lv_cur_01(i).p_jaql157sob,
                           CTXUSU = 'BANTOTAL',
                           CTXFCH = P_D_FECHA
                    where
                           PGCOD = 1
                           and CTNRO = lv_cur_01(i).p_jaql154cta
                           and TXCOD = 208
                           and CTXREN = 14;
                  exception when DUP_VAL_ON_INDEX then
                    P_C_RESULTADO := '';
                  end;
                when others then
                  begin
                    P_C_RESULTADO := '';
                  end;
                end;

            END LOOP;
        END LOOP;

        COMMIT;

        P_C_RESULTADO := 'INDICADOR RCD GENERADO CORRECTAMENTE AL ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 0;

      end if;

      if (ln_indpro is null) then
        P_C_RESULTADO := 'Antes debe CONSOLIDAR la información al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 1;
      end if;

      if (ln_indpro = 1) then
        P_C_RESULTADO := 'El consolidado se encuentra en ejecución al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 0;
      end if;

      if (ln_indpro = -1) then
        P_C_RESULTADO := 'Se produjo un Error al ejecutar el proceso. Intente nuevamente.';
        P_N_CODRES := ln_indpro;
      end if;

EXCEPTION

WHEN OTHERS THEN
  P_C_RESULTADO := SQLERRM;
  P_N_CODRES := SQLCODE;
END;
/

