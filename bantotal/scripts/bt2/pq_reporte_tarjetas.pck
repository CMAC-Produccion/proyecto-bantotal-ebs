create or replace package PQ_REPORTE_TARJETAS is

  procedure ejecutarReporte(p_pgcod          number,
                            p_fecini         date,
                            p_fecfin         date,
                            p_estado_tarjeta char,
                            p_c_msgerr       out varchar2);
  procedure insertar_jaqy577(P_JAQY577NRO CHAR,
                             P_JAQY577NOM CHAR,
                             P_JAQY577FMD DATE,
                             P_JAQY577HOR CHAR,
                             P_JAQY577UMD CHAR,
                             P_JAQY577SUC NUMBER,
                             P_JAQY577DSC CHAR,
                             P_JAQY577CMO NUMBER,
                             P_JAQY577DMO CHAR,
                             P_JAQY577UAU CHAR,
                             P_JAQY577MBL CHAR,
                             P_JAQY577EST CHAR,
                             P_JAQY577TTA CHAR,
                             p_c_msgerr   out varchar2);
  procedure ejecutarRptIBanking(p_pgcod  number,
                                p_fecini date,
                                p_fecfin date,
                                p_modo   number,
                                --p_rango    number,
                                p_usuario  varchar2,
                                p_c_msgerr out varchar2);
  procedure insertar_jaqy583(P_JAQY583CORRE NUMBER,
                             P_JAQY583COTRX VARCHAR2,
                             P_JAQY583OPERA CHAR,
                             P_JAQY583FECHA DATE,
                             P_JAQY583HORA  CHAR,
                             P_JAQY583MONED CHAR,
                             P_JAQY583MONTO NUMBER,
                             P_JAQY583TARJE CHAR,
                             P_JAQY583RPTA  CHAR,
                             P_JAQY583USURE varchar2,
                             P_JAQY583CTAO  CHAR,
                             P_JAQY583CTAD  CHAR,
                             p_c_msgerr     out varchar2);

  procedure insertar_jaqy587(P_JAQY587CORRE  NUMBER,
                             P_JAQY587FECHA  DATE,
                             P_JAQY587COENT  NUMBER,
                             P_JAQY587COTSV  NUMBER,
                             P_JAQY587PGCOD  NUMBER,
                             P_JAQY587ITMOD  NUMBER,
                             P_JAQY587ITTRAN NUMBER,
                             P_JAQY587ITSUC  NUMBER,
                             P_JAQY587ITNREL NUMBER,
                             P_JAQY587MONTO  NUMBER,
                             P_JAQY587ESTAD  CHAR,
                             P_JAQY587SUMIN  CHAR,
                             P_JAQY587PERIO  VARCHAR2,
                             P_JAQY587MONPA  NUMBER,
                             P_JAQY587ESTPA  CHAR,
                             P_JAQY587ESENV  CHAR,
                             P_JAQY587CONLO  CHAR,
                             P_JAQY587MONLO  NUMBER,
                             P_JAQY587ESTLO  CHAR,
                             P_JAQY587CONFI  CHAR,
                             P_JAQY587CONFE  CHAR,
                             p_c_msgerr      out varchar2);

  procedure ejecutarRptDetalleServ(p_pgcod    number,
                                   p_fecini   date,
                                   p_coent    number,
                                   p_cotsv    number,
                                   p_c_msgerr out varchar2);

end PQ_REPORTE_TARJETAS;
/

create or replace package body PQ_REPORTE_TARJETAS is

  procedure ejecutarReporte(p_pgcod  number,
                            p_fecini date,
                            p_fecfin date,
                            --p_td10suc2       number,
                            p_estado_tarjeta char,
                            --p_estado_bin     char                           
                            p_c_msgerr out varchar2) is
  
    cursor tarjActivas(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select d.z0e483nro JAQY577NRO,
             d.z0e483fmd JAQY577FMD,
             d.z0e483nom JAQY577NOM,
             d.z0e483hor JAQY577HOR,
             d.z0e483umd JAQY577UMD,
             d.z0e483uau JAQY577UAU,
             d.z0e483suc JAQY577SUC,
             s.scnom JAQY577DSC,
             null JAQY577CMO,
             null JAQY577DMO,
             null JAQY577MBL,
             'ACTIVAS' JAQY577EST,
             tta.z0e468dsc JAQY577TTA
        from z0e483 d, z0e478 e, fst001 s, z0e468 tta
       where d.z0e483nro = e.z0e478nro
         and d.z0e483suc = s.sucurs
         and s.pgcod = p_c_pgcod
         and tta.z0e468cod = e.z0e468cod
         and d.z0e483fmd >= p_c_fecini
         and d.z0e483fmd <= p_c_fecfin
         and d.z0e483tnv = 'INS'
         and e.z0e463cod = 1
         and d.z0e483est = 'PE'
       order by d.z0e483nro;
  
    cursor tarjInactivas(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select td10tar JAQY577NRO,
             td10fchrec JAQY577FMD,
             null JAQY577NOM,
             null JAQY577HOR,
             null JAQY577UMD,
             null JAQY577UAU,
             td10suc JAQY577SUC,
             s.scnom JAQY577DSC,
             null JAQY577CMO,
             null JAQY577DMO,
             null JAQY577MBL,
             'INACTIVA' JAQY577EST,
             tta.z0e468dsc JAQY577TTA
        from ftd10, fst001 s, z0e468 tta
       where td10est = 'INACTIVA'
         and s.pgcod = p_c_pgcod
         and td10suc = s.sucurs
         and tta.z0e468cod = td10tiptar
         and td10fchrec >= p_c_fecini
         and td10fchrec <= p_c_fecfin
       order by td10suc;
  
    cursor tarjEnTransito(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select td10tar JAQY577NRO,
             td10fchrec JAQY577FMD,
             null JAQY577NOM,
             null JAQY577HOR,
             null JAQY577UMD,
             null JAQY577UAU,
             td10suc JAQY577SUC,
             s.scnom JAQY577DSC,
             null JAQY577CMO,
             null JAQY577DMO,
             null JAQY577MBL,
             'ENTRANSITO' JAQY577EST,
             tta.z0e468dsc JAQY577TTA
        from ftd10, fst001 s, z0e468 tta
       where td10est = 'EN TRANSITO'
         and s.pgcod = p_c_pgcod
         and td10suc = s.sucurs
         and tta.z0e468cod = td10tiptar
         and td10fchrec >= p_c_fecini
         and td10fchrec <= p_c_fecfin
       order by td10suc;
  
    cursor tarjBloqueoPermanente(p_c_fecini in date, p_c_fecfin in date) is
      select z.z0e478nro JAQY577NRO,
             z.z0e478fmd JAQY577FMD,
             z.z0e478nom JAQY577NOM,
             d.z0e483hor JAQY577HOR,
             z.z0e478umd JAQY577UMD,
             null JAQY577UAU,
             u.ubsuc JAQY577SUC,
             suc.scnom JAQY577DSC,
             z.z0e478can JAQY577CMO,
             m.td13dsc JAQY577DMO,
             case
               when z.z0e478umd = 'USRSWITCH ' and u.ubsuc = 901 then
                'H.BANKING'
               when z.z0e478umd like 'UNIBANCA%' then
                'UNIBANCA'
               else
                'VENTANILLA'
             end JAQY577MBL,
             'BLOQUEADA' JAQY577EST,
             tta.z0e468dsc JAQY577TTA
        from z0e478 z, z0e483 d, ftd13 m, fst046 u, fst001 suc, z0e468 tta
       where z.z0e463cod = 5
         and z.z0e478fmd >= p_c_fecini
         and z.z0e478fmd <= p_c_fecfin
         and z.z0e478nro = d.z0e483nro
         and z.z0e478fmd = d.z0e483fmd
         and d.z0e463cod = 5
         and d.z0e483est = 'PE'
         and z.z0e478can = m.td13cod
         and z.z0e478umd = u.ubuser
         and u.pgcod = suc.pgcod
         and u.ubsuc = suc.sucurs
         and tta.z0e468cod = z.z0e468cod
       order by z.z0e478nro;
  
    cursor tarjBloqueoTemporal(p_c_fecini in date, p_c_fecfin in date) is
      select z.z0e478nro JAQY577NRO,
             z.z0e478fmd JAQY577FMD,
             z.z0e478nom JAQY577NOM,
             d.z0e483hor JAQY577HOR,
             z.z0e478umd JAQY577UMD,
             null JAQY577UAU,
             u.ubsuc JAQY577SUC,
             suc.scnom JAQY577DSC,
             null JAQY577CMO,
             null JAQY577DMO,
             case
               when z.z0e478umd = 'USRSWITCH ' and u.ubsuc = 901 then
                'H.BANKING'
               when z.z0e478umd like 'UNIBANCA%' then
                'UNIBANCA'
               else
                'VENTANILLA'
             end JAQY577MBL,
             'BLOQUEOTMP' JAQY577EST,
             tta.z0e468dsc JAQY577TTA
        from z0e478 z, z0e483 d, fst046 u, fst001 suc, z0e468 tta
       where z.z0e463cod = 7
         and z.z0e478fmd >= p_c_fecini
         and z.z0e478fmd <= p_c_fecfin
         and z.z0e478nro = d.z0e483nro
         and z.z0e478fmd = d.z0e483fmd
         and d.z0e463cod = 7
         and d.z0e483est = 'PE'
         and (z.z0e478umd = 'USRSWITCH' or z.z0e478umd like 'UNIBANCA%')
         and z.z0e478umd = u.ubuser
         and u.pgcod = suc.pgcod
         and u.ubsuc = suc.sucurs
         and tta.z0e468cod = z.z0e468cod
       order by z.z0e478nro;
  
    JAQY577NRO CHAR(19);
    JAQY577NOM CHAR(24);
    JAQY577FMD DATE;
    JAQY577HOR CHAR(8);
    JAQY577UMD CHAR(10);
    JAQY577SUC NUMBER;
    JAQY577DSC CHAR(30);
    JAQY577CMO NUMBER;
    JAQY577DMO CHAR(40);
    JAQY577UAU CHAR(10);
    JAQY577MBL CHAR(10);
    JAQY577EST CHAR(10);
    JAQY577TTA CHAR(30);
  begin
    if (p_estado_tarjeta = 'A' OR p_estado_tarjeta = 'T') then
      For tarj in tarjActivas(p_pgcod, p_fecini, p_fecfin) loop
        JAQY577NRO := tarj.JAQY577NRO;
        JAQY577FMD := tarj.JAQY577FMD;
        JAQY577NOM := tarj.JAQY577NOM;
        JAQY577HOR := tarj.JAQY577HOR;
        JAQY577UMD := tarj.JAQY577UMD;
        JAQY577UAU := tarj.JAQY577UAU;
        JAQY577SUC := tarj.JAQY577SUC;
        JAQY577DSC := tarj.JAQY577DSC;
        JAQY577DMO := tarj.JAQY577DMO;
        JAQY577MBL := tarj.JAQY577MBL;
        JAQY577EST := tarj.JAQY577EST;
        JAQY577TTA := tarj.JAQY577TTA;
        insertar_jaqy577(JAQY577NRO,
                         JAQY577NOM,
                         JAQY577FMD,
                         JAQY577HOR,
                         JAQY577UMD,
                         JAQY577SUC,
                         JAQY577DSC,
                         JAQY577CMO,
                         JAQY577DMO,
                         JAQY577UAU,
                         JAQY577MBL,
                         JAQY577EST,
                         JAQY577TTA,
                         p_c_msgerr);
      end loop;
    end if;
    if (p_estado_tarjeta = 'I' OR p_estado_tarjeta = 'T') then
      For tarj in tarjInactivas(p_pgcod, p_fecini, p_fecfin) loop
        JAQY577NRO := tarj.JAQY577NRO;
        JAQY577FMD := tarj.JAQY577FMD;
        JAQY577NOM := tarj.JAQY577NOM;
        JAQY577HOR := tarj.JAQY577HOR;
        JAQY577UMD := tarj.JAQY577UMD;
        JAQY577UAU := tarj.JAQY577UAU;
        JAQY577SUC := tarj.JAQY577SUC;
        JAQY577DSC := tarj.JAQY577DSC;
        JAQY577DMO := tarj.JAQY577DMO;
        JAQY577MBL := tarj.JAQY577MBL;
        JAQY577EST := tarj.JAQY577EST;
        JAQY577TTA := tarj.JAQY577TTA;
        insertar_jaqy577(JAQY577NRO,
                         JAQY577NOM,
                         JAQY577FMD,
                         JAQY577HOR,
                         JAQY577UMD,
                         JAQY577SUC,
                         JAQY577DSC,
                         JAQY577CMO,
                         JAQY577DMO,
                         JAQY577UAU,
                         JAQY577MBL,
                         JAQY577EST,
                         JAQY577TTA,
                         p_c_msgerr);
      end loop;
    end if;
  
    if (p_estado_tarjeta = 'E' OR p_estado_tarjeta = 'T') then
      For tarj in tarjEnTransito(p_pgcod, p_fecini, p_fecfin) loop
        JAQY577NRO := tarj.JAQY577NRO;
        JAQY577FMD := tarj.JAQY577FMD;
        JAQY577NOM := tarj.JAQY577NOM;
        JAQY577HOR := tarj.JAQY577HOR;
        JAQY577UMD := tarj.JAQY577UMD;
        JAQY577UAU := tarj.JAQY577UAU;
        JAQY577SUC := tarj.JAQY577SUC;
        JAQY577DSC := tarj.JAQY577DSC;
        JAQY577DMO := tarj.JAQY577DMO;
        JAQY577MBL := tarj.JAQY577MBL;
        JAQY577EST := tarj.JAQY577EST;
        JAQY577TTA := tarj.JAQY577TTA;
        insertar_jaqy577(JAQY577NRO,
                         JAQY577NOM,
                         JAQY577FMD,
                         JAQY577HOR,
                         JAQY577UMD,
                         JAQY577SUC,
                         JAQY577DSC,
                         JAQY577CMO,
                         JAQY577DMO,
                         JAQY577UAU,
                         JAQY577MBL,
                         JAQY577EST,
                         JAQY577TTA,
                         p_c_msgerr);
      end loop;
    end if;
    if (p_estado_tarjeta = 'T') then
      For tarj in tarjBloqueoPermanente(p_fecini, p_fecfin) loop
        JAQY577NRO := tarj.JAQY577NRO;
        JAQY577FMD := tarj.JAQY577FMD;
        JAQY577NOM := tarj.JAQY577NOM;
        JAQY577HOR := tarj.JAQY577HOR;
        JAQY577UMD := tarj.JAQY577UMD;
        JAQY577UAU := tarj.JAQY577UAU;
        JAQY577SUC := tarj.JAQY577SUC;
        JAQY577DSC := tarj.JAQY577DSC;
        JAQY577DMO := tarj.JAQY577DMO;
        JAQY577MBL := tarj.JAQY577MBL;
        JAQY577EST := tarj.JAQY577EST;
        JAQY577TTA := tarj.JAQY577TTA;
        insertar_jaqy577(JAQY577NRO,
                         JAQY577NOM,
                         JAQY577FMD,
                         JAQY577HOR,
                         JAQY577UMD,
                         JAQY577SUC,
                         JAQY577DSC,
                         JAQY577CMO,
                         JAQY577DMO,
                         JAQY577UAU,
                         JAQY577MBL,
                         JAQY577EST,
                         JAQY577TTA,
                         p_c_msgerr);
      end loop;
      For tarj in tarjBloqueoTemporal(p_fecini, p_fecfin) loop
        JAQY577NRO := tarj.JAQY577NRO;
        JAQY577FMD := tarj.JAQY577FMD;
        JAQY577NOM := tarj.JAQY577NOM;
        JAQY577HOR := tarj.JAQY577HOR;
        JAQY577UMD := tarj.JAQY577UMD;
        JAQY577UAU := tarj.JAQY577UAU;
        JAQY577SUC := tarj.JAQY577SUC;
        JAQY577DSC := tarj.JAQY577DSC;
        JAQY577DMO := tarj.JAQY577DMO;
        JAQY577MBL := tarj.JAQY577MBL;
        JAQY577EST := tarj.JAQY577EST;
        JAQY577TTA := tarj.JAQY577TTA;
        insertar_jaqy577(JAQY577NRO,
                         JAQY577NOM,
                         JAQY577FMD,
                         JAQY577HOR,
                         JAQY577UMD,
                         JAQY577SUC,
                         JAQY577DSC,
                         JAQY577CMO,
                         JAQY577DMO,
                         JAQY577UAU,
                         JAQY577MBL,
                         JAQY577EST,
                         JAQY577TTA,
                         p_c_msgerr);
      end loop;
    end if;
  end; --ejecutarReporte
  -------------------------------------------------------------------

  procedure insertar_jaqy577(P_JAQY577NRO CHAR,
                             P_JAQY577NOM CHAR,
                             P_JAQY577FMD DATE,
                             P_JAQY577HOR CHAR,
                             P_JAQY577UMD CHAR,
                             P_JAQY577SUC NUMBER,
                             P_JAQY577DSC CHAR,
                             P_JAQY577CMO NUMBER,
                             P_JAQY577DMO CHAR,
                             P_JAQY577UAU CHAR,
                             P_JAQY577MBL CHAR,
                             P_JAQY577EST CHAR,
                             P_JAQY577TTA CHAR,
                             p_c_msgerr   out varchar2) is
  begin
    insert into jaqy577
      (jaqy577nro,
       jaqy577nom,
       jaqy577fmd,
       jaqy577hor,
       jaqy577umd,
       jaqy577suc,
       jaqy577dsc,
       jaqy577cmo,
       jaqy577dmo,
       jaqy577uau,
       jaqy577mbl,
       jaqy577est,
       jaqy577tta)
    values
      (p_jaqy577nro,
       p_jaqy577nom,
       p_jaqy577fmd,
       p_jaqy577hor,
       p_jaqy577umd,
       p_jaqy577suc,
       p_jaqy577dsc,
       p_jaqy577cmo,
       p_jaqy577dmo,
       p_jaqy577uau,
       p_jaqy577mbl,
       p_jaqy577est,
       p_jaqy577tta);
    commit;
  exception
    when others then
      --dbms_output.put_line(sqlerrm);
      p_c_msgerr := sqlerrm;
  end; --insertar_jaqy577
  -------------------------------------------------------------------
  procedure ejecutarRptIBanking(p_pgcod  number,
                                p_fecini date,
                                p_fecfin date,
                                p_modo   number,
                                --p_rango    number,
                                p_usuario  varchar2,
                                p_c_msgerr out varchar2) is
    cursor operacionesNoContRecientes(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select z.x9996drqsv JAQY583COTRX,
             trim(c.x9996cdesc) JAQY583OPERA,
             z.x9996dfesv JAQY583FECHA,
             z.x9996dhosv JAQY583HORA,
             fs.monom JAQY583MONED,
             z.x9996dimpo JAQY583MONTO,
             substr(x9996drqcl, 1, 16) JAQY583TARJE,
             z.x9996grsco JAQY583RPTA,
             '' jaqy583ctao,
             '' jaqy583ctad
        from x9996d z
       inner join x9996c c on z.x9996acnco = c.x9996acnco
                          and z.x9996bopco = c.x9996bopco
                          and z.x9996cvart = c.x9996cvart
       inner join fst005 fs on fs.moneda = z.x9996dmdao
       where z.x9996acnco = 5
         and z.x9996dfesv >= p_c_fecini
         and z.x9996dfesv <= p_c_fecfin
         and (z.x9996acnco, z.x9996bopco, z.x9996cvart) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = p_c_pgcod
                 and tp1cod1 = 10801
                 and tp1corr1 = 15
                 and tp1corr2 = 1
                 and tp1corr3 > 0)
       order by z.x9996drqsv asc;
    cursor operacionesContablesRecientes(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select z.pgcod || '-' || z.hcmod || '-' || z.htran || '-' || z.hnrel JAQY583COTRX,
             trim(c.trnom) JAQY583OPERA,
             z.hfcon JAQY583FECHA,
             z.hhora JAQY583HORA,
             fs.monom JAQY583MONED,
             e.hcimp1 JAQY583MONTO,
             (select substr(x9996drqcl, 1, 16)
                from x9996d q
               where q.x9996acnco = 5
                 and q.x9996dfesv = z.hfcon
                 and q.x9996ddcta = e.hcta
                 and rownum = 1) JAQY583TARJE,
             case
               when z.hccorr = 0 then
                'NORMAL'
               else
                'CANCELADA'
             end JAQY583RPTA,
             case
               when e.hmodul = 21 then
                lpad(e.hcta, 9, 0) || lpad(e.hmodul, 3, 0) ||
                lpad(e.hmda, 3, 0) || lpad(e.hsubop, 2, 0) ||
                lpad(e.htoper, 3, 0)
               when e.hmodul = 22 then
                lpad(e.hcta, 9, 0) || lpad(e.hmodul, 3, 0) ||
                lpad(e.hmda, 3, 0) || lpad(e.hoper, 9, 0) ||
                lpad(e.htoper, 3, 0)
               else
                ''
             end JAQY583CTAO,
             /*(select case
                                             when q.x9996dcmod = 21 then
                                              lpad(q.x9996dccta, 9, 0) || lpad(q.x9996dcmod, 3, 0) ||
                                              lpad(q.x9996dcmda, 3, 0) || lpad(q.x9996dcsbo, 2, 0) ||
                                              lpad(q.x9996dctop, 3, 0)
                                             when q.x9996dcmod = 22 then
                                              lpad(q.x9996dccta, 9, 0) || lpad(q.x9996dcmod, 3, 0) ||
                                              lpad(q.x9996dcmda, 3, 0) || lpad(q.x9996dcope, 9, 0) ||
                                              lpad(q.x9996dctop, 3, 0)
                                             else
                                              ''
                                           end
                                      from x9996d q
                                     where q.x9996acnco = 5
                                       and q.x9996dfesv = z.hfcon
                                       and q.x9996ddcta = e.hcta
                                       and q.x9996dccta <> 0
                                       and 
                                       and rownum = 1)*/
             (select case
                       when q.hmodul = 21 then
                        lpad(q.hcta, 9, 0) || lpad(q.hmodul, 3, 0) ||
                        lpad(q.hmda, 3, 0) || lpad(q.hsubop, 2, 0) ||
                        lpad(q.htoper, 3, 0)
                       when q.hmodul = 22 then
                        lpad(q.hcta, 9, 0) || lpad(q.hmodul, 3, 0) ||
                        lpad(q.hmda, 3, 0) || lpad(q.hoper, 9, 0) ||
                        lpad(q.htoper, 3, 0)
                       else
                        ''
                     end
                from fsh016 q
               where q.pgcod = e.pgcod
                 and q.hcmod = e.hcmod
                 and q.hsucor = e.hsucor
                 and q.htran = e.htran
                 and q.hnrel = e.hnrel
                 and q.hfcon = e.hfcon
                 and q.hcodmo = 2
                 and q.hmodul = 21
                 and q.hcmcod <> 55
                 and q.hcmcod <> 920) JAQY583CTAD
        from fsh015 z
       inner join fsh016 e on z.pgcod = e.pgcod
                          and z.hcmod = e.hcmod
                          and z.hsucor = e.hsucor
                          and z.htran = e.htran
                          and z.hnrel = e.hnrel
                          and z.hfcon = e.hfcon
       inner join fst034 c on z.pgcod = c.pgcod
                          and z.hcmod = c.trmod
                          and z.htran = c.trnro
       inner join fst005 fs on fs.moneda = e.hcmdao
       where z.pgcod = p_c_pgcod
         and z.hcmod = 140
         and z.hfcon >= p_c_fecini
         and z.hfcon <= p_c_fecfin
         and e.hcodmo = 1
         and e.hmodul = 21
         and e.hcmcod <> 55
         and e.hcmcod <> 920;
  
    cursor operacionesContablesDia(p_c_pgcod number, p_c_fec in date) is
      select z.pgcod || '-' || z.itmod || '-' || z.ittran || '-' ||
             z.itnrel JAQY583COTRX,
             trim(c.trnom) JAQY583OPERA,
             z.itfcon JAQY583FECHA,
             z.ithora JAQY583HORA,
             fs.monom JAQY583MONED,
             e.itimp1 JAQY583MONTO,
             (select substr(x9996drqcl, 1, 16)
                from x9996d q
               where q.x9996acnco = 5
                 and q.x9996dfesv = z.itfcon
                 and q.x9996ddcta = e.ctnro
                 and rownum = 1) JAQY583TARJE,
             case
               when z.itcorr = 0 then
                'NORMAL'
               else
                'CANCELADA'
             end JAQY583RPTA,
             case
               when e.modulo = 21 then
                lpad(e.ctnro, 9, 0) || lpad(e.modulo, 3, 0) ||
                lpad(e.moneda, 3, 0) || lpad(e.itsubo, 2, 0) ||
                lpad(e.itoper, 3, 0)
               when e.modulo = 22 then
                lpad(e.ctnro, 9, 0) || lpad(e.modulo, 3, 0) ||
                lpad(e.moneda, 3, 0) || lpad(e.itoper, 9, 0) ||
                lpad(e.itoper, 3, 0)
               else
                ''
             end JAQY583CTAO,
             /*(select case
                                              when q.x9996dcmod = 21 then
                                               lpad(q.x9996dccta, 9, 0) || lpad(q.x9996dcmod, 3, 0) ||
                                               lpad(q.x9996dcmda, 3, 0) || lpad(q.x9996dcsbo, 2, 0) ||
                                               lpad(q.x9996dctop, 3, 0)
                                              when q.x9996dcmod = 22 then
                                               lpad(q.x9996dccta, 9, 0) || lpad(q.x9996dcmod, 3, 0) ||
                                               lpad(q.x9996dcmda, 3, 0) || lpad(q.x9996dcope, 9, 0) ||
                                               lpad(q.x9996dctop, 3, 0)
                                              else
                                               ''
                                            end
                                       from x9996d q
                                      where q.x9996acnco = 5
                                        and q.x9996dfesv = z.itfcon
                                        and q.x9996ddcta = e.ctnro
                                        and q.x9996dccta <> 0
                                        and rownum = 1)*/
             (select case
                       when e.modulo = 21 then
                        lpad(e.ctnro, 9, 0) || lpad(e.modulo, 3, 0) ||
                        lpad(e.moneda, 3, 0) || lpad(e.itsubo, 2, 0) ||
                        lpad(e.itoper, 3, 0)
                       when e.modulo = 22 then
                        lpad(e.ctnro, 9, 0) || lpad(e.modulo, 3, 0) ||
                        lpad(e.moneda, 3, 0) || lpad(e.itoper, 9, 0) ||
                        lpad(e.itoper, 3, 0)
                       else
                        ''
                     end
                from fsd016 q
               where q.pgcod = e.pgcod
                 and q.itmod = e.itmod
                 and q.itsuc = e.itsuc
                 and q.ittran = e.ittran
                 and q.itnrel = e.itnrel
                 and q.itfval = e.itfval
                 and q.itdbha = 2
                 and q.modulo = 21
                 and q.itcodm <> 55
                 and q.itcodm <> 920) JAQY583CTAD
        from fsd015 z
       inner join fsd016 e on z.pgcod = e.pgcod
                          and z.itmod = e.itmod
                          and z.itsuc = e.itsuc
                          and z.ittran = e.ittran
                          and z.itnrel = e.itnrel
                          and z.itfcon = e.itfval
       inner join fst034 c on z.pgcod = c.pgcod
                          and z.itmod = c.trmod
                          and z.ittran = c.trnro
       inner join fst005 fs on fs.moneda = e.itmdao
       where z.pgcod = p_c_pgcod
         and z.itmod = 140
         and z.itfcon = p_c_fec
         and e.itdbha = 1
         and e.modulo = 21
         and e.itcodm <> 55
         and e.itcodm <> 920;
  
    /*cursor operacionesNoContHistorico(p_c_pgcod number, p_c_fecini in date) is
      select z.x9996drqsv JAQY583COTRX,
             trim(c.x9996cdesc) JAQY583OPERA,
             z.x9996dfesv JAQY583FECHA,
             z.x9996dhosv JAQY583HORA,
             z.x9996dmdao JAQY583MONED,
             z.x9996dimpo JAQY583MONTO,
             substr(x9996drqcl, 1, 16) JAQY583TARJE,
             z.x9996grsco JAQY583RPTA
        from x9996d z
       inner join x9996c c on z.x9996acnco = c.x9996acnco
                          and z.x9996bopco = c.x9996bopco
                          and z.x9996cvart = c.x9996cvart
       where z.x9996acnco = 5
         and z.x9996dfesv >= p_c_fecini
         and (z.x9996acnco, z.x9996bopco, z.x9996cvart) in
             (select tp1nro1, tp1nro2, tp1nro3
                from fst198
               where tp1cod = p_c_pgcod
                 and tp1cod1 = 10801
                 and tp1corr1 = 15
                 and tp1corr2 = 1
                 and tp1corr3 > 0)
       order by z.x9996drqsv asc;
    
    cursor operacionesContablesHistorico(p_c_pgcod number, p_c_fecini in date, p_c_fecfin in date) is
      select z.pgcod || '-' || z.hcmod || '-' || z.htran || '-' || z.hnrel JAQY583COTRX,
             trim(c.trnom) JAQY583OPERA,
             z.hfcon JAQY583FECHA,
             z.hhora JAQY583HORA,
             e.hcmdao JAQY583MONED,
             e.hcimp1 JAQY583MONTO,
             (select substr(x9996drqcl, 1, 16)
                from x9996d q
               where q.x9996acnco = 5
                 and q.x9996dfesv = z.hfcon
                 and q.x9996ddcta = e.hcta
                 and rownum = 1) JAQY583TARJE,
             case
               when z.hccorr = 0 then
                'NORMAL'
               else
                'CANCELADA'
             end JAQY583RPTA
        from fsh015 z
       inner join fsh016 e on z.pgcod = e.pgcod
                          and z.hcmod = e.hcmod
                          and z.hsucor = e.hsucor
                          and z.htran = e.htran
                          and z.hnrel = e.hnrel
                          and z.hfcon = e.hfcon
       inner join fst034 c on z.pgcod = c.pgcod
                          and z.hcmod = c.trmod
                          and z.htran = c.trnro
       where z.pgcod = p_c_pgcod
         and z.hcmod = 140
         and z.hfcon >= p_c_fecini
         and z.hfcon <= p_c_fecfin
         and e.hcodmo = 1
         and e.hmodul = 21
         and e.hcmcod <> 55
         and e.hcmcod <> 920;*/
  
    JAQY583CORRE NUMBER(10);
    JAQY583COTRX VARCHAR2(20);
    JAQY583OPERA CHAR(65);
    JAQY583FECHA DATE;
    JAQY583HORA  CHAR(8);
    JAQY583MONED CHAR(30);
    JAQY583MONTO NUMBER(16, 2);
    JAQY583TARJE CHAR(16);
    JAQY583RPTA  CHAR(9);
    JAQY583CTAO  CHAR(27);
    JAQY583CTAD  CHAR(27);
    contador     number;
    FECINI       x9996d.x9996dfesv%type;
    FECAPE       fst017.pgfape%type;
    FECSIS       date;
  begin
    contador := 1;
    --FECINI   := p_fecini;
  
    select min(x9996dfesv) into FECINI from x9996d where x9996acnco = 5;
    if (p_fecini > FECINI) then
      FECINI := p_fecini;
    end if;
    select pgfape into FECAPE from fst017 where pgcod = p_pgcod;
  
    select trunc(sysdate) into FECSIS from dual;
  
    if (p_modo = 1 or p_modo = 3) then
      For opIB in operacionesNoContRecientes(p_pgcod, FECINI, p_fecfin) loop
        JAQY583CORRE := contador;
        JAQY583COTRX := opIB.JAQY583COTRX;
        JAQY583OPERA := opIB.JAQY583OPERA;
        JAQY583FECHA := opIB.JAQY583FECHA;
        JAQY583HORA  := opIB.JAQY583HORA;
        JAQY583MONED := opIB.JAQY583MONED;
        JAQY583MONTO := opIB.JAQY583MONTO;
        JAQY583TARJE := opIB.JAQY583TARJE;
        JAQY583RPTA  := opIB.JAQY583RPTA;
        JAQY583CTAO  := opIB.Jaqy583ctao;
        JAQY583CTAD  := opIB.Jaqy583ctad;
        insertar_jaqy583(JAQY583CORRE,
                         JAQY583COTRX,
                         JAQY583OPERA,
                         JAQY583FECHA,
                         JAQY583HORA,
                         JAQY583MONED,
                         JAQY583MONTO,
                         JAQY583TARJE,
                         JAQY583RPTA,
                         p_usuario,
                         JAQY583CTAO,
                         JAQY583CTAD,
                         p_c_msgerr);
        contador := contador + 1;
      end loop;
    end if;
    if (p_modo = 2 or p_modo = 3) then
      if (FECAPE <= p_fecfin) then
        For opIB in operacionesContablesDia(p_pgcod, FECAPE) loop
          JAQY583CORRE := contador;
          JAQY583COTRX := opIB.JAQY583COTRX;
          JAQY583OPERA := opIB.JAQY583OPERA;
          JAQY583FECHA := opIB.JAQY583FECHA;
          JAQY583HORA  := opIB.JAQY583HORA;
          JAQY583MONED := opIB.JAQY583MONED;
          JAQY583MONTO := opIB.JAQY583MONTO;
          JAQY583TARJE := opIB.JAQY583TARJE;
          JAQY583RPTA  := opIB.JAQY583RPTA;
          JAQY583CTAO  := opIB.Jaqy583ctao;
          JAQY583CTAD  := opIB.Jaqy583ctad;
          insertar_jaqy583(JAQY583CORRE,
                           JAQY583COTRX,
                           JAQY583OPERA,
                           JAQY583FECHA,
                           JAQY583HORA,
                           JAQY583MONED,
                           JAQY583MONTO,
                           JAQY583TARJE,
                           JAQY583RPTA,
                           p_usuario,
                           JAQY583CTAO,
                           JAQY583CTAD,
                           p_c_msgerr);
          contador := contador + 1;
        end loop;
      end if;
      For opIB in operacionesContablesRecientes(p_pgcod, FECINI, p_fecfin) loop
        JAQY583CORRE := contador;
        JAQY583COTRX := opIB.JAQY583COTRX;
        JAQY583OPERA := opIB.JAQY583OPERA;
        JAQY583FECHA := opIB.JAQY583FECHA;
        JAQY583HORA  := opIB.JAQY583HORA;
        JAQY583MONED := opIB.JAQY583MONED;
        JAQY583MONTO := opIB.JAQY583MONTO;
        JAQY583TARJE := opIB.JAQY583TARJE;
        JAQY583RPTA  := opIB.JAQY583RPTA;
        JAQY583CTAO  := opIB.Jaqy583ctao;
        JAQY583CTAD  := opIB.Jaqy583ctad;
        insertar_jaqy583(JAQY583CORRE,
                         JAQY583COTRX,
                         JAQY583OPERA,
                         JAQY583FECHA,
                         JAQY583HORA,
                         JAQY583MONED,
                         JAQY583MONTO,
                         JAQY583TARJE,
                         JAQY583RPTA,
                         p_usuario,
                         JAQY583CTAO,
                         JAQY583CTAD,
                         p_c_msgerr);
        contador := contador + 1;
      end loop;
    end if;
    /*if (p_modo = 1 or p_modo = 3) and p_rango = 2 then
      For opIB in operacionesNoContHistorico(p_pgcod, p_fecini) loop
        JAQY583CORRE := contador;
        JAQY583COTRX := opIB.JAQY583COTRX;
        JAQY583OPERA := opIB.JAQY583OPERA;
        JAQY583FECHA := opIB.JAQY583FECHA;
        JAQY583HORA  := opIB.JAQY583HORA;
        JAQY583MONED := opIB.JAQY583MONED;
        JAQY583MONTO := opIB.JAQY583MONTO;
        JAQY583TARJE := opIB.JAQY583TARJE;
        JAQY583RPTA  := opIB.JAQY583RPTA;
        insertar_jaqy583(JAQY583CORRE,
                         JAQY583COTRX,
                         JAQY583OPERA,
                         JAQY583FECHA,
                         JAQY583HORA,
                         JAQY583MONED,
                         JAQY583MONTO,
                         JAQY583TARJE,
                         JAQY583RPTA,
                         p_c_msgerr);
        contador := contador + 1;
      end loop;
    end if;
    if (p_modo = 2 or p_modo = 3) and p_rango = 2 then
      For opIB in operacionesContablesHistorico(p_pgcod, p_fecini, FECINI) loop
        JAQY583CORRE := contador;
        JAQY583COTRX := opIB.JAQY583COTRX;
        JAQY583OPERA := opIB.JAQY583OPERA;
        JAQY583FECHA := opIB.JAQY583FECHA;
        JAQY583HORA  := opIB.JAQY583HORA;
        JAQY583MONED := opIB.JAQY583MONED;
        JAQY583MONTO := opIB.JAQY583MONTO;
        JAQY583TARJE := opIB.JAQY583TARJE;
        JAQY583RPTA  := opIB.JAQY583RPTA;
        insertar_jaqy583(JAQY583CORRE,
                         JAQY583COTRX,
                         JAQY583OPERA,
                         JAQY583FECHA,
                         JAQY583HORA,
                         JAQY583MONED,
                         JAQY583MONTO,
                         JAQY583TARJE,
                         JAQY583RPTA,
                         p_c_msgerr);
        contador := contador + 1;
      end loop;
    end if;*/
  
  end; --ejecutarRptIBanking
  ------------------------------------------------------------------------------
  procedure insertar_jaqy583(P_JAQY583CORRE NUMBER,
                             P_JAQY583COTRX VARCHAR2,
                             P_JAQY583OPERA CHAR,
                             P_JAQY583FECHA DATE,
                             P_JAQY583HORA  CHAR,
                             P_JAQY583MONED CHAR,
                             P_JAQY583MONTO NUMBER,
                             P_JAQY583TARJE CHAR,
                             P_JAQY583RPTA  CHAR,
                             P_JAQY583USURE varchar2,
                             P_JAQY583CTAO  CHAR,
                             P_JAQY583CTAD  CHAR,
                             p_c_msgerr     out varchar2) is
  begin
    insert into jaqy583
      (JAQY583CORRE,
       JAQY583COTRX,
       JAQY583OPERA,
       JAQY583FECHA,
       JAQY583HORA,
       JAQY583MONED,
       JAQY583MONTO,
       JAQY583TARJE,
       JAQY583RPTA,
       JAQY583FECRE,
       JAQY583USURE,
       JAQY583CTAO,
       JAQY583CTAD)
    values
      (P_JAQY583CORRE,
       P_JAQY583COTRX,
       P_JAQY583OPERA,
       P_JAQY583FECHA,
       P_JAQY583HORA,
       P_JAQY583MONED,
       P_JAQY583MONTO,
       P_JAQY583TARJE,
       P_JAQY583RPTA,
       sysdate,
       P_JAQY583USURE,
       P_JAQY583CTAO,
       P_JAQY583CTAD);
    commit;
  exception
    when others then
      --dbms_output.put_line(sqlerrm);
      p_c_msgerr := sqlerrm;
    
  end; --insertar_jaqy583

  ------------------------------------------------------------------------------

  procedure insertar_jaqy587(P_JAQY587CORRE  NUMBER,
                             P_JAQY587FECHA  DATE,
                             P_JAQY587COENT  NUMBER,
                             P_JAQY587COTSV  NUMBER,
                             P_JAQY587PGCOD  NUMBER,
                             P_JAQY587ITMOD  NUMBER,
                             P_JAQY587ITTRAN NUMBER,
                             P_JAQY587ITSUC  NUMBER,
                             P_JAQY587ITNREL NUMBER,
                             P_JAQY587MONTO  NUMBER,
                             P_JAQY587ESTAD  CHAR,
                             P_JAQY587SUMIN  CHAR,
                             P_JAQY587PERIO  VARCHAR2,
                             P_JAQY587MONPA  NUMBER,
                             P_JAQY587ESTPA  CHAR,
                             P_JAQY587ESENV  CHAR,
                             P_JAQY587CONLO  CHAR,
                             P_JAQY587MONLO  NUMBER,
                             P_JAQY587ESTLO  CHAR,
                             P_JAQY587CONFI  CHAR,
                             P_JAQY587CONFE  CHAR,
                             p_c_msgerr      out varchar2) is
  begin
    insert into jaqy587
      (JAQY587CORRE,
       JAQY587FECHA,
       JAQY587COENT,
       JAQY587COTSV,
       JAQY587PGCOD,
       JAQY587ITMOD,
       JAQY587ITTRAN,
       JAQY587ITSUC,
       JAQY587ITNREL,
       JAQY587MONTO,
       JAQY587ESTAD,
       JAQY587SUMIN,
       JAQY587PERIO,
       JAQY587MONPA,
       JAQY587ESTPA,
       JAQY587ESENV,
       JAQY587CONLO,
       JAQY587MONLO,
       JAQY587ESTLO,
       JAQY587CONFI,
       JAQY587CONFE)
    values
      (P_JAQY587CORRE,
       P_JAQY587FECHA,
       P_JAQY587COENT,
       P_JAQY587COTSV,
       P_JAQY587PGCOD,
       P_JAQY587ITMOD,
       P_JAQY587ITTRAN,
       P_JAQY587ITSUC,
       P_JAQY587ITNREL,
       P_JAQY587MONTO,
       P_JAQY587ESTAD,
       P_JAQY587SUMIN,
       P_JAQY587PERIO,
       P_JAQY587MONPA,
       P_JAQY587ESTPA,
       P_JAQY587ESENV,
       P_JAQY587CONLO,
       P_JAQY587MONLO,
       P_JAQY587ESTLO,
       P_JAQY587CONFI,
       P_JAQY587CONFE);
    commit;
  exception
    when others then
      --dbms_output.put_line(sqlerrm);
      p_c_msgerr := sqlerrm;
    
  end; --insertar_jaqy587

  -------------------------------------------------------------------
  procedure ejecutarRptDetalleServ(p_pgcod    number,
                                   p_fecini   date,
                                   p_coent    number,
                                   p_cotsv    number,
                                   p_c_msgerr out varchar2) is
  
    cursor datosServicio(p_n_codent number, p_n_codtsv number) is
      select a.jaql509rgcta cta,
             a.jaql509rgmod mou,
             a.jaql509rgmda mda,
             a.jaql509rgsop sop,
             a.jaql509rgtop top,
             to_number(trim(a.jaql509c3aux)) age
        from jaql509 a
       where jaql508coent = p_n_codent
         and jaql509cotse = p_n_codtsv;
  
    cursor ctaF11(p_p_pgcod number, p_modulo number, p_ittope number, p_moneda number, p_ctnro number, p_itsubo number, p_itsucd number) is
      select Scrub, Scpap
        from fsd011
       Where Pgcod = p_p_pgcod
         and Scmod = p_modulo
         and Sctope = p_ittope
         and Scmda = p_moneda
         and Sccta = p_ctnro
         and Scsbop = p_itsubo
         and Scsuc = p_itsucd;
  
    cursor pagos(p_pgcod number, p_ctnro number, p_modulo number, p_moneda number, p_itsubo number, p_ittope number, p_itsucd number, p_itord number, p_itdbha number) is
      select b.itfcon,
             a.pgcod,
             a.itsuc,
             a.itmod,
             a.ittran,
             a.itnrel,
             a.itimp1,
             b.itcorr,
             b.itcont,
             c.jaql515sumin,
             (select sum(jaql516mocob)
                from jaql516 e
               where e.jaql515copsv = c.jaql515copsv
                 and e.jaql516esreg = 'V') jaql515mtoop,
             c.jaql515esreg,
             c.jaql515esenv,
             d.jaqy584nrcon,
             d.jaqy584mocob,
             d.jaqy584cores,
             d.jaqy584confi,
             (select e.jaqy584confi
                from jaqy584 e
               where d.jaqy584coent = e.jaqy584coent
                 and d.jaqy584cotsv = e.jaqy584cotsv
                 and d.jaqy584nrcon = e.jaqy584nrcon
                 and d.jaqy584trace = e.jaqy584trace
                 and d.jaqy584fesis = e.jaqy584fesis
                 and e.jaqy584comsg = '400'
                 and e.jaqy584cores = '00') EXTORNO
        from fsd016 a
       inner join fsd015 b on a.pgcod = b.pgcod
                          and a.itsuc = b.itsuc
                          and a.itmod = b.itmod
                          and a.ittran = b.ittran
                          and a.itnrel = b.itnrel
                          and a.itfval = b.itfcon
       inner join jaql515 c on c.jaql515pgcod = a.pgcod
                           and c.jaql515pgsuc = a.itsuc
                           and c.jaql515scmod = a.itmod
                           and c.jaql515stran = a.ittran
                           and c.jaql515snrel = a.itnrel
                           and c.jaql515femov = a.itfval
       inner join jaql516 e on c.jaql515copsv = e.jaql515copsv
        left join jaqy584 d on d.jaqy584pgcod = a.pgcod
                           and d.jaqy584itmod = a.itmod
                           and d.jaqy584ttran = a.ittran
                           and d.jaqy584itrel = a.itnrel
                           and d.jaqy584feape = b.itfcon
                           and d.jaqy584itsuc = a.itsuc
                           and d.jaqy584copsv = c.jaql515copsv
       where a.pgcod = p_pgcod
         and a.ctnro = p_ctnro
         and a.modulo = p_modulo
         and a.moneda = p_moneda
         and a.itsubo = p_itsubo
         and a.ittope = p_ittope
         and a.itsucd = p_itsucd
         and a.itord = p_itord
         and a.itdbha = p_itdbha
         and ((b.Itmod = 50 and b.Ittran = 980) or
             (b.Itmod = 50 and b.Ittran = 990) or
             (b.Itmod = 140 and b.Ittran = 981) or
             (b.Itmod = 490 and b.Ittran = 982) or
             (b.Itmod = 490 and b.Ittran = 983) or
             (b.Itmod = 50 and b.Ittran = 940) or
             (b.Itmod = 490 and b.Ittran = 942) or
             --Hlaqui 23/08/2018
             (b.Itmod = 490 and b.Ittran = 947) or
             (b.Itmod=490 and b.Ittran=943) or 
             (b.Itmod=66 and b.Ittran=943) or 
             (b.Itmod=489 and b.Ittran=942) or 
             (b.Itmod=489 and b.Ittran=982) or 
             (b.Itmod=66 and b.Ittran=983)
             )
       order by d.jaqy584cotra desc;
  
    cursor pagosH(p_pgcod number, p_ctnro number, p_modulo number, p_moneda number, p_itsubo number, p_ittope number, p_itsucd number, p_rubro number, p_pap number, p_itord number, p_itdbha number, p_fecha date) is
      select b.hfcon,
             a.pgcod,
             a.hsucor,
             a.hcmod,
             a.htran,
             a.hnrel,
             a.hcimp1,
             b.hccorr,
             'S' itcont,
             c.jaql515sumin,
             (select sum(jaql516mocob)
                from jaql516 e
               where e.jaql515copsv = c.jaql515copsv
                 and e.jaql516esreg = 'V') jaql515mtoop,
             c.jaql515esreg,
             c.jaql515esenv,
             d.jaqy584nrcon,
             d.jaqy584mocob,
             d.jaqy584cores,
             d.jaqy584confi,
             (select e.jaqy584confi
                from jaqy584 e
               where d.jaqy584coent = e.jaqy584coent
                 and d.jaqy584cotsv = e.jaqy584cotsv
                 and d.jaqy584nrcon = e.jaqy584nrcon
                 and d.jaqy584trace = e.jaqy584trace
                 and d.jaqy584fesis = e.jaqy584fesis
                 and e.jaqy584comsg = '400'
                 and e.jaqy584cores = '00') EXTORNO
        from fsh016 a
       inner join fsh015 b on a.pgcod = b.pgcod
                          and a.hsucor = b.hsucor
                          and a.hcmod = b.hcmod
                          and a.htran = b.htran
                          and a.hnrel = b.hnrel
                          and a.hfcon = b.hfcon
       inner join jaql515 c on c.jaql515pgcod = a.pgcod
                           and c.jaql515pgsuc = a.hsucor
                           and c.jaql515scmod = a.hcmod
                           and c.jaql515stran = a.htran
                           and c.jaql515snrel = a.hnrel
                           and c.jaql515femov = a.hfcon
        left join jaqy584 d on d.jaqy584pgcod = a.pgcod
                           and d.jaqy584itmod = a.hcmod
                           and d.jaqy584ttran = a.htran
                           and d.jaqy584itrel = a.hnrel
                           and d.jaqy584feape = b.hfcon
                           and d.jaqy584itsuc = a.hsucor
                           and d.jaqy584copsv = c.jaql515copsv
       where a.pgcod = p_pgcod
         and a.hsucur = p_itsucd
         and a.hrubro = p_rubro
         and a.hmda = p_moneda
         and a.hpap = p_pap
         and a.hcta = p_ctnro
         and a.hmodul = p_modulo
         and a.hsubop = p_itsubo
         and a.htoper = p_ittope
         and a.hfcon = p_fecha
         and a.hcord = p_itord
         and a.hcodmo = p_itdbha
         and ((b.hcmod = 50 and b.htran = 980) or
             (b.hcmod = 50 and b.htran = 990) or
             (b.hcmod = 140 and b.htran = 981) or
             (b.hcmod = 490 and b.htran = 982) or
             (b.hcmod = 490 and b.htran = 983) or
             (b.hcmod = 50 and b.htran = 940) or
             (b.hcmod = 490 and b.htran = 942) or
              --Hlaqui 23/08/2018
             (b.hcmod = 490 and b.htran = 947) or
             (b.hcmod=490 and b.htran=943) or 
             (b.hcmod=66 and b.htran=943) or 
             (b.hcmod=489 and b.htran=942) or 
             (b.hcmod=489 and b.htran=982) or 
             (b.hcmod=66 and b.htran=983)
             )
       order by d.jaqy584cotra desc;
  
    /*JAQY587CORRE  NUMBER(4);
    JAQY587FECHA  DATE;
    JAQY587COENT  NUMBER(3);
    JAQY587COTSV  NUMBER(3);
    JAQY587PGCOD  NUMBER(4);
    JAQY587ITMOD  NUMBER(3);
    JAQY587ITTRAN NUMBER(3);
    JAQY587ITSUC  NUMBER(3);
    JAQY587ITNREL NUMBER(4);
    JAQY587MONTO  NUMBER(17, 2);
    JAQY587ESTAD  CHAR(1);
    JAQY587SUMIN  CHAR(20);
    JAQY587PERIO  VARCHAR2(40);
    JAQY587MONPA  NUMBER(17, 2);
    JAQY587ESTPA  CHAR(1);
    JAQY587ESENV  CHAR(1);
    JAQY587CONLO  CHAR(20);
    JAQY587MONLO  NUMBER(17, 2);
    JAQY587ESTLO  CHAR(1);*/
    contador number;
    --FECINI        x9996d.x9996dfesv%type;
    FECAPE   fst017.pgfape%type;
    estado   CHAR(1);
    scrubAux fsd011.scrub%type;
    papAux   fsd011.scpap%type;
    --FECSIS        date;
  begin
    contador := 1;
    --FECINI   := p_fecini;
  
    --select min(x9996dfesv) into FECINI from x9996d where x9996acnco = 5;
    --if (p_fecini > FECINI) then
    --  FECINI := p_fecini;
    --end if;
    delete from jaqy587;
    select pgfape into FECAPE from fst017 where pgcod = p_pgcod;
  
    --select trunc(sysdate) into FECSIS from dual;
    For daServ in datosServicio(p_coent, p_cotsv) loop
      If p_fecini = FECAPE then
        For daPag in pagos(p_pgcod,
                           daServ.Cta,
                           daServ.Mou,
                           daServ.Mda,
                           daServ.Sop,
                           daServ.Top,
                           daServ.Age,
                           10,
                           2) loop
          If daPag.Itcont = 'S' and daPag.Itcorr = 0 then
            estado := 'V';
          Else
            If daPag.Itcont = 'S' and daPag.Itcorr = 99 then
              estado := 'E';
            Else
              estado := 'N';
            End If;
          End IF;
          insertar_jaqy587(contador,
                           daPag.Itfcon,
                           p_coent,
                           p_cotsv,
                           daPag.Pgcod,
                           daPag.Itmod,
                           daPag.Ittran,
                           daPag.Itsuc,
                           daPag.Itnrel,
                           daPag.Itimp1,
                           estado,
                           daPag.Jaql515sumin,
                           '',
                           daPag.Jaql515mtoop,
                           daPag.Jaql515esreg,
                           daPag.Jaql515esenv,
                           daPag.Jaqy584nrcon,
                           daPag.Jaqy584mocob,
                           daPag.Jaqy584cores,
                           daPag.Jaqy584confi,
                           daPag.Extorno,
                           p_c_msgerr);
          contador := contador + 1;
        End loop;
      Else
        scrubAux := 0;
        papAux   := 0;
        For daCta in ctaF11(p_pgcod,
                            daServ.Mou,
                            daServ.Top,
                            daServ.Mda,
                            daServ.Cta,
                            daServ.Sop,
                            daServ.Age) loop
          scrubAux := daCta.Scrub;
          papAux   := daCta.Scpap;
        End loop;
      
        For daPag1 in pagosH(p_pgcod,
                             daServ.Cta,
                             daServ.Mou,
                             daServ.Mda,
                             daServ.Sop,
                             daServ.Top,
                             daServ.Age,
                             scrubAux,
                             papAux,
                             10,
                             2,
                             p_fecini) loop
          If daPag1.hccorr = 0 then
            estado := 'V';
          Else
            If daPag1.hccorr = 99 then
              estado := 'E';
            Else
              estado := 'N';
            End If;
          End IF;
          insertar_jaqy587(contador,
                           daPag1.hfcon,
                           p_coent,
                           p_cotsv,
                           daPag1.Pgcod,
                           daPag1.hcmod,
                           daPag1.htran,
                           daPag1.Hsucor,
                           daPag1.hnrel,
                           daPag1.hcimp1,
                           estado,
                           daPag1.Jaql515sumin,
                           '',
                           daPag1.Jaql515mtoop,
                           daPag1.Jaql515esreg,
                           daPag1.Jaql515esenv,
                           daPag1.Jaqy584nrcon,
                           daPag1.Jaqy584mocob,
                           daPag1.Jaqy584cores,
                           daPag1.Jaqy584confi,
                           daPag1.Extorno,
                           p_c_msgerr);
          contador := contador + 1;
        End loop;
      End if;
    End loop;
  
  end; --ejecutarRptDetalleServ

end PQ_REPORTE_TARJETAS;
/

