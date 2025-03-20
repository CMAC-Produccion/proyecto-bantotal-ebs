CREATE OR REPLACE PROCEDURE SP_INSERTA_JAQN44(FECHA in DATE)  is
BEGIN
    DELETE FROM JAQN44;
    COMMIT;
      INSERT INTO JAQN44 (JAQN44PAI, JAQN44TPD, JAQN44NRD,JAQN44EMP, JAQN44MOD, JAQN44SUC,JAQN44MON, JAQN44PAP, JAQN44CTA, JAQN44NOP, JAQN44TOP,JAQN44SUO,JAQN44SAC,JAQN44NU1,JAQN44FEC,JAQN44FE1)
      select /*+ all_rows*/
      DISTINCT a.PFPAIS,
               a.PFTDOC,
               trim(a.PFNDOC), ---2022.08.16 dcastro se agrego trim
               c.PGCOD,
               c.AOMOD,
               c.AOSUC,
               c.AOMDA,
               c.AOPAP,
               b.CTNRO,
               c.aooper,
               c.aotope,
               c.aosbop,
               e.BCSDMN,
               MAX(fsd012.EVCORR),
               c.Aofval,
               FECHA
        FROM FSD002 a
       inner join fsr008 b
          ON b.pgcod = 1
         AND b.pepais = a.PFPAIS
         AND b.Petdoc = a.PFTDOC
         AND b.Pendoc = a.PFNDOC
         AND b.cttfir = 'T'
       inner join fsd010 c
          on c.pgcod = 1
         and c.aocta = b.ctnro
         and (c.aostat <> 99 or (c.aostat = 99 and c.aofe99 > FECHA))
       inner join fst198 o
          on o.tp1cod = 1
         and o.tp1cod1 = 908
         and o.tp1corr1 = 2
       inner join fsd011 f
          on f.pgcod = C.PGCOD
         and f.scsuc = C.AOSUC
         and f.scmda = C.AOMDA
         and f.scpap = C.AOPAP
         and f.sccta = c.AOCTA
         and f.scoper = C.AOOPER
         and f.scsbop = C.AOSBOP
         and f.sctope = c.Aotope
         and f.scstat <> 99
       inner join fsh012 e
          on e.bcemp = c.pgcod
         and e.bcfech = FECHA
         and e.BCSuc = c.Aosuc
         and e.BCCTA = c.aocta
         and e.BCMod = c.aomod
         and e.bcmda = c.aomda
         and e.bcpap = c.aopap
         and e.bcoper = c.aooper
         and e.BCSbOp = c.Aosbop
         and e.BCTOp = c.Aotope
         and e.bcrubr = f.scrub
        left outer join (select *
                           from fsd012 c
                          where c.EVCORR =
                                (SELECT MAX(j.EVCORR)
                                   FROM fsd012 j
                                  where j.PGCOD = c.PGCOD
                                    AND j.AOMOD = c.AOMOD
                                    AND j.AOSUC = c.AOSUC
                                    AND j.AOMDA = c.AOMDA
                                    AND j.AOPAP = c.AOPAP
                                    AND j.AOCTA = c.AOCTA
                                    AND j.AOOPER = c.AOOPER
                                    AND j.AOSBOP = c.AOSBOP
                                    AND j.aotope = c.aotope
                                    ---dcastro 2022-08.16 se agrego condicion para tasa actual
                                    and j.evtipo = 3
                                    and j.d012co = 'S'
                                    and j.evtasa <> 0
                                    ----
                                    )) fsd012
          on C.PGCOD = fsd012.PGCOD
         AND c.AOMOD = fsd012.AOMOD
         AND C.AOSUC = fsd012.AOSUC
         AND C.AOMDA = fsd012.AOMDA
         AND C.AOPAP = fsd012.AOPAP
         AND c.AOCTA = fsd012.AOCTA
         AND C.AOOPER = fsd012.AOOPER
         AND C.AOSBOP = fsd012.AOSBOP
         AND C.aotope = fsd012.aotope
         and fsd012.evtipo = 3
         and fsd012.d012co = 'S'
         and fsd012.evtasa <> 0
       where a.pfebco in ('S', 'N')
         and -- se agrego indicador trabador 2022/08/03 dcastro
             c.aomod = o.TP1NRO1
         and c.aotope = o.TP1NRO2
         and ((c.aostat = 99 and c.aofe99 > FECHA) or
             (c.aostat <> 99 and c.aofval <= FECHA))
       group by a.PFPAIS,
                a.PFTDOC,
                a.PFNDOC,
                c.PGCOD,
                c.AOMOD,
                c.AOSUC,
                c.AOMDA,
                c.AOPAP,
                b.CTNRO,
                c.aooper,
                c.aotope,
                c.aosbop,
                e.BCSDMN,
                c.Aofval;

      MERGE INTO JAQN44 a
      USING(SELECT * FROM fsd012) c
        ON (c.Pgcod = a.JAQN44EMP
        and c.Aomod  = a.JAQN44MOD
        and c.Aosuc  = a.JAQN44SUC
        and c.Aomda  = a.JAQN44MON
        and c.Aopap  = a.JAQN44PAP
        and c.Aocta  = a.JAQN44CTA
        and c.Aooper = a.JAQN44NOP
        and c.Aosbop = a.JAQN44SUO
        and c.Aotope = a.JAQN44TOP
        and c.EVCORR = a.JAQN44NU1)
      WHEN MATCHED THEN
      UPDATE SET
      a.JAQN44TAC=c.EVTASA;


      MERGE INTO JAQN44 a
      USING(SELECT * FROM fsd010) c
        ON (c.Pgcod = a.JAQN44EMP
        and c.Aomod  = a.JAQN44MOD
        and c.Aosuc  = a.JAQN44SUC
        and c.Aomda  = a.JAQN44MON
        and c.Aopap  = a.JAQN44PAP
        and c.Aocta  = a.JAQN44CTA
        and c.Aooper = a.JAQN44NOP
        and c.Aosbop = a.JAQN44SUO
        and c.Aotope = a.JAQN44TOP)
      WHEN MATCHED THEN
      UPDATE SET
      a.JAQN44TAC =c.aotasa
      WHERE a.JAQN44TAC IS NULL;

      MERGE INTO JAQN44 a
      USING(SELECT * FROM fst004) c
        ON (c.modulo  = a.JAQN44MOD 
        and c.totope = a.JAQN44TOP)
      WHEN MATCHED THEN
      UPDATE SET
      a.JAQN44TCR =c.tonom;
      Commit;

END SP_INSERTA_JAQN44;
/

