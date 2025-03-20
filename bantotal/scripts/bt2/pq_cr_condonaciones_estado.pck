create or replace package pq_cr_condonaciones_estado is

  -- Author  : KVALENCIAC
  -- Created : 25/01/2019 4:21:43 p. m.
  -- Purpose : Condonaciones
  
   procedure sp_estadoactual (vn_Pgcod in number, vn_cta in number, vn_oper in number, vn_mda in number, vn_estado out number,vc_DescripEstActual out char);
end pq_cr_condonaciones_estado;
/

create or replace package body pq_cr_condonaciones_estado is
procedure sp_estadoactual (vn_Pgcod in number, vn_cta in number, vn_oper in number, vn_mda in number, vn_estado out number,vc_DescripEstActual out char)
  is    
  begin
    begin
    select  scstat  into vn_estado from (select scstat 
    from fsd011
    where PgCod = vn_Pgcod
      and Sccta = vn_cta
      and Scoper = vn_oper    
      and Scmda = vn_mda
      and scstat <> 99
      and Scmod in (select modulo from fst111 where dscod = 50 union select 65 from dual)      
      order by scsbop desc)
      where rownum = 1;
      
   EXCEPTION
   when no_data_found then    
     begin
      select aostat into vn_estado 
      from fsd010
      where PgCod = vn_Pgcod
        and Aocta = vn_cta
        and Aooper = vn_oper    
        and Aomda = vn_mda
        and AOMOD in (select modulo from fst111 where dscod = 50 union select 65 from dual)
        and aostat <> 99
--30.11.2019        
and rownum = 1
       order by PgCod,Aocta,Aooper,aosbop;
      EXCEPTION
      when no_data_found then
                  begin
                  select aostat into vn_estado 
                  from fsd010
                   where PgCod = vn_Pgcod
                   and Aocta = vn_cta
                   and Aooper = vn_oper    
                   and Aomda = vn_mda
                   and AOMOD in (select modulo from fst111 where dscod = 50 union select 65 from dual)
                   and rownum = 1
                   order by PgCod,Aocta,Aooper,aosbop;
                  EXCEPTION
                  when no_data_found then
                     vn_estado := -1;
                  end;
      End;
   End; 
      begin
      select Cenom into vc_DescripEstActual
      from FST026
      where Cecod = vn_estado;
      exception
        when no_data_found then
          vc_DescripEstActual:= '';
      end;
  end sp_estadoactual;
end pq_cr_condonaciones_estado;
/

