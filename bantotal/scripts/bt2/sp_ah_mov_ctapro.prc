create procedure sp_ah_mov_ctapro(P_C_FECPRO IN VARCHAR2) is
   -- *****************************************************************
    -- Nombre                     : sp_ah_mov_ctapro
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 25/08/2025
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Procedimiento para copiar data de movimientos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************  
cursor c_cuentas is
  select * 
    from fst198 
   where tp1cod1  = 10825 
     and tp1corr1 = 135;
begin
  if substr(P_C_FECPRO,1,2) = '01' then 
     execute immediate('truncate table AQPC452');
  end if;
  
  for i in c_cuentas loop
       insert into AQPC452
            select f.pgcod,  
                   f.hsucor, 
                   f.hcmod,  
                   f.htran,  
                   f.hnrel,  
                   f.hfcon,  
                   f.hcord,  
                   f.hcsubo, 
                   f.hcta,   
                   f.hoper,  
                   f.hsubop, 
                   f.hmodul, 
                   f.hsucur, 
                   f.htoper, 
                   f.hmda,   
                   f.hpap,   
                   f.hcimp4,
                   null,  
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null,
                   null
              from fsh016 f, fsh015 h 
             where f.pgcod = h.pgcod
               and f.hsucor = h.hsucor
               and f.hcmod = h.hcmod
               and f.htran = h.htran               
               and f.hnrel = h.hnrel
               and h.hfcon = f.hfcon
               and f.hfcon = to_date(P_C_FECPRO,'dd//mm/rrrr')
               and h.hccorr <> 99
               and f.pgcod  = i.Tp1cod
               and f.hcta   = i.Tp1corr3
               and f.hoper  = i.Tp1nro1
               and f.hsubop = i.Tp1nro2
               and f.hmodul = i.Tp1imp1
               and f.hsucur = i.Tp1imp2
               and f.htoper = i.Tp1nro2
               and f.hmda   = i.Tp1imp3
               and f.hpap   = 0
               and f.pgcod  = 1
               and h.pgcod  = 1;
               commit;
  end loop; 
exception
when others then
    null;                   
end sp_ah_mov_ctapro;
/
