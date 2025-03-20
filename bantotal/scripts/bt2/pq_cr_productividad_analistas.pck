create or replace package PQ_CR_PRODUCTIVIDAD_ANALISTAS is

  -- Author  : RMONTESR
  -- Created : 18/08/2021 16:22:27
  -- Purpose : Paquete para caraga de productividad Analistas

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
  function fn_get_codcat(pv_catana in varchar2, pd_fecha in date)
    return number;
  -----------------------------------------------------------------------------------------------
  function fn_get_tipase(pc_codana in char, pd_fecha in date) return char;
  -----------------------------------------------------------------------------------------------
  procedure sp_cargar_jaqy830(pn_cor in number, pn_usurio in varchar2, pn_flag out varchar2);

end PQ_CR_PRODUCTIVIDAD_ANALISTAS;
/

create or replace package body PQ_CR_PRODUCTIVIDAD_ANALISTAS is
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
        -- PRODUCTIVIDAD

        pn_flag := 'S';

        --- Obtener el correlativo
        select nvl(max(t.aqpb366cor), 0) + 1 into pn_corr from aqpb366 t;

        --- Reporte FAE
        insert into aqpb366
          (aqpb366cod,
           aqpb366fec,
           aqpb366cor,
           aqpb366est,
           aqpb366usr,
           aqpb366fcr,
           aqpb366hcr)
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
        ---PRODUCTIVIDAD

        pn_flag := 'S';

        update AQPB366 t
           set t.aqpb366est = pn_estado,
               t.aqpb366usd = pn_usuario,
               t.aqpb366fed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb366hed = to_char(sysdate, 'HH24:MI:SS')

         where t.aqpb366cod = pn_pgcod
           and t.aqpb366fec = pn_fecha
           and t.aqpb366cor = pn_corr;
        commit;

    end case;

  end sp_actualizar_pauxiliar;
  ------------------------------------------------------------------------------
  function fn_get_codcat(pv_catana in varchar2, pd_fecha in date)
    return number is
    ln_codcat number;
  begin
    begin
      select a.jaqy830codcat
        into ln_codcat
        from jaqy830 a
       where a.jaqy830catana = pv_catana
         and a.jaqy830fini = pd_fecha
         and rownum <= 1;
    exception
      when no_data_found then
        ln_codcat := 0;
    end;
    return ln_codcat;
  end fn_get_codcat;
  ------------------------------------------------------------------------------
  function fn_get_tipase(pc_codana in char, pd_fecha in date) return char is
    lc_tipase char(1);
  begin
    begin
      select a.jaqy830tipase
        into lc_tipase
        from jaqy830 a
       where a.jaqy830codana = pc_codana
         and a.jaqy830fini = pd_fecha
         and rownum <= 1;
    exception
      when no_data_found then
        lc_tipase := 'P';
    end;
    return lc_tipase;
  end fn_get_tipase;
  ------------------------------------------------------------------------------
  procedure sp_cargar_jaqy830(pn_cor in number, pn_usurio in varchar2, pn_flag out varchar2) is
    ld_ultimacarga date;
    my_errm VARCHAR2(32000);
    lv_hora varchar2(15);
  begin
    lv_hora := to_char(sysdate, 'HH24:MI:SS');
    pn_flag := 'S';
    begin
      select max(jaqy830fini)
        into ld_ultimacarga
        from jaqy830
       where jaqy830est = 'S';
    exception
      when others then
        ld_ultimacarga := null;
    end;
    begin
      update jaqy830 set jaqy830est = 'N' where jaqy830est = 'S';
      commit;
    exception
      when others then
           null;
    end;
    begin
      insert into jaqy830
        (JAQY830CODANA,
         JAQY830ANA,
         JAQY830CODCAT,
         JAQY830CATANA,
         JAQY830CODAGE,
         JAQY830AGEN,
         JAQY830FINI,
         JAQY830EST,
         JAQY830CODID,
         JAQY830NDOC,
         JAQY830TIPASE,
         jaqy830ffin,
         jaqy830dial,
         jaqy830vol,
         JAQY830FAUX,
         jaqy830antage,
         jaqy830DSus,/*efuentes 2021.11.09*/
         jaqy830FCar,/*efuentes 2021.11.09*/
         jaqy830HCar,/*efuentes 2021.11.09*/
         jaqy830UCar)/*efuentes 2021.11.09*/
        select nvl(trim(a.aqpb366dcodbt), b.jaqn002usr),
               trim(a.aqpb366dnomtrab),
               --fn_get_codcat(trim(a.aqpb366dcargo), ld_ultimacarga), --codcat crear guia para obtener
               case
                 when (select count(*)
                         from aqpb617 a
                        where lower(trim(a.aqpb617ncat)) = lower(trim(a.aqpb366dcargo))
                          and upper(a.aqpb617tage) = upper(a.aqpb366dantage)) > 0
                      then (select a.aqpb617cat
                              from aqpb617 a
                             where lower(trim(a.aqpb617ncat)) = lower(trim(a.aqpb366dcargo))
                               and upper(a.aqpb617tage) = upper(a.aqpb366dantage)
                            offset 0 rows fetch next 1 rows only)
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS EN FORMACION' then 0
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS JUNIOR' then 1
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS JUNIOR VOLANTE' then 1
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO VOLANTE' then 2
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS  AVANZADO VOLANTE' then 2
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO' then 2
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS  AVANZADO' then 2
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO AGRICOLA' then 2
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO EXPERTO' then 3
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO EXPERTO VOLANTE' then 3
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO SUPERIOR' then 4
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS AVANZADO SUPERIOR VOLANTE' then 4
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS EXPERTO' then 5
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS EXPERTO VOLANTE' then 5
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS SUPERIOR' then 6
                 when trim(a.aqpb366dcargo) = 'ANALISTA DE CREDITOS SUPERIOR VOLANTE' then 6
                 when trim(a.aqpb366dcargo) = 'ANALISTA SENIOR VOLANTE' then 7
                 when trim(a.aqpb366dcargo) = 'ANALISTA SENIOR' then 7
                 when trim(a.aqpb366dcargo) = 'ANALISTA SENIOR DE CREDITOS' then 7
                 when trim(a.aqpb366dcargo) = 'ANALISTA SENIOR EXPERTO' then 8
                 when trim(a.aqpb366dcargo) = 'ANALISTA SENIOR EXPERTO VOLANTE' then 8
                 when trim(a.aqpb366dcargo) = 'ANALISTA MASTER VOLANTE' then 9
                 when trim(a.aqpb366dcargo) = 'ANALISTA MASTER' then 9
                 else 99
               end,
               trim(a.aqpb366dcargo),
               c.sucurs,
               trim(a.aqpb366ddescuni),
               --to_date(sysdate, 'DD/MM/YYYY'), /*efuentes 2021.11.09 - SE COMENTO*/
               --to_date(LAST_DAY(ADD_MONTHS(a.AQPB366DFEC,-1)), 'DD/MM/YYYY'), /*efuentes 2021.11.09*/
               LAST_DAY(ADD_MONTHS(a.AQPB366DFEC,-1)),
               'S',
               a.aqpb366dcodtrab,
               a.aqpb366dndoc,
               --fn_get_tipase(nvl(trim(a.aqpb366dcodbt), b.jaqn002usr),ld_ultimacarga), --tipo analista con guia
               nvl(d.jaqy830tipase,'P'),
               case when a.aqpb366dfcese = to_date('01/01/0001', 'DD/MM/YYYY') then null else a.aqpb366dfcese end,
               a.aqpb366ddias,
               case when a.aqpb366dcargo like '%VOLANTE%' then 'VOLANTE' else '' end,
               a.aqpb366dfingr,
               upper(a.aqpb366dantage),
               a.AQPB366DDSus, /*efuentes 2021.11.09*/
               a.AQPB366DFEC,  /*efuentes 2021.11.09*/
               lv_hora,  /*efuentes 2021.11.09*/
               pn_usurio /*efuentes 2021.11.09*/
          from aqpb366d a
          left join jaqn002 b
                 on b.jaqn002pgc = 1
                and b.jaqn002pai = 604
                and b.jaqn002tdo = 21
                and b.jaqn002ndo = a.aqpb366dndoc
          left join fst001 c
                 on c.pgcod = 1
                and c.scnom = a.aqpb366ddescuni
          left join jaqy830 d
                 on d.jaqy830codana = nvl(rpad(a.aqpb366dcodbt,20), rpad(b.jaqn002usr,20))
                and d.jaqy830fini = ld_ultimacarga
         where a.aqpb366dcod = 1
           and a.aqpb366dcor = pn_cor;
      commit;
      exception when others then
        pn_flag := 'N';
        my_errm := SQLERRM;
        --DBMS_OUTPUT.put_line (my_errm);
    end;
    if pn_flag = 'N' then
       begin      
        update jaqy830 set jaqy830est = 'S' where jaqy830est = 'N' and jaqy830fini = ld_ultimacarga;
        commit;
       exception when others then 
         null;
       end;
    end if;
  end sp_cargar_jaqy830;

end PQ_CR_PRODUCTIVIDAD_ANALISTAS;
/

