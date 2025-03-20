CREATE OR REPLACE TRIGGER TG_JAQL083_UPD_EXT
  AFTER INSERT ON JAQL083
  FOR EACH ROW 
 WHEN (NEW.JAQL83au01 = 'S') DECLARE
       cosr varchar2(10);
       codp varchar2(10);
       codc varchar2(10);
       codm number;
      CURSOR REG20(REGISTRO IN VARCHAR2, CODCLI IN VARCHAR2, CODPAG IN VARCHAR2, CODMON IN NUMBER  ) IS
            SELECT * FROM CTREG20@paginst A WHERE TRIM(A.REGNROREC) = TRIM(REGISTRO) AND TRIM(A.REGCIACOD) = TRIM(CODCLI) AND TRIM(A.REGCPAGCOD) = TRIM(CODPAG) AND TRIM(A.REGTIPMONCOD) = TRIM(CODMON) AND TRIM(A.REGADICOD) IN ('40COMICLIE','40COMICMAC');

BEGIN
      IF :NEW.JAQL83au01 = 'S' THEN
         select trim(jaql82cosr),trim(jaql82coin),trim(jaql82copa),trim(jaql82mone) into cosr,codc,codp,codm from jaql082 a where a.jaql82cobt = :new.jaql83cobt;


         begin
         FOR X IN REG20(cosr,codc,codp,codm )  LOOP
            UPDATE CPRCO60@paginst
            SET RC3ADIMONPAG = 0
            WHERE RC1CIACOD = X.REGCIACOD
            AND RC1CPAGCOD = X.REGCPAGCOD
            AND RC1PRDOCOD = X.REGPRDOCOD
            AND RC1SPDOCOD = X.REGSPDOCOD
            AND RC2CPTOCOD = X.REGCPTOCOD
            AND TRIM(RC3ADICOD) IN ('40COMICMAC','40COMICLIE');
          
         END LOOP;
         exception
            WHEN NO_DATA_FOUND THEN
                 cosr := cosr;                       
         end;  
      END IF;
EXCEPTION
     WHEN OTHERS THEN
       null; 
END;
/

