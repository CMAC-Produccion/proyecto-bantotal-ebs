create or replace procedure Sp_cr_RegistroJAQY141(lc_cuenta    in number,
                                                  lc_operacion in number,
                                                  lc_insertado out varchar2) is

  ln_corre     number;
  flg_registro varchar2(2);

begin
  lc_insertado := 'N';
  begin
    -- Maximo Correlativo
    select max(jaqy141corr) into ln_corre from jaqy141;
  exception
    when others then
      ln_corre := 0;
  end;

  begin
  
    begin
      -- Reviso Registro
      select 'S'
        into flg_registro
        from jaqy141
       where jaqy141cta = lc_cuenta
         and jaqy141ope = lc_operacion;
    exception
      when others then
        flg_registro := 'N';
    end;
  
    if flg_registro = 'N' then
      begin
        insert into jaqy141
          (jaqy141corr, jaqy141cta, jaqy141ope)
        values
          (ln_corre + 1, lc_cuenta, lc_operacion);
        commit;
      end;
    
      Begin
        select 'S'
          into lc_insertado
          from jaqy141
         where jaqy141cta = lc_cuenta
           and jaqy141ope = lc_operacion;
      exception
        when others then
          lc_insertado := 'N';
      end;
    
    end if;
  
   /* Begin
      select 'S'
        into lc_insertado
        from jaqy141
       where jaqy141cta = lc_cuenta
         and jaqy141ope = lc_operacion;
    exception
      when others then
        lc_insertado := 'N';
    end;*/
  
  end;
end Sp_cr_RegistroJAQY141;
/

