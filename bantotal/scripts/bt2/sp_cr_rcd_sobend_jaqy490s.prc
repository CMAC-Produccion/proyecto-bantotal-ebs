CREATE OR REPLACE PROCEDURE SP_CR_RCD_SOBEND_JAQY490S(P_D_FECHA IN DATE,
                                             P_N_CODRES OUT NUMBER,
                                             P_C_RESULTADO OUT VARCHAR2)
IS

    type cur_rec is record(
      p_jaqy490t_bccta jaqy490t.bccta%type,
      p_jaqy490sob char(1)
      
    );

    TYPE cur_01 IS TABLE OF cur_rec;

    lv_cur_01 cur_01;

    cursor cur_sob is
                  select 
                  t.bccta,
                  (case
                         when s.jaqy490sob = 0 then '0'
                         when s.jaqy490sob in (1,2) then '1'
                         else '9'
                   end) jaqy490sob
                  from jaqy490s s
                  inner join jaqy490t t
                  on s.jaqy490fec = t.bcfech
                  and s.jaqy490pai = t.pepais
                  and s.jaqy490tdo = t.petdoc
                  and s.jaqy490ndo = t.pendoc
                  and s.jaqy490ins = t.numins
                  and s.jaqy490fec = P_D_FECHA;

BEGIN

    OPEN cur_sob;
    LOOP

      FETCH cur_sob BULK COLLECT
      INTO lv_cur_01 LIMIT 100;
      EXIT WHEN lv_cur_01.COUNT = 0;

        FOR i IN 1 .. lv_cur_01.COUNT LOOP

            begin

              delete from fsx008
              where PGCOD = 1
              and CTNRO = lv_cur_01(i).p_jaqy490t_bccta
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
                     lv_cur_01(i).p_jaqy490t_bccta,
                     208,
                     14,
                     lv_cur_01(i).p_jaqy490sob,
                     'BANTOTAL',
                     P_D_FECHA
                );
            exception
            when DUP_VAL_ON_INDEX then
              begin
                update fsx008
                set
                       CTXTXT = lv_cur_01(i).p_jaqy490sob,
                       CTXUSU = 'BANTOTAL',
                       CTXFCH = P_D_FECHA
                where
                       PGCOD = 1
                       and CTNRO = lv_cur_01(i).p_jaqy490t_bccta
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

EXCEPTION

WHEN OTHERS THEN
  P_C_RESULTADO := SQLERRM;
  P_N_CODRES := SQLCODE;
END;
/

