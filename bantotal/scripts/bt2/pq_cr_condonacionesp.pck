create or replace package pq_cr_condonacionesp is
  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para políticas de condonaciones
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 05/05/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 

  procedure sp_escondonado  (v_pgfape  in date,
                             v_instancia in number,
                             v_rpta   out number,
                             v_fecha  out date,
                             v_rpta1   out number
                             ) ;

end pq_cr_condonacionesp;
/

create or replace package body pq_cr_condonacionesp is
procedure sp_escondonado(    v_pgfape  in date,
                             v_instancia in number,
                             v_rpta   out number,
                             v_fecha  out date,
                             v_rpta1   out number
                             ) is    
ld_fecha date;
ln_indicador number(10);
ln_existe number (10);
begin
  ln_indicador:=0;
  BEGIN   
    select  max(p.aqpa018itfcon),count(*)
           into ld_fecha,ln_indicador
    from sng001 s
    inner join fsr008 f on s.sng001pais=f.pepais and s.sng001tdoc=f.petdoc and s.sng001ndoc=f.pendoc and f.cttfir='T'
    inner join aqpa018 p on p.aqpa018hcta=f.ctnro 
                   and p.aqpa018est='C' and p.aqpa018mcapitc+p.aqpa018mincoc>0 
                   and p.aqpa018itfcon>=(  add_months(sysdate,-(select tpimp from fst098 where tpcod=7735 and tpcorr=2 )))
    where s.sng001inst=v_instancia;
  Exception
         when no_data_found then
         ln_indicador:=0;
  end;
  if (ln_indicador > 0 ) then
    v_rpta:=1; 
     ln_indicador := 1 ;
     v_fecha:=ld_fecha;
  end if;
  if ( ln_indicador = 1 ) then
    ln_existe:=0;
      begin 
        select COUNT(*) into ln_existe
        from sng001 s
        inner join fsr008 f on s.sng001pais=f.pepais and s.sng001tdoc=f.petdoc and s.sng001ndoc=f.pendoc and f.cttfir='T'
        inner join fsd010 d on d.pgcod=s.sng001emp and d.aocta=f.ctnro and d.aomod in (select modulo from fst111 where dscod=50) and d.aosbop=0 and d.aofval>=ld_fecha
        where s.sng001inst=v_instancia  
        and sng001ori <> 3;
      Exception
             when no_data_found then
             ln_existe:=0;
      end; 
  end if;
    if (ln_existe > 0  ) then
      v_rpta1:=1;  
    end if;
end sp_escondonado;
end pq_cr_condonacionesp;
/

