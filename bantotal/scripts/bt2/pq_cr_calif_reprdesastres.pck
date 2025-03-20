create or replace package PQ_CR_CALIF_REPRDESASTRES is

  -- Author  : MPOSTIGOC
  -- Created : 14/12/2017 10:34:12 a.m.
  -- Purpose : RP Valida calificacion RCC
  -- Fecha de Modificación      :  12/02/2024
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se agrego rownum cuando la consulta devuelva mas de 1 registro
  -- *****************************************************************

  procedure sp_cr_VerfCalTitConyRL6M(ln_Instancia  in number,
                                     lc_VerifCal6M out varchar2);

end PQ_CR_CALIF_REPRDESASTRES;
/

create or replace package body PQ_CR_CALIF_REPRDESASTRES is

  -- Verifica si Titular / conyugue o Titular / Reprs Legal tiene calif 100% Normal en el ultimo periodo

  procedure sp_cr_VerfCalTitConyRL6M(ln_Instancia  in number,
                                     lc_VerifCal6M out varchar2) is
  
    ld_FchRCC    date;
    ln_PaisDoc   number;
    ln_TipoDoc   number;
    lc_Ndoc      varchar2(12);
    ln_PaisDocII number;
    ln_TipoDocII number;
    lc_NdocII    varchar2(12);
    --  ln_meses       number := 0;
    -- ld_MesVerifica date;
    lc_FlagCalif    varchar2(2) := 'N';
    ln_ctdocid      varchar2(1);
    ln_ctdocidII    varchar2(1);
    ln_Calificacion number; -- 03/04/2018 mpostigoc
  
  begin
  
    begin
      --Extrae Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_PaisDoc, ln_TipoDoc, lc_Ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      --280818 mpostigoc
      when others then
        null;
    end;
  
    if ln_PaisDoc is not null then
      --280818 mpostigoc, verifico que si tenga valor la varible de pais
    
      begin
        -- mpostigoc 09012018
        select to_char(a.tp1corr3)
          into ln_ctdocid
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 11111
           and a.tp1corr1 = 1
           and a.tp1corr2 = 3
           and a.tp1nro1 = ln_TipoDoc;
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
      
        begin
          -- mpostigoc 09012018
          select to_char(a.tp1corr3)
            into ln_ctdocidII
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11111
             and a.tp1corr1 = 1
             and a.tp1corr2 = 3
             and a.tp1nro1 = ln_TipoDocII;
        exception
          when others then
            null;
          
        end;
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
    
      -- while ln_meses <= 6 loop
    
      --  ld_MesVerifica := last_day(ADD_MONTHS(ld_FchRCC, - (ln_meses)));
    
      begin
        -- Extrae Calificacion
      
        select c.n_calif0 -- 03/04/2018 mpostigoc
          into ln_Calificacion
          from cldrcci c
         where c.c_docide = trim(lc_Ndoc)
           and c.c_tdocid = ln_ctdocid -- mpostigoc 09012018
           and c.d_fecpre = ld_FchRCC;
      exception
        when no_data_found then
          lc_FlagCalif := 'N';
        when too_many_rows then
          begin
            --mpostigoc 05/01/2018
            select c.n_calif0 -- 03/04/2018 mpostigoc
              into ln_Calificacion
              from cldrcci c
             where c.c_docide = trim(lc_Ndoc)
               and c.c_tdocid = ln_ctdocid -- mpostigoc 09012018
               and c.d_fecpre = ld_FchRCC
                  --and c.n_calif0 = 100
               and c.c_person = '1'
               and rownum = 1;
          end;
      end;
    
      if ln_Calificacion = 100 then
        -- 03/04/2018 mpostigoc
        lc_FlagCalif := 'N';
      else
        if ln_Calificacion < 100 then
          lc_FlagCalif := 'S';
        end if;
      end if;
    
      if lc_FlagCalif = 'N' and lc_NdocII is not null then
      
        ln_Calificacion := null;
      
        begin
          -- Extrae Calificacion
        
          select c.n_calif0 -- 03/04/2018 mpostigoc
            into ln_Calificacion
            from cldrcci c
           where c.c_docide = trim(lc_NdocII)
             and c.c_tdocid = ln_ctdocidII -- mpostigoc 09012018
             and c.d_fecpre = ld_FchRCC;
        exception
          when no_data_found then
            lc_FlagCalif := 'N';
          when too_many_rows then
            begin
              --mpostigoc 05/01/2018
              select c.n_calif0 -- 03/04/2018 mpostigoc
                into ln_Calificacion
                from cldrcci c
               where c.c_docide = trim(lc_NdocII)
                 and c.c_tdocid = ln_ctdocidII -- mpostigoc 09012018
                 and c.d_fecpre = ld_FchRCC
                    --  and c.n_calif0 = 100
                 and c.c_person = '1'
                 and rownum = 1;
            end;
        end;
      
        if ln_Calificacion = 100 then
          -- 03/04/2018 mpostigoc
          lc_FlagCalif := 'N';
        else
          if ln_Calificacion < 100 then
            -- 09/04/2018 mpostigoc
            lc_FlagCalif := 'S';
          end if;
        end if;
      
      end if;
    
    else
      --280818 mpostigoc
      lc_FlagCalif := 'N'; -- 280818 mpostigoc
    
    end if; --280818 mpostigoc
  
    lc_VerifCal6M := lc_FlagCalif;
  
  end sp_cr_VerfCalTitConyRL6M;

end PQ_CR_CALIF_REPRDESASTRES;
/

