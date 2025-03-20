create or replace package pq_cr_campaniaPyme_2019 is

  Procedure Sp_monto(pn_ins    in number,
                     pd_fecpro in date,
                     pc_usr    in char,
                     pn_mto    out number);
  Procedure Sp_monto_Politica(pn_ins    in number,
                              pd_fecpro in date,
                              pn_mto    out number);
  Procedure Sp_Segmento_Des(pn_ins in number, pn_seg out number);
  Procedure sp_creditosVigentes(pn_ins    in number,
                                pd_fecpro in date,
                                pn_tipcam in number,
                                pn_mto    out number,
                                pn_cont   out number);
  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out char);
  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2);

end pq_cr_campaniaPyme_2019;
/

create or replace package body pq_cr_campaniaPyme_2019 is

  Procedure Sp_monto(pn_ins    in number,
                     pd_fecpro in date,
                     pc_usr    in char,
                     pn_mto    out number) is
  
    ln_emp       number(3);
    ln_mod       number(3);
    ln_suc       number(3);
    ln_mda       number(4);
    ln_pap       number(4);
    ln_cta       number(9);
    ln_ope       number(9);
    ln_sbo       number(3);
    ln_top       number(3);
    ln_mtoAux1   number(17, 2);
    ln_mto1      number(17, 2);
    ln_mto2      number(17, 2);
    ln_mto3      number(17, 2);
    ln_porc      number(9);
    ln_eval      number(10);
    ln_tipcam    number(14, 8);
    ln_NivelDol  number(17, 2);
    ln_NivelSol  number(17, 2);
    ln_porcVen   number(9);
    ln_seg       number(5);
    ln_mtoSeg    number(17, 2);
    ln_MtoNivel  number(17, 2);
    ln_mtoVig    number(17, 2);
    ln_contVig   number(10);
    ln_maxVig    number(9);
    ln_mtoMax    number(17, 2);
    ln_mtoFinal  number(17, 2);
    LN_TIPOCRED  number(5);
    ln_plazo     number(5);
    lc_flgExiste char(1);
    ld_fecrcc    date;
    lc_flgSeg    char(1);
    ld_fecvto    date;
    ld_fecvtoM1  date;
    ld_fecdes    date;
    ln_PatriSol  number(17, 2); --mod@abr20191023
    ln_PatriDol  number(17, 2); --mod@abr20191023
    ln_Patrimon  number(17, 2); --mod@abr20191023
    ln_ratio     number(9, 6); --mod@abr20191023
    ln_sector    number(2); --mod@abr20191023
    lc_clienteNR char(2); --mod@abr20191023
    ln_ocup      number(5); --mod@abr20191023
    ln_tope      number(9, 2); --mod@abr20191023
    lc_tipo      char(1); --mod@abr20191023
    lc_tipoPer   char(2); --mod@abr20191023
    ln_mto4      number(17, 2); --mod@abr20191023
  
  begin
  
    --valida si existe data
    lc_flgExiste := 'N';
    begin
      select 'S'
        into lc_flgExiste
        from JAQZ694 a
       where a.JAQZ694ins = pn_ins;
    exception
      when others then
        lc_flgExiste := 'N';
    end;
    lc_flgExiste := nvl(lc_flgExiste, 'N');
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope,
             a.xwfmonto1
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_mtoAux1
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select a.aofval
        into ld_fecdes
        from fsd010 a
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;
    exception
      when others then
        null;
    end;
    if lc_flgExiste = 'N' then
    
      if ld_fecdes = pd_fecpro then
      
        begin
          select min(a.ppfpag)
            into ld_fecvto
            from fsd601 a
           where a.pgcod = ln_emp
             and a.ppmod = ln_mod
             and a.ppsuc = ln_suc
             and a.ppmda = ln_mda
             and a.pppap = ln_pap
             and a.ppcta = ln_cta
             and a.ppoper = ln_ope
             and a.ppsbop = ln_sbo
             and a.pptope = ln_top;
        exception
          when others then
            null;
        end;
        ld_fecvtoM1 := ld_fecvto + 1;
      
        begin
          --monto maximo 
          select a.tp1nro1
            into ln_mtoMax
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 4
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      
        --verifica monto 50% campaña
        begin
          --porcentaje
          select a.tp1nro1
            into ln_porc
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 1
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      
        ln_mto1 := (nvl(ln_mtoAux1, 0) * nvl(ln_porc, 0)) / 100;
        if ln_mto1 > ln_mtoMax then
          ln_mto1 := ln_mtoMax;
        end if;
      
        --Nivel de ventas
        begin
        
          select a.sng021eval
            into ln_eval
            from sng021 a
           where a.sng021sol = pn_ins;
        
        exception
          when others then
            null;
        end;
      
        begin
          --tipo de cambio
          select a.sng120tcbi
            into ln_tipcam
            from sng120 a
           where a.sng120ins = pn_ins
             and a.sng120tsk = 'EVALUACION';
        exception
          when others then
            null;
        end;
      
        begin
          --nivel venta soles
          select a.sng023mto
            into ln_NivelSol
            from sng023 a
           where a.sng021eval = ln_eval
             and a.sng026cod = 73;
        exception
          when others then
            null;
        end;
      
        begin
          --nivel venta dolares
          select a.sng023mto
            into ln_NivelDol
            from sng023 a
           where a.sng021eval = ln_eval
             and a.sng026cod = 573;
        exception
          when others then
            null;
        end;
      
        begin
          --porcentaje nivel ventas
          select a.tp1nro1
            into ln_porcVen
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 2
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      
        ln_MtoNivel := nvl(ln_NivelSol, 0) +
                       (nvl(ln_NivelDol, 0) * nvl(ln_tipcam, 0));
        ln_mto2     := (nvl(ln_MtoNivel, 0) * nvl(ln_porcVen, 0)) / 100;
      
        if ln_mto2 > ln_mtoMax then
          ln_mto2 := ln_mtoMax;
        end if;
      
        --Segmentacion
      
        pq_cr_campaniaPyme_2019.Sp_Segmento_Des(pn_ins, ln_seg);
      
        begin
          select a.jaqz416c1
            into ln_mtoSeg
            from jaqz416 a
           where a.jaqz416seg = ln_seg;
        exception
          when others then
            null;
        end;
        pq_cr_campaniaPyme_2019.sp_creditosVigentes(pn_ins    => pn_ins,
                                                    pd_fecpro => pd_fecpro,
                                                    pn_tipcam => ln_tipcam,
                                                    pn_mto    => ln_mtoVig,
                                                    pn_cont   => ln_contVig);
      
        ln_mto3 := nvl(ln_mtoSeg, 0) - nvl(ln_mtoVig, 0);
      
        if ln_mto3 > ln_mtoMax then
          ln_mto3 := ln_mtoMax;
        end if;
      
        --if ln_mto3 < 0 then
        --  ln_mto3 := 0;
        --end if;
      
        --mod@abr 20191023
        --Patrimonio
        begin
          --patrimonio soles
          select a.sng023mto
            into ln_PatriSol
            from sng023 a
           where a.sng021eval = ln_eval
             and a.sng026cod = 70;
        exception
          when others then
            null;
        end;
      
        begin
          --patrimonio dolares
          select a.sng023mto
            into ln_PatriDol
            from sng023 a
           where a.sng021eval = ln_eval
             and a.sng026cod = 570;
        exception
          when others then
            null;
        end;
      
        ln_Patrimon := nvl(ln_PatriSol, 0) +
                       (nvl(ln_PatriDol, 0) * ln_tipcam);
      
        --SECTOR 132
        begin
          select to_number(trim(pae71val))
            into ln_sector
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 132
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70ins = pn_ins;
        exception
          when no_data_found then
            null;
          
          when too_many_ROWS then
            begin
              select to_number(trim(pae71val))
                into ln_sector
                from fpae70 n, fpae71 v
               where n.pae70nro = v.pae70nro
                 and v.pae71ite = 132
                 and n.pae51eva = v.pae51eva
                 and v.pae51eva = 2
                 and n.pae70nro = (select max(pae70nro)
                                     from fpae70 a
                                    where pae70ins = pn_ins
                                      and a.pae51eva = 2)
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
        --CLIENTE_NR  578
        begin
          select trim(pae71val)
            into lc_clienteNR
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 578
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70ins = pn_ins;
        exception
          when no_data_found then
            null;
          
          when too_many_ROWS then
            begin
              select trim(pae71val)
                into lc_clienteNR
                from fpae70 n, fpae71 v
               where n.pae70nro = v.pae70nro
                 and v.pae71ite = 578
                 and n.pae51eva = v.pae51eva
                 and v.pae51eva = 2
                 and n.pae70nro = (select max(pae70nro)
                                     from fpae70 a
                                    where pae70ins = pn_ins
                                      and a.pae51eva = 2)
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
      
        --LN_RATIOEP 554
        begin
          select to_number(trim(pae71val), '999999999.999999')
            into ln_ratio
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 554
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70ins = pn_ins;
        exception
          when no_data_found then
            null;
          
          when too_many_ROWS then
            begin
              select to_number(trim(pae71val), '999999999.999999')
                into ln_ratio
                from fpae70 n, fpae71 v
               where n.pae70nro = v.pae70nro
                 and v.pae71ite = 554
                 and n.pae51eva = v.pae51eva
                 and v.pae51eva = 2
                 and n.pae70nro = (select max(pae70nro)
                                     from fpae70 a
                                    where pae70ins = pn_ins
                                      and a.pae51eva = 2)
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
        --COD_OCUPACION 565
        begin
          select to_number(trim(pae71val))
            into ln_ocup
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 565
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70ins = pn_ins;
        exception
          when no_data_found then
            null;
          
          when too_many_ROWS then
            begin
              select to_number(trim(pae71val))
                into ln_ocup
                from fpae70 n, fpae71 v
               where n.pae70nro = v.pae70nro
                 and v.pae71ite = 565
                 and n.pae51eva = v.pae51eva
                 and v.pae51eva = 2
                 and n.pae70nro = (select max(pae70nro)
                                     from fpae70 a
                                    where pae70ins = pn_ins
                                      and a.pae51eva = 2)
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
      
        --TIPO_PERSONA 42
        begin
          select trim(pae71val)
            into lc_tipoPer
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 42
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70ins = pn_ins;
        exception
          when no_data_found then
            null;
          
          when too_many_ROWS then
            begin
              select trim(pae71val)
                into lc_tipoPer
                from fpae70 n, fpae71 v
               where n.pae70nro = v.pae70nro
                 and v.pae71ite = 42
                 and n.pae51eva = v.pae51eva
                 and v.pae51eva = 2
                 and n.pae70nro = (select max(pae70nro)
                                     from fpae70 a
                                    where pae70ins = pn_ins
                                      and a.pae51eva = 2)
                 and rownum = 1;
            exception
              when others then
                null;
            end;
          
          when others then
            null;
        end;
      
        begin
          select b.petipo
            into lc_tipo
            from fsr008 a, fsd001 b
           where a.ctnro = ln_cta
             and a.cttfir = 'T'
             and a.pepais = b.pepais
             and a.petdoc = b.petdoc
             and a.pendoc = b.pendoc;
        exception
          when others then
            null;
        end;
      
        --condiciones
      
        if lc_clienteNR = 'C' and ln_mod = 104 then
          ln_tope := 0.6;
        end if;
      
        if lc_clienteNR <> 'C' and ln_mod = 104 then
          ln_tope := 0.8;
        end if;
      
        if ln_sector = 1 and ln_ocup = 6 and lc_tipo <> 'J' then
          ln_tope := 1;
        end if;
      
        if ln_sector <> 1 and ln_ocup = 6 and lc_tipo <> 'J' then
          ln_tope := 0.9;
        end if;
      
        if ln_ocup in (1, 2, 3) and lc_tipo = 'J' then
          ln_tope := 0.9;
        end if;
      
        if ln_sector = 1 and ln_ocup in (5, 6, 7) and lc_tipo = 'J' then
          ln_tope := 1;
        end if;
      
        if ln_sector <> 1 and ln_ocup in (5, 6, 7) and lc_tipo = 'J' then
          ln_tope := 0.9;
        end if;
      
        if ln_ocup = 5 and lc_tipo <> 'J' then
          ln_tope := 0.9;
        end if;
      
        if ln_ocup = 4 and lc_tipoPer = 'F' then
          ln_tope := 1;
        end if;
      
        if ln_ocup in (8, 9) and lc_tipo = 'J' then
          ln_tope := 1;
        end if;
      
        ln_mto4 := nvl(ln_Patrimon, 0) *
                   (nvl(ln_tope, 0) - nvl(ln_ratio, 0));
      
        if ln_mto4 > ln_mtoMax then
          ln_mto4 := ln_mtoMax;
        end if;
      
        --mod@abr 20191023
      
        begin
          --maximo numero de creditos vigentes
          select a.tp1nro1
            into ln_maxVig
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 3
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
        lc_flgSeg := 'N';
        begin
          --segmentacion con monto en 0
          select 'S'
            into lc_flgSeg
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 6
             and a.tp1nro1 = ln_seg;
        exception
          when others then
            lc_flgSeg := 'N';
        end;
      
        lc_flgSeg := nvl(lc_flgSeg, 'N');
      
        if ln_contVig > ln_maxVig or lc_flgSeg = 'S' then
          ln_mtoFinal := 0;
        else
        
          begin
            select min(valor)
              into ln_mtoFinal
              from (select ln_mto1 valor
                      from dual
                    -- where ln_mto1 <> 0
                    union
                    select ln_mto2 valor
                      from dual
                    -- where ln_mto2 <> 0
                    union
                    select ln_mto3 valor
                      from dual
                    -- where ln_mto3 <> 0
                    union
                    select ln_mto4 valor
                      from dual);
          exception
            when others then
              null;
          end;
        
        end if;
      
        --plazo por tipologia SBS
        begin
          -- Tipo de Credito en el flujo
        
          select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval,
                                                         ';',
                                                         ''))),
                                          '([A-Z])',
                                          ''))
            into LN_TIPOCRED
            from wfattsvalues w
           where w.wfinsprcid = pn_ins
             and w.wfattsid = 'TIPO_CREDITO';
        exception
          when others then
            null;
        end;
      
        begin
          --plazo
          select a.tp1nro1
            into ln_plazo
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 5
             and a.tp1nro2 = LN_TIPOCRED;
        exception
          when others then
            null;
        end;
      
        begin
          --fecha rcc 
          select to_date(tpnro, 'dd/mm/yyyy')
            into ld_fecrcc
            from fst098
           where pgcod = 1
             and tpcod = 7647
             and tpcorr = 12;
        exception
          when others then
            ld_fecrcc := null;
        end;
      
        --Insertar log
      
        pn_mto := ln_mtoFinal;
        insert into JAQZ694
          (JAQZ694ins,
           JAQZ694eva,
           JAQZ694mt1,
           JAQZ694mt2,
           JAQZ694mt3,
           JAQZ694mtf,
           JAQZ694seg,
           JAQZ694plz,
           JAQZ694nrc,
           JAQZ694rcc,
           JAQZ694fep,
           JAQZ694usr,
           JAQZ694FVT,
           JAQZ694FV1,
           JAQZ694SBS)
        values
          (pn_ins,
           ln_eval,
           ln_mto1,
           ln_mto2,
           ln_mto3,
           ln_mtoFinal,
           ln_seg,
           ln_plazo,
           ln_contVig,
           ld_fecrcc,
           pd_fecpro,
           pc_usr,
           ld_fecvto,
           ld_fecvtoM1,
           LN_TIPOCRED);
      
        commit;
      
      else
      
        pn_mto := 0;
      end if;
    
    else
    
      begin
        select a.JAQZ694mtf
          into ln_mtoFinal
          from JAQZ694 a
         where a.JAQZ694ins = pn_ins;
      exception
        when others then
          ln_mtoFinal := 0;
      end;
    
      pn_mto := ln_mtoFinal;
    
    end if;
  
  end Sp_monto;

  Procedure Sp_monto_Politica(pn_ins    in number,
                              pd_fecpro in date,
                              pn_mto    out number) is
  
    ln_emp       number(3);
    ln_mod       number(3);
    ln_suc       number(3);
    ln_mda       number(4);
    ln_pap       number(4);
    ln_cta       number(9);
    ln_ope       number(9);
    ln_sbo       number(3);
    ln_top       number(3);
    ln_mtoAux1   number(17, 2);
    ln_mto1      number(17, 2);
    ln_mto2      number(17, 2);
    ln_mto3      number(17, 2);
    ln_porc      number(9);
    ln_eval      number(10);
    ln_tipcam    number(14, 8);
    ln_NivelDol  number(17, 2);
    ln_NivelSol  number(17, 2);
    ln_porcVen   number(9);
    ln_seg       number(5);
    ln_mtoSeg    number(17, 2);
    ln_MtoNivel  number(17, 2);
    ln_mtoVig    number(17, 2);
    ln_contVig   number(10);
    ln_maxVig    number(9);
    ln_mtoMax    number(17, 2);
    ln_mtoFinal  number(17, 2);
    lc_flgSeg    char(1);
    ln_ori       number(2);
    ln_PatriSol  number(17, 2); --mod@abr20191023
    ln_PatriDol  number(17, 2); --mod@abr20191023
    ln_Patrimon  number(17, 2); --mod@abr20191023
    ln_ratio     number(9, 6); --mod@abr20191023
    ln_sector    number(2); --mod@abr20191023
    lc_clienteNR char(2); --mod@abr20191023
    ln_ocup      number(5); --mod@abr20191023
    ln_tope      number(9, 2); --mod@abr20191023
    lc_tipo      char(1); --mod@abr20191023
    lc_tipoPer   char(2); --mod@abr20191023
    ln_mto4      number(17, 2); --mod@abr20191023
  
  begin
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope,
             a.xwfmonto1
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_mtoAux1
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      --monto maximo 
      select a.tp1nro1
        into ln_mtoMax
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 4
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    --verifica monto 50% campaña
    begin
      --porcentaje
      select a.tp1nro1
        into ln_porc
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 1
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ln_mto1 := (nvl(ln_mtoAux1, 0) * nvl(ln_porc, 0)) / 100;
    if ln_mto1 > ln_mtoMax then
      ln_mto1 := ln_mtoMax;
    end if;
  
    --Nivel de ventas
    begin
    
      select a.sng021eval
        into ln_eval
        from sng021 a
       where a.sng021sol = pn_ins;
    
    exception
      when others then
        null;
    end;
  
    begin
      --tipo de cambio
      select a.sng120tcbi
        into ln_tipcam
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      --nivel venta soles
      select a.sng023mto
        into ln_NivelSol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      --nivel venta dolares
      select a.sng023mto
        into ln_NivelDol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 573;
    exception
      when others then
        null;
    end;
  
    begin
      --porcentaje nivel ventas
      select a.tp1nro1
        into ln_porcVen
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ln_MtoNivel := nvl(ln_NivelSol, 0) +
                   (nvl(ln_NivelDol, 0) * nvl(ln_tipcam, 0));
    ln_mto2     := (nvl(ln_MtoNivel, 0) * nvl(ln_porcVen, 0)) / 100;
  
    if ln_mto2 > ln_mtoMax then
      ln_mto2 := ln_mtoMax;
    end if;
  
    --Segmentacion
  
    pq_cr_campaniaPyme_2019.Sp_Segmento_Des(pn_ins, ln_seg);
  
    begin
      select a.jaqz416c1
        into ln_mtoSeg
        from jaqz416 a
       where a.jaqz416seg = ln_seg;
    exception
      when others then
        null;
    end;
    pq_cr_campaniaPyme_2019.sp_creditosVigentes(pn_ins    => pn_ins,
                                                pd_fecpro => pd_fecpro,
                                                pn_tipcam => ln_tipcam,
                                                pn_mto    => ln_mtoVig,
                                                pn_cont   => ln_contVig);
    ln_mtoVig := nvl(ln_mtoVig, 0) + ln_mtoAux1;
    ln_mto3   := nvl(ln_mtoSeg, 0) - nvl(ln_mtoVig, 0);
  
    begin
      select a.sng001ori
        into ln_ori
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    if ln_ori <> 4 then
      ln_contVig := nvl(ln_contVig, 0) + 1;
    end if;
  
    if ln_mto3 > ln_mtoMax then
      ln_mto3 := ln_mtoMax;
    end if;
  
    --if ln_mto3 < 0 then
    --  ln_mto3 := 0;
    --end if;
  
    --mod@abr 20191023
    --Patrimonio
    begin
      --patrimonio soles
      select a.sng023mto
        into ln_PatriSol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 70;
    exception
      when others then
        null;
    end;
  
    begin
      --patrimonio dolares
      select a.sng023mto
        into ln_PatriDol
        from sng023 a
       where a.sng021eval = ln_eval
         and a.sng026cod = 570;
    exception
      when others then
        null;
    end;
  
    ln_Patrimon := nvl(ln_PatriSol, 0) + (nvl(ln_PatriDol, 0) * ln_tipcam);
  
    --SECTOR 132
    begin
      select to_number(trim(pae71val))
        into ln_sector
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 132
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 2
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select to_number(trim(pae71val))
            into ln_sector
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 132
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70nro = (select max(pae70nro)
                                 from fpae70 a
                                where pae70ins = pn_ins
                                  and a.pae51eva = 2)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
    --CLIENTE_NR  578
    begin
      select trim(pae71val)
        into lc_clienteNR
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 578
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 2
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select trim(pae71val)
            into lc_clienteNR
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 578
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70nro = (select max(pae70nro)
                                 from fpae70 a
                                where pae70ins = pn_ins
                                  and a.pae51eva = 2)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    --LN_RATIOEP 554
    begin
      select to_number(trim(pae71val), '999999999.999999')
        into ln_ratio
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 554
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 2
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select to_number(trim(pae71val), '999999999.999999')
            into ln_ratio
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 554
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70nro = (select max(pae70nro)
                                 from fpae70 a
                                where pae70ins = pn_ins
                                  and a.pae51eva = 2)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
    --COD_OCUPACION 565
    begin
      select to_number(trim(pae71val))
        into ln_ocup
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 565
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 2
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select to_number(trim(pae71val))
            into ln_ocup
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 565
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70nro = (select max(pae70nro)
                                 from fpae70 a
                                where pae70ins = pn_ins
                                  and a.pae51eva = 2)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    --TIPO_PERSONA 42
    begin
      select trim(pae71val)
        into lc_tipoPer
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 42
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 2
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select trim(pae71val)
            into lc_tipoPer
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 42
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 2
             and n.pae70nro = (select max(pae70nro)
                                 from fpae70 a
                                where pae70ins = pn_ins
                                  and a.pae51eva = 2)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    begin
      select b.petipo
        into lc_tipo
        from fsr008 a, fsd001 b
       where a.ctnro = ln_cta
         and a.cttfir = 'T'
         and a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc;
    exception
      when others then
        null;
    end;
  
    --condiciones
  
    if lc_clienteNR = 'C' and ln_mod = 104 then
      ln_tope := 0.6;
    end if;
  
    if lc_clienteNR <> 'C' and ln_mod = 104 then
      ln_tope := 0.8;
    end if;
  
    if ln_sector = 1 and ln_ocup = 6 and lc_tipo <> 'J' then
      ln_tope := 1;
    end if;
  
    if ln_sector <> 1 and ln_ocup = 6 and lc_tipo <> 'J' then
      ln_tope := 0.9;
    end if;
  
    if ln_ocup in (1, 2, 3) and lc_tipo = 'J' then
      ln_tope := 0.9;
    end if;
  
    if ln_sector = 1 and ln_ocup in (5, 6, 7) and lc_tipo = 'J' then
      ln_tope := 1;
    end if;
  
    if ln_sector <> 1 and ln_ocup in (5, 6, 7) and lc_tipo = 'J' then
      ln_tope := 0.9;
    end if;
  
    if ln_ocup = 5 and lc_tipo <> 'J' then
      ln_tope := 0.9;
    end if;
  
    if ln_ocup = 4 and lc_tipoPer = 'F' then
      ln_tope := 1;
    end if;
  
    if ln_ocup in (8, 9) and lc_tipo = 'J' then
      ln_tope := 1;
    end if;
  
    ln_mto4 := nvl(ln_Patrimon, 0) * (nvl(ln_tope, 0) - nvl(ln_ratio, 0));
    if ln_mto4 > ln_mtoMax then
      ln_mto4 := ln_mtoMax;
    end if;
    --mod@abr 20191023
  
    begin
      --maximo numero de creditos vigentes
      select a.tp1nro1
        into ln_maxVig
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 3
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
    lc_flgSeg := 'N';
    begin
      --segmentacion con monto en 0
      select 'S'
        into lc_flgSeg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 6
         and a.tp1nro1 = ln_seg;
    exception
      when others then
        lc_flgSeg := 'N';
    end;
  
    lc_flgSeg := nvl(lc_flgSeg, 'N');
  
    if ln_contVig > ln_maxVig or lc_flgSeg = 'S' then
      ln_mtoFinal := 0;
    else
    
      begin
        select min(valor)
          into ln_mtoFinal
          from (select ln_mto1 valor
                  from dual
                --where ln_mto1 <> 0
                union
                select ln_mto2 valor
                  from dual
                -- where ln_mto2 <> 0
                union
                select ln_mto3 valor
                  from dual
                union
                select ln_mto4 valor
                  from dual
                -- where ln_mto3 <> 0
                );
      exception
        when others then
          null;
      end;
    
    end if;
  
    pn_mto := ln_mtoFinal;
  
  end Sp_monto_Politica;

  Procedure Sp_Segmento_Des(pn_ins in number, pn_seg out number) is
    lc_segmentacion char(30);
  
  begin
    begin
      select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
        into lc_segmentacion
        from fpae70 n, fpae71 v
       where n.pae70nro = v.pae70nro
         and v.pae71ite = 380
         and n.pae51eva = v.pae51eva
         and v.pae51eva = 1
         and n.pae70ins = pn_ins;
    exception
      when no_data_found then
        null;
      
      when too_many_ROWS then
        begin
          select substr(pae71val, 1, INSTR(pae71val, ':') - 1)
            into lc_segmentacion
            from fpae70 n, fpae71 v
           where n.pae70nro = v.pae70nro
             and v.pae71ite = 380
             and n.pae51eva = v.pae51eva
             and v.pae51eva = 1
             and n.pae70nro = (select max(ff.pae70nro)
                                 from fpae70 ff
                                where ff.pae70ins = pn_ins
                                  and ff.pae51eva = 1)
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
      when others then
        null;
    end;
  
    begin
      select a.jaqy067ccal
        into pn_seg
        from jaqy067 a
       where a.jaqy067ncal = trim(lc_segmentacion)
         and a.jaqy067ccal >= 30;
    exception
      when others then
        null;
    end;
  
  end Sp_Segmento_Des;

  Procedure sp_creditosVigentes(pn_ins    in number,
                                pd_fecpro in date,
                                pn_tipcam in number,
                                pn_mto    out number,
                                pn_cont   out number) is
  
    cursor lista_cuentas is
    
      select distinct f.ctnro ln_cuenta
        from fsr008 f
       where (f.pepais, f.petdoc, f.pendoc) in
             (select f.pepais, f.petdoc, f.pendoc
                from sng001 s, fsr008 f
               where s.sng001inst = pn_ins
                 and s.sng001cta = f.ctnro
              union
              select g.rppais, g.rptdoc, g.rpndoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = pn_ins
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.pepais
                 and h.petdoc = g.petdoc
                 and h.pendoc = g.pendoc
                 and g.rpccyg = 66
              union
              select g.pepais, g.petdoc, g.pendoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = pn_ins
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.rppais
                 and h.petdoc = g.rptdoc
                 and h.pendoc = g.rpndoc
                 and g.rpccyg = 66);
  
    cursor cred_vigentes(ln_cuenta number) is
    
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
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (116, 108)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro;
  
    ln_ins       number(10);
    ln_ori       number(2);
    ln_mtoCap    number(17, 2);
    ln_mtoCapTot number(17, 2);
    ln_cont      number(10);
    ln_pai       number(3);
    ln_tdo       number(2);
    ln_ndo       char(12);
    lc_flg       char(1);
    lc_flgAmp    char(1);
  begin
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, ln_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    ln_mtoCapTot := 0;
    ln_cont      := 0;
  
    for k in lista_cuentas loop
      for i in cred_vigentes(k.ln_cuenta) loop
      
        --verifica si es parcial
        ln_ins := fn_instancia_credito(v_Scmod  => i.ln_mod10,
                                       v_Scsuc  => i.ln_suc10,
                                       v_Scmda  => i.ln_mda10,
                                       v_Scpap  => i.ln_pap10,
                                       v_Sccta  => i.ln_cta10,
                                       v_Scoper => i.ln_oper10,
                                       v_Scsbop => i.ln_sbop10,
                                       v_Sctope => i.ln_tope10);
        begin
          select a.sng001ori
            into ln_ori
            from sng001 a
           where a.sng001inst = ln_ins;
        exception
          when others then
            null;
        end;
      
        if ln_ori = 7 then
        
          begin
            select a.sng120mto
              into ln_mtoCap
              from sng120 a
             where a.sng120ins = ln_ins
               and a.sng120tsk like 'APROBAC%'
               and rownum = 1;
          exception
            when others then
              null;
          end;
          if i.ln_mda10 = 101 then
            ln_mtoCap := nvl(ln_mtoCap, 0) * pn_tipcam;
          end if;
        
        else
        
          begin
            select scsdo
              into ln_mtoCap
              from fsd011 a
             where a.pgcod = i.ln_pgcod10
               and a.scmod = i.ln_mod10
               and a.scsuc = i.ln_suc10
               and a.scmda = i.ln_mda10
               and a.scpap = i.ln_pap10
               and a.sccta = i.ln_cta10
               and a.scoper = i.ln_oper10
               and a.scsbop = i.ln_sbop10
               and a.sctope = i.ln_tope10;
          exception
            when others then
              null;
          end;
        
          if ln_mtoCap < 0 then
            ln_mtoCap := nvl(ln_mtoCap, 0) * -1;
          end if;
        
          if i.ln_mda10 = 101 then
            ln_mtoCap := ln_mtoCap * pn_tipcam;
          end if;
        end if;
      
        pq_cr_campaniaPyme_2019.Sp_ampliados_CK(ln_emp10  => i.ln_pgcod10,
                                                ln_mod10  => i.ln_mod10,
                                                ln_suc10  => i.ln_suc10,
                                                ln_mda10  => i.ln_mda10,
                                                ln_pap10  => i.ln_pap10,
                                                ln_cta10  => i.ln_cta10,
                                                ln_oper10 => i.ln_oper10,
                                                ln_sbop10 => i.ln_sbop10,
                                                ln_tope10 => i.ln_tope10,
                                                Pc_flag   => lc_flgAmp);
      
        if nvl(lc_flgAmp, 'N') = 'N' then
          ln_mtoCapTot := nvl(ln_mtoCapTot, 0) + nvl(ln_mtoCap, 0);
        end if;
        --cuenta creditos
        pq_cr_campaniaPyme_2019.Sp_Adicional_CK(i.ln_mod10,
                                                i.ln_tope10,
                                                lc_flg);
        if nvl(lc_flg, 'N') = 'N' and nvl(lc_flgAmp, 'N') = 'N' then
          ln_cont := ln_cont + 1;
        end if;
      
      end loop;
    end loop;
    pn_mto  := ln_mtoCapTot;
    pn_cont := ln_cont;
  
  end sp_creditosVigentes;

  Procedure Sp_Adicional_CK(pn_mod  in number,
                            pn_top  in number,
                            Pc_flag out char) is
  
  begin
    if pn_mod = 117 then
      begin
        select 'S'
          into Pc_flag
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 20001
           and a.tp1corr1 = 1
           and a.tp1corr2 = 1211
           and a.tp1nro1 = pn_top;
      
      exception
        when no_data_found then
          Pc_flag := 'N';
      end;
    else
      Pc_flag := 'N';
    end if;
  
  end Sp_Adicional_CK;

  Procedure Sp_ampliados_CK(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            Pc_flag   out varchar2) is --mod 2016.04.12
  
  begin
  
    begin
    
      select 'S'
        into Pc_flag
        from xwf700 a, sng001 s /* xwf070 w,*/, wfwrkitems x
       where a.xwfempresa = ln_emp10
         and a.xwfsucursal = ln_suc10
         and a.xwfmodulo = ln_mod10
         and a.xwfmoneda = ln_mda10
         and a.xwfpapel = ln_pap10
         and a.xwfcuenta = ln_cta10
         and a.xwfoperacion = ln_oper10
         and a.xwfsubope = ln_sbop10
         and a.xwftipope = ln_tope10
         and a.xwfprcins = s.sng001inst
         and s.sng001ori in (4, 15) -- Ampliaciones Normales, Ampliaciones Especiales
         and s.sng001inst = x.wfinsprcid
         and x.wfitemstsact = 1
         and rownum = 1;
    exception
      when no_data_found then
        Pc_flag := 'N';
    end;
  
  end Sp_ampliados_CK;

end pq_cr_campaniaPyme_2019;
/

