CREATE OR REPLACE FORCE VIEW V_JAQZ583 AS
SELECT d_fecpre Fecha,
       c_docide NRODOC,
       C_NOMDEU NOMBRE,
       n_calif0 NORMAL,
       n_calif1 CPP,
       n_calif1 DEFICIENTE,
       n_calif3 DUDOSO,
       n_calif4 PERDIDA
  from CLDRCCI
where d_fecpre = (select to_date(to_char(tpnro), 'dd/mm/yyyy') fecha
                     from FST098
                    where pgcod = 1
                    and Tpcod = 7647
                      and Tpcorr = 12)
union
SELECT d_fecpre Fecha,
       c_docide NRODOC,
       C_NOMDEU NOMBRE,
       n_calif0 NORMAL,
       n_calif1 CPP,
       n_calif1 DEFICIENTE,
       n_calif3 DUDOSO,
       n_calif4 PERDIDA
  from CLDRCCI
where d_fecpre = (select add_months(to_date(to_char(tpnro), 'dd/mm/yyyy'),-1) fecha
                     from FST098
                    where pgcod = 1
                    and Tpcod = 7647
                      and Tpcorr = 12)
union
SELECT d_fecpre Fecha,
       c_docide NRODOC,
       C_NOMDEU NOMBRE,
       n_calif0 NORMAL,
       n_calif1 CPP,
       n_calif1 DEFICIENTE,
       n_calif3 DUDOSO,
       n_calif4 PERDIDA
  from CLDRCCI
where d_fecpre = (select  add_months(to_date(to_char(tpnro), 'dd/mm/yyyy'),-2) fecha
                     from FST098
                    where pgcod = 1
                    and Tpcod = 7647
                      and Tpcorr = 12);

