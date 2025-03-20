create or replace package pq_cr_control_criesgos is

  -- Author  : CHERNANDEZ
  -- Created : 17/10/2019 10:41:55 a.m.
  -- Purpose : Control Acceso Central Riesgos

  /* ************************************************************************************************************
     -- Nombre                     : pq_cr_control_criesgos
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Activas
     -- Descripción                : Control Acceso Central Riesgos Huella Interna
     -- Versión                    : 1.0
     -- Fecha de Creación          : 17/10/2019
     -- Autor de Creación          : Cinthya Liz Hernandez Ortega
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 29/11/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: Se corrigió el envío de correo al mismo analista del cliente 
                                     cuando se hizo una consulta previa de otro analista.
     -- Fecha de Modificación      : 02/12/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: Se agregó rte para control de cancelación adelantada
     -- Fecha de Modificación      : 23/12/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: Se extendió el tamaño de variable.
     -- Fecha de Modificación      : 06/02/2020
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: Se quitó la comparación con blanco cuando es cts dpf
  * *************************************************************************************************************/

  procedure sp_valida_usuario(pv_usua varchar2, pn_rpta out number);
  procedure sp_valida_cartera(pn_pais   number,
                              pn_tdoc   number,
                              pv_ndoc   varchar2,
                              pd_fecpro date,
                              pv_ases   varchar2,
                              pn_canal  number,
                              pv_tipo   varchar2,
                              pn_rpta   out number);
                              
  procedure sp_valida_cartera_l(pn_pais   number,
                              pn_tdoc   number,
                              pv_ndoc   varchar2,
                              pd_fecpro date,
                              pv_ases   varchar2,
                              pn_canal  number,
                              pv_tipo   varchar2,
                              pn_rpta   out number);
                                                          
  procedure sp_genera_log(pn_pais   number,
                          pn_tdoc   number,
                          pv_ndoc   varchar2,
                          pd_fecpro date,
                          pv_usua   varchar2,
                          pv_tipo   varchar2,
                          pn_canal  number,
                          pn_tipCon varchar2,
                          pv_esta   varchar2);
  procedure sp_envio_correo(pn_pais    number,
                            pn_tdoc    number,
                            pc_ndoc    character,
                            pd_fecpro  date,
                            pv_usucon  varchar2,
                            pv_agencia varchar2);
  function fn_obt_analista(pn_vuelta number,
                           pn_correl number,
                           v_Scmod   in number,
                           v_Scsuc   in number,
                           v_Scmda   in number,
                           v_Scpap   in number,
                           v_Sccta   in number,
                           v_Scoper  in number,
                           v_Scsbop  in number,
                           v_Sctope  in number) return varchar2;
  function fn_tiene_garantiadpfcts(pn_instancia number) return number;
  function fn_valida_reemplazo(pc_usucon character, pc_usucli character)
    return number;
  procedure sp_valida_misti(pv_usua   varchar2,
                            pn_pais   number,
                            pn_tdoc   number,
                            pv_ndoc   varchar2,
                            pn_canal  number,
                            pv_tipCon varchar2,
                            pn_crpt   out varchar2,
                            pn_rpta   out varchar2);
  procedure sp_genera_logmisti(pv_usua   varchar2,
                               pn_pais   number,
                               pn_tdoc   number,
                               pv_ndoc   varchar2,
                               pn_canal  number,
                               pv_tipCon varchar2,
                               pv_esta   varchar2,
                               pn_crpt   out varchar2,
                               pn_rpta   out varchar2);
  procedure sp_cancelacion_adelantada(pn_pgcod  number,
                                      pn_ITSUC  number,
                                      pn_ITMOD  number,
                                      pn_ITTRAN number,
                                      pn_ITNREL number,
                                      pd_fecope date);
  procedure sp_envio_correo_cancelacion(pn_analista char,
                                        pv_inicio   varchar2,
                                        pv_linea    varchar2);
  procedure sp_ver_log(BL_DATOS IN OUT SYS_REFCURSOR,
                       pv_usua  varchar2,
                       pn_crpt  out varchar2,
                       pn_rpta  out varchar2);
  function fn_valida_cargo(VE_usuario varchar,ve_sucursal number) return number;                       
end pq_cr_control_criesgos;
/

create or replace package body pq_cr_control_criesgos is

  /*--------------------*/
  procedure sp_valida_usuario(pv_usua varchar2, pn_rpta out number) is
    pc_usua character(10);
  begin
    pc_usua := pv_usua;
    select count(*)
      into pn_rpta
      from SNG057
     where sng057usr = pc_usua
       and sng055car in (select tp1nro1
                           from fst198
                          where tp1cod = 1
                            and tp1cod1 = 11105
                            and tp1corr1 = 28
                            and tp1corr2 = 2
                            and tp1corr3 > 0);
  
  end sp_valida_usuario;

  /*--------------------*/
  procedure sp_valida_cartera(pn_pais   number,
                              pn_tdoc   number,
                              pv_ndoc   varchar2,
                              pd_fecpro date,
                              pv_ases   varchar2,
                              pn_canal  number,
                              pv_tipo   varchar2,
                              pn_rpta   out number) is
    cursor cuentas(pnc_pais number, pnc_tdoc number, pcc_ndoc character) is
      select pgcod, ctnro
        from fsr008
       where pepais = pnc_pais
         and petdoc = pnc_tdoc
         and pendoc = pcc_ndoc;
  
    cursor conyuge(pnc_pais number, pnc_tdoc number, pcc_ndoc character) is
      select rppais, rptdoc, rpndoc
        from fsr002
       where pepais = pnc_pais
         and petdoc = pnc_tdoc
         and pendoc = pcc_ndoc
         and rpccyg = 66
      union
      select pepais, petdoc, pendoc
        from fsr002
       where rppais = pnc_pais
         and rptdoc = pnc_tdoc
         and rpndoc = pcc_ndoc
         and rpccyg = 66;
  
    cursor cred_vigentes(ln_pgcod number, ln_cuenta number) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = ln_pgcod
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (116, 108)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99;
         --and d10.aofvto >= pd_fecpro; --ecollado 14/06/2022
  
    lc_ndoc     character(12);
    lc_analista character(10); --bk
    lc_aseing   character(10); --analista que consulta
    lc_analcli  character(10); --analista del cliente
    lc_empty    character(10); --analista del cliente validacion limpia
    ln_codcorr  number(9);
    ln_vuelta   number(9);
    ln_correl   number(9);
    lc_hora     character(8);
    ln_flag     number(2);
    ln_rpttit   number(1);
    ln_rptcyg   number(1);
    vi_acceso_cargo number(1);
    vi_acceso_cargoc number(1);
    --ve_sucursal_usuario character(10);
    --ve_sucursal_cliente character(10);
  begin
    lc_ndoc    := pv_ndoc;
    lc_aseing  := pv_ases;
    lc_analcli := '';
    lc_empty   := '';
    ln_codcorr := 1;
    ln_flag    := 0;
    --insert into prueba_log(pgcod,msg)values(180,to_char(pn_pais)||'-'||to_char(pn_tdoc)||'-'||pv_ndoc||'-'||to_char(pd_fecpro,'dd/mm/yyyy')||'-'||pv_ases||'-'||to_char(pn_canal)||'-'||pv_tipo);
    
    sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
    select to_char(sysdate, 'HH24:Mi:SS') into lc_hora from dual;
    /*select ubsuc into ve_sucursal_usuario from fst046 where pgcod = 1 and ubuser = 'SCRE0204';
    select distinct d10.aosuc ln_suc10 into ve_sucursal_cliente
       from fsd010 d10
      where d10.Pgcod = 1
        and d10.Aocta = 1413045
        and (d10.Aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (116, 108)) or
            d10.Aomod = 117)
        and d10.Aostat <> 99;*/
      
    --titular
    vi_acceso_cargo := 0;
    begin
      for i in cuentas(pn_pais, pn_tdoc, lc_ndoc) loop
        for j in cred_vigentes(i.pgcod, i.ctnro) loop
          lc_analista := pq_cr_control_criesgos.fn_obt_analista(ln_vuelta,
                                                                ln_correl,
                                                                j.ln_mod10,
                                                                j.ln_suc10,
                                                                j.ln_mda10,
                                                                j.ln_pap10,
                                                                j.ln_cta10,
                                                                j.ln_oper10,
                                                                j.ln_sbop10,
                                                                j.ln_tope10);
          If ln_flag = 0 then
            lc_analcli := lc_analista;
            ln_flag    := 1;
          end if;
          If lc_analista is null then
            lc_analista := lc_analcli;
          end If;
          --chernandez 06/02/2020
          if lc_analista <> lc_analcli and lc_analista <> lc_empty then
            lc_analcli := 'ERROR';
          end if;
          
          if  pq_cr_control_criesgos.fn_valida_cargo(pv_ases,j.ln_suc10) >= 1 then
              vi_acceso_cargo := 1;
          end if; 
        end loop;
      end loop;
      If lc_aseing = lc_analcli or lc_analcli is null or
         lc_analcli = lc_empty  then
        ln_rpttit := 1; --si es su cartera
      else
        
        if pq_cr_control_criesgos.fn_valida_reemplazo(lc_aseing, lc_analcli) >= 1 then
          ln_rpttit := 1; --es reemplazo
        else
          ln_rpttit := 0; --no es su cartera ni reemplazo
          --validar perfiles
           --   ln_rpttit := 1; --deacuerdo a cargo estadentro de su rango
          /*else
              ln_rpttit := 0; --de acuerdo a cargo tampoco esta en su rango
          */
          
        end if;      
      end if;
      if vi_acceso_cargo = 1 then
          ln_rpttit := 1; --esta dentro del rango del cargo;
      end if;  
    exception
      when others then
        null;
    end;
  
    begin
    
      insert into aqpa026
        (aqpa026vlta,
         aqpa026corr,
         aqpa026fech,
         aqpa026hora,
         aqpa026pais,
         aqpa026tdo,
         aqpa026ndoc,
         aqpa026anco,
         aqpa026ancl,
         AQPA026Canal,
         AQPA026TIPO,
         AQPA026TCON,
         aqpa026rpta)
      values
        (ln_vuelta,
         ln_correl,
         pd_fecpro,
         lc_hora,
         pn_pais,
         pn_tdoc,
         lc_ndoc,
         lc_aseing,
         lc_analcli,
         pn_canal,
         'T',
         pv_tipo,
         ln_rpttit);
      commit;
    exception
      when others then
        null;
    end;
  
    --conyuge
    --inicializamos
    ln_rptcyg  := 1;
    lc_analcli := '';
    ln_flag    := 0;
  
    begin
      for k in conyuge(pn_pais, pn_tdoc, lc_ndoc) loop
        sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
        for i in cuentas(k.rppais, k.rptdoc, k.rpndoc) loop
          for j in cred_vigentes(i.pgcod, i.ctnro) loop
            lc_analista := pq_cr_control_criesgos.fn_obt_analista(ln_vuelta,
                                                                  ln_correl,
                                                                  j.ln_mod10,
                                                                  j.ln_suc10,
                                                                  j.ln_mda10,
                                                                  j.ln_pap10,
                                                                  j.ln_cta10,
                                                                  j.ln_oper10,
                                                                  j.ln_sbop10,
                                                                  j.ln_tope10);
            If ln_flag = 0 then
              lc_analcli := lc_analista;
              ln_flag    := 1;
            end if;
            
            
            If lc_analista is null then
              lc_analista := lc_analcli;
            end If;
            --chernandez 06/02/2020
            if lc_analista <> lc_analcli and lc_analista <> lc_empty then
              lc_analcli := 'ERROR';
            end if;
            if  pq_cr_control_criesgos.fn_valida_cargo(pv_ases,j.ln_suc10) >= 1 then
              vi_acceso_cargoc := 1;
            end if;
          end loop;
        end loop;
      
        If lc_aseing = lc_analcli or lc_analcli is null or
           lc_analcli = lc_empty then
           ln_rptcyg := 1; --si es su cartera
        else         
            ln_rptcyg := 0; --no es su cartera ni reemplazo
        end if;
        if vi_acceso_cargoc = 1 then
          ln_rptcyg := 1; --esta dentro del rango del cargo;
        end if;  
      
      
        begin
        
          insert into aqpa026
            (aqpa026vlta,
             aqpa026corr,
             aqpa026fech,
             aqpa026hora,
             aqpa026pais,
             aqpa026tdo,
             aqpa026ndoc,
             aqpa026anco,
             aqpa026ancl,
             AQPA026Canal,
             AQPA026TIPO,
             AQPA026TCON,
             aqpa026rpta)
          values
            (ln_vuelta,
             ln_correl,
             pd_fecpro,
             lc_hora,
             k.rppais,
             k.rptdoc,
             k.rpndoc,
             lc_aseing,
             lc_analcli,
             pn_canal,
             'C',
             pv_tipo,
             ln_rptcyg);
          commit;
        exception
          when others then
            null;
        end;
      
      end loop;
    
    exception
      when others then
        null;
    end;
    if ln_rpttit = 1 and ln_rptcyg = 1 then
      pn_rpta := 1;
    else
      pn_rpta := 0;
    end if;
    
  end sp_valida_cartera;

procedure sp_valida_cartera_l(pn_pais   number,
                              pn_tdoc   number,
                              pv_ndoc   varchar2,
                              pd_fecpro date,
                              pv_ases   varchar2,
                              pn_canal  number,
                              pv_tipo   varchar2,
                              pn_rpta   out number) is
    cursor cuentas(pnc_pais number, pnc_tdoc number, pcc_ndoc character) is
      select pgcod, ctnro
        from fsr008
       where pepais = pnc_pais
         and petdoc = pnc_tdoc
         and pendoc = pcc_ndoc;
  
    cursor conyuge(pnc_pais number, pnc_tdoc number, pcc_ndoc character) is
      select rppais, rptdoc, rpndoc
        from fsr002
       where pepais = pnc_pais
         and petdoc = pnc_tdoc
         and pendoc = pcc_ndoc
         and rpccyg = 66
      union
      select pepais, petdoc, pendoc
        from fsr002
       where rppais = pnc_pais
         and rptdoc = pnc_tdoc
         and rpndoc = pcc_ndoc
         and rpccyg = 66;
  
    cursor cred_vigentes(ln_pgcod number, ln_cuenta number) is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = ln_pgcod
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (116, 108)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99;
         --and d10.aofvto >= pd_fecpro; --ecollado 14/06/2022
  
    lc_ndoc     character(12);
    lc_analista character(10); --bk
    lc_aseing   character(10); --analista que consulta
    lc_analcli  character(10); --analista del cliente
    lc_empty    character(10); --analista del cliente validacion limpia
    ln_codcorr  number(9);
    ln_vuelta   number(9);
    ln_correl   number(9);
    lc_hora     character(8);
    ln_flag     number(2);
    ln_rpttit   number(1);
    ln_rptcyg   number(1);
    vi_acceso_cargo number(1);
    vi_acceso_cargoc number(1);
    
  begin
    lc_ndoc    := pv_ndoc;
    lc_aseing  := pv_ases;
    lc_analcli := '';
    lc_empty   := '';
    ln_codcorr := 1;
    ln_flag    := 0;
    sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
    select to_char(sysdate, 'HH24:Mi:SS') into lc_hora from dual;
    --titular
    begin
      for i in cuentas(pn_pais, pn_tdoc, lc_ndoc) loop
        for j in cred_vigentes(i.pgcod, i.ctnro) loop
          lc_analista := pq_cr_control_criesgos.fn_obt_analista(ln_vuelta,
                                                                ln_correl,
                                                                j.ln_mod10,
                                                                j.ln_suc10,
                                                                j.ln_mda10,
                                                                j.ln_pap10,
                                                                j.ln_cta10,
                                                                j.ln_oper10,
                                                                j.ln_sbop10,
                                                                j.ln_tope10);
          If ln_flag = 0 then
            lc_analcli := lc_analista;
            ln_flag    := 1;
          end if;
          If lc_analista is null then
            lc_analista := lc_analcli;
          end If;
          --chernandez 06/02/2020
          if lc_analista <> lc_analcli and lc_analista <> lc_empty then
            lc_analcli := 'ERROR';
          end if;
          if  pq_cr_control_criesgos.fn_valida_cargo(pv_ases,j.ln_suc10) >= 1 then
              vi_acceso_cargo := 1;
          end if;
        end loop;
      end loop;
      If lc_aseing = lc_analcli or lc_analcli is null or
         lc_analcli = lc_empty then
        ln_rpttit := 1; --si es su cartera
      else
        if pq_cr_control_criesgos.fn_valida_reemplazo(lc_aseing, lc_analcli) >= 1 then
          ln_rpttit := 1; --es reemplazo
        else
          ln_rpttit := 0; --no es su cartera ni reemplazo
        end if;
      
      end if;
      if vi_acceso_cargo = 1 then
          ln_rpttit := 1; --esta dentro del rango del cargo;
      end if; 
    exception
      when others then
        null;
    end;
  
    /*begin
    
      insert into aqpa026
        (aqpa026vlta,
         aqpa026corr,
         aqpa026fech,
         aqpa026hora,
         aqpa026pais,
         aqpa026tdo,
         aqpa026ndoc,
         aqpa026anco,
         aqpa026ancl,
         AQPA026Canal,
         AQPA026TIPO,
         AQPA026TCON,
         aqpa026rpta)
      values
        (ln_vuelta,
         ln_correl,
         pd_fecpro,
         lc_hora,
         pn_pais,
         pn_tdoc,
         lc_ndoc,
         lc_aseing,
         lc_analcli,
         pn_canal,
         'T',
         pv_tipo,
         ln_rpttit);
      commit;
    exception
      when others then
        null;
    end;*/
  
    --conyuge
    --inicializamos
    ln_rptcyg  := 1;
    lc_analcli := '';
    ln_flag    := 0;
  
    begin
      for k in conyuge(pn_pais, pn_tdoc, lc_ndoc) loop
        sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
        for i in cuentas(k.rppais, k.rptdoc, k.rpndoc) loop
          for j in cred_vigentes(i.pgcod, i.ctnro) loop
            lc_analista := pq_cr_control_criesgos.fn_obt_analista(ln_vuelta,
                                                                  ln_correl,
                                                                  j.ln_mod10,
                                                                  j.ln_suc10,
                                                                  j.ln_mda10,
                                                                  j.ln_pap10,
                                                                  j.ln_cta10,
                                                                  j.ln_oper10,
                                                                  j.ln_sbop10,
                                                                  j.ln_tope10);
            If ln_flag = 0 then
              lc_analcli := lc_analista;
              ln_flag    := 1;
            end if;
            If lc_analista is null then
              lc_analista := lc_analcli;
            end If;
            --chernandez 06/02/2020
            if lc_analista <> lc_analcli and lc_analista <> lc_empty then
              lc_analcli := 'ERROR';
            end if;
            if  pq_cr_control_criesgos.fn_valida_cargo(pv_ases,j.ln_suc10) >= 1 then
              vi_acceso_cargoc := 1;
          end if;
          end loop;
        end loop;
      
        If lc_aseing = lc_analcli or lc_analcli is null or
           lc_analcli = lc_empty then
          ln_rptcyg := 1; --si es su cartera
        else
          if pq_cr_control_criesgos.fn_valida_reemplazo(lc_aseing,
                                                        lc_analcli) >= 1 then
            ln_rptcyg := 1; --es reemplazo
          else
            ln_rptcyg := 0; --no es su cartera ni reemplazo
          end if;
        end if;
        if vi_acceso_cargoc = 1 then
          ln_rptcyg := 1; --esta dentro del rango del cargo;
        end if; 
      
        /*begin
        
          insert into aqpa026
            (aqpa026vlta,
             aqpa026corr,
             aqpa026fech,
             aqpa026hora,
             aqpa026pais,
             aqpa026tdo,
             aqpa026ndoc,
             aqpa026anco,
             aqpa026ancl,
             AQPA026Canal,
             AQPA026TIPO,
             AQPA026TCON,
             aqpa026rpta)
          values
            (ln_vuelta,
             ln_correl,
             pd_fecpro,
             lc_hora,
             k.rppais,
             k.rptdoc,
             k.rpndoc,
             lc_aseing,
             lc_analcli,
             pn_canal,
             'C',
             pv_tipo,
             ln_rptcyg);
          commit;
        exception
          when others then
            null;
        end;*/
      
      end loop;
    
    exception
      when others then
        null;
    end;
    if ln_rpttit = 1 and ln_rptcyg = 1 then
      pn_rpta := 1;
    else
      pn_rpta := 0;
    end if;
  
  end sp_valida_cartera_l;

  /*--------------------*/
  procedure sp_genera_log(pn_pais   number,
                          pn_tdoc   number,
                          pv_ndoc   varchar2,
                          pd_fecpro date,
                          pv_usua   varchar2,
                          pv_tipo   varchar2,
                          pn_canal  number,
                          pn_tipCon varchar2,
                          pv_esta   varchar2) is
    cursor titular(pcc_ndoc character) is
      select *
        from (select *
                from aqpa026
               where aqpa026pais = pn_pais
                 and aqpa026tdo = pn_tdoc
                 and aqpa026ndoc = pcc_ndoc
                 and aqpa026fech = pd_fecpro
                 and AQPA026TIPO = 'T'
              --and aqpa026rpta = 0
               order by aqpa026vlta desc, aqpa026corr desc) a
      
       where rownum = 1;
  
    cursor conyuge(pcc_ndoc character) is
      select *
      
        from (select *
                from aqpa026
               where (aqpa026pais, aqpa026tdo, aqpa026ndoc) in
                     (select rppais, rptdoc, rpndoc
                        from fsr002
                       where pepais = pn_pais
                         and petdoc = pn_tdoc
                         and pendoc = pcc_ndoc
                         and rpccyg = 66
                      union
                      select pepais, petdoc, pendoc
                        from fsr002
                       where rppais = pn_pais
                         and rptdoc = pn_tdoc
                         and rpndoc = pcc_ndoc
                         and rpccyg = 66)
                    
                 and aqpa026fech = pd_fecpro
                 and AQPA026TIPO = 'C'
              --and aqpa026rpta = 0
               order by aqpa026vlta desc, aqpa026corr desc) a
      
       where rownum = 1;
  
    pc_usua    character(10);
    ln_codcorr number(9);
    ln_vuelta  number(9);
    ln_correl  number(9);
    lc_hora    character(8);
    ln_sucur   number(3);
    lc_ndoc    character(12);
    lv_usua    varchar(30);
    lv_agen    varchar(30);
    lv_esta    varchar(1);
  
  begin
    pc_usua    := pv_usua;
    ln_codcorr := 2;
    lc_ndoc    := pv_ndoc;
  
    select to_char(sysdate, 'HH24:Mi:SS') into lc_hora from dual;
  
    begin
      SELECT ubsuc
        into ln_sucur
        FROM FST046
       where pgcod = 1
         and ubuser = pc_usua;
    
    exception
      when others then
        ln_sucur := 0;
      
    end;
  
    for j in titular(lc_ndoc) loop
    
      sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
    
      If j.aqpa026rpta = 0 then
        lv_esta := 'V';
      else
        lv_esta := 'N';
      End if;
      begin
        insert into AQPA026L
          (aqpa026lvlta,
           aqpa026lcorr,
           aqpa026lpais,
           aqpa026ltdoc,
           aqpa026lndoc,
           aqpa026lfecha,
           aqpa026lhora,
           aqpa026ltipo,
           aqpa026lusua,
           aqpa026lcana,
           aqpa026ltcon,
           aqpa026lesta,
           aqpa026lagen)
        values
          (ln_vuelta,
           ln_correl,
           j.aqpa026pais,
           j.aqpa026tdo,
           j.aqpa026ndoc,
           pd_fecpro,
           lc_hora,
           'T',
           pc_usua,
           pn_canal,
           pn_tipCon,
           lv_esta,
           ln_sucur);
        commit;
      exception
        when others then
          null;
      end;
    end loop;
  
    for k in conyuge(lc_ndoc) loop
    
      sp_cr_genera_correlativo(ln_codcorr, ln_vuelta, ln_correl);
    
      If k.aqpa026rpta = 0 then
        lv_esta := 'V';
      else
        lv_esta := 'N';
      End if;
      begin
        insert into AQPA026L
          (aqpa026lvlta,
           aqpa026lcorr,
           aqpa026lpais,
           aqpa026ltdoc,
           aqpa026lndoc,
           aqpa026lfecha,
           aqpa026lhora,
           aqpa026ltipo,
           aqpa026lusua,
           aqpa026lcana,
           aqpa026ltcon,
           aqpa026lesta,
           aqpa026lagen)
        values
          (ln_vuelta,
           ln_correl,
           k.aqpa026pais,
           k.aqpa026tdo,
           k.aqpa026ndoc,
           pd_fecpro,
           lc_hora,
           'C',
           pc_usua,
           pn_canal,
           pn_tipCon,
           lv_esta,
           ln_sucur);
        commit;
      exception
        when others then
          null;
      end;
    end loop;
  
    begin
    
      begin
        select ubnom
          into lv_usua
          from fst746
         where pgcodac = 1
           and ubuser = pc_usua;
      exception
        when others then
          lv_usua := '';
      end;
    
      begin
        select scnom
          into lv_agen
          from fst001
         where pgcod = 1
           and sucurs = ln_sucur;
      exception
        when others then
          lv_agen := '';
      end;
    
      sp_envio_correo(pn_pais,
                      pn_tdoc,
                      lc_ndoc,
                      pd_fecpro,
                      lv_usua,
                      lv_agen);
    
    exception
      when others then
        null;
    end;
  
  end sp_genera_log;

  /*--------------------*/
  procedure sp_envio_correo(pn_pais    number,
                            pn_tdoc    number,
                            pc_ndoc    character,
                            pd_fecpro  date,
                            pv_usucon  varchar2,
                            pv_agencia varchar2) is
    vi_correoa varchar(40); --CAMBIAR A 40    
  cod_error varchar2(20);
  cod_des varchar2(500);
    cursor analistas is
      select trim(aqpa026danal) || '@cajaarequipa.pe' correo,
            aqpa026danal analista,
             vv.aqpa026pais,
             vv.aqpa026tdo,
             vv.aqpa026ndoc,
             case
               when vv.aqpa026tipo = 'T' then
                'titular'
               else
                'cónyuge'
             end tipo
        from aqpa026d dd, aqpa026 vv
       where dd.aqpa026dvlta = vv.aqpa026vlta
         and dd.aqpa026dcorr = vv.aqpa026corr
            
         and (aqpa026dvlta, aqpa026dcorr) in
             (select *
                from (select aqpa026vlta, aqpa026corr
                        from aqpa026
                       where aqpa026pais = pn_pais
                         and aqpa026tdo = pn_tdoc
                         and aqpa026ndoc = pc_ndoc
                         and aqpa026fech = pd_fecpro
                         and AQPA026TIPO = 'T'
                      --and aqpa026rpta = 0
                       order by aqpa026vlta desc, aqpa026corr desc) a
              
               where rownum = 1)
         and vv.aqpa026rpta = 0
      union
      
      select trim(aqpa026danal) || '@cajaarequipa.pe' correo,
             aqpa026danal analista,
             vv.aqpa026pais,
             vv.aqpa026tdo,
             vv.aqpa026ndoc,
             case
               when vv.aqpa026tipo = 'T' then
                'titular'
               else
                'cónyuge'
             end tipo
        from aqpa026d dd, aqpa026 vv
       where dd.aqpa026dvlta = vv.aqpa026vlta
         and dd.aqpa026dcorr = vv.aqpa026corr
            
         and (aqpa026dvlta, aqpa026dcorr) in
             (select *
                from (select aqpa026vlta, aqpa026corr
                        from aqpa026
                       where (aqpa026pais, aqpa026tdo, aqpa026ndoc) in
                             (select rppais, rptdoc, rpndoc
                                from fsr002
                               where pepais = pn_pais
                                 and petdoc = pn_tdoc
                                 and pendoc = pc_ndoc
                                 and rpccyg = 66
                              union
                              select pepais, petdoc, pendoc
                                from fsr002
                               where rppais = pn_pais
                                 and rptdoc = pn_tdoc
                                 and rpndoc = pc_ndoc
                                 and rpccyg = 66)
                         and aqpa026fech = pd_fecpro
                         and AQPA026TIPO = 'C'
                      --and aqpa026rpta = 0
                       order by aqpa026vlta desc, aqpa026corr desc) a
               where rownum = 1)
         and vv.aqpa026rpta = 0;
  
    lv_remitente varchar2(50);
    lv_mensaje   VARCHAR2(2000);
    lv_clie      varchar(30);
  begin
    begin
      select trim(tp1desc)
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := lv_remitente || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
    for i in analistas loop
      begin
          select w.wfusremail
          into vi_correoa from WFUSERS W
          WHERE W.WFUSRCOD = i.analista;
      exception
        when others then
             vi_correoa := ''; 
      end;
      begin
        select penom
          into lv_clie
          from fsd001
         where pepais = i.aqpa026pais
           and petdoc = i.aqpa026tdo
           and pendoc = i.aqpa026ndoc;
      
      exception
        when others then
          lv_clie := '';
      end;
      lv_mensaje := '<html><head><style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                    '</head><body><br><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>' ||
                    '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'El usuario ' || trim(pv_usucon) || ' de la agencia ' ||
                    trim(pv_agencia) || ' realizó una consulta como ' ||
                    i.tipo || ' a la información del cliente ' ||
                    trim(lv_clie) || ' con documento ' ||
                    trim(i.aqpa026ndoc) || ' asignado a su cartera.' ||
                    '.</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                    'Saludos</p></body></html>';
      Begin 
          
                pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => vi_correoa,
                                                 p_DestinatariosCC   => '',
                                                 p_DestinatariosBcc  => '' ,
                                                 p_Mensaje           => lv_mensaje,
                                                 p_Remitente         => lv_remitente,
                                                 p_Asunto            => 'Alerta de consulta a su Cartera',
                                                 p_TipoMensaje       => 'HTML',
                                                 p_Directorio        => '',
                                                 p_ArchivosAdjuntos  => '',
                                                 p_c_coderr          => cod_error,--000
                                                 p_c_deserr          => cod_des);  --riesgo
       exception
         when others then
           cod_des := trim(cod_des)||'-'||trim(cod_error)||'-'||trim(sqlerrm);  
                                   
        end;               
    /* 
     sys.sp_sy_enviamail_html(pc_aquien  => i.correo,
                               pc_de      => lv_remitente,
                               pc_motivo  => 'Alerta de consulta a su Cartera',
                               pc_mensaje => lv_mensaje);
                               */
    end loop;
  end sp_envio_correo;

  /*--------------------*/
  function fn_obt_analista(pn_vuelta number,
                           pn_correl number,
                           v_Scmod   in number,
                           v_Scsuc   in number,
                           v_Scmda   in number,
                           v_Scpap   in number,
                           v_Sccta   in number,
                           v_Scoper  in number,
                           v_Scsbop  in number,
                           v_Sctope  in number) return varchar2 is
  
    /*  2015.11.23 DCASTRO Se agrego condicion cuando instancia es 0 y es judicial, castigado - busca en FSR011 */
    /* 2016.06.09 DCASTRO Se agrego condicion cuando instancia es 0 es judicial y proviene de una linea*/
  
    lc_analista  fst046.ubuser%type;
    ln_instancia number(10);
    ln_lote      fpp175.pp174cod%type;
  
  begin
  
    --para prendario nombre del tasador
    if (v_Scmod = 108) then
      begin
        SELECT max(pp174cod)
          into ln_lote
          FROM fpp175 d
         where d.pp175suc = v_Scsuc
           and d.pp175mda = v_Scmda
           and d.pp175pap = v_Scpap
           and d.pp175cta = v_Sccta
           and d.pp175oper = v_Scoper
           and d.pp175sbop = v_Scsbop
           and d.pp175mod = v_Scmod
           and d.pp175tope = v_Sctope;
      exception
        when no_data_found then
          ln_lote := null;
      end;
    
      begin
        select max(substr(pp178dtext, 1, 10))
          into lc_analista
          from fpp178
         where pp174cod = ln_lote
           and pp177codd = 7;
      exception
        when no_data_found then
          lc_analista := null;
      end;
    else
      If v_Scmod = 116 THEN
        Begin
          select max(xw2.xwfprcins)
            into ln_instancia
            From Fsr011 rel
            join xwf700 xw2
              on xw2.xwfempresa = rel.r2cod
             and xw2.xwfmodulo = rel.r2mod
             and xw2.xwfsucursal = rel.r2suc
             and xw2.xwfmoneda = rel.r2mda
             and xw2.xwfpapel = rel.r2pap
             and xw2.xwfcuenta = rel.r2cta
             and xw2.xwfoperacion = rel.r2oper
             and xw2.xwfsubope = rel.r2sbop
             and xw2.xwftipope = rel.r2tope
             and rel.relcod = 46
             and xw2.xwfcar3 = '1'
           where rel.r1cod = 1
             and rel.r1mod = v_Scmod
             and rel.r1suc = v_Scsuc
             and rel.r1mda = v_Scmda
             and rel.r1pap = v_Scpap
             and rel.r1cta = v_Sccta
             and rel.r1oper = v_Scoper
             and rel.r1sbop = v_Scsbop
             and rel.r1tope = v_Sctope;
          If nvl(ln_instancia, 0) = 0 Then
            Begin
              select max(xw2.xwfprcins)
                into ln_instancia
                From Fsr011 rel
                join xwf700 xw2
                  on xw2.xwfempresa = rel.r2cod
                 and xw2.xwfmodulo = rel.r2mod
                 and xw2.xwfsucursal = rel.r2suc
                 and xw2.xwfmoneda = rel.r2mda
                 and xw2.xwfpapel = rel.r2pap
                 and xw2.xwfcuenta = rel.r2cta
                 and xw2.xwfoperacion = rel.r2oper
                 and xw2.xwfsubope = rel.r2sbop
                 and xw2.xwftipope = rel.r2tope
                 and rel.relcod = 46
               where rel.r1cod = 1
                 and rel.r1mod = v_Scmod
                 and rel.r1suc = v_Scsuc
                 and rel.r1mda = v_Scmda
                 and rel.r1pap = v_Scpap
                 and rel.r1cta = v_Sccta
                 and rel.r1oper = v_Scoper
                 and rel.r1tope = v_Sctope;
            End;
          End IF;
        End;
      
      Else
        Begin
          select xw2.xwfprcins
            into ln_instancia
            from xwf700 xw2
           where xw2.xwfempresa = 1
             and xw2.xwfsucursal = v_Scsuc
             and xw2.xwfmodulo = v_Scmod
             and xw2.xwfmoneda = v_Scmda
             and xw2.xwfpapel = v_Scpap
             and xw2.xwfcuenta = v_Sccta
             and xw2.xwfoperacion = v_Scoper
             and xw2.xwfsubope = v_Scsbop
             and xw2.xwftipope = v_Sctope
             and xw2.xwfcar3 = '1';
        Exception
          When Others Then
            If v_Scmod in (200, 33) or v_Sctope = 550 Then
              Begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  from xwf700 xw2
                 where xw2.xwfempresa = 1
                   and xw2.xwfsucursal = v_Scsuc
                   and xw2.xwfmoneda = v_Scmda
                   and xw2.xwfpapel = v_Scpap
                   and xw2.xwfcuenta = v_Sccta
                   and xw2.xwfoperacion = v_Scoper;
              end;
            Else
            
              Begin
                select xw2.xwfprcins
                  into ln_instancia
                  from xwf700 xw2
                 where xw2.xwfempresa = 1
                   and xw2.xwfsucursal = v_Scsuc
                   and xw2.xwfmodulo = v_Scmod
                   and xw2.xwfmoneda = v_Scmda
                   and xw2.xwfpapel = v_Scpap
                   and xw2.xwfcuenta = v_Sccta
                   and xw2.xwfoperacion = v_Scoper
                   and xw2.xwftipope = v_Sctope
                   and xw2.xwfcar3 = '1';
              Exception
                When Others Then
                  begin
                    select max(xw2.xwfprcins)
                      into ln_instancia
                      from xwf700 xw2
                     where xw2.xwfempresa = 1
                       and xw2.xwfsucursal = v_Scsuc
                       and xw2.xwfmodulo = v_Scmod
                       and xw2.xwfmoneda = v_Scmda
                       and xw2.xwfpapel = v_Scpap
                       and xw2.xwfcuenta = v_Sccta
                       and xw2.xwfoperacion = v_Scoper
                       and xw2.xwftipope = v_Sctope
                       and xw2.xwfcar3 = '1';
                  end;
              End;
            End IF;
        End;
      
        --2015.11.23 cuando instancia es 0 verificar si es judicial
        if nvl(ln_instancia, 0) = 0 and v_Scmod in (200, 33) then
          begin
            select max(xw2.xwfprcins)
              into ln_instancia
              From Fsr011 rel
              join xwf700 xw2
                on xw2.xwfempresa = rel.r2cod
               and xw2.xwfmodulo = rel.r2mod
               and xw2.xwfsucursal = rel.r2suc
               and xw2.xwfmoneda = rel.r2mda
               and xw2.xwfpapel = rel.r2pap
               and xw2.xwfcuenta = rel.r2cta
               and xw2.xwfoperacion = rel.r2oper
               and xw2.xwfsubope = rel.r2sbop
               and xw2.xwftipope = rel.r2tope
               and rel.relcod = 46
               and xw2.xwfcar3 = '1'
             where rel.r1cod = 1
               and rel.r1mod = v_Scmod
               and rel.r1suc = v_Scsuc
               and rel.r1mda = v_Scmda
               and rel.r1pap = v_Scpap
               and rel.r1cta = v_Sccta
               and rel.r1oper = v_Scoper
               and rel.r1sbop = v_Scsbop
               and rel.r1tope = v_Sctope;
            --2016.08.09        
            if nvl(ln_instancia, 0) = 0 then
              begin
                select max(xw2.xwfprcins)
                  into ln_instancia
                  From Fsr011 rel
                  join xwf700 xw2
                    on xw2.xwfempresa = rel.r2cod
                   and xw2.xwfmodulo = rel.r2mod
                   and xw2.xwfsucursal = rel.r2suc
                   and xw2.xwfmoneda = rel.r2mda
                   and xw2.xwfpapel = rel.r2pap
                   and xw2.xwfcuenta = rel.r2cta
                   and xw2.xwfoperacion = rel.r2oper
                   and xw2.xwfsubope = rel.r2sbop
                   and xw2.xwftipope = rel.r2tope
                   and rel.relcod = 46
                 where rel.r1cod = 1
                   and rel.r1mod = v_Scmod
                   and rel.r1suc = v_Scsuc
                   and rel.r1mda = v_Scmda
                   and rel.r1pap = v_Scpap
                   and rel.r1cta = v_Sccta
                   and rel.r1oper = v_Scoper
                   and rel.r1sbop = v_Scsbop
                   and rel.r1tope = v_Sctope;
              exception
                when no_Data_found then
                  ln_instancia := 0;
              end;
            end if;
          end;
          --2016.08.09   
        
        end if;
        --2015.11.23
      
      End IF;
      if nvl(ln_instancia, 0) = 0 then
        Begin
          select max(xw2.xwfprcins)
            into ln_instancia
            from xwf700 xw2
           where xw2.xwfempresa = 1
             and xw2.xwfsucursal = v_Scsuc
             and xw2.xwfmoneda = v_Scmda
             and xw2.xwfpapel = v_Scpap
             and xw2.xwfcuenta = v_Sccta
             and xw2.xwfoperacion = v_Scoper;
        end;
      end if;
    
      If ln_instancia is not null then
        If fn_tiene_garantiadpfcts(ln_instancia) = 0 then
          Begin
            select sng001ase
              into lc_analista
              from sng001 --Cambiar la tabla para producción
             where sng001inst = ln_instancia;
          Exception
            when no_data_found then
              lc_analista := null;
          end;
        Else
          lc_analista := '';
        End If;
      End If;
    
    end if;
    begin
      insert into aqpa026d
        (AQPA026DVLTA, AQPA026DCORR, AQPA026DINST, AQPA026DANAL)
      values
        (pn_vuelta, pn_correl, ln_instancia, lc_analista);
      commit;
    exception
      when others then
        null;
    end;
    return lc_analista;
  
  end;
  /*--------------------*/
  function fn_tiene_garantiadpfcts(pn_instancia number) return number is
    ln_cant number;
  begin
    select count(*)
      into ln_cant
      from sng122
     where sng122inst = pn_instancia
       and SNG122Tope in (80, 85);
    return ln_cant;
  end;

  /*--------------------*/
  function fn_valida_reemplazo(pc_usucon character, pc_usucli character)
    return number is
    ln_cant number;
  begin
    select count(*)
      into ln_cant
      from SNG057
     where sng057usr = pc_usucli
       and SNG057SUP = pc_usucon;
    return ln_cant;
  end;

  /*--------------------*/
  procedure sp_valida_misti(pv_usua   varchar2,
                            pn_pais   number,
                            pn_tdoc   number,
                            pv_ndoc   varchar2,
                            pn_canal  number,
                            pv_tipCon varchar2,
                            pn_crpt   out varchar2,
                            pn_rpta   out varchar2) is
    ld_fecpro  date;
    ln_respUsu number(5);
    ln_resp    number(5);
  
  begin
    pn_crpt := '00000';
    pn_rpta := '';
    ln_resp := 1;
    pq_cr_control_criesgos.sp_valida_usuario(pv_usua, ln_respUsu);
  
    if ln_respUsu >= 1 then
      select pgfape into ld_fecpro from fst017 where pgcod = 1;
      pq_cr_control_criesgos.sp_valida_cartera(pn_pais,
                                               pn_tdoc,
                                               pv_ndoc,
                                               ld_fecpro,
                                               pv_usua,
                                               pn_canal,
                                               pv_tipCon,
                                               ln_resp);
    
    end if;
    if ln_resp = 0 then
      pn_crpt := '90000';
      select LISTAGG(tp1desc) WITHIN GROUP(ORDER BY tp1corr3)
        into pn_rpta
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 1
         and tp1corr3 > 0;
    end if;
  
  end sp_valida_misti;

  procedure sp_genera_logmisti(pv_usua   varchar2,
                               pn_pais   number,
                               pn_tdoc   number,
                               pv_ndoc   varchar2,
                               pn_canal  number,
                               pv_tipCon varchar2,
                               pv_esta   varchar2,
                               pn_crpt   out varchar2,
                               pn_rpta   out varchar2) is
    ld_date date;
    lv_tipo varchar2(1);
    lv_esta varchar2(1);
  begin
  
    pn_crpt := '00000';
    pn_rpta := '';
    lv_tipo := 'T';
    if pv_esta = '00000' then
      lv_esta := 'N';
    else
      lv_esta := 'V';
    end if;
  
    select pgfape into ld_date from fst017 where pgcod = 1;
  
    pq_cr_control_criesgos.sp_genera_log(pn_pais,
                                         pn_tdoc,
                                         pv_ndoc,
                                         ld_date,
                                         pv_usua,
                                         lv_tipo,
                                         pn_canal,
                                         pv_tipCon,
                                         lv_esta);
  exception
    when others then
      null;
  end sp_genera_logmisti;
  --chernandez 02/12/2019
  procedure sp_cancelacion_adelantada(pn_pgcod  number,
                                      pn_ITSUC  number,
                                      pn_ITMOD  number,
                                      pn_ITTRAN number,
                                      pn_ITNREL number,
                                      pd_fecope date) is
    cursor detalle is
      select MODULO, ITTOPE, ITSUCD, MONEDA, PAPEL, CTNRO, ITOPER, ITSUBO
        from fsd016
       where pgcod = pn_pgcod
         AND ITSUC = pn_ITSUC
         AND ITMOD = pn_ITMOD
         AND ITTRAN = pn_ITTRAN
         AND ITNREL = pn_ITNREL
         and itord = 10;
  
    cursor integrantes(ln_cuenta number) is
      select pepais, petdoc, pendoc
        from fsr008
       where pgcod = pn_pgcod
         and ctnro = ln_cuenta;
  
    cursor log(ln_pepais number,
               ln_petdoc number,
               ln_pendoc char,
               ld_fec    date) is
      select *
        from aqpa026l
       where aqpa026lpais = ln_pepais
         and aqpa026ltdoc = ln_petdoc
         and aqpa026lndoc = ln_pendoc
         and aqpa026lesta = 'V'
         and aqpa026lfecha >= ld_fec;
  
    ln_cantidad number(5);
    ld_fecha    date;
    lv_linea    varchar2(32000); --chernandez 23/12/2019
    lv_clie     varchar2(30);
    lv_agen     varchar2(30);
    ln_j        number(5);
    lv_credito  varchar2(21);
    lv_inicio   varchar2(250);
    lc_analista character(10);
    pn_rpta     number(5);
  
  begin
    pn_rpta  := 0;
    ln_j     := 0;
    lv_linea := '';
    begin
      select trim(tp1desc)
        into ln_cantidad
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 31
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_cantidad := 30;
    end;
  
    ld_fecha := pd_fecope - ln_cantidad;
  
    for i in detalle loop
      lv_credito  := lpad(to_char(i.ctnro), 9, '0') ||
                     lpad(to_char(i.moneda), 3, '0') ||
                     lpad(to_char(i.itoper), 9, '0');
      lv_inicio   := 'Se realizó la cancelación adelantada del crédito ' ||
                     lv_credito ||
                     ' y los integrantes fueron consultados por:';
      lc_analista := fn_analista_credito(i.modulo,
                                         i.itsucd,
                                         i.moneda,
                                         i.papel,
                                         i.ctnro,
                                         i.itoper,
                                         i.itsubo,
                                         i.ittope);
      for j in integrantes(i.ctnro) loop
        for k in log(j.pepais, j.petdoc, j.pendoc, ld_fecha) loop
          --Cliente A : xxx de la agencia ggg el 25/10/2019.
          begin
            select penom
              into lv_clie
              from fsd001
             where pepais = j.pepais
               and petdoc = j.petdoc
               and pendoc = j.pendoc;
          exception
            when others then
              lv_clie := '';
          end;
        
          begin
            select scnom
              into lv_agen
              from fst001
             where pgcod = 1
               and sucurs = k.aqpa026lagen;
          exception
            when others then
              lv_agen := '';
          end;
          if ln_j = 0 then
            lv_linea := 'Cliente: ' || j.pendoc || '- ' || lv_clie ||
                        ', Usuario: ' || k.aqpa026lusua ||
                        ' de la agencia ' || lv_agen || ' el ' ||
                        k.aqpa026lfecha || ' ' || K.AQPA026LHORA;
          else
            lv_linea := lv_linea || '<BR />' || 'Cliente: ' || j.pendoc || '- ' ||
                        lv_clie || ', Usuario: ' || k.aqpa026lusua ||
                        ' de la agencia ' || lv_agen || ' el ' ||
                        k.aqpa026lfecha || ' ' || K.AQPA026LHORA;
          end if;
          ln_j    := ln_j + 1;
          pn_rpta := 1;
        end loop;
      end loop;
    end loop;
    if pn_rpta = 1 then
      sp_envio_correo_cancelacion(lc_analista, lv_inicio, lv_linea);
    end if;
  exception
    --chernandez 23/12/2019
    when others then
      null;
  end sp_cancelacion_adelantada;

  procedure sp_envio_correo_cancelacion(pn_analista char,
                                        pv_inicio   varchar2,
                                        pv_linea    varchar2) is
    cursor analistas is
      select trim(sng057sup) || '@cajaarequipa.pe' as correo
        from (SELECT sng057sup
                FROM SNG057
               where sng057usr = pn_analista
                 and sng057sup is not null
                 and sng057sup <> '          '
              union
              SELECT SNG057USR
                FROM SNG057
               where sng057usr = pn_analista
              union
              select SNG057USR
                from sng057 a, FST046 b
               where a.sng055car = 202
                 and a.sng055emp = b.pgcod
                 and a.sng057usr = b.ubuser
                 and b.ubsuc =
                     (select ubsuc from fst046 where ubuser = pn_analista)) a;
  
    lv_remitente varchar2(50);
    lv_mensaje   varchar2(32000); --chernandez 23/12/2019
  begin
    begin
      select trim(tp1desc)
        into lv_remitente
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 28
         and tp1corr2 = 4
         and tp1corr3 = 1;
      lv_remitente := lv_remitente || '@cajaarequipa.pe';
    exception
      when others then
        lv_remitente := 'notificacionesbantotal@cajaarequipa.pe';
    end;
    for i in analistas loop
    
      lv_mensaje := substr('<html><head><style type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
                           '</head><body><br><p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">Estimado.</p>' ||
                           '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                           trim(pv_inicio) || '<BR />' || trim(pv_linea) ||
                           '.</p> <p style="font-family:''Courier New'', Courier, monospace;  font-size:13px">' ||
                           'Saludos</p></body></html>',
                           1,
                           31999);
    
      sys.sp_sy_enviamail_html(pc_aquien  => i.correo,
                               pc_de      => lv_remitente,
                               pc_motivo  => 'Alerta Cancelación Crédito Adelantado - Huella Interna',
                               pc_mensaje => lv_mensaje);
    end loop;
  exception
    --chernandez 23/12/2019
    when others then
      null;
  end sp_envio_correo_cancelacion;
  procedure sp_ver_log(BL_DATOS IN OUT SYS_REFCURSOR,
                       pv_usua  varchar2,
                       pn_crpt  out varchar2,
                       pn_rpta  out varchar2) is
    pc_usua character(10);
  begin
    pc_usua := pv_usua;
    pn_crpt := '00000';
    pn_rpta := '';
    open BL_DATOS for
      select d.aqpa026lpais pn_pais,
             d.aqpa026ltdoc pn_tdoc,
             d.aqpa026lndoc pv_ndoc,
             d.aqpa026lcana pn_canal,
             d.aqpa026ltcon pv_tipCon,
             d.aqpa026lesta pv_esta,
             d.aqpa026lfecha || ' ' || d.aqpa026lhora fecha
        from aqpa026l d
       where aqpa026lusua = pc_usua
       order by aqpa026lfecha, aqpa026lhora;
  end sp_ver_log;
  
  
   function fn_valida_cargo(VE_usuario varchar,ve_sucursal number) return number is
     
    vi_autorizador varchar (10);
    vi_sautorizador varchar (10);
    vi_regcod number(3);
    vi_cargo number(3);
  
    begin
          begin
              SELECT sng055car
              into vi_cargo
              FROM SNG057
              WHERE SNG057USR=rpad(VE_usuario,10,' '); 
          exception
            when others then
                 vi_cargo := 0;  
          end;
          begin
              select f.regcod
               into vi_regcod
                from fst811 f
               where oficod = ve_sucursal /*(reemplazar por la sucursal del credito a consultar)*/
                 and regcod < 100;
          end;
          if vi_cargo <= 202 then
             begin
                 select s.sng057usr,s.sng057sup
                   into vi_autorizador,vi_sautorizador
                   from fst811 f, sng057 s, fst046 t
                  where s.sng057usr = t.ubuser
                    and s.sng055car = vi_cargo
                    and t.ubsuc = f.oficod
                    and t.ubsuc = ve_sucursal
                    and regcod = vi_regcod
                    and rownum= 1;
              exception
                    when others then
              return 0;     
              end;     
          end if;
          if vi_cargo = 220 then
              begin
                 select s.sng057usr,s.sng057sup
                   into vi_autorizador,vi_sautorizador
                   from fst811 f, sng057 s, fst046 t
                  where s.sng057usr = t.ubuser
                    and s.sng055car = vi_cargo
                    and t.ubsuc = f.oficod
                    and regcod = vi_regcod                      
                    and rownum= 1;
              exception
                    when others then
              return 0;     
              end; 
          end if;
          if vi_cargo = 230 then
             begin
                 select s.sng057usr,s.sng057sup
                 into vi_autorizador,vi_sautorizador
                 from sng057 s where s.sng055car= vi_cargo 
                 and rownum = 1;
             exception
                    when others then
              return 0;     
              end; 
          end if;
           
          if vi_cargo >= 202 and vi_cargo <= 220 then
             if trim(vi_autorizador)=VE_usuario  or trim(vi_sautorizador)=VE_usuario  then
                return 1;
             else
                return 0;
             end if;         
          end if;             
    return 0;
  end;
  
end pq_cr_control_criesgos;
/

