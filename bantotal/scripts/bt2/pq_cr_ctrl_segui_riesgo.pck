create or replace package PQ_CR_CTRL_SEGUI_RIESGO is

  -- Author  : EFUENTES
  -- Created : 17/05/2022 09:25:25
  -- Purpose : PAQUETE PARA REGISTRAR CONTORL DE RIESGO

  ------------------------------------------------------------------------------ 
  procedure sp_control_riesgo(pn_cor     in number,
                              pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_pais    in number,
                              pn_tdoc    in number,
                              pv_ndoc    in varchar2,
                              pv_nomcli  in varchar2,
                              pv_anasup  in varchar2,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecreg  in date,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_usureg  in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_tipo    in varchar2,
                              pv_flgconf out varchar2);
  ------------------------------------------------------------------------------ 
  procedure sp_grabar_control(pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_pais    in number,
                              pn_tdoc    in number,
                              pv_ndoc    in varchar2,
                              pv_nomcli  in varchar2,
                              pv_anasup  in varchar2,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecreg  in date,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_usureg  in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_flgconf out varchar2);

  ------------------------------------------------------------------------------  
  procedure sp_eliminar_control(pn_cor     in number,
                                pn_pgcod   in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mdn     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sope    in number,
                                pn_tope    in number,
                                pd_fecact  in date,
                                pd_usuact  in varchar2,
                                pv_flgconf out varchar2);

  ------------------------------------------------------------------------------ 
  procedure sp_update_control(pn_cor     in number,
                              pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_flgconf out varchar2);
                              
  ------------------------------------------------------------------------------  
  procedure sp_validar_eliminar(pv_analista in varchar,
                                pv_flg      out varchar2);
end PQ_CR_CTRL_SEGUI_RIESGO;
/

create or replace package body PQ_CR_CTRL_SEGUI_RIESGO is
  ------------------------------------------------------------------------------  
  procedure sp_control_riesgo(pn_cor     in number,
                              pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_pais    in number,
                              pn_tdoc    in number,
                              pv_ndoc    in varchar2,
                              pv_nomcli  in varchar2,
                              pv_anasup  in varchar2,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecreg  in date,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_usureg  in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_tipo    in varchar2,
                              pv_flgconf out varchar2) is
  begin
    if pv_tipo = 'INS' then
      PQ_CR_CTRL_SEGUI_RIESGO.sp_grabar_control(pn_pgcod,
                                                pn_mod,
                                                pn_suc,
                                                pn_mdn,
                                                pn_pap,
                                                pn_cta,
                                                pn_ope,
                                                pn_sope,
                                                pn_tope,
                                                pn_pais,
                                                pn_tdoc,
                                                pv_ndoc,
                                                pv_nomcli,
                                                pv_anasup,
                                                pn_agesup,
                                                pv_tipeve,
                                                pv_codeve,
                                                pd_fecreg,
                                                pd_fecsup,
                                                pv_obs,
                                                pv_usureg,
                                                pv_ressup,
                                                pd_fecact,
                                                pd_usuact,
                                                pv_flgconf);
    elsif pv_tipo = 'UPD' then
      PQ_CR_CTRL_SEGUI_RIESGO.sp_update_control(pn_cor,
                                                pn_pgcod,
                                                pn_mod,
                                                pn_suc,
                                                pn_mdn,
                                                pn_pap,
                                                pn_cta,
                                                pn_ope,
                                                pn_sope,
                                                pn_tope,
                                                pn_agesup,
                                                pv_tipeve,
                                                pv_codeve,
                                                pd_fecsup,
                                                pv_obs,
                                                pv_ressup,
                                                pd_fecact,
                                                pd_usuact,
                                                pv_flgconf);
    elsif pv_tipo = 'DEL' then
      PQ_CR_CTRL_SEGUI_RIESGO.sp_eliminar_control(pn_cor,
                                                  pn_pgcod,
                                                  pn_mod,
                                                  pn_suc,
                                                  pn_mdn,
                                                  pn_pap,
                                                  pn_cta,
                                                  pn_ope,
                                                  pn_sope,
                                                  pn_tope,
                                                  pd_fecact,
                                                  pd_usuact,
                                                  pv_flgconf);
    else
      pv_flgconf := 'X';
    end if;
  end sp_control_riesgo;

  ------------------------------------------------------------------------------  
  procedure sp_grabar_control(pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_pais    in number,
                              pn_tdoc    in number,
                              pv_ndoc    in varchar2,
                              pv_nomcli  in varchar2,
                              pv_anasup  in varchar2,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecreg  in date,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_usureg  in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_flgconf out varchar2) is
    my_errm varchar2(32000);
    ln_corr number;
    lv_hora varchar2(15);
  
    lv_nomsuc varchar2(30);
    ln_CodZon number(3);
    lc_NomZon char(40);
    ln_CodReg number(9);
    lc_NomReg char(30);
  
    lv_deseve char(50);
  
  begin
    --hora
    lv_hora := to_char(sysdate, 'HH24:MI:SS');
  
    --correlativo
    begin
      select nvl(max(AQPB624COR), 0) + 1
        into ln_corr
        from aqpb624
       where AQPB624PGCOD = pn_pgcod
         and AQPB624MOD = pn_mod
         and AQPB624SUC = pn_suc
         and AQPB624MND = pn_mdn
         and AQPB624PAP = pn_pap
         and AQPB624CTA = pn_cta
         and AQPB624OPE = pn_ope
         and AQPB624SOPE = pn_sope
         and AQPB624TOPE = pn_tope;
    exception
      when others then
        my_errm := SQLERRM;
    end;
  
    /*  
    --desactivar
    begin
      update aqpb624 a
         set a.aqpb624est = 'E'
       where AQPB624PGCOD = pn_pgcod
         and AQPB624MOD = pn_mod
         and AQPB624SUC = pn_suc
         and AQPB624MND = pn_mdn
         and AQPB624PAP = pn_pap
         and AQPB624CTA = pn_cta
         and AQPB624OPE = pn_ope
         and AQPB624SOPE = pn_sope
         and AQPB624TOPE = pn_tope;
    exception
      when others then
        my_errm := SQLERRM;
    end;
    */
    --Descripcion evento
    begin
      select b.aqpb624ades
        into lv_deseve
        from aqpb624a b
       where b.aqpb624aest = 'S'
         and b.aqpb624atip = rpad(pv_tipeve, 20, ' ')
         and b.aqpb624acod = rpad(pv_codeve, 10, ' ');
    exception
      when others then
        my_errm := SQLERRM;
    end;
  
    --nombre sucursal
    begin
      select Scnom
        into lv_nomsuc
        from Fst001
       Where Pgcod = 1
         and Sucurs = pn_agesup;
    exception
      when others then
        my_errm := SQLERRM;
    end;
  
    --codigo zona
    begin
      SELECT RegCod
        into ln_CodZon
        FROM fst811
       Where Pgcod = 1
         AND OfiCod = pn_agesup
         AND RegCod < 100;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --nombre zona
    begin
      SELECT RegNom
        into lc_NomZon
        FROM Fst810
       Where Pgcod = 1
         AND RegCod = ln_CodZon
         AND RegCod < 100;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --codigo y nombre region
    begin
      SELECT Tp1nro1, Tp1desc
        into ln_CodReg, lc_NomReg
        FROM fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10872
         AND Tp1corr1 = 11
         AND Tp1nro2 = ln_CodZon;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --insert registro
    begin
      insert into aqpb624
        (AQPB624COR, --1 correlativo
         AQPB624PGCOD, --2 empresa
         AQPB624MOD, --3 modulo
         AQPB624SUC, --4 sucursal
         AQPB624MND, --5 moneda
         AQPB624PAP, --6 papel
         AQPB624CTA, --7 cuenta
         AQPB624OPE, --8 operación
         AQPB624SOPE, --9 suboperacion
         AQPB624TOPE, --10 tipo de operación
         AQPB624EST, --11 estado
         AQPB624PAIS, --12 pais
         AQPB624TDOC, --13 tipo documento
         AQPB624NDOC, --14 numero documento
         AQPB624NOM, --15 nombre cliente
         AQPB624ANAS, --16 analista de creditos supervisado
         AQPB624AGES, --17 agencia de supervision
         AQPB624NOMS, --18 nombre sucursal
         AQPB624ZON, --19 zona
         AQPB624NOMZ, --20 nombre zona
         AQPB624REG, --21 region
         AQPB624NOMR, --22 nombre region
         AQPB624TIPE, --23 Tipo de evento
         AQPB624CODE, --24 codigo evento
         AQPB624DESE, --25 descripcion evento
         AQPB624FREG, --26 fecha registro
         AQPB624HREG, --27 hora registro
         AQPB624FSUP, --28 fecha supervision
         AQPB624HSUP, --29 hora supervision
         AQPB624OBS, --30 texto obsercacion 
         AQPB624USUR, --31 usuario de registro
         AQPB624RESR, --32 responsable de supervicion
         AQPB624FACT, --33 fecha actualizacion del evento
         AQPB624HACT, --34 hora actualizacion del evento
         AQPB624USUA) --35 usuario de actualizacion
      values
        (ln_corr, --1 correlativo
         pn_pgcod, --2 empresa
         pn_mod, --3 modulo
         pn_suc, --4 sucursal
         pn_mdn, --5 moneda
         pn_pap, --6 papel
         pn_cta, --7 cuenta
         pn_ope, --8 operación
         pn_sope, --9 suboperacion
         pn_tope, --10 tipo de operación         
         'A', --11 estado         
         pn_pais, --12 pais
         pn_tdoc, --13 tipo documento
         pv_ndoc, --14 numero documento
         pv_nomcli, --15 nombre cliente         
         pv_anasup, --16 analista de creditos supervisado
         pn_agesup, --17 agencia de supervision 
         lv_nomsuc, --18 nombre sucursal
         ln_CodZon, --19 zona
         lc_NomZon, --20 nombre zona
         ln_CodReg, --21 region
         lc_NomReg, --22 nombre region
         pv_tipeve, --23 Tipo de evento
         pv_codeve, --24 codigo evento
         lv_deseve, --25 descripcion evento         
         pd_fecreg, --26 fecha registro
         lv_hora, --27 hora registro         
         pd_fecsup, --28 fecha supervision
         lv_hora, --29 hora supervision
         pv_obs, --30 texto obsercacion 
         pv_usureg, --31 usuario de registro
         pv_ressup, --32 responsable de supervicion
         pd_fecact, --33 fecha actualizacion del evento
         lv_hora, --34 hora actualizacion del evento
         pd_usuact); --35 usuario de actualizacion
      commit;
      pv_flgconf := 'S';
    exception
      when others then
        pv_flgconf := 'N';
        my_errm    := SQLERRM;
    end;
  
  end sp_grabar_control;

  ------------------------------------------------------------------------------  
  procedure sp_eliminar_control(pn_cor     in number,
                                pn_pgcod   in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mdn     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sope    in number,
                                pn_tope    in number,
                                pd_fecact  in date,
                                pd_usuact  in varchar2,
                                pv_flgconf out varchar2) is
    my_errm varchar2(32000);
    lv_hora varchar2(15);
  begin
    lv_hora := to_char(sysdate, 'HH24:MI:SS');
  
    if pn_cor = 0 or pn_cor is null then
      pv_flgconf := 'N';
    else
      --desactivar
      begin
        update aqpb624 a
           set a.aqpb624est  = 'E',
               a.aqpb624fact = pd_fecact,
               a.aqpb624hact = lv_hora,
               a.aqpb624usua = pd_usuact
         where AQPB624COR = pn_cor
           and AQPB624PGCOD = pn_pgcod
           and AQPB624MOD = pn_mod
           and AQPB624SUC = pn_suc
           and AQPB624MND = pn_mdn
           and AQPB624PAP = pn_pap
           and AQPB624CTA = pn_cta
           and AQPB624OPE = pn_ope
           and AQPB624SOPE = pn_sope
           and AQPB624TOPE = pn_tope;
        commit;
        pv_flgconf := 'S';
      exception
        when others then
          pv_flgconf := 'N';
          my_errm    := SQLERRM;
      end;
    end if;
  
  end sp_eliminar_control;

  ------------------------------------------------------------------------------  
  procedure sp_update_control(pn_cor     in number,
                              pn_pgcod   in number,
                              pn_mod     in number,
                              pn_suc     in number,
                              pn_mdn     in number,
                              pn_pap     in number,
                              pn_cta     in number,
                              pn_ope     in number,
                              pn_sope    in number,
                              pn_tope    in number,
                              pn_agesup  in number,
                              pv_tipeve  in varchar2,
                              pv_codeve  in varchar2,
                              pd_fecsup  in date,
                              pv_obs     in varchar2,
                              pv_ressup  in varchar2,
                              pd_fecact  in date,
                              pd_usuact  in varchar2,
                              pv_flgconf out varchar2) is
    my_errm varchar2(32000);
    lv_hora varchar2(15);
  
    lv_nomsuc varchar2(30);
    ln_CodZon number(3);
    lc_NomZon char(40);
    ln_CodReg number(9);
    lc_NomReg char(30);
  
    lv_deseve char(50);
  
  begin
    --hora
    lv_hora := to_char(sysdate, 'HH24:MI:SS');
  
    --Descripcion evento
    begin
      select b.aqpb624ades
        into lv_deseve
        from aqpb624a b
       where b.aqpb624aest = 'S'
         and b.aqpb624atip = rpad(pv_tipeve, 20, ' ')
         and b.aqpb624acod = rpad(pv_codeve, 10, ' ');
    exception
      when others then
        my_errm := SQLERRM;
    end;
  
    --nombre sucursal
    begin
      select Scnom
        into lv_nomsuc
        from Fst001
       Where Pgcod = 1
         and Sucurs = pn_agesup;
    exception
      when others then
        my_errm := SQLERRM;
    end;
  
    --codigo zona
    begin
      SELECT RegCod
        into ln_CodZon
        FROM fst811
       Where Pgcod = 1
         AND OfiCod = pn_agesup
         AND RegCod < 100;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --nombre zona
    begin
      SELECT RegNom
        into lc_NomZon
        FROM Fst810
       Where Pgcod = 1
         AND RegCod = ln_CodZon
         AND RegCod < 100;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --codigo y nombre region
    begin
      SELECT Tp1nro1, Tp1desc
        into ln_CodReg, lc_NomReg
        FROM fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10872
         AND Tp1corr1 = 11
         AND Tp1nro2 = ln_CodZon;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --insert registro
    begin
      update aqpb624 a
         set a.AQPB624NOMS = lv_nomsuc,
             a.AQPB624ZON  = ln_CodZon,
             a.AQPB624NOMZ = lc_NomZon,
             a.AQPB624REG  = ln_CodReg,
             a.AQPB624NOMR = lc_NomReg,
             a.AQPB624AGES = pn_agesup,
             a.AQPB624TIPE = pv_tipeve,
             a.AQPB624CODE = pv_codeve,
             a.AQPB624DESE = lv_deseve,
             a.AQPB624FSUP = pd_fecsup,
             a.AQPB624HSUP = lv_hora,
             a.AQPB624OBS  = pv_obs,
             a.AQPB624RESR = pv_ressup,
             a.AQPB624FACT = pd_fecact,
             a.AQPB624HACT = lv_hora,
             a.AQPB624USUA = pd_usuact
       where a.AQPB624COR = pn_cor
         and AQPB624PGCOD = pn_pgcod
         and AQPB624MOD = pn_mod
         and AQPB624SUC = pn_suc
         and AQPB624MND = pn_mdn
         and AQPB624PAP = pn_pap
         and AQPB624CTA = pn_cta
         and AQPB624OPE = pn_ope
         and AQPB624SOPE = pn_sope
         and AQPB624TOPE = pn_tope;
      commit;
      pv_flgconf := 'S';
    exception
      when others then
        pv_flgconf := 'N';
        my_errm    := SQLERRM;
    end;
  
  end sp_update_control;

  ------------------------------------------------------------------------------  
  procedure sp_validar_eliminar(pv_analista in varchar,
                                pv_flg      out varchar2) is
    my_errm     varchar2(32000);
    lc_analista char(10);
  begin
    lc_analista := pv_analista;
    pv_flg      := 'N';
    begin
      SELECT 'S'
        into pv_flg
        FROM prfu00 T
       WHERE T.UBUSER = lc_analista
         AND T.PRFGCOD IN (select RPAD(f.tp1desc, 10, ' ')
                             from fst198 f
                            where f.tp1cod = 1
                              and f.tp1cod1 = 11162
                              and f.tp1corr1 = 1
                              and f.tp1corr2 = 0
                              and f.tp1corr3 > 0)
         and rownum = 1;
    exception
      when others then
        pv_flg  := 'N';
        my_errm := SQLERRM;
    end;
  
  end sp_validar_eliminar;

end PQ_CR_CTRL_SEGUI_RIESGO;
/

