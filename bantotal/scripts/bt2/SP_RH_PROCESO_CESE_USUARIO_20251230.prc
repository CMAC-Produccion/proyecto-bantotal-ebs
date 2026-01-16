CREATE OR REPLACE PROCEDURE "SP_RH_PROCESO_CESE_USUARIO"
 is
    -- *****************************************************************
    -- Nombre                     : SP_RH_PROCESO_CESE_USUARIO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Administración
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/02/2017
    -- Autor de Creación          : EHIDALGOM
    -- Uso                        : Cese de Usuarios en Bantotal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 2026/01/05
    -- Autor Modificacion         : EHIDALGOM
    -- Detalle                    : Cese de Usuarios de BD posterior a validación en JAQN002
    -- *****************************************************************
    LVCCAD VARCHAR2(2000);
    V_HOSTNAME  VARCHAR(100);
    c_userces CHAR(10);
    c_usercesebs VARCHAR2(100);
    N_CONTUSRBT NUMBER;
    N_CONTUSREBS NUMBER;
    N_EXSTUSRBT NUMBER;
    N_EXSTUSREBS NUMBER;
    n_contjaqzbt number;
    n_contjaqzebs number;
    c_ok_BT CHAR(1);
    c_ok_EBS CHAR(1);
    cursor c1 is
           select * from JAQZ499;
    cursor c_trab_cese is
           select "nu_docu_iden" nro_doc, "fecha_cese" fec_ces ,"estado" estado
           from t_trabcesa@empces
           where "estado"='I' and "fecha_cese"+1<=trunc(sysdate);
begin

--  update t_trabcesa@empces set "estado"='P' where "estado"='I' and "fecha_cese"=trunc(sysdate)-1;
--  commit;
  --MODIFICADO 21.02.2017
  for c in c_trab_cese loop
    update t_trabcesa@empces set "estado"='P' where "estado"=c.estado and "nu_docu_iden"=c.nro_doc and "fecha_cese"=c.fec_ces;
    commit;
  end loop;

  --liberar tabla temporal
  delete from JAQZ499;
  commit;
  --insertar data actual de users cesados de Ofiplan
  insert into JAQZ499
  select "fecha_actual" JAQZ499FAC,"nu_docu_iden" JAQZ499NDI,"no_apel_pate" JAQZ499NAP,"no_apel_mate" JAQZ499NAM,
         "no_trab" JAQZ499NTR,"fecha_cese" JAQZ499FCE, "co_trab" JAQZ499CTR, "estado" JAQZ499ESP, "usr_ceso" JAQZ499UCE
    from t_trabcesa@empces a
   where /*trunc(a."fecha_actual") = trunc(sysdate)
     and */(a."fecha_cese" is not null or a."fecha_cese" <> '') and a."estado"='P';
  commit;

  --Procesa en BT y EBS
  for i in c1 loop
      --Valida existencia en JAQN002
      begin
        select jaqn002usr into c_userces from jaqn002 where jaqn002ndo=rpad(i.jaqz499ndi,12,' ');
      exception when others then
        insert into JAQZ499H (jaqz499fpr, jaqz499fac, jaqz499ndi, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, jaqz499des,jaqz499sbt,jaqz499seb,JAQZ499UCE)
        select sysdate, jaqz499fac, jaqz499ndi, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, 'NO EXISTE EN JAQN002','ERR','ERR', JAQZ499UCE from JAQZ499 where jaqz499ndi=i.jaqz499ndi;
        commit;
      --30.12.2019
      --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;
--        raise_application_error(-20000, 'DNI '|| i.jaqz499ndi || ' NO registrado en JAQN002. Error:' ||sqlerrm);
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario no se pudo cesar porque NO EXISTE EN JAQN002',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;

        continue;
      end;

      --Cesa Usuarios de Bases de Datos--2026.01.02
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_BT(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_VESTA(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_EBS(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_FTS(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_SIX(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        pq_rh_usuarios.SP_RH_BLOQUEA_USER_BD_DATAWH(c_userces);
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;

      -------------------------------------------------------------------------------------------------------------
      --VALIDAR QUE USER EXISTA EN BT
      select COUNT(*)
        INTO N_EXSTUSRBT
        from PRFU00
       WHERE PGCOD = 1
         AND UBUSER = c_userces;

      IF (N_EXSTUSRBT<>0) THEN
        --VALIDAR QUE USER NO ESTÉ CESADO EN BT

        select COUNT(*)
          INTO N_CONTUSRBT
          from PRFU00
         WHERE PGCOD = 1
           AND PRFGCOD = 'CESADO'
           AND UBUSER = c_userces;

        IF(N_CONTUSRBT=0) then

          pq_rh_usuarios.sp_rh_cese_usuario_bt(c_userces,RPAD(TRIM(i.jaqz499ndi),12,' '),i.jaqz499fce,c_ok_BT);

          --SI PROCESO BT OK?
          if c_ok_BT ='S' then
                select count(*) into n_contjaqzbt from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                if n_contjaqzbt>0 then
                  UPDATE JAQZ499H SET jaqz499sBT='OK'
                  where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                  commit;
                else
                  insert into JAQZ499H (jaqz499fpr, jaqz499fac, jaqz499ndi, JAQZ499USR, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, jaqz499sbt,JAQZ499UCE)
                  select sysdate, jaqz499fac, jaqz499ndi, c_userces, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, 'OK',JAQZ499UCE
                  from JAQZ499
                  where jaqz499ndi=i.jaqz499ndi;
                  commit;
                END if;
          else
                select count(*) into n_contjaqzbt from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                if n_contjaqzbt>0 then
                  UPDATE JAQZ499H SET jaqz499sBt='ERR' , JAQZ499DES='ERROR EN RETORNO DE pq_rh_usuarios.sp_rh_cese_usuario_BT'
                  where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                  commit;
                else
                  insert into JAQZ499H (jaqz499fpr, jaqz499fac, jaqz499ndi, JAQZ499USR, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, JAQZ499DES, jaqz499sbt,JAQZ499UCE)
                  select sysdate, jaqz499fac, jaqz499ndi, c_userces, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, 'ERROR EN RETORNO DE pq_rh_usuarios.sp_rh_cese_usuario_BT', 'ERR',JAQZ499UCE
                  from JAQZ499
                  where jaqz499ndi=i.jaqz499ndi;
                  commit;
                END if;
          END IF;
        ELSE
          c_ok_BT:='2'     ;--ya cesado en BT
        END IF;
      else
        c_ok_BT:='1'     ;  --Inexistente en BT
      END IF;
      -------------------------------------------------------------------------------------------------------------
      --30.12.2019
      BEGIN
        --VALIDAR QUE USER EXISTA EN EBS
        select COUNT(*)
          INTO N_EXSTUSREBS
          from FND_USER@erp
         WHERE USER_NAME = trim(c_userces);
        commit;

        IF (N_EXSTUSREBS<>0) THEN

          --VALIDAR QUE USER NO ESTÉ CESADO EN EBS

          select COUNT(*)
            INTO N_CONTUSREBS
            from FND_USER@erp
    --       WHERE USER_NAME = trim(c_usercesebs) AND END_DATE IS NOT NULL;
           WHERE USER_NAME = trim(c_userces) AND END_DATE IS NOT NULL;
           commit;

          IF(N_CONTUSREBS=0) then

    --        pq_rh_usuarios.sp_rh_cese_usuario_ebs(trim(c_usercesebs),RPAD(TRIM(i.jaqz499ndi),12,' '),i.jaqz499fce,c_ok_EBS);
            pq_rh_usuarios.sp_rh_cese_usuario_ebs(trim(c_userces),RPAD(TRIM(i.jaqz499ndi),12,' '),i.jaqz499fce,c_ok_EBS);

            --SI PROCESO EBS OK?
            if c_ok_EBS ='S' then
                select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                if n_contjaqzebs>0 then
                  UPDATE JAQZ499H SET jaqz499sEB='OK'
                  where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                  commit;
                else
                  insert into JAQZ499H (jaqz499fpr, jaqz499fac, jaqz499ndi, JAQZ499USR, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, jaqz499sEB,JAQZ499UCE)
                  select sysdate, jaqz499fac, jaqz499ndi, c_userces, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, 'OK',JAQZ499UCE
                  from JAQZ499
                  where jaqz499ndi=i.jaqz499ndi;
                  commit;
                END if;
            else
                select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                if n_contjaqzebs>0 then
                  UPDATE JAQZ499H SET jaqz499sEB='ERR' , JAQZ499DES='ERROR EN RETORNO DE pq_rh_usuarios.sp_rh_cese_usuario_EBS'
                  where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
                  commit;
                else
                  insert into JAQZ499H (jaqz499fpr, jaqz499fac, jaqz499ndi, JAQZ499USR, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, JAQZ499DES, jaqz499sEB,JAQZ499UCE)
                  select sysdate, jaqz499fac, jaqz499ndi, c_userces, jaqz499nap, jaqz499nam, jaqz499ntr, jaqz499fce, jaqz499ctr, 'ERROR EN RETORNO DE pq_rh_usuarios.sp_rh_cese_usuario_EBS. ', 'ERR',JAQZ499UCE
                  from JAQZ499
                  where jaqz499ndi=i.jaqz499ndi;
                  commit;
                END if;
            END IF;
          ELSE
            c_ok_EBS:='2'     ;--ya cesado en EBS
          END IF;
        ELSE
          c_ok_EBS:='1'     ;--inexistente en EBS
        END IF;
      EXCEPTION
        WHEN OTHERS THEN--30.12.2019
        c_ok_EBS:='N';
        LVCCAD := TO_CHAR('SP_RH_PROCESO_CESE_USUARIO__EBS: '||SQLCODE||' - '||SQLERRM);
        ROLLBACK;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe',
                      'Error SP_RH_PROCESO_CESE_USUARIO__EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||c_userces||'-'||i.jaqz499ndi||'-'||i.jaqz499fce||CHR(13)||LVCCAD);
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe',
                      'Error SP_RH_PROCESO_CESE_USUARIO__EBS ' ||
                      sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                      V_HOSTNAME,
                      'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                      CHR(13) || 'Hora Actual en Servidor : ' ||
                      to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Error al procesar: '||c_userces||'-'||i.jaqz499ndi||'-'||i.jaqz499fce||CHR(13)||LVCCAD);
        exception
            when others then
              null;
        end;
      END;

      --Si alguno de los usuarios tratados de cesar dieron error, regresar estado a I para volver a procesar
      IF(c_ok_BT='N' OR c_ok_EBS='N') THEN
        update t_trabcesa@empces set "estado"='I' where "estado"='P' AND "nu_docu_iden"=i.jaqz499ndi;
        commit;
      END IF;
      ------------------------------------------------------------------------------------------------

      --Ambos usuarios No existen en BT ni EBS                                 ==>1
      IF(c_ok_BT='1' AND c_ok_EBS='1') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN No existe en BT ni EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      --Usuario no existe en Bt. En EBS el usuario esta cesado                 ==>2
      IF(c_ok_BT='1' AND c_ok_EBS='2') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sBT='NEX'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
          commit;
          UPDATE JAQZ499H SET jaqz499sEB='YCE'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi
          and (jaqz499sEB <> 'OK' or jaqz499sEB is null or jaqz499sEB = '');
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      --Usuario no existe en Bt. En EBS el usuario se ha cesado               ==>3
      IF(c_ok_BT='1' AND c_ok_EBS='S') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sBT='NEX'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en EBS. No existe en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      --Usuario ya cesado en BT. No existe el usuario en EBS                   ==>4
      IF(c_ok_BT='2' AND c_ok_EBS='1') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sEB='NEX'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
          commit;
          UPDATE JAQZ499H SET jaqz499sBT='YCE'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi
          and (jaqz499sBT <> 'OK' or jaqz499sBT is null or jaqz499sBT = '');
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN ya cesado en BT. No existe en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      --Usuario se ha cesado en BT. No existe el usuario en EBS                 ==>5
      IF(c_ok_BT='S' AND c_ok_EBS='1') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sEB='NEX'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN. Se cesó en BT. No existe en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      -- Ambos usuarios YA estaban cesados en BT y EBS                         ==>6
      IF (C_OK_BT='2' AND C_OK_EBS='2') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      END IF;
      ------------------------------------------------------------------------------------------------


      -- Ambos usuarios No estaban cesados y fueron cesados en BT y EBS        ==>7
      IF(c_ok_BT='S' AND c_ok_EBS='S') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en Bantotal y EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      END IF;
      ------------------------------------------------------------------------------------------------

      --Usuario ya cesado en BT. Usuario se ha cesado ok en EBS                   ==>8
      IF(c_ok_BT='2' AND c_ok_EBS='S') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sBT='YCE'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi
          and (jaqz499sBT <> 'OK' or jaqz499sBT is null or jaqz499sBT = '');
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en Bantotal. Se cesó en EBS. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

      --Usuarios se ha cesado ok en BT. Usuario ya cesado en EBS                   ==>9
      IF(c_ok_BT='S' AND c_ok_EBS='2') THEN
        --inserta data de tabla remota a tabla historica remota segun tabla local
        insert into t_trabcesah@empces ("fecha_actual","nu_docu_iden","no_apel_pate","no_apel_mate","no_trab","fecha_cese","co_trab","usr_ceso")
        values(i.jaqz499fac, i.jaqz499ndi, i.jaqz499nap, i.jaqz499nam, i.jaqz499ntr, i.jaqz499fce, i.jaqz499ctr, i.JAQZ499UCE);
        commit;
        --borra de tabla remota lo que hay en tabla local
        delete from t_trabcesa@empces where "nu_docu_iden"=i.jaqz499ndi and "estado"='P';
        commit;

        select count(*) into n_contjaqzebs from JAQZ499H where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi;
        if n_contjaqzebs>0 then
          UPDATE JAQZ499H SET jaqz499sEB='YCE'
          where trunc(jaqz499fpr) = TRUNC(SYSDATE) AND jaqz499ndi=i.jaqz499ndi
          and (jaqz499sEB <> 'OK' or jaqz499sEB is null or jaqz499sEB = '');
          commit;
        end if;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rzegarrae@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'gcubas@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'rmezac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr
                    );
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ',
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
        begin
        sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'zmallco@cajaarequipa.pe',
                    'Usuario Cesado en OFIPLAN que YA ESTABA Cesado en EBS. Se cesó en BT. ' ,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'DNI : '||i.jaqz499ndi||CHR(13) ||
                    'Nombre : '||i.jaqz499nap||' '||i.jaqz499nam||' '||i.jaqz499ntr||CHR(13) ||
                    'Fecha Cese : '||i.jaqz499fce||CHR(13) ||
                    'Código Trabajador : '||i.jaqz499ctr);
        exception
            when others then
              null;
        end;
      end if;
      ------------------------------------------------------------------------------------------------

  end loop;
  --borra tabla local
  delete from JAQZ499;
  commit;
EXCEPTION
  WHEN OTHERS THEN
    select HOST_NAME INTO V_HOSTNAME from v$instance;
    LVCCAD := TO_CHAR('SP_RH_PROCESO_CESE_USUARIO: '||SQLCODE||' - '||SQLERRM);
    begin
    sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'ehidalgom@cajaarequipa.pe',
                    'Error SP_RH_PROCESO_CESE_USUARIO ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error : '||LVCCAD);
    sys.sp_sy_enviamail('ceseusuarios@cajaarequipa.pe',
                    'kcabrerac@cajaarequipa.pe',
                    'Error SP_RH_PROCESO_CESE_USUARIO ' ||
                    sys_context('USERENV', 'DB_NAME') || ' HOST ' ||
                    V_HOSTNAME,
                    'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                    'INSTANCIA=' || sys_context('USERENV', 'INSTANCE_NAME') ||
                    CHR(13) || 'Hora Actual en Servidor : ' ||
                    to_char(sysdate, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                    'Error : '||LVCCAD);
    exception
        when others then
          null;
    end;
end sp_rh_proceso_cese_usuario;
 /* GOLDENGATE_DDL_REPLICATION */
/
