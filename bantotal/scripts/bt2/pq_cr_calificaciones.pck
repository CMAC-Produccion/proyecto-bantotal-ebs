create or replace package PQ_CR_CALIFICACIONES is

  -- Author  : MPOSTIGOC
  -- Created : 04/12/2017 12:42:39 p.m.
  -- Purpose : 

  -- Public type declarations
  procedure sp_cr_UltCalifiTit(ln_Instancia in number,
                               ln_Verifica  out varchar2);
  procedure sp_cr_VerfCalDetTitConyRL6M(ln_Instancia     in number,
                                        lc_VerifCalDet6M out varchar2);

  procedure sp_cr_MoraMaxTitConyRL(ln_Instancia        in number,
                                   ln_MoraMaxTitConyRL out number);

end PQ_CR_CALIFICACIONES;
/

create or replace package body PQ_CR_CALIFICACIONES is
  --------------------------------------------------------------

  procedure sp_cr_UltCalifiTit(ln_Instancia in number,
                               ln_Verifica  out varchar2) is
    ld_FchRCC            date;
    ln_CodSBS            varchar2(10) := null;
    lc_VerifCaliOtrasEnt varchar2(2) := 'N';
    lc_VerifCaliCMAC     varchar2(2) := 'N';
    ln_PaisDoc           number;
    ln_TipoDoc           number;
    lc_Ndoc              varchar2(12);
  
  begin
  
    begin
      --Extrae Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_PaisDoc, ln_TipoDoc, lc_Ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      -- Extrae Fecha RCC
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      -- Extrae Codigo SBS
      select c.c_codsbs
        into ln_CodSBS
        from cldrcci c
       where c.c_docide = trim(lc_Ndoc)
         and c.d_fecpre = ld_FchRCC;
    exception
      when others then
        null;
    end;
  
    begin
      -- Verifica si en otras entidades su calificaciones es diferente a Normal
      select case
               when ln_num > 0 then
                'S'
               else
                'N'
             end
        into lc_VerifCaliOtrasEnt
        from (select count(*) ln_num
                from cldrccs d
               where d.c_codsbs = ln_CodSBS
                 and d.d_fecpre = ld_FchRCC
                 and d.c_codemp <> '00104'
                 and d.c_calvig > '0') t;
    
    exception
      when others then
        lc_VerifCaliOtrasEnt := 'N';
    end;
  
    if lc_VerifCaliOtrasEnt = 'N' then
    
      begin
        -- Verifica si en CMAC su calificacion es mayor a CPP      
        select case
                 when ln_num > 0 then
                  'S'
                 else
                  'N'
               end
          into lc_VerifCaliCMAC
          from (select count(*) ln_num
                  from cldrccs d
                 where d.c_codsbs = ln_CodSBS
                   and d.d_fecpre = ld_FchRCC
                   and d.c_codemp = '00104'
                   and d.c_calvig > '1') t;
      exception
        when others then
          lc_VerifCaliCMAC := 'N';
      end;
    end if;
  
    -- Si en otras entidades su calif es = Normal y en CMAC Su cali no es > cpp, devuelve N
    if lc_VerifCaliOtrasEnt = 'N' and lc_VerifCaliCMAC = 'N' then
      ln_Verifica := 'N';
    else
      ln_Verifica := 'S';
    end if;
  
  end sp_cr_UltCalifiTit;
  ----------------------------------------------
  -- Verifica si TutlarNatural/conyugue o TitularJurid/Reprs Legal tiene calif hasta CPP detallado en los ultimos 6 meses
  -- sin considerar CMAC

  procedure sp_cr_VerfCalDetTitConyRL6M(ln_Instancia     in number,
                                        lc_VerifCalDet6M out varchar2) is
  
    ld_FchRCC      date;
    ln_PaisDoc     number;
    ln_TipoDoc     number;
    lc_Ndoc        varchar2(12);
    ln_PaisDocII   number;
    ln_TipoDocII   number;
    lc_NdocII      varchar2(12);
    ln_meses       number := 0;
    ld_MesVerifica date;
    --lc_FlagCalif         varchar2(2) := 'N';
    lc_VerifCaliOtrasEnt varchar2(2) := 'N';
    --lc_VerifCaliCMAC     varchar2(2) := 'N';
    ln_CodSBS   varchar2(12) := null;
    ln_CodSBSII varchar2(12) := null;
    ln_Verifica varchar2(2) := 'N';
  
  begin
  
    begin
      --Extrae Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_PaisDoc, ln_TipoDoc, lc_Ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipoDoc = 21 then
      begin
        select f.rppais, f.rptdoc, f.rpndoc
          into ln_PaisDocII, ln_TipoDocII, lc_NdocII
          from fsr002 f
         where f.pepais = ln_PaisDoc
           and f.petdoc = ln_TipoDoc
           and f.pendoc = lc_Ndoc
           and f.rpccyg = 66;
      exception
        when others then
          null;
      end;
      if ln_TipoDoc = 9 then
        begin
          select f.pfpai1, f.pftdo1, f.pfndo1
            into ln_PaisDocII, ln_TipoDocII, lc_NdocII
            from fsr003 f
           where f.pjpais = ln_PaisDoc
             and f.pjtdoc = ln_TipoDoc
             and f.pjndoc = lc_Ndoc
             and f.vicod = 7;
        exception
          when others then
            null;
        end;
      end if;
    end if;
  
    begin
      -- Extrae Fecha RCC
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      -- Extrae Codigo SBS
      select c.c_codsbs
        into ln_CodSBS
        from cldrcci c
       where c.c_docide = trim(lc_Ndoc)
         and c.d_fecpre = ld_FchRCC;
    exception
      when others then
        null;
    end;
  
    while ln_meses <= 6 loop
    
      ld_MesVerifica := last_day(ADD_MONTHS(ld_FchRCC, - (ln_meses)));
    
      begin
        -- Verifica si en otras entidades su calificaciones es diferente a Normal
        select case
                 when ln_num > 0 then
                  'S'
                 else
                  'N'
               end
          into lc_VerifCaliOtrasEnt
          from (select count(*) ln_num
                  from cldrccs d
                 where d.c_codsbs = ln_CodSBS
                   and d.d_fecpre = ld_MesVerifica
                   and d.c_codemp <> '00104'
                   and (substr(d.c_cuenta, 1, 4) in
                       (select trim(Tp1desc)
                           from fst198
                          Where Tp1cod = 1
                            and Tp1cod1 = 10899
                            and Tp1corr1 = 13
                            and Tp1corr2 = 6) or
                       substr(d.c_cuenta, 1, 6) in
                       (select trim(Tp1desc)
                           from fst198
                          Where Tp1cod = 1
                            and Tp1cod1 = 10899
                            and Tp1corr1 = 13
                            and Tp1corr2 = 7))
                   and d.c_calvig > '1') t;
      exception
        when others then
          lc_VerifCaliOtrasEnt := 'N';
      end;
    
      /*if lc_VerifCaliOtrasEnt = 'N' then
      
        begin
          -- Verifica si en CMAC su calificacion es mayor a CPP      
          select case
                   when ln_num > 0 then
                    'S'
                   else
                    'N'
                 end
            into lc_VerifCaliCMAC
            from (select count(*) ln_num
                    from cldrccs d
                   where d.c_codsbs = ln_CodSBS
                     and d.d_fecpre = ld_MesVerifica
                     and d.c_codemp = '00104'
                     and d.c_calvig > '1') t;
        end;
      
      end if;*/
    
      -- Si en otras entidades su calif es = Normal y en CMAC Su cali no es > cpp, devuelve N
      if lc_VerifCaliOtrasEnt = 'N' /*and lc_VerifCaliCMAC = 'N'*/
       then
        ln_Verifica := 'N';
        ln_meses    := ln_meses + 1;
      else
        ln_Verifica := 'S';
        exit;
      end if;
    
    end loop;
  
    if ln_Verifica = 'N' then
      ln_meses := 0;
    
      begin
        -- Extrae Codigo SBS
        select c.c_codsbs
          into ln_CodSBSII
          from cldrcci c
         where c.c_docide = trim(lc_NdocII)
           and c.d_fecpre = ld_MesVerifica;
      exception
        when others then
          null;
      end;
    
      while ln_meses <= 6 loop
      
        ld_MesVerifica := last_day(ADD_MONTHS(ld_FchRCC, - (ln_meses)));
      
        begin
          -- Verifica si en otras entidades su calificaciones es diferente a Normal
          select case
                   when ln_num > 0 then
                    'S'
                   else
                    'N'
                 end
            into lc_VerifCaliOtrasEnt
            from (select count(*) ln_num
                    from cldrccs d
                   where d.c_codsbs = ln_CodSBSII
                     and d.d_fecpre = ld_MesVerifica
                     and d.c_codemp <> '00104'
                     and (substr(d.c_cuenta, 1, 4) in
                         (select trim(Tp1desc)
                             from fst198
                            Where Tp1cod = 1
                              and Tp1cod1 = 10899
                              and Tp1corr1 = 13
                              and Tp1corr2 = 6) or
                         substr(d.c_cuenta, 1, 6) in
                         (select trim(Tp1desc)
                             from fst198
                            Where Tp1cod = 1
                              and Tp1cod1 = 10899
                              and Tp1corr1 = 13
                              and Tp1corr2 = 7))
                     and d.c_calvig > '1') t;
        exception
          when others then
            lc_VerifCaliOtrasEnt := 'N';
          
        end;
      
        /* if lc_VerifCaliOtrasEnt = 'N' then
        
          begin
            -- Verifica si en CMAC su calificacion es mayor a CPP      
            select case
                     when ln_num > 0 then
                      'S'
                     else
                      'N'
                   end
              into lc_VerifCaliCMAC
              from (select count(*) ln_num
                      from cldrccs d
                     where d.c_codsbs = ln_CodSBS
                       and d.d_fecpre = ld_FchRCC
                       and d.c_codemp = '00104'
                       and d.c_calvig > '1') t;
          end;
        end if;*/
      
        -- Si en otras entidades su calif es = Normal y en CMAC Su cali no es > cpp, devuelve N
        if lc_VerifCaliOtrasEnt = 'N' /* and lc_VerifCaliCMAC = 'N' */
         then
          ln_Verifica := 'N';
          ln_meses    := ln_meses + 1;
        else
          ln_Verifica := 'S';
          exit;
        end if;
      
      end loop;
    
    end if;
  
    lc_VerifCalDet6M := ln_Verifica;
  
  end sp_cr_VerfCalDetTitConyRL6M;

  ----------------------------------------------
  procedure sp_cr_MoraMaxTitConyRL(ln_Instancia        in number,
                                   ln_MoraMaxTitConyRL out number) is
  
    cursor Cred_Vigentes(ln_Pepais number, ln_Petdoc number, ln_Pendoc varchar2, ld_FchSist date) is
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
       where d10.Pgcod = 1
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               and Cttfir = 'T'*/
                           )
         and (d10.Aomod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (108)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= ld_FchSist;
  
    cursor calendario(ln_pgcod number, ln_sucursal number, ln_modulo number, ln_moneda number, ln_papel number, ln_cuenta number, ln_operacion number, ln_subopera number, ln_tipopera number, ld_FchSist date) is
      select f.pgcod  ln_pgcod,
             f.ppsuc  ln_sucursal,
             f.ppmod  ln_modulo,
             f.ppmda  ln_moneda,
             f.pppap  ln_papel,
             f.ppcta  ln_cuenta,
             f.ppoper ln_operacion,
             f.ppsbop ln_subopera,
             f.pptope ln_tipopera,
             f.ppfpag ld_FchCalendario
        from fsd601 f
       where f.pgcod = ln_pgcod
         and f.ppsuc = ln_sucursal
         and f.ppmod = ln_modulo
         and f.ppmda = ln_moneda
         and f.pppap = ln_papel
         and f.ppcta = ln_cuenta
         and f.ppoper = ln_operacion
         and f.ppsbop = ln_subopera
         and f.pptope = ln_tipopera
         and f.ppfpag <= ld_FchSist;
  
    ln_pgcod        number;
    ln_sucursal     number;
    ln_modulo       number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_subopera     number;
    ln_tipopera     number;
    ld_FchSist      date;
    ln_MoraCuota    number := 0;
    ln_MoraCuotaAux number := 0;
    ln_PaisDoc      number := 0;
    ln_TipoDoc      number := 0;
    lc_Ndoc         varchar2(12);
    ln_PaisDocII    number := 0;
    ln_TipoDocII    number := 0;
    lc_NdocII       varchar2(12);
  
  begin
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      --Extrae Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_PaisDoc, ln_TipoDoc, lc_Ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    if ln_TipoDoc = 21 then
      begin
        select f.rppais, f.rptdoc, f.rpndoc
          into ln_PaisDocII, ln_TipoDocII, lc_NdocII
          from fsr002 f
         where f.pepais = ln_PaisDoc
           and f.petdoc = ln_TipoDoc
           and f.pendoc = lc_Ndoc
           and f.rpccyg = 66;
      exception
        when others then
          null;
      end;
    else
      if ln_TipoDoc = 9 then
        begin
          select f.pfpai1, f.pftdo1, f.pfndo1
            into ln_PaisDocII, ln_TipoDocII, lc_NdocII
            from fsr003 f
           where f.pjpais = ln_PaisDoc
             and f.pjtdoc = ln_TipoDoc
             and f.pjndoc = lc_Ndoc
             and f.vicod = 7;
        exception
          when others then
            null;
        end;
      end if;
    end if;
  
    for d in Cred_Vigentes(ln_PaisDoc, ln_TipoDoc, lc_Ndoc, ld_FchSist) loop
      for c in calendario(d.ln_pgcod10,
                          d.ln_suc10,
                          d.ln_mod10,
                          d.ln_mda10,
                          d.ln_pap10,
                          d.ln_cta10,
                          d.ln_oper10,
                          d.ln_sbop10,
                          d.ln_tope10,
                          ld_FchSist) loop
      
        begin
          select max(pp1fech - ppfpag) -- mpostigoc 05/01/2018
            into ln_MoraCuota
            from fsd602
           where pgcod = c.ln_pgcod
             and ppsuc = c.ln_sucursal
             and ppmod = c.ln_modulo
             and ppmda = c.ln_moneda
             and pppap = c.ln_papel
             and ppcta = c.ln_cuenta
             and ppoper = c.ln_operacion
             and ppsbop = c.ln_subopera
             and pptope = c.ln_tipopera
             and pp1stat = 'T'
             and pp1cap > 0
             and ppfpag = c.ld_FchCalendario;
        exception
          when no_Data_found then
            ln_MoraCuota := ld_FchSist - c.ld_FchCalendario;
        end;
      
        if ln_MoraCuota > ln_MoraCuotaAux then
          ln_MoraCuotaAux := ln_MoraCuota;
        end if;
      
      end loop;
    
    end loop;
  
    if ln_PaisDocII <> 0 then
    
      for d in Cred_Vigentes(ln_PaisDocII,
                             ln_TipoDocII,
                             lc_NdocII,
                             ld_FchSist) loop
        for c in calendario(d.ln_pgcod10,
                            d.ln_suc10,
                            d.ln_mod10,
                            d.ln_mda10,
                            d.ln_pap10,
                            d.ln_cta10,
                            d.ln_oper10,
                            d.ln_sbop10,
                            d.ln_tope10,
                            ld_FchSist) loop
        
          begin
            select max(pp1fech - ppfpag) -- mpostigoc 05/01/2018
              into ln_MoraCuota
              from fsd602
             where pgcod = c.ln_pgcod
               and ppsuc = c.ln_sucursal
               and ppmod = c.ln_modulo
               and ppmda = c.ln_moneda
               and pppap = c.ln_papel
               and ppcta = c.ln_cuenta
               and ppoper = c.ln_operacion
               and ppsbop = c.ln_subopera
               and pptope = c.ln_tipopera
               and pp1stat = 'T'
               and pp1cap > 0
               and ppfpag = c.ld_FchCalendario;
          exception
            when no_Data_found then
              ln_MoraCuota := ld_FchSist - c.ld_FchCalendario;
          end;
        
          if ln_MoraCuota > ln_MoraCuotaAux then
            ln_MoraCuotaAux := ln_MoraCuota;
          end if;
        
        end loop;
      
      end loop;
    
    end if;
  
    ln_MoraMaxTitConyRL := ln_MoraCuotaAux;
  
  end sp_cr_MoraMaxTitConyRL;

---------------------------------------------
end PQ_CR_CALIFICACIONES;
/

