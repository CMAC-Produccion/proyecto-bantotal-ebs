create or replace procedure SP_CR_MEMPRESA(p_fecha  in date,
                                           p_codSBS in varchar2,
                                           p_user   in varchar2) is

cursor llenaMatriz (fecha in date) is
    select c_codemp, sum(n_salcap) saldo,D_FECPRE
      from Cldrccs
        Where D_FECPRE = fecha --'28/02/2018'
        and C_CODSBS  = p_codSBS
        and C_TIPDET = 'Z'
        and C_TIPREG = '2'
        and ((substr(c_cuenta,1,4) = '1411') Or (substr(c_cuenta,1,4) = '1413' ) Or (substr(c_cuenta,1,4) = '1414') Or (substr(c_cuenta,1,4) = '1415') Or (substr(c_cuenta,1,4) = '1416') Or (substr(c_cuenta,1,4) = '1418')
        Or (substr(c_cuenta,1,4) = '1421') Or (substr(c_cuenta,1,4) = '1423') Or (substr(c_cuenta,1,4) = '1424') Or (substr(c_cuenta,1,4) = '1425') Or (substr(c_cuenta,1,4) = '1426')
         Or (substr(c_cuenta,1,4) = '1428')
        Or (substr(c_cuenta,1,4) = '7111') Or (substr(c_cuenta,1,4) = '7112') Or (substr(c_cuenta,1,4) = '7113') Or (substr(c_cuenta,1,4) = '7114')
        Or (substr(c_cuenta,1,4) = '7121') Or (substr(c_cuenta,1,4) = '7122') Or (substr(c_cuenta,1,4) = '7123') Or (substr(c_cuenta,1,4) = '7124')
        Or (substr(c_cuenta,1,4) = '8113') Or (substr(c_cuenta,1,4) = '8123')
        Or (substr(c_cuenta,1,6) = '811302') Or (substr(c_cuenta,1,6) = '812302')
        Or (substr(c_cuenta,1,6) = '721501') Or (substr(c_cuenta,1,6) = '721502') Or (substr(c_cuenta,1,6) = '721503') Or (substr(c_cuenta,1,6) = '721504') Or (substr(c_cuenta,1,6) = '721505') Or (substr(c_cuenta,1,6) = '721506') Or (substr(c_cuenta,1,6) = '721507')
        Or (substr(c_cuenta,1,6) = '722501') Or (substr(c_cuenta,1,6) = '722502') Or (substr(c_cuenta,1,6) = '722503') Or (substr(c_cuenta,1,6) = '722504') Or (substr(c_cuenta,1,6) = '722505') Or (substr(c_cuenta,1,6) = '722506') Or (substr(c_cuenta,1,6) = '722507')
       )
        group by c_codemp,D_FECPRE
        order by c_codemp;
  cursor entidades is
    select distinct(jaqz565codemp)
      from jaqz565 where jaqz565user = trim(p_user) --chernandez 05/07/2018
     order by jaqz565codemp;
     
  cursor Insertar(entidad in varchar2)  is
    select  max( decode( JAQZ565FECHA ,p_fecha, JAQZ565SALDO)) col_1,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-1)), JAQZ565SALDO)) col_2,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-2)), JAQZ565SALDO)) col_3,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-3)), JAQZ565SALDO)) col_4,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-4)), JAQZ565SALDO)) col_5,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-5)), JAQZ565SALDO)) col_6,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-6)), JAQZ565SALDO)) col_7,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-7)), JAQZ565SALDO)) col_8,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-8)), JAQZ565SALDO)) col_9,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-9)), JAQZ565SALDO)) col_10,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-10)), JAQZ565SALDO)) col_11,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-11)), JAQZ565SALDO)) col_12,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-12)), JAQZ565SALDO)) col_13,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-13)), JAQZ565SALDO)) col_14,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-14)), JAQZ565SALDO)) col_15,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-15)), JAQZ565SALDO)) col_16,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-16)), JAQZ565SALDO)) col_17,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-17)), JAQZ565SALDO)) col_18,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-18)), JAQZ565SALDO)) col_19,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-19)), JAQZ565SALDO)) col_20,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-20)), JAQZ565SALDO)) col_21,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-21)), JAQZ565SALDO)) col_22,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-22)), JAQZ565SALDO)) col_23,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-23)), JAQZ565SALDO)) col_24,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-24)), JAQZ565SALDO)) col_25,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-25)), JAQZ565SALDO)) col_26,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-26)), JAQZ565SALDO)) col_27,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-27)), JAQZ565SALDO)) col_28,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-28)), JAQZ565SALDO)) col_29,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-29)), JAQZ565SALDO)) col_30,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-30)), JAQZ565SALDO)) col_31,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-31)), JAQZ565SALDO)) col_32,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-32)), JAQZ565SALDO)) col_33,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-33)), JAQZ565SALDO)) col_34,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-34)), JAQZ565SALDO)) col_35,
            max( decode( JAQZ565FECHA ,last_day( add_months(p_fecha,-35)), JAQZ565SALDO)) col_36
       from jaqz565
      where jaqz565codemp = entidad and jaqz565user=trim(p_user)
      order by jaqz565fecha desc;

  a number(2):=1;
  fecha date := p_fecha;
  cont number:= 0;
  valor number;
  nombre varchar2(30);

begin

  delete jaqz565 where jaqz565user = trim(p_user);--chernandez 05/07/2018
  delete jaqz564 where jaqz564user = trim(p_user);--chernandez 05/07/2018
  commit;

  while a <= 36 loop
    for reg in llenamatriz (fecha) loop
        begin
            insert into jaqz565(jaqz565codemp, jaqz565saldo, jaqz565fecha,jaqz565user  )
             values(reg.c_codemp,reg.saldo,reg.d_fecpre,p_user);
        exception
          when dup_val_on_index then
            cont := cont + 1;
        end;
    end loop;

    fecha := last_day( add_months(p_fecha,-a));
    a := a + 1;
  end loop;
  commit;

  for ent in entidades loop
    valor := to_number(ent.jaqz565codemp);
    begin
      select Tp1desc
        into nombre
        from fst198
       where Tp1cod = 1
         and Tp1cod1 = 10849
         and Tp1corr1 = 10
         and Tp1nro1 = valor;
    Exception
      When no_data_found then
         nombre := 'No descripción';
    End;
    For ing in Insertar(ent.jaqz565codemp) loop
      begin
        insert into jaqz564(jaqz564codemp,jaqz564sal1,jaqz564sal2,jaqz564sal3,jaqz564sal4,jaqz564sal5,jaqz564sal6,
                            jaqz564sal7,jaqz564sal8,jaqz564sal9,jaqz564sal10,jaqz564sal11,jaqz564sal12,jaqz564sal13,
                            jaqz564sal14,jaqz564sal15,jaqz564sal16,jaqz564sal17,jaqz564sal18,jaqz564sal19,jaqz564sal20,
                            jaqz564sal21,jaqz564sal22,jaqz564sal23,jaqz564sal24,jaqz564sal25,jaqz564sal26,jaqz564sal27,
                            jaqz564sal28,jaqz564sal29,jaqz564sal30,jaqz564sal31,jaqz564sal32,jaqz564sal33,jaqz564sal34,
                            jaqz564sal35,jaqz564sal36,jaqz564desc,jaqz564user)
             values(ent.jaqz565codemp,ing.col_1,ing.col_2,ing.col_3,ing.col_4,ing.col_5,ing.col_6,ing.col_7,ing.col_8,
                    ing.col_9,ing.col_10,ing.col_11,ing.col_12,ing.col_13,ing.col_14,ing.col_15,ing.col_16,ing.col_17,
                    ing.col_18,ing.col_19,ing.col_20,ing.col_21,ing.col_22,ing.col_23,ing.col_24,ing.col_25,ing.col_26,
                    ing.col_27,ing.col_28,ing.col_29,ing.col_30,ing.col_31,ing.col_32,ing.col_33,ing.col_34,ing.col_35,
                    ing.col_36,nombre,p_user);

      exception
        when dup_val_on_index then
          cont := cont + 1;
      end;
    end loop;
    commit;
  end loop;

end SP_CR_MEMPRESA;
/

