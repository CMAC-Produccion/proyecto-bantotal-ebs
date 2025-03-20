create or replace package PQ_CR_FECHA_EVAL_HS is
    -- *********************************************************************************
    -- Nombre                     : FUNCIONES PARA COBRO DE COMISIONES INTERPLAZAS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : PASIVAS
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.06.24
    -- Autor de Creación          : SMARQUEZ
    -- Uso                        : VERIFICACIONES Y COBRO DE COMISION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 24/06/2014
    -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_obtener_fecha_eval(instancia in int,fechaconsulta in date,fechaeval out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_segmentacion_actual(pais in int,tdoc in int, lc_pendoc in varchar2,fecha in date,descr out varchar2);
	
end PQ_CR_FECHA_EVAL_HS;
/

create or replace package body pq_cr_fecha_eval_hs is
PROCEDURE sp_obtener_fecha_eval(instancia in int,fechaconsulta in date,fechaeval out date) 
is

          begin
              select max(sng021fec)into fechaeval from sng021 where sng021sol=instancia;
				  exception
					when others then 
				      fechaeval := '01/01/2001';
end;
procedure sp_obtener_segmentacion_actual(pais in int,tdoc in int, lc_pendoc in varchar2,fecha in date,descr out varchar2)
is
calf varchar2(50) :=null;
ano  varchar2(4) :=TO_CHAR(fecha,'YYYY');
mes  varchar2(2) :=TO_CHAR(fecha,'MM');
numdoc char(12);
begin

     numdoc := rpad(lc_pendoc,12,' ');

          begin
             select 
						       a.jaqy066calf
						 into
						       calf 
						 from jaqy066 a
								      where a.jaqy066paic   =  pais
									      and a.jaqy066tdoc   =  tdoc
									      and a.jaqy066tndoc  =  numdoc
									      and a.jaqy066pano   =  ano
									      and a.jaqy066pmes   =  mes;
					exception
					when too_many_rows then
							 begin
									select 
									   a.jaqy066calf
								  into
									   calf
									from jaqy066 a
							 where a.jaqy066paic         =  pais
									and a.jaqy066tdoc        =  tdoc
									and a.jaqy066tndoc       =  numdoc
									and a.jaqy066pano        =  ano
									and a.jaqy066pmes        =  mes
									and a.jaqy066nse         =  'S';
							 end;
				  when no_data_found then
					     calf:=null;
					end;
          begin
               select jaqy067ncal into descr from jaqy067 where jaqy067ccal=trim(calf);
				  exception
							 when no_data_found then
							      descr:=null;
          end;
                                					
end;

end PQ_CR_FECHA_EVAL_HS;
/

