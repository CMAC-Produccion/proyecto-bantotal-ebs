create or replace package PQ_CR_ENDEUDAMIENTO_RCC_BI is

  -- Author  : CHERNANDEZ
  -- Created : 15/04/2020
  -- Purpose :

  procedure sp_inicio_llena_data(pd_fecha   date,
                                 pn_cuenta  number,
                                 pn_eval    number,
                                 pn_pais    number,
                                 pn_tdoc    number,
                                 pc_ndoc    character,
                                 pv_usuario varchar2,
                                 pn_inst    in out number);
  function fn_cr_nomcli(pn_pais   in number,
                        pn_tdoc   in number,
                        pc_numdoc in char) return character;
  function fn_cr_tipdoc(pn_tdoc in number) return character;
  function fn_cr_rubro(pn_rubro in number) return character;

end PQ_CR_ENDEUDAMIENTO_RCC_BI;
/

create or replace package body PQ_CR_ENDEUDAMIENTO_RCC_BI is

  --CHERNANDEZ 13/04/2020 data entry
  --chernandez 20/04/2020 panel bantotal
  procedure sp_inicio_llena_data(pd_fecha   date,
                                 pn_cuenta  number,
                                 pn_eval    number,
                                 pn_pais    number,
                                 pn_tdoc    number,
                                 pc_ndoc    character,
                                 pv_usuario varchar2,
                                 pn_inst    in out number) is
  
    cursor prestamos is
      select *
        from jaqy327_bdj
       where jaqy327fech = pd_fecha
         --and jaqy327inst = pn_inst
         and jaqy327neva = pn_eval
         and jaqy327esta = 'S'
         and jaqy327dori = '1'
         and jaqy327flin = 'P'
      --and jaqy327ndoc = plc_pendoc
      ;
  
    cursor lineas is
      select *
        from jaqy327_bdj
       where jaqy327fech = pd_fecha
         --and jaqy327inst = pn_inst
         and jaqy327neva = pn_eval
         and jaqy327esta = 'S'
         and jaqy327dori = '1'
         and jaqy327flin = 'L'
      --and jaqy327ndoc = plc_pendoc
      ;
  
    cursor noregulada is
      select *
        from jaqy327_bdj
       where jaqy327fech = pd_fecha
         --and jaqy327inst = pn_inst
         and jaqy327neva = pn_eval
         and jaqy327esta = 'S'
         and jaqy327dori = '2'
      --and jaqy327ndoc = plc_pendoc
      ;
  
    cursor deuingresada is
      select *
        from jaqy327_bdj
       where jaqy327fech = pd_fecha
         --and jaqy327inst = pn_inst
         and jaqy327neva = pn_eval
         and jaqy327esta = 'S'
         and jaqy327dori = '3'
      --and jaqy327ndoc = plc_pendoc
      ;
  
    ld_pgfape date;
    ld_fecrcc date;
    ln_pgcod  numeric(3);
    lc_hora   character(8);
    ln_cont   number(4);
  
    ln_mda    number(3);
    lc_moneda character(1);
    lc_rubro  varchar(20);
  
  begin
  
    ln_pgcod := 1;
    ln_cont  := 0;
    select to_char(sysdate, 'hh24:mi:ss') into lc_hora from dual;
  
    select pgfape into ld_pgfape from fst017 where Pgcod = ln_pgcod;
  
    begin
      --fch RCC
      select to_date(to_char(Tpnro), 'dd/mm/yyyy')
        into ld_fecrcc
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    delete from aqpb004 a
     where /*a.aqpb004inst = pn_inst
       and */a.aqpb004eval = pn_eval
       and a.aqpb004fech = pd_fecha;
    commit;
  
    for b in prestamos loop
      ln_cont   := ln_cont + 1;
      --chernandez 20/04/2020
      /*lc_moneda := b.jaqy327mda;
    
      if lc_moneda = '1' then
        ln_mda := 0;
      else
        ln_mda := 101;
      end if;*/
      ln_mda := b.jaqy327mda;
      lc_rubro := SubStr(b.jaqy327rubr, 1, 13);
    
      insert into aqpb004
        (aqpb004fech,
         aqpb004corr,
         aqpb004hora,
         aqpb004inst,
         aqpb004eval,
         aqpb004esta,
         aqpb004cdeu,
         aqpb004dsctdo,
         aqpb004ndoc,
         aqpb004nomb,
         aqpb004rela,
         aqpb004enti,
         aqpb004rubr,
         aqpb004dsccr,
         aqpb004dsctcr,
         aqpb004sdeu,
         aqpb004cuoest,
         aqpb004gasfin,
         aqpb004facpre,
         aqpb004codent,
         aqpb004moned,
         aqpb004linea,
         aqpb004tipo,
         aqpb004tdoc,
         aqpb004pais)
      values
        (pd_fecha, --ld_pgfape,
         ln_cont,
         lc_hora,
         pn_inst,
         pn_eval,
         b.jaqy327chek,
         b.jaqy327aux4,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_tipdoc(b.jaqy327tdoc),
         trim(b.jaqy327ndoc),
         b.jaqy327pers,
         b.jaqy327rela,
         b.jaqy327enti,
         lc_rubro,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_rubro(to_number(lc_rubro)),
         substr(b.jaqy327tcre, 1, 20), --
         b.jaqy327sdeu,
         b.jaqy327ccalc, --
         b.jaqy327gfin, --
         b.jaqy327fac3, --
         b.jaqy327CENT,
         ln_mda,
         b.jaqy327line,
         '1',
         b.jaqy327tdoc,
         b.jaqy327pais);
    end loop;
  
    for c in lineas loop
    
      ln_cont   := ln_cont + 1;
      --chernandez 20/04/2020
      /*lc_moneda := SubStr(c.jaqy327mda, 3, 1);
    
      if lc_moneda = '1' then
        ln_mda := 0;
      else
        ln_mda := 101;
      end if;*/
      ln_mda := c.jaqy327mda;
      lc_rubro := SubStr(c.jaqy327rubr, 1, 13);
    
      insert into aqpb004
        (aqpb004fech,
         aqpb004corr,
         aqpb004hora,
         aqpb004inst,
         aqpb004eval,
         aqpb004esta,
         aqpb004cdeu,
         aqpb004dsctdo,
         aqpb004ndoc,
         aqpb004nomb,
         aqpb004rela,
         aqpb004enti,
         aqpb004rubr,
         aqpb004dsccr,
         aqpb004dsctcr,
         aqpb004mtou,
         aqpb004mtonu,
         aqpb004cuoest,
         aqpb004gasfin,
         aqpb004cuopot,
         aqpb004facuso,
         aqpb004facnus,
         aqpb004codent,
         aqpb004moned,
         aqpb004linea,
         aqpb004tipo,
         aqpb004tdoc,
         aqpb004pais)
      values
        (pd_fecha, --ld_pgfape,
         ln_cont,
         lc_hora,
         pn_inst,
         pn_eval,
         c.jaqy327chek,
         c.jaqy327aux4,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_tipdoc(c.jaqy327tdoc),
         trim(c.jaqy327ndoc),
         c.jaqy327pers,
         c.jaqy327rela,
         c.jaqy327ENTI,
         lc_rubro,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_rubro(to_number(lc_rubro)),
         substr(c.jaqy327tcre, 1, 20), --
         c.jaqy327util,
         c.jaqy327aux8,
         c.jaqy327ccalc,
         c.jaqy327gfin,
         c.jaqy327cptn,
         c.jaqy327fac1,
         c.jaqy327fac2,
         c.jaqy327cent,
         ln_mda,
         c.jaqy327line,
         '2',
         c.jaqy327tdoc,
         c.jaqy327pais);
    end loop;
    for e in noregulada loop
      ln_cont   := ln_cont + 1;
      --chernandez 20/04/2020
      /*lc_moneda := e.jaqy327mda;
      if lc_moneda = '1' then
        ln_mda := 0;
      else
        ln_mda := 101;
      end if;*/
      ln_mda := e.jaqy327mda;
    
      insert into aqpb004
        (aqpb004fech,
         aqpb004corr,
         aqpb004hora,
         aqpb004inst,
         aqpb004eval,
         aqpb004esta,
         aqpb004cdeu,
         aqpb004dsctdo,
         aqpb004ndoc,
         aqpb004nomb,
         aqpb004rela,
         aqpb004enti,
         aqpb004sdeu,
         aqpb004cuoest,
         aqpb004gasfin,
         aqpb004facpre,
         aqpb004codent,
         aqpb004moned,
         aqpb004linea,
         aqpb004tipo,
         aqpb004tdoc,
         aqpb004pais)
      values
        (pd_fecha, --ld_pgfape,
         ln_cont,
         lc_hora,
         pn_inst,
         pn_eval,
         e.jaqy327chek,
         e.jaqy327aux4,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_tipdoc(e.jaqy327tdoc),
         trim(e.jaqy327ndoc),
         e.jaqy327pers,
         e.jaqy327rela,
         e.jaqy327enti,
         e.jaqy327sdeu,
         e.jaqy327ccalc, --
         e.jaqy327gfin, --
         e.jaqy327fac3, --
         e.jaqy327cent,
         ln_mda,
         e.jaqy327line,
         '3',
         e.jaqy327tdoc,
         e.jaqy327pais);
    
    end loop;
    for g in deuingresada loop
      ln_cont  := ln_cont + 1;
      lc_rubro := SubStr(g.jaqy327rubr, 1, 13);
      insert into aqpb004
        (aqpb004fech,
         aqpb004corr,
         aqpb004hora,
         aqpb004inst,
         aqpb004eval,
         aqpb004esta,
         aqpb004cdeu,
         aqpb004dsctdo,
         aqpb004ndoc,
         aqpb004nomb,
         aqpb004rela,
         aqpb004enti,
         aqpb004rubr,
         aqpb004dsccr,
         aqpb004dsctcr,
         aqpb004sdeu,
         aqpb004mtou,
         aqpb004mtonu,
         aqpb004cuoest,
         aqpb004gasfin,
         aqpb004facpre,
         aqpb004cuopot,
         aqpb004facuso,
         aqpb004facnus,
         aqpb004codent,
         aqpb004moned,
         aqpb004linea,
         aqpb004tipo,
         aqpb004tdoc,
         aqpb004pais)
      values
        (pd_fecha, --ld_pgfape,
         ln_cont,
         lc_hora,
         pn_inst,
         pn_eval,
         g.jaqy327chek,
         g.jaqy327aux4,
         PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_tipdoc(g.jaqy327tdoc),
         trim(g.jaqy327ndoc),
         g.jaqy327pers,
         g.jaqy327rela,
         g.jaqy327enti,
         lc_rubro,
         '',--PQ_CR_ENDEUDAMIENTO_RCC_BI.fn_cr_rubro(to_number(lc_rubro)),--chernandez 20/04/2020
         substr(g.jaqy327tcre, 1, 20),
         g.jaqy327sdeu,
         g.jaqy327util,
         g.jaqy327aux8,
         g.jaqy327ccalc,
         g.jaqy327gfin,
         g.jaqy327fac3,
         g.jaqy327cptn,
         g.jaqy327fac1,
         g.jaqy327fac2,
         g.jaqy327cent,
         g.jaqy327mda,
         g.jaqy327line,
         '4',
         g.jaqy327tdoc,
         g.jaqy327pais);
    end loop;
    commit;
  end sp_inicio_llena_data;

  function fn_cr_nomcli(pn_pais   in number,
                        pn_tdoc   in number,
                        pc_numdoc in char) return character is
    -- *****************************************************************
    -- Nombre                     :
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          :
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    pc_nomcli character(30);
  begin
  
    begin
      select f.penom
        into pc_nomcli
        from fsd001 f
       where f.pepais = pn_pais
         and f.petdoc = pn_tdoc
         and f.pendoc = pc_numdoc;
    exception
      when others then
        pc_nomcli := null;
    end;
    return pc_nomcli;
  end fn_cr_nomcli;
  ---------------------------------------------------------------------------------------------------------

  function fn_cr_tipdoc(pn_tdoc in number) return character is
    -- *****************************************************************
    -- Nombre                     :
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          :
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    pc_tdnom character(20);
  begin
  
    begin
      select f.tdnom into pc_tdnom from fst014 f where f.tdocum = pn_tdoc;
    exception
      when others then
        pc_tdnom := null;
    end;
    return pc_tdnom;
  end fn_cr_tipdoc;
  ---------------------------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------

  function fn_cr_rubro(pn_rubro in number) return character is
    -- *****************************************************************
    -- Nombre                     :
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          :
    -- Autor de Creación          :
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    --
    -- *****************************************************************
    pc_descri character(40);
  begin
  
    begin
      select f.pcnomr
        into pc_descri
        from fsd014 f
       where f.rubro = pn_rubro;
    exception
      when others then
        pc_descri := null;
    end;
    return pc_descri;
  end fn_cr_rubro;
  ---------------------------------------------------------------------------------------------------------

end PQ_CR_ENDEUDAMIENTO_RCC_BI;
/

