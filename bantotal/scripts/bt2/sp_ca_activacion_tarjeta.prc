create or replace procedure SP_CA_ACTIVACION_TARJETA(P_TARJETA character,
                                                     P_USUARIO character) is
  n_cantidad numeric(5);
  C_ERROR    VARCHAR2(1000);
  VHOST_NAME VARCHAR2(100);
	v_found number;
	
BEGIN
  --chernandez 13/07/2017
  /*SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
  if UPPER(vhost_name) in ('SC01ZDBADM010101',
                           'SC01ZDBADM020101',
                           'BTRAC4051') then
    sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                        'chernandez@cajaarequipa.pe', --para
                        'SP_CA_ACTIVACION_TARJETA', --titulo
                        sys_context('USERENV', 'DB_NAME') || '-' ||
                        sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                        'TARJETA:' || P_TARJETA || '-' || 'USUARIO:' ||
                        P_USUARIO);
    sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                        'lcarpio@cajaarequipa.pe', --para
                        'SP_CA_ACTIVACION_TARJETA', --titulo
                        sys_context('USERENV', 'DB_NAME') || '-' ||
                        sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                        'TARJETA:' || P_TARJETA || '-' || 'USUARIO:' ||
                        P_USUARIO);
  End If;*/

  UPDATE Z0E481
     set Z0E481FAU = trunc(sysdate),
         Z0E481UAU = 'USRSWITCH',
         Z0E481EST = 'AC',
         Z0E481TNV = '   ',
         Z0E463COD = 1
   Where Z0E481nro = P_TARJETA;

  UPDATE Z0E482
     set Z0E482FAU = trunc(sysdate),
         Z0E482UAU = 'USRSWITCH',
         Z0E482EST = 'AC'
   Where Z0E481nro = P_TARJETA;

  --chernandez 28/06/2017
  delete from Z0E478 where Z0E478NRO = P_TARJETA;

  insert into Z0E478
    (Z0E478NRO,
     Z0E478TIP,
     Z0E478SUC,
     Z0E478CTE,
     Z0E478CTT,
     Z0E478THP,
     Z0E478THT,
     Z0E478THD,
     Z0E478CDO,
     Z0E468COD,
     Z0E469COD,
     Z0E462COD,
     Z0E461COD,
     Z0E465COD,
     Z0E478PES,
     Z0E478NOM,
     Z0E478LIN,
     Z0E466COD,
     Z0E477COD,
     Z0E478TCD,
     Z0E478CTD,
     Z0E478DSU,
     Z0E478DCD,
     Z0E478DSC,
     Z0E478DMO,
     Z0E478DMN,
     Z0E478DPA,
     Z0E478DTO,
     Z0E478DOP,
     Z0E478NR1,
     Z0E478NR2,
     Z0E463COD,
     Z0E478FMD,
     Z0E478UMD,
     Z0E478FAU,
     Z0E478UAU,
     Z0E478EST,
     Z0E478TNV,
     Z0E478CSA,
     Z0E478PLA,
     Z0E478PLS,
     Z0E478PGC,
     Z0E478RES,
     Z0E478AUT,
     Z0E478USR,
     Z0E478FUU,
     Z0E478FEP,
     Z0E478FRP,
     Z0E478CEO,
     Z0E478FAL,
     Z0E478FBJ,
     Z0E478HBA,
     Z0E478FAH,
     Z0E478FPH,
     Z0E478FUH,
     Z0E478TTI,
     Z0E478ADI,
     Z0E478CLI,
     Z0E478FVT,
     Z0E478CAN,
     Z0E478LEX,
     Z0E478SEG,
     Z0E478FAS,
     Z0E478FBS,
     Z0E478SDE)
    select Z0E481NRO,
           Z0E481TIP,
           Z0E481SUC,
           Z0E481CTE,
           Z0E481CTT,
           Z0E481THP,
           Z0E481THT,
           Z0E481THD,
           Z0E481CDO,
           Z0E468COD,
           Z0E469COD,
           Z0E462COD,
           Z0E461COD,
           Z0E465COD,
           Z0E481PES,
           Z0E481NOM,
           Z0E481LIN,
           Z0E466COD,
           Z0E477COD,
           Z0E481TCD,
           Z0E481CTD,
           Z0E481DSU,
           Z0E481DCD,
           Z0E481DSC,
           Z0E481DMO,
           Z0E481DMN,
           Z0E481DPA,
           Z0E481DTO,
           Z0E481DOP,
           Z0E481NR1,
           Z0E481NR2,
           1,
           trunc(sysdate),
           'USRSWITCH',
           trunc(sysdate),
           'USRSWITCH',
           'AC',
           '   ',
           2,
           'ENTREGADA',
           (select TD10SUC from ftd10 where td10tar = P_TARJETA),
           1,
           ' ',
           ' ',
           '          ',
           To_date('01/01/0001', 'DD/MM/YYYY'),
           To_date('01/01/0001', 'DD/MM/YYYY'),
           To_date('01/01/0001', 'DD/MM/YYYY'),
           '   ',
           trunc(sysdate),
           To_date('01/01/0001', 'DD/MM/YYYY'),
           ' ',
           To_date('01/01/0001', 'DD/MM/YYYY'),
           To_date('01/01/0001', 'DD/MM/YYYY'),
           To_date('01/01/0001', 'DD/MM/YYYY'),
           '                   ',
           'N',
           '0',
           Z0E481FVT,
           Z0E481CAN,
           Z0E481LEX,
           Z0E481SEG,
           Z0E481FAS,
           Z0E481FBS,
           Z0E481SDE
    
      from z0e481
     where Z0E481NRO = P_TARJETA;

  --chernandez 28/06/2017
  delete from Z0E479 where Z0E478NRO = P_TARJETA;

  Insert into Z0E479
    (Z0E478NRO,
     Z0E479SUC,
     Z0E479CTA,
     Z0E479SCT,
     Z0E479MOD,
     Z0E479MON,
     Z0E479PAP,
     Z0E479TOP,
     Z0E479OPE,
     Z0E479EST,
     Z0E479TUS,
     Z0E460COD,
     Z0E480COD,
     Z0E479FMD,
     Z0E479UMD,
     Z0E479FAU,
     Z0E479UAU,
     Z0E479TNV,
     Z0E479CTB,
     Z0E479PGC)
    select Z0E481NRO,
           Z0E482SUC,
           Z0E482CTA,
           Z0E482SCT,
           Z0E482MOD,
           Z0E482MON,
           Z0E482PAP,
           Z0E482TOP,
           Z0E482OPE,
           'AC',
           Z0E482TUS,
           Z0E460COD,
           Z0E480COD,
           Z0E482FMD,
           Z0E482UMD,
           trunc(sysdate),
           'USRSWITCH',
           Z0E482TNV,
           Z0E482CTB,
           Z0E482PGC
      from Z0E482
     where Z0E481NRO = P_TARJETA;

  --chernandez 28/06/2017
  delete from Z0E483 where z0e483nro = P_TARJETA;

  insert into Z0E483
    (z0e483nro,
     z0e483fch,
     z0e483hor,
     z0e483tip,
     z0e483suc,
     z0e483cte,
     z0e483ctt,
     z0e483thp,
     z0e483tht,
     z0e483thd,
     z0e483cdo,
     z0e468cod,
     z0e469cod,
     z0e462cod,
     z0e461cod,
     z0e465cod,
     z0e483pes,
     z0e483nom,
     z0e483lin,
     z0e466cod,
     z0e477cod,
     z0e483tcd,
     z0e483ctd,
     z0e483dsu,
     z0e483dcd,
     z0e483dsc,
     z0e483dmo,
     z0e483dmn,
     z0e483dpa,
     z0e483dto,
     z0e483dop,
     z0e483nr1,
     z0e483nr2,
     z0e463cod,
     z0e483fmd,
     z0e483umd,
     z0e483fau,
     z0e483uau,
     z0e483est,
     z0e483tnv,
     z0e483csa,
     z0e483pgc,
     z0e483pla,
     z0e483pls,
     z0e483res,
     z0e483aut,
     z0e483usr,
     z0e483fuu,
     z0e483fep,
     z0e483frp,
     z0e483ceo,
     z0e483tti,
     z0e483adi,
     z0e483lco,
     z0e483fvt,
     td13cod,
     z0e483lex,
     z0e483seg,
     z0e483fas,
     z0e483fbs,
     z0e483sde)
    select Z0E478NRO,
           trunc(sysdate),
           TO_CHAR(sysdate, 'HH24:mm:ss'),
           Z0E478TIP,
           Z0E478SUC,
           Z0E478CTE,
           Z0E478CTT,
           Z0E478THP,
           Z0E478THT,
           Z0E478THD,
           Z0E478CDO,
           Z0E468COD,
           Z0E469COD,
           Z0E462COD,
           Z0E461COD,
           Z0E465COD,
           Z0E478PES,
           Z0E478NOM,
           Z0E478LIN,
           Z0E466COD,
           Z0E477COD,
           Z0E478TCD,
           Z0E478CTD,
           Z0E478DSU,
           Z0E478DCD,
           Z0E478DSC,
           Z0E478DMO,
           Z0E478DMN,
           Z0E478DPA,
           Z0E478DTO,
           Z0E478DOP,
           Z0E478NR1,
           Z0E478NR2,
           Z0E463COD,
           Z0E478FMD,
           Z0E478UMD,
           Z0E478FAU,
           Z0E478UAU,
           'PE',
           'INS',
           0,
           Z0E478PGC,
           null,
           0,
           Z0E478RES,
           Z0E478AUT,
           Z0E478USR,
           Z0E478FUU,
           Z0E478FEP,
           Z0E478FRP,
           Z0E478CEO,
           Z0E478TTI,
           Z0E478ADI,
           Z0E478CLI,
           Z0E478FVT,
           Z0E478CAN,
           Z0E478LEX,
           Z0E478SEG,
           Z0E478FAS,
           Z0E478FBS,
           Z0E478SDE
    
      from Z0E478
     where Z0E478NRO = P_TARJETA;

  select count(*)
    into n_cantidad
    from jaqy252
   where jaqy252nutar = P_TARJETA;

  if n_cantidad = 0 then
  
    insert into jaqy252
      (jaqy252nutar,
       jaqy252feint,
       jaqy252hoint,
       jaqy252nuint,
       jaqy252nucan,
       jaqy252usint)
    values
      (P_TARJETA,
       trunc(sysdate),
       TO_CHAR(sysdate, 'HH24:mm:ss'),
       0,
       2,
       'USRSWITCH');
  
  else
  
    update jaqy252
       set jaqy252feint = trunc(sysdate),
           jaqy252hoint = TO_CHAR(sysdate, 'HH24:mm:ss'),
           jaqy252nuint = 0,
           jaqy252nucan = 2,
           jaqy252usint = 'USRSWITCH'
     where jaqy252nutar = P_TARJETA;
  end If;

  --chernandez 28/06/2017 internet banking
  delete from cnl001
   where cnl000cod = 5
     and cnl001adm = P_TARJETA;
  delete from cnl002
   where cnl000cod = 5
     and cnl001adm = P_TARJETA;
  delete from cnl023
   where cnl000cod = 5
     and cnl001adm = P_TARJETA;
  delete from cnl034
   where cnl000cod = 5
     and cnl001adm = P_TARJETA;

  insert into cnl001
    select 5,
           z0e478nro,
           z0e478nro,
           z0e478nom,
           null,
           'NORMA',
           z0e478thp,
           z0e478tht,
           z0e478thd,
           z0e478thp,
           z0e478tht,
           z0e478thd,
           0,
           0,
           null,
           0,
           0,
           'S',
           0,
           'ES',
           null,
           null,
           null,
           null,
           0,
           0,
           0,
           trunc(sysdate),
           to_char(sysdate, 'HH24:MI:SS'),
           'S',
           ' ',
           ' ',
           0,
           ' ',
           'N',
           to_date('01-01-0001', 'dd-mm-yyyy'),
           ' ',
           ' ',
           ' ',
           ' ',
           ' ',
           ' ',
           ' ',
           to_date('01-01-0001', 'dd-mm-yyyy'),
           ' ',
           ' ',
           ' ',
           ' ',
           0,
           ' ',
           ' ',
           ' ',
           ' ',
           ' ',
           null,
           ' ',
           to_date('01-01-0001', 'dd-mm-yyyy'),
           ' ',
           ' ',
           ' '
      from z0e478 a
     where z0e478nro = P_TARJETA;

  insert into cnl002
    select 5,
           a.z0e478nro,
           a.z0e478nro,
           c.pgcod,
           c.scmod,
           c.scsuc,
           c.scmda,
           c.scpap,
           c.scoper,
           c.sctope,
           c.sccta,
           c.scsbop,
           0,
           'S',
           0.00,
           null
      from fsd011 c, z0e478 a, fsr008 b
     where c.pgcod = 1
       and c.scmod = 21
       and c.sccta = b.ctnro
       and z0e478nro = P_TARJETA
       and a.z0e478thp = b.pepais
       and a.z0e478tht = b.petdoc
       and a.z0e478thd = b.pendoc
    union
    select 5,
           a.z0e478nro,
           a.z0e478nro,
           c.pgcod,
           426,
           c.scsuc,
           c.scmda,
           c.scpap,
           c.scoper,
           0,
           c.sccta,
           c.scsbop,
           0,
           'S',
           0.00,
           null
      from fsd011 c, z0e478 a, fsr008 b
     where c.pgcod = 1
       and c.scmod = 22
       and c.sccta = b.ctnro
       and z0e478nro = P_TARJETA
       and a.z0e478thp = b.pepais
       and a.z0e478tht = b.petdoc
       and a.z0e478thd = b.pendoc
    union
    select 5,
           a.z0e478nro,
           a.z0e478nro,
           c.pgcod,
           0,
           0,
           0,
           0,
           0,
           0,
           c.sccta,
           0,
           0,
           'S',
           0.00,
           null
      from fsd011 c, z0e478 a, fsr008 b
     where c.pgcod = 1
       and c.sccta = b.ctnro
       and z0e478nro = P_TARJETA
       and a.z0e478thp = b.pepais
       and a.z0e478tht = b.petdoc
       and a.z0e478thd = b.pendoc;

  update cnl002
     set cnl002ima = 999999999.00
   where cnl000cod = 5
     and cnl001adm = P_TARJETA
     and cnl002mod > 0
     and (cnl002suc, cnl002cta, cnl002sbo, cnl002ope) in
         (select z0e479suc, z0e479cta, z0e479sct, z0e479ope
            from z0e479
           where z0e478nro = P_TARJETA
             and z0e479est = 'AC');

  --CNL023
  insert into cnl023
    select 5,
           B.Z0E478NRO,
           B.Z0E478NRO,
           a.tp1nro1,
           '00:00:00',
           '23:59:59',
           null,
           decode(tp1nro2 + (select count(*)
                               from jaqy259
                              where jaqy259nutar = P_TARJETA
                                and jaqy259habil = 'S'),
                  0,
                  'N',
                  'S'),
           case tp1imp1
             when 0 then
              null
             else
              'I'
           end,
           0.00,
           0,
           null
      from fst198 a, z0e478 b
     where tp1cod1 = 10863
       and tp1corr1 = 1
       and tp1corr2 = 4
       and tp1nro1 > 0
       and tp1desc = 'E'
       and b.z0e478nro = P_TARJETA;

  --CNL034
  insert into cnl034
    select 5, a.z0e478nro, a.z0e478nro, b.cnl035cod, 'S'
      from z0e478 a, cnl035 b
     where z0e478nro = P_TARJETA;

EXCEPTION
  WHEN OTHERS THEN
    C_ERROR := sqlerrm;
    SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
		
		SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);


--    if UPPER(vhost_name) in ('SC01ZDBADM010101',
--                             'SC01ZDBADM020101',
--                             'BTRAC4051') then
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then                             

  if v_found =1 then
		
      sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                          'chernandez@cajaarequipa.pe', --para
                          'SP_CA_ACTIVACION_TARJETAEEE', --titulo
                          sys_context('USERENV', 'DB_NAME') || '-' ||
                          sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                          c_error);
      sys.sp_sy_enviamail('activaciontar@cajaarequipa.pe', --de
                          'lcarpio@cajaarequipa.pe', --para
                          'SP_CA_ACTIVACION_TARJETAEEE', --titulo
                          sys_context('USERENV', 'DB_NAME') || '-' ||
                          sys_context('USERENV', 'INSTANCE_NAME') || '-' ||
                          c_error);
    end if;
END SP_CA_ACTIVACION_TARJETA;
/

