create or replace package PQ_CR_ASIGN_SUCREEMP is
  -- *****************************************************************
  -- Nombre                     : Proceso para asignacion de Sucursal y reemplazo de usuarios
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 25/06/2024 08:53:51
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Asignacion de Sucursal y reemplazo de usuarios
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación:   
  -- *****************************************************************

  procedure sp_cr_CambSucursal(lc_Usuario     in varchar2,
                               ln_NewSucursal in number,
                               lc_Gestor      in varchar2,
                               lc_sms         out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_Reemplazo(lc_Usuario  in varchar2,
                            lc_Suplente in varchar2,
                            ld_FchIni   in date,
                            ld_FchFin   in date,
                            lc_Gestor   in varchar2,
                            lc_sms      out varchar2);
  -------------------------------------------------------------
  procedure sp_Cr_LogAQPB177(ld_fecha   in date,
                             lc_gestor  in varchar2,
                             lc_identf  in varchar2,
                             lc_user    in varchar2,
                             ln_cargusu in number,
                             ln_sucori  in number,
                             ln_sucdes  in number,
                             lc_supl    in varchar2,
                             ln_cargsp  in number,
                             ld_fchini  in date,
                             ld_fchfin  in date);

end PQ_CR_ASIGN_SUCREEMP;
/

create or replace package body PQ_CR_ASIGN_SUCREEMP is

  procedure sp_cr_CambSucursal(lc_Usuario     in varchar2,
                               ln_NewSucursal in number,
                               lc_Gestor      in varchar2,
                               lc_sms         out varchar2) is
  
    ln_SucOld     number;
    ln_ContCambio number := 0;
    ld_FchSist    date;
  
  begin
  
    lc_sms := 'No se pudo realizar lo solicitado';
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpb177 a
         set a.aqpb177est = 'I'
       where a.aqpb177fecha = ld_FchSist
         and a.aqpb177gestor = lc_Gestor
         and a.aqpb177user = lc_Usuario
         and a.aqpb177identf = 'SUCURSAL';
      commit;
    end;
  
    begin
      select count(*)
        into ln_ContCambio
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 133
         and f.tp1corr2 = 1
         and f.tp1corr3 > 0
         and f.tp1desc = rpad(lc_Gestor, 30, ' ');
    exception
      when others then
        ln_ContCambio := 0;
    end;
  
    ln_ContCambio := nvl(ln_ContCambio, 0);
  
    if ln_ContCambio > 0 then
    
      begin
        select f.ubsuc
          into ln_SucOld
          from fst046 f
         where f.pgcod = 1
           and f.ubuser = RPAD(lc_Usuario, 10, ' ');
      exception
        when others then
          null;
      end;
    
      if ln_NewSucursal > 0 then
        begin
          update fst046 f
             set f.ubsuc = ln_NewSucursal
           where f.pgcod = 1
             and f.ubuser = RPAD(lc_Usuario, 10, ' ');
        end;
      
        if ln_NewSucursal = 905 then
        
          begin
            update sng057 s
               set s.sng057aut = 'N'
             where s.sng057usr = RPAD(lc_Usuario, 10, ' ');
          end;
        end if;
      
        if ln_SucOld = 905 and ln_NewSucursal <> 905 then
          begin
            update sng057 s
               set s.sng057aut = 'S'
             where s.sng057usr = RPAD(lc_Usuario, 10, ' ');
          end;
        end if;
      
        lc_sms := 'Se realizo lo solicitado satisfactoriamente.';
        commit;
      end if;
    
    else
      if ln_ContCambio = 0 then
      
        lc_sms := 'Usuario no habilitado para realizar la accion.';
      
      end if;
    end if;
  
    begin
      pq_cr_asign_sucreemp.sp_Cr_LogAQPB177(ld_fecha   => ld_FchSist,
                                            lc_gestor  => lc_Gestor,
                                            lc_identf  => 'SUCURSAL',
                                            lc_user    => lc_Usuario,
                                            ln_cargusu => null,
                                            ln_sucori  => ln_SucOld,
                                            ln_sucdes  => ln_NewSucursal,
                                            lc_supl    => null,
                                            ln_cargsp  => null,
                                            ld_fchini  => null,
                                            ld_fchfin  => null);
    end;
  
  end sp_cr_CambSucursal;
  -----------------------------------------------------------------------------------
  procedure sp_cr_Reemplazo(lc_Usuario  in varchar2,
                            lc_Suplente in varchar2,
                            ld_FchIni   in date,
                            ld_FchFin   in date,
                            lc_Gestor   in varchar2,
                            lc_sms      out varchar2) is
  
    ln_ContCambio   number := 0;
    ln_CargUsu      number := 0;
    ln_CargReempl   number := 0;
    ln_ContCargSupl number := 0;
    ln_ContCargUsu  number := 0;
    ld_FchSist      date;
  
  begin
  
    lc_sms := 'No se pudo realizar lo solicitado';
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpb177 a
         set a.aqpb177est = 'I'
       where a.aqpb177fecha = ld_FchSist
         and a.aqpb177gestor = lc_Gestor
         and a.aqpb177user = lc_Usuario
         and a.aqpb177identf = 'SUPLENCIA';
      commit;
    end;
  
    begin
      select count(*)
        into ln_ContCambio
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 133
         and f.tp1corr2 = 1
         and f.tp1corr3 > 0
         and f.tp1desc = rpad(lc_Gestor, 30, ' ');
    exception
      when others then
        ln_ContCambio := 0;
    end;
  
    ln_ContCambio := nvl(ln_ContCambio, 0);
  
    if ln_ContCambio > 0 then
    
      begin
        select s.sng055car
          into ln_CargUsu
          from sng057 s
         where s.sng057usr = rpad(lc_Usuario, 10, ' ');
      exception
        when others then
          null;
      end;
    
      begin
        select s.sng055car
          into ln_CargReempl
          from sng057 s
         where s.sng057usr = rpad(lc_Suplente, 10, ' ');
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_ContCargUsu
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 133
           and f.tp1corr2 = 2
           and f.tp1nro3 = ln_CargUsu;
      exception
        when others then
          ln_ContCargUsu := 0;
      end;
    
      begin
        select count(*)
          into ln_ContCargSupl
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 133
           and f.tp1corr2 = 2
           and f.tp1nro3 = ln_CargReempl;
      exception
        when others then
          ln_ContCargSupl := 0;
      end;
    
      if ln_ContCargUsu > 0 and ln_ContCargSupl > 0 then
      
        begin
          update sng057 s
             set s.sng057sup = lc_Suplente,
                 S.SNG057INI = ld_FchIni,
                 s.sng057fin = ld_FchFin + 1
           where s.sng057usr = rpad(lc_Usuario, 10, ' ');
        end;
        commit;
      
        lc_sms := 'Se realizo lo solicitado satisfactoriamente.';
      
      else
      
        lc_sms := 'El cargo de uno de los usuarios ingresados no cumple con las condiciones establecidas.';
      
      end if;
    
    else
    
      lc_sms := 'Usuario no habilitado para realizar lo solicitado.';
    
    end if;
  
    begin
      pq_cr_asign_sucreemp.sp_Cr_LogAQPB177(ld_fecha   => ld_FchSist,
                                            lc_gestor  => lc_Gestor,
                                            lc_identf  => 'SUPLENCIA',
                                            lc_user    => lc_Usuario,
                                            ln_cargusu => ln_CargUsu,
                                            ln_sucori  => null,
                                            ln_sucdes  => null,
                                            lc_supl    => lc_Suplente,
                                            ln_cargsp  => ln_CargReempl,
                                            ld_fchini  => ld_FchIni,
                                            ld_fchfin  => ld_FchFin + 1);
    end;
  
  end sp_cr_Reemplazo;
  --------------------------------------------------------------
  procedure sp_Cr_LogAQPB177(ld_fecha   in date,
                             lc_gestor  in varchar2,
                             lc_identf  in varchar2,
                             lc_user    in varchar2,
                             ln_cargusu in number,
                             ln_sucori  in number,
                             ln_sucdes  in number,
                             lc_supl    in varchar2,
                             ln_cargsp  in number,
                             ld_fchini  in date,
                             ld_fchfin  in date) is
  
    ln_corr number := 0;
    lc_hora varchar2(10) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpb177cor)
        into ln_corr
        from aqpb177 a
       where a.aqpb177fecha = ld_fecha
         and a.aqpb177gestor = lc_gestor;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb177
        (aqpb177cor,
         aqpb177fecha,
         aqpb177hora,
         aqpb177gestor,
         aqpb177identf,
         aqpb177user,
         aqpb177cargusu,
         aqpb177sucori,
         aqpb177sucdes,
         aqpb177supl,
         aqpb177cargsp,
         aqpb177fchini,
         aqpb177fchfin,
         aqpb177est)
      values
        (ln_corr + 1,
         ld_fecha,
         lc_hora,
         lc_gestor,
         lc_identf,
         lc_user,
         ln_cargusu,
         ln_sucori,
         ln_sucdes,
         lc_supl,
         ln_cargsp,
         ld_fchini,
         ld_fchfin,
         'H');
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_Cr_LogAQPB177;
  --------------------------------------------------------------------------------
end PQ_CR_ASIGN_SUCREEMP;
/

