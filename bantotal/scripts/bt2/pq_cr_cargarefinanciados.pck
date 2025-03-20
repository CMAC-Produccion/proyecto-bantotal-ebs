create or replace package PQ_CR_CARGAREFINANCIADOS is

  -- Author  : MPOSTIGOC
  -- Created : 28/12/2023 12:52:13
  -- Purpose : 

  -- Public type declarations

  procedure sp_Cr_cargaAQPB175;
  -------------------------------------------------
  procedure sp_Cr_VerfRefVuelo(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               lc_RefVuelo  out varchar2,
                               ln_InstVuelo out number);
  --------------------------------------------------------                               
  procedure sp_Cr_InsertAQPB175(ld_fecha in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_empr  in number,
                                ln_modr  in number,
                                ln_sucr  in number,
                                ln_mdar  in number,
                                ln_papr  in number,
                                ln_ctar  in number,
                                ln_oper  in number,
                                ln_subpr in number,
                                ln_toper in number,
                                ln_grupo in number);

end PQ_CR_CARGAREFINANCIADOS;
/

create or replace package body PQ_CR_CARGAREFINANCIADOS is

  procedure sp_Cr_cargaAQPB175 is
  
    cursor lista_aqpb175a is
      select *
        from aqpb175a a
       where a.aqpb175afecha =
             (select max(s.aqpb175afecha) from aqpb175a s);
  
    ln_estado        number := 999;
    ln_ContEst       number := 0;
    ln_ContRC        number := 0;
    ln_ContReg       number := 0;
    ln_GrupoVignt    number := 0;
    lc_TieneRefVuelo varchar2(5) := 'N';
    ln_InsVuelo      number := 0;
    ln_ContRegS      number := 0;
    ln_ContRegP      number := 0;
    lc_ListaRC       VARCHAR2(5) := 'NO';
    lc_TieneIV       VARCHAR2(5) := 'NO';
    ld_MaxFch175A    date;
  
  begin
  
    begin
      select max(s.aqpb175afecha) into ld_MaxFch175A from aqpb175a s;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpb175a a
         set a.aqpb175aestr = 'N'
       where a.aqpb175afecha < ld_MaxFch175A;
      commit;
    end;
  
    for l in lista_aqpb175a loop
    
      begin
        select count(*)
          into ln_ContReg
          from aqpb175 a
         where a.aqpb175empr = l.aqpb175aemp
           and a.aqpb175modr = l.aqpb175amod
           and a.aqpb175sucr = l.aqpb175asuc
           and a.aqpb175mdar = l.aqpb175amda
           and a.aqpb175papr = l.aqpb175apap
           and a.aqpb175ctar = l.aqpb175acta
           and a.aqpb175oper = l.aqpb175aope
           and a.aqpb175subpr = l.aqpb175asubp
           and a.aqpb175toper = l.aqpb175atope
           and a.aqpb175est in ('S', 'P');
      exception
        when others then
          ln_ContReg := 0;
      end;
    
      if ln_ContReg > 0 then
      
        begin
          select count(*)
            into ln_ContRegS
            from aqpb175 a
           where a.aqpb175empr = l.aqpb175aemp
             and a.aqpb175modr = l.aqpb175amod
             and a.aqpb175sucr = l.aqpb175asuc
             and a.aqpb175mdar = l.aqpb175amda
             and a.aqpb175papr = l.aqpb175apap
             and a.aqpb175ctar = l.aqpb175acta
             and a.aqpb175oper = l.aqpb175aope
             and a.aqpb175subpr = l.aqpb175asubp
             and a.aqpb175toper = l.aqpb175atope
             and a.aqpb175est = 'S';
        exception
          when others then
            ln_ContReg := 0;
        end;
      
        begin
          select count(*)
            into ln_ContRegP
            from aqpb175 a
           where a.aqpb175empr = l.aqpb175aemp
             and a.aqpb175modr = l.aqpb175amod
             and a.aqpb175sucr = l.aqpb175asuc
             and a.aqpb175mdar = l.aqpb175amda
             and a.aqpb175papr = l.aqpb175apap
             and a.aqpb175ctar = l.aqpb175acta
             and a.aqpb175oper = l.aqpb175aope
             and a.aqpb175subpr = l.aqpb175asubp
             and a.aqpb175toper = l.aqpb175atope
             and a.aqpb175est = 'P';
        exception
          when others then
            ln_ContReg := 0;
        end;
      
        if ln_ContRegS > 0 then
        
          begin
            select a.aqpb175grupo
              into ln_GrupoVignt
              from aqpb175 a
             where a.aqpb175empr = l.aqpb175aemp
               and a.aqpb175modr = l.aqpb175amod
               and a.aqpb175sucr = l.aqpb175asuc
               and a.aqpb175mdar = l.aqpb175amda
               and a.aqpb175papr = l.aqpb175apap
               and a.aqpb175ctar = l.aqpb175acta
               and a.aqpb175oper = l.aqpb175aope
               and a.aqpb175subpr = l.aqpb175asubp
               and a.aqpb175toper = l.aqpb175atope
               and a.aqpb175est = 'S';
          exception
            when others then
              ln_GrupoVignt := 0;
          end;
        
          if l.aqpb175agrupo <> ln_GrupoVignt then
          
            PQ_CR_CARGAREFINANCIADOS.sp_Cr_VerfRefVuelo(ln_pgcod     => l.aqpb175aemp,
                                                        ln_mod       => l.aqpb175amod,
                                                        ln_suc       => l.aqpb175asuc,
                                                        ln_mda       => l.aqpb175amda,
                                                        ln_pap       => l.aqpb175apap,
                                                        ln_cta       => l.aqpb175acta,
                                                        ln_oper      => l.aqpb175aope,
                                                        lc_RefVuelo  => lc_TieneRefVuelo,
                                                        ln_InstVuelo => ln_InsVuelo);
          
            if ln_InsVuelo > 0 then
            
              SP_CR_CERRAR_INSTANCIA(LN_INS => ln_InsVuelo);
            
            end if;
          
            begin
              update aqpb175 a
                 set a.aqpb175est = 'N'
               where a.aqpb175empr = l.aqpb175aemp
                 and a.aqpb175modr = l.aqpb175amod
                 and a.aqpb175sucr = l.aqpb175asuc
                 and a.aqpb175mdar = l.aqpb175amda
                 and a.aqpb175papr = l.aqpb175apap
                 and a.aqpb175ctar = l.aqpb175acta
                 and a.aqpb175oper = l.aqpb175aope
                 and a.aqpb175subpr = l.aqpb175asubp
                 and a.aqpb175toper = l.aqpb175atope;
              commit;
            end;
          
            begin
              -- Verificamos el estado del credito
              select f.aostat
                into ln_estado
                from fsd010 f
               where f.pgcod = l.aqpb175aemp
                 and f.aomod = l.aqpb175amod
                 and f.aosuc = l.aqpb175asuc
                 and f.aomda = l.aqpb175amda
                 and f.aopap = l.aqpb175apap
                 and f.aocta = l.aqpb175acta
                 and f.aooper = l.aqpb175aope
                 and f.aosbop = l.aqpb175asubp
                 and f.aotope = l.aqpb175atope;
            exception
              when others then
                ln_estado := 999;
            end;
          
            begin
              select count(*)
                into ln_ContEst
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10899
                 and f.tp1corr1 = 127
                 and f.tp1corr2 = 1
                 and f.tp1nro3 = ln_estado;
            exception
              when others then
                null;
            end;
          
            -- verifica si esta en el listado de refinancia caja
            begin
              select count(*)
                into ln_ContRC
                from jaqn870 j
               where j.jaqn870emp = l.aqpb175aemp
                 and j.jaqn870mod = l.aqpb175amod
                 and j.jaqn870suc = l.aqpb175asuc
                 and j.jaqn870mda = l.aqpb175amda
                 and j.jaqn870pap = l.aqpb175apap
                 and j.jaqn870cta = l.aqpb175acta
                 and j.jaqn870ope = l.aqpb175aope
                 and j.jaqn870sbo = l.aqpb175asubp
                 and j.jaqn870top = l.aqpb175atope
                 and j.jaqn870est in ('I', 'X', 'C', 'P');
            exception
              when others then
                null;
            end;
          
            if ln_ContEst > 0 and ln_ContRC = 0 then
            
              PQ_CR_CARGAREFINANCIADOS.sp_Cr_InsertAQPB175(ld_fecha => l.aqpb175afecha,
                                                           ln_pais  => l.aqpb175apais,
                                                           ln_tdoc  => l.aqpb175atdoc,
                                                           lc_ndoc  => l.aqpb175andoc,
                                                           ln_empr  => l.aqpb175aemp,
                                                           ln_modr  => l.aqpb175amod,
                                                           ln_sucr  => l.aqpb175asuc,
                                                           ln_mdar  => l.aqpb175amda,
                                                           ln_papr  => l.aqpb175apap,
                                                           ln_ctar  => l.aqpb175acta,
                                                           ln_oper  => l.aqpb175aope,
                                                           ln_subpr => l.aqpb175asubp,
                                                           ln_toper => l.aqpb175atope,
                                                           ln_grupo => l.aqpb175agrupo);
            
            end if;
          
            if ln_ContRC > 0 then
              lc_ListaRC := 'SI';
            else
              lc_ListaRC := 'NO';
            end if;
          
            IF ln_InsVuelo > 0 then
              lc_TieneIV := 'SI';
            else
              lc_TieneIV := 'NO';
            end if;
          
            begin
              update aqpb175a a
                 set a.aqpb175aestc  = ln_estado,
                     a.aqpb175arefcj = lc_ListaRC,
                     a.aqpb175asolv  = lc_TieneIV,
                     a.aqpb175ainst  = ln_InsVuelo,
                     a.aqpb175aestr  = 'S'
               where a.aqpb175aemp = l.aqpb175aemp
                 and a.aqpb175amod = l.aqpb175amod
                 and a.aqpb175asuc = l.aqpb175asuc
                 and a.aqpb175amda = l.aqpb175amda
                 and a.aqpb175apap = l.aqpb175apap
                 and a.aqpb175acta = l.aqpb175acta
                 and a.aqpb175aope = l.aqpb175aope
                 and a.aqpb175asubp = l.aqpb175asubp
                 and a.aqpb175atope = l.aqpb175atope;
            end;
          
            /*  else
            if l.aqpb175agrupo = ln_GrupoVignt then
              exit;
            end if;*/
          end if;
        
        end if;
      
        /*  if ln_ContRegP > 0 then
          exit;
        end if;*/
      
      else
        if ln_ContReg = 0 then
        
          begin
            -- Verificamos el estado del credito
            select f.aostat
              into ln_estado
              from fsd010 f
             where f.pgcod = l.aqpb175aemp
               and f.aomod = l.aqpb175amod
               and f.aosuc = l.aqpb175asuc
               and f.aomda = l.aqpb175amda
               and f.aopap = l.aqpb175apap
               and f.aocta = l.aqpb175acta
               and f.aooper = l.aqpb175aope
               and f.aosbop = l.aqpb175asubp
               and f.aotope = l.aqpb175atope;
          exception
            when others then
              ln_estado := 999;
          end;
        
          begin
            select count(*)
              into ln_ContEst
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10899
               and f.tp1corr1 = 127
               and f.tp1corr2 = 1
               and f.tp1nro3 = ln_estado;
          exception
            when others then
              null;
          end;
        
          -- verifica si esta en el listado de refinancia caja
          begin
            select count(*)
              into ln_ContRC
              from jaqn870 j
             where j.jaqn870emp = l.aqpb175aemp
               and j.jaqn870mod = l.aqpb175amod
               and j.jaqn870suc = l.aqpb175asuc
               and j.jaqn870mda = l.aqpb175amda
               and j.jaqn870pap = l.aqpb175apap
               and j.jaqn870cta = l.aqpb175acta
               and j.jaqn870ope = l.aqpb175aope
               and j.jaqn870sbo = l.aqpb175asubp
               and j.jaqn870top = l.aqpb175atope
               and j.jaqn870est in ('I', 'X', 'P');
          exception
            when others then
              null;
          end;
        
          if ln_ContEst > 0 and ln_ContRC = 0 then
          
            PQ_CR_CARGAREFINANCIADOS.sp_Cr_InsertAQPB175(ld_fecha => l.aqpb175afecha,
                                                         ln_pais  => l.aqpb175apais,
                                                         ln_tdoc  => l.aqpb175atdoc,
                                                         lc_ndoc  => l.aqpb175andoc,
                                                         ln_empr  => l.aqpb175aemp,
                                                         ln_modr  => l.aqpb175amod,
                                                         ln_sucr  => l.aqpb175asuc,
                                                         ln_mdar  => l.aqpb175amda,
                                                         ln_papr  => l.aqpb175apap,
                                                         ln_ctar  => l.aqpb175acta,
                                                         ln_oper  => l.aqpb175aope,
                                                         ln_subpr => l.aqpb175asubp,
                                                         ln_toper => l.aqpb175atope,
                                                         ln_grupo => l.aqpb175agrupo);
          
          end if;
        
          if ln_ContRC > 0 then
            lc_ListaRC := 'SI';
          else
            lc_ListaRC := 'NO';
          end if;
        
          begin
            update aqpb175a a
               set a.aqpb175aestc  = ln_estado,
                   a.aqpb175arefcj = lc_ListaRC,
                   a.aqpb175asolv  = lc_TieneIV,
                   a.aqpb175ainst  = ln_InsVuelo,
                   a.aqpb175aestr  = 'S'
             where a.aqpb175aemp = l.aqpb175aemp
               and a.aqpb175amod = l.aqpb175amod
               and a.aqpb175asuc = l.aqpb175asuc
               and a.aqpb175amda = l.aqpb175amda
               and a.aqpb175apap = l.aqpb175apap
               and a.aqpb175acta = l.aqpb175acta
               and a.aqpb175aope = l.aqpb175aope
               and a.aqpb175asubp = l.aqpb175asubp
               and a.aqpb175atope = l.aqpb175atope;
          end;
        
        end if;
      end if;
    end loop;
  
  end sp_Cr_cargaAQPB175;
  ----------------------------------------
  procedure sp_Cr_VerfRefVuelo(ln_pgcod     in number,
                               ln_mod       in number,
                               ln_suc       in number,
                               ln_mda       in number,
                               ln_pap       in number,
                               ln_cta       in number,
                               ln_oper      in number,
                               lc_RefVuelo  out varchar2,
                               ln_InstVuelo out number) is
  
    ln_InstVerfca number; --07012020 mpostigoc
  
  begin
  
    lc_RefVuelo  := 'N';
    ln_InstVuelo := 0;
  
    if ln_mod = 117 then
    
      begin
        select max(w.xwfprcins)
          into ln_InstVerfca
          from fsr011 f, xwf700 w
         where f.r1cod = w.xwfempresa
           and f.r1mod = w.xwfmodulo
           and f.r1suc = w.xwfsucursal
           and f.r1mda = w.xwfmoneda
           and f.r1pap = w.xwfpapel
           and f.r1cta = w.xwfcuenta
           and w.xwfcar3 = 'R'
           and f.r2cod = ln_pgcod
           and f.r2mod = ln_mod
           and f.r2suc = ln_suc
           and f.R2MDA = ln_mda
           and f.R2PAP = ln_pap
           and f.r2cta = ln_cta
           and f.r2oper = ln_oper
           and f.relcod = 46;
      exception
        when no_data_found then
          ln_InstVerfca := 0;
      end;
    
      --mpostigoc 20200107 INC2264
      begin
        select 'S'
          into lc_RefVuelo
          from wfwrkitems w, sng001 s
         where w.wfinsprcid = s.sng001inst
           and w.wfinsprcid = ln_InstVerfca
           and s.sng001ori in (3)
           and w.wfitemstsact = 1;
      exception
        when others then
          lc_RefVuelo := 'N';
      end;
    
      if lc_RefVuelo = 'S' then
        ln_InstVuelo := ln_InstVerfca;
      end if;
      --    
    else
    
      begin
        select 'S', s.sng001inst
          into lc_RefVuelo, ln_InstVuelo
          from xwf700 a, sng001 s /*, xwf070 w*/, wfwrkitems x
         where a.xwfempresa = ln_pgcod
           and a.xwfsucursal = ln_suc
           and a.xwfmodulo = ln_mod
           and a.xwfmoneda = ln_mda
           and a.xwfpapel = ln_pap
           and a.xwfcuenta = ln_cta
           and a.xwfoperacion = ln_oper
              -- and a.xwfsubope = ln_sbop10
              -- and a.xwftipope = ln_tope10
           and a.xwfprcins = s.sng001inst
           and s.sng001ori in (3) -- Refinanciaciones, Reprogramaciones
           and s.sng001inst = x.wfinsprcid
           and x.wfitemstsact = 1
           and rownum = 1;
      exception
        when no_data_found then
          lc_RefVuelo := 'N';
      end;
    end if;
  
  end sp_Cr_VerfRefVuelo;
  ------------------------------------------------------------
  procedure sp_Cr_InsertAQPB175(ld_fecha in date,
                                ln_pais  in number,
                                ln_tdoc  in number,
                                lc_ndoc  in varchar2,
                                ln_empr  in number,
                                ln_modr  in number,
                                ln_sucr  in number,
                                ln_mdar  in number,
                                ln_papr  in number,
                                ln_ctar  in number,
                                ln_oper  in number,
                                ln_subpr in number,
                                ln_toper in number,
                                ln_grupo in number) is
  
    ln_cor  number := 0;
    lc_hora varchar2(10);
  
  begin
  
    begin
      select max(a.aqpb175cor)
        into ln_cor
        from aqpb175 a
       where a.aqpb175fecha = ld_fecha;
    exception
      when others then
        null;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb175
        (aqpb175cor,
         aqpb175fecha,
         aqpb175hora,
         aqpb175pais,
         aqpb175tdoc,
         aqpb175ndoc,
         aqpb175empr,
         aqpb175modr,
         aqpb175sucr,
         aqpb175mdar,
         aqpb175papr,
         aqpb175ctar,
         aqpb175oper,
         aqpb175subpr,
         aqpb175toper,
         aqpb175grupo,
         aqpb175est)
      values
        (ln_cor + 1,
         ld_fecha,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_empr,
         ln_modr,
         ln_sucr,
         ln_mdar,
         ln_papr,
         ln_ctar,
         ln_oper,
         ln_subpr,
         ln_toper,
         ln_grupo,
         'S');
      commit;
    end;
  
  end;

end PQ_CR_CARGAREFINANCIADOS;
/

