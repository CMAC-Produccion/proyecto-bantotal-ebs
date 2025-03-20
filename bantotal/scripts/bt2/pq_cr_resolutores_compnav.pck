create or replace package pq_Cr_resolutores_compnav is

  Procedure Sp_Ventas(pn_ins  in number,
                      pn_mto3 out number,
                      pn_mto4 out number);
  procedure sp_SaldoRCC(pn_ins in number, pn_mto out number);

  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number;
end pq_Cr_resolutores_compnav;
/

create or replace package body pq_Cr_resolutores_compnav is

  Procedure Sp_Ventas(pn_ins  in number,
                      pn_mto3 out number,
                      pn_mto4 out number) is
  
    ln_eva    number(10);
    ln_tipcam number(14, 8);
    ln_mtoDol number(17, 2);
    ln_mto    number(17, 2);
    ln_mtoFin number(17, 2);
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
      select a.sng120tcbi
        into ln_tipcam
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk = 'EVALUACION';
    exception
      WHEN TOO_MANY_ROWS THEN
        begin
          select a.sng120tcbi
            into ln_tipcam
            from sng120 a
           where a.sng120ins = pn_ins
             and a.sng120tsk = 'EVALUACION'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into ln_mto
        from sng023 a
       where a.sng021eval = ln_eva
         and a.sng026cod = 73;
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng023mto
        into ln_mtoDol
        from sng023 a
       where a.sng021eval = ln_eva
         and a.sng026cod = 573;
    exception
      when others then
        null;
    end;
  
    ln_mtoFin := nvl(ln_mto, 0) + (nvl(ln_mtoDol, 0) / nvl(ln_tipcam, 0));
  
    pn_mto3 := ln_mtoFin * 3;
    pn_mto4 := ln_mtoFin * 4;
  
  end Sp_Ventas;

  procedure sp_SaldoRCC(pn_ins in number, pn_mto out number) is
  
    ln_pai    number(3);
    ln_tdo    number(2);
    lc_ndo    char(12);
    lc_tiper  char(1);
    DocSbsTit char(1);
    fec_rcc   date;
  begin
    /*
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;*/
    --ln_pai := 604;
    --ln_tdo := 21;
    --lc_ndo := '47852329';
  
    --Guia equivalencia tipo de documento
    /* begin
      select Trim(to_char(a.tp1corr3))
        into DocSbsTit
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 11111
         and a.tp1corr1 = 1
         and a.tp1corr2 = 3
         and tp1nro1 = ln_tdo;
    exception
      when no_data_found then
        DocSbsTit := null;
    end;*/
  
    /* --tipo de persona
    begin
      select a.petipo
        into lc_tiper
        from fsd001 a
       where a.pepais = ln_pai
         and a.petdoc = ln_tdo
         and a.pendoc = lc_ndo;
    exception
      when no_data_found then
        lc_tiper := null;
    end;
    
    begin
      select to_date(tpnro, 'dd/mm/yyyy')
        into fec_rcc
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        fec_rcc := null;
    end;
    
    pn_mto := pq_cr_resolutores_compnav.Fn_cant_instit(DocSbsTit,
                                                       lc_ndo,
                                                       fec_rcc,
                                                       lc_tiper);*/
  
    pn_mto := 0.00;
  
  end sp_SaldoRCC;

  Function Fn_cant_instit(TipDocSbs in char,
                          pc_ndo    in char,
                          pd_fecRcc in date,
                          lc_tiper  in char) return number is
  
    lc_CodSbs    char(10);
    ln_i         number(10);
    pd_fecRccTmp date;
    ln_saldo     number(17, 2);
    ln_saldoFin  number(17, 2);
    ln_saldoAnt  number(17, 2);
  
  begin
    begin
      case
        when lc_tiper = 'F' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCID = TipDocSbs
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        when lc_tiper = 'J' then
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_TDOCTR = TipDocSbs
               and C_DOCTRI = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
        else
          begin
            select C_CODSBS
              into lc_CodSbs
              from CLDRCCI
             Where D_FECPRE = pd_fecRcc
               and C_DOCIDE = trim(pc_ndo)
               and rownum = 1;
          exception
            when no_data_found then
              lc_CodSbs := NULL;
          end;
          if lc_CodSbs is null then
            begin
              select C_CODSBS
                into lc_CodSbs
                from CLDRCCI
               Where D_FECPRE = pd_fecRcc
                 and C_DOCTRI = trim(pc_ndo)
                 and rownum = 1;
            exception
              when no_data_found then
                lc_CodSbs := NULL;
            end;
          end if;
        
      end case;
    
      begin
        ln_i         := 1;
        pd_fecRccTmp := pd_fecRcc;
        ln_saldoAnt  := 0;
      
        while ln_i <= 13 loop
        
          begin
            select sum(a.n_salcap)
              into ln_saldo
              from CLDRCCS a
             Where C_CODSBS = lc_CodSbs
                  --and C_CODEMP <> '00104'
               and (C_CUENTA like '14_1%' Or C_CUENTA like '14_2%' Or
                   C_CUENTA like '14_3%' Or C_CUENTA like '14_4%' Or
                   C_CUENTA like '14_5%' Or C_CUENTA like '14_6%' Or
                   C_CUENTA like '71_1%' Or C_CUENTA like '71_2%' Or
                   C_CUENTA like '71_3%' Or C_CUENTA like '71_4%' Or
                   C_CUENTA like '81_302%')
               and D_FECPRE = pd_fecRccTmp;
          exception
            when others then
              null;
          end;
        
          ln_i         := ln_i + 1;
          pd_fecRccTmp := Add_months(pd_fecRccTmp, -1);
          pd_fecRccTmp := last_day(pd_fecRccTmp);
          ln_saldo     := nvl(ln_saldo, 0);
          if ln_saldo > ln_saldoAnt then
            ln_saldoFin := ln_saldo;
          else
            ln_saldoFin := ln_saldoAnt;
          end if;
          ln_saldoAnt := ln_saldoFin;
        
        end loop;
      End;
    
    end;
    return ln_saldoFin;
  
  end Fn_cant_instit;

end pq_Cr_resolutores_compnav;
/

