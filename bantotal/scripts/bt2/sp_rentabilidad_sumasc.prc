create or replace procedure sp_rentabilidad_sumasc(re_fecha in date,re_usuario in char,RESULTADO OUT VARCHAR2) is
begin
  RESULTADO := '';
  --- calcula las sumas de conceptos y actualiza la tabla 
    DECLARE
       CURSOR C1 IS select jaqz259scod ,g.jaqz259gord,c.jaqz259csec from jaqz259s 
                    inner join jaqz259c c on c.jaqz259ccod=jaqz259scod 
                    inner join jaqz259G g on g.jaqz259gcod=c.jaqz259ccodg and g.jaqz259gtip=1  ---cuadro 1                
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
            Begin  
               update jaqz259 s set s.jaqz259sal=
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='+') and jaqz259suc=s.jaqz259suc and jaqz259fecp=re_fecha) -
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='-') and jaqz259suc=s.jaqz259suc and jaqz259fecp=re_fecha)  
              where s.jaqz259codc=codigo
              and s.jaqz259fecp=re_fecha;
              commit;
            exception
            when DUP_VAL_ON_INDEX then
              RESULTADO := '1';
            end;
          END LOOP;
       CLOSE C1;
    END;      
end sp_rentabilidad_sumasc;
/

