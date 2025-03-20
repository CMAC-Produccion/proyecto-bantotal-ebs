create or replace package PQ_cR_TipoPersona is

  procedure Sp_Cr_tipo_persona(pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                               pc_flg out char);

end PQ_cR_TipoPersona;
/

create or replace package body PQ_cR_TipoPersona is

  procedure Sp_Cr_tipo_persona(pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                               pc_flg out char) is
  
    lc_flg char(1);
    lc_tip char(1);
    ln_cod number(2);
  begin
  
    begin
      select a.petipo
        into lc_tip
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
    exception
      when others then
        null;
    end;
    if lc_tip = 'J' then
    
      begin
        select a.njcod
          into ln_cod
          from fsd003 a
         where a.pjpais = pn_pai
           and a.pjtdoc = pn_tdo
           and a.pjndoc = pc_ndo;
      exception
        when others then
          null;
      end;
    
      begin
        select 'E' --flag de empresa EIRL
          into lc_flg
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 3000
           and a.tp1corr2 = 1
           and a.tp1nro1 = ln_cod;
      exception
        when others then
          lc_flg := 'J';
      end;
    
      lc_flg := nvl(lc_flg, 'J');
    
    else
      lc_flg := nvl(lc_flg, 'F');
    end if;
  
    pc_flg := lc_flg;
  
  end Sp_Cr_tipo_persona;

end PQ_cR_TipoPersona;
/

