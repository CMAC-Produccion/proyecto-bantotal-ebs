create or replace package "PQ_CR_RESOLUTOR_SEG_DESEMPLEO" is

  -- Author  : SMARQUEZ
  -- Created : 16/03/2023 10:49:30
  -- Purpose : Creacion de variables para el seguro de dESEMPLEO
  -- Modificacion: SMARQUEZ 02/09/2024 cambio de sucursal de cobro por sucursal de credito
  -- Modificacion: SMARQUEZ 25/03/2025 PRoceso pra el Desembolso Digital /polizas desde APP
  Procedure Sp_seg_desempleo(pn_ins in number,
                             pn_tip out number,
                             pc_tsg out varchar2);

  Procedure Sp_seg_agricola(pn_ins in number,
                            pn_tip out number,
                            pc_tsg out varchar2);

  Procedure Sp_cantidad_segdesemagri (pn_ins in number,
                                      pn_tipo in number,
                                      pn_cant out number,
                                      pc_valida out varchar2);

  Procedure Sp_valida_anterior(pn_ins in number,
                               pn_tipo in number,
                               pc_valida out varchar2);

  Procedure Sp_valida_periodo(pn_ins in number,
                              pn_tipo in number,
                              pc_periodo out varchar2)  ;

  Procedure Sp_valida_mtoprima(pn_ins in number,
                               pn_tipo in number,
                               pn_mtocre out number,
                               pn_mtopri out number,
                               pn_mtotot out number)  ;

  Procedure Cobros_SegDESAGRI(pd_fechaini in date,
                              pd_fechafin in date,
                              pn_tipo     in number,
                              pc_users    in varchar2); -- 1 agricola 2 desempleo

  Procedure PlazoCuoata_meses(pn_ins in number,
                              pn_tipo in number,
                              pc_flag out varchar2,
                              pc_periodo out varchar2)   ;

  Procedure MtoAdicional_AgriDes(pn_ins in number,
                                 pn_monto out number);

  Procedure desembolso_desempleo(pn_ins in number,
                                 pc_flag out varchar2);

  Procedure PlazoCuoata_meses2(pn_ins in number,
                              pn_tipo in number,
                              pc_flag out varchar2,
                              pc_periodo out varchar2);

  Procedure Sp_DesempleoSeg_APP(pn_instancia in number,
                                pc_tisegdes  out varchar2,
                                pc_tisegagri out varchar2,
                                pn_montosegD out number,
                                pn_montosegA out number,
                                pc_tiposegmento out varchar2);
  Procedure Sp_segmento_desempleo(pn_instancia in number,
                                 pc_tiposegmento out varchar2);


end PQ_CR_RESOLUTOR_SEG_DESEMPLEO;
 /* GOLDENGATE_DDL_REPLICATION */
/
create or replace package body "PQ_CR_RESOLUTOR_SEG_DESEMPLEO" is

  -- Author  : SMARQUEZ
  -- Created : 16/03/2023 10:49:30
  -- Purpose : Creacion de variables para el seguro de dESEMPLEO
  -- Autor   :  SMARQUEZ
  -- fecha   : 22/08/2023
  -- Modificacion: en el procedimiento Cobros Seguros
  -- Autor   :  SMARQUEZ
  -- fecha   : 26/01/2024
  -- Modificacion: GENERACION DE REPORTE DE COBROS AGRICOLAS
  -- Autor   :  SMARQUEZ
  -- fecha   : 21/03/2024
  -- Modificacion: Adición de sucursal en el proceso de cobros SegDESAGRI
  -- Autor   :  SMARQUEZ
  -- fecha   : 27/03/2024
  -- Modificacion: Eliminacion de filtro hora el proceso de cobros SegDESAGRI
  -- Modificacion: SMARQUEZ 02/09/2024 cambio de sucursal de cobro por sucursal de credito
  -- Modificacion: SMARQUEZ> 23/12/2024 control duplicados en seg desempleo
  -- Modificacion: SMARQUEZ 24/01/2025 cambio para evitar bloqueos con el truncate table aqpa560
  -- Modificacion: SMARQUEZ 19/05/2025 PRoceso pra el Desembolso Digital /polizas desde APP
  -- Modificacion: SMARQUEZ 12/06/2025 Adecuacion para desmbolso Digital 
  Procedure Sp_seg_desempleo(pn_ins in number,
                             pn_tip out number,
                             pc_tsg out varchar2)is
  existe varchar2(1):= 'N';


  Begin
      select 'S', b.jaqm65cod
        into pc_tsg, pn_tip
        from jaqm65 b , jaqm66 a
       where b.jaqm65tad = 2
         and b.jaqm65ins = pn_ins
         and a.jaqm66ins = b.jaqm65ins
         and a.jaqm66est <>'E';
  exception
      when no_Data_found then
        pc_tsg:= 'N';
        pn_tip:= 0;
      when too_many_rows then
        pc_tsg:= 'S';
        pn_tip:= 99;

  end Sp_seg_desempleo;


  Procedure Sp_seg_agricola(pn_ins in number,
                            pn_tip out number,
                            pc_tsg out varchar2)is
  existe varchar2(1):= 'N';


  Begin
      select 'S', b.jaqm65cod
        into pc_tsg, pn_tip
        from jaqm65 b , jaqm66 a
       where b.jaqm65tad = 1
         and b.jaqm65ins = pn_ins
         and a.jaqm66ins = b.jaqm65ins
         and a.jaqm66est <>'E';
  exception
      when no_Data_found then
        pc_tsg:= 'N';
        pn_tip:= 0;
      when too_many_rows then
        pc_tsg:= 'S';
        pn_tip:= 99;

  end Sp_seg_agricola;

  Procedure Sp_cantidad_segdesemagri (pn_ins in number,
                                      pn_tipo in number,
                                      pn_cant out number,
                                      pc_valida out varchar2)is
   cursor instancias(cta in number) is
    select * from xwf700 a , fsd010 b
    where a.xwfcuenta = Cta
      and a.xwfprcins <> pn_ins
      and a.xwfcar3 ='1'
      and b.pgcod = xwfempresa
      and b.aomod = xwfmodulo
      and b.aosuc = xwfsucursal
      and b.aomda = xwfmoneda
      and b.aopap = xwfpapel
      and b.aocta =  xwfcuenta
      and b.aooper = xwfoperacion
      and b.aosbop = xwfsubope
      and b.aotope = xwftipope
      and b.aostat <> 99;

  cursor cuentas (doc in char, ctn in number) is
      select * from fsr008
       where pendoc = doc
         and ctnro <> ctn
         and cttfir = 'T'
         and rownum = 1;


  cuenta number:=0;
--  contador number:=0;
  documento character(12);

  Begin
    pn_cant := 0;
    pc_valida :='N';

    BEgin
      --obtiene cuenta actual
       select xwfcuenta into cuenta from xwf700 where xwfprcins = pn_ins and xwfcar3 ='1';
       --obtiene documento
       select pendoc into documento
         from fsr008
        where ctnro  = cuenta
          and ttcod = 1
          and cttfir = 'T'
          and rownum = 1;
    exception
      when no_data_found then
        cuenta := 0;
    end;

   /* select count(*)
          into pn_cant
          from jaqm65 b , jaqm66 a
         where b.jaqm65tad = pn_tipo  ---1 agricola,2 desempleo
           and b.jaqm65ins = pn_ins
           and a.jaqm66ins = b.jaqm65ins
           and a.jaqm66est <>'E';

     if pn_cant < 2 then*/
        for i in instancias(cuenta) loop
           if pn_cant = 0 or null  then
            select count(*)
              into pn_cant
              from jaqm65 b , jaqm66 a
             where b.jaqm65tad = pn_tipo  ---1 agricola,2 desempleo
               and b.jaqm65ins = i.xwfprcins
               and a.jaqm66ins = b.jaqm65ins
               and a.jaqm66est <>'E';

            else
              exit;
            end if;
        end loop;

        if pn_cant = 0 or pn_cant is null then
          for r in cuentas(documento,cuenta) loop
            for i in instancias(r.ctnro) loop
             if pn_cant = 0  then
              select count(*)
                into pn_cant
                from jaqm65 b , jaqm66 a
               where b.jaqm65tad = pn_tipo---1 agricola,2 desempleo
                 and b.jaqm65ins = i.xwfprcins
                 and a.jaqm66ins = b.jaqm65ins
                 and a.jaqm66est <>'E';

              else
                exit;
              end if;
            end loop;
          end loop;
        end if;
--    end if;
    if pn_cant = 0 or pn_cant is null then
      pn_cant:= 0;
    end if;
    if pn_cant > 0 then
        pc_valida :='S';
    end if;

  end Sp_cantidad_segdesemagri;
  Procedure Sp_valida_anterior(pn_ins in number,
                               pn_tipo in number,
                               pc_valida out varchar2)is
  cursor instancias(cta in number,ope in number) is
    select *
      from xwf700
     where xwfcuenta = cta
       and xwfoperacion = ope
       and xwfcar3 <> '1';
  cuenta number := 0;
  operacion number:= 0;
  Begin
       pc_valida := 'N';

    BEgin
      --obtiene cuenta actual
       select xwfcuenta, xwfoperacion
         into cuenta, operacion
         from xwf700
        where xwfprcins = pn_ins
          and xwfcar3 ='1';
       for c in instancias(cuenta, operacion) loop

         Begin
            select 'S'
              into pc_valida
              from jaqm65 b , jaqm66 a
             where b.jaqm65tad = pn_tipo ---1 Agricola, 2 desemplero
               and b.jaqm65ins = c.xwfprcins
               and a.jaqm66ins = b.jaqm65ins
               and a.jaqm66est <>'E';
          exception
            when no_data_found then
              pc_valida := 'N';
            when others then
              pc_valida := 'S';
           end;
        end loop;
     exception
       when others then
         pc_valida := 'N';
     end;
  end Sp_valida_anterior;

  Procedure Sp_valida_periodo(pn_ins in number,
                              pn_tipo in number,
                              pc_periodo out varchar2)is
  Begin

    select b.jaqm65per
      into pc_periodo
      from jaqm65 b , jaqm66 a
     where b.jaqm65tad = pn_tipo ---1 Agricola, 2 desemplero
       and b.jaqm65ins = pn_ins
       and a.jaqm66ins = b.jaqm65ins
       and a.jaqm66est <>'E';
  exception
    when no_data_found then
      pc_periodo := '0';
    when others then
      select b.jaqm65per
      into pc_periodo
      from jaqm65 b , jaqm66 a
     where b.jaqm65tad = pn_tipo ---1 Agricola, 2 desemplero
       and b.jaqm65ins = pn_ins
       and a.jaqm66ins = b.jaqm65ins
       and a.jaqm66est <>'E'
       and rownum = 1;
  end Sp_valida_periodo;

  Procedure Sp_valida_mtoprima(pn_ins in number,
                               pn_tipo in number,
                               pn_mtocre out number,
                               pn_mtopri out number,
                               pn_mtotot out number) is
  mtocre number:= 0;
  mtopri number:= 0;
  mtotot number:= 0;

  Begin
    select a.jaqm66imp, jaqm66ime , jaqm66tim
      into pn_mtocre, pn_mtopri, pn_mtotot
      from jaqm65 b , jaqm66 a
     where b.jaqm65tad = pn_tipo---1 Agricola, 2 desemplero
       and b.jaqm65ins = pn_ins
       and a.jaqm66ins = b.jaqm65ins
       and a.jaqm66est <>'E';

  exception
    when no_data_found then
       pn_mtocre:= 0;
       pn_mtopri := 0;
       pn_mtotot := 0;
  end Sp_valida_mtoprima;
  Procedure Cobros_SegDESAGRI(pd_fechaini in date,
                              pd_fechafin in date,
                              pn_tipo     in number,
                              pc_users    in varchar2) is

  fecha date;
  fechaini date;
  Begin
   --- execute truncate aqpa560;
   -- Execute immediate ('truncate table aqpa560');-- sma.24/01/2025
   DELETE   aqpa560;
    /*+ INDEX(AQPA56001_IDX) */
    ---FROM aqpa560  WHERE AQPA560COD = pn_tipo and aqpa560a4 = pc_users;
   -- delete aqpa560 where aqpa560a4 = pc_users;
    commit;


    begin
    select pgfape into fecha from fst017 where pgcod = 1;
    exception
      when others then
        fecha := trunc(sysdate);
    end;
    fechaini := pd_fechaini;
    if pn_tipo = 1 then -- Agricola
      if pd_fechafin = fecha then
        begin
           INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun ,
                                aqpa560a6)--dni
           select pn_tipo,
                  fecha,
                  f6.ctnro,
                  'SEG.AGRICOLA',
                  (select lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0')
                    from jaqm66 a , jaqm65 b, xwf700 c
                   where b.jaqm65ins = a.jaqm66ins
                     and b.jaqm65ac1 = 'C'
                     and a.jaqm66ins = j6.jaqm66ins
                     and c.xwfprcins = b.jaqm65ins
                     and c.xwfcar3 = '1'),--nro  certificado
                  f6.itimp1,
                  (SELECT SCNOM FROM FST001 where sucurs =  f5.itsuc),
                  (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad = 1 and jaqm64cod = b1.jaqm65cod)
                     from jaqm66 a1 , jaqm65 b1
                    where b1.jaqm65ins = a1.jaqm66ins
                      and a1.jaqm66ins = j6.jaqm66ins
                      and b1.jaqm65ac1 = 'C'),--'motivo',
                  'Soles',
                  (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.ctnro and ttcod= 1 and cttfir = 'T')) ,
                  (select pendoc from fsr008 where ctnro = f6.ctnro and ttcod= 1 and cttfir = 'T'),
                  pc_users,
                  (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and b1.jaqm65ac1 = 'C'
                            and a1.jaqm66ins = j6.jaqm66ins),
                 (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and b1.jaqm65ac1 = 'C'
                            and a1.jaqm66ins = j6.jaqm66ins),
                  f5.itsuc, --COD SUC
                 (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                 (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                    from sng001 where sng001inst = j6.jaqm66ins),
                 (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
            from fsd015 f5,
                 fsd016 f6,
                 jaqm66 j6
           where f5.pgcod = 1
             and f5.itmod = 30
             and f5.itsuc = 11
             and f5.ittran = 440
             and f5.itsuc = 11
             and f5.itfcon  = fecha --pfecha ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
             and f5.itcorr  = 0
             and f5.itcont = 'S'
             and f6.pgcod = f5.pgcod
             and f6.itmod = f5.itmod
             and f6.itsuc = f5.itsuc
             and f6.ittran = f5.ittran
             and f6.itnrel = f5.itnrel
             and f6.rubro = 2514020000020
             and f6.modulo = 260
             and j6.jaqm66cta = f6.ctnro
             and j6.jaqm66ime = f6.itimp1
             and j6.jaqm66hor = f5.ithora;
             commit;
        exception
          when dup_val_on_index then
            null;
        end;
        while fechaini < pd_fechafin loop
          Begin
             INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun,
                                aqpa560a6 )--dni
                 select pn_tipo,
                        fechaini,
                        f6.hcta,
                        'SEG.AGRICOLA',
                        (select (lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0'))
                          from jaqm66 a , jaqm65 b, xwf700 c
                          where b.jaqm65ins = a.jaqm66ins
                           and a.jaqm66ins = j6.jaqm66ins
                           and b.jaqm65ac1 = 'C'
                           and c.xwfprcins = b.jaqm65ins
                           and c.xwfcar3 = '1'),--nro  certificado
                        f6.hcimp1,
                        (SELECT SCNOM FROM FST001 where sucurs =  f5.hsucor),
                        (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad = 1 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'), --'motivo',
                        'Soles',

                        (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T')) ,
                        (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' ),
                        pc_users,
                        (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                         f5.hsucor,
                         (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                         (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                            from sng001 where sng001inst = j6.jaqm66ins) ,
                         (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
              from fsh015 f5,
                   fsh016 f6,
                   jaqm66 j6
             where f5.pgcod = 1
               and f5.hcmod = 30
               and f5.hsucor = 11
               and f5.htran = 440
               and f5.hfcon  = fechaini ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
               and f5.hccorr = 0
               and f6.pgcod = f5.pgcod
               and f6.hcmod = f5.hcmod
               and f6.hsucor = f5.hsucor
               and f6.htran = f5.htran
               and f6.hnrel = f5.hnrel
               and f6.hfcon = f5.hfcon
               and f6.hrubro = 2514020000020
               and f6.hmodul = 260
               and j6.jaqm66cta = f6.HCTA
               and j6.jaqm66ime = f6.HCIMP1
               and j6.jaqm66fea = f6.hfcon;
--               and j6.jaqm66hor = f5.hhora;
               commit;
              fechaini := fechaini + 1;
           exception
             when no_data_found then
               null;
             when dup_val_on_index then
                 null;
           end;
        end loop;
      else
        while fechaini <= pd_fechafin loop
          Begin
             INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                Aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun,
                                Aqpa560a6
                                )--dni
                 select pn_tipo,
                        fechaini,
                        f6.hcta,
                        'SEG.AGRICOLA',
                        (select (lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0'))
                          from jaqm66 a , jaqm65 b, xwf700 c
                         where b.jaqm65ins = a.jaqm66ins
                           and a.jaqm66ins = j6.jaqm66ins
                           and b.jaqm65ac1 = 'C'
                           and c.xwfprcins = b.jaqm65ins
                           and c.xwfcar3 = '1'),--nro  certificado
                        f6.hcimp1,
                        (SELECT SCNOM FROM FST001 where sucurs =  f5.hsucor),
                        (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad = 1 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'), --'motivo',
                        'Soles',

                        (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' and rownum = 1)) ,
                        (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' and rownum = 1),
                        pc_users,
                        (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        f5.hsucor,
                        (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                        (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                            from sng001 where sng001inst = j6.jaqm66ins) ,
                        (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
              from fsh015 f5,
                   fsh016 f6,
                   jaqm66 j6
             where f5.pgcod = 1
               and f5.hcmod = 30
               and f5.hsucor = 11
               and f5.htran = 440
               and f5.hfcon  = fechaini ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
               and f5.hccorr = 0
               and f6.pgcod = f5.pgcod
               and f6.hcmod = f5.hcmod
               and f6.hsucor = f5.hsucor
               and f6.htran = f5.htran
               and f6.hnrel = f5.hnrel
               and f6.hfcon = f5.hfcon
               and f6.hrubro = 2514020000020
               and f6.hmodul = 260
               and j6.jaqm66cta = f6.HCTA
               and j6.jaqm66ime = f6.HCIMP1
               and j6.jaqm66fea = f6.hfcon;
               --and j6.jaqm66hor = f5.hhora;
               commit;
              fechaini := fechaini + 1;
           exception
             when no_data_found then
               null;
             when dup_val_on_index then
                 null;
           end;
        end loop;
      end if;

    else
      -- Aqui para Desempleo cambia el rubro
      if pd_fechafin = fecha then
        begin
           INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560a3, --numero
                                aqpa560a1,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun,
                                aqpa560a6 )--tasa
           select pn_tipo,
                  fecha,
                  f6.ctnro,
                  'SEG.DESEMPLEO',
                  (select lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0')
                    from jaqm66 a , jaqm65 b, xwf700 c
                   where b.jaqm65ins = a.jaqm66ins
                     and b.jaqm65ac1 = 'C'
                     and a.jaqm66ins = j6.jaqm66ins
                     and c.xwfprcins = b.jaqm65ins
                     and c.xwfcar3 = '1'),--nro  certificado
                  f6.itimp1,
                  (SELECT SCNOM FROM FST001 where sucurs = (select c.xwfsucursal
                                                                    from jaqm66 a , jaqm65 b, xwf700 c
                                                                    where b.jaqm65ins = a.jaqm66ins
                                                                     and a.jaqm66ins = j6.jaqm66ins
                                                                     and b.jaqm65ac1 = 'C'
                                                                     and c.xwfprcins = b.jaqm65ins
                                                                     and c.xwfcar3 = '1')),
                  (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad = 2 and jaqm64cod = b1.jaqm65cod)
                     from jaqm66 a1 , jaqm65 b1
                    where b1.jaqm65ins = a1.jaqm66ins
                      and a1.jaqm66ins = j6.jaqm66ins
                      and b1.jaqm65ac1 = 'C'),--'motivo',
                  'Soles',
                  (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.ctnro and ttcod= 1 and cttfir = 'T')) ,
                  (select pendoc from fsr008 where ctnro = f6.ctnro and ttcod= 1 and cttfir = 'T'),
                  pc_users,
                  (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and b1.jaqm65ac1 = 'C'
                            and a1.jaqm66ins = j6.jaqm66ins),
                 (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and b1.jaqm65ac1 = 'C'
                            and a1.jaqm66ins = j6.jaqm66ins),
                   (select (select to_char(jaqm64por)||'%'  from  jaqm64 where jaqm64tad = 2 and jaqm64cod = b1.jaqm65cod)
                     from jaqm66 a1 , jaqm65 b1
                    where b1.jaqm65ins = a1.jaqm66ins
                      and a1.jaqm66ins = j6.jaqm66ins
                      and b1.jaqm65ac1 = 'C'),
                    (select a1.jaqm66per
                     from jaqm66 a1 , jaqm65 b1
                    where b1.jaqm65ins = a1.jaqm66ins
                      and a1.jaqm66ins = j6.jaqm66ins
                      and b1.jaqm65ac1 = 'C'),
                    (select c.xwfsucursal
                       from jaqm66 a , jaqm65 b, xwf700 c
                      where b.jaqm65ins = a.jaqm66ins
                        and a.jaqm66ins = j6.jaqm66ins
                        and b.jaqm65ac1 = 'C'
                        and c.xwfprcins = b.jaqm65ins
                        and c.xwfcar3 = '1'),
                     (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                     (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                            from sng001 where sng001inst = j6.jaqm66ins),
                     (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
            from fsd015 f5,
                 fsd016 f6,
                 jaqm66 j6
           where f5.pgcod = 1
             and f5.itmod = 30
             and f5.itsuc = 11
             and f5.ittran = 441
             and f5.itsuc = 11
             and f5.itfcon  = fecha --pfecha ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
             and f5.itcorr  = 0
             and f5.itcont = 'S'
             and f6.pgcod = f5.pgcod
             and f6.itmod = f5.itmod
             and f6.itsuc = f5.itsuc
             and f6.ittran = f5.ittran
             and f6.itnrel = f5.itnrel
             and f6.rubro = 2514020000022
             and f6.modulo = 260
             and j6.jaqm66cta = f6.ctnro
             and j6.jaqm66ime = f6.itimp1
             and substr(j6.jaqm66hor,1,5) =  substr(f5.ithora,1,5);
             commit;
        exception
          when dup_val_on_index then
            null;
        end;
        while fechaini < pd_fechafin loop
          Begin
             INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560a3, --numero
                                aqpa560a1,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun,
                                aqpa560a6)--tasa
                 select pn_tipo,
                        fechaini,
                        f6.hcta,
                        'SEG.DESEMPLEO',
                        (select (lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0'))
                          from jaqm66 a , jaqm65 b, xwf700 c
                          where b.jaqm65ins = a.jaqm66ins
                           and a.jaqm66ins = j6.jaqm66ins
                           and b.jaqm65ac1 = 'C'
                           and c.xwfprcins = b.jaqm65ins
                           and c.xwfcar3 = '1'),--nro  certificado
                        f6.hcimp1,
                        (SELECT SCNOM FROM FST001 where sucurs = (select c.xwfsucursal
                                                                    from jaqm66 a , jaqm65 b, xwf700 c
                                                                    where b.jaqm65ins = a.jaqm66ins
                                                                     and a.jaqm66ins = j6.jaqm66ins
                                                                     and b.jaqm65ac1 = 'C'
                                                                     and c.xwfprcins = b.jaqm65ins
                                                                     and c.xwfcar3 = '1')),--sucursal
                        (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad =2 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'), --'motivo',
                        'Soles',

                        (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T')) ,
                        (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' ),
                        pc_users,
                        (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select (select to_char(jaqm64por)||'%'  from  jaqm64 where jaqm64tad = 2 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'), ---tasa
                          (select a1.jaqm66per
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),--periodo
                          (select c.xwfsucursal
                             from jaqm66 a , jaqm65 b, xwf700 c
                            where b.jaqm65ins = a.jaqm66ins
                              and a.jaqm66ins = j6.jaqm66ins
                              and b.jaqm65ac1 = 'C'
                              and c.xwfprcins = b.jaqm65ins
                              and c.xwfcar3 = '1'),
                         (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                         (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                            from sng001 where sng001inst = j6.jaqm66ins) ,
                          (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
              from fsh015 f5,
                   fsh016 f6,
                   jaqm66 j6
             where f5.pgcod = 1
               and f5.hcmod = 30
               and f5.hsucor = 11
               and f5.htran = 441
               and f5.hfcon  = fechaini ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
               and f5.hccorr = 0
               and f6.pgcod = f5.pgcod
               and f6.hcmod = f5.hcmod
               and f6.hsucor = f5.hsucor
               and f6.htran = f5.htran
               and f6.hnrel = f5.hnrel
               and f6.hfcon = f5.hfcon
               and f6.hrubro = 2514020000022
               and f6.hmodul = 260
               and j6.jaqm66cta = f6.HCTA
               and j6.jaqm66ime = f6.HCIMP1
               and j6.jaqm66fea = f6.hfcon
               and substr(j6.jaqm66hor,1,5) = substr(f5.hhora ,1,5);
               commit;
              fechaini := fechaini + 1;
            exception
             when no_data_found then
               null;
             when dup_val_on_index then
                 null;
           end;
        end loop;
      else
        while fechaini <= pd_fechafin loop
          Begin
             INSERT INTO AQPA560 (aqpa560cod,
                                aqpa560fec,
                                aqpa560cta,
                                aqpa560pro,
                                aqpa560nroc,
                                aqpa560mto,
                                aqpa560suc,
                                aqpa560mot,
                                aqpa560mda,
                                aqpa560dep,
                                aqpa560a7,
                                aqpa560a4,
                                aqpa560a2,
                                aqpa560a5,
                                aqpa560a3, --numero
                                aqpa560a1,
                                aqpa560age,
                                aqpa560cfun,
                                aqpa560dfun,
                                aqpa560a6)--tasa
                 select pn_tipo,
                        fechaini,
                        f6.hcta,
                        'SEG.DESEMPLEO',
                        (select (lpad(c.xwfcuenta,9,'0')||lpad(c.xwfoperacion,9,'0'))
                          from jaqm66 a , jaqm65 b, xwf700 c
                         where b.jaqm65ins = a.jaqm66ins
                           and a.jaqm66ins = j6.jaqm66ins
                           and b.jaqm65ac1 = 'C'
                           and c.xwfprcins = b.jaqm65ins
                           and c.xwfcar3 = '1'),--nro  certificado
                        f6.hcimp1,
                        (SELECT SCNOM FROM FST001 where sucurs = (select c.xwfsucursal
                                                                    from jaqm66 a , jaqm65 b, xwf700 c
                                                                    where b.jaqm65ins = a.jaqm66ins
                                                                     and a.jaqm66ins = j6.jaqm66ins
                                                                     and b.jaqm65ac1 = 'C'
                                                                     and c.xwfprcins = b.jaqm65ins
                                                                     and c.xwfcar3 = '1')),
                        (select (select jaqm64cod||'-'||trim(jaqm64des) from  jaqm64 where jaqm64tad = 2 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'), --'motivo',
                        'Soles',

                        (select penom from fsd001 where pepais =604 and petdoc= 21 and  pendoc = (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' and rownum = 1)) ,
                        (select pendoc from fsr008 where ctnro = f6.hcta and ttcod= 1 and cttfir = 'T' and rownum = 1),
                        pc_users,
                        (select a1.jaqm66imp
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select a1.jaqm66fea
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                        (select (select to_char(jaqm64por)||'%'  from  jaqm64 where jaqm64tad = 2 and jaqm64cod = b1.jaqm65cod)
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                          (select a1.jaqm66per
                           from jaqm66 a1 , jaqm65 b1
                          where b1.jaqm65ins = a1.jaqm66ins
                            and a1.jaqm66ins = j6.jaqm66ins
                            and b1.jaqm65ac1 = 'C'),
                          (select c.xwfsucursal
                             from jaqm66 a , jaqm65 b, xwf700 c
                            where b.jaqm65ins = a.jaqm66ins
                              and a.jaqm66ins = j6.jaqm66ins
                              and b.jaqm65ac1 = 'C'
                              and c.xwfprcins = b.jaqm65ins
                              and c.xwfcar3 = '1'),
                         (select sng001ase from sng001 where sng001inst = j6.jaqm66ins),
                         (select ( select WFUSRNAME from WFUSERS WHERE WFUSRCOD = sng001ase )
                            from sng001 where sng001inst = j6.jaqm66ins),
                         (select XWFFEC1 from xwf700 where xwfprcins =  j6.jaqm66ins AND XWFCAR3 ='1')
              from fsh015 f5,
                   fsh016 f6,
                   jaqm66 j6
             where f5.pgcod = 1
               and f5.hcmod = 30
               and f5.hsucor = 11
               and f5.htran = 441
               and f5.hfcon  = fechaini ---- la fecha es del domingo pues el proceso se corre el primer domingo --en todo caso `08/08/2021¿ ya estare de vuelta
               and f5.hccorr = 0
               and f6.pgcod = f5.pgcod
               and f6.hcmod = f5.hcmod
               and f6.hsucor = f5.hsucor
               and f6.htran = f5.htran
               and f6.hnrel = f5.hnrel
               and f6.hfcon = f5.hfcon
               and f6.hrubro = 2514020000022
               and f6.hmodul = 260
               and j6.jaqm66cta = f6.HCTA
               and j6.jaqm66ime = f6.HCIMP1
               and j6.jaqm66fea = f6.hfcon
               and substr(j6.jaqm66hor,1,5) = substr(f5.hhora,1,5);
               commit;
              fechaini := fechaini + 1;
           exception
             when no_data_found then
               null;
             when dup_val_on_index then
                 null;
           end;
        end loop;
      end if;
    end if;

  end Cobros_SegDESAGRI ;
  Procedure PlazoCuoata_meses(pn_ins in number,
                              pn_tipo in number,
                              pc_flag out varchar2,
                              pc_periodo out varchar2)is

  plazo1   number:=0;
  fecha    date;
  cuenta   number:=0;
  operacion number:=0;
  fvalor    date;
  mtoprima  number(17,2):=0;
  camtcuotas number:=0;
  periodo   number:=0;
  mod1      number:=0;
  suc1      number:=0;
  subop1    number:=0;
  tipo1     number:=0;
  mda1      number:=0;
  nrocuotas number:=0;
  periodo1  number :=0;
  fcuotauno date;
  nro_meses1 number:=0;
  nro_meses2 number:=0;
  nro_meses3 number:=0;
  nro_dias number:=0;
  meses    number:=0;
  Begin
    BEgin
      select b.jaqm66per, c.xwfplazo1, c.xwffec1, c.xwfcuenta, c.xwfoperacion, c.xwfmodulo, c.xwfsucursal,
             c.xwfsubope, c.xwftipope ,c.xwfmoneda
        into periodo, plazo1, fecha, cuenta, operacion, mod1, suc1, subop1,tipo1,mda1
        from jaqm65 a, xwf700 c, jaqm66 b --,
       where a.jaqm65ins = pn_ins
         and a.jaqm65tad = 2
         and b.jaqm66ins = a.jaqm65ins
         and c.xwfprcins = b.jaqm66ins
         and c.xwfcar3 = '1';
   exception
     when no_data_found then null;
     when too_many_rows then
       select b.jaqm66per, c.xwfplazo1, c.xwffec1, c.xwfcuenta, c.xwfoperacion, c.xwfmodulo, c.xwfsucursal,
             c.xwfsubope, c.xwftipope ,c.xwfmoneda
        into periodo, plazo1, fecha, cuenta, operacion, mod1, suc1, subop1,tipo1,mda1
        from jaqm65 a, xwf700 c, jaqm66 b --,
       where a.jaqm65ins = pn_ins
         and a.jaqm65tad = 2
         and b.jaqm66ins = a.jaqm65ins
         and c.xwfprcins = b.jaqm66ins
         and c.xwfcar3 = '1'
         and rownum > 1;
   end;
   Begin
     select xllfvalor, xllfprimpa, xllcantcuo, xllperiodo
       into fvalor, fcuotauno, nrocuotas, periodo1
       from x054023
      where xllpgcod = 1
        and xllaomod = mod1
        and xllaosuc = suc1
        and xllaomda = mda1
        and xllaopap = 0
        and xllaocta = cuenta
        and xllaooper = operacion
        and xllaosbop = subop1
        and xllaotop = tipo1;
    BEgin
       select fecha - fvalor,
              trunc((fecha - fvalor) / 31),
              trunc((fcuotauno - fvalor) / 31),
              trunc((fecha - fcuotauno) / 31)
         into nro_dias, nro_meses1, nro_meses2, nro_meses3
         from dual;
     if (nro_dias /31) > trunc((nro_dias /31)) then
       meses := trunc((nro_dias /31)) + 1;
     else
        meses := trunc((nro_dias /31));
     end if;

     pc_periodo :=  meses;--round(nro_dias /31);---(nro_meses2+ nro_meses3);

     if nro_meses1 = (nro_meses2+ nro_meses3) then
       pc_flag:= 'S';
     ----  pc_periodo := (nro_meses2+ nro_meses3);
     else
       pc_flag := 'N';
     end if;
    exception
      when no_data_found then
        null;
   end;



   exception
     when no_data_found then
       null;
   end;


  exception
    when no_Data_found then
        null;
  end PlazoCuoata_meses;
  Procedure MtoAdicional_AgriDes(pn_ins in number,
                                 pn_monto out number) is
  begin
    select jaqm66tim
      into pn_monto
      from jaqm66 where jaqm66ins = pn_ins;
  exception
    when no_data_found then
      pn_monto := 0;
  end MtoAdicional_AgriDes;
  Procedure desembolso_desempleo(pn_ins in number,
                                 pc_flag out varchar2) is
  segdesempleo char(1):='N';
  sesion_u char(30);
  Begin
    BEgin
      select 'S'
        into segdesempleo
        from jaqm65 a
       where a.jaqm65ins = pn_ins
         and a.jaqm65tad = 2;

       Begin
         select 'S'
           into pc_flag
           from sng308
          where sng308inst = pn_ins
            and sng300cod = 10;
       exception
         when no_data_found then
               ---------SMA 12062025
            Begin
              SELECT SYS_CONTEXT('USERENV', 'SESSION_USER')
              into  sesion_u  ---Usuario de la sesión actual (normalmente quien se conectó).                    
              FROM dual;
              if trim(sesion_u) = 'NSBTUSER' then
                pc_flag :='S';
              else
                pc_flag :='N';
              end if;
           exception
              when no_Data_Found then
                pc_flag :='E';
           end;
       end;

     exception
       when no_data_found then
         pc_flag :='N';
     end;

  end desembolso_desempleo;
  Procedure PlazoCuoata_meses2(pn_ins in number,
                              pn_tipo in number,
                              pc_flag out varchar2,
                              pc_periodo out varchar2)is

  plazo1   number:=0;
  fecha    date;
  cuenta   number:=0;
  operacion number:=0;
  fvalor    date;
  mtoprima  number(17,2):=0;
  camtcuotas number:=0;
  periodo   number:=0;
  mod1      number:=0;
  suc1      number:=0;
  subop1    number:=0;
  tipo1     number:=0;
  mda1      number:=0;
  nrocuotas number:=0;
  periodo1  number :=0;
  fcuotauno date;
  nro_meses1 number:=0;
  nro_meses2 number:=0;
  nro_meses3 number:=0;
  nro_dias number:=0;
  meses    number:=0;
  Begin
    BEgin
      select b.jaqm66per, c.xwfplazo1, c.xwffec1, c.xwfcuenta, c.xwfoperacion, c.xwfmodulo, c.xwfsucursal,
             c.xwfsubope, c.xwftipope ,c.xwfmoneda
        into periodo, plazo1, fecha, cuenta, operacion, mod1, suc1, subop1,tipo1,mda1
        from jaqm65 a, xwf700 c, jaqm66 b --,
       where a.jaqm65ins = pn_ins
         and a.jaqm65tad = 2
         and b.jaqm66ins = a.jaqm65ins
         and c.xwfprcins = b.jaqm66ins
         and c.xwfcar3 = '1';
   exception
     when no_data_found then null;
     when too_many_rows then
       select b.jaqm66per, c.xwfplazo1, c.xwffec1, c.xwfcuenta, c.xwfoperacion, c.xwfmodulo, c.xwfsucursal,
             c.xwfsubope, c.xwftipope ,c.xwfmoneda
        into periodo, plazo1, fecha, cuenta, operacion, mod1, suc1, subop1,tipo1,mda1
        from jaqm65 a, xwf700 c, jaqm66 b --,
       where a.jaqm65ins = pn_ins
         and a.jaqm65tad = 2
         and b.jaqm66ins = a.jaqm65ins
         and c.xwfprcins = b.jaqm66ins
         and c.xwfcar3 = '1'
         and rownum > 1;
   end;
   Begin
     select xllfvalor, xllfprimpa, xllcantcuo, xllperiodo
       into fvalor, fcuotauno, nrocuotas, periodo1
       from x054023
      where xllpgcod = 1
        and xllaomod = mod1
        and xllaosuc = suc1
        and xllaomda = mda1
        and xllaopap = 0
        and xllaocta = cuenta
        and xllaooper = operacion
        and xllaosbop = subop1
        and xllaotop = tipo1;
        BEgin
           select fecha - fvalor,
                  trunc((fecha - fvalor) / 30.6),
                  trunc((fcuotauno - fvalor) / 30.6),
                  trunc((fecha - fcuotauno) / 30.6)
             into nro_dias, nro_meses1, nro_meses2, nro_meses3
             from dual;
         if (nro_dias /30.6) > trunc((nro_dias /30.6)) then
           meses := trunc((nro_dias /30.6)) + 1;
         else
            meses := trunc((nro_dias /30.6));
         end if;

         pc_periodo :=  meses;--round(nro_dias /31);---(nro_meses2+ nro_meses3);

         if nro_meses1 = (nro_meses2+ nro_meses3) then
           pc_flag:= 'S';
         ----  pc_periodo := (nro_meses2+ nro_meses3);
         else
           pc_flag := 'N';
         end if;
        exception
          when no_data_found then
            null;
       end;
   exception
     when no_data_found then
       null;
   end;
  exception
    when no_Data_found then
        null;
  end PlazoCuoata_meses2;
  Procedure Sp_DesempleoSeg_APP(pn_instancia in number,
                                pc_tisegdes  out varchar2,
                                pc_tisegagri out varchar2,
                                pn_montosegD out number,
                                pn_montosegA out number,
                                pc_tiposegmento out varchar2)is
  ln_pais number(3);
  ln_tdoc number(3);
  lc_ndoc char(12);
  Begin
     pc_tisegdes := 'N';
     pc_tisegagri:= 'N';
     pn_montosegD := 0;
     pn_montosegA := 0;
     pc_tiposegmento :='I';
     bEGIN
       select 'S',a.JAQM66IME
          into pc_tisegdes, pn_montosegD
          from jaqm65 b , jaqm66 a
         where b.jaqm65tad = 2
           and b.jaqm65ins = pn_instancia
           and a.jaqm66ins = b.jaqm65ins
           and a.jaqm66est <>'E';
    exception
        when no_Data_found then
          pc_tisegdes := 'N';
          Begin
            select 'S', a.JAQM66IME
              into pc_tisegagri, pn_montosegA
              from jaqm65 b , jaqm66 a
             where b.jaqm65tad = 1
               and b.jaqm65ins = pn_instancia
               and a.jaqm66ins = b.jaqm65ins
               and a.jaqm66est <>'E';
          exception
            when no_Data_found then
              pc_tisegagri := 'N';
          end;
        when too_many_rows then
          begin
            select 'S',a.JAQM66IME
              into pc_tisegdes, pn_montosegD
              from jaqm65 b , jaqm66 a
             where b.jaqm65tad = 2
               and b.jaqm65ins = pn_instancia
               and a.jaqm66ins = b.jaqm65ins
               and a.jaqm66est <>'E'
               and rownum = 1;
          exception
            when no_data_found then
              null;
          end;
      END;
        ---------------------segmento-----------------------
         begin
          select s.sng001pais, s.sng001tdoc, TRIM(s.sng001ndoc)
            into ln_pais, ln_tdoc, lc_ndoc
            from sng001 s
           where s.sng001inst = pn_instancia;
        exception when others then
            ln_pais :=0;
            ln_tdoc :=0;
            lc_ndoc := null;
        end;


         BEgin
            select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
              into pc_tiposegmento
              from  sngc60
             where sngc60pais = ln_pais
               and sngc60tdoc = ln_tdoc
               and sngc60ndoc = lc_ndoc
               and sngc60corr = 0;
        exception
          when others then
            pc_tiposegmento := 'I';
        end;
         /*   if segmento = 'I' then
              codigocia:= 51;
            else
              codigocia :=50;
           end if;
                                   */
  end Sp_DesempleoSeg_APP;
  Procedure Sp_segmento_desempleo(pn_instancia in number,
                                  pc_tiposegmento out varchar2)is
  ln_pais number(3);
  ln_tdoc number(3);
  lc_ndoc char(12);
  existe char(1);
  Begin
       ---------------------segmento-----------------------
       begin
         select 'S'
           into existe
           from jaqm65
           where jaqm65ins = pn_instancia
             and JAQM65TAD = 2;

       exception
         when others then
           Existe :='N';
       end ;
       if Existe = 'S' then
           begin
            select s.sng001pais, s.sng001tdoc, s.sng001ndoc
              into ln_pais, ln_tdoc, lc_ndoc
              from sng001 s
             where s.sng001inst = pn_instancia;
          exception when others then
              ln_pais :=0;
              ln_tdoc :=0;
              lc_ndoc := null;
          end;


           BEgin
              select DEcode(sngc60ocup, 1,'D',2,'D',8,'D',9,'D','I')
                into pc_tiposegmento
                from  sngc60
               where sngc60pais = ln_pais
                 and sngc60tdoc = ln_tdoc
                 and sngc60ndoc = lc_ndoc
                 and sngc60corr = 0;
          exception
            when others then
              pc_tiposegmento := 'I';
          end;
     else
       pc_tiposegmento :='N';
     end if;
         /*   if segmento = 'I' then
              codigocia:= 51;
            else
              codigocia :=50;
           end if;
                                   */

  end Sp_segmento_desempleo;

end PQ_CR_RESOLUTOR_SEG_DESEMPLEO;
 /* GOLDENGATE_DDL_REPLICATION */
/
