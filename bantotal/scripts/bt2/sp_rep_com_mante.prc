create or replace procedure SP_REP_COM_MANTE(PD_FECPRO  date,
                                             PN_SUCUR   number,
                                             PN_REGION  number,
                                             PC_USUARIO varchar2) is

  type tp_USUARIO IS TABLE OF jaql063.jaql63ch01%type INDEX BY BINARY_INTEGER;
  type tp_IDE IS TABLE OF jaql063.jaql63nu01%type INDEX BY BINARY_INTEGER;
  type tp_REGION IS TABLE OF jaql063.jaql63ch01%type INDEX BY BINARY_INTEGER;
  type tp_SUCURS IS TABLE OF jaql063.jaql63nu01%type INDEX BY BINARY_INTEGER;
  type tp_CUENTA IS TABLE OF jaql063.jaql63ch01%type INDEX BY BINARY_INTEGER;
  type tp_PRODUCTO IS TABLE OF jaql063.jaql63ch01%type INDEX BY BINARY_INTEGER;
  type tp_MONEDA IS TABLE OF jaql063.jaql63nu01%type INDEX BY BINARY_INTEGER;
  type tp_CLIENTE IS TABLE OF jaql063.jaql63ch01%type INDEX BY BINARY_INTEGER;
  type tp_COMISION IS TABLE OF jaql063.jaql63de01%type INDEX BY BINARY_INTEGER;
  type tp_MTO_COBRADO IS TABLE OF jaql063.jaql63de01%type INDEX BY BINARY_INTEGER;
  type tp_MTO_PENDIENTE IS TABLE OF jaql063.jaql63de01%type INDEX BY BINARY_INTEGER;
  type tp_SALDO_CIERRE IS TABLE OF jaql063.jaql63de01%type INDEX BY BINARY_INTEGER;
  type tp_SALDO_ACTUAL IS TABLE OF jaql063.jaql63de01%type INDEX BY BINARY_INTEGER;
  type tp_ESTADO IS TABLE OF jaql063.jaql63nu01%type INDEX BY BINARY_INTEGER;
  type tp_FECHA_CARGO IS TABLE OF jaql063.jaql63da01%type INDEX BY BINARY_INTEGER;
  type tp_FECHA_APERT IS TABLE OF jaql063.jaql63da01%type INDEX BY BINARY_INTEGER;
  type tp_FECHA_CA IS TABLE OF jaql063.jaql63da01%type INDEX BY BINARY_INTEGER;
  type tp_SUBOPE IS TABLE OF jaql063.jaql63nu01%type INDEX BY BINARY_INTEGER;
  type tp_FECHA1 IS TABLE OF jaql063.jaql63da01%type INDEX BY BINARY_INTEGER;
  type tp_FECHA2 IS TABLE OF jaql063.jaql63da01%type INDEX BY BINARY_INTEGER;

  USUARIO       tp_USUARIO;
  IDE           tp_IDE;
  REGION        tp_REGION;
  SUCURS        tp_SUCURS;
  CUENTA        tp_CUENTA;
  PRODUCTO      tp_PRODUCTO;
  MONEDA        tp_MONEDA;
  CLIENTE       tp_CLIENTE;
  COMISION      tp_COMISION;
  MTO_COBRADO   tp_MTO_COBRADO;
  MTO_PENDIENTE tp_MTO_PENDIENTE;
  SALDO_CIERRE  tp_SALDO_CIERRE;
  SALDO_ACTUAL  tp_SALDO_ACTUAL;
  ESTADO        tp_ESTADO;
  FECHA_CARGO   tp_FECHA_CARGO;
  FECHA_APERT   tp_FECHA_APERT;
  FECHA_CA      tp_FECHA_CA;
  SUBOPE        tp_SUBOPE;
  FECHA1        tp_FECHA1;
  FECHA2        tp_FECHA2;

  v_usuario jaql063.jaql63ch01%type := PC_USUARIO;

  cursor c_datos_a is
    select pc_usuario usuario,
           16 ide,
           upper(g.regnom) region,
           --d.scnom agencia,
           d.sucurs,
           /*lpad(b.ctnro, 9, '0') || lpad(c.scmod, 3, '0') ||
           lpad(b.moneda, 3, '0') || lpad(b.itsubo, 2, '0') ||
           lpad(c.sctope, 3, '0')*/
           to_char(c.sccta) cuenta,
           --h.tonom 
           to_char(h.totope) producto,
           --k.mosign moneda,
           k.moneda,
           j.penom    cliente,
           b.n_monto7 comision,
           0          mto_cobrado,
           0          mto_pendiente,
           m.sbsdo    saldo_cierre,
           c.scsdo    saldo_actual,
           --l.cenom estado,
           l.cecod estado,
           b.d_Fecha1 fecha_cargo,
           c.scfval fecha_apert,
           c.scfulm fecha_ca, --decode(c.scstat, 99, c.scfulm, null) fecha_ca,
           c.scsbop subope,
           trunc(sysdate) fecha1,
           trunc(sysdate) fecha2
      from crdtcap b,
           fsd011  c,
           fst001  d,
           fst811  e,
           fst810  g,
           fst004  h,
           fsr008  i,
           fsd001  j,
           fst005  k,
           fst026  l,
           fsh021  m
     where c.pgcod = b.n_monto1
       and c.scsuc = b.n_monto3
       and c.scmda = b.n_monto4
       and c.scpap = b.n_monto6
       and c.sccta = b.n_monto2
       and c.scsbop = b.n_monto5
       and d.pgcod = b.n_monto1
       and d.sucurs = b.n_monto3
       and e.pgcod = b.n_monto1
       and e.oficod = b.n_monto3
       and g.pgcod = e.pgcod
       and g.regcod = e.regcod
       and h.modulo = c.scmod
       and h.totope = c.sctope
       and i.pgcod = b.n_monto1
       and i.ctnro = b.n_monto2
       and j.pepais = i.pepais
       and j.petdoc = i.petdoc
       and j.pendoc = i.pendoc
       and k.moneda = b.n_monto4
       and l.cecod = c.scstat
       and c.scoper = 0
       and c.scmod = 21
       and e.regcod < 100
       and e.ofisuc = 'S'
          --
       and m.sbcod = c.pgcod
       and m.sbsuc = c.scsuc
       and m.sbmda = c.scmda
       and m.sbpap = c.scpap
       and m.sbcta = c.sccta
       and m.sboper = c.scoper
       and m.sbsbop = c.scsbop
       and m.sbtope = c.sctope
       and m.sbmod = c.scmod
       and m.sbfech = b.d_fecha1
       and i.ttcod = 1
       and i.cttfir = 'T';

  cursor c_datos_b(usu char) is
    select jaql63ch01 usuario,
           jaql63nu05 ide,
           jaql63ch02 region,
           jaql63nu01 sucurs,
           jaql63ch03 cuenta,
           jaql63ch04 producto,
           jaql63nu02 moneda,
           jaql63ch05 cliente,
           jaql63de01 comision,
           jaql63de02 mto_cobrado,
           jaql63de03 mto_pendiente,
           jaql63de04 saldo_cierre,
           jaql63de05 saldo_actual,
           jaql63nu03 estado,
           jaql63da01 fecha_cargo,
           jaql63da02 fecha_apert,
           jaql63da03 fecha_ca,
           jaql63nu04 subope
      from rep_com_man
     where jaql63ch01 = usu
       and jaql63nu05 = 16;

  lc_error  varchar2(400);
  comi      number;
  prod      number;
  pd_fecfin date;

  cursor c_datos_c is
    select jaql63ch01 usuario,
           jaql63nu05 ide,
           jaql63ch02 region,
           jaql63nu01 sucurs,
           jaql63ch03 cuenta,
           jaql63ch04 producto,
           jaql63nu02 moneda,
           jaql63ch05 cliente,
           jaql63de01 comision,
           jaql63de02 mto_cobrado,
           jaql63de03 mto_pendiente,
           jaql63de04 saldo_cierre,
           jaql63de05 saldo_actual,
           jaql63nu03 estado,
           jaql63da01 fecha_cargo,
           jaql63da02 fecha_apert,
           jaql63da03 fecha_ca,
           jaql63nu04 subope,
           trunc(sysdate),
           trunc(sysdate)
      from rep_com_man
     where jaql63ch01 = v_usuario
       and jaql63nu05 = 16;

begin

  execute immediate 'drop index idx_rep_com_man';
  execute immediate 'truncate table rep_com_man';
  execute immediate 'truncate table crdtcap';

  begin
  
    insert into crdtcap
      (n_monto1,
       d_fecha1,
       n_monto2,
       n_monto3,
       n_monto4,
       n_monto5,
       n_monto6,
       n_monto7)
    
      select a.pgcod,
             a.itfcon,
             b.ctnro,
             b.itsucd,
             b.moneda,
             b.itsubo,
             b.papel,
             b.itimp1
        from fsd015 a, fsd016 b, fst811 e
       where a.pgcod = b.pgcod
         and a.itsuc = b.itsuc
         and a.itmod = b.itmod
         and a.ittran = b.ittran
         and a.itnrel = b.itnrel
         and a.itcorr <> 99
         and a.itcont = 'S'
         and a.itmod = 99
         and a.itfcon = pd_Fecpro
         and a.ittran = 996
         and b.modulo = 406
         and e.pgcod = b.pgcod
         and e.oficod = b.itsucd
         and e.regcod < 100
         and e.ofisuc = 'S'
         and e.regcod = decode(pn_region, 0, e.regcod, pn_region)
         and b.itsucd = decode(pn_sucur, 0, b.itsucd, pn_sucur)
      
      union
      
      select a.pgcod,
             a.hfcon,
             b.hcta,
             b.hsucur,
             b.hmda,
             b.hsubop,
             b.hpap,
             b.hcimp1
        from fsh015 a, fsh016 b, fst811 e
       where a.pgcod = b.pgcod
         and a.hsucor = b.hsucor
         and a.hcmod = b.hcmod
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hccorr <> 99
         and a.hcmod = 99
         and a.hfcon = pd_Fecpro
         and a.htran = 996
         and b.hmodul = 406
         and e.pgcod = b.pgcod
         and e.oficod = b.hsucur
         and e.regcod < 100
         and e.ofisuc = 'S'
         and e.regcod = decode(pn_region, 0, e.regcod, pn_region)
         and b.hsucur = decode(pn_sucur, 0, b.hsucur, pn_sucur);
  end;

  OPEN c_datos_a;
  LOOP
    FETCH c_datos_a BULK COLLECT
      INTO USUARIO,
           IDE,
           REGION,
           SUCURS,
           CUENTA,
           PRODUCTO,
           MONEDA,
           CLIENTE,
           COMISION,
           MTO_COBRADO,
           MTO_PENDIENTE,
           SALDO_CIERRE,
           SALDO_ACTUAL,
           ESTADO,
           FECHA_CARGO,
           FECHA_APERT,
           FECHA_CA,
           SUBOPE,
           FECHA1,
           FECHA2 LIMIT 10000;
    EXIT WHEN USUARIO.count = 0;
    begin
      FORALL z IN 1 .. USUARIO.COUNT
        INSERT /*+ append */
        INTO rep_com_man
          (jaql63ch01,
           jaql63nu05,
           jaql63ch02,
           jaql63nu01,
           jaql63ch03,
           jaql63ch04,
           jaql63nu02,
           jaql63ch05,
           jaql63de01,
           jaql63de02,
           jaql63de03,
           jaql63de04,
           jaql63de05,
           jaql63nu03,
           jaql63da01,
           jaql63da02,
           jaql63da03,
           jaql63nu04)
        values
          (USUARIO(z),
           IDE(z),
           REGION(z),
           SUCURS(z),
           CUENTA(z),
           PRODUCTO(z),
           MONEDA(z),
           CLIENTE(z),
           COMISION(z),
           MTO_COBRADO(z),
           MTO_PENDIENTE(z),
           SALDO_CIERRE(z),
           SALDO_ACTUAL(z),
           ESTADO(z),
           FECHA_CARGO(z),
           FECHA_APERT(z),
           FECHA_CA(z),
           SUBOPE(z));
    
      commit;
    exception
      when others then
        lc_error := sqlerrm;
        dbms_output.put_line(lc_error);
      
        commit;
    end;
  END LOOP;
  CLOSE c_datos_a;

  execute immediate 'truncate table crdtcap_1';
  execute immediate 'drop index IDX_CRDTCAP';

  begin
  
    pd_fecfin := last_day(pd_fecpro + 1) - 1;
  
    insert into crdtcap_1
      (n_monto1, n_monto2, n_monto3, n_monto4, n_monto5)
      select b1.ctnro, b1.ittope, b1.itsubo, b1.moneda, b1.itimp1
        from fsd015 a1, fsd016 b1
       where a1.pgcod = b1.pgcod
         and a1.itsuc = b1.itsuc
         and a1.itmod = b1.itmod
         and a1.ittran = b1.ittran
         and a1.itnrel = b1.itnrel
         and b1.pgcod = 1
         and a1.itcorr <> 99
         and a1.itcont = 'S'
         and a1.itmod = 97
         and a1.ittran between 50 and 99
         and b1.modulo = 21
         and a1.itfcon between pd_fecpro and pd_fecfin
      
      union all
      
      select b1.hcta, b1.htoper, b1.hsubop, b1.hmda, b1.hcimp1
        from fsh015 a1, fsh016 b1
       where a1.pgcod = b1.pgcod
         and a1.hsucor = b1.hsucor
         and a1.hcmod = b1.hcmod
         and a1.htran = b1.htran
         and a1.hnrel = b1.hnrel
         and b1.pgcod = 1
         and a1.hccorr <> 99
         and a1.hcmod = 97
         and a1.htran between 50 and 99 -- 11 19
         and b1.hmodul = 21
         and a1.hfcon between pd_fecpro and pd_fecfin;
  
    commit;
  
  end;

  execute immediate 'CREATE INDEX idx_crdtcap ON crdtcap_1 (n_monto1,n_monto2,n_monto3,n_monto4)';
  execute immediate 'create index idx_rep_com_man on rep_com_man (JAQL63CH01, JAQL63NU05, JAQL63NU01, JAQL63CH03, JAQL63CH04, JAQL63NU02, JAQL63NU04, JAQL63DA01)';

  for i in c_datos_b(v_usuario) loop
  
    prod := to_number(i.PRODUCTO);
  
    select nvl(sum(n_monto5), 0)
      into comi
      from crdtcap_1
     where n_monto1 = i.CUENTA
       and n_monto2 = prod
       and n_monto3 = i.SUBOPE
       and n_monto4 = i.MONEDA;
  
    begin
      update rep_com_man --jaql063
         set jaql63de02 = comi --, jaql63de03 = 888
       where jaql63ch01 = i.USUARIO
         and jaql63nu05 = i.IDE
         and jaql63nu01 = i.SUCURS
         and jaql63ch03 = i.CUENTA
         and jaql63ch04 = i.PRODUCTO
         and jaql63nu02 = i.MONEDA
         and jaql63nu04 = i.SUBOPE
         and jaql63da01 = i.FECHA_CARGO;
      commit;
    exception
      when others then
        lc_error := sqlerrm;
        dbms_output.put_line(lc_error);
        commit;
    end;
  END LOOP;

  begin
  
    delete from jaql063
     where jaql63ch01 = v_usuario
       and jaql63nu05 = 16;
  
    OPEN c_datos_c;
    LOOP
      FETCH c_datos_c BULK COLLECT
        INTO USUARIO,
             IDE,
             REGION,
             SUCURS,
             CUENTA,
             PRODUCTO,
             MONEDA,
             CLIENTE,
             COMISION,
             MTO_COBRADO,
             MTO_PENDIENTE,
             SALDO_CIERRE,
             SALDO_ACTUAL,
             ESTADO,
             FECHA_CARGO,
             FECHA_APERT,
             FECHA_CA,
             SUBOPE,
             FECHA1,
             FECHA2 LIMIT 10000;
      EXIT WHEN USUARIO.count = 0;
      begin
        FORALL z IN 1 .. USUARIO.COUNT
          INSERT /*+ append */
          INTO jaql063
            (jaql63ch01,
             jaql63nu05,
             jaql63ch02,
             jaql63nu01,
             jaql63ch03,
             jaql63ch04,
             jaql63nu02,
             jaql63ch05,
             jaql63de01,
             jaql63de02,
             jaql63de03,
             jaql63de04,
             jaql63de05,
             jaql63nu03,
             jaql63da01,
             jaql63da02,
             jaql63da03,
             jaql63nu04,
             jaql63da04,
             jaql63da05)
          values
            (USUARIO(z),
             IDE(z),
             REGION(z),
             SUCURS(z),
             CUENTA(z),
             PRODUCTO(z),
             MONEDA(z),
             CLIENTE(z),
             COMISION(z),
             MTO_COBRADO(z),
             MTO_PENDIENTE(z),
             SALDO_CIERRE(z),
             SALDO_ACTUAL(z),
             ESTADO(z),
             FECHA_CARGO(z),
             FECHA_APERT(z),
             FECHA_CA(z),
             SUBOPE(z),
             FECHA1(z),
             FECHA2(z));
        commit;
      exception
        when others then
          lc_error := sqlerrm;
          dbms_output.put_line(lc_error);
          commit;
      end;
    END LOOP;
    CLOSE c_datos_c;
  end;

end SP_REP_COM_MANTE;
/

