create or replace force view aqpa013 as
select ciacod AS AQPA013ciacod,
       ciades AS AQPA013ciades,
       ciaruc AS AQPA013ciaruc
  from nmcia10@cole
where ciaest = 2 ORDER BY ciades ASC;

