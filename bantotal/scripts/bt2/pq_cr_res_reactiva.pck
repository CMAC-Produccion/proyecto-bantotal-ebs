create or replace package pq_cr_res_reactiva is

  Procedure sp_tieneReactiva(pn_ins in number, pc_flg out char);

end pq_cr_res_reactiva;
/

create or replace package body pq_cr_res_reactiva is
--2020.09.16 dcastro adiciono consulta pgcod

  Procedure sp_tieneReactiva(pn_ins in number, pc_flg out char) is
  
    ln_pai number(3);
    ln_tdo number(2);
    ln_ndo char(12);
    lc_flg char(1);
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
  
    begin
    
      select 'S'
        into lc_flg
        from fsr008 a, fsd010 b
       where a.pepais = ln_pai
         and a.petdoc = ln_tdo
         and a.pendoc = ln_ndo
         and a.cttfir = 'T'
         and a.pgcod = 1       -- 2020.09.16 dcastro agrego condicion  
         and b.pgcod = a.pgcod -- 2020.09.16 dcastro agrego condicion         
         and a.ctnro = b.aocta
         and b.aostat <> 99
         and b.aomod in (select c.tp1nro1
                           from fst198 c
                          where c.tp1cod = 1
                            and c.tp1cod1 = 11141
                            and c.tp1corr1 = 11
                            and c.tp1corr2 = 1)
         and b.aotope in (select c.tp1nro2
                            from fst198 c
                           where c.tp1cod = 1
                             and c.tp1cod1 = 11141
                             and c.tp1corr1 = 11
                             and c.tp1corr2 = 1)
         and rownum = 1;
    exception
      when others then
        null;
    end;
    pc_flg := nvl(lc_flg, 'N');
  end sp_tieneReactiva;

end pq_cr_res_reactiva;
/

