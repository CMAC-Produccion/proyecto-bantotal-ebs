create or replace package pq_cr_controlEmerg is

  -- Author  : CHERNANDEZ
  -- Created : 18/03/2020 12:49:42
  -- Purpose : 
  -- Autor Modificacion: chernandez
  -- fecha: 18/06/2020
  -- se agregó modulo 116 para pagarse por transaccion 30 - 100
  -- Autor Modificacion: chernandez
  -- fecha: 18/06/2020
  -- se agregó modulo 116 para pagarse por transaccion 30 - 100  
  -- Autor Modificacion: chernandez
  -- fecha: 22/09/2020
  -- se agregó filtro de pago total

  procedure sp_cr_control(pn_pgcod   in number,
                          pn_itsuc   in number,
                          pn_itmod   in number,
                          pn_ittran  in number,
                          pn_itnrel  in number,
                          pn_itord   in number,
                          pn_itsbor  in number,
                          pv_mensaje out varchar2,
                          pn_rpta    out varchar2);
  procedure sp_cr_tienediasatraso(pn_pgcod   in number,
                                  pn_itsuc   in number,
                                  pn_itmod   in number,
                                  pn_ittran  in number,
                                  pn_itnrel  in number,
                                  pn_itord   in number,
                                  pn_itsbor  in number,
                                  pn_pgfape  in date,
                                  pv_mensaje out varchar2,
                                  pn_rpta    out varchar2);

end pq_cr_controlEmerg;
/

create or replace package body pq_cr_controlEmerg is
  procedure sp_cr_control(pn_pgcod   in number,
                          pn_itsuc   in number,
                          pn_itmod   in number,
                          pn_ittran  in number,
                          pn_itnrel  in number,
                          pn_itord   in number,
                          pn_itsbor  in number,
                          pv_mensaje out varchar2,
                          pn_rpta    out varchar2) is
    cursor fsd016 is
      select *
        from fsd016
       Where Pgcod = pn_pgcod
         and Itsuc = pn_itsuc
         and Itmod = pn_itmod
         and Ittran = pn_ittran
         and Itnrel = pn_itnrel
         and Itord = pn_itord
         and Itsbor = pn_itsbor;
  
    cursor fsd602(pln_ITTOPE number,
                  pln_ITSUCD number,
                  pln_MONEDA number,
                  pln_PAPEL  number,
                  pln_CTNRO  number,
                  pln_ITOPER number,
                  pln_ITSUBO number,
                  pln_MODULO number) is
      select max(pp1fech) fecha
        from fsd602 a
       where a.pgcod = pn_pgcod
         and a.ppmod = pln_MODULO
         and a.ppsuc = pln_ITSUCD
         and a.ppmda = pln_MONEDA
         and a.pppap = pln_PAPEL
         and a.ppcta = pln_CTNRO
         and a.ppoper = pln_ITOPER
         and a.ppsbop = pln_ITSUBO
         and a.pptope = pln_ITTOPE
         and a.d602co = 'S';
  
    ln_MODULO number(3);
    ln_ITTOPE number(3);
    ln_ITSUCD number(3);
    ln_RUBRO  number(16);
    ln_MONEDA number(4);
    ln_PAPEL  number(4);
    ln_CTNRO  number(9);
    ln_ITOPER number(9);
    ln_ITSUBO number(3);
    ld_fecha  date;
    ld_fecgui date;
    ld_fecAct date;
    ld_fec601 date; --chernandez 31/08/2020
  begin
    pv_mensaje := '';
    pn_rpta    := 'S';
    ld_fec601  := null; --chernandez 31/08/2020
    begin
      select to_date(trim(tp1desc), 'dd/mm/yyyy')
        into ld_fecgui
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11105
         and tp1corr1 = 35
         and tp1corr2 = 1
         and tp1corr3 = 1;
    
      for a in fsd016 loop
        ln_MODULO := a.Modulo;
        ln_ITTOPE := a.Ittope;
        ln_ITSUCD := a.Itsucd;
        ln_RUBRO  := a.Rubro;
        ln_MONEDA := a.Moneda;
        ln_PAPEL  := a.Papel;
        ln_CTNRO  := a.Ctnro;
        ln_ITOPER := a.Itoper;
        ln_ITSUBO := a.Itsubo;
      
        ld_fecha := ld_fecgui;
        --chernandez 31/08/2020
        begin
          select min(a.ppfpag)
            into ld_fec601
            from fsd601 a
           where pgcod = 1
             and ppmod = ln_MODULO
             and ppsuc = ln_ITSUCD
             and ppmda = ln_MONEDA
             and pppap = ln_PAPEL
             and ppcta = ln_CTNRO
             and ppoper = ln_ITOPER
             and ppsbop = ln_ITSUBO
             and pptope = ln_ITTOPE
             and d601co = 'S'
             and pptipo <> 'K'
             and not exists (select *
                    from fsd602 b
                   where b.pgcod = a.pgcod
                     and b.ppmod = a.ppmod
                     and b.ppsuc = a.ppsuc
                     and b.ppmda = a.ppmda
                     and b.pppap = a.pppap
                     and b.ppcta = a.ppcta
                     and b.ppoper = a.ppoper
                     and b.ppsbop = a.ppsbop
                     and b.pptope = a.pptope
                     and b.ppfpag = a.ppfpag
                     and b.d602co = 'S'
                     and b.pp1stat = 'T');--chernandez 22/09/2020 
        exception
          when others then
            null;
        end;
        for b in fsd602(ln_ITTOPE,
                        ln_ITSUCD,
                        ln_MONEDA,
                        ln_PAPEL,
                        ln_CTNRO,
                        ln_ITOPER,
                        ln_ITSUBO,
                        ln_MODULO) loop
          ld_fecha := b.fecha;
        end loop;
        --chernandez 31/08/2020
        If ld_fec601 is not null and ld_fec601 > ld_fecgui then
          ld_fecAct := ld_fec601;
        else
          ld_fecAct := ld_fecgui;
        end if;
        if ld_fecAct < ld_fecha then
          ld_fecAct := ld_fecha;
        end if;
      
        update fsd603
           set PfdFva1 = ld_fecAct
         where Pgcod = pn_pgcod
           and Itsuc = pn_itsuc
           and Itmod = pn_itmod
           and Ittran = pn_ittran
           and Itnrel = pn_itnrel;
        update FSD016
           set Itfval = ld_fecAct
         where Pgcod = pn_pgcod
           and Itsuc = pn_itsuc
           and Itmod = pn_itmod
           and Ittran = pn_ittran
           and Itnrel = pn_itnrel
           and Itord = pn_itord;
        commit;
        pn_rpta := 'N';
      
      end loop;
    
    exception
      when others then
        null;
    end;
  
  end sp_cr_control;

  procedure sp_cr_tienediasatraso(pn_pgcod   in number,
                                  pn_itsuc   in number,
                                  pn_itmod   in number,
                                  pn_ittran  in number,
                                  pn_itnrel  in number,
                                  pn_itord   in number,
                                  pn_itsbor  in number,
                                  pn_pgfape  in date,
                                  pv_mensaje out varchar2,
                                  pn_rpta    out varchar2) is
    cursor fsd016 is
      select *
        from fsd016
       Where Pgcod = pn_pgcod
         and Itsuc = pn_itsuc
         and Itmod = pn_itmod
         and Ittran = pn_ittran
         and Itnrel = pn_itnrel
         and Itord = pn_itord
         and Itsbor = pn_itsbor;
  
    ln_MODULO number(3);
    ln_ITTOPE number(3);
    ln_ITSUCD number(3);
    ln_RUBRO  number(16);
    ln_MONEDA number(4);
    ln_PAPEL  number(4);
    ln_CTNRO  number(9);
    ln_ITOPER number(9);
    ln_ITSUBO number(3);
    ln_dias   number(4);
    ln_aostat number(2);
    ld_aofvto date;
  
  begin
    pv_mensaje := '';
    pn_rpta    := 'N';
    for a in fsd016 loop
      ln_MODULO := a.Modulo;
      ln_ITTOPE := a.Ittope;
      ln_ITSUCD := a.Itsucd;
      ln_RUBRO  := a.Rubro;
      ln_MONEDA := a.Moneda;
      ln_PAPEL  := a.Papel;
      ln_CTNRO  := a.Ctnro;
      ln_ITOPER := a.Itoper;
      ln_ITSUBO := a.Itsubo;
    
      select aostat, aofvto
        into ln_aostat, ld_aofvto
        from fsd010 g
       where g.pgcod = pn_pgcod
         and g.aomod = ln_MODULO
         and g.aosuc = ln_ITSUCD
         and g.aomda = ln_MONEDA
         and g.aopap = ln_PAPEL
         and g.aocta = ln_CTNRO
         and g.aooper = ln_ITOPER
         and g.aosbop = ln_ITSUBO
         and g.aotope = ln_ITTOPE
         and rownum = 1;
    
      select fn_dias_atraso(pn_pgfape,
                            pn_pgcod,
                            ln_MODULO,
                            ln_ITSUCD,
                            ln_MONEDA,
                            ln_PAPEL,
                            ln_CTNRO,
                            ln_ITOPER,
                            ln_ITSUBO,
                            ln_ITTOPE,
                            ln_aostat,
                            ld_aofvto)
        into ln_dias
        from dual;
    
      If pn_ittran = 97 then
        if ln_dias > 0 then
          --se agregó modulo 116 chernandez 18/06/2020
          if ln_MODULO in (116, 117, 108, 33, 200, 65, 144) or
             ln_aostat in (23, 64, 90, 65, 67) or ln_ITTOPE = 550 then
            pn_rpta    := 'S';
            pv_mensaje := 'Este crédito no se puede pagar por esta transacción';
          else
            pn_rpta := 'N';
          end if;
        else
          pn_rpta    := 'S';
          pv_mensaje := 'Este crédito no se puede pagar por esta transacción';
        end if;
      Else
        if ln_dias <= 0 or ln_MODULO in (144, 116) then
          --chernandez 19/03/2020 se agrego 116 18/06/2020
          pn_rpta := 'N';
        else
          pn_rpta    := 'S';
          pv_mensaje := 'Utilizar la transacción 30/97 para este crédito.';
        End If;
      
      end if;
      insert into aqpa045
        (aqpa045pgcod,
         aqpa045modu,
         aqpa045tope,
         aqpa045sucd,
         aqpa045mon,
         aqpa045pap,
         aqpa045ctnro,
         aqpa045oper,
         aqpa045sbop,
         aqpa045fec,
         aqpa045hor,
         aqpa045dias,
         aqpa045trx,
         aqpa045rpt,
         aqpa045msg)
      values
        (pn_pgcod,
         ln_MODULO,
         ln_ITTOPE,
         ln_ITSUCD,
         ln_MONEDA,
         ln_PAPEL,
         ln_CTNRO,
         ln_ITOPER,
         ln_ITSUBO,
         pn_pgfape,
         (select to_char(sysdate, 'HH24:mi:ss') from dual),
         ln_dias,
         pn_ittran,
         pn_rpta,
         pv_mensaje);
      commit;
    
    end loop;
  end sp_cr_tienediasatraso;
end pq_cr_controlEmerg;
/

