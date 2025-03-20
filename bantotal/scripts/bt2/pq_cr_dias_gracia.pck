create or replace package pq_cr_dias_gracia is

/* ************************************************************************************************************
    -- Nombre                     : pq_cr_dias_gracia
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos
    -- Descripción                : Devuelve días de Gracia
    -- Versión                    : 1.0
    -- Fecha de Creación          : 21/12/2017
    -- Autor de Creación          : Karen Valencia Cornejo
    -- Versión                    : 2.0
    -- Fecha de Modificación      : 17/06/2020
    -- Autor de la Modificación   : Karen Valencia C.
    -- Descripción de Modificación: Se módificó la obtención de periodos de la tabla X054032
    --
* *************************************************************************************************************/
  procedure sp_dias_gracia (vd_Pgfape date, vn_instancia in  number, vn_ndias out number);
end pq_cr_dias_gracia;
/

create or replace package body pq_cr_dias_gracia is

procedure sp_dias_gracia ( vd_Pgfape date, vn_instancia number, vn_ndias out number)
  is
vn_xwfcta number(9);
vn_xwfope number(9);
vn_cont number(9);
vn_per number(9);
vn_xwfempresa number(3);
vn_xwfsucursal number(3);
vn_xwfmodulo number(3);
vn_xwfmoneda number(4);
vn_xwfpapel number(4);
vn_xwfcuenta number(9);
vn_xwfoperacion number(9);
vn_xwfsubope number(3);
vn_xwftipope number(3);
begin
--select xwfcuenta,xwfoperacion into vn_xwfcta,vn_xwfope from xwf700 where xwfprcins=vn_instancia and xwfcar3=1;
  begin 
  select  w.xwfempresa,
          w.xwfsucursal,
          w.xwfmodulo,
          w.xwfmoneda,
          w.xwfpapel,
          w.xwfcuenta,
          w.xwfoperacion,
          w.xwfsubope,
          w.xwftipope
          into 
          vn_xwfempresa,   
          vn_xwfsucursal,  
          vn_xwfmodulo,    
          vn_xwfmoneda,    
          vn_xwfpapel,     
          vn_xwfcuenta,    
          vn_xwfoperacion ,
          vn_xwfsubope,    
          vn_xwftipope    
    from  (select * 
    from xwf700
    where xwfprcins = vn_instancia
    and xwfcar3 = '1'
    order by  xwfempresa, xwfsucursal, xwfmodulo, xwfmoneda, xwfpapel, xwfcuenta, xwfoperacion, xwfsubope desc , xwftipope  
    ) w
    where rownum= 1; 
  exception 
    when no_data_found then
     vn_xwfcuenta := 0;
  end;
  vn_cont := 0;
  vn_per := 0;
if ( vn_xwfcuenta<>0 or  vn_xwfcuenta is not null) then
      Begin
        select xllaocntp  ---distinct x.xllaocntp
          into vn_cont
          from ( select * from X054032 x
          where xllpgcod= vn_xwfempresa
           and xllaosuc = vn_xwfsucursal
           and xllaomod = vn_xwfmodulo
           and xllaomda = vn_xwfmoneda
           and xllaopap = vn_xwfpapel
           and xllaocta = vn_xwfcuenta
           and x.xllaooper = vn_xwfoperacion
           and x.xllaosbop = vn_xwfsubope
           and x.xllaotop = vn_xwftipope
           order by XLLPGCOD, XLLAOMOD, XLLAOSUC, XLLAOMDA, XLLAOPAP, XLLAOCTA, XLLAOOPER, XLLAOSBOP, XLLAOTOP, XLLAOPERI desc)
           where rownum= 1 ;
           
      Exception
        when no_data_found then
          vn_cont := 0;
      end;

      begin
        select x.xllperiodo
          into vn_per
          from X054023 x       
         where xllpgcod= vn_xwfempresa
           and xllaosuc = vn_xwfsucursal
           and xllaomod = vn_xwfmodulo
           and xllaomda = vn_xwfmoneda
           and xllaopap = vn_xwfpapel
           and xllaocta = vn_xwfcuenta
           and x.xllaooper = vn_xwfoperacion
           and x.xllaosbop = vn_xwfsubope
           and x.xllaotop = vn_xwftipope;
      Exception
        when no_data_found then
          vn_per := 0;
      end;
end if;
     --número de días de gracia
/*          begin
          select d.ppfvto-s.ppfvto into vn_ndias from fsd601 d,
           (select  ppfvto from fsd601 f where f.ppcta=vn_xwfcta and f.ppoper=vn_xwfope and ( pptipo='K' or pptipo='I') and rownum=1 order by ppfvto) s
            where d.pgcod=1 and d.ppcta=vn_xwfcta and d.ppoper=vn_xwfope and ( d.pptipo<>'K' and d.pptipo<>'I') and rownum=1 order by d.ppfvto;
           Exception
                 when no_data_found then
                      vn_ndias := 0;               
           end;*/

  vn_ndias:=vn_cont*vn_per;

end sp_dias_gracia;
end pq_cr_dias_gracia;
/

