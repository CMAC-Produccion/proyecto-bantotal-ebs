create or replace package PQ_CR_UPD_RATING is

  -- Author  : MPOSTIGOC
  -- Created : 13/03/2018 03:46:46 p.m.
  -- Purpose : 
  -- Fecha de Modificación      : 10/12/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se mdoifico el procedimiento sp_Cr_riesgoanalista2 
  -- Fecha de Modificación      : 23/01/2025
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: se agrego el procedimiento sp_cr_VerfEnSegui 
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------
  procedure sp_cr_UpdateRatingAnalista(lc_Analista         in varchar2,
                                       lc_Usuario          in varchar2,
                                       ln_RatingAntg       in varchar2,
                                       ln_RatingNuevo      in varchar2,
                                       ln_ProductAntig     in number,
                                       ln_ProductNueva     in number,
                                       lc_FlagUpdRantAnals out varchar2);
  ---------------------------------------------------------------------------------

  procedure sp_cr_VerRtngAntgAnalista(lc_Analista         in varchar2,
                                      lc_RatingAntg       out varchar2,
                                      ln_ProductAntig     out number,
                                      lc_FlgExistRtngAntg out varchar2);
  --------------------------------------------------------------------------------
  procedure sp_cr_riesgoanalista(pn_insta in numeric, pv_rpta out varchar2);
  ---------------------------------------------------------------------------------
  procedure sp_cr_seguim_aut(pn_insta in numeric, pv_rpta out varchar2);
  ---------------------------------------------------------------------------------
  procedure sp_cr_riesgoagencia2(pn_insta in numeric, pv_rpta out varchar2);
  ---------------------------------------------------------------------------------
  procedure sp_cr_riesgoanalista2(pn_insta in numeric,
                                  pv_rpta  out varchar2);
  -------------------------------------------------------------------
  procedure sp_cr_VerfEnSegui(ln_Instancia in number,
                              lv_EnSegui   out varchar2,
                              lv_User      out varchar2);
  ---------------------------------------------------------------------
  procedure sp_Cr_LogAQPB190(ln_inst in number,
                             lv_user in varchar2,
                             lv_ind  in varchar2);
  ---------------------------------------------------------------------------------

end PQ_CR_UPD_RATING;
/

create or replace package body PQ_CR_UPD_RATING is

  procedure sp_cr_UpdateRatingAnalista(lc_Analista         in varchar2,
                                       lc_Usuario          in varchar2,
                                       ln_RatingAntg       in varchar2,
                                       ln_RatingNuevo      in varchar2,
                                       ln_ProductAntig     in number,
                                       ln_ProductNueva     in number,
                                       lc_FlagUpdRantAnals out varchar2) is
  
    --lc_NewNivelRiesgoDesc varchar2(30);
    ln_newrating  number(3);
    ln_antrating  number(3);
    ln_ratingact  number(3);
    ld_Fec_actual date;
    --lc_hora               char(8);
    --ln_NuevaProduct number(10, 3);
    --lc_ratingAnt varchar2(30);
    lc_autAnt   char(1);
    lc_aut_bckp char(1);
    ln_maxcorr  number(10);
  
  begin
    begin
      select pgfape into ld_fec_actual from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tp1nro3
        into ln_newrating
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 350
         and f.tp1corr2 = 2
         and trim(upper(f.tp1desc)) = trim(upper(ln_RatingNuevo));
    exception
      when others then
        null;
    end;
    begin
      select f.tp1nro3
        into ln_antrating
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 350
         and f.tp1corr2 = 2
         and trim(upper(f.tp1desc)) = trim(upper(ln_RatingAntg));
    exception
      when others then
        null;
    end;
  
    begin
      select max(aqpc356corr) into ln_maxcorr from aqpc356;
    exception
      when others then
        ln_maxcorr := 0;
    end;
    ln_maxcorr := nvl(ln_maxcorr, 0);
    begin
      select t1.aqpc356codrat, t1.aqpc356aut
        into ln_ratingact, lc_autAnt
        from aqpc356 t1
       where t1.aqpc356pgcod = 1
         and t1.aqpc356analst = RPAD(lc_Analista, 10)
         and t1.aqpc356est = 'S';
    exception
      when no_data_found then
        ln_ratingact := 0;
        lc_autAnt    := 'N';
      when others then
        null;
    end;
    if ln_ratingact <> 0 then
      if ln_ratingact <> ln_newrating then
        if ln_newrating = 1 then
          begin
            select t2.sng057aut
              into lc_aut_bckp
              from sng057 t2
             where t2.sng055emp = 1
               and t2.sng057usr = rpad(lc_Analista, 10);
          exception
            when others then
              lc_aut_bckp := 'N';
          end;
          begin
            update sng057 ta
               set ta.sng057aut = 'N'
             where ta.sng055emp = 1
               and ta.sng057usr = rpad(lc_Analista, 10);
            commit;
          exception
            when others then
              null;
          end;
        end if;
        if ln_ratingact = 1 then
          begin
            update sng057 ta
               set ta.sng057aut = lc_autAnt
             where ta.sng055emp = 1
               and ta.sng057usr = rpad(lc_Analista, 10);
            commit;
          exception
            when others then
              null;
          end;
        end if;
        begin
          update aqpc356
             set aqpc356est    = 'N',
                 aqpc356useedi = rpad(lc_usuario, 10),
                 aqpc356fchedi = sysdate,
                 aqpc356horedi = to_char(sysdate, 'HH24:MI:SS')
           where aqpc356pgcod = 1
             and aqpc356analst = RPAD(lc_Analista, 10)
             and aqpc356est = 'S';
          commit;
        exception
          when others then
            null;
        end;
        begin
          insert into aqpc356
            (aqpc356corr,
             aqpc356pgcod,
             aqpc356analst,
             aqpc356codrat,
             aqpc356rating,
             aqpc356prccum,
             aqpc356usecre,
             aqpc356fchcre,
             aqpc356horcre,
             aqpc356useedi,
             aqpc356fchedi,
             aqpc356horedi,
             aqpc356est,
             aqpc356aut)
          values
            (ln_maxcorr + 1,
             1,
             rpad(lc_Analista, 10),
             ln_newrating,
             ln_RatingNuevo,
             0,
             rpad(lc_usuario, 10),
             sysdate,
             to_char(sysdate, 'HH24:MI:SS'),
             rpad(lc_usuario, 10),
             sysdate,
             to_char(sysdate, 'HH24:MI:SS'),
             'S',
             lc_aut_bckp);
          commit;
        exception
          when others then
            null;
        end;
      end if;
    else
      if ln_newrating = 1 then
        begin
          select t2.sng057aut
            into lc_aut_bckp
            from sng057 t2
           where t2.sng055emp = 1
             and t2.sng057usr = rpad(lc_Analista, 10);
        exception
          when others then
            lc_aut_bckp := 'N';
        end;
        begin
          update sng057 ta
             set ta.sng057aut = 'N'
           where ta.sng055emp = 1
             and ta.sng057usr = rpad(lc_Analista, 10);
          commit;
        exception
          when others then
            null;
        end;
      end if;
      begin
        insert into aqpc356
          (aqpc356corr,
           aqpc356pgcod,
           aqpc356analst,
           aqpc356codrat,
           aqpc356rating,
           aqpc356prccum,
           aqpc356usecre,
           aqpc356fchcre,
           aqpc356horcre,
           aqpc356useedi,
           aqpc356fchedi,
           aqpc356horedi,
           aqpc356est,
           aqpc356aut)
        values
          (ln_maxcorr + 1,
           1,
           rpad(lc_Analista, 10),
           ln_newrating,
           ln_RatingNuevo,
           0,
           rpad(lc_usuario, 10),
           sysdate,
           to_char(sysdate, 'HH24:MI:SS'),
           rpad(lc_usuario, 10),
           sysdate,
           to_char(sysdate, 'HH24:MI:SS'),
           'S',
           lc_aut_bckp);
        commit;
      exception
        when others then
          null;
      end;
    end if;
  
    begin
      select 'U'
        into lc_FlagUpdRantAnals
        from aqpc356 j
       where j.aqpc356pgcod = 1
         and j.aqpc356analst = RPAD(lc_Analista, 10)
         and j.aqpc356est = 'S'
         and j.aqpc356codrat = ln_newrating;
    exception
      when others then
        lc_FlagUpdRantAnals := 'N';
    end;
    if lc_FlagUpdRantAnals = 'U' then
      if ln_newrating = 1 then
        lc_FlagUpdRantAnals := 'V'; --para notificar que se actualizo a seguimiento
      end if;
    end if;
  
  end sp_cr_UpdateRatingAnalista;
  -----------------------------------------------------------------------------

  procedure sp_cr_VerRtngAntgAnalista(lc_Analista         in varchar2,
                                      lc_RatingAntg       out varchar2,
                                      ln_ProductAntig     out number,
                                      lc_FlgExistRtngAntg out varchar2) is
  
  begin
  
    begin
      select j.aqpc356rating, j.aqpc356prccum
        into lc_RatingAntg, ln_ProductAntig
        from aqpc356 j
       where j.aqpc356pgcod = 1
         and j.aqpc356analst = RPAD(lc_Analista, 10)
         and j.aqpc356est = 'S';
    exception
      when no_data_found then
        lc_RatingAntg   := null;
        ln_ProductAntig := 99999;
    end;
  
    if lc_RatingAntg is not null then
      lc_FlgExistRtngAntg := 'S';
    else
      lc_FlgExistRtngAntg := 'N';
    end if;
  
  end sp_cr_VerRtngAntgAnalista;
  ----------------------------------------------------------------------
  procedure sp_cr_riesgoanalista(pn_insta in numeric, pv_rpta out varchar2) is
    ln_analista char(10);
  begin
  
    pv_rpta := 'N';
    begin
      select sng001ase
        into ln_analista
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;
    begin
      select upper(TRIM(t7.AQPC356rating))
        into pv_rpta
        from AQPC356 t7
       where t7.AQPC356pgcod = 1
         and t7.AQPC356analst = ln_analista
         and t7.AQPC356est = 'S';
    exception
      when others then
        pv_rpta := '';
    end;
  
  end sp_cr_riesgoanalista;
  ------------------------------------------------------------------------
  procedure sp_cr_seguim_aut(pn_insta in numeric, pv_rpta out varchar2) is
    lc_analista char(10);
    lc_jefe     char(10);
    ln_cargo    number;
  begin
  
    pv_rpta := 'N';
    begin
      select sng001ase
        into lc_analista
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;
    ln_cargo := 200;
    begin
      while ln_cargo = 200 loop
        select t7.sng057jef, t7.sng055car
          into lc_jefe, ln_cargo
          from sng057 t7
         where t7.sng055emp = 1
           and t7.sng057usr = lc_analista;
        if lc_jefe = lc_analista then
          --06/02/2023 se agrego validacion para q no se genere bucle en el caso de que se asigne como su mismo jefe
          lc_jefe := '';
        end if;
        if lc_jefe = '' or lc_jefe = '          ' or lc_jefe is null then
          exit;
        end if;
        if ln_cargo = 200 then
          lc_analista := lc_jefe;
        end if;
      end loop;
    exception
      when others then
        null;
    end;
    pv_rpta := 'N';
    begin
      select 'S'
        into pv_rpta
        from AQPC356 t8
       where t8.AQPC356pgcod = 1
         and RPAD(t8.AQPC356analst, 10) = lc_analista
         and t8.AQPC356CODRAT = 1
         and t8.AQPC356est = 'S'
         and rownum = 1;
    exception
      when others then
        pv_rpta := 'N';
    end;
  
  end sp_cr_seguim_aut;
  /***    Tablas aqpb882 y aqpb883   */
  -----------------------------------------------------------------------------------
  procedure sp_cr_riesgoagencia2(pn_insta in numeric, pv_rpta out varchar2) is
    ln_suc numeric;
    --ln_nivel numeric;
    ld_maxfe date;
    lc_age   varchar2(30);
  begin
  
    pv_rpta := 'N';
    begin
      select t8.xwfsucursal
        into ln_suc
        from xwf700 t8
       where t8.xwfprcins = pn_insta
         and rownum <= 1;
    exception
      when others then
        null;
    end;
    begin
      select t8.scnom
        into lc_age
        from fst001 t8
       where t8.pgcod = 1
         and t8.sucurs = ln_suc;
    exception
      when others then
        lc_age := '';
    end;
    begin
      select max(aqpb882fec) into ld_maxfe from aqpb882 t9;
    exception
      when others then
        null;
    end;
    begin
      select case
               when t9.aqpb882rat like '%Bajo%' then
                'RB'
               when t9.aqpb882rat like '%Medio%' then
                'RM'
               when t9.aqpb882rat like '%Alto%' then
                'RA'
               when t9.aqpb882rat like '%Extremo%' then
                'RE'
               else
                ''
             end
        into pv_rpta
        from aqpb882 t9
       where t9.aqpb882fec = ld_maxfe
         and t9.aqpb882age = lc_age;
    exception
      when others then
        pv_rpta := '';
    end;
  
  end sp_cr_riesgoagencia2;
  ----------------------------------------------------------------------
  procedure sp_cr_riesgoanalista2(pn_insta in numeric,
                                  pv_rpta  out varchar2) is
    ln_analista varchar2(10);
    ld_maxfe    date;
    lc_rating   varchar2(14);
  begin
  
    pv_rpta := 'N';
  
    begin
      select sng001ase
        into ln_analista
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        ln_analista := '';
    end;
  
    begin
      select max(aqpb883fec) into ld_maxfe from aqpb883 t9;
    exception
      when others then
        null;
    end;
  
    ln_analista := trim(ln_analista);
  
    begin
      select UPPER(t9.aqpb883rat)
        into lc_rating
        from aqpb883 t9
       where t9.aqpb883fec = ld_maxfe
         and t9.aqpb883ana = ln_analista;
    exception
      when others then
        pv_rpta := '';
    end;
  
    if lc_rating like '%COACHEE%' then
      pv_rpta := 'COACHEE';
    else
      if lc_rating like '%COACH%' then
        pv_rpta := 'COACH';
      else
        if lc_rating like '%SEGUIMIENTO%' then
          pv_rpta := 'SEGUIMIENTO';
        else
          if lc_rating like '%TOP%' then
            pv_rpta := 'TOP';
          else
            pv_rpta := '';
          end if;
        end if;
      end if;
    end if;
  
  end sp_cr_riesgoanalista2;
  --------------------------------------------------------------------
  procedure sp_cr_VerfEnSegui(ln_Instancia in number,
                              lv_EnSegui   out varchar2,
                              lv_User      out varchar2) is
  
    cursor lista(ln_091Aut number) is
      select s.sng065usr from sng065 s where s.sng062aut = ln_091Aut;
  
    ln_091Aut   number;
    ln_EsSeguim number;
  
  begin
  
    lv_EnSegui := 'N';
  
    begin
      select n.sng091aut
        into ln_091Aut
        from sng091 n
       where n.sng001inst = ln_Instancia;
    exception
      when others then
        ln_091Aut := 0;
    end;
  
    for l in lista(ln_091Aut) loop
    
      begin
        select count(*)
          into ln_EsSeguim
          from AQPC356 t8
         where t8.AQPC356pgcod = 1
           and RPAD(t8.AQPC356analst, 10) = l.sng065usr
           and t8.AQPC356CODRAT = 1
           and t8.AQPC356est = 'S';
      exception
        when others then
          null;
      end;
    
      if ln_EsSeguim > 0 then
        lv_EnSegui := 'S';
        lv_User    := trim(l.sng065usr);
      
        Pq_Cr_Upd_Rating.sp_Cr_LogAQPB190(ln_inst => ln_Instancia,
                                          lv_user => lv_User,
                                          lv_ind  => lv_EnSegui);
      
        exit;
      end if;
    
    end loop;
  
  end sp_cr_VerfEnSegui;
  --------------------------------------------------------------------
  procedure sp_Cr_LogAQPB190(ln_inst in number,
                             lv_user in varchar2,
                             lv_ind  in varchar2) is
  
    ln_cor     number := 0;
    ld_FchSist date;
    lc_hora    varchar2(10) := '00:00:00';
  
  begin
  
    update aqpb190 a set a.aqpb190est = 'I' where a.aqpb190inst = ln_inst;
    commit;
  
    begin
      select max(a.aqpb190cor)
        into ln_cor
        from aqpb190 a
       where a.aqpb190inst = ln_inst;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb190
        (aqpb190cor,
         aqpb190fch,
         aqpb190hora,
         aqpb190inst,
         aqpb190user,
         aqpb190ind,
         aqpb190est)
      values
        (ln_cor + 1, ld_FchSist, lc_hora, ln_inst, lv_user, lv_ind, 'H');
      commit;
    end;
  end sp_Cr_LogAQPB190;
  --------------------------------------------------------------------
end PQ_CR_UPD_RATING;
/

