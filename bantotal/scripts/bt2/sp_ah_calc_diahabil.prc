CREATE OR REPLACE PROCEDURE SP_AH_CALC_DIAHABIL(P_D_FECPRO IN DATE,
                                P_N_NUMDIA IN NUMBER,
                                p_d_diahab out date) is
    ln_codcal number(3);
    ln_cont   number(9) := 0;
    cursor c_dias(ln_codcal in number) is
      SELECT f.*
        from FST028 f
       WHERE f.calcod = ln_codcal
         AND f.fhabil = 'S'
         AND f.ffecha > P_D_FECPRO
       ORDER BY FFECHA;
  begin
    ---***
    p_d_diahab := null;
    ln_codcal  := 999;
    ---***
    for i in c_dias(ln_codcal) loop
      ln_cont    := ln_cont + 1;
      p_d_diahab := i.ffecha;
      IF (ln_cont = P_N_NUMDIA) THEN
        RETURN;
        --exit;
      ELSE
        p_d_diahab := null;
      END IF;
    end loop;

    EXCEPTION
      when others then
        p_d_diahab := null;
        --P_ERRCOD := '040';
        --P_ERRMSG := sqlcode||'->'||sqlerrm;

  END SP_AH_CALC_DIAHABIL;
/

