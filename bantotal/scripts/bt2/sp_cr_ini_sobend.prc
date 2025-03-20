CREATE OR REPLACE PROCEDURE SP_CR_INI_SOBEND(P_D_FECHA IN DATE,
                                             P_N_CODRES OUT NUMBER,
                                             P_C_RESULTADO OUT VARCHAR2)
IS

lc_prcsobend varchar2(500);
ln_regini number(17,0);
ln_regfin number(17,0);
ln_count number(10);
ln_limit number(17,4);

ln_indpro jaql410.jaql410reg%type;

ln_anio number := to_number(EXTRACT(YEAR FROM P_D_FECHA));
ln_mes number := to_number(EXTRACT(MONTH FROM P_D_FECHA));
lc_hostname varchar2(64);

BEGIN
begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  begin
    select jaql410reg
    into ln_indpro
    from jaql410
    where jaql410fch = P_D_FECHA
    and jaql410rgi = 0;
  exception
  when no_data_found then
    ln_indpro := null;
  when others then
    ln_indpro := -1;
  end;

  if (ln_indpro is null) then

    begin
      select count(*)
      into ln_limit
      from fsh014 f
      inner join fsr008 r on f.hacta = r.ctnro
                          and f.pgcod = r.pgcod
      inner join xwf700 x on f.pgcod = x.XWFEMPRESA
                    and f.hasuc = x.XWFSUCURSAL
                    and f.hamda = x.XWFMONEDA
                    and f.hapap = x.XWFPAPEL
                    and f.hacta = x.XWFCUENTA
                    and f.haoper = x.XWFOPERACION
                    and f.hasbop = x.XWFSUBOPE
                    and f.hatope = x.XWFTIPOPE
                    and f.hamod = x.XWFMODULO
      where 
      ( f.hamod in (select modulo from fst111 where dscod = 50) or f.hamod = 117 )
      and f.pgcod = 1
      and 
      (
          ( ln_mes = 1 and f.hasd01 <> 0 ) or 
          ( ln_mes = 2 and f.hasd02 <> 0 ) or 
          ( ln_mes = 3 and f.hasd03 <> 0 ) or
          ( ln_mes = 4 and f.hasd04 <> 0 ) or
          ( ln_mes = 5 and f.hasd05 <> 0 ) or
          ( ln_mes = 6 and f.hasd06 <> 0 ) or
          ( ln_mes = 7 and f.hasd07 <> 0 ) or
          ( ln_mes = 8 and f.hasd08 <> 0 ) or
          ( ln_mes = 9 and f.hasd09 <> 0 ) or
          ( ln_mes = 10 and f.hasd10 <> 0 ) or
          ( ln_mes = 11 and f.hasd11 <> 0 ) or
          ( ln_mes = 12 and f.hasd12 <> 0 )                                                                                                                                                                                                                                                                                                            
      )
      and r.cttfir = 'T'
      and x.xwfcar3 = '1'
      and f.haanio = ln_anio;
    exception when others then
      ln_limit := 0;
    end;

    delete from jaql154 where jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                          and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA));

    ln_limit := ceil(ln_limit/1000);
    ln_regini := 1;
    ln_regfin := 1000;

    insert into jaql410
    (
      JAQL410FCH,
      JAQL410RGI,
      JAQL410RGF,
      JAQL410HRI,
      JAQL410REG
    )
    values
    (
      P_D_FECHA,
      0,
      ln_limit,
      sysdate,
      1
    );
    COMMIT;

    FOR i IN 1 .. ln_limit LOOP

      ln_count := i;

      lc_prcsobend := 'PQ_CR_JAQL157_SOBEND.sp_cr_sobreend_jaql154('''||P_D_FECHA||''','||ln_regini||','||ln_regfin||');';
--      if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--      if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
            DBMS_JOB.SUBMIT(ln_count, lc_prcsobend, sysdate + 1 / (24 * 60), null, false, 2, false);
      else
            DBMS_JOB.SUBMIT(ln_count, lc_prcsobend, sysdate + 1 / (24 * 60), null, false, 1, false);
      end if;        

      ln_regini := ln_regfin + 1;
      ln_regfin := ln_regfin + 1000;

    END LOOP;

    P_C_RESULTADO := 'Ejecutando proceso de información al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
    P_N_CODRES := 0;

    COMMIT;

  end if;

  if (ln_indpro = 0) then
    P_C_RESULTADO := 'INFORMACIÓN PROCESADA CORRECTAMENTE AL ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
    P_N_CODRES := 0;
  end if;

  if (ln_indpro = 1) then
    P_C_RESULTADO := 'El proceso se encuentra en ejecución al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
    P_N_CODRES := 0;
  end if;

  if (ln_indpro = -1) then
    P_C_RESULTADO := 'Se produjo un Error al ejecutar el proceso. Intente nuevamente.';
    P_N_CODRES := ln_indpro;
  end if;

EXCEPTION

WHEN OTHERS THEN
  P_C_RESULTADO := SQLERRM;
  P_N_CODRES := SQLCODE;

END;
/

