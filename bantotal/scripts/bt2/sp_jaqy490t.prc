CREATE OR REPLACE PROCEDURE SP_JAQY490T
(
  INSTANCIA IN NUMBER
, SUCURSAL IN NUMBER
, FECHAINI IN DATE
, FECHAFIN IN DATE
, TOTAL OUT NUMBER
, TOTAL1 OUT NUMBER
)
is
    l_cont NUMBER(18):=0;
    l_cont1 NUMBER(18):=0;
    l_cont2 NUMBER(18):=0;
    l_cont3 NUMBER(18):=0;
    l_ases VARCHAR2(10);
    nppais number(3):= null;
    npetdoc number(4):= null;
    npendoc varchar2(25):= null;
    nfecha  date;
    l_suma1 NUMBER(18.2):=0;
    l_suma2 NUMBER(18.2):=0;
    l_sumatotal NUMBER(18.2):=0;
BEGIN

  SELECT  SNG001ASE INTO l_ases from sng001 where sng001INST=INSTANCIA;

  select count(*) INTO l_cont2
  from JAQY490S c
  inner join JAQY490T b
  ON b.BCFech=c.JAQY490FEC
  AND b.Pepais=c.JAQY490PAI
  AND b.Petdoc=c.JAQY490TDO
  AND b.Pendoc=c.JAQY490NDO
  INNER JOIN sng001 a
  on a.SNG001INST=b.NUMINS
  where b.BCMOD=116
  AND b.BCFECH>=FECHAINI
  AND b.BCFECH <=FECHAFIN
  AND b.BCSUC=SUCURSAL
    AND a.SNG001ASE=l_ases
  AND c.JAQY490SOB in (1,2);


  Select count(*) into l_cont1 from JAQA76 where jaqa76usu=l_ases and JAQA76EST='S';
  TOTAL:=l_cont2;
  TOTAL1:=l_cont1;
  DBMS_OUTPUT.PUT_LINE ('l_sumatotal: '||TOTAL);
END SP_JAQY490T;
/

