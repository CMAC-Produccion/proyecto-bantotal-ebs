create or replace procedure SP_Reporte_Cheques(usuario varchar2,
                                               fecini  date,
                                               fecfin  date,
                                               vbanco  number,
                                               vsucur  number,
                                               vmone   number) is

  vjaql63ch01 jaql063.jaql63ch01%type;

begin

  vjaql63ch01 := usuario;

  delete from jaql063
   where jaql63nu05 = 15
     and jaql63ch01 = vjaql63ch01;

  commit;

  insert into jaql063
    (jaql63ch01,
     jaql63nu05,
     jaql63da01,
     jaql63ch02,
     jaql63nu01,
     jaql63nu02,
     jaql63de01,
     jaql63de02,
     jaql63nu03,
     jaql63de03,
     jaql63nu04,
     jaql63ch03,
     jaql63de04,
     jaql63ch04,
     jaql63ch05,
     jaql63de05,
     jaql63da02,
     jaql63da03,
     jaql63da04,
     jaql63da05)
    select usuario,
           15 codigo,
           d.hfcon fecha,
           d.hhora hora,
           c.chbco banco, --b.banom banco,
           c.chsbco agencia,
           c.chctache ctache, --lpad(c.chctache, 10, '0') cuenta,
           c.chcheq cheque, --lpad(c.chcheq, 8, '0') cheque,
           c.chmda, --m1.mosign,
           e.hcimp1 importe,
           c.chcta cuenta_ben,
           p.penom beneficiario,
           g.i2mda mdaben, --m2.mosign moneda_ben,
           a.scnom agereg,
           d.husing usuing,
           0 d1,
           trunc(sysdate) f1,
           trunc(sysdate) f2,
           trunc(sysdate) f3,
           trunc(sysdate) f4
      from fse111 c,
           fsh015 d,
           fsh016 e,
           fst002 b,
           fst005 m1,
           fst001 a,
           fsr008 r,
           fsd001 p,
           fsr111 g,
           fst005 m2
     where d.pgcod = e.pgcod
       and d.hcmod = e.hcmod
       and d.hsucor = e.hsucor
       and d.htran = e.htran
       and d.hnrel = e.hnrel
       and d.hfcon = e.hfcon
       and c.e111cd = d.pgcod
       and c.e111mo = d.hcmod
       and c.e111su = d.hsucor
       and c.e111tr = d.htran
       and c.e111re = d.hnrel
       and c.e111fc = d.hfcon
       and c.e111or = e.hcord
       and c.e111sb = e.hcsubo
       and c.chbco = b.banco
       and m1.moneda = c.chmda
       and a.pgcod = d.pgcod
       and a.sucurs = d.hsucor
       and r.pgcod = d.pgcod
       and r.ctnro = e.hcta
       and r.ttcod = 1
       and r.cttfir = 'T'
       and p.pepais = r.pepais
       and p.petdoc = r.petdoc
       and p.pendoc = r.pendoc
       and c.e111cd = g.r111cd
       and c.e111mo = g.r111mo
       and c.e111su = g.r111su
       and c.e111tr = g.r111tr
       and c.e111re = g.r111re
       and c.e111fc = g.r111fc
       and c.e111or = g.r111or
       and c.e111sb = g.r111sb
       and m2.moneda = g.i2mda
       and c.e111fc between fecini and fecfin
       and c.e111co = 'S'
       and c.chbco = decode(vbanco, -1, c.chbco, vbanco)
       and c.chsuc = decode(vsucur, -1, c.chsuc, vsucur)
       and c.chmda = decode(vmone, -1, c.chmda, vmone)
       and g.r111co = 'S'
    union
    select usuario,
           15 codigo,
           d.itfcon fecha,
           d.ithora hora,
           c.chbco banco, --b.banom banco,
           c.chsbco agencia,
           c.chctache ctache, --lpad(c.chctache, 10, '0') cuenta,
           c.chcheq cheque, --lpad(c.chcheq, 8, '0') cheque,
           c.chmda, --m1.mosign,
           e.itimp1 importe,
           c.chcta cuenta_ben,
           p.penom beneficiario,
           g.i2mda mdaben, --m2.mosign moneda_ben,
           a.scnom agereg,
           d.ituing usuing,
           0 d1,
           trunc(sysdate) f1,
           trunc(sysdate) f2,
           trunc(sysdate) f3,
           trunc(sysdate) f4
      from fse111 c,
           fsd015 d,
           fsd016 e,
           fst002 b,
           fst005 m1,
           fst001 a,
           fsr008 r,
           fsd001 p,
           fsr111 g,
           fst005 m2
     where d.pgcod = e.pgcod
       and d.itmod = e.itmod
       and d.itsuc = e.itsuc
       and d.ittran = e.ittran
       and d.itnrel = e.itnrel
       and c.e111cd = d.pgcod
       and c.e111mo = d.itmod
       and c.e111su = d.itsuc
       and c.e111tr = d.ittran
       and c.e111re = d.itnrel
       and c.e111fc = d.itfcon
       and c.e111or = e.itord
       and c.e111sb = e.itsbor
       and c.chbco = b.banco
       and m1.moneda = c.chmda
       and a.pgcod = d.pgcod
       and a.sucurs = d.itsuc
       and r.pgcod = d.pgcod
       and r.ctnro = e.ctnro
       and r.ttcod = 1
       and r.cttfir = 'T'
       and p.pepais = r.pepais
       and p.petdoc = r.petdoc
       and p.pendoc = r.pendoc
       and c.e111cd = g.r111cd
       and c.e111mo = g.r111mo
       and c.e111su = g.r111su
       and c.e111tr = g.r111tr
       and c.e111re = g.r111re
       and c.e111fc = g.r111fc
       and c.e111or = g.r111or
       and c.e111sb = g.r111sb
       and m2.moneda = g.i2mda
       and c.e111fc between fecini and fecfin
       and c.e111co = 'S'
       and c.chbco = decode(vbanco, -1, c.chbco, vbanco)
       and c.chsuc = decode(vsucur, -1, c.chsuc, vsucur)
       and c.chmda = decode(vmone, -1, c.chmda, vmone)
       and g.r111co = 'S';
       
       commit;

end SP_Reporte_Cheques;
/

