create or replace package "PQ_RH_USUARIOS" is

  -- Author  : EHIDALGOM
  -- Created : 26/01/2017
  -- Purpose : Cese usuarios

  PROCEDURE sp_rh_cese_usuario_bt(P_C_USERCES  IN CHAR,
                               P_C_NUMDOC IN varCHAR2,
                               P_D_FECCES IN DATE,
                               P_OK OUT CHAR);
                               
  PROCEDURE SP_RH_BLOQUEA_USER_BD_BT(P_C_USERCES  IN CHAR);
  PROCEDURE SP_RH_BLOQUEA_USER_BD_VESTA(P_C_USERCES  IN CHAR);
  PROCEDURE SP_RH_BLOQUEA_USER_BD_EBS(P_C_USERCES  IN CHAR);
  PROCEDURE SP_RH_BLOQUEA_USER_BD_FTS(P_C_USERCES  IN CHAR);  
  PROCEDURE SP_RH_BLOQUEA_USER_BD_SIX(P_C_USERCES  IN CHAR);    
                                   
  PROCEDURE sp_rh_cese_usuario_ebs(P_C_USERCES  IN VARCHAR2,
                               P_C_NUMDOC IN varCHAR2,
                               P_D_FECCES IN DATE,
                               P_OK OUT CHAR);
                               
  PROCEDURE sp_rh_rep_userscesados (P_C_RECIPIENTE  IN VARCHAR2);   
  
  PROCEDURE sp_rh_rep_userscesados_csv ;   

  PROCEDURE sp_rh_rep_user_li_vc_txt;
  
  PROCEDURE sp_rh_rep_usercesa_cyberseg (P_C_RECIPIENTE  IN VARCHAR2);   
  
  FUNCTION FN_TR_FECULTASESS(p_user in char) return date;
  
end pq_rh_usuarios;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body "PQ_RH_USUARIOS" is
  PROCEDURE sp_rh_cese_usuario_bt(P_C_USERCES  IN CHAR, P_C_NUMDOC IN varCHAR2, P_D_FECCES in date, P_OK OUT CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR2(100);
  V_CELULAR_CLIENTE  VARCHAR2(20);
  N_CONT number;
  cursor c1 is
     select ctnro from fsr008 where pgcod=1 and pendoc=P_C_NUMDOC;
  Begin
    select HOST_NAME INTO V_HOSTNAME from v$instance;
    DELETE FROM PRFU00 WHERE UBUSER=P_C_USERCES; 
    
--    INSERT INTO PRFU00 (PGCOD,PRFGCOD, UBUSER, PRFUFECALT, PRFUFECVTO,PRFUUSER, PRFUTPO) VALUES(1,'CESADO',P_C_USERCES,P_D_FECCES/**/,'31/12/2040','JOB_CESE'/*???*/,0);
--28.02.2017 en fecha alta colocar fecha actual, no fecha de cese
    INSERT INTO PRFU00 (PGCOD,PRFGCOD, UBUSER, PRFUFECALT, PRFUFECVTO,PRFUUSER, PRFUTPO) VALUES(1,'CESADO',P_C_USERCES,trunc(sysdate)/*P_D_FECCES*/,'31/12/2040','JOB_CESE'/*???*/,0);
    UPDATE FST046 SET PGCOD=1,UBUSER=P_C_USERCES,UBSUC=904/**/, UBCAJ='N', UBNCAJ=0, UBNIV=0, UBMNU='MINSTAL', UBPRD=0 where Ubuser=P_C_USERCES;
    UPDATE MBC009 SET MBC9SUC=904/**/,MBC9NCAJ=0,MBC9CAJH='N',MBC9CAJ='N',MBC9TES='N' WHERE MBC9USU=P_C_USERCES;
    DELETE FROM fst056 WHERE UBUSER=P_C_USERCES;
    UPDATE SNG057 SET SNG057JEF=' ' where SNG057USR=P_C_USERCES;

--    UPDATE SNGU02 SET SNGU02INH ='S', SNGU02FIN=P_D_FECCES/**/  WHERE SNGU02USR=P_C_USERCES;
--01.03.2017 en fecha colocar fecha actual, no fecha de cese   
    UPDATE SNGU02 SET SNGU02INH ='S', SNGU02FIN=trunc(sysdate)  WHERE SNGU02USR=P_C_USERCES;
    UPDATE RENIEC.REMUSUA SET C_CODEST=' ' WHERE C_CODUSU=trim(P_C_USERCES) or C_CODUSU=P_C_USERCES;
    
    DELETE FROM RENIEC.REDPEUS WHERE C_CODUSU=trim(P_C_USERCES) or C_CODUSU=P_C_USERCES;
    
    UPDATE RENIEC.REDCOUS SET N_NUMCON=0 WHERE C_CODUSU=trim(P_C_USERCES) or C_CODUSU=P_C_USERCES;
    UPDATE FSE101 SET PEXING='1' WHERE PENDOC=P_C_NUMDOC/**/;
    UPDATE fsd002 SET PFEBCO='N' WHERE PFNDOC=P_C_NUMDOC/**/;
    UPDATE SNGC60 SET SNGC60TIPA=12, SNGC60ACTE=99  WHERE SNGC60NDOC=P_C_NUMDOC/**/;
    
    for i in c1 loop
      UPDATE FSD008 SET SECCOD=1, CTEMPL='N' WHERE pgcod=1 and CTNRO=i.ctnro;
    end loop;
    
    DELETE FROM WFROLES1 WHERE WFUSRCOD=rpad(P_C_USERCES,30,' ');

    --febrero 2020
    DELETE FROM FST047 WHERE UBUSER=P_C_USERCES;
    DELETE FROM FST048 WHERE UBUSER=P_C_USERCES;
    commit;

    --marzo 2022
    begin
      SELECT COUNT(9) INTO N_CONT FROM CLIENTES_AFILIADOS WHERE CODIGO_CLIENTE = TRIM(P_C_USERCES) and rownum<2;
      IF N_CONT=1 THEN
        SELECT CELULAR_CLIENTE INTO V_CELULAR_CLIENTE FROM CLIENTES_AFILIADOS WHERE CODIGO_CLIENTE = TRIM(P_C_USERCES) and rownum<2;
--        DELETE FROM CLIENTES_AFILIADOS WHERE CELULAR_CLIENTE =V_CELULAR_CLIENTE;
        DELETE FROM CLIENTES_AFILIADOS WHERE CODIGO_CLIENTE = TRIM(P_C_USERCES);--abr2022
        commit;        
        DELETE FROM JAQL708 A WHERE A.JAQL708USR=P_C_USERCES;
        commit;
        delete from WPLSTEU B where B.C_CODUSU=trim(P_C_USERCES) and B.C_NUMERO=V_CELULAR_CLIENTE;
        commit;
      END IF;  
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      SP_RH_BLOQUEA_USER_BD_BT(P_C_USERCES);
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      SP_RH_BLOQUEA_USER_BD_VESTA(P_C_USERCES);
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      SP_RH_BLOQUEA_USER_BD_EBS(P_C_USERCES);
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      SP_RH_BLOQUEA_USER_BD_FTS(P_C_USERCES);
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      SP_RH_BLOQUEA_USER_BD_SIX(P_C_USERCES);
    EXCEPTION 
      WHEN OTHERS THEN
        NULL;
    END;
    
    P_OK := 'S';
  exception
    when others then 
      P_OK := 'N'; 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_CESE_USUARIO_BT: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_CESE_USUARIO_BT ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||P_C_NUMDOC||'-'||P_D_FECCES||CHR(13)||LVCCAD);
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_CESE_USUARIO_BT ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||P_C_NUMDOC||'-'||P_D_FECCES||CHR(13)||LVCCAD);                    
      exception
        when others then
          null;
      end;
  End sp_rh_cese_usuario_bt;
  
  ---------------------------------------------------------
  PROCEDURE SP_RH_BLOQUEA_USER_BD_BT(P_C_USERCES  IN CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  usuario VARCHAR(100);
  Begin
     select username 
     into usuario
     from systabrep.sy_users_bt 
     where rpad(upper(replace(correo, '@cajaarequipa.pe', '')),10,' ')=P_C_USERCES and habilitado='S';
     
     SP_SY_BLOQUEA_USER(usuario);
     
     update systabrep.sy_users_bt 
       set habilitado='N',fechabloqueo=sysdate
      where username=usuario and habilitado='S';
     commit;
     --09.07.2019
     begin
       sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Usuario Bloqueado de BD BT ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD BT : '||P_C_USERCES||'-'||CHR(13));
       sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Usuario Bloqueado de BD BT ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD BT : '||P_C_USERCES||'-'||CHR(13));
      exception
          when others then
            null;
      end;
  exception
    when no_data_found then
      null;
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_BLOQUEA_USER_BD_BT: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Error SP_RH_BLOQUEA_USER_BD_BT ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);                          
      sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Error SP_RH_BLOQUEA_USER_BD_BT ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);  
                                                 
  End SP_RH_BLOQUEA_USER_BD_BT;   

  ---------------------------------------------------------
  
  ---------------------------------------------------------
  PROCEDURE SP_RH_BLOQUEA_USER_BD_VESTA(P_C_USERCES  IN CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  usuario VARCHAR(100);
  Begin
     select "c_lsmlsm"
     into usuario
     from t_lsmi@VESTA
     where "c_lsmlsm"=lower(trim(P_C_USERCES));
     commit;
     
     update t_lsmi@VESTA
       set "c_stilsm"=0
     WHERE "c_lsmlsm"=usuario;
     commit;

  exception
    when no_data_found then
      ROLLBACK;
      null;
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_BLOQUEA_USER_BD_VESTA: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin  
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_VESTA ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);                          
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_VESTA ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);   
      exception
          when others then
            null;
      end;
  End SP_RH_BLOQUEA_USER_BD_VESTA;   

  ---------------------------------------------------------
  
  ---------------------------------------------------------
  PROCEDURE SP_RH_BLOQUEA_USER_BD_EBS(P_C_USERCES  IN CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  usuario VARCHAR(100);
  Begin
     select username 
     into usuario
     from systabrep.sy_users_ebs@erp
     where rpad(upper(replace(correo, '@cajaarequipa.pe', '')),10,' ')=P_C_USERCES and habilitado='S';
     
     SP_SY_BLOQUEA_USER@erp(usuario);
     
     update systabrep.sy_users_ebs@erp
       set habilitado='N',fechabloqueo=sysdate
      where username=usuario and habilitado='S';
     commit;

     begin
       sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Usuario Bloqueado de BD EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD EBS : '||P_C_USERCES||'-'||CHR(13));
       sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Usuario Bloqueado de BD EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD EBS : '||P_C_USERCES||'-'||CHR(13));                                       
    exception
        when others then
          null;
    end;  
  exception
    when no_data_found then
      null;
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_BLOQUEA_USER_BD_EBS: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);                          
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);  
      exception
        when others then
          null;
      end;                                           
  END SP_RH_BLOQUEA_USER_BD_EBS;
  ---------------------------------------------------------
  
  ---------------------------------------------------------
  PROCEDURE SP_RH_BLOQUEA_USER_BD_FTS(P_C_USERCES  IN CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  usuario VARCHAR(100);
  Begin
     select username 
     into usuario
     from systabrep.sy_users_sw@FTS
     where rpad(upper(replace(correo, '@cajaarequipa.pe', '')),10,' ')=P_C_USERCES and habilitado='S';
 
     SP_SY_BLOQUEA_USER@FTS2(usuario);
     
     update systabrep.sy_users_sw@FTS
       set habilitado='N',fechabloqueo=sysdate
      where username=usuario and habilitado='S';
     commit;

     begin
       sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Usuario Bloqueado de BD FTS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD FTS : '||P_C_USERCES||'-'||CHR(13));
       sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Usuario Bloqueado de BD FTS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD FTS : '||P_C_USERCES||'-'||CHR(13));                                       
    exception
        when others then
          null;
    end;  
  exception
    when no_data_found then
      null;
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_BLOQUEA_USER_BD_FTS: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_FTS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);                          
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_FTS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);  
      exception
        when others then
          null;
      end;                                           
  END SP_RH_BLOQUEA_USER_BD_FTS;
  ---------------------------------------------------------
  
  ---------------------------------------------------------
  PROCEDURE SP_RH_BLOQUEA_USER_BD_SIX(P_C_USERCES  IN CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  usuario VARCHAR(100);
  Begin
     select username 
     into usuario
     from systabrep.sy_users_six@SIX
     where rpad(upper(replace(correo, '@cajaarequipa.pe', '')),10,' ')=P_C_USERCES and habilitado='S';

     SP_SY_BLOQUEA_USER@SIX(usuario);
     
     update systabrep.sy_users_six@SIX
       set habilitado='N',fechabloqueo=sysdate
      where username=usuario and habilitado='S';
     commit;

     begin
       sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Usuario Bloqueado de BD SIX ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD SIX : '||P_C_USERCES||'-'||CHR(13));
       sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Usuario Bloqueado de BD SIX ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Se bloqueó al usuario de BD SIX : '||P_C_USERCES||'-'||CHR(13));                                       
    exception
        when others then
          null;
    end;  
  exception
    when no_data_found then
      null;
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_BLOQUEA_USER_BD_SIX: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_SIX ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);                          
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_BLOQUEA_USER_BD_SIX ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||CHR(13)||LVCCAD);  
      exception
        when others then
          null;
      end;                                           
  END SP_RH_BLOQUEA_USER_BD_SIX;
  ---------------------------------------------------------
  
  PROCEDURE sp_rh_cese_usuario_ebs(P_C_USERCES  IN VARCHAR2, P_C_NUMDOC IN varCHAR2, P_D_FECCES in date, P_OK OUT CHAR) is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  Begin
     --01.03.2017 en fecha fin colocar fecha actual, no fecha de cese
     --UPDATE FND_USER@erp SET END_DATE=P_D_FECCES WHERE USER_NAME=P_C_USERCES;
--     UPDATE FND_USER@erp SET END_DATE=trunc(sysdate) WHERE USER_NAME=P_C_USERCES;
     UPDATE FND_USER@erp 
            SET END_DATE=trunc(sysdate), last_updated_by=-2, last_update_date=sysdate 
                WHERE USER_NAME=P_C_USERCES;
     commit;
     P_OK := 'S';
  exception
    when others then 
      P_OK := 'N'; 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_CESE_USUARIO_EBS: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_CESE_USUARIO_EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||P_C_NUMDOC||'-'||P_D_FECCES||CHR(13)||LVCCAD);
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_CESE_USUARIO_EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||P_C_USERCES||'-'||P_C_NUMDOC||'-'||P_D_FECCES||CHR(13)||LVCCAD);  
      exception
        when others then
          null;
      end;
  End sp_rh_cese_usuario_ebs;   
  
  ---------------------------------------------------------
  PROCEDURE sp_rh_rep_userscesados (P_C_RECIPIENTE  IN VARCHAR2) is
    cursor c_trabcesa is
    select 
      jaqz499ndi, 
      jaqz499usr, 
      jaqz499nap, 
      jaqz499nam, 
      jaqz499ntr, 
      jaqz499fce, 
      jaqz499ctr, 
      jaqz499sbt, 
      jaqz499seb,
      jaqz499des,
      JAQZ499UCE
      FROM JAQZ499H 
    where trunc(JAQZ499FPR) = trunc(sysdate);

    v_wstring varchar2 (32000);
    v_header varchar2(10000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(80);
    C_SMTP_SERVER VARCHAR2(30);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2( 100 );
    rawData    RAW(32000);
    c_dni VARCHAR2(100);
    v_found number;
    n_Port number;
  BEGIN
    SELECT HOST_NAME
      INTO VHOST_NAME
    FROM V$INSTANCE;

SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
  
  
--    IF UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','BTRAC4051'/*DGLIMA*/) then
--    if  UPPER(VHOST_NAME) IN ('SC01ZDBADM010101','SC01ZDBADM020101','T54BTRAC4052','T74BTRAC4051') then
      if v_found =1 then

        v_From      := 'ceseusuarios@cajaarequipa.pe';
        v_Recipient := P_C_RECIPIENTE;
        v_Subject   := 'Relacion de Trabajadores Cesados - '||to_char(sysdate, 'yyyy.mm.dd');
        C_SMTP_SERVER := '10.0.200.68';
        n_Port := 2528;
        
        select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
        select port into n_Port from  systabrep.hostnames_mail where habilitado='S';
        
--        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER, 2528);
        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER,n_Port);
        msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                         'From: ' || v_From || utl_tcp.crlf ||
                         'Subject: ' || v_Subject || utl_tcp.crlf ||
                         'To: ' || v_Recipient || utl_tcp.crlf;

        --Se negocia la transaccion con el servidor SMTP
        utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
        utl_smtp.Mail(V_Conexion, v_From);
        utl_smtp.Rcpt(V_Conexion, v_Recipient);
        UTL_SMTP.OPEN_DATA(V_Conexion);

        --Se escribe la cabecera
        UTL_SMTP.WRITE_DATA(V_Conexion, msg);
          utl_smtp.write_data(V_Conexion,
                              'MIME-Version: 1.0' || utl_tcp.crlf);                                                                     -- Use MIME mail standard
          utl_smtp.write_data(V_Conexion,'Content-Type: multipart/mixed;' ||utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf);

          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              'Content-Type: text/plain;' || utl_tcp.crlf);
                              --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Trabajadores Cesados - ' || to_char(sysdate, 'DD-MM-RRRR') ||  CHR(13)
                              || CHR(13) || CHR(13) || 'Las comillas simples ('') se agregaron al inicio de las celdas del excel para reconocer los ceros de adelante.' || utl_tcp.crlf); --Message Body
          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              --'Content-Type: text/plain;' || utl_tcp.crlf);--
                              'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' name=RELACION_TRABCESE_' || to_char(sysdate, 'DD-MM-RR') || utl_tcp.crlf); --xls
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Disposition: attachment;' ||
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' filename=RELACION_TRAB_CESADOS_' || to_char(sysdate, 'DD-MM-RR')||'.xls'|| utl_tcp.crlf ||
                              utl_tcp.crlf);

        v_header :='DOC. IDE.'||chr(9)||'USUARIO'||chr(9)||'APELLIDO PATERNO'||chr(9)||'APELLIDO MATERNO'||chr(9)||
                   'NOMBRES'||chr(9)||'FECHA_CESE'||chr(9)||
                   'CODIGO_TRAB'||chr(9)||'CESADO_OK_BT'||chr(9)||'CESADO_OK_EBS'||chr(9)||
                   'DESC_ERROR'||chr(9)||'USER_CESO_OFIPLAN';
        utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);

        for r_trab in c_trabcesa loop
--             select decode(substr(r_trab.jaqz499ndi,1,1),'0','''','') into c_DNI from dual;
             c_DNI := '''';  
             v_wstring := c_DNI||r_trab.jaqz499ndi||chr(9)||r_trab.jaqz499usr||chr(9)||r_trab.jaqz499nap||chr(9)||
                                r_trab.jaqz499nam||chr(9)||r_trab.jaqz499ntr||chr(9)||to_char(r_trab.jaqz499fce,'RRRR/MM/DD')||chr(9)||
                          ''''||r_trab.jaqz499ctr||chr(9)||r_trab.jaqz499sbt||chr(9)||r_trab.jaqz499seb||chr(9)||
                          r_trab.jaqz499des||chr(9)||r_trab.JAQZ499UCE;
          --utl_smtp.write_data(V_Conexion,v_wstring||utl_tcp.crlf);
          -- transforma el v_wstring en RAW y escribe el cuerpo del correo
          rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);

        end loop;

        v_wstring := ' ';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := ' ';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'ESTADOS DE CESE:';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'OK=>Usuario fue cesado correctamente';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'YCE=>Usuario ya estaba cesado';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'NEX=>Usuario no existe';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);

        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);

        --Cerramos la conexion
        UTL_SMTP.close_data(V_Conexion);
        UTL_SMTP.quit(V_Conexion);      
    end if;  
  EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);  
  end sp_rh_rep_userscesados;   
  
  -------------------------------------------------------------------------------------------------------------------
  PROCEDURE sp_rh_rep_userscesados_csv is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  n_var number;
  Begin
    select HOST_NAME INTO V_HOSTNAME from v$instance;
    
    if(to_char(sysdate,'HH24:MI') = '05:20') then
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate)-1,'DD/MM/RRRR')||' 23:20:01','DD/MM/RRRR HH24:MI:SS') and
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 05:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user',
                                          'DIR_CESEUSERS')) nt;
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between
                                                          to_date(to_char(trunc(sysdate) - 1,'DD/MM/RRRR') ||' 23:20:01','DD/MM/RRRR HH24:MI:SS') and
                                                          to_date(to_char(trunc(sysdate),'DD/MM/RRRR') ||' 05:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user_' ||
                                          to_char(SYSDATE,'DD_MM_YYYY_HH24_MI_SS'),
                                          'DIR_CESEUSERS')) nt;
    
    end if;
    
    if(to_char(sysdate,'HH24:MI') = '11:20') then
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 05:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 11:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user',
                                          'DIR_CESEUSERS')) nt;
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 05:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 11:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user_' ||
                                          to_char(SYSDATE,'DD_MM_YYYY_HH24_MI_SS'),
                                          'DIR_CESEUSERS')) nt;
    
    end if;
    
    if(to_char(sysdate,'HH24:MI') = '17:20') then
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 11:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 17:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user',
                                          'DIR_CESEUSERS')) nt;
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 11:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 17:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user_' ||
                                          to_char(SYSDATE,'DD_MM_YYYY_HH24_MI_SS'),
                                          'DIR_CESEUSERS')) nt;
    
    end if;

    if(to_char(sysdate,'HH24:MI') = '23:20') then
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 17:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 23:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user',
                                          'DIR_CESEUSERS')) nt;
      SELECT 1
        into n_var
        FROM TABLE(fn_ad_parallel_dump_v3(CURSOR (select trim(USUARIO)
                                             from (select 0 fila,
                                                          'Name' USUARIO
                                                     from dual
                                                   union
                                                   select distinct rownum     fila,
                                                                   JAQZ499USR USUARIO
                                                     FROM JAQZ499H
                                                    where JAQZ499USR is not null
                                                      and JAQZ499FPR between 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 17:20:01','DD/MM/RRRR HH24:MI:SS') and 
                                                      to_date(to_char(trunc(sysdate),'DD/MM/RRRR')||' 23:20:00','DD/MM/RRRR HH24:MI:SS'))
                                            order by fila),
                                          'user_' ||
                                          to_char(SYSDATE,'DD_MM_YYYY_HH24_MI_SS'),
                                          'DIR_CESEUSERS')) nt;
    
    end if;
    
  exception
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_REP_USERSCESADOS_CSV: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Error SP_RH_REP_USERSCESADOS_CSV ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar csv: '||LVCCAD);                                        
      sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Error SP_RH_REP_USERSCESADOS_CSV ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar csv: '||LVCCAD);                     
  End sp_rh_rep_userscesados_csv;
  
  ---------------------------------------------------------
  PROCEDURE sp_rh_rep_user_li_vc_txt is
  LVCCAD VARCHAR2(2000);
  V_HOSTNAME  VARCHAR(100);
  n_var number;
  Begin
    select HOST_NAME INTO V_HOSTNAME from v$instance;
    SELECT 1
      into n_var
      FROM TABLE(FN_AD_PARALLEL_DUMP_V1(CURSOR
--FROM TABLE(fn_ad_parallel_dump_v3(CURSOR
                                  (
                                  /*SELECT lower(trim(UBUSER)) UBUSER
                                     FROM JAQZ601
                                    WHERE FECINI = TRUNC(SYSDATE) - 60
                                      AND FECTERM >= TRUNC(SYSDATE)
                                    ORDER BY FECTERM DESC*/
                                    /*SELECT lower(trim(UBUSER)) FROM JAQZ601 
                                    WHERE TRUNC(SYSDATE) BETWEEN FECINI AND FECTERM 
                                    UNION
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 WHERE FECTERM=TRUNC(SYSDATE)-5*/
                                    --26.03.2018
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 
                                    WHERE TRUNC(SYSDATE) BETWEEN FECINI AND FECTERM 
                                    UNION
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 WHERE TRUNC(SYSDATE)-FECTERM between 0 and 5 
                                  ),
                                  'RELACION_TRAB_LIC_VAC',
                                  'DIR_CESEUSERS')) nt;
    SELECT 1
      into n_var
      FROM TABLE(FN_AD_PARALLEL_DUMP_V1(CURSOR
--FROM TABLE(fn_ad_parallel_dump_v3(CURSOR
                                  (/*SELECT lower(trim(UBUSER)) UBUSER
                                     FROM JAQZ601
                                    WHERE FECINI = TRUNC(SYSDATE) - 60
                                      AND FECTERM >= TRUNC(SYSDATE)
                                    ORDER BY FECTERM DESC*/
                                    /*SELECT lower(trim(UBUSER)) FROM JAQZ601 
                                    WHERE TRUNC(SYSDATE) BETWEEN FECINI AND FECTERM 
                                    UNION
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 WHERE FECTERM=TRUNC(SYSDATE)-5*/
                                    --26.03.2018
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 
                                    WHERE TRUNC(SYSDATE) BETWEEN FECINI AND FECTERM 
                                    UNION
                                    SELECT lower(trim(UBUSER)) FROM JAQZ601 WHERE TRUNC(SYSDATE)-FECTERM between 0 and 5 
                                  ),
                                  'RELACION_TRAB_LIC_VAC_' ||
                                  to_char(SYSDATE, 'DD_MM_YYYY_HH24_MI_SS'),
                                  'DIR_CESEUSERS')) nt;
  exception
    when others then 
      LVCCAD := TO_CHAR('PQ_RH_USUARIOS-SP_RH_REP_USER_LI_VC_TXT: '||SQLCODE||' - '||SQLERRM);
      ROLLBACK;
      sys.sp_sy_enviamail('lcvcusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Error SP_RH_REP_USER_LI_VC_TXT ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar txt: '||LVCCAD);                    
      sys.sp_sy_enviamail('lcvcusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Error SP_RH_REP_USER_LI_VC_TXT ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error al procesar txt: '||LVCCAD);                   

  End sp_rh_rep_user_li_vc_txt; 
  
  FUNCTION FN_TR_FECULTASESS(p_user in char) return date is
  d_ultfecsess date;
  begin
    select aud_fst946_uon
      into d_ultfecsess
      from (select b.aud_fst946_uon
              from aud_fst946_audit b
             where (b.aud_old_sessusr = p_user or b.aud_new_sessusr = p_user)
               and b.aud_fst946_uas = 'I'
             order by b.aud_fst946_uon desc)
     where rownum < 2;
    return d_ultfecsess;
  exception
    when no_data_found then
      d_ultfecsess := TO_DATE('01010001', 'DDMMYYYY');
      return d_ultfecsess;
    when others then
      d_ultfecsess := null;
      return d_ultfecsess;
  END FN_TR_FECULTASESS;
  

  PROCEDURE SP_RH_REP_USERCESA_CYBERSEG (P_C_RECIPIENTE  IN VARCHAR2) is
    cursor c_trabcesa is
    SELECT B.UBUSER USUARIO, B.PRFUFECALT FECHA_ALTA,B.PRFGCOD ESTADO,
       a.jaqz499ctr CODIGO_TRAB,
       a.jaqz499ndi DNI,
--       a.jaqz499usr USUARIO,
       a.jaqz499nap APEPAT,
       a.jaqz499nam APEMAT,
       a.jaqz499ntr NOMBRES,
       a.jaqz499sbt CESE_OK_BT,
       a.jaqz499seb CESE_OK_EBS,
       a.jaqz499des DESCR_ERROR,
       to_char(a.JAQZ499FAC,'DD/MM/RRRR') FECHA_CESE_OFIPLAN,
       to_char(a.JAQZ499FAC,'HH24:MI:SS') HORA_CESE_OFIPLAN,       
       a.jaqz499fce FECHA_BD_OFIPLAN,
       to_char(a.JAQZ499FPR,'DD/MM/RRRR') FECHA_CESE_JOB,
       to_char(a.JAQZ499FPR,'HH24:MI:SS') HORA_CESE_JOB,       
--       to_char(fn_tr_fecultasess(a.jaqz499usr),'DD/MM/RRRR') FECHA_ULT_SESS,
--       to_char(fn_tr_fecultasess(a.jaqz499usr),'HH24:MI:SS') HORA_ULT_SESS,
       (select max(seg002fci) from seg002 where seg002usu=a.jaqz499usr) FECHA_ULT_CONBT,
       (select max(seg002hri) from seg002 where seg002usu=a.jaqz499usr and seg002fci=(select max(seg002fci) from seg002 where seg002usu=a.jaqz499usr)) HORA_ULT_CONBT,
       (select ubfech from fst746 where ubuser = a.jaqz499usr) FECHA_ULT_ACT,
       (select ubhora from fst746 where ubuser = a.jaqz499usr) HORA_ULT_ACT
  FROM prfu00 B left join JAQZ499H a on (B.UBUSER=a.jaqz499usr
     and trunc(a.JAQZ499FPR) between trunc(sysdate - 4, 'MM') and trunc(last_day(sysdate - 4)))
 WHERE B.PRFGCOD = 'CESADO    '
   and B.PRFUFECALT between trunc(sysdate - 4, 'MM') and trunc(last_day(sysdate - 4))
   order by 14;

    v_wstring varchar2 (32000);
    v_header varchar2(10000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
    v_Subject   VARCHAR2(80);
    C_SMTP_SERVER VARCHAR2(30);
    V_Conexion    utl_smtp.Connection;
    msg           varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2( 100 );
    rawData    RAW(32000);
    c_dni VARCHAR2(100);
    v_found number;
    n_Port number;
  BEGIN
    SELECT HOST_NAME
      INTO VHOST_NAME
    FROM V$INSTANCE;

SELECT count(*) into v_found
  FROM systabrep.hostnames 
  where habilitado = 'S' and upper(host_name)=UPPER(vhost_name);
  
  
      if v_found =1 then

        v_From      := 'ceseusuarios@cajaarequipa.pe';
        v_Recipient := P_C_RECIPIENTE;
        v_Subject   := 'Relacion de Trabajadores Cesados - '||to_char(sysdate-4, 'yyyy.mm');
        
        select host_name into C_SMTP_SERVER from  systabrep.hostnames_mail where habilitado='S';
        select port into n_Port from  systabrep.hostnames_mail where habilitado='S';
        
        V_Conexion    := UTL_SMTP.OPEN_CONNECTION(C_SMTP_SERVER,n_Port);
        msg           := 'Date: ' ||to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||utl_tcp.crlf ||
                         'From: ' || v_From || utl_tcp.crlf ||
                         'Subject: ' || v_Subject || utl_tcp.crlf ||
                         'To: ' || v_Recipient || utl_tcp.crlf;

        --Se negocia la transaccion con el servidor SMTP
        utl_smtp.Helo(V_Conexion, C_SMTP_SERVER);
        utl_smtp.Mail(V_Conexion, v_From);
        utl_smtp.Rcpt(V_Conexion, v_Recipient);
        UTL_SMTP.OPEN_DATA(V_Conexion);

        --Se escribe la cabecera
        UTL_SMTP.WRITE_DATA(V_Conexion, msg);
          utl_smtp.write_data(V_Conexion,
                              'MIME-Version: 1.0' || utl_tcp.crlf);                                                                     -- Use MIME mail standard
          utl_smtp.write_data(V_Conexion,'Content-Type: multipart/mixed;' ||utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,' boundary=-----SECBOUND' || utl_tcp.crlf ||utl_tcp.crlf);

          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              'Content-Type: text/plain;' || utl_tcp.crlf);
                              --'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf || utl_tcp.crlf || 'Adj. Relación de Trabajadores Cesados - ' || to_char(sysdate-4, 'MM-RRRR') ||  CHR(13)
                              || CHR(13) || CHR(13) || 'Las comillas simples ('') se agregaron al inicio de las celdas del excel para reconocer los ceros de adelante.' || utl_tcp.crlf); --Message Body
          utl_smtp.write_data(V_Conexion,
                              '-------SECBOUND' || utl_tcp.crlf ||
                              --'Content-Type: text/plain;' || utl_tcp.crlf);--
                              'Content-Type: text/plain; charset=iso-8859-1' || utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' name=RELACION_TRABCESE_' || to_char(sysdate-4, 'MM-RRRR') || utl_tcp.crlf); --xls
          utl_smtp.write_data(V_Conexion,
                              'Content-Transfer_Encoding: 8bit' ||--8bit
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              'Content-Disposition: attachment;' ||
                              utl_tcp.crlf);
          utl_smtp.write_data(V_Conexion,
                              ' filename=RELACION_TRAB_CESADOS_' || to_char(sysdate-4, 'MM-RRRR')||'.xls'|| utl_tcp.crlf ||
                              utl_tcp.crlf);

        v_header :='USUARIO'||chr(9)||'FECHA_ALTA'||chr(9)||'ESTADO'||chr(9)||'CODIGO_TRAB'||chr(9)||
                   'DNI'||chr(9)||'APEPAT'||chr(9)||'APEMAT'||chr(9)||'NOMBRES'||chr(9)||'CESE_OK_BT'||chr(9)||'CESE_OK_EBS'||chr(9)||
                   'DESCR_ERROR'||chr(9)||'FECHA_CESE_OFIPLAN'||chr(9)||'HORA_CESE_OFIPLAN'||chr(9)||'FECHA_BD_OFIPLAN'||chr(9)||
                   'FECHA_CESE_JOB'||chr(9)||'HORA_CESE_JOB'||chr(9)||'FECHA_ULT_CONBT'||chr(9)||'HORA_ULT_CONBT'||chr(9)||
                   'FECHA_ULT_ACT'||chr(9)||'HORA_ULT_ACT';
        utl_smtp.write_data(V_Conexion,v_header||utl_tcp.crlf);

        for r_trab in c_trabcesa loop
--             select decode(substr(r_trab.jaqz499ndi,1,1),'0','''','') into c_DNI from dual;
             c_DNI := '''';  
             v_wstring := r_trab.USUARIO||chr(9)||r_trab.FECHA_ALTA||chr(9)||r_trab.ESTADO||chr(9)||c_DNI||r_trab.CODIGO_TRAB||chr(9)||
             c_DNI||r_trab.DNI||chr(9)||r_trab.APEPAT||chr(9)||r_trab.APEMAT||chr(9)||r_trab.NOMBRES||chr(9)||
             r_trab.CESE_OK_BT||chr(9)||r_trab.CESE_OK_EBS||chr(9)||r_trab.DESCR_ERROR||chr(9)||r_trab.FECHA_CESE_OFIPLAN||chr(9)||
             r_trab.HORA_CESE_OFIPLAN||chr(9)||r_trab.FECHA_BD_OFIPLAN||chr(9)||r_trab.FECHA_CESE_JOB||chr(9)||r_trab.HORA_CESE_JOB||chr(9)||
             r_trab.FECHA_ULT_CONBT||chr(9)||r_trab.HORA_ULT_CONBT||chr(9)||r_trab.FECHA_ULT_ACT||chr(9)||r_trab.HORA_ULT_ACT||chr(9);
--             r_trab.FECHA_HORA_ULT_SESS||chr(9)||r_trab.FECHA_ULT_ACT||chr(9)||r_trab.HORA_ULT_ACT||chr(9);
          --utl_smtp.write_data(V_Conexion,v_wstring||utl_tcp.crlf);
          -- transforma el v_wstring en RAW y escribe el cuerpo del correo
          rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
          UTL_smtp.write_raw_data(V_Conexion, rawData);

        end loop;

        v_wstring := ' ';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := ' ';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'ESTADOS DE CESE:';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'OK=>Usuario fue cesado correctamente';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'YCE=>Usuario ya estaba cesado';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);
        v_wstring := 'NEX=>Usuario no existe';
        rawData := utl_raw.cast_to_raw(v_wstring||utl_tcp.crlf);
        UTL_smtp.write_raw_data(V_Conexion, rawData);

        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
        utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
        utl_smtp.write_data(V_Conexion, utl_tcp.crlf);

        --Cerramos la conexion
        UTL_SMTP.close_data(V_Conexion);
        UTL_SMTP.quit(V_Conexion);      
    end if;  
  EXCEPTION
  WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
    p_c_msgerr:='Unable to send mail: ' || sqlerrm;
    raise_application_error(-20000, 'Unable to send mail: ' || p_c_msgerr);  
  END SP_RH_REP_USERCESA_CYBERSEG;
  
end pq_rh_usuarios;
 /* GOLDENGATE_DDL_REPLICATION */
/

