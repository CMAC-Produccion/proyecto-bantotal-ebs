CREATE OR REPLACE PROCEDURE SP_AH_INSJAQY669(P_MOD       IN NUMBER,
                                             P_TRAN      IN NUMBER,
                                             P_REL       IN NUMBER,
                                             P_SUC       IN NUMBER,
                                             P_FECHA     IN DATE,
                                             P_CUENTA    IN VARCHAR2,
                                             P_FECOPE    IN DATE,
                                             P_NROOPE    IN VARCHAR2,
                                             P_DESCOPE   IN VARCHAR2,
                                             P_TIPMTO    IN VARCHAR2,
                                             P_MONTO     IN NUMBER,
                                             P_AGENCIA   IN VARCHAR2,
                                             P_FECEXT    IN DATE,
                                             P_HORAEXT   IN VARCHAR2,
                                             P_OPESOLI   IN VARCHAR2,
                                             P_OPECONF   IN VARCHAR2,
                                             P_AUTORIZ   IN VARCHAR2,
                                             P_MOTIVO    IN VARCHAR2,
                                             P_ACCION    IN NUMBER,
                                             P_USUARIO   IN VARCHAR2,
                                             P_MONEDA    IN NUMBER,
                                             P_TC_CAMBIO IN NUMBER                                             ) IS
 tipocambio number(16,5) := 0;                                            
Begin
 IF (P_MOD = 550 AND P_TRAN = 535) OR(P_MOD = 550 AND P_TRAN = 536) THEN
   tipocambio := P_TC_CAMBIO;
 ELSE  
   tipocambio := fn_tipo_cambio(fecha  => trunc(sysdate),
                                monori => 101,
                                mondes => 0,
                                tipo   => 500
                                );
  end if;                             
 /* DELETE jaqy669
      where jaqy669au4  = RPAD(P_USUARIO,100,' ');
      COMMIT;                             */
                              
CASE P_ACCION
 WHEN 1 THEN
      bEGIN
      insert into jaqy669
                 (jaqy669mod,
                  jaqy669tran,
                  jaqy669rel,
                  jaqy669suc,
                  jaqy669fec,
                  jaqy669cta,
                  jaqy669fope,
                  jaqy669nope,
                  jaqy669dope,
                  jaqy669tmvo,
                  jaqy669mon,
                  jaqy669agee,
                  jaqy669fext,
                  jaqy669hext,
                  jaqy669oing,
                  jaqy669oconf,
                  jaqy669uau,
                  jaqy669mot,
                  jaqy669au4,
                  jaqy669au1,
                  jaqy669au3
                  )
          values
                (P_MOD,
                 P_TRAN,
                 P_REL,
                 P_SUC,
                 P_FECHA,
                 P_CUENTA,
                 P_FECOPE,
                 P_NROOPE,
                 P_DESCOPE,
                 P_TIPMTO,
                 P_MONTO,
                 P_AGENCIA,
                 P_FECEXT,
                 P_HORAEXT,
                 P_OPESOLI,
                 P_OPECONF,
                 P_AUTORIZ,
                 P_MOTIVO,
                 P_USUARIO,
                 P_MONEDA,
                 tipocambio );
           COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;    
  WHEN 2 THEN

      DELETE jaqy669
      where jaqy669au4  = RPAD(P_USUARIO,100,' ');
      COMMIT;

  END CASE;
END SP_AH_INSjaqy669;
/

