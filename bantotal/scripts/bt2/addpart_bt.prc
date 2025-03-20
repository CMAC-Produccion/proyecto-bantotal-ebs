CREATE OR REPLACE PROCEDURE "ADDPART_BT"(c_tabla in varchar2, c_tablespace in varchar2, C_INITRANS in varchar2)  AS
  fecpar_ini date;
  fecpar_less date;
  fecpar_fin date;
  cfec_part varchar2(10);
  LVCCAD varchar2(1000);
begin
  SELECT TO_DATE(SUBSTR(MAX(PARTITION_NAME),8,8),'YYYY-MM-DD')
  INTO FECPAR_INI --MÁXIMA PARTICION
  FROM DBA_TAB_PARTITIONS WHERE TABLE_OWNER='BANTPROD' AND TABLE_NAME=C_TABLA;

  fecpar_fin := add_months(fecpar_ini,1);

  IF (TO_CHAR(SYSDATE,'DD') = '25') THEN    --PARA CADA 25
      fecpar_less := fecpar_ini;
      LOOP
       cfec_part:=to_char(fecpar_less+1,'RRRRMMDD');
       execute immediate(
       /*DBMS_OUTPUT.PUT_LINE(*/
            'ALTER TABLE BANTPROD.'||c_tabla||
            ' ADD PARTITION '||c_tabla||'_'||cfec_part||' VALUES LESS THAN (TO_DATE('||''''||to_char(fecpar_less+2,'RRRR-MM-DD')||''''||','||''''||'YYYY-MM-DD'||''''||')) TABLESPACE '||c_tablespace||' INITRANS '||C_INITRANS||' UPDATE INDEXES'
       );
       fecpar_less := fecpar_less + 1;
       EXIT WHEN fecpar_less>=fecpar_fin;
      END LOOP;

      SELECT TO_DATE(SUBSTR(MAX(PARTITION_NAME),8,8),'YYYY-MM-DD')
      INTO FECPAR_INI --MÁXIMA PARTICION DESPUÉS DE ADICION
      FROM DBA_TAB_PARTITIONS WHERE TABLE_OWNER='BANTPROD' AND TABLE_NAME=C_TABLA;

      SYS.sp_sy_enviamail(  PC_DE      => 'bantoem@cajaarequipa.pe',
                        PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                        PC_MOTIVO  => sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||' => ADICIÓN DE PARTICIONES '||c_tabla,
                        PC_MENSAJE => 'AL '||TO_CHAR(SYSDATE,'DD-MM-RRRR HH24:MI:SS')||' LA MAXIMA PARTICION DE '||c_tabla||': '||TO_CHAR(FECPAR_INI));
      SYS.sp_sy_enviamail(  PC_DE      => 'bantoem@cajaarequipa.pe',
                        PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                        PC_MOTIVO  => sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||' => ADICIÓN DE PARTICIONES '||c_tabla,
                        PC_MENSAJE => 'AL '||TO_CHAR(SYSDATE,'DD-MM-RRRR HH24:MI:SS')||' LA MAXIMA PARTICION DE '||c_tabla||': '||TO_CHAR(FECPAR_INI));
  END IF;
EXCEPTION
    WHEN OTHERS THEN
      LVCCAD := TO_CHAR('error:'||SQLCODE||' - '||SQLERRM);
      DBMS_OUTPUT.PUT_LINE(LVCCAD);
      SYS.sp_sy_enviamail(PC_DE      => 'bantoem@cajaarequipa.pe',
                      PC_AQUIEN  => 'ehidalgom@cajaarequipa.pe',
                      PC_MOTIVO  => sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||' => ERROR EN ADICIÓN DE PARTICIONES '||c_tabla,
                      PC_MENSAJE => 'AL '||TO_CHAR(SYSDATE,'DD-MM-RRRR HH24:MI:SS')||' ERROR'||LVCCAD);
      SYS.sp_sy_enviamail(PC_DE      => 'bantoem@cajaarequipa.pe',
                      PC_AQUIEN  => 'kcabrerac@cajaarequipa.pe',
                      PC_MOTIVO  => sys_context('USERENV', 'DB_NAME')||'-'||sys_context('USERENV', 'INSTANCE_NAME')||' => ERROR EN ADICIÓN DE PARTICIONES '||c_tabla,
                      PC_MENSAJE => 'AL '||TO_CHAR(SYSDATE,'DD-MM-RRRR HH24:MI:SS')||' ERROR'||LVCCAD);                      
END;
 /* GOLDENGATE_DDL_REPLICATION */
/

