create or replace procedure sp_ah_copiaichannel(P_D_FECINI  IN DATE,
                                                P_D_FECFIN  IN DATE,
                                                P_C_USUARIO IN VARCHAR2                         
                                                ) is
   -- *****************************************************************
    -- Nombre                     : sp_ah_copiaichannel
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Copia data de ichannel
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 12/04/2024
    -- Autor de la Modificación   : Yrving Lozada
    -- Descripción de Modificación: Se adicionó mas canales 
    -- *****************************************************************                                                 
  lv_texto varchar2(4000):='';
  lv_usuario char(10)   := P_C_USUARIO; 
  lv_fecini varchar2(10):= to_char(P_D_FECINI,'dd.mm.rrrr');
  lv_fecfin varchar2(10):= to_char(P_D_FECFIN,'dd.mm.rrrr');
begin
  lv_texto := 'delete from aqpa146 where AQPA146USU = '||''''||lv_usuario||'''';
  execute immediate (lv_texto);      
  commit;         
  lv_texto := 'insert into aqpa146 (AQPA146USU,AQPA146IDE,AQPA146CAN,AQPA146EST,AQPA146ENV,AQPA146DES,AQPA146MSG,AQPA146FIN,AQPA156FMD,AQPA146ERR) 
    select '||''''||lv_usuario||''''||', id,canal,estado,tipo_envio,destino,mensaje,fecha_hora_insercion,fecha_hora_modificacion,error_envio
      from "mensajes"@ichannel
     where to_date(substr(fecha_hora_insercion, 1,10),''dd.mm.rrrr'') between to_date('||''''||lv_fecini||''''||',''dd.mm.rrrr'') and to_date('||''''||lv_fecfin||''''||',''dd.mm.rrrr'')
       and canal in (Select distinct x.tp1nro2 from fst198 x where x.tp1cod   = 1 and x.tp1cod1  = 10825 and x.tp1corr1 = 126 and x.tp1corr2 = 7)'; 
  execute immediate (lv_texto);   
  commit;     
exception
when others then  
  rollback;
end sp_ah_copiaichannel;
/

