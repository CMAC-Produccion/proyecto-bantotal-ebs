create or replace procedure SP_VERIFICA_TRAB_FSD009
is

begin
    delete from jaql482  where JAQL482CCT in(4 ,5,6);
    commit;
     insert into jaql482 (JAQL482CCT, JAQL482PGE, JAQL482SUC, JAQL482CTA, JAQL482MOD, JAQL482MDA, JAQL482PAP, JAQL482OPE, JAQL482SBO, JAQL482TOP,   JAQL482FEI,   JAQL482FEF, JAQL482FEC, JAQL482FEM, JAQL482USC, JAQL482USM, JAQL482HCR, JAQL482HMD, JAQL482AX1, JAQL482AX2, JAQL482AX3, JAQL482AX4,   JAQL482AX5, JAQL482AX6,   JAQL482AX7, JAQL482AX8, JAQL482AX9)
      select /*+ parallel (c,4), parallel (d,4) +*/
              4,a.pgcod,
              a.scsuc,
              a.sccta,
              a.scmod,
              a.scmda,
              a.scpap,
              a.scoper,
              a.scsbop,
              a.sctope,
              trunc(sysdate),trunc(sysdate+2),trunc(sysdate),
              to_date('01010001','ddmmyyyy'),'BANTOTAL',null,to_char(systimestamp,'hh24:mi:ss'),null,1,0,0.00,0.00, to_date('01010001','ddmmyyyy'),
              to_date('01010001','ddmmyyyy'),null,null,null
        from fsd011 a,
             (    select /*+ parallel (x,4)+*/
                   x.pgcod,x.ctnro
                    from fsr008 x
                   where x.pgcod = 1
                     and x.ttcod = 1
                group by x.pgcod,x.ctnro
                  having count(1) = 1
             )b,
             fsr008 c,
             fsd002 d
       where a.pgcod  = b.pgcod
         and a.sccta  = b.ctnro
         and b.pgcod  = c.pgcod
         and b.ctnro  = c.ctnro
         and c.pepais = d.pfpais
         and c.petdoc = d.pftdoc
         and c.pendoc = d.pfndoc
         and d.pfebco = 'S'
         and c.ttcod  = 1
         and c.cttfir = 'T'
         and a.scmod  = 21
         and a.sctope IN (1,3,8)
         and a.scstat <> 99;

    commit;
     insert into jaql482 (JAQL482CCT, JAQL482PGE, JAQL482SUC, JAQL482CTA, JAQL482MOD, JAQL482MDA, JAQL482PAP, JAQL482OPE, JAQL482SBO, JAQL482TOP,   JAQL482FEI,   JAQL482FEF, JAQL482FEC, JAQL482FEM, JAQL482USC, JAQL482USM, JAQL482HCR, JAQL482HMD, JAQL482AX1, JAQL482AX2, JAQL482AX3, JAQL482AX4,   JAQL482AX5, JAQL482AX6,   JAQL482AX7, JAQL482AX8, JAQL482AX9)
    select 5, JAQL482PGE, JAQL482SUC, JAQL482CTA, JAQL482MOD, JAQL482MDA, JAQL482PAP, JAQL482OPE, JAQL482SBO, JAQL482TOP,   JAQL482FEI,   JAQL482FEF, JAQL482FEC, JAQL482FEM, JAQL482USC, JAQL482USM, JAQL482HCR, JAQL482HMD, JAQL482AX1, JAQL482AX2, JAQL482AX3, JAQL482AX4,   JAQL482AX5, JAQL482AX6,   JAQL482AX7, JAQL482AX8, JAQL482AX9
    from jaql482
    where JAQL482CCT=4;
    commit;

     insert into jaql482 (JAQL482CCT, JAQL482PGE, JAQL482SUC, JAQL482CTA, JAQL482MOD, JAQL482MDA, JAQL482PAP, JAQL482OPE, JAQL482SBO, JAQL482TOP,   JAQL482FEI,   JAQL482FEF, JAQL482FEC, JAQL482FEM, JAQL482USC, JAQL482USM, JAQL482HCR, JAQL482HMD, JAQL482AX1, JAQL482AX2, JAQL482AX3, JAQL482AX4,   JAQL482AX5, JAQL482AX6,   JAQL482AX7, JAQL482AX8, JAQL482AX9)
    select 6, JAQL482PGE, JAQL482SUC, JAQL482CTA, JAQL482MOD, JAQL482MDA, JAQL482PAP, JAQL482OPE, JAQL482SBO, JAQL482TOP,   JAQL482FEI,   JAQL482FEF, JAQL482FEC, JAQL482FEM, JAQL482USC, JAQL482USM, JAQL482HCR, JAQL482HMD, JAQL482AX1, JAQL482AX2, JAQL482AX3, JAQL482AX4,   JAQL482AX5, JAQL482AX6,   JAQL482AX7, JAQL482AX8, JAQL482AX9
    from jaql482
    where JAQL482CCT=4;
    commit;
    delete from fsd009 where tgcod=21 and grnro=160401 and PGCOD=1;
    delete from fsd009 where tgcod=4 and grnro=22001 and PGCOD=1;
    
    --01.03.2021
    delete from fsd009 where tgcod=30 and grnro=160401 and PGCOD=1;

    
    insert into fsd009 (TGCOD, GRNRO, PGCOD, CTNRO, GRINCOD, GRPORC)
          select
          4, 22001, 1, b.ctnro, 1, 0.000

        from
             (    select /*+ parallel (x,4)+*/
                         x.pgcod,x.ctnro
                    from fsr008 x
                   where x.pgcod = 1
                     and x.ttcod = 1
                group by x.pgcod,x.ctnro
                  having count(1) = 1
             )b,
             fsr008 c,
             fsd002 d
       where b.pgcod  = c.pgcod
         and b.ctnro  = c.ctnro
         and c.pepais = d.pfpais
         and c.petdoc = d.pftdoc
         and c.pendoc = d.pfndoc
         and d.pfebco = 'S'
         and c.ttcod  = 1
         and c.pgcod=1
         and c.cttfir = 'T';
    commit;

end;
/

