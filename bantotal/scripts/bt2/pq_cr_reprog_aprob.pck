create or replace package pq_cr_reprog_aprob is

  -- Author  : HSUAREZ
  -- Created : 10/07/2021 17:39:02
  -- Purpose : 
  
procedure sp_cr_reg_backup(
                           VE_AQPB556COD in number,
                           VE_AQPB556INST in number,
                           VE_fecha in date,
                           VE_corr  in number
  );
PROCEDURE SP_CR_LOGS(
                        VE_AQPB556LCOD   IN NUMBER,
                        VE_AQPB556Linst  IN NUMBER,
                        VE_AQPB556Lpais  IN NUMBER,
                        VE_AQPB556Lptdc  IN NUMBER,
                        VE_AQPB556Ldni   IN VARCHAR2,
                        VE_AQPB556Lemp   IN NUMBER ,
                        VE_AQPB556Lmod   IN NUMBER ,
                        VE_AQPB556Lsuc   IN NUMBER ,
                        VE_AQPB556Lmda   IN NUMBER ,
                        VE_AQPB556Lpap   IN NUMBER ,
                        VE_AQPB556Lcta   IN NUMBER ,
                        VE_AQPB556Loper  IN NUMBER ,
                        VE_AQPB556Lsbop  IN NUMBER ,
                        VE_AQPB556Ltop   IN NUMBER ,
                        VE_AQPB556Lest   IN VARCHAR2 ,
                        VE_AQPB556LCONS  IN NUMBER,
                        VE_AQPB556LTCOV  IN VARCHAR2,
                        VE_AQPB556Ltprg  IN NUMBER ,
                        
                        VE_AQPB556LUSR   IN VARCHAR,
                        VE_AQPB556LPFEC  IN DATE,
                        VE_AQPB556LBACK  IN VARCHAR2,
                        VE_AQPB556LFLAG  IN VARCHAR2,
                        VE_AQPB556LFG8   IN VARCHAR2, 
                        VE_AQPB556LBFEC  IN DATE,
                        VE_AQPB556LBCOR  NUMBER
                        ); 

end pq_cr_reprog_aprob;
/

create or replace package body pq_cr_reprog_aprob is

procedure sp_cr_reg_backup(
                           VE_AQPB556COD in number,
                           VE_AQPB556INST in number,
                           VE_fecha in date,
                           VE_corr  in number
  ) is
  begin
        --EJECUTAR PROCESO EN CASO DE QUE FALLE EL BACKUP 
        /*BEGIN
          
          END;
        */
        BEGIN
          UPDATE AQPB556 
             SET AQPB556BFEC = VE_FECHA,
                 AQPB556BCOR = VE_CORR
           WHERE AQPB556COD  = VE_AQPB556COD
             AND AQPB556INST = VE_AQPB556INST;
           COMMIT;
        END;
    end;
PROCEDURE SP_CR_LOGS(
                        VE_AQPB556LCOD   IN NUMBER,
                        VE_AQPB556Linst  IN NUMBER,
                        VE_AQPB556Lpais  IN NUMBER,
                        VE_AQPB556Lptdc  IN NUMBER,
                        VE_AQPB556Ldni   IN VARCHAR2,
                        VE_AQPB556Lemp   IN NUMBER ,
                        VE_AQPB556Lmod   IN NUMBER ,
                        VE_AQPB556Lsuc   IN NUMBER ,
                        VE_AQPB556Lmda   IN NUMBER ,
                        VE_AQPB556Lpap   IN NUMBER ,
                        VE_AQPB556Lcta   IN NUMBER ,
                        VE_AQPB556Loper  IN NUMBER ,
                        VE_AQPB556Lsbop  IN NUMBER ,
                        VE_AQPB556Ltop   IN NUMBER ,
                        VE_AQPB556Lest   IN VARCHAR2 ,
                        VE_AQPB556LCONS  IN NUMBER,
                        VE_AQPB556LTCOV  IN VARCHAR2,
                        VE_AQPB556Ltprg  IN NUMBER ,
                        
                        VE_AQPB556LUSR   IN VARCHAR,
                        VE_AQPB556LPFEC  IN DATE,
                        VE_AQPB556LBACK  IN VARCHAR2,
                        VE_AQPB556LFLAG  IN VARCHAR2,
                        VE_AQPB556LFG8   IN VARCHAR2, 
                        VE_AQPB556LBFEC  IN DATE,
                        VE_AQPB556LBCOR  NUMBER
                        ) IS
BEGIN
     BEGIN
       insert into AQPB556L (AQPB556LCOD, AQPB556LINST, AQPB556LPAIS, AQPB556LPTDC, AQPB556LDNI, 
                   AQPB556LEMP, AQPB556LMOD, AQPB556LSUC, AQPB556LMDA, AQPB556LPAP, AQPB556LCTA, 
                   AQPB556LOPER, AQPB556LSBOP, AQPB556LTOP, AQPB556LEST, AQPB556LCONS, AQPB556LTCOV, 
                   AQPB556LTPRG, AQPB556LUSR, AQPB556LPFEC, AQPB556LBACK, AQPB556LFLAG, AQPB556LFG8, 
                   AQPB556LBFEC, AQPB556LBCOR, AQPB556LTIME)
       values (VE_AQPB556LCOD, VE_AQPB556Linst, VE_AQPB556Lpais, VE_AQPB556Lptdc, VE_AQPB556Ldni,
               VE_AQPB556Lemp, VE_AQPB556Lmod,VE_AQPB556Lsuc,VE_AQPB556Lmda,VE_AQPB556Lpap,VE_AQPB556Lcta,
               VE_AQPB556Loper,VE_AQPB556Lsbop,VE_AQPB556Ltop,VE_AQPB556Lest,VE_AQPB556LCONS,VE_AQPB556LTCOV,
               VE_AQPB556Ltprg,VE_AQPB556LUSR, VE_AQPB556LPFEC,VE_AQPB556LBACK,VE_AQPB556LFLAG,VE_AQPB556LFG8,
               VE_AQPB556LBFEC,VE_AQPB556LBCOR,SYSDATE);
       COMMIT;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;          
     END;
END;
end pq_cr_reprog_aprob;
/

