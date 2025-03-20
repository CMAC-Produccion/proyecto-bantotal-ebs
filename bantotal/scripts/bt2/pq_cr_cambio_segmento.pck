create or replace package pq_cr_cambio_segmento is
 -- *****************************************************************
    -- Nombre                     : pq_cr_potencial_pyme
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : procemientos para calculo de variables de cambio de segmento 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Parámetros de Salida       : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************

   Procedure sp_saldocon_mn_hist(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_saldo  out number
                        ) ;     
                                        
 
 
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
  
  Procedure Sp_CalculaCuotas(pn_emp      in number,
                           pn_mod      in number,
                           pn_suc      in number,
                           pn_mda      in number,
                           pn_pap      in number,
                           pn_cta      in number,
                           pn_ope      in number,
                           pn_sbo      in number,
                           pn_top      in number,
                           pd_fec      in date,
                           pd_fecor    in date,
                           pn_stat     in number,
                           ln_contador out number,
                           ln_diasTot  out number, 
                           ln_diaMax   out number);
  
  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number);
                               
  Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   pd_fecini     in date,
                                   ln_contCuoTot out number,
                                   ln_diaTot     out number, 
                                   ln_diaMax     out number 
                                   );
                                   
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      ln_contCuoTot out number,
                                      ln_diaTot     out number, 
                                      ln_diaMax     out number);
                                      
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
                                                                                                                                          
end pq_cr_cambio_segmento;
/

create or replace package body pq_cr_cambio_segmento is


-----------------------------------------------------------------------------
  
Procedure sp_saldocon_mn_hist(
                        pd_fecha  in date,
                        pn_pais   in number,
                        pn_tdoc   in number,
                        pc_ndoc   in char,
                        pn_saldo  out number
                        )  is
  
  -- *****************************************************************
    -- Nombre                     : sp_saldo_mn_hist
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : CALCULA EL SALDO CONSOLIDADO MAYOR EN UN PERIODO DE TIEMPO
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pd_fecha ( FECHA DE PROCESO )
    --                            : pn_pais ( PAIS )
    --                            : pn_tdoc ( TIPO DE DOCUMENTO )
    --                            : pc_ndoc ( NUMERO DE DOCUMENTO )
    -- Parámetros de Salida       : pn_saldo ( MONTO CONSOLIDADO )
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************
                       
    ln_saldo_mn number(17,2) :=0;  --valor sin respuesta
    ld_fecha date :=null;
    ln_tiempo number(10) := null;
  begin
    
    ld_fecha := last_day(add_months(pd_fecha,-1));
    
    /*obtiene ventana de tiempo*/
    begin 
      select t.tpnro
        into ln_tiempo
        from fst098 t
       where t.pgcod = 1
         and t.tpcod = 7752
         and t.tpcorr = 11;
    exception when others then 
      ln_tiempo :=36;
    end;
  
    begin
    
      /*obtener el saldo consolidado mayor en mn del cliente*/
      select fecha, saldo_mn
        into ld_fecha, ln_saldo_mn
        from (select fecha, saldo_mn
                from (select j.jaql114fech fecha, sum(j.jaql114sdmn) saldo_mn
                        from jaql114 j
                       where j.jaql114fech > add_months(ld_fecha, -1*ln_tiempo) --meses 
                         and substr(j.jaql114rubr, 1, 4) in
                             (1411,
                              1414,
                              1415,
                              1416,
                              1421,
                              1424,
                              1425,
                              1426,
                              8113,
                              8123,
                              8119,
                              8129)
                         and j.jaql114cta <> 999999999
                         and j.jaql114stat <> 99
                         and j.jaql114mod not in (141, 33, 108)
                            --and j.jaql114mod  in (33)
                         and j.jaql114pais = pn_pais --604
                         and j.jaql114tdoc = pn_tdoc --21
                         and j.jaql114ndoc = pc_ndoc --'29653879'
                       group by j.jaql114fech)
               order by saldo_mn desc)
       where rownum = 1;
      
      pn_saldo := ln_saldo_mn;
      
    exception
      when others then
       -- dbms_output.put_line( sqlerrm);
       ld_fecha := null;
       ln_saldo_mn := 0 ;
        pn_saldo := ln_saldo_mn; --ln_potencial;   --caso de no haber nada por default 5 (muy bajo) cambio solicitado por parametrizacion
    end;  
    
  exception when others then       
      ld_fecha := null;
       ln_saldo_mn := 0 ;
        pn_saldo := ln_saldo_mn;
  
  end sp_saldocon_mn_hist;

----------------------------------------------------------------------------- 



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
    /*****************************************************************
    -- Nombre                     : Fn_CuotasPag
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Numero de cuotas pagadas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_emp    empresa
                                    pn_mod    modulo
                                    pn_suc    sucursar
                                    pn_mda    moneda
                                    pn_pap    papel
                                    pn_cta    cuenta
                                    pn_ope    operacion
                                    pn_sbo    suboperacion
                                    pn_top    tipo operacion
                                    pd_fec    fecha
                                    pd_fecpro fecha de proceso
    -- Parámetros de Salida       : Numero de cuotas pagadas
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/                     
                        
                        
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
-----------------------------------------------------------------------------
  
  Procedure Sp_CalculaCuotas(pn_emp      in number,
                             pn_mod      in number,
                             pn_suc      in number,
                             pn_mda      in number,
                             pn_pap      in number,
                             pn_cta      in number,
                             pn_ope      in number,
                             pn_sbo      in number,
                             pn_top      in number,
                             pd_fec      in date,
                             pd_fecor    in date,
                             pn_stat     in number,
                             ln_contador out number,
                             ln_diasTot  out number, 
                             ln_diaMax   out number) is    
      /*****************************************************************
    -- Nombre                     : Sp_CalculaCuotas
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula las cuotas para promedio
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_emp    empresa
                                    pn_mod    modulo
                                    pn_suc    sucursar
                                    pn_mda    moneda
                                    pn_pap    papel
                                    pn_cta    cuenta
                                    pn_ope    operacion
                                    pn_sbo    suboperacion
                                    pn_top    tipo operacion
                                    pd_fec    fecha
                                    pd_fecpro fecha de proceso
                                    pd_fecor    fecha orden
                                    pn_stat     estado
    -- Parámetros de Salida       : ln_contador contador de cuotas
                                    ln_diasTot  dias de atraso total 
                                    ln_diaMax   dias de atraso mayor
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/  
                           
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
             a.ppfpag --,modificado 20151022 porque no esta tomando la ultima cuota pendiente de pago
      --b.ppfpag pag602,modificado 20151022
      --b.pp1fech modificado 20151022
        from fsd601 a --,fsd602 b modificado 20151022
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
            --and a.ppfpag >= pd_fecor
         and a.ppfpag < pd_fec
         and a.d601co = 'S'
         and (a.ppcap + a.ppint) <> 0;
    /*and a.pgcod = b.pgcod
    and a.ppmod = b.ppmod
    and a.ppsuc = b.ppsuc
    and a.ppmda = b.ppmda
    and a.pppap = b.pppap
    and a.ppcta = b.ppcta
    and a.ppoper = b.ppoper
    and a.ppsbop = b.ppsbop
    and a.pptope = b.pptope
    and a.ppfpag = b.ppfpag
    and b.pp1stat = 'T'
    and b.d602co = 'S'
    and b.pp1fech >=pd_fecor*/ --modificado 20151022;
  
    --ln_contador number(5);
    ln_dias number(10);
    --ln_diamax number(10) :=0;
    --ln_diasTot number(5);
  
    --ld_fecpag date;
    --ln_mpag number(2);
    --ln_mdpa number(2);
    --ln_apag number(4);
    --ln_adpa number(4);
  
    ln_flag    number(1);
    ld_fecantC date;
  
    ld_fecpago date; --modificado 20151022
  
  begin
    begin
      ln_diasTot  := 0;
      ln_contador := 0;
      ln_flag     := 0;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ln_diaMax   := 0;  --dia atraso maximo
      
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
        
          if ld_fecantC <> i.ppfpag then
            ln_contador := ln_contador + 1;
          
            ln_dias    := pq_cr_cambio_segmento.fn_cuotasPag(i.pgcod,
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
                                                           
            if ln_diamax < ln_dias  then --calculo de dias de atraso maximo 
              ln_diaMax := ln_dias;             
            end if;
                                                            
            ln_diasTot := ln_diasTot + ln_dias;
          end if;
        
          ld_fecantC := i.ppfpag;
        end if;
      
      end loop;
    
      if pn_stat = 99 then
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
      end if;
    
      if ln_flag = 1 then
        ln_contador := ln_contador + 1;
      end if;
    end;
  
  end Sp_CalculaCuotas;
------------------------------------------------------------
  
  Procedure Sp_DiaAtraso_linea(pn_pai      in number,
                               pn_tdo      in number,
                               pc_ndo      in char,
                               pd_fecpro   in date,
                               ln_promedio out number) is
    /*****************************************************************
    -- Nombre                     : Sp_DiaAtraso_linea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula las los dias de atraso
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pai      pais
                                    pn_tdo      tipo de documento
                                    pc_ndo      numero de documento
                                    pd_fecpro   fecha de proceso
    -- Parámetros de Salida       : ln_promedio promedio
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/                              
  
    ld_fecini   date;
    ln_vig      number(9);
    ln_dia      number(18);
    ln_contador number(18);
    ln_diamax   number(18);
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
    delete from jaqz081 a
     where a.pepais = pn_pai
       and a.petdoc = pn_tdo
       and a.pendoc = pc_ndo;
    exception when others then 
      null;
     end;    
    commit;
    --execute immediate('truncate table jaqz081');
    begin
      insert into jaqz081
        (PGCOD,
         AOMOD,
         AOSUC,
         AOMDA,
         AOPAP,
         AOCTA,
         AOOPER,
         AOSBOP,
         AOTOPE,
         AOFVAL,
         AOFVTO,
         AOFE99,
         AOSTAT,
         PEPAIS,
         PETDOC,
         PENDOC,
         FEUSO)
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
               pq_cr_cambio_segmento.Fn_DiaPago(b.PGCOD,
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
               --b.aofe99,
               b.aostat,
               a.pepais,
               a.petdoc,
               a.pendoc,
               --(case when aostat <> 99 then aofvto
               --else aofe99 end )FEUSO
               
               (case
                 when aostat <> 99 then
                  aofvto
                 else
                  pq_cr_cambio_segmento.Fn_DiaPago(b.PGCOD,
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
    exception when others then 
      null;  
    end;
    
    begin
    pq_cr_cambio_segmento.Sp_cr_histDiaAtr_linea(pn_pai,
                                                 pn_tdo,
                                                 pc_ndo,
                                                 Pd_fecpro,
                                                 ld_fecini,
                                                 ln_contador,
                                                 ln_dia,
                                                 ln_diamax);
    exception when others then null;
    end;
                                                 
    if ln_contador = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round(( (ln_dia - nvl(ln_diamax,0)) / ln_contador), 2);
    end if;
    
  exception when others then null;
    --      Sp_cr_histDiaAtr_linea
  end Sp_DiaAtraso_linea;
  ------------------------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea(pn_pai        in number,
                                   pn_tdo        in number,
                                   pc_ndo        in char,
                                   pd_fecpro     in date,
                                   pd_fecini     in date,
                                   ln_contCuoTot out number,
                                   ln_diaTot     out number, 
                                   ln_diaMax     out number ) is
      /*****************************************************************
    -- Nombre                     : Sp_cr_histDiaAtr_linea
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula las historico dias de atraso
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pai        pais
                                    pn_tdo        tipo de documento
                                    pc_ndo        numero de documento
                                    pd_fecpro     fecha de proceso
                                    pd_fecini     fecha inicial
    -- Parámetros de Salida       : ln_diaTot     dias total atraso
                                   ln_diaMax      dias maximo
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/                                    
  
    cursor creditos is
      select *
        from jaqz081 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by aostat, aofe99 desc, aofval desc; --aofe99;--aofval DESC;
    /*cursor creditos is
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
                       pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                              AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       --b.aofe99,
                       b.aostat,
                       a.pepais,
                       a.petdoc,
                       a.pendoc,
                       (case when aostat <> 99 then aofvto
                       else aofe99 end )FEUSO
                  from fsr008 a, fsd010 b
                 where a.pgcod = 1
                   and a.pepais = pn_pai
                   and a.petdoc = pn_tdo
                   and a.pendoc = pc_ndo
                   and a.cttfir = 'T'
                   and b.pgcod = a.pgcod
                   and b.aocta = a.ctnro
                   and aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108)) 
                   and (aofe99 >= pd_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550;*/
  
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
        if (i.aofe99 is null or
           i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')) and
           i.aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofe99, 'mm'));
          ln_aniac  := to_number(to_char(i.aofe99, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := last_day(i.aofe99);
          --ld_aofe99 := last_day(i.aofe99);
          ld_fecdes  := i.aofval;
          ld_sysdate := last_day(pd_fecpro);
        
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if i.aostat <> 99 then
            ld_aofe99 := pd_fecpro;
          end if;
        
          if ld_fecantD is null then
            if i.aostat = 99 then
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
              if i.aostat = 99 then
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
                --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                ld_aofe99 := last_day(ld_fecantD);
                if i.aostat = 99 then
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if;*/
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if; */
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofe99 < ld_fecantD then
              
                if i.aostat = 99 then
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
        
          /*if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
             if ld_fecantC > i.aofval then
                ld_aofval := ld_fecantC;
             end if;
             ld_fecantC := pd_fecpro;
          end if;
          
          if i.aofe99 > ld_fecantC then
                       --ld_fecantD := ld_aofval;
                       ld_fecantC := i.aofe99;
          
          end if;*/
        
          --if i.aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
          ld_fecantD := ld_aofval;
          ld_fecantC := i.aofe99;
        
          ln_mesan := to_number(to_char(ld_fecantD, 'mm'));
          ln_anian := to_number(to_char(ld_fecantD, 'yyyy'));
        
          if ln_contador = 6 then
            --ld_feccorte := i.aofval;
            lc_fecaux   := to_char(ld_aofval, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
            /*if ln_contador = 12 then
               ld_feccorte := ld_fecdes;
               pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
                ln_diaTot := ln_diaTot + ln_dia;
                ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
            
               exit;
            end if;*/
            /*pq_cr_relcrediticia.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,
                                                 ln_contCuotas,ln_dia);
            ln_diaTot := ln_diaTot + ln_dia;
            ln_contCuoTot := ln_contCuoTot + ln_contCuotas;*/
          
          end if;
          if ln_contador > 6 then
            ln_auxiliar := ln_contador - 6;
            ld_fecaux   := add_months(ld_aofval, ln_auxiliar);
            lc_fecaux   := to_char(ld_fecaux, 'yyyymm');
            ld_feccorte := to_date((lc_fecaux || '01'), 'yyyymmdd');
            exit;
          end if;
          ld_feccorte := ld_aofval;
        end if;
      end loop;
      pq_cr_cambio_segmento.Sp_cr_histDiaAtr_linea_ii(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    ld_feccorte,
                                                    pd_fecpro, /*pd_fecini,*/
                                                    ln_contCuoTot,
                                                    ln_diaTot, 
                                                    ln_diaMax);
    exception when others then null;                                                
    
    end;
  end Sp_cr_histDiaAtr_linea;
---------------------------------------------------------------------------------
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai        in number,
                                      pn_tdo        in number,
                                      pc_ndo        in char,
                                      pd_fecor      in date,
                                      pd_fecpro     in date, /*pd_fecini in date,*/
                                      ln_contCuoTot out number,
                                      ln_diaTot     out number, 
                                      ln_diaMax     out number) is                                      
    /*****************************************************************
    -- Nombre                     : Sp_cr_histDiaAtr_linea_ii
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula las historico dias de atraso
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_pai        pais
                                    pn_tdo        tipo documento
                                    pc_ndo        numero documento
                                    pd_fecor      fecha
                                    pd_fecpro     fecha de proceso 
    -- Parámetros de Salida       : ln_contCuoTot cuota total
                                    ln_diaTot     dias atraso total 
                                    ln_diaMax     dias atraso maximo
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/   
    cursor creditos is
    
      select *
        FROM JAQZ081 a
       WHERE a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.feuso >= pd_fecor
       order by aofval desc;
  
    /*cursor creditos is
    Select * from(
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
                       pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                              AOSBOP,AOTOPE,aostat,aofe99)aofe99,
                       --b.aofe99,
                       b.aostat,
                       a.pepais,
                       a.petdoc,
                       a.pendoc,
                       (case when aostat <> 99 then aofvto
                       else aofe99 end )FEUSO
                  from fsr008 a, fsd010 b
                 where a.pgcod = 1
                   and a.pepais = pn_pai
                   and a.petdoc = pn_tdo
                   and a.pendoc = pc_ndo
                   and a.cttfir = 'T'
                   and b.pgcod = a.pgcod
                   and b.aocta = a.ctnro
                   and aomod in (select modulo from fst111 where dscod = 50 and modulo not in (200,33,108)) 
                   and (aofe99 >= pd_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                   and aotope <> 550)
                   where feuso >=pd_fecor
    order by aofval desc;*/
  
    ln_contCuotas number(18);
    ln_dia        number(18);
    ln_diaMaxi    number(18);
    ln_diaMaxi_tmp number(18);
  
    ld_feccan date;
  begin
  
    begin
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
      ln_diaMaxi     := 0;
      ln_diaMaxi_tmp := 0;
      
      for i in creditos loop
        if i.aostat = 99 then
          --                ld_feccan := last_day(i.aofe99);
          ld_feccan := i.aofe99;
        else
          --ld_feccan := last_day(pd_fecpro);
          ld_feccan := pd_fecpro;
        end if;
        pq_cr_cambio_segmento.sp_calculaCuotas(i.pgcod,
                                             i.aomod,
                                             i.aosuc,
                                             i.aomda,
                                             i.aopap,
                                             i.aocta,
                                             i.aooper,
                                             i.aosbop,
                                             i.aotope,
                                             ld_feccan,
                                             pd_fecor,
                                             i.aostat,
                                             ln_contCuotas,
                                             ln_dia,
                                             ln_diaMaxi_tmp);
                                             
        if ln_diaMaxi < ln_diaMaxi_tmp then  -- Calculo de dias de atraso maximo por cliente 
           ln_diaMaxi := ln_diaMaxi_tmp;  
           ln_diaMax := ln_diaMaxi;         
        end if;    
                                         
        ln_diaTot     := ln_diaTot + ln_dia;
        ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
      end loop;
    exception when others then null; 
    end;
  
  end Sp_cr_histDiaAtr_linea_ii;
------------------------------------------------------------------------------------------------
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
    /*****************************************************************
    -- Nombre                     : Fn_DiaPago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.06.15
    -- Autor de Creación          : YYAMPI
    -- Uso                        : retorna dia de fecha de pago
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pn_emp empresa
                                    pn_mod modulo
                                    pn_suc sucursal
                                    pn_mda moneda
                                    pn_pap papel
                                    pn_cta cuenta
                                    pn_ope operacion
                                    pn_sbo suboperacion
                                    pn_top tipo de operacion
                                    pn_est estado
                                    pd_fec fecha 
    -- Parámetros de Salida       : 
                                    
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --  
    -- *****************************************************************/                      
                      
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
      /*
      if pn_est = 0 then
         ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
         else
              if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or  then
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
                         and a.pp1stat = 'T';
                 exception 
                         when no_data_found then
                              ld_fecpag := to_date('01.01.0001','dd.mm.yyyy'); 
      
                 end;
                 else
                     ld_fecpag := pd_fec;
              end if;        
      end if;*/
    end;
    return ld_fecpag;
  end Fn_DiaPago;



-----------------------------------------------------------------------------
end pq_cr_cambio_segmento;
/

