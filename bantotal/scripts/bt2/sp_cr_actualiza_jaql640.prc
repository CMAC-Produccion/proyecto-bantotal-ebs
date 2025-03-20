CREATE OR REPLACE PROCEDURE SP_CR_ACTUALIZA_JAQL640(V_jaql640riesg VARCHAR2,
                                                             v_jaql640prdef NUMBER,
                                                             v_jaql640pndoc CHAR,
                                                             v_jaql640fepre DATE) IS
  -- ---------------------------------------------------------------------------
  -- Nombre                   : SP_CR_ACTUALIZA_jaql640
  -- Sistema                  : BANTOTAL
  -- Módulo                   : BANTOTAL
  -- Versión                  : 1.0
  -- Fecha de Creación        : 2025.02.19
  -- Autor de Creación        : Erika V. Hidalgo Málaga
  -- Uso                      : Actualización sobre la tabla jaql640
  -- Estado                   : Activo
  -- Acceso                   : Público
  -- Fecha de Modificación    : 2025.03.10
  -- Autor de Modificación    : Erika Hidalgo
  -- Descripción Modificación : Mayúsculas al nombre del procedimiento
  -- ---------------------------------------------------------------------------
                                                       
  N_CONT NUMBER;
  usuario varchar2(10);
BEGIN

  SELECT COUNT(1)
    INTO N_CONT
    FROM jaql640
   WHERE jaql640pndoc = v_jaql640pndoc
     and jaql640fepre = v_jaql640fepre;

  IF N_CONT = 1 THEN
    select decode(SUBSTR(USER, 1, 3),'C##',SUBSTR(USER, 4, 3),SUBSTR(USER, 1, 3)) into usuario from dual;
    EXECUTE IMMEDIATE 'create table operador.jaql640_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      usuario ||
                      ' as select * from jaql640 where jaql640pndoc =''' ||
                      v_jaql640pndoc || ''' and jaql640fepre=' ||
                      'to_date('''||to_char(v_jaql640fepre,'DDMMRRRR')||''',''DDMMRRRR'')';

    UPDATE jaql640
       SET jaql640riesg = V_jaql640riesg, jaql640prdef = v_jaql640prdef
     WHERE jaql640pndoc = v_jaql640pndoc
       and jaql640fepre = v_jaql640fepre;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en jaql640 para jaql640pndoc:' ||
                         v_jaql640pndoc || ' y jaql640fepre:' ||
                         to_char(v_jaql640fepre, 'DD/MM/RRRR'));
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en la tabla jaql640 para jaql640pndoc:' ||
                         v_jaql640pndoc || ' y jaql640fepre:' ||
                         to_char(v_jaql640fepre, 'DD/MM/RRRR'));
  END IF;
  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_CR_ACTUALIZA_JAQL640',
     v_jaql640pndoc || '-' || to_char(v_jaql640fepre, 'DD/MM/RRRR') || '-' ||
     V_jaql640riesg || '-' || v_jaql640prdef);
  commit;
END SP_CR_ACTUALIZA_JAQL640;
/

