create or replace procedure SP_CR_SEGVIDACAJA(pn_ins  in number,
                                              pc_flgV out varchar2) is

  pn_cantV number(5);
  pn_cantVVS number(5);
begin
  
    --Vida Caja
    begin
    
      select count(*)
        into pn_cantV
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
                             AND A.SNG001INST = pn_ins)
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
                                where xwfprcins = pn_ins
                                  and xwfcar3 <> '1');
    exception
      when others then
        null;
    end;
        
    --Solicitud en vuelo
    begin
      select count(*)
        into pn_cantVVS
        from fpp001 gg, xwf700 h
       where gg.sgcod in (select b.tp1nro3
                            from fst198 b
                           Where Tp1cod = 1
                             and Tp1cod1 = 10898
                             and Tp1corr1 = 18
                             and tp1corr3 = 1)
         and gg.pgcod = h.xwfempresa
         and gg.aomod = h.xwfmodulo
         and gg.aosuc = h.xwfsucursal
         and gg.aomda = h.xwfmoneda
         and gg.aopap = h.xwfpapel
         and gg.aocta = h.xwfcuenta
         and gg.aooper = h.xwfoperacion
         and gg.aosbop = h.xwfsubope
         and gg.aotope = h.xwftipope
         and h.xwfcar3 = '1'
         and h.xwfprcins = pn_ins
         and gg.aooper not in (select xwfoperacion
                                 from xwf700
                                where xwfprcins = pn_ins
                                  and xwfcar3 <> '1');
    exception
      when others then
        null;
    end;
    
    IF pn_cantV >= 1 or pn_cantVVS >= 1  then
      pc_flgV := 'S';
    else
      pc_flgV := 'N';
    end if;
  
  end SP_CR_SEGVIDACAJA;
/

