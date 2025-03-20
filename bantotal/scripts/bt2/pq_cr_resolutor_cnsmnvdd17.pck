create or replace package PQ_CR_RESOLUTOR_CNSMNVDD17 is

  -- Author  : MPOSTIGOC
  -- Created : 10/10/2017 09:36:09 a.m.
  -- Purpose : 

/* ************************************************************************************************************
    -- Nombre                     : AQPA012
    -- Sistema                    : BANTOTAL
    -- Módulo                     : paquete resolutor 
    -- Descripción                : 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 10/10/2017
    -- Autor de Creación          : MPOSTIGOC
    -- Versión                    : 2.0
    -- Fecha de Modificación      : 22/08/2019
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: 
    --
* *************************************************************************************************************/



  PROCEDURE SP_CR_NROENTIDADESRCC(--ln_instancia       in number, --MOD@ABR 20180719
                                  ln_pais IN NUMBER,--MOD@ABR 20180719
                                  ln_tipdoc IN NUMBER,--MOD@ABR 20180719
                                  ln_nrodoc IN CHAR,--MOD@ABR 20180719
                                  ln_nroentidadesrcc out number);
  ------------------------------------------------------------------
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar);
  ------------------------------------------------------------------
  procedure sp_cr_MoraMaxMicroConsumo(ln_instancia        in number,
                                      ln_MoraMaxMicroCons out number);
  --------------------------------------------------------------------
  procedure sp_cr_PromeAtrasoMax(pn_pai           in number,
                                 pn_tdo           in number,
                                 pc_ndo           in char,
                                 pd_fecpro        in date,
                                 ln_promedio      out number,
                                 ln_MaxPromAtraso out number);
  ---------------------------------------------------------------------
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number;

  --------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea(pn_pai           in number,
                                   pn_tdo           in number,
                                   pc_ndo           in char,
                                   pd_fecpro        in date,
                                   pd_fecini        in date,
                                   ln_contCuoTot    out number,
                                   ln_diaTot        out number,
                                   ln_MaxPromAtraso out number);
  --------------------------------------------------------------------------------                                   
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai           in number,
                                      pn_tdo           in number,
                                      pc_ndo           in char,
                                      pd_fecor         in date,
                                      pd_fecpro        in date, /*pd_fecini in date,*/
                                      ln_contCuoTot    out number,
                                      ln_diaTot        out number,
                                      ln_MaxPromAtraso out number);
  --------------------------------------------------------------------------------                                      
  Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date;
  --------------------------------------------------------------------------------  
  Procedure sp_calculaCuotas(pn_emp           in number,
                             pn_mod           in number,
                             pn_suc           in number,
                             pn_mda           in number,
                             pn_pap           in number,
                             pn_cta           in number,
                             pn_ope           in number,
                             pn_sbo           in number,
                             pn_top           in number,
                             pd_fec           in date,
                             pd_fecor         in date,
                             pn_stat          in number,
                             ln_contador      out number,
                             ln_diasTot       out number,
                             ln_MaxPromAtraso out number);

end PQ_CR_RESOLUTOR_CNSMNVDD17;
/

create or replace package body PQ_CR_RESOLUTOR_CNSMNVDD17 is

  procedure sp_cr_NroEntidadesRCC(--ln_instancia       in number, --MOD@ABR 20180719
                                  ln_pais IN NUMBER,--MOD@ABR 20180719
                                  ln_tipdoc IN NUMBER,--MOD@ABR 20180719
                                  ln_nrodoc IN CHAR,--MOD@ABR 20180719
                                  ln_nroentidadesrcc out number) is
  
    --ln_pais     number; --MOD@ABR 20180719
    --ln_tipdoc   number;--MOD@ABR 20180719
    --ln_nrodoc   varchar2(12);--MOD@ABR 20180719
    
    -- DCASTRO  22/08/2019 modificar consulta para retornar numero de entidades
    
    lc_C_TDOCID number;
    ln_FchRCC   number;
    ln_dia      number;
    ln_Mes      number;
    ln_Anio     number;
    D_FECPRE    varchar2(10);
    D_FECPRE1   date;
    lc_codsbs   varchar2(16);
  
  begin
  --MOD@ABR 20180719
    /*begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tipdoc, ln_nrodoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;*/
 --MOD@ABR 20180719 
 
    begin
      -- Fecha RCC
      select Tpnro
        into ln_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      ln_dia  := SubStr(ln_FchRCC, 1, 2);
      ln_Mes  := SubStr(ln_FchRCC, 3, 2);
      ln_Anio := SubStr(ln_FchRCC, 5, 4);
    
      D_FECPRE  := ln_dia || '/' || ln_Mes || '/' || ln_Anio;
      D_FECPRE1 := to_date(D_FECPRE, 'dd/mm/rrrr');
    
    end;
  
    pq_cr_resolutor_cnsmnvdd17.sp_Tipo_Doc_SBS(ln_tipdoc,
                                               ln_nrodoc,
                                               lc_C_TDOCID);
  
    begin
      select C_CODSBS -- para sacar el CodSBS
        into lc_codsbs
        from cldrcci
       where c_docide = trim(ln_nrodoc)
         and C_TDOCID = lc_C_TDOCID
         and d_fecpre = D_FECPRE1  --22/08/2019 se agrego fecha de proceso
         and rownum = 1;
    exception
      when others then
        lc_codsbs := null;
    end;
  
    /* se comento 22/08/2019
    begin
      select count(distinct(c_codemp))
        into ln_nroentidadesrcc
        from cldrccs
       where c_codsbs = lc_codsbs
         and d_fecpre = D_FECPRE1
         and c_codemp <> '00104';
    exception
      when others then
        ln_nroentidadesrcc := 0;
    end;
    */

    --22/08/2019 DCASTRO
   if  lc_codsbs is null then
       ln_nroentidadesrcc := 0;       
   else 
      begin
         select count(distinct c_codemp)
           into ln_nroentidadesrcc
           from cldrccs a
          where c_codsbs = lc_CodSbs
            and d_fecpre = D_FECPRE1
            and C_CODEMP <> '00104'
            and (REGEXP_LIKE(c_cuenta, '^14.[1-6]') or
                REGEXP_LIKE(c_cuenta, '^72.5') or REGEXP_LIKE(c_cuenta, '^71.1') or
                REGEXP_LIKE(c_cuenta, '^71.2') or REGEXP_LIKE(c_cuenta, '^71.3') or
                REGEXP_LIKE(c_cuenta, '^71.4') or REGEXP_LIKE(c_cuenta, '^81.302'))
            and not (REGEXP_LIKE(c_cuenta, '^14.[1-6]0313') );
       exception when others then
            ln_nroentidadesrcc := 0;        
       end;   
   
    end if;
    --22/08/2019 
  
  end sp_cr_NroEntidadesRCC;
  ----------------------------------------------------------------------- 
  procedure sp_Tipo_Doc_SBS(ln_tdoc  in number,
                            lc_tndoc in varchar2,
                            C_TDOCID out varchar) is
  
    --  C_TDOCID char(1);
  
  Begin
    Begin
      C_TDOCID := '0';
    
      If ln_tdoc = 21 then
        C_TDOCID := '1';
      End If;
    
      If ln_tdoc = 9 then
        If Length(lc_tndoc) < 11 then
          C_TDOCID := '2';
        End If;
      
        If Length(lc_tndoc) >= 11 then
          C_TDOCID := '3';
        End If;
      End If;
    
      if C_TDOCID = '0' then
      
        If ln_tdoc = 2 then
          C_TDOCID := '2';
        ELSE
          If ln_tdoc = 4 then
            C_TDOCID := '3';
          else
            If ln_tdoc = 15 then
              C_TDOCID := '4';
            else
              If ln_tdoc = 5 then
                C_TDOCID := '5';
              else
                If ln_tdoc = 6 then
                  C_TDOCID := '8';
                End If;
              End If;
            End If;
          End If;
        End If;
      End If;
    
    End;
  
  end sp_Tipo_Doc_SBS;
  --------------------------------------------------------------------------------------
  procedure sp_cr_MoraMaxMicroConsumo(ln_instancia        in number,
                                      ln_MoraMaxMicroCons out number) is
  
    ln_pais        number;
    ln_tipdoc      number;
    ln_numdoc      varchar2(12);
    lc_Flag        varchar2(2) := 'N';
    lc_Flag2       varchar2(2) := 'N';
    ln_pgcod       number;
    ln_modulo      number;
    ln_sucursal    number;
    ln_moneda      number;
    ln_papel       number;
    ln_cuenta      number;
    ln_operacion   number;
    ln_sboperacion number;
    ln_tipopercion number;
  
  begin
  
    ln_MoraMaxMicroCons := 0;
  
    begin
      -- Datos del Cliente
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, 'S'
        into ln_pais, ln_tipdoc, ln_numdoc, lc_Flag
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if lc_Flag = 'S' then
    
      begin
        -- Datos del Ultimo Crédito MicroConsumo
      
        select a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               'S'
          into ln_pgcod,
               ln_modulo,
               ln_sucursal,
               ln_moneda,
               ln_papel,
               ln_cuenta,
               ln_operacion,
               ln_sboperacion,
               ln_tipopercion,
               lc_Flag2
        
          from fsd010 a
         where a.pgcod = 1
           and a.aocta in (select f.ctnro
                             from fsr008 f
                            where f.pgcod = 1
                              and f.pepais = ln_pais
                              and f.petdoc = ln_tipdoc
                              and f.pendoc = ln_numdoc)
           and a.aomod = 106
           and a.aofval =
               (select max(d.aofval)
                  from fsd010 d
                 where d.pgcod = 1
                   and d.aocta in (select f.ctnro
                                     from fsr008 f
                                    where f.pgcod = 1
                                      and f.pepais = ln_pais
                                      and f.petdoc = ln_tipdoc
                                      and f.pendoc = ln_numdoc)
                   and d.aomod = 106
                   and d.aotope = 40)
           and a.aotope = 40;
      exception
        when others then
          null;
      end;
    
      if lc_Flag2 = 'S' then
      
        begin
          -- Mora Máxima del Credito Microconsumo
          select max(d.pp1fech - d.ppfpag)
            into ln_MoraMaxMicroCons
            from fsd602 d
           where d.pgcod = ln_pgcod
             and d.ppmod = ln_modulo
             and d.ppsuc = ln_sucursal
             and d.ppmda = ln_moneda
             and d.pppap = ln_papel
             and d.ppcta = ln_cuenta
             and d.ppoper = ln_operacion
             and d.ppsbop = ln_sboperacion
             and d.pptope = ln_tipopercion;
        exception
          when others then
            ln_MoraMaxMicroCons := 0;
        end;
      end if;
    end if;
  end sp_cr_MoraMaxMicroConsumo;
  ---------------------------------------------------------------------------------------
  procedure sp_cr_PromeAtrasoMax(pn_pai           in number,
                                 pn_tdo           in number,
                                 pc_ndo           in char,
                                 pd_fecpro        in date,
                                 ln_promedio      out number,
                                 ln_MaxPromAtraso out number) is
  
    ld_fecini   date;
    ln_vig      number(9);
    ln_dia      number(18);
    ln_contador number(18);
  begin
  
    begin
      select tp1nro1
        into ln_vig
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 2
         and tp1corr2 = 4;
    exception
      when others then
        ln_vig := null; --cambiar en produccion
    
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    begin
      delete from jaqz815 a
       where a.jaqz815pepais = pn_pai
         and a.jaqz815petdoc = pn_tdo
         and a.jaqz815pendoc = pc_ndo;
      commit;
    exception
      when others then
        null;
    end;
    --execute immediate('truncate table jaqz081');
    begin
      insert into jaqz815
        (jaqz815PGCOD,
         jaqz815AOMOD,
         jaqz815AOSUC,
         jaqz815AOMDA,
         jaqz815AOPAP,
         jaqz815AOCTA,
         jaqz815AOOPER,
         jaqz815AOSBOP,
         jaqz815AOTOPE,
         jaqz815AOFVAL,
         jaqz815AOFVTO,
         jaqz815AOFE99,
         jaqz815AOSTAT,
         jaqz815PEPAIS,
         jaqz815PETDOC,
         jaqz815PENDOC,
         jaqz815FEUSO)
        select B.PGCOD,
               b.aomod,
               b.aosuc,
               b.aomda,
               b.aopap,
               b.aocta,
               b.aooper,
               b.aosbop,
               b.aotope,
               b.aofval,
               b.aofvto,
               PQ_CR_RESOLUTOR_CNSMNVDD17.Fn_DiaPago(b.PGCOD,
                                                     AOMOD,
                                                     AOSUC,
                                                     AOMDA,
                                                     AOPAP,
                                                     AOCTA,
                                                     AOOPER,
                                                     AOSBOP,
                                                     AOTOPE,
                                                     aostat,
                                                     aofe99),
               
               b.aostat,
               a.pepais,
               a.petdoc,
               a.pendoc,
               (case
                 when aostat <> 99 then
                  aofvto
                 else
                  PQ_CR_RESOLUTOR_CNSMNVDD17.Fn_DiaPago(b.PGCOD,
                                                        AOMOD,
                                                        AOSUC,
                                                        AOMDA,
                                                        AOPAP,
                                                        AOCTA,
                                                        AOOPER,
                                                        AOSBOP,
                                                        AOTOPE,
                                                        aostat,
                                                        aofe99)
               end) FEUSO
        
          from fsr008 a, fsd010 b
         where a.pgcod = 1
           and a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.cttfir = 'T'
           and b.pgcod = a.pgcod
           and b.aocta = a.ctnro
           and aomod in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (200, 33, 108))
           and (aofe99 >= ld_fecini or
               aofe99 = to_date('0001.01.01', 'yyyy.mm.dd'))
           and aotope <> 550;
    
      commit;
    exception
      when others then
        null;
      
    end;
  
    PQ_CR_RESOLUTOR_CNSMNVDD17.Sp_cr_histDiaAtr_linea(pn_pai,
                                                      pn_tdo,
                                                      pc_ndo,
                                                      Pd_fecpro,
                                                      ld_fecini,
                                                      ln_contador,
                                                      ln_dia,
                                                      ln_MaxPromAtraso);
    if ln_contador = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round((ln_dia / ln_contador), 2);
    end if;
  
    --      Sp_cr_histDiaAtr_linea
  
  end sp_cr_PromeAtrasoMax;
  -------------------------------------------------------------------------------------
  Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date is
    ld_fecpag date;
  
  begin
  
    begin
      if pn_est = 99 then
        if pd_fec = to_date('01.01.0001', 'dd.mm.yyyy') or pd_fec is null then
          begin
          
            Select max(pp1fech)
              into ld_fecpag
              from fsd602 a
             where a.pgcod = pn_emp
               and a.ppmod = pn_mod
               and a.ppsuc = pn_suc
               and a.ppmda = pn_mda
               and a.pppap = pn_pap
               and a.ppcta = pn_cta
               and a.ppoper = pn_ope
               and a.ppsbop = pn_sbo
               and a.pptope = pn_top
               and a.d602co = 'S'
               and (a.pp1cap + a.pp1int) <> 0
               and a.pp1stat = 'T';
          exception
            when no_data_found then
              ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
            
          end;
        else
          ld_fecpag := pd_fec;
        end if;
      
      else
        ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
      end if;
    
    end;
    return ld_fecpag;
  end Fn_DiaPago;

  ---------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea(pn_pai           in number,
                                   pn_tdo           in number,
                                   pc_ndo           in char,
                                   pd_fecpro        in date,
                                   pd_fecini        in date,
                                   ln_contCuoTot    out number,
                                   ln_diaTot        out number,
                                   ln_MaxPromAtraso out number) is
  
    cursor creditos is
      select *
        from jaqz815 a
       where a.jaqz815pepais = pn_pai
         and a.jaqz815petdoc = pn_tdo
         and a.jaqz815pendoc = pc_ndo
       order by jaqz815aostat, jaqz815aofe99 desc, jaqz815aofval desc; --aofe99;--aofval DESC;
  
    --ln_contador number(5);    
    ld_fecantD date;
    ld_fecantC date;
    --ln_aux number(4);
    ln_mesac number(2);
    ln_aniac number(4);
    ln_mesan number(2);
    ln_anian number(4);
    ln_suma  number(5);
  
    ld_aofval date;
    ld_aofe99 date;
    --ld_dia number(2);
    ld_feccorte date;
    ln_auxiliar number(5);
    ld_fecdes   date;
    ld_fecaux   date;
    lc_fecaux   char(6);
    ld_sysdate  date;
  
    --ln_contCuoTot number(5);
    --ln_diaTot number(5);
    ln_contador number(18);
  
    ln_sw number(1);
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      --ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    
      For i in creditos loop
        ln_sw := 0;
        if (i.jaqz815aofe99 is null or
           i.jaqz815aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.jaqz815aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.jaqz815aofe99, 'mm'));
          ln_aniac  := to_number(to_char(i.jaqz815aofe99, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.jaqz815aofval;
          ld_aofe99 := last_day(i.jaqz815aofe99);
          --ld_aofe99 := last_day(i.aofe99);
          ld_fecdes  := i.jaqz815aofval;
          ld_sysdate := last_day(pd_fecpro);
        
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if i.jaqz815aostat <> 99 then
            ld_aofe99 := pd_fecpro;
          end if;
        
          if ld_fecantD is null then
            if i.jaqz815aostat = 99 then
              ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            else
              ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            
            end if;
          
          Else
          
            if ld_aofe99 = ld_fecantD or
               (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
              if i.jaqz815aostat = 99 then
                ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              else
                ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              end if;
            
            else
              if ld_aofe99 > ld_fecantD then
              
                ld_aofe99 := last_day(ld_fecantD);
                if i.jaqz815aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofe99 < ld_fecantD then
              
                if i.jaqz815aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
          ld_fecantD := ld_aofval;
          ld_fecantC := i.jaqz815aofe99;
        
          ln_mesan := to_number(to_char(ld_fecantD, 'mm'));
          ln_anian := to_number(to_char(ld_fecantD, 'yyyy'));
        
          if ln_contador = 12 then
          
            lc_fecaux   := to_char(ld_aofval, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
          
          end if;
          if ln_contador > 12 then
            ln_auxiliar := ln_contador - 12;
            ld_fecaux   := add_months(ld_aofval, ln_auxiliar);
            lc_fecaux   := to_char(ld_fecaux, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
          end if;
          ld_feccorte := ld_aofval;
        end if;
      end loop;
      PQ_CR_RESOLUTOR_CNSMNVDD17.Sp_cr_histDiaAtr_linea_ii(pn_pai,
                                                           pn_tdo,
                                                           pc_ndo,
                                                           ld_feccorte,
                                                           pd_fecpro,
                                                           ln_contCuoTot,
                                                           ln_diaTot,
                                                           ln_MaxPromAtraso);
    
    end;
  end Sp_cr_histDiaAtr_linea;
  ----------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai           in number,
                                      pn_tdo           in number,
                                      pc_ndo           in char,
                                      pd_fecor         in date,
                                      pd_fecpro        in date,
                                      ln_contCuoTot    out number,
                                      ln_diaTot        out number,
                                      ln_MaxPromAtraso out number) is
  
    cursor creditos is
    
      select *
        FROM jaqz815 a
       WHERE a.jaqz815pepais = pn_pai
         and a.jaqz815petdoc = pn_tdo
         and a.jaqz815pendoc = pc_ndo
         and a.jaqz815feuso >= pd_fecor
       order by jaqz815aofval desc;
  
    ln_contCuotas number(18);
    ln_dia        number(18);
    -- ln_MaxPromAtraso    number;
    ld_feccan           date;
    ln_MaxPromAtrasoAux number := 0;
  begin
  
    begin
      ln_contCuoTot       := 0;
      ln_diaTot           := 0;
      ln_MaxPromAtraso    := 0;
      ln_MaxPromAtrasoAux := 0;
    
      for i in creditos loop
        if i.jaqz815aostat = 99 then
        
          ld_feccan := i.jaqz815aofe99;
        else
          ld_feccan := pd_fecpro;
        end if;
      
        PQ_CR_RESOLUTOR_CNSMNVDD17.sp_calculaCuotas(i.jaqz815pgcod,
                                                    i.jaqz815aomod,
                                                    i.jaqz815aosuc,
                                                    i.jaqz815aomda,
                                                    i.jaqz815aopap,
                                                    i.jaqz815aocta,
                                                    i.jaqz815aooper,
                                                    i.jaqz815aosbop,
                                                    i.jaqz815aotope,
                                                    ld_feccan,
                                                    pd_fecor,
                                                    i.jaqz815aostat,
                                                    ln_contCuotas,
                                                    ln_dia,
                                                    ln_MaxPromAtrasoAux);
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      
        if ln_MaxPromAtrasoAux > ln_MaxPromAtraso then
          ln_MaxPromAtraso := ln_MaxPromAtrasoAux;
        end if;
      end loop;
    
    end;
  
  end Sp_cr_histDiaAtr_linea_ii;
  -------------------------------------------------------------------------------------
  Procedure Sp_CalculaCuotas(pn_emp           in number,
                             pn_mod           in number,
                             pn_suc           in number,
                             pn_mda           in number,
                             pn_pap           in number,
                             pn_cta           in number,
                             pn_ope           in number,
                             pn_sbo           in number,
                             pn_top           in number,
                             pd_fec           in date,
                             pd_fecor         in date,
                             pn_stat          in number,
                             ln_contador      out number,
                             ln_diasTot       out number,
                             ln_MaxPromAtraso out number) is
    cursor creditos is
      select a.pgcod,
             a.ppmod,
             a.ppsuc,
             a.ppmda,
             a.pppap,
             a.ppcta,
             a.ppoper,
             a.ppsbop,
             a.pptope,
             a.ppfpag
        from fsd601 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag < pd_fec
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
  
    ln_dias    number(10);
    ln_flag    number(1);
    ld_fecantC date;
    ld_fecpago date;
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      For i in creditos loop
      
        begin
        
          select b.pp1fech
            into ld_fecpago
            from fsd602 b
           where b.pgcod = i.pgcod
             and b.ppmod = i.ppmod
             and b.ppsuc = i.ppsuc
             and b.ppmda = i.ppmda
             and b.pppap = i.pppap
             and b.ppcta = i.ppcta
             and b.ppoper = i.ppoper
             and b.ppsbop = i.ppsbop
             and b.pptope = i.pptope
             and b.ppfpag = i.ppfpag
             and b.pp1stat = 'T'
             and b.d602co = 'S'
             and (b.pp1cap + b.pp1int) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            ld_fecpago := null;
        end;
      
        if ld_fecpago >= pd_fecor or ld_fecpago is null then
        
         -- if ld_fecantC <> i.ppfpag then
            ln_contador := ln_contador + 1;
          
            ln_dias := PQ_CR_RESOLUTOR_CNSMNVDD17.fn_cuotasPag(i.pgcod,
                                                               i.ppmod,
                                                               i.ppsuc,
                                                               i.ppmda,
                                                               i.pppap,
                                                               i.ppcta,
                                                               i.ppoper,
                                                               i.ppsbop,
                                                               i.pptope,
                                                               i.ppfpag,
                                                               pd_fec);
          
            ln_diasTot := ln_diasTot + ln_dias;
          --end if;
        
          ld_fecantC := i.ppfpag;
        end if;
      
      end loop;
    
     /* if pn_stat = 99 then
        begin
        
          select 1
            into ln_flag
            from fsd601 a
           where a.pgcod = pn_emp
             and a.ppmod = pn_mod
             and a.ppsuc = pn_suc
             and a.ppmda = pn_mda
             and a.pppap = pn_pap
             and a.ppcta = pn_cta
             and a.ppoper = pn_ope
             and a.ppsbop = pn_sbo
             and a.pptope = pn_top
                --and a.ppfpag between pd_fecor and pd_fec
             and a.ppfpag >= pd_fec
                --and a.ppfpag < pd_fec
             and a.d601co = 'S'
             and (a.ppcap + a.ppint) <> 0
             and rownum = 1;
        exception
          when no_data_found then
            ln_flag := 0;
        end;
      else
        ln_flag := 0;
      end if;*/
    
      if ln_flag = 1 then
        ln_contador := ln_contador + 1;
      end if;
    end;
  
    begin
    
      ln_diasTot  := nvl(ln_diasTot, 0);
      ln_contador := nvl(ln_contador, 0);
    
      if ln_contador > 0 then
        ln_MaxPromAtraso := ln_diasTot / ln_contador;
      
      else
        ln_MaxPromAtraso := 0;
      end if;
      
    end;
  
  end Sp_CalculaCuotas;
  --------------------------------------------------------------------------------------
  Function Fn_CuotasPag(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        pd_fec    in date,
                        pd_fecpro in date) return number is
    ln_dias number(10);
  begin
  
    begin
    
      select (a.pp1fech - a.ppfpag)
        into ln_dias
        from fsd602 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.ppfpag = pd_fec
         and a.d602co = 'S'
         and a.pp1stat = 'T'
         and (a.pp1cap + a.pp1int) <> 0
         and rownum = 1;
    
    exception
      when no_data_found then
        ln_dias := pd_fecpro - pd_fec;
      When too_many_rows then
        dbms_output.put_line(pn_cta || '-' || pn_ope || '-' || pn_sbo || '-' ||
                             pn_top || '-' || pd_fec);
      
    end;
  
    if ln_dias < 0 then
      ln_dias := 0;
    end if;
  
    return ln_dias;
  
  end Fn_CuotasPag;
  --------------------------------------------------------------------------------------  
end PQ_CR_RESOLUTOR_CNSMNVDD17;
/

