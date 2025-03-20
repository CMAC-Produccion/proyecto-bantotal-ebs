CREATE OR REPLACE PROCEDURE SP_AH_INSJAQY685(P_PGCOD     IN NUMBER,
                                             P_SCSUC     IN NUMBER,
                                             P_SCMDA     IN NUMBER,
                                             P_SCPAP     IN NUMBER,
                                             P_SCCTA     IN NUMBER,
                                             P_SCOPE     IN NUMBER,
                                             P_SCSUB     IN NUMBER,
                                             P_SCTOP     IN NUMBER,
                                             P_SCMOD     IN NUMBER,               
                                             P_FECHA     IN DATE,
                                             P_HORA      IN VARCHAR2,
                                             P_CUENTA    IN VARCHAR2,                                             
                                             P_USUARIO   IN VARCHAR2,
                                             P_SUCURSAL  IN NUMBER,
                                             P_DE        IN DATE,
                                             P_AL        IN DATE
                                             ) IS
Begin
      insert into jaqy685
                (jaqy685pgc,
                 jaqy685suc,
                 jaqy685mda,
                 jaqy685pap,
                 jaqy685sct,
                 jaqy685ope,
                 jaqy685sob,
                 jaqy685top,
                 jaqy685mod,
                 jaqy685fec,                 
                 jaqy685hra,
                 jaqy685cta,
                 jaqy685usu,
                 jaqy685agu,
                 jaqy685de,
                 jaqy685al)
          values
                (P_PGCOD,
                 P_SCSUC,
                 P_SCMDA,
                 P_SCPAP,
                 P_SCCTA,
                 P_SCOPE,
                 P_SCSUB,
                 P_SCTOP,
                 P_SCMOD,    
                 P_FECHA,                 
                 P_HORA,
                 P_CUENTA,
                 P_USUARIO,
                 P_SUCURSAL,
                 P_DE,
                 P_AL);
           COMMIT;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    NULL;
END SP_AH_INSJAQY685;
/

