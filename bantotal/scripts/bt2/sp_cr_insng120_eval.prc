create or replace procedure SP_CR_INSNG120_EVAL(ln_instancia in number) is

  cursor lista_InstSinRegEval(ln_pais number,
                              ln_tdoc number,
                              lc_ndoc varchar2) is
    select s.sng001inst ln_InsSinReg
      from sng001 s, sng021 g
     where s.sng001pais = ln_pais
       and s.sng001tdoc = ln_tdoc
       and s.sng001ndoc = lc_ndoc
       and s.sng001inst = g.sng021sol
       and g.sng021tmod = 13
    minus
    select t.sng120ins ln_InsSinReg
      from sng120 t
     where t.sng120tsk = 'EVALUACION';

  ln_pais       number;
  ln_tdoc       number;
  lc_ndoc       varchar2(12);
  lc_sng120tsk  varchar2(15);
  ln_sng120mod  number;
  ln_sng120top  number;
  ln_sng120mda  number;
  ln_sng120pap  number;
  ln_sng120pzo  number;
  ln_sng120cuo  number;
  ln_sng120per  number;
  ln_sng120cliq varchar2(5);
  ln_sng120mto  number(17, 2);
  ln_sng120mcr  number(17, 2);
  ld_sng120fval date;
  ld_sng120fpag date;
  ld_sng120fvto date;
  ln_sng120vcuo number(17, 2);
  ln_sng120ttas number;
  ln_sng120clta number;
  ln_sng120tasa number(10, 6);
  ln_sng120plus number(10, 6);
  ln_sng120tcbi number(14, 8);

begin

  begin
    select s.sng001pais, s.sng001tdoc, s.sng001ndoc
      into ln_pais, ln_tdoc, lc_ndoc
      from sng001 s
     where s.sng001inst = ln_instancia;
  exception
    when others then
      null;
  end;

  if ln_pais > 0 then
  
    for a in lista_InstSinRegEval(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        select s.sng120tsk,
               s.sng120mod,
               s.sng120top,
               s.sng120mda,
               s.sng120pap,
               s.sng120pzo,
               s.sng120cuo,
               s.sng120per,
               s.sng120cliq,
               s.sng120mto,
               s.sng120mcr,
               s.sng120fval,
               s.sng120fpag,
               s.sng120fvto,
               s.sng120vcuo,
               s.sng120ttas,
               s.sng120clta,
               s.sng120tasa,
               s.sng120plus,
               s.sng120tcbi
          into lc_sng120tsk,
               ln_sng120mod,
               ln_sng120top,
               ln_sng120mda,
               ln_sng120pap,
               ln_sng120pzo,
               ln_sng120cuo,
               ln_sng120per,
               ln_sng120cliq,
               ln_sng120mto,
               ln_sng120mcr,
               ld_sng120fval,
               ld_sng120fpag,
               ld_sng120fvto,
               ln_sng120vcuo,
               ln_sng120ttas,
               ln_sng120clta,
               ln_sng120tasa,
               ln_sng120plus,
               ln_sng120tcbi
          from sng120 s
         where s.sng120ins in (select max(d.sng001inst)
                                 from sng001 d, xwf070 x
                                where d.sng001pais = ln_pais
                                  and d.sng001tdoc = ln_tdoc
                                  and d.sng001ndoc = lc_ndoc
                                  and d.sng001inst < a.ln_InsSinReg
                                  and d.sng001inst = x.xwfprcin
                                  and x.xwfcont = 'S')
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          null;
      end;
    
      if lc_sng120tsk is not null then
        begin
          insert into sng120
            (sng120ins,
             sng120tsk,
             sng120mod,
             sng120top,
             sng120mda,
             sng120pap,
             sng120pzo,
             sng120cuo,
             sng120per,
             sng120cliq,
             sng120mto,
             sng120mcr,
             sng120fval,
             sng120fpag,
             sng120fvto,
             sng120vcuo,
             sng120ttas,
             sng120clta,
             sng120tasa,
             sng120plus,
             sng120tcbi)
          values
            (a.ln_InsSinReg,
             lc_sng120tsk,
             ln_sng120mod,
             ln_sng120top,
             ln_sng120mda,
             ln_sng120pap,
             ln_sng120pzo,
             ln_sng120cuo,
             ln_sng120per,
             ln_sng120cliq,
             ln_sng120mto,
             ln_sng120mcr,
             ld_sng120fval,
             ld_sng120fpag,
             ld_sng120fvto,
             ln_sng120vcuo,
             ln_sng120ttas,
             ln_sng120clta,
             ln_sng120tasa,
             ln_sng120plus,
             ln_sng120tcbi);
          commit;
        end;
      end if;
    end loop;
  end if;

insert into AQPB876 values (user,sysdate,'SP_CR_INSNG120_EVAL',   ln_instancia);
commit;
end SP_CR_INSNG120_EVAL;
/

