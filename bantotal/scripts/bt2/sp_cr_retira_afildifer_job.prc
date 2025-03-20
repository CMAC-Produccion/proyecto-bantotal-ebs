create or replace procedure sp_cr_RETIRA_AFILDIFER_JOB is
  --Luis Carpio/Erika Hidalgo
cursor presta is
select *
  from fsr011 a, fsd011 b
 where b.pgcod = a.r1cod
   and b.scsuc = a.r1suc
   and b.scmda = a.r1mda
   and b.scpap = a.r1pap
   and b.sccta = a.r1cta
   and b.scoper = a.r1oper
   and b.scsbop = a.r1sbop
   and b.sctope = a.r1tope
   and b.scmod = a.r1mod
--   and a.relcod = 131
   and a.relcod in (121,131)--30.06.2020
   and a.r011co = 'S'
   and b.scmod not in (200, 33)
   and b.sctope <> 550
   and b.pgcod = 1
   and b.scmod > 100
   and b.scmod <= 117
   and not exists (select *
          from fsd011 c
         where c.pgcod = a.r1cod
           and c.scsuc = a.r2suc
           and c.pgcod = 1
           and c.scmda = a.r2mda
           and c.scpap = a.r2pap
           and c.sccta = a.r2cta
           and c.scoper = a.r2oper
           and c.scmod = a.r2mod);
begin
  for i in presta loop
      update fsr011
         set r011co = 'N'
       where R1COD  = i.R1COD
         and R1MOD  = i.R1MOD
         and R1SUC  = i.R1SUC
         and R1MDA  = i.R1MDA
         and R1PAP  = i.R1PAP
         and R1CTA  = i.R1CTA
         and R1OPER = i.R1OPER
         and R1SBOP = i.R1SBOP
         and R1TOPE = i.R1TOPE
         and RELCOD = i.RELCOD
         and R2MOD  = i.R2MOD
         and R2CTA  = i.R2CTA
         and R2OPER = i.R2OPER
         and R2SBOP = i.R2SBOP
         and R2COD  = i.R2COD
         and R2SUC  = i.R2SUC
         and R2MDA  = i.R2MDA
         and R2PAP  = i.R2PAP
         and R2TOPE = i.R2TOPE;
   commit;
  end loop;
end sp_cr_RETIRA_AFILDIFER_JOB;
/

