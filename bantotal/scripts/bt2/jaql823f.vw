create or replace force view jaql823f as
select ncodpai, ntipdoc, cnumdoc, cmeicli
  from (select row_number() over(partition by ncodpai, ntipdoc, cnumdoc order by cmeicli) as num,
               ncodpai,
               ntipdoc,
               cnumdoc,
               cmeicli
          from (select /*+all_rows*/a.z0e478thp as ncodpai,
                       a.z0e478tht as ntipdoc,
                       a.z0e478thd as cnumdoc,
                       substr(c.pextxt, 1, (instr(c.pextxt, '\') - 1)) as cmeicli
                  from z0e478 a
                 inner join fsx001 c
                    on a.z0e478thp = c.pepais
                   and a.z0e478tht = c.petdoc
                   and a.z0e478thd = c.pendoc) tp1) tp2
 where tp2.num = 1;

