create or replace package PQ_CR_CONSULTABURO is

  /* ************************************************************************************************************
     -- Nombre                     : 
     -- Sistema                    : BANTOTAL
     -- Módulo                     : CREDITOS
     -- Descripción                : Resolutor informacion Buros
     -- Versión                    : 1.0
     -- Fecha de Creación          : 27/11/2017 08:35:53 p.m.
     -- Autor de Creación          : MPOSTIGOC
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 20/05/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: se adicionó tipo documento en sp_verificarcc
     -- Fecha de Modificación      : 07/06/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: se comentó consulta a buros
     -- Fecha de Modificación      : 12/06/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: se agrego excepcion por creditos convenio
     -- Fecha de Modificación      : 11/07/2019
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: se cambio validacion de rubros
     -- Fecha de Modificación      : 17/02/2020
     -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
     -- Descripción de Modificación: se cambio validacion de rubros
  * *************************************************************************************************************/

  procedure sp_cr_TipoCredito(ln_instancia in number,
                              lc_Verif     out varchar2);
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number);
  procedure sp_cr_VerifBuro2(ln_Instancia     in number,
                             lc_SegmntoActual in number,
                             lc_Verif         out varchar2);
  procedure sp_cr_VerifBuro1(ln_Instancia     in number,
                             lc_SegmntoActual in number,
                             lc_Verif         out varchar2);
  procedure sp_cr_VerificaRCC(ln_Instancia in number,
                              ln_flag      in number,
                              lc_VerifRCC  out varchar2);
  procedure sp_cr_RubroMetSobreend(pv_rubro     in varchar2,
                                   pv_VerifRubr out varchar2);
end PQ_CR_CONSULTABURO;
/

create or replace package body PQ_CR_CONSULTABURO is
  --chernandez 20/05/2019
  --rmontes 2021.03.08 modificaciones rubro 0303 lineas 696.697.699.700
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

  procedure sp_cr_TipoCredito(ln_instancia in number,
                              lc_Verif     out varchar2) is
  
    cursor xwf700 is
      select xwfempresa, XWfModulo, XWfTipOpe, XWfMoneda, XWfPapel
        from xwf700
       where XWFPRCINS = ln_Instancia
         and XWFCar3 = '1';
  
    cursor tip_cred(ln_pgcod in number,
                    ln_mod   in number,
                    ln_tip   in number,
                    ln_mda   in number,
                    ln_pap   in number) is
    
      select Pp028DefC
        from fpp028
       Where Pp028Emp = ln_pgcod
         and Pp028Mod = ln_mod
         and Pp028Top = ln_tip
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp017Par = 115;
  
    ln_TipCred       number;
    lc_VerifIngPanel varchar2(2) := 'N';
    lc_TieneRCC      varchar2(2);
    rubro            varchar2(1);
    lc_SegmntoActual NUMBER;
    ln_flag          number;
    ln_EsSupEmpr     number(5);
  
  begin
    --chernandez 12/06/2019 se cambió el orden y se modificó el llamado a verifica rcc
    PQ_CR_CONSULTABURO.sp_cr_SegmntoActual(ln_Instancia, lc_SegmntoActual);
  
    ln_flag := 1;
    if lc_SegmntoActual = 2 then
      begin
        select 2
          into ln_flag
          from xwf700
         Where XWFPRCINS = ln_Instancia
           and XWFCar3 = '1'
           and XWFMODULO = 107;
      
      exception
        when others then
          ln_flag := 1;
      end;
    else
      if lc_SegmntoActual = 1 then
        -- PRY6415 Mpostigoc 21.08.2023
        begin
          select count(*)
            into ln_EsSupEmpr
            from fst004 f
           where (f.modulo, f.totope) in
                 (select x.xwfmodulo, x.xwftipope
                    from xwf700 x
                   where x.xwfprcins = ln_Instancia
                     and x.xwfcar3 = '1')
             and f.modulo = 103
             and (f.tonom like '%Sup%' or f.tonom like '%Emp%');
        exception
          when others then
            null;
        end;
      
        if ln_EsSupEmpr > 0 then
          ln_flag := 2;
        else
          ln_flag := 1;
        end if;
      end if;
    end if;
  
    PQ_CR_CONSULTABURO.sp_cr_VerificaRCC(ln_instancia,
                                         ln_flag,
                                         lc_TieneRCC);
  
    lc_Verif := 'S';
  
    if lc_TieneRCC = 'S' and lc_SegmntoActual = 2 then
    
      begin
        --- Verifica si se ingreso al Panel Saldo Consumo    
        select 'S'
          into lc_VerifIngPanel
          from jaqz862
         where jaqz862inst = ln_Instancia
           and jaqz862esta = 'S'
           and jaqz862dori = '1'
           and rownum = 1;
      exception
        when no_data_found then
          lc_VerifIngPanel := 'N';
      end;
    
      if lc_VerifIngPanel = 'N' then
        lc_Verif := 'N';
      end if;
    else
      if lc_TieneRCC = 'S' and lc_SegmntoActual = 1 then
        -- mpostigoc 10/10/18 INC1373
        begin
          --- Verifica si se ingreso al Panel Saldo Consumo    
          select 'S'
            into lc_VerifIngPanel
            from jaqy327
           where jaqy327inst = ln_Instancia
             and jaqy327esta = 'S'
             and jaqy327dori = '1'
             and rownum = 1;
        exception
          when no_data_found then
            lc_VerifIngPanel := 'N';
        end;
      
        if lc_VerifIngPanel = 'N' then
          lc_Verif := 'N';
        end if;
      end if;
    end if;
    --chernandez 07/06/2019
    /*if lc_Verif = 'S' then
    
      -- if lc_VerifIngPanel = 'S' then
    
      begin
        for i in xwf700 loop
        
          for j in tip_cred(i.xwfempresa,
                            i.xwfmodulo,
                            i.xwftipope,
                            i.xwfmoneda,
                            i.xwfpapel) loop
          
            rubro      := substr(trim(j.pp028defc), 6, 1);
            ln_TipCred := 1;
            begin
              select 2
                into ln_TipCred
                from fst198
               Where Tp1cod = 1
                 and Tp1cod1 = 10801
                 and Tp1corr1 = 36
                 and Tp1corr2 = 2
                 and Tp1nro2 = to_number(rubro);
            exception
              when others then
                ln_TipCred := 1;
            end;
          
          end loop;
        end loop;
      
        if ln_TipCred = 2 then
          -- Sentinel
        
          PQ_CR_CONSULTABURO.sp_cr_VerifBuro2(ln_instancia,
                                              lc_SegmntoActual,
                                              lc_Verif);
        
        else
          if ln_TipCred = 1 then
            -- Experian
            PQ_CR_CONSULTABURO.sp_cr_VerifBuro1(ln_instancia,
                                                lc_SegmntoActual,
                                                lc_Verif);
          
          end if;
        end if;
      end;
      -- end if;
    end if;*/
  end sp_cr_TipoCredito;
  -------------------------------------------------------------------
  procedure sp_cr_SegmntoActual(ln_Instancia     in number,
                                lc_SegmntoActual out number) is
  
    ln_pais   number;
    ln_tdoc   number;
    lc_nrodoc char(12);
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_nrodoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null; --17072019 mpostigoc
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = lc_nrodoc
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = lc_nrodoc
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = lc_nrodoc
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  
  end sp_cr_SegmntoActual;

  ------------------------------------------------------------
  procedure sp_cr_VerifBuro2(ln_Instancia     in number,
                             lc_SegmntoActual in number,
                             lc_Verif         out varchar2) is
  
    lc_VerifDif  varchar2(2) := 'S';
    ln_flag1     number := 0;
    ln_num       number := 0;
    ln_serialaux number := 0;
    ln_flag      number := 0;
    lc_numdoc    char(12);
  
    cursor documentos is
      select distinct (trim(f.pendoc)) ln_doc, f.petdoc ln_tdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(g.rpndoc)) ln_doc, g.rptdoc ln_tdoc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
      union
      select distinct (trim(g.pendoc)) ln_doc, g.petdoc ln_tdoc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66;
  
  begin
  
    begin
    
      for d in documentos loop
        -- Primero verificamos Sentinel
        ln_flag1     := 0;
        ln_serialaux := null;
        lc_numdoc    := rpad(trim(d.ln_doc), 12, ' ');
        begin
          select max(j.jaqz236serial)
            into ln_serialaux
            from jaqz236 j
           where j.jaqz236tidob = d.ln_tdoc
             and j.jaqz236nudoc = lc_numdoc
             and j.JAQZ236Coerr = '00000';
        exception
          when others then
            ln_serialaux := 0;
        end;
      
        ln_serialaux := nvl(ln_serialaux, 0);
      
        begin
          select count(*)
            into ln_flag1
            from jaqz238 k
           where k.jaqz238serial = ln_serialaux
             and k.JAQZ238TIDET = '18'
             and k.JAQZ238INDBO = '0'
             and k.JAQZ238ESTADO <> '06';
        exception
          when others then
            ln_flag1 := 0;
        end;
      
        ln_flag1 := nvl(ln_flag1, 0);
      
        if ln_flag1 = 0 and ln_serialaux = 0 then
        
          -- Si no hay data para el cliente en Sentinel, verificamos Experian
        
          begin
            select max(j.jaql546serial)
              into ln_serialaux
              from jaql546 j
             where j.jaql546tidob = d.ln_tdoc
               and j.jaql546nudoc = lc_numdoc
               and j.JAQL546Coerr = '00000';
          exception
            when others then
              ln_serialaux := 0;
          end;
        
          ln_serialaux := nvl(ln_serialaux, 0);
        
          begin
            select count(*) ln_num
              into ln_flag1
              from jaql548 h
             where h.jaql546serial = ln_serialaux
               and h.JAQL548Tidet = '18'
               and h.JAQL548indbo = '0'
               and h.JAQL548Estado <> '06';
          end;
        
        end if;
      
        ln_flag1 := nvl(ln_flag1, 0);
      
        ln_flag := ln_flag + ln_flag1;
      
      end loop;
    
    end;
  
    if lc_SegmntoActual = 2 then
      --mpostigoc 10/10/18 INC1373
    
      begin
        select count(*)
          into ln_num
          from jaqz862 j
         where j.jaqz862inst = ln_Instancia
           and j.jaqz862esta = 'S'
           and j.jaqz862dori = '2'; --BURO 
      exception
        when others then
          ln_num := 0;
      end;
    else
      if lc_SegmntoActual = 1 then
        --mpostigoc 10/10/18 INC1373
        begin
          select count(*)
            into ln_num
            from jaqy327 j
           where j.jaqy327inst = ln_Instancia
             and j.jaqy327esta = 'S'
             and j.jaqy327dori = '2'; --BURO 
        exception
          when others then
            ln_num := 0;
        end;
      end if;
    end if;
  
    ln_num := nvl(ln_num, 0);
  
    if ln_flag <> ln_num then
      lc_VerifDif := 'N';
    else
      lc_VerifDif := 'S';
    end if;
  
    lc_Verif := lc_VerifDif;
  
  end sp_cr_VerifBuro2;
  --------------------------------------------------------------------------------------
  procedure sp_cr_VerifBuro1(ln_Instancia     in number,
                             lc_SegmntoActual in number,
                             lc_Verif         out varchar2) is
  
    lc_VerifDif  varchar2(2) := 'S';
    ln_flag1     number := 0;
    ln_flag      number := 0;
    ln_num       number := 0;
    ln_serialaux number := 0;
    lc_numdoc    char(12);
  
    cursor documentos2 is
      select distinct (trim(f.pendoc)) ln_doc, f.petdoc ln_tdoc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct (trim(g.rpndoc)) ln_doc, g.rptdoc ln_tdoc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
      union
      select distinct (trim(g.pendoc)) ln_doc, g.petdoc ln_tdoc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66;
  
  begin
  
    for d2 in documentos2 loop
    
      ln_flag1     := 0;
      ln_serialaux := null;
      lc_numdoc    := rpad(trim(d2.ln_doc), 12, ' ');
    
      begin
        select max(j.jaql546serial)
          into ln_serialaux
          from jaql546 j
         where j.jaql546tidob = d2.ln_tdoc
           and j.jaql546nudoc = lc_numdoc
           and j.JAQL546Coerr = '00000';
      exception
        when others then
          ln_serialaux := 0;
      end;
    
      ln_serialaux := nvl(ln_serialaux, 0);
    
      begin
        select count(*) ln_num
          into ln_flag1
          from jaql548 h
         where h.jaql546serial = ln_serialaux
           and h.JAQL548Tidet = '18'
           and h.JAQL548indbo = '0'
           and h.JAQL548Estado <> '06';
      end;
    
      ln_flag1 := nvl(ln_flag1, 0);
    
      ln_flag := ln_flag + ln_flag1;
    
    end loop;
  
    if lc_SegmntoActual = 2 then
      --mpostigoc 10/10/18 INC1373
    
      begin
        select count(*)
          into ln_num
          from jaqz862 j
         where j.jaqz862inst = ln_Instancia
           and j.jaqz862esta = 'S'
           and j.jaqz862dori = '2'; --BURO  
      exception
        when others then
          null;
      end;
    
    else
      if lc_SegmntoActual = 1 then
        --mpostigoc 10/10/18 INC1373
        begin
          select count(*)
            into ln_num
            from jaqy327 j
           where j.jaqy327inst = ln_Instancia
             and j.jaqy327esta = 'S'
             and j.jaqy327dori = '2'; --BURO  
        exception
          when others then
            null;
        end;
      end if;
    end if;
  
    if ln_flag <> ln_num then
      lc_VerifDif := 'N';
    else
    
      lc_VerifDif := 'S';
    end if;
  
    lc_Verif := lc_VerifDif;
  
  end sp_cr_VerifBuro1;

  ---------------------------------------------------------------------------------------

  procedure sp_cr_VerificaRCC(ln_Instancia in number,
                              ln_flag      in number,
                              lc_VerifRCC  out varchar2) is
    --chernandez 20/05/2019
    cursor CrCldrcci(numdoc varchar2, tipdoc varchar2) is
      select c_codsbs
        from (select c_codsbs
                from cldrcci
               where ((c_tdocid = tipdoc and c_docide = numdoc and
                     c_person = '1') or
                     (c_tdocid = tipdoc and c_docide = numdoc and
                     c_person = '1') or
                     (c_tdoctr = tipdoc and c_doctri = numdoc and
                     c_person = '2'))
               order by d_fecpre desc)
       where rownum = 1;
  
    --chernandez 20/05/2019 se agregó pais y tipo documento
    cursor documentos2 is
      select distinct f.PEPAIS, f.PETDOC, (trim(f.pendoc)) ln_doc
        from fsr008 f
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
      union
      select distinct g.rppais, g.rptdoc, (trim(g.rpndoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
         and 1 = ln_flag
      union
      select distinct g.pepais, g.petdoc, (trim(g.pendoc)) ln_doc
        from fsr008 f, fsr002 g
       where f.ctnro in (select s.sng001cta
                           from sng001 s
                          where s.sng001inst = ln_Instancia)
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66
         and 1 = ln_flag;
  
    cursor lista_CredRCC(ld_FchRCC in date, lc_CodSBS in varchar2) is
      select a.c_cuenta RubroRCC
        from cldrccs a
       where a.d_fecpre = ld_FchRCC
         and a.c_codsbs = lc_CodSBS
         and a.c_codemp <> '00104';
  
    lc_CodSBS   varchar2(10);
    ld_FchRCC   date;
    lc_TieneRCC varchar2(2) := 'N';
    lc_existe_1 varchar2(2) := 'N';
    lc_existe_2 varchar2(2) := 'N';
    lc_existe_3 varchar2(2) := 'N';
    lc_existe_4 varchar2(2) := 'N';
    lc_existe_5 varchar2(2) := 'N';
    ln_tdocequi number;
  
  begin
  
    begin
      --fch RCC
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
  
    for d in documentos2 loop
    
      lc_CodSBS := null;
    
      --chernandez 20/05/2019
      ln_tdocequi := null;
      ln_tdocequi := fn_equivalenviaDoc(d.petdoc);
      for rcc in CrCldrcci(d.ln_doc, ln_tdocequi) loop
        lc_CodSBS := rcc.c_codsbs;
      end loop;
    
      for l in lista_CredRCC(ld_FchRCC, lc_CodSBS) loop
      
        sp_cr_RubroMetSobreend(l.rubrorcc, lc_existe_1);
      
        if lc_existe_1 = 'S' then
          lc_TieneRCC := 'S';
          exit;
        end if;
      
      end loop;
    
      if lc_TieneRCC = 'S' then
        lc_VerifRCC := 'S';
        exit;
      else
        lc_VerifRCC := 'N';
      end if;
    
    end loop;
  
  end sp_cr_VerificaRCC;

  procedure sp_cr_RubroMetSobreend(pv_rubro     in varchar2,
                                   pv_VerifRubr out varchar2) is
  Begin
    pv_VerifRubr := 'N';
    begin
      select 'S'
        into pv_VerifRubr
        from dual
       where REGEXP_LIKE(pv_rubro, '^14.[1-6]0302')
          or REGEXP_LIKE(pv_rubro,
                         '^14.[1-6]020601|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202')
            --chernandez 17/02/2020
          or REGEXP_LIKE(pv_rubro, '^72.506')
          or (REGEXP_LIKE(pv_rubro, '^72.503') and
              not REGEXP_LIKE(pv_rubro, '^72.5030202|^72.5030302'))
          or REGEXP_LIKE(pv_rubro, '^14.[1-6]030602|^14.[1-6]030302') --se agrego rubro 0303
          or (REGEXP_LIKE(pv_rubro, '^14.[1-6]0306|^14.[1-6]0303') and
              not --se agrego rubro 0303
               REGEXP_LIKE(pv_rubro,
                           '^14.[1-6]030602|^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030302|^14.[1-6]030311|^14.[1-6]030312')) --se agrego rubro 0303
          or REGEXP_LIKE(pv_rubro,
                         '^14.[1-6]030611|^14.[1-6]030612|^14.[1-6]030311|^14.[1-6]030312') --se agrego rubro 0303
          or REGEXP_LIKE(pv_rubro, '^14.[1-6]04')
          or (REGEXP_LIKE(pv_rubro, '^14.[1-6]12|^14.[1-6]02|^14.[1-6]13') and not
               REGEXP_LIKE(pv_rubro,
                                                                                            '^14.[1-6]020601|^14.[1-6]0202|^14.[1-6]130601|^14.[1-6]1302|^14.[1-6]120601|^14.[1-6]1202'))
          or REGEXP_LIKE(pv_rubro, '^71.[1-4]');
    exception
      when others then
        pv_VerifRubr := 'N';
    end;
  end sp_cr_RubroMetSobreend;

end PQ_CR_CONSULTABURO;
/

