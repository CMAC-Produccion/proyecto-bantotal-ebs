CREATE OR REPLACE PROCEDURE sp_rentabilidad_concepto (re_fecha in date,re_usuario in char,RESULTADO OUT VARCHAR2/*, q out sys_refcursor*/)is
/*scnom varchar(250); */
/*cadena varchar(4000);*/
/*v_sql VARCHAR2 (4000);*/
ld_fec varchar(6);
begin  
/*   cadena:='';*/
   RESULTADO := '';
   ld_fec := concat(to_char(re_fecha,'MM'), to_char(re_fecha,'YYYY')) ;
   delete JAQZ259 where JAQZ259FECP=re_fecha;
   commit;        
   
   Begin
    Insert into JAQZ259 (JAQZ259FECP,JAQZ259CODC,JAQZ259SUC,JAQZ259SAL,JAQZ259CODPER,JAQZ259CODG,JAQZ259USU,JAQZ259FUPD)
    select j.jaqz259rfecp,j.jaqz259rcodc,j.jaqz259rsuc, sum(j.jaqz259rsal),j.jaqz259rcodper,j.jaqz259rcodg,re_usuario,sysdate 
    from JAQZ259R j
    where j.jaqz259rfecp= re_fecha
    group by j.jaqz259rfecp,j.jaqz259rcodc,j.jaqz259rsuc,j.jaqz259rcodper,j.jaqz259rcodg;
    commit;
   exception
            when DUP_VAL_ON_INDEX then
              RESULTADO := '1';
            end;

    ---agrega todos los conceptos que no tienen valor en la JAQZ259
    DECLARE
/*       CURSOR C3 IS select sucurs from FST001 where sucurs not in (select tpnro from FST098 where pgcod=1 and  tpcod=7707 and ( tpcorr>=2 and tpcorr<=30 ));*/
       CURSOR C3 IS select JAQZ422CCOD from JAQZ422C where jaqz422ccod<1000 order by jaqz422ccod ;      
       re_suc numeric(3);
    BEGIN
       OPEN C3;
       LOOP
          FETCH C3 INTO re_suc;
          EXIT WHEN C3%NOTFOUND;
           Begin
            Insert into JAQZ259 (JAQZ259FECP,JAQZ259CODC,JAQZ259SUC,JAQZ259SAL,JAQZ259CODPER,JAQZ259CODG,JAQZ259USU,JAQZ259FUPD)
            select re_fecha,c.jaqz259ccod,re_suc, 0,ld_fec,c.jaqz259ccodg,re_usuario,sysdate 
            from JAQZ259C c 
            where c.jaqz259ccod not in (select jaqz259rcodc from jaqz259r where jaqz259rfecp=re_fecha group by jaqz259rcodc)
            and c.jaqz259ccodg in (select JAQZ259GCOD from JAQZ259G where JAQZ259GTIP=1);
            commit;          
           exception
            when DUP_VAL_ON_INDEX then
              RESULTADO := '1';
            end;
       END LOOP;
       CLOSE C3;
    END;           
    /*-- carga los valores que fueron ingresados digitalmente en el JAQZ259I al JAQZ259        
--    Begin
      update
      (select jaqz259sal,jaqz259isal from jaqz259 j
      inner join jaqz259i i on i.jaqz259icodc=j.jaqz259codc and i.jaqz259isuc=j.jaqz259suc and i.jaqz259ifecp=re_fecha
      and j.jaqz259codg in (select JAQZ259GCOD from JAQZ259G where JAQZ259GTIP=1)) t
      set t.jaqz259sal=t.jaqz259isal;
      commit;
--    exception
--            when others then
--              RESULTADO := '1';
--            end;*/

  
  /*--- calcula las sumas de conceptos y actualiza la tabla 
    DECLARE
       CURSOR C1 IS select jaqz259scod ,g.jaqz259gord,c.jaqz259csec from jaqz259s 
                    inner join jaqz259c c on c.jaqz259ccod=jaqz259scod 
                    inner join jaqz259G g on g.jaqz259gcod=c.jaqz259ccodg and g.jaqz259gtip=1                  
                    group by jaqz259scod,g.jaqz259gord,c.jaqz259csec
                    order by g.jaqz259gord,c.jaqz259csec;
       codigo varchar(6);
       ord numeric(3);
       sec numeric(3);
    BEGIN
       OPEN C1;
       LOOP
          FETCH C1 INTO codigo,ord,sec;
          EXIT WHEN C1%NOTFOUND;
            dbms_output.put_line (codigo);  
--            Begin  
               update jaqz259 s set s.jaqz259sal=
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='+') and jaqz259suc=s.jaqz259suc) -
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='-') and jaqz259suc=s.jaqz259suc)  
              where s.jaqz259codc=codigo;
              commit;
--            exception
--            when others then
--              RESULTADO := '1';
--            end;
          END LOOP;
       CLOSE C1;
    END;      */
end sp_rentabilidad_concepto;
/

