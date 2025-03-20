CREATE OR REPLACE PACKAGE PQ_AH_RRHHREP IS
------------------------------------------------------------
PROCEDURE SP_AH_REALIZAR_REPORTE (V_TIPOREP IN NUMBER,
                                  V_USUARIO IN VARCHAR2);
------------------------------------------------------------
PROCEDURE SP_consolidado (V_TIPOREP IN NUMBER,
                          V_USUARIO IN VARCHAR2);
------------------------------------------------------------

PROCEDURE SP_DATA(FECHA_PROCESO IN DATE);
------------------------------------------------------------

END PQ_AH_RRHHREP;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_RRHHREP IS

PROCEDURE SP_AH_REALIZAR_REPORTE (V_TIPOREP IN NUMBER,
                                  V_USUARIO IN VARCHAR2)IS

CURSOR CEROFAM IS
   SELECT T2.PFNDOC DNI,
          TRIM(T2.PFAPE1)||' '||TRIM(T2.PFAPE2)||' '||TRIM(T2.PFNOM1)||' '||TRIM(T2.PFNOM2) NOMBRE,
          T2.PFFNAC FECHANAC,
          T2.PFEBCO
     FROM jaqy668 T2
    WHERE /*T2.PFEBCO = 'S'
      AND*/ NOT EXISTS( SELECT 1
                        FROM fsr002 F2
                       WHERE F2.PEPAIS = T2.PFPAIS
                         AND F2.PETDOC = T2.PFTDOC
                         AND F2.PENDOC = T2.PFNDOC)
      AND NOT EXISTS ( SELECT 1
                         FROM fsr002 FS
                        WHERE FS.RPPAIS = T2.PFPAIS
                          AND FS.RPTDOC = T2.PFTDOC
                          AND FS.RPNDOC = T2.PFNDOC)
     AND NOT EXISTS (SELECT 1
                          FROM JAQY673
                         WHERE jaqy673dnit = T2.PFNDOC);

CURSOR TRESFAM IS
 SELECT SUM(T1.CONTADOR) TOTAL ,
        T1.DNI
   FROM
      (select COUNT(*) CONTADOR,
              t_iden.pfndoc DNI
        from jaqy668 t_iden,--fsd002 t_iden,
             fsr002 t_relf,
             fst020 t_desp,
             fsd002 t_idfa,

             fst014 t_tido,
             fsr003 t_rcaj,
             fst020 t_trel,

             fst014 t_tdfa,
             fsr003 t_rcfa,
             fst020 t_rcde
       where t_relf.pepais = t_iden.pfpais
          and t_relf.petdoc = t_iden.pftdoc
          and t_relf.pendoc = t_iden.pfndoc
          and t_desp.vicod = t_relf.rpccyg

          and t_idfa.pfpais = t_relf.rppais
          and t_idfa.pftdoc = t_relf.rptdoc
          and t_idfa.pfndoc = t_relf.rpndoc

          and t_tido.tdocum(+) = t_iden.pftdoc

          and t_rcaj.pjndoc(+) = '20100209641 '
          and t_rcaj.pfndo1(+) = t_iden.pftdoc
          and t_trel.vicod(+) = t_rcaj.vicod

          and t_tdfa.tdocum(+) = t_idfa.pftdoc

          and t_rcfa.pjndoc(+) = '20100209641 '
          and t_rcfa.pfndo1(+) = t_idfa.pfndoc
          and t_rcde.vicod(+) = t_rcfa.vicod
         ---and t_iden.pfndoc = '47216030' ---PRUEBAS
          GROUP BY t_iden.pfndoc

      union all

      select COUNT(*) CONTADOR, t_iden.pfndoc DNI
        from jaqy668 t_iden,
             fsr002 t_relf,
             fst020 t_desp,
             fsd002 t_idfa,

             fst014 t_tido,
             fsr003 t_rcaj,
             fst020 t_trel,

             fst014 t_tdfa,
             fsr003 t_rcfa,
             fst020 t_rcde

       where t_relf.rppais = t_iden.pfpais
         and t_relf.rptdoc = t_iden.pftdoc
         and t_relf.rpndoc = t_iden.pfndoc
         and t_desp.vicod = t_relf.rpccyg

         and t_idfa.pfpais = t_relf.pepais
         and t_idfa.pftdoc = t_relf.petdoc
         and t_idfa.pfndoc = t_relf.pendoc

         and t_tido.tdocum(+) = t_iden.pftdoc

         and t_rcaj.pjndoc(+) = '20100209641 '
         and t_rcaj.pfndo1(+) = t_iden.pftdoc
         and t_trel.vicod(+) = t_rcaj.vicod

         and t_tdfa.tdocum(+) = t_idfa.pftdoc

         and t_rcfa.pjndoc(+) = '20100209641 '
         and t_rcfa.pfndo1(+) = t_idfa.pfndoc
         and t_rcde.vicod(+) = t_rcfa.vicod
---            and t_iden.pfndoc = '47216030'---PRUEBAS
       GROUP BY t_iden.pfndoc) T1
    GROUP BY T1.DNI
    HAVING SUM(T1.CONTADOR) < 4;


CURSOR TODOSFAM IS
    SELECT SUM(T1.CONTADOR) TOTAL ,
           T1.DNI
      FROM
     (select COUNT(*) CONTADOR,
             t_iden.pfndoc DNI
        from jaqy668 t_iden,
             fsr002 t_relf,
             fst020 t_desp,
             fsd002 t_idfa,

             fst014 t_tido,
             fsr003 t_rcaj,
             fst020 t_trel,

             fst014 t_tdfa,
             fsr003 t_rcfa,
             fst020 t_rcde
       where t_relf.pepais = t_iden.pfpais
         and t_relf.petdoc = t_iden.pftdoc
         and t_relf.pendoc = t_iden.pfndoc
         and t_desp.vicod = t_relf.rpccyg

         and t_idfa.pfpais = t_relf.rppais
         and t_idfa.pftdoc = t_relf.rptdoc
         and t_idfa.pfndoc = t_relf.rpndoc

         and t_tido.tdocum(+) = t_iden.pftdoc
         and t_rcaj.pjndoc(+) = '20100209641 '
         and t_rcaj.pfndo1(+) = t_iden.pftdoc
         and t_trel.vicod(+) = t_rcaj.vicod

         and t_tdfa.tdocum(+) = t_idfa.pftdoc

         and t_rcfa.pjndoc(+) = '20100209641 '
         and t_rcfa.pfndo1(+) = t_idfa.pfndoc
         and t_rcde.vicod(+) = t_rcfa.vicod
       --   and t_iden.pfndoc = '47216030' ---PRUEBAS
        GROUP BY t_iden.pfndoc
    union all

    select COUNT(*) CONTADOR,
           t_iden.pfndoc  DNI
      from jaqy668 t_iden,
           fsr002 t_relf,
           fst020 t_desp,
           fsd002 t_idfa,

           fst014 t_tido,
           fsr003 t_rcaj,
           fst020 t_trel,

           fst014 t_tdfa,
           fsr003 t_rcfa,
           fst020 t_rcde
     where t_relf.rppais = t_iden.pfpais
       and t_relf.rptdoc = t_iden.pftdoc
       and t_relf.rpndoc = t_iden.pfndoc
       and t_desp.vicod = t_relf.rpccyg

       and t_idfa.pfpais = t_relf.pepais
       and t_idfa.pftdoc = t_relf.petdoc
       and t_idfa.pfndoc = t_relf.pendoc

       and t_tido.tdocum(+) = t_iden.pftdoc

       and t_rcaj.pjndoc(+) = '20100209641 '
       and t_rcaj.pfndo1(+) = t_iden.pftdoc
       and t_trel.vicod(+) = t_rcaj.vicod

       and t_tdfa.tdocum(+) = t_idfa.pftdoc

       and t_rcfa.pjndoc(+) = '20100209641 '
       and t_rcfa.pfndo1(+) = t_idfa.pfndoc
       and t_rcde.vicod(+) = t_rcfa.vicod
--      and t_iden.pfndoc = '47216030'---PRUEBAS
      GROUP BY t_iden.pfndoc) T1
    GROUP BY T1.DNI;


CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,
                 1 Tipo_Reg,
                 t_iden.pfeciv
            from jaqy668 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde
           where t_relf.pepais = t_iden.pfpais
             and t_relf.petdoc = t_iden.pftdoc
             and t_relf.pendoc = t_iden.pfndoc
             and t_desp.vicod = t_relf.rpccyg

             and t_idfa.pfpais = t_relf.rppais
             and t_idfa.pftdoc = t_relf.rptdoc
             and t_idfa.pfndoc = t_relf.rpndoc

             and t_tido.tdocum(+) = t_iden.pftdoc

             and t_rcaj.pjndoc(+) = '20100209641 '
             and t_rcaj.pfndo1(+) = t_iden.pftdoc
             and t_trel.vicod(+) = t_rcaj.vicod

             and t_tdfa.tdocum(+) = t_idfa.pftdoc

             and t_rcfa.pjndoc(+) = '20100209641 '
             and t_rcfa.pfndo1(+) = t_idfa.pfndoc
             and t_rcde.vicod(+) = t_rcfa.vicod

             and t_iden.pfndoc =  NRODOC ---'47216030'--'47216030'-- '29589266' 02446903
        union all
          select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,

                 2 Tipo_reg,
                 t_iden.pfeciv
            from jaqy668 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde

            where t_relf.rppais = t_iden.pfpais
                  and t_relf.rptdoc = t_iden.pftdoc
                  and t_relf.rpndoc = t_iden.pfndoc
                  and t_desp.vicod = t_relf.rpccyg

                  and t_idfa.pfpais = t_relf.pepais
                  and t_idfa.pftdoc = t_relf.petdoc
                  and t_idfa.pfndoc = t_relf.pendoc

                  and t_tido.tdocum(+) = t_iden.pftdoc

                  and t_rcaj.pjndoc(+) = '20100209641 '
                  and t_rcaj.pfndo1(+) = t_iden.pftdoc
                  and t_trel.vicod(+) = t_rcaj.vicod

                  and t_tdfa.tdocum(+) = t_idfa.pftdoc

                  and t_rcfa.pjndoc(+) = '20100209641 '
                  and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                  and t_rcde.vicod(+) = t_rcfa.vicod

                  and t_iden.pfndoc = NRODOC) T2; --'47216030'--'29589266' '40760733'

VCONT_ABUELOS NUMBER;--63
VCONT_CONYUGE NUMBER;--66
VCONT_HIJOS   NUMBER;--69
VCONT_CUNADOS NUMBER;--67
VCONT_PADRES  NUMBER;--71
VCONT_SUEGROS NUMBER;--75
VCONT_BISABUELO   NUMBER;--64
VCONT_BISNIETO    NUMBER;--65
VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
VCONT_NIETO       NUMBER;--70  NIETO(A)
VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
VCONT_PRIMO       NUMBER;---72 PRIMO(A)
VCONT_SOBRINO     NUMBER;--74  SOBRINO(A)
VCONT_TATARABUELO NUMBER;--76  TATARABUELO(A)
VCONT_TATANIETO   NUMBER;--77  TATARANIETO(A)
VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
VCONT_TIO         NUMBER;---79 TIO(A)
VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
-------------------------
VCONT_CONVIVIENTE NUMBER; --91 CONVIVIENTE
VCONT_PROGENITOR  NUMBER; --92 PROGENITOR EXPAREJA



OBSERVACION   varchar2(200);
V_FECHAHOY    DATE;
V_YEARHOY     NUMBER;
V_YEARNAC     NUMBER;
V_EDADT       NUMBER;
V_EDADF       NUMBER;
fechafam      DATE;
fechahoy      DATE;

Type temp1 is table of fsd002%rowtype;
Nt temp1;

BEGIN
  --------------------------
  DELETE JAQY667;
--  WHERE JAQY667USER = V_USUARIO;
  COMMIT;

  DELETE jaqy668;
  COMMIT;

  Begin
      Select * bulk collect
        into Nt
        from fsd002
       where pfebco= 'S';
         for i in Nt.first..Nt.last loop
           insert into jaqy668 (pfpais,
                                pftdoc,
                                pfndoc,
                                pfape1,
                                pfape2,
                                pfnom1,
                                pfnom2,
                                pfebco,
                                pffibc,
                                pfcant,
                                pffnac,
                                pfeciv,
                                pfpnac,
                                pflnac,
                                pfcleg,
                                pffleg,
                                pffal,
                                pfffal,
                                pfcapl,
                                pffant,
                                pfepat,
                                pffpep)
                          values(nt(i).pfpais,
                                nt(i).pftdoc,
                                nt(i).pfndoc,
                                nt(i).pfape1,
                                nt(i).pfape2,
                                nt(i).pfnom1,
                                nt(i).pfnom2,
                                nt(i).pfebco,
                                nt(i).pffibc,
                                nt(i).pfcant,
                                nt(i).pffnac,
                                nt(i).pfeciv,
                                nt(i).pfpnac,
                                nt(i).pflnac,
                                nt(i).pfcleg,
                                nt(i).pffleg,
                                nt(i).pffal,
                                nt(i).pfffal,
                                nt(i).pfcapl,
                                nt(i).pffant,
                                nt(i).pfepat,
                                nt(i).pffpep );

         end loop;
         commit;
   End;



  SELECT PGFAPE
    INTO V_FECHAHOY
    FROM FST017
 WHERE PGCOD = 1;



  CASE V_TIPOREP

    WHEN  1 THEN
      FOR CE IN CEROFAM LOOP
           BEGIN
             
             V_EDADT := trunc(months_between(V_FECHAHOY ,CE.FECHANAC)/12,0);  
             --V_EDADT :=  V_YEARHOY - V_YEARNAC;
             INSERT INTO JAQY667(jaqy667dnit,
                                 jaqy667dnif,
                                 jaqy667nomt,
                                 jaqy667fnac,
                                 jaqy667estt,
                                 jaqy667user,
                                 Jaqy667edat)
                          VALUES (CE.DNI,
                                  1,
                                  CE.NOMBRE,
                                  CE.FECHANAC,
                                  CE.PFEBCO,
                                  V_USUARIO,
                                  V_EDADT
                                 );
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
               NULL;
           END;
      END LOOP;
      COMMIT;

    WHEN  2 THEN
      FOR REG IN TRESFAM LOOP
         FOR DES IN DESPLIEGUE(REG.DNI) LOOP
           BEGIN
             OBSERVACION   := null;
             --Observaciones sobre registro
             IF DES.COD_RELA = 69 THEN
                IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser PADRE/MADRE';
                END IF;
             END IF;

             IF DES.COD_RELA = 71 THEN
                IF DES.FEC_NAC < DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser HIJO/HIJA';
                END IF;
             END IF;

             IF DES.COD_RELA = 70 THEN
                 IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                      OBSERVACION := 'Ingreso Incorrecto deberia ser ABUELO/ABUELA';
                  END IF;
             END IF;
             -- Extraqemos Año de nacimiento de trab
        /*    SELECT EXTRACT(YEAR FROM(DES.FEC_NAC))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADT :=  V_YEARHOY - V_YEARNAC;

             SELECT EXTRACT(YEAR FROM(DES.FEC_NAC_FAM))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADF :=  V_YEARHOY - V_YEARNAC;*/
              V_EDADT := trunc(months_between(V_FECHAHOY ,DES.FEC_NAC)/12,0); -- V_YEARHOY - V_YEARNAC;

          --   fecha2:= to_char(DES.FEC_NAC_FAM,'dd/mm/yyyy');
             fechafam := DES.FEC_NAC_FAM;
             fechahoy := V_FECHAHOY;
             V_EDADF :=  trunc(months_between(fechahoy,fechafam)/12,0);

             INSERT INTO JAQY667(jaqy667dnit,
                                 jaqy667dnif,
                                 jaqy667nomt,
                                 jaqy667fnac,
                                 jaqy667estt,
                                 jaqy667crel,
                                 jaqy667dcod,
                                 jaqy667tdoc,
                                 jaqy667nomf,
                                 jaqy667fnaf,
                                 jaqy667user,
                                 jaqy667aux4,
                                 jaqy667edat,
                                 jaqy667edaf)
                          VALUES (DES.DNI,
                                  DES.DNI_FAM,
                                  DES.NOMTRABAJADOR,
                                  DES.FEC_NAC,
                                  DES.SN,
                                  DES.COD_RELA,
                                  DES.RELACION,
                                  DES.TIP_DOC_FAM,
                                  DES.NOM_FAM,
                                  DES.FEC_NAC_FAM,
                                  V_USUARIO,
                                  OBSERVACION,
                                  V_EDADT,
                                  V_EDADF
                                 );
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
               NULL;
           END;
         END LOOP;
         COMMIT;
      END LOOP;

    WHEN  3 THEN


      FOR TOD IN TODOSFAM LOOP
         VCONT_ABUELOS := 0;  --63
         VCONT_CONYUGE := 0;--66
         VCONT_HIJOS   := 0;--69
         VCONT_CUNADOS := 0;--67
         VCONT_PADRES  := 0;--71
         VCONT_SUEGROS := 0;--75
         VCONT_NIETO       := 0;--70   NIETO(A)
         VCONT_BISABUELO   := 0;--64
         VCONT_BISNIETO    := 0;--65
         VCONT_HERMANO     := 0;-- 68 HERMANO(A)
         VCONT_PRIMOHNO    := 0; --73 PRIMO HERMANO(A)
         VCONT_PRIMO       := 0;---72 PRIMO(A)
         VCONT_SOBRINO     := 0;--74   SOBRINO(A)
         VCONT_TATARABUELO := 0;--76   TATARABUELO(A)
         VCONT_TATANIETO   := 0;--77   TATARANIETO(A)
         VCONT_TIOABUELO   := 0;---78 TIO ABUELO(A)
         VCONT_TIO         := 0;---79 TIO(A)
         VCONT_NUERAYERNO  := 0;-- 89 NUERA/YERNO

         VCONT_CONVIVIENTE := 0;--91
         VCONT_PROGENITOR  := 0;--92

         OBSERVACION   := null;
         FOR DES IN DESPLIEGUE(TOD.DNI) LOOP
           BEGIN
            OBSERVACION   := null;
             --- conteo de  parientes
             IF DES.COD_RELA = 63 THEN
                VCONT_ABUELOS := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_ABUELOS := 0;
             END IF;

             IF DES.COD_RELA = 66 and des.pfeciv= '1' THEN
                VCONT_CONYUGE := 1;---VCONT_CONYUGE + 1;
             ELSE
               IF DES.COD_RELA = 66 and des.pfeciv= '1' THEN
                VCONT_CONVIVIENTE := 1;---VCONT_CONYUGE + 1;
               ELSE
                VCONT_CONYUGE := 0;
               END IF;
             END IF;

             IF DES.COD_RELA = 69  THEN
                VCONT_HIJOS := 1;  ---VCONT_HIJOS + 1;
                IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser PADRE/MADRE';
                END IF;
             ELSE
                VCONT_HIJOS := 0;
             END IF;

             IF DES.COD_RELA = 67 THEN
                VCONT_CUNADOS := 1; ---VCONT_CUNADOS + 1;
             ELSE
                VCONT_CUNADOS := 0;
             END IF;

             IF DES.COD_RELA = 71 THEN
                VCONT_PADRES :=  1;---VCONT_PADRES + 1;
                IF DES.FEC_NAC < DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser HIJO/HIJA';
                END IF;
             ELSE
                 VCONT_PADRES := 0;
             END IF;

             IF DES.COD_RELA = 75 THEN
                VCONT_SUEGROS := 1; ---VCONT_SUEGROS + 1;
             ELSE
                VCONT_SUEGROS := 0;
             END IF;

             IF DES.COD_RELA = 70 THEN
                 VCONT_NIETO := 1;
                 IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                      OBSERVACION := 'Ingreso Incorrecto deberia ser ABUELO/ABUELA';
                 END IF;
             ELSE
               VCONT_NIETO := 0;
             END IF;
             ------
                          --- conteo de  parientes
             IF DES.COD_RELA = 64 THEN
                VCONT_BISABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_BISABUELO := 0;
             END IF;

             IF DES.COD_RELA = 65 THEN
                VCONT_BISNIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_BISNIETO := 0;
             END IF;

             IF DES.COD_RELA = 68 THEN
                VCONT_HERMANO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_HERMANO := 0;
             END IF;

             IF DES.COD_RELA = 73 THEN
                VCONT_PRIMOHNO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_PRIMOHNO := 0;
             END IF;

             IF DES.COD_RELA = 72 THEN
                VCONT_PRIMO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_PRIMO := 0;
             END IF;

             IF DES.COD_RELA = 74 THEN
                VCONT_SOBRINO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_SOBRINO := 0;
             END IF;

             IF DES.COD_RELA = 76 THEN
                VCONT_TATARABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TATARABUELO := 0;
             END IF;

             IF DES.COD_RELA = 77 THEN
                VCONT_TATANIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TATANIETO := 0;
             END IF;

             IF DES.COD_RELA = 78 THEN
                VCONT_TIOABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TIOABUELO := 0;
             END IF;

             IF DES.COD_RELA = 79 THEN
                VCONT_TIO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TIO := 0;
             END IF;

             IF DES.COD_RELA = 89 THEN
                VCONT_NUERAYERNO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_NUERAYERNO := 0;
             END IF;
             IF DES.COD_RELA = 91 THEN
                VCONT_CONVIVIENTE := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_PROGENITOR := 0;
             END IF;


             --eDADES
             SELECT EXTRACT(YEAR FROM( SELECT DES.FEC_NAC FROM DUAL))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADT :=  V_YEARHOY - V_YEARNAC;
             SELECT EXTRACT(YEAR FROM( SELECT DES.FEC_NAC_FAM FROM DUAL))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADF :=  V_YEARHOY - V_YEARNAC;
             Begin
                 INSERT INTO JAQY667(jaqy667dnit,
                                     jaqy667dnif,
                                     jaqy667nomt,
                                     jaqy667fnac,
                                     jaqy667estt,
                                     jaqy667crel,
                                     jaqy667dcod,
                                     jaqy667tdoc,
                                     jaqy667nomf,
                                     jaqy667fnaf,
                                     jaqy667nabu,
                                     jaqy667npad,
                                     jaqy667ncoy,
                                     jaqy667nhij,
                                     jaqy667nsue,
                                     jaqy667ncun,
                                     jaqy667user,
                                     jaqy667aux4,
                                     JAQY667EDAT,
                                     Jaqy667edaf,
                                     jaqy667nny,
                                     jaqy667ntia,
                                     jaqy667ntio,
                                     jaqy667ntni,
                                     jaqy667ntab,
                                     jaqy667nsob,
                                     jaqy667nphr,
                                     jaqy667nnie,
                                     jaqy667nher,
                                     jaqy667nbni,
                                     jaqy667nbab,
                                     jaqy667nPRI,
                                     JAQY667AUX1,
                                     JAQY667AUX2
                                      )
                              VALUES (DES.DNI,
                                      DES.DNI_FAM,
                                      DES.NOMTRABAJADOR,
                                      DES.FEC_NAC,
                                      DES.SN,
                                      DES.COD_RELA,
                                      DES.RELACION,
                                      DES.TIP_DOC_FAM,
                                      DES.NOM_FAM,
                                      DES.FEC_NAC_FAM,
                                      VCONT_ABUELOS,
                                      VCONT_PADRES,
                                      VCONT_CONYUGE,
                                      VCONT_HIJOS,
                                      VCONT_SUEGROS,
                                      VCONT_CUNADOS,
                                      V_USUARIO,
                                      OBSERVACION,
                                      V_EDADT,
                                      V_EDADF,
                                      VCONT_NUERAYERNO,
                                      VCONT_TIOABUELO,
                                      VCONT_TIO,
                                      VCONT_TATANIETO,
                                      VCONT_TATARABUELO,
                                      VCONT_SOBRINO,
                                      VCONT_PRIMOHNO,
                                      VCONT_NIETO,
                                      VCONT_HERMANO,
                                      VCONT_BISNIETO,
                                      VCONT_BISABUELO,
                                      VCONT_PRIMO,
                                      VCONT_CONVIVIENTE,
                                      VCONT_PROGENITOR
                                     );
                    COMMIT;
               EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                   NULL;
               END;
           exception
             When others then
               null;
           End;
         END LOOP;
     END LOOP;

   WHEN  4 THEN
     DELETE JAQY667
      WHERE JAQY667USER = V_USUARIO;
     COMMIT;
  END CASE;

END SP_AH_REALIZAR_REPORTE;

--- modificacion de reporte de datos conjunta
-- creacion nueva tabla jaqy667aux

PROCEDURE SP_Consolidado (V_TIPOREP IN NUMBER,
                          V_USUARIO IN VARCHAR2)IS

CURSOR TODOSFAM IS
    Select pfndoc DNI
        from fsd002
       where pfebco= 'S';
--       and pfndoc = '29730509';

 

CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,
                 1 Tipo_Reg,
                 t_iden.pfeciv
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde
           where t_relf.pepais = t_iden.pfpais
             and t_relf.petdoc = t_iden.pftdoc
             and t_relf.pendoc = t_iden.pfndoc
             and t_iden.pfebco = 'S'
             and t_desp.vicod = t_relf.rpccyg

             and t_idfa.pfpais = t_relf.rppais
             and t_idfa.pftdoc = t_relf.rptdoc
             and t_idfa.pfndoc = t_relf.rpndoc

             and t_tido.tdocum(+) =  t_idfa.pftdoc --t_iden.pftdoc

             and t_rcaj.pjndoc(+) = '20100209641 '
             and t_rcaj.pfndo1(+) =  t_idfa.pftdoc--t_iden.pftdoc
             and t_trel.vicod(+) = t_rcaj.vicod

             and t_tdfa.tdocum(+) = t_idfa.pftdoc

             and t_rcfa.pjndoc(+) = '20100209641 '
             and t_rcfa.pfndo1(+) = t_idfa.pfndoc
             and t_rcde.vicod(+) = t_rcfa.vicod
             and t_iden.pfebco = 'S'
             and t_iden.pfndoc =  NRODOC ---'47216030'--'47216030'-- '29589266' 02446903
        union all
          select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,

                 2 Tipo_reg,
                 t_iden.pfeciv
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde

            where t_relf.rppais = t_iden.pfpais
                  and t_relf.rptdoc = t_iden.pftdoc
                  and t_relf.rpndoc = t_iden.pfndoc
                  and t_iden.pfebco = 'S'
                  and t_desp.vicod = t_relf.rpccyg

                  and t_idfa.pfpais = t_relf.pepais
                  and t_idfa.pftdoc = t_relf.petdoc
                  and t_idfa.pfndoc = t_relf.pendoc

                  and t_tido.tdocum(+) =  t_idfa.pftdoc --t_iden.pftdoc

                  and t_rcaj.pjndoc(+) = '20100209641 '
                  and t_rcaj.pfndo1(+) =  t_idfa.pftdoc-- t_iden.pftdoc
                  and t_trel.vicod(+) = t_rcaj.vicod

                  and t_tdfa.tdocum(+) = t_idfa.pftdoc

                  and t_rcfa.pjndoc(+) = '20100209641 '
                  and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                  and t_rcde.vicod(+) = t_rcfa.vicod
                  and t_iden.pfebco = 'S'
                  and t_iden.pfndoc = NRODOC
            union all
                select a.jaqy673nomt  NomTrabajador,
                 a.jaqy673dnit  DNI,
--                 (SELECT pffnac  FROM FSD002 WHERE PFPAIS =604 AND PFTDOC=21 AND PFNDOC= NRODOC) Fec_Nac,
                 b.pffnac Fec_Nac,
                 --(SELECT pfebco   FROM FSD002 WHERE PFPAIS =604 AND PFTDOC=21 AND PFNDOC= NRODOC) SN,
                 b.pfebco SN,
                 null Rel_Caja,
                 a.jaqy673crel  Cod_rela,
                 a.jaqy673dcod  Relacion,
                 a.jaqy673nomf  Nom_Fam,
                 'Sin/Doc' Tip_Doc_Fam,
                 lpad(TRIM(a.jaqy673dnif),9,'0')  DNI_Fam,
                 null Fec_Nac_Fam,
                 'No' Vinc_Fam_con_Caja,
                 3 Tipo_reg,
                 '0' pfeciv
                  from jaqy673 a,
                       fsd002 b
                 where b.pfpais =604
                   and b.pftdoc = 21
                   and b.pfndoc = a.jaqy673dnit
                   and b.pfebco = 'S'
                   AND a.jaqy673dnit = NRODOC --'47216030'
                 ) T2; --'47216030'--'29589266' '40760733'

VCONT_ABUELOS NUMBER;--63
VCONT_CONYUGE NUMBER;--66
VCONT_HIJOS   NUMBER;--69
VCONT_CUNADOS NUMBER;--67
VCONT_PADRES  NUMBER;--71
VCONT_SUEGROS NUMBER;--75
VCONT_BISABUELO   NUMBER;--64
VCONT_BISNIETO    NUMBER;--65
VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
VCONT_NIETO       NUMBER;--70  NIETO(A)
VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
VCONT_PRIMO       NUMBER;---72 PRIMO(A)
VCONT_SOBRINO     NUMBER;--74  SOBRINO(A)
VCONT_TATARABUELO NUMBER;--76  TATARABUELO(A)
VCONT_TATANIETO   NUMBER;--77  TATARANIETO(A)
VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
VCONT_TIO         NUMBER;---79 TIO(A)
VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
-------------------------
VCONT_CONVIVIENTE NUMBER; --91 CONVIVIENTE
VCONT_PROGENITOR  NUMBER; --92 PROGENITOR EXPAREJA



OBSERVACION   varchar2(200);
V_FECHAHOY    DATE;
V_YEARHOY     NUMBER;
V_YEARNAC     NUMBER;
V_EDADT       NUMBER;
V_EDADF       NUMBER;
fecha1        char(10);
fecha2        char(10);
fechatrab     date;
fechafam      date;
ANIOTRAB      NUMBER;
ANIOFAM       NUMBER;
fechahoy      date;

Type temp1 is table of fsd002%rowtype;
-- temp1;

usuario       char(10);
hoyfecha      char(10);
BEGIN
  --------------------------
  DELETE JAQY667AUX;
  COMMIT;

usuario := trim(v_usuario);
  SELECT PGFAPE
    INTO  V_FECHAHOY
    FROM FST017
 WHERE PGCOD = 1;

V_YEARHOY := TO_NUMBER(HOYFECHA);
--V_FECHAHOY := to_date(hoyfecha,'dd/mm/yyyy');

 /*SELECT EXTRACT(YEAR FROM( SELECT V_FECHAHOY FROM DUAL))
   INTO V_YEARHOY
   FROM DUAL;*/

  CASE V_TIPOREP


    WHEN  3 THEN


      FOR TOD IN TODOSFAM LOOP
         VCONT_ABUELOS := 0;  --63
         VCONT_CONYUGE := 0;--66
         VCONT_HIJOS   := 0;--69
         VCONT_CUNADOS := 0;--67
         VCONT_PADRES  := 0;--71
         VCONT_SUEGROS := 0;--75
         VCONT_NIETO       := 0;--70   NIETO(A)
         VCONT_BISABUELO   := 0;--64
         VCONT_BISNIETO    := 0;--65
         VCONT_HERMANO     := 0;-- 68 HERMANO(A)
         VCONT_PRIMOHNO    := 0; --73 PRIMO HERMANO(A)
         VCONT_PRIMO       := 0;---72 PRIMO(A)
         VCONT_SOBRINO     := 0;--74   SOBRINO(A)
         VCONT_TATARABUELO := 0;--76   TATARABUELO(A)
         VCONT_TATANIETO   := 0;--77   TATARANIETO(A)
         VCONT_TIOABUELO   := 0;---78 TIO ABUELO(A)
         VCONT_TIO         := 0;---79 TIO(A)
         VCONT_NUERAYERNO  := 0;-- 89 NUERA/YERNO

         VCONT_CONVIVIENTE := 0;--91
         VCONT_PROGENITOR  := 0;--92

         OBSERVACION   := null;
         FOR DES IN DESPLIEGUE(TOD.DNI) LOOP
           BEGIN
            OBSERVACION   := null;
             --- conteo de  parientes
             IF DES.COD_RELA = 63 THEN
                VCONT_ABUELOS := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_ABUELOS := 0;
             END IF;

             IF DES.COD_RELA = 66 and des.pfeciv = '1' THEN
                VCONT_CONYUGE := 1;---VCONT_CONYUGE + 1;
             ELSE
               IF DES.COD_RELA = 66 and des.pfeciv= '1' THEN
                 VCONT_CONVIVIENTE := 1;---VCONT_CONYUGE + 1;
               ELSE
                 VCONT_CONYUGE := 0;
               END IF;
             END IF;

             IF DES.COD_RELA = 69 THEN
                VCONT_HIJOS := 1;  ---VCONT_HIJOS + 1;
                IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser PADRE/MADRE';
                END IF;
             ELSE
                VCONT_HIJOS := 0;
             END IF;

             IF DES.COD_RELA = 67 THEN
                VCONT_CUNADOS := 1; ---VCONT_CUNADOS + 1;
             ELSE
                VCONT_CUNADOS := 0;
             END IF;

             IF DES.COD_RELA = 71 THEN
                VCONT_PADRES :=  1;---VCONT_PADRES + 1;
                IF DES.FEC_NAC < DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser HIJO/HIJA';
                END IF;
             ELSE
                 VCONT_PADRES := 0;
             END IF;

             IF DES.COD_RELA = 75 THEN
                VCONT_SUEGROS := 1; ---VCONT_SUEGROS + 1;
             ELSE
                VCONT_SUEGROS := 0;
             END IF;

             IF DES.COD_RELA = 70 THEN
                 VCONT_NIETO := 1;
                 IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                      OBSERVACION := 'Ingreso Incorrecto deberia ser ABUELO/ABUELA';
                 END IF;
             ELSE
               VCONT_NIETO := 0;
             END IF;
             ------
                          --- conteo de  parientes
             IF DES.COD_RELA = 64 THEN
                VCONT_BISABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_BISABUELO := 0;
             END IF;

             IF DES.COD_RELA = 65 THEN
                VCONT_BISNIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_BISNIETO := 0;
             END IF;

             IF DES.COD_RELA = 68 THEN
                VCONT_HERMANO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_HERMANO := 0;
             END IF;

             IF DES.COD_RELA = 73 THEN
                VCONT_PRIMOHNO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_PRIMOHNO := 0;
             END IF;

             IF DES.COD_RELA = 72 THEN
                VCONT_PRIMO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_PRIMO := 0;
             END IF;

             IF DES.COD_RELA = 74 THEN
                VCONT_SOBRINO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_SOBRINO := 0;
             END IF;

             IF DES.COD_RELA = 76 THEN
                VCONT_TATARABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TATARABUELO := 0;
             END IF;

             IF DES.COD_RELA = 77 THEN
                VCONT_TATANIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TATANIETO := 0;
             END IF;

             IF DES.COD_RELA = 78 THEN
                VCONT_TIOABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TIOABUELO := 0;
             END IF;

             IF DES.COD_RELA = 79 THEN
                VCONT_TIO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TIO := 0;
             END IF;

             IF DES.COD_RELA = 89 THEN
                VCONT_NUERAYERNO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_NUERAYERNO := 0;
             END IF;
             IF DES.COD_RELA = 91 THEN
                VCONT_CONVIVIENTE := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_PROGENITOR := 0;
             END IF;


             --eDADES
         /*    SELECT TO_CHAR(DES.FEC_NAC,'YYYY') INTO ANIOTRAB FROM DUAL;
             V_YEARNAC := TO_NUMBER(ANIOTRAB);
             V_EDADT :=  V_YEARHOY - V_YEARNAC;
             SELECT TO_CHAR(DES.FEC_NAC_FAM,'YYYY') INTO ANIOFAM FROM DUAL;
             V_YEARNAC := TO_NUMBER(ANIOFAM);
             V_EDADF :=  V_YEARHOY - V_YEARNAC;*/
             
    /*         fecha1 := to_char(DES.FEC_NAC,'dd/mm/yyyy');
             fechatrab := fecha1;*/
             V_EDADT := trunc(months_between(V_FECHAHOY ,DES.FEC_NAC)/12,0); -- V_YEARHOY - V_YEARNAC;

          --   fecha2:= to_char(DES.FEC_NAC_FAM,'dd/mm/yyyy');
             fechafam := DES.FEC_NAC_FAM;
             fechahoy := V_FECHAHOY;
             V_EDADF :=  trunc(months_between(fechahoy,fechafam)/12,0);
             Begin
               ----jaqz667_aux
                 INSERT INTO JAQY667AUX(jaqy667dnitX,
                                     jaqy667dnifX,
                                     jaqy667nomtX,
                                     jaqy667fnacX,
                                     jaqy667esttX,
                                     jaqy667crelX,
                                     jaqy667dcodX,
                                     jaqy667tdocX,
                                     jaqy667nomfX,
                                     jaqy667fnafX,
                                     jaqy667nabuX,
                                     jaqy667npadX,
                                     jaqy667ncoyX,
                                     jaqy667nhijX,
                                     jaqy667nsueX,
                                     jaqy667ncunX,
                                     jaqy667userX,
                                     jaqy667aux4X,
                                     JAQY667EDATX,
                                     Jaqy667edafX,
                                     jaqy667nnyX,
                                     jaqy667ntiaX,
                                     jaqy667ntioX,
                                     jaqy667ntniX,
                                     jaqy667ntabX,
                                     jaqy667nsobX,
                                     jaqy667nphrX,
                                     jaqy667nnieX,
                                     jaqy667nherX,
                                     jaqy667nbniX,
                                     jaqy667nbabX,
                                     jaqy667nPRIMX,
                                     JAQY667AUX1X,
                                     JAQY667AUX2X,
                                     JAQY667REPX
                                      )
                              VALUES (DES.DNI,
                                      DES.DNI_FAM,
                                      DES.NOMTRABAJADOR,
                                      DES.FEC_NAC,
                                      DES.SN,
                                      DES.COD_RELA,
                                      DES.RELACION,
                                      DES.TIP_DOC_FAM,
                                      DES.NOM_FAM,
                                      DES.FEC_NAC_FAM,
                                      VCONT_ABUELOS,
                                      VCONT_PADRES,
                                      VCONT_CONYUGE,
                                      VCONT_HIJOS,
                                      VCONT_SUEGROS,
                                      VCONT_CUNADOS,
                                      USUARIO,--V_USUARIO,
                                      OBSERVACION,
                                      V_EDADT,
                                      V_EDADF,
                                      VCONT_NUERAYERNO,
                                      VCONT_TIOABUELO,
                                      VCONT_TIO,
                                      VCONT_TATANIETO,
                                      VCONT_TATARABUELO,
                                      VCONT_SOBRINO,
                                      VCONT_PRIMOHNO,
                                      VCONT_NIETO,
                                      VCONT_HERMANO,
                                      VCONT_BISNIETO,
                                      VCONT_BISABUELO,
                                      VCONT_PRIMO,
                                      VCONT_CONVIVIENTE,
                                      VCONT_PROGENITOR,
                                     'Taux'
                                     );
                    COMMIT;
               EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                   NULL;
               END;
           exception
             When others then
               null;
           End;
         END LOOP;
     END LOOP;

   WHEN  4 THEN
     DELETE JAQY667aux
      WHERE JAQY667USERX = V_USUARIO;
     COMMIT;
  END CASE;

END SP_Consolidado;

PROCEDURE SP_DATA(FECHA_PROCESO IN DATE) IS
CURSOR TODOSFAM IS
    Select pfndoc DNI
        from fsd002
       where pfebco= 'S';


CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,
                 1 Tipo_Reg,
                 t_iden.pfeciv
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde
           where t_relf.pepais = t_iden.pfpais
             and t_relf.petdoc = t_iden.pftdoc
             and t_relf.pendoc = t_iden.pfndoc
             and t_iden.pfebco = 'S'
             and t_desp.vicod = t_relf.rpccyg

             and t_idfa.pfpais = t_relf.rppais
             and t_idfa.pftdoc = t_relf.rptdoc
             and t_idfa.pfndoc = t_relf.rpndoc

             and t_tido.tdocum(+) = t_idfa.pftdoc --t_iden.pftdoc

             and t_rcaj.pjndoc(+) = '20100209641 '
             and t_rcaj.pfndo1(+) = t_idfa.pftdoc --t_iden.pftdoc
             and t_trel.vicod(+) = t_rcaj.vicod

             and t_tdfa.tdocum(+) = t_idfa.pftdoc

             and t_rcfa.pjndoc(+) = '20100209641 '
             and t_rcfa.pfndo1(+) = t_idfa.pfndoc
             and t_rcde.vicod(+) = t_rcfa.vicod

             and t_iden.pfndoc =  NRODOC ---'47216030'--'47216030'-- '29589266' 02446903
        union all
          select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2) NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pfndoc DNI_Fam,
                 t_idfa.pffnac Fec_Nac_Fam,
                 t_rcde.vinom Vinc_Fam_con_Caja,

                 2 Tipo_reg,
                 t_iden.pfeciv
            from fsd002 t_iden,
                 fsr002 t_relf,
                 fst020 t_desp,
                 fsd002 t_idfa,

                 fst014 t_tido,
                 fsr003 t_rcaj,
                 fst020 t_trel,

                 fst014 t_tdfa,
                 fsr003 t_rcfa,
                 fst020 t_rcde

            where t_relf.rppais = t_iden.pfpais
                  and t_relf.rptdoc = t_iden.pftdoc
                  and t_relf.rpndoc = t_iden.pfndoc
                  and t_iden.pfebco ='S'
                  and t_desp.vicod = t_relf.rpccyg

                  and t_idfa.pfpais = t_relf.pepais
                  and t_idfa.pftdoc = t_relf.petdoc
                  and t_idfa.pfndoc = t_relf.pendoc

                  and t_tido.tdocum(+) = t_idfa.pftdoc--t_iden.pftdoc

                  and t_rcaj.pjndoc(+) = '20100209641 '
                  and t_rcaj.pfndo1(+) = t_idfa.pftdoc --t_iden.pftdoc
                  and t_trel.vicod(+) = t_rcaj.vicod

                  and t_tdfa.tdocum(+) = t_idfa.pftdoc

                  and t_rcfa.pjndoc(+) = '20100209641 '
                  and t_rcfa.pfndo1(+) = t_idfa.pfndoc
                  and t_rcde.vicod(+) = t_rcfa.vicod

                  and t_iden.pfndoc = NRODOC
            union all
                select a.jaqy673nomt  NomTrabajador,
                 a.jaqy673dnit  DNI,
                 b.pffnac Fec_Nac,
                 b.pfebco SN,
                 null Rel_Caja,
                 a.jaqy673crel  Cod_rela,
                 a.jaqy673dcod  Relacion,
                 a.jaqy673nomf  Nom_Fam,
                 'Sin/Doc' Tip_Doc_Fam,
                 lpad(TRIM(a.jaqy673dnif),9,'0')  DNI_Fam,
                 null Fec_Nac_Fam,
                 'No' Vinc_Fam_con_Caja,
                 3 Tipo_reg,
                 '0' pfeciv
                  from jaqy673 a,
                       fsd002 b
                 where b.pfpais =604
                   and b.pftdoc = 21
                   and b.pfndoc = a.jaqy673dnit
                   and b.pfebco = 'S'
                   and a.jaqy673dnit = NRODOC --'47216030'
                 ) T2; --'47216030'--'29589266' '40760733'

VCONT_ABUELOS NUMBER;--63
VCONT_CONYUGE NUMBER;--66
VCONT_HIJOS   NUMBER;--69
VCONT_CUNADOS NUMBER;--67
VCONT_PADRES  NUMBER;--71
VCONT_SUEGROS NUMBER;--75
VCONT_BISABUELO   NUMBER;--64
VCONT_BISNIETO    NUMBER;--65
VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
VCONT_NIETO       NUMBER;--70  NIETO(A)
VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
VCONT_PRIMO       NUMBER;---72 PRIMO(A)
VCONT_SOBRINO     NUMBER;--74  SOBRINO(A)
VCONT_TATARABUELO NUMBER;--76  TATARABUELO(A)
VCONT_TATANIETO   NUMBER;--77  TATARANIETO(A)
VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
VCONT_TIO         NUMBER;---79 TIO(A)
VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
-------------------------
VCONT_CONVIVIENTE NUMBER; --91 CONVIVIENTE
VCONT_PROGENITOR  NUMBER; --92 PROGENITOR EXPAREJA



OBSERVACION   varchar2(200);
V_FECHAHOY    DATE;
V_YEARHOY     NUMBER;
V_YEARNAC     NUMBER;
V_EDADT       NUMBER;
V_EDADF       NUMBER;
fechafam      DATE;
fechahoy      DATE;

Type temp1 is table of fsd002%rowtype;


BEGIN


  SELECT PGFAPE
    INTO V_FECHAHOY
    FROM FST017
 WHERE PGCOD = 1;

 SELECT EXTRACT(YEAR FROM(V_FECHAHOY))
   INTO V_YEARHOY
   FROM DUAL;


      FOR TOD IN TODOSFAM LOOP
         VCONT_ABUELOS := 0;  --63
         VCONT_CONYUGE := 0;--66
         VCONT_HIJOS   := 0;--69
         VCONT_CUNADOS := 0;--67
         VCONT_PADRES  := 0;--71
         VCONT_SUEGROS := 0;--75
         VCONT_NIETO       := 0;--70   NIETO(A)
         VCONT_BISABUELO   := 0;--64
         VCONT_BISNIETO    := 0;--65
         VCONT_HERMANO     := 0;-- 68 HERMANO(A)
         VCONT_PRIMOHNO    := 0; --73 PRIMO HERMANO(A)
         VCONT_PRIMO       := 0;---72 PRIMO(A)
         VCONT_SOBRINO     := 0;--74   SOBRINO(A)
         VCONT_TATARABUELO := 0;--76   TATARABUELO(A)
         VCONT_TATANIETO   := 0;--77   TATARANIETO(A)
         VCONT_TIOABUELO   := 0;---78 TIO ABUELO(A)
         VCONT_TIO         := 0;---79 TIO(A)
         VCONT_NUERAYERNO  := 0;-- 89 NUERA/YERNO

         VCONT_CONVIVIENTE := 0;--91
         VCONT_PROGENITOR  := 0;--92

         OBSERVACION   := null;
         FOR DES IN DESPLIEGUE(TOD.DNI) LOOP
           BEGIN
            OBSERVACION   := null;
             --- conteo de  parientes
             IF DES.COD_RELA = 63 THEN
                VCONT_ABUELOS := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_ABUELOS := 0;
             END IF;

             IF DES.COD_RELA = 66 and des.pfeciv = '1' THEN
                VCONT_CONYUGE := 1;---VCONT_CONYUGE + 1;
             ELSE
               IF DES.COD_RELA = 66 and des.pfeciv= '1' THEN
                 VCONT_CONVIVIENTE := 1;---VCONT_CONYUGE + 1;
               ELSE
                 VCONT_CONYUGE := 0;
               END IF;
             END IF;

             IF DES.COD_RELA = 69 THEN
                VCONT_HIJOS := 1;  ---VCONT_HIJOS + 1;
                IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser PADRE/MADRE';
                END IF;
             ELSE
                VCONT_HIJOS := 0;
             END IF;

             IF DES.COD_RELA = 67 THEN
                VCONT_CUNADOS := 1; ---VCONT_CUNADOS + 1;
             ELSE
                VCONT_CUNADOS := 0;
             END IF;

             IF DES.COD_RELA = 71 THEN
                VCONT_PADRES :=  1;---VCONT_PADRES + 1;
                IF DES.FEC_NAC < DES.FEC_NAC_FAM THEN
                  OBSERVACION := 'Ingreso Incorrecto deberia ser HIJO/HIJA';
                END IF;
             ELSE
                 VCONT_PADRES := 0;
             END IF;

             IF DES.COD_RELA = 75 THEN
                VCONT_SUEGROS := 1; ---VCONT_SUEGROS + 1;
             ELSE
                VCONT_SUEGROS := 0;
             END IF;

             IF DES.COD_RELA = 70 THEN
                 VCONT_NIETO := 1;
                 IF DES.FEC_NAC > DES.FEC_NAC_FAM THEN
                      OBSERVACION := 'Ingreso Incorrecto deberia ser ABUELO/ABUELA';
                 END IF;
             ELSE
               VCONT_NIETO := 0;
             END IF;
             ------
                          --- conteo de  parientes
             IF DES.COD_RELA = 64 THEN
                VCONT_BISABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_BISABUELO := 0;
             END IF;

             IF DES.COD_RELA = 65 THEN
                VCONT_BISNIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_BISNIETO := 0;
             END IF;

             IF DES.COD_RELA = 68 THEN
                VCONT_HERMANO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_HERMANO := 0;
             END IF;

             IF DES.COD_RELA = 73 THEN
                VCONT_PRIMOHNO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_PRIMOHNO := 0;
             END IF;

             IF DES.COD_RELA = 72 THEN
                VCONT_PRIMO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_PRIMO := 0;
             END IF;

             IF DES.COD_RELA = 74 THEN
                VCONT_SOBRINO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_SOBRINO := 0;
             END IF;

             IF DES.COD_RELA = 76 THEN
                VCONT_TATARABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TATARABUELO := 0;
             END IF;

             IF DES.COD_RELA = 77 THEN
                VCONT_TATANIETO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TATANIETO := 0;
             END IF;

             IF DES.COD_RELA = 78 THEN
                VCONT_TIOABUELO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_TIOABUELO := 0;
             END IF;

             IF DES.COD_RELA = 79 THEN
                VCONT_TIO := 1;---VCONT_CONYUGE + 1;
             ELSE
                VCONT_TIO := 0;
             END IF;

             IF DES.COD_RELA = 89 THEN
                VCONT_NUERAYERNO := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_NUERAYERNO := 0;
             END IF;
             IF DES.COD_RELA = 91 THEN
                VCONT_CONVIVIENTE := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_CONVIVIENTE
             ELSE
                VCONT_PROGENITOR := 0;
             END IF;


             --eDADES
             /*SELECT EXTRACT(YEAR FROM(DES.FEC_NAC))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADT :=  V_YEARHOY - V_YEARNAC;
             SELECT EXTRACT(YEAR FROM(DES.FEC_NAC_FAM))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADF :=  V_YEARHOY - V_YEARNAC;*/
             
              V_EDADT := trunc(months_between(V_FECHAHOY ,DES.FEC_NAC)/12,0); -- V_YEARHOY - V_YEARNAC;

          --   fecha2:= to_char(DES.FEC_NAC_FAM,'dd/mm/yyyy');
             fechafam := DES.FEC_NAC_FAM;
             fechahoy := V_FECHAHOY;
             V_EDADF :=  trunc(months_between(fechahoy,fechafam)/12,0);
             
             Begin
               ----jaqz667_aux
                 INSERT INTO JAQY667HIS(jaqy667dnitH,
                                     jaqy667dnifH,
                                     jaqy667nomtH,
                                     jaqy667fnacH,
                                     jaqy667esttH,
                                     jaqy667crelH,
                                     jaqy667dcodH,
                                     jaqy667tdocH,
                                     jaqy667nomfH,
                                     jaqy667fnafH,
                                     jaqy667nabuH,
                                     jaqy667npadH,
                                     jaqy667ncoyH,
                                     jaqy667nhijH,
                                     jaqy667nsueH,
                                     jaqy667ncunH,
                                     jaqy667userH,
                                     jaqy667aux4H,
                                     JAQY667EDATH,
                                     Jaqy667edafH,
                                     jaqy667nnyH,
                                     jaqy667ntiaH,
                                     jaqy667ntioH,
                                     jaqy667ntniH,
                                     jaqy667ntabH,
                                     jaqy667nsobH,
                                     jaqy667nphrH,
                                     jaqy667nnieH,
                                     jaqy667nherH,
                                     jaqy667nbniH,
                                     jaqy667nbabH,
                                     jaqy667nPRIMH,
                                     JAQY667AUX1H,
                                     JAQY667AUX2H,
                                     JAQY667REPH,
                                     JAQY667FPROH)
                              VALUES (DES.DNI,
                                      DES.DNI_FAM,
                                      DES.NOMTRABAJADOR,
                                      DES.FEC_NAC,
                                      DES.SN,
                                      DES.COD_RELA,
                                      DES.RELACION,
                                      DES.TIP_DOC_FAM,
                                      DES.NOM_FAM,
                                      DES.FEC_NAC_FAM,
                                      VCONT_ABUELOS,
                                      VCONT_PADRES,
                                      VCONT_CONYUGE,
                                      VCONT_HIJOS,
                                      VCONT_SUEGROS,
                                      VCONT_CUNADOS,
                                      'PROC_HIST',
                                      OBSERVACION,
                                      V_EDADT,
                                      V_EDADF,
                                      VCONT_NUERAYERNO,
                                      VCONT_TIOABUELO,
                                      VCONT_TIO,
                                      VCONT_TATANIETO,
                                      VCONT_TATARABUELO,
                                      VCONT_SOBRINO,
                                      VCONT_PRIMOHNO,
                                      VCONT_NIETO,
                                      VCONT_HERMANO,
                                      VCONT_BISNIETO,
                                      VCONT_BISABUELO,
                                      VCONT_PRIMO,
                                      VCONT_CONVIVIENTE,
                                      VCONT_PROGENITOR,
                                     'HIS',
                                      FECHA_PROCESO);
                    COMMIT;
               EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                   NULL;
               END;
           exception
             When others then
               null;
           End;
         END LOOP;
     END LOOP;
END SP_DATA;

END PQ_AH_RRHHREP;
/

