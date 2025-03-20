create or replace procedure SP_OP_OPEREXTR_Y_CANC (lc_fecini in varchar, lc_fecfin in varchar)
is
  cursor ope_extrj(ld_fecini in date, ld_fecfin in date) is

  --create table repext as
    select t.jaqy254pgctr,
           t.jaqy254suctr,
           t.jaqy254modtr,
           t.jaqy254codtr,
           t.jaqy254reltr,
           t.jaqy254fetra,
           t.jaqy254feneg,
           t.jaqy254feini,
           t.jaqy254fefin,
           t.jaqy254comsg,
           t.jaqy254cotra trac,
           t.jaqy254nutar tarjeta,
           t.jaqy254fetra fecha,
           t.JAQY254HOFIN hora,
           case
             when t.jaqy254codtr in (16, 0) then
              'RETIRO'
             when t.jaqy254codtr = 50 then
              'COMPRAS'
           end operacion,
           t.jaqy254moned moneda_trx,
           t.jaqy254imdeb monto_trx,
           case
             when t.jaqy254comsg = '00' then
              t.jaqy254ubtra
             else
              ''
           end lugar,
           case
             when t.jaqy254comsg = '00' then
              'NORMAL'
             else
              'RECHAZADA'
           end estado,
           case
             when t.jaqy254comsg <> '00' then
              (select y.descripcion
                 from atm_error y
                where y.jaqy254comsg = t.jaqy254comsg)
             else
              ''
           end motivo_rechazo
      from /**/jaqy254 t
     where jaqy254titra not in (34)
       and jaqy254cored in (5, 2)
       and jaqy254codtr in (16, 0, 50)
       and jaqy254moned = 101
       and t.jaqy254comsg = '00'
       and t.jaqy254fetra between ld_fecini and ld_fecfin;

  ln_cta       number;
  ln_oper      number;
  ln_toper     number;
  ln_mod       number;
  ln_mda       number;
  ld_fecini    date;
  ld_fecfin    date;
  lc_titular   varchar2(200);
  ln_pais      number;
  ln_tdoc      number;
  lc_numdoc    fsd001.pendoc%type;
  ln_variable1 number;
  ln_variable2 number;
  ln_importe   number(17, 2);
  lc_operacion varchar2(30);

begin
  ld_fecini    := to_date(lc_fecini/*'&I_yyyymmdd'*/, 'yyyymmdd');
  ld_fecfin    := to_date(lc_fecfin/*'&F_yyyymmdd'*/, 'yyyymmdd');
  ln_variable1 := 16;
  ln_variable2 := 50;
  delete /**/repext;
  commit;

  for i in ope_extrj(ld_fecini, ld_fecfin) loop
    ln_cta       := null;
    ln_oper      := null;
    ln_toper     := null;
    ln_mod       := null;
    ln_mda       := null;
    lc_titular   := null;
    ln_pais      := null;
    ln_tdoc      := null;
    lc_numdoc    := null;
    ln_importe   := null;
    lc_operacion := null;

    begin
      select distinct c.hcta,
                      c.hoper,
                      c.htoper,
                      c.hmodul,
                      c.hmda,
                      e.pepais,
                      e.petdoc,
                      e.pendoc,
                      c.hcimp1,
                      case
                        when c.htran = 16 then
                         'RETIRO'
                        when c.htran = 50 then
                         'COMPRAS'
                      end operacion
        into ln_cta,
             ln_oper,
             ln_toper,
             ln_mod,
             ln_mda,
             ln_pais,
             ln_tdoc,
             lc_numdoc,
             ln_importe,
             lc_operacion
        from /**/fsh016 c, /**/fsr008 e
       where c.pgcod = i.jaqy254pgctr
         and c.hcmod = i.jaqy254modtr
         and c.hsucor = i.jaqy254suctr
         and c.htran = i.jaqy254codtr
         and c.hnrel = i.jaqy254reltr
         and c.hfcon = i.jaqy254feini
         and hcta <> 0
         and e.cttfir = 'T'
         and e.ctnro = c.hcta
         and i.jaqy254comsg = '00'
         and c.hcord =
             /**/pq_datos_fin_mes.fn_ordinal(i.jaqy254pgctr,
                                                  i.jaqy254modtr,
                                                  i.jaqy254suctr,
                                                  i.jaqy254codtr,
                                                  i.jaqy254reltr,
                                                  i.jaqy254feini);
    exception
      when no_data_found then
        begin
          select distinct c.hcta,
                          c.hoper,
                          c.htoper,
                          c.hmodul,
                          c.hmda,
                          e.pepais,
                          e.petdoc,
                          e.pendoc,
                          c.hcimp1,
                          case
                            when c.htran = 16 then
                             'RETIRO'
                            when c.htran = 50 then
                             'COMPRAS'
                          end operacion
            into ln_cta,
                 ln_oper,
                 ln_toper,
                 ln_mod,
                 ln_mda,
                 ln_pais,
                 ln_tdoc,
                 lc_numdoc,
                 ln_importe,
                 lc_operacion
            from /**/fsh016 c, /**/fsr008 e
           where c.pgcod = 1
             and c.hcmod = 66
             and c.hsucor = 903
             and c.htran in (16, 50)
                --and c.hnrel  = i.hnrel
             and c.hfcon = i.jaqy254feini
             and c.hcimp1 = i.monto_trx
             and c.hcord =
                 /**/Pq_Datos_Fin_Mes.fn_ordinal_sin_relacion(1,
                                                                   66,
                                                                   903,
                                                                   ln_variable1,
                                                                   ln_variable2,
                                                                   i.jaqy254feini)
             and hcta <> 0
             and e.cttfir = 'T'
             and e.ctnro = c.hcta
             and i.jaqy254comsg = '00';

        exception
          when too_many_rows then
            dbms_output.put_line('mas de 1: ' || i.jaqy254fetra || '-' ||
                                 i.monto_trx);
          when no_data_found then
            null;
        end;
      when too_many_rows then
        null;

    end;
    begin
      select j.penom
        into lc_titular
        from fsd001 j
       where j.pepais = ln_pais
         and j.petdoc = ln_tdoc
         and j.pendoc = lc_numdoc;
    exception
      when others then
        lc_titular := null;
    end;

    --if lc_entfin = 'N' then
    insert into /**/repext
      (jaqy254pgctr,
       jaqy254suctr,
       jaqy254modtr,
       jaqy254codtr,
       jaqy254reltr,
       jaqy254fetra,
       jaqy254feneg,
       jaqy254feini,
       jaqy254fefin,
       jaqy254comsg,
       trac,
       tarjeta,
       fecha,
       hora,
       operacion,
       moneda_trx,
       monto_trx,
       lugar,
       estado,
       motivo_rechazo,
       cta,
       oper,
       toper,
       modul,
       mda,
       pepais,
       petdoc,
       pendoc,
       imp1,
       penom,
       oper_h16)
    values
      (i.jaqy254pgctr,
       i.jaqy254suctr,
       i.jaqy254modtr,
       i.jaqy254codtr,
       i.jaqy254reltr,
       i.jaqy254fetra,
       i.jaqy254feneg,
       i.jaqy254feini,
       i.jaqy254fefin,
       i.jaqy254comsg,
       i.trac,
       i.tarjeta,
       i.fecha,
       i.hora,
       i.operacion,
       i.moneda_trx,
       i.monto_trx,
       i.lugar,
       i.estado,
       i.motivo_rechazo,
       ln_cta,
       ln_oper,
       ln_toper,
       ln_mod,
       ln_mda,
       ln_pais,
       ln_tdoc,
       lc_numdoc,
       ln_importe,
       lc_titular,
       lc_operacion);
    commit;
    --end if;
  end loop;
end SP_OP_OPEREXTR_Y_CANC;
/

