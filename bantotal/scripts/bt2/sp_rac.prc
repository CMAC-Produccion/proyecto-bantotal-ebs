create or replace procedure sp_rac(re_fecha in date,RESULTADO OUT VARCHAR2) is
PeriodoA char(6);
Periodo char(6);
begin
  Periodo := concat(to_char(re_fecha,'YYYY'),to_char(re_fecha,'MM'));
--  dbms_output.put_line (Periodo);
  DECLARE
       CURSOR C1 IS select distinct JAQZ255acodtra from JAQZ255a where JAQZ255ACODPER=Periodo;
       cod_tra numeric(3);
    BEGIN
       OPEN C1;
       LOOP
          FETCH C1 INTO cod_tra;
          EXIT WHEN C1%NOTFOUND;
          Begin

            select jaqz255acodper into PeriodoA from JAQZ255A
            where JAQZ255ACODPER <> Periodo
            and JAQZ255ACODPER < Periodo
            and JAQZ255Acodtra = cod_tra
            and rownum=1
            order by JAQZ255ACODPER desc;
            exception
            when no_data_found then
               PeriodoA := ' ';
          end;
--          dbms_output.put_line (PeriodoA);
--           RESULTADO := concat(Periodo,PeriodoA) ;

          if (PeriodoA = ' ') then
--              dbms_output.put_line (cod_tra);
--              dbms_output.put_line (Periodo);
--              dbms_output.put_line (PeriodoA);
              -- update JAQZ255 set jaqz255ind=1 where jaqz255ndoc in (select j.jaqz255ndoc  from JAQZ255I i
              -- inner join jaqy470c c on c.jqy470cnro=i.jaqz255icodtra and c.jqy470ccta=i.jaqz255ictacli and c.jqy470cope=i.jaqz255icodope and
              -- c.jqy470cmod=i.jaqz255imod and c.jqy470csuc=i.jaqz255isuc and c.jqy470ctip=i.jaqz255itip and c.jqy470crub=i.jaqz255irub and c.jqy470ccda=i.jaqz255icda
              -- inner join jaqz255 j on j.jaqz255cta=c.jqy470ccta and j.jaqz255codper=Periodo
              -- where
              -- c.jqy470cnro = cod_tra and
              -- c.JQY470CSAL > 0 and
              -- c.jqy470cmod in (33,451,200,455)
              -- and i.jaqz255iactsal<>c.jqy470csal);
               update JAQZ255 set jaqz255ind=1 where
               jaqz255ndoc in (select a.jaqz255anrodoc from JAQZ255A a
               inner join jaqy953 j on j.jaqy953cta=a.jaqz255acta and j.jaqy953ope=a.jaqz255acodope
               where a.jaqz255acodper=Periodo
               and a.jaqz255acodtra=cod_tra
               and a.jaqz255acap+a.jaqz255aint<>j.jaqy953cav+j.jaqy953inv);
               --and a.jaqz255acodtra in (select q.jaqy952gru from jaqy952 q where q.jaqy952nro=j.jaqy952nro)); ya valida arriba el grupo
               commit;
          else
               update JAQZ255 set jaqz255ind=1 where
               jaqz255ndoc in (select a.jaqz255anrodoc from JAQZ255A a
               inner join  JAQZ255A b on b.JAQZ255Acodper=PeriodoA and  a.jaqz255acta=b.jaqz255acta
               and a.jaqz255acodope=b.jaqz255acodope and a.jaqz255acodtra=b.jaqz255acodtra
               where a.JAQZ255Acodper=Periodo
               and a.jaqz255acodtra=cod_tra
               and a.jaqz255atot<>b.jaqz255atot);
               commit;
          End if;
        END LOOP;
       CLOSE C1;
    END;
end sp_rac;
/

