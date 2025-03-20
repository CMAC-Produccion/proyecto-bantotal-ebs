create or replace procedure SP_CR_PROCMAS_PAGVIG is
CURSOR PAGARES(sucursal in number) is
    SELECT SCSUC v1SCSUC,
           SCCTA v1SCCTA,
           SCOPER v1SCOPER,
           Scmda v1Scmda,
           Scpap v1Scpap,
           Scmod v1Scmod,
           Scsbop v1Scsbop,
           Sctope v1Sctope,
           Scfval v1Scfval,
           scstat v1scstat,
           (Scsdo * -1) v1Scsdo,
           to_char(scfcon,'dd/mm/yyyy')  Fecha_contable,
           (select min(b.aofval)
              from fsd010 b
             where b.pgcod = 1
               and b.aomod = scmod
               and b.aocta = sccta
               and b.aooper = scoper
               and b.aosuc = scsuc) fecha_inicial
      FROM fsd011 f1
     where Pgcod = 1
       AND Scmod in (select tp1nro1
                       from fst198
                      where tp1cod = 1
                        AND tp1cod1 = 10884
                        AND TP1CORR1 = 5
                        AND TP1CORR2 = 1)
       AND Scmda in (0, 101)
       AND Scpap = 0
       AND Scsuc = sucursal
       and scstat in (select tp1nro1
                       from fst198
                      where tp1cod = 1
                        AND tp1cod1 = 10884
                        AND TP1CORR1 = 5
                        AND TP1CORR2 = 2)
       AND Scstat <> 99
       and Scfval <'14/12/2018'
     order by fecha_inicial;
     
     
   cursor Sucursales is
      select sucurs
        from fst001
       where pgcod = 1
         and sucurs not in (select tpnro 
                              from fst098 
                             where TPCOD=7681 
                               and tpnro not in (select tp1nro1
                                                   from fst198
                                                  where tp1cod = 1
                                                    and tp1cod1 = 10884  
                                                    and TP1CORR1 = 16
                                                    and tp1corr2 = 0))--sma.13.12.2018
         and sucurs < 800;
         
         
age number;
hora char(8);
fecha date;
agencia number;
observacion varchar2(30);
pepais1 number;
petdoc1 number;
pendoc1 number;
usudes  char(10);
begin

  delete jaqz560_aux;
  delete jaqz562_aux;
  delete jaqz560;
  delete jaqz561;
  delete jaqz562;
  commit;
  For suc in Sucursales loop
     age := suc.sucurs;
    For reg in pagares(age) loop
      -- datos cliente
      Begin
        select pepais, petdoc, pendoc
          into pepais1, petdoc1, pendoc1
          from fsr008
         where ctnro = reg.v1SCCTA
           and ttcod = 1
           and cttfir = 'T' ;
      exception
        when no_data_found then
          null;
      end ;
      
      
      --SUCURSAL DE DESEMBOLSO
      PQ_CR_MODULO_ABMPAGARES.sp_usuario(1,
                                         reg.v1scsuc,
                                         reg.v1scmod,
                                         reg.v1scmda,
                                         reg.v1scpap,
                                         reg.v1sccta,
                                         reg.v1scoper,
                                         reg.v1scsbop,
                                         reg.v1sctope,
                                         reg.fecha_inicial,
                                         agencia,
                                         usudes,
                                         observacion);
     
       fecha := pq_ah_pagare_vigente.Fecha_judicial(1,
                                                   reg.v1scmod,
                                                   reg.v1scsuc,
                                                   reg.v1scmda,
                                                   reg.v1scpap,
                                                   reg.v1sccta,
                                                   reg.v1scoper,
                                                   reg.v1scsbop,
                                                   reg.v1sctope,
                                                   reg.v1scstat);
      SELECT TO_CHAR(sysdate,'HH24:mm:ss') into hora from dual;

      Begin
        insert into jaqz560(jaqz560pgc,
                            jaqz560mod,
                            jaqz560suc,
                            jaqz560mda,
                            jaqz560pap,
                            jaqz560cta,
                            jaqz560ope,
                            jaqz560sbo,
                            jaqz560top,
                            jaqz560fvl,
                            jaqz560hra,
                            jaqz560usr,
                            jaqz560pai,
                            jaqz560tdc,
                            jaqz560doc,
                            jaqz560au9,
                            jaqz560au1,
                            jaqz560au8,
                            jaqz560au2,
                            jaqz560au5)
                     values(1,
                            reg.v1scmod,
                            agencia, --reg.v1scsuc, sucur desembolso
                            reg.v1scmda,
                            reg.v1scpap,
                            reg.v1sccta,
                            reg.v1scoper,
                            reg.v1scsbop,
                            reg.v1sctope,
                            reg.v1scfval,
                            hora,
                            usudes,--usuariodesembolso
                            pepais1,
                            petdoc1,
                            pendoc1,
                            fecha,
                            reg.v1scstat,
                            observacion,
                            reg.v1scsuc,
                            'OP_MASIVO');
      exception
        when dup_val_on_index then
          null;
      End;
      Begin
        insert into jaqz561(jaqz561pgc,
                            jaqz561mod,
                            jaqz561suc,
                            jaqz561mda,
                            jaqz561pap,
                            jaqz561cta,
                            jaqz561ope,
                            jaqz561sbo,
                            jaqz561top,
                            jaqz561fvl,
                            jaqz561cor,
                            jaqz561hra,
                            jaqz561usr,
                            jaqz561est,
                            jaqz561fmv,
                            jaqz561d1,
                            jaqz561d2,
                            jaqz561d3,
                            jaqz561d4,
                            jaqz561d5,
                            jaqz561d6,
                            jaqz561d7,
                            jaqz561au1,
                            jaqz561au2,
                            jaqz561au4,
                            jaqz561au7,
                            jaqz561au5,
                            jaqz561obs,
                            jaqz561suco,
                            jaqz561v4)
                     values(1,
                            reg.v1scmod,
                            agencia, --reg.v1scsuc, sucur desembolso
                            reg.v1scmda,
                            reg.v1scpap,
                            reg.v1sccta,
                            reg.v1scoper,
                            reg.v1scsbop,
                            reg.v1sctope,
                            reg.v1scfval,
                            1,
                            hora,
                            usudes,--usuario desembolso 'OP_MASIVO',
                            'B',
                            TRUNC(SYSDATE),
                            'S',
                            'S',
                            'S',
                            'S',
                            'N',
                            'S',
                            'N',
                            0,
                            0,
                            'I',
                            fecha,
                            reg.v1scstat,
                            observacion,
                            reg.v1scsuc,
                            'OP_MASIVO');

      exception
        when dup_val_on_index then
          NULL;
      end;
    End Loop;
    COMMIT ;
  End loop;
end SP_CR_PROCMAS_PAGVIG;
/

