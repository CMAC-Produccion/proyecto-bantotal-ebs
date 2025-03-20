create or replace package pq_cr_resolutor_lineas_consumo is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA EVALUAR Y OBTENER EL RATIO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2017.09.29
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : Realiza cálculos  
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --Modificacion                : Usuario ultima modificacion 27/09/2018
  -- Fecha de Modificación      : 30/11/2023
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se considero NVL para la variable de nro de cuotas en casos de flujo de caja y actualizacion devalores en log
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  -- Fecha de Modificación      : 16/04/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se considero nueva logica para ratio en disposicion de lineas
  -- Fecha de Modificación      : 23/04/2024
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se modifico la manera de obtener deuda RCC para disposiciones.
  -- Fecha de Modificación      : 07/05/2024
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se modifico el formato de fecha de inicio del nuevo ratio
  -----------------------------------------------------------
  -- *****************************************************************

  procedure sp_resultadonetolinea(ln_instancia in number,
                                  --ln_captotcaja    in number,
                                  ln_pepais        in number,
                                  ln_petdoc        in number,
                                  lv_pendoc        in varchar2,
                                  pn_emp           in number,
                                  pn_mod           in number,
                                  pn_suc           in number,
                                  pn_mda           in number,
                                  pn_pap           in number,
                                  pn_cta           in number,
                                  pn_ope           in number,
                                  pn_sbo           in number,
                                  pn_top           in number,
                                  pn_emp116        in number,
                                  pn_mod116        in number,
                                  pn_suc116        in number,
                                  pn_mda116        in number,
                                  pn_pap116        in number,
                                  pn_cta116        in number,
                                  pn_ope116        in number,
                                  pn_sbo116        in number,
                                  pn_top116        in number,
                                  pn_trn           in number,
                                  LN_ITPGCOD       in number, --ccerpa 27/09/2018
                                  LN_ITSUC         in number, --ccerpa 27/09/2018
                                  LN_ITMOD         in number, --ccerpa 27/09/2018
                                  LN_ITTRAN        in number, --ccerpa 27/09/2018
                                  LN_ITNREL        in number, --ccerpa 27/09/2018
                                  LN_ITORD         in number, --ccerpa 27/09/2018
                                  LN_ITSBOR        in number, --ccerpa 27/09/2018                                  
                                  ln_garant        in varchar2, --ccerpa 27/09/2018                                                                  
                                  ln_segmen        in number, --ccerpa 27/09/2018 
                                  lv_usuario       in varchar2, --ccerpa 09/10/2018                                                                    
                                  ln_capcaja       out number,
                                  ln_resultadorcc  out number,
                                  ln_resultadoneto out number,
                                  ln_resultado     out number);
  ----------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  lc_flgprg         in varchar2,
                                  LN_ITPGCOD        in number,
                                  LN_ITSUC          in number,
                                  LN_ITMOD          in number,
                                  LN_ITTRAN         in number,
                                  LN_ITNREL         in number,
                                  LN_ITORD          in number,
                                  LN_ITSBOR         in number,
                                  ln_garant         in varchar2,
                                  ln_segmen         in number,
                                  lc_Usuario        in varchar2,
                                  ln_MntCuoCntgAval out number);
  --------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia in number,
                                
                                lc_flgprg       in varchar2,
                                LN_ITPGCOD      in number,
                                LN_ITSUC        in number,
                                LN_ITMOD        in number,
                                LN_ITTRAN       in number,
                                LN_ITNREL       in number,
                                LN_ITORD        in number,
                                LN_ITSBOR       in number,
                                ln_garant       in varchar2,
                                ln_segmen       in number,
                                lc_Usuario      in varchar2,
                                ln_MntCuoCntgCF out number);
  ------------------------------------------------------
  procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number);

  ---------------------------------------------------------------------------                                  

  procedure sp_insert_jaqy140(ln_instancia in number,
                              -- ln_captotcaja    in number,
                              ln_pepais in number,
                              ln_petdoc in number,
                              lv_pendoc in varchar2,
                              --ln_capcaja       out number,
                              ln_resultadorcc  in number,
                              ln_resultadoneto in number,
                              ln_resultado     in number);

  procedure sp_validar_segmento(P_N_PAIS    in number,
                                p_n_tipdoc  in number,
                                p_c_numdoc  in VARCHAR2,
                                pn_retornar out NUMBER);
  procedure sp_empresa_lineatmp(ln_instancia in number,
                                lv_flag90    out varchar2,
                                ln_valor     out number);
  procedure sp_empresa_lineatmp1(ln_instancia in number,
                                 lv_flag90    out varchar2,
                                 ln_valor     out number);
  procedure sp_update_status(ln_pgcod  in number,
                             ln_suc    in number,
                             ln_itmod  in number,
                             ln_ittran in number,
                             ln_itrel  in number,
                             ln_itord  in number,
                             ln_itsbor in number);
  procedure sp_update_extornado(ln_pgcod  in number,
                                ln_suc    in number,
                                ln_itmod  in number,
                                ln_ittran in number,
                                ln_itrel  in number,
                                ln_itord  in number,
                                ln_itsbor in number);

end pq_cr_resolutor_lineas_consumo;
/

create or replace package body pq_cr_resolutor_lineas_consumo is
  -- *****************************************************************
  -- Nombre                     : sp_resultadonetolinea
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : EVALUA Y CALCULA EL RATIO DE LA LINEA DE CREDITO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --
  -- *****************************************************************

  procedure sp_resultadonetolinea(ln_instancia in number,
                                  --ln_captotcaja      in number,
                                  ln_pepais        in number,
                                  ln_petdoc        in number,
                                  lv_pendoc        in varchar2,
                                  pn_emp           in number,
                                  pn_mod           in number,
                                  pn_suc           in number,
                                  pn_mda           in number,
                                  pn_pap           in number,
                                  pn_cta           in number,
                                  pn_ope           in number,
                                  pn_sbo           in number,
                                  pn_top           in number,
                                  pn_emp116        in number,
                                  pn_mod116        in number,
                                  pn_suc116        in number,
                                  pn_mda116        in number,
                                  pn_pap116        in number,
                                  pn_cta116        in number,
                                  pn_ope116        in number,
                                  pn_sbo116        in number,
                                  pn_top116        in number,
                                  pn_trn           in number,
                                  LN_ITPGCOD       in number, --ccerpa 27/09/2018
                                  LN_ITSUC         in number, --ccerpa 27/09/2018
                                  LN_ITMOD         in number, --ccerpa 27/09/2018
                                  LN_ITTRAN        in number, --ccerpa 27/09/2018
                                  LN_ITNREL        in number, --ccerpa 27/09/2018
                                  LN_ITORD         in number, --ccerpa 27/09/2018
                                  LN_ITSBOR        in number, --ccerpa 27/09/2018                                  
                                  ln_garant        in varchar2, --ccerpa 27/09/2018                                                                  
                                  ln_segmen        in number, --ccerpa 27/09/2018                    
                                  lv_usuario       in varchar2, --ccerpa 09/10/2018   
                                  ln_capcaja       out number,
                                  ln_resultadorcc  out number,
                                  ln_resultadoneto out number,
                                  ln_resultado     out number) is
  
    ln_codeva                number(10, 0);
    lc_pendoc                char(12);
    ld_fecha                 date;
    ld_fechaactual           date;
    sng023montosoles         number(17, 2);
    sng023montodolares       number(17, 2);
    sng023montorccsoles      number(17, 2);
    sng023montorccdolares    number(17, 2);
    tipodecambio             number(17, 2);
    ln_numerador             number(17, 2);
    ln_denominador           number(17, 2);
    ln_contar                number(17);
    ln_contarelse            number(17);
    ln_contarsng021          number(17);
    jaqz515instancia         number(10);
    jaqz516evapis            number(10);
    ln_resultrccdolareselse  number(17, 2);
    ln_resultrccsoleselse    number(17, 2);
    ln_resultnetosoleselse   number(17, 2);
    ln_resultnetodolareselse number(17, 2);
    ln_numeradorelse         number(17, 2);
    ln_denominadorelse       number(17, 2);
    ln_resultadonetoelse     number(17, 2);
    ln_resultadorccelse      number(17, 2);
    jaqz515fecha             date;
    ln_captotcaja            number;
    ld_fechaactualmenosundia date;
    lv_prgm                  varchar2(8);
    saldo_externo            number;
    ResultNeto               number;
    ln_captotal              number;
    existencia_r             number;
    sng023montorcc2soles     number(17, 2);
    sng023montorcc2dolares   number(17, 2);
    ln_resultrcc2soleselse   number(17, 2);
    ln_resultrcc2dolareselse number(17, 2);
    ln_MntCuoCntgAval        NUMBER(17, 2) := 0; --MPOSTIGOC 04022019
    ln_MntCuoCntgCF          NUMBER(17, 2) := 0; --MPOSTIGOC 04022019
    ln_MntPotncial           number(17, 2) := 0; --MPOSTIGOC 04022019
    ln_MntCuoCntg            number(17, 2) := 0; --MPOSTIGOC 04022019
    ln_SolEval               number;
    ld_FchRegEval            date;
    ld_FchIniNewRatio        date;
    ln_InstUltEva            number;
    ln_saldoextSoles         number;
    ln_saldoextDol           number;
  
  Begin
  
    lc_pendoc       := RPAD(trim(lv_pendoc), 12, ' ');
    ln_contar       := 0;
    ln_contarelse   := 0;
    tipodecambio    := 0;
    ln_resultado    := 0;
    ln_contarsng021 := 0;
    lv_prgm         := 'RJAQZ726';
  
    Begin
    
      begin
        select pgfape
          into ld_fechaactual
          from fst017
         where fst017.pgcod = 1;
      exception
        when others then
          null;
        
      end;
    
      ln_capcaja               := ln_captotcaja;
      ld_fechaactualmenosundia := ld_fechaactual - 1;
    
      begin
        select count(cotcbi)
          into ln_contar
          from (select cotcbi
                  from fsh005
                 where cofdes <= ld_fechaactualmenosundia
                   and moneda = 101
                   and cotcbi > 0
                 order by cofdes desc)
         where rownum = 1;
      exception
        when others then
          null;
        
      end;
    
      begin
        select to_date(f.tp1imp1, 'yyyy/mm/dd')
          into ld_FchIniNewRatio
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 132
           and f.tp1corr2 = 1;
      exception
        when others then
          null;
      end;
    
      if ln_contar <> 0 then
        begin
          select cotcbi
            into tipodecambio
            from (select cotcbi
                    from fsh005
                   where cofdes <= ld_fechaactualmenosundia
                     and moneda = 101
                     and cotcbi > 0
                   order by cofdes desc)
           where rownum = 1;
        exception
          when others then
            null;
          
        end;
      end if;
    
      begin
        pq_cr_ratio_LINEACONSUMO.sp_cuentas(ln_pepais,
                                            ln_Petdoc,
                                            lc_pendoc,
                                            tipodecambio,
                                            ln_instancia,
                                            ld_fechaactual,
                                            lv_prgm,
                                            pn_emp,
                                            pn_mod,
                                            pn_suc,
                                            pn_mda,
                                            pn_pap,
                                            pn_cta,
                                            pn_ope,
                                            pn_sbo,
                                            pn_top,
                                            pn_emp116,
                                            pn_mod116,
                                            pn_suc116,
                                            pn_mda116,
                                            pn_pap116,
                                            pn_cta116,
                                            pn_ope116,
                                            pn_sbo116,
                                            pn_top116,
                                            pn_trn,
                                            LN_ITPGCOD, --ccerpa 27/09/2018
                                            LN_ITSUC, --ccerpa 27/09/2018
                                            LN_ITMOD, --ccerpa 27/09/2018
                                            LN_ITTRAN, --ccerpa 27/09/2018
                                            LN_ITNREL, --ccerpa 27/09/2018
                                            LN_ITORD, --ccerpa 27/09/2018
                                            LN_ITSBOR, --ccerpa 27/09/2018                                  
                                            ln_garant, --ccerpa 27/09/2018                                                                  
                                            ln_segmen, --ccerpa 27/09/2018 
                                            lv_usuario, --ccerpa 09/10/2018 
                                            ln_captotcaja,
                                            saldo_externo,
                                            ResultNeto,
                                            ln_captotal);
      
      end;
      ----------------------------------------------------------------------------
    
      ln_capcaja := ln_captotcaja;
    
      --********* MPOSTIGOC 04022019
    
      PQ_CR_RESOLUTOR_LINEAS_CONSUMO.sp_cr_CuotaContinAval(ln_Instancia      => ln_instancia,
                                                           lc_flgprg         => 'S',
                                                           LN_ITPGCOD        => LN_ITPGCOD,
                                                           LN_ITSUC          => LN_ITSUC,
                                                           LN_ITMOD          => LN_ITMOD,
                                                           LN_ITTRAN         => LN_ITTRAN,
                                                           LN_ITNREL         => LN_ITNREL,
                                                           LN_ITORD          => LN_ITORD,
                                                           LN_ITSBOR         => LN_ITSBOR,
                                                           ln_garant         => ln_garant,
                                                           ln_segmen         => ln_segmen,
                                                           lc_Usuario        => lv_usuario,
                                                           ln_MntCuoCntgAval => ln_MntCuoCntgAval);
    
      PQ_CR_RESOLUTOR_LINEAS_CONSUMO.sp_cr_CuotaContinCF(ln_Instancia    => ln_instancia,
                                                         lc_flgprg       => 'S',
                                                         LN_ITPGCOD      => LN_ITPGCOD,
                                                         LN_ITSUC        => LN_ITSUC,
                                                         LN_ITMOD        => LN_ITMOD,
                                                         LN_ITTRAN       => LN_ITTRAN,
                                                         LN_ITNREL       => LN_ITNREL,
                                                         LN_ITORD        => LN_ITORD,
                                                         LN_ITSBOR       => LN_ITSBOR,
                                                         ln_garant       => ln_garant,
                                                         ln_segmen       => ln_segmen,
                                                         lc_Usuario      => lv_usuario,
                                                         ln_MntCuoCntgCF => ln_MntCuoCntgCF);
    
      ln_MntCuoCntg := NVL(ln_MntCuoCntgAval, 0) + nvl(ln_MntCuoCntgCF, 0); -- cuota contingente
    
      PQ_CR_RESOLUTOR_LINEAS_CONSUMO.sp_cR_CuotaPotencial(ln_Instancia   => ln_instancia,
                                                          ln_MntPotncial => ln_MntPotncial);
    
      ln_MntPotncial := nvl(ln_MntPotncial, 0); -- cuota Potencial
    
      begin
        update aqpa270
           set aqpa270.aqpa270ccontg = ln_MntCuoCntg, --ln_resultadorcc ,
               aqpa270.aqpa270cpoten = ln_MntPotncial
         where aqpa270.aqpa270pais = ln_pepais
           and aqpa270.aqpa270tdoc = ln_petdoc
              -- and aqpa270.aqpa270ndoc = lc_pendoc
           and aqpa270.aqpa270inst = ln_instancia
           and aqpa270.aqpa270est = 'I'
           and aqpa270.aqpa270fec = ld_fechaactual
           and aqpa270.aqpa270hora =
               (select max(aqpa270.aqpa270hora)
                  from aqpa270
                 where aqpa270.aqpa270pais = ln_pepais
                   and aqpa270.aqpa270tdoc = ln_petdoc
                      -- and aqpa270.aqpa270ndoc = lc_pendoc
                   and aqpa270.aqpa270inst = ln_instancia
                   and aqpa270.aqpa270est = 'I'
                   and aqpa270.aqpa270fec = ld_fechaactual);
        commit;
      end;
    
      -- ****************** FIN DE CAMBIOS MPOSTIGOC
    
      begin
        select count(*)
          into ln_contarsng021
          from sng021 a
         inner join xwf070 x
            on a.sng021sol = x.xwfprcin
         where x.xwfcont = 'S'
           and a.sng021pdoc = ln_pepais ---604
           and a.sng021tdoc = ln_petdoc --- 21
           and a.sng021ndoc = lc_pendoc --- '40969090'
           and a.sng021fec = (select max(a.sng021fec)
                                from sng021 a
                               inner join xwf070 x
                                  on a.sng021sol = x.xwfprcin
                               where x.xwfcont = 'S'
                                 and a.sng021pdoc = ln_pepais ---604
                                 and a.sng021tdoc = ln_petdoc --- 21
                                 and a.sng021ndoc = lc_pendoc --- '40969090'                               
                              );
      exception
        when others then
          ln_contarsng021 := 0;
        
      end;
    
      if ln_contarsng021 > 0 then
        begin
          select a.sng021eval, a.sng021fec
            into ln_codeva, ld_fecha
            from sng021 a
           inner join xwf070 x
              on a.sng021sol = x.xwfprcin
           where x.xwfcont = 'S'
             and a.sng021pdoc = ln_pepais ---604
             and a.sng021tdoc = ln_petdoc --- 21
             and a.sng021ndoc = lc_pendoc --- '40969090'
             and a.sng021fec = (select max(a.sng021fec)
                                  from sng021 a
                                 inner join xwf070 x
                                    on a.sng021sol = x.xwfprcin
                                 where x.xwfcont = 'S'
                                   and a.sng021pdoc = ln_pepais ---604
                                   and a.sng021tdoc = ln_petdoc --- 21
                                   and a.sng021ndoc = lc_pendoc --- '40969090'                                 
                                )
             AND rownum = 1;
        exception
          when others then
            null;
        end;
      end if;
    
      begin
        select count(*)
          into ln_contarelse
          from jaqz515
         inner join xwf070 x
            on jaqz515.jaqz515ins = x.xwfprcin
         where x.xwfcont = 'S'
           and jaqz515.jaqz515pai = ln_pepais
           and jaqz515.jaqz515tdo = ln_petdoc
           and jaqz515.jaqz515ndo = lc_pendoc
           and jaqz515.jaqz515fee =
               (select max(jaqz515.jaqz515fee)
                  from jaqz515
                 inner join xwf070 x
                    on jaqz515.jaqz515ins = x.xwfprcin
                 where x.xwfcont = 'S'
                   and jaqz515.jaqz515pai = ln_pepais
                   and jaqz515.jaqz515tdo = ln_petdoc
                   and jaqz515.jaqz515ndo = lc_pendoc)
           AND rownum = 1;
      exception
        when others then
          null;
        
      end;
    
      if ln_contarelse > 0 then
        begin
          select jaqz515.jaqz515ins, jaqz515.jaqz515fee
            into jaqz515instancia, jaqz515fecha
            from jaqz515
           inner join xwf070 x
              on jaqz515.jaqz515ins = x.xwfprcin
           where x.xwfcont = 'S'
             and jaqz515.jaqz515pai = ln_pepais
             and jaqz515.jaqz515tdo = ln_petdoc
             and jaqz515.jaqz515ndo = lc_pendoc
             and jaqz515.jaqz515fee =
                 (select max(jaqz515.jaqz515fee)
                    from jaqz515
                   inner join xwf070 x
                      on jaqz515.jaqz515ins = x.xwfprcin
                   where x.xwfcont = 'S'
                     and jaqz515.jaqz515pai = ln_pepais
                     and jaqz515.jaqz515tdo = ln_petdoc
                     and jaqz515.jaqz515ndo = lc_pendoc)
             AND rownum = 1;
        exception
          when others then
            null;
          
        end;
      end if;
      -----------------------------------------------------------------------------
    
      if ln_contarelse > 0 and ln_contarsng021 > 0 then
      
        if ld_fecha >= jaqz515fecha then
        
          begin
            select s.sng021sol, s.sng021fec, s.sng021sol
              into ln_SolEval, ld_FchRegEval, ln_InstUltEva
              from sng021 s
             where s.sng021eval = ln_codeva;
          exception
            when others then
              null;
          end;
        
          begin
            select sng023Mto
              into sng023montosoles
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 27;
          exception
            when others then
              sng023montosoles := 0;
          end;
        
          begin
            select sng023Mto
              into sng023montodolares
              from sng023 a
             where a.sng021eval = ln_codeva
               and a.sng026cod = 527;
          exception
            when others then
              sng023montodolares := 0;
          end;
          ----rcc
          begin
            begin
              select sum(j.JAQZ862gfin)
                into ln_saldoextSoles
                from JAQZ862 j
               where j.JAQZ862inst = ln_InstUltEva
                 and j.JAQZ862esta = 'S'
                 and j.JAQZ862chek = '1'
                 and j.jaqz862cent <> '00104'
                 and j.JAQZ862tcre in
                     ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
                 and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
                 and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
            exception
              when others then
                ln_saldoextSoles := 0;
            end;
          
            begin
              begin
                select sum(j.JAQZ862gfin)
                  into ln_saldoextDol
                  from JAQZ862 j
                 where j.JAQZ862inst = ln_InstUltEva
                   and j.JAQZ862esta = 'S'
                   and j.JAQZ862chek = '1'
                   and j.jaqz862cent <> '00104'
                   and j.JAQZ862tcre in
                       ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
                   and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
                   and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
              exception
                when others then
                  ln_saldoextDol := 0;
              end;
            
              ln_saldoextDol := nvl(ln_saldoextDol, 0) * tipodecambio;
            
            end;
          
            ln_resultadorcc := nvl(ln_saldoextDol, 0) +
                               nvl(ln_saldoextSoles, 0);
          end;
        
          ln_resultadoneto := (sng023montosoles +
                              (sng023montodolares * tipodecambio));
        
          ln_resultadoneto := nvl(ln_resultadoneto, 0);
        
          ln_resultadorcc := nvl(ln_resultadorcc, 0);
        
          -- ln_resultadorcc := ln_resultadorcc - nvl(ln_MntPotncial, 0); --mpostigoc 03.07.21
        
          ln_numerador := (ln_captotcaja + ln_resultadorcc + ln_MntCuoCntg +
                          ln_MntPotncial);
        
          if ld_FchRegEval >= ld_FchIniNewRatio then
            -- mpostigoc 26.03.2024
            ln_denominador := (ln_resultadoneto + ln_resultadorcc +
                              ln_MntPotncial);
          else
            if ld_FchRegEval < ld_FchIniNewRatio then
              ln_denominador := (ln_resultadoneto + ln_resultadorcc);
            end if;
          end if;
        
          if ln_denominador <> 0 then
            ln_resultado := round(ln_numerador / ln_denominador, 6);
          else
            ln_resultado := 0;
          end if;
          -- end if;
        else
        
          if jaqz515fecha <= ld_fechaactual then
            begin
              select jaqz516.jaqz516eval
                INTO jaqz516evapis
                from jaqz516
               WHERE jaqz516.jaqz516sol = jaqz515instancia;
            exception
              when others then
                null;
                jaqz516evapis := 0;
            end;
            ---Resultado Neto
            begin
              select jaqz517.jaqz517mto
                into ln_resultnetosoleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 27;
            exception
              when others then
                null;
                ln_resultnetosoleselse := 0;
            end;
            begin
              select jaqz517.jaqz517mto
                into ln_resultnetodolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 527;
            exception
              when others then
                null;
                ln_resultnetodolareselse := 0;
            end;
          
            -- RCC
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrccsoleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 19;
            exception
              when others then
                -- null;
                ln_resultrccsoleselse := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrccdolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 519;
            exception
              when others then
                -- null;
                ln_resultrccdolareselse := 0;
            end;
          
            --RCC2  
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrcc2soleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 79;
            exception
              when others then
                -- null;
                ln_resultrcc2soleselse := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrcc2dolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 579;
            exception
              when others then
                -- null;
                ln_resultrcc2dolareselse := 0;
            end;
          
            ln_resultadorcc := ((ln_resultrccsoleselse +
                               ln_resultrcc2soleselse) +
                               ((ln_resultrccdolareselse +
                               ln_resultrcc2dolareselse) * tipodecambio));
          
            ln_resultadonetoelse := (ln_resultnetosoleselse + (ln_resultnetodolareselse *
                                    tipodecambio)); --ojito el tipo de cambio
          
            ln_resultadoneto := nvl(ln_resultadonetoelse, 0);
          
            ln_resultadorcc := nvl(ln_resultadorcc, 0);
          
            -- ln_resultadorcc := ln_resultadorcc - nvl(ln_MntPotncial, 0); --mpostigoc 03.07.21
          
            ln_numeradorelse   := (ln_captotcaja + ln_resultadorcc +
                                  ln_MntCuoCntg + ln_MntPotncial);
            ln_denominadorelse := (ln_resultadoneto + ln_resultadorcc +
                                  ln_MntPotncial);
            if ln_denominadorelse <> 0 then
              ln_resultado := round(ln_numeradorelse / ln_denominadorelse,
                                    6);
            else
              ln_resultado := 0;
            end if;
          end if;
        
        end if;
      else
        if ln_contarsng021 > 0 then
          if ld_fecha <= ld_fechaactual then
          
            begin
              select s.sng021sol, s.sng021fec, s.sng021sol
                into ln_SolEval, ld_FchRegEval, ln_InstUltEva
                from sng021 s
               where s.sng021eval = ln_codeva;
            exception
              when others then
                null;
            end;
            ----resultados    27   527
            Begin
              select sng023Mto
                into sng023montosoles
                from sng023 a
               where a.sng021eval = ln_codeva
                 and a.sng026cod = 27;
            exception
              when others then
                null;
                sng023montosoles := 0;
            end;
          
            begin
              select sng023Mto
                into sng023montodolares
                from sng023 a
               where a.sng021eval = ln_codeva
                 and a.sng026cod = 527;
            exception
              when others then
                null;
                sng023montodolares := 0;
            end;
          
            --RCC
          
            begin
              begin
                select sum(j.JAQZ862gfin)
                  into ln_saldoextSoles
                  from JAQZ862 j
                 where j.JAQZ862inst = ln_InstUltEva
                   and j.JAQZ862esta = 'S'
                   and j.JAQZ862chek = '1'
                   and j.jaqz862cent <> '00104'
                   and j.JAQZ862tcre in
                       ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
                   and j.JAQZ862aux3 = 'R'
                   and j.JAQZ862aux1 = 7;
              exception
                when others then
                  ln_saldoextSoles := 0;
              end;
            
              begin
                begin
                  select sum(j.JAQZ862gfin)
                    into ln_saldoextDol
                    from JAQZ862 j
                   where j.JAQZ862inst = ln_InstUltEva
                     and j.JAQZ862esta = 'S'
                     and j.JAQZ862chek = '1'
                     and j.jaqz862cent <> '00104'
                     and j.JAQZ862tcre in
                         ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
                     and j.JAQZ862aux3 = 'R'
                     and j.JAQZ862aux1 = 7;
                exception
                  when others then
                    ln_saldoextDol := 0;
                end;
              
                ln_saldoextDol := nvl(ln_saldoextDol, 0) * tipodecambio;
              
              end;
            
              ln_resultadorcc := nvl(ln_saldoextDol, 0) +
                                 nvl(ln_saldoextSoles, 0);
            end;
          
            ln_resultadoneto := (sng023montosoles +
                                (sng023montodolares * tipodecambio));
          
            ln_resultadoneto := nvl(ln_resultadoneto, 0);
          
            ln_resultadorcc := nvl(ln_resultadorcc, 0);
          
            --ln_resultadorcc := ln_resultadorcc - nvl(ln_MntPotncial, 0); --mpostigoc 03.07.21
          
            ln_numerador := (ln_captotcaja + ln_resultadorcc +
                            ln_MntCuoCntg + ln_MntPotncial);
            /*     ln_denominador := (ln_resultadoneto + ln_resultadorcc +
            ln_MntPotncial);*/
            if ld_FchRegEval >= ld_FchIniNewRatio then
              -- mpostigoc 26.03.2024
              ln_denominador := (ln_resultadoneto + ln_resultadorcc +
                                ln_MntPotncial);
            else
              if ld_FchRegEval < ld_FchIniNewRatio then
                ln_denominador := (ln_resultadoneto + ln_resultadorcc);
              end if;
            end if;
          
            if ln_denominador <> 0 then
              ln_resultado := round(ln_numerador / ln_denominador, 6);
            else
              ln_resultado := 0;
            end if;
          end if;
        else
          if /*ld_fechalimite <= jaqz515fecha and*/
           jaqz515fecha <= ld_fechaactual then
            begin
              select jaqz516.jaqz516eval
                INTO jaqz516evapis
                from jaqz516
               WHERE jaqz516.jaqz516sol = jaqz515instancia;
            exception
              when others then
                null;
                jaqz516evapis := 0;
            end;
            ---Resultado Neto
            begin
              select jaqz517.jaqz517mto
                into ln_resultnetosoleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 40;
            exception
              when others then
                null;
                ln_resultnetosoleselse := 0;
            end;
            begin
              select jaqz517.jaqz517mto
                into ln_resultnetodolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 540;
            exception
              when others then
                null;
                ln_resultnetodolareselse := 0;
            end;
          
            -- RCC
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrccsoleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 19;
            exception
              when others then
                -- null;
                ln_resultrccsoleselse := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrccdolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 519;
            exception
              when others then
                -- null;
                ln_resultrccdolareselse := 0;
            end;
          
            --RCC2  
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrcc2soleselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 79;
            exception
              when others then
                -- null;
                ln_resultrcc2soleselse := 0;
            end;
          
            begin
              select nvl(jaqz517.jaqz517mto, 0)
                into ln_resultrcc2dolareselse
                from jaqz517
               where jaqz517.jaqz517eval = jaqz516evapis
                 and jaqz517.jaqz517cod = 579;
            exception
              when others then
                -- null;
                ln_resultrcc2dolareselse := 0;
            end;
          
            ln_resultadorcc := ((ln_resultrccsoleselse +
                               ln_resultrcc2soleselse) +
                               ((ln_resultrccdolareselse +
                               ln_resultrcc2dolareselse) * tipodecambio));
          
            ln_resultadoneto := (ln_resultnetosoleselse +
                                (ln_resultnetodolareselse * tipodecambio)); --ojisto el tipo de cambio
          
            ln_resultadoneto := nvl(ln_resultadoneto, 0);
          
            ln_resultadorcc := nvl(ln_resultadorcc, 0);
          
            -- ln_resultadorcc := ln_resultadorcc - nvl(ln_MntPotncial, 0); --mpostigoc 03.07.21
          
            ln_numeradorelse   := (ln_captotcaja + ln_resultadorcc +
                                  ln_MntCuoCntg + ln_MntPotncial);
            ln_denominadorelse := (ln_resultadoneto + ln_resultadorcc +
                                  ln_MntPotncial);
            if ln_denominadorelse <> 0 then
              ln_resultado := Round(ln_numeradorelse / ln_denominadorelse,
                                    6);
            else
              ln_resultado := 0;
            end if;
          end if;
        
        end if;
      
      end if;
    
      begin
        update aqpa270
           set aqpa270.aqpa270ratio  = ln_resultado,
               aqpa270.aqpa270sldext = ln_resultadorcc,
               aqpa270.aqpa270resnet = ln_resultadoneto --ln_resultadorcc ,
         where aqpa270.aqpa270pais = ln_pepais
           and aqpa270.aqpa270tdoc = ln_petdoc
              -- and aqpa270.aqpa270ndoc = lc_pendoc
           and aqpa270.aqpa270inst = ln_instancia
           and aqpa270.aqpa270est = 'I'
           and aqpa270.aqpa270fec = ld_fechaactual
           and aqpa270.aqpa270hora =
               (select max(aqpa270.aqpa270hora)
                  from aqpa270
                 where aqpa270.aqpa270pais = ln_pepais
                   and aqpa270.aqpa270tdoc = ln_petdoc
                      -- and aqpa270.aqpa270ndoc = lc_pendoc
                   and aqpa270.aqpa270inst = ln_instancia
                   and aqpa270.aqpa270est = 'I'
                   and aqpa270.aqpa270fec = ld_fechaactual);
        commit;
      end;
    
    End;
  End sp_resultadonetolinea;

  ----------------------------------------------------------------------------------
  -- MPOSTIGOC 040219, cambio en formula para calculo de ratio

  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                lc_flgprg       in varchar2,
                                LN_ITPGCOD      in number,
                                LN_ITSUC        in number,
                                LN_ITMOD        in number,
                                LN_ITTRAN       in number,
                                LN_ITNREL       in number,
                                LN_ITORD        in number,
                                LN_ITSBOR       in number,
                                ln_garant       in varchar2,
                                ln_segmen       in number,
                                lc_Usuario      in varchar2,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF(ln_pais number,
                           ln_tdoc number,
                           lc_ndoc varchar2) is
    
      select distinct d10.pgcod    ln_pgcod10,
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
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from sng001 s, fsr008 f
                            where s.sng001inst = ln_Instancia
                              and s.sng001pais = f.pepais
                              and s.sng001tdoc = f.Petdoc
                              and s.sng001ndoc = f.pendoc
                              and cttfir = 'T')
         and d10.Aomod = 141
         and d10.Aostat <> 99;
  
    cursor lista_CredvueloCF(ln_pais number,
                             ln_tdoc number,
                             lc_ndoc varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstAvalada
        from xwf700 x, wfwrkitems w
       where x.xwfempresa = 1
         and x.xwfcuenta in (select Ctnro
                               from sng001 s, fsr008 f
                              where s.sng001inst = ln_Instancia
                                and s.sng001pais = f.pepais
                                and s.sng001tdoc = f.Petdoc
                                and s.sng001ndoc = f.pendoc
                                and cttfir = 'T')
            
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        number;
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    ln_moneda      number;
    pd_fecpro      date;
  
  begin
    ln_MntCuoCntgCF := 0;
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigCF(ln_pais, ln_tdoc, lc_ndoc) loop
        begin
          select f.scsdo * -1
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.ln_pgcod10
             and f.scsuc = l.ln_suc10
             and f.scmda = l.ln_mda10
             and f.scpap = l.ln_pap10
             and f.sccta = l.ln_cta10
             and f.scoper = l.ln_oper10
             and f.scsbop = l.ln_sbop10
             and f.sctope = l.ln_tope10;
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if l.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        --  if lc_flgprg = 'S' or lc_flgprg = 'R' then
        begin
          pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                    lnPetdoc     => ln_tdoc,
                                                    lnPendoc     => lc_ndoc,
                                                    tipocambio   => ln_tipocambio,
                                                    Instancia    => ln_Instancia,
                                                    pd_fecpro    => pd_fecpro,
                                                    ln_PGCOD     => L.LN_PGCOD10,
                                                    ln_MOD       => l.ln_mod10,
                                                    ln_SUC       => l.ln_suc10,
                                                    ln_MDA       => l.ln_mda10,
                                                    ln_PAP       => l.ln_pap10,
                                                    ln_CTA       => l.ln_cta10,
                                                    ln_OPE       => l.ln_oper10,
                                                    ln_SBOP      => l.ln_sbop10,
                                                    ln_TOPE      => l.ln_tope10,
                                                    ln_peri10    => 999,
                                                    ln_nrocuotas => 0,
                                                    ln_parciales => 0,
                                                    ln_flagFC    => 'N',
                                                    ln_cuotimp   => ln_SaldCap,
                                                    ln_seguro    => 0,
                                                    ln_CapFC     => 0,
                                                    CapLinea     => 0,
                                                    ln_CAPCUO    => ln_CuotCntgAux,
                                                    lc_IndCred   => 'CredVgntCF',
                                                    lc_flgprg    => 'L',
                                                    LN_ITPGCOD   => LN_ITPGCOD,
                                                    LN_ITSUC     => LN_ITSUC,
                                                    LN_ITMOD     => LN_ITMOD,
                                                    LN_ITTRAN    => LN_ITTRAN,
                                                    LN_ITNREL    => LN_ITNREL,
                                                    LN_ITORD     => LN_ITORD,
                                                    LN_ITSBOR    => LN_ITSBOR,
                                                    ln_garant    => ln_garant,
                                                    ln_segmen    => ln_segmen,
                                                    lc_Usuario   => lc_Usuario);
        
        end;
        --end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF(ln_pais, ln_tdoc, lc_ndoc) loop
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if lc_flgprg = 'S' or lc_flgprg = 'R' then
        begin
          pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                    lnPetdoc     => ln_tdoc,
                                                    lnPendoc     => lc_ndoc,
                                                    tipocambio   => ln_tipocambio,
                                                    Instancia    => ln_Instancia,
                                                    pd_fecpro    => pd_fecpro,
                                                    ln_PGCOD     => v.LN_PGCOD10,
                                                    ln_MOD       => v.ln_mod10,
                                                    ln_SUC       => v.ln_suc10,
                                                    ln_MDA       => v.ln_mda10,
                                                    ln_PAP       => v.ln_pap10,
                                                    ln_CTA       => v.ln_cta10,
                                                    ln_OPE       => v.ln_oper10,
                                                    ln_SBOP      => v.ln_sbop10,
                                                    ln_TOPE      => v.ln_tope10,
                                                    ln_peri10    => 999,
                                                    ln_nrocuotas => 0,
                                                    ln_parciales => 0,
                                                    ln_flagFC    => 'N',
                                                    ln_cuotimp   => ln_SaldCap,
                                                    ln_seguro    => 0,
                                                    ln_CapFC     => 0,
                                                    CapLinea     => 0,
                                                    ln_CAPCUO    => ln_CuotCntgAux,
                                                    lc_IndCred   => 'CredVuelCF',
                                                    lc_flgprg    => 'L',
                                                    LN_ITPGCOD   => LN_ITPGCOD,
                                                    LN_ITSUC     => LN_ITSUC,
                                                    LN_ITMOD     => LN_ITMOD,
                                                    LN_ITTRAN    => LN_ITTRAN,
                                                    LN_ITNREL    => LN_ITNREL,
                                                    LN_ITORD     => LN_ITORD,
                                                    LN_ITSBOR    => LN_ITSBOR,
                                                    ln_garant    => ln_garant,
                                                    ln_segmen    => ln_segmen,
                                                    lc_Usuario   => lc_Usuario);
        end;
        -- end if;
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  lc_flgprg         in varchar2,
                                  LN_ITPGCOD        in number,
                                  LN_ITSUC          in number,
                                  LN_ITMOD          in number,
                                  LN_ITTRAN         in number,
                                  LN_ITNREL         in number,
                                  LN_ITORD          in number,
                                  LN_ITSBOR         in number,
                                  ln_garant         in varchar2,
                                  ln_segmen         in number,
                                  lc_Usuario        in varchar2,
                                  ln_MntCuoCntgAval out number) is
  
    cursor lista_CredVigAval(ln_pais number,
                             ln_tdoc number,
                             lc_doc  varchar2) is
      select distinct h.pgcod  ln_pgcod10,
                      h.aomod  ln_mod10,
                      h.aosuc  ln_suc10,
                      h.aomda  ln_mda10,
                      h.aopap  ln_pap10,
                      h.aocta  ln_cta10,
                      h.aooper ln_oper10,
                      h.aosbop ln_sbop10,
                      h.aotope ln_tope10
        from sng003 g, xwf700 x, fsd010 h
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfempresa = h.pgcod
         and x.xwfsucursal = h.aosuc
         and x.xwfmodulo = h.aomod
         and x.xwfmoneda = h.aomda
         and x.xwfpapel = h.aopap
         and x.xwfcuenta = h.aocta
         and x.xwfoperacion = h.aooper
         and x.xwfsubope = h.aosbop
         and x.xwftipope = h.aotope
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and h.aostat <> 99;
  
    cursor lista_CredvueloAval(ln_pais number,
                               ln_tdoc number,
                               lc_doc  varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstanciaAvalada
      
        from sng003 g, xwf700 x, wfwrkitems w
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfprcins = w.wfinsprcid
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and w.wfitemstsact = 1;
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_paiscy      number;
    ln_tdoccy      number;
    lc_ndoccy      varchar2(12);
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    pd_fecpro      date;
    ln_Modulo      number;
    ln_moneda      number;
    lc_verfamp     varchar2(2) := 'N';
    lc_vrfrefrep   varchar2(2) := 'N';
    lc_verfvinc    varchar2(2) := 'N';
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
  
    begin
      select w.xwfmodulo
        into ln_Modulo
        from xwf700 w
       where w.xwfprcins = ln_Instancia;
    exception
      when others then
        ln_Modulo := 0;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                                ln_mod10  => l.ln_mod10,
                                                ln_suc10  => l.ln_suc10,
                                                ln_mda10  => l.ln_mda10,
                                                ln_pap10  => l.ln_pap10,
                                                ln_cta10  => l.ln_cta10,
                                                ln_oper10 => l.ln_oper10,
                                                ln_sbop10 => l.ln_sbop10,
                                                ln_tope10 => l.ln_tope10,
                                                Pc_flag   => lc_verfamp);
      
        pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
                                                ln_mod10    => l.ln_mod10,
                                                ln_suc10    => l.ln_suc10,
                                                ln_mda10    => l.ln_mda10,
                                                ln_pap10    => l.ln_pap10,
                                                ln_cta10    => l.ln_cta10,
                                                ln_oper10   => l.ln_oper10,
                                                lc_fgRefLin => lc_vrfrefrep);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                   ln_suc10  => l.ln_suc10,
                                                   ln_mda10  => l.ln_mda10,
                                                   ln_pap10  => l.ln_pap10,
                                                   ln_cta10  => l.ln_cta10,
                                                   ln_oper10 => l.ln_oper10,
                                                   ln_sbop10 => l.ln_sbop10,
                                                   ln_tope10 => l.ln_tope10,
                                                   lc_FlgLn  => lc_verfvinc);
      
        if lc_verfamp = 'N' and lc_vrfrefrep = 'N' and lc_verfvinc = 'N' then
        
          if l.ln_mod10 <> 117 then
            begin
              select f.scsdo
                into ln_SaldCap
                from fsd011 f
               where f.pgcod = l.ln_pgcod10
                 and f.scsuc = l.ln_suc10
                 and f.scmda = l.ln_mda10
                 and f.scpap = l.ln_pap10
                 and f.sccta = l.ln_cta10
                 and f.scoper = l.ln_oper10
                 and f.scsbop = l.ln_sbop10
                 and f.sctope = l.ln_tope10;
            exception
              when others then
                ln_SaldCap := 0;
            end;
          
            if ln_SaldCap < 0 then
              ln_SaldCap := ln_SaldCap * -1;
            end if; --mpostigoc 08/07/2019
          
            if l.ln_mda10 = 101 then
              ln_SaldCap := ln_SaldCap * ln_tipocambio;
            end if;
          
          else
            if l.ln_mod10 = 117 then
              begin
                select x.xwfmonto1
                  into ln_SaldCap
                  from xwf700 x
                 where x.xwfempresa = l.ln_pgcod10
                   and x.xwfsucursal = l.ln_suc10
                   and x.xwfmodulo = l.ln_mod10
                   and x.xwfmoneda = l.ln_mda10
                   and x.xwfpapel = l.ln_pap10
                   and x.xwfcuenta = l.ln_cta10
                   and x.xwfoperacion = l.ln_oper10
                   and x.xwfsubope = l.ln_sbop10
                   and x.xwftipope = l.ln_tope10
                   and x.xwfcar3 = '1';
              exception
                when others then
                  ln_SaldCap := 0;
              end;
            
              if ln_SaldCap < 0 then
                ln_SaldCap := ln_SaldCap * -1;
              end if; --mpostigoc 08/07/2019
            
              if l.ln_mda10 = 101 then
                ln_SaldCap := ln_SaldCap * ln_tipocambio;
              end if;
            end if;
          end if;
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
        
          -- if lc_flgprg = 'S' or lc_flgprg = 'R' then
        
          begin
            pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                      lnPetdoc     => ln_tdoc,
                                                      lnPendoc     => lc_ndoc,
                                                      tipocambio   => ln_tipocambio,
                                                      Instancia    => ln_Instancia,
                                                      pd_fecpro    => pd_fecpro,
                                                      ln_PGCOD     => L.LN_PGCOD10,
                                                      ln_MOD       => l.ln_mod10,
                                                      ln_SUC       => l.ln_suc10,
                                                      ln_MDA       => l.ln_mda10,
                                                      ln_PAP       => l.ln_pap10,
                                                      ln_CTA       => l.ln_cta10,
                                                      ln_OPE       => l.ln_oper10,
                                                      ln_SBOP      => l.ln_sbop10,
                                                      ln_TOPE      => l.ln_tope10,
                                                      ln_peri10    => 999,
                                                      ln_nrocuotas => 0,
                                                      ln_parciales => 0,
                                                      ln_flagFC    => 'N',
                                                      ln_cuotimp   => ln_SaldCap,
                                                      ln_seguro    => 0,
                                                      ln_CapFC     => 0,
                                                      CapLinea     => 0,
                                                      ln_CAPCUO    => ln_CuotCntgAux,
                                                      lc_IndCred   => 'CredVgnAvl',
                                                      lc_flgprg    => 'L',
                                                      LN_ITPGCOD   => LN_ITPGCOD,
                                                      LN_ITSUC     => LN_ITSUC,
                                                      LN_ITMOD     => LN_ITMOD,
                                                      LN_ITTRAN    => LN_ITTRAN,
                                                      LN_ITNREL    => LN_ITNREL,
                                                      LN_ITORD     => LN_ITORD,
                                                      LN_ITSBOR    => LN_ITSBOR,
                                                      ln_garant    => ln_garant,
                                                      ln_segmen    => ln_segmen,
                                                      lc_Usuario   => lc_Usuario);
          
          end;
          --end if;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        END IF;
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
        
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
        
          pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                    lnPetdoc     => ln_tdoc,
                                                    lnPendoc     => lc_ndoc,
                                                    tipocambio   => ln_tipocambio,
                                                    Instancia    => ln_Instancia,
                                                    pd_fecpro    => pd_fecpro,
                                                    ln_PGCOD     => v.LN_PGCOD10,
                                                    ln_MOD       => v.ln_mod10,
                                                    ln_SUC       => v.ln_suc10,
                                                    ln_MDA       => v.ln_mda10,
                                                    ln_PAP       => v.ln_pap10,
                                                    ln_CTA       => v.ln_cta10,
                                                    ln_OPE       => v.ln_oper10,
                                                    ln_SBOP      => v.ln_sbop10,
                                                    ln_TOPE      => v.ln_tope10,
                                                    ln_peri10    => 999,
                                                    ln_nrocuotas => 0,
                                                    ln_parciales => 0,
                                                    ln_flagFC    => 'N',
                                                    ln_cuotimp   => ln_SaldCap,
                                                    ln_seguro    => 0,
                                                    ln_CapFC     => 0,
                                                    CapLinea     => 0,
                                                    ln_CAPCUO    => ln_CuotCntgAux,
                                                    lc_IndCred   => 'CredVlAval',
                                                    lc_flgprg    => 'L',
                                                    LN_ITPGCOD   => LN_ITPGCOD,
                                                    LN_ITSUC     => LN_ITSUC,
                                                    LN_ITMOD     => LN_ITMOD,
                                                    LN_ITTRAN    => LN_ITTRAN,
                                                    LN_ITNREL    => LN_ITNREL,
                                                    LN_ITORD     => LN_ITORD,
                                                    LN_ITSBOR    => LN_ITSBOR,
                                                    ln_garant    => ln_garant,
                                                    ln_segmen    => ln_segmen,
                                                    lc_Usuario   => lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null and ln_Modulo <> 107 then
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        pq_cr_resolutor_cappago.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                                ln_mod10  => l.ln_mod10,
                                                ln_suc10  => l.ln_suc10,
                                                ln_mda10  => l.ln_mda10,
                                                ln_pap10  => l.ln_pap10,
                                                ln_cta10  => l.ln_cta10,
                                                ln_oper10 => l.ln_oper10,
                                                ln_sbop10 => l.ln_sbop10,
                                                ln_tope10 => l.ln_tope10,
                                                Pc_flag   => lc_verfamp);
      
        pq_cr_resolutor_cappago.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
                                                ln_mod10    => l.ln_mod10,
                                                ln_suc10    => l.ln_suc10,
                                                ln_mda10    => l.ln_mda10,
                                                ln_pap10    => l.ln_pap10,
                                                ln_cta10    => l.ln_cta10,
                                                ln_oper10   => l.ln_oper10,
                                                lc_fgRefLin => lc_vrfrefrep);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                   ln_suc10  => l.ln_suc10,
                                                   ln_mda10  => l.ln_mda10,
                                                   ln_pap10  => l.ln_pap10,
                                                   ln_cta10  => l.ln_cta10,
                                                   ln_oper10 => l.ln_oper10,
                                                   ln_sbop10 => l.ln_sbop10,
                                                   ln_tope10 => l.ln_tope10,
                                                   lc_FlgLn  => lc_verfvinc);
      
        if lc_verfamp = 'N' and lc_vrfrefrep = 'N' and lc_verfvinc = 'N' then
        
          if l.ln_mod10 <> 117 then
            begin
              select f.scsdo
                into ln_SaldCap
                from fsd011 f
               where f.pgcod = l.ln_pgcod10
                 and f.scsuc = l.ln_suc10
                 and f.scmda = l.ln_mda10
                 and f.scpap = l.ln_pap10
                 and f.sccta = l.ln_cta10
                 and f.scoper = l.ln_oper10
                 and f.scsbop = l.ln_sbop10
                 and f.sctope = l.ln_tope10;
            exception
              when others then
                ln_SaldCap := 0;
            end;
          
            if ln_SaldCap < 0 then
              ln_SaldCap := ln_SaldCap * -1;
            end if; --mpostigoc 08/07/2019
          
            if l.ln_mda10 = 101 then
              ln_SaldCap := ln_SaldCap * ln_tipocambio;
            end if;
          
          else
            if l.ln_mod10 = 117 then
              begin
                select x.xwfmonto1
                  into ln_SaldCap
                  from xwf700 x
                 where x.xwfempresa = l.ln_pgcod10
                   and x.xwfsucursal = l.ln_suc10
                   and x.xwfmodulo = l.ln_mod10
                   and x.xwfmoneda = l.ln_mda10
                   and x.xwfpapel = l.ln_pap10
                   and x.xwfcuenta = l.ln_cta10
                   and x.xwfoperacion = l.ln_oper10
                   and x.xwfsubope = l.ln_sbop10
                   and x.xwftipope = l.ln_tope10
                   and x.xwfcar3 = '1';
              exception
                when others then
                  ln_SaldCap := 0;
              end;
            
              if ln_SaldCap < 0 then
                ln_SaldCap := ln_SaldCap * -1;
              end if; --mpostigoc 08/07/2019
            
              if l.ln_mda10 = 101 then
                ln_SaldCap := ln_SaldCap * ln_tipocambio;
              end if;
            end if;
          end if;
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
        
          -- if lc_flgprg = 'S' or lc_flgprg = 'R' then
          begin
          
            pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                      lnPetdoc     => ln_tdoc,
                                                      lnPendoc     => lc_ndoc,
                                                      tipocambio   => ln_tipocambio,
                                                      Instancia    => ln_Instancia,
                                                      pd_fecpro    => pd_fecpro,
                                                      ln_PGCOD     => L.LN_PGCOD10,
                                                      ln_MOD       => l.ln_mod10,
                                                      ln_SUC       => l.ln_suc10,
                                                      ln_MDA       => l.ln_mda10,
                                                      ln_PAP       => l.ln_pap10,
                                                      ln_CTA       => l.ln_cta10,
                                                      ln_OPE       => l.ln_oper10,
                                                      ln_SBOP      => l.ln_sbop10,
                                                      ln_TOPE      => l.ln_tope10,
                                                      ln_peri10    => 999,
                                                      ln_nrocuotas => 0,
                                                      ln_parciales => 0,
                                                      ln_flagFC    => 'N',
                                                      ln_cuotimp   => ln_SaldCap,
                                                      ln_seguro    => 0,
                                                      ln_CapFC     => 0,
                                                      CapLinea     => 0,
                                                      ln_CAPCUO    => ln_CuotCntgAux,
                                                      lc_IndCred   => 'CredVgnAvl',
                                                      lc_flgprg    => 'L',
                                                      LN_ITPGCOD   => LN_ITPGCOD,
                                                      LN_ITSUC     => LN_ITSUC,
                                                      LN_ITMOD     => LN_ITMOD,
                                                      LN_ITTRAN    => LN_ITTRAN,
                                                      LN_ITNREL    => LN_ITNREL,
                                                      LN_ITORD     => LN_ITORD,
                                                      LN_ITSBOR    => LN_ITSBOR,
                                                      ln_garant    => ln_garant,
                                                      ln_segmen    => ln_segmen,
                                                      lc_Usuario   => lc_Usuario);
          end;
          --end if;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
          pq_cr_ratio_lineaconsumo.sp_cr_LogCuentas(lnPepais     => ln_pais,
                                                    lnPetdoc     => ln_tdoc,
                                                    lnPendoc     => lc_ndoc,
                                                    tipocambio   => ln_tipocambio,
                                                    Instancia    => ln_Instancia,
                                                    pd_fecpro    => pd_fecpro,
                                                    ln_PGCOD     => v.LN_PGCOD10,
                                                    ln_MOD       => v.ln_mod10,
                                                    ln_SUC       => v.ln_suc10,
                                                    ln_MDA       => v.ln_mda10,
                                                    ln_PAP       => v.ln_pap10,
                                                    ln_CTA       => v.ln_cta10,
                                                    ln_OPE       => v.ln_oper10,
                                                    ln_SBOP      => v.ln_sbop10,
                                                    ln_TOPE      => v.ln_tope10,
                                                    ln_peri10    => 999,
                                                    ln_nrocuotas => 0,
                                                    ln_parciales => 0,
                                                    ln_flagFC    => 'N',
                                                    ln_cuotimp   => ln_SaldCap,
                                                    ln_seguro    => 0,
                                                    ln_CapFC     => 0,
                                                    CapLinea     => 0,
                                                    ln_CAPCUO    => ln_CuotCntgAux,
                                                    lc_IndCred   => 'CredVlAval',
                                                    lc_flgprg    => 'L',
                                                    LN_ITPGCOD   => LN_ITPGCOD,
                                                    LN_ITSUC     => LN_ITSUC,
                                                    LN_ITMOD     => LN_ITMOD,
                                                    LN_ITTRAN    => LN_ITTRAN,
                                                    LN_ITNREL    => LN_ITNREL,
                                                    LN_ITORD     => LN_ITORD,
                                                    LN_ITSBOR    => LN_ITSBOR,
                                                    ln_garant    => ln_garant,
                                                    ln_segmen    => ln_segmen,
                                                    lc_Usuario   => lc_Usuario);
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  procedure sp_cR_CuotaPotencial(ln_Instancia   in number,
                                 ln_MntPotncial out number) is
  
    ln_TipoSol number;
  
  begin
  
    ln_MntPotncial := 0;
  
    begin
      select s.sng021tmod
        into ln_TipoSol
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipoSol = 13 then
      begin
        select j.jaqy140cpoten
          into ln_MntPotncial
          from jaqy140 j
         where j.jaqy140inst = ln_Instancia
           and j.jaqy140est = 'H'
           and j.jaqy140tarea = 55;
      exception
        when others then
          ln_MntPotncial := 0;
        
      end;
    
    else
      if ln_TipoSol = 14 then
      
        begin
          select j.jaqz821cpoten
            into ln_MntPotncial
            from jaqz821 j
           where j.jaqz821inst = ln_Instancia
             and j.jaqz821est = 'H'
             and j.jaqz821tarea = 55;
        exception
          when others then
            ln_MntPotncial := 0;
        end;
      end if;
    end if;
  
  end sp_cR_CuotaPotencial;

  ----------------------------------------------------------------------------------------------------------------
  -- *****************************************************************
  -- Nombre                     : sp_insert_jaqy140
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : ACTULIZA LA TABLA JAQY140 CON LOS NUEVOS CALCULOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : se cambio actulizacion de tabla ccerpa 27/08/2018
  -- Descripción de Modificación: 
  --
  -- *****************************************************************
  procedure sp_insert_jaqy140(ln_instancia in number,
                              --ln_captotcaja    in number,
                              ln_pepais in number,
                              ln_petdoc in number,
                              lv_pendoc in varchar2,
                              -- ln_capcaja       out number,
                              ln_resultadorcc  in number,
                              ln_resultadoneto in number,
                              ln_resultado     in number) is
    lc_pendoc   char(12);
    totalrcc    number;
    totalneto   number;
    ratio       number;
    fechasistem date;
  Begin
  
    lc_pendoc := RPAD(trim(lv_pendoc), 12, ' ');
    totalrcc  := nvl(ln_resultadorcc, 0);
    totalneto := nvl(ln_resultadoneto, 0);
    ratio     := nvl(ln_resultado, 0);
    begin
    
      begin
        select fst017.pgfape
          into fechasistem
          from fst017
         where fst017.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      begin
        update aqpa270
           set aqpa270.aqpa270sldext = totalrcc, --ln_resultadorcc ,
               aqpa270.aqpa270resnet = totalneto,
               aqpa270.aqpa270ratio  = ratio
         where aqpa270.aqpa270pais = ln_pepais
           and aqpa270.aqpa270tdoc = ln_petdoc
           and aqpa270.aqpa270ndoc = lc_pendoc
           and aqpa270.aqpa270inst = ln_instancia
           and aqpa270.aqpa270est = 'I'
           and aqpa270.aqpa270fec = fechasistem
           and aqpa270.aqpa270hora =
               (select max(aqpa270.aqpa270hora)
                  from aqpa270
                 where aqpa270.aqpa270pais = ln_pepais
                   and aqpa270.aqpa270tdoc = ln_petdoc
                   and aqpa270.aqpa270ndoc = lc_pendoc
                   and aqpa270.aqpa270inst = ln_instancia
                   and aqpa270.aqpa270est = 'I'
                   and aqpa270.aqpa270fec = fechasistem);
        commit;
      end;
    
    end;
  
  End sp_insert_jaqy140;
  ----------------------------------------------------------------------------------------------------------------
  -- *****************************************************************
  -- Nombre                     : sp_insert_jaqy140
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : CRISTHIAN CERPA
  -- Uso                        : ACTULIZA VALIDA QUE LA PERSONA NO TENGA SEGMENTO 2
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --
  -- *****************************************************************
  procedure sp_validar_segmento(P_N_PAIS    in number,
                                p_n_tipdoc  in number,
                                p_c_numdoc  in VARCHAR2,
                                pn_retornar out NUMBER) is
    lc_pendoc      char(12);
    ln_SegLinea    number(5);
    contarjuridica number(5);
  begin
    ln_SegLinea    := 0;
    lc_pendoc      := RPAD(trim(p_c_numdoc), 12, ' ');
    contarjuridica := 0;
  
    begin
      select count(*)
        into contarjuridica
        from fsd001 a
       where a.pepais = P_N_PAIS
         and a.petdoc = p_n_tipdoc
         and a.pendoc = lc_pendoc
         and a.petipo = 'J';
    exception
      when others then
        null;
      
    end;
  
    if contarjuridica > 0 then
      ln_SegLinea := 1;
    else
      begin
        select b.segcod
          into ln_SegLinea
          from sngc60 a, sngc07 b
         where a.sngc60pais = P_N_PAIS
           and a.sngc60tdoc = p_n_tipdoc
           and a.sngc60ndoc = lc_pendoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select b.segcod
              into ln_SegLinea
              from sngc60 a, sngc07 b
             where a.sngc60pais = P_N_PAIS
               and a.sngc60tdoc = p_n_tipdoc
               and a.sngc60ndoc = lc_pendoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = P_N_PAIS
                       and a.sngc60tdoc = p_n_tipdoc
                       and a.sngc60ndoc = lc_pendoc
                       and a.sngc60ocup = b.sngc07cod);
          
          end;
        when no_data_found then
          null;
      end;
    end if;
  
    pn_retornar := ln_SegLinea;
  End sp_validar_segmento;
  ------------------------------------------------------------
  procedure sp_empresa_lineatmp(ln_instancia in number,
                                lv_flag90    out varchar2,
                                ln_valor     out number) is
  
    LN_TIPOCRED        number;
    ln_conexite        number;
    ln_pgcod           number;
    ln_suc             number;
    ln_mod             number;
    ln_mda             number;
    ln_pap             number;
    ln_cta             number;
    ln_ope             number;
    ln_sub             number;
    ln_tope            number;
    ld_fdesmb          date;
    ld_UltDiaMesDesebm date;
  
  begin
  
    begin
      select to_number(trim(replace(SUBSTR(w.wfattsval, 1, 2), ';', '')))
        into LN_TIPOCRED
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'TIPO_CREDITO';
    exception
      when others then
        LN_TIPOCRED := 0;
    end;
  
    LN_TIPOCRED := nvl(LN_TIPOCRED, 0);
  
    if LN_TIPOCRED = 0 then
      -- buscamos el tipo de credito de la ejecucion de politicas item 101 en evaluacion propuesta
      begin
        select to_number(f.pae71val)
          into LN_TIPOCRED
          from fpae71 f
         where f.pae51eva = 2
           and f.pae70nro = (select max(f.pae70nro)
                               from fpae70 f
                              where f.pae70ins = ln_instancia
                                and f.pae51eva = 2)
           and f.pae71ite = 101;
      exception
        when others then
          LN_TIPOCRED := 0;
      end;
    
      if LN_TIPOCRED = 0 then
        -- si no esta, buscamos el tipo de credito de la ejecucion de politicas item 101 en desembolso
        begin
          select to_number(f.pae71val)
            into LN_TIPOCRED
            from fpae71 f
           where f.pae51eva = 4
             and f.pae70nro = (select max(f.pae70nro)
                                 from fpae70 f
                                where f.pae70ins = ln_instancia
                                  and f.pae51eva = 4)
             and f.pae71ite = 101;
        exception
          when others then
            LN_TIPOCRED := 0;
        end;
      end if;
    
      LN_TIPOCRED := nvl(LN_TIPOCRED, 0);
    
      if LN_TIPOCRED = 0 then
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
                 ln_sub,
                 ln_tope
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            null;
        end;
      
        begin
          select f.aofval
            into ld_fdesmb
            from fsd010 f
           where f.pgcod = ln_pgcod
             and f.aomod = ln_mod
             and f.aosuc = ln_suc
             and f.aomda = ln_mda
             and f.aopap = ln_pap
             and f.aocta = ln_cta
             and f.aooper = ln_ope
             and f.aosbop = ln_sub
             and f.aotope = ln_tope
             and f.aostat <> 99;
        exception
          when others then
            null;
        end;
      
        begin
          SELECT LAST_DAY(ld_fdesmb) into ld_UltDiaMesDesebm FROM DUAL;
        exception
          when others then
            null;
        end;
      
        begin
          select f.BCGPO
            into LN_TIPOCRED
            from fsh012 f
           where f.bcemp = ln_pgcod
             and f.bcmod = ln_mod
             and f.bcsuc = ln_suc
             and f.bcmda = ln_mda
             and f.bcpap = ln_pap
             and f.bccta = ln_cta
             and f.bcoper = ln_ope
             and f.bcsbop = ln_sub
             and f.bctop = ln_tope
             and f.BCFECH = ld_UltDiaMesDesebm;
        exception
          when others then
            null;
        end;
      end if;
    end if;
  
    begin
      select count(*)
        into ln_conexite
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 101
         and Tp1nro1 = 1
         AND Tp1nro3 = LN_TIPOCRED;
    exception
      when others then
        null;
    end;
  
    if ln_conexite > 0 then
      lv_flag90 := 'S';
    
      begin
        select fst198.tp1imp1
          into ln_valor
          from fst198
         where Tp1cod = 1
           and Tp1cod1 = 10899
           and Tp1corr1 = 101
           and Tp1nro1 = 1
           AND Tp1nro3 = LN_TIPOCRED;
      exception
        when others then
          null;
        
      end;
    else
      lv_flag90 := 'N';
      ln_valor  := 0.00;
    end if;
  
    /* lv_flag90:='S';
    ln_valor:=0.8;*/
  end sp_empresa_lineatmp;
  -------------------------------------------------------------  
  procedure sp_empresa_lineatmp1(ln_instancia in number,
                                 lv_flag90    out varchar2,
                                 ln_valor     out number) is
  
  begin
  
    pq_cr_resolutor_lineas.sp_empresa_lineatmp(ln_instancia,
                                               lv_flag90,
                                               ln_valor);
  
    /* lv_flag90:='S';
    ln_valor:=0.8;*/
  end sp_empresa_lineatmp1;
  -------------------------------------------------------

  procedure sp_update_extornado(ln_pgcod  in number,
                                ln_suc    in number,
                                ln_itmod  in number,
                                ln_ittran in number,
                                ln_itrel  in number,
                                ln_itord  in number,
                                ln_itsbor in number) is
  
    ln_fechasistem date;
    ln_NroRelacion number;
    ln_itmod1      number := ln_itmod + 500;
  begin
    BEGIN
      select fst017.pgfape
        into ln_fechasistem
        from fst017
       where fst017.pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
    
      select to_number(Txtext)
        into ln_NroRelacion
        from FSX015
       Where PgCod = ln_pgcod
         and Hcmod = ln_itmod1
         and Hsucor = ln_suc
         and Htran = ln_ittran
         and Hnrel = ln_itrel
         and Hfcon = ln_fechasistem
         and Txcod = 0
         and Txreng = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      update aqpa270
         set AQPA270.AQPA270EST = 'E'
       WHERE aqpa270.aqpa270pgcod = ln_pgcod
         AND aqpa270.aqpa270itsuc = ln_suc
         AND aqpa270.aqpa270itmod = ln_itmod
         AND aqpa270.aqpa270ittran = ln_ittran
         AND aqpa270.aqpa270itnrel = ln_NroRelacion
         AND aqpa270.aqpa270itord = ln_itord
         AND aqpa270.aqpa270itsbor = ln_itsbor
         and aqpa270.aqpa270fec = ln_fechasistem
         and aqpa270.aqpa270est = 'H';
    exception
      when others then
        null;
    end;
  
    begin
      update aqpa271
         set AQPA271.AQPA271EST = 'E'
       WHERE aqpa271.AQPA271IPGCOD = ln_pgcod
         AND aqpa271.AQPA271ITSUC = ln_suc
         AND aqpa271.AQPA271ITMOD = ln_itmod
         AND aqpa271.AQPA271ITTRAN = ln_ittran
         AND aqpa271.AQPA271ITNREL = ln_NroRelacion
         AND aqpa271.AQPA271ITORD = ln_itord
         AND aqpa271.AQPA271ITSBOR = ln_itsbor
         and aqpa271.aqpa271fec = ln_fechasistem
         and aqpa271.aqpa271est = 'H';
    exception
      when others then
        null;
    end;
  
  end sp_update_extornado;
  -------------------------------------------------
  procedure sp_update_status(ln_pgcod  in number,
                             ln_suc    in number,
                             ln_itmod  in number,
                             ln_ittran in number,
                             ln_itrel  in number,
                             ln_itord  in number,
                             ln_itsbor in number) is
  
    ln_fechasistem date;
    ln_intancia    number;
  begin
    BEGIN
      select fst017.pgfape
        into ln_fechasistem
        from fst017
       where fst017.pgcod = 1;
    exception
      when others then
        null;
    END;
  
    begin
      update aqpa270
         set AQPA270.AQPA270EST = 'H'
       WHERE aqpa270.aqpa270pgcod = ln_pgcod
         AND aqpa270.aqpa270itsuc = ln_suc
         AND aqpa270.aqpa270itmod = ln_itmod
         AND aqpa270.aqpa270ittran = ln_ittran
         AND aqpa270.aqpa270itnrel = ln_itrel
         AND aqpa270.aqpa270itord = ln_itord
         AND aqpa270.aqpa270itsbor = ln_itsbor
         and aqpa270.aqpa270fec = ln_fechasistem
         AND AQPA270.AQPA270HORA =
             (select max(AQPA270.AQPA270HORA)
                from aqpa270
               WHERE aqpa270.aqpa270pgcod = ln_pgcod
                 AND aqpa270.aqpa270itsuc = ln_suc
                 AND aqpa270.aqpa270itmod = ln_itmod
                 AND aqpa270.aqpa270ittran = ln_ittran
                 AND aqpa270.aqpa270itnrel = ln_itrel
                 AND aqpa270.aqpa270itord = ln_itord
                 AND aqpa270.aqpa270itsbor = ln_itsbor
                 and aqpa270.aqpa270fec = ln_fechasistem);
    exception
      when others then
        null;
    end;
  
    begin
      update aqpa271
         set AQPA271.AQPA271EST = 'H'
       WHERE aqpa271.AQPA271IPGCOD = ln_pgcod
         AND aqpa271.AQPA271ITSUC = ln_suc
         AND aqpa271.AQPA271ITMOD = ln_itmod
         AND aqpa271.AQPA271ITTRAN = ln_ittran
         AND aqpa271.AQPA271ITNREL = ln_itrel
         AND aqpa271.AQPA271ITORD = ln_itord
         AND aqpa271.AQPA271ITSBOR = ln_itsbor
         and aqpa271.aqpa271fec = ln_fechasistem
         AND AQPA271.AQPA271HORA =
             (select max(aqpa271.AQPA271HORA)
                from aqpa271
               WHERE aqpa271.AQPA271IPGCOD = ln_pgcod
                 AND aqpa271.AQPA271ITSUC = ln_suc
                 AND aqpa271.AQPA271ITMOD = ln_itmod
                 AND aqpa271.AQPA271ITTRAN = ln_ittran
                 AND aqpa271.AQPA271ITNREL = ln_itrel
                 AND aqpa271.AQPA271ITORD = ln_itord
                 AND aqpa271.AQPA271ITSBOR = ln_itsbor
                 and aqpa271.aqpa271fec = ln_fechasistem);
    
    exception
      when others then
        null;
    end;
    --- Eliminar
    begin
    
      begin
        select aqpa270.aqpa270inst
          into ln_intancia
          from aqpa270
         WHERE aqpa270.aqpa270pgcod = ln_pgcod
           AND aqpa270.aqpa270itsuc = ln_suc
           AND aqpa270.aqpa270itmod = ln_itmod
           AND aqpa270.aqpa270ittran = ln_ittran
           AND aqpa270.aqpa270itnrel = ln_itrel
           AND aqpa270.aqpa270itord = ln_itord
           AND aqpa270.aqpa270itsbor = ln_itsbor
           and aqpa270.aqpa270fec = ln_fechasistem
           and rownum = 1;
      exception
        -- mpostigoc 05/11/18
        when others then
          ln_intancia := null;
      end;
    
      if ln_intancia is not null then
        --  mpostigoc 05/11/18
        begin
          delete from aqpa270 a
           where a.aqpa270inst = ln_intancia
             and a.aqpa270pgcod = ln_pgcod --16/05/2019
             and a.aqpa270itsuc = ln_suc
             and a.aqpa270itmod = ln_itmod
             and a.aqpa270ittran = ln_ittran
             and a.aqpa270itnrel = ln_itrel
             and a.aqpa270itord = ln_itord
             and a.aqpa270itsbor = ln_itsbor
             and a.aqpa270est not in ('E', 'H');
        end;
      
        begin
        
          delete from aqpa271 a
           where a.aqpa271inst = ln_intancia
             and a.aqpa271pgcod = ln_pgcod --16/05/2019
             and a.aqpa271itsuc = ln_suc
             and a.aqpa271itmod = ln_itmod
             and a.aqpa271ittran = ln_ittran
             and a.aqpa271itnrel = ln_itrel
             and a.aqpa271itord = ln_itord
             and a.aqpa271itsbor = ln_itsbor
             and a.aqpa271est not in ('E', 'H');
        
        end;
      end if;
    end;
  end sp_update_status;

end pq_cr_resolutor_lineas_consumo;
/

