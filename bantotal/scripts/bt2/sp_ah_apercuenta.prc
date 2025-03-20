CREATE OR REPLACE PROCEDURE SP_AH_APERCUENTA (LN_CUENTA IN NUMBER,
                                              LN_SUPOPE IN NUMBER,
                                              LN_TIPOPE IN NUMBER,
                                              LN_SUCURS IN NUMBER,
                                              LN_MODULO IN NUMBER,
                                              LN_MONEDA IN NUMBER,
                                              LN_PAPEL  IN NUMBER,
                                              LN_OPER   IN NUMBER,
                                              LN_AGENTE IN NUMBER
                                              ) IS
                                            
estrab number := 0;  
cantidad number := 0;   
FECHA_COMP TIMESTAMP;                                         
BEGIN
select count(*) 
  into estrab 
  from fsr008 
 where pgcod = 1 
   and ctnro = LN_CUENTA 
   and  EXISTS(SELECT 1 from fsd009 where tgcod=4 and grnro=22001 and pgcod=1  and ctnro=LN_CUENTA) ;
   --in (select rpad(to_char(NU_DOCU_IDEN),12,' ') from jaqy570);

  if estrab>0 then
    
    select count(*) into cantidad from fsr008 where pgcod=1 and ctnro = LN_CUENTA;
    
    if cantidad = 1 then
             
            insert into jaql482
              (JAQL482CCT,
               JAQL482PGE,
               JAQL482SUC,
               JAQL482CTA,
               JAQL482MOD,
               JAQL482MDA,
               JAQL482PAP,
               JAQL482OPE,
               JAQL482SBO,
               JAQL482TOP,
               JAQL482FEI,
               JAQL482FEF,
               JAQL482FEC,
               JAQL482FEM,
               JAQL482USC,
               JAQL482USM,
               JAQL482HCR,
               JAQL482HMD,
               JAQL482AX1,
               JAQL482AX2,
               JAQL482AX3,
               JAQL482AX4,
               JAQL482AX5,
               JAQL482AX6,
               JAQL482AX7,
               JAQL482AX8,
               JAQL482AX9)
              select 4,
                     a.pgcod,
                     a.scsuc,
                     a.sccta,
                     a.scmod,
                     a.scmda,
                     a.scpap,
                     a.scoper,
                     a.scsbop,
                     a.sctope,
                     trunc(sysdate),
                     trunc(sysdate + 2),
                     trunc(sysdate),
                     to_date('01010001', 'ddmmyyyy'),
                     'BANTOTAL',
                     null,
                     to_char(systimestamp, 'hh24:mi:ss'),
                     null,
                     1,
                     0,
                     0.00,
                     0.00,
                     to_date('01010001', 'ddmmyyyy'),
                     to_date('01010001', 'ddmmyyyy'),
                     null,
                     null,
                     null
                from fsd011 a
               where pgcod = 1
                 and scmod = 21
                 and sccta = LN_CUENTA
                 and scsbop = LN_SUPOPE
                 and sctope = LN_TIPOPE
                 and scstat < 99;
            
            insert into jaql482
              (JAQL482CCT,
               JAQL482PGE,
               JAQL482SUC,
               JAQL482CTA,
               JAQL482MOD,
               JAQL482MDA,
               JAQL482PAP,
               JAQL482OPE,
               JAQL482SBO,
               JAQL482TOP,
               JAQL482FEI,
               JAQL482FEF,
               JAQL482FEC,
               JAQL482FEM,
               JAQL482USC,
               JAQL482USM,
               JAQL482HCR,
               JAQL482HMD,
               JAQL482AX1,
               JAQL482AX2,
               JAQL482AX3,
               JAQL482AX4,
               JAQL482AX5,
               JAQL482AX6,
               JAQL482AX7,
               JAQL482AX8,
               JAQL482AX9)
              select 5,
                     a.pgcod,
                     a.scsuc,
                     a.sccta,
                     a.scmod,
                     a.scmda,
                     a.scpap,
                     a.scoper,
                     a.scsbop,
                     a.sctope,
                     trunc(sysdate),
                     trunc(sysdate + 2),
                     trunc(sysdate),
                     to_date('01010001', 'ddmmyyyy'),
                     'BANTOTAL',
                     null,
                     to_char(systimestamp, 'hh24:mi:ss'),
                     null,
                     1,
                     0,
                     0.00,
                     0.00,
                     to_date('01010001', 'ddmmyyyy'),
                     to_date('01010001', 'ddmmyyyy'),
                     null,
                     null,
                     null
                from fsd011 a
               where pgcod = 1
                 and scmod = 21
                 and sccta = LN_CUENTA
                 and scsbop = LN_SUPOPE
                 and sctope = LN_TIPOPE
                 and scstat < 99;
        
            insert into jaql482
              (JAQL482CCT,
               JAQL482PGE,
               JAQL482SUC,
               JAQL482CTA,
               JAQL482MOD,
               JAQL482MDA,
               JAQL482PAP,
               JAQL482OPE,
               JAQL482SBO,
               JAQL482TOP,
               JAQL482FEI,
               JAQL482FEF,
               JAQL482FEC,
               JAQL482FEM,
               JAQL482USC,
               JAQL482USM,
               JAQL482HCR,
               JAQL482HMD,
               JAQL482AX1,
               JAQL482AX2,
               JAQL482AX3,
               JAQL482AX4,
               JAQL482AX5,
               JAQL482AX6,
               JAQL482AX7,
               JAQL482AX8,
               JAQL482AX9)
              select 6,
                     a.pgcod,
                     a.scsuc,
                     a.sccta,
                     a.scmod,
                     a.scmda,
                     a.scpap,
                     a.scoper,
                     a.scsbop,
                     a.sctope,
                     trunc(sysdate),
                     trunc(sysdate + 2),
                     trunc(sysdate),
                     to_date('01010001', 'ddmmyyyy'),
                     'BANTOTAL',
                     null,
                     to_char(systimestamp, 'hh24:mi:ss'),
                     null,
                     1,
                     0,
                     0.00,
                     0.00,
                     to_date('01010001', 'ddmmyyyy'),
                     to_date('01010001', 'ddmmyyyy'),
                     null,
                     null,
                     null
                from fsd011 a
               where pgcod = 1
                 and scmod = 21
                 and sccta = LN_CUENTA
                 and scsbop = LN_SUPOPE
                 and sctope = LN_TIPOPE
                 and scstat < 99;

    end if;
  end if;
  bEGIN
    SELECT SYSDATE INTO FECHA_COMP FROM DUAL;
        INSERT INTO JAQY679 (JAQY679MOD,
                            JAQY679SUC,
                            JAQY679MDA,
                            JAQY679PAP,
                            JAQY679CTA,
                            JAQY679OPER,
                            JAQY679SBOP,
                            JAQY679TOPE,
                            JAQY679FECH,
                            JAQY679AGEN)
                     VALUES(LN_MODULO,
                            LN_SUCURS,
                            LN_MONEDA,
                            LN_PAPEL,
                            LN_CUENTA,
                            LN_OPER,
                            LN_SUPOPE,
                            LN_TIPOPE,
                            FECHA_COMP,
                            LN_AGENTE                            
                            );
               COMMIT;             
                           
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      NULL;
  END;  

END SP_AH_APERCUENTA;
/

