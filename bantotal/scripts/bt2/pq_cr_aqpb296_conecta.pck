create or replace package PQ_CR_AQPB296_CONECTA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_AQPB296_CONECTA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.09.20
  -- Autor de Creación          : DCASTRO
  -- Uso                        : RETORNA INFORMACION TABLA AQPB296
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 03/10/2024
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure SP_ACTUALIZA(    pn_petdoc in number,                        
                             pc_pendoc in varchar2,
                             pc_usuario in varchar2,
                             pn_sucur in number,
                             pc_estado out varchar2
                         )  ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


                                                            
end PQ_CR_AQPB296_CONECTA;
/

create or replace package body PQ_CR_AQPB296_CONECTA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_AQPB296_CONECTA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.09.20
  -- Autor de Creación          : DCASTRO
  -- Uso                        : RETORNA INFORMACION TABLA AQPB296
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure SP_ACTUALIZA(    pn_petdoc in number,                        
                             pc_pendoc in varchar2,
                             pc_usuario in varchar2,
                             pn_sucur in number,
                             pc_estado out varchar2
                         ) is
    -- *****************************************************************
    -- Nombre                     : SP_ACTUALIZA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.09.20
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Actualiza la la tabla AQPB296
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 03/10/2024
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: SE AGREGARON LOS SIGUIENTES CAMPOS A ACTUALIZAR:
    --                              - AQPB296AGE
    --                              - AQPB296ZON
    --                              - AQPB296REG
    -- *****************************************************************
  ld_fecha date;
  lc_pendoc char(12);
  ln_contador number;
  lc_existe char(1);
  ln_regcod number(3);
  ln_codzon number(3);
  
  begin
   pc_estado := 'N';  --inicializa en N    
   lc_pendoc := rpad(trim(pc_pendoc),12, ' ');

    begin            
        select to_date ( trim(tp1desc), 'DD/MM/RRRR') 
           into ld_fecha    
           from fst198 f
           where tp1cod = 1
             and tp1cod1 = 10847 
             and tp1corr1 = 900
              and tp1corr2 = 1;
     exception when others then
          ld_fecha  := null;   
      end;           
    
    --verificar si existe
    begin
       select 'S'
         into lc_existe  
         from aqpb296 a
       where a.aqpb296feca = ld_fecha
         and a.aqpb296tdoc = pn_petdoc
         and a.aqpb296ndoc = lc_pendoc
         and a.aqpb296est  = 'S';
    exception when others then
          lc_existe  := 'N';         
    end;
    if lc_existe = 'S' then
       ---si esta registrado
       begin
            select count(*) 
              into ln_contador
               from aqpb296 a
             where a.aqpb296feca = ld_fecha
               and a.aqpb296tdoc = pn_petdoc
               and a.aqpb296ndoc = lc_pendoc
               and a.aqpb296est  = 'S'
               and a.aqpb296desc = 'REGISTRADO';
       exception when others then
           ln_contador := 0;   
       end;   
    
       if ln_contador = 0 then ---sino esta registrado debe actualizar
             begin
                 select r.regcod, r.codzon
                 into ln_regcod, ln_codzon
                  from regsuc r 
                  where r.sucurs = pn_sucur; 
             exception when others then
                 ln_regcod := 0;
                 ln_codzon := 0;
             end;           
       
             begin
                  update aqpb296 a
                     set a.aqpb296usu1 = pc_usuario,
                         a.aqpb296desc = 'REGISTRADO',
                         a.aqpb296var2 = 'Cliente Activo Registrado',
                         a.aqpb296fech1 = trunc(sysdate), 
                         a.aqpb296hora = to_char(sysdate, 'HH:MM:SS'),
                         a.aqpb296age =  pn_sucur, 
                         a.aqpb296zon =  ln_codzon,
                         a.aqpb296reg =  ln_regcod
                   where a.aqpb296feca = ld_fecha
                     and a.aqpb296tdoc = pn_petdoc
                     and a.aqpb296ndoc = lc_pendoc
                     and a.aqpb296est  = 'S';
                   commit; 
                   pc_estado := 'S';  
             exception when others then
                 pc_estado := 'N';   
             end;
       else
           pc_estado := 'N';        
       end if;    
     end if;
           
  end SP_ACTUALIZA;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


end PQ_CR_AQPB296_CONECTA;
/

