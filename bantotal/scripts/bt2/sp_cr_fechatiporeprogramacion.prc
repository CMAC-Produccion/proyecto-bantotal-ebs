create or replace procedure sp_cr_fechatiporeprogramacion(pn_emp in number,
                                                         pn_mod in number,
                                                         pn_suc in number,
                                                         pn_mda in number,
                                                         pn_pap in number,
                                                         pn_cta in number,
                                                         pn_ope in number,
                                                         pn_sbo in number,
                                                         pn_tpo in number,
                                                         ld_fecha out date,
                                                         lv_tipo out varchar2) is
begin
  begin
  
    select fecha, tipo
      into ld_fecha, lv_tipo
      from (select *
              from (select aqpb002fep fecha, 'CONGEL' tipo
                      from aqpb002
                     where aqpb002emp = pn_emp
                       and aqpb002mod = pn_mod
                       and aqpb002suc = pn_suc
                       and aqpb002mda = pn_mda
                       and aqpb002pap = pn_pap
                       and aqpb002cta = pn_cta
                       and aqpb002ope = pn_ope
                       and aqpb002sbo = pn_sbo
                       and aqpb002top = pn_tpo
                       and aqpb002est = 'C'
                       and nvl(aqpb002revr, 'N') = 'N'
                    union all
                    select jaqz698fep, 'RECONO'
                      from jaqz698
                     where jaqz698emp = pn_emp
                       and jaqz698mod = pn_mod
                       and jaqz698suc = pn_suc
                       and jaqz698mda = pn_mda
                       and jaqz698pap = pn_pap
                       and jaqz698cta = pn_cta
                       and jaqz698ope = pn_ope
                       and jaqz698sbo = pn_sbo
                       and jaqz698top = pn_tpo
                       and jaqz698est = 'C'
                    union all
                    select jaqa255fec, 'CAPIMA'
                      from jaqa255
                     where jaqa255emp = pn_emp
                       and jaqa255mod = pn_mod
                          --and jaqa255suc = pn_suc
                       and jaqa255mda = pn_mda
                       and jaqa255pap = pn_pap
                       and jaqa255cta = pn_cta
                       and jaqa255ope = pn_ope
                       and jaqa255sbo = pn_sbo - 1
                       and jaqa255tpo = pn_tpo
                       and jaqa255est = 'L'
                    union all
                    select aofval, 'CAPIAG'
                      from fsd010
                     where pgcod = pn_emp
                       and aosuc = pn_suc
                       and aomod = pn_mod
                       and aomda = pn_mda
                       and aopap = pn_pap
                       and aocta = pn_cta
                       and aooper = pn_ope
                       and aosbop = pn_sbo
                       and aotope = pn_tpo
                       and (pgcod, aosuc, aomod, aomda, aopap, aocta, aooper,
                            aosbop, aotope) in
                           (select xwfempresa,
                                   xwfsucursal,
                                   xwfmodulo,
                                   xwfmoneda,
                                   xwfpapel,
                                   xwfcuenta,
                                   xwfoperacion,
                                   xwfsubope,
                                   xwftipope
                              from xwf700 d
                             where xwfprcins in
                                   (select sng001inst
                                      from sng001
                                     where sng001ori in (13, 14)
                                       and sng001fin >=
                                           to_date('15/03/2020', 'dd/mm/yyyy'))
                               and exists
                             (select *
                                      from xwf070 a
                                     where a.xwfprcin = d.xwfprcins
                                       and a.xwfcont = 'S')
                               and xwfcar3 = '1'))
             order by fecha desc)
     where rownum = 1;
  exception
    when others then
      ld_Fecha := null;
      lv_tipo  := '';
  end;
end sp_cr_fechatiporeprogramacion;
/

