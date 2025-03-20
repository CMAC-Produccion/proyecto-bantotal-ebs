create or replace procedure SP_LINEAS_117(p_instancia in number,
                                          p_flag out varchar2) is
-- *****************************************************************
-- Nombre                     : Proceso que devuelve flag si corresponde la impresion del seguro de desgravamen
-- Sistema                    : BANTOTAL
-- Módulo                     : Créditos - Activas
-- Versión                    : 1.0
-- Fecha de Creación          : 2023.12.26
-- Autor de Creación          : SILVIA MARQUEZ
-- Uso                        : Realiza CONSULTAS
-- Estado                     : Activo
-- Acceso                     : Público
-- Modificación fecha motivo  : SMARQUEZ 12/06/2024 Validacion de persona juridica
-- Modificacion               : SMARQUEZ 16/10/2024 Valor de caracter documento
-- *****************************************************************

cuenta number;
operacion number;
dni char(12);
edad number;
monto number(17,2);
moneda number;
fecha date;
tipocambio number(14,8);
pais number(3);
tipo number(2);
documento char(12);
begin
   select last_day(add_months(pgfape,-1))
     into fecha
     from fst017 where pgcod = 1 ;


   BEgin
     select xwfcuenta, xwfoperacion, xwfmonto1 ,xwfmoneda
       into cuenta, operacion, monto, moneda
       from xwf700
      where xwfprcins = p_instancia
        and xwfmodulo = 117
        and xwfcar3 = '1';

   exception
     when no_data_found then
       p_flag := 'N';
   end;
    Begin
        select pepais,petdoc, pendoc
          into pais,tipo,documento
          from fsr008
         where ctnro = cuenta
           and ttcod = 1
           and cttfir ='T';
    exception
      when no_Data_found then
         documento  :='0';
    end;
    if tipo = 9 then
      begin
        select 'S'
          into p_flag
          from fsd003 a
          where a.pjpais = pais
            and a.pjtdoc = tipo
            and a.pjndoc = documento
            and a.njcod = 7;
      exception
        when no_data_found then
          p_flag := 'N';
      end;
    else
        Begin
            select (select trunc(months_between(sysdate,pffnac)/12,0) edad from fsd002 where pfndoc = pendoc )
              into edad
              from fsr008
             where ctnro = cuenta
               and ttcod = 1
               and cttfir ='T';
        exception
          when no_Data_found then
             p_flag := 'N';
        end;

        if edad > 80 then
          p_flag := 'N';
        else
          p_flag := 'S';
        end if;
    end if;
  /*
    if moneda = 101 then
      if monto >= '80000' then
        p_flag := 'N';
      else
        p_flag := 'S';
      end if;
    else
      tipocambio :=  fn_tipo_cambio_fijo(fecha);
      monto := monto *tipocambio;
      if monto >= '80000' then
        p_flag := 'N';
      else
        p_flag := 'S';
      end if;
    end if;  */


end SP_LINEAS_117;
/

