create or replace package PQ_CR_DEVOLVER_SUMAAQPC423 is

  -- Author  : ENINAH
  -- Created : 29/09/2022 17:15:50
  -- Purpose : Actualiza el campo flag a X y devuelve una suma de la aqpc423

  procedure SP_CR_ACT_DEVOL_AQPC423(cod_grup in number,
                                    --fecha_aux   in date,
                                    fecha_venta in date,
                                    sum_aqpc432 out number);
  procedure SP_CR_Obtener_cambio(fecha in date, tipo_cambio out number);

end PQ_CR_DEVOLVER_SUMAAQPC423;
/

create or replace package body PQ_CR_DEVOLVER_SUMAAQPC423 is
  -- ------------------------------------------------------------------------------------------------
  -- NOMBRE                : PQ_CR_DEVOLVER_SUMAAQPC423
  -- SISTEMA               : BANTOTAL
  -- MODULO                : activas
  -- VERSION               : 1.0
  -- FECHA DE CREACION     : 29/09/2022
  -- AUTOR DE CREACION     : EDEHILTON NINA HURTADO
  -- APLICACION            : ACTUALIZACION Y EXTRACION DE INFORMACION 
  -- ESTADO                : ACTIVO
  -- ACCESO                : PUBLICO
  -----------------------------------------------------------------------------------------------------------------------------------------------------
  procedure SP_CR_ACT_DEVOL_AQPC423(cod_grup in number,
                                    --fecha_aux   in date,
                                    fecha_venta in date,
                                    sum_aqpc432 out number) is
  begin
    begin
      update AQPC423 A
         set A.AQPC423FTRA = 'X'
       where A.AQPC423CODGRU = cod_grup
         and A.AQPC423EST = 'C'
            --and A.AQPC423FTRA != 'T';
            --and AQPC423ITFCON >= fecha_aux
         and AQPC423ITFCON <= fecha_venta
         and (A.AQPC423FTRA is null or A.AQPC423FTRA = ' ' or
             A.AQPC423FTRA = 'X');
      commit;
    exception
      when others then
        null;
    END;
  
    begin
      select SUM(A.AQPC423TOTP)
        into sum_aqpc432
        from AQPC423 A
       where A.AQPC423CODGRU = cod_grup
            --and AQPC423ITFCON >= fecha_aux
         and AQPC423ITFCON <= fecha_venta
         and (A.AQPC423FTRA is null or A.AQPC423FTRA = ' ' or
             A.AQPC423FTRA = 'X');
      --and A.AQPC423FTRA = 'X';
    exception
      when others then
        null;
    end;
  end SP_CR_ACT_DEVOL_AQPC423;

  procedure SP_CR_Obtener_cambio(fecha in date, tipo_cambio out number) is
  Begin
    begin
      select cotcbi
        into tipo_cambio
        from fsh005
       where moneda = 101
         and cofdes <= fecha
         and rownum = 1
       order by cofdes desc;
    exception
      when others then
        tipo_cambio := 0;
    end;
  end SP_CR_Obtener_cambio;

end PQ_CR_DEVOLVER_SUMAAQPC423;
/

