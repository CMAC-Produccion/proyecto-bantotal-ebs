create or replace procedure SP_AH_TCPREFERENCIAL(lc_usuario in varchar2,
                                                 ld_fecini  in date,
                                                 ld_fecfin  in date,
                                                 lc_sucurs  in number) is
  CURSOR SUCURSAL IS
    SELECT *
      FROM FST001
     WHERE SUCURS <800;

 CURSOR DHISTORICO (suc1 in number) IS
     select a.hfcont fecha,
                decode(a.htran, 535, 'COMPRA', 'VENTA') Tran,
                'Dolares' moneda1,
                decode(c.hctcbi,0,0,(c.hcimp1 / c.hctcbi)) importe,
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
                a.exusau UAUTO,
                Decode(a.excod, 20, 'Agencia', 'Tesorería') Autoriza,
                (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 6 ) as dni,
                (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 5 ) as nombre,
                   NVL((SELECT 1 FROM FSD002  WHERE PFPAIS = 604 AND PFTDOC = 21 and pfndoc = (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 6 )
                    AND PFEBCO = 'S'),0) trabajador,
                    a.EXCOD codigo,
             c.* ---PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCONT, HCORD, HCSUBO, EXCOD
           from fsh010 a, fsh015 b, fsh016 c
          where a.pgcod = 1
            and a.hcmod = 50
            and a.hsucor = SUC1 ---sucursal cursor
            and a.htran in (535, 536)
            and a.hfcont between ld_fecini and ld_fecfin--'30/06/2016'
            and a.HCSUBO = 1
            and a.EXCOD in (20, 49)
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
            and c.hmodul = 50
            and c.hctcbi > 0;

  CURSOR DIARIO (SUC IN NUMBER) IS
         select a.hfcont fecha,
                decode(a.htran, 535, 'COMPRA', 'VENTA') Tran,
                'Dolares' moneda1,
                ---decode(a.htran,535,c.itimp1,(c.itimp1 / c.ittcbi)) importe,
                decode(c.ittcbi,0,0,(c.itimp1 / c.ittcbi)) importe,
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
                a.exusau UAUTO,
                Decode(a.excod, 20, 'Agencia', 'Tesorería') Autoriza,
                (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 6 ) as dni,
                (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 5 ) as nombre,
                NVL((SELECT 1 FROM FSD002  WHERE PFPAIS = 604 AND PFTDOC = 21 and pfndoc = (select trim(txtord)
                   from fsx016
                  where pgcod = a.pgcod
                    and hcmod = a.hcmod
                    and hsucor = a.hsucor
                    and htran = a.htran
                    and hnrel = a.hnrel
                    and  hfcon = a.hfcont
                    and txcod = 6 )
                    AND PFEBCO = 'S'),0) trabajador,
                a.EXCOD codigo,
                c.* ---PGCOD, HCMOD, HSUCOR, HTRAN, HNREL, HFCONT, HCORD, HCSUBO, EXCOD
           from fsh010 a, fsd015 b, fsd016 c
          where a.pgcod = 1
            and a.hcmod = 50
            and a.hsucor = SUC ---sucursal cursor
            and a.htran in (535, 536)
            and a.hfcont = ld_fecfin---'25/04/2017' --between '18/04/2017' and '18/04/2017'
            and a.HCSUBO = 1
            and a.EXCOD in (20, 49)
            and a.exstat = 'S' --colocarlo para despues
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
            and c.ittcbi > 0;

   NOMAGE CHAR(30);
   fechahoy date;
   USUARIO CHAR(10);
   trabajador number := 0;

begin
  select pgfape
    into fechahoy
    from fst017
    where pgcod = 1;

  USUARIO := lc_usuario ;
  DELETE JAQY699 WHERE JAQY699AU5 = USUARIO;--- lc_usuario;
  COMMIT;
  IF lc_sucurs = 0 THEN
    fOR REG IN SUCURSAL LOOP
      for his in DHISTORICO(reg.sucurs) loop
        Begin
          SELECT 1
            into trabajador
            FROM FSD002
           WHERE PFPAIS = 604
             AND PFTDOC = 21
             and pfndoc = rpad(his.dni,12,' ')
             AND PFEBCO = 'S';
        exception
          when no_data_found then
            trabajador := 0;
        end;

        INSERT INTO JAQY699 (jaqy699cod,
                                    jaqy699suc,
                                    jaqy699snom,
                                    jaqy699fech,
                                    jaqy699tran,
                                    jaqy699mda,
                                    jaqy699imp,
                                    jaqy699pre,
                                    jaqy699piz,
                                    jaqy699usu,
                                    JAQY699AU4,
                                    JAQY699AU5,
                                    jaqy699au7,
                                    jaqy699au8,
                                    jaqy699au1,
                                    jaqy699au2  )
                             VALUES(SQ_AH_JAQY699.NEXTVAL,
                                    REG.SUCURS,
                                    REG.SCNOM,
                                    his.FECHA,
                                    his.TRAN,
                                    his.MONEDA1,
                                    his.IMPORTE,
                                    his.PREFERENCIAL,
                                    his.PIZARRA,
                                    his.UAUTO,
                                    his.AUTORIZA,
                                    lc_usuario,
                                    his.dni,
                                    his.nombre,
                                    trabajador,
                                    his.codigo
                                    );
      end loop;
      commit;
      if fechahoy = ld_fecfin then
          FOR DIA IN DIARIO(REG.SUCURS) LOOP
            Begin
              SELECT 1
                into trabajador
                FROM FSD002
               WHERE PFPAIS = 604
                 AND PFTDOC = 21
                 and pfndoc = rpad(dia.dni,12,' ')
                 AND PFEBCO = 'S';
            exception
              when no_data_found then
                trabajador := 0;
            end;
               INSERT INTO JAQY699 (jaqy699cod,
                                    jaqy699suc,
                                    jaqy699snom,
                                    jaqy699fech,
                                    jaqy699tran,
                                    jaqy699mda,
                                    jaqy699imp,
                                    jaqy699pre,
                                    jaqy699piz,
                                    jaqy699usu,
                                    JAQY699AU4,
                                    JAQY699AU5,
                                    JAQY699AU7,
                                    jaqy699au8,
                                    jaqy699au1,
                                    JAQY699AU2)
                             VALUES(SQ_AH_JAQY699.NEXTVAL,
                                    REG.SUCURS,
                                    REG.SCNOM,
                                    DIA.FECHA,
                                    DIA.TRAN,
                                    DIA.MONEDA1,
                                    DIA.IMPORTE,
                                    DIA.PREFERENCIAL,
                                    DIA.PIZARRA,
                                    DIA.UAUTO,
                                    DIA.AUTORIZA,
                                    lc_usuario,
                                    dia.dni,
                                    dia.nombre,
                                    trabajador,
                                    dia.codigo
                                    );
          END LOOP;
          COMMIT;
       end if;
    END LOOP;
  ELSE
    SELECT SCNOM INTO NOMAGE FROM FST001 WHERE SUCURS = lc_sucurs;
    for his in DHISTORICO(lc_sucurs) loop
        Begin
          SELECT 1
            into trabajador
            FROM FSD002
           WHERE PFPAIS = 604
             AND PFTDOC = 21
             and pfndoc = rpad(his.dni,12,' ')
             AND PFEBCO = 'S';
        exception
          when no_data_found then
            trabajador := 0;
        end;
        INSERT INTO JAQY699 (jaqy699cod,
                                    jaqy699suc,
                                    jaqy699snom,
                                    jaqy699fech,
                                    jaqy699tran,
                                    jaqy699mda,
                                    jaqy699imp,
                                    jaqy699pre,
                                    jaqy699piz,
                                    jaqy699usu,
                                    JAQY699AU4,
                                    JAQY699AU5,
                                    JAQY699AU7,
                                    jaqy699au8,
                                    jaqy699au1,
                                    jaqy699au2)
                             VALUES(SQ_AH_JAQY699.NEXTVAL,
                                    lc_sucurs,
                                    NOMAGE,
                                    his.FECHA,
                                    his.TRAN,
                                    his.MONEDA1,
                                    his.IMPORTE,
                                    his.PREFERENCIAL,
                                    his.PIZARRA,
                                    his.UAUTO,
                                    his.AUTORIZA,
                                    lc_usuario,
                                    his.dni,
                                    his.nombre,
                                    trabajador,
                                    his.codigo
                                    );
      end loop;
      commit;
    if  fechahoy = ld_fecfin then
        FOR DIA IN DIARIO(lc_sucurs) LOOP
           Begin
              SELECT 1
                into trabajador
                FROM FSD002
               WHERE PFPAIS = 604
                 AND PFTDOC = 21
                 and pfndoc = rpad(dia.dni,12,' ')
                 AND PFEBCO = 'S';
            exception
              when no_data_found then
                trabajador := 0;
            end;
           INSERT INTO JAQY699 (jaqy699cod,
                                jaqy699suc,
                                jaqy699snom,
                                jaqy699fech,
                                jaqy699tran,
                                jaqy699mda,
                                jaqy699imp,
                                jaqy699pre,
                                jaqy699piz,
                                jaqy699usu,
                                JAQY699AU4,
                                JAQY699AU5,
                                JAQY699AU7,
                                jaqy699au8,
                                jaqy699au1,
                                jaqy699au2)
                         VALUES(SQ_AH_JAQY699.NEXTVAL,
                                lc_sucurs,
                                NOMAGE,
                                DIA.FECHA,
                                DIA.TRAN,
                                DIA.MONEDA1,
                                DIA.IMPORTE,
                                DIA.PREFERENCIAL,
                                DIA.PIZARRA,
                                DIA.UAUTO,
                                DIA.AUTORIZA,
                                lc_usuario,
                                dia.dni,
                                dia.nombre,
                                trabajador,
                                dia.codigo
                                );

        END LOOP;
        COMMIT;
     end if;
  END IF;

end SP_AH_TCPREFERENCIAL;
/

