create or replace force view v_aqpc584 as
(
select TIPO_DOC,
       DOCUMENTO,
       APELLIDOS_NOMBRES,
       FECHA_ACTUAL_RCC,
       FECHA_RCC,
       V_NORMAL,
       V_CPP,
       V_DEFICIENTE,
       V_DUDOSO,
       V_PERDIDA,
       sum(deuda) DEUDA,
       fn_cum_cat(to_char(m1.dias_atraso) || ',') DIAS_ATRASO,
       count(*) NRO_ENTIDADES,
       fn_cum_cat(m2.c_desabr || ',') DESC_ENTIDADES
  from (select t5.c_tdocid TIPO_DOC,
               t5.c_docide DOCUMENTO,
               t5.c_nomdeu APELLIDOS_NOMBRES,
               to_date(t4.tpnro, 'ddMMYYYY') FECHA_ACTUAL_RCC,
               t5.d_fecpre FECHA_RCC,
               t5.n_calif0 V_NORMAL,
               t5.n_calif1 V_CPP,
               t5.n_calif2 V_DEFICIENTE,
               t5.n_calif3 V_DUDOSO,
               t5.n_calif4 V_PERDIDA,
               t6.c_codemp,
               sum(n_salcap) DEUDA,
               sum(t6.n_diaatr) DIAS_ATRASO
          from cldrcci t5
          left join fst098 t4
            on t4.pgcod = 1
           and t4.tpcod = 7647
           and t4.tpcorr = 12
          left join cldrccs t6
            on t5.d_fecpre = t6.d_fecpre
           and t5.c_codsbs = t6.c_codsbs
         where 1 = 1
           and t5.c_tdocid in ('1','2')
           and t5.d_fecpre <= to_date(t4.tpnro, 'ddMMYYYY')
           and t5.d_fecpre >= add_months(to_date(t4.tpnro, 'ddMMYYYY'), -5)
           and (t6.c_cuenta like '1411%' or t6.c_cuenta like '1413%' or
               t6.c_cuenta like '1414%' or t6.c_cuenta like '1415%' or
               t6.c_cuenta like '1416%' Or t6.c_cuenta like '1418%' or
               t6.c_cuenta like '1421%' Or t6.c_cuenta like '1423%' Or
               t6.c_cuenta like '1424%' Or t6.c_cuenta like '1425%' Or
               t6.c_cuenta like '1426%' Or t6.c_cuenta like '1428%' or
               t6.c_cuenta like '7111%' Or t6.c_cuenta like '7112%' Or
               t6.c_cuenta like '7113%' Or t6.c_cuenta like '7114%' or
               t6.c_cuenta like '7121%' Or t6.c_cuenta like '7122%' Or
               t6.c_cuenta like '7123%' Or t6.c_cuenta like '7124%' or
               t6.c_cuenta like '8113%' Or t6.c_cuenta like '8123%' or
               t6.c_cuenta like '811302%' Or t6.c_cuenta like '8123025%' or
               t6.c_cuenta like '721501%' Or t6.c_cuenta like '721502%' Or
               t6.c_cuenta like '721503%' Or t6.c_cuenta like '721504%' Or
               t6.c_cuenta like '721505%' Or t6.c_cuenta like '721506%' Or
               t6.c_cuenta like '721507%' or t6.c_cuenta like '722501%' Or
               t6.c_cuenta like '722502%' Or t6.c_cuenta like '722503%' Or
               t6.c_cuenta like '722504%' Or t6.c_cuenta like '722505%' Or
               t6.c_cuenta like '722506%' Or t6.c_cuenta like '722507%')
         group by t5.c_tdocid,
                  t5.c_docide,
                  t5.c_nomdeu,
                  to_date(t4.tpnro, 'ddMMYYYY'),
                  t5.d_fecpre,
                  t5.n_calif0,
                  t5.n_calif1,
                  t5.n_calif2,
                  t5.n_calif3,
                  t5.n_calif4,
                  t6.c_codemp) m1
  left join ahtbanc m2
    on m1.c_codemp = m2.c_codefi
 group by TIPO_DOC,
          DOCUMENTO,
          APELLIDOS_NOMBRES,
          FECHA_ACTUAL_RCC,
          FECHA_RCC,
          V_NORMAL,
          V_CPP,
          V_DEFICIENTE,
          V_DUDOSO,
          V_PERDIDA
);

