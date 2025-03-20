CREATE OR REPLACE TRIGGER TG_ACT_ESTCIV_FSD002
  after update of pfeciv on FSD002
  for each row
declare
  -- pragma autonomous_transaction;
  -- local variables here
   cursor correoRiego is
     select tpdesc
      from fst098
     where pgcod = 1
       and tpcod=7613
       and tpcorr =30;


   NRODOC     CHAR(12);
   pepais1    number(3);
   ll_mensaje clob;
   lv_mensaje VARCHAR2(32767);
   estrab     number := 0;
   V_EXISTE   NUMBER := 0;
   NOMBRE     VARCHAR2(250);
   civ_old    char(20);
   civ_new    char(20);
   documento  char(12);
   petdoc1    NUMBER(3);
   l_crlf char(2) := Chr(13)||Chr(10);---chr(10)||chr(13);
   lc_usuario char(10) := null;
   CORREO1    VARCHAR2(50) := NULL;
   CORREO2    VARCHAR2(50) := NULL;
   CORREO3    VARCHAR2(50) := NULL;
   cod_error  varchar2(20):='000';
   cod_des    varchar2(200);
   USUARIO  char(10);

    RequestNumber     VARCHAR2(50);
  UserName          VARCHAR2(50);
  WrkstName         VARCHAR2(50);
  Server            VARCHAR2(50);
  Application       VARCHAR2(50);
  ProgramName       VARCHAR2(50);
  TransactionNumber VARCHAR2(50);
  ConnectionId      VARCHAR2(50);
  ExistConData      NUMBER;
  nodata            varchar2(3):=null;

begin
 -------------------------
  --  SELECT sys_context('USERENV', 'SID') INTO ConnectionId FROM dual;
  SELECT COUNT(*)
    INTO ExistConData
    FROM DBA_OBJECTS
   WHERE OWNER = sys_context('userenv', 'current_schema')
     AND OBJECT_TYPE = 'TABLE'
     AND OBJECT_NAME = 'CONDATA';
  if ExistConData is null then
    ExistConData := 0;
  end if;  
     
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
   UserName := TRIM(UserName);
 ----------------------------------

  lc_usuario := SUBSTR(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'),1,10);

  documento := :old.pfndoc; ---pfeciv
  pepais1   := :old.pfpais;
  petdoc1   := :old.pftdoc;
  lv_mensaje := null;


  if :new.pfebco ='S' then
    estrab := 1;
  end if;

  nombre := (TRIM(:old.PFAPE1)||' '||TRIM(:old.PFAPE2)||' '||TRIM(:old.PFNOM1)||' '||TRIM(:old.PFNOM2));


  NRODOC := documento;


  if :old.pfeciv <> :new.pfeciv then
    if :old.pfeciv in ('1','3') then
      if :new.pfeciv <> '1' and :new.pfeciv <>'3' then
          V_EXISTE := 1;
       end if;
    end if;
  end if;

  Begin
    select ecnom into civ_old from fst009 where eccod = :old.pfeciv;
  exception
    when no_data_found then
     null;
  end;

  Begin
    select ecnom into civ_new from fst009 where eccod = :new.pfeciv;
  exception
    when no_data_found then
     null;
  end;

     lv_mensaje := 'ALERTA ACTUALIZACION DE DATOS PERSONAS'||l_crlf;
     lv_mensaje := lv_mensaje|| l_crlf;
     lv_mensaje := lv_mensaje ||'Fecha:'||to_char(trunc(sysdate), 'DD-MON-YYYY')||l_crlf;
     lv_mensaje := lv_mensaje ||l_crlf;
     lv_mensaje := lv_mensaje ||'La persona identificado(a) como:  '||NOMBRE ||l_crlf;
     lv_mensaje := lv_mensaje ||'Con número de DNI:   '|| NRODoc ||l_crlf;
     lv_mensaje := lv_mensaje ||'Ha modificado su Estado Civil '||l_crlf;
     lv_mensaje := lv_mensaje ||'De: '||civ_old||l_crlf;
     lv_mensaje := lv_mensaje ||'A:  '|| civ_new ||l_crlf;
     lv_mensaje := lv_mensaje ||'El usuario que realizo la modificacion es:  '|| UserName ||l_crlf;


 --dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
  if V_EXISTE = 1 then
    bEGIN
      select TPDESC INTO CORREO2 from fst098 where tpcod = 7613  AND TPCORR = 40 AND TPNRO =1;
      CORREO2 := TRIM(CORREO2)||'@cajaarequipa.pe';
      select TPDESC INTO CORREO3 from fst098 where tpcod = 7613  AND TPCORR = 50 AND TPNRO =1;
      CORREO3 := TRIM(CORREO3)||'@cajaarequipa.pe';
   END;
    if estrab > 0 then
    -- si es trabajador sys.SP_SY_ENVIAMAIL_SILVIA
     cod_error := '000';
     cod_des := null;
     select trim(tpdesc)
       into CORREO1
       from fst098
      where pgcod = 1
        and tpcod=7613
        and tpcorr =30;


                CORREO1 := TRIM(CORREO1)||'@cajaarequipa.pe';
                BEgin

                pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => CORREO1,
                                                 p_DestinatariosCC   => nodata,
                                                 p_DestinatariosBcc  => nodata ,
                                                 p_Mensaje           => lv_mensaje,
                                                 p_Remitente         => CORREO3,
                                                 p_Asunto            => 'Alerta de Actualización de Estado Civil-- Trabajador',
                                                 p_TipoMensaje       => 'TEXT',
                                                 p_Directorio        => nodata,
                                                 p_ArchivosAdjuntos  => nodata,
                                                 p_c_coderr          => cod_error,--000
                                                 p_c_deserr          => cod_des);  --riesgo
               exception
                 when others then
                   cod_des := trim(cod_des)||'-'||trim(cod_error)||'-'||trim(sqlerrm);  
               end;
               Begin
                pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => CORREO2,
                                                 p_DestinatariosCC   => nodata,
                                                 p_DestinatariosBcc  => nodata ,
                                                 p_Mensaje           => lv_mensaje,
                                                 p_Remitente         => CORREO3,
                                                 p_Asunto            => 'Alerta de Actualización de Estado Civil-- Trabajador',
                                                 p_TipoMensaje       => 'TEXT',
                                                 p_Directorio        => nodata,
                                                 p_ArchivosAdjuntos  => nodata,
                                                 p_c_coderr          => cod_error,--000
                                                 p_c_deserr          => cod_des);  --rrhh
                exception
                 when others then
                   cod_des := trim(cod_des)||'-'||trim(cod_error)||'-'||trim(sqlerrm);  
               end;   

     else
         cod_error := '000';
         cod_des := null;
         select trim(tpdesc)
           into CORREO1
           from fst098
          where pgcod = 1
            and tpcod=7613
            and tpcorr =30;


                CORREO1 := TRIM(CORREO1)||'@cajaarequipa.pe';
                Begin
                
                pq_ah_planillas.P_SendMailAttach(p_DestinatariosPara => CORREO1,
                                                 p_DestinatariosCC   => nodata,
                                                 p_DestinatariosBcc  => nodata ,
                                                 p_Mensaje           => lv_mensaje,
                                                 p_Remitente         => CORREO3,
                                                 p_Asunto            =>  'Alerta de Actualización de Estado Civil--Cliente',
                                                 p_TipoMensaje       => 'TEXT',
                                                 p_Directorio        => nodata,
                                                 p_ArchivosAdjuntos  => nodata,
                                                 p_c_coderr          => cod_error,--000
                                                 p_c_deserr          => cod_des);
                exception
                 when others then
                   cod_des := trim(cod_des)||'-'||trim(cod_error)||'-'||trim(sqlerrm);  
               end;   

     end if;
  end if;

end TG_ACT_ESTCIV_FSD002;
/

