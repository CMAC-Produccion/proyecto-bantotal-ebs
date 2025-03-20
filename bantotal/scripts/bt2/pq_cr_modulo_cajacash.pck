create or replace package pq_cr_modulo_cajacash is

  procedure Sp_verifica_cajaCash(pn_pai     in number,
                                 pn_tdo     in number,
                                 pc_ndo     in char,
                                 pd_Fecpro  in date,
                                 pc_flg     out char,
                                 pn_ins     out number,
                                 pn_segori  out number,
                                 pn_segact  out number,
                                 pc_flgSeg  out char,
                                 pd_fvto    out date,
                                 pc_flgVto  out char,
                                 pc_flgSis  out char,
                                 pn_pasAnt  out number,
                                 pn_PasAct  out number,
                                 pc_flgPas  out char,
                                 pn_cal     out number,
                                 pc_flgCal  out char,
                                 pd_fecCal  out date,
                                 pn_prom    out number,
                                 pc_flgProm out char,
                                 pc_flgMora out char,
                                 pc_flgVig  out char,
                                 pn_mto4    out number,
                                 pc_flgPat  out char,
                                 pn_dia     out number,
                                 pd_fecVig  out date);
  Procedure Sp_segmento(pn_ins    in number,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        ln_segOri out number,
                        ln_SegAct out number,
                        pc_flg    out char);
  Procedure Sp_fecVcto(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec out date,
                       pc_flg out char);
  Procedure Sp_cr_sdoCaja(pn_ins    in number,
                          pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pd_fecpro in date,
                          pn_pasAnt out number,
                          pn_PasAct out number,
                          pc_flg    out char);
  procedure sp_cuentasRatio(ln_Pepais     in number,
                            ln_Petdoc     in number,
                            ln_Pendoc     in char,
                            tipocambio    in number,
                            Instancia     in number,
                            pd_fecpro     in date,
                            ln_captotcaja out number);
  procedure sp_resolutor(tipocambio  in number,
                         Instancia   in number,
                         ln_pgcod10  in number,
                         ln_mod10    in number,
                         ln_suc10    in number,
                         ln_mda10    in number,
                         ln_pap10    in number,
                         ln_cta10    in number,
                         ln_oper10   in number,
                         ln_sbop     in number,
                         ln_tope10   in number,
                         lc_fgRefLin in varchar2,
                         ln_saldocap out number);
  procedure sp_resolutor_venc(tipocambio   in number,
                              Instancia    in number,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              ln_capacidad out number);
  Procedure Sp_calificacion(pn_pai    in number,
                            pn_tdo    in number,
                            pc_ndo    in char,
                            pn_ins    in number,
                            pn_cal    out number,
                            pc_flg    out char,
                            pd_fecCal out date);
  procedure sp_cr_inicio(ln_Instancia in number, pd_FecRCC out date);
  procedure sp_Cr_DeudaIFIS_ME(ln_Instancia in number, pd_FecRCC out date);
  Procedure Sp_Mora(pn_pai     in number,
                    pn_tdo     in number,
                    pc_ndo     in char,
                    pd_Fecpro  in date,
                    pn_emp     in number,
                    pn_mod     in number,
                    pn_suc     in number,
                    pn_mda     in number,
                    pn_pap     in number,
                    pn_cta     in number,
                    pn_ope     in number,
                    pn_sbo     in number,
                    pn_top     in number,
                    pn_prom    out number,
                    pc_flgProm out char,
                    pc_flgMora out char,
                    pn_dia     out number);
  Procedure Sp_controlPatrimonio(pn_ins  in number,
                                 pn_cta  in number,
                                 pn_mod  in number,
                                 pn_mto  in number,
                                 pn_mto4 out number,
                                 pc_flg  out char);
  Procedure Sp_calificacion_RCC(TipDocSbs   in char,
                                pc_ndo_FN   in char,
                                pd_fecRcc   in date,
                                MesRcc      in number,
                                lc_tiper_FN in char,
                                pn_cal      out number,
                                pd_fecCal   out date);
  Procedure Sp_plazo(pn_ins in number, pn_plazo out number);
  Procedure Sp_valida_cuenta(pn_pai in number,
                             pn_tdo in number,
                             pc_ndo in char,
                             pn_cta out number,
                             pc_flg out char);

  Procedure Sp_insert_bandeja1(pn_ins    in number,
                               pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pn_pzo    in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_cuo    in number,
                               pn_cta    in number,
                               pc_flg    out char,
                               pc_ase    out char);
  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char);
  Procedure Sp_insert_bandeja3(pn_ins in number, pc_ndo in char);
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

end pq_cr_modulo_cajacash;
/

create or replace package body pq_cr_modulo_cajacash is

  procedure Sp_verifica_cajaCash(pn_pai     in number,
                                 pn_tdo     in number,
                                 pc_ndo     in char,
                                 pd_Fecpro  in date,
                                 pc_flg     out char,
                                 pn_ins     out number,
                                 pn_segori  out number,
                                 pn_segact  out number,
                                 pc_flgSeg  out char,
                                 pd_fvto    out date,
                                 pc_flgVto  out char,
                                 pc_flgSis  out char,
                                 pn_pasAnt  out number,
                                 pn_PasAct  out number,
                                 pc_flgPas  out char,
                                 pn_cal     out number,
                                 pc_flgCal  out char,
                                 pd_fecCal  out date,
                                 pn_prom    out number,
                                 pc_flgProm out char,
                                 pc_flgMora out char,
                                 pc_flgVig  out char,
                                 pn_mto4    out number,
                                 pc_flgPat  out char,
                                 pn_dia     out number,
                                 pd_fecVig  out date) is
  
    ln_ins    number(10);
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
    ln_mtoFin number(17, 2);
  
  begin
    begin
      select max(b.jaqz694ins)
        into ln_ins
        from sng001 a, jaqz694 b
       where a.sng001pais = pn_pai
         and a.sng001tdoc = pn_tdo
         and a.sng001ndoc = pc_ndo
         and b.jaqz694ins = a.sng001inst;
    exception
      when others then
        null;
    end;
  
    pn_ins := ln_ins;
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = ln_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if nvl(ln_ins, 0) <> 0 then
      pc_flg := 'S'; --Si existe
    else
      pc_flg := 'N';
    
    end if;
  
    --verifica segmento
    pq_Cr_modulo_cajacash.sp_segmento(ln_ins,
                                      pn_pai,
                                      pn_tdo,
                                      pc_ndo,
                                      pn_segori,
                                      pn_segact,
                                      pc_flgSeg);
  
    --verifica pago de vencimiento de cuota
    pq_Cr_modulo_cajacash.Sp_fecVcto(ln_emp,
                                     ln_mod,
                                     ln_suc,
                                     ln_mda,
                                     ln_pap,
                                     ln_cta,
                                     ln_ope,
                                     ln_sbo,
                                     ln_top,
                                     pd_fvto,
                                     pc_flgVto);
  
    if pd_Fecpro > pd_fvto then
      pc_flgSis := 'S'; --CUMPLE fecha de proceso posterior al vencimiento
    else
      pc_flgSis := 'N';
    end if;
    --verifica saldo caja
    Pq_Cr_Modulo_Cajacash.Sp_cr_sdoCaja(pn_ins    => ln_ins,
                                        pn_emp    => ln_emp,
                                        pn_mod    => ln_mod,
                                        pn_suc    => ln_suc,
                                        pn_mda    => ln_mda,
                                        pn_pap    => ln_pap,
                                        pn_cta    => ln_cta,
                                        pn_ope    => ln_ope,
                                        pn_sbo    => ln_sbo,
                                        pn_top    => ln_top,
                                        pn_pai    => pn_pai,
                                        pn_tdo    => pn_tdo,
                                        pc_ndo    => pc_ndo,
                                        pd_fecpro => pd_fecpro,
                                        pn_pasAnt => pn_pasAnt,
                                        pn_PasAct => pn_PasAct,
                                        pc_flg    => pc_flgPas);
    --verifica calificacion
    pq_cr_modulo_cajacash.Sp_calificacion(pn_pai    => pn_pai,
                                          pn_tdo    => pn_tdo,
                                          pc_ndo    => pc_ndo,
                                          pn_ins    => ln_ins,
                                          pn_cal    => pn_cal,
                                          pc_flg    => pc_flgCal,
                                          pd_fecCal => pd_fecCal);
  
    --Mora y promedio de mora
    Pq_Cr_Modulo_Cajacash.sp_mora(pn_pai,
                                  pn_tdo,
                                  pc_ndo,
                                  pd_Fecpro,
                                  ln_emp,
                                  ln_mod,
                                  ln_suc,
                                  ln_mda,
                                  ln_pap,
                                  ln_cta,
                                  ln_ope,
                                  ln_sbo,
                                  ln_top,
                                  pn_prom,
                                  pc_flgProm,
                                  pc_flgMora,
                                  pn_dia);
  
    --Fecha vigencia de campaña                                  
    begin
      select to_date(a.tp1nro1, 'dd/mm/yyyy')
        into pd_fecVig
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 9
         and a.tp1corr3 = 2;
    exception
      when no_data_found then
        pd_fecVig := null;
    end;
    --pd_fecVig := to_date('31/03/2019', 'dd/mm/yyyy');
  
    if pd_fecpro > pd_fecVig then
      pc_flgVig := 'S'; --incumple fecha vigencia
    else
      pc_flgVig := 'N';
    end if;
  
    --control patrimonio
    pq_cr_modulo_cajacash.Sp_controlPatrimonio(ln_ins,
                                               ln_cta,
                                               ln_mod,
                                               ln_mtoFin,
                                               pn_mto4,
                                               pc_flgPat);
  
    ----------------------------PRUEBA----------------------------
    --pc_flgVig := 'N';
    --pc_flgSis := 'S';
    --pc_flgVto := 'S';
    --pc_flgSeg := 'S';
  
  end Sp_verifica_cajaCash;

  Procedure Sp_segmento(pn_ins    in number,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        ln_segOri out number,
                        ln_SegAct out number,
                        pc_flg    out char) is
  
  begin
  
    begin
      select to_number(trim(g.pae71val))
        into ln_segOri
        from fpae70 f, fpae71 g
       where f.pae51eva = g.pae51eva
         and f.pae70nro = g.pae70nro
         and f.pae70ins = pn_ins
         and f.pae51eva = 2
         and g.pae71ite = 43;
    exception
      when too_many_rows then
        begin
          select TO_NUMBER(trim(g.pae71val))
            into ln_segOri
            from fpae70 f, fpae71 g
           where f.pae51eva = g.pae51eva
             and f.pae70nro = g.pae70nro
             and f.pae70ins = pn_ins
             and f.pae51eva = 2
             and g.pae71ite = 43
             and f.pae70nro = (select max(f.pae70nro)
                                 from fpae70 f
                                where f.pae70ins = pn_ins
                                  and f.pae51eva = 2);
        end;
      when others then
        null;
    end;
  
    begin
      select b.segcod
        into ln_SegAct
        from sngc60 a, sngc07 b
       where a.sngc60pais = pn_pai
         and a.sngc60tdoc = pn_tdo
         and a.sngc60ndoc = pc_ndo
         and a.sngc60corr = 0
         and a.sngc60ocup = b.sngc07cod;
    exception
      when others then
        null;
    end;
  
    if ln_SegAct = ln_segOri then
      pc_flg := 'S'; --cumple segmento actual igual al del origen
    else
      pc_flg := 'N';
    
    end if;
  
  end Sp_segmento;

  Procedure Sp_fecVcto(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec out date,
                       pc_flg out char) is
    ld_fecpago date;
  
  begin
  
    begin
      select min(a.ppfpag)
        into ld_fecpago
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
         and a.d601co = 'S';
    exception
      when others then
        null;
    end;
  
    begin
      select 'S' --si cumple pago del primer vencimiento
        into pc_flg
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
         and a.ppfpag = ld_fecpago
         and a.pp1stat = 'T'
         and a.d602co = 'S'
         and rownum = 1;
    exception
      when others then
        pc_flg := 'N';
    end;
  
    pd_fec := ld_fecpago;
  
  end Sp_fecVcto;

  Procedure Sp_cr_sdoCaja(pn_ins    in number,
                          pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_ope    in number,
                          pn_sbo    in number,
                          pn_top    in number,
                          pn_pai    in number,
                          pn_tdo    in number,
                          pc_ndo    in char,
                          pd_fecpro in date,
                          pn_pasAnt out number,
                          pn_PasAct out number,
                          pc_flg    out char) is
  
    ln_mtoDes number(17, 2) := 0;
    ln_sdoPas number(17, 2) := 0;
    ln_tipcam number(14, 8);
  
  begin
  
    begin
      select a.aoimp
        into ln_mtoDes
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top;
    exception
      when others then
        null;
    end;
  
    --obtener pasivo log 
    begin
      select sum(a.jaqy148saldcap)
        into ln_sdoPas
        from jaqy148 a
       where a.jaqy148inst = pn_ins
         and a.jaqy148est = 'H'
         and a.jaqy148indic <> 'CredEnVuelo';
    exception
      when others then
        null;
    end;
  
    pn_pasAnt := nvl(ln_sdoPas, 0) + nvl(ln_mtoDes, 0);
  
    --calculo pasivo actual
  
    begin
      --tipo de cambio
      select cotcbi
        into ln_tipcam
        from fsh005 f
       where cofdes in (select max(cofdes)
                          from fsh005 g
                         where g.cofdes <= pd_fecpro
                           and moneda = 101)
         and moneda = 101;
    exception
      when no_data_found then
        ln_tipcam := 0;
    end;
  
    Pq_Cr_Modulo_Cajacash.sp_cuentasRatio(pn_pai,
                                          pn_tdo,
                                          pc_ndo,
                                          ln_tipcam,
                                          0,
                                          pd_Fecpro,
                                          pn_PasAct);
  
    if pn_PasAct <= pn_pasAnt then
      pc_flg := 'S'; --cumple con el pasivo caja
    else
      pc_flg := 'N';
    end if;
  
  end Sp_cr_sdoCaja;

  procedure sp_cuentasRatio(ln_Pepais     in number,
                            ln_Petdoc     in number,
                            ln_Pendoc     in char,
                            tipocambio    in number,
                            Instancia     in number,
                            pd_fecpro     in date,
                            ln_captotcaja out number) is
  
    cursor inserta is
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
                              and pendoc = ln_Pendoc)
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or d10.Aomod in (141))
         and d10.Aostat <> 99
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in ((select tp1nro1
                                       from fst198 a
                                      where a.tp1cod = 1
                                        and a.tp1cod1 = 10899
                                        and a.tp1corr1 = 17
                                        and a.tp1corr2 = 2))
                  and modulo not in (29, 33, 200)) or b.Aomod in (141))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    cursor linea is
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
                              and pendoc = ln_Pendoc)
         and d10.Aomod = 117
         and d10.Aostat <> 99
         and d10.aofvto > pd_fecpro
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.Aomod in (117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto > pd_fecpro;
  
    cursor lineas_ven is
    
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
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      --and Aostat = 99
      
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
            --and b.aostat = 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred varchar2(12);
  
    ln_capacidad number;
    lc_fgAmpl    varchar2(1) := 'N';
    lc_ven       char(1);
    ln_indicador number;
    lc_fgRefLin  varchar2(1) := 'N';
    lc_fgRepro   varchar2(2) := 'N';
    lc_FlgLn     varchar2(2) := 'N';
    --Patrimonio     number(10, 2);
    --evaluacion     number(10, 2);
    --mntsoles       number(10, 2);
    --mntdolar       number(10, 2);
    --saldo_extSoles NUMBER(10, 2);
    --saldo_extDol   number(10, 2);
    --saldo_externo number(10, 2);
    --ln_cajaext   number(10, 2);
    --ln_captotal1 number(10, 6);
    --ln_captotal  number(10, 6);
  
  begin
  
    ln_captotcaja := 0;
  
    for i in inserta loop
    
      ln_indicador := 1;
      lc_IndCred   := 'CredVigente';
    
      if lc_fgRefLin <> 'S' and lc_fgAmpl <> 'S' AND lc_fgRepro <> 'S' and
         lc_FlgLn <> 'S' then
        pq_cr_modulo_cajacash.sp_resolutor(tipocambio,
                                           Instancia,
                                           i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           lc_fgRefLin,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    for l in linea loop
    
      ln_indicador := 1;
      lc_IndCred   := 'CredLinea';
    
      if lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
      
        pq_cr_modulo_cajacash.sp_resolutor(tipocambio,
                                           Instancia,
                                           l.ln_pgcod10,
                                           l.ln_mod10,
                                           l.ln_suc10,
                                           l.ln_mda10,
                                           l.ln_pap10,
                                           l.ln_cta10,
                                           l.ln_oper10,
                                           l.ln_sbop10,
                                           l.ln_tope10,
                                           lc_fgRefLin,
                                           ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
    
      ln_indicador := 3;
      begin
        select 'S'
          into lc_ven
          from fsr011 a, fsd010 b
         where a.r2cod = j.ln_pgcod10
           and a.r2mod = j.ln_mod10
           and a.r2suc = j.ln_suc10
           and a.r2mda = j.ln_mda10
           and a.r2pap = j.ln_pap10
           and a.r2cta = j.ln_cta10
           and a.r2oper = j.ln_oper10
           and a.r2sbop = j.ln_sbop10
           and a.r2tope = j.ln_tope10
           and a.r1cod = b.pgcod
           and a.r1mod = b.aomod
           and a.r1suc = b.aosuc
           and a.r1mda = b.aomda
           and a.r1pap = b.aopap
           and a.r1cta = b.aocta
           and a.r1oper = b.aooper
           and a.r1sbop = b.aosbop
           and a.r1tope = b.aotope
           and b.aostat <> 99
           and relcod = 46
           and rownum = 1;
      exception
        when no_data_found then
          lc_ven := 'N';
      end;
    
      if lc_ven = 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        pq_cr_modulo_cajacash.sp_resolutor_venc(tipocambio,
                                                Instancia,
                                                j.ln_pgcod10,
                                                j.ln_mod10,
                                                j.ln_suc10,
                                                j.ln_mda10,
                                                j.ln_pap10,
                                                j.ln_cta10,
                                                j.ln_oper10,
                                                j.ln_sbop10,
                                                j.ln_tope10,
                                                ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
  end sp_cuentasRatio;

  procedure sp_resolutor(tipocambio  in number,
                         Instancia   in number,
                         ln_pgcod10  in number,
                         ln_mod10    in number,
                         ln_suc10    in number,
                         ln_mda10    in number,
                         ln_pap10    in number,
                         ln_cta10    in number,
                         ln_oper10   in number,
                         ln_sbop     in number,
                         ln_tope10   in number,
                         lc_fgRefLin in varchar2,
                         ln_saldocap out number) is
  
  begin
  
    If lc_fgRefLin <> 'S' then
    
      PQ_CR_SALDOPYME.sp_cr_saldocapital(ln_pgcod10,
                                         ln_mod10,
                                         ln_suc10,
                                         ln_mda10,
                                         ln_pap10,
                                         ln_cta10,
                                         ln_oper10,
                                         ln_sbop,
                                         ln_tope10,
                                         tipocambio,
                                         Instancia,
                                         ln_saldocap);
    else
      if lc_fgRefLin = 'S' then
      
        PQ_CR_SALDOPYME.sp_cr_saldocapitalref(tipocambio,
                                              Instancia,
                                              ln_saldocap);
      
      End if;
    
    End if;
  
  end sp_resolutor;

  procedure sp_resolutor_venc(tipocambio   in number,
                              Instancia    in number,
                              ln_pgcod10   in number,
                              ln_mod10     in number,
                              ln_suc10     in number,
                              ln_mda10     in number,
                              ln_pap10     in number,
                              ln_cta10     in number,
                              ln_oper10    in number,
                              ln_sbop10    in number,
                              ln_tope10    in number,
                              ln_capacidad out number) is
    ln_saldocap number;
    -- ln_parciales  number;
    /* ln_cuotimp    number;
    ln_seguro     number;
    fech_maxcuota date;*/
    --   ln_instancia  number;
    lc_ven char(1);
  
    cursor creditos is
      select a.r1cod  ln_pgcod10,
             a.r1mod  ln_mod10,
             a.r1suc  ln_suc10,
             a.r1mda  ln_mda10,
             a.r1pap  ln_pap10,
             a.r1cta  ln_cta10,
             a.r1oper ln_oper10,
             a.r1sbop ln_sbop10,
             a.r1tope ln_tope10
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46;
  
    -- ln_pr116  number;
    --  ln_capTem number;
  
  begin
  
    begin
      select 'S'
        into lc_ven
        from fsr011 a, fsd010 b
       where a.r2cod = ln_pgcod10
         and a.r2mod = ln_mod10
         and a.r2suc = ln_suc10
         and a.r2mda = ln_mda10
         and a.r2pap = ln_pap10
         and a.r2cta = ln_cta10
         and a.r2oper = ln_oper10
         and a.r2sbop = ln_sbop10
         and a.r2tope = ln_tope10
         and a.r1cod = b.pgcod
         and a.r1mod = b.aomod
         and a.r1suc = b.aosuc
         and a.r1mda = b.aomda
         and a.r1pap = b.aopap
         and a.r1cta = b.aocta
         and a.r1oper = b.aooper
         and a.r1sbop = b.aosbop
         and a.r1tope = b.aotope
         and b.aostat <> 99
         and a.relcod = 46
         and rownum = 1;
    exception
      when no_data_found then
        lc_ven := 'N';
    end;
  
    if lc_ven = 'S' then
      for i in creditos loop
      
        PQ_CR_SALDOPYME.sp_cr_saldocapital(i.ln_pgcod10,
                                           i.ln_mod10,
                                           i.ln_suc10,
                                           i.ln_mda10,
                                           i.ln_pap10,
                                           i.ln_cta10,
                                           i.ln_oper10,
                                           i.ln_sbop10,
                                           i.ln_tope10,
                                           tipocambio,
                                           Instancia,
                                           ln_saldocap);
      
        ln_capacidad := nvl(ln_capacidad, 0) + nvl(ln_saldocap, 0);
      
      end loop;
    end if;
  
  end sp_resolutor_venc;

  Procedure Sp_calificacion(pn_pai    in number,
                            pn_tdo    in number,
                            pc_ndo    in char,
                            pn_ins    in number,
                            pn_cal    out number,
                            pc_flg    out char,
                            pd_fecCal out date) is
  
    lc_DocSbsTit char(1);
    ld_FecRCC    date;
    lc_tiper     char(1);
    ld_fecRCCIni date;
    ln_paiC      number(3);
    ln_tdoC      number(2);
    lc_ndoC      char(12);
    lc_DocSbsCyg char(1);
    lc_tiperCyg  char(1);
    ln_mesRCC    number(10);
  
  begin
  
    --Guia equivalencia tipo de documento
    begin
      select Trim(to_char(a.tp1corr3))
        into lc_DocSbsTit
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        lc_DocSbsTit := null;
    end;
  
    begin
      select to_date(tpnro, 'dd/mm/yyyy')
        into ld_FecRCC
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        ld_FecRCC := null;
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
  
    begin
      select max(a.jaqy327frcc)
        into ld_fecRCCIni
        from jaqy327 a
       where a.jaqy327inst = pn_ins
         and a.jaqy327esta = 'S';
    exception
      when others then
        null;
    end;
  
    if ld_fecRCCIni is null then
      pq_cr_modulo_cajacash.sp_cr_deudaIFIS_ME(pn_ins, ld_fecRCCIni);
    end if;
  
    begin
      select trunc(months_between(ld_FecRCC, ld_fecRCCIni))
        into ln_mesRCC
        from dual;
    exception
      when others then
        ln_mesRCC := 1;
    end;
    if ln_mesRCC = 0 then
      ln_mesRCC := 1;
    end if;
  
    pn_cal := 100.00;
  
    pq_cr_modulo_cajacash.Sp_calificacion_RCC(lc_DocSbsTit,
                                              pc_ndo,
                                              ld_FecRCC,
                                              ln_mesRCC,
                                              lc_tiper,
                                              pn_cal,
                                              
                                              pd_fecCal);
  
    --evalua conyugue si la calificacion es normal para el titular
  
    begin
      select a.rppais, a.rptdoc, a.rpndoc
        into ln_paiC, ln_tdoC, lc_ndoC
        from fsr002 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.rpccyg = 66
         and rownum = 1;
    exception
      when no_data_found then
        ln_paiC := null;
        ln_tdoC := null;
        lc_ndoC := null;
    end;
  
    --Guia equivalencia tipo de documento
    begin
      select Trim(to_char(a.tp1corr3))
        into lc_DocSbsCyg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdoC;
    exception
      when no_data_found then
        lc_DocSbsCyg := null;
    end;
  
    --tipo de persona
    begin
      select a.petipo
        into lc_tiperCyg
        from fsd001 a
       where a.pepais = ln_paiC
         and a.petdoc = ln_tdoC
         and a.pendoc = lc_ndoC;
    exception
      when no_data_found then
        lc_tiperCyg := null;
    end;
  
    if pn_cal = 100.00 and lc_ndoC is not null then
    
      pq_cr_modulo_cajacash.Sp_calificacion_RCC(lc_DocSbsCyg,
                                                lc_ndoC,
                                                ld_FecRCC,
                                                ln_mesRCC,
                                                lc_tiperCyg,
                                                pn_cal,
                                                pd_fecCal);
    
    end if;
  
    if pn_cal = 100 then
      pc_flg := 'S'; --cumple con calificacion
    else
      pc_flg := 'N';
    end if;
  
  end Sp_calificacion;

  procedure sp_cr_inicio(ln_Instancia in number, pd_FecRCC out date) is
  
    lc_TieneInfoPSD varchar2(2) := 'S';
    lc_VerfEval     varchar2(2) := 'S';
    ln_NroSolCred   number(10);
    ln_NroEval      number(10);
  
  begin
  
    pq_Cr_mantiene_eval.sp_cr_verifPSD(ln_Instancia, lc_TieneInfoPSD);
    pq_cr_mantiene_eval.sp_cr_verifEval(ln_Instancia, lc_VerfEval);
  
    if lc_TieneInfoPSD = 'N' and lc_VerfEval = 'S' then
      PQ_Cr_mantiene_eval.sp_Cr_VerfUltEvaluacion(ln_Instancia,
                                                  ln_NroSolCred,
                                                  ln_NroEval);
    
      if ln_NroSolCred > 0 and ln_NroEval > 0 then
        pq_cr_modulo_cajacash.sp_Cr_DeudaIFIS_ME(ln_Instancia => ln_NroSolCred,
                                                 pd_FecRCC    => pd_FecRCC);
      
      end if;
    
    end if;
  
  end sp_cr_inicio;

  procedure sp_Cr_DeudaIFIS_ME(ln_Instancia in number, pd_FecRCC out date) is
  
  begin
    begin
    
      begin
        select max(j.jaqy327frcc)
          into pd_FecRCC
          from jaqy327 j
         where j.jaqy327inst = ln_Instancia
           and j.jaqy327esta = 'S';
      
      exception
        when others then
          pd_FecRCC := null;
        
      end;
    
    end;
  end sp_Cr_DeudaIFIS_ME;

  Procedure Sp_Mora(pn_pai     in number,
                    pn_tdo     in number,
                    pc_ndo     in char,
                    pd_Fecpro  in date,
                    pn_emp     in number,
                    pn_mod     in number,
                    pn_suc     in number,
                    pn_mda     in number,
                    pn_pap     in number,
                    pn_cta     in number,
                    pn_ope     in number,
                    pn_sbo     in number,
                    pn_top     in number,
                    pn_prom    out number,
                    pc_flgProm out char,
                    pc_flgMora out char,
                    pn_dia     out number) is
  
    cursor clientes is
      select distinct A.CTNRO
        from fsr008 a
        left join fsr002 b
          on a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc
         and b.rpccyg = 66
      
       where ctnro in (select ctnro
                         from fsr008 a
                        where a.pepais = pn_pai
                          and a.petdoc = pn_tdo
                          and a.pendoc = pc_ndo);
  
    cursor creditos(ln_cta in number) is
      select distinct B.PGCOD,
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
                      b.aostat,
                      a.pepais,
                      a.petdoc,
                      a.pendoc
        from fsd010 b, fsr008 a
       where b.pgcod = 1
         and b.aocta = ln_cta
         and b.pgcod = a.pgcod
         and b.aocta = a.ctnro
         and a.cttfir = 'T'
         and aomod in (select modulo
                         from fst111
                        where dscod = 50
                          and modulo not in (200, 33, 108))
            
         and aotope <> 550
         and aostat <> 99
       order by aofval desc;
  
    cursor cuotas is
    --14052020
      select /*+index(a FSD60107)*/ a.*
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
         and a.d601co = 'S';
  
    ln_diaMax number(9) := null;
    ln_diaMor number(10);
    ln_MorMax number(10) := 0;
  begin
  
    for k in cuotas loop
      ln_diaMor := pq_Cr_modulo_cajacash.fn_cuotasPag(pn_emp,
                                                      pn_mod,
                                                      pn_suc,
                                                      pn_mda,
                                                      pn_pap,
                                                      pn_cta,
                                                      pn_ope,
                                                      pn_sbo,
                                                      pn_top,
                                                      k.ppfpag,
                                                      pd_Fecpro);
    
      if nvl(ln_diaMor, 0) > ln_MorMax then
        ln_MorMax := nvl(ln_diaMor, 0);
      end if;
    
    end loop;
  
    pn_prom := ln_MorMax;
  
    begin
      select a.tp1nro1
        into ln_diaMax
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 9
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    if ln_MorMax > ln_diaMax then
      pc_flgProm := 'S'; --incumplio mora maxima
    else
      pc_flgProm := 'N';
    end if;
  
    pc_flgMora := 'N';
    for j in clientes loop
      for i in creditos(j.ctnro) loop
        pn_dia := fn_dias_atraso(v_Pgfape => pd_Fecpro,
                                 v_Pgcod  => i.pgcod,
                                 v_Scmod  => i.aomod,
                                 v_Scsuc  => i.aosuc,
                                 v_Scmda  => i.aomda,
                                 v_Scpap  => i.aopap,
                                 v_Sccta  => i.aocta,
                                 v_Scoper => i.aooper,
                                 v_Scsbop => i.aosbop,
                                 v_Sctope => i.aotope,
                                 v_Scstat => i.aostat,
                                 v_fecven => i.aofvto);
      
        if nvl(pn_dia, 0) > 0 then
          pc_flgMora := 'S'; --inclumplio mora al dia
          exit;
        end if;
      
      end loop;
    
      if nvl(pn_dia, 0) > 0 then
        pc_flgMora := 'S'; --inclumplio mora al dia
        exit;
      end if;
    
    end loop;
  
  end;

  Procedure Sp_controlPatrimonio(pn_ins  in number,
                                 pn_cta  in number,
                                 pn_mod  in number,
                                 pn_mto  in number,
                                 pn_mto4 out number,
                                 pc_flg  out char) is
  
    ln_PatriSol  number(17, 2);
    ln_PatriDol  number(17, 2);
    ln_Patrimon  number(17, 2);
    ln_ratio     number(9, 6);
    ln_sector    number(2);
    lc_clienteNR char(2);
    ln_ocup      number(5);
    ln_tope      number(9, 2);
    lc_tipo      char(1);
    lc_tipoPer   char(2);
    ln_eval      number(10);
    ln_tipcam    number(14, 8);
    ln_mtoMax    number(17, 2);
  begin
  
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
       where a.ctnro = pn_cta
         and a.cttfir = 'T'
         and a.pepais = b.pepais
         and a.petdoc = b.petdoc
         and a.pendoc = b.pendoc;
    exception
      when others then
        null;
    end;
  
    --condiciones
  
    if lc_clienteNR = 'C' and pn_mod = 104 then
      ln_tope := 0.6;
    end if;
  
    if lc_clienteNR <> 'C' and pn_mod = 104 then
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
  
    pn_mto4 := nvl(ln_Patrimon, 0) * (nvl(ln_tope, 0) - nvl(ln_ratio, 0));
  
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
  
    if pn_mto4 > ln_mtoMax then
      pn_mto4 := ln_mtoMax;
    end if;
  
    if pn_mto4 > pn_mto then
      pc_flg := 'S'; --inclumple control por patrimonio
    else
      pc_flg := 'N';
    end if;
  
  end Sp_controlPatrimonio;

  Procedure Sp_calificacion_RCC(TipDocSbs   in char,
                                pc_ndo_FN   in char,
                                pd_fecRcc   in date,
                                MesRcc      in number,
                                lc_tiper_FN in char,
                                pn_cal      out number,
                                pd_fecCal   out date) is
    ln_i         number(5);
    CodSbs       char(10);
    LN_CALIF0    number(5, 2);
    LN_CALIF1    number(5, 2);
    LN_CALIF2    number(5, 2);
    LN_CALIF3    number(5, 2);
    LN_CALIF4    number(5, 2);
    pd_fecRccTmp date;
  
  begin
  
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
                pn_cal    := 0.00;
                pd_fecCal := pd_fecRccTmp;
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
                pn_cal    := 0.00;
                pd_fecCal := pd_fecRccTmp;
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
                pn_cal    := 0.00;
                pd_fecCal := pd_fecRccTmp;
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
                  pn_cal    := 0.00;
                  pd_fecCal := pd_fecRccTmp;
                  Exit;
                End If;
              End If;
            end if;
          
        end case;
        if pn_cal = 0.00 then
          pd_fecCal := pd_fecRccTmp;
          Exit;
        end if;
        ln_i         := ln_i + 1;
        pd_fecRccTmp := Add_months(pd_fecRccTmp, -1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
      end loop;
    end;
  end Sp_calificacion_RCC;

  Procedure Sp_plazo(pn_ins in number, pn_plazo out number) is
    LN_TIPOCRED number(5);
    ln_plazo    number(3);
    lc_tipcred  char(30);
  begin
    begin
      -- Tipo de Credito en el flujo
    
      select w.wfattsval
        into lc_tipcred
        from wfattsvalues w
       where w.wfinsprcid = pn_ins
         and w.wfattsid = 'TIPO_CREDITO';
    exception
      when others then
        null;
    end;
  
    LN_TIPOCRED := to_number(substr(lc_tipcred,
                                    1,
                                    INSTR(lc_tipcred, ';') - 1));
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
  
    pn_plazo := ln_plazo;
  end Sp_plazo;

  Procedure Sp_valida_cuenta(pn_pai in number,
                             pn_tdo in number,
                             pc_ndo in char,
                             pn_cta out number,
                             pc_flg out char) is
  
    cursor cuentas is
      select ctnro
        from fsr008 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.cttfir = 'T';
  
    ln_cont number(5);
    lc_flg  char(1) := 'N';
  
  begin
  
    begin
    
      for i in cuentas loop
        begin
          select count(*)
            into ln_cont
            from fsr008 a
           where a.ctnro = i.ctnro;
        exception
          when others then
            null;
        end;
      
        if ln_cont = 1 then
          lc_flg := 'S'; --es unico integrante de la cuenta
          pn_cta := i.ctnro;
          exit;
        end if;
      
      end loop;
    
      if nvl(lc_flg, 'N') = 'N' then
        lc_flg := 'N';
      end if;
    
    end;
  
    pc_flg := lc_flg;
  
  end Sp_valida_cuenta;

  Procedure Sp_insert_bandeja1(pn_ins    in number,
                               pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pn_pzo    in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_cuo    in number,
                               pn_cta    in number,
                               pc_flg    out char, --flag si tiene asesor
                               pc_ase    out char) is
  
    lc_ase     char(10);
    lc_flg     char(1) := 'N';
    ln_emp     number(3);
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
    lc_flgAse  char(1) := 'N';
    ld_Fecaux  date;
    lc_hab     char(1) := 'N';
    ln_cont    number(5);
    pd_fecprim date;
    pn_HisNR   number(1);
    pn_mod     number(3);
    pn_top     number(3);
    ln_Corr    number(9);
    lc_estado  char(1);
    ln_flgProc number(5) := 0;
    ln_seg     number(5);
    ln_Cor751  number(9);
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  begin
  
    begin
      select a.tp1nro1
        into ln_flgProc
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 16
         and a.tp1corr3 = 1;
    exception
      when others then
        ln_flgProc := 0;
    end;
  
    if nvl(ln_flgProc, 0) = 0 then
      lc_estado := 'N';
    else
      lc_estado := 'O';
    end if;
  
    begin
      select a.sng001ase
        into lc_ase
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select a.xwfempresa,
             a.xwfmodulo,
             a.xwfsucursal,
             a.xwfmoneda,
             a.xwfpapel,
             a.xwfcuenta,
             a.xwfoperacion,
             a.xwfsubope,
             a.xwftipope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_flg --es credito cancleado
        from fsd010 b
       where b.pgcod = ln_emp
         and b.aomod = ln_mod
         and b.aosuc = ln_suc
         and b.aomda = ln_mda
         and b.aopap = ln_pap
         and b.aocta = ln_cta
         and b.aooper = ln_ope
         and b.aosbop = ln_sbo
         and b.aotope = ln_top
         and b.aostat = 99
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if lc_flg = 'S' then
      --es credito cancelado
    
      begin
        select 'S'
          into lc_flgAse --si es valido el analista
          from fst046 a
         where a.ubuser = lc_ase
           and a.ubsuc = ln_suc;
      exception
        when others then
          lc_flgAse := 'N';
      end;
    
      if nvl(lc_flgAse, 'N') = 'N' then
        lc_ase := null;
      
        begin
          select trim(a.tp1desc)
            into lc_ase
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 5555
             and a.tp1corr2 = 12
             and a.tp1corr3 >= 1
             and a.tp1nro1 = pn_ins;
        exception
          when others then
            null;
        end;
      
      end if;
    
    else
      lc_flgAse := 'S';
    end if;
  
    pc_flg := lc_flgAse;
    pc_ase := lc_ase;
  
    ---------FECHA PRIMER PAGO--------------
    ld_Fecaux := pd_fecpro + pn_pzo;
    --verificar si es dia habil
    begin
      select a.fhabil
        into lc_hab
        from fst028 a, fst001 b
       where a.calcod = b.calcod
         and a.ffecha = ld_Fecaux
         and b.sucurs = ln_suc;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_hab, 'N') = 'N' then
      begin
        select min(a.ffecha)
          into pd_fecprim
          from fst028 a, fst001 b
         where a.calcod = b.calcod
           and a.ffecha > ld_Fecaux
           and b.sucurs = ln_suc
           and a.fhabil = 'S';
      exception
        when others then
          null;
      end;
    
    else
      pd_fecprim := ld_Fecaux;
    
    end if;
  
    ---------------------NUEVO/RECURRENTE-----------------
    Pq_Cr_Relcrediticia.Sp_RelCredi_NR(pn_pai      => pn_pai,
                                       pn_tdo      => pn_tdo,
                                       pc_ndo      => pc_ndo,
                                       pd_Fecpro   => pd_fecpro,
                                       ln_contador => ln_cont);
  
    if ln_cont >= 6 then
      pn_HisNR := 2; --Recurrente
    end if;
  
    if ln_cont < 6 then
      pn_HisNR := 1; --Nuevo
    end if;
  
    ------------------MODULO CAJA CASH------------------    
    begin
      select a.tp1nro1
        into pn_mod
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 13
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ------------------TIPO OPERACION CAJA CASH------------------
    begin
      select a.tp1nro1
        into pn_top
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 14
         and a.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(ln_flgProc, 0) = 0 then
      --proceso fintech
      begin
        select nvl(max(jaqm750reg), 0) + 1
          into ln_Corr
          from jaqm750
         where jaqm750fch = pd_fecpro
           and jaqm750reg < 1000000;
      exception
        when others then
          ln_Corr := null;
      end;
    
      if nvl(ln_Corr, 0) = 0 then
        ln_Corr := 1;
      end if;
    
    else
      --proceso flujo online
    
      begin
        select nvl(max(jaqm750reg), 0) + 1
          into ln_Corr
          from jaqm750
         where jaqm750fch = pd_fecpro
           and jaqm750reg >= 1000000;
      exception
        when others then
          ln_Corr := null;
      end;
    
      if nvl(ln_Corr, 0) = 1 then
        ln_Corr := 1000000;
      end if;
    
    end if;
  
    if nvl(lc_flgAse, 'N') = 'S' then
      Insert into JAQM750
      
      values
        (1,
         pd_fecpro,
         ln_Corr,
         pn_pai,
         pn_tdo,
         pc_ndo,
         0,
         0,
         pn_HisNR,
         pn_mod,
         pn_top,
         ln_suc,
         ln_mda,
         0,
         pn_cta,
         lc_ase,
         2,
         1,
         pd_fecprim,
         pn_mto,
         pn_cuo,
         pn_pzo,
         lc_estado);
    
      commit;
    
    end if;
  
    ---INSERTAR JAQM751 SEGUROS
    begin
      select a.tp1nro1
        into ln_seg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 5555
         and a.tp1corr2 = 17
         and a.tp1nro2 = pn_pzo;
    exception
      when others then
        ln_seg := 0;
    end;
  
    begin
      select nvl(max(a.jaqm751cor), 0) + 1
        into ln_Cor751
        from jaqm751 a
       where a.jaqm751emp = 1
         and a.jaqm751fch = pd_fecpro
         and a.jaqm751att = 'SEGCOD'
         and a.jaqm751reg = ln_Corr;
    exception
      when others then
        ln_Cor751 := null;
    end;
  
    if nvl(ln_Cor751, 0) = 1 then
      ln_Cor751 := 1;
    end if;
  
    insert into jaqm751
      (jaqm751emp,
       jaqm751fch,
       jaqm751reg,
       jaqm751att,
       jaqm751cor,
       jaqm751val)
    values
      (1, pd_fecpro, ln_Corr, 'SEGCOD', ln_Cor751, ln_seg);
  
    commit;
  
  end Sp_insert_bandeja1;

  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char) is
  
  begin
    Insert into Aqpa190a
    
    values
      (sq_cn_flujoeval.nextval,
       pn_pai,
       pn_tdo,
       pc_ndo,
       pd_Fecpro,
       pc_ase,
       0,
       13);
  
    commit;
  
  end Sp_insert_bandeja2;

  Procedure Sp_insert_bandeja3(pn_ins in number, pc_ndo in char) is
  
    cursor evaluacion(cn_eva in number) is
      select * from sng023 a where a.sng021eval = cn_eva;
  
    ln_eva    number(10);
    ln_evaMax number(10);
  begin
  
    begin
      select a.sng021eval
        into ln_eva
        from sng021 a
       where a.sng021sol = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select max(aqpa190aeval)
        into ln_evaMax
        from aqpa190a
       where aqpa190andoc = pc_ndo;
    end;
  
    for i in evaluacion(ln_eva) loop
    
      insert into AQPA190b values (ln_evaMax, i.sng026cod, i.sng023mto);
      commit;
    end loop;
  
  end Sp_insert_bandeja3;

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
        from /*bantprod.*/ fsd602 a
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

end pq_cr_modulo_cajacash;
/

