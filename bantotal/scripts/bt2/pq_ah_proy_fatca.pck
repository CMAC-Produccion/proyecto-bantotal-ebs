create or replace package PQ_AH_PROY_FATCA is
---------------------------------------------------------
  -- Author  : SMARQUEZ
  -- Created : 16/06/2016 10:41:02
  -- Purpose : Proyecto US person  
  -- Public type declarations
-----------------------------------------------------  
  -- Public function and procedure declarations
  procedure Registro_Datos;      
  procedure actualiza_estado;
  
end PQ_AH_PROY_FATCA;
/

create or replace package body PQ_AH_PROY_FATCA is

  -- Private variable declarations

procedure Registro_Datos is
  Cursor paises is 
    select tp1nro1, tp1desc
      from fst198
     where tp1cod = 1
       and tp1cod1 =10849
       and tp1corr1 =15
       and tp1corr2 = 1;
  
  Cursor datos (pais in number) is
    select a.pfpais pais,
           a.pftdoc tipdoc,
           a.pfndoc nrodoc,
           TRIM(a.pfnom1) || ' ' || TRIM(a.pfnom2) || ' ' || TRIM(a.pfape1) || ' ' ||
           TRIM(a.pfape2) cliente,
           ' ' PERJURIDICA,
           a.pfnom1 nom1,
           a.pfnom2 nom2,
           a.pfape1 ape1,
           a.pfape2 ape2,
           0 pais1,
           0 tipo1,
           ' ' documento1,
           ' ' cargo,
           (select trim(tdnom) from fst014 where tdocum = a.pftdoc) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = a.pfpnac) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
           a.pffnac birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = a.pfpais
               and Petdoc = a.pftdoc
               and Pendoc = a.pfndoc
               and Txcod = 0
               and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto
      from fsd002 a, fsr008 b, fsd011 c, sngc13 d
     where a.pfpnac = pais 
       and b.pepais = a.pfpais
       and b.petdoc = a.pftdoc
       and b.pendoc = a.pfndoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = b.pepais
       and d.sngc13tdoc(+) = b.petdoc
       and d.sngc13ndoc(+) = b.pendoc
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       ORDER BY c.scfcon;
       
  cursor datosJ(Pais in number) is
    select a.pjpais pais,
           a.pjtdoc tipdoc,
           a.pjndoc nrodoc,
           a.pjrazs cliente,
           (Select substr((TRIM(pfnom1) || ' ' || TRIM(pfnom2) || ' ' ||TRIM(pfape1) || ' ' || TRIM(pfape2)),1,70)
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) PERJURIDICA,
           (Select pfnom1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom1,
           (Select pfnom2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom2,
           (Select pfape1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE1,
           (Select pfape2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE2,
           z.pfpai1 pais1,
           z.pftdo1 tipo1,
           z.pfndo1 documento1,
           (select trim(vinom) from fst020 where vicod = z.vicod) cargo,
           (select trim(tdnom) from fst014 where tdocum = z.pftdo1) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = z.pfpai1) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
            (Select pffnac            
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1)birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon ,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = z.pfpai1
               and Petdoc = z.pftdo1
               and Pendoc = z.pfndo1
               and Txcod = 0
                and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto
    from FSR003 Z, fsd003 a, fsr008 b, fsd011 c, sngc13 d
     where Z.PFPAI1 = 604
       and z.pftdo1 = 21
       and z.pfndo1 in (select pfndoc 
                          from  fsd002
                         where  pfpnac in ( select tp1nro1 from fst198   where tp1cod = 1    and tp1cod1 =10849     and tp1corr1 =15  and tp1corr2 = 1)
                           and  pfpais =604
                           and  pftdoc = 21 )
       AND a.pjpais = Z.PJPAIS
       AND a.pjtdoc = z.pjtdoc
       and a.pjndoc = z.pjndoc
       and b.pepais = a.pjpais
       and b.petdoc = a.pjtdoc
       and b.pendoc = a.pjndoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = z.pfpai1
       and d.sngc13tdoc(+) = z.pftdo1
       and d.sngc13ndoc(+) = z.pfndo1
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       union
    select a.pjpais pais,
           a.pjtdoc tipdoc,
           a.pjndoc nrodoc,
           a.pjrazs cliente,
           (Select substr((TRIM(pfnom1) || ' ' || TRIM(pfnom2) || ' ' ||TRIM(pfape1) || ' ' || TRIM(pfape2)),1,70)
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) PERJURIDICA,
           (Select pfnom1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom1,
           (Select pfnom2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom2,
           (Select pfape1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE1,
           (Select pfape2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE2,
           z.pfpai1 pais1,
           z.pftdo1 tipo1,
           z.pfndo1 documento1,
           (select trim(vinom) from fst020 where vicod = z.vicod) cargo,
           (select trim(tdnom) from fst014 where tdocum = z.pftdo1) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = z.pfpai1) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
            (Select pffnac            
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1)birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = z.pfpai1
               and Petdoc = z.pftdo1
               and Pendoc = z.pfndo1
               and Txcod = 0
                and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto
      from FSR003 Z, fsd003 a, fsr008 b, fsd011 c, sngc13 d
     where Z.PFPAI1 = pais
       AND a.pjpais = Z.PJPAIS
       AND a.pjtdoc = z.pjtdoc
       and a.pjndoc = z.pjndoc
       and b.pepais = a.pjpais
       and b.petdoc = a.pjtdoc
       and b.pendoc = a.pjndoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = z.pfpai1
       and d.sngc13tdoc(+) = z.pftdo1
       and d.sngc13ndoc(+) = z.pfndo1
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       ORDER BY 22;

  Cursor datosF (pais in number, pfecha in date) is
    select a.pfpais pais,
           a.pftdoc tipdoc,
           a.pfndoc nrodoc,
           TRIM(a.pfnom1) || ' ' || TRIM(a.pfnom2) || ' ' || TRIM(a.pfape1) || ' ' ||
           TRIM(a.pfape2) cliente,
           ' ' PERJURIDICA,
           a.pfnom1 nom1,
           a.pfnom2 nom2,
           a.pfape1 ape1,
           a.pfape2 ape2,
           0 pais1,
           0 tipo1,
           ' ' documento1,
           ' ' cargo,
           (select trim(tdnom) from fst014 where tdocum = a.pftdoc) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = a.pfpnac) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
           a.pffnac birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = a.pfpais
               and Petdoc = a.pftdoc
               and Pendoc = a.pfndoc
               and Txcod = 0
               and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto    
      from fsd002 a, fsd001 a1, fsr008 b, fsd011 c, sngc13 d
     where a.pfpnac = pais
       and a1.pepais = a.pfpais 
       and a1.petdoc = a.pftdoc
       and a1.pendoc = a.pfndoc
       and a1.pefalt > pfecha
       and b.pepais = a1.pepais
       and b.petdoc = a1.petdoc
       and b.pendoc = a1.pendoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = b.pepais
       and d.sngc13tdoc(+) = b.petdoc
       and d.sngc13ndoc(+) = b.pendoc
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       ORDER BY c.scfcon;
       
  cursor datosFJ(Pais in number, Pfecha in date) is
      select a.pjpais pais,
           a.pjtdoc tipdoc,
           a.pjndoc nrodoc,
           a.pjrazs cliente,
           (Select substr((TRIM(pfnom1) || ' ' || TRIM(pfnom2) || ' ' ||TRIM(pfape1) || ' ' || TRIM(pfape2)),1,70)
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) PERJURIDICA,
           (Select pfnom1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom1,
           (Select pfnom2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom2,
           (Select pfape1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE1,
           (Select pfape2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE2,
           z.pfpai1 pais1,
           z.pftdo1 tipo1,
           z.pfndo1 documento1,
           (select trim(vinom) from fst020 where vicod = z.vicod) cargo,
           (select trim(tdnom) from fst014 where tdocum = z.pftdo1) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = z.pfpai1) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
            (Select pffnac            
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1)birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon ,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = z.pfpai1
               and Petdoc = z.pftdo1
               and Pendoc = z.pfndo1
               and Txcod = 0
                and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto
    from FSR003 Z, fsd003 a, fsr008 b, fsd011 c, sngc13 d
     where Z.PFPAI1 = 604
       and z.pftdo1 = 21
       and z.pfndo1 in (select pfndoc 
                          from  fsd002
                         where  pfpnac in ( select tp1nro1 from fst198   where tp1cod = 1    and tp1cod1 =10849     and tp1corr1 =15  and tp1corr2 = 1)
                           and  pfpais =604
                           and  pftdoc = 21 )
       AND a.pjpais = Z.PJPAIS
       AND a.pjtdoc = z.pjtdoc
       and a.pjndoc = z.pjndoc
       and b.pepais = a.pjpais
       and b.petdoc = a.pjtdoc
       and b.pendoc = a.pjndoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = z.pfpai1
       and d.sngc13tdoc(+) = z.pftdo1
       and d.sngc13ndoc(+) = z.pfndo1
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       union
    select a.pjpais pais,
           a.pjtdoc tipdoc,
           a.pjndoc nrodoc,
           a.pjrazs cliente,
           (Select substr((TRIM(pfnom1) || ' ' || TRIM(pfnom2) || ' ' ||TRIM(pfape1) || ' ' || TRIM(pfape2)),1,70)
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) PERJURIDICA,
           (Select pfnom1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom1,
           (Select pfnom2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) nom2,
           (Select pfape1
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE1,
           (Select pfape2
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1) APE2,
           z.pfpai1 pais1,
           z.pftdo1 tipo1,
           z.pfndo1 documento1,
           (select trim(vinom) from fst020 where vicod = z.vicod) cargo,
           (select trim(tdnom) from fst014 where tdocum = z.pftdo1) DescDoc,
           (select iso3166_a2 from jaql053 where iso3166_n = z.pfpai1) country,
           trim(d.sngc13dir) adress,
           (select trim(DepNom)
              from FST068
             Where Pais = d.sngc13pdoc
               and DepCod = d.sngc13dpto) depto,
           (select trim(LocNom)
              from FST070
             Where Pais = d.sngc13pdoc
               and LocCod = d.sngc13prov) provincia,
           (select trim(Fst071Dsc)
              from FST071
             Where Fst071Pai = d.sngc13pdoc
               and Fst071Col = d.sngc13dist) distrito,
            (Select pffnac            
              from fsd002
             where pfpais = z.pfpai1
               and pftdoc = z.pftdo1
               and pfndoc = z.pfndo1)birthdate,
           decode(c.scmod,
                  21,
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                  lpad(sctope, 3, '0'),
                  lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                  lpad(scmda, 3, '0') || lpad(scoper, 9, '0') ||
                  lpad(sctope, 3, '0')) CUENTA,
           c.scfcon,
           c.sccta,
           c.scmod,
           c.scmda,
           c.scsbop,
           c.sctope,
           c.scoper,
           c.scsdo,
           c.scsuc codAge,
           (select trim(scnom) from fst001 where sucurs = c.scsuc) agencia,
           (select trim(Pextxt)
              from FSX001
             Where Pepais = z.pfpai1
               and Petdoc = z.pftdo1
               and Pendoc = z.pfndo1
               and Txcod = 0
               and Pexren = 1) correo,
           c.scfulm ultmov,
           (select tonom from fst004 where modulo = c.scmod and totope = c.sctope) producto               
      from FSR003 Z, fsd001 a1, fsd003 a, fsr008 b, fsd011 c, sngc13 d
     where Z.PFPAI1 = pais
       and a1.pepais = z.pfpai1
       and a1.petdoc = z.pftdo1
       and a1.pendoc = z.pfndo1
       and a1.pefalt > pfecha
       AND a.pjpais = Z.PJPAIS
       AND a.pjtdoc = z.pjtdoc
       and a.pjndoc = z.pjndoc
       and b.pepais = a.pjpais
       and b.petdoc = a.pjtdoc
       and b.pendoc = a.pjndoc
       and b.ttcod = 1
       and b.cttfir = 'T'
       and c.pgcod = 1
       and c.sccta = b.ctnro
       and c.scmod in (21, 22)
       and c.scmda in (0, 101)
       and c.scpap = 0
       and c.scstat <> 99
       and d.sngc13pais(+) = z.pfpai1
       and d.sngc13tdoc(+) = z.pftdo1
       and d.sngc13ndoc(+) = z.pfndo1
       and d.sngc13est(+) = 'H'
       and d.docod(+) = 1
       ORDER BY 22;     
             
  Cursor telefono (pais in number, tipdoc in number, numdoc in varchar2) is 
     select Dotelfp 
       from FSR005  
      Where Pepais = pais
        and Petdoc = tipdoc
        and pendoc = numdoc  
        and Docod = 1;
   
Nrofono varchar2(50);
Nropais number(3);
maxfecha date;
estado  varchar2(1);
saldoSol number(16,2);
fechahoy date;

Begin
    select max(jaqy683aux9)
      into maxfecha
      from jaqy683;
      
    select pgfape
      into fechahoy
      from fst017
     where pgcod = 1;
        
    if maxfecha is null then
      estado := 'A';
         for reg in paises loop
          nropais := reg.tp1nro1;
          for dat in datos(nropais) loop
            Nrofono := null;
            for tel in telefono(dat.pais,dat.tipdoc,dat.nrodoc) loop
              Nrofono := trim(tel.dotelfp)||' '||Nrofono; 
            end loop;  
            if dat.scmda = 101 then
              saldoSol := round(dat.scsdo * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                              monori => dat.scmda,
                                                                              mondes => 0,
                                                                              tipo   => 500
                                                                              ),2);
            else
              saldoSol := dat.scsdo;
            end if;
                  
            Begin
             insert into jaqy683(JAQY683PAIS,
                                  JAQY683TDOC,
                                  JAQY683NDOC,
                                  JAQY683CTA,
                                  JAQY683PDESC,
                                  JAQY683CLIE,
                                  JAQY683PERJ,
                                  JAQY683NOM1,
                                  JAQY683NOM2,
                                  JAQY683APE1,
                                  JAQY683APE2,
                                  JAQY683PAIS1,
                                  JAQY683TDOC1,
                                  JAQY683NDOC1,
                                  JAQY683CARGO,
                                  JAQY683DESDOC,
                                  JAQY683SIGLA,
                                  JAQY683DIR,
                                  JAQY683DEPT,
                                  JAQY683PROV,
                                  JAQY683DIST,
                                  JAQY683FNAC,
                                  JAQY683FAPE,
                                  JAQY683SCCTA,
                                  JAQY683SCMOD,
                                  JAQY683SCMDA,
                                  JAQY683SCPAP,
                                  JAQY683SCOPER,
                                  JAQY683SCSBOP,
                                  JAQY683SCTOPE,
                                  JAQY683SCSLD,
                                  JAQY683SCSUC,
                                  JAQY683AGE,
                                  JAQY683MAIL,
                                  JAQY683TELE,
                                  JAQY683EST,
                                  JAQY683FINS,
                                  jaqy683aux1,
                                  jaqy683aux9,
                                  jaqy683aux11,
                                  jaqy683aux5                         
                                 )
                          values(dat.pais,
                                 dat.tipdoc,
                                 dat.nrodoc,
                                 dat.cuenta,
                                 reg.tp1desc,
                                 dat.cliente,
                                 dat.perjuridica,
                                 dat.nom1,
                                 dat.nom2,
                                 dat.ape1,
                                 dat.ape2,
                                 dat.pais1,
                                 dat.tipo1,
                                 dat.documento1,
                                 dat.cargo,
                                 dat.descdoc,
                                 dat.country,
                                 dat.adress,
                                 dat.depto,
                                 dat.provincia,
                                 dat.distrito,
                                 dat.birthdate,
                                 dat.scfcon,
                                 dat.sccta,
                                 dat.scmod,
                                 dat.scmda,
                                 0,
                                 dat.scoper,
                                 dat.scsbop,
                                 dat.sctope,
                                 dat.scsdo,
                                 dat.codage,
                                 dat.agencia,
                                 dat.correo,
                                 Nrofono,
                                 estado,
                                 sysdate,
                                 saldoSol,
                                 fechahoy,
                                 dat.ultmov,
                                 dat.producto                    
                                 );
             commit;    
            exception
              when DUP_VAL_ON_INDEX then
                null;
            end; 
          end loop;
          for datj in datosJ(nropais) loop
            Nrofono := null;
            for tel in telefono(datj.pais,datj.tipdoc,datj.nrodoc) loop
              Nrofono := trim(tel.dotelfp)||' '||Nrofono; 
            end loop;   
            if datJ.scmda = 101 then
              saldoSol := round(datJ.scsdo * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                              monori => datJ.scmda,
                                                                              mondes => 0,
                                                                              tipo   => 500
                                                                              ),2);
            else
              saldoSol := datJ.scsdo;
            end if;     
            Begin
             insert into jaqy683(JAQY683PAIS,
                                  JAQY683TDOC,
                                  JAQY683NDOC,
                                  JAQY683CTA,
                                  JAQY683PDESC,
                                  JAQY683CLIE,
                                  JAQY683PERJ,
                                  JAQY683NOM1,
                                  JAQY683NOM2,
                                  JAQY683APE1,
                                  JAQY683APE2,
                                  JAQY683PAIS1,
                                  JAQY683TDOC1,
                                  JAQY683NDOC1,
                                  JAQY683CARGO,
                                  JAQY683DESDOC,
                                  JAQY683SIGLA,
                                  JAQY683DIR,
                                  JAQY683DEPT,
                                  JAQY683PROV,
                                  JAQY683DIST,
                                  JAQY683FNAC,
                                  JAQY683FAPE,
                                  JAQY683SCCTA,
                                  JAQY683SCMOD,
                                  JAQY683SCMDA,
                                  JAQY683SCPAP,
                                  JAQY683SCOPER,
                                  JAQY683SCSBOP,
                                  JAQY683SCTOPE,
                                  JAQY683SCSLD,
                                  JAQY683SCSUC,
                                  JAQY683AGE,
                                  JAQY683MAIL,
                                  JAQY683TELE,
                                  JAQY683EST,
                                  JAQY683FINS,
                                  JAQY683AUX1,
                                  JAQY683AUX9,
                                  jaqy683aux11,
                                  jaqy683aux5
                                  )
                          values(datj.pais,
                                 datj.tipdoc,
                                 datj.nrodoc,
                                 datj.cuenta,
                                 reg.tp1desc,
                                 datj.cliente,
                                 datj.perjuridica,
                                 datj.nom1,
                                 datj.nom2,
                                 datj.ape1,
                                 datj.ape2,
                                 datj.pais1,
                                 datj.tipo1,
                                 datj.documento1,
                                 datj.cargo,
                                 datj.descdoc,
                                 datj.country,
                                 datj.adress,
                                 datj.depto,
                                 datj.provincia,
                                 datj.distrito,
                                 datj.birthdate,
                                 datj.scfcon,
                                 datj.sccta,
                                 datj.scmod,
                                 datj.scmda,
                                 0,
                                 datj.scoper,
                                 datj.scsbop,
                                 datj.sctope,
                                 datj.scsdo,
                                 datj.codage,
                                 datj.agencia,
                                 datj.correo,
                                 Nrofono,
                                 estado,
                                 sysdate,
                                 saldoSol,
                                 fechahoy,
                                 datj.ultmov,
                                 datj.producto
                                 );
             commit;    
            exception
              when DUP_VAL_ON_INDEX then
                null;
            end; 
          end loop;
        end loop;
     else       
       Actualiza_estado;
       estado := 'N';
       for reg in paises loop
          nropais := reg.tp1nro1;
          for dat in datosF(nropais,maxfecha ) loop
            Nrofono := null;
            for tel in telefono(dat.pais,dat.tipdoc,dat.nrodoc) loop
              Nrofono := trim(tel.dotelfp)||' '||Nrofono; 
            end loop;  
            if dat.scmda = 101 then
              saldoSol := round(dat.scsdo * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                              monori => dat.scmda,
                                                                              mondes => 0,
                                                                              tipo   => 500
                                                                              ),2);
            else
              saldoSol := dat.scsdo;
            end if;
                  
            Begin
             insert into jaqy683(JAQY683PAIS,
                                  JAQY683TDOC,
                                  JAQY683NDOC,
                                  JAQY683CTA,
                                  JAQY683PDESC,
                                  JAQY683CLIE,
                                  JAQY683PERJ,
                                  JAQY683NOM1,
                                  JAQY683NOM2,
                                  JAQY683APE1,
                                  JAQY683APE2,
                                  JAQY683PAIS1,
                                  JAQY683TDOC1,
                                  JAQY683NDOC1,
                                  JAQY683CARGO,
                                  JAQY683DESDOC,
                                  JAQY683SIGLA,
                                  JAQY683DIR,
                                  JAQY683DEPT,
                                  JAQY683PROV,
                                  JAQY683DIST,
                                  JAQY683FNAC,
                                  JAQY683FAPE,
                                  JAQY683SCCTA,
                                  JAQY683SCMOD,
                                  JAQY683SCMDA,
                                  JAQY683SCPAP,
                                  JAQY683SCOPER,
                                  JAQY683SCSBOP,
                                  JAQY683SCTOPE,
                                  JAQY683SCSLD,
                                  JAQY683SCSUC,
                                  JAQY683AGE,
                                  JAQY683MAIL,
                                  JAQY683TELE,
                                  JAQY683EST,
                                  JAQY683FINS,
                                  jaqy683aux1,
                                  jaqy683aux9,
                                  jaqy683aux11,
                                  jaqy683aux5                         
                                 )
                          values(dat.pais,
                                 dat.tipdoc,
                                 dat.nrodoc,
                                 dat.cuenta,
                                 reg.tp1desc,
                                 dat.cliente,
                                 dat.perjuridica,
                                 dat.nom1,
                                 dat.nom2,
                                 dat.ape1,
                                 dat.ape2,
                                 dat.pais1,
                                 dat.tipo1,
                                 dat.documento1,
                                 dat.cargo,
                                 dat.descdoc,
                                 dat.country,
                                 dat.adress,
                                 dat.depto,
                                 dat.provincia,
                                 dat.distrito,
                                 dat.birthdate,
                                 dat.scfcon,
                                 dat.sccta,
                                 dat.scmod,
                                 dat.scmda,
                                 0,
                                 dat.scoper,
                                 dat.scsbop,
                                 dat.sctope,
                                 dat.scsdo,
                                 dat.codage,
                                 dat.agencia,
                                 dat.correo,
                                 Nrofono,
                                 estado,
                                 sysdate,
                                 saldoSol,
                                 fechahoy,
                                 dat.ultmov,
                                 dat.producto
                                 );
             commit;    
            exception
              when DUP_VAL_ON_INDEX then
                null;
            end; 
          end loop;
          for datj in datosFJ(nropais, maxfecha) loop
            Nrofono := null;
            for tel in telefono(datj.pais,datj.tipdoc,datj.nrodoc) loop
              Nrofono := trim(tel.dotelfp)||' '||Nrofono; 
            end loop;   
            if datJ.scmda = 101 then
              saldoSol := round(datJ.scsdo * fn_tipo_cambio(fecha  => trunc(sysdate),
                                                                              monori => datJ.scmda,
                                                                              mondes => 0,
                                                                              tipo   => 500
                                                                              ),2);
            else
              saldoSol := datJ.scsdo;
            end if;     
            Begin
             insert into jaqy683(JAQY683PAIS,
                                  JAQY683TDOC,
                                  JAQY683NDOC,
                                  JAQY683CTA,
                                  JAQY683PDESC,
                                  JAQY683CLIE,
                                  JAQY683PERJ,
                                  JAQY683NOM1,
                                  JAQY683NOM2,
                                  JAQY683APE1,
                                  JAQY683APE2,
                                  JAQY683PAIS1,
                                  JAQY683TDOC1,
                                  JAQY683NDOC1,
                                  JAQY683CARGO,
                                  JAQY683DESDOC,
                                  JAQY683SIGLA,
                                  JAQY683DIR,
                                  JAQY683DEPT,
                                  JAQY683PROV,
                                  JAQY683DIST,
                                  JAQY683FNAC,
                                  JAQY683FAPE,
                                  JAQY683SCCTA,
                                  JAQY683SCMOD,
                                  JAQY683SCMDA,
                                  JAQY683SCPAP,
                                  JAQY683SCOPER,
                                  JAQY683SCSBOP,
                                  JAQY683SCTOPE,
                                  JAQY683SCSLD,
                                  JAQY683SCSUC,
                                  JAQY683AGE,
                                  JAQY683MAIL,
                                  JAQY683TELE,
                                  JAQY683EST,
                                  JAQY683FINS,
                                  JAQY683AUX1,
                                  JAQY683AUX9,
                                  jaqy683aux11,
                                  jaqy683aux5 )
                          values(datj.pais,
                                 datj.tipdoc,
                                 datj.nrodoc,
                                 datj.cuenta,
                                 reg.tp1desc,
                                 datj.cliente,
                                 datj.perjuridica,
                                 datj.nom1,
                                 datj.nom2,
                                 datj.ape1,
                                 datj.ape2,
                                 datj.pais1,
                                 datj.tipo1,
                                 datj.documento1,
                                 datj.cargo,
                                 datj.descdoc,
                                 datj.country,
                                 datj.adress,
                                 datj.depto,
                                 datj.provincia,
                                 datj.distrito,
                                 datj.birthdate,
                                 datj.scfcon,
                                 datj.sccta,
                                 datj.scmod,
                                 datj.scmda,
                                 0,
                                 datj.scoper,
                                 datj.scsbop,
                                 datj.sctope,
                                 datj.scsdo,
                                 datj.codage,
                                 datj.agencia,
                                 datj.correo,
                                 Nrofono,
                                 estado,
                                 sysdate,
                                 saldoSol,
                                 fechahoy,
                                 datj.ultmov,
                                 datj.producto
                                 );
             commit;    
            exception
              when DUP_VAL_ON_INDEX then
                null;
            end; 
          end loop;
        end loop;
      
    end if;  
             
End Registro_Datos;    

  -- Function and procedure implementations
Procedure  Actualiza_estado is
  fecha date; 
  begin
    select LAST_DAY(ADD_MONTHS(pgfapE, -2)) + 1
      into fecha
      from fst017
     where pgcod = 1;
    
    update jaqy683
       set jaqy683est = 'A'
     where jaqy683est = 'N'
       and jaqy683aux9 < fecha;
    commit;   
end;

end PQ_AH_PROY_FATCA;
/

