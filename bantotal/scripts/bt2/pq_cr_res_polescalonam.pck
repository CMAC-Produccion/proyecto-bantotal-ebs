create or replace package pq_cr_res_PolEscalonam is

  Procedure Sp_cr_saldo(pd_fecpro in date,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        pn_mto    out number);

end pq_cr_res_PolEscalonam;
/

create or replace package body pq_cr_res_PolEscalonam is

  Procedure Sp_cr_saldo(pd_fecpro in date,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        pn_mto    out number) is
  
    cursor personas is
      select ctnro
        from fsr008 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
         and a.cttfir = 'T';
  
    cursor creditos(cd_fec in date, cn_cta in number) is
      select /*+index(a FSH01204)*/
       sum(a.bcsdmn * -1) bcsdmn
        from fsh012 a
       where a.bcemp = 1
         and a.bcrubr in (select rubro
                            from fsd014 a
                           where a.pcnivc in
                                 (select modulo
                                    from fst111
                                   where dscod = 50
                                     and modulo not in
                                         (select tp1nro1
                                            from fst198 a
                                           where a.tp1cod = 1
                                             and a.tp1cod1 = 10899
                                             and a.tp1corr1 = 17
                                             and a.tp1corr2 = 2))
                             and substr(a.rubro, 5, 2) in
                                 (select trim(aa.tp1desc)
                                    from fst198 aa
                                   where aa.tp1cod = 1
                                     and aa.tp1cod1 = 10899
                                     and aa.tp1corr1 = 17
                                     and aa.tp1corr2 = 3))
            
         and bcfech = cd_fec
         and bccta = cn_cta;
  
    ld_Fecaux   date;
    ln_mto      number(17, 2) := 0;
    ln_mtoAnt   number(17, 2) := 0;
    ln_cont     number(5) := 0;
    ln_mtoFinal number(17, 2) := 0;
  begin
    for a in 1 .. 12 loop
      --modificar aqui si es menos meses
      ld_Fecaux := last_day(add_months(pd_fecpro, -a));
      ln_mto    := 0;
      for i in personas loop
        for k in creditos(ld_Fecaux, i.ctnro) loop
          ln_mto := nvl(ln_mto, 0) + nvl(k.bcsdmn, 0);
        
        end loop;
      end loop;
    
      if ln_cont > 0 then
        if ln_mtoAnt > ln_mto then
          ln_mto      := ln_mtoAnt;
          ln_mtoFinal := ln_mtoAnt;
        else
          ln_mtoFinal := ln_mto;
        end if;
      end if;
      ln_cont   := ln_cont + 1;
      ln_mtoAnt := ln_mto;
    end loop;
  
    pn_mto := ln_mtoFinal;
  end Sp_cr_saldo;

end pq_cr_res_PolEscalonam;
/

