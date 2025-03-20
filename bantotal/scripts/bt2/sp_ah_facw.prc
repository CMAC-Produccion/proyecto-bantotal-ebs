create or replace procedure SP_AH_FACW(CUENTA  IN NUMBER,
                                       USUARIO IN VARCHAR2,
                                       TIPO    IN NUMBER) is
    cursor productos is
       select scmda, scoper, scsbop, sctope, scmod 
         from fsd011
        where PGCOD = 1     
          and SCCTA = cuenta
          AND SCMOD IN (21,22);
--          and scstat = 0;
          
     cursor datos (scmda1 number,  scoper1 number, scsbop1 number, sctope1 number, scmod1 number ) is   
         SELECT  distinct
                 F.FACCOD CODIGO,      
               --  F.CTFACCOR GRUPO, 
                 (SELECT  FacNom FROM FST130  WHERE FacCod =  F.FACCOD) FACULTAD,
                 F.CTFECDES FECHAINI,
                 F.CTFACLIM LIMDOLAR,
                 F.CTFACLIMMN LIMSOL,
--                 NVL(TO_CHAR(F1.F131FeHs),'INDETERMINADO') FECHAFIN,     
                 F1.F131FeHs fechafin,  
                 decode(S.R1MOD,22, (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1OPER)),9,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0')),
                            (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1SBOP)),2,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0'))) cuenta,
                (SELECT TONOM FROM FST004 WHERE MODULO = S.R1MOD AND TOTOPE = S.R1TOPE) PRODUCTO,                
                (select TRIM(PFAPE1)||' '||TRIM(PFAPE2)||' '||TRIM(PFNOM1)||' '||TRIM(PFNOM2) from fsd002 where pFpais = r.pfpai2 and pFtdoc = r.pftdo2 and pFndoc = r.pfndo2 ) integrante,
                 r.pfndo2 DNI               
            FROM fse130 F,
                 FSR011 S,
                 FSE131 F1,
                 FSR130 R
           where F.PgCod = 1
             AND F.Ctnro =  CUENTA ---52728 --241557       
              AND S.Relcod = 5  
              and s.r2cta = f.ctnro
              AND S.R2sbop = F.CTFACCOR
              AND S.R1cta  = F.CTNRO
           --   AND S.R2mod =1
              AND S.R2oper = TO_CHAR(F.CTFECDES,'YYYYMMDD')   
              and s.r1mda = scmda1
              and s.R1OPER = scoper1
              and s.r1mod = scmod1
              and s.r1sbop = scsbop1
              and s.r1tope = sctope1
              and r.pgcod = f.pgcod
              and r.ctnro = s.r1cta
              and r.faccod = f.faccod
              and r.ctfaccor = f.ctfaccor
              AND F1.F131Pg(+) = F.PGCOD
              AND F1.F131Cta(+) = F.CTNRO
              AND F1.F131Fac(+) = F.FACCOD
              AND F131Cor(+) = F.CTFACCOR;  
v_fecha varchar2(20);              
begin
  CASE 
    WHEN TIPO = 1 THEN 
      DELETE JAQY694 WHERE JAQY694USU = rpad(USUARIO,12,' ');
      COMMIT;
        FOR REG IN PRODUCTOS LOOP
          FOR DAT IN DATOS (REG.SCMDA,REG.SCOPER,REG.SCSBOP,REG.SCTOPE,REG.SCMOD) LOOP
             if  DAT.FECHAFIN is null or DAT.FECHAFIN = to_Date('01/01/0001','dd/mm/yy') then
               v_fecha:='Indeterminado';
             else  
               v_fecha := to_char(DAT.FECHAFIN,'dd')||'/'||to_char(DAT.FECHAFIN,'MM')||'/'||to_char(DAT.FECHAFIN,'yyyy');
             end if;
              INSERT INTO JAQY694(jaqy694cod, 
                                  jaqy694cta, 
                                  jaqy694pro, 
                                  jaqy694int, 
                                  jaqy694dni, 
                                  jaqy694usu, 
                                  jaqy694ax4,                                   
                                  jaqy694fini, 
                                  jaqy694lme, 
                                  jaqy694lmn,                                  
                                  jaqy694des, 
                                  jaqy694fac,
                                  jaqy694ax2,
                                  jaqy694ax5 )
                           VALUES(SEQ_JAQY694.NEXTVAL,
                                  DAT.CUENTA,
                                  DAT.PRODUCTO,
                                  DAT.INTEGRANTE,
                                  DAT.DNI,
                                  usuario,
                                  v_fecha, ---DAT.FECHAFIN,
                                  DAT.FECHAINI,
                                  DAT.LIMDOLAR,
                                  DAT.LIMSOL,
                                  DAT.FACULTAD,
                                  DAT.CODIGO,
                                  CUENTA,
                                  dat.cuenta
                                  );
           
          END LOOP;
        END LOOP;
        COMMIT;
    WHEN TIPO = 2 THEN
      DELETE JAQY694 WHERE JAQY694USU = rpad(USUARIO,12,' ');
      COMMIT;
    END CASE;
  
end SP_AH_FACW;
/

