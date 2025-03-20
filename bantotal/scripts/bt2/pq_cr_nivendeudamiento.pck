create or replace package pq_cr_nivendeudamiento is

function fn_cr_calcula_deu_mes_bt(P_C_CODSBS VARCHAR2,P_C_TIPPER VARCHAR2,P_C_NUMDOC VARCHAR2,
                                 P_N_NUMMES NUMBER,
                                 P_D_FECPRO DATE

                                 ) return number;
function fn_cr_calcula_deuda_bt(P_C_CODSBS VARCHAR2,P_C_TIPPER VARCHAR2,P_C_NUMDOC VARCHAR2,P_D_FECPRO DATE
                               ) return NUMBER;



end pq_cr_nivendeudamiento;
/

create or replace package body pq_cr_nivendeudamiento is

function fn_cr_calcula_deu_mes_bt(P_C_CODSBS VARCHAR2,P_C_TIPPER VARCHAR2,P_C_NUMDOC VARCHAR2,
                                 P_N_NUMMES NUMBER,
                                 P_D_FECPRO DATE
                                 ) return number IS

  ln_deumes number;
  ld_feccal date;
  begin

        ld_feccal := last_day(add_months(P_D_FECPRO,-1*P_N_NUMMES));
        ln_deumes := fn_cr_calcula_deuda_bt(P_C_CODSBS,P_C_TIPPER,P_C_NUMDOC,ld_feccal);

  return ln_deumes;
  end fn_cr_calcula_deu_mes_bt;


function fn_cr_calcula_deuda_bt(P_C_CODSBS VARCHAR2,P_C_TIPPER VARCHAR2,P_C_NUMDOC VARCHAR2,P_D_FECPRO DATE
                               ) return NUMBER is

  ln_totsbs  NUMBER;
  ln_totdif  NUMBER;

  begin

  IF P_C_CODSBS is not null then

    SELECT SUM(t_rccs.n_salcap)
      INTO ln_totsbs
      FROM cldrccs t_rccs
     WHERE t_rccs.c_codsbs = P_C_CODSBS
       AND t_rccs.d_fecpre = P_D_FECPRO
       AND t_rccs.c_tipreg = '2'
       AND t_rccs.c_cretip not in ('13','4')
       AND ((substr(t_rccs.c_cuenta, 1, 2) = '14' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '3','4', '5', '6') and substr(t_rccs.c_cuenta, 5, 2) <> '04' )
            or
            (substr(t_rccs.c_cuenta, 1, 2) = '71' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '2','3', '4'))
           );
    SELECT SUM(t_rccs.n_salcap)
      INTO ln_totdif
      FROM cldrccs t_rccs
     WHERE t_rccs.c_codsbs = P_C_CODSBS
       AND t_rccs.d_fecpre = P_D_FECPRO
       AND t_rccs.c_tipreg = '2'
       AND t_rccs.c_cretip not in ('13','4')
       AND (substr(t_rccs.c_cuenta, 1, 4) in ( '2911', '2921') and substr(t_rccs.c_cuenta, 5, 2) IN ('01', '02','04'));
  ELSE

    --
    -- Averiguamos si es persona natural o juriridca
    --


       if P_C_TIPPER = 'F'then
          SELECT SUM(t_rccs.n_salcap)
            INTO ln_totsbs
            FROM cldrcci t_clie,
                 cldrccs t_rccs
           WHERE t_clie.c_codsbs = t_rccs.c_codsbs
             AND t_clie.c_docide = P_C_NUMDOC
             AND t_clie.d_fecpre = t_rccs.d_fecpre--added Liz Ll.
             AND t_rccs.d_fecpre = P_D_FECPRO
             AND t_rccs.c_tipreg = '2'
             AND t_rccs.c_cretip not in ('13','4')
             AND ((substr(t_rccs.c_cuenta, 1, 2) = '14' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '3','4', '5', '6') and substr(t_rccs.c_cuenta, 5, 2) <> '04' )
                  or
                  (substr(t_rccs.c_cuenta, 1, 2) = '71' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '2','3', '4'))
                 );

          SELECT SUM(t_rccs.n_salcap)
            INTO ln_totdif
            FROM cldrcci t_clie,
                 cldrccs t_rccs
           WHERE t_clie.c_codsbs = t_rccs.c_codsbs
             AND t_clie.c_docide = P_C_NUMDOC
             AND t_clie.d_fecpre = t_rccs.d_fecpre--added Liz Ll.
             AND t_rccs.d_fecpre = P_D_FECPRO
             AND t_rccs.c_tipreg = '2'
             AND t_rccs.c_cretip not in ('13','4')
             AND (substr(t_rccs.c_cuenta, 1, 4) in ( '2911', '2921') and substr(t_rccs.c_cuenta, 5, 2) IN ('01', '02','04'));

       else

          SELECT SUM(t_rccs.n_salcap)
            INTO ln_totsbs
            FROM cldrcci t_clie,
                 cldrccs t_rccs
           WHERE t_clie.c_codsbs = t_rccs.c_codsbs
             AND t_clie.c_doctri = P_C_NUMDOC
             AND t_clie.d_fecpre = t_rccs.d_fecpre--added Liz Ll.
             AND t_rccs.d_fecpre = P_D_FECPRO
             AND t_rccs.c_tipreg = '2'
             AND t_rccs.c_cretip not in ('13','4')
             AND ((substr(t_rccs.c_cuenta, 1, 2) = '14' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '3','4', '5', '6') and substr(t_rccs.c_cuenta, 5, 2) <> '04' )
                  or
                  (substr(t_rccs.c_cuenta, 1, 2) = '71' AND substr(t_rccs.c_cuenta, 4, 1) IN ('1', '2','3', '4'))
                 );

          SELECT SUM(t_rccs.n_salcap)
            INTO ln_totdif
            FROM cldrcci t_clie,
                 cldrccs t_rccs
           WHERE t_clie.c_codsbs = t_rccs.c_codsbs
             AND t_clie.c_doctri = P_C_NUMDOC
             AND t_clie.d_fecpre = t_rccs.d_fecpre--added Liz Ll.
             AND t_rccs.d_fecpre = P_D_FECPRO
             AND t_rccs.c_tipreg = '2'
             AND t_rccs.c_cretip not in ('13','4')
             AND (substr(t_rccs.c_cuenta, 1, 4) in ( '2911', '2921') and substr(t_rccs.c_cuenta, 5, 2) IN ('01', '02','04'));
       end if;

  END IF;
    return round(nvl(ln_totsbs, 0) - nvl(ln_totdif, 0), 2);
  exception
  when no_data_found then
    return 0;
  end fn_cr_calcula_deuda_bt;

end pq_cr_nivendeudamiento;
/

