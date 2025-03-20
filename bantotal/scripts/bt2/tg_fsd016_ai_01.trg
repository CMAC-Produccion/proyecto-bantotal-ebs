CREATE OR REPLACE TRIGGER TG_FSD016_AI_01
  AFTER INSERT ON FSD016
  FOR EACH ROW
DECLARE
  RequestNumber     VARCHAR2(50);
  UserName          VARCHAR2(50);
  WrkstName         VARCHAR2(50);
  Server            VARCHAR2(50);
  Application       VARCHAR2(50);
  ProgramName       VARCHAR2(50);
  TransactionNumber VARCHAR2(50);
  ConnectionId      VARCHAR2(50);
  ExistConData      NUMBER;
  c_descoper        CHAR(30);
  n_descoper        NUMBER;
  c_nombre          CHAR(35);
  V_HOSTNAME        VARCHAR2( 100 );
BEGIN
  select host_name
    into V_HOSTNAME
    from v$instance;

  SELECT sys_context('USERENV', 'SID') INTO ConnectionId FROM dual;
  SELECT COUNT(*)
    INTO ExistConData
    FROM DBA_OBJECTS
   WHERE OWNER = sys_context('userenv', 'current_schema')
     AND OBJECT_TYPE = 'TABLE'
     AND OBJECT_NAME = 'CONDATA';
  IF ExistConData > 0 THEN
    SELECT MAX(Value)
      INTO RequestNumber
      FROM CONDATA
     WHERE Data = 'REQUESTID';
    SELECT MAX(Value) INTO UserName FROM CONDATA WHERE Data = 'USERID';
    SELECT MAX(Value) INTO WrkstName FROM CONDATA WHERE Data = 'WRKST';
    SELECT MAX(Value) INTO Server FROM CONDATA WHERE Data = 'SERVER';
    SELECT MAX(Value)
      INTO Application
      FROM CONDATA
     WHERE Data = 'APPLICATION';
    SELECT MAX(Value) INTO ProgramName FROM CONDATA WHERE Data = 'PROGRAM';
  END IF;
  RequestNumber     := COALESCE(RequestNumber, '-1');
  TransactionNumber := COALESCE(TransactionNumber, '-1');
  ConnectionId      := COALESCE(ConnectionId, '-1');
  SELECT COALESCE(UserName,
                  sys_context('USERENV', 'SESSION_USER'),
                  'NOTDEFINED')
    INTO UserName
    FROM dual;
  SELECT COALESCE(WrkstName, sys_context('USERENV', 'HOST'), 'NOTDEFINED')
    INTO WrkstName
    FROM dual;
  SELECT COALESCE(Server,
                  sys_context('USERENV', 'SERVER_HOST'),
                  'NOTDEFINED')
    INTO Server
    FROM dual;
  SELECT COALESCE(Application,
                  sys_context('USERENV', 'ACTION'),
                  'NOTDEFINED')
    INTO Application
    FROM dual;
  SELECT COALESCE(ProgramName,
                  sys_context('USERENV', 'ACTION'),
                  'NOTDEFINED')
    INTO ProgramName
    FROM dual;

  IF(:new.CTNRO IN (2412767,2411117,2412731)) then

    SELECT count(1)
      INTO n_descoper
      FROM FST034 A
     WHERE A.PGCOD = :new.PGCOD
       AND A.TRMOD = :new.ITMOD
       AND A.TRNRO = :new.ITTRAN
       AND UPPER(A.TRNOM) LIKE '%ATM%';

    IF (N_DESCOPER>0) THEN

      SELECT A.TRNOM
        INTO c_descoper
        FROM FST034 A
       WHERE A.PGCOD = :new.PGCOD
         AND A.TRMOD = :new.ITMOD
         AND A.TRNRO = :new.ITTRAN
         AND UPPER(A.TRNOM) LIKE '%ATM%';

      INSERT INTO FSD016_AUDIT
        ( aud_new_pgcod,
          aud_new_itsuc,
          aud_new_itmod,
          aud_new_ittran,
          aud_new_itnrel,
          aud_new_itord,
          aud_new_itsbor,
          aud_new_modulo,
          aud_new_ittope,
          aud_new_itsucd,
          aud_new_rubro,
          aud_new_moneda,
          aud_new_papel,
          aud_new_ctnro,
          aud_new_itoper,
          aud_new_itsubo,
          aud_new_itfval,
          aud_new_itfvto,
          aud_new_itpzo,
          aud_new_itper,
          aud_new_itttas,
          aud_new_ittasa,
          aud_new_ittmor,
          aud_new_ittdia,
          aud_new_ittvto,
          aud_new_ittano,
          aud_new_ittint,
          aud_new_itarb,
          aud_new_itarb1,
          aud_new_itmd,
          aud_new_itmd1,
          aud_new_ittcbi,
          aud_new_ittcbi1,
          aud_new_itpre,
          aud_new_itpre1,
          aud_new_itdrev,
          aud_new_itafiv,
          aud_new_itafgt,
          aud_new_itplus,
          aud_new_itcodm,
          aud_new_itser,
          aud_new_itcheq,
          aud_new_itimp1,
          aud_new_itimp2,
          aud_new_itimp3,
          aud_new_itimp4,
          aud_new_itimp5,
          aud_new_itimp6,
          aud_new_itimp7,
          aud_new_itimp8,
          aud_new_itimp9,
          aud_new_itimp10,
          aud_new_itimp11,
          aud_new_itimp12,
          aud_new_itimp13,
          aud_new_itimp14,
          aud_new_itimp15,
          aud_new_itimp16,
          aud_new_itimp17,
          aud_new_itimp18,
          aud_new_itimp19,
          aud_new_itimp20,
          aud_new_itimpo,
          aud_new_itmdao,
          aud_new_itdbha,
          aud_new_itncor,
          aud_new_itbbtt,
          aud_new_itfunc,
          aud_new_itsegm,
          aud_new_itccos,
          aud_new_itcbcu,
          aud_new_itccli,
          aud_new_itref,
          aud_new_itanu,
          aud_new_itposic,
          aud_new_itvalua,
          aud_new_itcltcod,
          aud_new_itpza,
          aud_new_itdcom,
          aud_FSD016_guidkey,
          aud_FSD016_uon,
          aud_FSD016_ut ,
          aud_FSD016_ubr,
          aud_FSD016_ubc,
          aud_FSD016_ubt,
          aud_FSD016_ubu,
          aud_FSD016_uba,
          aud_FSD016_ubs,
          aud_FSD016_ubp,
          aud_FSD016_ubm,
          aud_FSD016_uas)
      VALUES
        ( :new.pgcod,
          :new.itsuc,
          :new.itmod,
          :new.ittran,
          :new.itnrel,
          :new.itord,
          :new.itsbor,
          :new.modulo,
          :new.ittope,
          :new.itsucd,
          :new.rubro,
          :new.moneda,
          :new.papel,
          :new.ctnro,
          :new.itoper,
          :new.itsubo,
          :new.itfval,
          :new.itfvto,
          :new.itpzo,
          :new.itper,
          :new.itttas,
          :new.ittasa,
          :new.ittmor,
          :new.ittdia,
          :new.ittvto,
          :new.ittano,
          :new.ittint,
          :new.itarb,
          :new.itarb1,
          :new.itmd,
          :new.itmd1,
          :new.ittcbi,
          :new.ittcbi1,
          :new.itpre,
          :new.itpre1,
          :new.itdrev,
          :new.itafiv,
          :new.itafgt,
          :new.itplus,
          :new.itcodm,
          :new.itser,
          :new.itcheq,
          :new.itimp1,
          :new.itimp2,
          :new.itimp3,
          :new.itimp4,
          :new.itimp5,
          :new.itimp6,
          :new.itimp7,
          :new.itimp8,
          :new.itimp9,
          :new.itimp10,
          :new.itimp11,
          :new.itimp12,
          :new.itimp13,
          :new.itimp14,
          :new.itimp15,
          :new.itimp16,
          :new.itimp17,
          :new.itimp18,
          :new.itimp19,
          :new.itimp20,
          :new.itimpo,
          :new.itmdao,
          :new.itdbha,
          :new.itncor,
          :new.itbbtt,
          :new.itfunc,
          :new.itsegm,
          :new.itccos,
          :new.itcbcu,
          :new.itccli,
          :new.itref,
          :new.itanu,
          :new.itposic,
          :new.itvalua,
          :new.itcltcod,
          :new.itpza,
          :new.itdcom,
          SYS_GUID(),
          SYSTIMESTAMP,
          SYSTIMESTAMP,
          RequestNumber,
          ConnectionId,
          TransactionNumber,
          UserName,
          Application,
          Server,
          ProgramName,
          WrkstName,
          'I');

      --enviar mail
      begin
        SELECT a.ctnom
          into c_nombre
          FROM FSD008 a
         where a.pgcod = 1
           and a.ctnro = :new.CTNRO; --in (2412767,2411117,2412731);
        sys.sp_sy_enviamail('alertabantotalQA@cajaarequipa.pe',
                          'ehidalgom@cajaarequipa.pe',
                          'Alerta: Cuentas Observadas - INS -' ||
                          sys_context('USERENV', 'DB_NAME') || ' HOST ' || V_HOSTNAME,
                          'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                          'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                          'Nro Cuenta : '|| :new.CTNRO ||CHR(13) ||
                          'Cliente : '|| c_nombre || CHR(13) ||
                          'Operación : '|| c_descoper || CHR(13)
                          );
        sys.sp_sy_enviamail('alertabantotalQA@cajaarequipa.pe',
                          'jobando@cajaarequipa.pe',
                          'Alerta: Cuentas Observadas - INS -' ||
                          sys_context('USERENV', 'DB_NAME') || ' HOST ' || V_HOSTNAME,
                          'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                          'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                          'Nro Cuenta : '|| :new.CTNRO ||CHR(13) ||
                          'Cliente : '|| c_nombre || CHR(13) ||
                          'Operación : '|| c_descoper || CHR(13)
                          );
        sys.sp_sy_enviamail('alertabantotalQA@cajaarequipa.pe',
                          'lcarpio@cajaarequipa.pe',
                          'Alerta: Cuentas Observadas - INS -' ||
                          sys_context('USERENV', 'DB_NAME') || ' HOST ' || V_HOSTNAME,
                          'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                          'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                          'Nro Cuenta : '|| :new.CTNRO ||CHR(13) ||
                          'Cliente : '|| c_nombre || CHR(13) ||
                          'Operación : '|| c_descoper || CHR(13)
                          );
        sys.sp_sy_enviamail('alertabantotalQA@cajaarequipa.pe',
                          'cdelgado@cajaarequipa.pe',
                          'Alerta: Cuentas Observadas - INS -' ||
                          sys_context('USERENV', 'DB_NAME') || ' HOST ' || V_HOSTNAME,
                          'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                          'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                          'Hora Actual en Servidor : ' ||to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                          'Nro Cuenta : '|| :new.CTNRO ||CHR(13) ||
                          'Cliente : '|| c_nombre || CHR(13) ||
                          'Operación : '|| c_descoper || CHR(13)
                          );
      exception
        when others then null;
      end;

    END IF;
  END IF;
END TG_FSD016_AI_01;
/

