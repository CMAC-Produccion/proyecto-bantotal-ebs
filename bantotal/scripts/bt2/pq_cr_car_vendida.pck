create or replace package PQ_CR_CAR_VENDIDA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CAR_VENDIDA
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2019.10.23
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : paquete que evalua instancia
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : 
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_avalado_Vendida(pn_pais in number, pn_petdoc in number, pc_pendoc in char, pc_char out char);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
end PQ_CR_CAR_VENDIDA;
/

create or replace package body PQ_CR_CAR_VENDIDA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CAR_VENDIDA
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2019.08.09
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : paquete que evalua instancia
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 2019.11.11
  -- Autor de la Modificaci�n   : DCASTRO
  -- Descripci�n de Modificaci�n: Se agreg� operacion
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_avalado_Vendida(pn_pais in number, pn_petdoc in number, pc_pendoc in char, pc_char out char) is
   -- *****************************************************************
  -- Nombre                     : sp_cr_avalados_Vendida
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2019.08.09
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : retorna S si titular representativo tiene avalados con creditos en estado 65 vendido
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : 
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************
 
    cursor cuentas(ln_pais   in number,
                   ln_petdoc in number,
                   ln_pendoc in char) is
      select ctnro
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_petdoc
         and f.pendoc = ln_pendoc
         /*and f.ttcod = 1
         and f.cttfir = 'T'*/;
  
     cursor instancia(ln_cuenta in number) is
       select s.sng001inst
          from sng003 s-- avales
         where s.sng003cta = ln_cuenta; 
     
  
    ln_pais   number;
    ln_petdoc number;
    lc_pendoc char(12);
    lc_char   char(1);
    ln_cantidad number;
    ln_instancia number;
    ln_pgcod   number;
    ln_cuenta  number;
    ln_operacion number;
  
  begin
    lc_char := 'N';
    
    for i in cuentas(pn_pais, pn_petdoc, pc_pendoc) loop
      
      for j in instancia(i.ctnro) loop    
        ln_instancia := j.sng001inst;
        
        if ln_instancia is not null then
          begin
             select x.xwfempresa , x.xwfcuenta, x.xwfoperacion
               into ln_pgcod, ln_cuenta, ln_operacion   
               from xwf700 x 
              where x.xwfprcins = ln_instancia
                and x.xwfcar3 = '1';
          exception when others then
              ln_pgcod := null;
              ln_cuenta := null;
              ln_operacion := null;
          end;
          
           if ln_cuenta is not null then
              begin
                select count(*)
                  into ln_cantidad
                  from fsd011 f
                 where f.pgcod = 1
                   and f.scmod = 65
                   and f.sccta = ln_cuenta
                   and f.scoper = ln_operacion;  --11/11/2019
              end;
             
              if nvl(ln_cantidad, 0) > 0 then
                lc_char := 'S';
                exit;
              else
                lc_char := 'N';
              end if;
              
            end if;
         end if;
                
      end loop;
      
    end loop;
  
  
    pc_char := lc_char;
    
  end sp_cr_avalado_Vendida;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CAR_VENDIDA;
/

