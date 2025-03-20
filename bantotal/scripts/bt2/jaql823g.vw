create or replace force view jaql823g as
select ncodpai, ntipdoc, cnumdoc, cdircli, ntipviv
  from (select row_number() over(partition by ncodpai, ntipdoc, cnumdoc, ntipviv order by ntipviv) as num,
               ncodpai,
               ntipdoc,
               cnumdoc,
               cdircli,
               ntipviv
          from (select /*+all_rows*/sngc13pais as ncodpai,
                       sngc13tdoc as ntipdoc,
                       sngc13Ndoc as cnumdoc,
                       sngc13dir  as cdircli,
                       docod      as ntipviv
                  from sngc13
                 where docod in (1, 3)
                   and sngc13Est = 'H'
                   and sngc13corr = 1) tp1) tp2
 where tp2.num = 1;

