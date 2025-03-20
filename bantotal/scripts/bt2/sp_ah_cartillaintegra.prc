create or replace procedure SP_AH_CARTILLAINTEGRA(CUENTA in NUMBER,
                                                  MODULO in NUMBER,
                                                  MONEDA IN NUMBER,
                                                  TIPO   IN NUMBER,
                                                  OPER   IN NUMBER,
                                                  SUCURS IN NUMBER,
                                                  SUBOPE IN NUMBER,
                                                  ACCION IN NUMBER,
                                                  UBUSER IN VARCHAR2,
                                                  TIPOCTA out varchar2) is
    CURSOR GRUPOS IS
        SELECT  distinct F.CTFACCOR GRUPO
          FROM fse130 F,
               FSR011 S,
               FSR130 R
         where F.PgCod = 1
           AND F.Ctnro = CUENTA
            AND S.Relcod = 5
            and s.r2cta = f.ctnro
            AND S.R2sbop = F.CTFACCOR
            and s.r1cod = 1
            AND S.R1cta  = F.CTNRO
           -- AND S.R2mod =1
            AND S.R2oper = TO_CHAR(F.CTFECDES,'YYYYMMDD')
            and s.r1mda = MONEDA
            and s.r1mod = MODULO
            AND s.r1suc = SUCURS
            AND S.R1OPER = OPER
            and s.r1sbop = SUBOPE
            and s.r1tope = TIPO
            and r.pgcod = f.pgcod
            and r.ctnro = s.r1cta
            and r.faccod = f.faccod
            and r.ctfaccor = f.ctfaccor
            order by F.CTFACCOR;


    CURSOR DATOS(GRUPO IN NUMBER) IS
         SELECT distinct F.FACCOD CODIGO,
                F.CTFACCOR GRUPO,
                (SELECT  FacNom FROM FST130  WHERE FacCod =  F.FACCOD) FACULTAD,
                decode(S.R1MOD,22, (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1OPER)),9,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0')),
                            (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1SBOP)),2,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0'))) cuenta,
                (select penom from fsd001 where pepais = r.pfpai2 and petdoc = r.pftdo2 and pendoc = r.pfndo2 ) integrante,
                r.pfpai2 pais,
                r.pftdo2 tdoc,
                r.pfndo2 ndoc
           FROM fse130 F,
                FSR011 S,
                FSR130 R
          where F.PgCod = 1
            AND F.Ctnro = CUENTA
            AND F.CTFACCOR = GRUPO
            AND S.Relcod = 5
            and s.r2cta = f.ctnro
            AND S.R2sbop = F.CTFACCOR
            and s.r1cod = 1
            AND S.R1cta  = F.CTNRO
          ---  AND S.R2mod =1
            AND S.R2oper = TO_CHAR(F.CTFECDES,'YYYYMMDD')
            and s.r1mda = MONEDA
            and s.r1mod = MODULO
            AND s.r1suc = SUCURS
            AND S.R1OPER = OPER
            and s.r1sbop = SUBOPE
            and s.r1tope = TIPO
            and r.pgcod = f.pgcod
            and r.ctnro = s.r1cta
            and r.faccod = f.faccod
            and r.ctfaccor = f.ctfaccor
            order by F.CTFACCOR, r.pfpai2,r.pftdo2,r.pfndo2;
      CURSOR DATOSDPF(GRUPO IN NUMBER) IS
         SELECT distinct F.FACCOD CODIGO,
                F.CTFACCOR GRUPO,
                (SELECT  FacNom FROM FST130  WHERE FacCod =  F.FACCOD) FACULTAD,
                decode(S.R1MOD,22, (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(22)),3,'0')  ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1OPER)),9,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0')),
                            (Lpad(trim(to_char(S.R1CTA)),9,'0') ||'-'|| Lpad(trim(to_char(21)),3,'0') ||'-'|| Lpad(trim(to_char( S.R1MDA)),3,'0') ||'-'|| Lpad(trim(to_char(S.R1SBOP)),2,'0') ||'-'|| Lpad(trim(to_char(S.R1TOPE)),3,'0'))) cuenta,
                (select penom from fsd001 where pepais = r.pfpai2 and petdoc = r.pftdo2 and pendoc = r.pfndo2 ) integrante,
                r.pfpai2 pais,
                r.pftdo2 tdoc,
                r.pfndo2 ndoc
           FROM fse130 F,
                FSR011 S,
                FSR130 R
          where F.PgCod = 1
            AND F.Ctnro = CUENTA
            AND F.CTFACCOR = GRUPO
            AND S.Relcod = 5
            and s.r2cta = f.ctnro
            AND S.R2sbop = F.CTFACCOR
            AND S.R1cta  = F.CTNRO
           --- AND S.R2mod =1
            AND S.R2oper = TO_CHAR(F.CTFECDES,'YYYYMMDD')
            and s.r1mda = MONEDA
            and s.r1mod in (22,122)
            AND s.r1suc = SUCURS
            AND S.R1OPER = OPER
            and s.r1tope = TIPO
            and r.pgcod = f.pgcod
            and r.ctnro = s.r1cta
            and r.faccod = f.faccod
            and r.ctfaccor = f.ctfaccor
            order by F.CTFACCOR, r.pfpai2,r.pftdo2,r.pfndo2;

 grupo  number:= 0;
 codigo varchar2(1500) := null;
 cont   number := 0;
 pais   varchar2(3);
 tdoc   varchar2(2);
 tipo1  varchar2(1);
 NroRep number:= 0;
 EXISTE NUMBER:= 0;
 MANCO  NUMBER:= 0;
 
begin
  case
    when ACCION = 1 then
      delete jaqy695; --- where jaqy695usu = rpad(ubuser,12,' ');
      commit;
      SELECT COUNT(*)
        into NroRep
       FROM FSR003
       where pjpais = (select pepais from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and pjtdoc = (select petdoc  from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and pjndoc = (select pendoc  from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and vicod = 7;

       IF NroRep = 1 then
         TIPOCTA := 'INDIVIDUAL';
       ELSE
          for G in GRUPOS loop
               CODIGO := NULL;
               CONT   := 0;
               IF G.GRUPO = 511 THEN
                 MANCO := 1;
               END IF;
               FOR D IN DATOS(G.GRUPO) LOOP
                  
                  codigo := codigo ||lpad(to_char(d.pais),3,'0')||lpad(to_char(d.tdoc),2,'0')||TRIM(d.ndoc)||'&';
                  cont := cont + 1;
               END LOOP;
               begin
                 if MANCO = 0 then
                   tipo1 := 'I';
                 else
                   tipo1 := 'C';
                 end if;
                   codigo := substr(codigo,1,200);
                 insert into jaqy695(jaqy695cod,
                                     jaqy695usu,
                                     jaqy695tip,
                                     jaqy695fec,
                                     jaqy695au1 )
                              values(codigo,
                                     ubuser,
                                     tipo1,
                                     trunc(sysdate),
                                     MANCO);
                 commit;
               EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                   NULL;
               end;
           end loop;


           ---------------------------********************************************------------------------
             bEGIN
               SELECT 1
                 INTO EXISTE
                 FROM jaqy695
                where JAQY695USU = RPAD(UBUSER,12,' ')
                  AND jaqy695tip = 'C'
                  AND jaqy695au1 = 1
                  and rownum= 1;
                TIPOCTA :='MANCOMUNADA';
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                BEGIN
                  SELECT 1
                   INTO EXISTE
                   FROM jaqy695
                  where JAQY695USU = RPAD(UBUSER,12,' ')
                    AND jaqy695tip = 'I'
                    AND jaqy695au1 = 0
                    and rownum = 1;
                  TIPOCTA :='INDISTINTA';
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                      SELECT 1
                        INTO EXISTE
                        FROM jaqz158
                       where JAQZ158PGE = 1
                         AND JAQZ158MOD = MODULO
                         AND JAQZ158SUC = SUCURS
                         AND JAQZ158MDA = MONEDA
                         AND JAQZ158PAP = 0
                         AND JAQZ158CTA = CUENTA
                         AND JAQZ158OPE = OPER
                         AND JAQZ158SBO = SUBOPE
                         AND JAQZ158TPO = TIPO
                         AND JAQZ158TIP = 'C'
                         and rownum = 1;
                         TIPOCTA :='MANCOMUNADA';
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    BEGIN
                       SELECT 1
                        INTO EXISTE
                        FROM jaqz158
                       where JAQZ158PGE = 1
                         AND JAQZ158MOD = MODULO
                         AND JAQZ158SUC = SUCURS
                         AND JAQZ158MDA = MONEDA
                         AND JAQZ158PAP = 0
                         AND JAQZ158CTA = CUENTA
                         AND JAQZ158OPE = OPER
                         AND JAQZ158SBO = SUBOPE
                         AND JAQZ158TPO = TIPO
                         AND JAQZ158TIP = 'I'
                         and rownum = 1;
                         TIPOCTA :='INDISTINTA';
                    EXCEPTION
                    WHEN NO_dATA_FOUND THEN
                      TIPOCTA := 'NO IDENTIFICADO';
                    END;
                  END;
                END;
             END;
         END IF;

           -----------------------------------------------------------------------------------------------
    when accion = 2 then
      delete jaqy695;--- where jaqy695usu = rpad(ubuser,12,' ');
      commit;
    when ACCION = 3 then
       delete jaqy695;-- where jaqy695usu = rpad(ubuser,12,' ');
       commit;
      SELECT COUNT(*)
        into NroRep
        FROM FSR003
       where pjpais = (select pepais from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and pjtdoc = (select petdoc  from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and pjndoc = (select pendoc  from fsr008 where ctnro = CUENTA and ttcod = 1 and cttfir = 'T')
         and vicod = 7;

       IF NroRep = 1 then
         TIPOCTA := 'INDIVIDUAL';
       ELSE
          for G in GRUPOS loop
               CODIGO := NULL;
               CONT   := 0;
               IF G.GRUPO = 511 THEN
                 MANCO := 1;
               END IF;
               FOR D IN DATOSDPF(G.GRUPO) LOOP
                  codigo := codigo ||lpad(to_char(d.pais),3,'0')||lpad(to_char(d.tdoc),2,'0')||TRIM(d.ndoc)||'&';
                  cont := cont + 1;
               END LOOP;
               begin
                 if cont = 1 or manco = 0 then
                   tipo1 := 'I';
                 else
                   tipo1 := 'C';
                 end if;
                 codigo := substr(codigo,1,200);
                 insert into jaqy695(jaqy695cod,
                                     jaqy695usu,
                                     jaqy695tip,
                                     jaqy695fec,
                                     jaqy695au1)
                              values(codigo,
                                     ubuser,
                                     tipo1,
                                     trunc(sysdate),
                                     MANCO);
                 commit;
               EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                   NULL;
               end;
           end loop;
           bEGIN
               SELECT 1
                 INTO EXISTE
                 FROM jaqy695
                where JAQY695USU = RPAD(UBUSER,12,' ')
                  AND jaqy695tip = 'C'
                  and jaqy695au1 = 1
                  AND ROWNUM = 1;
                TIPOCTA :='MANCOMUNADA';
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                BEGIN
                  SELECT 1
                   INTO EXISTE
                   FROM jaqy695
                  where JAQY695USU = RPAD(UBUSER,12,' ')
                    AND jaqy695tip = 'I'
                    and jaqy695au1 = 0
                    AND ROWNUM = 1;
                  TIPOCTA :='INDISTINTA';
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  BEGIN
                      SELECT 1
                        INTO EXISTE
                        FROM jaqz158
                       where JAQZ158PGE = 1
                         AND JAQZ158MOD in (22,122) --= MODULO
                         AND JAQZ158SUC = SUCURS
                         AND JAQZ158MDA = MONEDA
                         AND JAQZ158PAP = 0
                         AND JAQZ158CTA = CUENTA
                         AND JAQZ158OPE = OPER
                         AND JAQZ158SBO = SUBOPE
                         AND JAQZ158TPO = TIPO
                         AND JAQZ158TIP = 'C'
                         AND rOWNUM = 1;
                         TIPOCTA :='MANCOMUNADA';
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    BEGIN
                       SELECT 1
                        INTO EXISTE
                        FROM jaqz158
                       where JAQZ158PGE = 1
                         AND JAQZ158MOD  in (22,122)--= MODULO
                         AND JAQZ158SUC = SUCURS
                         AND JAQZ158MDA = MONEDA
                         AND JAQZ158PAP = 0
                         AND JAQZ158CTA = CUENTA
                         AND JAQZ158OPE = OPER
                         AND JAQZ158SBO = SUBOPE
                         AND JAQZ158TPO = TIPO
                         AND JAQZ158TIP = 'I'
                         AND ROWNUM = 1;
                         TIPOCTA :='INDISTINTA';
                    EXCEPTION
                    WHEN NO_dATA_FOUND THEN
                      TIPOCTA := 'NO IDENTIFICADO';
                    END;
                  END;
                END;
             END;
         END IF;

  end case;
end SP_AH_CARTILLAINTEGRA;
/

