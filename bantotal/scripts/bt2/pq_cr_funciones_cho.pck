create or replace package pq_cr_funciones_cho is
  /* ************************************************************************************************************
          -- Nombre                     : pq_cr_funciones_cho
          -- Sistema                    : BANTOTAL
          -- Módulo                     : Creditos
          -- Descripción                : paquete para reprogramaciones 
          -- Author  : CHERNANDEZ
          -- Created : 13/06/2020
          -- Purpose : Contador de autorizaciones gerente de agencia politica 12
          -- MODIFCADO :
          -- Author  : CHERNANDEZ
          -- Created : 19/06/2020
          -- Purpose : Contador de autorizaciones gerente regional politica varia
          -- MODIFCADO :
          -- Author  : CHERNANDEZ
          -- Created : 26/06/2020
          -- Purpose : Procedimiento que obtiene tasa de tabla aqpa970
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 14/11/2020
          -- Purpose : Procedimiento que obtiene tasa de reprogramados por reprogramacion caja
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 03/12/2020
          -- Purpose : Procedimiento que obtiene tasa de reprogramados por reprogramacion gobierno
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 22/12/2020
          -- Purpose : Procedimiento que osp_obtener_IdLEY
          -- Author  : DCASTRO
          -- Created : 25/02/2021
          -- Purpose : Procedimiento que valida CRM - CAJA
          -- Author  : DCASTRO
          -- Created : 18/03/2021
          -- Purpose : sp_existe_CRM_Caja
          -- Author  : DCASTRO 23/04/2021 se inicializo variable  
          -- Created : 06/09/2021
          -- Purpose : sp_obtener_tasaGob
          -- Author  : DCASTRO 23/04/2021 se inicializo variable  
          -- Modificado : sp_obtener_TASAREFI
          --            : DCASTRO 2024/01/19 sp_obtener_TASAREFI
          --            : DCASTRO 2024/01/19 sp_obtener_tasaRepro
          -- Modificado : sp_Tipos_CRM - se modifico el procedimiento de CRM para aceptar los sin CRM
          --            : DCASTRO - 2024.09.04 se modifico sp_Tipos_CRM 
          --            ; DCASTRO - 2024.10.18 se agregó procedimiento sp_obtener_TASACREDINKA
          --            : DCASTRO - 2024.10.25 se modifico procedimiento sp_obtener_TASACREDINKA para exceptuar retorno de tasa
          --            : DCASTRO - 2024.10.29 se modifico procedimiento sp_obtener_TASACREDINKA, sp_cr_tasaRepro 
  /***********************************************************************************************/

  procedure sp_cont_autoriz_agencia(pn_inst   number,
                                    pn_pgfape date,
                                    pn_cont   out number);
  procedure sp_cont_autoriz_regional(pn_inst   number,
                                     pn_pgfape date,
                                     pn_cont   out number);
  procedure obtener_InicioMes(pd_pgfape    date,
                              pn_autmes    out number,
                              pn_autmesant out number);
  procedure sp_cont_autoriz_agencia_poli(pn_inst   number,
                                         pn_pgfape date,
                                         pn_politi number,
                                         pn_cont   out number);
  procedure sp_cont_autoriz_regional_poli(pn_inst   number,
                                          pn_pgfape date,
                                          pn_politi number,
                                          pn_cont   out number);
  procedure sp_obtener_tasaRepro(pn_emp  in number,
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 pn_tasa out number);

  procedure sp_obtener_tasaRepro_Caja(pn_emp  in number,
                                      pn_mod  in number,
                                      pn_suc  in number,
                                      pn_mda  in number,
                                      pn_pap  in number,
                                      pn_cta  in number,
                                      pn_ope  in number,
                                      pn_sbo  in number,
                                      pn_top  in number,
                                      pn_tasa out number);

  function fn_obtener_tasaRepro_Caja(pn_emp in number,
                                     pn_mod in number,
                                     pn_suc in number,
                                     pn_mda in number,
                                     pn_pap in number,
                                     pn_cta in number,
                                     pn_ope in number,
                                     pn_sbo in number,
                                     pn_top in number) return varchar2;
  ----------------------------------------
  procedure sp_obtener_IdLey(pn_emp   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_idley out number);

  function fn_obtener_tasaRepro_Actual(pn_emp in number,
                                       pn_mod in number,
                                       pn_suc in number,
                                       pn_mda in number,
                                       pn_pap in number,
                                       pn_cta in number,
                                       pn_ope in number,
                                       pn_sbo in number,
                                       pn_top in number) return number;

  procedure sp_es_reprogramado(pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pv_rpta out varchar2);
  --------------------------------------------                               
  procedure sp_obtener_tasaGob(pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pn_tasa out number,
                               pn_ttas out number);
  --------------------------------------------
  procedure sp_obtener_tasaRepro_Gob(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_tasa out number);

  procedure sp_Tipo_Repro(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pc_tip out varchar2,
                          pn_tas out number);
  --------------------------------------------
  procedure sp_indicador_CRM_Caja(pn_instancia in number,
                                  pc_ind       out varchar2);

  procedure sp_existe_CRM_Caja(pn_instancia in number, pc_ind out varchar2);

  procedure sp_obtener_tasaRepro_Act(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_tasa out number);

  procedure sp_Repro_COVID(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_ind out varchar2);

  procedure sp_fecha_COVID(pn_instancia in number, pc_ind out varchar2);

  procedure sp_unilateral(pn_instancia in number, pc_ind out varchar2);

  procedure sp_obtener_tasaFondo(pn_emp  in number,
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 pn_tasa out number,
                                 pn_ttas out number);

  procedure sp_Tipos_CRM(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pc_ind out varchar2);
  --------------------------------------------------------------------------------
  procedure sp_Plazo_Caja(pn_instancia in number, pn_plazo out number);
  --------------------------------------------------------------------------------
  procedure sp_gestion_FONDO(pn_instancia in number, pn_perfil out number);
  --------------------------------------------------------------------------------
  procedure sp_REPROGRAMA_FONDO(pn_instancia in number, pn_tipo out number);

  --------------------------------------------------------------------------------
  procedure sp_obtener_TASAREFI(pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                pn_tasa out number);
  -----------------------------------------------------------------------------  
 procedure sp_obtener_TASACREDINKA(pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    pn_tasa out number) ;
 ----------------------------------------------------------
  procedure sp_retorna_Tasa(        pn_instancia in number,
                                    pn_cuenta  in number,
                                    pc_indicador out varchar2) ;
-------------------------------------------------------------------------------                                    
-------------------------------------------------------------------
end pq_cr_funciones_cho;
/

create or replace package body pq_cr_funciones_cho is
  /* ************************************************************************************************************
          -- Nombre                     : pq_cr_funciones_cho
          -- Sistema                    : BANTOTAL
          -- Módulo                     : Creditos
          -- Descripción                : paquete para reprogramaciones 
          -- Author  : CHERNANDEZ
          -- Created : 13/06/2020
          -- Purpose : Contador de autorizaciones gerente de agencia politica 12
          -- MODIFCADO :
          -- Author  : CHERNANDEZ
          -- Created : 19/06/2020
          -- Purpose : Contador de autorizaciones gerente regional politica varia
          -- MODIFCADO :
          -- Author  : CHERNANDEZ
          -- Created : 26/06/2020
          -- Purpose : Procedimiento que obtiene tasa de tabla aqpa970
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 14/11/2020
          -- Purpose : Procedimiento que obtiene tasa de reprogramados por reprogramacion caja
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 03/12/2020
          -- Purpose : Procedimiento que obtiene tasa de reprogramados por reprogramacion gobierno
          -- MODIFCADO :
          -- Author  : DCASTRO
          -- Created : 22/12/2020
          -- Purpose : Procedimiento que osp_obtener_IdLEY
          -- Author  : DCASTRO
          -- Created : 25/02/2021
          -- Purpose : Procedimiento que valida CRM - CAJA
          -- Author  : DCASTRO
          -- Created : 18/03/2021
          -- Purpose : sp_existe_CRM_Caja
          -- Author  : DCASTRO 23/04/2021 se inicializo variable  
          -- Created : 06/09/2021
          -- Purpose : sp_obtener_tasaGob
          -- Author  : DCASTRO 23/04/2021 se inicializo variable  
          -- Modificado : sp_obtener_TASAREFI
          --            : DCASTRO 2024/01/19 sp_obtener_TASAREFI
          --            : DCASTRO 2024/01/19 sp_obtener_tasaRepro
          -- Modificado : DCASTRO 2024/09/04 sp_Tipos_CRM - se modifico el procedimiento de CRM para aceptar los sin CRM
  /***********************************************************************************************/
  procedure sp_cont_autoriz_agencia(pn_inst   number,
                                    pn_pgfape date,
                                    pn_cont   out number) is
    ln_contador  number(5);
    ln_agencia   number(5);
    ld_fec       date;
    ld_fecfin    date;
    ln_autmes    number(10);
    ln_autmesant number(10);
  begin
    ln_contador := 0;
    begin
      pq_cr_funciones_cho.obtener_InicioMes(pn_pgfape,
                                            ln_autmes,
                                            ln_autmesant);
    end;
  
    begin
      select TRUNC(pn_pgfape, 'MM'), TRUNC(last_day(pn_pgfape))
        into ld_fec, ld_fecfin
        from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select sng001age
        into ln_agencia
        from sng001
       where sng001inst = pn_inst;
    exception
      when others then
        null;
    end;
  
    begin
      select nvl(count(*), 0)
        into ln_contador
        from (select *
                from sng065 a, sng091 b
               where a.sng062aut = b.sng091aut
                 and a.sng065est = 'F' --estado finalizado
                 and a.sng065res = 'A' --respuesta autorizado
                 and b.sng091tpo = 'P' --politica
                 and b.sng091num = 12 --138 --numero politica
                 and a.sng065car = 202 --cargo
                 and a.sng065suc = ln_agencia
                 and sng065fap >= ld_fec
                 and sng065fap <= ld_fecfin
                 and sng062aut >= ln_autmes
                 and sng091aut >= ln_autmes
              union all
              select *
                from sng065 a, sng091 b
               where a.sng062aut = b.sng091aut
                 and a.sng065est in ('P', 'A') --estado
                 and a.sng065res = 'P' --respuesta pendiente
                 and b.sng091tpo = 'P' --politica
                 and b.sng091num = 12 --138 --numero politica
                 and a.sng065car = 202 --cargo
                 and a.sng065suc = ln_agencia
                 and sng062aut >= ln_autmesant);
    exception
      when others then
        null;
    end;
  
    pn_cont := ln_contador;
  
  end sp_cont_autoriz_agencia;

  -- Author  : CHERNANDEZ
  -- Created : 13/06/2020
  -- Purpose : Contador de autorizaciones gerente regional politica 12
  -- MODIFCADO :
  procedure sp_cont_autoriz_regional(pn_inst   number,
                                     pn_pgfape date,
                                     pn_cont   out number) is
    ln_contador  number(5);
    ln_agencia   number(5);
    ld_fec       date;
    ld_fecfin    date;
    ln_autmes    number(10);
    ln_autmesant number(10);
  begin
    ln_contador := 0;
    begin
      pq_cr_funciones_cho.obtener_InicioMes(pn_pgfape,
                                            ln_autmes,
                                            ln_autmesant);
    
      begin
        select TRUNC(pn_pgfape, 'MM'), TRUNC(last_day(pn_pgfape))
          into ld_fec, ld_fecfin
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
        select sng001age
          into ln_agencia
          from sng001
         where sng001inst = pn_inst;
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(count(*), 0)
          into ln_contador
          from (select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est = 'F' --estado finalizado
                   and a.sng065res = 'A' --respuesta autorizado
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = 12 --121 --numero politica
                   and a.sng065car = 220 --cargo
                   and a.sng065suc in
                       (select oficod
                          from fst811
                         where regcod = (select regcod
                                           from fst811
                                          where pgcod = 1
                                            and oficod = ln_agencia
                                            and regcod < 100
                                            and rownum = 1))
                      
                   and sng065fap >= ld_fec
                   and sng065fap <= ld_fecfin
                   and sng062aut >= ln_autmes
                   and sng091aut >= ln_autmes
                union all
                select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est in ('P', 'A') --estado
                   and a.sng065res = 'P' --respuesta pendiente
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = 12 --121 --numero politica
                   and a.sng065car = 220 --cargo
                   and a.sng065suc in
                       (select oficod
                          from fst811
                         where regcod = (select regcod
                                           from fst811
                                          where pgcod = 1
                                            and oficod = ln_agencia
                                            and regcod < 100
                                            and rownum = 1))
                   and sng062aut >= ln_autmesant
                
                );
      
      exception
        when others then
          null;
      end;
    
    end;
    pn_cont := ln_contador;
  end sp_cont_autoriz_regional;

  procedure obtener_InicioMes(pd_pgfape    date,
                              pn_autmes    out number,
                              pn_autmesant out number) is
    ln_mes     number(3);
    ln_anio    number(4);
    ln_mesAnt  number(3);
    ln_anioAnt number(4);
    ld_fecha   date;
    ln_auto    number(10);
    ln_paquete number(10);
    ld_fecant  date;
  
  begin
    begin
      ld_fecant := add_months(pd_pgfape, -1);
    
      begin
        select extract(month from pd_pgfape),
               extract(year from pd_pgfape),
               extract(month from ld_fecant),
               extract(year from ld_fecant)
          into ln_mes, ln_anio, ln_mesAnt, ln_anioAnt
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
        select tp1nro3, tp1nro3
          into pn_autmes, pn_autmesant
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11105
           and tp1corr1 = 38
           and tp1corr2 = 1
           and tp1nro1 = ln_mes
           and tp1nro2 = ln_anio;
      exception
        when others then
          null;
      end;
    
      begin
        select tp1nro3
          into pn_autmesant
          from fst198
         where tp1cod = 1
           and tp1cod1 = 11105
           and tp1corr1 = 38
           and tp1corr2 = 1
           and tp1nro1 = ln_mesAnt
           and tp1nro2 = ln_anioAnt;
      exception
        when others then
          null;
      end;
    exception
      when others then
        ld_fecha := to_date('01' || '/' || lpad(ln_mes, 2, '0') || '/' ||
                            ln_anio,
                            'dd/mm/yyyy');
      
        begin
          select min(sng060pqt)
            into ln_paquete
            from sng060
           where sng060fap >= ld_fecha; --4515030
        exception
          when others then
            null;
        end;
      
        begin
          select sng091aut
            into ln_auto
            from sng091
           where sng090pqt = ln_paquete; --4577682
        exception
          when others then
            null;
        end;
      
        begin
          insert into fst198
            (tp1cod,
             tp1cod1,
             tp1corr1,
             tp1corr2,
             tp1corr3,
             tp1nro1,
             tp1nro2,
             tp1nro3,
             tp1imp1)
          values
            (1,
             11105,
             38,
             1,
             (select nvl(max(tp1corr3), 0) + 1
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 11105
                 and tp1corr1 = 38
                 and tp1corr2 = 1),
             ln_mes,
             ln_anio,
             ln_auto,
             ln_paquete);
          commit;
        exception
          when others then
            null;
        end;
    end;
  end obtener_InicioMes;

  procedure sp_cont_autoriz_agencia_poli(pn_inst   number,
                                         pn_pgfape date,
                                         pn_politi number,
                                         pn_cont   out number) is
    ln_contador  number(5);
    ln_agencia   number(5);
    ld_fec       date;
    ld_fecfin    date;
    ln_autmes    number(10);
    ln_autmesant number(10);
  begin
    ln_contador := 0;
    begin
      pq_cr_funciones_cho.obtener_InicioMes(pn_pgfape,
                                            ln_autmes,
                                            ln_autmesant);
    
      begin
        select TRUNC(pn_pgfape, 'MM'), TRUNC(last_day(pn_pgfape))
          into ld_fec, ld_fecfin
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
      
        select sng001age
          into ln_agencia
          from sng001
         where sng001inst = pn_inst;
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(count(*), 0)
          into ln_contador
          from (select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est = 'F' --estado finalizado
                   and a.sng065res = 'A' --respuesta autorizado
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = pn_politi --138 --numero politica
                   and a.sng065car = 202 --cargo
                   and a.sng065suc = ln_agencia
                   and sng065fap >= ld_fec
                   and sng065fap <= ld_fecfin
                   and sng062aut >= ln_autmes
                   and sng091aut >= ln_autmes
                union all
                select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est in ('P', 'A') --estado
                   and a.sng065res = 'P' --respuesta pendiente
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = pn_politi --138 --numero politica
                   and a.sng065car = 202 --cargo
                   and a.sng065suc = ln_agencia
                   and sng062aut >= ln_autmesant);
      exception
        when others then
          null;
      end;
    
    end;
    pn_cont := ln_contador;
  end sp_cont_autoriz_agencia_poli;

  -- Author  : CHERNANDEZ
  -- Created : 19/06/2020
  -- Purpose : Contador de autorizaciones gerente regional politica
  -- MODIFCADO :
  procedure sp_cont_autoriz_regional_poli(pn_inst   number,
                                          pn_pgfape date,
                                          pn_politi number,
                                          pn_cont   out number) is
    ln_contador  number(5);
    ln_agencia   number(5);
    ld_fec       date;
    ld_fecfin    date;
    ln_autmes    number(10);
    ln_autmesant number(10);
  begin
    ln_contador := 0;
    begin
      pq_cr_funciones_cho.obtener_InicioMes(pn_pgfape,
                                            ln_autmes,
                                            ln_autmesant);
    
      begin
        select TRUNC(pn_pgfape, 'MM'), TRUNC(last_day(pn_pgfape))
          into ld_fec, ld_fecfin
          from dual;
      exception
        when others then
          null;
      end;
    
      begin
        select sng001age
          into ln_agencia
          from sng001
         where sng001inst = pn_inst;
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(count(*), 0)
          into ln_contador
          from (select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est = 'F' --estado finalizado
                   and a.sng065res = 'A' --respuesta autorizado
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = pn_politi --121 --numero politica
                   and a.sng065car = 220 --cargo
                   and a.sng065suc in
                       (select oficod
                          from fst811
                         where regcod = (select regcod
                                           from fst811
                                          where pgcod = 1
                                            and oficod = ln_agencia
                                            and regcod < 100
                                            and rownum = 1))
                      
                   and sng065fap >= ld_fec
                   and sng065fap <= ld_fecfin
                   and sng062aut >= ln_autmes
                   and sng091aut >= ln_autmes
                union all
                select *
                  from sng065 a, sng091 b
                 where a.sng062aut = b.sng091aut
                   and a.sng065est in ('P', 'A') --estado
                   and a.sng065res = 'P' --respuesta pendiente
                   and b.sng091tpo = 'P' --politica
                   and b.sng091num = pn_politi --121 --numero politica
                   and a.sng065car = 220 --cargo
                   and a.sng065suc in
                       (select oficod
                          from fst811
                         where regcod = (select regcod
                                           from fst811
                                          where pgcod = 1
                                            and oficod = ln_agencia
                                            and regcod < 100
                                            and rownum = 1))
                   and sng062aut >= ln_autmesant
                
                );
      
      exception
        when others then
          null;
      end;
    end;
  
    pn_cont := ln_contador;
  end sp_cont_autoriz_regional_poli;
  --chernandez 26/06/2020
  procedure sp_obtener_tasaRepro(pn_emp  in number,
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 pn_tasa out number) is
    --dcastro 14/11/2020
    -- 2022/08/18 dcastro Obtener tasa fondo para reprogramacion por flujo
    -----2024.01.19 dcastro TASA REFINANCIADO MEMO 18
    ---- 2024.01.31 dcastro se agrego guia de excepcion para tasa.
    ---- 2024.10.29 dcastro se modifico nvl en pn_tasa 
  
    ln_tasa number;
    ln_div  number;
  
  begin
    pn_tasa := 0;
  
    ----2024.01.31
    begin
      select TP1NRO3, TP1IMP1
        into ln_tasa, ln_div
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11152
         and f.tp1corr1 = 120
         and f.tp1corr2 = 1
         and f.tp1nro1 = pn_cta
         and f.tp1nro2 = pn_ope
         and f.tp1imp3 = 1; --1 habiliado / 0-deshabilitado
    exception
      when others then
        ln_tasa := 0;
    end;
    if ln_tasa > 0 then
      pn_tasa := ln_tasa / ln_div;
      return;
    end if;
  
    /* 2024.10.18 dcastro se agrego validacion para clientes CREDINKA   */
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then    
      begin
          pq_cr_funciones_cho.sp_obtener_TASACREDINKA(pn_emp => pn_emp,
                                                      pn_mod => pn_mod,
                                                      pn_suc => pn_suc,
                                                      pn_mda => pn_mda,
                                                      pn_pap => pn_pap,
                                                      pn_cta => pn_cta,
                                                      pn_ope => pn_ope,
                                                      pn_sbo => pn_sbo,
                                                      pn_top => pn_top,
                                                      pn_tasa => pn_tasa);
  
      exception when others then
        pn_tasa := 0;
      end;
        
    end if;  
    /* 2024.10.18 dcastro fin validacion para clientes CREDINKA   */
    
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then 
      ----     --2024.01.31
    
      --14/11/2020
      begin
        pq_cr_funciones_cho.sp_obtener_tasarepro_caja(pn_emp  => pn_emp,
                                                      pn_mod  => pn_mod,
                                                      pn_suc  => pn_suc,
                                                      pn_mda  => pn_mda,
                                                      pn_pap  => pn_pap,
                                                      pn_cta  => pn_cta,
                                                      pn_ope  => pn_ope,
                                                      pn_sbo  => pn_sbo,
                                                      pn_top  => pn_top,
                                                      pn_tasa => pn_tasa);
      end;
    
    end if; ---fin de     --2024.01.31
  
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then 
      -- no existe en la tabla de CRM
      --14/11/2020
      begin
      
        select a.aqpa970tasa
          into pn_tasa
          from aqpa970 a
         where a.aqpa970emp = pn_emp
           and a.aqpa970mod = pn_mod
           and a.aqpa970suc = pn_suc
           and a.aqpa970mda = pn_mda
           and a.aqpa970pap = pn_pap
           and a.aqpa970cta = pn_cta
           and a.aqpa970ope = pn_ope
           and a.aqpa970sbo = pn_sbo
           and a.aqpa970top = pn_top
           and a.aqpa970fep = (select max(b.aqpa970fep)
                                 from aqpa970 b
                                where b.aqpa970emp = pn_emp
                                  and b.aqpa970mod = pn_mod
                                  and b.aqpa970suc = pn_suc
                                  and b.aqpa970mda = pn_mda
                                  and b.aqpa970pap = pn_pap
                                  and b.aqpa970cta = pn_cta
                                  and b.aqpa970ope = pn_ope
                                  and b.aqpa970sbo = pn_sbo
                                  and b.aqpa970top = pn_top);
      
      exception
        when others then
          null;
      end;
    
    end if; --14/11/2020
  
    --- 2022/08/18 dcastro Obtener tasa fondo
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then 
      BEGIN
        SELECT F.NUEVATASA -- 'F'
          into pn_tasa
          FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
         WHERE F.IDFONDO = G.IDFONDO
           AND G.ESTADOSOLICITUD in ('BT', 'AP')
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo --- disminuye 1 para obtener suboperacion credito origen
           AND F.TIPOOPERACION in
               (select f.tp1nro2
                  from fst198 f
                 where f.tp1cod = 1
                   and f.tp1cod1 = 10899
                   and f.tp1corr1 = 400000
                   and f.tp1corr2 = 26
                   and f.tp1corr3 = 1);
      
      Exception
        when others then
          pn_tasa := 0;
      END;
    end if;
    ----- 2022/08/18 dcastro fin
  
    --- 2023/03/20 dcastro Obtener tasa fondo turismo
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then 
      BEGIN
        SELECT F.NUEVATASA -- 'F'
          into pn_tasa
          FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F
         WHERE F.IDTURISMO = G.IDTURISMO
           AND G.ESTADOSOLICITUD in ('BT', 'AP')
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo --- disminuye 1 para obtener suboperacion credito origen
           AND F.TIPOOPERACION in
               (select f.tp1nro2
                  from fst198 f
                 where f.tp1cod = 1
                   and f.tp1cod1 = 10899
                   and f.tp1corr1 = 400000
                   and f.tp1corr2 = 26
                   and f.tp1corr3 >= 1);
      
      Exception
        when others then
          pn_tasa := 0;
      END;
    end if;
    ----- 2023/03/20 dcastro fin
  
    -----2024.01.19 dcastro TASA REFINANCIADO MEMO 18
    pn_tasa := nvl(pn_tasa, 0);---2024.10.29 dcastro
   if pn_tasa = 0 then 
      begin
        pq_cr_funciones_cho.sp_obtener_TASAREFI(pn_emp  => pn_emp,
                                                pn_mod  => pn_mod,
                                                pn_suc  => pn_suc,
                                                pn_mda  => pn_mda,
                                                pn_pap  => pn_pap,
                                                pn_cta  => pn_cta,
                                                pn_ope  => pn_ope,
                                                pn_sbo  => pn_sbo,
                                                pn_top  => pn_top,
                                                pn_tasa => pn_tasa);
      end;
    end if;
    -----2024.01.19 dcastro TASA REFINANCIADO MEMO 18 FIN  
  exception
    when others then
      null;
  end sp_obtener_tasaRepro;

  procedure sp_obtener_tasaRepro_Caja(pn_emp  in number,
                                      pn_mod  in number,
                                      pn_suc  in number,
                                      pn_mda  in number,
                                      pn_pap  in number,
                                      pn_cta  in number,
                                      pn_ope  in number,
                                      pn_sbo  in number,
                                      pn_top  in number,
                                      pn_tasa out number) is
  
    --dcastro 14/11/2020 se agrego reprogramacion caja
    --dcastro 03/12/2020 se agrego reprogramacion gobierno
  
    ln_tasa number;
  
  begin
  
    begin
      SELECT F.NUEVATASA
        into ln_tasa
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION = pn_top;
    exception
      when others then
        ln_tasa := 0;
    end;
  
    if ln_tasa = 0 then
      -- validar si es reprogramacion gobierno  03/12/2020
      begin
        SELECT F.NUEVATASA
          into ln_tasa
          FROM LEY31050 L
         INNER JOIN LEY31050_CREDITOSFACILIDAD F
            ON L.IDLEY31050 = F.IDLEY31050
         WHERE L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'GOBIERNO'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
          ln_tasa := 0;
      end;
    
    end if;
  
    pn_tasa := ln_tasa;
  
  end sp_obtener_tasaRepro_Caja;

  function fn_obtener_tasaRepro_Caja(pn_emp in number,
                                     pn_mod in number,
                                     pn_suc in number,
                                     pn_mda in number,
                                     pn_pap in number,
                                     pn_cta in number,
                                     pn_ope in number,
                                     pn_sbo in number,
                                     pn_top in number) return varchar2 is
    --dcastro 14/11/2020
  
    lc_existe char(1);
  
  begin
  
    begin
      SELECT 'S'
        into lc_existe
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'CAJA'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION = pn_top;
    exception
      when others then
        lc_existe := 'N';
    end;
  
    return lc_existe;
  
  end fn_obtener_tasaRepro_Caja;

  ----------------------------------------
  procedure sp_obtener_IdLey(pn_emp   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pn_idley out number) is
  
    --dcastro 14/11/2020
    --dcastro 22/12/2020 se comento condicion TIPOFACILIDAD
  
  begin
  
    begin
      SELECT F.IDLEY31050
        into pn_idley
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
            --AND L.TIPOFACILIDAD = 'CAJA'  22/12/2020
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION = pn_top
         AND ROWNUM = 1;
    exception
      when others then
        pn_idley := 0;
    end;
  
  end sp_obtener_IdLey;

  --------------------------------------------

  function fn_obtener_tasaRepro_Actual(pn_emp in number,
                                       pn_mod in number,
                                       pn_suc in number,
                                       pn_mda in number,
                                       pn_pap in number,
                                       pn_cta in number,
                                       pn_ope in number,
                                       pn_sbo in number,
                                       pn_top in number) return number is
  
    --dcastro 14/11/2020
    ln_tasa number(10, 6);
  
  begin
  
    begin
      SELECT F.TASAACTUAL
        into ln_tasa
        FROM LEY31050_CREDITOS F
       WHERE SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION = pn_top;
    exception
      when others then
        ln_tasa := 0;
    end;
  
    return ln_tasa;
  
  end fn_obtener_tasaRepro_Actual;

  --22/10/2020 chernandez 
  procedure sp_es_reprogramado(pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pv_rpta out varchar2) is
    /*ln_cong numeric(5);
    ln_reco numeric(5);
    ln_masi numeric(5);
    ln_agen numeric(5);*/
    ln_bi     numeric(5);
    ln_estado numeric(4);
  begin
  
    /*select nvl(count(*), 0)
      into ln_cong
      from aqpb002
     where aqpb002emp = pn_emp
       and aqpb002mod = pn_mod
       and aqpb002suc = pn_suc
       and aqpb002mda = pn_mda
       and aqpb002pap = pn_pap
       and aqpb002cta = pn_cta
       and aqpb002ope = pn_ope
       and aqpb002sbo = pn_sbo
       and aqpb002top = pn_top
       and aqpb002est = 'C'
       and nvl(aqpb002revr, 'N') = 'N';
    
    select nvl(count(*), 0)
      into ln_reco
      from jaqz698
     where jaqz698emp = pn_emp
       and jaqz698mod = pn_mod
       and jaqz698suc = pn_suc
       and jaqz698mda = pn_mda
       and jaqz698pap = pn_pap
       and jaqz698cta = pn_cta
       and jaqz698ope = pn_ope
       and jaqz698sbo = pn_sbo
       and jaqz698top = pn_top
       and jaqz698est = 'C';
    
    select nvl(count(*), 0)
      into ln_masi
      from jaqa255
     where jaqa255emp = pn_emp
       and jaqa255mod = pn_mod
       and jaqa255mda = pn_mda
       and jaqa255pap = pn_pap
       and jaqa255cta = pn_cta
       and jaqa255ope = pn_ope
       and jaqa255sbo = pn_sbo - 1
       and jaqa255tpo = pn_top
       and jaqa255est = 'L';
    
    select nvl(count(*), 0)
      into ln_agen
      from fsd010
     where pgcod = pn_emp
       and aosuc = pn_suc
       and aomod = pn_mod
       and aomda = pn_mda
       and aopap = pn_pap
       and aocta = pn_cta
       and aooper = pn_ope
       and aosbop = pn_sbo
       and aotope = pn_top
       and (pgcod, aosuc, aomod, aomda, aopap, aocta, aooper, aosbop, aotope) in
           (select xwfempresa,
                   xwfsucursal,
                   xwfmodulo,
                   xwfmoneda,
                   xwfpapel,
                   xwfcuenta,
                   xwfoperacion,
                   xwfsubope,
                   xwftipope
              from xwf700 d
             where xwfprcins in
                   (select sng001inst
                      from sng001
                     where sng001ori in (13, 14)
                       and sng001fin >= to_date('15/03/2020', 'dd/mm/yyyy'))
               and exists (select *
                      from xwf070 a
                     where a.xwfprcin = d.xwfprcins
                       and a.xwfcont = 'S')
               and xwfcar3 = '1');
    
    if ln_cong + ln_reco + ln_masi + ln_agen > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;*/
  
    begin
      select count(*)
        into ln_bi
        from aqpa833
       where bccta = pn_cta
         and bcoper = pn_ope
         and bcsbop = pn_sbo
         and EXTORNO = 'NO';
    exception
      when others then
        null;
    end;
  
    begin
      select aostat
        into ln_estado
        from fsd010
       where pgcod = pn_emp
         and aosuc = pn_suc
         and aomod = pn_mod
         and aomda = pn_mda
         and aopap = pn_pap
         and aocta = pn_cta
         and aooper = pn_ope
         and aosbop = pn_sbo
         and aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    pv_rpta := 'N';
  
    if ln_bi > 0 then
      If ln_estado <> 61 then
        pv_rpta := 'S';
      else
        pv_rpta := 'N';
      end if;
    end if;
    -- pv_rpta := 'N';
  
  end sp_es_reprogramado;

  procedure sp_obtener_tasaGob(pn_emp  in number,
                               pn_mod  in number,
                               pn_suc  in number,
                               pn_mda  in number,
                               pn_pap  in number,
                               pn_cta  in number,
                               pn_ope  in number,
                               pn_sbo  in number,
                               pn_top  in number,
                               pn_tasa out number,
                               pn_ttas out number) is
    --dcastro 12/02/2021
    --dcastro 06/09/2021 se agrego condicion para retornar pn_ttas = 0 cuando la tasa es 0
  begin
    pn_tasa := 0;
  
    begin
      select f.aottas
        into pn_ttas
        from fsd010 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top;
    exception
      when others then
        pn_ttas := 0;
    end;
  
    begin
      pq_cr_funciones_cho.sp_obtener_tasarepro_gob(pn_emp  => pn_emp,
                                                   pn_mod  => pn_mod,
                                                   pn_suc  => pn_suc,
                                                   pn_mda  => pn_mda,
                                                   pn_pap  => pn_pap,
                                                   pn_cta  => pn_cta,
                                                   pn_ope  => pn_ope,
                                                   pn_sbo  => pn_sbo,
                                                   pn_top  => pn_top,
                                                   pn_tasa => pn_tasa);
    end;
  
    if pn_tasa = 0 then
      ---06/09/2021 dcastro
      pn_ttas := 0;
    end if;
  
    /*if pn_tasa = 0 then
        -- no existe en la tabla de CRM
        begin
        
          select a.aqpa970tasa
            into pn_tasa
            from aqpa970 a
           where a.aqpa970emp = pn_emp
             and a.aqpa970mod = pn_mod
             and a.aqpa970suc = pn_suc
             and a.aqpa970mda = pn_mda
             and a.aqpa970pap = pn_pap
             and a.aqpa970cta = pn_cta
             and a.aqpa970ope = pn_ope
             and a.aqpa970sbo = pn_sbo
             and a.aqpa970top = pn_top
             and a.aqpa970fep = (select max(b.aqpa970fep)
                                   from aqpa970 b
                                  where b.aqpa970emp = pn_emp
                                    and b.aqpa970mod = pn_mod
                                    and b.aqpa970suc = pn_suc
                                    and b.aqpa970mda = pn_mda
                                    and b.aqpa970pap = pn_pap
                                    and b.aqpa970cta = pn_cta
                                    and b.aqpa970ope = pn_ope
                                    and b.aqpa970sbo = pn_sbo
                                    and b.aqpa970top = pn_top);
        
        exception
          when others then
            null;
        end;
      
      end if;
    */
  exception
    when others then
      null;
  end sp_obtener_tasaGob;

  procedure sp_obtener_tasaRepro_Gob(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_tasa out number) is
  
    --dcastro 12/02/2021 se agrego reprogramacion gobierno
    --DCASTRO 13/08/2021 se agrego consulta para reprogramacion caja
    --DCASTRO 21/09/2021 se agregó condicion para validar sino tiene tasa gobierno busca tasa para caja.
  
    ln_tasa number;
  
  begin
    /* tabla reprogramados
        begin
          select count(*)
            into ln_creditoscrm
            from (select *
                    FROM  REPROG L
                   WHERE L.ESTADOSOLICITUD = 'BT'
                     AND SUBSTR(L.CUENTAOPERACION,
                                0,
                                INSTR(L.CUENTAOPERACION, '-') - 1) = ln_cuenta
                     AND SUBSTR(L.CUENTAOPERACION,
                                INSTR(L.CUENTAOPERACION, '-') + 1,
                                99) = ln_operacion) t;
        exception
          when others then
               ln_creditoscrm := 0;
        end;  
    */
  
    begin
      SELECT F.NUEVATASA
        into ln_tasa
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE L.ESTADOSOLICITUD = 'BT'
         AND L.TIPOFACILIDAD = 'GOBIERNO'
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION = pn_top;
    exception
      when others then
        ln_tasa := 0;
    end;
  
    if ln_tasa = 0 then
      -- 2021.09.21 DCASTRO
    
      ---//2021.08.13  DCASTRO
      begin
        SELECT F.NUEVATASA
          into ln_tasa
          FROM LEY31050 L
         INNER JOIN LEY31050_CREDITOSFACILIDAD F
            ON L.IDLEY31050 = F.IDLEY31050
         WHERE L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'CAJA'
           AND UPPER(F.FACILIDAD) like 'REDUC%'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
          ln_tasa := 0;
      end;
      ---//2021.08.13 DCASTRO
    
      if ln_tasa = 0 then
        ----VERIFICAR   ---//2021.10.28  DCASTRO
      
        begin
          SELECT F.NUEVATASA
            into ln_tasa
            FROM LEY31050 L
           INNER JOIN LEY31050_CREDITOSFACILIDAD F
              ON L.IDLEY31050 = F.IDLEY31050
           WHERE L.ESTADOSOLICITUD = 'BT'
             AND L.TIPOFACILIDAD = 'CAJA'
             AND UPPER(F.FACILIDAD) like '%JUNTOS%'
             AND SUBSTR(F.CUENTAOPERACION,
                        0,
                        INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
             AND SUBSTR(F.CUENTAOPERACION,
                        INSTR(F.CUENTAOPERACION, '-') + 1,
                        99) = pn_ope
             AND F.EMPRESA = pn_emp
             AND F.SUCURSAL = pn_suc
             AND F.MODULO = pn_mod
             AND F.MONEDA = pn_mda
             AND F.PAPEL = pn_pap
             AND F.SUBOPERACION = pn_sbo
             AND F.TIPOOPERACION = pn_top;
        exception
          when others then
            ln_tasa := 0;
        end;
      end if; ---//2021.10.28 DCASTRO
    
    end if; -- 2021.09.21 DCASTRO
  
    pn_tasa := ln_tasa;
  
  end sp_obtener_tasaRepro_Gob;

  procedure sp_Tipo_Repro(pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pc_tip out varchar2,
                          pn_tas out number) is
  
    --dcastro 12/02/2021 se agrego reprogramacion gobierno
  
    lc_tipo varchar(1);
  
  begin
  
    begin
      SELECT 'G', F.NUEVATASA
        into lc_tipo, pn_tas
        FROM LEY31050 L
       INNER JOIN LEY31050_CREDITOSFACILIDAD F
          ON L.IDLEY31050 = F.IDLEY31050
       WHERE /*L.ESTADOSOLICITUD = 'AP' 
                                            AND*/
       L.TIPOFACILIDAD = 'GOBIERNO'
       AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
       pn_cta
       AND SUBSTR(F.CUENTAOPERACION, INSTR(F.CUENTAOPERACION, '-') + 1, 99) =
       pn_ope
       AND F.EMPRESA = pn_emp
       AND F.SUCURSAL = pn_suc
       AND F.MODULO = pn_mod
       AND F.MONEDA = pn_mda
       AND F.PAPEL = pn_pap
       AND F.SUBOPERACION = pn_sbo
       AND F.TIPOOPERACION = pn_top;
    exception
      when others then
        lc_tipo := '';
    end;
  
    pc_tip := lc_tipo;
  
  end sp_Tipo_Repro;

  procedure sp_indicador_CRM_Caja(pn_instancia in number,
                                  pc_ind       out varchar2) is
  
    pn_emp number;
    pn_suc number;
    pn_mod number;
    pn_mda number;
    pn_pap number;
    pn_cta number;
    pn_ope number;
    pn_sbo number;
    pn_top number;
  
  Begin
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        SELECT 'C'
          into pc_ind
          FROM /*usrwebcrm.*/ LEY31050 L
         INNER JOIN /*usrwebcrm.*/
        LEY31050_CREDITOSFACILIDAD F
            ON L.IDLEY31050 = F.IDLEY31050
         WHERE L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'CAJA'
           AND UPPER(F.FACILIDAD) not like '%JUNTOS%'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
        
          begin
            SELECT 'G'
              into pc_ind
              FROM /*usrwebcrm.*/ LEY31050 L
             INNER JOIN /*usrwebcrm.*/
            LEY31050_CREDITOSFACILIDAD F
                ON L.IDLEY31050 = F.IDLEY31050
             WHERE L.ESTADOSOLICITUD = 'BT'
               AND L.TIPOFACILIDAD = 'GOBIERNO'
               AND SUBSTR(F.CUENTAOPERACION,
                          0,
                          INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
               AND SUBSTR(F.CUENTAOPERACION,
                          INSTR(F.CUENTAOPERACION, '-') + 1,
                          99) = pn_ope
               AND F.EMPRESA = pn_emp
               AND F.SUCURSAL = pn_suc
               AND F.MODULO = pn_mod
               AND F.MONEDA = pn_mda
               AND F.PAPEL = pn_pap
               AND F.SUBOPERACION = pn_sbo
               AND F.TIPOOPERACION = pn_top;
          exception
            when others then
              begin
                --24/07/2021
                select 'V'
                  into pc_ind
                  from (select *
                          FROM /*USRWEBCRM.*/ REPROG L
                         WHERE L.ESTADOSOLICITUD = 'BT'
                           AND SUBSTR(L.CUENTAOPERACION,
                                      0,
                                      INSTR(L.CUENTAOPERACION, '-') - 1) =
                               pn_cta
                           AND SUBSTR(L.CUENTAOPERACION,
                                      INSTR(L.CUENTAOPERACION, '-') + 1,
                                      99) = pn_ope) t;
              exception
                when others then
                  BEGIN
                    SELECT 'F'
                      into pc_ind
                      FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
                     WHERE F.IDFONDO = G.IDFONDO
                       AND G.ESTADOSOLICITUD = 'BT'
                       AND F.Perfil in (select f.tp1imp1 --21/07/2021
                                          from fst198 f
                                         where f.tp1cod = 1
                                           and f.tp1cod1 = 10899
                                           and f.tp1corr1 = 400000
                                           and f.tp1corr2 = 5
                                           and f.tp1corr3 > 0) --21/07/2021 dcastro se agrego tipo de perfil
                       AND SUBSTR(F.CUENTAOPERACION,
                                  0,
                                  INSTR(F.CUENTAOPERACION, '-') - 1) =
                           pn_cta
                       AND SUBSTR(F.CUENTAOPERACION,
                                  INSTR(F.CUENTAOPERACION, '-') + 1,
                                  99) = pn_ope
                       AND F.EMPRESA = pn_emp
                       AND F.SUCURSAL = pn_suc
                       AND F.MODULO = pn_mod
                       AND F.MONEDA = pn_mda
                       AND F.PAPEL = pn_pap
                       AND F.SUBOPERACION = pn_sbo
                       AND F.TIPOOPERACION = pn_top;
                  
                  exception
                    ---20211028 dcastro 
                    when others then
                      begin
                        SELECT 'J'
                          into pc_ind
                          FROM /*usrwebcrm.*/ LEY31050 L
                         INNER JOIN /*usrwebcrm.*/
                        LEY31050_CREDITOSFACILIDAD F
                            ON L.IDLEY31050 = F.IDLEY31050
                         WHERE L.ESTADOSOLICITUD = 'BT'
                           AND L.TIPOFACILIDAD = 'CAJA'
                           AND UPPER(F.FACILIDAD) like '%JUNTOS%'
                           AND SUBSTR(F.CUENTAOPERACION,
                                      0,
                                      INSTR(F.CUENTAOPERACION, '-') - 1) =
                               pn_cta
                           AND SUBSTR(F.CUENTAOPERACION,
                                      INSTR(F.CUENTAOPERACION, '-') + 1,
                                      99) = pn_ope
                           AND F.EMPRESA = pn_emp
                           AND F.SUCURSAL = pn_suc
                           AND F.MODULO = pn_mod
                           AND F.MONEDA = pn_mda
                           AND F.PAPEL = pn_pap
                           AND F.SUBOPERACION = pn_sbo
                           AND F.TIPOOPERACION = pn_top;
                      exception
                        when others then
                          --apachecoh 2023.09.27
                          begin
                            SELECT 'V'
                              into pc_ind
                              FROM AQPC952 B
                             WHERE B.AQPC952FECC =
                                   (SELECT MAX(AQPC952FECC) FROM AQPC952)
                               AND B.AQPC952HORC =
                                   (SELECT MAX(AQPC952HORC)
                                      FROM AQPC952
                                     WHERE AQPC952FECC =
                                           (SELECT MAX(AQPC952FECC)
                                              FROM AQPC952))
                               AND B.AQPC952CTA = pn_cta
                               AND B.AQPC952OPER = pn_ope;
                            /*SELECT 'V'
                             into pc_ind
                             FROM USRREPBI.REP_308_REPROGRAMACIONES_VENCIDOS B
                            WHERE B.BCCTA = pn_cta
                              AND B.BCOPER = pn_ope
                              AND ROWNUM = 1;*/
                          exception
                            when others then
                              pc_ind := 'N';
                          end;
                      end; ---20211028 dcastro 
                  end;
              end;
          end;
      end;
    else
      pc_ind := 'N';
    end if;
  
  end sp_indicador_CRM_Caja;

  procedure sp_existe_CRM_Caja(pn_instancia in number, pc_ind out varchar2) is
    --25/05/2021 DCASTRO se adicion? consulta para validar aqpb561fecr
  
    ln_mtocap     number(18, 2);
    ln_tasa       number(10, 6);
    ln_porcentaje number(10, 6);
    ln_mtocred    number(18, 2);
    pn_emp        number;
    pn_suc        number;
    pn_mod        number;
    pn_mda        number;
    pn_pap        number;
    pn_cta        number;
    pn_ope        number;
    pn_sbo        number;
    pn_top        number;
    ln_scap       number(18, 2);
    ln_capt       number(18, 2);
    ln_redu       number(10, 6);
    lc_autonomia  varchar2(100);
  
  Begin
  
    pc_ind := 'N';
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        SELECT F.MONTOCAPITALIZACION, /*F.PORCENTAJEREDUCCION,*/
               F.MONTOCREDITO,
               F.NUEVATASA,
               F.MENSAJEAUTONOMIA
          into ln_mtocap, /*ln_porcentaje,*/
               ln_mtocred,
               ln_tasa,
               lc_autonomia
          FROM /*usrwebcrm.*/ LEY31050 L
         INNER JOIN /*usrwebcrm.*/
        LEY31050_CREDITOSFACILIDAD F
            ON L.IDLEY31050 = F.IDLEY31050
         WHERE L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'CAJA'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
          ln_tasa    := 0;
          ln_mtocred := 0;
          pc_ind     := 'N'; --2021/07/22 dcastro se agrego variable
      end;
    
      if upper(lc_autonomia) like '%ANALISTA%' then
        pc_ind := 'S';
        return;
      else
      
        begin
          SELECT A.AQPB561SCAP, A.AQPB561CAPT, A.AQPB561REDU
            INTO ln_scap, ln_capt, ln_redu
            FROM AQPB561 A
           WHERE A.AQPB561EMP = pn_emp
             AND A.AQPB561MOD = pn_mod
             AND A.AQPB561SUC = pn_suc
             AND A.AQPB561MDA = pn_mda
             AND A.AQPB561PAP = pn_pap
             AND A.AQPB561CTA = pn_cta
             AND A.AQPB561OPER = pn_ope
             AND A.AQPB561SBOP = pn_sbo
             AND A.AQPB561TOP = pn_top
             AND A.AQPB561INST = pn_instancia
             AND A.AQPB561EST = 'A'
             AND A.AQPB561EHAB = 'H'
             AND A.AQPB561FECR =
                 (SELECT MAX(B.AQPB561FECR)
                    FROM AQPB561 B
                   WHERE B.AQPB561EMP = pn_emp
                     AND B.AQPB561MOD = pn_mod
                     AND B.AQPB561SUC = pn_suc
                     AND B.AQPB561MDA = pn_mda
                     AND B.AQPB561PAP = pn_pap
                     AND B.AQPB561CTA = pn_cta
                     AND B.AQPB561OPER = pn_ope
                     AND B.AQPB561SBOP = pn_sbo
                     AND B.AQPB561TOP = pn_top
                     AND B.AQPB561INST = pn_instancia
                     AND B.AQPB561EST IN ('A', 'P')
                     AND B.AQPB561EHAB = 'H');
        exception
          when others then
            ln_scap := 0;
            ln_capt := 0;
            pc_ind  := 'Z';
            return;
            --ln_redu := 0;
        end;
      
        if nvl(ln_mtocap, 0) = nvl(ln_capt, 0) and
           nvl(ln_redu, 0) = nvl(ln_tasa, 0) and nvl(ln_capt, 0) >= 0 then
          pc_ind := 'S';
        else
          pc_ind := 'D'; --18/03/2021 se agrego estado  
        end if;
      
      end if;
    
    end if;
  
  end sp_existe_CRM_Caja;

  procedure sp_obtener_tasaRepro_Act(pn_emp  in number,
                                     pn_mod  in number,
                                     pn_suc  in number,
                                     pn_mda  in number,
                                     pn_pap  in number,
                                     pn_cta  in number,
                                     pn_ope  in number,
                                     pn_sbo  in number,
                                     pn_top  in number,
                                     pn_tasa out number) is
  
    --dcastro 26/02/2021 se obtiene tasa de ley31050_creditos
  
  begin
  
    begin
      pn_tasa := pq_cr_funciones_cho.fn_obtener_tasarepro_actual(pn_emp => pn_emp,
                                                                 pn_mod => pn_mod,
                                                                 pn_suc => pn_suc,
                                                                 pn_mda => pn_mda,
                                                                 pn_pap => pn_pap,
                                                                 pn_cta => pn_cta,
                                                                 pn_ope => pn_ope,
                                                                 pn_sbo => pn_sbo,
                                                                 pn_top => pn_top);
    
    end;
  
    begin
      -- Call the procedure
      pq_cr_repro_cov.sp_actualizar_aqpb088(pn_emp => pn_emp,
                                            pn_mod => pn_mod,
                                            pn_suc => pn_suc,
                                            pn_mda => pn_mda,
                                            pn_pap => pn_pap,
                                            pn_cta => pn_cta,
                                            pn_ope => pn_ope,
                                            pn_sbo => pn_sbo,
                                            pn_top => pn_top);
    exception
      when others then
        null;
    end;
  
  end sp_obtener_tasaRepro_Act;

  procedure sp_Repro_COVID(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_ind out varchar2) is
  
    --dcastro 19/03/2021 se agrego reprogramacion gobierno COVID
  
    ln_cont number;
  
  begin
  
    begin
      /*   select count(*)
      into ln_cont
       FROM REPROG L
      WHERE L.ESTADOSOLICITUD = 'BT'
        AND SUBSTR(L.CUENTAOPERACION,
                   0,
                   INSTR(L.CUENTAOPERACION, '-') - 1) = pn_cta
        AND SUBSTR(L.CUENTAOPERACION,
                   INSTR(L.CUENTAOPERACION, '-') + 1,
                   99) = pn_ope;
                   */
      select count(*)
        into ln_cont
        FROM (select *
                FROM REPROG L
               WHERE L.ESTADOSOLICITUD = 'BT'
                 AND L.CUENTAOPERACION = (pn_cta || '-' || pn_ope));
    exception
      when others then
        ln_cont := 0;
    end;
  
    if ln_cont > 0 then
      pc_ind := 'S';
    else
      pc_ind := 'N';
    end if;
  
  end sp_Repro_COVID;

  procedure sp_fecha_COVID(pn_instancia in number, pc_ind out varchar2) is
  
    --dcastro 19/03/2021 se agrego reprogramacion gobierno COVID
  
    ln_cont   number;
    ld_fec    date;
    ld_newfec date;
    ln_dias   number;
    pn_emp    number;
    pn_suc    number;
    pn_mod    number;
    pn_mda    number;
    pn_pap    number;
    pn_cta    number;
    pn_ope    number;
    pn_sbo    number;
    pn_top    number;
  
  begin
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        select F.AOFVTO
          into ld_fec
          from fsd010 f
         where f.pgcod = pn_emp
           and f.aomod = pn_mod
           and f.aosuc = pn_suc
           and f.aomda = pn_mda
           and f.aopap = pn_pap
           and f.aocta = pn_cta
           and f.aooper = pn_ope
           and f.aosbop = pn_sbo
           and f.aotope = pn_top;
      exception
        when others then
          ld_fec := null;
      end;
    
      begin
        select f.tp1nro1
          into ln_dias
          from fst198 f
         where f.tp1cod1 = 10899
           and f.tp1corr1 = 400000
           and f.tp1corr2 = 4
           and f.tp1corr3 = 1;
      exception
        when others then
          ln_dias := 0;
      end;
    
      ld_fec := ld_fec + ln_dias;
    
      begin
        select max(f.ppfpag)
          into ld_newfec
          from fsd601 f
         where f.pgcod = pn_emp
           and f.ppmod = pn_mod
           and f.ppsuc = pn_suc
           and f.ppmda = pn_mda
           and f.pppap = pn_pap
           and f.ppcta = pn_cta
           and f.ppoper = pn_ope
           and f.ppsbop = 609
           and f.pptope = pn_top;
      exception
        when others then
          ld_newfec := null;
      end;
    
      if ld_newfec > ld_fec then
        pc_ind := 'S';
      else
        pc_ind := 'N';
      end if;
    
    else
      pc_ind := 'E';
    end if;
  
  end sp_fecha_COVID;

  procedure sp_unilateral(pn_instancia in number, pc_ind out varchar2) is
  
    --dcastro 19/03/2021 se agrego indicador si es unilateral
    --dcastro 23/04/2021 se inicializo variable
  
    lc_tipo varchar2(1);
    pn_emp  number;
    pn_suc  number;
    pn_mod  number;
    pn_mda  number;
    pn_pap  number;
    pn_cta  number;
    pn_ope  number;
    pn_sbo  number;
    pn_top  number;
  
  begin
  
    lc_tipo := 'N'; --- 2021/04/23 se inicializo variable dcastro     
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        SELECT TRIM(J.JAQA400AC1)
          INTO lc_tipo
          FROM JAQA400 J
         WHERE J.JAQA400EMP = pn_emp
           AND J.JAQA400MOD = pn_mod
           AND J.JAQA400SUC = pn_suc
           AND J.JAQA400MDA = pn_mda
           AND J.JAQA400PAP = pn_pap
           AND J.JAQA400CTA = pn_cta
           AND J.JAQA400OPE = pn_ope
           AND J.JAQA400SBO = pn_sbo
           AND J.JAQA400TOP = pn_top
           AND J.JAQA400FEC = (select MAX(JAQA400FEC)
                                 FROM JAQA400 D
                                WHERE D.JAQA400EMP = pn_emp
                                  AND D.JAQA400MOD = pn_mod
                                  AND D.JAQA400SUC = pn_suc
                                  AND D.JAQA400MDA = pn_mda
                                  AND D.JAQA400PAP = pn_pap
                                  AND D.JAQA400CTA = pn_cta
                                  AND D.JAQA400OPE = pn_ope
                                  AND D.JAQA400SBO = pn_sbo
                                  AND D.JAQA400TOP = pn_top
                               /*AND D.JAQA400EST = 'A'*/
                               );
      exception
        when others then
          lc_tipo := null;
      end;
    
      pc_ind := lc_tipo;
    
    else
      pc_ind := 'E';
    end if;
  
  end sp_unilateral;

  procedure sp_obtener_tasaFondo(pn_emp  in number,
                                 pn_mod  in number,
                                 pn_suc  in number,
                                 pn_mda  in number,
                                 pn_pap  in number,
                                 pn_cta  in number,
                                 pn_ope  in number,
                                 pn_sbo  in number,
                                 pn_top  in number,
                                 pn_tasa out number,
                                 pn_ttas out number) is
  
    --dcastro 18/06/2021 se agrego reprogramacion FONDO gobierno
  
    ln_tasa number;
  
  begin
  
    pn_tasa := 0;
  
    begin
      select f.aottas
        into pn_ttas
        from fsd010 f
       where f.pgcod = pn_emp
         and f.aomod = pn_mod
         and f.aosuc = pn_suc
         and f.aomda = pn_mda
         and f.aopap = pn_pap
         and f.aocta = pn_cta
         and f.aooper = pn_ope
         and f.aosbop = pn_sbo
         and f.aotope = pn_top;
    exception
      when others then
        pn_ttas := 0;
    end;
  
    --2023/03/13 DCASTRO SE AGREGO PARA FAE TURISMO
    IF pn_top = 355 THEN
      begin
        SELECT F.NUEVATASA
          into ln_tasa
          FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F
         WHERE F.IDTURISMO = G.IDTURISMO
           AND G.ESTADOSOLICITUD IN ('BT', 'AP')
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
          ln_tasa := 0;
      end;
    
    END IF;
    --2023/03/13
  
    pn_tasa := ln_tasa;
  
  end sp_obtener_tasaFondo;

  procedure sp_Tipos_CRM(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pc_ind out varchar2) is
  
  Begin
    
    pc_ind := 'N';                     
  
    if pn_cta is not null then
    
      begin
        SELECT case
                 when UPPER(FACILIDAD) like 'REDUC%' then
                  'R'
                 when UPPER(FACILIDAD) like 'EXO%' then
                  'E'
                 when UPPER(FACILIDAD) like 'JUN%' then
                  'J' -- 20211028 dcastro
               end case
          into pc_ind
          FROM /*usrwebcrm.*/ LEY31050 L
         INNER JOIN /*usrwebcrm.*/
        LEY31050_CREDITOSFACILIDAD F
            ON L.IDLEY31050 = F.IDLEY31050
         WHERE L.ESTADOSOLICITUD = 'BT'
           AND L.TIPOFACILIDAD = 'CAJA'
           AND SUBSTR(F.CUENTAOPERACION,
                      0,
                      INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                      INSTR(F.CUENTAOPERACION, '-') + 1,
                      99) = pn_ope
           AND F.EMPRESA = pn_emp
           AND F.SUCURSAL = pn_suc
           AND F.MODULO = pn_mod
           AND F.MONEDA = pn_mda
           AND F.PAPEL = pn_pap
           AND F.SUBOPERACION = pn_sbo
           AND F.TIPOOPERACION = pn_top;
      exception
        when others then
        
          begin
            SELECT 'G'
              into pc_ind
              FROM /*usrwebcrm.*/ LEY31050 L
             INNER JOIN /*usrwebcrm.*/
            LEY31050_CREDITOSFACILIDAD F
                ON L.IDLEY31050 = F.IDLEY31050
             WHERE L.ESTADOSOLICITUD = 'BT'
               AND L.TIPOFACILIDAD = 'GOBIERNO'
               AND SUBSTR(F.CUENTAOPERACION,
                          0,
                          INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
               AND SUBSTR(F.CUENTAOPERACION,
                          INSTR(F.CUENTAOPERACION, '-') + 1,
                          99) = pn_ope
               AND F.EMPRESA = pn_emp
               AND F.SUCURSAL = pn_suc
               AND F.MODULO = pn_mod
               AND F.MONEDA = pn_mda
               AND F.PAPEL = pn_pap
               AND F.SUBOPERACION = pn_sbo
               AND F.TIPOOPERACION = pn_top;
          exception
            when others then
              pc_ind := 'N';
          end;
      end;
      begin
        SELECT 'V'
          INTO pc_ind 
          from REPROG F
         WHERE SUBSTR(F.CUENTAOPERACION,
                          0,
                          INSTR(F.CUENTAOPERACION, '-') - 1) = pn_cta
           AND SUBSTR(F.CUENTAOPERACION,
                          INSTR(F.CUENTAOPERACION, '-') + 1,
                          99) = pn_ope
           AND ESTADOSOLICITUD = 'BT';--- 2024.09.04 DCASTRO SE AGREGO CONDICION BT
        ---
        EXCEPTION
          WHEN OTHERS THEN
               pc_ind := 'N';
      end;
   
  

    else
      pc_ind := 'N';
    end if;
  
  end sp_Tipos_CRM;

  procedure sp_Plazo_Caja(pn_instancia in number, pn_plazo out number) is
  
    ld_fecsis date;
    ld_newfec date;
    pn_emp    number;
    pn_suc    number;
    pn_mod    number;
    pn_mda    number;
    pn_pap    number;
    pn_cta    number;
    pn_ope    number;
    pn_sbo    number;
    pn_top    number;
  
  begin
  
    begin
      select f.pgfape into ld_fecsis from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_fecsis := null;
    end;
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    if pn_cta is not null then
    
      begin
        select max(f.ppfpag)
          into ld_newfec
          from fsd601 f
         where f.pgcod = pn_emp
           and f.ppmod = pn_mod
           and f.ppsuc = pn_suc
           and f.ppmda = pn_mda
           and f.pppap = pn_pap
           and f.ppcta = pn_cta
           and f.ppoper = pn_ope
           and f.ppsbop = 609
           and f.pptope = pn_top;
      exception
        when others then
          ld_newfec := null;
      end;
    
      pn_plazo := ld_newfec - ld_fecsis;
    end if;
  
  end sp_Plazo_Caja;

  procedure sp_gestion_FONDO(pn_instancia in number, pn_perfil out number) is
    -- 2022/08/18 retorna perfil CRM reprogramacion Fondo
  
    pn_emp number;
    pn_suc number;
    pn_mod number;
    pn_mda number;
    pn_pap number;
    pn_cta number;
    pn_ope number;
    pn_sbo number;
    pn_top number;
  
  begin
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = 'S' ---reprogramacion
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    BEGIN
      SELECT F.PERFIL
        into pn_perfil
        FROM FONDOS G, FONDOS_CREDITOSFACILIDAD F
       WHERE F.IDFONDO = G.IDFONDO
         AND G.ESTADOSOLICITUD in ('BT', 'AP')
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo --- disminuye 1 para obtener suboperacion credito origen
         AND F.TIPOOPERACION in (select f.tp1nro2
                                   from fst198 f
                                  where f.tp1cod = 1
                                    and f.tp1cod1 = 10899
                                    and f.tp1corr1 = 400000
                                    and f.tp1corr2 = 26
                                    and f.tp1corr3 >= 1);
    
    Exception
      when others then
        pn_perfil := 0;
    END;
  
  exception
    when others then
      null;
  end sp_gestion_FONDO;

  -----

  procedure sp_REPROGRAMA_FONDO(pn_instancia in number, pn_tipo out number) is
  
    /* ************************************************************************************************************
        -- Nombre                     : sp_REPROGRAMA_FONDO
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Creditos
        -- Descripción                : retorna tipo de operacion reprogramacion Fondo 
        --                               355 -- FAE TURISMO
        --                               353 -- REACTIVA
        --                               0 -- NO PERTENECE A FONDO
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2023/03/15
        -- Autor de Creación          : DCASTRO
        -- Fecha de Modificación      : -
        -- Autor de Modificación      : -
        -- Descripción Modificación   : -
    
    * *************************************************************************************************************/
    pn_emp number;
    pn_suc number;
    pn_mod number;
    pn_mda number;
    pn_pap number;
    pn_cta number;
    pn_ope number;
    pn_sbo number;
    pn_top number;
  
  begin
  
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
        into pn_emp,
             pn_suc,
             pn_mod,
             pn_mda,
             pn_pap,
             pn_cta,
             pn_ope,
             pn_sbo,
             pn_top
        from xwf700 x
       where x.xwfprcins = pn_instancia
         and x.xwfcar3 = 'S' ---reprogramacion
         and rownum = 1;
    exception
      when others then
        pn_cta := null;
    end;
  
    BEGIN
      SELECT F.TIPOOPERACION
        into pn_tipo
        FROM TURISMO G, TURISMO_CREDITOSFACILIDAD F
       WHERE F.IDTURISMO = G.IDTURISMO
         AND G.ESTADOSOLICITUD in ('BT', 'AP')
         AND SUBSTR(F.CUENTAOPERACION, 0, INSTR(F.CUENTAOPERACION, '-') - 1) =
             pn_cta
         AND SUBSTR(F.CUENTAOPERACION,
                    INSTR(F.CUENTAOPERACION, '-') + 1,
                    99) = pn_ope
         AND F.EMPRESA = pn_emp
         AND F.SUCURSAL = pn_suc
         AND F.MODULO = pn_mod
         AND F.MONEDA = pn_mda
         AND F.PAPEL = pn_pap
         AND F.SUBOPERACION = pn_sbo
         AND F.TIPOOPERACION in (select f.tp1nro2
                                   from fst198 f
                                  where f.tp1cod = 1
                                    and f.tp1cod1 = 10899
                                    and f.tp1corr1 = 400000
                                    and f.tp1corr2 = 26
                                    and f.tp1corr3 >= 1);
    
    Exception
      when others then
        pn_tipo := 0;
    END;
  
  exception
    when others then
      pn_tipo := 0;
  end sp_REPROGRAMA_FONDO;

  ---
  procedure sp_obtener_TASAREFI(pn_emp  in number,
                                pn_mod  in number,
                                pn_suc  in number,
                                pn_mda  in number,
                                pn_pap  in number,
                                pn_cta  in number,
                                pn_ope  in number,
                                pn_sbo  in number,
                                pn_top  in number,
                                pn_tasa out number) is
    /* ************************************************************************************************************
        -- Nombre                     : sp_obtener_TASAREFI
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Creditos
        -- Descripción                : retorna TASA de tabla AQPB514 MEMO 18 - REFINANCIADOS
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2024.01.19
        -- Autor de Creación          : DCASTRO
        -- Fecha de Modificación      : -
        -- Autor de Modificación      : -
        -- Descripción Modificación   : -
    
    * *************************************************************************************************************/
  
    ln_instancia number;
    ln_emp       number;
    ln_mod       number;
    ln_suc       number;
    ln_mda       number;
    ln_pap       number;
    ln_cta       number;
    ln_ope       number;
    ln_sbo       number;
    ln_top       number;
    ln_tasa      number;
  
  begin
    pn_tasa := 0;
  
    ln_emp := pn_emp;
    ln_suc := pn_suc;
    ln_mod := pn_mod;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_cta := pn_cta;
    ln_ope := pn_ope;
    ln_sbo := pn_sbo;
    ln_top := pn_top;
  
    ---busca los datos en tabla de REFINACIADOS - MEMO 18
    begin
      select a.aqpd154tredu
        into ln_tasa
        from AQPD154 a
       where aqpd154emp = ln_emp
         and aqpd154mod = ln_mod
         and aqpd154suc = ln_suc
         and aqpd154mda = ln_mda
         and aqpd154pap = ln_pap
         and aqpd154cta = ln_cta
         and aqpd154ope = ln_ope
         and aqpd154sbop = ln_sbo
         and aqpd154tope = ln_top
         and aqpd154estreg = 'P'; --- Estado P - procesado
    exception
      when others then
        ln_tasa := 0;
    end;
  
    pn_tasa := ln_tasa;
  
  exception
    when others then
      null;
  end sp_obtener_TASAREFI;

---------------------------------------------
  procedure sp_obtener_TASACREDINKA(pn_emp  in number,
                                    pn_mod  in number,
                                    pn_suc  in number,
                                    pn_mda  in number,
                                    pn_pap  in number,
                                    pn_cta  in number,
                                    pn_ope  in number,
                                    pn_sbo  in number,
                                    pn_top  in number,
                                    pn_tasa out number) is
    /* ************************************************************************************************************
        -- Nombre                     : sp_obtener_TASACREDINKA
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Creditos
        -- Descripción                : retorna TASA de tabla AQPB837 - clientes credinka
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2024.10.18
        -- Autor de Creación          : DCASTRO
        -- Fecha de Modificación      : 2024.10.25
        -- Autor de Modificación      : DCASTRO
        -- Descripción Modificación   : Se agrego guia de excepcion para retorno de tasa 10847 -1000
        ----                          : 2024.10.29 dcastro se modifico nvl en ln_tasa     
    * *************************************************************************************************************/


  
    ln_instancia number;
    ln_emp       number;
    ln_mod       number;
    ln_suc       number;
    ln_mda       number;
    ln_pap       number;
    ln_cta       number;
    ln_ope       number;
    ln_sbo       number;
    ln_top       number;
    ln_tasa      number;
    ld_fecha     date;
    ln_excepcion number;
  
  begin
    pn_tasa := 0;
  
    ln_emp := pn_emp;
    ln_suc := pn_suc;
    ln_mod := pn_mod;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_cta := pn_cta;
    ln_ope := pn_ope;
    ln_sbo := pn_sbo;
    ln_top := pn_top;
    
    ---obtiene maxima fecha cargada
    begin
    select to_date(TP1DESC, 'DD/MM/YYYY')
      into ld_fecha
      from fst198 f
     where f.tp1cod = 1
       and f.tp1cod1 = 10847
       and f.tp1corr1 = 906
       and f.tp1corr2 = 1;
    exception when others then
         ld_fecha := null;
    end;

    ---obtener instancia
   begin
      select x.xwfprcins
          into ln_instancia   
         from xwf700 x
       where 
             x.xwfempresa  =  pn_emp
         and x.xwfsucursal =  pn_suc
         and x.xwfmodulo   =  pn_mod
         and x.xwfmoneda   =  pn_mda
         and x.xwfpapel    =  pn_pap
         and x.xwfcuenta   =  pn_cta
         and x.xwfoperacion =  pn_ope
         and x.xwfsubope    =  pn_sbo
         and x.xwftipope    =  pn_top
         and x.xwfcar3 = '1';
    exception when others then 
       ln_instancia := 0;
    end;
    ---
    
    --valida si existe en guia de excepcion, no retorna tasa
    ln_excepcion := 0;
    begin
         select count(1)
            into ln_excepcion
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10847
             and f.tp1corr1 = 1000 
             and f.tp1corr2 = 1
             and f.tp1nro1 = ln_instancia;
    exception  when others then
      ln_excepcion := 0;
    end;
    ln_tasa := 0;
    
    if ln_excepcion = 0 then --si es mayor a 0(existe en guia) no debe retornar tasa
      
        ---retorna minima tasa de AQPB837, de los integrante de la instancia
        begin
         select min(AQPB837IMP5)
           into ln_tasa
           from FSR008 f, AQPB837 a
          where f.pgcod = 1
            and f.pendoc = a.aqpb837ndoc
            and f.ctnro = ln_cta
            and a.AQPB837EST = 'S'
            and a.aqpb837fec = ld_fecha
            and a.aqpb837mto2 = 2--; --no compartido
            and not exists (
                    select 1 from aqpd402 g, aqpd403 h
                    where g.aqpd402freg = h.aqpd403freg 
                    and g.aqpd402ureg = h.aqpd403ureg 
                    and g.aqpd402hreg = h.aqpd403hreg
                    and g.aqpd402est = 'S'  
                    and h.aqpd403ncrd = a.aqpb837var5
                    );
        exception
          when others then
            ln_tasa := 0;
        end;
    
    end if;    
    pn_tasa := nvl(ln_tasa, 0);
  
  exception
    when others then
      null;
  end sp_obtener_TASACREDINKA;
  -------------------------------------
  
 ---------------------------------------------
  procedure sp_retorna_Tasa(        pn_instancia in number,
                                    pn_cuenta  in number,
                                    pc_indicador out varchar2) is
    /* ************************************************************************************************************
        -- Nombre                     : sp_retorna_Tasa
        -- Sistema                    : BANTOTAL
        -- Módulo                     : Creditos
        -- Descripción                : retorna TASA de tabla AQPB837 - clientes credinka
        -- Versión                    : 1.0
        -- Fecha de Creación          : 2024.10.18
        -- Autor de Creación          : DCASTRO
        -- Fecha de Modificación      : 2024.10.25
        -- Autor de Modificación      : DCASTRO
        -- Descripción Modificación   : Se agregó condicion de consulta en guia de excepcion
    
    * *************************************************************************************************************/


    ld_fecha     date;
    ln_cont      number;
    ln_excepcion number;
  
  begin
   
    
    ---obtiene maxima fecha cargada
    begin
    select to_date(TP1DESC, 'DD/MM/YYYY')
      into ld_fecha
      from fst198 f
     where f.tp1cod = 1
       and f.tp1cod1 = 10847
       and f.tp1corr1 = 906
       and f.tp1corr2 = 1;
    exception when others then
         ld_fecha := null;
    end;

    ---retorna indicador AQPB837, de los integrante de la instancia
    begin
     select count(1) 
       into ln_cont
       from FSR008 f, AQPB837 a
      where f.pgcod = 1
        and f.pendoc = a.aqpb837ndoc
        and f.ctnro = pn_cuenta
        and a.AQPB837EST = 'S'
        and a.aqpb837fec = ld_fecha
        and a.aqpb837mto2 = 2 --no compartido
        and not exists (
            select 1 from aqpd402 g, aqpd403 h
            where g.aqpd402freg = h.aqpd403freg 
            and g.aqpd402ureg = h.aqpd403ureg 
            and g.aqpd402hreg = h.aqpd403hreg
            and g.aqpd402est = 'S'  
            and h.aqpd403ncrd = a.aqpb837var5
            );
    exception
      when others then
        ln_cont := 0;
    end;
  
   if ln_cont >= 1 then
      pc_indicador := 'S';
      
        ln_excepcion := 0;
        begin
             select count(1)
                into ln_excepcion
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10847
                 and f.tp1corr1 = 1000 
                 and f.tp1corr2 = 1
                 and f.tp1nro1 = pn_instancia;
        exception  when others then
          ln_excepcion := 0;
        end;
        if ln_excepcion > 0 then
            pc_indicador := 'N';
        end if;
   else
      pc_indicador := 'N'; 
   end if; 
  
  exception
    when others then
      null;
  end sp_retorna_Tasa; 
-------------------------------------------------------------------
-----------------------------------------------------------
end pq_cr_funciones_cho;
/

