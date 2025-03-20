CREATE OR REPLACE PROCEDURE MIGRA_MOV_TEST2 (
       ain_emp  IN PLS_INTEGER, -- Empresa
       ain_sud  IN PLS_INTEGER, -- Sucursal Desde
       ain_suh  IN PLS_INTEGER, -- Sucursal Hasta
       ain_mod  IN PLS_INTEGER, -- Modulo Desde
       ain_moh  IN PLS_INTEGER, -- Modulo Hasta
       ain_trd  IN PLS_INTEGER, -- Transacción Desde
       ain_trh  IN PLS_INTEGER, -- Transacción Hasta
       ain_bk   IN PLS_INTEGER  -- Limite para BULK COLLECT.

)
       is

       CURSOR c_fsd015 IS
              SELECT Pgcod,
                   Itmod,
                   Itsuc,
                   Ittran,
                   Itnrel,
                   Itfcon,
                   Itfvc,
                   Itcorr,
                   Ituing,
                   Itwing,
                   Itucnf,
                   Itwcnf,
                   Ithora,
                   Itcaja
              FROM FSD015
              WHERE Pgcod = ain_emp and itsuc between ain_sud and ain_suh
                                    and itmod between ain_mod and ain_moh
                                    and ittran between ain_trd and ain_trh
                    and Itcont = 'S' or Itcont = 'P';

       CURSOR c_fsd016 IS
              SELECT T1.Pgcod,
                     T1.Itmod,
                     T1.Itsuc,
                     T1.Ittran,
                     T1.Itnrel,
                     T2.Itfcon,
                     T1.Itord,
                     T1.Itsbor,
                     T1.Modulo,
                     T1.Ittope,
                     T1.Itsucd,
                     T1.Rubro,
                     T1.Moneda,
                     T1.Papel,
                     T1.Ctnro,
                     T1.Itoper,
                     T1.Itsubo,
                     T1.Itfval,
                     T1.Itfvto,
                     T1.Itpzo,
                     T1.Itper,
                     T1.Itttas,
                     T1.Ittasa,
                     T1.Ittmor,
                     T1.Ittdia,
                     T1.Ittvto,
                     T1.Ittano,
                     T1.Ittint,
                     T1.Itarb,
                     T1.Itarb1,
                     T1.Ittcbi,
                     T1.Ittcbi1,
                     T1.Itmd,
                     T1.Itmd1,
                     T1.Itpre,
                     T1.Itpre1,
                     T1.Itdrev,
                     T1.Itafiv,
                     T1.Itafgt,
                     T1.Itplus,
                     T1.Itcodm,
                     T1.Itser,
                     T1.Itcheq,
                     T1.Itimp1,
                     T1.Itimp2,
                     T1.Itimp3,
                     T1.Itimp4,
                     T1.Itimp5,
                     T1.Itimp6,
                     T1.Itimpo,
                     T1.Itmdao,
                     T1.Itdbha,
                     T1.Itncor,
                     T1.Itbbtt,
                     T1.Itfunc,
                     T1.Itsegm,
                     T1.Itccos,
                     T1.Itcbcu,
                     T1.Itccli,
                     T1.Itref,
                     T2.Itfvc,
                     ' ' t1,
                     ' ' t2,
                     T1.Itcltcod
              /*
              FROM fsd015 T2
              INNER JOIN fsd016 T1 on T2.Pgcod = T1.Pgcod
                                   and T2.Itsuc = T1.Itsuc
                                   and T2.Itmod = T1.Itmod
                                   and T2.Ittran = T1.Ittran
                                   and T2.Itnrel = T1.Itnrel
              WHERE T2.itcont = 'S' or T2.itcont = 'P'
                 and itimp1 <> 0
                 and itanu <> 'S'
                 and T1.Pgcod = ain_emp and T1.itsuc = ain_suc and T1.itmod = ain_mod and T1.ittran = ain_trn ;
              */
              FROM fsd015 T2,
                       fsd016 T1 WHERE
                                   T1.Pgcod = ain_emp and T1.itsuc between ain_sud and ain_suh
                                                   and T1.itmod between ain_mod and ain_moh
                                                   and T1.ittran between ain_trd and ain_trh
                                   and T2.Pgcod = T1.Pgcod
                                   and T2.Itsuc = T1.Itsuc
                                   and T2.Itmod = T1.Itmod
                                   and T2.Ittran = T1.Ittran
                                   and T2.Itnrel = T1.Itnrel
                 and T2.itcont = 'S' or T2.itcont = 'P'
                 and itimp1 <> 0
                 and itanu <> 'S';
        TYPE t_fsd015 is TABLE of c_fsd015%ROWTYPE INDEX BY PLS_INTEGER;
        TYPE t_fsd016 is TABLE of c_fsd016%ROWTYPE INDEX BY PLS_INTEGER;

        l_fsd015   t_fsd015;
        l_fsd016   t_fsd016;

BEGIN
     OPEN c_fsd015;

     LOOP
         FETCH c_fsd015
         BULK COLLECT INTO l_fsd015 LIMIT ain_bk;
         EXIT WHEN l_fsd015.count = 0;

         FORALL i IN l_fsd015.first .. l_fsd015.last
            INSERT INTO FSH015
            VALUES (l_fsd015(i).Pgcod,
                    l_fsd015(i).Itmod,
                    l_fsd015(i).Itsuc,
                    l_fsd015(i).Ittran,
                    l_fsd015(i).Itnrel,
                    l_fsd015(i).Itfcon,
                    l_fsd015(i).Itfvc,
                    l_fsd015(i).Itcorr,
                    l_fsd015(i).Ituing,
                    l_fsd015(i).Itwing,
                    l_fsd015(i).Itucnf,
                    l_fsd015(i).Itwcnf,
                    l_fsd015(i).Ithora,
                    l_fsd015(i).Itcaja);

         COMMIT;
     END LOOP;
     CLOSE c_fsd015;

     OPEN c_fsd016;

     LOOP
         FETCH c_fsd016
         BULK COLLECT INTO l_fsd016 LIMIT ain_bk;
         EXIT WHEN l_fsd016.count = 0;

         FORALL i IN l_fsd016.first .. l_fsd016.last
            INSERT INTO FSH016
            VALUES (l_fsd016(i).Pgcod,
                    l_fsd016(i).Itmod,
                    l_fsd016(i).Itsuc,
                    l_fsd016(i).Ittran,
                    l_fsd016(i).Itnrel,
                    l_fsd016(i).Itfcon,
                    l_fsd016(i).Itord,
                    l_fsd016(i).Itsbor,
                    l_fsd016(i).Modulo,
                    l_fsd016(i).Ittope,
                    l_fsd016(i).Itsucd,
                    l_fsd016(i).Rubro,
                    l_fsd016(i).Moneda,
                    l_fsd016(i).Papel,
                    l_fsd016(i).Ctnro,
                    l_fsd016(i).Itoper,
                    l_fsd016(i).Itsubo,
                    l_fsd016(i).Itfval,
                    l_fsd016(i).Itfvto,
                    l_fsd016(i).Itpzo,
                    l_fsd016(i).Itper,
                    l_fsd016(i).Itttas,
                    l_fsd016(i).Ittasa,
                    l_fsd016(i).Ittmor,
                    l_fsd016(i).Ittdia,
                    l_fsd016(i).Ittvto,
                    l_fsd016(i).Ittano,
                    l_fsd016(i).Ittint,
                    l_fsd016(i).Itarb,
                    l_fsd016(i).Itarb1,
                    l_fsd016(i).Ittcbi,
                    l_fsd016(i).Ittcbi1,
                    l_fsd016(i).Itmd,
                    l_fsd016(i).Itmd1,
                    l_fsd016(i).Itpre,
                    l_fsd016(i).Itpre1,
                    l_fsd016(i).Itdrev,
                    l_fsd016(i).Itafiv,
                    l_fsd016(i).Itafgt,
                    l_fsd016(i).Itplus,
                    l_fsd016(i).Itcodm,
                    l_fsd016(i).Itser,
                    l_fsd016(i).Itcheq,
                    l_fsd016(i).Itimp1,
                    l_fsd016(i).Itimp2,
                    l_fsd016(i).Itimp3,
                    l_fsd016(i).Itimp4,
                    l_fsd016(i).Itimp5,
                    l_fsd016(i).Itimp6,
                    l_fsd016(i).Itimpo,
                    l_fsd016(i).Itmdao,
                    l_fsd016(i).Itdbha,
                    l_fsd016(i).Itncor,
                    l_fsd016(i).Itbbtt,
                    l_fsd016(i).Itfunc,
                    l_fsd016(i).Itsegm,
                    l_fsd016(i).Itccos,
                    l_fsd016(i).Itcbcu,
                    l_fsd016(i).Itccli,
                    l_fsd016(i).Itref,
                    l_fsd016(i).Itfvc,
                    l_fsd016(i).t1,
                    l_fsd016(i).t2,
                    l_fsd016(i).Itcltcod);

         COMMIT;
     END LOOP;
     CLOSE c_fsd016;

END;
/

