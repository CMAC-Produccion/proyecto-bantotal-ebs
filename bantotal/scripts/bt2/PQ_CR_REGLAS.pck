create or replace package PQ_CR_REGLAS is
  -- ------------------------------------------------------------------------------------------------
  -- Nombre                : PQ_CR_REGLAS
  -- Sistema               : BANTOTAL
  -- Módulo                : REGLAS CENTRAL DE RIESGO LOCAL
  -- Versión               : 1.0
  -- Fecha de Creación     : 31/05/2017
  -- Autor de Creación     : JPINTO/CHERNANDEZ
  -- Uso                   :
  -- Estado                : Activo
  -- Acceso                : Público
  -- Fecha de Modificación : 16/01/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agregó busqueda en sngc60 en busqueda de inicio de actividades
  -- Fecha de Modificación : 19/01/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : Se agregó filtro para que obtenga solo el primer registro de la tabla sngc60
  -- Fecha de Modificación : 29/05/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agregó filtro para entidades no reguladas financieras
  -- Fecha de Modificación : 12/07/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agrego la parametrizacion del buro por regla
  -- Fecha de Modificación : 31/08/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agrego en sp_busca_rcc reglas 51 52 de producto quintuplica
  -- Fecha de Modificación : 09/10/2018
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agrego filtro en la regla 32 para estado de empresa
  -- Fecha de Modificación : 11/01/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : Se agregó regla 53 - 8 meses 100% normal campaña verano 
  -- Fecha de Modificación : 12/07/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se cambio consulta de experian y sentinel
  -- Fecha de Modificación : 26/07/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se agregó bifurcación de CPP
  -- Fecha de Modificación : 06/05/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : Se cambió regla 22
  -- Fecha de Modificación : 28/10/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : se mando codnum en regla 50
  -- Fecha de Modificación : 07/11/2019
  -- Autor de Modificación : Cinthya Liz Hernandez Ortega
  -- Descripción Modific.  : actualizacion de regla 22,24,25
  -- Modificacion          : 10/05/2024 APACHECOH Se actualizó las reglas con el nuevo buro experian
  -- Modificacion          : 18/06/2024 APACHECOH Se actualizó la regla 33 deuda tributaria segun definicion
  -- ------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure sp_ejecutar_precalificacion(p_n_serial number,
                                        p_n_numcon number,
                                        p_n_tiprod number,
                                        p_c_usuari varchar2);

  procedure sp_busca_integrantes(p_n_instan number);

  procedure sp_busca_regla_bantotal(p_n_instan number,
                                    p_n_nroreg number,
                                    p_c_tipint varchar2,
                                    p_c_usuari varchar2,
                                    p_c_rpttit out varchar2,
                                    p_n_correl out number);

  procedure sp_busca_regla_buro(p_n_instan number,
                                p_n_nroreg number,
                                p_c_tipint varchar2,
                                p_c_usuari varchar2,
                                p_c_rpttit in out varchar2,
                                p_n_correl in out number);

  procedure sp_busca_regla_enti(p_n_instan number,
                                p_n_nroreg number,
                                p_c_usuari varchar2,
                                p_c_rpttit out varchar2,
                                p_c_rptttt out varchar2,
                                p_c_rptcon out varchar2,
                                p_c_canent in out varchar2,
                                p_n_correl in out number);

  procedure sp_busca_regla_enti2(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_c_rpttit in out varchar2,
                                 p_n_correl in out number);

  procedure sp_contador_entidades(p_n_tipdoc numeric,
                                  p_c_numdoc character,
                                  p_d_perrcc date,
                                  p_n_tipBur numeric,
                                  p_n_serial numeric,
                                  p_n_canent in out numeric);

  procedure sp_cont_entid_cmac(p_n_tipdoc numeric,
                               p_c_numdoc character,
                               p_d_perrcc date,
                               p_n_tipBur numeric,
                               p_n_serial numeric,
                               p_n_canent in out numeric);

  procedure sp_proceso(p_n_correl number,
                       p_n_nregla number,
                       p_c_rptrcc varchar2,
                       p_d_perrcc date,
                       p_n_tipdoc number,
                       p_c_numdoc char,
                       p_n_flgact number,
                       p_c_rptind out char);

  procedure sp_resolverRpt(p_c_rptfin in out char, p_c_rptind char);

  procedure sp_obtenerFechaRcc(p_d_fecrcc out date, p_d_rccant out date);

  procedure sp_valida_calif_activo(p_c_arreglo   in varchar,
                                   p_n_respuesta out number);

  procedure sp_busca_rcc(p_n_instan number,
                         p_n_nroreg number,
                         p_c_tipint varchar2,
                         p_c_usuari varchar2,
                         p_c_rpttit out varchar2,
                         p_n_correl out number);

  /*procedure sp_proceso_2(p_n_correl number,
  p_n_nregla number,
  p_c_rptrcc varchar2,
  p_d_perrcc date,
  p_n_tipdoc number,
  p_c_numdoc char,
  p_n_flgact number,
  p_c_rptind out char);*/
  procedure sp_busca_cal100N10CPP(p_n_instan number,
                                  p_n_nroreg number,
                                  p_c_usuari varchar2,
                                  p_c_rpttit out varchar2,
                                  p_n_correl out number);
  procedure sp_actualizaDetalle(p_n_instan number,
                                p_n_correl number,
                                p_n_nregla number,
                                p_n_tipdoc varchar2,
                                p_c_numdoc char,
                                p_c_estprc char,
                                p_n_porper number,
                                p_d_perrcc date);
  procedure sp_busca_inicio_acti(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 l_n_actmen out number,
                                 p_n_correl in out number);

  procedure sp_obtener_pasivosSC(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_c_rpttit out varchar2,
                                 p_n_correl out number);
  procedure sp_obtener_entidades(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_n_rptcan out number,
                                 p_n_correl out number);
  procedure sp_cont_ent_regSC(p_n_tipdoc numeric,
                              p_c_numdoc character,
                              p_d_perrcc date,
                              p_n_canent in out numeric);

  procedure sp_obtener_saldos_totales(p_n_serial     number,
                                      p_n_numcon     number,
                                      p_n_tipDoc     varchar2,
                                      p_c_numDoc     varchar2,
                                      p_c_usuari     varchar2,
                                      p_n_saldoCCaja out number,
                                      p_n_saldoSCaja out number,
                                      p_n_saldoNRegu out number,
                                      p_n_correl     out number);
  function fn_equivalenviaDoc(p_tdoc in number) return varchar2;

  procedure sp_cont_entid_cmac_all(p_n_tipdoc numeric, --chernandez 29/05/2018
                                   p_c_numdoc character,
                                   p_d_perrcc date,
                                   p_n_tipBur numeric,
                                   p_n_serial numeric,
                                   p_n_canent in out numeric);
  --chernandez 26/07/2019
  procedure sp_bifurcacpp(p_n_corr  numeric,
                          p_n_regla numeric,
                          p_n_rpta  out numeric);
  --chernandez 06/05/2019
  procedure sp_mora_max(p_n_instan number,
                        p_n_nroreg number,
                        p_c_tipint varchar2,
                        p_c_usuari varchar2,
                        p_c_rpttit out varchar2,
                        p_n_correl out number);

  procedure sp_verificaCtas(p_n_instan number,
                            p_n_nroreg number,
                            p_c_tipint varchar2,
                            p_n_flag   out number);
  --apachecoh 24/08/2022                          
  procedure sp_proceso_reg(p_n_correl number,
                           p_n_nregla number,
                           p_c_rptrcc varchar2,
                           p_d_perrcc date,
                           p_n_tipdoc number,
                           p_c_numdoc char,
                           p_n_flgact number,
                           p_n_flgmes number,
                           p_c_rptind out char);

end PQ_CR_REGLAS;
/
create or replace package body PQ_CR_REGLAS is

  procedure sp_ejecutar_precalificacion(p_n_serial number,
                                        p_n_numcon number,
                                        p_n_tiprod number,
                                        p_c_usuari varchar2) is
    cursor reglas1 is
      select jaqy590nro1 as tipo,
             jaqy590nro2 as tipo2,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 <= 12;
  
    cursor reglas2 is
      select jaqy590nro1 as tipo,
             jaqy590nro2 as tipo2,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 >= 13
         and jaqy590corr3 <= 21;
  
    cursor reglas3 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 >= 22
         and jaqy590corr3 <= 25;
  
    cursor reglas4 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 >= 27
         and jaqy590corr3 <= 28;
  
    cursor reglas5 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 >= 29
         and jaqy590corr3 <= 30;
  
    cursor reglas6 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 >= 31
         and jaqy590corr3 <= 37;
  
    cursor reglas7 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 = 49;
  
    cursor reglas8 is
      select jaqy590nro1 as tipo,
             jaqy590desc2 || jaqy590desc3 as mensaje,
             jaqy590corr3 as regla
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 8
         and jaqy590corr2 = 1
         and jaqy590corr3 = 50;
  
    cursor consnormal(correl numeric) is
      select jaqy589estad
        from jaqy589
       where jaqy589corre = correl
         and jaqy588tireg = 0;
  
    cursor consnormal_reg(correl numeric, regla numeric, item numeric) is
      select jaqy589estad
        from jaqy589
       where jaqy589corre = correl
         and jaqy588tireg = regla
         and jaqy589corel = item
       order by jaqy589corel, jaqy589perio desc;
  
    l_c_rpttit varchar2(9);
    l_c_rptaux varchar2(9);
    l_c_rptttt char(1);
    l_c_rptcon char(1);
    l_c_rptnor char(1);
    l_c_canent varchar2(9);
    l_n_correl numeric(10);
    l_n_corre2 numeric(10);
    l_n_result numeric(5);
    l_n_tipo   numeric(5);
    l_c_result char(1);
    l_n_activo numeric(5);
    errorv     varchar2(500);
    canti      varchar2(20);
    l_n_mora   numeric(5);
    l_n_mormax numeric(5);
    l_c_rptmor numeric(10, 2);
    ln_rptcpp  numeric(5);
    lv_mensaje varchar2(200);
    ln_conta   numeric(5);
    ln_flag    numeric(5);
    vi_buro    number(3);
    l_n_rpttip number(3);
    l_n_cont   number(3);
    l_c_rptpri varchar2(5);
    l_c_rpttri varchar2(5);
  begin
    l_n_result := 1;
    delete from JAQY598 where JAQY598Corre = p_n_serial;
    commit;
    --AGREGADO AQPA011L 08.02.2022 CONSULTA BURO.
    BEGIN
      select L.AQPA011LBURO
        INTO vi_buro
        from AQPA011L L
       WHERE L.aqpa011lnucon = p_n_numcon
            --AND L.aqpa011lseria = p_n_serial
         and l.aqpa011lestad = 1
         and l.aqpa011lhora = (select min(b.aqpa011lhora)
                                 from aqpa011l b
                                where b.aqpa011lnucon = p_n_numcon
                                  and b.aqpa011lestad = 1
                               --AND b.aqpa011lseria = p_n_serial
                               )
         and rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_buro := 1;
    END;
    for i in reglas1 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        l_c_rpttit := null;
        l_n_correl := null;
        sp_busca_regla_bantotal(p_n_serial,
                                i.regla,
                                '2', --se mantiene por la definicio de guia
                                p_c_usuari,
                                l_c_rpttit,
                                l_n_correl);
        if l_c_rpttit <> 'S' then
          --Si es N es porque no cumple la regla
        
          l_c_rptnor := '';
          l_n_tipo   := 0;
        
          --apachecoh 2022.08.25 se adicionaron reglas
          If i.regla in (7, 8, 10) then
            begin
              l_c_rptnor := 'S';
              for item in 1 .. 3 loop
                l_n_cont   := 1;
                l_c_rptpri := 'S';
                l_c_rpttri := 'S';
                for h in consnormal_reg(l_n_correl, i.regla, item) loop
                  /*if l_n_cont = 1 then
                      l_c_rptpri := h.jaqy589estad; 
                  else
                      if h.jaqy589estad = 'N' then
                         l_c_rpttri := 'N';  
                      end if;
                  end if;*/
                  if h.jaqy589estad = 'N' then
                    l_n_cont := l_n_cont + 1;
                  end if;
                end loop;
                --if l_c_rptpri = 'N' and l_c_rpttri = 'N' then
                if l_n_cont > 4 then
                  l_c_rptnor := 'N';
                  l_n_rpttip := item;
                  exit;
                end if;
              end loop;
            exception
              when others then
                l_c_rptnor := 'S';
            end;
            --apachecoh 2022.12.15 tipo de bloqueante 1, 2, 3 
            if l_n_rpttip = 1 then
              l_n_tipo := 3;
              if l_n_result < 3 then
                l_n_result := 3;
              end if;
            else
              l_n_tipo := 2;
              if l_n_result < 2 then
                l_n_result := 2;
              end if;
            end if;
          
          Else
          
            if l_n_result < i.tipo then
              l_n_result := i.tipo;
            end if;
          
            l_c_rptnor := '';
            l_n_tipo   := i.tipo;
          
          End If;
          --apachecoh 2022.08.25
        
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          lv_mensaje := i.mensaje;
        
          --chernandez 26/07/2019
          If i.regla >= 10 and i.regla <= 12 then
          
            sp_bifurcacpp(l_n_correl, i.regla, ln_rptcpp);
            if ln_rptcpp = 1 then
              lv_mensaje := trim(lv_mensaje) || '*';
            end if;
          End If;
        
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, lv_mensaje);
        
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas2 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        l_c_rpttit := null;
        l_n_correl := null;
        sp_busca_regla_bantotal(p_n_serial,
                                i.regla,
                                '2',
                                p_c_usuari,
                                l_c_rpttit,
                                l_n_correl);
        if l_c_rpttit <> 'S' then
          l_c_rptnor := '';
          l_n_tipo   := 0;
        
          begin
            l_c_rptnor := 'S';
            for h in consnormal(l_n_correl) loop
              if h.jaqy589estad = 'N' then
                l_c_rptnor := 'N';
              end if;
            end loop;
          
          exception
            when others then
              l_c_rptnor := 'S';
          end;
        
          if l_c_rptnor <> 'S' then
            l_n_tipo := i.tipo;
            if l_n_result < i.tipo then
              l_n_result := i.tipo;
            end if;
          else
            l_n_tipo := i.tipo2;
            if l_n_result < i.tipo2 then
              l_n_result := i.tipo2;
            end if;
          end if;
        
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, i.mensaje);
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas3 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        lv_mensaje := i.mensaje;
        --22,24,25,48
        sp_busca_regla_bantotal(p_n_serial,
                                i.regla,
                                '2',
                                p_c_usuari,
                                l_c_rpttit,
                                l_n_correl);
      
        /*if i.regla = 22 then
          l_c_rptaux := l_c_rpttit;
          sp_busca_regla_bantotal(p_n_serial,
                                  48,
                                  '2',
                                  p_c_usuari,
                                  l_c_rpttit,
                                  l_n_correl);
          if l_c_rptaux = 'N' then
            l_c_rpttit := 'N';
          end if;
        end if;*/
      
        --chernandez 06/05/2019
        if l_c_rpttit <> 'S' then
          if i.regla = 22 then
            sp_verificaCtas(p_n_serial, i.regla, '2', ln_flag);
            if ln_flag = 1 then
              begin
                select tp1nro2
                  into l_n_mormax
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 11105
                   and tp1corr1 = 15
                   and tp1corr2 = 1
                   and tp1corr3 = 1;
              exception
                when others then
                  l_n_mormax := 0;
              end;
            
              sp_mora_max(p_n_serial,
                          i.regla,
                          '2',
                          p_c_usuari,
                          l_c_rptmor,
                          l_n_corre2);
              l_n_mora := to_number(l_c_rptmor);
              --si la mora maxima es 8 y no se activo otra politica de la 1 a la 21
              if l_n_mora <= l_n_mormax and l_n_result <= 1 then
                l_c_rpttit := 'S';
              end if;
            end if;
            /*
            if l_c_rpttit <> 'S' then
              --chernandez 07/11/2019          
              sp_bifurcaMitUlt(l_n_correl, i.regla, ln_rptcpp);
              if ln_rptcpp = 1 then --si tiene judicial durante los ultimos 6 meses
                lv_mensaje := trim(lv_mensaje) || '*';--* bloqueante
              else --si tiene judicial durante los primeros 6 meses se verifica si esta 100% normal en los ultimos 6 meses.
                sp_busca_regla_bantotal(p_n_serial,
                                    54,
                                    '2',
                                    p_c_usuari,
                                    l_c_rptaux,
                                    l_n_corre2);
                if l_c_rptaux = 'N' then
                   lv_mensaje := trim(lv_mensaje) || '*';--* bloqueante
                end if;
                
              end if;
            end if;
            */
          End If;
        End if;
      
        if l_c_rpttit <> 'S' then
          if l_n_result < i.tipo then
            l_n_result := i.tipo;
          end if;
        
          l_c_rptnor := '';
          l_n_tipo   := i.tipo;
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, lv_mensaje); --se cambio a lv_mensaje 07/11/2019
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas4 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        --27,28
        l_n_correl := 2;
        l_c_canent := to_char(p_n_numcon);
        sp_busca_regla_enti(p_n_serial,
                            i.regla,
                            p_c_usuari,
                            l_c_rpttit,
                            l_c_rptttt,
                            l_c_rptcon,
                            l_c_canent,
                            l_n_correl);
      
        if l_c_rpttit <> 'S' then
        
          if l_n_result < i.tipo then
            l_n_result := i.tipo;
          end if;
        
          l_c_rptnor := '';
          l_n_tipo   := i.tipo;
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, i.mensaje);
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas5 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        --29,30
        l_n_correl := 2;
        l_c_rpttit := to_char(p_n_numcon);
        sp_busca_regla_enti2(p_n_serial,
                             i.regla,
                             p_c_usuari,
                             l_c_rpttit,
                             l_n_correl);
        if l_c_rpttit <> 'S' then
        
          if l_n_result < i.tipo then
            l_n_result := i.tipo;
          end if;
        
          l_c_rptnor := '';
          l_n_tipo   := i.tipo;
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, i.mensaje);
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas6 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        --31,32,33,34,35,36,37
        l_n_correl := 2;
        --chernandez 12/07/2019
        l_c_rpttit := to_char(p_n_numcon);
        sp_busca_regla_buro(p_n_serial,
                            i.regla,
                            vi_buro, --'3', ---- se modifico para EQUIFAX
                            p_c_usuari,
                            l_c_rpttit,
                            l_n_correl);
        if l_c_rpttit <> 'S' then
        
          if l_n_result < i.tipo then
            l_n_result := i.tipo;
          end if;
        
          l_c_rptnor := '';
          l_n_tipo   := i.tipo;
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, i.mensaje);
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas7 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        --49
        l_n_correl := 2;
        l_c_rpttit := to_char(p_n_numcon);
        sp_busca_regla_enti2(p_n_serial,
                             i.regla,
                             p_c_usuari,
                             l_c_rpttit,
                             l_n_correl);
        if l_c_rpttit <> 'S' then
          begin
            select JAQY588RESVAR
              into canti
              from JAQY588
             where JAQY588CORRE = l_n_correl;
          exception
            when others then
              canti := '0';
          end;
          l_c_rptnor := '';
          l_n_tipo   := i.tipo;
          case l_n_tipo
            when 2 then
              l_c_rptnor := 'O';
            when 3 then
              l_c_rptnor := 'R';
            when 4 then
              l_c_rptnor := 'A';
          end case;
          insert into JAQY598
            (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
          values
            (p_n_serial, i.regla, l_c_rptnor, i.mensaje || ' ' || canti);
          commit;
        end if;
      end if;
    end loop;
  
    for i in reglas8 loop
      select count(*)
        into l_n_activo
        from jaqy590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 9
         and jaqy590corr2 = i.regla
         and jaqy590corr3 = p_n_tiprod;
      if l_n_activo >= 1 then
        --50
        l_n_correl := 2;
        --chernandez 28/10/2019
        l_c_rpttit := to_char(p_n_numcon);
        sp_busca_regla_buro(p_n_serial,
                            i.regla,
                            vi_buro, --- se modifico para equifax
                            p_c_usuari,
                            l_c_rpttit,
                            l_n_correl);
        l_c_rptnor := '';
        l_n_tipo   := i.tipo;
        case l_n_tipo
          when 2 then
            l_c_rptnor := 'O';
          when 3 then
            l_c_rptnor := 'R';
          when 4 then
            l_c_rptnor := 'A';
        end case;
        insert into JAQY598
          (JAQY598Corre, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
        values
          (p_n_serial,
           i.regla,
           l_c_rptnor,
           i.mensaje || ' ' || l_n_correl || ' meses.');
        commit;
      end if;
    end loop;
  
    --final
    If l_n_result = 1 then
      l_c_result := 'P';
    end if;
    If l_n_result = 2 then
      l_c_result := 'O';
    end if;
    If l_n_result = 3 then
      l_c_result := 'R';
    end if;
    delete from JAQY599 where JAQY599Corre = p_n_serial;
    commit;
    insert into JAQY599
      (JAQY599corre, Jaqy599accio)
    values
      (p_n_serial, l_c_result);
  
    commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_ejecutar_precalificacion',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_serial,
         0,
         errorv);
      commit;
  end sp_ejecutar_precalificacion;

  procedure sp_busca_integrantes(p_n_instan number) is
  
    cursor titular(sng001emp number, sng001cta number) is
      select *
        from fsr008
       where ctnro = sng001cta
         and pgcod = sng001emp
         and (petdoc, pendoc) not in
             (select JAQY591tdoc, JAQY591ndoc
                from JAQY591
               where JAQY591instan = p_n_instan);
  
    cursor repreLegal(n_pais number, n_tdoc number, c_ndoc character) is
      select * --pfpai1,pftdo1,pfndo1
        from Fsr003
       where pjpais = n_pais
         and pjtdoc = n_tdoc
         and pjndoc = c_ndoc
         and vicod in (select tp1corr2
                         from fst198
                        where tp1cod1 = 10802
                          and Tp1corr1 = 11);
  
    cursor integJuriNat(n_pais number, n_tdoc number, c_ndoc character) is
      select pjpais, pjtdoc, pjndoc
        from fsr003
       where pfpai1 = n_pais
         and pftdo1 = n_tdoc
         and pfndo1 = c_ndoc
         and vicod in (select JAQY590CORR3
                         from jaqy590
                        where JAQY590COD = 1
                          and JAQY590COD1 = 1
                          and JAQY590CORR1 = 4);
  
    cursor integJuriJur(n_pais number, n_tdoc number, c_ndoc character) is
      select a.pjpais, a.pjtdoc, a.pjndoc
        from fsr003 a
       where (pfpai1, pftdo1, pfndo1) in
             (select pfpai1, pftdo1, pfndo1
                from Fsr003 b
               where b.pjpais = n_pais
                 and b.pjtdoc = n_tdoc
                 and b.pjndoc = c_ndoc
                 and b.vicod in (select JAQY590CORR3
                                   from jaqy590
                                  where JAQY590COD = 1
                                    and JAQY590COD1 = 1
                                    and JAQY590CORR1 = 4))
         and a.vicod in (select JAQY590CORR3
                           from jaqy590
                          where JAQY590COD = 1
                            and JAQY590COD1 = 1
                            and JAQY590CORR1 = 4)
         and a.pjpais <> n_pais
         and a.pjtdoc <> n_tdoc
         and a.pjndoc <> c_ndoc;
  
    cursor conyugue(n_pais number, n_tdoc number, c_ndoc character) is
      select rppais, rptdoc, rpndoc
        from fsr002
       where pepais = n_pais
         and petdoc = n_tdoc
         and pendoc = c_ndoc
         and rpccyg = 66;
  
    cursor fiadores is
      select sng003pgc, sng003cta
        from sng003
       where sng001inst = p_n_instan;
  
    cursor empleador(pais number, tdoc number, ndoc char) is
      SELECT SNGC60Rute, SNGC60Rzso
        FROM SNGC60
       WHERE SNGC60Pais = pais
         and SNGC60Tdoc = tdoc
         and SNGC60Ndoc = ndoc
         and SNGC60Corr = 0
         and SNGC60Rute is not null
         and SNGC60Rute <> ' ';
  
    sng001pais   number;
    sng001tdoc   number;
    sng001ndoc   char(12);
    sng001cta    number;
    sng001emp    number;
    correlativo  number;
    correlativo2 number;
    cantidad     number;
    tipo         char(2);
    validar      number;
    correlintT   number;
    correlintC   number;
    correlintF   number;
    errorv       varchar2(500);
  
  begin
  
    select count(*)
      into cantidad
      from JAQY591
     where JAQY591INSTAN = p_n_instan;
  
    if cantidad = 0 then
      correlintT   := 0;
      correlintC   := 0;
      correlintF   := 0;
      correlativo  := 0;
      correlativo2 := 0;
      --obtengo titular
      select b.sng001pais,
             b.sng001tdoc,
             b.sng001ndoc,
             b.sng001cta,
             b.sng001emp
        into sng001pais, sng001tdoc, sng001ndoc, sng001cta, sng001emp
        from sng001 b
       where sng001inst = p_n_instan;
    
      if sng001tdoc = 9 then
        tipo := 'T2';
      else
        tipo := 'T1';
      end if;
    
      correlativo := correlativo + 1;
    
      begin
      
        insert into JAQY591
          (JAQY591INSTAN,
           JAQY591INTEGR,
           JAQY591FCHSIS,
           JAQY591TIPERS,
           JAQY591TDOC,
           JAQY591NDOC)
        values
          (p_n_instan,
           'TITULAR_' || correlativo,
           sysdate,
           tipo,
           sng001tdoc,
           sng001ndoc);
        commit;
      exception
        when others then
          dbms_output.put_line(sqlerrm);
          errorv := substr(sqlerrm, 1, 500);
          insert into jaqy592_er
            (JAQY592PROC,
             JAQY592FECH,
             JAQY592HORA,
             JAQY592INST,
             JAQY592REGL,
             JAQY592DESC)
          values
            ('sp_busca_integrantes1',
             trunc(sysdate),
             to_char(sysdate, 'HH24:MI:SS'),
             p_n_instan,
             1,
             errorv);
      end;
    
      if sng001tdoc = 9 then
        --A
        --obtengo representante legal
        for d in repreLegal(sng001pais, sng001tdoc, sng001ndoc) loop
          --B
          correlativo2 := correlativo2 + 1;
          begin
          
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'PERSONJUR_T' || correlativo2,
               sysdate,
               'P1',
               d.pftdo1,
               d.pfndo1);
            commit;
          
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes2',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 2,
                 errorv);
              commit;
          end;
        end loop; --B
      
        --obtengo integracion de titular
        for d in integJuriJur(sng001pais, sng001tdoc, sng001ndoc) loop
          --C
          begin
            correlintT := correlintT + 1;
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'INTEGRJUR_T' || correlintT,
               sysdate,
               'I1',
               d.pjtdoc,
               d.pjndoc);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes3',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 3,
                 errorv);
              commit;
          end;
        end loop; --C
      
      else
        --A
        --obtengo conyugue
        for d in conyugue(sng001pais, sng001tdoc, sng001ndoc) loop
          --D
          begin
          
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'CONYUGUE_' || correlativo,
               sysdate,
               'C1',
               d.rptdoc,
               d.rpndoc);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes4',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 4,
                 errorv);
              commit;
          end;
        
          --obtengo integracion de conyugue
          for e in integJuriNat(d.rppais, d.rptdoc, d.rpndoc) loop
            --I
            correlintC := correlintC + 1;
            begin
              insert into JAQY591
                (JAQY591INSTAN,
                 JAQY591INTEGR,
                 JAQY591FCHSIS,
                 JAQY591TIPERS,
                 JAQY591TDOC,
                 JAQY591NDOC)
              values
                (p_n_instan,
                 'INTEGRJUR_C' || correlintC,
                 sysdate,
                 'I2',
                 e.pjtdoc,
                 e.pjndoc);
              commit;
            exception
              when others then
                dbms_output.put_line(sqlerrm);
                errorv := substr(sqlerrm, 1, 500);
                insert into jaqy592_er
                  (JAQY592PROC,
                   JAQY592FECH,
                   JAQY592HORA,
                   JAQY592INST,
                   JAQY592REGL,
                   JAQY592DESC)
                values
                  ('sp_busca_integrantes5',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:MI:SS'),
                   p_n_instan,
                   5,
                   errorv);
                commit;
            end;
          end loop; --I
        
        end loop; --D
      
        --obtener integracion jurifica de titular
        for e in integJuriNat(sng001pais, sng001tdoc, sng001ndoc) loop
          --M
          begin
            correlintT := correlintT + 1;
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'INTEGRJUR_T' || correlintT,
               sysdate,
               'I1',
               e.pjtdoc,
               e.pjndoc);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes6',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 6,
                 errorv);
              commit;
          end;
        end loop; --M
      
      end if; --A
    
      --obtengo titular 
      for d in titular(sng001emp, sng001cta) loop
        --E
      
        select count(*)
          into validar
          from JAQY591
         where JAQY591INSTAN = p_n_instan
           and JAQY591NDOC = d.pendoc
           and JAQY591TDOC = d.petdoc;
      
        if validar = 0 then
        
          if d.petdoc = 9 then
            tipo := 'T2';
          else
            tipo := 'T1';
          end if;
        
          correlativo := correlativo + 1;
        
          insert into JAQY591
            (JAQY591INSTAN,
             JAQY591INTEGR,
             JAQY591FCHSIS,
             JAQY591TIPERS,
             JAQY591TDOC,
             JAQY591NDOC)
          values
            (p_n_instan,
             'TITULAR_' || correlativo,
             sysdate,
             tipo,
             d.petdoc,
             d.pendoc);
          commit;
        
          --OBTENGO REPRESENTANTE LEGAL
          if d.petdoc = 9 then
            --F
          
            for e in repreLegal(d.pepais, d.petdoc, d.pendoc) loop
              --G
            
              begin
              
                correlativo2 := correlativo2 + 1;
              
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'PERSONJUR_T' || correlativo2,
                   sysdate,
                   'P1',
                   e.pftdo1,
                   e.pfndo1);
                commit;
              
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes7',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     7,
                     errorv);
                  commit;
              end;
            
            end loop; --G
          
            --obtener integracion jurifica de titular
            for e in integJuriJur(d.pepais, d.petdoc, d.pendoc) loop
              --J
              begin
                correlintT := correlintT + 1;
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'INTEGRJUR_T' || correlintT,
                   sysdate,
                   'I1',
                   e.pjtdoc,
                   e.pjndoc);
                commit;
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes8',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     8,
                     errorv);
                  commit;
              end;
            end loop; --J
          
          else
            --F
            --obtengo conyugue titular 
            for e in conyugue(d.pepais, d.petdoc, d.pendoc) loop
              --H
              insert into JAQY591
                (JAQY591INSTAN,
                 JAQY591INTEGR,
                 JAQY591FCHSIS,
                 JAQY591TIPERS,
                 JAQY591TDOC,
                 JAQY591NDOC)
              values
                (p_n_instan,
                 'CONYUGUE_' || correlativo,
                 sysdate,
                 'C1',
                 e.rptdoc,
                 e.rpndoc);
              commit;
            
              --obtener integracion jurifica de conyugue
              for f in integJuriNat(e.rppais, e.rptdoc, e.rpndoc) loop
                --k
                begin
                  correlintC := correlintC + 1;
                  insert into JAQY591
                    (JAQY591INSTAN,
                     JAQY591INTEGR,
                     JAQY591FCHSIS,
                     JAQY591TIPERS,
                     JAQY591TDOC,
                     JAQY591NDOC)
                  values
                    (p_n_instan,
                     'INTEGRJUR_C' || correlintC,
                     sysdate,
                     'I2',
                     f.pjtdoc,
                     f.pjndoc);
                  commit;
                exception
                  when others then
                    dbms_output.put_line(sqlerrm);
                    errorv := substr(sqlerrm, 1, 500);
                    insert into jaqy592_er
                      (JAQY592PROC,
                       JAQY592FECH,
                       JAQY592HORA,
                       JAQY592INST,
                       JAQY592REGL,
                       JAQY592DESC)
                    values
                      ('sp_busca_integrantes9',
                       trunc(sysdate),
                       to_char(sysdate, 'HH24:MI:SS'),
                       p_n_instan,
                       9,
                       errorv);
                    commit;
                end;
              end loop; --k
            
            end loop; --H
          
            --obtener integracion jurifica de titular
            for e in integJuriNat(d.pepais, d.petdoc, d.pendoc) loop
              --L
              begin
                correlintT := correlintT + 1;
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'INTEGRJUR_T' || correlintT,
                   sysdate,
                   'I1',
                   e.pjtdoc,
                   e.pjndoc);
                commit;
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes10',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     10,
                     errorv);
                  commit;
              end;
            end loop; --L
          
          end if; --F
        
        end if;
      
      end loop; --E
    
      for d in empleador(sng001pais, sng001tdoc, sng001ndoc) loop
        insert into JAQY591
          (JAQY591INSTAN,
           JAQY591INTEGR,
           JAQY591FCHSIS,
           JAQY591TIPERS,
           JAQY591TDOC,
           JAQY591NDOC)
        values
          (p_n_instan, 'EMPLEADOR', sysdate, 'E1', 9, d.SNGC60Rute);
        commit;
      end loop;
    
    end if;
    ---------------------------------------------------------------------------------------
    correlativo := 0;
    --chernandez 04/06/2018
    correlintF   := 0;
    correlativo2 := 0;
  
    delete from JAQY591
     where JAQY591INSTAN = p_n_instan
       and (JAQY591INTEGR like 'FIADOR%' or
           JAQY591INTEGR like 'CONYUGUE_F%' or
           JAQY591INTEGR like 'PERSONJUR_F%' or
           JAQY591INTEGR like 'INTEGRJUR_F%');
    commit;
  
    for d in fiadores loop
    
      --obtengo titular principal fiadores
      select pepais, petdoc, pendoc
        into sng001pais, sng001tdoc, sng001ndoc
        from fsr008
       where ctnro = d.sng003cta
         and pgcod = d.sng003pgc
         and cttfir = 'T';
    
      if sng001tdoc = 9 then
        tipo := 'F2';
      else
        tipo := 'F1';
      end if;
    
      correlativo := correlativo + 1;
    
      insert into JAQY591
        (JAQY591INSTAN,
         JAQY591INTEGR,
         JAQY591FCHSIS,
         JAQY591TIPERS,
         JAQY591TDOC,
         JAQY591NDOC)
      values
        (p_n_instan,
         'FIADOR_' || trim(to_char(correlativo)),
         sysdate,
         tipo,
         sng001tdoc,
         sng001ndoc);
      commit;
    
      --obtengo representante legal
    
      if sng001tdoc = 9 then
      
        for e in repreLegal(sng001pais, sng001tdoc, sng001ndoc) loop
          begin
          
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'PERSONJUR_F',
               sysdate,
               'P3',
               e.pftdo1,
               e.pfndo1);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes11',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 11,
                 errorv);
              commit;
          end;
        end loop;
      
        --obtener integracion jurifica de fiador
        for e in integJuriJur(sng001pais, sng001tdoc, sng001ndoc) loop
          --M
          begin
            correlintF := correlintF + 1;
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'INTEGRJUR_F' || correlintF,
               sysdate,
               'I3',
               e.pjtdoc,
               e.pjndoc);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes12',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 12,
                 errorv);
              commit;
          end;
        end loop; --M
      
      else
      
        for e in conyugue(sng001pais, sng001tdoc, sng001ndoc) loop
          insert into JAQY591
            (JAQY591INSTAN,
             JAQY591INTEGR,
             JAQY591FCHSIS,
             JAQY591TIPERS,
             JAQY591TDOC,
             JAQY591NDOC)
          values
            (p_n_instan,
             'CONYUGUE_F' || trim(to_char(correlativo)),
             sysdate,
             'C2',
             e.rptdoc,
             e.rpndoc);
          commit;
        
          --obtener integracion jurifica de conyugue
          for f in integJuriNat(e.rppais, e.rptdoc, e.rpndoc) loop
            --M
            begin
              correlintF := correlintF + 1;
              insert into JAQY591
                (JAQY591INSTAN,
                 JAQY591INTEGR,
                 JAQY591FCHSIS,
                 JAQY591TIPERS,
                 JAQY591TDOC,
                 JAQY591NDOC)
              values
                (p_n_instan,
                 'INTEGRJUR_F' || correlintF,
                 sysdate,
                 'I3',
                 f.pjtdoc,
                 f.pjndoc);
              commit;
            exception
              when others then
                dbms_output.put_line(sqlerrm);
                errorv := substr(sqlerrm, 1, 500);
                insert into jaqy592_er
                  (JAQY592PROC,
                   JAQY592FECH,
                   JAQY592HORA,
                   JAQY592INST,
                   JAQY592REGL,
                   JAQY592DESC)
                values
                  ('sp_busca_integrantes13',
                   trunc(sysdate),
                   to_char(sysdate, 'HH24:MI:SS'),
                   p_n_instan,
                   13,
                   errorv);
                commit;
            end;
          end loop; --M
        
        end loop;
      
        --obtener integracion jurifica de titular
        for f in integJuriNat(sng001pais, sng001tdoc, sng001ndoc) loop
          --M
          begin
            correlintF := correlintF + 1;
            insert into JAQY591
              (JAQY591INSTAN,
               JAQY591INTEGR,
               JAQY591FCHSIS,
               JAQY591TIPERS,
               JAQY591TDOC,
               JAQY591NDOC)
            values
              (p_n_instan,
               'INTEGRJUR_F' || correlintF,
               sysdate,
               'I3',
               f.pjtdoc,
               f.pjndoc);
            commit;
          exception
            when others then
              dbms_output.put_line(sqlerrm);
              errorv := substr(sqlerrm, 1, 500);
              insert into jaqy592_er
                (JAQY592PROC,
                 JAQY592FECH,
                 JAQY592HORA,
                 JAQY592INST,
                 JAQY592REGL,
                 JAQY592DESC)
              values
                ('sp_busca_integrantes14',
                 trunc(sysdate),
                 to_char(sysdate, 'HH24:MI:SS'),
                 p_n_instan,
                 14,
                 errorv);
              commit;
          end;
        end loop; --M
      
      end if;
    
      --obtengo titular 2 fiadores
      for f in titular(d.sng003pgc, d.sng003cta) loop
      
        select count(*)
          into validar
          from JAQY591
         where JAQY591INSTAN = p_n_instan
           and JAQY591NDOC = f.pendoc
           and JAQY591TDOC = f.petdoc;
      
        if validar = 0 then
        
          if f.petdoc = 9 then
            tipo := 'F2';
          else
            tipo := 'F1';
          end if;
        
          correlativo := correlativo + 1;
        
          insert into JAQY591
            (JAQY591INSTAN,
             JAQY591INTEGR,
             JAQY591FCHSIS,
             JAQY591TIPERS,
             JAQY591TDOC,
             JAQY591NDOC)
          values
            (p_n_instan,
             'FIADOR_' || trim(to_char(correlativo)),
             sysdate,
             tipo,
             f.petdoc,
             f.pendoc);
          commit;
          --OBTENGO REPRESENTANTE LEGAL
          if f.petdoc = 9 then
          
            for e in repreLegal(f.pepais, f.petdoc, f.pendoc) loop
            
              begin
                correlativo2 := correlativo2 + 1;
              
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'PERSONJUR_F' || correlativo2,
                   sysdate,
                   'P3',
                   e.pftdo1,
                   e.pfndo1);
                commit;
              
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes15',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     15,
                     errorv);
                  commit;
              end;
            end loop;
          
            --obtener integracion jurifica de titular
            for e in integJuriJur(f.pepais, f.petdoc, f.pendoc) loop
              --M
              begin
                correlintF := correlintF + 1;
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'INTEGRJUR_F' || correlintF,
                   sysdate,
                   'I3',
                   e.pjtdoc,
                   e.pjndoc);
                commit;
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes16',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     16,
                     errorv);
                  commit;
              end;
            end loop; --M
          
          else
            --obtengo conyugue titular 2
            for e in conyugue(f.pepais, f.petdoc, f.pendoc) loop
            
              insert into JAQY591
                (JAQY591INSTAN,
                 JAQY591INTEGR,
                 JAQY591FCHSIS,
                 JAQY591TIPERS,
                 JAQY591TDOC,
                 JAQY591NDOC)
              values
                (p_n_instan,
                 'CONYUGUE_F' || trim(to_char(correlativo)),
                 sysdate,
                 'C2',
                 e.rptdoc,
                 e.rpndoc);
              commit;
            
              --obtener integracion jurifica de conyugue
              for g in integJuriNat(e.rppais, e.rptdoc, e.rpndoc) loop
                --M
                begin
                  correlintF := correlintF + 1;
                  insert into JAQY591
                    (JAQY591INSTAN,
                     JAQY591INTEGR,
                     JAQY591FCHSIS,
                     JAQY591TIPERS,
                     JAQY591TDOC,
                     JAQY591NDOC)
                  values
                    (p_n_instan,
                     'INTEGRJUR_F' || correlintF,
                     sysdate,
                     'I3',
                     g.pjtdoc,
                     g.pjndoc);
                  commit;
                exception
                  when others then
                    dbms_output.put_line(sqlerrm);
                    errorv := substr(sqlerrm, 1, 500);
                    insert into jaqy592_er
                      (JAQY592PROC,
                       JAQY592FECH,
                       JAQY592HORA,
                       JAQY592INST,
                       JAQY592REGL,
                       JAQY592DESC)
                    values
                      ('sp_busca_integrantes17',
                       trunc(sysdate),
                       to_char(sysdate, 'HH24:MI:SS'),
                       p_n_instan,
                       17,
                       errorv);
                    commit;
                end;
              end loop; --M
            
            end loop;
          
            --obtener integracion jurifica de conyugue
            for g in integJuriNat(f.pepais, f.petdoc, f.pendoc) loop
              --M
              begin
                correlintF := correlintF + 1;
                insert into JAQY591
                  (JAQY591INSTAN,
                   JAQY591INTEGR,
                   JAQY591FCHSIS,
                   JAQY591TIPERS,
                   JAQY591TDOC,
                   JAQY591NDOC)
                values
                  (p_n_instan,
                   'INTEGRJUR_F' || correlintF,
                   sysdate,
                   'I3',
                   g.pjtdoc,
                   g.pjndoc);
                commit;
              exception
                when others then
                  dbms_output.put_line(sqlerrm);
                  errorv := substr(sqlerrm, 1, 500);
                  insert into jaqy592_er
                    (JAQY592PROC,
                     JAQY592FECH,
                     JAQY592HORA,
                     JAQY592INST,
                     JAQY592REGL,
                     JAQY592DESC)
                  values
                    ('sp_busca_integrantes18',
                     trunc(sysdate),
                     to_char(sysdate, 'HH24:MI:SS'),
                     p_n_instan,
                     18,
                     errorv);
                  commit;
              end;
            end loop; --M
          
          end if;
        
        end if;
      
      end loop;
    
    end loop;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_integrantes19',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         19,
         errorv);
      commit;
    
  end sp_busca_integrantes;

  --//

  procedure sp_busca_regla_bantotal(p_n_instan number,
                                    p_n_nroreg number,
                                    p_c_tipint varchar2,
                                    p_c_usuari varchar2,
                                    p_c_rpttit out varchar2,
                                    p_n_correl out number) is
  
    /*cursor integrantes is
    Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
      from JAQY591
     where JAQY591instan = p_n_instan
       and JAQY591TIPERS in
           (select JAQY590DESC3
              from JAQY590 a
             where jaqy590cod = 1
               and jaqy590cod1 = 1
               and jaqy590corr1 = 3
               and jaqy590corr2 = p_n_nroreg);*/
  
    cursor integrantes is
      Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
         and '1' = p_c_tipint
      UNION
      select aqpa012tdoc, aqpa012ndoc, aqpa012integr
        from aqpa012
       where aqpa012corre = p_n_instan
         and aqpa012aux3 in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
            --and '2' = p_c_tipint;
         and p_c_tipint in ('2', '3'); --04/05/2022 APACHECOH Se le agrego buro 3 Equifax
  
    l_n_tipdoc number;
    l_n_tipdo2 number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_c_rptrcc varchar2(100);
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_n_flgact number;
    errorv     varchar2(500);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       p_c_tipint, --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    commit;
    -- por cada integrantes del credito
    for d in integrantes loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
    
      If p_n_nroreg IN (1, 2, 3, 13, 14, 15) then
      
        --CALIFICACION PERDIDA MAYOR
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.sp_cr_calperdidaGen(l_n_tipdoc,
                                                l_c_numdoc,
                                                p_n_nroreg,
                                                l_c_rptrcc);
      
        sp_valida_calif_activo(l_c_rptrcc, l_n_flgact);
      
      end if;
    
      If p_n_nroreg IN (4, 5, 6, 16, 17, 18) then
      
        --CALIFICACION DUDOSO
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.sp_cr_caldudosoGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrcc);
      
        sp_valida_calif_activo(l_c_rptrcc, l_n_flgact);
      
      end if;
    
      If p_n_nroreg IN (7, 8, 9, 19, 20, 21) then
      
        --CALIFICACION DEFICIENTE
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.sp_cr_caldeficientegen(l_n_tipdoc,
                                                   l_c_numdoc,
                                                   p_n_nroreg,
                                                   l_c_rptrcc);
      
        sp_valida_calif_activo(l_c_rptrcc, l_n_flgact);
      
      end if;
    
      If p_n_nroreg IN (10, 11, 12) then
      
        --CALIFICACION CPP
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_CalCppGen(l_n_tipdoc,
                                            l_c_numdoc,
                                            p_n_nroreg,
                                            l_c_rptrcc);
      
        sp_valida_calif_activo(l_c_rptrcc, l_n_flgact);
      
      end if;
    
      --apachecoh 2022.08.25 se quitaron reglas 7, 8, 10
      If p_n_nroreg in
         (1, 2, 3, 4, 5, 6, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21) then
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc, --l_d_rccant,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        --in: l_c_rptfin respuesta final
        --    l_c_rptind ultima respuesta individual
        --out:l_c_rptfin respuesta final
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      --apachecoh 2022.08.25 modificaciones de reglas
      If p_n_nroreg = 10 then
      
        sp_proceso_reg(p_n_correl,
                       p_n_nroreg,
                       l_c_rptrcc,
                       l_d_perrcc, --l_d_rccant,
                       l_n_tipdoc,
                       l_c_numdoc,
                       l_n_flgact,
                       4,
                       l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      If p_n_nroreg in (7, 8) then
      
        sp_proceso_reg(p_n_correl,
                       p_n_nroreg,
                       l_c_rptrcc,
                       l_d_perrcc, --l_d_rccant,
                       l_n_tipdoc,
                       l_c_numdoc,
                       l_n_flgact,
                       4,
                       l_c_rptind);
      
        pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               0,
                                               l_c_rptrcc);
      
        sp_proceso_reg(p_n_correl,
                       p_n_nroreg,
                       l_c_rptrcc,
                       l_d_perrcc, --l_d_rccant,
                       l_n_tipdoc,
                       l_c_numdoc,
                       l_n_flgact,
                       1,
                       l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
      --apachecoh 2022.08.25
    
      If p_n_nroreg in (13, 14, 15, 16, 17, 18, 19, 20, 21) then
        --si no se cumple la regla, se validará si tiene que ser bloqueante o excepcion
        If l_c_rptfin = 'N' then
          --CALIFICACION NORMAL
          --in: numero documento persona
          --out: arreglo con los porcentajes separados con ;
        
          pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                                 l_c_numdoc,
                                                 0,
                                                 l_c_rptrcc);
        
          --l_n_flgact := 1;
        
          sp_proceso(p_n_correl,
                     0,
                     l_c_rptrcc,
                     l_d_perrcc,
                     l_n_tipdoc,
                     l_c_numdoc,
                     l_n_flgact,
                     l_c_rptind);
        
          --in: l_c_rptfin respuesta final
          --    l_c_rptind ultima respuesta individual
          --out:l_c_rptfin respuesta final
          if l_c_rptind = 'N' then
            l_c_rptfin := 'B';
          else
            l_c_rptfin := 'N';
          end if;
          --sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      end if;
    
      If p_n_nroreg = 22 then
      
        --JUDICIAL CASTIGADO 13 a 24
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_JudCastCC(l_n_tipdoc, --chernandez 07/11/2019 se puso saldo con caja
                                            l_c_numdoc,
                                            p_n_nroreg,
                                            l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
        --chernandez 07/11/2019
        pq_cr_variables_rcc.Sp_cr_JudCastCMACVar(604,
                                                 l_n_tipdoc,
                                                 l_c_numdoc,
                                                 p_n_nroreg,
                                                 l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
        /*chernandez 07/11/2019
        pq_cr_variables_rcc.Sp_cr_JudCast13(l_n_tipdoc,
                                            l_c_numdoc,
                                            l_c_rptrcc);
        
        l_n_flgact := 1;
        
        l_d_perrcc := add_months(l_d_perrcc, -12);
        
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
        
        --in: l_c_rptfin respuesta final
        --    l_c_rptind ultima respuesta individual
        --out:l_c_rptfin respuesta final
        
        sp_resolverRpt(l_c_rptfin, l_c_rptind);*/
      
      end if;
    
      If p_n_nroreg in (24) then
      
        --REFINANCIADO 12
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_RefinSCVar(l_n_tipdoc, --chernandez 07/11/2019
                                             l_c_numdoc,
                                             p_n_nroreg,
                                             l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      If p_n_nroreg in (25) then
      
        --REFINANCIADO 12 caja
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
        pq_cr_variables_rcc.Sp_cr_RefinCMACVar(l_n_tipdoc, --chernandez 07/11/2019
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrcc);
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
        pq_cr_variables_rcc.Sp_cr_RefinCMAC(604,
                                            l_n_tipdoc,
                                            l_c_numdoc,
                                            p_n_nroreg,
                                            l_c_rptrcc);
        --l_c_rptind := l_c_rptind || ';';
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      --//chernandez 16/10/2017
      If p_n_nroreg in (40, 53) then
        --chernandez 11/01/2019
      
        --NORMAL 6 8 
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      --//chernandez 17/10/2017
      If p_n_nroreg in (41) then
      
        --DEF DUD PER ultimo periodo 1 %
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_CalDeficienteGen(l_n_tipdoc,
                                                   l_c_numdoc,
                                                   p_n_nroreg,
                                                   l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
        -----
      
        pq_cr_variables_rcc.Sp_cr_CalDudosoGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
        -----
      
        pq_cr_variables_rcc.Sp_cr_CalPerdidaGen(l_n_tipdoc,
                                                l_c_numdoc,
                                                p_n_nroreg,
                                                l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      --//chernandez 16/10/2017
      If p_n_nroreg in (47) then
      
        if d.JAQY591integr = 'CONYUGUE_1' then
          --NORMAL 12
          --in: numero documento persona
          --out: arreglo con los porcentajes separados con ;
        
          pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                                 l_c_numdoc,
                                                 p_n_nroreg,
                                                 l_c_rptrcc);
        
          l_n_flgact := 1;
        
          sp_proceso(p_n_correl,
                     p_n_nroreg,
                     l_c_rptrcc,
                     l_d_perrcc,
                     l_n_tipdoc,
                     l_c_numdoc,
                     l_n_flgact,
                     l_c_rptind);
        
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      
      end if;
      --chernandez 06/06/2018
      If p_n_nroreg = 48 then
      
        --JUDICIAL CASTIGADO 1 a 24 incluyendo caja
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_JudCastCC(l_n_tipdoc,
                                            l_c_numdoc,
                                            p_n_nroreg,
                                            l_c_rptrcc);
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
    end loop;
    commit;
  
    p_c_rpttit := l_c_rptfin;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT = trim(l_c_rptfin),
           jaqy588horaf = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = p_c_tipint;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_regla_bantotal',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_regla_bantotal;

  --//

  procedure sp_busca_regla_buro(p_n_instan number,
                                p_n_nroreg number,
                                p_c_tipint varchar2,
                                p_c_usuari varchar2,
                                p_c_rpttit in out varchar2, --chernandez 12/07/2019
                                p_n_correl in out number) is
  
    cursor integrantes is
      select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             (select aqpa011iseria
                from aqpa011i
               where aqpa011itdoc = JAQY591tdoc
                 and aqpa011indoc = JAQY591ndoc
                 and aqpa011iburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)
                 and aqpa011iinsta = p_n_instan
                 and rownum = 1) JAQY591Serial, --chernandez 12/07/2018
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) JAQY591Buro --chernandez 12/07/2018
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
         and '-1' = p_c_tipint
      UNION
      select aqpa012tdoc,
             aqpa012ndoc,
             aqpa012integr,
             (select max(aqpa011lseria)
                from aqpa011l
               where aqpa011ltdoc = aqpa012tdoc
                 and aqpa011lndoc = aqpa012ndoc
                 and aqpa011lnucon = to_number(p_c_rpttit)
                 and aqpa011lburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)) aqpa012Serial,
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) AQPA012buro
        from aqpa012
       where aqpa012corre = p_n_instan
         and aqpa012aux3 in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg);
    --and '2' = p_c_tipint;  -- DCASTRO 07/02 se modifico
    --and  p_c_tipint in ('2', '3');  --- DCASTRO 07/02 se modifico
    --04/05/2022 APACHECOH se cambio para considerar 1
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_c_estcon varchar2(30);
    l_n_monsun numeric(18, 2);
    l_n_tipBur numeric(5, 0);
    l_n_serial numeric(9, 0);
    l_n_proacl numeric(5, 0);
    l_n_cantde numeric(5, 0);
    l_n_estcon numeric(5, 0);
    errorv     varchar2(500);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
  
    l_n_tipBur := p_n_correl;
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       p_c_tipint, --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    commit;
  
    -- por cada integrantes del credito  
    l_n_estcon := 1;
  
    for d in integrantes loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
      l_n_serial := d.jaqy591serial;
      l_n_tipBur := d.jaqy591buro;
    
      if d.jaqy591serial is null or d.jaqy591serial = 0 then
        --chernandez 09/10/2018
        --chernandez 12/07/2018
        /* 09.02.2022 - HSUAREZ
        if l_n_tipBur = 1 then
          l_n_tipBur := 2;
        else
          l_n_tipBur := 1;
        end if;
        */
        l_n_tipBur := p_c_tipint; --l_n_tipBur := 3;  --- 07/02/2022 DCASTRO verificar cambio equifax
      
        begin
          --if p_c_tipint = '2' then    --- 07/02/2022 DCASTRO comentado
          --if p_c_tipint in ( '2', '3') then   --- 07/02/2022 DCASTRO se agrego tipo 3 equifax
          --04/05/2022 APACHECOH se llama solo a la aqpa011l y no a la aqpa011i
          select aqpa011lseria
            into l_n_serial
            from aqpa011l
           where aqpa011ltdoc = l_n_tipdoc
             and aqpa011lndoc = l_c_numdoc
             and aqpa011lburo = l_n_tipBur
             and aqpa011lestad = 1
             and aqpa011lnucon = to_number(p_c_rpttit)
             and rownum = 1;
        exception
          when others then
            --l_n_estcon := 0; no grabar esto
            l_n_serial := 0;
        end;
      
      end if;
    
      if l_n_estcon = 1 then
      
        --Regla 31
        If p_n_nroreg in (31) then
        
          if l_n_tipBur = 1 then
            --ANTIGUO experian
            select count(*)
              into l_n_cantde
              from JAQL548 v
             where jaql548estado <> '06'
               and jaql548indbo = '0'
               and jaql546serial = l_n_serial
                  --chernandez 29/05/2018 se agrego ticta
               and jaql548ticta in
                   (select jaqy590desc2
                      from jaqy590
                     where jaqy590cod = 1
                       and jaqy590cod1 = 1
                       and jaqy590corr1 = 10
                       and jaqy590corr2 = 1)
               and (INSTR(substr(jaql548compor, 1, 12), '1', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), '2', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), '3', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), '4', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), '5', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), '6', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), 'D', 1) > 0 or
                   INSTR(substr(jaql548compor, 1, 12), 'C', 1) > 0);
          
          else
            if l_n_tipBur = 2 then
              --NUEVO experian
              select count(*)
                into l_n_cantde
                from JAQL548 v
               where jaql548estado <> '06'
                 and jaql548indbo = '3'
                 and jaql546serial = l_n_serial
                 and jaql548regu = 'NR'
                 /*and jaql548ticta in
                     (select jaqy590desc2
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 10
                         and jaqy590corr2 = 1)*/
                 and (INSTR(substr(JAQL548compor, 1, 12), '1', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), '2', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), '3', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), '4', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), '5', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), '6', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), 'D', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), 'C', 1) > 0 or
                     INSTR(substr(JAQL548compor, 1, 12), 'J', 1) > 0);
              --sentinel
              /*select count(*)
               into l_n_cantde
               from JAQZ238 v
              where JAQZ238estado <> '06'
                and JAQZ238indbo = '0'
                and JAQZ238serial = l_n_serial
                   --chernandez 29/05/2018 se agrego ticta
                and JAQZ238ticta in
                    (select jaqy590desc2
                       from jaqy590
                      where jaqy590cod = 1
                        and jaqy590cod1 = 1
                        and jaqy590corr1 = 10
                        and jaqy590corr2 = 1)
                and (INSTR(substr(JAQZ238compor, 1, 12), '1', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), '2', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), '3', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), '4', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), '5', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), '6', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), 'D', 1) > 0 or
                    INSTR(substr(JAQZ238compor, 1, 12), 'C', 1) > 0);*/
              --2022.09.21 dcastro
            else
              --equifax --apachecoh 2022.01.18
              select count(*)
                into l_n_cantde
                from AQPB515B
               where AQPB515Bestado <> '06'
                 and AQPB515Bindbo = '3'
                 and AQPB515Bserial = l_n_serial
                 and AQPB515Bticta in
                     (select jaqy590desc2
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 10
                         and jaqy590corr2 = 1)
                 and (INSTR(substr(AQPB515Bcompor, 1, 12), '1', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), '2', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), '3', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), '4', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), '5', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), '6', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), 'D', 1) > 0 or
                     INSTR(substr(AQPB515Bcompor, 1, 12), 'C', 1) > 0);
              /*and AQPB515Bcondic in
              (select trim(tp1desc) 
                  from fst198 
               where tp1cod = 1 
                  and tp1cod1 = 11146 
                  and tp1corr1 = 1 
                  and tp1corr2 = 27 
                  and tp1corr3 > 0 
                  and tp1nro1 = 1 );*/
              --apachecoh 2022.01.18                           
            end if;
          
          end if;
        
          If l_n_cantde = 0 then
            l_c_rptind := 'S';
          else
            l_c_rptind := 'N';
          end if;
        
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        
        end if;
      
        --Regla 32
        If p_n_nroreg in (32) then
          --estado activo en sunat
          if l_n_tipdoc = 9 then
            begin
              if l_n_tipBur = 1 then
                --ANTIGUO experian
                select JAQL546escon
                  into l_c_estcon
                  from JAQL546
                 where JAQL546nudoc = l_c_numdoc
                   and jaql546tidob = l_n_tipdoc
                   and JAQL546coret = '13'
                   and jaql546serial = l_n_serial;
              else
                if l_n_tipBur = 2 then
                  --NUEVO experian
                  select JAQL546escon
                    into l_c_estcon
                    from JAQL546
                   where JAQL546nudoc = l_c_numdoc
                     and jaql546tidob = l_n_tipdoc
                     and JAQL546coret = '0 '
                     and jaql546serial = l_n_serial;
                  --sentinel
                  /*select jaqz236escon
                   into l_c_estcon
                   from jaqz236
                  where jaqz236nudoc = l_c_numdoc
                    and jaqz236tidob = l_n_tipdoc
                    and jaqz236coret in ('00', '03') --chernandez 09/10/2018
                    and jaqz236serial = l_n_serial;*/
                else
                  --equifax --apachecoh 2022.01.18
                  select AQPB515escon
                    into l_c_estcon
                    from AQPB515
                   where AQPB515nudoc = l_c_numdoc
                     and AQPB515tidob = l_n_tipdoc
                     and AQPB515coret in ('00', '03')
                     and AQPB515serial = l_n_serial;
                  --apachecoh 2022.01.18
                end if;
              end if;
            exception
              when others then
                begin
                  select jaqy594est
                    into l_c_estcon
                    from jaqy594
                   where jaqy594tdo = l_n_tipdoc
                     and jaqy594ndo = l_c_numdoc;
                exception
                  when others then
                    l_c_estcon := '--';
                end;
            end;
            If l_c_estcon = 'ACTIVO' then
              l_c_rptind := 'S';
            else
              l_c_rptind := 'N';
            end if;
          
          else
            --si no es ruc
            l_c_rptind := 'S';
          end if;
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      
        --Regla 33
        If p_n_nroreg in (33) then
          --deuda cobranza coactiva < 100        
          begin
            if l_n_tipBur = 1 then
              --ANTIGUO experian
              select sum(JAQL604mtode)
                into l_n_monsun
                from JAQL604
               where jaql546serial = l_n_serial
                 and jaql604tidet = 30;
            else
              if l_n_tipBur = 2 then
                --NUEVO experian
                select sum(JAQL604mtode)
                  into l_n_monsun
                  from JAQL604
                 where jaql546serial = l_n_serial
                   and jaql604aux1 = 999
                   --and jaql604perio = TO_CHAR(SYSDATE, 'YYYYMM') 
                   and TO_DATE(jaql604perio, 'YYYYMM') >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -48)
                   and jaql604tidet = 30;
                --sentinel
                /*select sum(JAQZ244mtode)
                  into l_n_monsun
                  from JAQZ244
                where JAQZ244serial = l_n_serial
                   and JAQZ244tidet = 30;*/
              else
                --equifax --apachecoh 2022.01.18
                select sum(AQPB515Hmtode)
                  into l_n_monsun
                  from AQPB515H
                 where AQPB515Hserial = l_n_serial
                   and AQPB515Htidet = 30;
                --apachecoh 2022.01.18                 
              end if;
            end if;
          exception
            when others then
              l_n_monsun := 0;
          end;
          If l_n_monsun < 100 or l_n_monsun is null then
            l_c_rptind := 'S';
          else
            l_c_rptind := 'N';
          end if;
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      
        --Regla 34
        If p_n_nroreg in (34) then
          --inicio de actividades sunat 24 meses        
          if l_n_tipBur = 1 then
            --ANTIGUO experian
            select case
                     when add_months(jaql546fealt, 24) <= trunc(sysdate) then
                      'S'
                     else
                      'N'
                   end
              into l_c_rptind
              from jaql546
             where jaql546nudoc = l_c_numdoc
               and jaql546tidob = l_n_tipdoc
               and jaql546serial = l_n_serial;
          else
            if l_n_tipBur = 2 then
              --NUEVO experian
              select case
                       when add_months(jaql546fealt, 24) <= trunc(sysdate) then
                        'S'
                       else
                        'N'
                     end
                into l_c_rptind
                from jaql546
               where jaql546nudoc = l_c_numdoc
                 and jaql546tidob = l_n_tipdoc
                 and jaql546serial = l_n_serial;
              --sentinel
              /*select case
                      when add_months(jaqz236fealt, 24) <= trunc(sysdate) then
                       'S'
                      else
                       'N'
                    end
               into l_c_rptind
               from jaqz236
              where jaqz236nudoc = l_c_numdoc
                and jaqz236tidob = l_n_tipdoc
                and jaqz236serial = l_n_serial;*/
            else
              --equifax --apachecoh 2022.01.18
              select case
                       when add_months(AQPB515fealt, 24) <= trunc(sysdate) then
                        'S'
                       else
                        'N'
                     end
                into l_c_rptind
                from AQPB515
               where AQPB515nudoc = l_c_numdoc
                 and AQPB515tidob = l_n_tipdoc
                 and AQPB515serial = l_n_serial;
              --apachecoh 2022.01.18
            end if;
          end if;
        
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        
        end if;
      
        --Regla 35
        If p_n_nroreg in (35) then
          --inicio de actividades sunat 36 meses        
          if l_n_tipBur = 1 then
            --ANTIGUO experian
            select case
                     when add_months(jaql546fealt, 36) <= trunc(sysdate) then
                      'S'
                     else
                      'N'
                   end
              into l_c_rptind
              from jaql546
             where jaql546nudoc = l_c_numdoc
               and jaql546tidob = l_n_tipdoc
               and jaql546serial = l_n_serial;
          else
            if l_n_tipBur = 2 then
              --NUEVO experian
              select case
                       when add_months(jaql546fealt, 36) <= trunc(sysdate) then
                        'S'
                       else
                        'N'
                     end
                into l_c_rptind
                from jaql546
               where jaql546nudoc = l_c_numdoc
                 and jaql546tidob = l_n_tipdoc
                 and jaql546serial = l_n_serial;
              --sentinel
              /*select case
                      when add_months(jaqz236fealt, 36) <= trunc(sysdate) then
                       'S'
                      else
                       'N'
                    end
               into l_c_rptind
               from jaqz236
              where jaqz236nudoc = l_c_numdoc
                and jaqz236tidob = l_n_tipdoc
                and jaqz236serial = l_n_serial;*/
            else
              --equifax --apachecoh 2022.01.18
              select case
                       when add_months(AQPB515fealt, 36) <= trunc(sysdate) then
                        'S'
                       else
                        'N'
                     end
                into l_c_rptind
                from AQPB515
               where AQPB515nudoc = l_c_numdoc
                 and AQPB515tidob = l_n_tipdoc
                 and AQPB515serial = l_n_serial;
              --apachecoh 2022.01.18  
            end if;
          end if;
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      
        --        
        If p_n_nroreg in (36) then
          if l_n_tipBur = 1 then
            --ANTIGUO experian
            select count(*)
              into l_n_proacl
              from (select *
                      from JAQL601
                     where jaql546serial = l_n_serial
                       and jaql601tidet = 23
                       and jaql601fereg >= trunc(sysdate) - 365
                       and jaql601tireg = 'PR'
                    UNION
                    select *
                      from JAQL601
                     where jaql546serial = l_n_serial
                       and jaql601tidet = 23
                       and to_char(jaql601fereg, 'dd/mm/yyyy') =
                           '01/01/0001'
                       and jaql601tireg = 'PR');
          else
            if l_n_tipBur = 2 then
              --NUEVO experian
              select count(*)
                into l_n_proacl
                from (select *
                        from JAQL601
                       where jaql546serial = l_n_serial
                         and jaql601tidet = 23
                         and jaql601fereg >= trunc(sysdate) - 365
                         and jaql601tireg = 'PR'
                      UNION
                      select *
                        from JAQL601
                       where jaql546serial = l_n_serial
                         and jaql601tidet = 23
                         and to_char(jaql601fereg, 'dd/mm/yyyy') =
                             '01/01/0001'
                         and jaql601tireg = 'PR');
              --sentinel
              /*select count(*)
              into l_n_proacl
              from (select *
                      from JAQZ241
                     where JAQZ241serial = l_n_serial
                       and JAQZ241tidet = 23
                       and JAQZ241fereg >= trunc(sysdate) - 365
                       and JAQZ241tireg = 'PR'
                    UNION
                    select *
                      from JAQZ241
                     where JAQZ241serial = l_n_serial
                       and JAQZ241tidet = 23
                       and to_char(JAQZ241fereg, 'dd/mm/yyyy') =
                           '01/01/0001'
                       and JAQZ241tireg = 'PR');*/
            else
              --equifax --apachecoh 2022.01.18
              select count(*)
                into l_n_proacl
                from (select *
                        from AQPB515E
                       where AQPB515Eserial = l_n_serial
                         and AQPB515Etidet = 23
                         and AQPB515Efereg >= trunc(sysdate) - 365
                         and AQPB515Etireg = 'PR'
                      UNION
                      select *
                        from AQPB515E
                       where AQPB515Eserial = l_n_serial
                         and AQPB515Etidet = 23
                         and to_char(AQPB515Efereg, 'dd/mm/yyyy') =
                             '01/01/0001'
                         and AQPB515Etireg = 'PR');
              --apachecoh 2022.01.18
            end if;
          end if;
        
          if l_n_proacl = 0 then
            l_c_rptind := 'S';
          else
            l_c_rptind := 'N';
          end if;
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        end if;
      
        --Regla 37
        If p_n_nroreg in (37) then
          --afp onp essalud
          if l_n_tipdoc = 9 then
          
            if l_n_tipBur = 1 then
              --ANTIGUO experian
              select sum(contador)
                into l_n_proacl
                from (select count(*) as contador
                        from JAQL604
                       where jaql546serial = l_n_serial
                         and jaql604entid in (2, 3)
                      union
                      select count(*) as contador
                        from JAQL608
                       where jaql546serial = l_n_serial);
            else
              if l_n_tipBur = 2 then
                --NUEVO experian
                select sum(contador)
                  into l_n_proacl
                  from (select count(*) as contador
                          from JAQL604
                         where jaql546serial = l_n_serial
                           and jaql604entid in (2, 3)
                           and jaql604perio = TO_CHAR(SYSDATE, 'YYYYMM') 
                           and jaql604aux1 = 999
                        union
                        select count(*) as contador
                          from JAQL608
                         where jaql546serial = l_n_serial);
                --sentinel
                /*select sum(contador)
                into l_n_proacl
                from (select count(*) as contador
                        from JAQZ244
                       where JAQZ244serial = l_n_serial
                         and JAQZ244entid in (2, 3)
                      union
                      select count(*) as contador
                        from JAQZ248
                       where JAQZ248serial = l_n_serial);*/
              else
                --equifax --apachecoh 2022.01.18                 
                select sum(contador)
                  into l_n_proacl
                  from (select count(*) as contador
                          from AQPB515H
                         where AQPB515Hserial = l_n_serial
                           and AQPB515Hentid in (2, 3)
                        union
                        select count(*) as contador
                          from AQPB515L
                         where AQPB515Lserial = l_n_serial);
                --apachecoh 2022.01.18
              end if;
            end if;
          
            if l_n_proacl = 0 then
              l_c_rptind := 'S';
            else
              l_c_rptind := 'N';
            end if;
          
          else
            --si no es ruc
            l_c_rptind := 'S';
          end if;
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        
        end if;
      
        -- Regla 50
        If p_n_nroreg in (50) then
          --solo para precalificación
          --inicio de actividades sunat 24 meses        
          begin
            select case
                     when to_char(JAQY594fec, 'dd/mm/yyyy') = '01/01/0001' then
                      0
                     else
                      trunc((trunc(sysdate) - JAQY594fec) / 30)
                   end
              into l_n_cantde
              from jaqy594
             where jaqy594tdo = l_n_tipdoc
               and jaqy594ndo = l_c_numdoc;
          exception
            when others then
              l_n_cantde := 0;
          end;
          l_c_rptind := 'N';
        
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        
        end if;
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      else
        l_c_rptfin := 'E';
      end if;
    
    end loop;
  
    commit;
  
    p_c_rpttit := l_c_rptfin;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT = trim(l_c_rptfin),
           jaqy588horaf = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = p_c_tipint;
  
    commit;
    If p_n_nroreg in (50) then
      p_n_correl := l_n_cantde;
    End If;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_regla_buro',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_regla_buro;

  --//

  procedure sp_busca_regla_enti(p_n_instan number,
                                p_n_nroreg number,
                                p_c_usuari varchar2,
                                p_c_rpttit out varchar2,
                                p_c_rptttt out varchar2,
                                p_c_rptcon out varchar2,
                                p_c_canent in out varchar2,
                                p_n_correl in out number) is
    --reglas 27 y 28
    cursor integrantes(p_c_tipint varchar2,
                       l_c_ingres char,
                       l_n_numcon number) is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             (select aqpa011iseria
                from aqpa011i
               where aqpa011itdoc = JAQY591tdoc
                 and aqpa011indoc = JAQY591ndoc
                 and aqpa011iburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)
                 and aqpa011iinsta = p_n_instan
                 and rownum = 1) JAQY591Serial, --chernandez 12/07/2018
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) JAQY591Buro --chernandez 12/07/2018
        from JAQY591
       where JAQY591instan = p_n_instan
         and (((JAQY591integr like 'TITULAR_%' or
             JAQY591integr like 'REP. LEGAL%') and
             ('T' = p_c_tipint or 'A' = p_c_tipint))
             
             or (JAQY591integr in
             ('CONYUGUE_1', 'CONYUGUE_2', 'CONYUGE_1', 'CONYUGE_2') and
             ('C' = p_c_tipint or 'A' = p_c_tipint))
             
             or (JAQY591integr in ('CONYUGUE_F1',
                                    'CONYUGUE_F2',
                                    'CONYUGE_F1',
                                    'CONYUGE_F2',
                                    'FIADOR_1',
                                    'FIADOR_2') and ('F' = p_c_tipint) or
             'A' = p_c_tipint)
             
             or (JAQY591integr = 'EMPLEADOR' and 'E' = p_c_tipint))
         and '1' = l_c_ingres
      
      UNION
      
      Select aqpa012tdoc,
             aqpa012ndoc,
             aqpa012integr,
             (select aqpa011lseria
                from aqpa011l
               where aqpa011ltdoc = aqpa012tdoc
                 and aqpa011lndoc = aqpa012ndoc
                 and aqpa011lburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)
                 and aqpa011lnucon = l_n_numcon
                 and rownum = 1) aqpa012Serial,
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) AQPA012buro
        from aqpa012
       where aqpa012corre = p_n_instan
         and (((aqpa012integr like 'TITULAR_%' or
             aqpa012integr like 'REP. LEGAL%') and
             ('T' = p_c_tipint or 'A' = p_c_tipint))
             
             or (aqpa012integr in
             ('CONYUGUE_1', 'CONYUGUE_2', 'CONYUGE_1', 'CONYUGE_2') and
             ('C' = p_c_tipint or 'A' = p_c_tipint))
             
             or (aqpa012integr in ('CONYUGUE_F1',
                                    'CONYUGUE_F2',
                                    'CONYUGE_F1',
                                    'CONYUGE_F2',
                                    'FIADOR_1',
                                    'FIADOR_2') and ('F' = p_c_tipint) or
             'A' = p_c_tipint)
             
             or (aqpa012integr = 'EMPLEADOR' and 'E' = p_c_tipint))
         and '2' = l_c_ingres;
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_c_rptrcc varchar2(100);
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_n_flgact number;
    l_n_tipBur numeric(5, 0);
    l_n_serial numeric(9, 0);
    l_n_canent numeric(5, 0);
    l_n_estcon numeric(5, 0);
    l_n_numcon numeric(9, 0);
    vi_buro    number(3);
    errorv     varchar2(500);
  
    l_c_ingres char(1);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
    l_n_flgact := 1;
  
    l_c_ingres := to_char(p_n_correl);
  
    if l_c_ingres = '2' then
      l_n_numcon := to_number(p_c_canent);
    end if;
    p_c_canent := null;
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       l_c_ingres, --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    commit;
    -- por cada integrantes del credito
    l_n_canent := 0;
  
    l_n_estcon := 1;
  
    for d in integrantes('T', l_c_ingres, l_n_numcon) loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
      l_n_serial := d.jaqy591serial;
      l_n_tipBur := d.jaqy591buro;
    
      if d.jaqy591serial is null then
        --chernandez 12/07/2018
        if l_n_tipBur = 1 then
          l_n_tipBur := 2;
        else
          l_n_tipBur := 1;
        end if;
        --AGREGADO AQPA011L 11.02.2022 CONSULTA BURO.
        BEGIN
          select L.AQPA011LBURO
            INTO vi_buro
            from AQPA011L L
           WHERE L.aqpa011lnucon = l_n_numcon
                --AND L.aqpa011lseria = p_n_serial
             and l.aqpa011lestad = 1
             and l.aqpa011lhora = (select min(b.aqpa011lhora)
                                     from aqpa011l b
                                    where b.aqpa011lnucon = l_n_numcon
                                      and b.aqpa011lestad = 1
                                   --AND b.aqpa011lseria = p_n_serial
                                   )
             and rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            vi_buro := 1;
        END;
        begin
          if l_c_ingres = '2' then
          
            select aqpa011lseria
              into l_n_serial
              from aqpa011l
             where aqpa011ltdoc = l_n_tipdoc
               and aqpa011lndoc = l_c_numdoc
               and aqpa011lburo = vi_buro --se cambio l_n_tipbur por vi_buro 11.02.2022
               and aqpa011lestad = 1
               and aqpa011lnucon = l_n_numcon
               and rownum = 1;
          else
            select aqpa011iseria
              into l_n_serial
              from aqpa011i
             where aqpa011itdoc = l_n_tipdoc
               and aqpa011indoc = l_c_numdoc
               and aqpa011iburo = vi_buro
               and aqpa011iestad = 1
               and rownum = 1;
          end if;
        exception
          when others then
            l_n_estcon := 0;
        end;
      
      end if;
    
      if l_n_estcon = 1 then
      
        /*l_n_serial := d.jaqy591serial;
        l_n_tipBur := d.jaqy591buro;*/
      
        sp_contador_entidades(l_n_tipdoc,
                              l_c_numdoc,
                              l_d_perrcc,
                              vi_buro, --se cambio l_n_tipbur por vi_buro 11.02.2022
                              l_n_serial,
                              l_n_canent);
      
        pq_cr_variables_rcc.Sp_cr_CalNormal6(l_n_tipdoc,
                                             l_c_numdoc,
                                             l_c_rptrcc);
      
        sp_proceso(p_n_correl,
                   0,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if; --conexion
    
    end loop;
  
    if l_n_estcon = 1 then
    
      --almaceno respuesta final de titulares
      p_c_rptttt := l_c_rptfin;
      l_c_rptfin := 'S';
    
      for d in integrantes('C', l_c_ingres, l_n_numcon) loop
      
        l_c_tipint := d.jaqy591integr;
        l_n_tipdoc := d.jaqy591tdoc;
        l_c_numdoc := d.jaqy591ndoc;
        l_n_serial := d.jaqy591serial;
        l_n_tipBur := d.jaqy591buro;
      
        if d.jaqy591serial is null then
          --chernandez 12/07/2018
          if l_n_tipBur = 1 then
            l_n_tipBur := 2;
          else
            l_n_tipBur := 1;
          end if;
          --AGREGADO AQPA011L 11.02.2022 CONSULTA BURO.
          BEGIN
            select L.AQPA011LBURO
              INTO vi_buro
              from AQPA011L L
             WHERE L.aqpa011lnucon = l_n_numcon
                  --AND L.aqpa011lseria = p_n_serial
               and l.aqpa011lestad = 1
               and l.aqpa011lhora = (select min(b.aqpa011lhora)
                                       from aqpa011l b
                                      where b.aqpa011lnucon = l_n_numcon
                                        and b.aqpa011lestad = 1
                                     --AND b.aqpa011lseria = p_n_serial
                                     )
               and rownum = 1;
          EXCEPTION
            WHEN OTHERS THEN
              vi_buro := 1;
          END;
          begin
            if l_c_ingres = '2' then
              select aqpa011lseria
                into l_n_serial
                from aqpa011l
               where aqpa011ltdoc = l_n_tipdoc
                 and aqpa011lndoc = l_c_numdoc
                 and aqpa011lburo = vi_buro --se cambio l_n_tipbur por vi_buro 11.02.2022
                 and aqpa011lestad = 1
                 and aqpa011lnucon = l_n_numcon
                 and rownum = 1;
            else
              select aqpa011iseria
                into l_n_serial
                from aqpa011i
               where aqpa011itdoc = l_n_tipdoc
                 and aqpa011indoc = l_c_numdoc
                 and aqpa011iburo = vi_buro --se cambio l_n_tipbur por vi_buro 11.02.2022
                 and aqpa011iestad = 1
                 and rownum = 1;
            end if;
          exception
            when others then
              l_n_estcon := 0;
          end;
        
        end if;
      
        if l_n_estcon = 1 then
        
          /*l_n_serial := d.jaqy591serial;
          l_n_tipBur := d.jaqy591buro;*/
        
          sp_contador_entidades(l_n_tipdoc,
                                l_c_numdoc,
                                l_d_perrcc,
                                vi_buro,
                                l_n_serial,
                                l_n_canent);
        
          pq_cr_variables_rcc.Sp_cr_CalNormal6(l_n_tipdoc,
                                               l_c_numdoc,
                                               l_c_rptrcc);
        
          sp_proceso(p_n_correl,
                     0,
                     l_c_rptrcc,
                     l_d_perrcc,
                     l_n_tipdoc,
                     l_c_numdoc,
                     l_n_flgact,
                     l_c_rptind);
        
          sp_resolverRpt(l_c_rptfin, l_c_rptind);
        
        end if;
      
      end loop;
      if l_n_estcon = 1 then
        --almaceno respuesta final de conyugue
        p_c_rptcon := l_c_rptfin;
        --obtengo respuesta final de conyugue y titular
        sp_resolverRpt(l_c_rptfin, p_c_rptttt);
        --almaceno cantidad final de entidades
        p_c_canent := l_n_canent;
      
        --si la calificacion normal no es 100% en los 6 ultimos periodos.
        if l_c_rptfin = 'N' then
        
          l_c_rptrcc := to_char(l_n_canent);
        
          sp_proceso(p_n_correl,
                     p_n_nroreg,
                     l_c_rptrcc,
                     l_d_rccant,
                     l_n_tipdoc,
                     l_c_numdoc,
                     l_n_flgact,
                     l_c_rptind);
        
          --si es S     
          if l_c_rptind = 'S' then
            --sino, no se muestra la regla
            l_c_rptfin := 'S';
          else
            --entonces se tiene que mostrar la regla            
            l_c_rptfin := 'N';
          end if;
        
        else
        
          l_c_rptfin := 'S';
        
        end if;
      else
      
        l_c_rptfin := 'E'; --sin data
      
      end if;
    else
    
      l_c_rptfin := 'E'; --sin data
    
    end if;
  
    commit;
  
    p_c_rpttit := l_c_rptfin;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT  = trim(l_c_rptfin),
           JAQY588RESVAR = trim(to_char(l_n_canent)),
           jaqy588horaf  = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = l_c_ingres;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_regla_enti',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_regla_enti;

  --//  

  procedure sp_busca_regla_enti2(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_c_rpttit in out varchar2,
                                 p_n_correl in out number) is
    --//--------------REGLAS 29 30
    cursor integrantes(p_c_tipint varchar2,
                       l_c_ingres char,
                       l_n_numcon number) is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             (select aqpa011iseria
                from aqpa011i
               where aqpa011itdoc = JAQY591tdoc
                 and aqpa011indoc = JAQY591ndoc
                 and aqpa011iburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)
                 and aqpa011iinsta = p_n_instan
                 and rownum = 1) JAQY591Serial, --chernandez 12/07/2018
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) JAQY591Buro --chernandez 12/07/2018
        from JAQY591
       where JAQY591instan = p_n_instan
         and (((JAQY591integr like 'TITULAR_%' or
             JAQY591integr like 'REP. LEGAL%') and
             ('T' = p_c_tipint or 'A' = p_c_tipint))
             
             or (JAQY591integr in
             ('CONYUGUE_1', 'CONYUGUE_2', 'CONYUGE_1', 'CONYUGE_2') and
             ('C' = p_c_tipint or 'A' = p_c_tipint))
             
             or (JAQY591integr in ('CONYUGUE_F1',
                                    'CONYUGUE_F2',
                                    'CONYUGE_F1',
                                    'CONYUGE_F2',
                                    'FIADOR_1',
                                    'FIADOR_2') and ('F' = p_c_tipint) or
             'A' = p_c_tipint)
             
             or (JAQY591integr = 'EMPLEADOR' and 'E' = p_c_tipint))
         and '1' = l_c_ingres
      
      UNION
      
      Select aqpa012tdoc,
             aqpa012ndoc,
             aqpa012integr,
             (select aqpa011lseria
                from aqpa011l
               where aqpa011ltdoc = aqpa012tdoc
                 and aqpa011lndoc = aqpa012ndoc
                 and aqpa011lburo =
                     (select jaqy590nro1
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 8
                         and jaqy590corr2 = 2
                         and jaqy590corr3 = p_n_nroreg)
                 and aqpa011lnucon = l_n_numcon
                 and rownum = 1) aqpa012Serial,
             (select jaqy590nro1
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 8
                 and jaqy590corr2 = 2
                 and jaqy590corr3 = p_n_nroreg) AQPA012buro
        from aqpa012
       where aqpa012corre = p_n_instan
         and (((aqpa012integr like 'TITULAR_%' or
             aqpa012integr like 'REP. LEGAL%') and
             ('T' = p_c_tipint or 'A' = p_c_tipint))
             
             or (aqpa012integr in
             ('CONYUGUE_1', 'CONYUGUE_2', 'CONYUGE_1', 'CONYUGE_2') and
             ('C' = p_c_tipint or 'A' = p_c_tipint))
             
             or (aqpa012integr in ('CONYUGUE_F1',
                                    'CONYUGUE_F2',
                                    'CONYUGE_F1',
                                    'CONYUGE_F2',
                                    'FIADOR_1',
                                    'FIADOR_2') and ('F' = p_c_tipint) or
             'A' = p_c_tipint)
             
             or (aqpa012integr = 'EMPLEADOR' and 'E' = p_c_tipint))
         and '2' = l_c_ingres;
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_c_rptrcc varchar2(100);
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_n_flgact number;
    l_n_tipBur numeric(5, 0);
    l_n_serial numeric(9, 0);
    l_n_canent numeric(5, 0);
    l_n_estcon numeric(5, 0);
    errorv     varchar2(500);
    l_c_ingres char(1);
    l_n_numcon numeric(9, 0);
    vi_buro    number(3);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
    l_n_flgact := 1;
  
    l_c_ingres := to_char(p_n_correl);
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       l_c_ingres, --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    commit;
    if l_c_ingres = '2' then
      l_n_numcon := to_number(p_c_rpttit);
    end if;
    p_c_rpttit := null;
    -- por cada integrantes del credito
    l_n_canent := 0;
    l_n_estcon := 1;
  
    for d in integrantes('T', l_c_ingres, l_n_numcon) loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
      l_n_serial := d.jaqy591serial;
      l_n_tipBur := d.jaqy591buro;
    
      if d.jaqy591serial is null then
        --chernandez 12/07/2018
        if l_n_tipBur = 1 then
          l_n_tipBur := 2;
        else
          l_n_tipBur := 1;
        end if;
        --AGREGADO AQPA011L 11.02.2022 CONSULTA BURO.
        BEGIN
          select L.AQPA011LBURO
            INTO vi_buro
            from AQPA011L L
           WHERE L.aqpa011lnucon = l_n_numcon
                --AND L.aqpa011lseria = p_n_serial
             and l.aqpa011lestad = 1
             and l.aqpa011lhora = (select min(b.aqpa011lhora)
                                     from aqpa011l b
                                    where b.aqpa011lnucon = l_n_numcon
                                      and b.aqpa011lestad = 1
                                   --AND b.aqpa011lseria = p_n_serial
                                   )
             and rownum = 1;
        EXCEPTION
          WHEN OTHERS THEN
            vi_buro := 1;
        END;
        begin
          if l_c_ingres = '2' then
            select aqpa011lseria
              into l_n_serial
              from aqpa011l
             where aqpa011ltdoc = l_n_tipdoc
               and aqpa011lndoc = l_c_numdoc
               and aqpa011lburo = vi_buro -- se cambio para que considere vi_buro
               and aqpa011lestad = 1
               and aqpa011lnucon = l_n_numcon
               and rownum = 1;
          else
            select aqpa011iseria
              into l_n_serial
              from aqpa011i
             where aqpa011itdoc = l_n_tipdoc
               and aqpa011indoc = l_c_numdoc
               and aqpa011iburo = l_n_tipBur
               and aqpa011iestad = 1
               and rownum = 1;
          end if;
        exception
          when others then
            l_n_estcon := 0;
        end;
      
      end if;
    
      if l_n_estcon = 1 then
      
        /*l_n_serial := d.jaqy591serial;
        l_n_tipBur := d.jaqy591buro;*/
        if p_n_nroreg = 49 then
          sp_cont_entid_cmac_all(l_n_tipdoc,
                                 l_c_numdoc,
                                 l_d_perrcc,
                                 l_n_tipBur,
                                 l_n_serial,
                                 l_n_canent);
        else
          sp_cont_entid_cmac(l_n_tipdoc,
                             l_c_numdoc,
                             l_d_perrcc,
                             l_n_tipBur,
                             l_n_serial,
                             l_n_canent);
        end if;
      
      end if;
    
    end loop;
  
    for d in integrantes('C', l_c_ingres, l_n_numcon) loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
      l_n_serial := d.jaqy591serial;
      l_n_tipBur := d.jaqy591buro;
    
      if d.jaqy591serial is null then
        --chernandez 12/07/2018
        if l_n_tipBur = 1 then
          l_n_tipBur := 2;
        else
          l_n_tipBur := 1;
        end if;
        begin
          if l_c_ingres = '2' then
          
            select aqpa011lseria
              into l_n_serial
              from aqpa011l
             where aqpa011ltdoc = l_n_tipdoc
               and aqpa011lndoc = l_c_numdoc
               and aqpa011lburo = l_n_tipBur
               and aqpa011lestad = 1
               and aqpa011lnucon = l_n_numcon
               and rownum = 1;
          else
            select aqpa011iseria
              into l_n_serial
              from aqpa011i
             where aqpa011itdoc = l_n_tipdoc
               and aqpa011indoc = l_c_numdoc
               and aqpa011iburo = l_n_tipBur
               and aqpa011iestad = 1
               and rownum = 1;
          end if;
        exception
          when others then
            l_n_estcon := 0;
        end;
      
      end if;
    
      if l_n_estcon = 1 then
      
        /*l_n_serial := d.jaqy591serial;
        l_n_tipBur := d.jaqy591buro;*/
        if p_n_nroreg = 49 then
          sp_cont_entid_cmac_all(l_n_tipdoc,
                                 l_c_numdoc,
                                 l_d_perrcc,
                                 l_n_tipBur,
                                 l_n_serial,
                                 l_n_canent);
        else
          sp_cont_entid_cmac(l_n_tipdoc,
                             l_c_numdoc,
                             l_d_perrcc,
                             l_n_tipBur,
                             l_n_serial,
                             l_n_canent);
        end if;
      
      end if;
    end loop;
    if l_n_estcon = 1 then
      l_c_rptrcc := to_char(l_n_canent);
    
      sp_proceso(p_n_correl,
                 p_n_nroreg,
                 l_c_rptrcc,
                 l_d_rccant,
                 0,
                 ' ',
                 l_n_flgact,
                 l_c_rptind);
    
      sp_resolverRpt(l_c_rptfin, l_c_rptind);
    else
      l_c_rptfin := 'E';
    end if;
    commit;
  
    p_c_rpttit := l_c_rptfin;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT  = trim(l_c_rptfin),
           JAQY588RESVAR = trim(to_char(l_n_canent)),
           jaqy588horaf  = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = l_c_ingres;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_regla_enti2',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_regla_enti2;

  --//

  procedure sp_contador_entidades(p_n_tipdoc numeric, --chernandez 29/05/2018
                                  p_c_numdoc character,
                                  p_d_perrcc date,
                                  p_n_tipBur numeric,
                                  p_n_serial numeric,
                                  p_n_canent in out numeric) is
  
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdoctr = tipdoc and c_doctri = numdoc))
               order by d_fecpre desc)
       where rownum = 1;
  
    l_c_codsbs varchar2(10);
    l_c_canreg numeric(5, 0);
    l_c_cannre numeric(5, 0);
    errorv     varchar2(500);
    l_n_equtip varchar2(1);
    l_c_numdoc varchar2(12);
  
  begin
    l_c_canreg := 0;
    l_c_cannre := 0;
    Begin
      l_n_equtip := fn_equivalenviaDoc(p_n_tipdoc);
    
      l_c_codsbs := null;
      l_c_numdoc := trim(p_c_numdoc);
    
      for i in CrCldrcci(l_c_numdoc, l_n_equtip) loop
        l_c_codsbs := i.c_codsbs;
      end loop;
    
      if l_c_codsbs is not null then
        select count(distinct c_codemp)
          into l_c_canreg
          from cldrccs d
         where c_codsbs = l_c_codsbs
           and d_fecpre = p_d_perrcc
           and c_cuenta not like '14__04%' --no credito hipotecario
           and c_codemp <> '00104'; --no caja arequipa
      end if;
    exception
      when others then
        --si no esta reportado, la cantidad de entidades sera cero.
        l_c_canreg := 0;
    end;
  
    --no reguladas        
    if p_n_tipBur = 1 then
      --ANTIGUO experian
      select count(*)
        into l_c_cannre
        from JAQL548
       where jaql548estado <> '06'
         and jaql548indbo = '0'
            --chernandez 29/05/2018 se agrego ticta
         and jaql548ticta in (select jaqy590desc2
                                from jaqy590
                               where jaqy590cod = 1
                                 and jaqy590cod1 = 1
                                 and jaqy590corr1 = 10
                                 and jaqy590corr2 = 1)
         and jaql546serial = p_n_serial;
    else
      if p_n_tipBur = 2 then
        --NUEVO experian
        select count(*)
          into l_c_cannre
          from JAQL548
         where jaql548estado <> '06'
           and jaql548indbo = '3'
              --chernandez 29/05/2018 se agrego ticta
           and jaql548regu = 'NR'
           /*and jaql548ticta in (select jaqy590desc2
                                  from jaqy590
                                 where jaqy590cod = 1
                                   and jaqy590cod1 = 1
                                   and jaqy590corr1 = 10
                                   and jaqy590corr2 = 1)*/
           and jaql546serial = p_n_serial;
        --sentinel
        /*select count(*)
         into l_c_cannre
         from JAQZ238
        where JAQZ238estado <> '06'
          and JAQZ238indbo = '0'
             --chernandez 29/05/2018 se agrego ticta
          and jaqz238ticta in (select jaqy590desc2
                                 from jaqy590
                                where jaqy590cod = 1
                                  and jaqy590cod1 = 1
                                  and jaqy590corr1 = 10
                                  and jaqy590corr2 = 1)
          and JAQZ238serial = p_n_serial;*/
      else
        --equifax --apachecoh 2022.01.18
        select count(*)
          into l_c_cannre
          from (select AQPB515Bentid, AQPB515Bticta
                  from AQPB515B
                 where AQPB515Bestado <> '06'
                   and AQPB515Bindbo = '3'
                   and AQPB515Bticta in
                       (select jaqy590desc2
                          from jaqy590
                         where jaqy590cod = 1
                           and jaqy590cod1 = 1
                           and jaqy590corr1 = 10
                           and jaqy590corr2 = 1)
                   and AQPB515Bserial = p_n_serial
                 group by AQPB515Bentid, AQPB515Bticta);
        --apachecoh 2022.01.18
      end if;
    end if;
    p_n_canent := p_n_canent + l_c_canreg + l_c_cannre;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_contador_entidades',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         23,
         errorv);
      commit;
  end sp_contador_entidades;

  procedure sp_cont_entid_cmac(p_n_tipdoc numeric, --chernandez 29/05/2018
                               p_c_numdoc character,
                               p_d_perrcc date,
                               p_n_tipBur numeric,
                               p_n_serial numeric,
                               p_n_canent in out numeric) is
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdoctr = tipdoc and c_doctri = numdoc))
               order by d_fecpre desc)
       where rownum = 1;
  
    l_c_codsbs varchar2(10);
    l_c_canreg numeric(5, 0);
    l_c_cannre numeric(5, 0);
    errorv     varchar2(500);
    l_n_equtip varchar2(1);
    l_c_numdoc varchar2(12);
  
  begin
    l_c_canreg := 0;
    l_c_cannre := 0;
    Begin
    
      l_n_equtip := fn_equivalenviaDoc(p_n_tipdoc);
    
      l_c_codsbs := null;
      l_c_numdoc := trim(p_c_numdoc);
    
      for i in CrCldrcci(l_c_numdoc, l_n_equtip) loop
        l_c_codsbs := i.c_codsbs;
      end loop;
    
      if l_c_codsbs is not null then
        select count(distinct c_codemp)
          into l_c_canreg
          from cldrccs
         where c_codsbs = l_c_codsbs
           and d_fecpre = p_d_perrcc
           and (c_cuenta like '14_1%' or c_cuenta like '14_3%' or
               c_cuenta like '14_4%' or c_cuenta like '14_5%' or
               c_cuenta like '14_6%' or c_cuenta like '81_3%' or
               c_cuenta like '81_925%')
           and c_cuenta not like '14____02%'
           and c_cuenta not like '14____19%';
      end if;
    exception
      when others then
        --si no esta reportado, la cantidad de entidades sera cero.
        l_c_canreg := 0;
    end;
  
    --no reguladas        
    if p_n_tipBur = 1 then
      --ANTIGUO experian
      select count(*)
        into l_c_cannre
        from JAQL548
       where jaql548estado <> '06'
         and jaql548indbo = '0'
            --chernandez 29/05/2018 se agrego ticta
         and jaql548ticta in (select jaqy590desc2
                                from jaqy590
                               where jaqy590cod = 1
                                 and jaqy590cod1 = 1
                                 and jaqy590corr1 = 10
                                 and jaqy590corr2 = 1)
         and jaql546serial = p_n_serial;
    else
      if p_n_tipBur = 2 then
        --NUEVO experian
        select count(*)
          into l_c_cannre
          from JAQL548
         where jaql548estado <> '06'
           and jaql548indbo = '3'
              --chernandez 29/05/2018 se agrego ticta
           and jaql548regu = 'NR'
           /*and jaql548ticta in (select jaqy590desc2
                                  from jaqy590
                                 where jaqy590cod = 1
                                   and jaqy590cod1 = 1
                                   and jaqy590corr1 = 10
                                   and jaqy590corr2 = 1)*/
           and jaql546serial = p_n_serial;
        --sentinel
        /*select count(*)
         into l_c_cannre
         from JAQZ238
        where JAQZ238estado <> '06'
          and JAQZ238indbo = '0'
             --chernandez 29/05/2018 se agrego ticta
          and JAQZ238ticta in (select jaqy590desc2
                                 from jaqy590
                                where jaqy590cod = 1
                                  and jaqy590cod1 = 1
                                  and jaqy590corr1 = 10
                                  and jaqy590corr2 = 1)
          and JAQZ238serial = p_n_serial;*/
      else
        --equifax --apachecoh 2022.01.18
        select count(*)
          into l_c_cannre
          from (select AQPB515Bentid, AQPB515Bticta
                  from AQPB515B
                 where AQPB515Bestado <> '06'
                   and AQPB515Bindbo = '3'
                   and AQPB515Bticta in
                       (select jaqy590desc2
                          from jaqy590
                         where jaqy590cod = 1
                           and jaqy590cod1 = 1
                           and jaqy590corr1 = 10
                           and jaqy590corr2 = 1)
                   and AQPB515Bserial = p_n_serial
                 group by AQPB515Bentid, AQPB515Bticta);
        --apachecoh 2022.01.18
      end if;
    end if;
    p_n_canent := p_n_canent + l_c_canreg + l_c_cannre;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_cont_entid_cmac',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         24,
         errorv);
      commit;
  end sp_cont_entid_cmac;

  procedure sp_proceso(p_n_correl number,
                       p_n_nregla number,
                       p_c_rptrcc varchar2,
                       p_d_perrcc date,
                       p_n_tipdoc number,
                       p_c_numdoc char,
                       p_n_flgact number,
                       p_c_rptind out char) is
  
    l_n_flgnul number;
    l_n_porper number;
    l_n_porreg number;
    l_n_tipope number;
    l_c_estprc char(1);
    l_n_mesper number;
    l_n_anoper number;
    l_c_valRpt char(1);
    l_c_tipRpt char(1);
    l_c_period char(7);
  
    l_v_rptrcc apex_application_global.vc_arr2;
    errorv     varchar2(500);
    l_n_contad number;
  
  begin
    --inicializa respuesta
    p_c_rptind := 'S'; --aqui 'N'
  
    --obtenemos mes y año de periodo
    select extract(month from p_d_perrcc) into l_n_mesper from dual;
    select extract(year from p_d_perrcc) into l_n_anoper from dual;
  
    --obtenemos porcentaje, tipo operacion, valor respuesta de la regla.
    select jaqy590nro1, jaqy590nro2, jaqy590desc3, jaqy590nro3
      into l_n_porreg, l_n_tipope, l_c_valRpt, l_c_tipRpt
      from JAQY590
     where jaqy590cod = 1
       and jaqy590cod1 = 1
       and jaqy590corr1 = 1
       and jaqy590corr2 = 1
       and jaqy590corr3 = p_n_nregla;
  
    --split al resultado rcc
    l_v_rptrcc := apex_util.string_to_table(p_c_rptrcc, ';');
  
    --por cada periodo
    for i in 1 .. l_v_rptrcc.count loop
    
      l_n_flgnul := 0;
      if l_c_tipRpt = 0 then
        --si la respuesta es porcentaje
        begin
          l_n_porper := to_number(l_v_rptrcc(i));
        exception
          when others then
            l_n_porper := null;
            l_n_flgnul := 1;
            l_c_estprc := 'S'; --aqui 'N'
        end;
      else
        --si la respuesta es N o S
        l_n_porper := 0;
        l_n_flgnul := 1;
        l_c_estprc := trim(l_v_rptrcc(i));
      
        --basta que se incumpla la regla un periodo, la respuesta final será 'N'--aqui 'S'
        if l_c_estprc = 'S' then
          p_c_rptind := 'N'; --aqui 'S'
        end if;
      
      end if;
      --si existe data y es porcentaje      
      if l_n_flgnul = 0 then
        if p_n_flgact = 1 then
          --si esta activo
        
          l_c_estprc := '';
        
          --//si es mayor
          if l_n_tipope = 1 then
            if l_n_porper > l_n_porreg then
              l_c_estprc := l_c_valRpt;
            else
              if l_c_valRpt = 'S' then
                l_c_estprc := 'N';
              else
                l_c_estprc := 'S';
              end if;
            end if;
          end if;
        
          --//si es igual
          if l_n_tipope = 0 then
            if l_n_porper = l_n_porreg then
              l_c_estprc := l_c_valRpt;
            else
              if l_c_valRpt = 'S' then
                l_c_estprc := 'N';
              else
                l_c_estprc := 'S';
              end if;
            end if;
          end if;
        
          --//si es menor igual
          if l_n_tipope = 2 then
            if l_n_porper <= l_n_porreg and l_n_porper > 0 then
              l_c_estprc := l_c_valRpt;
            else
              if l_c_valRpt = 'S' then
                l_c_estprc := 'N';
              else
                l_c_estprc := 'S';
              end if;
            end if;
          end if;
        
          --basta que se incumpla la regla un periodo, la respuesta final será 'N'--aqui 'S'
          if l_c_estprc = 'N' then
            --aqui 'S'
            p_c_rptind := 'N'; --aqui 'S'
          end if;
        else
          l_c_estprc := 'S';
        
        end if;
      end if;
      l_c_period := (lpad(l_n_mesper, 2, '0') || l_n_anoper);
      select count(*) + 1
        into l_n_contad
        from JAQY589
       where jaqy589corre = p_n_correl
         and jaqy588tireg = p_n_nregla
         and jaqy589perio = l_c_period
         and jaqy589tidoc = p_n_tipdoc
         and jaqy589nudoc = p_c_numdoc;
      --insertamos el detalle del periodo
      insert into JAQY589
        (jaqy589corre,
         jaqy588tireg,
         jaqy589perio,
         jaqy589tidoc,
         jaqy589nudoc,
         jaqy589estad,
         jaqy589valor,
         jaqy589corel)
      values
        (p_n_correl, --correlativo
         p_n_nregla, --numero de regla
         lpad(l_n_mesper, 2, '0') || l_n_anoper, --periodo analizado
         p_n_tipdoc, --tipo doc
         p_c_numdoc, --numdoc
         l_c_estprc, --respuesta periodo analizado
         l_n_porper,
         l_n_contad); --valor periodo analizado
      commit;
      --disminuimos el periodo
      l_n_mesper := l_n_mesper - 1;
    
      if l_n_mesper = 0 then
        l_n_mesper := 12;
        l_n_anoper := l_n_anoper - 1;
      End If;
    
    end loop;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_proceso',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         25,
         errorv);
      commit;
  end sp_proceso;

  --//
  --02/10/2017
  --se eliminó 14/11/2017 sp_proceso_2
  /*
  procedure sp_proceso_2(p_n_correl number,
  */
  --//

  procedure sp_resolverRpt(p_c_rptfin in out char, p_c_rptind char) is
    errorv varchar2(500);
  begin
    --si la respuesta global ya es 'N', entonces  siempre será 'N'
    --si la respuesta global es 'S', asignamos la respuesta individual
    --sin importar el valor.
    if p_c_rptfin = 'S' then
      p_c_rptfin := p_c_rptind;
    end if;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_resolverRpt',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         0,
         26,
         errorv);
      commit;
  end sp_resolverRpt;

  --//

  procedure sp_obtenerFechaRcc(p_d_fecrcc out date, p_d_rccant out date) is
    errorv varchar2(500);
  begin
  
    select to_date(substr(tpnro, 1, 2) || '/' || substr(tpnro, 3, 2) || '/' ||
                   substr(tpnro, 5, 4),
                   'DD/MM/YYYY')
      into p_d_fecrcc
      from Fst098 q
     where pgcod = 1
       and Tpcod = 7647
       and Tpcorr = 12;
  
    SELECT ADD_MONTHS(p_d_fecrcc, -1) into p_d_rccant FROM DUAL;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_obtenerFechaRcc',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         0,
         27,
         errorv);
      commit;
  end sp_obtenerFechaRcc;

  --//
  procedure sp_valida_calif_activo(p_c_arreglo   in varchar,
                                   p_n_respuesta out number) is
    -- 0 inactivo
    -- 1 activo
    l_v_rptrcc apex_application_global.vc_arr2;
    l_n_porper number;
    errorv     varchar2(500);
  begin
    --split al resultado rcc
    l_v_rptrcc := apex_util.string_to_table(p_c_arreglo, ';');
  
    p_n_respuesta := 0;
    --por cada periodo
    for i in 1 .. l_v_rptrcc.count loop
    
      begin
        l_n_porper := to_number(l_v_rptrcc(i));
      exception
        when others then
          l_n_porper := 0;
      end;
    
      if l_n_porper <> 0 then
        p_n_respuesta := 1;
      end if;
    
    end loop;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_valida_calif_activo',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         0,
         28,
         errorv);
      commit;
  end sp_valida_calif_activo;

  /*chernandez 02/10/2017*/
  /*chernandez 13/11/2017*/
  procedure sp_busca_rcc(p_n_instan number,
                         p_n_nroreg number,
                         p_c_tipint varchar2,
                         p_c_usuari varchar2,
                         p_c_rpttit out varchar2,
                         p_n_correl out number) is
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
  
    l_c_rptrcc varchar2(200);
    l_c_rptrc1 varchar2(200);
  
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_n_flgact number;
    errorv     varchar2(500);
    ln_tdoc    number(5);
    lc_ndoc    char(12);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
    if p_n_instan <> 0 then
      --obtengo correlativo de cabecera
      select sq_jaqy588.nextval into p_n_correl from dual;
    
      --obtengo fecha de rcc bantotal
    
      sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    
      select sng001tdoc, sng001ndoc
        into ln_tdoc, lc_ndoc
        from sng001
       where sng001inst = p_n_instan;
    
      ----------------------------------------------------------------------
      ----------------------------------------------------------------------
      ----------------------------------------------------------------------
      --inserto cabecera
      insert into JAQY588
        (jaqy588corre,
         JAQY588TIPIN,
         jaqy588tibur,
         jaqy588fecha,
         jaqy588horai,
         jaqy588insta,
         jaqy588usuar)
      values
        (p_n_correl,
         p_c_tipint, --T C F
         p_n_nroreg,
         trunc(sysdate),
         TO_CHAR(sysdate, 'HH24:Mi:SS'),
         p_n_instan,
         p_c_usuari);
    
      l_n_tipdoc := ln_tdoc;
      l_c_numdoc := lc_ndoc;
    
      If p_n_nroreg in (38, 51, 52) then
        --31/08/2018 se agregó reglas 51 52 para quintuplica
      
        --CALIFICACION NORMAL
        --in: numero documento persona
        --out: arreglo con los porcentajes separados con ;
      
        pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrc1);
      
        l_c_rptrcc := l_c_rptrc1;
      
        --///////////
      
        l_n_flgact := 1;
      
        sp_proceso(p_n_correl,
                   p_n_nroreg,
                   l_c_rptrcc,
                   l_d_perrcc,
                   l_n_tipdoc,
                   l_c_numdoc,
                   l_n_flgact,
                   l_c_rptind);
      
        --in: l_c_rptfin respuesta final
        --    l_c_rptind ultima respuesta individual
        --out:l_c_rptfin respuesta final
      
        sp_resolverRpt(l_c_rptfin, l_c_rptind);
      
      end if;
    
      commit;
    
      p_c_rpttit := l_c_rptfin;
    
      --actualiza respuesta en cabecera    
      update JAQY588
         set JAQY588RESPT = trim(l_c_rptfin),
             jaqy588horaf = TO_CHAR(sysdate, 'HH24:Mi:SS')
       where JAQY588CORRE = p_n_correl
         and JAQY588TIPIN = p_c_tipint;
    
      commit;
    else
      p_c_rpttit := l_c_rptfin;
    end if;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_rcc',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_rcc;

  --//Fecha Creación: 12/10/2017
  --//Descripción: Calificación de hasta 10% CPP en los últimos 6 meses, 
  --//excepto los dos últimos 100% Normal.
  --//Usuario: Cinthya Liz Hernandez Ortega
  --//Fecha Modificación: 24/10/2017
  --//Descripción: Se agregó regla 44
  --//Usuario: Cinthya Liz Hernandez Ortega
  procedure sp_busca_cal100N10CPP(p_n_instan number,
                                  p_n_nroreg number,
                                  p_c_usuari varchar2,
                                  p_c_rpttit out varchar2,
                                  p_n_correl out number) is
  
    cursor integrantes is
      Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg);
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_c_rptrcc varchar2(100);
    l_d_perrcc date;
    l_d_rccant date;
    l_c_rptfin char(1);
    l_c_rptind char(1);
    l_c_rptcpp char(1);
    l_n_meses1 number;
    l_n_meses2 number;
    l_n_porcpp number;
    l_n_pornor number;
    errorv     varchar2(500);
    varRcc     number;
    l_v_rptnor apex_application_global.vc_arr2;
    l_v_rptcpp apex_application_global.vc_arr2;
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       'G', --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
  
    select a.jaqy590nro2, a.jaqy590nro3
      into l_n_meses1, l_n_meses2
      from JAQY590 a
     where a.jaqy590cod = 1
       and a.jaqy590cod1 = 1
       and a.jaqy590corr1 = 6
       and a.jaqy590corr2 = p_n_nroreg
       and a.jaqy590corr3 = 1;
  
    -- por cada integrantes del credito
    for d in integrantes loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
    
      If p_n_nroreg IN (39, 44) then
      
        pq_cr_variables_rcc.Sp_cr_CalNormalGen(l_n_tipdoc,
                                               l_c_numdoc,
                                               p_n_nroreg,
                                               l_c_rptrcc);
      
        l_v_rptnor := apex_util.string_to_table(l_c_rptrcc, ';');
        varRcc     := 0;
        for i in 1 .. l_v_rptnor.count loop
          if i <= l_n_meses1 then
            --l_n_meses1 = 2 -- 2 primeros meses 100% normal
            begin
              l_n_pornor := to_number(l_v_rptnor(i));
            exception
              when others then
                l_n_pornor := 100;
            end;
          
            if l_n_pornor <> 100 then
              l_c_rptfin := 'N';
              l_c_rptind := 'N';
            else
              l_c_rptind := 'S';
            end if;
          
            sp_actualizaDetalle(p_n_instan,
                                p_n_correl,
                                0,
                                l_n_tipdoc,
                                l_c_numdoc,
                                l_c_rptind,
                                l_n_pornor,
                                add_months(l_d_perrcc, varRcc));
            varRcc := varRcc - 1;
          
          end if;
        end loop;
        if l_c_rptfin = 'S' then
        
          pq_cr_variables_rcc.Sp_cr_CalCppGen(l_n_tipdoc,
                                              l_c_numdoc,
                                              p_n_nroreg,
                                              l_c_rptrcc);
        
          l_v_rptcpp := apex_util.string_to_table(l_c_rptrcc, ';');
          varRcc     := 0;
          for i in 1 .. l_v_rptcpp.count loop
            l_n_porcpp := 0;
            if i > l_n_meses1 then
            
              begin
                l_n_pornor := to_number(l_v_rptnor(i));
              exception
                when others then
                  l_n_pornor := 100;
              end;
            
              if l_n_pornor <> 100 then
                --si no es 100% normal
                begin
                  l_n_porcpp := to_number(l_v_rptcpp(i));
                exception
                  when others then
                    l_n_porcpp := 0;
                end;
                if (l_n_porcpp + l_n_pornor) <> 100 then
                  l_c_rptfin := 'N';
                  l_c_rptind := 'N';
                  if l_n_porcpp <= 10 then
                    l_c_rptcpp := 'S';
                  else
                    l_c_rptcpp := 'N';
                  end if;
                else
                  if l_n_pornor < 90 then
                    l_c_rptfin := 'N';
                    l_c_rptind := 'N';
                  else
                    l_c_rptind := 'S';
                    if l_n_porcpp > 10 then
                      l_c_rptfin := 'N';
                      l_c_rptcpp := 'N';
                    else
                      l_c_rptcpp := 'S';
                    end if;
                  end if;
                end if;
              else
                l_c_rptind := 'S';
                l_c_rptcpp := 'S';
              end if;
              sp_actualizaDetalle(p_n_instan,
                                  p_n_correl,
                                  0,
                                  l_n_tipdoc,
                                  l_c_numdoc,
                                  l_c_rptind,
                                  l_n_pornor,
                                  add_months(l_d_perrcc, varRcc));
              sp_actualizaDetalle(p_n_instan,
                                  p_n_correl,
                                  p_n_nroreg,
                                  l_n_tipdoc,
                                  l_c_numdoc,
                                  l_c_rptcpp,
                                  l_n_porcpp,
                                  add_months(l_d_perrcc, varRcc));
            end if;
            varRcc := varRcc - 1;
          end loop;
        end if;
      end if;
    end loop;
    commit;
  
    p_c_rpttit := l_c_rptfin;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT = trim(l_c_rptfin),
           jaqy588horaf = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_cal100N10CPP',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_cal100N10CPP;

  procedure sp_actualizaDetalle(p_n_instan number,
                                p_n_correl number,
                                p_n_nregla number,
                                p_n_tipdoc varchar2,
                                p_c_numdoc char,
                                p_c_estprc char,
                                p_n_porper number,
                                p_d_perrcc date) is
  
    l_n_anoper number;
    l_n_mesper number;
    errorv     varchar2(500);
  begin
    select extract(month from p_d_perrcc) into l_n_mesper from dual;
    select extract(year from p_d_perrcc) into l_n_anoper from dual;
  
    insert into JAQY589
      (jaqy589corre,
       jaqy588tireg,
       jaqy589perio,
       jaqy589tidoc,
       jaqy589nudoc,
       jaqy589estad,
       jaqy589valor,
       jaqy589corel)
    values
      (p_n_correl, --correlativo
       p_n_nregla, --numero de regla
       lpad(l_n_mesper, 2, '0') || l_n_anoper, --periodo analizado
       p_n_tipdoc, --tipo doc
       p_c_numdoc, --numdoc
       p_c_estprc, --respuesta periodo analizado
       p_n_porper,
       (select count(*) + 1
          from JAQY589
         where jaqy589corre = p_n_correl
           and jaqy588tireg = p_n_nregla
           and jaqy589perio = (lpad(l_n_mesper, 2, '0') || l_n_anoper)
           and jaqy589tidoc = p_n_tipdoc
           and jaqy589nudoc = p_c_numdoc));
    commit;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_actualizaDetalle',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nregla,
         errorv);
      commit;
  end sp_actualizaDetalle;

  procedure sp_busca_inicio_acti(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 l_n_actmen out number,
                                 p_n_correl in out number) is
  
    cursor integrantes is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             JAQY591Serial,
             JAQY591Buro
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg);
  
    cursor grupoeconomico(anio   number,
                          mes    number,
                          tipdoc number,
                          numdoc char) is
      select *
        from jaqy051
       Where JAQY051PANO = anio
         and JAQY051PMES = mes
         and JAQY051TDOC = tipdoc
         and JAQY051NDOC = numdoc;
  
    cursor grupoeconomicodet(anio number, mes number, correl number) is
      select *
        from jaqy052
       Where JAQY051PANO = anio
         and JAQY051PMES = mes
         and JAQY051CORR = correl
         and JAQY052TDOC = 9;
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_d_perrcc date;
    l_d_rccant date;
    l_d_iniact numeric(9, 0);
    l_c_rptfin char(1);
    errorv     varchar2(500);
    l_n_flagen numeric(1);
    l_n_contad numeric(5, 0);
    l_n_mesper numeric(5, 0);
    l_n_anoper numeric(5, 0);
    l_c_period char(7);
    pgfape     date;
    mes        numeric(5);
    anio       numeric(5);
  
  begin
    --inicializamos respuesta
    l_c_rptfin := 'S'; --cambio N
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
  
    select extract(month from l_d_perrcc) into l_n_mesper from dual;
  
    select extract(year from l_d_perrcc) into l_n_anoper from dual;
  
    select to_char(pgfape, 'MM'), to_char(pgfape, 'YYYY')
      into mes, anio
      from fst017
     where pgcod = 1;
  
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       'X', --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    l_n_flagen := 0;
  
    for d in integrantes loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
    
      --chernandez 16/01/2018
      if p_n_nroreg = 43 and l_n_tipdoc <> 9 then
        begin
          select case
                   when to_char(sngc60fini, 'dd/mm/yyyy') = '01/01/0001' then
                    0
                   else
                    trunc((trunc(sysdate) - sngc60fini) / 30)
                 end
            into l_d_iniact
            from sngc60
           where sngc60tdoc = l_n_tipdoc
             and sngc60ndoc = l_c_numdoc
             and sngc60corr = 0;
        
        exception
          when others then
            l_d_iniact := 0;
        end;
      else
        begin
          select case
                   when to_char(JAQY594fec, 'dd/mm/yyyy') = '01/01/0001' then
                    0
                   else
                    trunc((trunc(sysdate) - JAQY594fec) / 30)
                 end
            into l_d_iniact
            from jaqy594
           where jaqy594tdo = l_n_tipdoc
             and jaqy594ndo = l_c_numdoc;
        exception
          when others then
            l_d_iniact := 0;
        end;
      end if;
    
      If l_n_flagen = 0 then
        l_n_flagen := 1;
        l_n_actmen := l_d_iniact;
      else
        if l_d_iniact < l_n_actmen then
          l_n_actmen := l_d_iniact;
        end if;
      end if;
    
      l_c_period := (lpad(l_n_mesper, 2, '0') || l_n_anoper);
    
      select count(*) + 1
        into l_n_contad
        from JAQY589
       where jaqy589corre = p_n_correl
         and jaqy588tireg = p_n_nroreg
         and jaqy589perio = l_c_period
         and jaqy589tidoc = l_n_tipdoc
         and jaqy589nudoc = l_c_numdoc;
      insert into JAQY589
        (jaqy589corre,
         jaqy588tireg,
         jaqy589perio,
         jaqy589tidoc,
         jaqy589nudoc,
         jaqy589estad,
         jaqy589valor,
         jaqy589corel)
      values
        (p_n_correl, --correlativo
         p_n_nroreg, --numero de regla
         l_c_period, --periodo analizado
         l_n_tipdoc, --tipo doc
         l_c_numdoc, --numdoc
         'X', --respuesta periodo analizado
         l_d_iniact,
         l_n_contad); --valor periodo analizado
      commit;
    
      if p_n_nroreg = 43 then
        if mes = 1 then
          mes  := 12;
          anio := anio - 1;
        else
          mes := mes - 1;
        end If;
      
        ----
        for e in grupoeconomico(mes, anio, l_n_tipdoc, l_c_numdoc) loop
          for g in grupoeconomicodet(mes, anio, e.jaqy051corr) loop
            l_n_tipdoc := g.JAQY052TDOC;
            l_c_numdoc := g.JAQY052NDOC;
          
            --chernandez 16/01/2018
            if l_n_tipdoc = 9 then
              begin
                select case
                         when to_char(JAQY594fec, 'dd/mm/yyyy') =
                              '01/01/0001' then
                          0
                         else
                          trunc((trunc(sysdate) - JAQY594fec) / 30)
                       end
                  into l_d_iniact
                  from jaqy594
                 where jaqy594tdo = l_n_tipdoc
                   and jaqy594ndo = l_c_numdoc;
              exception
                when others then
                  l_d_iniact := 0;
              end;
            else
              begin
                select case
                         when to_char(sngc60fini, 'dd/mm/yyyy') =
                              '01/01/0001' then
                          0
                         else
                          trunc((trunc(sysdate) - sngc60fini) / 30)
                       end
                  into l_d_iniact
                  from sngc60
                 where sngc60tdoc = l_n_tipdoc
                   and sngc60ndoc = l_c_numdoc
                   and sngc60corr = 0;
              
              exception
                when others then
                  l_d_iniact := 0;
              end;
            end if;
          
            If l_n_flagen = 0 then
              l_n_flagen := 1;
              l_n_actmen := l_d_iniact;
            else
              if l_d_iniact < l_n_actmen then
                l_n_actmen := l_d_iniact;
              end if;
            end if;
          
            l_c_period := (lpad(l_n_mesper, 2, '0') || l_n_anoper);
          
            select count(*) + 1
              into l_n_contad
              from JAQY589
             where jaqy589corre = p_n_correl
               and jaqy588tireg = p_n_nroreg
               and jaqy589perio = l_c_period
               and jaqy589tidoc = l_n_tipdoc
               and jaqy589nudoc = l_c_numdoc;
            insert into JAQY589
              (jaqy589corre,
               jaqy588tireg,
               jaqy589perio,
               jaqy589tidoc,
               jaqy589nudoc,
               jaqy589estad,
               jaqy589valor,
               jaqy589corel)
            values
              (p_n_correl, --correlativo
               p_n_nroreg, --numero de regla
               l_c_period, --periodo analizado
               l_n_tipdoc, --tipo doc
               l_c_numdoc, --numdoc
               'X', --respuesta periodo analizado
               l_d_iniact,
               l_n_contad); --valor periodo analizado
            commit;
          end loop;
        end loop;
      
      end if;
    
    end loop;
  
    commit;
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESVAR = to_char(l_n_actmen),
           jaqy588horaf  = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = 'X';
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_busca_inicio_acti',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_busca_inicio_acti;

  /*25/10/2017 chernandez*/
  procedure sp_obtener_pasivosSC(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_c_rpttit out varchar2,
                                 p_n_correl out number) is
  
    cursor integrantes is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             JAQY591Serial,
             JAQY591Buro
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg);
  
    cursor pasivosSC(ln_tipDoc number, lc_numDoc character, ln_mes number) is
      select case
               when saldosincaja is null then
                0
               else
                saldosincaja
             end saldosincaja
        from (select case
                       when ln_mes = 1 then
                        sum(jaqy592ssc1)
                       when ln_mes = 2 then
                        sum(jaqy592ssc2)
                       when ln_mes = 3 then
                        sum(jaqy592ssc3)
                       when ln_mes = 4 then
                        sum(jaqy592ssc4)
                       when ln_mes = 5 then
                        sum(jaqy592ssc5)
                       when ln_mes = 6 then
                        sum(jaqy592ssc6)
                       when ln_mes = 7 then
                        sum(jaqy592ssc7)
                       when ln_mes = 8 then
                        sum(jaqy592ssc8)
                       when ln_mes = 9 then
                        sum(jaqy592ssc9)
                       when ln_mes = 10 then
                        sum(jaqy592ssc10)
                       when ln_mes = 11 then
                        sum(jaqy592ssc11)
                       when ln_mes = 12 then
                        sum(jaqy592ssc12)
                     end saldosincaja
                from jaqy592_sd
               where jaqy592tdo = ln_tipDoc
                 and jaqy592ndo = lc_numDoc
                 and substr(jaqy592rub, 5, 2) not in
                     (select jaqy590desc2
                        from jaqy590
                       where jaqy590cod = 1
                         and jaqy590cod1 = 1
                         and jaqy590corr1 = 7
                         and jaqy590corr2 = 1));
  
    cursor crediEnVuelo(ln_Pepais number,
                        ln_tipDoc number,
                        lc_numDoc character,
                        ln_tpcam  number) is
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             x.xwfprcins,
             case
               when x.xwfmoneda = 0 then
                x.xwfmonto1
               else
                x.xwfmonto1 * ln_tpcam
             end ln_monto10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_tipDoc
                                and pendoc = lc_numDoc
                                and cttfir = 'T')
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
             
             or (x.xwfmodulo = 117 and
             x.xwftipope not in
             (select jaqy590desc2
                     from jaqy590
                    where jaqy590cod = 1
                      and jaqy590cod1 = 1
                      and jaqy590corr1 = 7
                      and jaqy590corr2 = 2))
             
             )
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = x.XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope,
                x.xwfprcins,
                x.xwfmonto1;
  
    cursor creditosvigentes(ln_Pepais number,
                            ln_tipDoc number,
                            lc_numDoc character,
                            ln_tpcam  number) is
      select sum(case
                   when scmda = 0 then
                    scsdo * -1
                   else
                    scsdo * ln_tpcam * -1
                 end) scsdo
        from fsd011
       where (pgcod, sccta) in (select pgcod, ctnro
                                  from fsr008
                                 where pepais = ln_Pepais
                                   and petdoc = ln_tipDoc
                                   and pendoc = lc_numDoc
                                   and cttfir = 'T')
            
         and substr(scrub, 1, 4) in
             (select trim(tp1desc)
                from fst198
               where tp1cod = 1
                 and tp1cod1 = 10899
                 and tp1corr1 = 26
                 and tp1corr2 in (3, 4, 5, 6, 7, 8))
         and substr(scrub, 5, 2) not in
             (select jaqy590desc2
                from jaqy590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 7
                 and jaqy590corr2 = 1)
         and scstat <> 99;
  
    cursor ultimaEvaluacion is
      select *
        from (select sng021eval, sng021fec
                from SNG021 t
               where sng021sol in (select sng001inst
                                     from sng001 x, xwf070 y
                                    where sng001cta in
                                          (select sng001cta
                                             from sng001
                                            where sng001inst = p_n_instan)
                                      and x.sng001emp = 1
                                      and x.sng001inst = y.xwfprcin
                                      and y.xwfpgcod = x.sng001emp
                                      and y.xwfcont = 'S')
               order by sng021fec desc)
       where rownum = 1;
  
    ln_tipdoc  numeric(5);
    ln_tdosbs  numeric(5);
    ln_mes     numeric(5);
    lc_numdoc  character(12);
    errorv     varchar2(500);
    ln_monto   numeric(17, 2);
    ln_moind   numeric(17, 2);
    ln_moAnt   numeric(17, 2);
    ln_valor   numeric(17, 2);
    ln_tcamb   numeric(14, 8);
    ld_fecha   date;
    ln_anio    numeric(4);
    ln_porto   numeric(17, 2);
    l_c_period character(7);
    ln_porcen  numeric(5);
  begin
  
    begin
      select to_number(to_char(to_date(tpnro, 'dd/mm/yyyy'), 'mm')),
             to_char(to_date(tpnro, 'dd/mm/yyyy'), 'mmyyyy')
        into ln_mes, l_c_period
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ln_mes := null;
    end;
    select pgfape into ld_fecha from fst017 where pgcod = 1;
    begin
      select sng120tcbi
        into ln_tcamb
        from sng120
       where sng120ins = p_n_instan
         and sng120tsk = 'EVALUACION';
    exception
      when no_data_found then
        select cotcbi
          into ln_tcamb
          from (select cotcbi
                  from fsh005
                 where cofdes <= ld_fecha
                   and moneda = 101
                   and cotcbi > 0
                 order by cofdes desc)
         where rownum = 1;
      
    end;
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    select sq_jaqy588.nextval into p_n_correl from dual;
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       'X', --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
  
    ln_monto := 0;
    ln_moind := 0;
    for d in integrantes loop
      ln_moind := 0;
    
      select a.tp1corr3
        into ln_tdosbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = d.jaqy591tdoc;
      ln_tipdoc := d.jaqy591tdoc;
      lc_numdoc := d.jaqy591ndoc;
      ln_anio   := 604;
    
      --pasivos sin caja
      for e in pasivosSC(ln_tdosbs, lc_numdoc, ln_mes) loop
        ln_valor := e.saldosincaja;
        if ln_valor is null then
          ln_valor := 0;
        end if;
      
        ln_monto := ln_monto + ln_valor;
        ln_moind := ln_moind + ln_valor;
      end loop;
      --12/01/2018 chernandez
      /*--creditos en vuelo
      for g in crediEnVuelo(ln_anio, ln_tipdoc, lc_numdoc, ln_tcamb) loop
        ln_valor := g.ln_monto10;
        if ln_valor is null then
          ln_valor := 0;
        end if;
        ln_monto := ln_monto + ln_valor;
        ln_moind := ln_moind + ln_valor;
      end loop;
      --creditos vigentes
      for g in creditosvigentes(ln_anio, ln_tipdoc, lc_numdoc, ln_tcamb) loop
        ln_valor := g.scsdo;
        if ln_valor is null then
          ln_valor := 0;
        end if;
        ln_monto := ln_monto + ln_valor;
        ln_moind := ln_moind + ln_valor;
      end loop;
      */
      insert into JAQY589
        (jaqy589corre,
         jaqy588tireg,
         jaqy589perio,
         jaqy589tidoc,
         jaqy589nudoc,
         jaqy589estad,
         jaqy589valor,
         jaqy589corel)
      values
        (p_n_correl, --correlativo
         p_n_nroreg, --numero de regla
         l_c_period, --periodo analizado
         ln_tipdoc, --tipo doc
         lc_numdoc, --numdoc
         'X', --respuesta periodo analizado
         ln_moind, --valor periodo analizado
         0);
      commit;
    
    end loop;
  
    ln_moAnt := 0;
    --ultima evaluación
    for h in ultimaEvaluacion loop
      begin
        select case
                 when sum(sng023mto) is null then
                  0
                 else
                  sum(sng023mto)
               end sng023mto
          into ln_moAnt
          from (select case
                         when sng026cod = 65 then
                          sng023mto
                         else
                          sng023mto * ln_tcamb
                       end sng023mto
                  from sng023
                 where sng021eval = h.sng021eval
                   and sng026cod in (65, 565));
      exception
        when others then
          ln_moAnt := 0;
      end;
    
    end loop;
  
    insert into JAQY589
      (jaqy589corre,
       jaqy588tireg,
       jaqy589perio,
       jaqy589tidoc,
       jaqy589nudoc,
       jaqy589estad,
       jaqy589valor,
       jaqy589corel)
    values
      (p_n_correl, --correlativo
       p_n_nroreg, --numero de regla
       l_c_period, --periodo analizado
       ln_tipdoc, --tipo doc
       'ULTEVAL', --numdoc
       'X', --respuesta periodo analizado
       ln_moAnt, --valor periodo analizado
       0);
    commit;
  
    begin
      ln_porto := ln_monto * 100 / ln_moAnt;
    
      ln_porto := ln_porto - 100;
      begin
        select JAQY590NRO1
          into ln_porcen
          from JAQY590 a
         where a.jaqy590cod = 1
           and a.jaqy590cod1 = 1
           and a.jaqy590corr1 = 1
           and a.jaqy590corr1 = 1
           and a.jaqy590corr3 = p_n_nroreg;
      exception
        when others then
          ln_porcen := 100;
      end;
      If ln_porto > ln_porcen then
        p_c_rpttit := 'S';
      else
        p_c_rpttit := 'N';
      end if;
    exception
      when others then
        p_c_rpttit := 'S';
    end;
  
    update JAQY588
       set JAQY588RESPT  = trim(p_c_rpttit),
           JAQY588RESVAR = to_char(ln_monto),
           jaqy588horaf  = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_obtener_pasivosSC',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_obtener_pasivosSC;
  /*31/10/2017 chernandez*/
  procedure sp_obtener_entidades(p_n_instan number,
                                 p_n_nroreg number,
                                 p_c_usuari varchar2,
                                 p_n_rptcan out number,
                                 p_n_correl out number) is
  
    cursor titularPrincipal is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             JAQY591Serial,
             JAQY591Buro
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591INTEGR = 'TITULAR_1';
  
    cursor conyugueTitular is
      Select JAQY591tdoc,
             JAQY591ndoc,
             JAQY591integr,
             JAQY591Serial,
             JAQY591Buro
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591INTEGR = 'CONYUGUE_1';
  
    ln_tipdoc numeric(5);
    lc_numdoc character(12);
    errorv    varchar2(500);
    ld_fecha  date;
    ln_anio   numeric(4);
    lc_period character(10);
    lc_peri   character(7);
    ln_concan numeric(5);
    ln_concyg numeric(5);
  begin
  
    begin
      select to_date(tpnro, 'dd/mm/yyyy'),
             to_char(to_date(tpnro, 'dd/mm/yyyy'), 'mmyyyy')
        into lc_period, lc_peri
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        lc_period := null;
        lc_peri   := null;
    end;
    select pgfape into ld_fecha from fst017 where pgcod = 1;
  
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    select sq_jaqy588.nextval into p_n_correl from dual;
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       'X', --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
  
    ln_concan := 0;
    ln_concyg := 0;
  
    --TITULAR PRINCIPAL
    for d in titularPrincipal loop
    
      ln_tipdoc := d.jaqy591tdoc;
      lc_numdoc := d.jaqy591ndoc;
      ln_anio   := 604;
    
      sp_cont_ent_regSC(ln_tipdoc, lc_numdoc, lc_period, ln_concan);
    
      insert into JAQY589
        (jaqy589corre,
         jaqy588tireg,
         jaqy589perio,
         jaqy589tidoc,
         jaqy589nudoc,
         jaqy589estad,
         jaqy589valor,
         jaqy589corel)
      values
        (p_n_correl, --correlativo
         p_n_nroreg, --numero de regla
         lc_peri, --periodo analizado
         ln_tipdoc, --tipo doc
         lc_numdoc, --numdoc
         'X', --respuesta periodo analizado
         ln_concan, --valor periodo analizado
         0);
      commit;
    end loop;
  
    --CONYUGUE TITULAR 
    for d in conyugueTitular loop
    
      ln_tipdoc := d.jaqy591tdoc;
      lc_numdoc := d.jaqy591ndoc;
      ln_anio   := 604;
    
      sp_cont_ent_regSC(ln_tipdoc, lc_numdoc, lc_period, ln_concyg);
    
      insert into JAQY589
        (jaqy589corre,
         jaqy588tireg,
         jaqy589perio,
         jaqy589tidoc,
         jaqy589nudoc,
         jaqy589estad,
         jaqy589valor,
         jaqy589corel)
      values
        (p_n_correl, --correlativo
         p_n_nroreg, --numero de regla
         lc_peri, --periodo analizado
         ln_tipdoc, --tipo doc
         lc_numdoc, --numdoc
         'X', --respuesta periodo analizado
         ln_concyg, --valor periodo analizado
         0);
      commit;
    end loop;
  
    p_n_rptcan := ln_concan + ln_concyg;
  
    update JAQY588
       set JAQY588RESPT  = '',
           JAQY588RESVAR = to_char(p_n_rptcan),
           jaqy588horaf  = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_obtener_contador',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_obtener_entidades;

  procedure sp_cont_ent_regSC(p_n_tipdoc numeric,
                              p_c_numdoc character,
                              p_d_perrcc date,
                              p_n_canent in out numeric) is
    l_c_codsbs varchar2(10);
    l_c_canreg numeric(5, 0);
    errorv     varchar2(500);
    l_c_numdoc varchar2(12);
    l_n_tipdoc varchar2(1);
    i          numeric(5, 0);
  
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select *
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdoctr = tipdoc and c_doctri = numdoc))
               order by d_fecpre desc)
       where rownum = 1;
  
  begin
    l_c_canreg := 0;
    l_c_numdoc := trim(p_c_numdoc);
    Begin
      l_n_tipdoc := fn_equivalenviaDoc(p_n_tipdoc);
    
      l_c_codsbs := null;
    
      for i in CrCldrcci(l_c_numdoc, l_n_tipdoc) loop
        l_c_codsbs := i.c_codsbs;
      end loop;
    
      if l_c_codsbs is not null then
        --obtener cantidad entidades reguladas.
      
        select count(distinct c_codemp)
          into l_c_canreg
          from cldrccs d
         where c_codsbs = l_c_codsbs
           and d_fecpre = p_d_perrcc
           and substr(trim(c_cuenta), 1, 4) in
               (select trim(jaqy590desc1)
                  from jaqy590
                 where jaqy590cod = 1
                   and jaqy590cod1 = 10899
                   and jaqy590corr1 = 26
                   and jaqy590corr2 in (3, 4, 5, 6, 7, 8))
           and c_cuenta not like '14__04%' --no credito hipotecario
           and c_codemp <> '00104'; --no caja arequipa
      else
        l_c_canreg := 0;
      end if;
    exception
      when others then
        --si no esta reportado, la cantidad de entidades sera cero.
        l_c_canreg := 0;
    end;
  
    p_n_canent := p_n_canent + l_c_canreg;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_cont_ent_regSC',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         46,
         errorv);
      commit;
  end sp_cont_ent_regSC;

  procedure sp_obtener_saldos_totales(p_n_serial     number,
                                      p_n_numcon     number,
                                      p_n_tipDoc     varchar2,
                                      p_c_numDoc     varchar2,
                                      p_c_usuari     varchar2,
                                      p_n_saldoCCaja out number,
                                      p_n_saldoSCaja out number,
                                      p_n_saldoNRegu out number,
                                      p_n_correl     out number) is
  
    cursor pasivosSC(ln_tipDoc number, lc_numDoc character, ln_mes number) is
      select case
               when saldosincaja is null then
                0
               else
                saldosincaja
             end saldosincaja
        from (select case
                       when ln_mes = 1 then
                        sum(jaqy592ssc1)
                       when ln_mes = 2 then
                        sum(jaqy592ssc2)
                       when ln_mes = 3 then
                        sum(jaqy592ssc3)
                       when ln_mes = 4 then
                        sum(jaqy592ssc4)
                       when ln_mes = 5 then
                        sum(jaqy592ssc5)
                       when ln_mes = 6 then
                        sum(jaqy592ssc6)
                       when ln_mes = 7 then
                        sum(jaqy592ssc7)
                       when ln_mes = 8 then
                        sum(jaqy592ssc8)
                       when ln_mes = 9 then
                        sum(jaqy592ssc9)
                       when ln_mes = 10 then
                        sum(jaqy592ssc10)
                       when ln_mes = 11 then
                        sum(jaqy592ssc11)
                       when ln_mes = 12 then
                        sum(jaqy592ssc12)
                     end saldosincaja
                from jaqy592_sd
               where jaqy592tdo = ln_tipDoc
                 and jaqy592ndo = lc_numDoc);
  
    cursor pasivosCC(ln_tipDoc number, lc_numDoc character, ln_mes number) is
      select case
               when saldoconcaja is null then
                0
               else
                saldoconcaja
             end saldoconcaja
        from (select case
                       when ln_mes = 1 then
                        sum(jaqy592scc1)
                       when ln_mes = 2 then
                        sum(jaqy592scc2)
                       when ln_mes = 3 then
                        sum(jaqy592scc3)
                       when ln_mes = 4 then
                        sum(jaqy592scc4)
                       when ln_mes = 5 then
                        sum(jaqy592scc5)
                       when ln_mes = 6 then
                        sum(jaqy592scc6)
                       when ln_mes = 7 then
                        sum(jaqy592scc7)
                       when ln_mes = 8 then
                        sum(jaqy592scc8)
                       when ln_mes = 9 then
                        sum(jaqy592scc9)
                       when ln_mes = 10 then
                        sum(jaqy592scc10)
                       when ln_mes = 11 then
                        sum(jaqy592scc11)
                       when ln_mes = 12 then
                        sum(jaqy592scc12)
                     end saldoconcaja
                from jaqy592_sd
               where jaqy592tdo = ln_tipDoc
                 and jaqy592ndo = lc_numDoc);
  
    cursor noreguladas(ln_serial number, ln_buro number) is
      select sum(saldo) saldo
        from (--ANTIGUO experian
              select sum(jaql548salac) saldo
                from jaql548
               where jaql546serial = ln_serial
                 and jaql548indbo = '0'
                 and jaql548estado <> '06'
                 and 1 = ln_buro
              UNION ALL --chernandez 12/07/2019                   
              --NUEVO experian --apachecoh 12/12/2023   
              select sum(saldo)
                from (select sum(jaql548salac) saldo
                         from jaql548
                        where jaql546serial = ln_serial
                          and jaql548indbo = '4'
                          and jaql548estado <> '06'
                          and 2 = ln_buro
                       union
                       select sum(jaql548salac) saldo
                         from jaql548
                        where jaql546serial = ln_serial
                          and jaql548indbo = '3'
                          and jaql548estado <> '06'
                          and jaql548regu = 'NR'
                          /*and jaql548ticta in
                              (select jaqy590desc2
                                 from jaqy590
                                where jaqy590cod = 1
                                  and jaqy590cod1 = 1
                                  and jaqy590corr1 = 10
                                  and jaqy590corr2 = 1)*/
                          and 2 = ln_buro)
              UNION ALL
              /*select sum(jaqz238salac) saldo
                from jaqz238
                where jaqz238serial = ln_serial
                and jaqz238indbo = '0'
                and jaqz238estado <> '06'
                and 2 = ln_buro*/                 
              --equifax --apachecoh 18/01/2022
              select sum(AQPB515Bsalac) saldo
                from AQPB515B
               where AQPB515Bserial = ln_serial
                 and AQPB515Bindbo = '3'
                 and AQPB515Bestado <> '06'
                 and 3 = ln_buro);
    --apachecoh 18/01/2022
  
    ln_tipdoc  numeric(5);
    ln_tdosbs  numeric(5);
    ln_mes     numeric(5);
    lc_numdoc  character(12);
    errorv     varchar2(500);
    ld_fecha   date;
    l_c_period character(7);
    ln_serial  numeric(10);
    ln_buro    numeric(5); --chernandez 12/07/2019
  begin
  
    begin
      select to_number(to_char(to_date(tpnro, 'dd/mm/yyyy'), 'mm')),
             to_char(to_date(tpnro, 'dd/mm/yyyy'), 'mmyyyy')
        into ln_mes, l_c_period
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ln_mes := null;
    end;
    select pgfape into ld_fecha from fst017 where pgcod = 1;
    --AGREGADO AQPA011L 08.02.2022 CONSULTA BURO.
    BEGIN
      select L.AQPA011LBURO
        INTO ln_buro
        from AQPA011L L
       WHERE L.aqpa011lnucon = p_n_numcon
            --AND L.aqpa011lseria = p_n_serial         
         and l.aqpa011lestad = 1
         and l.aqpa011lhora = (select min(b.aqpa011lhora)
                                 from aqpa011l b
                                where b.aqpa011lnucon = p_n_numcon
                                  and b.aqpa011lestad = 1
                               --AND b.aqpa011lseria = p_n_serial
                               )
         and rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        ln_buro := 1;
    END;
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    select sq_jaqy588.nextval into p_n_correl from dual;
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       'T', --T C F
       0,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_serial,
       p_c_usuari);
  
    select a.tp1corr3
      into ln_tdosbs
      from fst198 a
     where a.tp1cod = 1
       and a.tp1cod1 = 11111
       and a.tp1corr1 = 1
       and a.tp1corr2 = 3
       and tp1nro1 = p_n_tipDoc;
    ln_tipdoc := p_n_tipDoc;
    lc_numdoc := p_c_numDoc;
  
    p_n_saldoCCaja := 0;
    --pasivos con caja
    for e in pasivosCC(ln_tdosbs, lc_numdoc, ln_mes) loop
      p_n_saldoCCaja := e.saldoconcaja;
      if p_n_saldoCCaja is null then
        p_n_saldoCCaja := 0;
      end if;
    end loop;
    insert into jaqy598
      (JAQY598CORRE, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
    values
      (p_n_serial,
       1001,
       'S',
       'Saldo total deudor RCC= ' || to_char(p_n_saldoCCaja));
    insert into JAQY589
      (jaqy589corre,
       jaqy588tireg,
       jaqy589perio,
       jaqy589tidoc,
       jaqy589nudoc,
       jaqy589estad,
       jaqy589valor,
       jaqy589corel)
    values
      (p_n_correl, --correlativo
       0, --numero de regla
       l_c_period, --periodo analizado
       ln_tipdoc, --tipo doc
       lc_numdoc, --numdoc
       'X', --respuesta periodo analizado
       p_n_saldoCCaja, --valor periodo analizado
       1);
    commit;
  
    p_n_saldoSCaja := 0;
    --pasivos sin caja
    for e in pasivosSC(ln_tdosbs, lc_numdoc, ln_mes) loop
      p_n_saldoSCaja := e.saldosincaja;
      if p_n_saldoSCaja is null then
        p_n_saldoSCaja := 0;
      end if;
    end loop;
  
    p_n_saldoSCaja := p_n_saldoCCaja - p_n_saldoSCaja;
    insert into jaqy598
      (JAQY598CORRE, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
    values
      (p_n_serial,
       1002,
       'S',
       'Saldo total deudor con CMAC Arequipa= ' || to_char(p_n_saldoSCaja));
    insert into JAQY589
      (jaqy589corre,
       jaqy588tireg,
       jaqy589perio,
       jaqy589tidoc,
       jaqy589nudoc,
       jaqy589estad,
       jaqy589valor,
       jaqy589corel)
    values
      (p_n_correl, --correlativo
       0, --numero de regla
       l_c_period, --periodo analizado
       ln_tipdoc, --tipo doc
       lc_numdoc, --numdoc
       'X', --respuesta periodo analizado
       p_n_saldoSCaja, --valor periodo analizado
       0);
    commit;
  
    p_n_saldonregu := 0;
    --apachecoh 23.02.2022
    begin
      select a.aqpa011lseria
        into ln_serial
        from aqpa011l a
       where aqpa011lnucon = p_n_numcon
         and a.aqpa011ltdoc = ln_tipdoc
         and a.aqpa011lndoc = lc_numdoc
         and a.aqpa011lburo = ln_buro;
    end;
    /*begin
      ln_buro := 1;
      select a.aqpa011lseria
        into ln_serial
        from aqpa011l a
       where aqpa011lnucon = p_n_numcon
         and a.aqpa011ltdoc = ln_tipdoc
         and a.aqpa011lndoc = lc_numdoc
         and a.aqpa011lburo = 1;
    exception
      when others then
        ln_buro := 2;
        select a.aqpa011lseria
          into ln_serial
          from aqpa011l a
         where aqpa011lnucon = p_n_numcon
           and a.aqpa011ltdoc = ln_tipdoc
           and a.aqpa011lndoc = lc_numdoc
           and a.aqpa011lburo = 2;
    end;*/
    --no reguladas
    for e in noreguladas(ln_serial, ln_buro) loop
      --chernandez 12/07/2019
      p_n_saldonregu := e.saldo;
      if p_n_saldonregu is null then
        p_n_saldonregu := 0;
      end if;
    end loop;
  
    insert into jaqy598
      (JAQY598CORRE, JAQY598REGLA, JAQY598ACCIO, JAQY598MENSA)
    values
      (p_n_serial,
       1003,
       'S',
       'Saldo total deudor en No reguladas= ' || to_char(p_n_saldonregu));
  
    insert into JAQY589
      (jaqy589corre,
       jaqy588tireg,
       jaqy589perio,
       jaqy589tidoc,
       jaqy589nudoc,
       jaqy589estad,
       jaqy589valor,
       jaqy589corel)
    values
      (p_n_correl, --correlativo
       0, --numero de regla
       l_c_period, --periodo analizado
       ln_tipdoc, --tipo doc
       lc_numdoc, --numdoc
       'X', --respuesta periodo analizado
       p_n_saldonregu, --valor periodo analizado
       2);
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_obtener_saldos_totales',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_serial,
         0,
         errorv);
      commit;
  end sp_obtener_saldos_totales;

  function fn_equivalenviaDoc(p_tdoc in number) return varchar2 is
    cursor datos is
      select tp1nro2
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11111
         and tp1corr1 = 1
         and tp1corr2 = 5
         and tp1nro1 = p_tdoc;
  
    resp  number(5);
    respc varchar2(1);
  begin
    resp := 1;
    for i in datos loop
      resp := i.tp1nro2;
    end loop;
    respc := to_char(resp);
    return respc;
  end fn_equivalenviaDoc;

  procedure sp_cont_entid_cmac_all(p_n_tipdoc numeric, --chernandez 29/05/2018
                                   p_c_numdoc character,
                                   p_d_perrcc date,
                                   p_n_tipBur numeric,
                                   p_n_serial numeric,
                                   p_n_canent in out numeric) is
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdocid = tipdoc and c_docide = numdoc) or
                     (c_tdoctr = tipdoc and c_doctri = numdoc))
               order by d_fecpre desc)
       where rownum = 1;
  
    l_c_codsbs varchar2(10);
    l_c_canreg numeric(5, 0);
    l_c_cannre numeric(5, 0);
    errorv     varchar2(500);
    l_n_equtip varchar2(1);
    l_c_numdoc varchar2(12);
  
  begin
    l_c_canreg := 0;
    l_c_cannre := 0;
    Begin
    
      l_n_equtip := fn_equivalenviaDoc(p_n_tipdoc);
    
      l_c_codsbs := null;
      l_c_numdoc := trim(p_c_numdoc);
    
      for i in CrCldrcci(l_c_numdoc, l_n_equtip) loop
        l_c_codsbs := i.c_codsbs;
      end loop;
    
      if l_c_codsbs is not null then
        select count(distinct c_codemp)
          into l_c_canreg
          from cldrccs
         where c_codsbs = l_c_codsbs
           and d_fecpre = p_d_perrcc
           and (c_cuenta like '14_1%' or c_cuenta like '14_3%' or
               c_cuenta like '14_4%' or c_cuenta like '14_5%' or
               c_cuenta like '14_6%' or c_cuenta like '81_3%' or
               c_cuenta like '81_925%');
      end if;
    exception
      when others then
        --si no esta reportado, la cantidad de entidades sera cero.
        l_c_canreg := 0;
    end;
  
    --no reguladas        
    if p_n_tipBur = 1 then
      --ANTIGUO experian
      select count(*)
        into l_c_cannre
        from JAQL548
       where jaql548estado <> '06'
         and jaql548indbo = '0'
         and jaql548ticta in (select jaqy590desc2
                                from jaqy590
                               where jaqy590cod = 1
                                 and jaqy590cod1 = 1
                                 and jaqy590corr1 = 10
                                 and jaqy590corr2 = 1)
         and jaql546serial = p_n_serial;
    else
      if p_n_tipBur = 2 then
        --NUEVO experian        
        select count(*)
          into l_c_cannre
          from JAQL548
         where jaql548estado <> '06'
           and jaql548indbo = '3'
           and jaql548regu = 'NR'
           /*and jaql548ticta in (select jaqy590desc2
                                  from jaqy590
                                 where jaqy590cod = 1
                                   and jaqy590cod1 = 1
                                   and jaqy590corr1 = 10
                                   and jaqy590corr2 = 1)*/
           and jaql546serial = p_n_serial;
        --sentinel
        /*select count(*)
         into l_c_cannre
         from JAQZ238
        where JAQZ238estado <> '06'
          and JAQZ238indbo = '0'
             --chernandez 29/05/2018 se agrego ticta
          and JAQZ238ticta in (select jaqy590desc2
                                 from jaqy590
                                where jaqy590cod = 1
                                  and jaqy590cod1 = 1
                                  and jaqy590corr1 = 10
                                  and jaqy590corr2 = 1)
          and JAQZ238serial = p_n_serial;*/
      else
        --equifax --apachecoh 2022.01.18           
        select count(*)
          into l_c_cannre
          from (select AQPB515Bentid, AQPB515Bticta
                  from AQPB515B
                 where AQPB515Bestado <> '06'
                   and AQPB515Bindbo = '0'
                   and AQPB515Bticta in
                       (select jaqy590desc2
                          from jaqy590
                         where jaqy590cod = 1
                           and jaqy590cod1 = 1
                           and jaqy590corr1 = 10
                           and jaqy590corr2 = 1)
                   and AQPB515Bserial = p_n_serial
                 group by AQPB515Bentid, AQPB515Bticta);
        --apachecoh 2022.01.18
      end if;
    end if;
    p_n_canent := p_n_canent + l_c_canreg + l_c_cannre;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_cont_entid_cmac_all',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         24,
         errorv);
      commit;
  end sp_cont_entid_cmac_all;

  --chernandez 26/07/2019
  procedure sp_bifurcacpp(p_n_corr  numeric,
                          p_n_regla numeric,
                          p_n_rpta  out numeric) is
  
    cantInt numeric(5);
    existe  numeric(5);
  begin
    existe := 1;
    select count(*) / 6 * 3
      into cantInt
      from jaqy589 cc
     where jaqy589corre = p_n_corr
       and jaqy588tireg = p_n_regla;
  
    if cantInt <> 0 then
      select count(*)
        into existe
        from (select rownum num, a.*
                from (select fec, jaqy589estad
                        from (select to_date('01' || trim(JAQY589perio),
                                             'ddmmyyyy') fec,
                                     cc.*
                                from jaqy589 cc
                               where jaqy589corre = p_n_corr
                                 and jaqy588tireg = p_n_regla)
                       order by fec) a) b
       where b.num > cantInt
         and jaqy589estad = 'N';
    
    end if;
    if existe > 0 then
      p_n_rpta := 1;
    else
      p_n_rpta := 0;
    end if;
  
  end sp_bifurcacpp;
  --chernandez 06/05/2019
  procedure sp_mora_max(p_n_instan number,
                        p_n_nroreg number,
                        p_c_tipint varchar2,
                        p_c_usuari varchar2,
                        p_c_rpttit out varchar2,
                        p_n_correl out number) is
  
    cursor integrantes is
      Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
         and '1' = p_c_tipint
      UNION
      select aqpa012tdoc, aqpa012ndoc, aqpa012integr
        from aqpa012
       where aqpa012corre = p_n_instan
         and aqpa012aux3 in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
            --and '2' = p_c_tipint;
         and p_c_tipint in ('2', '3'); --04/05/2022 APACHECOH incluye Buro 3 Equifax
  
    l_n_tipdoc number;
    l_c_numdoc char(12);
    l_c_tipint varchar2(40);
    l_d_perrcc date;
    l_d_rccant date;
    errorv     varchar2(500);
  
    --chernandez 07/05/2019
    l_d_fecpro     date;
    l_n_pais       number;
    l_n_promedio   number;
    l_n_moramax    number(10);
    l_n_moramaxGen number(10);
    l_n_contador   number(5);
  begin
    l_n_pais       := 604;
    l_n_moramaxGen := 0;
    l_n_contador   := 0;
    --inicializamos respuesta
  
    --obtengo correlativo de cabecera
    select sq_jaqy588.nextval into p_n_correl from dual;
  
    --obtengo fecha de rcc bantotal
  
    sp_obtenerFechaRcc(l_d_perrcc, l_d_rccant);
  
    select pgfape into l_d_fecpro from fst017 where pgcod = 1;
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    ----------------------------------------------------------------------
    --inserto cabecera
    insert into JAQY588
      (jaqy588corre,
       JAQY588TIPIN,
       jaqy588tibur,
       jaqy588fecha,
       jaqy588horai,
       jaqy588insta,
       jaqy588usuar)
    values
      (p_n_correl,
       p_c_tipint, --T C F
       p_n_nroreg,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:Mi:SS'),
       p_n_instan,
       p_c_usuari);
    commit;
    -- por cada integrantes del credito
    for d in integrantes loop
    
      l_c_tipint := d.jaqy591integr;
      l_n_tipdoc := d.jaqy591tdoc;
      l_c_numdoc := d.jaqy591ndoc;
    
      --JUDICIAL CASTIGADO VALIDACIONES
      l_n_contador := l_n_contador + 1;
      --l_d_fecpro := add_months(l_d_fecpro, -6);
      pq_cr_ampliaciones.sp_promedio_mora('COBUS' || l_n_contador,
                                          'COBUS' || l_n_contador,
                                          p_c_usuari,
                                          p_n_instan,
                                          l_n_pais,
                                          l_n_tipdoc,
                                          l_c_numdoc,
                                          l_d_fecpro,
                                          l_n_promedio,
                                          l_n_moramax);
    
      If l_n_moramax > l_n_moramaxGen then
        l_n_moramaxGen := l_n_moramax;
      End If;
    end loop;
    commit;
    p_c_rpttit := trim(to_char(l_n_moramaxGen));
  
    --actualiza respuesta en cabecera    
    update JAQY588
       set JAQY588RESPT = trim(p_c_rpttit),
           jaqy588horaf = TO_CHAR(sysdate, 'HH24:Mi:SS')
     where JAQY588CORRE = p_n_correl
       and JAQY588TIPIN = p_c_tipint;
  
    commit;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_mora_max',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_n_instan,
         p_n_nroreg,
         errorv);
      commit;
  end sp_mora_max;

  --chernandez 07/11/2019
  /*procedure sp_bifurcaMitUlt(p_n_corr  numeric,
                             p_n_regla numeric,
                             p_n_rpta  out numeric) is
  
    cantInt numeric(5);
    existe  numeric(5);
  begin
    existe := 1;
    select count(*) / 6 * 3
      into cantInt
      from jaqy589 cc
     where jaqy589corre = p_n_corr
       and jaqy588tireg = p_n_regla;
  
    if cantInt <> 0 then
      select count(*)
        into existe
        from (select rownum num, a.*
                from (select fec, jaqy589estad
                        from (select to_date('01' || trim(JAQY589perio),
                                             'ddmmyyyy') fec,
                                     cc.*
                                from jaqy589 cc
                               where jaqy589corre = p_n_corr
                                 and jaqy588tireg = p_n_regla)
                       order by fec) a) b
       where b.num > cantInt
         and jaqy589estad = 'S';
    
    end if;
    if existe > 0 then
      p_n_rpta := 1;
    else
      p_n_rpta := 0;
    end if;
  
  end sp_bifurcaMitUlt;
  procedure sp_bifurcaMitPri(p_n_corr  numeric,
                             p_n_regla numeric,
                             p_n_rpta  out numeric) is
  
    cantInt numeric(5);
    existe  numeric(5);
  begin
    existe := 1;
    select count(*) / 6 * 3
      into cantInt
      from jaqy589 cc
     where jaqy589corre = p_n_corr
       and jaqy588tireg = p_n_regla;
  
    if cantInt <> 0 then
      select count(*)
        into existe
        from (select rownum num, a.*
                from (select fec, jaqy589estad
                        from (select to_date('01' || trim(JAQY589perio),
                                             'ddmmyyyy') fec,
                                     cc.*
                                from jaqy589 cc
                               where jaqy589corre = p_n_corr
                                 and jaqy588tireg = p_n_regla)
                       order by fec) a) b
       where b.num <= cantInt
         and jaqy589estad = 'S';
    
    end if;
    if existe > 0 then
      p_n_rpta := 1;
    else
      p_n_rpta := 0;
    end if;
  
  end sp_bifurcaMitPri;*/
  procedure sp_verificaCtas(p_n_instan number,
                            p_n_nroreg number,
                            p_c_tipint varchar2,
                            p_n_flag   out number) is
    cursor integrantesTit is
      Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
        from JAQY591
       where JAQY591instan = p_n_instan
         and JAQY591TIPERS in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
         and '1' = p_c_tipint
         and JAQY591TIPERS in ('T1', 'T2', 'C1')
         and rownum = 1
      UNION
      select aqpa012tdoc, aqpa012ndoc, aqpa012integr
        from aqpa012
       where aqpa012corre = p_n_instan
         and aqpa012aux3 in
             (select JAQY590DESC3
                from JAQY590 a
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 3
                 and jaqy590corr2 = p_n_nroreg)
            --and '2' = p_c_tipint   --DCASTRO 07/02
         and p_c_tipint in ('2', '3') --DCASTRO 07/02
         and aqpa012aux3 in ('T1', 'T2', 'C1')
         and rownum = 1;
  
    cursor cuentas(pn_PEPAIS number, pn_PETDOC number, pc_PENDOC character) is
      select *
        from fsr008
       where PEPAIS = pn_PEPAIS
         and PETDOC = pn_PETDOC
         and PENDOC = pc_PENDOC;
  
    cursor intcuent(pn_pgcod number, pn_cuenta number) is
      select *
        from fsr008 fs
        full join (Select JAQY591tdoc, JAQY591ndoc, JAQY591integr
                     from JAQY591
                    where JAQY591instan = p_n_instan
                      and JAQY591TIPERS in
                          (select JAQY590DESC3
                             from JAQY590 a
                            where jaqy590cod = 1
                              and jaqy590cod1 = 1
                              and jaqy590corr1 = 3
                              and jaqy590corr2 = p_n_nroreg)
                      and JAQY591TIPERS in ('T1', 'T2', 'C1')
                      and '1' = p_c_tipint
                   UNION
                   select aqpa012tdoc, aqpa012ndoc, aqpa012integr
                     from aqpa012
                    where aqpa012corre = p_n_instan
                      and aqpa012aux3 in
                          (select JAQY590DESC3
                             from JAQY590 a
                            where jaqy590cod = 1
                              and jaqy590cod1 = 1
                              and jaqy590corr1 = 3
                              and jaqy590corr2 = p_n_nroreg)
                      and aqpa012aux3 in ('T1', 'T2', 'C1')
                         --and '2' = p_c_tipint) inte         --DCASTRO 07/02
                      and p_c_tipint in ('2', '3')) inte --DCASTRO 07/02
      
          on fs.pepais = 604
         and fs.petdoc = inte.JAQY591tdoc
         and fs.pendoc = inte.JAQY591ndoc
       where pgcod = pn_pgcod
         and ctnro = pn_cuenta
         and (inte.JAQY591ndoc is null or fs.pendoc is null);
  
    cursor instancias(pnc_cuenta numeric, pdc_fecha date) is
    
      select sng001inst
        from sng001
       where sng001cta = pnc_cuenta
         and sng001fin >= pdc_fecha;
  
    cursor politicas(pnc_insta numeric) is
    
      select *
        from (select *
                from fpae73
               where (pae51eva, pae70nro) in
                    
                     (select pae51eva, pae70nro
                        from fpae70
                       where pae70ins = pnc_insta
                         and pae51eva in (2, 3))
                 and pae73pol in (148, 1481)
                 and pae73TIP in ('B', 'E')
               order by pae70nro desc)
       where rownum = 1;
  
    l_v_cuenti  varchar2(200);
    cantit      numeric(5);
    existe      numeric(5);
    ln_cuenta   numeric(9);
    ln_cont22   numeric(5);
    ln_pae70nro numeric(10);
    ld_fecha    date;
    l_v_ctatit  apex_application_global.vc_arr2;
  
  begin
  
    select pgfape into ld_fecha from fst017 where pgcod = 1;
  
    ld_fecha := add_months(ld_fecha, -12);
  
    cantit := 0;
  
    for i in integrantesTit loop
      for j in cuentas(604, i.jaqy591tdoc, i.jaqy591ndoc) loop
        existe := 0;
        for k in intcuent(j.pgcod, j.ctnro) loop
          existe := 1;
        end loop;
        if existe = 0 then
          if cantit = 0 then
            l_v_cuenti := trim(to_char(j.ctnro));
          else
            l_v_cuenti := l_v_cuenti || ';' || trim(to_char(j.ctnro));
          end if;
          cantit := cantit + 1;
        end if;
      end loop;
    end loop;
  
    p_n_flag   := 0;
    l_v_ctatit := apex_util.string_to_table(l_v_cuenti, ';');
  
    for o in 1 .. l_v_ctatit.count loop
      --verificar cuenta 
      ln_cuenta := to_number(l_v_ctatit(o));
    
      for p in instancias(ln_cuenta, ld_fecha) loop
      
        ln_cont22 := 0;
        select count(*)
          into ln_cont22
          from jaqy598
         where jaqy598corre =
               (select min(aqpa012corre)
                  from aqpa012
                 where aqpa012conec =
                       (select max(jaqy599anuope)
                          from jaqy599A
                         where jaqy599ainst = p.sng001inst))
           and jaqy598regla = 22;
        if ln_cont22 > 0 then
          for q in politicas(p.sng001inst) loop
            select max(pae70nro)
              into ln_pae70nro
              from fpae73
             where (pae51eva, pae70nro) in
                  
                   (select pae51eva, pae70nro
                      from fpae70
                     where pae70ins = p.sng001inst
                       and pae51eva = q.pae51eva)
               and pae51eva = q.pae51eva;
            if ln_pae70nro > q.pae70nro then
              --se exceptuó
              p_n_flag := 1;
            
            end if;
          end loop;
        end if;
      end loop;
    end loop;
  
  end sp_verificaCtas;

  --apachecoh 24/08/2022 --Procesamiento Reglas Especiales
  procedure sp_proceso_reg(p_n_correl number,
                           p_n_nregla number,
                           p_c_rptrcc varchar2,
                           p_d_perrcc date,
                           p_n_tipdoc number,
                           p_c_numdoc char,
                           p_n_flgact number,
                           p_n_flgmes number,
                           p_c_rptind out char) is
  
    l_n_flgnul  number;
    l_n_porper  number;
    l_n_porreg  number;
    l_n_porreg2 number;
    l_n_tipope  number;
    l_c_estprc  char(1);
    l_n_mesper  number;
    l_n_anoper  number;
    l_c_valRpt  char(1);
    l_c_tipRpt  char(1);
    l_c_period  char(7);
    l_n_flgmes  number;
    l_n_flgite  number;
    l_n_totite  number;
    l_n_cont    number;
    l_c_rptpri  varchar2(5);
    l_c_rpttri  varchar2(5);
  
    l_v_rptrcc apex_application_global.vc_arr2;
    errorv     varchar2(500);
    l_n_contad number;
  
    cursor bloqueantes(regla number) is
      select jaqy590desc1
        from JAQY590
       where jaqy590cod = 1
         and jaqy590cod1 = 1
         and jaqy590corr1 = 1
         and jaqy590corr2 = regla
       group by jaqy590desc1
       order by jaqy590desc1;
  
    cursor consnormal_reg(correl numeric, regla numeric, item numeric) is
      select jaqy589estad
        from jaqy589
       where jaqy589corre = correl
         and jaqy588tireg = regla
         and jaqy589corel = item
       order by jaqy589corel, jaqy589perio desc;
  
  begin
    --inicializa respuesta
    p_c_rptind := 'S'; --aqui 'N'
  
    --obtenemos porcentaje, tipo operacion, valor respuesta de la regla.
    begin
      select a.jaqy590nro1
        into l_n_flgmes
        from JAQY590 a
       where a.jaqy590cod = 1
         and a.jaqy590cod1 = 1
         and a.jaqy590corr1 = 6
         and a.jaqy590corr2 = p_n_nregla
         and a.jaqy590corr3 = 1;
    exception
      when others then
        l_n_flgmes := 4;
    end;
    --split al resultado rcc
    l_n_flgite := 0;
    for j in bloqueantes(p_n_nregla) loop
      l_n_flgite := l_n_flgite + 1;
      --obtenemos mes y año de periodo
      select extract(month from p_d_perrcc) into l_n_mesper from dual;
      select extract(year from p_d_perrcc) into l_n_anoper from dual;
    
      l_v_rptrcc := apex_util.string_to_table(p_c_rptrcc, ';');
      --por cada periodo
      for i in 1 .. l_n_flgmes loop
        l_n_flgnul := 0;
        begin
          l_n_porper := to_number(l_v_rptrcc(i));
        exception
          when others then
            l_n_porper := null;
            l_n_flgnul := 1;
            l_c_estprc := 'S'; --aqui 'N'
        end;
        --si existe data y es porcentaje      
        if l_n_flgnul = 0 then
          l_c_estprc := 'S';
          if p_n_flgact = 1 then
            if i <= p_n_flgmes then
              --si esta activo
              select jaqy590imp1, jaqy590imp2, jaqy590nro3, jaqy590desc2
                into l_n_porreg, l_n_porreg2, l_n_tipope, l_c_valRpt
                from JAQY590
               where jaqy590cod = 1
                 and jaqy590cod1 = 1
                 and jaqy590corr1 = 1
                 and jaqy590corr2 = p_n_nregla
                 and jaqy590desc1 = j.jaqy590desc1
                 and i >= jaqy590nro1
                 and i <= jaqy590nro2;
              --guia que me diga el valor por periodo por regla tipo de operacion y 
              l_c_estprc := '';
              --si es mayor
              if l_n_tipope = 0 then
                if l_n_porper > l_n_porreg then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --si es menor
              if l_n_tipope = 1 then
                if l_n_porper > 0 and l_n_porper < l_n_porreg then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --si es igual
              if l_n_tipope = 2 then
                if l_n_porper = l_n_porreg then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --si es between
              if l_n_tipope = 3 then
                if l_n_porper >= l_n_porreg and l_n_porper <= l_n_porreg2 then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --si es mayor igual
              if l_n_tipope = 4 then
                if l_n_porper >= l_n_porreg then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --si es menor igual
              if l_n_tipope = 5 then
                if l_n_porper > 0 and l_n_porper <= l_n_porreg then
                  l_c_estprc := l_c_valRpt;
                else
                  if l_c_valRpt = 'S' then
                    l_c_estprc := 'N';
                  else
                    l_c_estprc := 'S';
                  end if;
                end if;
              end if;
              --basta que se incumpla la regla un periodo, la respuesta final será 'N'--aqui 'S'
              /*if l_c_estprc = 'N' then
                --aqui 'S'
                p_c_rptind := 'N'; --aqui 'S'
              end if;*/
            else
              l_c_estprc := 'S';
            end if;
          end if;
        end if;
      
        l_c_period := (lpad(l_n_mesper, 2, '0') || l_n_anoper);
      
        if i <= p_n_flgmes then
          select count(*)
            into l_n_contad
            from JAQY589
           where jaqy589corre = p_n_correl
             and jaqy588tireg = p_n_nregla
             and jaqy589perio = l_c_period
             and jaqy589tidoc = p_n_tipdoc
             and jaqy589nudoc = p_c_numdoc;
          --total de items  
          select count(*)
            into l_n_totite
            from (select jaqy590desc1
                    from JAQY590
                   where jaqy590cod = 1
                     and jaqy590cod1 = 1
                     and jaqy590corr1 = 1
                     and jaqy590corr2 = p_n_nregla
                   group by jaqy590desc1);
        
          if l_n_contad < l_n_totite then
            l_n_contad := l_n_contad + 1;
            --insertamos el detalle del periodo
            insert into JAQY589
              (jaqy589corre,
               jaqy588tireg,
               jaqy589perio,
               jaqy589tidoc,
               jaqy589nudoc,
               jaqy589estad,
               jaqy589valor,
               jaqy589corel)
            values
              (p_n_correl, --correlativo
               p_n_nregla, --numero de regla
               lpad(l_n_mesper, 2, '0') || l_n_anoper, --periodo analizado
               p_n_tipdoc, --tipo doc
               p_c_numdoc, --numdoc
               l_c_estprc, --respuesta periodo analizado
               l_n_porper,
               l_n_contad); --valor periodo analizado
          else
            update jaqy589
               set jaqy589estad = l_c_estprc, jaqy589valor = l_n_porper
             where jaqy589corre = p_n_correl
               and jaqy588tireg = p_n_nregla
               and jaqy589perio = l_c_period
               and jaqy589tidoc = p_n_tipdoc
               and jaqy589nudoc = p_c_numdoc
               and jaqy589corel = l_n_flgite;
          end if;
          commit;
          --disminuimos el periodo
          l_n_mesper := l_n_mesper - 1;
        
          if l_n_mesper = 0 then
            l_n_mesper := 12;
            l_n_anoper := l_n_anoper - 1;
          End If;
        End If;
      End Loop;
    End Loop;
    --validar calificación final
    for item in 1 .. 3 loop
      l_n_cont   := 1;
      l_c_rptpri := 'S';
      l_c_rpttri := 'S';
      for h in consnormal_reg(p_n_correl, p_n_nregla, item) loop
        /*if l_n_cont = 1 then
            l_c_rptpri := h.jaqy589estad; 
        else
            if h.jaqy589estad = 'N' then
               l_c_rpttri := 'N';  
            end if;
        end if;*/
        if h.jaqy589estad = 'N' then
          l_n_cont := l_n_cont + 1;
        end if;
      end loop;
      --if l_c_rptpri = 'N' and l_c_rpttri = 'N' then
      if l_n_cont > 4 then
        p_c_rptind := 'N';
        exit;
      end if;
    end loop;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      errorv := substr(sqlerrm, 1, 500);
      insert into jaqy592_er
        (JAQY592PROC,
         JAQY592FECH,
         JAQY592HORA,
         JAQY592INST,
         JAQY592REGL,
         JAQY592DESC)
      values
        ('sp_proceso',
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         p_c_numdoc,
         25,
         errorv);
      commit;
  end sp_proceso_reg;

end PQ_CR_REGLAS;
/
