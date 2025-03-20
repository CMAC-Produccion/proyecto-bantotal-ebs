CREATE OR REPLACE PROCEDURE SP_CR_CON_SOBEND(P_D_FECHA IN DATE,
                                             P_N_CODRES OUT NUMBER,
                                             P_C_RESULTADO OUT VARCHAR2)
IS

lc_prcsobend varchar2(500);
ln_regini number(17,0);
ln_regfin number(17,0);
ln_count number(10);
ln_limit number(17,4);
lc_hostname varchar2(64);
ln_indpro jaql411.jaql411reg%type;

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

  if (ln_indpro = 0) then

      begin
        select jaql411reg
        into ln_indpro
        from jaql411
        where jaql411fch = P_D_FECHA
        and jaql411rgi = 0;
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
          from jaql154
          where
          jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
          and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA));
        exception when others then
          ln_limit := -1;
        end;

        delete from jaql157 where jaql157ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
                              and jaql157mes = to_number(EXTRACT(MONTH FROM P_D_FECHA));

        ln_limit := ceil(ln_limit/5000);
        ln_regini := 1;
        ln_regfin := 5000;

        insert into jaql411
        (
          jaql411FCH,
          jaql411RGI,
          jaql411RGF,
          jaql411HRI,
          jaql411REG
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

        --drc PRY3303
        begin
          update jaql154
          set jaql154csf = 20, 
          jaql154rdt = 200
          where jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
          and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA))
          and jaql154mod <> 33
          and jaql154ndo in
          (
            select jaql154ndo 
            from jaql154 
            where jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
            and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA))
            and jaql154mod = 33
          );
          commit;    
        exception when others then
          DBMS_OUTPUT.put_line('Error al actualizar castigos.');
        end;        

        --drc PRY3303 (2)
        begin
          update jaql154
          set jaql154csf = 20, 
          jaql154rdt = 200
          where jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
          and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA))
          and jaql154mod <> 200
          and jaql154ndo in
          (
            select jaql154ndo 
            from jaql154 
            where jaql154ani = to_number(EXTRACT(YEAR FROM P_D_FECHA))
            and jaql154mes = to_number(EXTRACT(MONTH FROM P_D_FECHA))
            and jaql154mod = 200
            and jaql154csf = 20
            and jaql154rdt = 200
          );
          commit;    
        exception when others then
          DBMS_OUTPUT.put_line('Error al actualizar castigos.');
        end;        


        FOR i IN 1 .. ln_limit LOOP

          ln_count := i;

          lc_prcsobend := 'PQ_CR_JAQL157_SOBEND.sp_cr_sobreend_jaql157('''||P_D_FECHA||''','||ln_regini||','||ln_regfin||');';
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then    
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
         DBMS_JOB.SUBMIT(ln_count, lc_prcsobend, sysdate + 1 / (24 * 60),instance => 2);--25.02.2014
         else
         DBMS_JOB.SUBMIT(ln_count, lc_prcsobend, sysdate + 1 / (24 * 60));--25.02.2014
        end if;
          ln_regini := ln_regfin + 1;
          ln_regfin := ln_regfin + 5000;

        END LOOP;

        P_C_RESULTADO := 'Ejecutando consolidado de información al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 0;

        COMMIT;

      end if;

      if (ln_indpro = 0) then
        P_C_RESULTADO := 'INFORMACIÓN CONSOLIDADA CORRECTAMENTE AL ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 0;
      end if;

      if (ln_indpro = 1) then
        P_C_RESULTADO := 'El consolidado se encuentra en ejecución al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 0;
      end if;

      if (ln_indpro = -1) then
        P_C_RESULTADO := 'Se produjo un Error al ejecutar el proceso. Intente nuevamente.';
        P_N_CODRES := ln_indpro;
      end if;

  else
      if (ln_indpro is null) then
        P_C_RESULTADO := 'Antes debe PROCESAR la información al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := 1;
      end if;

      if (ln_indpro = 1) then
        P_C_RESULTADO := 'El proceso se encuentra en ejecución al ' || to_char(P_D_FECHA,'DD/MM/YYYY' || '.');
        P_N_CODRES := ln_indpro;
      end if;

      if (ln_indpro = -1) then
        P_C_RESULTADO := 'Se produjo un Error al ejecutar el proceso. Intente nuevamente.';
        P_N_CODRES := ln_indpro;
      end if;
  end if;

EXCEPTION

WHEN OTHERS THEN
  P_C_RESULTADO := SQLERRM;
  P_N_CODRES := SQLCODE;

END;
/

