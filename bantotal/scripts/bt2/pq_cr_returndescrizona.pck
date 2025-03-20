create or replace package pq_cr_returnDescriZona is

  -- Author  : RMOGROVEJO
  -- Created : 15/11/2018 09:40:57 a.m.
  -- Purpose : 
  
PROCEDURE sp_Return_Zona(pn_sucursal in number,FunctionResult_pn_REGION out VARCHAR2,FunctionResult_pn_ZONA out VARCHAR2);
PROCEDURE sp_return_info_zona(pn_cod_ofi in number,pn_ofi_usr out number, pn_zona_usr out number, pn_reg_usr out number);
end pq_cr_returnDescriZona;
/

create or replace package body pq_cr_returnDescriZona is

  -- Function and procedure implementations
PROCEDURE sp_Return_Zona(pn_sucursal in number,FunctionResult_pn_REGION out VARCHAR2,FunctionResult_pn_ZONA out VARCHAR2) is
  
 pn_REGION char(120);
 pn_ZONA char(120);

begin
  -- Initialization
   begin
     
       select f.tp1desc REGION,
              t81.regnom ZONA
          into       
          pn_REGION,pn_ZONA
          from fst810 t81, fst811 t80, fst198 f 
          where t80.pgcod = t81.pgcod
          and t80.regcod = t81.regcod
          and t81.regcod = f.tp1nro2 
          and  f.tp1cod = 1 and f.tp1cod1= 10872 and f.tp1corr1= 11
          and  t81.regcod < 100
          and  t80.regcod < 100 
          and t80.oficod = pn_sucursal ; 
          
         exception
          when no_data_found then
            pn_REGION := null;
            pn_ZONA:= null;
            
        end;
        
          FunctionResult_pn_REGION:=pn_REGION;
          FunctionResult_pn_ZONA:=pn_ZONA;
          
end sp_Return_Zona;

PROCEDURE sp_return_info_zona(pn_cod_ofi in number,
                             pn_ofi_usr out number, 
                             pn_zona_usr out number, 
                             pn_reg_usr out number) is

begin
  -- Initialization
   begin
     
     select 
        f.tp1nro1 CODIGO_REGION , 
        t81.regcod CODIGO_ZONA,
        t80.oficod sucursal
      into pn_reg_usr, pn_zona_usr, pn_ofi_usr
      from fst810 t81 , fst811 t80, fst198 f 
      where t80.pgcod = t81.pgcod
      and t80.regcod = t81.regcod
      and t81.regcod = f.tp1nro2 
      and  tp1cod = 1 and tp1cod1= 10872 and tp1corr1= 11
      and  t81.regcod < 100
      and  t80.regcod < 100  
      AND  t80.oficod= pn_cod_ofi;
      
     exception
          when no_data_found then
            pn_ofi_usr := null;
            pn_zona_usr := null;
            pn_reg_usr := null;

   end;

end sp_return_info_zona;

end pq_cr_returnDescriZona;
/

