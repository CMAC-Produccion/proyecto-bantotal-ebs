create or replace procedure sp_ah_registra_4rem_log(LN_AQPA130PA1 IN NUMBER,
                                                    LN_AQPA130TP1 IN NUMBER,
                                                    LC_AQPA130NU1 IN VARCHAR2,
                                                    LN_AQPA130PA2 IN NUMBER,
                                                    LN_AQPA130TP2 IN NUMBER,
                                                    LC_AQPA130NU2 IN VARCHAR2,
                                                    LN_AQPA130CTA IN NUMBER,
                                                    LN_AQPA130TIP IN NUMBER,
                                                    LD_AQPA130FEC IN DATE,
                                                    LC_AQPA130HOR IN VARCHAR2,
                                                    LC_AQPA130USR IN VARCHAR2,
                                                    LN_AQPA130AGE IN NUMBER,
                                                    LN_AQPA130MDA IN NUMBER,
                                                    LN_AQPA130MTO IN NUMBER,
                                                    LN_AQPA130MDC IN NUMBER,
                                                    LN_AQPA130AXN IN NUMBER                                                    
                                                    ) is
 pragma autonomous_transaction;                                                    
begin
  insert into AQPA130(AQPA130COR,
                      AQPA130PA1,
                      AQPA130TP1,
                      AQPA130NU1,
                      AQPA130PA2,
                      AQPA130TP2,
                      AQPA130NU2,
                      AQPA130CTA,
                      AQPA130TIP,
                      AQPA130FEC,
                      AQPA130HOR,
                      AQPA130USR,
                      AQPA130AGE,
                      AQPA130MDA,
                      AQPA130MTO,
                      AQPA130MDC,
                      AQPA130AXN
                      )
               values(SQ_AH_ID_DISPO.NEXTVAL,
                      LN_AQPA130PA1,
                      LN_AQPA130TP1,
                      LC_AQPA130NU1,
                      LN_AQPA130PA2,
                      LN_AQPA130TP2,
                      LC_AQPA130NU2,
                      LN_AQPA130CTA,
                      LN_AQPA130TIP,
                      LD_AQPA130FEC,
                      LC_AQPA130HOR,
                      LC_AQPA130USR,
                      LN_AQPA130AGE,
                      LN_AQPA130MDA,
                      LN_AQPA130MTO,
                      LN_AQPA130MDC,
                      LN_AQPA130AXN
                      );
  commit;
Exception
When Others then  
  null;
end sp_ah_registra_4rem_log;
/

