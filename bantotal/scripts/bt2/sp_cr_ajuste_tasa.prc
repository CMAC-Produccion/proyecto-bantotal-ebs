CREATE OR REPLACE PROCEDURE SP_CR_AJUSTE_TASA(p_aocta  NUMBER,
                                              p_aooper NUMBER,
                                              p_aosbop number,
                                              p_aomod number,
                                              p_evcorr number,
                                              p_d012co char) IS

  N_CONT NUMBER := 0;
BEGIN
  --Luis Carpio/Erika Hidalgo
  if P_D012CO in ('E', 'S','N') then--20072020
    select count(*)
      into n_cont
      from fsd012 i
     where i.pgcod = 1
       and i.aomod = p_aomod
       and i.evtipo = 3
       and i.evcorr = p_evcorr
       and i.aocta = p_aocta
       and i.aooper = p_aooper
       and i.aosbop = p_aosbop;

    IF N_CONT = 1 THEN
      EXECUTE IMMEDIATE 'create table operador.fsd012_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from fsd012 ' ||
                        'where pgcod = 1 and aomod = '||p_aomod||' and evtipo = 3 and evcorr = '||p_evcorr||' and aocta=' ||
                        p_aocta || ' and aooper = ' || p_aooper ||
                        ' and aosbop = ' || p_aosbop;

      update fsd012 i
         set d012co = P_D012CO --
       where i.pgcod = 1
         and i.aomod = p_aomod
         and i.evtipo = 3
         and i.evcorr = p_evcorr
         and i.aocta = p_aocta
         and i.aooper = p_aooper
         and i.aosbop = p_aosbop; -- 1 REGISTRO
      COMMIT;
      dbms_output.put_line('SE ACTUALIZO ' || n_cont || ' registro.');
    ELSE
      dbms_output.put_line('La Cuenta:' || p_aocta || ' La Operacion:' ||p_aooper || ' La Suboperacion:' || p_aosbop ||
                           ' El Modulo:' || p_aomod ||' El Correlativo:' || p_evcorr ||
                           ' considera ' || n_cont || ' registro(s).' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
  else
    dbms_output.put_line('VALOR D012CO:' || P_D012CO ||
                         ', no es E, ni N ni S. No se realizó el Update.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_AJUSTE_TASA',   p_aocta||'-'||p_aooper||'-'||p_aosbop||'-'||p_aomod||'-'||p_evcorr||'-'||p_d012co);
commit;
END SP_CR_AJUSTE_TASA;
/

