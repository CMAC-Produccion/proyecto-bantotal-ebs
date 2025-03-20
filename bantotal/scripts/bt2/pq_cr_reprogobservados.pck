create or replace package pq_cr_reprogobservados is
  /* BHERNARD S. BEISAGA ARENAS
    * CARGA MASIVA DE CREDITOS REPROGRAMADOS OBSERVADOS, FONDOS REACTIVA Y FAE Mype
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

create or replace package body pq_cr_reprogobservados is

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
        pn_flag := 'S';
        --- Obtener el correlativo
        select nvl(max(t.aqpb764acor), 0) + 1 into pn_corr from aqpb764a t;
        insert into aqpb764a
          (aqpb764acod, aqpb764afec,aqpb764acor,
           aqpb764aest,
           aqpb764ausr, aqpb764afcr,aqpb764ahcr)
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
        pn_flag := 'S';
        --Actualización del detalle de la plantilla
        update aqpb764b t
           set t.aqpb764best  = pn_estado,
               t.aqpb764busu  = pn_usuario,
               t.aqpb764bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb764bhedi = to_char(sysdate, 'HH24:MI:SS')

         where t.aqpb764bcod = pn_pgcod
           and t.aqpb764bfec = pn_fecha
           and t.aqpb764bcor = pn_corr
           and t.aqpb764best <> 'D';
        commit;
      -- Actualizacion de la cabecera
        update aqpb764a t
           set t.aqpb764aest = pn_estado,
               t.aqpb764ausd = pn_usuario,
               t.aqpb764afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb764ahed = to_char(sysdate, 'HH24:MI:SS')

         where t.aqpb764acod = pn_pgcod
           and t.aqpb764afec = pn_fecha
           and t.aqpb764acor = pn_corr;
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
        pn_flag := 'S';

        update aqpb764a t
           set t.aqpb764aest = pn_estado,
               t.aqpb764ausd = pn_usuario,
               t.aqpb764afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb764ahed = to_char(sysdate, 'HH24:MI:SS')

         where t.aqpb764acod = pn_pgcod
           and t.aqpb764afec = pn_fecha
           and t.aqpb764acor = pn_corr;
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

  begin

    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        pn_flag := 'S';

        --Actualización de la cabecera principal
        update aqpb764a t
           set t.aqpb764aest = pn_estado,
               t.aqpb764ausd = pn_usuario,
               t.aqpb764afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb764ahed = to_char(sysdate, 'HH24:MI:SS')

         where t.aqpb764acod = pn_pgcod
           and t.aqpb764afec = pn_fecha
           and t.aqpb764acor = pn_corr;
        commit;

    end case;

  end sp_anulacion_individual;

end;
/

