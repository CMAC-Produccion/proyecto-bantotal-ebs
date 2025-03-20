create or replace package pq_cr_ValidacionItem is

  Procedure Sp_cr_verifica(pn_ins in number, pc_val out char);
  Procedure Sp_cr_grupo(pn_cta in number, pc_flg out char);

end pq_cr_ValidacionItem;
/

create or replace package body pq_cr_ValidacionItem is

  Procedure Sp_cr_verifica(pn_ins in number, pc_val out char) is
  
    lc_valor char(15);
  
  begin
    begin
      select trim(g.pae71val)
        into lc_valor
        from fpae70 f, fpae71 g
       where f.pae51eva = g.pae51eva
         and f.pae70nro = g.pae70nro
         and f.pae70ins = pn_ins
         and f.pae51eva = 1
         and g.pae71ite = 775;
    exception
      when too_many_rows then
        begin
          select trim(g.pae71val)
            into lc_valor
            from fpae70 f, fpae71 g
           where f.pae51eva = g.pae51eva
             and f.pae70nro = g.pae70nro
             and f.pae70ins = pn_ins
             and f.pae51eva = 1
             and g.pae71ite = 775
             and f.pae70nro = (select max(f.pae70nro)
                                 from fpae70 f
                                where f.pae70ins = pn_ins
                                  and f.pae51eva = 1);
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    pc_val := lc_valor;
  
  end Sp_cr_verifica;

  Procedure Sp_cr_grupo(pn_cta in number, pc_flg out char) is
    lc_flg char(1) := 'N';
  begin
    begin
      select 'S'
        into lc_flg
        from fsd009 a
       where a.tgcod in (select aa.tp1nro1
                           from fst198 aa
                          where aa.tp1cod = 1
                            and aa.tp1cod1 = 11134
                            and aa.tp1corr1 = 1
                            and aa.tp1corr2 = 1
                            and aa.tp1corr3 > 0)
         and a.pgcod = 1
         and a.ctnro = pn_cta;
    exception
      when others then
        lc_flg := 'N';
    end;
    pc_flg := lc_flg;
  
  end Sp_cr_grupo;

end pq_cr_ValidacionItem;
/

