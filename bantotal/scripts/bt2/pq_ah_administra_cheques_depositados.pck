create or replace package PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS is
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES DE ATENCIO
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.01.31
  -- Autor de Creación          : CVILLON
  -- Uso                        : MODULO DE ADMINISTRACION DE CHEQUES DEPOSITADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.01.31
  -- Modificado                 : CVILLON
  -- Descripción                : PCK Inicial
  -- ***************************************************************************************

  procedure SP_AH_BUSCAR_CHEQUES_DEPOSITADOS(p_usuario in varchar2,
                                             p_fecini  in date,
                                             p_fecfin  in date,
                                             p_banco   in number,
                                             p_sucur   in number,
                                             p_moneda  in number,
                                             p_errcod  out varchar,
                                             p_errmsg  out varchar);

end PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS;
/

create or replace package body PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS is
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : CANALES DE ATENCIO
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2025.01.31
  -- Autor de Creación          : CVILLON
  -- Uso                        : MODULO DE ADMINISTRACION DE CHEQUES DEPOSITADOS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.01.31
  -- Modificado                 : CVILLON
  -- Descripción                : PCK Inicial
  -- ***************************************************************************************

  procedure SP_AH_BUSCAR_CHEQUES_DEPOSITADOS(p_usuario in varchar2,
                                             p_fecini  in date,
                                             p_fecfin  in date,
                                             p_banco   in number,
                                             p_sucur   in number,
                                             p_moneda  in number,
                                             p_errcod  out varchar,
                                             p_errmsg  out varchar) is
  
  BEGIN
  
    ---***
    p_errcod := '000';
    p_errmsg := NULL;
    ---***
    ---***
    DELETE FROM AQPD321A
     WHERE AQPD321ACODIGO = 15
       AND AQPD321ACREUSU = TRIM(p_usuario);
    COMMIT;
    ---***
  
    ---***
    INSERT INTO AQPD321A
      (AQPD321ACREUSU,
       AQPD321ACODIGO,
       AQPD321AFECREG,
       AQPD321AHORREG,
       AQPD321ABANCOD,
       AQPD321ABANAGE,
       AQPD321ACTACHE,
       AQPD321ACHEQUE,
       AQPD321ACHEMDA,
       AQPD321ACHEIMP,
       AQPD321ACTACLI,
       AQPD321ACLINOM,
       AQPD321ACTAMDA,
       AQPD321AAGECOD,
       AQPD321AAGENOM,
       AQPD321AUSUREG,
       AQPD321ABANNOM,
       AQPD321ACHEMDD,
       AQPD321ACTAMDD,
       AQPD321ACRETIM)
      SELECT p_usuario,
             15         codigo,
             d.hfcon    fecha,
             d.hhora    hora,
             c.chbco    banco,
             c.chsbco   agencia,
             c.chctache ctache,
             c.chcheq   cheque,
             c.chmda,
             e.hcimp1   importe,
             c.chcta    cuenta_ben,
             p.penom    beneficiario,
             g.i2mda    mdaben,
             a.sucurs,
             a.scnom    agereg,
             d.husing   usuing,
             b.banom,
             m1.mosign,
             m2.mosign,
             SYSDATE
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
         and c.e111fc between p_fecini and p_fecfin
         and c.e111co = 'S'
         and c.chbco = decode(p_banco, -1, c.chbco, p_banco)
         and c.chsuc = decode(p_sucur, -1, c.chsuc, p_sucur)
         and c.chmda = decode(p_moneda, -1, c.chmda, p_moneda)
         and g.r111co = 'S'
      union
      select p_usuario,
             15         codigo,
             d.itfcon   fecha,
             d.ithora   hora,
             c.chbco    banco,
             c.chsbco   agencia,
             c.chctache ctache,
             c.chcheq   cheque,
             c.chmda,
             e.itimp1   importe,
             c.chcta    cuenta_ben,
             p.penom    beneficiario,
             g.i2mda    mdaben,
             a.sucurs,
             a.scnom    agereg,
             d.ituing   usuing,
             b.banom,
             m1.mosign,
             m2.mosign,
             SYSDATE
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
         and c.e111fc between p_fecini and p_fecfin
         and c.e111co = 'S'
         and c.chbco = decode(p_banco, -1, c.chbco, p_banco)
         and c.chsuc = decode(p_sucur, -1, c.chsuc, p_sucur)
         and c.chmda = decode(p_moneda, -1, c.chmda, p_moneda)
         and g.r111co = 'S';
  
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      p_errcod := '001';
      p_errmsg := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  
  end SP_AH_BUSCAR_CHEQUES_DEPOSITADOS;

end PQ_AH_ADMINISTRA_CHEQUES_DEPOSITADOS;
/

