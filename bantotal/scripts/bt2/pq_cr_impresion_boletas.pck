create or replace package pq_cr_impresion_boletas is

 procedure sp_cadena_devolucion_boletas (ve_cadena in varchar2, vr_rpta out varchar2);

end pq_cr_impresion_boletas;
/

create or replace package body pq_cr_impresion_boletas is

 procedure sp_cadena_devolucion_boletas (ve_cadena in varchar2, vr_rpta out varchar2) is
   
 vr_rpta_temporal VARCHAR2(500);
 validacion_seguro VARCHAR2(10);
 BEGIN
   BEGIN
   SELECT  LISTAGG(parts, '\r\n') WITHIN GROUP (ORDER BY parts) into vr_rpta_temporal FROM(
      SELECT 
      (case when parts like '% 0,00%' then 1 else 0 end) as logica, parts
      from (
      SELECT
      REGEXP_SUBSTR(ve_cadena, '[^-]+', 1, level) AS parts
      FROM dual
      CONNECT BY REGEXP_SUBSTR(ve_cadena, '[^-]+', 1, level) IS NOT NULL))
      where logica != 1
      group by logica;
      
      
      BEGIN
      SELECT trim(validacion_seguro) INTO validacion_seguro  from (
        SELECT 
        REGEXP_SUBSTR(vr_rpta_temporal, '[^\]+', 1, level) as validacion_seguro
        from dual
        CONNECT BY REGEXP_SUBSTR(vr_rpta_temporal, '[^\]+', 1, level) IS NOT NULL)
        where rownum = 1;
        
       EXCEPTION 
        WHEN OTHERS THEN 
            validacion_seguro := '0,00';
        END;
     
        IF validacion_seguro = '0,00' THEN
          vr_rpta := '              0,00\r\n' || vr_rpta_temporal;
        ELSE
          vr_rpta := vr_rpta_temporal;
        END IF;
   EXCEPTION 
     WHEN OTHERS THEN 
       vr_rpta := '              0,00';
     END;
     
           
 end sp_cadena_devolucion_boletas;
end pq_cr_impresion_boletas;
/

