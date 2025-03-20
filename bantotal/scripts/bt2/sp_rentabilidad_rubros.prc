create or replace procedure sp_rentabilidad_rubros(re_fecha in date, re_usuario in char,RESULTADO OUT VARCHAR2) is
ld_fec varchar(6);
re_suc numeric(3);
total numeric;
begin
   RESULTADO := '';
   ld_fec := concat(to_char(re_fecha,'MM'),to_char(re_fecha,'YYYY'));
   delete JAQZ259R where JAQZ259RFECP=re_fecha;
   commit;
   select count(jaqz422ccod) into total from JAQZ422C where jaqz422ccod<1000 order by jaqz422ccod;
/*   select count(sucurs) into total from FST001 where sucurs not in (select tpnro from FST098 where pgcod=1 and
       tpcod=7707 and ( tpcorr>=2 and tpcorr<=30 ));*/
   DECLARE
       /*CURSOR C1 IS select sucurs from FST001 where sucurs not in (select tpnro from FST098 where pgcod=1 and
       tpcod=7707 and ( tpcorr>=2 and tpcorr<=30 ));*/
       CURSOR C1 IS select JAQZ422CCOD from JAQZ422C where jaqz422ccod<1000 order by jaqz422ccod ;
       re_suc numeric(3);
    BEGIN
       OPEN C1;
       LOOP
          FETCH C1 INTO re_suc;
          EXIT WHEN C1%NOTFOUND;
            Begin
             Insert into JAQZ259R
               (JAQZ259RFECP,
                JAQZ259RCODRUB,
                JAQZ259RCODC,
                JAQZ259RSUC,
                JAQZ259RCODG,
                JAQZ259RSAL,
                JAQZ259RCODPER,
                JAQZ259RUSU,
                JAQZ259RFUPD)
               select /*Parallel(10)*/ re_fecha,
                      JAQZ259DRUB,
                      JAQZ259DCODC,
                      re_suc,
                      g.jaqz259gcod,
                      (select sum(bcsdmn)
                         from FSH012
                        where bcfech = re_fecha
                          and bcsuc = re_suc
                          and bcemp = 1
                          and bcrubr = d.jaqz259drub),
                      ld_fec,
                      re_usuario,
                      sysdate
                 from JAQZ259D d
                inner join JAQZ259C c
                   on c.jaqz259ccod = d.jaqz259dcodc
                inner join JAQZ259G g
                   on g.jaqz259gcod = c.jaqz259ccodg
                  and JAQZ259GTIP = 1 --cuadro 1 de Detalle
                where d.jaqz259dope = '+';
            exception
            when DUP_VAL_ON_INDEX then
              RESULTADO := '1';
            end;
            commit;
       END LOOP;
       CLOSE C1;
    END;
    ---actualizacion de signo para los rubros que empiezan 4, 1 y 68

      update JAQZ259R set jaqz259RSAL=jaqz259RSAL*-1 where jaqz259RFECP=re_fecha and (JAQZ259RCODRUB like '1%' or JAQZ259RCODRUB like '4%' or JAQZ259RCODRUB like '68%')
      and  jaqz259Rcodg in (select JAQZ259GCOD from JAQZ259G where JAQZ259GTIP=1);
      commit;
    ---rubros con excepcion de cambio de signo que empiezan 1419% y 1429%

      update JAQZ259R set jaqz259RSAL=jaqz259RSAL*-1 where jaqz259RFECP=re_fecha and (JAQZ259RCODRUB like '1419%' or JAQZ259RCODRUB like '1429%')
      and  jaqz259Rcodg in (select JAQZ259GCOD from JAQZ259G where JAQZ259GTIP=1);
      commit;
   ---actualiza perfil de ejecucion de procesos

      delete Jaqz260 where jaqz260usu=re_usuario and jaqz260fecp=re_fecha and JAQZ260CODP>1;
      commit;

end sp_rentabilidad_rubros;
/

