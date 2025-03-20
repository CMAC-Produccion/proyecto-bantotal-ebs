CREATE OR REPLACE PROCEDURE SP_CR_ACTUALIZA_jaql639(V_jaql639pdmy NUMBER,
                                                             v_jaql639rimy VARCHAR2,
                                                             v_jaql639cosbs VARCHAR2,
                                                             v_jaql639fepre DATE) IS
  -- ---------------------------------------------------------------------------
  -- Nombre                   : SP_CR_ACTUALIZA_jaql639
  -- Sistema                  : BANTOTAL
  -- Módulo                   : BANTOTAL
  -- Versión                  : 1.0
  -- Fecha de Creación        : 2025.02.27
  -- Autor de Creación        : Erika V. Hidalgo Málaga
  -- Uso                      : Actualización constante sobre la tabla jaql639
  -- Estado                   : Activo
  -- Acceso                   : Público
  -- Fecha de Modificación    : 
  -- Autor de Modificación    : 
  -- Descripción Modificación : 
  -- ---------------------------------------------------------------------------
                                                                     
  N_CONT NUMBER;
  usuario varchar2(10);
BEGIN
 
  SELECT COUNT(1)
    INTO N_CONT
    FROM jaql639
   WHERE jaql639cosbs = v_jaql639cosbs
     and jaql639fepre = v_jaql639fepre;
 
  IF N_CONT = 1 THEN
    select decode(SUBSTR(USER, 1, 3),'C##',SUBSTR(USER, 4, 3),SUBSTR(USER, 1, 3)) into usuario from dual;
    EXECUTE IMMEDIATE 'create table operador.jaql639_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      usuario ||
                      ' as select * from jaql639 where jaql639cosbs =''' ||
                      v_jaql639cosbs || ''' and jaql639fepre=' ||
                      'to_date('''||to_char(v_jaql639fepre,'DDMMRRRR')||''',''DDMMRRRR'')';
 
    UPDATE jaql639
       SET jaql639pdmy = V_jaql639pdmy, jaql639rimy = v_jaql639rimy
     WHERE jaql639cosbs = v_jaql639cosbs
       and jaql639fepre = v_jaql639fepre;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en jaql639 para jaql639cosbs:' ||
                         v_jaql639cosbs || ' y jaql639fepre:' ||
                         to_char(v_jaql639fepre, 'DD/MM/RRRR'));
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en la tabla jaql639 para jaql639cosbs:' ||
                         v_jaql639cosbs || ' y jaql639fepre:' ||
                         to_char(v_jaql639fepre, 'DD/MM/RRRR'));
  END IF;
  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_CR_ACTUALIZA_JAQL639',
     v_jaql639cosbs || '-' || to_char(v_jaql639fepre, 'DD/MM/RRRR') || '-' ||
     V_jaql639pdmy || '-' || v_jaql639rimy);
  commit;
END SP_CR_ACTUALIZA_jaql639;
/

