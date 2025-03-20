create or replace package pq_cr_faeturismo is
  /* BHERNARD S. BEISAGA ARENAS
    * PROYECTO CARGA MASIVA DE DATOS DE XLS PARA FAE TURISMO
    */

  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2);

  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2);
                                   
 procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);                            
                                   
 procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);                                 

end;
/

create or replace package body pq_cr_faeturismo is

  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2) is

    -- lc_corr number;

  begin

    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        -- FAE TURISMO
        pn_flag := 'S';
        --- Obtener el correlativo
        select nvl(max(t.aqpb762acor), 0) + 1 into pn_corr from aqpb762a t;
        --- Reporte FAE
        insert into aqpb762a
          (aqpb762acod, aqpb762afec,aqpb762acor,
           aqpb762aest,
           aqpb762ausr, aqpb762afcr,aqpb762ahcr)
        values
          (pn_pgcod, pn_fecha, pn_corr,
           'I', --INSERTAR
           pn_usuario, to_char(sysdate, 'DD/MM/YYYY'),to_char(sysdate, 'HH24:MI:SS'));
        commit;
    end case;

  end sp_insertar_pauxiliar;
  
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2) is  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---FAE AGRO      
        pn_flag := 'S';      
        --Actualización del detalle de la plantilla
        update aqpb762b t
           set t.aqpb762best  = pn_estado,
               t.aqpb762busu  = pn_usuario,
               t.aqpb762bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb762bhedi = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb762bcod = pn_pgcod
           and t.aqpb762bfec = pn_fecha
           and t.aqpb762bcor = pn_corr
           and t.aqpb762best <> 'D';
        commit;
      -- Actualizacion de la cabecera
        update aqpb762a t
           set t.aqpb762aest = pn_estado,
               t.aqpb762ausd = pn_usuario,
               t.aqpb762afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb762ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb762acod = pn_pgcod
           and t.aqpb762afec = pn_fecha
           and t.aqpb762acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_cabecera;
  
   procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
  begin  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---fae agro      
        pn_flag := 'S';
      
        update aqpb762a t
           set t.aqpb762aest = pn_estado,
               t.aqpb762ausd = pn_usuario,
               t.aqpb762afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb762ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb762acod = pn_pgcod
           and t.aqpb762afec = pn_fecha
           and t.aqpb762acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  
    procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
    pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---FAE AGRO
        pn_flag := 'S';
      
        --Actualización de la cabecera principal
        update aqpb762a t
           set t.aqpb762aest = pn_estado,
               t.aqpb762ausd = pn_usuario,
               t.aqpb762afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb762ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb762acod = pn_pgcod
           and t.aqpb762afec = pn_fecha
           and t.aqpb762acor = pn_corr;
        commit;
      
    end case;
  
  end sp_anulacion_individual;

end;
/

