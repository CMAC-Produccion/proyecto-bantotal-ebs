create or replace package pq_cr_control_refinanc_fondos is

  -- Author  : RMONTESR
  -- Created : 26/04/2021 10:45:58
  -- Purpose : Paquete para el control de refinanciacion de fondos FAE reactiva

  procedure sp_cr_refinan_verif(pn_insta in numeric, pv_rpta out varchar2);

  procedure sp_cr_refinan_verif_crecer(pn_insta in numeric,
                                       pv_rpta  out varchar2);

  procedure sp_cr_refinan_verif_crecern(pn_insta in numeric,
                                        pv_rpta  out varchar2);

  procedure sp_cr_refinan_verif_all(pn_insta in numeric,
                                    pv_rpta  out varchar2);

end pq_cr_control_refinanc_fondos;
/

create or replace package body pq_cr_control_refinanc_fondos is

  procedure sp_cr_refinan_verif(pn_insta in numeric, pv_rpta out varchar2) is
  
    ln_conta1    numeric;
    lc_tipofondo char;
  begin
    lc_tipofondo := 'N';
    pv_rpta      := 'N';
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_insta
         and sng001ori = 3;
    exception
      when others then
        ln_conta1 := 0;
    end;
    if ln_conta1 > 0 then
      begin
        select 'R'
          into lc_tipofondo
          from xwf700 a
         where a.xwfprcins = pn_insta
           and a.xwfcar3 != '1'
           and a.xwfmodulo = 101
           and a.xwftipope = 353
           and rownum <= 1;
      exception
        when others then
          null;
      end;
    
      if lc_tipofondo = 'N' then
        begin
          select 'F'
            into lc_tipofondo
            from xwf700 a
           where a.xwfprcins = pn_insta
             and a.xwfcar3 != '1'
             and a.xwfmodulo = 101
             and a.xwftipope = 354
             and rownum <= 1;
        exception
          when others then
            null;
        end;
      end if;
    
    end if;
    if lc_tipofondo = 'N' then
      pv_rpta := 'N';
    else
      pv_rpta := 'S';
    end if;
  
  end sp_cr_refinan_verif;
  ------------------------------------------------------------------------------------------

  procedure sp_cr_refinan_verif_crecer(pn_insta in numeric,
                                       pv_rpta  out varchar2) is
  
    ln_conta1    numeric;
    lc_tipofondo char;
  begin
    lc_tipofondo := 'N';
    pv_rpta      := 'N';
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_insta
         and sng001ori = 3;
    exception
      when others then
        ln_conta1 := 0;
    end;
    if ln_conta1 > 0 then
    
      begin
        select 'C'
          into lc_tipofondo
          from xwf700 a
         inner join aqpa377 b
            on a.xwfempresa = b.aqpa377pgcod
           and a.xwfsucursal = b.aqpa377suc
           and a.xwfmodulo = b.aqpa377mod
           and a.xwfmoneda = b.aqpa377mda
           and a.xwfpapel = b.aqpa377pap
           and a.xwfcuenta = b.aqpa377cta
           and a.xwfoperacion = b.aqpa377ope
           and a.xwfsubope = b.aqpa377sbop
           and a.xwftipope = b.aqpa377tope
         where a.xwfprcins = pn_insta
           and a.xwfcar3 != '1'
           and a.xwfmodulo = 101
           and a.xwftipope in (353, 354)
           and rownum <= 1;
      exception
        when others then
          null;
      end;
    
    end if;
    if lc_tipofondo = 'N' then
      pv_rpta := 'N';
    else
      pv_rpta := 'S';
    end if;
  
  end sp_cr_refinan_verif_crecer;
  ------------------------------------------------------------------------------------------

  procedure sp_cr_refinan_verif_crecern(pn_insta in numeric,
                                        pv_rpta  out varchar2) is
  
    ln_conta1    numeric;
    lc_tipofondo char;
  begin
    lc_tipofondo := 'N';
    pv_rpta      := 'N';
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_insta
         and sng001ori = 3;
    exception
      when others then
        ln_conta1 := 0;
    end;
    if ln_conta1 > 0 then
    
      begin
        select 'C'
          into lc_tipofondo
          from xwf700 a
         inner join aqpb073b b
            on a.xwfempresa = b.aqpb073bcod
           and a.xwfsucursal = b.aqpb073bsuc
           and a.xwfmodulo = b.aqpb073bmod
           and a.xwfmoneda = b.aqpb073bmda
           and a.xwfpapel = b.aqpb073bpap
           and a.xwfcuenta = b.aqpb073bcta
           and a.xwfoperacion = b.aqpb073bope
           and a.xwfsubope = b.aqpb073bsbo
           and a.xwftipope = b.aqpb073btop
         where a.xwfprcins = pn_insta
           and a.xwfcar3 != '1'
           and a.xwfmodulo = 101
           and a.xwftipope in (353, 354)
           and b.aqpb073best <> 'D'
           and rownum <= 1;
      exception
        when others then
          null;
      end;
    
    end if;
    if lc_tipofondo = 'N' then
      pv_rpta := 'N';
    else
      pv_rpta := 'S';
    end if;
  
  end sp_cr_refinan_verif_crecern;
  ------------------------------------------------------------------------------------------

  procedure sp_cr_refinan_verif_all(pn_insta in numeric,
                                    pv_rpta  out varchar2) is
  
    ln_conta1    numeric;
    lc_tipofondo char;
  begin
    lc_tipofondo := 'N';
    pv_rpta      := 'N';
    begin
      select count(*)
        into ln_conta1
        from sng001
       where sng001inst = pn_insta
         and sng001ori in (13, 14, 16);
    exception
      when others then
        ln_conta1 := 0;
    end;
    if ln_conta1 > 0 then
      begin
        select 'R'
          into lc_tipofondo
          from xwf700 a
         where a.xwfprcins = pn_insta
           and a.xwfcar3 != '1'
           and a.xwfmodulo = 101
           and a.xwftipope = 353
           and rownum <= 1;
      exception
        when others then
          null;
      end;
    
      if lc_tipofondo = 'N' then
        begin
          select 'F'
            into lc_tipofondo
            from xwf700 a
           where a.xwfprcins = pn_insta
             and a.xwfcar3 != '1'
             and a.xwfmodulo = 101
             and a.xwftipope = 354
             and rownum <= 1;
        exception
          when others then
            null;
        end;
      end if;
      if lc_tipofondo = 'N' then
        begin
          select 'C'
            into lc_tipofondo
            from xwf700 a
           inner join aqpb073b b
              on a.xwfempresa = b.aqpb073bcod
             and a.xwfsucursal = b.aqpb073bsuc
             and a.xwfmodulo = b.aqpb073bmod
             and a.xwfmoneda = b.aqpb073bmda
             and a.xwfpapel = b.aqpb073bpap
             and a.xwfcuenta = b.aqpb073bcta
             and a.xwfoperacion = b.aqpb073bope
             and a.xwfsubope = b.aqpb073bsbo
             and a.xwftipope = b.aqpb073btop
           where a.xwfprcins = pn_insta
             and a.xwfcar3 != '1'
             and a.xwfmodulo = 101
             and a.xwftipope in (353, 354)
             and b.aqpb073best <> 'D'
             and rownum <= 1;
        exception
          when others then
            null;
        end;
      end if;
    
    end if;
    if lc_tipofondo = 'N' then
      pv_rpta := 'N';
    else
      pv_rpta := 'S';
    end if;
  
  end sp_cr_refinan_verif_all;

end pq_cr_control_refinanc_fondos;
/

