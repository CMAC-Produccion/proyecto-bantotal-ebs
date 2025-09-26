create or replace procedure sp_rentabilidad_sumasc(re_fecha in date,re_usuario in char,RESULTADO OUT VARCHAR2) is
begin
  RESULTADO := '';
  -- Modificado : KVALENCIAC
  -- Fecha : 10/09/2025
  -- Purpose : Se optimizó consulta
  --- calcula las sumas de conceptos y actualiza la tabla 
    DECLARE
       CURSOR C1 IS select jaqz259scod ,g.jaqz259gord,c.jaqz259csec from jaqz259s 
                    inner join jaqz259c c on c.jaqz259ccod=jaqz259scod 
                    inner join jaqz259G g on g.jaqz259gcod=c.jaqz259ccodg and g.jaqz259gtip=1  ---cuadro 1                
                    group by jaqz259scod,g.jaqz259gord,c.jaqz259csec
                    order by g.jaqz259gord,c.jaqz259csec;
       cursor C2 (ln_codigo varchar) is select JAQZ259SUC 
       from jaqz259 where jaqz259codc = ln_codigo  and jaqz259fecp=re_fecha group by  JAQZ259SUC;
                    
       codigo varchar(6);
       ord numeric(3);
       sec numeric(3);
       ln_mas number(18,2);
       ln_menos number(18,2);
       lc_codigo varchar(6);
    BEGIN
       OPEN C1;
       LOOP
          FETCH C1 INTO codigo,ord,sec;
          EXIT WHEN C1%NOTFOUND;
            lc_codigo:=codigo;  --inicio kvalenciac 10/09/2025
             for k in c2(lc_codigo)  loop  
                  begin 
                    select nvl(sum(jaqz259sal),0) into ln_mas
                    from jaqz259 
                    where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=lc_codigo and jaqz259sope='+') 
                    and jaqz259suc=k.JAQZ259SUC and jaqz259fecp=re_fecha; 
                  exception 
                  when others then
                           ln_mas:=0;
                  end;              
                  begin 
                    select nvl(sum(jaqz259sal),0) into ln_menos
                    from jaqz259 
                    where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=lc_codigo and jaqz259sope='-') 
                    and jaqz259suc=k.JAQZ259SUC and jaqz259fecp=re_fecha ;
                  exception 
                  when others then
                           ln_menos:=0;
                  end ;             

                  Begin  
                     update jaqz259 s set s.jaqz259sal=ln_mas-ln_menos
                     where s.jaqz259codc=lc_codigo
                     and s.jaqz259fecp=re_fecha
                     and s.JAQZ259SUC=k.JAQZ259SUC;
                     commit;
                  exception
                  when DUP_VAL_ON_INDEX then
                    RESULTADO := '1';
                  end;
                   END LOOP; --fin kvalenciac 10/09/2025
                  /*  costo 561 bajo a 25 por cada consulta adicionada mas un cursor
                  update jaqz259 s set s.jaqz259sal=
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='+') and jaqz259suc=s.jaqz259suc and jaqz259fecp=re_fecha) -
              (select nvl(sum(jaqz259sal),0) from jaqz259 where jaqz259codc in (select jaqz259scodc from JAQZ259S where jaqz259scod=s.jaqz259codc and jaqz259sope='-') and jaqz259suc=s.jaqz259suc and jaqz259fecp=re_fecha)  
              where s.jaqz259codc=codigo
              and s.jaqz259fecp=re_fecha;
                 */
             
          END LOOP;
       CLOSE C1;
    END;      
end sp_rentabilidad_sumasc;
/
