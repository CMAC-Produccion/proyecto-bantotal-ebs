CREATE OR REPLACE PACKAGE PQ_CR_MIGRA_EVAL_CONS is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_MIGRA_EVAL_CONS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020
  -- Autor de Creación          : ABERNEDO
  -- Uso                        : Migracion de bd evaluacion consumo a bantotal
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de Modificación      : 

  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  ---------------------------------------------------------
  Procedure sp_cr_ultima_evaluacion(pn_instDES in number,
                                    P_ERROR    out varchar2);
  Procedure Sp_cuotas_restantes(pn_ins in number, pn_cuo out number);
  Procedure sp_calificacion_titu6M(pn_pai in number,
                                   pn_tdo in number,
                                   pc_ndo in char,
                                   pn_cal out number);
  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number;

end PQ_CR_MIGRA_EVAL_CONS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_MIGRA_EVAL_CONS is

  -----------------------------------------------------------------------------------------------                           
  Procedure sp_cr_ultima_evaluacion(pn_instDES in number,
                                    P_ERROR    out varchar2) is
    ld_MaxFchDesemb date;
    ln_pgcod        number;
    ln_modulo       number;
    ln_sucursal     number;
    ln_moneda       number;
    ln_papel        number;
    ln_cuenta       number;
    ln_operacion    number;
    ln_suboper      number;
    ln_tipooper     number;
    ln_instORI      number;
    ln_evalORI      number; --Origen
    ln_evalDES      number; --Destino
    L_FECHA         date;
  
  begin
    p_error := 'Importacion exitosa';
    begin
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      select max(g.aofval)
        into ld_MaxFchDesemb
        from fsd010 g
       where g.pgcod = 1
         and (g.aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (33, 200, 108)) or
             g.aomod = 117)
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          inner join sng001 x
                             on f.pepais = x.sng001pais
                            and f.petdoc = x.sng001tdoc
                            and f.pendoc = x.sng001ndoc
                            and f.cttfir = 'T'
                            and x.sng001inst = pn_instDES);
    exception
      when no_data_found then
        p_error := 'No se encontro credito para este cliente';
        return;
    end;
  
    begin
      select g.pgcod,
             g.aomod,
             g.aosuc,
             g.aomda,
             g.aopap,
             g.aocta,
             g.aooper,
             g.aosbop,
             g.aotope
        into ln_pgcod,
             ln_modulo,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper,
             ln_tipooper
      
        from fsd010 g
       where g.pgcod = 1
         and (g.aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (33, 200, 108)) or
             g.aomod = 117)
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          inner join sng001 x
                             on f.pepais = x.sng001pais
                            and f.petdoc = x.sng001tdoc
                            and f.pendoc = x.sng001ndoc
                            and f.cttfir = 'T'
                            and x.sng001inst = pn_instDES)
         and g.aofval = ld_MaxFchDesemb
         and rownum = 1;
    exception
      when no_data_found then
        p_error := 'No se encontro credito para este cliente';
        return;
    end;
  
    begin
      ln_instORI := fn_instancia_credito(v_Scmod  => ln_modulo,
                                         v_Scsuc  => ln_sucursal,
                                         v_Scmda  => ln_moneda,
                                         v_Scpap  => ln_papel,
                                         v_Sccta  => ln_cuenta,
                                         v_Scoper => ln_operacion,
                                         v_Scsbop => ln_suboper,
                                         v_Sctope => ln_tipooper);
    exception
      when no_data_found then
        p_error := 'No se encontro instancia para este cliente';
        return;
    end;
    --Migramos la instancia encontrada
    begin
      select x.sng021eval
        into ln_evalORI
        from sng021 x
       where x.sng021sol = ln_instORI; --Evaluacion Origen
      select y.sng021eval
        into ln_evalDES
        from sng021 y
       where y.sng021sol = pn_instDES; --Evaluacion Destino          
    
      /********************DATOS EVALUACION***********************/
      delete from sng023
       where sng021eval = ln_evalDES
         and sng026cod in (select tpnro
                             from fst098
                            where pgcod = 1
                              and tpcod = 7690
                              and tpimp = 2); /*Ev. dependiente*/
    
      insert into sng023
        select ln_evalDES, R.sng026cod, R.sng023mto
          from (select tpnro
                  from fst098
                 where pgcod = 1
                   and tpcod = 7690
                   and tpimp = 2) S
         inner join (SELECT a.sng021pdoc,
                            a.sng021tdoc,
                            a.sng021ndoc,
                            b.sng021eval,
                            b.sng026cod,
                            b.sng023mto
                       from SNG021 a, SNG023 b
                      Where a.sng021eval = b.sng021eval
                        and a.sng021eval = ln_evalORI) R
            on S.TPNRO = R.sng026cod;
    
      commit;
    exception
      when no_data_found then
        p_error := 'No se pudo copiar la ultima evaluacion';
        return;
    end;
  
  end sp_cr_ultima_evaluacion;
  -----------------------------------------------------------------------------------------------
  Procedure Sp_cuotas_restantes(pn_ins in number, pn_cuo out number) is
  
    ln_emp number(3);
    ln_mod number(3);
    ln_suc number(3);
    ln_mda number(4);
    ln_pap number(4);
    ln_cta number(9);
    ln_ope number(9);
    ln_sbo number(3);
    ln_top number(3);
  
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
         and a.xwfcar3 <> '1';
    exception
      when others then
        null;
    end;
  
    ----verifica cuotas pendientes de pago
  
    begin
      select count(*)
        into pn_cuo
        from fsd601 n
       where n.pgcod = ln_emp
         and n.ppcta = ln_cta
         and n.ppmda = ln_mda
         and n.ppsuc = ln_suc
         and n.pppap = ln_pap
         and n.ppoper = ln_ope
         and n.ppsbop = ln_sbo
         and n.pptope = ln_top
         and n.ppmod = ln_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists
      
       (select ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when others then
        null;
    end;
  
  end Sp_cuotas_restantes;

  Procedure sp_calificacion_titu6M(pn_pai in number,
                                   pn_tdo in number,
                                   pc_ndo in char,
                                   pn_cal out number) is
  
    DocSbs     number(10);
    DocSbsTit  char(1);
    fecNum_rcc number(9);
    fec_rcc    date;
    MesRcc     number(9);
    lc_tiper   char(1);
  begin
    --*******CALIFICACION_RCC********--------
    --Guia equivalencia tipo de documento
    begin
      select a.tp1corr3
        into DocSbs
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = pn_tdo;
    exception
      when no_data_found then
        DocSbs := null;
    end;
    DocSbsTit := Trim(to_char(DocSbs));
  
    --fecha RCC
  
    begin
      select tpnro
        into fecNum_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fecNum_rcc := null;
    end;
    fec_rcc := to_date(fecNum_rcc, 'dd/mm/yyyy');
  
    --Meses a evaluar RCC
    begin
      select tpnro
        into MesRcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 13;
    exception
      when no_data_found then
        MesRcc := null;
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
    pn_cal := 100.00;
  
    pn_cal := pq_Cr_migra_eval_cons.Fn_calificacion_RCC(DocSbsTit,
                                                        pc_ndo,
                                                        fec_rcc,
                                                        MesRcc,
                                                        lc_tiper);
  
  end sp_calificacion_titu6M;

  Function Fn_calificacion_RCC(TipDocSbs   in char,
                               pc_ndo_FN   in char,
                               pd_fecRcc   in date,
                               MesRcc      in number,
                               lc_tiper_FN in char) return number is
    ln_i         number(5);
    CodSbs       char(10);
    LN_CALIF0    number(5, 2);
    LN_CALIF1    number(5, 2);
    LN_CALIF2    number(5, 2);
    LN_CALIF3    number(5, 2);
    LN_CALIF4    number(5, 2);
    pn_cal       number(10, 5);
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
                pn_cal := 0.00;
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
                pn_cal := 0.00;
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
                pn_cal := 0.00;
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
                  pn_cal := 0.00;
                  Exit;
                End If;
              End If;
            end if;
          
        end case;
        if pn_cal = 0.00 then
          Exit;
        end if;
        ln_i         := ln_i + 1;
        pd_fecRccTmp := Add_months(pd_fecRccTmp, -1);
        pd_fecRccTmp := last_day(pd_fecRccTmp);
      end loop;
    end;
    return pn_cal;
  end Fn_calificacion_RCC;

end PQ_CR_MIGRA_EVAL_CONS;
/

