CREATE OR REPLACE PROCEDURE SP_CR_FECHA_DETALLE(PD_FECPRO in date,ps_FecDet out varchar2) IS
  lv_anio   varchar2(5);
  lv_mes    varchar2(15);
  lv_dia    varchar2(2);
BEGIN
  lv_anio := trim(to_char(PD_FECPRO,'YYYY'));
  lv_mes  := trim(to_char(PD_FECPRO,'Month','nls_date_language=spanish'));
  lv_dia  := trim(to_char(PD_FECPRO,'DD'));
          
  ps_FecDet := lv_dia || ' de ' || lv_mes || ' del ' || lv_anio; 

END SP_CR_FECHA_DETALLE;
/

