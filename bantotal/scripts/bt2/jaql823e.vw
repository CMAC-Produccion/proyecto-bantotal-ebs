create or replace force view jaql823e as
select ncodpai, ntipdoc, cnumdoc, ctelfij, ctelcel
  from (select row_number() over(partition by ncodpai, ntipdoc, cnumdoc order by ncodpai) as num,
               ncodpai,
               ntipdoc,
               cnumdoc,
               ctelfij,
               ctelcel
          from (select /*+all_rows*/ a.z0e478thp as ncodpai,
                       a.z0e478tht as ntipdoc,
                       a.z0e478thd as cnumdoc,
                       d.dotelfp   as ctelfij,
                       e.dotelfp   as ctelcel
                  from z0e478 a
                  left join fsr005 d
                    on a.z0e478thp = d.pepais
                   and a.z0e478tht = d.petdoc
                   and a.z0e478thd = d.pendoc
                   and d.doordp = 1
                  left join fsr005 e
                    on a.z0e478thp = e.pepais
                   and a.z0e478tht = e.petdoc
                   and a.z0e478thd = e.pendoc
                   and e.doordp = 2
                 where d.dotelfp is not null
                    or e.dotelfp is not null) tp1) tp2
 where tp2.num = 1;

