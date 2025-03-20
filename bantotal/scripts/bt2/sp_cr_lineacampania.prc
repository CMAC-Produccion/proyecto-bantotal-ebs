create or replace procedure Sp_cr_LineaCampania(pn_cta in number, pc_flg out char) is
lc_flg char(1) := 'N';
begin
  begin
     select 'S'
       into lc_flg
       from fsd010 a
      where a.pgcod = 1
        and a.aomod= 116
        and a.aotope in (select b.tp1nro1
                           from fst198 b
                          where b.tp1cod   = 1
                            and b.tp1cod1  = 10899
                            and b.tp1corr1 = 12
                            and b.tp1corr2 = 3)
        and aocta = pn_cta
        and rownum = 1;
  exception
    when others then null;
  end;
  pc_flg := lc_flg ;
end Sp_cr_LineaCampania;
/

