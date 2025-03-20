create or replace package pq_cr_seguro_vehicular is

  Procedure Sp_cr_verifica(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_flg out char);

end pq_cr_seguro_vehicular;
/

create or replace package body pq_cr_seguro_vehicular is

  Procedure Sp_cr_verifica(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pc_flg out char) is
  
    lc_flg char(1) := 'N';
  
  begin
  
    begin
      select 'S'
        into lc_flg
        from fpp001 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.sgcod in (select b.tp1nro1
                           from fst198 b
                          where b.tp1cod = 1
                            and b.tp1cod1 = 10898
                            and b.tp1corr1 = 20
                            and b.tp1corr2 = 1
                            and b.tp1nro2 = 1);
    exception
      when others then
        lc_flg := 'N';
    end;
  
    pc_flg := lc_flg;
  
  end Sp_cr_verifica;

end pq_cr_seguro_vehicular;
/

