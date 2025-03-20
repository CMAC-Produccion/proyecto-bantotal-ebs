create or replace package PQ_CR_RESOLUTOR_SEG_DESGRAVAMEN is
   -- *****************************************************************
    -- Nombre                     : PAQUETES RESOLUTOR DE SEGURO DE DESGRAVAMEN
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 27/03/2024 14:57:33
    -- Autor de Creaci�n          : SILVIA MARQUEZ 
    -- Uso                        : Realiza Validaci�n  de seguros anteriores
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      :
    --
    --
    --
    -- *****************************************************************


 
  Procedure Sp_Tuvo_desgravamen (pn_ins in number,
                                 pc_flg out varchar2);
end PQ_CR_RESOLUTOR_SEG_DESGRAVAMEN;
/

create or replace package body PQ_CR_RESOLUTOR_SEG_DESGRAVAMEN is

 Procedure Sp_Tuvo_desgravamen (pn_ins in number,
                                pc_flg out varchar2)is

  existe number;
  begin

       begin
       select 1
         into existe
         from xwf700 h , fpp001 gg
        where h.xwfprcins = pn_ins
          and h.xwfcar3 <> '1'
          and gg.pgcod  = h.xwfempresa
          and gg.aomod  = h.xwfmodulo
          and gg.aosuc  = h.xwfsucursal
          and gg.aomda  = h.xwfmoneda
          and gg.aopap  = h.xwfpapel
          and gg.aocta  = h.xwfcuenta
          and gg.aooper = h.xwfoperacion
          and gg.aosbop = h.xwfsubope
          and gg.aotope = h.xwftipope
          and gg.sgcod  in (select sgcod from fst300 where sgsn02 ='5' );


       exception
       when no_data_found  then
         existe:= 0;
       when too_many_rows then
         existe:= 1;
       end;

       if existe = 1 then
         pc_flg := 'S';
       else
         pc_flg := 'N';
       end if;
   
   

  end Sp_Tuvo_desgravamen;
end PQ_CR_RESOLUTOR_SEG_DESGRAVAMEN;
/

