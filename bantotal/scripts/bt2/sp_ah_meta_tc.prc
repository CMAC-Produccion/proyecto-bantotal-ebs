create or replace procedure SP_AH_META_TC(P_N_FECINI IN DATE,
                                          P_N_FECFIN IN DATE,
                                          P_N_SUCURS IN NUMBER,
                                          P_N_USUR   IN VARCHAR2) is
  -- ***************************************************************************************
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_META_TC
  -- Sistema                    : BANTOTAL
  -- Módulo                     : OPERACIONES
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2017.06.19
  -- Autor de Creación          : SMARQUEZ
  -- Uso                        : REPORTE POR METAS PARA OPERACIONES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.12.04
  -- Modificado                 : CVILLON
  -- Descripción                : TRANSACCCIONES BIMONEDA
  -- ***************************************************************************************
  -- ***************************************************************************************

  CURSOR DATOHIST(SUC IN NUMBER, fecha in date) IS
    select a.hfcon,
           (Select scnom
              from fst001
             where pgcod = 1
               and sucurs = a.hsucor) sucursal,
           a.hcmod,
           a.htran,
           a.hcodmo,
           a.hcimp1,
           b.hhora,
           (select NVL(exusau, ' ')
              from fsh010 s
             where s.Pgcod = 1
               and s.Hcmod = b.hcmod
               and s.Hsucor = b.hsucor
               and s.Htran = b.htran
               and s.Hnrel = b.hnrel
               and s.Hfcont = b.hfcon
               and s.Hcsubo = 1
               and s.Excod = 3
               and s.Exstat = 'S') autoriza
      from fsh016 a, fsh015 b
     where a.pgcod = 1
       and a.hcmod = 50
       and a.hsucor = SUC ---sucursal
       and a.hfcon = fecha --between P_N_FECINI and P_N_FECFIN sma 04022025
       and a.hcord > 97
       and a.hrubro = '2928090100001'
       and a.hmodul = 496
       and a.hmda = 101
       and a.hcta = 0
       and a.htran in (536, 535)
       and a.hnrel > 0
       and a.hsucor > 0
       and b.pgcod = a.pgcod
       and b.hcmod = a.hcmod
       and b.hsucor = a.hsucor
       and b.htran = a.htran
       and b.hnrel = a.hnrel
       and b.hfcon = a.hfcon
       and b.hccorr = 0
    --order by 2, 1;
    ---***
    union
    ---***
    select a.hfcon,
           (Select scnom
              from fst001
             where pgcod = 1
               and sucurs = a.hsucor) sucursal,
           a.hcmod,
           a.htran,
           a.hcodmo,
           a.hcimp1,
           b.hhora,
           (select NVL(exusau, ' ')
              from fsh010 s
             where s.Pgcod = 1
               and s.Hcmod = b.hcmod
               and s.Hsucor = b.hsucor
               and s.Htran = b.htran
               and s.Hnrel = b.hnrel
               and s.Hfcont = b.hfcon
               and s.Hcsubo = 1
               and s.Excod = 3
               and s.Exstat = 'S') autoriza
      from fsh016 a, fsh015 b
     where a.pgcod = 1
       and a.hcmod = 21
       and a.hsucor = SUC ---sucursal
       and a.hfcon = fecha --between P_N_FECINI and P_N_FECFIN sma 04022025
       and a.hcord > 97
       and a.hrubro = '2928090100001'
       and a.hmodul = 496
       and a.hmda = 101
       and a.hcta = 0
       and a.htran = 31
       and a.hnrel > 0
       and a.hsucor > 0
       and b.pgcod = a.pgcod
       and b.hcmod = a.hcmod
       and b.hsucor = a.hsucor
       and b.htran = a.htran
       and b.hnrel = a.hnrel
       and b.hfcon = a.hfcon
       and b.hccorr = 0;
  --order by 2, 1;

  cursor sucursal is
    select * from fst001 where sucurs < 800;

  cursor DatosHoy(sucu in number) is
    select b.itfcon,
           (Select scnom
              from fst001
             where pgcod = 1
               and sucurs = a.itsuc) sucursal,
           a.itmod,
           a.ittran,
           a.itcodm,
           a.itimp1,
           b.ithora,
           (select exusau
              from fsh010 s
             where s.Pgcod = 1
               and s.Hcmod = b.itmod
               and s.Hsucor = b.itsuc
               and s.Htran = b.ittran
               and s.Hnrel = b.itnrel
               and s.Hfcont = b.itfcon
               and s.Hcsubo = 1
               and s.Excod = 3
               and s.Exstat = 'S') autoriza
      from fsd016 a, fsd015 b --PGCOD, ITSUC, ITMOD, ITTRAN, ITNREL
     where a.pgcod = 1
       and a.itsuc = SUCU ---sucursal
       and a.itmod = 50
       and a.ittran in (535, 536)
       and a.itord > 97
       and a.rubro = '2928090100001'
       and a.modulo = 496
       and a.moneda = 101
          /*        and a.ctnro = 0 
          and a.ittran > 0 
          and a.itnrel > 0*/
       and b.pgcod = a.pgcod
       and b.itsuc = a.itsuc
       and b.itmod = a.itmod
       and b.ittran = a.ittran
       and b.itnrel = a.itnrel
       and b.itfcon = P_N_FECFIN
       and b.itcorr = 0
       and b.itcont = 'S'
    --order by 2, 1;
    ---***
    union
    ---***
    select b.itfcon,
           (Select scnom
              from fst001
             where pgcod = 1
               and sucurs = a.itsuc) sucursal,
           a.itmod,
           a.ittran,
           a.itcodm,
           a.itimp1,
           b.ithora,
           (select exusau
              from fsh010 s
             where s.Pgcod = 1
               and s.Hcmod = b.itmod
               and s.Hsucor = b.itsuc
               and s.Htran = b.ittran
               and s.Hnrel = b.itnrel
               and s.Hfcont = b.itfcon
               and s.Hcsubo = 1
               and s.Excod = 3
               and s.Exstat = 'S') autoriza
      from fsd016 a, fsd015 b --PGCOD, ITSUC, ITMOD, ITTRAN, ITNREL
     where a.pgcod = 1
       and a.itsuc = SUCU ---sucursal
       and a.itmod = 21
       and a.ittran = 31
       and a.itord > 97
       and a.rubro = '2928090100001'
       and a.modulo = 496
       and a.moneda = 101
          /*        and a.ctnro = 0 
          and a.ittran > 0 
          and a.itnrel > 0*/
       and b.pgcod = a.pgcod
       and b.itsuc = a.itsuc
       and b.itmod = a.itmod
       and b.ittran = a.ittran
       and b.itnrel = a.itnrel
       and b.itfcon = P_N_FECFIN
       and b.itcorr = 0
       and b.itcont = 'S';
  --order by 2, 1;

  fecha     date;
  usuario   char(10) := P_N_USUR;
  fecha_ini date;
begin
  execute immediate 'alter session set "_optimizer_batch_table_access_by_rowid" =false';
  delete jaqz552 where jaqz552AUT = usuario;
  commit;

  select pgfape into fecha from FST017 WHERE pgcod = 1;
  fecha_ini := P_N_FECINI;
  if P_N_SUCURS = 0 then
  
    ----- CAMBIO AQUI-----
    while fecha_ini <= P_N_FECFIN loop
      for reg in sucursal loop
        for dat in DATOHIST(reg.sucurs, fecha_ini) loop
          insert into JAQZ552
            (jaqz552cor,
             jaqz552fech,
             jaqz552suc,
             jaqz552mod,
             jaqz552tran,
             jaqz552itcom,
             jaqz552imp,
             jaqz552hro,
             jaqz552user,
             jaqz552aut)
          values
            (SQ_AH_JAQZ552.NEXTVAL,
             dat.hfcon,
             dat.sucursal,
             dat.hcmod,
             dat.htran,
             dat.hcodmo,
             dat.hcimp1,
             dat.hhora,
             dat.autoriza,
             P_N_USUR);
        
        end loop;
        commit;
      end loop;
      fecha_ini := fecha_ini + 1;
    end loop;
    IF P_N_FECFIN = fecha THEN
      for reg in sucursal loop
        for dia in DatosHoy(reg.sucurs) loop
          insert into JAQZ552
            (jaqz552cor,
             jaqz552fech,
             jaqz552suc,
             jaqz552mod,
             jaqz552tran,
             jaqz552itcom,
             jaqz552imp,
             jaqz552hro,
             jaqz552user,
             jaqz552aut)
          values
            (SQ_AH_JAQZ552.NEXTVAL,
             dia.itfcon,
             dia.sucursal,
             dia.itmod,
             dia.ittran,
             dia.itcodm,
             dia.itimp1,
             dia.ithora,
             dia.autoriza,
             P_N_USUR);
        end loop;
        COMMIT;
      end loop;
    END IF;
  
  else
    --cambio aqui---
    while fecha_ini <= P_N_FECFIN loop
      For dat in datohist(p_n_sucurs, fecha_ini) loop
        insert into JAQZ552
          (jaqz552cor,
           jaqz552fech,
           jaqz552suc,
           jaqz552mod,
           jaqz552tran,
           jaqz552itcom,
           jaqz552imp,
           jaqz552hro,
           jaqz552user,
           jaqz552aut)
        values
          (SQ_AH_JAQZ552.NEXTVAL,
           dat.hfcon,
           dat.sucursal,
           dat.hcmod,
           dat.htran,
           dat.hcodmo,
           dat.hcimp1,
           dat.hhora,
           dat.autoriza,
           P_N_USUR);
      end loop;
      commit;
      fecha_ini := fecha_ini + 1;
    end loop;
    if P_N_FECFIN = fecha then
      for dia in DatosHoy(p_n_sucurs) loop
        insert into JAQZ552
          (jaqz552cor,
           jaqz552fech,
           jaqz552suc,
           jaqz552mod,
           jaqz552tran,
           jaqz552itcom,
           jaqz552imp,
           jaqz552hro,
           jaqz552user,
           jaqz552aut)
        values
          (SQ_AH_JAQZ552.NEXTVAL,
           dia.itfcon,
           dia.sucursal,
           dia.itmod,
           dia.ittran,
           dia.itcodm,
           dia.itimp1,
           dia.ithora,
           dia.autoriza,
           P_N_USUR);
      end loop;
      commit;
    end if;
  end if;

end SP_AH_META_TC;
/
