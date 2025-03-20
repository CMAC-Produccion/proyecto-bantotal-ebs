create or replace procedure SP_AH_TCPREFERENCIAL_SOFI(lc_usuario in varchar2,
                                                      ld_fecini  in date,
                                                      ld_fecfin  in date) is
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_TCPREFERENCIAL_SOFI
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 23/09/2016 3:40:10 p. m.
  -- Autor de Creación          : SMARQUEZ
  -- Uso                        : Reporte de tasas preferenciasles Tesoreria
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- ---***
  -- Fecha de Modificación      : 2024.09.17
  -- Modificado                 : SMARQUEZ - Optimización de reporte tamaño de nombre

  -- Fecha de Modificación      : 2024.10.02
  -- Modificado                 : CVILLON  - Incluir TRX Bacth (98/530, 98/531)

  -- Fecha de Modificación      : 2024.10.23
  -- Modificado                 : CVILLON  - Banco de Ingreso y Banco de Salida

  -- Fecha de Modificación      : 2024.11.07
  -- Modificado                 : CVILLON  - Entidad de Crédito y Débito

  -- ***************************************************************************************

  CURSOR DHISTORICO IS
    select a.hfcont fecha,
           b.hhora  hora,
           b.husing operSofi,
           ---***
           decode(a.htran,
                  131,
                  'COMPRA',
                  531,
                  'COMPRA',
                  130,
                  'VENTA',
                  530,
                  'VENTA',
                  '-') Tran,
           ---***       
           'Dolares' moneda1,
           c.hmda mda,
           c.hcimp1 importe, -- decode(c.hctcbi,0,0,(c.hcimp1 / c.hctcbi)) importe,                
           c.hctcbi Preferencial,
           (select exarbb
              from fsh010
             where pgcod = 1
               and hcmod = a.hcmod
               and htran = a.htran
               and hfcont = a.hfcont
               and hnrel = a.hnrel
               and hsucor = a.hsucor
               and excod = 3) pizarra,
           CASE
             WHEN a.hcmod = 93 THEN
             --COALESCE(a.exusau, 'MNOLE')
              'MNOLE'
             WHEN a.hcmod = 98 THEN
             --COALESCE(b.husing, 'MNOLE')
              'MNOLE'
             ELSE
              '-'
           END UAUTO,
           'Tesorería' Autoriza,
           (select trim(txtord)
              from fsx016
             where pgcod = a.pgcod
               and hcmod = a.hcmod
               and hsucor = a.hsucor
               and htran = a.htran
               and hnrel = a.hnrel
               and hfcon = a.hfcont
               and txcod = 6) as dni,
           (select substr(txtord, 1, 60)
              from fsx016
             where pgcod = a.pgcod
               and hcmod = a.hcmod
               and hsucor = a.hsucor
               and htran = a.htran
               and hnrel = a.hnrel
               and hfcon = a.hfcont
               and txcod = 5) as nombre,
           (select d.penom
              from fsr008 r, fsd001 d
             where r.pgcod = 1
               and r.ctnro = c.hcta
               and r.ttcod = 1
               and r.cttfir = 'T'
               and d.pepais = r.pepais
               and d.petdoc = r.petdoc
               and d.pendoc = r.pendoc) Fintech,
           ---***
           (SELECT HCTA
              FROM FSH016
             WHERE PGCOD = b.pgcod
               AND HSUCOR = b.hsucor
               AND HCMOD = b.hcmod
               AND HTRAN = b.htran
               AND HNREL = b.hnrel
               AND HFCON = b.hfcon
               AND HCORD = 10) CTAORD10,
           ---***
           (SELECT HCTA
              FROM FSH016
             WHERE PGCOD = b.pgcod
               AND HSUCOR = b.hsucor
               AND HCMOD = b.hcmod
               AND HTRAN = b.htran
               AND HNREL = b.hnrel
               AND HFCON = b.hfcon
               AND HCORD = 35) CTAORD35,
           ---***
           ---***
           b.hcmod XMOD,
           b.htran XTRAN,
           b.hnrel XREL
    ---***
      from fsh010 a, fsh015 b, fsh016 c
     where a.pgcod = 1
          ---***
       AND ((a.hcmod = 93 AND a.htran in (131, 130)) OR
           (a.hcmod = 98 AND a.htran in (531, 530)))
          ---***
       and a.hfcont between ld_fecini and ld_fecfin --'30/06/2016'
       and a.HCSUBO = 1
       and a.EXCOD = 49
       and a.exstat = 'S' --colocarlo para despues
       and b.pgcod = a.pgcod
       and b.hcmod = a.hcmod
       and b.hsucor = a.hsucor
       and b.htran = a.htran
       and b.hnrel = a.hnrel
       and b.hfcon = a.hfcont
       and b.hccorr = 0
       and c.pgcod = b.pgcod
       and c.hsucor = b.hsucor
       and c.hcmod = b.hcmod
       and c.htran = b.htran
       and c.hnrel = b.hnrel
       and c.hfcon = b.hfcon
       and c.hcord = a.hcord
       and c.hcsubo = 1
       and c.hmodul = 93
       and c.hctcbi > 0
    union
    select b.hfcon  fecha,
           b.hhora  hora,
           b.husing operSofi,
           ---***
           decode(b.htran,
                  131,
                  'COMPRA',
                  531,
                  'COMPRA',
                  130,
                  'VENTA',
                  530,
                  'VENTA',
                  '-') Tran,
           ---***
           'Dolares' moneda1,
           c.hmda mda,
           c.hcimp1 importe, -- decode(c.hctcbi,0,0,(c.hcimp1 / c.hctcbi)) importe,                
           c.hctcbi Preferencial,
           (select exarbb
              from fsh010
             where pgcod = 1
               and hcmod = b.hcmod
               and htran = b.htran
               and hfcont = b.hfcon
               and hnrel = b.hnrel
               and hsucor = b.hsucor
               and excod = 3) pizarra,
           CASE
             WHEN b.hcmod = 93 THEN
              'MNOLE'
             WHEN b.hcmod = 98 THEN
             --COALESCE(b.husing, 'MNOLE')
              'MNOLE'
             ELSE
              '-'
           END UAUTO,
           'Tesorería' Autoriza,
           
           (select trim(txtord)
              from fsx016
             where pgcod = b.pgcod
               and hcmod = b.hcmod
               and hsucor = b.hsucor
               and htran = b.htran
               and hnrel = b.hnrel
               and hfcon = b.hfcon
               and txcod = 6) as dni,
           (select substr(txtord, 1, 60)
              from fsx016
             where pgcod = b.pgcod
               and hcmod = b.hcmod
               and hsucor = b.hsucor
               and htran = b.htran
               and hnrel = b.hnrel
               and hfcon = b.hfcon
               and txcod = 5) as nombre,
           (select d.penom
              from fsr008 r, fsd001 d
             where r.pgcod = 1
               and r.ctnro = c.hcta
               and r.ttcod = 1
               and r.cttfir = 'T'
               and d.pepais = r.pepais
               and d.petdoc = r.petdoc
               and d.pendoc = r.pendoc) Fintech,
           ---***
           (SELECT HCTA
              FROM FSH016
             WHERE PGCOD = b.pgcod
               AND HSUCOR = b.hsucor
               AND HCMOD = b.hcmod
               AND HTRAN = b.htran
               AND HNREL = b.hnrel
               AND HFCON = b.hfcon
               AND HCORD = 10) CTAORD10,
           ---***
           (SELECT HCTA
              FROM FSH016
             WHERE PGCOD = b.pgcod
               AND HSUCOR = b.hsucor
               AND HCMOD = b.hcmod
               AND HTRAN = b.htran
               AND HNREL = b.hnrel
               AND HFCON = b.hfcon
               AND HCORD = 35) CTAORD35,
           ---***
           ---***
           b.hcmod XMOD,
           b.htran XTRAN,
           b.hnrel XREL
    ---***
    --c.* ---PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCONT, HCORD, HCSUBO, EXCOD
      from fsh015 b, fsh016 c
     where b.pgcod = 1
          ---***
       AND ((b.hcmod = 93 AND b.htran in (131, 130)) OR
           (b.hcmod = 98 AND b.htran in (531, 530)))
          ---***
       and b.hfcon between ld_fecini and ld_fecfin
       and b.hccorr = 0
       and c.pgcod = b.pgcod
       and c.hsucor = b.hsucor
       and c.hcmod = b.hcmod
       and c.htran = b.htran
       and c.hnrel = b.hnrel
       and c.hfcon = b.hfcon
       and c.hcord = 10
       and c.hcsubo = 1
       and c.hmodul = 93
       and c.hctcbi > 0
       and not exists (select 1
              from fsh010
             where pgcod = b.pgcod
               and hcmod = b.hcmod
               and hsucor = b.hsucor
               and htran = b.htran
               and hfcont = b.hfcon
               and hnrel = b.hnrel
               and HCSUBO = 1
               and EXCOD = 49
               and exstat = 'S');

  CURSOR DIARIO IS
    select a.hfcont fecha,
           b.ithora hora,
           b.ituing operSofi,
           ---***
           decode(a.htran,
                  131,
                  'COMPRA',
                  531,
                  'COMPRA',
                  130,
                  'VENTA',
                  530,
                  'VENTA',
                  '-') Tran,
           ---***
           c.moneda mda,
           'Dolares' moneda1,
           c.itimp1 importe, ---decode(c.ittcbi,0,0,(c.itimp1 / c.ittcbi)) importe,               
           c.ittcbi Preferencial,
           (select exarbb
              from fsh010
             where pgcod = 1
               and hcmod = a.hcmod
               and htran = a.htran
               and hfcont = a.hfcont
               and hnrel = a.hnrel
               and hsucor = a.hsucor
               and excod = 3) pizarra,
           CASE
             WHEN a.hcmod = 93 THEN
             --COALESCE(a.exusau, 'MNOLE')
              'MNOLE'
             WHEN a.hcmod = 98 THEN
             --COALESCE(b.ituing, 'MNOLE')
              'MNOLE'
             ELSE
              '-'
           END UAUTO,
           'Tesorería' Autoriza,
           (select trim(txtord)
              from fsx016
             where pgcod = a.pgcod
               and hcmod = a.hcmod
               and hsucor = a.hsucor
               and htran = a.htran
               and hnrel = a.hnrel
               and hfcon = a.hfcont
               and txcod = 6) as dni,
           (select substr(txtord, 1, 60)
              from fsx016
             where pgcod = a.pgcod
               and hcmod = a.hcmod
               and hsucor = a.hsucor
               and htran = a.htran
               and hnrel = a.hnrel
               and hfcon = a.hfcont
               and txcod = 5) as nombre,
           (select d.penom
              from fsr008 r, fsd001 d
             where r.pgcod = 1
               and r.ctnro = c.ctnro
               and r.ttcod = 1
               and r.cttfir = 'T'
               and d.pepais = r.pepais
               and d.petdoc = r.petdoc
               and d.pendoc = r.pendoc) Fintech,
           ---***
           (SELECT CTNRO
              FROM FSD016
             WHERE PGCOD = b.pgcod
               AND ITSUC = b.itsuc
               AND ITMOD = b.itmod
               AND ITTRAN = b.ittran
               AND ITNREL = b.itnrel
               AND ITORD = 10) CTAORD10,
           ---***
           (SELECT CTNRO
              FROM FSD016
             WHERE PGCOD = b.pgcod
               AND ITSUC = b.itsuc
               AND ITMOD = b.itmod
               AND ITTRAN = b.ittran
               AND ITNREL = b.itnrel
               AND ITORD = 35) CTAORD35,
           ---***                       
           ---***
           b.itmod  XMOD,
           b.ittran XTRAN,
           b.itnrel XREL
    ---***
      from fsh010 a, fsd015 b, fsd016 c
     where a.pgcod = 1
          ---***
       AND ((a.hcmod = 93 AND a.htran in (131, 130)) OR
           (a.hcmod = 98 AND a.htran in (531, 530)))
          ---***
       and a.hfcont = ld_fecfin --'20/01/2021'
       and a.HCSUBO = 1
       and a.EXCOD = 49
       and a.exstat = 'S'
       and b.pgcod = a.pgcod
       and b.itmod = a.hcmod
       and b.itsuc = a.hsucor
       and b.ittran = a.htran
       and b.itnrel = a.hnrel
       and b.itfcon = a.hfcont
       and b.itcorr = 0
       and b.itcont = 'S'
       and c.pgcod = b.pgcod
       and c.itsuc = b.itsuc
       and c.itmod = b.itmod
       and c.ittran = b.ittran
       and c.itnrel = b.itnrel
       and c.itord = a.hcord
       and c.modulo = 93
       and c.ittcbi > 0
    union
    select b.itfcon fecha,
           b.ithora hora,
           b.ituing operSofi,
           ---***
           decode(b.ittran,
                  131,
                  'COMPRA',
                  531,
                  'COMPRA',
                  130,
                  'VENTA',
                  530,
                  'VENTA',
                  '-') Tran,
           ---***
           c.moneda mda,
           'Dolares' moneda1,
           c.itimp1 importe, ---decode(c.ittcbi,0,0,(c.itimp1 / c.ittcbi)) importe,                
           c.ittcbi Preferencial,
           c.ittcbi pizarra,
           CASE
             WHEN b.itmod = 93 THEN
              'MNOLE'
             WHEN b.itmod = 98 THEN
             --COALESCE(b.ituing, 'MNOLE')
              'MNOLE'
             ELSE
              '-'
           END UAUTO,
           'Tesorería' Autoriza,
           (select trim(txtord)
              from fsx016
             where pgcod = b.pgcod
               and hcmod = b.itmod
               and hsucor = b.itsuc
               and htran = b.ittran
               and hnrel = b.itnrel
               and hfcon = b.itfcon
               and txcod = 6) as dni,
           (select substr(txtord, 1, 60)
              from fsx016
             where pgcod = b.pgcod
               and hcmod = b.itmod
               and hsucor = b.itsuc
               and htran = b.ittran
               and hnrel = b.itnrel
               and hfcon = b.itfcon
               and txcod = 5) as nombre,
           (select d.penom
              from fsr008 r, fsd001 d
             where r.pgcod = 1
               and r.ctnro = c.ctnro
               and r.ttcod = 1
               and r.cttfir = 'T'
               and d.pepais = r.pepais
               and d.petdoc = r.petdoc
               and d.pendoc = r.pendoc) Fintech,
           ---***
           (SELECT CTNRO
              FROM FSD016
             WHERE PGCOD = b.pgcod
               AND ITSUC = b.itsuc
               AND ITMOD = b.itmod
               AND ITTRAN = b.ittran
               AND ITNREL = b.itnrel
               AND ITORD = 10) CTAORD10,
           ---***
           (SELECT CTNRO
              FROM FSD016
             WHERE PGCOD = b.pgcod
               AND ITSUC = b.itsuc
               AND ITMOD = b.itmod
               AND ITTRAN = b.ittran
               AND ITNREL = b.itnrel
               AND ITORD = 35) CTAORD35,
           ---***
           ---***
           b.itmod  XMOD,
           b.ittran XTRAN,
           b.itnrel XREL
    
    ---***
      from fsd015 b, fsd016 c
     where b.pgcod = 1
          ---***
       AND ((b.itmod = 93 AND b.ittran in (131, 130)) OR
           (b.itmod = 98 AND b.ittran in (531, 530)))
          ---***
       and b.itfcon = ld_fecfin
       and b.itcont = 'S'
       and b.itcorr = 0
       and c.pgcod = b.pgcod
       and c.itsuc = b.itsuc
       and c.itmod = b.itmod
       and c.ittran = b.ittran
       and c.itnrel = b.itnrel
       and c.itord = 10
       and c.modulo = 93
       and c.ittcbi > 0
       and not exists (select 1
              from fsh010
             where pgcod = b.pgcod
               and hcmod = b.itmod
               and hsucor = b.itsuc
               and htran = b.ittran
               and hfcont = b.itfcon
               and hnrel = b.itnrel
               and HCSUBO = 1
               and EXCOD = 49
               and exstat = 'S');

  NOMAGE   CHAR(30);
  fechahoy date;
  USUARIO  CHAR(10);
  MontoD   number(17, 2) := 0;
  MontoS   number(17, 2) := 0;

begin
  select pgfape into fechahoy from fst017 where pgcod = 1;

  USUARIO := trim(lc_usuario);

  DELETE JAQZ587 WHERE JAQZ587USU = USUARIO; --- lc_usuario;
  COMMIT;
  for his in DHISTORICO loop
    MontoD := 0;
    MontoS := 0;
    if his.mda = 101 then
      MontoD := his.importe;
      MontoS := his.importe * his.Preferencial;
    else
      MontoS := his.importe;
      MontoD := his.importe / his.Preferencial;
    end if;
  
    INSERT INTO JAQZ587
      (jaqz587cod,
       jaqz587fech,
       jaqz587hora,
       jaqz587dni,
       jaqz587nom,
       jaqz587opsofi,
       jaqz587uteso,
       jaqz587ent,
       jaqz587tipop,
       jaqz587mda,
       jaqz587imps,
       jaqz587impd,
       jaqz587tcp,
       jaqz587tcpre,
       jaqz587au8,
       jaqz587usu,
       JAQZ587OPEMOD,
       JAQZ587OPETRA,
       JAQZ587OPEREL,
       JAQZ587OPETRX,
       JAQZ587CTAO10,
       JAQZ587CTAO35)
    VALUES
      (SQ_AH_JAQZ587.NEXTVAL,
       his.FECHA,
       his.hora,
       his.dni,
       his.nombre,
       his.opersofi,
       his.UAUTO,
       his.fintech,
       his.TRAN,
       his.MONEDA1,
       MontoS,
       MontoD,
       his.PIZARRA,
       his.PREFERENCIAL,
       his.AUTORIZA,
       lc_usuario,
       his.XMOD,
       his.XTRAN,
       his.XREL,
       to_char(his.XMOD) || '/' || to_char(his.XTRAN),
       his.CTAORD10,
       his.CTAORD35);
  end loop;
  commit;
  if fechahoy = ld_fecfin then
    FOR DIA IN DIARIO LOOP
      MontoD := 0;
      MontoS := 0;
      if dia.mda = 101 then
        MontoD := dia.importe;
        MontoS := dia.importe * dia.Preferencial;
      else
        MontoS := dia.importe;
        MontoD := dia.importe / dia.Preferencial;
      end if;
      INSERT INTO JAQZ587
        (jaqz587cod,
         jaqz587fech,
         jaqz587hora,
         jaqz587dni,
         jaqz587nom,
         jaqz587opsofi,
         jaqz587uteso,
         jaqz587ent,
         jaqz587tipop,
         jaqz587mda,
         jaqz587imps,
         jaqz587impd,
         jaqz587tcp,
         jaqz587tcpre,
         jaqz587au8,
         jaqz587usu,
         JAQZ587OPEMOD,
         JAQZ587OPETRA,
         JAQZ587OPEREL,
         JAQZ587OPETRX,
         JAQZ587CTAO10,
         JAQZ587CTAO35)
      VALUES
        (SQ_AH_JAQZ587.NEXTVAL,
         dia.FECHA,
         dia.hora,
         dia.dni,
         dia.nombre,
         dia.opersofi,
         dia.UAUTO,
         dia.fintech,
         dia.TRAN,
         dia.MONEDA1,
         MontoS,
         MontoD,
         dia.PIZARRA,
         dia.PREFERENCIAL,
         dia.AUTORIZA,
         lc_usuario,
         dia.XMOD,
         dia.XTRAN,
         dia.XREL,
         to_char(dia.XMOD) || '/' || to_char(dia.XTRAN),
         dia.CTAORD10,
         dia.CTAORD35);
    
    END LOOP;
    COMMIT;
  end if;

end SP_AH_TCPREFERENCIAL_SOFI;
/

