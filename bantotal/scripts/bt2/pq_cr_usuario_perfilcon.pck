create or replace package PQ_CR_USUARIO_PERFILCON is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_USUARIO_PERFILCON
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/12/2023
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 2024.02.08 DCASTRO se agrego excepcion when others en procedimiento.
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_usuarios(pc_usuana in varchar2,
                           pc_usureg out varchar2,
                           pc_usuzon out varchar2
                           ) ;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_USUARIO_PERFILCON;
/

create or replace package body PQ_CR_USUARIO_PERFILCON is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_USUARIO_PERFILCON
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.02.08 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 2024.02.08 DCASTRO se agrego excepcion when others en procedimiento.
  --
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_usuarios(pc_usuana in varchar2,
                           pc_usureg out varchar2,
                           pc_usuzon out varchar2
                           ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_usuarios
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.11.17
    -- Autor de Creación          : YYAMPI/DCASTRO
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
    
    lc_codana char(10);
    lc_codsuc number;
    
  begin
       lc_codana := replace(pc_usuana , ' ',10);
        
       begin
          select f.ubsuc
            into lc_codsuc
            from fst046 f
           where f.ubuser = lc_codana;
       exception when others then
         null;    
       end;
  
  
       /*gerente regional */
       begin
          select s2.ubuser--s1.*, s2.*
            into pc_usureg
            from (select r2.*
                    from (select t.regcod,
                                 t.regnom,
                                 t.codzon,
                                 t.deszon,
                                 t.sucurs,
                                 t.scnom
                            from REGSUC T) r2,
                         (select t.regcod,
                                 t.regnom,
                                 t.codzon,
                                 t.deszon,
                                 t.sucurs,
                                 t.scnom
                            from REGSUC T
                           WHERE T.SUCURS = lc_codsuc) r1
                   where r2.regcod = r1.regcod --and r2.codzon = r1.codzon    
                  ) s1,
                 (select u.ubsuc, u.ubuser, t.PRFGCOD
                    from PRFU00 T, FST046 U
                   WHERE T.PRFGCOD IN (--'GREG01'
                                        select rpad(trim(TP1DESC), 10, ' ') 
                                          from fst198 f
                                         where f.tp1cod = 1
                                           and f.tp1cod1 = 10847
                                           and f.tp1corr1 = 95
                                           and f.tp1corr2 = 1
                                       )
                     and u.ubuser = t.ubuser) s2
           where s2.ubsuc = s1.sucurs
             and s1.sucurs <> 904;
      exception 
             when too_many_rows then 
                begin
                  select s2.ubuser--s1.*, s2.*
                    into pc_usureg
                    from (select r2.*
                            from (select t.regcod,
                                         t.regnom,
                                         t.codzon,
                                         t.deszon,
                                         t.sucurs,
                                         t.scnom
                                    from REGSUC T) r2,
                                 (select t.regcod,
                                         t.regnom,
                                         t.codzon,
                                         t.deszon,
                                         t.sucurs,
                                         t.scnom
                                    from REGSUC T
                                   WHERE T.SUCURS = lc_codsuc) r1
                           where r2.regcod = r1.regcod --and r2.codzon = r1.codzon    
                          ) s1,
                         (select u.ubsuc, u.ubuser, t.PRFGCOD
                            from PRFU00 T, FST046 U
                           WHERE T.PRFGCOD IN (--'GREG01'
                                                select rpad(trim(TP1DESC), 10, ' ')  
                                                  from fst198 f
                                                 where f.tp1cod = 1
                                                   and f.tp1cod1 = 10847
                                                   and f.tp1corr1 = 95
                                                   and f.tp1corr2 = 1
                                               )
                             and u.ubuser = t.ubuser) s2
                   where s2.ubsuc = s1.sucurs
                     and s1.sucurs <> 904
                     and rownum = 1;
                 exception when others then
                    null;    
                 end; 
            when others then -- 2024.02.08 dcastro se agrego excepcion when others 
                 null;
       end;

      /*gerente zonal */
      begin
          select s2.ubuser
            into pc_usuzon--s1.*, s2.*
            from (select r2.*
                    from (select t.regcod,
                                 t.regnom,
                                 t.codzon,
                                 t.deszon,
                                 t.sucurs,
                                 t.scnom
                            from REGSUC T) r2,
                         (select t.regcod,
                                 t.regnom,
                                 t.codzon,
                                 t.deszon,
                                 t.sucurs,
                                 t.scnom
                            from REGSUC T
                           WHERE T.SUCURS = lc_codsuc) r1
                   where r2.regcod = r1.regcod
                     and r2.codzon = r1.codzon) s1,
                 (select u.ubsuc, u.ubuser, t.PRFGCOD
                    from PRFU00 T, FST046 U
                   WHERE T.PRFGCOD IN (--'JZON01'
                                       select rpad(trim(TP1DESC), 10, ' ') 
                                          from fst198 f
                                         where f.tp1cod = 1
                                           and f.tp1cod1 = 10847
                                           and f.tp1corr1 = 95
                                           and f.tp1corr2 = 2
                                       )
                     and u.ubuser = t.ubuser) s2
           where s2.ubsuc = s1.sucurs
            and s1.sucurs <> 904;
       exception when others then
         null;            
       end;    
  
  end sp_cr_usuarios;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
end PQ_CR_USUARIO_PERFILCON;
/

