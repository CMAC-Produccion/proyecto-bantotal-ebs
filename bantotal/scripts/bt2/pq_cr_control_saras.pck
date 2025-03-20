create or replace package pq_cr_control_saras is

  -- Author  : JCAHUANAN
  -- Created : 21/10/2020 20:20:57
  -- Purpose : 

  -- Public type declarations

  procedure sp_cr_control_actividad(pn_instance in numeric,
                                    pd_Pgfape   in date,
                                    pv_Usuario  in varchar2,
                                    pv_rpta     out varchar2);

  procedure sp_cr_control_cuentas_saras(pn_instance in numeric);

  procedure sp_cr_cambio_actividad(pn_insta  in numeric,
                                   pd_Pgfape in date,
                                   pv_rpta   out varchar2);

  procedure sp_cr_firma_ddjj(pn_instancia in numeric,
                             pn_cuenta    in numeric,
                             pn_pais      in numeric,
                             pn_tdoc      in numeric,
                             pn_ndoc      in varchar2,
                             pn_rpta      in numeric,
                             pn_modo      in varchar2,
                             pn_user      in varchar2,
                             pn_fecha     in date,
                             pn_obs       in varchar2);

  -----------------------------------------------
  procedure sp_cr_LogAQPB351(ln_inst      in number,
                             ln_pais      in number,
                             ln_tdoc      in number,
                             lc_ndoc      in varchar2,
                             ld_fec       in date,
                             ln_cta       in number,
                             lc_user      in varchar2,
                             ln_tarea     in number,
                             ln_actividad in number);
  procedure sp_actualiza_aqpa302(pn_instancia in number);
  --------------------------------------------------
  procedure sp_cr_control_firma(pn_instance in numeric,
                                pv_rpta     out varchar2);
end pq_cr_control_saras;
/

create or replace package body pq_cr_control_saras is
  procedure sp_cr_control_cuentas_saras(pn_instance in numeric) is
    --retornamos la lista de cuentas
  
    ln_cuenta       numeric;
    ln_cant         numeric(5);
    ln_cant_aqpb302 numeric(5);
    ln_rpta         numeric(5);
    lv_nombre       varchar2(30);
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = ln_cuenta
         and pgcod = 1;
  
  begin
    -- buscar a los integrantes y buscar por cada uno si esta en la lista Saras  
    begin
      delete from aqpb303 where aqpb303inst = pn_instance;
      commit;
    
      --
      begin
        select sng001cta
          into ln_cuenta
          from sng001
         where sng001inst = pn_instance;
      exception
        when others then
          null;
      end;
      --
    
      for i in integrantes(ln_cuenta) loop
        select nvl(count(*), 0)
          into ln_cant
          from SNGC60
         where SNGC60PAIS = i.pepais
           and SNGC60TDOC = i.petdoc
           and SNGC60NDOC = i.pendoc
           and sngc60corr = 0
           and exists (select *
                  from aqpb352 a
                 where a.aqpb352tipo = 1
                   and a.aqpb352cod = SNGC60ACTE
                   and a.aqpb352est = 'G' -- buscamos el código de usuario en la 352
                );
        if ln_cant > 0 then
          begin
            select a.aqpb302respta
              into ln_rpta
              from aqpb302 a
             where a.aqpb302instancia = pn_instance
               and a.aqpb302pais = i.pepais
               and a.aqpb302tdoc = i.petdoc
               and a.aqpb302ndoc = i.pendoc
               and a.aqpb302estado = 'V';
          exception
            when others then
              ln_rpta := 0;
          end;
          --insertar en nueva tabla
          BEGIN
            select A.PENOM
              into lv_nombre
              from FSD001 A
             where A.PEPAIS = i.pepais
               AND A.PETDOC = i.petdoc
               AND A.PENDOC = i.pendoc;
          exception
            wHEN OTHERS then
              lv_nombre := '';
          end;
          insert into aqpb303
            (aqpb303inst,
             aqpb303tdoc,
             aqpb303ndoc,
             aqpb303nomb,
             aqpb303rpta,
             aqpb303pais,
             aqpb303fecha)
          values
            (pn_instance,
             i.petdoc,
             i.pendoc,
             lv_nombre,
             ln_rpta,
             i.pepais,
             sysdate);
          commit;
        end if;
      end loop;
    
    end; -- fin del begin principal
  
  end sp_cr_control_cuentas_saras;

  procedure sp_cr_control_actividad(pn_instance in numeric,
                                    pd_Pgfape   in date,
                                    pv_Usuario  in varchar2,
                                    pv_rpta     out varchar2) is
  
    -- agregue
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1;
  
    ln_cant     numeric(5);
    ln_cuenta   numeric;
    ln_etapa    numeric;
    ln_sng60act numeric;
  
  begin
  
    begin
      -- obtengo la cuenta 
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
  
    pv_rpta := 'N';
  
    begin
      select w.wftaskcod -- etapa de la cuenta
        into ln_etapa
        from wfwrkitems w
       where w.wfinsprcid = pn_instance
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
    end;
  
    if ln_etapa = 11 then
    
      update aqpb351 a
         set AQPB351EST = 'N'
       where a.aqpb351inst = pn_instance
         and a.aqpb351est = 'S'
         and a.aqpb351tarea = ln_etapa;
      commit;
    end if;
  
    for i in integrantes(ln_cuenta) loop
    
      begin
        select nvl(count(*), 0)
          into ln_cant
          from SNGC60
         where SNGC60PAIS = i.pepais
           and SNGC60TDOC = i.petdoc
           and SNGC60NDOC = i.pendoc
           and sngc60corr = 0
           and exists (select *
                  from aqpb352 a
                 where a.aqpb352tipo = 1
                   and a.aqpb352cod = SNGC60ACTE
                   and a.aqpb352est = 'G');
      exception
        when others then
          ln_cant := 0;
      end;
    
      begin
        -- obtenemos la actividad  de la tabña sngc60
        select SNGC60ACTE
          into ln_sng60act -- almacenamos en nuestra variable
          from SNGC60
         where SNGC60PAIS = i.pepais
           and SNGC60TDOC = i.petdoc
           and SNGC60NDOC = i.pendoc
           and sngc60corr = 0;
      exception
        when others then
          ln_sng60act := 0;
      end;
    
      if ln_cant > 0 then
        pv_rpta := 'S';
      
        if ln_etapa = 11 then
          ---------------------- verificar si existe o no
        
          pq_cr_control_saras.sp_cr_LogAQPB351(ln_inst      => pn_instance,
                                               ln_pais      => i.pepais,
                                               ln_tdoc      => i.petdoc,
                                               lc_ndoc      => i.pendoc,
                                               ld_fec       => pd_Pgfape,
                                               ln_cta       => ln_cuenta,
                                               lc_user      => pv_Usuario,
                                               ln_tarea     => ln_etapa,
                                               ln_actividad => ln_sng60act); -- si no existe, agregamos
        
        END IF;
      END IF;
    
    end loop;
  
  end sp_cr_control_actividad;

  procedure sp_cr_cambio_actividad(pn_insta  in numeric,
                                   pd_Pgfape in date,
                                   pv_rpta   out varchar2) is
  
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1;
  
    ln_cuenta        numeric;
    ln_actieco       numeric;
    ln_actiecosngc60 numeric;
  begin
    pv_rpta := 'N';
    begin
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;
  
    for i in integrantes(ln_cuenta) loop
      ln_actieco := 0;
      for hist_cambacti in (select *
                              from aqpb351
                             where aqpb351.aqpb351inst = pn_insta
                               and aqpb351tdoc = i.petdoc
                               and RPAD(trim(aqpb351.aqpb351ndoc), 12, ' ') =
                                   i.pendoc
                               and aqpb351pais = i.pepais
                               and ((pd_Pgfape - aqpb351.aqpb351fec) <= 30)
                               and ((pd_Pgfape - aqpb351.aqpb351fec) >= 0)) loop
        ln_actieco := hist_cambacti.aqpb351aeco;
      
        begin
          select SNGC60ACTE
            into ln_actiecosngc60
            from SNGC60
           where SNGC60PAIS = i.pepais
             and SNGC60TDOC = i.petdoc
             and SNGC60NDOC = i.pendoc
             and sngc60corr = 0;
        exception
          when others then
            ln_actiecosngc60 := 0;
        end;
      
        if ln_actieco <> ln_actiecosngc60 then
          pv_rpta := 'S';
          exit;
        end if;
      
      end loop;
    end loop;
  end sp_cr_cambio_actividad;
  procedure sp_cr_firma_ddjj(pn_instancia in numeric,
                             pn_cuenta    in numeric,
                             pn_pais      in numeric,
                             pn_tdoc      in numeric,
                             pn_ndoc      in varchar2,
                             pn_rpta      in numeric,
                             pn_modo      in varchar2,
                             pn_user      in varchar2,
                             pn_fecha     in date,
                             pn_obs       in varchar2) is
    ld_fecha date;
  
  begin
    begin
      select pgfape into ld_fecha from fst017 where pgcod = 1;
    exception
      when others then
        ld_fecha := sysdate;
    end;
    begin
      update aqpb302
         set aqpb302estado = 'N'
       where aqpb302instancia = pn_instancia
         and aqpb302cuenta = pn_cuenta
         and aqpb302pais = pn_pais
         and aqpb302tdoc = pn_tdoc
         and aqpb302ndoc = pn_ndoc
         and aqpb302estado = 'V';
    end;
  
    begin
      insert into aqpb302
        (aqpb302pais,
         aqpb302tdoc,
         aqpb302ndoc,
         aqpb302fecha,
         aqpb302hora,
         aqpb302estado,
         aqpb302respta,
         aqpb302modo,
         aqpb302userreg,
         aqpb302observ,
         aqpb302cuenta,
         aqpb302instancia)
      values
        (pn_pais,
         pn_tdoc,
         pn_ndoc,
         ld_fecha,
         to_char(sysdate, 'HH24:MI:SS'),
         'V',
         pn_rpta,
         pn_modo,
         pn_user,
         pn_obs,
         pn_cuenta,
         pn_instancia);
      commit;
    end;
  end sp_cr_firma_ddjj;
  ------------------------------------------------------------
  procedure sp_cr_LogAQPB351(ln_inst      in number,
                             ln_pais      in number,
                             ln_tdoc      in number,
                             lc_ndoc      in varchar2,
                             ld_fec       in date,
                             ln_cta       in number,
                             lc_user      in varchar2,
                             ln_tarea     in number,
                             ln_actividad in number) is
  
    ln_corr number := 0;
    lc_hora char(8) := '00:00:00';
    lc_est  varchar2(2) := 'S';
  
  begin
  
    begin
      select max(a.aqpb351corr)
        into ln_corr
        from aqpb351 a
       where a.aqpb351inst = ln_inst
         and a.aqpb351fec = ld_fec;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    lc_est := 'S';
  
    begin
      insert into aqpb351
        (aqpb351corr,
         aqpb351inst,
         aqpb351pais,
         aqpb351tdoc,
         aqpb351ndoc,
         aqpb351fec,
         aqpb351hora,
         aqpb351cta,
         aqpb351est,
         aqpb351user,
         aqpb351tarea,
         AQPB351AECO)
      values
        (ln_corr + 1,
         ln_inst,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ld_fec,
         lc_hora,
         ln_cta,
         lc_est,
         lc_user,
         ln_tarea,
         ln_actividad);
      commit;
    end;
  
  end sp_cr_LogAQPB351;

  procedure sp_actualiza_aqpa302(pn_instancia in number) is
  begin
    update aqpb302
       set aqpb302estado = 'N'
     where aqpb302instancia = pn_instancia
       and aqpb302estado = 'V';
    commit;
  end sp_actualiza_aqpa302;

  procedure sp_cr_control_firma(pn_instance in numeric,
                                pv_rpta     out varchar2) is
  
    -- agregue
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1;
  
    ln_cant     numeric(5);
    ln_cuenta   numeric;
    ln_sng60act numeric;
    ln_rpta numeric(5);
  
  begin
  
    begin
      -- obtengo la cuenta 
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_instance;
    exception
      when others then
        null;
    end;
  
    pv_rpta := 'N';
  
    for i in integrantes(ln_cuenta) loop
    
      begin
        select nvl(count(*), 0)
          into ln_cant
          from SNGC60
         where SNGC60PAIS = i.pepais
           and SNGC60TDOC = i.petdoc
           and SNGC60NDOC = i.pendoc
           and sngc60corr = 0
           and exists (select *
                  from aqpb352 a
                 where a.aqpb352tipo = 1
                   and a.aqpb352cod = SNGC60ACTE
                   and a.aqpb352est = 'G');
      exception
        when others then
          ln_cant := 0;
      end;
    
      if ln_cant > 0 then
        begin
          select A.AQPB302RESPTA INTO ln_rpta
            from aqpb302 a
           where a.aqpb302instancia = pn_instance
             and a.aqpb302pais = i.pepais
             and a.aqpb302tdoc = i.petdoc
             and a.aqpb302ndoc = i.pendoc
             and a.aqpb302estado = 'V';
        exception
          when others then
            pv_rpta := 'S';
        end;
      END IF;
      
    end loop;
  
  end sp_cr_control_firma;

end pq_cr_control_saras;
/

