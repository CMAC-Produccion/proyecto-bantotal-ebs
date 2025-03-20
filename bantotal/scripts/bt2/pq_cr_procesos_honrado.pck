create or replace package pq_cr_procesos_honrado is

  -- *****************************************************************
  -- Nombre                       : pq_cr_procesos_honrado
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 17/04/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete de procesos de honramiento
  -- Fecha de Modificación        :
  -- Autor de Modificación        :
  -- Descripción de Modificación  :
  -- *****************************************************************

  -- Registro de información en plantilla
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Actualización de información en plantilla
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_aqpb094e_eliminar(pn_pgcod   in number,
                                 pn_fecha   in date);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                    
end pq_cr_procesos_honrado;
/

create or replace package body pq_cr_procesos_honrado is

  -- *****************************************************************
  -- Nombre                       : pq_cr_procesos_honrado
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 17/04/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete de procesos de honramiento
  -- Fecha de Modificación        :
  -- Autor de Modificación        :
  -- Descripción de Modificación  :
  -- *****************************************************************

  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2) is
  
    lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- REACTIVA
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpb094cor), 0) + 1 into pn_corr from aqpb094 t;
      
        --- Reporte FAE
        insert into aqpb094
          (aqpb094cod,
           aqpb094cor,
           aqpb094fec,
           aqpb094est,
           aqpb094usr,
           aqpb094fcr,
           aqpb094hcr)
        values
          (pn_pgcod,
           pn_corr,
           pn_fecha,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2) is
  
    pn_est  char(1);
    pn_cont number(3);
  
  begin
  
    pn_flag := 'N';
  
    begin
      select count(*)
        into pn_cont
        from aqpb433 x
       where x.aqpb433cod = pn_pgcod
         and x.aqpb433cor = pn_corr
         and x.aqpb433est = 'C';
    exception
      when others then
        pn_cont := 0;
    end;
  
    --case
    --  when pn_tiporep = 1 and pn_cont then
    ---HONRAMIENTO
  
    if pn_cont = 0 then
    
      update aqpb094 t
         set t.aqpb094est = pn_estado, ---- A
             t.AQPB094usd = pn_usuario,
             t.AQPB094fed = to_char(sysdate, 'DD/MM/YYYY'),
             t.AQPB094hed = to_char(sysdate, 'HH24:MI:SS')
       where t.aqpb094cod = pn_pgcod
         and t.aqpb094cor = pn_corr
         and t.aqpb094fec = pn_fecha;
      commit;
    
      update aqpb433 t
         set t.aqpb433est = pn_estado ---A
       where t.aqpb433cod = pn_pgcod
         and t.aqpb433cor = pn_corr;
      commit;
    
      pn_flag := 'S';
    
    end if;
  
    --end case;
  
  end sp_actualizar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_aqpb094e_eliminar(pn_pgcod in number, pn_fecha in date) is
  
  begin
  
    delete from aqpb094e x
     where x.aqpb094ecod = pn_pgcod
       and x.aqpb094efec = pn_fecha;
    commit;
  
  end sp_aqpb094e_eliminar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

end pq_cr_procesos_honrado;
/

