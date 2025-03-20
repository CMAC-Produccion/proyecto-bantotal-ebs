create or replace procedure sp_ah_create_cts001_temp is
  lv_variable varchar2(4000);
begin
      lv_variable := 'DROP TABLE AQPA129';   
        begin
            execute immediate (lv_variable);       
        exception
        when others then
          null;
        end;
              
      lv_variable := 'CREATE TABLE AQPA129 AS
      SELECT DISTINCT GG.PGCOD,
                      GG.SCMOD,
                      GG.SCSUC,
                      GG.SCMDA,
                      GG.SCPAP,
                      GG.SCCTA,
                      GG.SCOPER,
                      GG.SCSBOP,
                      GG.SCTOPE
        FROM FSD011 GG,
             (SELECT DISTINCT QQ.CTSPEMP1,
                              QQ.CTSTEMP1,
                              QQ.CTSNEMP1,
                              QQ.CTSPEMP2,
                              QQ.CTSTEMP2,
                              QQ.CTSNEMP2,
                              QQ.CTSCTAE2,
                              QQ.CTSTIPRG,
                              QQ.CTSFECRG,
                              QQ.CTSIMPRM,
                              NVL(QQ.CTSMDARM, 0) CTSMDARM,
                              QQ.CTSAUXN2
                FROM CTS001 QQ,
                     (SELECT RR.CTSPEMP1,
                             RR.CTSTEMP1,
                             RR.CTSNEMP1,
                             RR.CTSPEMP2,
                             RR.CTSTEMP2,
                             RR.CTSNEMP2,
                             RR.CTSCTAE2,
                             RR.CTSTIPRG,
                             RR.CTSFECRG,
                             MAX(RR.CTSHORRG) CTSHORRG
                        FROM CTS001 RR
                       WHERE RR.CTSTIPRG = 1
                         AND RR.CTSPEMP1 > 0 + UID * 0
                         AND TRIM(RR.CTSNEMP2) IS NOT NULL
                         AND RR.CTSUSURG <> ''BANTOTAL''
                         AND RR.CTSFECRG =
                             (SELECT MAX(TRUNC(KK.CTSFECRG))
                                FROM CTS001 KK
                               WHERE KK.CTSTIPRG = 1
                                 AND KK.CTSPEMP1 > 0
                                 AND TRIM(KK.CTSNEMP2) IS NOT NULL
                                 AND KK.CTSUSURG <> ''BANTOTAL''
                                 AND KK.CTSPEMP1 = RR.CTSPEMP1
                                 AND KK.CTSTEMP1 = RR.CTSTEMP1
                                 AND KK.CTSNEMP1 = RR.CTSNEMP1
                                 AND KK.CTSPEMP2 = RR.CTSPEMP2
                                 AND KK.CTSTEMP2 = RR.CTSTEMP2
                                 AND KK.CTSNEMP2 = RR.CTSNEMP2
                                AND KK.CTSCTAE2 = RR.CTSCTAE2
                                 AND KK.CTSTIPRG = RR.CTSTIPRG)
                       GROUP BY RR.CTSPEMP1,
                                RR.CTSTEMP1,
                                RR.CTSNEMP1,
                                RR.CTSPEMP2,
                                RR.CTSTEMP2,
                                RR.CTSNEMP2,
                                RR.CTSCTAE2,
                                RR.CTSTIPRG,
                                RR.CTSFECRG) EE
               WHERE QQ.CTSTIPRG = 1
                 AND QQ.CTSPEMP1 > 0
                 AND QQ.CTSUSURG <> ''BANTOTAL''
                 AND QQ.CTSPEMP1 = EE.CTSPEMP1
                 AND QQ.CTSTEMP1 = EE.CTSTEMP1
                 AND QQ.CTSNEMP1 = EE.CTSNEMP1
                 AND QQ.CTSPEMP2 = EE.CTSPEMP2
                 AND QQ.CTSTEMP2 = EE.CTSTEMP2
                 AND QQ.CTSNEMP2 = EE.CTSNEMP2
                 AND QQ.CTSCTAE2 = EE.CTSCTAE2
                 AND QQ.CTSTIPRG = EE.CTSTIPRG
                 AND QQ.CTSFECRG = EE.CTSFECRG
                 AND QQ.CTSHORRG = EE.CTSHORRG
                 AND TRIM(QQ.CTSNEMP2) IS NOT NULL) ZZ
      WHERE GG.PGCOD = 1
         AND GG.SCMOD = 21
         AND GG.SCPAP = 0
         AND GG.SCOPER = 0
         AND GG.SCTOPE = 2
         AND GG.SCSBOP = TRUNC(ZZ.CTSAUXN2 / 1000)
         AND GG.SCCTA = ZZ.CTSCTAE2
         AND GG.SCSTAT <> 99';                     
        begin
            execute immediate (lv_variable);       
        exception
        when others then
             Null;
        end;  
        
        begin
            execute immediate ('create index AQPA1292 on AQPA129 (SCCTA) tablespace BANTPROD_G_IDX');               
        exception
        when others then
             Null;
        end;          
        
        begin
          DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                        tabname          => 'AQPA129',
                                        degree           => 10,
                                        granularity      => 'ALL',
                                        estimate_percent => 100,
                                        cascade          => TRUE);
        Exception                                
        when others then
             Null;                                        
        end;         
        
        begin
            execute immediate ('grant select on bantprod.AQPA129  to rol_bantprod_cons');   
            execute immediate ('grant select on bantprod.AQPA129  to rol_produccion');  
            execute immediate ('grant select on bantprod.AQPA129  to rol_funcionales');              
        exception
        when others then
             Null;
        end;  
        
        begin
            execute immediate ('ALTER PROCEDURE BANTPROD.SP_AH_RECAL_4REM COMPILE DEBUG');               
        exception
        when others then
             Null;
        end;                     
        
        
end sp_ah_create_cts001_temp;
/

