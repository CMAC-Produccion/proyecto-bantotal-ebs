create or replace package pq_cr_camp2021_segmper is

  -- Author  : RMONTESR
  -- Created : 5/10/2021 12:28:17
  -- Purpose : Procedimientos para carga de campanias segmento persona

  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -----------------------------------------------------------------------------------------------
  procedure sp_cr_en_campania_segm(pn_insta in numeric,
                                   pv_rpta  out varchar2);

end pq_cr_camp2021_segmper;
/

create or replace package body pq_cr_camp2021_segmper is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2) is
  
    -- lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- carga campania
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpb390cor), 0) + 1 into pn_corr from aqpb390 t;
      
        --- campania
        insert into aqpb390
          (aqpb390cod,
           aqpb390fec,
           aqpb390cor,
           aqpb390est,
           aqpb390usr,
           aqpb390fcr,
           aqpb390hcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        --- carga campania
      
        pn_flag := 'S';
      
        update AQPB390 t
           set t.aqpb390est = pn_estado,
               t.aqpb390usd = pn_usuario,
               t.aqpb390fed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb390hed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb390cod = pn_pgcod
           and t.aqpb390fec = pn_fecha
           and t.aqpb390cor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  ----------------------------------------------------------------------------------
  procedure sp_cr_en_campania_segm(pn_insta in numeric,
                                   pv_rpta  out varchar2) is
    ln_pepais     number;
    ln_petdoc     number;
    lc_pendoc     char(12);
    ld_maxfech    date;
    ln_conta      number;
    saldo_credi   number;
    saldo_envuelo number;
  begin
    saldo_credi   := 0;
    saldo_envuelo := 0;
    begin
      select t1.sng001pais, t1.sng001tdoc, t1.sng001ndoc
        into ln_pepais, ln_petdoc, lc_pendoc
        from sng001 t1
       where t1.sng001inst = pn_insta
         and t1.sng001emp = 1;
    exception
      when others then
        ln_pepais := 0;
        ln_petdoc := 0;
        lc_pendoc := '';
    end;
    begin
      select max(t2.aqpb390dfec)
        into ld_maxfech
        from aqpb390d t2
       where t2.aqpb390dest <> 'D';
    exception
      when others then
        null;
    end;
    begin
      select count(*)
        into ln_conta
        from aqpb390d t3
       where t3.aqpb390dcod = 1
         and t3.aqpb390dfec = ld_maxfech
         and t3.aqpb390dpepais = ln_pepais
         and t3.aqpb390dpetdoc = ln_petdoc
         and t3.aqpb390dpendoc = lc_pendoc
         and t3.aqpb390dest <> 'D';
    exception
      when others then
        ln_conta := 0;
    end;
    if ln_conta > 0 then
      begin
        select sum(scsdo)
          into saldo_credi
          from fsd011 a
         where a.pgcod = 1
           and a.scstat <> 99
           and a.sccta in (select ta.ctnro
                             from fsr008 ta
                            where ta.pepais = ln_pepais
                              and ta.petdoc = ln_petdoc
                              and ta.pendoc = lc_pendoc)
           and (a.scmod in (select modulo
                              from fst111
                             where dscod = 50
                               and modulo not in (29, 33, 200)) or
               a.scmod = 117);
      exception
        when others then
          saldo_credi := 0;
      end;
      begin
        select sum(x.xwfmonto1)
          into saldo_envuelo
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfcuenta in (select ta.ctnro
                                 from fsr008 ta
                                where ta.pepais = ln_pepais
                                  and ta.petdoc = ln_petdoc
                                  and ta.pendoc = lc_pendoc)
           and x.xwfcar3 = '1'
           and (x.xwfmodulo in
               (select modulo
                   from fst111
                  where dscod = 50
                    and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
           and x.XWFPRCINS in
               (select wfinsprcid
                  from wfwrkitems wf
                 where wf.wfinsprcid = x.xwfprcins
                   and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                   and wf.wfiteminit =
                       (select max(wfiteminit)
                          from wfwrkitems w
                         where w.wfinsprcid = x.xwfprcins
                           and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                           and w.wfitemstsact = 1
                              --and wftaskcod = 11
                           and w.wfiteminit >=
                               to_date('2013.07.01', 'yyyy.mm.dd'))
                   and wftaskcod = 11
                   and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'));
      exception
        when others then
          saldo_envuelo := 0;
      end;
      if saldo_credi is not null then
        if saldo_envuelo is not null then 
           if (saldo_credi*-1) + saldo_envuelo > 0 then
              pv_rpta := 'V';
           else
              pv_rpta := 'S';
           end if;
         else
           if (saldo_credi*-1) >0 then
             pv_rpta := 'V';
           else
              pv_rpta := 'S';
           end if;
         end if;
       else
         if saldo_envuelo is not null then 
           if saldo_envuelo > 0 then
              pv_rpta := 'V';
           else
              pv_rpta := 'S';
           end if;
         else
           pv_rpta := 'S';           
         end if;
       end if;
    else
      pv_rpta := 'N';
    end if;
  end sp_cr_en_campania_segm;
end pq_cr_camp2021_segmper;
/

