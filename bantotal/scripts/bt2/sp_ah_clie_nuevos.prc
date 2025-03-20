create or replace procedure sp_ah_clie_nuevos(P_C_FECPRO in varchar2) is

  cursor c_personas is
  select b.pepais, b.petdoc, b.pendoc
    from fsd011 a,
         fsr008 b
   where a.pgcod = b.pgcod
     and a.sccta = b.ctnro
     and a.scmod = 21
     and b.ttcod = 1
     and a.pgcod = 1
     and (a.scfval = a.scfcon and a.scfcon = to_date(P_C_FECPRO,'dd/mm/yy')
           or
          (a.scfval!= a.scfcon and a.scfcon = to_date(P_C_FECPRO,'dd/mm/yy') /*and a.scstat not in (99,81)*/)
         )
     and a.scfcon <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
     and a.scfval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
  union
  select b.pepais, b.petdoc, b.pendoc
    from fsd010 a,
         fsr008 b
   where a.pgcod = b.pgcod
     and a.aocta = b.ctnro
     and a.aomod = 22
     and a.aofval = to_date(P_C_FECPRO,'dd/mm/yy')
     and a.aosbop = 0
     and b.ttcod = 1
     and a.pgcod = 1;

  lc_flag char(1);
  ln_numape number:=0;
  ln_numcue number:=0;
  ln_numact number:=0;
  lc_cuevig number:=0;
  lc_numdoc char(12);
  ln_jaql106mod number(9):=0;
  ln_jaql106suc number(9):=0;
  ln_jaql106mda number(9):=0;
  ln_jaql106pap number(9):=0;
  ln_jaql106cta number(9):=0;
  ln_jaql106ope number(9):=0;
  ln_jaql106sbo number(9):=0;
  ln_jaql106top number(9):=0;

begin
  delete from jaql106 where jaql106fhc = to_date(P_C_FECPRO,'dd/mm/yy');
  commit;

    for i in c_personas loop
        lc_flag := 'S';
        ln_numape :=0;
        ln_numcue :=0;
        ln_numact :=0;
        lc_cuevig :=0;
        ln_jaql106mod :=0;
        ln_jaql106suc :=0;
        ln_jaql106mda :=0;
        ln_jaql106pap :=0;
        ln_jaql106cta :=0;
        ln_jaql106ope :=0;
        ln_jaql106sbo :=0;
        ln_jaql106top :=0;
        begin    -- AVERIGUAMOS SI TUVO APERTURAS EN EL DIA
            select x.scmod,x.scsuc,x.scmda,x.scpap,x.sccta,x.scoper,x.scsbop,x.sctope
              into ln_jaql106mod,ln_jaql106suc,ln_jaql106mda,ln_jaql106pap,ln_jaql106cta,ln_jaql106ope,ln_jaql106sbo,ln_jaql106top
              from (select a.SCMOD,a.SCSUC,a.SCMDA,a.SCPAP,a.SCCTA,a.SCOPER,a.SCSBOP,a.SCTOPE
                      from fsd011 a, fsr008 b
                     where a.pgcod = b.pgcod
                       and a.sccta = b.ctnro
                       and b.pepais = i.pepais
                       and b.petdoc = i.petdoc
                       and b.pendoc = i.pendoc
                       and a.scfval = a.scfcon
                       and a.scfcon = to_date(P_C_FECPRO, 'dd/mm/yy')
                       and a.scmod = 21
                       and b.ttcod = 1
                       and a.pgcod = 1
                    union
                    select a.AOMOD,a.AOSUC,a.AOMDA,a.AOPAP,a.AOCTA,a.AOOPER,a.AOSBOP,a.AOTOPE
                      from fsd010 a, fsr008 b
                     where a.pgcod = b.pgcod
                       and a.aocta = b.ctnro
                       and b.pepais = i.pepais
                       and b.petdoc = i.petdoc
                       and b.pendoc = i.pendoc
                       and a.aofval = to_date(P_C_FECPRO, 'dd/mm/yy')
                       and a.aomod = 22
                       and a.aosbop = 0
                       and b.ttcod = 1
                       and a.pgcod = 1
                       ) x
                 where rownum = 1;
            ln_numape := 1;
        exception
        when no_data_found then
             ln_numape := 0;
        end;

        if ln_numape > 0 then --si hubo aperturas entonces verificar que no tenga mas cuentas ni vigentes ni canceladas
                     begin
                          select count(1)
                            into ln_numcue
                            from
                            (
                              select a.sccta
                                from fsd011 a,
                                     fsr008 b
                               where a.pgcod = b.pgcod
                                 and a.sccta = b.ctnro
                                 and b.pepais = i.pepais
                                 and b.petdoc = i.petdoc
                                 and b.pendoc = i.pendoc
                                 and (a.scfval <> to_date(P_C_FECPRO,'dd/mm/yy')
                                     or
                                     a.scfcon <> to_date(P_C_FECPRO,'dd/mm/yy')
                                     )
                                 and a.scfval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                                 and a.scfcon <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                                 and a.scmod  in ('21')
                                 and a.pgcod = 1
                                 and b.ttcod = 1
                             union
                                select a.aocta
                                  from fsd010 a,
                                       fsr008 b
                                 where a.pgcod = b.pgcod
                                   and a.aocta = b.ctnro
                                   and b.pepais = i.pepais
                                   and b.petdoc = i.petdoc
                                   and b.pendoc = i.pendoc
                                   and a.aofval <> to_date(P_C_FECPRO,'dd/mm/yy')
                                   and a.aofval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                                   and a.aomod  = 22
                                   and b.ttcod = 1
                                   and a.pgcod = 1
                             );
                     end;
                     if  ln_numcue > 0 then
                         lc_flag := 'N';
                     else --CUMPLE Y DEBE REGISTRARSE COMO NUEVO POR APERTURA

                           begin
                           insert into jaql106(JAQL106PAI,
                                               JAQL106TDO,
                                               JAQL106DOC,
                                               JAQL106PGC,
                                               JAQL106MOD,
                                               JAQL106SUC,
                                               JAQL106MDA,
                                               JAQL106PAP,
                                               JAQL106CTA,
                                               JAQL106OPE,
                                               JAQL106SBO,
                                               JAQL106TOP,
                                               JAQL106FHC,
                                               JAQL106A01
                                               )
                                               values
                                               (i.pepais,
                                                i.petdoc,
                                                i.pendoc,
                                                1,
                                                ln_jaql106mod,
                                                ln_jaql106suc,
                                                ln_jaql106mda,
                                                ln_jaql106pap,
                                                ln_jaql106cta,
                                                ln_jaql106ope,
                                                ln_jaql106sbo,
                                                ln_jaql106top,
                                                to_date(P_C_FECPRO,'dd/mm/yy'),
                                                1
                                               );
                           exception
                           when others then
                                null;
                           end;
                           commit;
                     end if;

        else --NO TUBO APERTURAS EN EL DIA, VERIFICAR SI TU ACTIVACIONES EN EL DIA Y QUE EL RESTO DE SUS CUENTAS ESTEN CANCELADAS

                    begin
                      select a.scmod,a.scsuc,a.scmda,a.scpap,a.sccta,a.scoper,a.scsbop,a.sctope
                        into ln_jaql106mod,ln_jaql106suc,ln_jaql106mda,ln_jaql106pap,ln_jaql106cta,ln_jaql106ope,ln_jaql106sbo,ln_jaql106top
                        from fsd011 a,
                             fsr008 b
                       where a.pgcod = b.pgcod
                         and a.sccta = b.ctnro
                         and b.pepais = i.pepais
                         and b.petdoc = i.petdoc
                         and b.pendoc = i.pendoc
                         and (a.scfval <> to_date(P_C_FECPRO,'dd/mm/yy')
                             or
                             a.scfcon <> to_date(P_C_FECPRO,'dd/mm/yy')
                             )
                         and a.scfcon = to_date(P_C_FECPRO,'dd/mm/yy')
                         and a.scfval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                         and a.scfcon <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                         and a.scmod = 21
                         and a.pgcod = 1
                         and b.ttcod = 1
                         and a.scstat <> 81
                         and rownum = 1;

                         ln_numact := 1;
                    exception
                    when no_data_found then
                    ln_numact := 0;
                    end;
              if ln_numact > 0 then --verificar que el resto de sus cuentas esten canceladas
                      begin
                          select COUNT(1)
                            into lc_cuevig
                            from (
                            select a.pgcod
                              from fsd011 a,
                                   fsr008 b
                             where a.pgcod = b.pgcod
                               and a.sccta = b.ctnro
                               and b.pepais = i.pepais
                               and b.petdoc = i.petdoc
                               and b.pendoc = i.pendoc
                               and (a.scfval <> to_date(P_C_FECPRO,'dd/mm/yy')
                                   or
                                   a.scfcon <> to_date(P_C_FECPRO,'dd/mm/yy')
                                   )
                               and a.scfcon <  to_date(P_C_FECPRO,'dd/mm/yy')
                               and a.scfval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                               and a.scfcon <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                               and a.scmod  = 21
                               and b.ttcod = 1
                               and a.pgcod = 1
                               and a.scstat <> 99
                            union
                            select a.pgcod
                              from fsd010 a,
                                   fsr008 b
                             where a.pgcod = b.pgcod
                               and a.aocta = b.ctnro
                               and b.pepais = i.pepais
                               and b.petdoc = i.petdoc
                               and b.pendoc = i.pendoc
                               and a.aofval <> to_date(P_C_FECPRO,'dd/mm/yy')
                               and a.aofval <= to_date(P_C_FECPRO,'dd/mm/yy') -- ESTA CONDICION SOLO PARA CORRER PARA FECHAS DIFERENTE AL DIA ACTUAL
                               and a.aomod  = 22
                               and b.ttcod = 1
                               and a.pgcod = 1
                               and a.aostat <> 99
                             );

                      end;
                      if lc_cuevig > 0 then
                         lc_flag := 'N';
                      else  --CUMPLE Y DEBE DE REGISTRARSE COMO NUEVO POR ACTIVACION
                         begin
                         insert into jaql106(JAQL106PAI,
                                             JAQL106TDO,
                                             JAQL106DOC,
                                             JAQL106PGC,
                                             JAQL106MOD,
                                             JAQL106SUC,
                                             JAQL106MDA,
                                             JAQL106PAP,
                                             JAQL106CTA,
                                             JAQL106OPE,
                                             JAQL106SBO,
                                             JAQL106TOP,
                                             JAQL106FHC,
                                             JAQL106A01
                                             )
                                             values
                                             (i.pepais,
                                              i.petdoc,
                                              i.pendoc,
                                              1,
                                              ln_jaql106mod,
                                              ln_jaql106suc,
                                              ln_jaql106mda,
                                              ln_jaql106pap,
                                              ln_jaql106cta,
                                              ln_jaql106ope,
                                              ln_jaql106sbo,
                                              ln_jaql106top,
                                              to_date(P_C_FECPRO,'dd/mm/yy'),
                                              2
                                             );
                         exception
                         when dup_val_on_index then
                           begin
                                --insert into CRDTCAP(c_descri1,c_descri2,c_descri3,c_descri4) values(i.pepais,i.petdoc,i.pendoc,2);
                                lc_numdoc := i.pendoc;
                                update JAQL106
                                   set JAQL106FHC = to_date(P_C_FECPRO,'dd/mm/yy'),
                                       JAQL106PGC = 1,
                                       JAQL106MOD = ln_jaql106mod,
                                       JAQL106SUC = ln_jaql106suc,
                                       JAQL106MDA = ln_jaql106mda,
                                       JAQL106PAP = ln_jaql106pap,
                                       JAQL106CTA = ln_jaql106cta,
                                       JAQL106OPE = ln_jaql106ope,
                                       JAQL106SBO = ln_jaql106sbo,
                                       JAQL106TOP = ln_jaql106top,
                                       JAQL106A01 = 2
                                 where JAQL106PAI = i.pepais
                                   and JAQL106TDO = i.petdoc
                                   and JAQL106DOC = lc_numdoc;
                           end;
                         when others then
                              null;
                         end;
                         commit;
                      end if;
              end if;
        end if;
    end loop;
end sp_ah_clie_nuevos;
/

