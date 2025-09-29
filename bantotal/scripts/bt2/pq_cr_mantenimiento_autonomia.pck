create or replace package PQ_CR_MANTENIMIENTO_AUTONOMIA is
  --*****************************************************************
  -- Nombre                     : PQ_CR_MANTENIMIENTO_AUTONOMIA
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 13/11/2019 11:34:24 a. m.
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Proceso PQ_CR_MANTENIMIENTO_AUTONOMIA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 25/07/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se optimizo la consulta que devuelve el nombre del cliente, obtencion de la clave del credito.
  -- Fecha de Modificación      : 23/09/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se cambio la numeracion del correlativo para la insercion por una secuencia
  -- *****************************************************************

  procedure sp_cr_Inicio(lc_UsuLogin in varchar2,
                         lc_UsuUpdt  in varchar2,
                         lc_TipoUpdt in varchar2,
                         ld_FecPro   in date,
                         lc_Rpta     out varchar2);
  ----------------------------------------------------------                         
  procedure sp_cr_LogSNG057(ld_fec   in date,
                            lc_userl in varchar2,
                            lc_useru in varchar2,
                            ln_emp   in number,
                            lc_usr   in character,
                            ln_car   in number,
                            lc_aut   in character,
                            lc_sup   in character,
                            ld_ini   in date,
                            ld_fin   in date,
                            lc_jef   in character,
                            lc_wkf   in character,
                            ln_prc   in number,
                            ln_tsk   in number);
  ----------------------------------------------------
  procedure sp_cr_InicioReporte(lc_Usuario in varchar2,
                                ld_FecPro  in date,
                                ld_fchIni  in date,
                                ld_fchFin  in date,
                                lc_Tipo    in varchar2);

  ---------------------------------------------------
  procedure sp_cr_reporte(ld_fec        in date,
                          lc_user       in varchar2,
                          ln_inst       in number,
                          ln_pgcod      in number,
                          ln_mod        in number,
                          ln_suc        in number,
                          ln_cta        in number,
                          ln_ope        in number,
                          ln_sbop       in number,
                          ln_top        in number,
                          lc_NombCli    in varchar2,
                          lc_NombAge    in varchar2,
                          lc_AnalisCred in varchar2,
                          ln_MntSoli    in number,
                          lc_prod       in varchar2,
                          ln_nropol     in number,
                          ld_fori       in date,
                          lc_hori       in character,
                          lc_aut        in varchar2,
                          ld_faut       in date,
                          lc_haut       in character,
                          lc_rpta       in varchar2,
                          lc_com        in varchar2);

end PQ_CR_MANTENIMIENTO_AUTONOMIA;
/
create or replace package body PQ_CR_MANTENIMIENTO_AUTONOMIA is

  procedure sp_cr_Inicio(lc_UsuLogin in varchar2,
                         lc_UsuUpdt  in varchar2,
                         lc_TipoUpdt in varchar2,
                         ld_FecPro   in date,
                         lc_Rpta     out varchar2) is
  
    ln_055emp  number;
    lc_057usr  character(10);
    ln_055car  number;
    lc_057aut  character(1);
    lc_057sup  character(10);
    ld_057ini  date;
    ld_057fin  date;
    lc_057jef  character(10);
    lc_057wkf  character(1);
    ln_057prc  number;
    ln_057tsk  number;
    lc_ExstReg number := 0;
  
  begin
  
    begin
      select count(*)
        into lc_ExstReg
        from sng057 s
       where trim(s.sng057usr) = lc_UsuUpdt
         and trim(s.sng057aut) = lc_TipoUpdt;
    exception
      when others then
        lc_ExstReg := 0;
    end;
  
    if lc_ExstReg = 0 then
      --Log antes del Cambio
      begin
        select s.sng055emp,
               s.sng057usr,
               s.sng055car,
               s.sng057aut,
               s.sng057sup,
               s.sng057ini,
               s.sng057fin,
               s.sng057jef,
               s.sng057wkf,
               s.sng057prc,
               s.sng057tsk
          into ln_055emp,
               lc_057usr,
               ln_055car,
               lc_057aut,
               lc_057sup,
               ld_057ini,
               ld_057fin,
               lc_057jef,
               lc_057wkf,
               ln_057prc,
               ln_057tsk
          from sng057 s
         where trim(s.sng057usr) = lc_UsuUpdt;
      exception
        when others then
          null;
      end;
    
      if ln_055emp is not null then
        begin
          pq_cr_mantenimiento_autonomia.sp_cr_LogSNG057(ld_fec   => ld_FecPro,
                                                        lc_userl => lc_UsuLogin,
                                                        lc_useru => lc_UsuUpdt,
                                                        ln_emp   => ln_055emp,
                                                        lc_usr   => lc_057usr,
                                                        ln_car   => ln_055car,
                                                        lc_aut   => lc_057aut,
                                                        lc_sup   => lc_057sup,
                                                        ld_ini   => ld_057ini,
                                                        ld_fin   => ld_057fin,
                                                        lc_jef   => lc_057jef,
                                                        lc_wkf   => lc_057wkf,
                                                        ln_prc   => ln_057prc,
                                                        ln_tsk   => ln_057tsk);
        end;
      
        begin
          update sng057 s
             set s.sng057aut = lc_TipoUpdt
           where trim(s.sng057usr) = lc_UsuUpdt;
          commit;
        end;
        lc_Rpta := 'A'; -- Registro Actualizado
      else
        lc_Rpta := 'X'; -- No Existe el Usuario
      end if;
    else
      if lc_ExstReg > 0 then
      
        if lc_TipoUpdt = 'S' then
          lc_Rpta := 'S'; -- El usuario ya esta habilitado
        else
          if lc_TipoUpdt = 'N' then
            lc_Rpta := 'N'; -- El usuario no esta habilitado
          end if;
        end if;
      end if;
    end if;
  
  end sp_cr_Inicio;
  ----------------------------------------------
  procedure sp_cr_LogSNG057(ld_fec   in date,
                            lc_userl in varchar2,
                            lc_useru in varchar2,
                            ln_emp   in number,
                            lc_usr   in character,
                            ln_car   in number,
                            lc_aut   in character,
                            lc_sup   in character,
                            ld_ini   in date,
                            ld_fin   in date,
                            lc_jef   in character,
                            lc_wkf   in character,
                            ln_prc   in number,
                            ln_tsk   in number) is
  
    lc_est  varchar2(2) := 'H';
    ln_corr number := 0;
    lc_hora character(8) := '00:00:00';
  
  begin
  
    begin
      update aqpa369 a
         set a.aqpa369est = 'I'
       where a.aqpa369useru = lc_useru;
    end;
  
    begin
      select max(a.aqpa369corr)
        into ln_corr
        from aqpa369 a
       where a.aqpa369fec = ld_fec
         and a.aqpa369userl = lc_userl
         and a.aqpa369useru = lc_useru;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa369
        (aqpa369corr,
         aqpa369fec,
         aqpa369hora,
         aqpa369userl,
         aqpa369useru,
         aqpa369emp,
         aqpa369usr,
         aqpa369car,
         aqpa369aut,
         aqpa369sup,
         aqpa369ini,
         aqpa369fin,
         aqpa369jef,
         aqpa369wkf,
         aqpa369prc,
         aqpa369tsk,
         aqpa369est)
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         lc_userl,
         lc_useru,
         ln_emp,
         lc_usr,
         ln_car,
         lc_aut,
         lc_sup,
         ld_ini,
         ld_fin,
         lc_jef,
         lc_wkf,
         ln_prc,
         ln_tsk,
         lc_est);
      commit;
    end;
  
  end sp_cr_LogSNG057;
  ---------------------------------------------------------  
  procedure sp_cr_InicioReporte(lc_Usuario in varchar2,
                                ld_FecPro  in date,
                                ld_fchIni  in date,
                                ld_fchFin  in date,
                                lc_Tipo    in varchar2) is
  
    cursor lista_todos is
      select s.sng001inst Instancia,
             s.sng091num Nro_Politica,
             to_date(d.sng060now, 'DD/MM/YY') Fch_Originacion,
             to_char(d.sng060now, 'HH24:MI:SS') hra_Orign,
             g.sng065usr Autorizante,
             to_date(g.sng065now, 'DD/MM/YY') Fch_Autorizacion,
             to_char(g.sng065now, 'HH24:MI:SS') hra_Autoriza,
             case
               when g.sng065res = 'A' THEN
                'Aprobado'
               when g.sng065res = 'R' then
                'Rechazado'
               when g.sng065res = 'P' then
                'Pendiente'
             end Respuesta,
             g.sng065com Comentario
        from sng091 s, sng060 d, sng065 g
       where s.sng090pqt = d.sng060pqt
         and s.sng091aut = g.sng062aut
         and s.sng091num in (select f.tp1nro3
                               from FST198 F
                              WHERE f.tp1cod = 1
                                and f.tp1cod1 = 10899
                                and f.tp1corr1 = 650
                                and f.tp1corr2 = 1
                                and f.tp1corr3 > 0)
         and d.sng060fap between ld_fchIni and ld_fchFin;
  
    cursor lista_filtro is
      select s.sng001inst Instancia,
             s.sng091num Nro_Politica,
             to_date(d.sng060now, 'DD/MM/YY') Fch_Originacion,
             to_char(d.sng060now, 'HH24:MI:SS') hra_Orign,
             g.sng065usr Autorizante,
             to_date(g.sng065now, 'DD/MM/YY') Fch_Autorizacion,
             to_char(g.sng065now, 'HH24:MI:SS') hra_Autoriza,
             case
               when g.sng065res = 'A' THEN
                'Aprobado'
               when g.sng065res = 'R' then
                'Rechazado'
               when g.sng065res = 'P' then
                'Pendiente'
             end Respuesta,
             g.sng065com Comentario
        from sng091 s, sng060 d, sng065 g
       where s.sng090pqt = d.sng060pqt
         and s.sng091aut = g.sng062aut
         and s.sng091num in (select f.tp1nro3
                               from FST198 F
                              WHERE f.tp1cod = 1
                                and f.tp1cod1 = 10899
                                and f.tp1corr1 = 650
                                and f.tp1corr2 = 1
                                and f.tp1corr3 > 0)
         and d.sng060fap between ld_fchIni and ld_fchFin
         and g.sng065res = lc_Tipo;
  
    ln_pgcod      number;
    ln_suc        number;
    ln_mod        number;
    ln_mda        number;
    ln_pap        number;
    ln_cta        number;
    ln_ope        number;
    ln_sbop       number;
    ln_tope       number;
    lc_NombClien  varchar2(150);
    lc_NombAge    varchar2(35);
    lc_Analista   varchar2(10);
    lc_NomTipProd varchar2(35);
    ln_MntSolic   number(17, 2);
    ln_tdoc       number := 0;
  
  begin
  
    begin
      delete aqpa370 a where a.aqpa370user = lc_Usuario;
      commit;
    end;
  
    if lc_Tipo = 'T' then
      for t in lista_todos loop
      
        ln_pgcod      := 0;
        ln_suc        := 0;
        ln_mod        := 0;
        ln_mda        := 0;
        ln_pap        := 0;
        ln_cta        := 0;
        ln_ope        := 0;
        ln_sbop       := 0;
        ln_tope       := 0;
        ln_MntSolic   := 0.00;
        lc_NombClien  := null;
        lc_NombAge    := null;
        lc_NomTipProd := null;
        lc_Analista   := null;
      
        begin
          select x.xwfempresa,
                 x.xwfsucursal,
                 x.xwfmodulo,
                 x.xwfmoneda,
                 x.xwfpapel,
                 x.xwfcuenta,
                 x.xwfoperacion,
                 x.xwfsubope,
                 x.xwftipope
            into ln_pgcod,
                 ln_suc,
                 ln_mod,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbop,
                 ln_tope
            from xwf700 x
           where x.xwfprcins = t.instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        if ln_pgcod = 0 then
        
          begin
            select x.xwfempresa,
                   x.xwfsucursal,
                   x.xwfmodulo,
                   x.xwfmoneda,
                   x.xwfpapel,
                   x.xwfcuenta,
                   x.xwfoperacion,
                   x.xwfsubope,
                   x.xwftipope
              into ln_pgcod,
                   ln_suc,
                   ln_mod,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbop,
                   ln_tope
              from xwf700 x
             where x.xwfprcins = t.instancia
               and x.xwfsubope =
                   (select max(x.xwfsubope)
                      from xwf700 x
                     where x.xwfprcins = t.instancia);
          exception
            when others then
              null;
          end;
        
        end if;
      
        begin
          select x.xllcapital
            into ln_MntSolic
            from x054023 x
           where x.xllpgcod = ln_pgcod
             and x.xllaomod = ln_mod
             and x.xllaosuc = ln_suc
             and x.xllaomda = ln_mda
             and x.xllaopap = ln_pap
             and x.xllaocta = ln_cta
             and x.xllaooper = ln_ope
             and x.xllaosbop = ln_sbop
             and x.xllaotop = ln_tope;
        exception
          when others then
            null;
          
        end;
      
        begin
          select s.sng001tdoc
            into ln_tdoc
            from sng001 s
           where s.sng001inst = t.instancia;
        exception
          when others then
            ln_tdoc := 0;
        end;
      
        if ln_tdoc = 9 then
          begin
            select trim(f.pjrazs)
              into lc_NombClien
              from sng001 s, fsd003 f
             where s.sng001inst = t.instancia
               and s.sng001pais = f.pjpais
               and s.sng001tdoc = f.pjtdoc
               and s.sng001ndoc = f.pjndoc;
          exception
            when others then
              null;
          end;
        
        else
          begin
            select trim(f.pfnom1) || ' ' || trim(f.pfnom2) || ' ' ||
                   trim(f.pfape1) || ' ' || trim(f.pfape2)
              into lc_NombClien
              from sng001 s, fsd002 f
             where s.sng001inst = t.instancia
               and s.sng001pais = f.pfpais
               and s.sng001tdoc = f.pftdoc
               and s.sng001ndoc = f.pfndoc;
          exception
            when others then
              null;
          end;
        end if;
      
        begin
          select f.scnom
            into lc_NombAge
            from fst001 f
           where f.pgcod = 1
             and f.sucurs = ln_suc;
        exception
          when others then
            null;
        end;
      
        begin
          select f.tonom
            into lc_NomTipProd
            from fst004 f
           where f.modulo = ln_mod
             and f.totope = ln_tope;
        exception
          when others then
            null;
        end;
      
        begin
          lc_Analista := fn_analista_credito(v_Scmod  => ln_mod,
                                             v_Scsuc  => ln_suc,
                                             v_Scmda  => ln_mda,
                                             v_Scpap  => ln_pap,
                                             v_Sccta  => ln_cta,
                                             v_Scoper => ln_ope,
                                             v_Scsbop => ln_sbop,
                                             v_Sctope => ln_tope);
        end;
      
        pq_cr_mantenimiento_autonomia.sp_cr_reporte(ld_fec        => ld_FecPro,
                                                    lc_user       => lc_Usuario,
                                                    ln_inst       => t.instancia,
                                                    ln_pgcod      => ln_pgcod,
                                                    ln_mod        => ln_mod,
                                                    ln_suc        => ln_suc,
                                                    ln_cta        => ln_cta,
                                                    ln_ope        => ln_ope,
                                                    ln_sbop       => ln_sbop,
                                                    ln_top        => ln_tope,
                                                    lc_NombCli    => lc_NombClien,
                                                    lc_NombAge    => lc_NombAge,
                                                    lc_AnalisCred => lc_Analista,
                                                    ln_MntSoli    => ln_MntSolic,
                                                    lc_prod       => lc_NomTipProd,
                                                    ln_nropol     => t.nro_politica,
                                                    ld_fori       => t.fch_originacion,
                                                    lc_hori       => t.hra_orign,
                                                    lc_aut        => t.autorizante,
                                                    ld_faut       => t.fch_autorizacion,
                                                    lc_haut       => t.hra_autoriza,
                                                    lc_rpta       => t.respuesta,
                                                    lc_com        => t.comentario);
      
      end loop;
      commit;
    
    else
      if lc_Tipo = 'A' or lc_Tipo = 'R' or lc_Tipo = 'P' then
      
        for f in lista_filtro loop
          ln_pgcod      := 0;
          ln_suc        := 0;
          ln_mod        := 0;
          ln_mda        := 0;
          ln_pap        := 0;
          ln_cta        := 0;
          ln_ope        := 0;
          ln_sbop       := 0;
          ln_tope       := 0;
          ln_MntSolic   := 0.00;
          lc_NombClien  := null;
          lc_NombAge    := null;
          lc_NomTipProd := null;
          lc_Analista   := null;
        
          begin
            select x.xwfempresa,
                   x.xwfsucursal,
                   x.xwfmodulo,
                   x.xwfmoneda,
                   x.xwfpapel,
                   x.xwfcuenta,
                   x.xwfoperacion,
                   x.xwfsubope,
                   x.xwftipope
              into ln_pgcod,
                   ln_suc,
                   ln_mod,
                   ln_mda,
                   ln_pap,
                   ln_cta,
                   ln_ope,
                   ln_sbop,
                   ln_tope
              from xwf700 x
             where x.xwfprcins = f.instancia
               and x.xwfcar3 = '1';
          exception
            when others then
              null;
          end;
        
          if ln_pgcod = 0 then
          
            begin
              select x.xwfempresa,
                     x.xwfsucursal,
                     x.xwfmodulo,
                     x.xwfmoneda,
                     x.xwfpapel,
                     x.xwfcuenta,
                     x.xwfoperacion,
                     x.xwfsubope,
                     x.xwftipope
                into ln_pgcod,
                     ln_suc,
                     ln_mod,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbop,
                     ln_tope
                from xwf700 x
               where x.xwfprcins = f.instancia
                 and x.xwfsubope =
                     (select max(x.xwfsubope)
                        from xwf700 x
                       where x.xwfprcins = f.instancia);
            exception
              when others then
                null;
            end;
          
          end if;
        
          begin
            select x.xllcapital
              into ln_MntSolic
              from x054023 x
             where x.xllpgcod = ln_pgcod
               and x.xllaomod = ln_mod
               and x.xllaosuc = ln_suc
               and x.xllaomda = ln_mda
               and x.xllaopap = ln_pap
               and x.xllaocta = ln_cta
               and x.xllaooper = ln_ope
               and x.xllaosbop = ln_sbop
               and x.xllaotop = ln_tope;
          exception
            when others then
              null;
          end;
        
          begin
            select s.sng001tdoc
              into ln_tdoc
              from sng001 s
             where s.sng001inst = f.instancia;
          exception
            when others then
              ln_tdoc := 0;
          end;
        
          if ln_tdoc = 9 then
            begin
              select trim(f.pjrazs)
                into lc_NombClien
                from sng001 s, fsd003 f
               where s.sng001inst = f.instancia
                 and s.sng001pais = f.pjpais
                 and s.sng001tdoc = f.pjtdoc
                 and s.sng001ndoc = f.pjndoc;
            exception
              when others then
                null;
            end;
          
          else
            begin
              select trim(f.pfnom1) || ' ' || trim(f.pfnom2) || ' ' ||
                     trim(f.pfape1) || ' ' || trim(f.pfape2)
                into lc_NombClien
                from sng001 s, fsd002 f
               where s.sng001inst = f.instancia
                 and s.sng001pais = f.pfpais
                 and s.sng001tdoc = f.pftdoc
                 and s.sng001ndoc = f.pfndoc;
            exception
              when others then
                null;
            end;
          end if;
        
          begin
            select f.scnom
              into lc_NombAge
              from fst001 f
             where f.pgcod = 1
               and f.sucurs = ln_suc;
          exception
            when others then
              null;
          end;
        
          begin
            select f.tonom
              into lc_NomTipProd
              from fst004 f
             where f.modulo = ln_mod
               and f.totope = ln_tope;
          exception
            when others then
              null;
          end;
        
          begin
            lc_Analista := fn_analista_credito(v_Scmod  => ln_mod,
                                               v_Scsuc  => ln_suc,
                                               v_Scmda  => ln_mda,
                                               v_Scpap  => ln_pap,
                                               v_Sccta  => ln_cta,
                                               v_Scoper => ln_ope,
                                               v_Scsbop => ln_sbop,
                                               v_Sctope => ln_tope);
          end;
        
          pq_cr_mantenimiento_autonomia.sp_cr_reporte(ld_fec        => ld_FecPro,
                                                      lc_user       => lc_Usuario,
                                                      ln_inst       => f.instancia,
                                                      ln_pgcod      => ln_pgcod,
                                                      ln_mod        => ln_mod,
                                                      ln_suc        => ln_suc,
                                                      ln_cta        => ln_cta,
                                                      ln_ope        => ln_ope,
                                                      ln_sbop       => ln_sbop,
                                                      ln_top        => ln_tope,
                                                      lc_NombCli    => lc_NombClien,
                                                      lc_NombAge    => lc_NombAge,
                                                      lc_AnalisCred => lc_Analista,
                                                      ln_MntSoli    => ln_MntSolic,
                                                      lc_prod       => lc_NomTipProd,
                                                      ln_nropol     => f.nro_politica,
                                                      ld_fori       => f.fch_originacion,
                                                      lc_hori       => f.hra_orign,
                                                      lc_aut        => f.autorizante,
                                                      ld_faut       => f.fch_autorizacion,
                                                      lc_haut       => f.hra_autoriza,
                                                      lc_rpta       => f.respuesta,
                                                      lc_com        => f.comentario);
        
        end loop;
        commit;
      
      end if;
    end if;
  
  end sp_cr_InicioReporte;
  ------------------------------------------------------
  procedure sp_cr_reporte(ld_fec        in date,
                          lc_user       in varchar2,
                          ln_inst       in number,
                          ln_pgcod      in number,
                          ln_mod        in number,
                          ln_suc        in number,
                          ln_cta        in number,
                          ln_ope        in number,
                          ln_sbop       in number,
                          ln_top        in number,
                          lc_NombCli    in varchar2,
                          lc_NombAge    in varchar2,
                          lc_AnalisCred in varchar2,
                          ln_MntSoli    in number,
                          lc_prod       in varchar2,
                          ln_nropol     in number,
                          ld_fori       in date,
                          lc_hori       in character,
                          lc_aut        in varchar2,
                          ld_faut       in date,
                          lc_haut       in character,
                          lc_rpta       in varchar2,
                          lc_com        in varchar2) is
  
    -- ln_corr number := 0;
    lc_hora character(8) := '00:00:00';
    Region  varchar(40);
    Zona    varchar(40);
  
  begin
    /* begin
      select max(a.aqpa370corr)
        into ln_corr
        from aqpa370 a
       where a.aqpa370fec = ld_fec
         and a.aqpa370user = lc_user;
    exception
      when others then
        ln_corr := 0;
    end;
    
    ln_corr := nvl(ln_corr, 0);*/
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
    --------------------------------------------------
    Begin
      select upper(r.regnom), upper(r.deszon)
        into Region, Zona
        from regsuc r
       where r.sucurs = ln_suc;
    exception
      when no_data_found then
        Region := 'Desconoce';
        Zona   := 'Desconoce';
    end;
    ---------------------------------------------------
    begin
      insert into aqpa370
        (aqpa370corr,
         aqpa370fec,
         aqpa370hora,
         aqpa370user,
         aqpa370inst,
         aqpa370pgcod,
         aqpa370mod,
         aqpa370suc,
         aqpa370cta,
         aqpa370ope,
         aqpa370sbop,
         aqpa370top,
         aqpa370nomb,
         aqpa370age,
         aqpa370anlst,
         aqpa370mnt,
         aqpa370prod,
         aqpa370nropol,
         aqpa370fori,
         aqpa370hori,
         aqpa370aut,
         aqpa370faut,
         aqpa370haut,
         aqpa370rpta,
         aqpa370com,
         aqpa370vaux2,
         aqpa370vaux3)
      
      values
        (SQ_CR_AQPA370.NEXTVAL,
         ld_fec,
         lc_hora,
         lc_user,
         ln_inst,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_top,
         lc_NombCli,
         lc_NombAge,
         lc_AnalisCred,
         ln_MntSoli,
         lc_prod,
         ln_nropol,
         ld_fori,
         lc_hori,
         lc_aut,
         ld_faut,
         lc_haut,
         lc_rpta,
         lc_com,
         region,
         zona);
    end;
    commit;
  
  end sp_Cr_reporte;

end PQ_CR_MANTENIMIENTO_AUTONOMIA;
/
