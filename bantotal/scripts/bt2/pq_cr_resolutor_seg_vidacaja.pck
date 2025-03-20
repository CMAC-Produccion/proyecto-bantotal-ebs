create or replace package pq_cr_resolutor_seg_vidacaja is

-- Author  : RMONTESR
-- Created : 24/05/2021 16:01:11
-- Purpose : Paquete para resolutores seguro vida caja
-- Modificacion: SMARQUEZ
-- Creado: 13/08/2021
-- Proposito: Adicion de verificacion de nro de seguros VC tiene el cliente
   procedure sp_cr_clientecampana(pn_insta in numeric, pv_rpta out varchar2);

   procedure sp_cr_validarcampana(pn_insta in numeric, pv_rpta out varchar2);

   procedure sp_cr_seguro_vidacaja(pn_insta in numeric, pv_rpta out varchar2);
   ---------------------------------------------------------------------------
   procedure sp_cr_contador_SegVidaCaja(pn_insta in numeric, pv_rpta out number);

end pq_cr_resolutor_seg_vidacaja;
/

create or replace package body pq_cr_resolutor_seg_vidacaja is
  -----------------------------------------------------------------------------
  procedure sp_cr_clientecampana(pn_insta in numeric, pv_rpta out varchar2) is
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1
         and cttfir = 'T';
  
    ln_conta  numeric;
    ln_conta2 numeric;
    ln_cuenta numeric;
  begin
  
    pv_rpta := 'N';
    begin
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;
    ln_conta2 := 0;
    for i in integrantes(ln_cuenta) loop
      begin
        select count(*)
          into ln_conta
          from CDCCREDITO C
         INNER JOIN C_LOGINGRESO L
            ON C.IDLOGINGRESO = L.IDLOGINGRESO
        
         where rpad(C.DNI,12) = i.pendoc;
      exception
        when others then
          ln_conta := 0;
      end;
      ln_conta2 := ln_conta2 + ln_conta;
    end loop;
    if ln_conta2 > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
  
  end sp_cr_clientecampana;
  -------------------------------------------------------------------------------------------
  procedure sp_cr_validarcampana(pn_insta in numeric, pv_rpta out varchar2) is
    cursor integrantes(cuenta numeric) is
      select *
        from fsr008
       where ctnro = cuenta
         and pgcod = 1
         and cttfir = 'T';
  
    ln_conta  numeric;
    ln_conta2 numeric;
    ln_conta3 numeric;
    ln_cuenta numeric;
    ln_pgcod  numeric;
    ln_mod    numeric;
    ln_suc    numeric;
    ln_mda    numeric;
    ln_pap    numeric;
    ln_cta    numeric;
    ln_ope    numeric;
    ln_sbop   numeric;
    ln_tope   numeric;
    ld_fec    date;
    ln_pais   numeric;
    ln_tdoc   numeric;
    lc_ndoc   char(12);
  begin
  
    pv_rpta := 'N';
    begin
      select sng001cta
        into ln_cuenta
        from sng001
       where sng001inst = pn_insta;
    exception
      when others then
        null;
    end;
    ln_conta2 := 0;
    for i in integrantes(ln_cuenta) loop
      ln_pais := i.pepais;
      ln_tdoc := i.petdoc;
      lc_ndoc := i.pendoc;
      begin
        select count(*)
          into ln_conta
          from CDCCREDITO C
         where rpad(C.DNI,12) = i.pendoc;
      exception
        when others then
          ln_conta := 0;
      end;
      ln_conta2 := ln_conta2 + ln_conta;
    end loop;
    if ln_conta2 > 0 then
      pv_rpta := 'S';
      begin
        select t1.xwfempresa,
               t1.xwfsucursal,
               t1.xwfmodulo,
               t1.xwfmoneda,
               t1.xwfpapel,
               t1.xwfcuenta,
               t1.xwfoperacion,
               t1.xwfsubope,
               t1.xwftipope
          into ln_pgcod,
               ln_suc,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbop,
               ln_tope
          from xwf700 t1
         where t1.xwfprcins = pn_insta
           and t1.xwfcar3 = '1'
           and rownum <= 1;
      end;
      begin
        --Fecha del Sistema
        select pgfape into ld_fec from fst017 where pgcod = 1;
      end;
      begin
        select count(*)
          into ln_conta3
          from aqpa553 t2
         where t2.aqpa553cod = ln_pgcod
           and t2.aqpa553mod = ln_mod
           and t2.aqpa553suc = ln_suc
           and t2.aqpa553mda = ln_mda
           and t2.aqpa553pap = ln_pap
           and t2.aqpa553cta = ln_cta
           and t2.aqpa553ope = ln_ope
           and t2.aqpa553sbo = ln_sbop
           and t2.aqpa553tip = ln_tope;
      end;
      if ln_conta3 >= 1 then
        update aqpa553 t2
           set t2.aqpa553fec = ld_fec, t2.aqpa553est = 'N'
         where t2.aqpa553cod = ln_pgcod
           and t2.aqpa553mod = ln_mod
           and t2.aqpa553suc = ln_suc
           and t2.aqpa553mda = ln_mda
           and t2.aqpa553pap = ln_pap
           and t2.aqpa553cta = ln_cta
           and t2.aqpa553ope = ln_ope
           and t2.aqpa553sbo = ln_sbop
           and t2.aqpa553tip = ln_tope;
        commit;
      else
        insert into aqpa553
          (aqpa553cod,
           aqpa553mod,
           aqpa553suc,
           aqpa553mda,
           aqpa553pap,
           aqpa553cta,
           aqpa553ope,
           aqpa553sbo,
           aqpa553tip,
           aqpa553fec,
           aqpa553pai,
           aqpa553tdo,
           aqpa553ndo,
           aqpa553est,
           aqpa553tpro)
        values
          (ln_pgcod,
           ln_suc,
           ln_mod,
           ln_mda,
           ln_pap,
           ln_cta,
           ln_ope,
           ln_sbop,
           ln_tope,
           ld_fec,
           ln_pais,
           ln_tdoc,
           lc_ndoc,
           'N',
           'C');
        commit;
      end if;
    else
      pv_rpta := 'N';
    end if;
  
  end sp_cr_validarcampana;
  ------------------------------------------------------------------------------
  procedure sp_cr_seguro_vidacaja(pn_insta in numeric,
                                  pv_rpta  out varchar2) is
  begin
    begin
      select gg.sgcod
        into pv_rpta
        from fsd010 ff, fpp001 gg
       where ff.pgcod = gg.pgcod
         and ff.aomod = gg.aomod
         and ff.aosuc = gg.aosuc
         and ff.aomda = gg.aomda
         and ff.aopap = gg.aopap
         and ff.aocta = gg.aocta
         and ff.aooper = gg.aooper
         and ff.aosbop = gg.aosbop
         and ff.aotope = gg.aotope
         and ff.aocta in (SELECT NVL(B1.CTNRO, B1.CTNRO) ---15022017
                            from SNG001 A, FSR008 B1
                           WHERE A.SNG001PAIS = B1.PEPAIS
                             AND A.SNG001TDOC = B1.PETDOC
                             AND A.SNG001NDOC = B1.PENDOC
                             AND A.SNG001INST = pn_insta)
         and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD = 50)
         and ff.aostat <> 99
         and gg.sgcod in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod = 1
                             and Tp1cod1 = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
         and gg.aooper not in (select xwfoperacion
                                 from xwf700
                                where xwfprcins = pn_insta
                                  and xwfcar3 <> '1')
         and rownum <= 1;
    exception
      when others then
        pv_rpta := '';
    end;
  end sp_cr_seguro_vidacaja;

procedure sp_cr_contador_SegVidaCaja(pn_insta in numeric, pv_rpta out number)is
  pn_contador number:=0;
  pn_contador1 number:=0;
  pn_contador2 number:=0;
  pn_contadorDos number:=0;
  pc_flgVC char(1) := 'N';
  lc_seg char(25):= 'VIDA CAJA AHORROS%';
  pn_pais number:=0;
  pn_tdoc number:=0;
  pc_ndoc char(12);

  begin
     begin
       select count(*)
       into pn_contador
       from fsd010 ff,
            fpp001 gg,
            xwf700 xx,
            wfwrkitems  ww
      where ff.pgcod  = gg.pgcod
        and ff.aomod  = gg.aomod
        and ff.aosuc  = gg.aosuc
        and ff.aomda  = gg.aomda
        and ff.aopap  = gg.aopap
        and ff.aocta  = gg.aocta
        and ff.aooper = gg.aooper
        and ff.aosbop = gg.aosbop
        and ff.aotope = gg.aotope
        and ff.aocta in (SELECT NVL (B1.CTNRO, B1.CTNRO)---15022017
                           from SNG001 A,
                                FSR008 B1
                          WHERE A.SNG001PAIS = B1.PEPAIS
                            AND A.SNG001TDOC = B1.PETDOC
                            AND A.SNG001NDOC = B1.PENDOC
                            AND A.SNG001INST = pn_insta
                            )
        and ff.aomod in (SELECT MODULO FROm FST111 WHERE DSCOD=50)
        and ff.aostat <>99
        and gg.sgcod  in (select b2.tp1nro3
                            from fst198 b2
                           Where Tp1cod   = 1
                             and Tp1cod1  = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
         and xx.xwfempresa = ff.pgcod
         and xx.xwfsucursal = ff.aosuc
         and xx.xwfmodulo = ff.aomod
         and xx.XWFMONEDA = ff.aomda
         and xx.Xwfpapel  = ff.aopap
         and xx.XWFCUENTA  = ff.aocta
         and xx.XWFOPERACION = ff.aooper
         and xx.XWFSUBOPE = ff.aosbop
         and xx.XWFTIPOPE = ff.aotope
         and xx.XWFPRCINS <> pn_insta
         and xx.xwfcar3 = '1' --14/10/2021 sma
         and ww.wfinsprcid = xx.xwfprcins
         and ww.wfitemstsact = 1; ---16/02/2022 sma

        select count(*)
          into pn_contador1
          from xwf700 a ,
               fpp001 b,
               sng001 c
         where c.sng001inst = pn_insta
           and c.sng001ori not in (4,3,13)
           and a.xwfprcins = c.sng001inst
      ---   where a.xwfprcins = 
           and a.xwfcar3='1'
           and b.pgcod = a.xwfempresa
           and b.aomod = a.xwfmodulo
           and b.aosuc = a.xwfsucursal
           and b.aomda = a.xwfmoneda
           and b.aopap = a.xwfpapel
           and b.aocta = a.xwfcuenta
           and b.aooper = a.xwfoperacion
           and b.aosbop = a.xwfsubope
           and b.aotope = a.xwftipope
           and b.sgcod in (select b2.tp1nro3
                             from fst198 b2
                            Where Tp1cod = 1
                              and Tp1cod1 = 10898
                              and Tp1corr1 = 18
                              and tp1corr3 = 1);
       /**********************************************************/
       select count(*)
          into pn_contadorDos
          from xwf700 a ,
               fpp001 b,
               sng001 c
         where c.sng001inst = pn_insta
           and c.sng001ori in (4,3,13)
           and a.xwfprcins = c.sng001inst
      ---   where a.xwfprcins = 
           and a.xwfcar3='1'
           and b.pgcod = a.xwfempresa
           and b.aomod = a.xwfmodulo
           and b.aosuc = a.xwfsucursal
           and b.aomda = a.xwfmoneda
           and b.aopap = a.xwfpapel
           and b.aocta = a.xwfcuenta
           and b.aooper = a.xwfoperacion
           and b.aosbop = a.xwfsubope
           and b.aotope = a.xwftipope
           and b.sgcod in (select b2.tp1nro3
                             from fst198 b2
                            Where Tp1cod = 1
                              and Tp1cod1 = 10898
                              and Tp1corr1 = 18
                              and tp1corr3 = 1);
           if  pn_contadorDos <> 0 then             
             pn_contadorDos := pn_contadorDos -1;                   
           else
             pn_contadorDos := 0;
           end if;


     begin
       select sng001pais, sng001tdoc, sng001ndoc
         into pn_pais,pn_tdoc,pc_ndoc
       from sng001  where sng001inst = pn_insta;
     exception
       when no_data_found then
         pn_pais := 0;
     end;
     if pn_pais <> 0 then
       Begin
          pQ_CR_CREDITOS_ALERTAS.SP_CR_TIENE_SEGURO(pn_pais,pn_tdoc,pc_ndoc,lc_seg,pc_flgVC);
       end;
       if pc_flgVC ='S' then
         pn_contador2 := 1;
       end if ;

     end if;
--        and rownum<=1;
     if pn_contador is null then
       pn_contador :=0;
     end if;  
      if pn_contador1 is null then
       pn_contador1 :=0;
     end if;  
      if pn_contador2 is null then
       pn_contador2 :=0;
     end if;    
        pv_rpta := pn_contador + pn_contador1 + pn_contador2 + pn_contadorDos;
     exception
     when others then
       pv_rpta := 0;
     end;



  end sp_cr_contador_Segvidacaja;

end pq_cr_resolutor_seg_vidacaja;
/

