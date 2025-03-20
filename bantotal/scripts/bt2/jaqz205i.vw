create or replace force view jaqz205i as
select ciacod AS JAQZ205ICOD, ciades AS JAQZ205IDES, tipicod AS JAQZ205ITIP
from nmcia10@cole where ciaest = 2 ORDER BY ciades ASC;

