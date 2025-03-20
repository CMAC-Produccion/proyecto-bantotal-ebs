create or replace package PQ_CR_HIPOTECARIO_VEHICULAR is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_PRODUCTIVIDAD_2016
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :  12/02/2024
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se modifico la formula del ratio Consumo Ingreso Neto
  -- Fecha de Modificación      :  24/02/2024
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se modifico los conceptos de descuentos dolares para ingreso neto  
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_entidades_Tit(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pn_nument out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_entidades_Cyg(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pn_nument out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Entidades(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in varchar2,
                            pn_nument out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_DesemParcial(pn_instancia in number,
                               pc_indicador out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cuo_IngNeto(pd_fecpro    in date,
                              pn_instancia in number,
                              pn_porcuo    out number);
  ----------------------------------------------------------------------------------
  procedure sp_cr_InsertLogJAQZ834(ln_pais       in number,
                                   ln_tdoc       in number,
                                   lc_ndoc       in varchar2,
                                   ln_tipcamb    in number,
                                   ld_fecpro     in date,
                                   ln_instancia  in number,
                                   ln_NroEva     in number,
                                   ln_capcaja    in number,
                                   ln_mtoingneto in number,
                                   ln_rathipot   in number,
                                   lc_Indc       in varchar2,
                                   ln_CuotPotnc  in number,
                                   ln_CuotContg  in number,
                                   ln_DIfis      in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Eva_Excedente(pn_instancia in number,
                                pn_MtoExc    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Eva_IngNeto(pn_instancia in number, pn_MtoIng out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cuo_Excedente(pd_fecpro    in date,
                                pn_instancia in number,
                                pn_porcuo    out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                ln_MntCuoCntgCF out number);
  ------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  ln_MntCuoCntgAval out number);

end PQ_CR_HIPOTECARIO_VEHICULAR;
/

create or replace package body PQ_CR_HIPOTECARIO_VEHICULAR is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_HIPOTECARIO_VEHICULAR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 
  -- Autor de Creación          : DCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 2017.08.09 DCASTRO Se modifico sp_cr_entidades_Tit
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_entidades_Tit(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pn_nument out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Tit
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : ENTIDADES ENDEUDADAS EXCLUYE TARJETAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 2017.08.09 Se agrego condicion para excluir todas lineas credito.
    -- *****************************************************************
    ld_fecrcc   date;
    ld_fecdes   date;
    ln_mes      number(10);
    ln_count    number(10);
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
    lc_numdoc   varchar(12);
    lc_docide   varchar(12);
    lc_codsbs   varchar(12);
    ln_nument   number(4);
    ln_numlin   number(4);
  
    ln_TipCedIdent number;
  
  begin
  
    ln_TipoDni     := 21;
    ln_TipoRuc     := 9;
    ln_TipoCex     := 2;
    ln_TipCedIdent := 10; -- MPOSTIGOC 29.06.2021
  
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from Fst098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    if pn_tipdoc = ln_TipoDni or pn_tipdoc <> ln_TipoRuc then
      If pn_tipdoc = ln_TipoDni then
        lc_C_TDOCID := '1';
      End If;
      If pn_tipdoc = ln_tipocex or pn_tipdoc = ln_TipCedIdent then
        lc_C_TDOCID := '2';
      End If;
      If pn_tipdoc <> ln_tipodni And pn_tipdoc <> ln_tiporuc and
         lc_C_TDOCID is null then
        --lc_C_TDOCID := to_char(pn_tipdoc);
        ---2023.08.21 dcastro se modifico
        if pn_tipdoc > 10 then
          begin
            select f.tp1nro2
              into lc_C_TDOCID
              from fst198 f
             where f.tp1cod = 1
               and Tp1cod1 = 11111
               and tp1corr1 = 1
               and tp1corr2 = 5
               and tp1nro1 = pn_tipdoc; -- guia de equivalencia de tipo de doc con la rcc
          exception
            when others then
              lc_C_TDOCID := null;
          end;
        else
          lc_C_TDOCID := to_char(pn_tipdoc);
        end if;
        --2023.08.21 dcastro se modifico
      
      End If;
    
      lc_docide := trim(pc_numdoc);
    
      If pn_tipdoc = ln_tiporuc then
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_DOCTRI = lc_docide
             and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      Else
      
        begin
          select a.C_CODSBS
            into lc_codsbs
            from CLDRCCI a
           Where C_TDOCID = lc_C_TDOCID
             and C_DOCIDE = lc_docide
             and D_FECPRE = ld_fecrcc
             and rownum = 1;
        exception
          when no_data_found then
            lc_codsbs := null;
        end;
      
      End If;
    
      if lc_codsbs is not null then
      
        begin
          select count(distinct C_CODEMP)
            into ln_nument
            from CLDRCCS a
           Where C_CODSBS = lc_codsbs
             and D_FECPRE = ld_fecrcc
             and substr(c_cuenta, 1, 4) not in
                 ('1418', '1428', '1419', '1429')
             and (substr(c_cuenta, 1, 4) not in
                 ('7215', '7225', '8119', '8129') and
                 (substr(c_cuenta, 1, 2) = '14' and
                 substr(c_cuenta, 7, 2) not in ('02', '19')));
        exception
          when no_data_found then
            ln_nument := 0;
        end;
      
        pn_nument := ln_nument;
      else
        pn_nument := 0;
      end if;
    
    end if;
  
  end sp_cr_entidades_Tit;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_entidades_Cyg(pn_pais   in number,
                                pn_tipdoc in number,
                                pc_numdoc in char,
                                pn_nument out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_entidades_Cyg
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : ENTIDADES ENDEUDADAS EXCLUYE TARJETAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecrcc   date;
    ld_fecdes   date;
    ln_mes      number(10);
    ln_count    number(10);
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
  
    lc_docide varchar(12);
    lc_codsbs varchar(12);
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);
  
    ln_nument number(4);
    ln_numlin number(4);
  
  begin
  
    lc_docide := rpad(pc_numdoc, 12, ' ');
  
    begin
      select b.rppais, b.rptdoc, b.rpndoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from fsr002 b
       where b.pepais = pn_pais
         and b.petdoc = pn_tipdoc
         and b.pendoc = lc_docide
         and b.rpccyg = 66;
    
    exception
      when others then
        lc_numdoc := null;
    end;
  
    if lc_numdoc is not null then
    
      begin
      
        pq_cr_hipotecario_vehicular.sp_cr_entidades_tit(pn_pais   => ln_pais,
                                                        pn_tipdoc => ln_tipdoc,
                                                        pc_numdoc => lc_numdoc,
                                                        pn_nument => pn_nument);
      end;
    
    else
      pn_nument := 0;
    
    end if;
  
  end sp_cr_entidades_Cyg;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Entidades(pn_pais   in number,
                            pn_tipdoc in number,
                            pc_numdoc in varchar2,
                            pn_nument out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Entidades
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : TOTAL ENTIDADES RCC CONYUGE Y TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
    ld_fecrcc   date;
    ld_fecdes   date;
    ln_mes      number(10);
    ln_count    number(10);
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
  
    lc_docide varchar(12);
    lc_codsbs varchar(12);
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc varchar(12);
    ln_canTit number := 0;
    ln_canCyg number := 0;
  
  begin
  
    ln_pais   := pn_pais;
    ln_tipdoc := pn_tipdoc;
    lc_numdoc := pc_numdoc;
  
    begin
      pq_cr_hipotecario_vehicular.sp_cr_entidades_tit(pn_pais   => ln_pais,
                                                      pn_tipdoc => ln_tipdoc,
                                                      pc_numdoc => lc_numdoc,
                                                      pn_nument => ln_canTit);
    end;
  
    begin
      pq_cr_hipotecario_vehicular.sp_cr_entidades_Cyg(pn_pais   => ln_pais,
                                                      pn_tipdoc => ln_tipdoc,
                                                      pc_numdoc => lc_numdoc,
                                                      pn_nument => ln_canCyg);
    end;
  
    pn_nument := ln_canTit + ln_canCyg;
  
  end sp_cr_Entidades;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_DesemParcial(pn_instancia in number,
                               pc_indicador out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_DesemParcial
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : TOTAL ENTIDADES RCC CONYUGE Y TITULAR
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    cursor parciales is
      select s.sng002mon Monto
        from sng002 s
       where s.sng001inst = pn_instancia;
  
    ln_mtomin    number := 0;
    ln_mtomax    number := 0;
    ln_maxdes    number := 0;
    ln_mindes    number := 0;
    ln_totdes    number := 0;
    ln_pordes    number := 0;
    ln_pordesMax number := 0;
    ln_pordesMin number := 0;
    lc_indicador char(1);
    ln_ctacli    number;
  
  begin
  
    begin
      select max(s.sng002mon), min(s.sng002mon), sum(s.sng002mon)
        into ln_maxdes, ln_mindes, ln_totdes
        from sng002 s
       where s.sng001inst = pn_instancia;
    exception
      when others then
        ln_maxdes := 0;
        ln_totdes := 0;
        ln_mindes := 0;
    end;
  
    lc_indicador := 'N';
  
    for i in parciales loop
    
      ln_pordes := round((i.Monto * 100) / ln_totdes, 2);
    
      if ln_pordes >= ln_mtomin and ln_pordes <= ln_mtomax then
        lc_indicador := 'S';
      else
        lc_indicador := 'N';
        exit;
      end if;
    
    end loop;
  
    pc_indicador := lc_indicador;
  
  end sp_cr_DesemParcial;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cuo_IngNeto(pd_fecpro    in date,
                              pn_instancia in number,
                              pn_porcuo    out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Cuo_IngNeto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Cuotas/Ingreso Neto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_ctacli number;
  
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc char(12);
  
    ln_captotcaja    number(17, 2);
    ln_saldo_externo number(17, 2);
    ln_resultneto    number(17, 2);
    ln_captotal      number(17, 2);
    ln_tipcam        number(14, 8);
    ln_mtoing        number(17, 2);
    lc_prgm          varchar2(8);
    cont             number := 0;
  
    ln_DeudaIFIS      number(17, 2) := 0.00;
    ln_MntPotncial    number(17, 2) := 0.00;
    ln_MntCuoCntgCF   number(17, 2) := 0.00;
    ln_MntCuoCntgAval number(17, 2) := 0.00;
    ln_MntCuoCntg     number(17, 2) := 0.00;
    lc_Indc           VARCHAR2(5);
    ln_NroEva         number;
    saldo_extDol      number(17, 2) := 0.00;
    saldo_extSoles    number(17, 2) := 0.00;
  
  begin
  
    --lc_docide := rpad(pc_numdoc, 12,' ');
  
    begin
      select distinct SNG001cta
        into ln_ctacli
        from sng001
       Where SNG001Inst = pn_instancia;
    exception
      when others then
        ln_ctacli := null;
    end;
    begin
      select s.sng021eval
        into ln_NroEva
        from sng021 s
       where s.sng021sol = pn_instancia;
    exception
      when others then
        ln_NroEva := 0;
      
    end;
  
    begin
      select pepais, petdoc, pendoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from FSR008
       Where Ctnro = ln_ctacli
         and Ttcod = 1
         and Cttfir = 'T';
    exception
      when others then
        ln_pais   := null;
        ln_tipdoc := null;
        lc_numdoc := null;
    end;
  
    begin
      select SNG120TCbi
        into ln_tipcam
        from sng120
       where SNG120Ins = pn_instancia
         and SNG120Tsk = 'EVALUACION';
    exception
      --mod@abr 20170228
      when no_data_found then
        begin
          select SNG120TCbi
            into ln_tipcam
            from sng120
           where SNG120Ins = pn_instancia
             and SNG120Tsk like 'EVAL%';
        exception
          when others then
            null;
        end;
      when others then
        null;
        --mod@abr 20170228
    end;
  
    lc_prgm := 'RJAQZ455';
  
    begin
      pq_cr_resolutor_cappago.sp_cuentaship(ln_pepais     => ln_pais,
                                            ln_petdoc     => ln_tipdoc,
                                            ln_pendoc     => lc_numdoc,
                                            tipocambio    => ln_tipcam, -- De la solicitud
                                            instancia     => pn_instancia,
                                            pd_fecpro     => pd_fecpro,
                                            lc_prgm       => lc_prgm,
                                            ln_captotcaja => ln_captotcaja, -- deuda en la caja A
                                            saldo_externo => ln_saldo_externo, -- Deuda en el sistema financiero sin considerar la caja B
                                            resultneto    => ln_resultneto, -- C
                                            ln_captotal   => ln_captotal); -- (A+B)/(B+C)
      cont := cont + 1;
    end;
  
    if cont = 1 and ln_captotcaja = 0 then
      pq_cr_resolutor_cappago.sp_cuentas(ln_pepais     => ln_pais,
                                         ln_petdoc     => ln_tipdoc,
                                         ln_pendoc     => lc_numdoc,
                                         tipocambio    => ln_tipcam, -- De la solicitud
                                         instancia     => pn_instancia,
                                         pd_fecpro     => pd_fecpro,
                                         lc_prgm       => lc_prgm,
                                         ln_captotcaja => ln_captotcaja, -- deuda en la caja A
                                         saldo_externo => ln_saldo_externo, -- Deuda en el sistema financiero sin considerar la caja B
                                         resultneto    => ln_resultneto, -- C
                                         ln_captotal   => ln_captotal); -- (A+B)/(B+C)
    
    end if;
  
    ln_captotcaja := nvl(ln_captotcaja, 0);
  
    -- Deuda IFIS  
    begin
      begin
      
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extSoles
            from JAQZ862 j
           where j.JAQZ862inst = pn_instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.jaqz862cent <> '00104'
             and j.JAQZ862tcre in
                 ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
             and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extSoles := 0;
        end;
      
        begin
          begin
            select sum(j.JAQZ862gfin)
              into saldo_extDol
              from JAQZ862 j
             where j.JAQZ862inst = pn_instancia
               and j.JAQZ862esta = 'S'
               and j.JAQZ862chek = '1'
               and j.jaqz862cent <> '00104'
               and j.JAQZ862tcre in
                   ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
               and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
          exception
            when others then
              saldo_extDol := 0;
          end;
        
          saldo_extDol := nvl(saldo_extDol, 0) * ln_tipcam;
        
        end;
      
        ln_DeudaIFIS := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
      end;
    end;
    -------
  
    ln_DeudaIFIS := nvl(ln_DeudaIFIS, 0);
  
    -- Cuota Potencial
    begin
      select sum(j.jaqz862cptn)
        into ln_MntPotncial
        from jaqz862 j
       where j.jaqz862inst = pn_instancia
         and j.jaqz862esta = 'S'
         and j.jaqz862chek = '1'
         and j.jaqz862flin = 'L';
    exception
      when others then
        ln_MntPotncial := 0;
    end;
  
    ln_MntPotncial := nvl(ln_MntPotncial, 0);
    ---------------------
  
    ------- Cuota Contingente ------------
    begin
      -- Cuota Contingente PRY1527 
      pq_cr_hipotecario_vehicular.sp_cr_CuotaContinCF(pn_instancia,
                                                      ln_MntCuoCntgCF);
    
      pq_cr_hipotecario_vehicular.sp_cr_CuotaContinAval(pn_instancia,
                                                        ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
      ln_MntCuoCntg := nvl(ln_MntCuoCntg, 0);
    end;
    --------------------------------------------------
  
    begin
      pq_cr_hipotecario_vehicular.sp_cr_eva_ingneto(pn_instancia => pn_instancia,
                                                    pn_mtoing    => ln_mtoing);
    end;
  
    --mod@abr 20170228
    --PRY6876 MPOSTIGOC 20240212
    if nvl(ln_mtoing, 0) = 0 then
      pn_porcuo := 0;
    else
      pn_porcuo := round(((ln_captotcaja + ln_DeudaIFIS + ln_MntPotncial +
                         ln_MntCuoCntg) / nvl(ln_mtoing, 0)),
                         6);
    end if;
    --mod@abr 20170228  
  
    lc_Indc := 'CI';
    if ln_pais > 0 then
      begin
        -- mpostigoc 10/10/18 guarda log cabecera
        pq_cr_hipotecario_vehicular.sp_cr_InsertLogJAQZ834(ln_pais,
                                                           ln_tipdoc,
                                                           lc_numdoc,
                                                           ln_tipcam,
                                                           pd_fecpro,
                                                           pn_instancia,
                                                           ln_NroEva,
                                                           ln_captotcaja,
                                                           ln_mtoing,
                                                           pn_porcuo,
                                                           lc_Indc,
                                                           ln_MntPotncial,
                                                           ln_MntCuoCntg,
                                                           ln_DeudaIFIS);
      end;
    end if;
  
  end sp_cr_Cuo_IngNeto;
  -----------------------------------------------------------------------------------------
  procedure sp_cr_InsertLogJAQZ834(ln_pais       in number,
                                   ln_tdoc       in number,
                                   lc_ndoc       in varchar2,
                                   ln_tipcamb    in number,
                                   ld_fecpro     in date,
                                   ln_instancia  in number,
                                   ln_NroEva     in number,
                                   ln_capcaja    in number,
                                   ln_mtoingneto in number,
                                   ln_rathipot   in number,
                                   lc_Indc       in varchar2,
                                   ln_CuotPotnc  in number,
                                   ln_CuotContg  in number,
                                   ln_DIfis      in number) is
  
    lc_hora    char(8) := '00:00:00';
    ln_corr    number := 0;
    lc_Usuario varchar2(15);
  begin
  
    begin
      update jaqz834 j
         set j.jaqz834est = 'I'
       where j.jaqz834inst = ln_instancia
         and j.jaqz834est = 'H';
      commit;
    end;
  
    begin
      select max(j.jaqz834corr)
        into ln_corr
        from jaqz834 j
       where j.jaqz834fec = ld_fecpro
         and j.jaqz834inst = ln_instancia
         and j.jaqz834ind = 'H';
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod)
        into lc_Usuario
        from wfwrkitems w
       where w.wfinsprcid = ln_instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      insert into jaqz834
        (jaqz834corr,
         jaqz834pais,
         jaqz834tdoc,
         jaqz834ndoc,
         jaqz834tcamb,
         jaqz834inst,
         jaqz834fec,
         jaqz834capcaja,
         jaqz834nroeval,
         jaqz834ingnet,
         jaqz834ratio,
         jaqz834ind,
         jaqz834est,
         jaqz834hora,
         jaqz834user,
         jaqz834cpont,
         jaqz834ccont,
         jaqz834difis)
      values
        (ln_corr + 1,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_tipcamb,
         ln_instancia,
         ld_fecpro,
         ln_capcaja,
         ln_NroEva,
         ln_mtoingneto,
         ln_rathipot,
         lc_Indc, --Hipotecario
         'H',
         lc_hora,
         lc_Usuario,
         ln_CuotPotnc,
         ln_CuotContg,
         ln_DIfis);
      commit;
    
    end;
  
  end sp_cr_InsertLogJAQZ834;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Eva_IngNeto(pn_instancia in number, pn_MtoIng out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Eva_IngNeto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Cuotas/Ingreso Neto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
    /*}
    INGRESO CONSUM SOLES 
    sum(case when sng026cod in (5, 6, 7, 8) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
    group by sng021eval
    
    INGRESO CONSUM DÓLAR
    sum(case when sng026cod in (505, 506, 507, 508) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval  = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512)
    group by sng021eval
    
    TIPO_CAMBIO_EVAL
    case when SNG120TCBI = 0 THEN 1 else SNG120TCBI end
    SNG120 WHERE SNG120TSK = 'EVALUACION' AND SNG120INS = @INSTANCIA
    
    
    */
  
    ln_IngEgreSol number(17, 2);
    ln_IngEgreDol number(17, 2);
  
  Begin
  
    begin
      select sum(case
                   when sng026cod in (5, 6, 7, 8) then
                    sng023mto * -1
                   else
                    sng023mto
                 end)
        into ln_IngEgreSol
        from SNG023 s, sng021 t
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
       group by s.sng021eval;
    exception
      when others then
        ln_IngEgreSol := 0;
    end;
  
    begin
      select sum(case
                   when sng026cod in (505, 506, 507, 508) then
                    sng023mto * -1
                   else
                    sng023mto
                 end) * u.SNG120TCBI
        into ln_IngEgreDol
        from SNG023 s, sng021 t, sng120 u
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN
             (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512) --antes estaba con estos valores (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) pero estos conceptos son soles
         and u.SNG120TSK = 'EVALUACION'
         and t.sng021sol = SNG120INS
       group by t.sng021eval, u.SNG120TCBI;
    exception
      when others then
        ln_IngEgreDol := 0;
    end;
  
    pn_MtoIng := ln_IngEgreSol + ln_IngEgreDol;
  
  end sp_cr_Eva_IngNeto;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Eva_Excedente(pn_instancia in number,
                                pn_MtoExc    out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Eva_Excedente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Cuotas/Ingreso Neto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
    /*}
    INGRESO CONSUM SOLES 
    sum(case when sng026cod in (5, 6, 7, 8) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
    group by sng021eval
    
    INGRESO CONSUM DÓLAR
    sum(case when sng026cod in (505, 506, 507, 508) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval  = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512)
    group by sng021eval
    
    TIPO_CAMBIO_EVAL
    case when SNG120TCBI = 0 THEN 1 else SNG120TCBI end
    SNG120 WHERE SNG120TSK = 'EVALUACION' AND SNG120INS = @INSTANCIA
    
    
    */
  
    ln_IngEgreSol number(17, 2);
    ln_IngEgreDol number(17, 2);
  
  Begin
  
    begin
      select sum(case
                   when sng026cod in
                        (5, 6, 7, 8, 13, 14, 15, 16, 17, 18, 19, 20) then
                    sng023mto * -1
                   else
                    sng023mto
                 end)
        into ln_IngEgreSol
        from SNG023 s, sng021 t
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN (1,
                             2,
                             3,
                             4,
                             5,
                             6,
                             7,
                             8,
                             9,
                             10,
                             11,
                             12,
                             13,
                             14,
                             15,
                             16,
                             17,
                             18,
                             19,
                             20)
       group by s.sng021eval;
    exception
      when others then
        ln_IngEgreSol := 0;
    end;
  
    begin
      select sum(case
                   when sng026cod in
                        (5, 6, 7, 8, 13, 14, 15, 16, 17, 18, 19, 20) then
                    sng023mto * -1
                   else
                    sng023mto
                 end) * u.SNG120TCBI
        into ln_IngEgreDol
        from SNG023 s, sng021 t, sng120 u
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN (1,
                             2,
                             3,
                             4,
                             5,
                             6,
                             7,
                             8,
                             9,
                             10,
                             11,
                             12,
                             13,
                             14,
                             15,
                             16,
                             17,
                             18,
                             19,
                             20)
         and u.SNG120TSK = 'EVALUACION'
         and t.sng021sol = SNG120INS
       group by t.sng021eval, u.SNG120TCBI;
    exception
      when others then
        ln_IngEgreDol := 0;
    end;
  
    pn_MtoExc := ln_IngEgreSol + ln_IngEgreDol;
  
  end sp_cr_Eva_Excedente;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Cuo_Excedente(pd_fecpro    in date,
                                pn_instancia in number,
                                pn_porcuo    out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Cuo_Excedente
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : DCASTRO
    -- Uso                        : Cuotas/Ingreso Neto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    -- *****************************************************************
  
    ln_ctacli number;
  
    ln_pais   number(3);
    ln_tipdoc number(2);
    lc_numdoc char(12);
  
    ln_captotcaja    number(17, 2);
    ln_saldo_externo number(17, 2);
    ln_ExcdntMensual number(17, 2);
    ln_captotal      number(17, 2);
    ln_tipcam        number(14, 8);
  
    ln_mtoexc number(17, 2);
    lc_prgm   varchar2(8);
  
  begin
  
    --lc_docide := rpad(pc_numdoc, 12,' ');
  
    begin
      select distinct SNG001cta
        into ln_ctacli
        from sng001
       Where SNG001Inst = pn_instancia;
    exception
      when others then
        ln_ctacli := null;
    end;
  
    begin
      select pepais, petdoc, pendoc
        into ln_pais, ln_tipdoc, lc_numdoc
        from FSR008
       Where Ctnro = ln_ctacli
         and Ttcod = 1
         and Cttfir = 'T';
    exception
      when others then
        ln_pais   := null;
        ln_tipdoc := null;
        lc_numdoc := null;
    end;
  
    begin
      select SNG120TCbi
        into ln_tipcam
        from sng120
       where SNG120Ins = pn_instancia
         and SNG120Tsk = 'EVALUACION';
    exception
      --mod@abr 20170228
      when no_data_found then
        begin
          select SNG120TCbi
            into ln_tipcam
            from sng120
           where SNG120Ins = pn_instancia
             and SNG120Tsk like 'EVAL%';
        exception
          when others then
            null;
        end;
      when others then
        null;
        --mod@abr 20170228
    end;
  
    begin
      -- mpostigoc 19/10/2017
      lc_prgm := 'RJAQZ';
    
      PQ_CR_RATIO_CUOCNSM.sp_cuentas_hip(ln_pepais        => ln_pais,
                                         ln_petdoc        => ln_tipdoc,
                                         ln_pendoc        => lc_numdoc,
                                         tipocambio       => ln_tipcam, -- De la solicitud
                                         instancia        => pn_instancia,
                                         pd_fecpro        => pd_fecpro,
                                         lc_prgm          => lc_prgm,
                                         ln_captotcaja    => ln_captotcaja, -- deuda en la caja A
                                         saldo_externo    => ln_saldo_externo, -- Deuda en el sistema financiero sin considerar la caja B
                                         ln_ExcdntMensual => ln_ExcdntMensual, -- C
                                         ln_RatioConsumo  => pn_porcuo); -- (A+B)/(B+C)
    end;
  
    -- mpostigoc 19/10/2017
    /*begin
      pq_cr_resolutor_cappago.sp_cuentas(ln_pepais     => ln_pais,
                                         ln_petdoc     => ln_tipdoc,
                                         ln_pendoc     => lc_numdoc,
                                         tipocambio    => ln_tipcam, -- De la solicitud
                                         instancia     => pn_instancia,
                                         pd_fecpro     => pd_fecpro,
                                         lc_prgm       => lc_prgm,
                                         ln_captotcaja => ln_captotcaja, -- deuda en la caja A
                                         saldo_externo => ln_saldo_externo, -- Deuda en el sistema financiero sin considerar la caja B
                                         resultneto    => ln_resultneto, -- C
                                         ln_captotal   => ln_captotal); -- (A+B)/(B+C)
    end;
    
    begin
      pq_cr_hipotecario_vehicular.sp_cr_eva_excedente(pn_instancia => pn_instancia,
                                                      pn_mtoexc    => ln_mtoexc);
    end;
    
    --pn_porcuo :=  round((ln_captotcaja / ln_mtoexc),2); --mod@abr 20170228
    --mod@abr 20170228
    if nvl(ln_mtoexc, 0) = 0 then
      pn_porcuo := 0;
    else
      pn_porcuo := round((nvl(ln_captotcaja, 0) / nvl(ln_mtoexc, 0)), 2);
    end if;
    --mod@abr 20170228  */
  
  end sp_cr_Cuo_Excedente;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
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
    lc_Usuario     varchar2(10);
    --pd_fecpro      date;
    ln_Tarea  number;
    ln_moneda number;
  
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
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
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
  
    /* begin
        select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
      end;
    */
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
      
        ln_CuotCntgAux  := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
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
      
        ln_CuotCntgAux  := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
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
    lc_Usuario     varchar2(10);
    --pd_fecpro      date;
    ln_Tarea     number;
    ln_moneda    number;
    lc_verfamp   varchar2(2) := 'N';
    lc_vrfrefrep varchar2(2) := 'N';
    lc_verfvinc  varchar2(2) := 'N';
    ln_EsConsd   number;
  
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
      -- Usuario que esta procesando la Solicitud MPOSTIGOC 08/11/2017
      select trim(w.wfitemusrcod), w.wftaskcod
        into lc_Usuario, ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
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
  
    /* begin
      select pgfape into pd_fecpro from fst017 f where f.pgcod = 1;
    end;
    */
  
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
        
          ln_CuotCntgAux    := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        end if;
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
      
        ln_CuotCntgAux    := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null then
    
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        begin
          select count(*)
            into ln_EsConsd
            from jaqy142 j
           where j.jaqy142pgcod = l.ln_pgcod10
             and j.jaqy142mod = l.ln_mod10
             and j.jaqy142suc = l.ln_suc10
             and j.jaqy142mda = l.ln_mda10
             and j.jaqy142pap = l.ln_pap10
             and j.jaqy142cta = l.ln_cta10
             and j.jaqy142ope = l.ln_oper10
             and j.jaqy142sbop = l.ln_sbop10
             and j.jaqy142tope = l.ln_tope10
             and j.jaqy142inst = ln_Instancia
             and j.jaqy142est = 'H';
        exception
          when others then
            null;
        end;
      
        if ln_EsConsd = 0 then
        
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
          
            ln_CuotCntgAux    := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
            ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
          end if;
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  end sp_cr_CuotaContinAval;

-----------------------------------------------------------------------------------------------
end PQ_CR_HIPOTECARIO_VEHICULAR;
/

