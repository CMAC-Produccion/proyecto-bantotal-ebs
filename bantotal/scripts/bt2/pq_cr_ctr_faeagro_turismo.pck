create or replace package pq_cr_ctr_faeagro_turismo is

  -- Author  : RMONTESR
  -- Created : 26/08/2021 09:30:13
  -- Purpose : Procedimientos para detectar si es fae agro o turismo

  procedure sp_cr_es_fae_agro(pn_instance in numeric, pv_rpta out varchar2);
  ----------------------------------------------------------------------------------
  procedure sp_cr_es_fae_turismo(pn_instance in numeric,
                                 pv_rpta     out varchar2);
  ----------------------------------------------------------------------------------
  procedure sp_cr_es_pae(pn_instance in numeric, pv_rpta out varchar2);
  ----------------------------------------------------------------------------------
  procedure sp_cr_es_fae_agro1(pn_instance in numeric,
                               pv_rpta     out varchar2);
  ----------------------------------------------------------------------------------
  procedure sp_cr_es_fae_turismo1(pn_instance in numeric,
                                  pv_rpta     out varchar2);
  --------------------------------------------------------------------------------------
  procedure sp_cr_es_pae1(pn_instance in numeric, pv_rpta out varchar2);

end pq_cr_ctr_faeagro_turismo;
/

create or replace package body pq_cr_ctr_faeagro_turismo is

  procedure sp_cr_es_fae_turismo(pn_instance in numeric, pv_rpta out varchar2) is
    ln_mod  numeric;
    ln_tope numeric;

  begin
    begin
      select a.xwfmodulo, a.xwftipope
        into ln_mod, ln_tope
        from XWF700 a
       where a.XWFPRCINS = pn_instance
         and a.XWFCar3 in ('R', 'G')
         and rownum < 2;
    exception
      when no_data_found then
        ln_mod  := 0;
        ln_tope := 0;
    end;
    if ln_mod = 101 and ln_tope = 355 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;

  end sp_cr_es_fae_turismo;

  -----------------------------------------------------------------------------------
  procedure sp_cr_es_fae_agro(pn_instance in numeric,
                                 pv_rpta     out varchar2) is
    ln_mod  numeric;
    ln_tope numeric;

  begin

    begin
      select a.xwfmodulo, a.xwftipope
        into ln_mod, ln_tope
        from XWF700 a
       where a.XWFPRCINS = pn_instance
         and a.XWFCar3 in ('R', 'G')
         and rownum < 2;
    exception
      when no_data_found then
        ln_mod  := 0;
        ln_tope := 0;
    end;
    if (ln_mod = 116 or ln_mod = 117) and ln_tope = 20 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;

  end sp_cr_es_fae_agro;
  -----------------------------------------------------------------------------------
  procedure sp_cr_es_pae(pn_instance in numeric,
                                 pv_rpta     out varchar2) is
    ln_mod  numeric;
    ln_tope numeric;

  begin

    begin
      select a.xwfmodulo, a.xwftipope
        into ln_mod, ln_tope
        from XWF700 a
       where a.XWFPRCINS = pn_instance
         and a.XWFCar3 in ('R', 'G')
         and rownum < 2;
    exception
      when no_data_found then
        ln_mod  := 0;
        ln_tope := 0;
    end;
    if ln_mod = 101  and ln_tope = 356 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;

  end sp_cr_es_pae;
  ----------------------------------------------------------------------------------------
  procedure sp_cr_es_fae_turismo1(pn_instance in numeric,
                               pv_rpta     out varchar2) is
    ln_mod    numeric;
    ln_tope   numeric;
    ln_conta1 numeric;
  begin
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_instance
         and sng001ori in (3, 4, 12, 13, 14, 15, 16); --3 reprogramaciones, 4,12,15 ampliaciones 13,14,16 refinanciaciones
    exception
      when others then
        ln_conta1 := 0;
    end;
    pv_rpta := 'N';
    if ln_conta1 > 0 then
      begin
        select a.xwfmodulo, a.xwftipope
          into ln_mod, ln_tope
          from XWF700 a
         where a.XWFPRCINS = pn_instance
           and a.XWFCar3 in ('R', 'G', 'S')
           and rownum < 2;
      exception
        when no_data_found then
          ln_mod  := 0;
          ln_tope := 0;
      end;
      if ln_mod = 101 and ln_tope = 355 then
        pv_rpta := 'S';
      else
        pv_rpta := 'N';
      end if;
    end if;

  end sp_cr_es_fae_turismo1;

  -----------------------------------------------------------------------------------
  procedure sp_cr_es_fae_agro1(pn_instance in numeric,
                                  pv_rpta     out varchar2) is
    ln_mod    numeric;
    ln_tope   numeric;
    ln_conta1 numeric;
  begin
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_instance
         and sng001ori in (3, 4, 12, 15, 13, 14, 16); --3 reprogramaciones, 4,12,15 ampliaciones 13,14,16 refinanciaciones
    exception
      when others then
        ln_conta1 := 0;
    end;
    pv_rpta := 'N';
    if ln_conta1 > 0 then
      begin
        select a.xwfmodulo, a.xwftipope
          into ln_mod, ln_tope
          from XWF700 a
         where a.XWFPRCINS = pn_instance
           and a.XWFCar3 in ('R', 'G', 'S')
           and rownum < 2;
      exception
        when no_data_found then
          ln_mod  := 0;
          ln_tope := 0;
      end;
      if (ln_mod = 116 or ln_mod = 117) and ln_tope = 20 then
        pv_rpta := 'S';
      else
        pv_rpta := 'N';
      end if;
    end if;
  end sp_cr_es_fae_agro1;
   ----------------------------------------------------------------------------------------
  procedure sp_cr_es_pae1(pn_instance in numeric,
                               pv_rpta     out varchar2) is
    ln_mod    numeric;
    ln_tope   numeric;
    ln_conta1 numeric;
  begin
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_instance
         and sng001ori in (3, 4, 12, 13, 14, 15, 16); --3 reprogramaciones, 4,12,15 ampliaciones 13,14,16 refinanciaciones
    exception
      when others then
        ln_conta1 := 0;
    end;
    pv_rpta := 'N';
    if ln_conta1 > 0 then
      begin
        select a.xwfmodulo, a.xwftipope
          into ln_mod, ln_tope
          from XWF700 a
         where a.XWFPRCINS = pn_instance
           and a.XWFCar3 in ('R', 'G', 'S')
           and rownum < 2;
      exception
        when no_data_found then
          ln_mod  := 0;
          ln_tope := 0;
      end;
      if ln_mod = 101 and ln_tope = 356 then
        pv_rpta := 'S';
      else
        pv_rpta := 'N';
      end if;
    end if;

  end sp_cr_es_pae1;

end pq_cr_ctr_faeagro_turismo;
/

