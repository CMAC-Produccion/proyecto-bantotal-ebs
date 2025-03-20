create or replace package PQ_CR_SEGM_MENS_MYPE22 is
  -- *****************************************************************
    -- Nombre                     : PQ_CR_SEGM_MENS_MYPE22
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/09/2022 04:20:32 p.m
    -- Autor de Creación          : RCASTRO
    -- Descripción de Modificación: 26/12/2024 MHUAMANIA Se añadió una nueva variable REL_CREDI_MAS_CDK
    --                            : 15/01/2025 MHUAMANIA Se incluyó el código credinka 
    -- *****************************************************************
  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
                              ln_CntInsRep  out number,
                              lc_fin_sobend out varchar2,
                              lc_castigado  out varchar2,
                              ln_CntAntRcc  out number);
  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number;
  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number;
  Procedure Sp_Resolutores_NS(pn_pai           in number,
                              pn_tdo           in number,
                              pc_ndo           in char,
                              pd_fecpro        in date,
                              ln_histCred      out number,
                              ln_promAtr       out number,
                              ln_segcod        out number,
                              lc_refinan       out char,
                              lc_tipHN         out char,
                              pn_cal           out number,
                              c_TipHist        out char, --mod@abr20170127
                              c_sdoTit         out char, --mod@abr 20181123
                              c_sdoCyg         out char, --mod@abr 20181123
                              n_segori         out number, --mod@abr 20181123
                              lc_premium_unico out char, --mod@abr 20180110
                              lc_premium       out char, --mod@abr 20180110
                              lc_preferencialA out char, --mod@abr 20180110
                              lc_preferencialb out char, --mod@abr 20180110
                              lc_preferencialC out char, --mod@abr 20180110
                              lc_Forjador      out char, --mod@abr 20180110
                              lc_Emprendedor   out char, --mod@abr 20180110
                              lc_PrefExclusivo out char, --mod@abr 20180110
                              lc_PreferenteA   out char, --mod@abr 20180110
                              lc_PreferenteB   out char, --mod@abr 20180110
                              lc_Recurrente    out char, --mod@abr 20180110
                              lc_Nuevo         out char, --mod@abr 20180110
                              ln_segmentac     out number --mod@abr 20201003
                              );
  procedure sp_job_carga(P_D_FECPRO IN DATE,
                         P_N_JOBS   IN NUMBER,
                         PC_USR     IN VARCHAR2);
  Procedure Sp_Carga_data(pd_fecpro  in date,
                          P_N_DIGITO in number,
                          pc_usr     in varchar2);

end PQ_CR_SEGM_MENS_MYPE22;
/

create or replace package body PQ_CR_SEGM_MENS_MYPE22 is
  -- *****************************************************************
    -- Nombre                     : PQ_CR_SEGM_MENS_MYPE22
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 13/09/2022 04:20:32 p.m
    -- Autor de Creación          : RCASTRO
    -- Descripción de Modificación: 26/12/2024 MHUAMANIA Se añadió una nueva variable REL_CREDI_MAS_CDK
    --                            : 15/01/2025 MHUAMANIA Se incluyó el código credinka 
    
    -- *****************************************************************
  Procedure Sp_cr_Resolutores(pn_pai        in number,
                              pn_tdo        in number,
                              pc_ndo        in char,
                              pd_fecpro     in date,
                              pn_cal        out number,
                              ln_CntInsRep  out number,
                              lc_fin_sobend out varchar2,
                              lc_castigado  out varchar2,
                              ln_CntAntRcc  out number) is
    DocSbs_Cyg   number(10);
    DocSbsCyg    char(1);
    DocSbs       number(10);
    DocSbsTit    char(1);
    lc_tiper_Cyg char(1);
  
    fecNum_rcc number(9);
    MesRcc     number(9);
    ln_Rpccyg  number(2);
    lc_tiper   char(1);
    fec_rcc    date;
    ln_paiC    number(3);
    ln_tdoC    number(2);
    lc_ndoC    char(12);
    --------------------
    ln_CntOpeRccTi number(10); --mod@abr 20201003
    ln_CntOpeRccCy number(10); --mod@abr 20201003
    -------------------
    lc_conyu      char(1);
    lc_tit_sobend char(1);
    lc_con_sobend char(1);
    ld_fecdob     date;
    ln_anio       number(4);
    ln_mes        number(2);
  
    ln_aux_pendoc VARCHAR2(12);
    ------------------
    ln_estaCan number(9);
    cursor cuentas is
      select a.ctnro
        from fsr008 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    ln_aoemp   number(3);
    ln_aomod   number(3);
    ln_aosuc   number(3);
    ln_aomda   number(4);
    ln_aopap   number(4);
    ln_aocta   number(9);
    ln_aooper  number(9);
    ln_aosbop  number(3);
    ln_aotope  number(3);
    ln_aostat  number(2);
    ld_fecrec  date;
    ln_r1mod   number(3);
    ln_r1suc   number(3);
    ln_r1mda   number(4);
    ln_r1pap   number(4);
    ln_r1cta   number(9);
    ln_r1oper  number(9);
    ln_r1sbop  number(3);
    ln_r1tope  number(3);
    ln_evento  number(10);
    ld_FechaRL date;
    ------------------------
    ln_lim       number(9);
    ln_ic        number(3);
    ld_fecantrcc date;
    lc_flgEx     char(1);
  
  begin
    --*******CALIFICACION_RCC********--------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
    if pd_fecpro = to_date('30.11.2015', 'dd.mm.RRRR') then
      fec_rcc := to_date('31.10.2015', 'dd.mm.RRRR');
    else
      if pd_fecpro = to_date('31.12.2015', 'dd.mm.RRRR') then
        fec_rcc := to_date('30.11.2015', 'dd.mm.RRRR');
      else
        if pd_fecpro = to_date('31.01.2016', 'dd.mm.RRRR') then
          fec_rcc := to_date('31.12.2015', 'dd.mm.RRRR');
        else
          begin
            select tpnro
              into fecNum_rcc
              from fst098
             where pgcod = 1
               and tpcod = 7647
               and tpcorr = 12;
          exception
            when no_data_found then
              fecNum_rcc := null;
          end;
          fec_rcc := to_date(fecNum_rcc, 'dd/mm/RRRR');
        end if;
      end if;
    end if;
  
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
    end;
    --vinculo conyugue
    begin
      select a.tp1corr3
        into ln_Rpccyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 1;
    exception
      when no_data_found then
        ln_Rpccyg := null;
    end;
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    pn_cal := 100.00;
  
    pn_cal := PQ_CR_SEGM_MENS_MYPE22.Fn_calificacion_RCC(DocSbsTit,
                                                         pc_ndo,
                                                         fec_rcc,
                                                         MesRcc,
                                                         lc_tiper);
  
    --evalua conyugue si la calificacion es normal para el titular
  
    begin
      select a.rppais, a.rptdoc, a.rpndoc
        into ln_paiC, ln_tdoC, lc_ndoC
        from fsr002 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.rpccyg = ln_Rpccyg
         and rownum = 1;
    exception
      when no_data_found then
        ln_paiC := null;
        ln_tdoC := null;
        lc_ndoC := null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs_Cyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdoC;
    exception
      when no_data_found then
        DocSbs_Cyg := null;
    end;
    DocSbsCyg := Trim(to_char(DocSbs_Cyg));
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper_Cyg
        from fsd001 a
       where a.pepais = ln_paiC
         and a.petdoc = ln_tdoC
         and a.pendoc = lc_ndoC;
    exception
      when no_data_found then
        lc_tiper_Cyg := null;
    end;
  
    if pn_cal = 100.00 and lc_ndoC is not null then
      if lc_ndoC is null then
        insert into jaqz082_aux
          (jaqz082ndo, JAQZ082TPO)
        values
          (pc_ndo, 'CYG');
        commit;
      end if;
    
      pn_cal := PQ_CR_SEGM_MENS_MYPE22.Fn_calificacion_RCC(DocSbsCyg,
                                                           lc_ndoC,
                                                           fec_rcc,
                                                           MesRcc,
                                                           lc_tiper_Cyg);
    
    end if;
  
    --***************CANT_ENTIDADES**********----
    ln_CntOpeRccTi := 0;
    ln_CntOpeRccCy := 0; --mod@abr 20180116
    ln_CntInsRep   := 0; --mod@abr 20180116
  
    ln_CntOpeRccTi := PQ_CR_SEGM_MENS_MYPE22.Fn_cant_instit(DocSbsTit, --mod@abr 20180116
                                                            pc_ndo, --mod@abr 20180116
                                                            fec_rcc, --mod@abr 20180116
                                                            lc_tiper); --mod@abr 20180116
  
    if lc_ndoC is not null then
      --mod@abr 20180116
      ln_CntOpeRccCy := PQ_CR_SEGM_MENS_MYPE22.Fn_cant_instit(DocSbsCyg, --mod@abr 20180116
                                                              lc_ndoC, --mod@abr 20180116
                                                              fec_rcc, --mod@abr 20180116
                                                              lc_tiper_Cyg); --mod@abr 20180116
    end if; --mod@abr 20180116                                
  
    ln_CntInsRep := ln_CntOpeRccTi + ln_CntOpeRccCy; --mod@abr 20180116
  
    --MOD@ABR 20201003
    --pq_cr_deurcc.sp_cr_rcc(pn_pai, pn_tdo, pc_ndo, ln_CntInsRep); --mod@abr 20180116
  
    --*******SOBREENDEUDAMIENTO******-----
    lc_tit_sobend := 'N';
    lc_con_sobend := 'N';
    lc_fin_sobend := 'N';
  
    --determinar fecha de proceso
    ld_fecdob := add_months(pd_fecpro, -1);
    ln_anio   := to_number(to_char(ld_fecdob, 'yyyy'));
    ln_mes    := to_number(to_char(ld_fecdob, 'mm'));
    --guia si se debe incluir al conyugue
    begin
      select trim(a.tp1desc)
        into lc_conyu
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and a.tp1corr1 = 1
         and a.tp1corr2 = 5;
    exception
      when no_data_found then
        lc_conyu := null;
    end;
    begin
      select jaql157sob
        into lc_tit_sobend
        from JAQL157
       Where jaql157pai = pn_pai
         and jaql157tdo = pn_tdo
         and jaql157ndo = pc_ndo
         and jaql157ani = ln_anio
         and jaql157mes = ln_mes;
    exception
      when no_data_found then
        lc_tit_sobend := null;
    end;
    ---analisis conyugue
    if lc_conyu = 'S' then
      begin
        select a.rppais, a.rptdoc, a.rpndoc
          into ln_paiC, ln_tdoC, lc_ndoC
          from fsr002 a
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.rpccyg = ln_Rpccyg
           and rownum = 1;
      exception
        when no_data_found then
          ln_paiC := null;
          ln_tdoC := null;
          lc_ndoC := null;
      end;
    
      begin
        select jaql157sob
          into lc_con_sobend
          from JAQL157
         Where jaql157pai = ln_paiC
           and jaql157tdo = ln_tdoC
           and jaql157ndo = lc_ndoC
           and jaql157ani = ln_anio
           and jaql157mes = ln_mes;
      exception
        when no_data_found then
          lc_con_sobend := null;
      end;
    
    end if;
  
    If lc_tit_sobend = 'S' or lc_con_sobend = 'S' then
      lc_fin_sobend := 'S';
    Else
      If lc_tit_sobend = 'E' or lc_con_sobend = 'E' then
        lc_fin_sobend := 'E';
      Else
        lc_fin_sobend := 'N';
      End If;
    End IF;
  
    ----*******CASTIGADOS*****----------
    lc_castigado := 'N';
    ld_FechaRL   := null;
    --Estado credito castigado
    begin
      select a.tp1nro1
        into ln_estaCan
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 2
         and tp1corr3 = 1;
    exception
      when no_data_found then
        ln_estaCan := null;
    end;
  
    begin
      for i in cuentas loop
        begin
          select a.pgcod,
                 a.aomod,
                 a.aosuc,
                 a.aomda,
                 a.aopap,
                 a.aocta,
                 a.aooper,
                 a.aosbop,
                 a.aotope,
                 a.aostat,
                 'S'
            into ln_aoemp,
                 ln_aomod,
                 ln_aosuc,
                 ln_aomda,
                 ln_aopap,
                 ln_aocta,
                 ln_aooper,
                 ln_aosbop,
                 ln_aotope,
                 ln_aostat,
                 lc_castigado
            from fsd010 a
           where a.pgcod = 1
             and a.aocta = i.ctnro
             and (a.aomod in (select modulo from fst111 b where dscod = 50) or
                 aomod = 117)
             and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
             and a.aofval <= pd_fecpro
             and aostat = ln_estaCan
             and rownum = 1;
        exception
          when no_data_found then
            ln_aoemp     := null;
            ln_aomod     := null;
            ln_aosuc     := null;
            ln_aomda     := null;
            ln_aopap     := null;
            ln_aocta     := null;
            ln_aooper    := null;
            ln_aosbop    := null;
            ln_aotope    := null;
            ln_aostat    := null;
            lc_castigado := 'N';
          
        end;
      
        if lc_castigado = 'S' then
          begin
            select a.r1mod,
                   a.r1suc,
                   a.r1mda,
                   a.r1pap,
                   a.r1cta,
                   a.r1oper,
                   a.r1sbop,
                   a.r1tope
              into ln_r1mod,
                   ln_r1suc,
                   ln_r1mda,
                   ln_r1pap,
                   ln_r1cta,
                   ln_r1oper,
                   ln_r1sbop,
                   ln_r1tope
              from fsr011 a
             where a.r2cod = ln_aoemp
               and a.r2mod = ln_aomod
               and a.r2suc = ln_aosuc
               and a.r2mda = ln_aomda
               and a.r2pap = ln_aopap
               and a.r2cta = ln_aocta
               and a.r2oper = ln_aooper
               and a.r2sbop = ln_aosbop
               and a.r2tope = ln_aotope
               and a.relcod = 52;
          exception
            when no_data_found then
              ln_r1mod  := null;
              ln_r1suc  := null;
              ln_r1mda  := null;
              ln_r1pap  := null;
              ln_r1cta  := null;
              ln_r1oper := null;
              ln_r1sbop := null;
              ln_r1tope := null;
          end;
        end if;
      
        if ln_r1oper is null then
          ln_r1mod  := ln_aomod;
          ln_r1suc  := ln_aosuc;
          ln_r1mda  := ln_aomda;
          ln_r1pap  := ln_aopap;
          ln_r1cta  := ln_aocta;
          ln_r1oper := ln_aooper;
          ln_r1sbop := ln_aosbop;
          ln_r1tope := ln_aotope;
        end if;
        ln_evento := 1100;
        while ln_evento <= 1101 loop
          begin
            select max(SNG410FecG)
              into ld_fecrec
              from sng410 a
             Where SNG400Cod = 1
               and SNG400Evto = ln_evento
               and SNG410Mod = ln_r1mod
               and SNG410Top = ln_r1tope
               and SNG410Cta = ln_r1cta
               and SNG410Suc = ln_r1suc
               and SNG410Mda = ln_r1mda
               and SNG410Pap = ln_r1pap
               and SNG410Op = ln_r1oper
               and SNG410Sbop = ln_r1sbop
               and SNG410Its <> 999;
          exception
            when no_data_found then
              ld_fecrec := null;
          end;
        
          ln_evento := ln_evento + 1;
        end loop;
        If ld_fecrec > ld_FechaRL then
          ld_FechaRL := ld_fecrec;
        End If;
      
      end loop;
    
      if lc_castigado = 'N' then
        begin
          select 'S'
            into lc_castigado
            from jaqy164 a
           where a.jaqy164pais = pn_pai
             and a.jaqy164tdoc = pn_tdo
             and a.jaqy164ndoc = pc_ndo
             and rownum = 1;
        exception
          when no_data_found then
            lc_castigado := 'N';
        end;
      end if;
      --Validacion si ha tenido créditos después
      if lc_castigado = 'S' then
        for j in cuentas loop
          if ld_FechaRL is not null then
            begin
              select 'N'
                into lc_castigado
                from fsd010 a
               where a.pgcod = 1
                 and a.aocta = j.ctnro
                 and (a.aomod in
                     (select modulo from fst111 where dscod = 50) or
                     aomod = 117)
                 and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
                 and a.aofval <= pd_fecpro
                 and aofval > ld_FechaRL
                 and rownum = 1;
            exception
              when no_data_found then
                lc_castigado := 'S';
            end;
          
          else
          
            begin
              select 'N'
                into lc_castigado
                from fsd010 a
               where a.pgcod = 1
                 and a.aocta = j.ctnro
                 and (a.aomod in
                     (select modulo from fst111 where dscod = 50) or
                     aomod = 117)
                 and a.aomod not in (33, 108, 120, 142, 200, 144, 29)
                 and a.aofval <= pd_fecpro
                 and aofval >= to_date('01/07/2013', 'dd/mm/yyyy')
                 and rownum = 1;
            exception
              when no_data_found then
                lc_castigado := 'S';
            end;
          
          end if;
          If lc_castigado = 'N' then
            Exit;
          End If;
        end loop;
      end if;
    
    end;
  
    --********ANTIGUEDAD RCC********---------
    ln_CntAntRcc  := 0;
    ln_ic         := 0;
    ln_aux_pendoc := trim(pc_ndo);
  
    pQ_CR_SEGMENTACION_PYME_NUEVO.sp_cr_antiguedad_pyme(pn_pai,
                                                        pn_tdo,
                                                        ln_aux_pendoc, --pc_ndo,
                                                        ln_CntAntRcc);
  
    /*   --limite antiguedad rcc
     begin
       select tp1nro1
         into ln_lim
         from fst198 a
        where a.tp1cod = 1
          and Tp1cod1 = 10854
          and Tp1corr1 = 2
          and Tp1corr2 = 1
          and tp1corr3 = 2;
     exception
       when no_data_found then
         ln_lim := null;
     end;
     --fecha rcc
     if pd_fecpro = to_date('30.11.2015', 'dd.mm.RRRR') then
       ld_fecantrcc := to_date('31.10.2015', 'dd.mm.RRRR');
     else
       if pd_fecpro = to_date('31.12.2015', 'dd.mm.RRRR') then
         ld_fecantrcc := to_date('30.11.2015', 'dd.mm.RRRR');
       else
         if pd_fecpro = to_date('31.01.2016', 'dd.mm.RRRR') then
           ld_fecantrcc := to_date('31.12.2015', 'dd.mm.RRRR');
         else
           begin
             select to_date(tpnro, 'dd/mm/RRRR')
               into ld_fecantrcc
               from fst098
              where pgcod = 1
                and tpcod = 7647
                and tpcorr = 12;
           exception
             when no_data_found then
               ld_fecantrcc := null;
           end;
         end if;
       end if;
     end if;
    
     while ln_ic <= ln_lim loop
       case
         when lc_tiper = 'F' then
           begin
             select 'S'
               into lc_flgEx
               from CLDRCCI
              Where D_FECPRE = ld_fecantrcc
                and C_TDOCID = DocSbsTit
                and C_DOCIDE = trim(pc_ndo)
                and rownum = 1;
           exception
             when no_data_found then
               lc_flgEx := 'N';
           end;
           if lc_flgEx = 'S' then
             ln_CntAntRcc := ln_CntAntRcc + 1;
           end if;
         when lc_tiper = 'J' then
           begin
             select 'S'
               into lc_flgEx
               from CLDRCCI
              Where D_FECPRE = ld_fecantrcc
                and C_TDOCTR = DocSbsTit
                and C_DOCTRI = trim(pc_ndo)
                and rownum = 1;
           exception
             when no_data_found then
               lc_flgEx := 'N';
           end;
           if lc_flgEx = 'S' then
             ln_CntAntRcc := ln_CntAntRcc + 1;
           end if;
         else
           begin
             select 'S'
               into lc_flgEx
               from CLDRCCI
              Where D_FECPRE = ld_fecantrcc
                and C_DOCIDE = trim(pc_ndo)
                and rownum = 1;
           exception
             when no_data_found then
               lc_flgEx := 'N';
           end;
           if lc_flgEx = 'S' then
             ln_CntAntRcc := ln_CntAntRcc + 1;
           end if;
         
           if lc_flgEx = 'N' then
             begin
               select 'S'
                 into lc_flgEx
                 from CLDRCCI
                Where D_FECPRE = ld_fecantrcc
                  and C_DOCTRI = trim(pc_ndo)
                  and rownum = 1;
             exception
               when no_data_found then
                 lc_flgEx := 'N';
             end;
             if lc_flgEx = 'S' then
               ln_CntAntRcc := ln_CntAntRcc + 1;
             end if;
           end if;
         
       end case;
       ld_fecantrcc := last_day(add_months(ld_fecantrcc, -1));
       ln_ic        := ln_ic + 1;
     
     end loop;
    */
  end Sp_cr_Resolutores;

  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number is
    ln_i         number(5);
    CodSbs       char(10);
    LN_CALIF0    number(5, 2);
    LN_CALIF1    number(5, 2);
    LN_CALIF2    number(5, 2);
    LN_CALIF3    number(5, 2);
    LN_CALIF4    number(5, 2);
    pn_cal       number(10, 5);
    pd_fecRccTmp date;
  
  begin
  
    if pc_ndo_FN is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo_FN, 'ANTES');
      commit;
    end if;
  
    if lc_tiper_FN is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo_FN, 'lc_tiper');
      commit;
    end if;
  
    pd_fecRccTmp := pd_fecRcc;
    pn_cal       := 100.00;
    ln_i         := 1;
    begin
      while ln_i <= MesRcc loop
        case
          when lc_tiper_FN = 'F' then
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_TDOCID = TipDocSbs
                 and C_DOCIDE = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
          
            If LN_CALIF0 = 100.00 or CodSbs is null then
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          when lc_tiper_FN = 'J' then
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_TDOCTR = TipDocSbs
                 and C_DOCTRI = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
            If LN_CALIF0 = 100.00 or CodSbs is null then
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          else
            begin
              select c_CodSbs,
                     N_CALIF0,
                     N_CALIF1,
                     N_CALIF2,
                     N_CALIF3,
                     N_CALIF4
                into CodSbs,
                     LN_CALIF0,
                     LN_CALIF1,
                     LN_CALIF2,
                     LN_CALIF3,
                     LN_CALIF4
                from cldrcci a
               where D_FECPRE = pd_fecRccTmp
                 and C_DOCIDE = trim(pc_ndo_FN)
                 and rownum = 1;
            exception
              when no_data_found then
                CodSbs    := null;
                LN_CALIF0 := null;
                LN_CALIF1 := null;
                LN_CALIF2 := null;
                LN_CALIF3 := null;
                LN_CALIF4 := null;
            end;
          
            If LN_CALIF0 = 100.00 or CodSbs is null then
              pn_cal := 100.00;
            Else
              If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 + LN_CALIF4 = 0) then
                pn_cal := 100.00;
              Else
                pn_cal := 0.00;
                Exit;
              End If;
            End If;
          
            if CodSbs is null then
              begin
                select c_CodSbs,
                       N_CALIF0,
                       N_CALIF1,
                       N_CALIF2,
                       N_CALIF3,
                       N_CALIF4
                  into CodSbs,
                       LN_CALIF0,
                       LN_CALIF1,
                       LN_CALIF2,
                       LN_CALIF3,
                       LN_CALIF4
                  from cldrcci a
                 where D_FECPRE = pd_fecRccTmp
                   and C_DOCTRI = trim(pc_ndo_FN)
                   and rownum = 1;
              exception
                when no_data_found then
                  CodSbs    := null;
                  LN_CALIF0 := null;
                  LN_CALIF1 := null;
                  LN_CALIF2 := null;
                  LN_CALIF3 := null;
                  LN_CALIF4 := null;
              end;
              If LN_CALIF0 = 100.00 or CodSbs is null then
                pn_cal := 100.00;
              Else
                If (LN_CALIF0 + LN_CALIF1 + LN_CALIF2 + LN_CALIF3 +
                   LN_CALIF4 = 0) then
                  pn_cal := 100.00;
                Else
                  pn_cal := 0.00;
                  Exit;
                End If;
              End If;
            end if;
          
        end case;
        if pn_cal = 0.00 then
          Exit;
        end if;
        ln_i         := ln_i + 1;
        pd_fecRccTmp := Add_months(pd_fecRccTmp, -1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
      end loop;
    end;
    return pn_cal;
  end Fn_calificacion_RCC;

  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number is
  -- 15/01/2025 MHUAMANIA Se incluyó el código credinka 
  
    ln_NumEnt number(10);
    lc_CodSbs char(10);
  
    cursor entidades(lc_CodSbs in char) is
      select distinct C_CODEMP
        from CLDRCCS
       Where C_CODSBS = lc_CodSbs
        -- and C_CODEMP <> '00104'
         and (C_CODEMP <> '00104' and C_CODEMP <> '00230') --mhuamani 19/12/2024 se incluye codigo credinka
         and (C_CUENTA like '14_1%' Or C_CUENTA like '14_2%' Or
             C_CUENTA like '14_3%' Or C_CUENTA like '14_4%' Or
             C_CUENTA like '14_5%' Or C_CUENTA like '14_6%' Or
             C_CUENTA like '71_1%' Or C_CUENTA like '71_2%' Or
             C_CUENTA like '71_3%' Or C_CUENTA like '71_4%' Or
             C_CUENTA like '81_302%')
         and D_FECPRE = pd_fecRcc
         and C_CRETIP not in (select tp1nro1
                                from fst198 a
                               Where Tp1cod = 1
                                 and Tp1cod1 = 20001
                                 and Tp1corr1 = 1
                                 and Tp1corr2 = 1205);
  
  begin
    ln_NumEnt := 0;
    begin
      case
        when lc_tiper = 'F' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCID = TipDocSbs
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        when lc_tiper = 'J' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCTR = TipDocSbs
               and C_DOCTRI = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        else
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
          if lc_CodSbs is null then
            begin
              select C_CODSBS
                into lc_CodSbs
                from CLDRCCI
               Where D_FECPRE = pd_fecRcc
                 and C_DOCTRI = trim(pc_ndo)
                 and rownum = 1;
            exception
              when no_data_found then
                lc_CodSbs := NULL;
            end;
          end if;
        
      end case;
    
      begin
        for i in entidades(lc_CodSbs) loop
          ln_NumEnt := ln_NumEnt + 1;
        
        end loop;
      End;
    
    end;
    return ln_NumEnt;
  
  end Fn_cant_instit;

  Procedure Sp_Resolutores_NS(pn_pai           in number,
                              pn_tdo           in number,
                              pc_ndo           in char,
                              pd_fecpro        in date,
                              ln_histCred      out number,
                              ln_promAtr       out number,
                              ln_segcod        out number,
                              lc_refinan       out char,
                              lc_tipHN         out char,
                              pn_cal           out number,
                              c_TipHist        out char, --mod@abr20170127
                              c_sdoTit         out char, --mod@abr 20181123
                              c_sdoCyg         out char, --mod@abr 20181123
                              n_segori         out number, --mod@abr 20181123
                              lc_premium_unico out char, --mod@abr 20180110
                              lc_premium       out char, --mod@abr 20180110
                              lc_preferencialA out char, --mod@abr 20180110
                              lc_preferencialb out char, --mod@abr 20180110
                              lc_preferencialC out char, --mod@abr 20180110
                              lc_Forjador      out char, --mod@abr 20180110
                              lc_Emprendedor   out char, --mod@abr 20180110
                              lc_PrefExclusivo out char, --mod@abr 20180110
                              lc_PreferenteA   out char, --mod@abr 20180110
                              lc_PreferenteB   out char, --mod@abr 20180110
                              lc_Recurrente    out char, --mod@abr 20180110
                              lc_Nuevo         out char, --mod@abr 20180110
                              ln_segmentac     out number --mod@abr 20201003
                              ) is
  
    ln_hist     number(5);
    ln_estado   number(2);
    ld_fect     date;
    lc_existe   char(1);
    ld_fecrel   date;
    ld_fecvac   date;
    ld_fectmp   date;
    ln_contador number(5);
  
    DocSbs    number(10);
    DocSbsTit char(1);
  
    DocSbs_Cyg number(10);
    DocSbsCyg  char(1);
  
    lc_tiper     char(1);
    lc_tiper_Cyg char(1);
  
    fecNum_rcc number(9);
    MesRcc     number(9);
    ln_Rpccyg  number(2);
  
    fec_rcc date;
    ln_paiC number(3);
    ln_tdoC number(2);
    lc_ndoC char(12);
  
    ln_moraFebrero number(18, 2); --mod@abr 20201003
    ln_moraReal    number(18, 2); --mod@abr 20201003
  
  begin
  
    --******RELACION CREDITICIA*****--------
    /*ld_fecvac := to_date('01010001', 'ddmmyyyy');
    lc_existe := 'N';
    ld_fectmp := to_date(to_number(to_char(to_char(add_months(pd_fecpro,
                                                              -12),
                                                   'yyyy') ||
                                           to_char(add_months(pd_fecpro,
                                                              -12),
                                                   'mm') || '01')),
                         'yyyymmdd'); RC */
    --verifica fecha de proceso de relacion crediticia
  
    /* if pd_fecpro = to_date('30.11.2015', 'dd.mm.RRRR') then
      ld_fecrel := to_date('31.10.2015', 'dd.mm.RRRR');
    else
      if pd_fecpro = to_date('31.12.2015', 'dd.mm.RRRR') then
        ld_fecrel := to_date('30.11.2015', 'dd.mm.RRRR');
      else
        if pd_fecpro = to_date('31.01.2016', 'dd.mm.RRRR') then
          ld_fecrel := to_date('31.12.2015', 'dd.mm.RRRR');
        else
          begin
            select to_date(tp1nro1, 'ddmmyyyy')
              into ld_fecrel
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10823
               and a.tp1corr1 = 8;
          exception
            when no_data_found then
              ld_fecrel := null;
          end;
        end if;
      end if;
    end if;*/
    --verifica si existe en la tabla de relacion crediticia
    lc_existe := 'N';
    begin
      select a.JAQZ076HIS, 'S'
        into ln_hist, lc_existe --, ln_estado, ld_fect,
        from JAQZ076 a
       where a.JAQZ076PAI = pn_pai
         and a.JAQZ076TDO = pn_tdo
         and a.JAQZ076NDO = pc_ndo
         and a.JAQZ076EST = 'S';
    exception
      when no_data_found then
        ln_hist   := null;
        lc_existe := 'N';
    end;
  
    /*begin
      select a.jaqz074his, a.jaqz074est, a.jaqz074fec, 'S'
        into ln_hist, ln_estado, ld_fect, lc_existe
        from jaqz074 a
       where a.jaqz074pai = pn_pai
         and a.jaqz074tdo = pn_tdo
         and a.jaqz074ndo = pc_ndo
         and a.jaqz074fep = ld_fecrel;
    exception
      when no_data_found then
        ln_hist   := null;
        ln_estado := null;
        ld_fect   := null;
        lc_existe := 'N';
      
    end;*/
    ln_histCred := 0;
    if lc_existe = 'S' then
      ln_histCred := ln_hist;
    else
      BEGIN
        pq_cr_relcrediticia_a.sp_cr_recalcula(pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              pd_fecpro,
                                              ln_histCred);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    end if;
    IF ln_histCred IS NULL THEN
      ln_histCred := 0;
    END IF;
  
    ---*******DIAS DE ATRASO******------
    ln_promAtr := 0;
    /*pq_cr_relcrediticia.sp_diaatraso_linea(pn_pai,
    pn_tdo,
    pc_ndo,
    pd_fecpro,
    ln_moraReal); RC*/
    BEGIN
      PQ_CR_RELCREDITICIA_NUEVO.sp_diaatraso_linea(pn_pai,
                                                   pn_tdo,
                                                   pc_ndo,
                                                   pd_fecpro,
                                                   ln_moraReal);
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --mod@abr 20201003
    BEGIN
      pq_cr_segmentacion_CVD.sp_cr_segmentacion_HIS(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    ln_segmentac,
                                                    ln_moraFebrero);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    /*if ln_moraFebrero < ln_moraReal then --yyampi 31/12/2021
    
      ln_promAtr := ln_moraFebrero; --yyampi 31/12/2021
    
    else*/ --yyampi 31/12/2021
    ln_promAtr := ln_moraReal;
    --end if; --yyampi 31/12/2021
  
    --********SEGMENTO**********------
  
    begin
      select b.segcod
        into ln_segcod
        from sngc60 a, sngc07 b
       where a.sngc60pais = pn_pai
         and a.sngc60tdoc = pn_tdo
         and a.sngc60ndoc = pc_ndo
         and a.sngc60ocup = sngc07cod
         and rownum = 1;
    exception
      when no_data_found then
        ln_segcod := null;
    end;
  
    --******REFINANCIADO*******------
    begin
      select 'S'
        into lc_refinan
        from fsr008 a, fsd010 b
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and b.pgcod = 1
         and b.aocta = a.ctnro
         and b.aostat in (61, 33, 34)
         and aofval <= pd_fecpro
         and rownum = 1;
    exception
      when no_data_found then
        lc_refinan := 'N';
    end;
  
    --******HISTORIAL NUEVO RECURRENTE*****-----
    BEGIN
      pq_cr_relcrediticia.Sp_RelCredi_NR(pn_pai,
                                         pn_tdo,
                                         pc_ndo,
                                         pd_fecpro,
                                         ln_contador);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    if ln_contador > 18 then
      lc_tipHN := 'A';
    else
      if ln_contador <= 18 and ln_contador >= 6 then
        lc_tipHN := 'B';
      else
        if ln_contador < 6 then
          lc_tipHN := 'C';
        end if;
      end if;
    end if;
  
    --*******CALIFICACION RCC 2 ****--------------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
  
    if pd_fecpro = to_date('30.11.2015', 'dd.mm.RRRR') then
      fec_rcc := to_date('31.10.2015', 'dd.mm.RRRR');
    else
      if pd_fecpro = to_date('31.12.2015', 'dd.mm.RRRR') then
        fec_rcc := to_date('30.11.2015', 'dd.mm.RRRR');
      else
        if pd_fecpro = to_date('31.01.2016', 'dd.mm.RRRR') then
          fec_rcc := to_date('31.12.2015', 'dd.mm.RRRR');
        else
        
          begin
            select tpnro
              into fecNum_rcc
              from fst098
             where pgcod = 1
               and tpcod = 7647
               and tpcorr = 12;
          exception
            when no_data_found then
              fecNum_rcc := null;
          end;
          fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
        end if;
      end if;
    end if;
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7702
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
    end;
    --vinculo conyugue
    begin
      select a.tp1corr3
        into ln_Rpccyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10823
         and Tp1corr1 = 3
         and Tp1corr2 = 1;
    exception
      when no_data_found then
        ln_Rpccyg := null;
    end;
    --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    pn_cal := 100.00;
    if pc_ndo is null then
      insert into jaqz082_aux
        (jaqz082ndo, JAQZ082TPO)
      values
        (pc_ndo, 'TIT2');
      commit;
    end if;
    BEGIN
      pn_cal := PQ_CR_SEGM_MENS_MYPE22.Fn_calificacion_RCC(DocSbsTit,
                                                           pc_ndo,
                                                           fec_rcc,
                                                           MesRcc,
                                                           lc_tiper);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --evalua conyugue si la calificacion es normal para el titular
  
    if pn_cal = 100.00 then
      begin
        select a.rppais, a.rptdoc, a.rpndoc
          into ln_paiC, ln_tdoC, lc_ndoC
          from fsr002 a
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.rpccyg = ln_Rpccyg
           and rownum = 1;
      exception
        when no_data_found then
          ln_paiC := null;
          ln_tdoC := null;
          lc_ndoC := null;
      end;
    
      --Guia equivalencia tipo de documento
      begin
        select a.tp1corr3
          into DocSbs_Cyg
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 11111
           and a.tp1corr1 = 1
           and a.tp1corr2 = 3
           and tp1nro1 = ln_tdoC;
      exception
        when no_data_found then
          DocSbs_Cyg := null;
      end;
      DocSbsCyg := Trim(to_char(DocSbs_Cyg));
    
      --tipo de persona
      begin
        select a.petipo
          into lc_tiper_Cyg
          from fsd001 a
         where a.pepais = ln_paiC
           and a.petdoc = ln_tdoC
           and a.pendoc = lc_ndoC;
      exception
        when no_data_found then
          lc_tiper_Cyg := null;
      end;
      if pc_ndo is null then
        insert into jaqz082_aux
          (jaqz082ndo, JAQZ082TPO)
        values
          (lc_ndoC, 'CYG');
        commit;
      end if;
      If lc_ndoC is not null then
        BEGIN
          pn_cal := PQ_CR_SEGM_MENS_MYPE22.Fn_calificacion_RCC(DocSbsCyg,
                                                               lc_ndoC,
                                                               fec_rcc,
                                                               MesRcc,
                                                               lc_tiper_Cyg);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      end if;
    end if;
  
    --Mod @abr 20170127
  
    begin
      pq_cr_relcrediticia.Sp_Obtiene_HistPyme(pn_pai,
                                              pn_tdo,
                                              pc_ndo,
                                              c_TipHist);
    exception
      when others then
        null;
    end;
    -- fin Mod @abr 20170127  
  
    --Mod @abr 20181123
  
    begin
      pq_cr_segmentacion_variable.sp_cr_saldo3(pn_pai    => pn_pai,
                                               pn_tdo    => pn_tdo,
                                               pc_ndo    => pc_ndo,
                                               pc_flgTit => c_sdoTit,
                                               pc_flgCyg => c_sdoCyg);
    
    exception
      when others then
        null;
    end;
    -- fin Mod @abr 20181123   
  
    --Mod @abr 20181123
  
    begin
      pq_cr_campanianav2018.sp_cr_resolutor4_so(pn_pai => pn_pai,
                                                pn_tdo => pn_tdo,
                                                pc_ndo => pc_ndo,
                                                pn_seg => n_segori);
    exception
      when others then
        null;
    end;
    -- fin Mod @abr 20181123   
  
    --Mod@abr20180110
    begin
      pQ_CR_SEGMENTACION_PERMAN.Sp_cr_variables(pn_pai,
                                                pn_tdo,
                                                pc_ndo,
                                                lc_premium_unico,
                                                lc_premium,
                                                lc_preferencialA,
                                                lc_preferencialb,
                                                lc_preferencialC,
                                                lc_Forjador,
                                                lc_Emprendedor,
                                                lc_PrefExclusivo,
                                                lc_PreferenteA,
                                                lc_PreferenteB,
                                                lc_Recurrente,
                                                lc_Nuevo);
    
    exception
      when others then
        null;
    end;
    --Fin Mod@abr20180110
  
  end Sp_Resolutores_NS;

  procedure sp_job_carga(P_D_FECPRO IN DATE,
                         P_N_JOBS   IN NUMBER,
                         PC_USR     IN VARCHAR2) is
  
    /*cursor c_clientes_job(p_fecpro date) is
    select substr(trim(j.jaqy163ndoc), -1, 1) digito
      from jaqy163 j
     group by substr(trim(j.jaqy163ndoc), -1, 1);*/
  
    lc_fecpro   varchar2(10);
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    --l_jaqy163pano  jaqy163.jaqy066pano%type;
    --l_jaqy163pmes  jaqy163..jaqy066pmes%type;
    ln_cont   number(2) := 0;
    ln_inst   number(1) := 1;
    ln_limit  number(3) := 20;
    ln_numjob number(5);
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
    --execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';
    lc_fecpro := to_char(P_D_FECPRO, 'RRRR.MM.DD');
    --l_jaqy066pano := to_number(to_char(add_months(P_D_FECPRO, -1),'RRRR'));
    --l_jaqy066pmes := to_number(to_char(add_months(P_D_FECPRO, -1),'MM')); 
    begin
      delete from AQPC187 a where a.AQPC187fech = P_D_FECPRO;
      commit;
    exception
      when others then
        null;
    end;
  
    --apachecoh 2023.07.03
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 10
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
  
    for i in 0 .. P_N_JOBS loop
    
      lc_variable := ' begin ' ||
                     ' PQ_CR_SEGM_MENS_MYPE22.Sp_Carga_data(TO_DATE(''' ||
                     lc_fecpro || ''',''RRRR.MM.DD''),''' || i || ''',''' ||
                     PC_USR || ''');' || ' End; ';
      ln_job      := ln_job + 1;
    
      --              DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*60));
      --if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      BEGIN
        IF SYS.FN_BD_ISRAC = 'TRUE' THEN
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          --                     instance => ln_inst,
                          instance => 1,
                         -- instance => 2, --Solo por hoy 01.07.2015 hmev new 01/01/2024
                          force    => false);
        else
          DBMS_JOB.SUBMIT(job       => ln_job,
                          what      => lc_variable,
                          next_date => sysdate + 1 / (24 * 60),
                          interval  => null,
                          no_parse  => false,
                          force     => false);
        end if;
        commit;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --apachecoh 2023.07.03  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_CR_SEGM_MENS_MYPE22.SP_CARGA_DATA%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob = ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_CR_SEGM_MENS_MYPE22.SP_CARGA_DATA%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
    
    end loop;
  
  end sp_job_carga;

  Procedure Sp_Carga_data(pd_fecpro  in date,
                          P_N_DIGITO in number,
                          pc_usr     in varchar2) is
  -- 26/12/2024 MHUAMANIA Se añadió una nueva variable REL_CREDI_MAS_CDK
    cursor c_clientes(p_fecpro date) is
      select l.jaqy163pais, l.jaqy163tdoc, l.jaqy163ndoc
        from JAQY163 l
       where not exists (select 1
                from AQPC187 c
               where c.AQPC187pais = l.jaqy163pais
                 and c.AQPC187tdoc = l.jaqy163tdoc
                 and c.AQPC187ndoc = l.jaqy163ndoc
                 and c.AQPC187fech = pd_fecpro)
         and JAQY163NUME2 = P_N_DIGITO;
  
    pn_cal        number(5, 2);
    ln_CntInsRep  number(10);
    lc_fin_sobend char(1);
    lc_castigado  char(1);
    ln_histCred   number(5);
    ln_promAtr    number(18, 2);
    ln_segcod     number(2);
    lc_refinan    char(1);
    lc_tipHN      char(1);
    pn_cal2       number(5, 2);
    ln_CntAntRcc  number(10);
    ln_cal        number(5);
    --apachecoh 2023.02.23
    ln_afdatr    number(17, 2);
    ln_afcalif   number(10, 2);
    ln_afcalif2  number(10, 2);
    ln_afecta    number(5);
    lv_afecta    varchar2(50);
    lv_ndocum    varchar2(12);
    ln_instancia number(10);
  
    hist_pyme        char(1); --mod@abr20170127
    saldo_Tit        char(1); --mod@abr20181123
    saldo_Cyg        char(1); --mod@abr20181123
    seg_ori          number(5); --mod@abr20181123
    lc_premium_unico char(1); --mod@abr 20180110
    lc_premium       char(1); --mod@abr 20180110
    lc_preferencialA char(1); --mod@abr 20180110
    lc_preferencialb char(1); --mod@abr 20180110
    lc_preferencialC char(1); --mod@abr 20180110
    lc_Forjador      char(1); --mod@abr 20180110
    lc_Emprendedor   char(1); --mod@abr 20180110
    lc_PrefExclusivo char(1); --mod@abr 20180110
    lc_PreferenteA   char(1); --mod@abr 20180110
    lc_PreferenteB   char(1); --mod@abr 20180110
    lc_Recurrente    char(1); --mod@abr 20180110
    lc_Nuevo         char(1); --mod@abr 20180110
    ln_segmentac     number(5); --mod@abr 20201003
    ln_segpymeant    varchar2(100);
    lc_JAQZ082VAR1   varchar2(100);
    lc_JAQZ082VAR2   varchar2(100);
    lc_JAQZ082VAR3   varchar2(100);
    lc_JAQZ082VAR4   varchar2(100);
    lc_JAQZ082VAR5   varchar2(100);
    lc_JAQZ082VAR6   varchar2(100);
    lc_JAQZ082VAR7   varchar2(100);
    lc_JAQZ082VAR8   varchar2(100);
    lc_JAQZ082VAR9   varchar2(100);
    lc_JAQZ082VAR10  varchar2(100);
    lc_JAQZ082VAR11  varchar2(100);
    lc_JAQZ082VAR12  varchar2(100);
    lc_JAQZ082VAR13  varchar2(100); --mod@abr20170127
    lc_JAQZ082VAR14  varchar2(100); --mod@abr20181123
    lc_JAQZ082VAR15  varchar2(100); --mod@abr20181123
  
    lc_JAQZ082VAR16 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR17 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR18 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR19 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR20 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR21 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR22 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR23 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR24 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR25 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR26 varchar2(100); --mod@abr 20180110
    lc_JAQZ082VAR27 varchar2(100); --mod@abr 20180110
  
    lc_JAQZ082VAR28 varchar2(100); --mod@abr 20201003
    lc_JAQZ082VAR29 varchar2(100);
    lc_lista        char(1);
    lc_hora         char(8);
  
    TYPE tp_pais IS TABLE OF jaqy163.jaqy163pais%type INDEX BY BINARY_INTEGER;
    TYPE tp_tdoc IS TABLE OF jaqy163.jaqy163tdoc%type INDEX BY BINARY_INTEGER;
    TYPE tp_ndoc IS TABLE OF jaqy163.jaqy163ndoc%type INDEX BY BINARY_INTEGER;
  
    la_jaqy163pais tp_pais;
    la_jaqy163tdoc tp_tdoc;
    la_jaqy163ndoc tp_ndoc;
  
    --cursor creditos is
    --select * from JAQY163 a
    --where a.jaqy163ndoc = '29524923'
    
    --Nuevas variables para antiguedad credinka mhuamani
    ln_anticredinka  number(4);
    ln_coder    number(5);
    lv_menser    varchar2(50);  
    
  begin
    lc_lista := 'N';
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=". "';
  
    OPEN c_clientes(pd_fecpro); -- Clientes Bulk
    FETCH c_clientes BULK COLLECT
      INTO la_jaqy163pais, la_jaqy163tdoc, la_jaqy163ndoc;
  
    IF la_jaqy163ndoc.count > 0 THEN
      FOR c IN la_jaqy163ndoc.FIRST .. la_jaqy163ndoc.LAST LOOP
      
        --for i in creditos loop
        BEGIN
          PQ_CR_SEGM_MENS_MYPE22.Sp_cr_Resolutores( /*i.jaqy163pais*/la_jaqy163pais(c),
                                                   /*i.jaqy163tdoc*/
                                                   la_jaqy163tdoc(c),
                                                   /*i.jaqy163ndoc*/
                                                   la_jaqy163ndoc(c),
                                                   pd_fecpro,
                                                   pn_cal,
                                                   ln_CntInsRep,
                                                   lc_fin_sobend,
                                                   lc_castigado,
                                                   ln_CntAntRcc);
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        BEGIN
          PQ_CR_SEGM_MENS_MYPE22.Sp_Resolutores_NS( /*i.jaqy163pais*/la_jaqy163pais(c),
                                                   /*i.jaqy163tdoc*/
                                                   la_jaqy163tdoc(c),
                                                   /*i.jaqy163ndoc*/
                                                   la_jaqy163ndoc(c),
                                                   pd_fecpro,
                                                   ln_histCred,
                                                   ln_promAtr,
                                                   ln_segcod,
                                                   lc_refinan,
                                                   lc_tipHN,
                                                   pn_cal2,
                                                   hist_pyme, --mod@abr20170127
                                                   saldo_Tit,
                                                   saldo_Cyg,
                                                   seg_ori, --mod@abr 20181123
                                                   lc_premium_unico, --mod@abr 20180110
                                                   lc_premium, --mod@abr 20180110
                                                   lc_preferencialA, --mod@abr 20180110
                                                   lc_preferencialb, --mod@abr 20180110
                                                   lc_preferencialC, --mod@abr 20180110
                                                   lc_Forjador, --mod@abr 20180110
                                                   lc_Emprendedor, --mod@abr 20180110
                                                   lc_PrefExclusivo, --mod@abr 20180110
                                                   lc_PreferenteA, --mod@abr 20180110
                                                   lc_PreferenteB, --mod@abr 20180110
                                                   lc_Recurrente, --mod@abr 20180110
                                                   lc_Nuevo, --mod@abr 20180110
                                                   ln_segmentac --mod@abr 20201003
                                                   );
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
        /****Variable SEGM_ANTerior***/
        BEGIN
          pQ_cr_segmentacion_PYME_NUEVAR.SP_CR_SEGM_ANT(la_jaqy163pais(c),
                                                        la_jaqy163tdoc(c),
                                                        la_jaqy163ndoc(c),
                                                        0,
                                                        ln_segpymeant);
        
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        --apachecoh 2023.02.23
        begin
          select tp1nro2
            into ln_afecta
            from fst198
           where tp1cod = 1
             and tp1cod1 = 10823
             and tp1corr1 = 55
             and tp1corr2 = 4
             and tp1corr3 = 0;
        exception
          when others then
            ln_afecta := 0;
        end;
        if ln_afecta = 1 then
          lv_ndocum := trim(la_jaqy163ndoc(c));
          begin
            PQ_CR_SEGMNXCOMPORT.sp_cr_Inicio(ln_instancia,
                                             la_jaqy163pais(c),
                                             la_jaqy163tdoc(c),
                                             lv_ndocum,
                                             pc_usr,
                                             lv_afecta);
          exception
            when others then
              null;
          end;
          begin
            PQ_CR_VAR_SEGMENTACION_CONG_RP.sp_cr_variables_cong(la_jaqy163pais(c),
                                                                la_jaqy163tdoc(c),
                                                                lv_ndocum,
                                                                1,
                                                                ln_afdatr,
                                                                ln_afcalif,
                                                                ln_afcalif2);
          exception
            when others then
              null;
          end;
          
        end if;
        -- MHUAMANIA 26/12/2024 - Se llama al paquete para obtener la antiguedad 
        begin
        pq_cr_segmentacion_credinka.sp_antiguedad_rcc_cli(la_jaqy163pais(c),
                                                                la_jaqy163tdoc(c),
                                                                lv_ndocum,
                                                                ln_anticredinka,
                                                                ln_coder,
                                                                lv_menser);
        exception
          when others then 
            null;
        end;
        --apachecoh 2023.02.23
        lc_JAQZ082VAR1 := 'ANTIGUEDAD_RCC_N' || '=' ||
                          trim(to_char(ln_CntAntRcc));
        lc_JAQZ082VAR2 := 'CANT_INSTREP_N' || '=' ||
                          trim(to_char(ln_CntInsRep)); --MOD@ABR 20201003
        lc_JAQZ082VAR3 := 'CALIFICACION_RCC_N' || '=' ||
                          trim(to_char(pn_cal));
      
        IF ln_histCred = 0 THEN
          lc_JAQZ082VAR4 := 'REL_CREDI_N =' || '0'; --MOD
        ELSE
          lc_JAQZ082VAR4 := 'REL_CREDI_N' || '=' ||
                            trim(to_char(ln_histCred));
        END IF;
      
        if ln_promAtr = 0 then
          lc_JAQZ082VAR5 := 'DIA_ATRASO_N=0.00';
        else
          case
            when ln_promAtr < 1 and ln_promAtr > 0 then
              lc_JAQZ082VAR5 := 'DIA_ATRASO_N=' || '0' ||
                                TRIM(TO_CHAR(ln_promAtr));
            else
              lc_JAQZ082VAR5 := 'DIA_ATRASO_N=' ||
                                TRIM(TO_CHAR(ln_promAtr));
          end case;
        end if;
        lc_JAQZ082VAR6 := 'SEGPYME_ANT' || '=' || trim(ln_segpymeant);
      
        lc_JAQZ082VAR7  := 'SOBRE_ENDEUDADO' || '=' || trim(lc_fin_sobend);
        lc_JAQZ082VAR8  := 'REFINANCIADO' || '=' || trim(lc_refinan);
        lc_JAQZ082VAR9  := 'CASTIGADO' || '=' || trim(lc_castigado);
        lc_JAQZ082VAR10 := 'LISTA_NEGRA' || '=' || trim(lc_lista);
        lc_JAQZ082VAR11 := 'SEGMENTO' || '=' || trim(to_char(ln_segcod));
        lc_JAQZ082VAR12 := 'SEGMENTACION_MENS' || '=' ||
                           trim(to_char(ln_segmentac));
      
        --apachecoh 2023.02.23        
        if ln_afecta = 1 then
          lc_JAQZ082VAR13 := 'DATR_P_CEN_RN' || '=' ||
                             trim(to_char(ln_afdatr));
          lc_JAQZ082VAR14 := 'CALF_P_CEN_RN' || '=' ||
                             trim(to_char(ln_afcalif));
          lc_JAQZ082VAR15 := 'SEGMENCOM_RN' || '=' || trim(lv_afecta);
        end if;
        
        lc_JAQZ082VAR16 := 'REL_CREDI_MAS_CDK' || '=' || trim(to_char(ln_anticredinka));-- MHUAMANIA / Nueva variable 26/12/2024
        
        ln_cal  := 0;
        lc_hora := TO_CHAR(SYSDATE, 'hh:mm:ss');
      
        BEGIN
          insert into AQPC187
            (AQPC187FECH,
             AQPC187PAIS,
             AQPC187TDOC,
             AQPC187NDOC,
             AQPC187HORA,
             AQPC187CCAL,
             AQPC187VAR1,
             AQPC187VAR2,
             AQPC187VAR3,
             AQPC187VAR4,
             AQPC187VAR5,
             AQPC187VAR6,
             AQPC187VAR7,
             AQPC187VAR8,
             AQPC187VAR9,
             AQPC187VAR10,
             AQPC187VAR11,
             AQPC187VAR12,
             AQPC187VAR13,
             AQPC187VAR14,
             AQPC187VAR15,
             AQPC187VAR16,
             AQPC187USR,
             AQPC187NUME)
          values
            (pd_fecpro, /*i.jaqy163pais*/
             la_jaqy163pais(c),
             /*i.jaqy163tdoc*/
             la_jaqy163tdoc(c),
             /*i.jaqy163ndoc*/
             la_jaqy163ndoc(c),
             lc_hora,
             ln_cal,
             lc_JAQZ082VAR1,
             lc_JAQZ082VAR2,
             lc_JAQZ082VAR3,
             lc_JAQZ082VAR4,
             lc_JAQZ082VAR5,
             lc_JAQZ082VAR6,
             lc_JAQZ082VAR7,
             lc_JAQZ082VAR8,
             lc_JAQZ082VAR9,
             lc_JAQZ082VAR10,
             lc_JAQZ082VAR11,
             lc_JAQZ082VAR12,
             lc_JAQZ082VAR13,
             lc_JAQZ082VAR14,
             lc_JAQZ082VAR15,
             lc_JAQZ082VAR16,
             pc_usr,
             P_N_DIGITO);
        
          commit;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      end loop;
      commit;
    end if;
  
  end Sp_Carga_data;

end PQ_CR_SEGM_MENS_MYPE22;
/

