create or replace procedure sp_cr_verificar_reprogramado(pn_emp in number,
                                                         pn_mod in number,
                                                         pn_suc in number,
                                                         pn_mda in number,
                                                         pn_pap in number,
                                                         pn_cta in number,
                                                         pn_ope in number,
                                                         pn_sbo in number,
                                                         pn_tpo in number,
                                                         pv_rpt out varchar2) is
  contador  number(5);
  contador2 number(5);
  ld_fecha  date;
  lv_tipo   varchar2(10);
begin
  pv_rpt := 'N';
  --chernandez 24/08/2020
  lv_tipo := '';

  sp_cr_fechatiporeprogramacion(pn_emp,
                                pn_mod,
                                pn_suc,
                                pn_mda,
                                pn_pap,
                                pn_cta,
                                pn_ope,
                                pn_sbo,
                                pn_tpo,
                                ld_fecha,
                                lv_tipo);

  if lv_tipo = '' or NVL(lv_tipo, '0') = '0' or pn_mod = 108 then   --gcarranzas 27/08/2020
    pv_rpt := 'N';
  else
    pv_rpt := 'S';
  end if;
  /*
  select nvl(count(*), 0)
    into contador
    from jaqa255 a
   where JAQA255EMP = pn_emp
     and JAQA255MOD = pn_mod
     and JAQA255SUC = pn_suc
     and JAQA255MDA = pn_mda
     and JAQA255PAP = pn_pap
     and JAQA255CTA = pn_cta
     and JAQA255OPE = pn_ope
     and JAQA255TPO = pn_tpo
     and JAQA255SBO < pn_sbo
     and JAQA255EST = 'L';
  
  select nvl(count(*), 0)
    into contador2
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
     and (pgcod, aosuc, aomod, aomda, aopap, aocta, aooper, aosbop, aotope) in
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
                 (select sng001inst from sng001 where sng001ori in (13, 14))
             and exists (select *
                    from xwf070 a
                   where a.xwfprcin = d.xwfprcins
                     and a.xwfcont = 'S')
                
                --chernandez 13/08/2020
             and xwfcar3 = '1');
  
  if contador > 0 or contador2 > 0 then
    pv_rpt := 'S';
  end if;*/
end sp_cr_verificar_reprogramado;
/

