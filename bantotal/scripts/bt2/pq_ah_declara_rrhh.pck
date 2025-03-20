CREATE OR REPLACE PACKAGE PQ_AH_DECLARA_RRHH IS

------------------------------------------------------
Procedure SP_AH_GENERA_TODOS;
------------------------------------------------------
procedure SP_AH_ALERT_REGFAM;
------------------------------------------------------
procedure SP_AH_REGFAMUNO(lc_dninro  in varchar2,
                          lc_usuario in varchar2);
------------------------------------------------------
procedure SP_AH_GENERA_DATOS(LN_DNI     IN VARCHAR2,
                             LC_USUARIO IN VARCHAR2);
------------------------------------------------------
procedure SP_AH_ENVIA_CORREO(LC_USUARIO IN VARCHAR2,
                             LD_FECGEN  IN DATE);
------------------------------------------------------
procedure SP_AH_BORRATABLA(lc_dninro  in varchar2,
                           lc_usuario in varchar2);
------------------------------------------------------
procedure SP_AH_UPDATETABLA(lc_usuario in varchar2,
                            ln_flag    in number);
-----------------------16012019 SMA-------------------
Procedure SP_DECLARA_ANUAL;

Procedure SP_DATOSFAM(LN_DNI     IN VARCHAR2,
                      LC_USUARIO IN VARCHAR2);

procedure SP_GENERA_INFO(LN_DNI     IN VARCHAR2,
                         LC_USUARIO IN VARCHAR2,
                         LC_RUTA    IN VARCHAR2,
                         LC_NOMARC  IN VARCHAR2);

procedure SP_ENVIA_CORREO (LC_USUARIO IN VARCHAR2,
                           LD_FECGEN IN DATE);

procedure SP_ACTUALIZATABLA(LC_USUARIO IN VARCHAR2,
                            LC_DNI     IN VARCHAR2,
                            LC_RUTA    IN VARCHAR2,
                            LC_FLAG    IN NUMBER);
------------------------------------------------------
procedure Sp_Copia (LC_DNI     IN VARCHAR2,
                    LC_RUTA    IN VARCHAR2);
-----------------------  07/10/2019 SMA ------------------------------
procedure SP_RRHH_CONTROL(P_DNIT    IN VARCHAR2,
                          P_RELA    IN NUMBER,
                          P_ESTC    IN VARCHAR2,
                          P_MENSAJE OUT VARCHAR2);

procedure SP_RRHH_INSJAQZ573_FF(p_opc in varchar2,
                                p_dni in varchar2,
                                p_rel in number,
                                p_nomf in varchar2,
                                p_usu in varchar2);
END PQ_AH_DECLARA_RRHH;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_DECLARA_RRHH IS

Procedure SP_AH_GENERA_TODOS IS
  CURSOR TRABAJADOR IS
     SELECT *
       FROM FSD002 F2
      WHERE F2.PFPAIS = 604
        AND F2.PFTDOC = 21
        AND F2.PFEBCO = 'S'
        and exists (select *
                      from jaqy667
                     where jaqy667dnit = f2.pfndoc);
   USUARIO VARCHAR2(12);
   FECHA DATE;
BEGIN

    DELETE JAQY672
    WHERE JAQY672DNI IS NULL or jaqy672dni =' ';
    commit;

    DELETE JAQY667
    COMMIT;


    USUARIO := 'RECURSOHUM';
    PQ_AH_DECLARA_RRHH.SP_AH_ALERT_REGFAM;

    FOR REG IN TRABAJADOR LOOP
      PQ_AH_DECLARA_RRHH.SP_AH_GENERA_DATOS(REG.PFNDOC,USUARIO);
    END LOOP;

    select pgfape into FECHA from fst017 where pgcod = 1;
    PQ_AH_DECLARA_RRHH.SP_AH_ENVIA_CORREO(USUARIO,FECHA);

    FOR RE1 IN TRABAJADOR LOOP
        PQ_AH_DECLARA_RRHH.SP_AH_BORRATABLA(RE1.PFNDOC,USUARIO);
    END LOOP;


END SP_AH_GENERA_TODOS;

procedure SP_AH_ALERT_REGFAM is

   CURSOR TODOSFAM IS
    SELECT SUM(T1.CONTADOR) TOTAL ,
           T1.DNI
      FROM
     (select COUNT(*) CONTADOR,
             t_iden.pfndoc DNI
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
         and t_iden.pfndoc <> '29457967'
        --and t_iden.pfndoc in ('40332079','47216030')
         and  not exists (select *
                            from jaqy672
                           where jaqy672dni = trim(t_iden.pfndoc) )
        GROUP BY t_iden.pfndoc

    union all

    select COUNT(*) CONTADOR,
           t_iden.pfndoc  DNI
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
       and t_iden.pfndoc <> '29457967'
  --- and t_iden.pfndoc in ('47216030','40332079')
       and  not exists (select *
                            from jaqy672
                           where jaqy672dni = trim(t_iden.pfndoc) )
      GROUP BY t_iden.pfndoc) T1,  --'29589266'),
          FSD002 T2
    WHERE T1.DNI = T2.PFNDOC
      AND T2.PFEBCO = 'S'
    GROUP BY T1.DNI;

   CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
   SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2)NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

             and t_iden.pfndoc =  NRODOC
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
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

                  and t_iden.pfndoc = NRODOC) T2;

     CURSOR CEROFAM IS
     SELECT T2.PFNDOC DNI,
            TRIM(T2.PFAPE1)||' '||TRIM(T2.PFAPE2)||' '||TRIM(T2.PFNOM1)||' '||TRIM(T2.PFNOM2) NOMBRE,
            T2.PFFNAC FECHANAC,
            T2.PFEBCO
       FROM FSD002 T2
      WHERE T2.PFEBCO = 'S'
      --  and t2.pfndoc ='43214729'
        AND NOT EXISTS( SELECT 1
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
    VCONT_ABUELOS NUMBER;--63
    VCONT_CONYUGE NUMBER;--66
    VCONT_HIJOS   NUMBER;--69
    VCONT_CUNADOS NUMBER;--67
    VCONT_PADRES  NUMBER;--71
    VCONT_SUEGROS NUMBER;--75
    VCONT_BISABUELO   NUMBER;--64
    VCONT_BISNIETO    NUMBER;--65
    VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
    VCONT_NIETO       NUMBER;--70   NIETO(A)
    VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
    VCONT_PRIMO       NUMBER;---72 PRIMO(A)
    VCONT_SOBRINO     NUMBER;--74   SOBRINO(A)
    VCONT_TATARABUELO NUMBER;--76   TATARABUELO(A)
    VCONT_TATANIETO   NUMBER;--77   TATARANIETO(A)
    VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
    VCONT_TIO         NUMBER;---79 TIO(A)
    VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
    VCONT_CONVIVIENTE NUMBER;---91 CONVIVIENTE
    VCONT_PROGENITOR  NUMBER;-- 92 PROGENITOR


    OBSERVACION   varchar2(200);
    V_FECHAHOY    DATE;
    V_YEARHOY     NUMBER;
    V_YEARNAC     NUMBER;
    V_EDADT       NUMBER;
    V_EDADF       NUMBER;
    NORDEN        NUMBER;

   ubuser varchar2(10):= 'RECURSOHUM';



begin

  DELETE JAQY667
  WHERE JAQY667USER = ubuser;
  COMMIT;

  SELECT PGFAPE
    INTO V_FECHAHOY
    FROM FST017
   WHERE PGCOD = 1;

  SELECT EXTRACT(YEAR FROM( SELECT V_FECHAHOY FROM DUAL))
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
         VCONT_CONVIVIENTE := 0; --91
         VCONT_PROGENITOR  := 0; --92
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

             IF DES.COD_RELA = 66 and Des.Pfeciv = '1' THEN
                VCONT_CONYUGE := 1;---VCONT_CONYUGE + 1;
             ELSE
               IF DES.COD_RELA = 66 and Des.Pfeciv = '3' THEN
                VCONT_CONVIVIENTE := 1;
               else 
                VCONT_CONYUGE := 0;
               end if;
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
                VCONT_CONVIVIENTE := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_ABUELOS + 1;
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

             SELECT TP1CORR3
               INTO NORDEN
               FROM FST198
              WHERE TP1COD = 1
                AND TP1COD1 = 10861
                AND tp1corr1 = 1
                AND tp1corr2 = 1
                AND tp1nro1 =  DES.COD_RELA
                AND TP1DESC = DES.RELACION;
----                tdoc_fam := trim(to_char(des.doc_fam)

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
                                 jaqy667AUX6,
                                 JAQY667AUX7,
                                 JAQY667ORD,
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
                                  ubuser,
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
                                  NORDEN,
                                  DES.DOC_FAM,
                                  DES.PAIS_FAM
                                 );
           EXCEPTION
             WHEN OTHERS THEN
               NULL;
           END;

         END LOOP;
     END LOOP;
     COMMIT;
     FOR X IN CEROFAM LOOP
       BEGIN
         INSERT INTO JAQY667(JAQY667DNIT,
                             JAQY667DNIF,
                             JAQY667NOMT,
                             JAQY667ESTT,
                             JAQY667CREL,
                             JAQY667DCOD,
                             JAQY667USER)
                     VALUES (X.DNI,
                             '0',
                             X.NOMBRE,
                             X.PFEBCO,
                             99,
                             'S/FAMILIARES',
                             ubuser);
       EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
               NULL;
       END;
     END LOOP;
     COMMIT;
end SP_AH_ALERT_REGFAM;

procedure SP_AH_REGFAMUNO (lc_dninro in varchar2,
                           lc_usuario in varchar2)is


   CURSOR TODOSFAM(dninro in varchar2)  IS
    SELECT SUM(T1.CONTADOR) TOTAL ,
           T1.DNI
      FROM
     (select COUNT(*) CONTADOR,
             t_iden.pfndoc DNI
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
         and t_iden.pfndoc =  rpad(dninro,12,' ')  -- '47216030'--- IN ('29242520','41097320','40760733','41471421','41892854','40060751','45316645','45353953','40014541','47216030','29542050','29557429','47852329','47413165','30962703','40332079','45072614','29542050','46140580')
        GROUP BY t_iden.pfndoc       --  and t_iden.pfndoc = '47216030'-- '29589266'

    union all

    select COUNT(*) CONTADOR,
           t_iden.pfndoc  DNI
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
      and t_iden.pfndoc =  rpad(dninro,12,' ') ---ro---'47216030'---IN ('29242520','41097320','40760733','41471421','41892854','40060751','45316645','45353953','40014541','47216030','29542050','29557429','47852329','47413165','30962703','40332079','45072614','29542050','46140580')
      GROUP BY t_iden.pfndoc) T1,  --'29589266'),
          FSD002 T2
    WHERE T1.DNI = T2.PFNDOC
      AND T2.PFEBCO = 'S'
    GROUP BY T1.DNI;

   CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
   SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2)NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

             and t_iden.pfndoc =  NRODOC
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
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

                  and t_iden.pfndoc = NRODOC) T2;

   CURSOR CEROFAM (DNINRO IN VARCHAR2) IS
     SELECT T2.PFNDOC DNI,
            TRIM(T2.PFAPE1)||' '||TRIM(T2.PFAPE2)||' '||TRIM(T2.PFNOM1)||' '||TRIM(T2.PFNOM2) NOMBRE,
            T2.PFFNAC FECHANAC,
            T2.PFEBCO
       FROM FSD002 T2
      WHERE T2.PFEBCO = 'S'
        and T2.PFNDOC =  RPAD(DNINRO,12,' ')
        AND NOT EXISTS( SELECT 1
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

    VCONT_ABUELOS NUMBER;--63
    VCONT_CONYUGE NUMBER;--66
    VCONT_HIJOS   NUMBER;--69
    VCONT_CUNADOS NUMBER;--67
    VCONT_PADRES  NUMBER;--71
    VCONT_SUEGROS NUMBER;--75
    VCONT_BISABUELO   NUMBER;--64
    VCONT_BISNIETO    NUMBER;--65
    VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
    VCONT_NIETO       NUMBER;--70   NIETO(A)
    VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
    VCONT_PRIMO       NUMBER;---72 PRIMO(A)
    VCONT_SOBRINO     NUMBER;--74   SOBRINO(A)
    VCONT_TATARABUELO NUMBER;--76   TATARABUELO(A)
    VCONT_TATANIETO   NUMBER;--77   TATARANIETO(A)
    VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
    VCONT_TIO         NUMBER;---79 TIO(A)
    VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
    VCONT_CONVIVIENTE NUMBER;---91 CONVIVIENTE
    VCONT_PROGENITOR  NUMBER;-- 92 PROGENITOR


    OBSERVACION   varchar2(200);
    V_FECHAHOY    DATE;
    V_YEARHOY     NUMBER;
    V_YEARNAC     NUMBER;
    V_EDADT       NUMBER;
    V_EDADF       NUMBER;
    NORDEN        NUMBER;
   --ubuser varchar2(10);



begin

  DELETE JAQY667
  WHERE JAQY667DNIT = RPAD(lc_dninro,12,' ');---lc_usuario;
  COMMIT;

  SELECT PGFAPE
    INTO V_FECHAHOY
    FROM FST017
   WHERE PGCOD = 1;

  SELECT EXTRACT(YEAR FROM( SELECT V_FECHAHOY FROM DUAL))
    INTO V_YEARHOY
    FROM DUAL;

   FOR TOD IN TODOSFAM(lc_dninro) LOOP

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
         VCONT_CONVIVIENTE := 0; --91
         VCONT_PROGENITOR  := 0; --92
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
               IF DES.COD_RELA = 66 and Des.Pfeciv = '3' THEN
                VCONT_CONVIVIENTE := 1;
               else 
                VCONT_CONYUGE := 0;--
               end if;                
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
                VCONT_CONVIVIENTE := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_PROGENITOR := 0;
             END IF;

             --eDADES
             SELECT EXTRACT(YEAR FROM (SELECT DES.FEC_NAC FROM DUAL))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADT := V_YEARHOY - V_YEARNAC;
             SELECT EXTRACT(YEAR FROM (SELECT DES.FEC_NAC_FAM FROM DUAL))
               INTO V_YEARNAC
               FROM DUAL;
             V_EDADF := V_YEARHOY - V_YEARNAC;

             SELECT TP1CORR3
               INTO NORDEN
               FROM FST198
              WHERE TP1COD = 1
                AND TP1COD1 = 10861
                AND tp1corr1 = 1
                AND tp1corr2 = 1
                AND tp1nro1 = DES.COD_RELA
                AND TP1DESC = DES.RELACION;

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
                                 jaqy667AUX6,
                                 JAQY667AUX7,
                                 JAQY667ORD,
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
                                  lc_usuario,
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
                                  NORDEN,
                                  DES.DOC_FAM,
                                  DES.PAIS_FAM
                                 );
           EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
               NULL;
           END;

         END LOOP;
     END LOOP;
     COMMIT;
     for x in CEROFAM (lc_dninro) loop
       bEGIN
         INSERT INTO JAQY667(jaqy667dnit,
                             jaqy667dnif,
                             jaqy667nomt,
                             jaqy667estt,
                             jaqy667crel,
                             jaqy667dcod,
                             jaqy667user)
                     VALUES (x.dni,
                             '0',
                             x.nombre,
                             x.pfebco,
                             99,
                             'S/FAMILIARES',
                             lc_usuario);
       Exception
          WHEN DUP_VAL_ON_INDEX THEN
               NULL;
       END;
     end loop;
     commit;
end SP_AH_REGFAMUNO;

procedure SP_AH_GENERA_DATOS(LN_DNI IN VARCHAR2,
                             LC_USUARIO IN VARCHAR2 ) IS

  cursor familia (nrodni in varchar2,usuario in varchar2) is
     select j.*
       from jaqy667 j,
            fst198 f
      --Where j.JAQY667USER = usuario
      Where j.JAQY667DNIT = rpad(nrodni, 12, ' ')
        and f.tp1nro1 = j.jaqy667crel
        and f.tp1desc = j.jaqy667dcod
        and f.tp1cod = 1
        and f.tp1cod1 = 10861
        and f.tp1corr1 =1
        and f.tp1corr2 = 1
        order by f.tp1corr3;

  cursor familia1 (nrodni in varchar2,usuario in varchar2) is

     select j.*
       from jaqy673 j,
            fst198 f
      Where j.JAQY673DNIT = rpad(nrodni, 12, ' ')
        and f.tp1nro1 = j.jaqy673crel
        and f.tp1desc = j.jaqy673dcod
        and f.tp1cod = 1
        and f.tp1cod1 = 10861
        and f.tp1corr1 =1
        and f.tp1corr2 = 1
        order by f.tp1corr3;

   cursor correos (nrodni in varchar2) is ---HAY QUE VERIFICAR
      select w.wfusrcod, w.wfusremail, f2.JAQN002NDO
        from WFUSERS w, JAQN002 f2
       where f2.jaqn002pgc = 1
         AND f2.JAQN002PAI = 604
         and f2.JAQN002TDO = 21
         and TRIM(f2.JAQN002NDO) = TRIM(nrodni) ---LN_DNI ---'40332079' ---'40332079'--IN ('40332079','47216030')
         AND W.WFUSRCOD = f2.JAQN002USR;



   cont_abu number ;
   cont_pad number ;
   cont_coy number ;
   cont_hij number ;
   cont_sug number ;
   cont_conv number ;
   cont_proex number ;
   nombre     varchar2(25);
   ll_mensaje clob;
   ln_correla number;
   lv_mensaje VARCHAR2(32767);

   ld_fec_gen date;
   lv_nombre varchar2(100);
   lv_dni    varchar2(12);
   correo    varchar2(50);
   lc_error  varchar2(400);
   flag      number := 0;
   V_EXISTE NUMBER := 0;

   MenIncon VARCHAR2(32767);
Begin
  dbms_lob.createtemporary(ll_mensaje, TRUE);

  select nvl(max(JAQY672COR),0) into ln_correla from jaqy672;
  ln_correla := ln_correla + 1;

  select pgfape into ld_fec_gen from fst017 where pgcod = 1;

  For c in correos(LN_DNI) loop
     correo := c.wfusremail;
  End loop;

     IF correo IS NULL THEN
       Begin
          select  w.wfusremail
            into correo
            from WFUSERS w, JAQN002 f2
           where f2.jaqn002pgc = 1
             AND f2.JAQN002PAI = 604
             and f2.JAQN002TDO = 21
             and TRIM(f2.JAQN002NDO) = TRIM(LN_DNI) ---LN_DNI ---'40332079' ---'40332079'--IN ('40332079','47216030')
             AND W.WFUSRCOD = f2.JAQN002USR;
       exception
         when no_data_found then
            correo := NULL;
       end;
     end if;

     cont_abu := 0;
     cont_pad := 0;
     cont_coy := 0;
     cont_hij := 0;
     cont_sug := 0;
     cont_conv := 0;
     cont_proex := 0;

     Begin

       select distinct(jaqy667dnit) dninro , JAQY667NOMT nombre
        into lv_dni,lv_nombre
        from jaqy667
        --Where JAQY667USER = LC_USUARIO
        Where jaqy667dnit = rpad(LN_DNI,12,' ');


       lv_mensaje := --ll_mensaje ||
            '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
            '<table cellspacing=0 cellpadding=0 width=942>' ||
            '  <tr>' ||
            '    <td align="center" colspan="2">DECLARACION JURADA</td>' ||
            '  </tr><br/>' ||
            '  <tr>' ||
            '    <td align="center" colspan="2">REGISTRO DE FAMILIARES</td>' ||
            '  </tr>' ||
            '  <tr>' ||
            '    <td width="74" align="left">AREQUIPA, </td>' ||
            '    <td width="724" align="left">'||to_char(trunc(sysdate), 'DD-MON-YYYY') ||'</td>' ||
            '  </tr>    ' ||
            '</table>' ||
            '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> Yo:  '|| lv_nombre || 'identificado(a) con DNI Nro '|| lv_dni || 'y Trabajador de CAJA AREQUIPA. </p>' ||
            '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> Por medio de la presente, declaro bajo juramento que tengo registrados como familiares a:  </p> <br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '|| 'DNI' || '  '|| 'PARENTESCO' || '  '||'NOMBRES'||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

       For x in familia(LN_DNI,LC_USUARIO) loop
           lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '|| X.JAQY667DNIF || '  '|| X.JAQY667DCOD || '  '||TRIM(X.JAQY667NOMF)||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           cont_abu := cont_abu + x.JAQY667NABU;
           cont_pad := cont_pad + x.JAQY667NPAD;
           cont_coy := cont_coy + x.JAQY667NCOY;
           cont_hij := cont_hij + x.JAQY667NHIJ;
           cont_sug := cont_sug + x.JAQY667NSUE;
           cont_conv := cont_conv + x.JAQY667AUX6;
           cont_proex := cont_proex + x.JAQY667AUX7;
        End loop;
        For y in familia1(LN_DNI,LC_USUARIO) loop
            lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '||' '||' '||' '||' '||' ' ||' '||' '|| y.jaqy673dcod || '  '||TRIM(y.jaqy673nomf)||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           cont_abu := cont_abu + y.jaqy673nabu;
           cont_pad := cont_pad + y.jaqy673npad;
           cont_coy := cont_coy + y.jaqy673ncoy;
           cont_hij := cont_hij + y.jaqy673nhij;
           cont_sug := cont_sug + y.jaqy673nsue;
           cont_conv := cont_conv + y.jaqy673aux5;
           cont_proex := cont_proex + y.jaqy673aux6;
        End loop;
      exception
          When no_data_found then
            null;
      end;
      Begin
         Select 1
           INTO V_EXISTE
           from jaqy667
          where jaqy667dnit = LN_DNI
            --and jaqy667user = LC_USUARIO
            and jaqy667crel = 99;
            lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> UD.NO TIENE REGISTRADO NINGUN FAMILIAR</p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      Exception
        When no_data_found then
          null;
      End;
          lv_mensaje := --ll_mensaje ||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> </p><br/>'||
         '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> Es cuanto declaro en honor a la verdad, asumiendo total responsabilidad por la informaci;n de la misma.</p><br/>';
         dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

          lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px; color:red; size="5"> ALERTA DE REGISTROS FALTANTES: </p>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

         if cont_abu < 4 then
            cont_abu := 4 -cont_abu;
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_abu || '  ABUELO(S)'||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Debe Registrar'||' '|| cont_abu || 'ABUELO(S)';
            flag := 1;
         end if;

         if cont_abu > 4 then
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted ingreso'||'  '|| cont_abu || '  ABUELO(S). Verifique solo debe tener 4 abuelos registrados'||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            flag := 1;
             MenIncon := MenIncon ||'Usted ingreso'||'  '|| cont_abu || '  ABUELO(S). Verifique solo debe tener 4 abuelos registrados';
         end if;

         if cont_pad < 2 then
            cont_pad := 2 -cont_pad;
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_pad || '  PADRE(S)'||' </p><br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Debe Registrar'||'  '|| cont_pad || '  PADRE(S)';
            flag := 1;
         end if;
         if cont_pad > 2 then
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted Ingreso'||'  '|| cont_pad || '  PADRE(S). Verifique solo debe tener 2 padres registrados'||' </p><br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_pad || '  PADRE(S). Verifique solo debe tener 2 padres registrados';
            flag := 1;
         end if;

         if cont_hij > 0 then
           if cont_coy = 0 then
              if cont_conv = 0 then
                if cont_proex = 0 then

                    lv_mensaje := --ll_mensaje ||
                    '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar A SU CONYUGE O CONVIVIENTE O AL PROGENITOR DE SU(S) HIJO(S)'||' </p><br/>';
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                    MenIncon := MenIncon ||'Debe Registrar A SU CONYUGE O CONVIVIENTE O AL PROGENITOR DE SU(S) HIJO(S)';
                    flag := 1;
                end if ;
              end if;
           end if;
         end if;
         if cont_coy = 1 then
           if cont_sug < 2 then
             cont_sug := 2 - cont_sug;
              lv_mensaje := --ll_mensaje ||
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)'||' </p><br/>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)';
              flag := 1;
           end if;
           if cont_sug > 2 then
              lv_mensaje := --ll_mensaje ||
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.'||' </p><br/>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Usted registr;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.';
              flag := 1;
           end if;
           if cont_conv >= 1 then
              lv_mensaje := --ll_mensaje ||
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr;'||'  '|| cont_coy || '  CONYUGE y'||'  '|| cont_conv ||' CONVIVIENTE . Verifique solo puede registrar un conyuge o un conviviente no ambos.'||' </p><br/>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Usted registr;'||'  '|| cont_sug || 'Conyuge y'||'  '||cont_conv||' conviviente Verifique solo puede tener un conyuge o un conviviente no ambos.';
              flag := 1;           end if;
         else
           if  cont_coy > 1 then
             lv_mensaje := --ll_mensaje ||
             '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted Ingreso'||'  '|| cont_coy || 'CONYUGES. Verifique ud. debe tener solo 1 conyuge registrado'||' </p><br/>';
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
             MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_coy || 'CONYUGES. Verifique ud. debe tener solo 1 conyuge registrado.';
             flag := 1;
           end if;
         end if;
                  ---------SMA 05122018---------
         if cont_sug <> 0 THEN
           if cont_coy = 0 then
             lv_mensaje := --ll_mensaje ||
             '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted ingreso'||'  '|| cont_sug || 'SUEGRO(S). Verifique ud. debe registrar un conyuge '||' </p><br/>';
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegros. Verifique ud. debe registrar 1 conyuge o eliminar los suegros.';
             flag := 1;
           else
             if cont_sug < 2 then
               cont_sug := 2 - cont_sug;
                lv_mensaje := --ll_mensaje ||
                '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)'||' </p><br/>';
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegro. Verifique ud. debe registrar dos suegros.';
                flag := 1;
             end if;
              if cont_sug > 2 then
                lv_mensaje := --ll_mensaje ||
                '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.'||' </p><br/>';
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegros. Verifique ud. debe registrar dos suegros.';
                flag := 1;
             end if;
           end if;
         end if;

         ------------------------------

        lv_mensaje := --ll_mensaje ||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> INSTRUCCIONES </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 1.-  Para registrar a sus familiares deber ingresar al Sistema Bantotal, men de RRHH y la opci;n de Registro de Familiares del trabajador.  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Se cuenta con una Gu;a Operativa para el ingreso de familiares al Bantotal en la que se detalla los pasos para el registro de sus familiares,  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      la cual podr ubicarla en el portal de INTRANET  en la siguiente ruta:    </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Biblioteca/Gu;as Operativas/Administraci;n de Personal'||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 2.-  Recuerde que el proceso culmina con la realizaci;n de la FIRMA DIGITAL, caso contrario el sistema no considerar el registro de sus familiares. </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 3.-  Le recordamos que es obligaci;n del trabajador mantener actualizado el registro de sus familiares, de acuerdo a lo establecido en el punto 6.2 del  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> Cap;tulo II del T;tulo VI de nuestro Reglamento Interno de Trabajo. Su incumplimiento es considerado como Falta Laboral.  '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 4.-  Plazos de cumplimiento:'||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      El personal nuevo tiene 5 d;as a partir de la fecha de su ingreso para proceder al registro de sus familiares'||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      En los dem;s casos el personal tiene el plazo de 2 d;as a partir de la fecha de recepci;n del presente para realizar su Declaraci;n Jurada. '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '||' </p><br/>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> Atentamente RRHH. </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">  </p>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

        BEGIN

          insert into jaqy672( JAQY672COR,
                            JAQY672FCH,
                            JAQY672HRG,
                            JAQY672FEN,
                            JAQY672MAI,
                            JAQY672CUE,
                            JAQY672USR,
                            JAQY672USE,
                            JAQY672EST,
                            JAQY672CTRL,
                            JAQY672REP
                            )
                      values(ln_correla,
                             ld_fec_gen,
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             correo,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             'N',
                             flag,
                             lv_dni
                            );
                      commit;
        EXCEPTION
          when others then
          lc_error:= sqlcode||'-'||sqlerrm;
               insert into jaqy672( JAQY672COR,
                            JAQY672FCH,
                            JAQY672HRG,
                            JAQY672FEN,
                            JAQY672MAI,
                            JAQY672CUE,
                            JAQY672USR,
                            JAQY672USE,
                            JAQY672EST,
                            JAQY672ERR,
                            JAQY672CTRL,
                            jaqy672REP
                            )
                      values(ln_correla,
                             ld_fec_gen,
                             to_char(sysdate,'HH24:mi:ss'),
                             null,
                             correo,
                             ll_mensaje,
                             lc_usuario,
                             null,
                             'N',
                             lc_error,
                             flag,
                             lv_dni
                            );
                      commit;
        END;
        Begin
           insert into jaqy672tem(jaqy672dnit,
                                  jaqy672fcht,
  --                                jaqy672cuet,  pruebas140119
                                  jaqy672usrt,
                                --  jaqy672uset,
                                --  jaqy672estt,
                                  jaqy672msg,
                                  jaqy672errt,
                                  jaqy672hrgt,
                                  jaqy672hret)
                           VALUES(LN_DNI,
                                  ld_fec_gen,
--                                  ll_mensaje, pruebas 140119
                                  'TEMPORAL',
                                  MenIncon,
                                  lc_error,
                                  to_char(sysdate,'HH24:mi:ss'),
                                  to_char(sysdate,'HH24:mi:ss')
                                  );
                           commit;
        exception
          when dup_val_on_index then
            null;
        end;
 ---End Loop;
END SP_AH_GENERA_DATOS;

procedure SP_AH_ENVIA_CORREO (LC_USUARIO IN VARCHAR2,
                             LD_FECGEN IN DATE) IS


  cursor c_mail is
   SELECT *
     FROM JAQY672
    WHERE JAQY672MOT is null
--    WHERE JAQY672MOT is not null
      AND JAQY672EST = 'N'
--      and jaqy672usr='RECURSOHUM'--added
--      and jaqy672mai is not null
      AND trim(JAQY672USR) = trim(lc_usuario)----rpad(lc_usuario,10,' ')
      AND trunc(JAQY672FCH) = ld_fecgen;
  lc_error varchar2(400);
  BEGIN
      for i in c_mail loop
       begin

         sys.sp_sy_enviamail_html(pc_aquien =>I.JAQY672MAI,--- sys.sp_sy_enviamail_html_silvia
                                  pc_de => 'declaracionjurada@cajaarequipa.pe',
                                  pc_motivo => 'Declaracion Jurada de Registro de Familiares',
                                  pc_mensaje => i.jaqy672cue
                                 );
         update JAQY672 a
            set a.JAQY672fen = ld_fecgen,--sysdate,
                a.JAQY672hre = to_char(sysdate,'HH24:mi:ss'),
                a.JAQY672use = lc_usuario,
                a.JAQY672est = 'S',
                a.jaqy672mot = TRIM('ENVIADO CORRECTAMENTE')
          where a.JAQY672cor = i.JAQY672cor;
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
         update JAQY672 a
            set a.JAQY672est = 'N',
                a.JAQY672mot = lc_error
          where a.JAQY672cor = i.JAQY672cor;
       end;
       commit;
      end loop;

END SP_AH_ENVIA_CORREO;
procedure SP_AH_BORRATABLA(lc_dninro in varchar2,
                           lc_usuario in varchar2) is
Begin
   delete jaqy667
    where jaqy667dnit = rpad(lc_dninro,12,' ')
      and jaqy667user = lc_usuario;
      commit;

End SP_AH_BORRATABLA;

procedure SP_AH_UPDATETABLA(lc_usuario in varchar2,
                            ln_flag    in number)is
email varchar2(50);
--v_year  number;
dnitrabajador varchar2(12);
correlativo number;
Begin
     email := TRIM(Lower(trim(lc_usuario)||'@cajaarequipa.pe'));
    -- email := (email||'%');
     Begin     
       select jaqy672rep ,jaqy672cor
         into dnitrabajador, correlativo
         from jaqy672
        where trim(jaqy672mai) = trim(email)
          and  jaqy672cor = (select max(jaqy672cor) --sma.18.10.2021       
                               from jaqy672
                              where trim(jaqy672mai) = trim(email));
     update JAQY672 a
        set a.jaqy672ctrl  = ln_flag
      where jaqy672cor = correlativo
        and jaqy672rep = dnitrabajador
        AND (jaqy672dni is null or jaqy672dni = ' ' );
        
      commit;
     exception 
       when no_data_found then
         null;
     end; 
 


End SP_AH_UPDATETABLA;

Procedure SP_DECLARA_ANUAL IS
  CURSOR TRABAJADOR IS
     SELECT *
       FROM FSD002 F2
      WHERE F2.PFPAIS = 604
        AND F2.PFTDOC = 21
        AND F2.PFEBCO = 'S'
       -- AND F2.PFNDOC ='47216030' -- PRUEBAS PROCESO
        AND F2.PFNDOC not in ('09392256','07788079','29457967')
        and not exists (select 1
                          from jaqz574
                         where jaqz574year = (SELECT EXTRACT(YEAR FROM
                                                            (SELECT pgfape FROM fst017 where pgcod = 1)) anio
                                                FROM DUAL)
                           and jaqz574dni = F2.Pfndoc);
   USUARIO VARCHAR2(12);
   FECHA DATE;
BEGIN
    execute immediate 'truncate table JAQY667'; 

    USUARIO := 'RECURSOHUM';
    For fam in TRABAJADOR loop
        PQ_AH_DECLARA_RRHH.SP_DATOSFAM(FAM.PFNDOC, USUARIO);
    END LOOP;

    FOR REG IN TRABAJADOR LOOP
      PQ_AH_DECLARA_RRHH.SP_GENERA_INFO(REG.PFNDOC,USUARIO,NULL,NULL);
    END LOOP;

    select pgfape into FECHA from fst017 where pgcod = 1;
    PQ_AH_DECLARA_RRHH.SP_ENVIA_CORREO(USUARIO,FECHA);

    FOR RE1 IN TRABAJADOR LOOP
        PQ_AH_DECLARA_RRHH.SP_AH_BORRATABLA(RE1.PFNDOC,USUARIO);
    END LOOP;

END SP_DECLARA_ANUAL;

Procedure SP_DATOSFAM(LN_DNI IN VARCHAR2,
                      LC_USUARIO IN VARCHAR2) is

   CURSOR DESPLIEGUE(NRODOC IN VARCHAR2) IS
   SELECT *  FROM
         (select trim(t_iden.pfape1)||' '||trim(t_iden.pfape2)||' '||trim(t_iden.pfnom1)||' '||trim(t_iden.pfnom2)NomTrabajador,
                 t_iden.pfndoc DNI,
                 t_iden.pffnac Fec_Nac,
                 t_iden.pfebco SN,
                 t_trel.vinom Rel_Caja,

                 t_relf.rpccyg Cod_rela,
                 t_desp.vinom Relacion,
                 trim(t_idfa.pfape1)||' '||trim(t_idfa.pfape2)||' '||trim(t_idfa.pfnom1)||' '||trim(t_idfa.pfnom2) Nom_Fam,
                 t_tdfa.tdnom Tip_Doc_Fam,
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

             and t_iden.pfndoc =  NRODOC
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
                 t_idfa.pftdoc Doc_Fam,
                 t_idfa.pfpais pais_fam,
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

                  and t_iden.pfndoc = NRODOC) T2;

     CURSOR CEROFAM (dni char) IS
     SELECT T2.PFNDOC DNI,
            TRIM(T2.PFAPE1)||' '||TRIM(T2.PFAPE2)||' '||TRIM(T2.PFNOM1)||' '||TRIM(T2.PFNOM2) NOMBRE,
            T2.PFFNAC FECHANAC,
            T2.PFEBCO
       FROM FSD002 T2
      WHERE T2.PFEBCO = 'S'
        and t2.pfndoc = dni
        AND NOT EXISTS( SELECT 1
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
    VCONT_ABUELOS NUMBER;--63
    VCONT_CONYUGE NUMBER;--66
    VCONT_HIJOS   NUMBER;--69
    VCONT_CUNADOS NUMBER;--67
    VCONT_PADRES  NUMBER;--71
    VCONT_SUEGROS NUMBER;--75
    VCONT_BISABUELO   NUMBER;--64
    VCONT_BISNIETO    NUMBER;--65
    VCONT_HERMANO     NUMBER;-- 68 HERMANO(A)
    VCONT_NIETO       NUMBER;--70   NIETO(A)
    VCONT_PRIMOHNO    NUMBER; --73 PRIMO HERMANO(A)
    VCONT_PRIMO       NUMBER;---72 PRIMO(A)
    VCONT_SOBRINO     NUMBER;--74   SOBRINO(A)
    VCONT_TATARABUELO NUMBER;--76   TATARABUELO(A)
    VCONT_TATANIETO   NUMBER;--77   TATARANIETO(A)
    VCONT_TIOABUELO   NUMBER;---78 TIO ABUELO(A)
    VCONT_TIO         NUMBER;---79 TIO(A)
    VCONT_NUERAYERNO  NUMBER;-- 89 NUERA/YERNO
    VCONT_CONVIVIENTE NUMBER;---91 CONVIVIENTE
    VCONT_PROGENITOR  NUMBER;-- 92 PROGENITOR


    OBSERVACION   varchar2(200);
    V_FECHAHOY    DATE;
    V_YEARHOY     NUMBER;
    V_YEARNAC     NUMBER;
    V_EDADT       NUMBER;
    V_EDADF       NUMBER;
    NORDEN        NUMBER;

   ubuser varchar2(10):= 'RECURSOHUM';

   VARDNI         CHAR(12);
   dniUno         char(12);

begin

  VARDNI := LN_DNI;
 

  SELECT PGFAPE
    INTO V_FECHAHOY
    FROM FST017
   WHERE PGCOD = 1;

  SELECT EXTRACT(YEAR FROM( SELECT V_FECHAHOY FROM DUAL))
    INTO V_YEARHOY
    FROM DUAL;

    IF LC_USUARIO IS NULL THEN
       ubuser := 'RECURSOHUM';
    ELSE
       UBUSER := lc_USUARIO;
    END IF;

 ---  FOR TOD IN TODOSFAM LOOP

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
         VCONT_CONVIVIENTE := 0; --91
         VCONT_PROGENITOR  := 0; --92
         OBSERVACION   := null;

         FOR DES IN DESPLIEGUE(VARDNI)LOOP ---TOD.DNI) LOOP
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
               IF DES.COD_RELA = 66 and Des.Pfeciv = '3' THEN
                VCONT_CONVIVIENTE := 1;
               else 
                VCONT_CONYUGE := 0;
               end if;
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
                VCONT_CONVIVIENTE := 1; --VCONT_ABUELOS + 1;
             ELSE
                VCONT_CONVIVIENTE := 0;
             END IF;

             IF DES.COD_RELA = 92 THEN
                VCONT_PROGENITOR := 1; --VCONT_ABUELOS + 1;
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

             SELECT TP1CORR3
               INTO NORDEN
               FROM FST198
              WHERE TP1COD = 1
                AND TP1COD1 = 10861
                AND tp1corr1 = 1
                AND tp1corr2 = 1
                AND tp1nro1 =  DES.COD_RELA
                AND TP1DESC = DES.RELACION;

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
                                 jaqy667AUX6,
                                 JAQY667AUX7,
                                 JAQY667ORD,
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
                                  ubuser,
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
                                  NORDEN,
                                  DES.DOC_FAM,
                                  DES.PAIS_FAM
                                 );
           EXCEPTION
             WHEN OTHERS THEN
               NULL;
           END;
           COMMIT;
         END LOOP;
  ---   END LOOP;
--     COMMIT;
     dniUno := LN_DNI;
     FOR X IN CEROFAM(dniuno) LOOP
       BEGIN
         INSERT INTO JAQY667(JAQY667DNIT,
                             JAQY667DNIF,
                             JAQY667NOMT,
                             JAQY667ESTT,
                             JAQY667CREL,
                             JAQY667DCOD,
                             JAQY667USER)
                     VALUES (X.DNI,
                             '0',
                             X.NOMBRE,
                             X.PFEBCO,
                             99,
                             'S/FAMILIARES',
                             ubuser);
       EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
               NULL;
       END;
     END LOOP;
     COMMIT;


End SP_DATOSFAM;
procedure SP_GENERA_INFO(LN_DNI     IN VARCHAR2,
                         LC_USUARIO IN VARCHAR2,
                         LC_RUTA    IN VARCHAR2,
                         LC_NOMARC  IN VARCHAR2) IS

  cursor familia (nrodni in varchar2,usuario in varchar2) is
     select j.*
       from jaqy667 j,
            fst198 f
      --Where j.JAQY667USER = usuario
      Where j.JAQY667DNIT = rpad(nrodni, 12, ' ')
        and f.tp1nro1 = j.jaqy667crel
        and f.tp1desc = j.jaqy667dcod
        and f.tp1cod = 1
        and f.tp1cod1 = 10861
        and f.tp1corr1 =1
        and f.tp1corr2 = 1
        order by f.tp1corr3;

  cursor familia1 (nrodni in varchar2,usuario in varchar2) is

     select j.*
       from jaqy673 j,
            fst198 f
      Where j.JAQY673DNIT = rpad(nrodni, 12, ' ')
        and f.tp1nro1 = j.jaqy673crel
        and f.tp1desc = j.jaqy673dcod
        and f.tp1cod = 1
        and f.tp1cod1 = 10861
        and f.tp1corr1 =1
        and f.tp1corr2 = 1
        order by f.tp1corr3;

   cursor correos (nrodni in varchar2) is ---HAY QUE VERIFICAR
      select w.wfusrcod, w.wfusremail, f2.JAQN002NDO
        from WFUSERS w, JAQN002 f2
       where f2.jaqn002pgc = 1
         AND f2.JAQN002PAI = 604
         and f2.JAQN002TDO = 21
         and TRIM(f2.JAQN002NDO) = TRIM(nrodni) ---LN_DNI ---'40332079' ---'40332079'--IN ('40332079','47216030')
         AND W.WFUSRCOD = f2.JAQN002USR;



   cont_abu number ;
   cont_pad number ;
   cont_coy number ;
   cont_hij number ;
   cont_sug number ;
   cont_conv number ;
   cont_proex number ;
   nombre     varchar2(25);
   ll_mensaje clob;
   --ln_correla number;
   lv_mensaje VARCHAR2(32767);

   ld_fec_gen date;
   lv_nombre varchar2(100);
   --lv_dni    varchar2(12);
   lv_dni574 char(12);
   correo    varchar2(50);
   lc_error  varchar2(400);
   flag      number := 0;
   V_EXISTE NUMBER := 0;
   --------------------------
   MenIncon VARCHAR2(32767);
   v_year   number;
   l_bfile  BFILE;
   l_blob   BLOB;
   fechapro date;
   hora     char(8);
  --- fechanac date;
   USUARIO  CHAR(10);
   cuerpo   clob;

   control NUMBER;
   lv_nomrep  varchar2(30):='DIRDECLARA';
  -- ruta varchar2(100);
  jaqz574uconf1 varchar2(10);
  jaqz574fconf1 date;
  jaqz574hconf1 char(8);
  jaqz574rep1   char(12);
Begin
  dbms_lob.createtemporary(ll_mensaje, TRUE);


  select pgfape into ld_fec_gen from fst017 where pgcod = 1;

  select EXTRACT(YEAR FROM pgfape)
          into v_year
          from fst017 where pgcod = 1;

  For c in correos(LN_DNI) loop
     correo := c.wfusremail;
  End loop;

     IF correo IS NULL THEN
       Begin
          select  w.wfusremail
            into correo
            from WFUSERS w, JAQN002 f2
           where f2.jaqn002pgc = 1
             AND f2.JAQN002PAI = 604
             and f2.JAQN002TDO = 21
             and TRIM(f2.JAQN002NDO) = TRIM(LN_DNI) ---LN_DNI ---'40332079' ---'40332079'--IN ('40332079','47216030')
             AND W.WFUSRCOD = f2.JAQN002USR;
       exception
         when no_data_found then
            correo := NULL;
       end;
     end if;

     cont_abu := 0;
     cont_pad := 0;
     cont_coy := 0;
     cont_hij := 0;
     cont_sug := 0;
     cont_conv := 0;
     cont_proex := 0;

     Begin

       select distinct(jaqy667dnit) dninro , JAQY667NOMT nombre
        into lv_dni574,lv_nombre
        from jaqy667
        --Where JAQY667USER = LC_USUARIO
        Where jaqy667dnit = rpad(LN_DNI,12,' ');
      --  ruta := Server.MapPath(@"~/opt/bantotal/archivosbt/logos/logo_caja.jpg");

       lv_mensaje := --ll_mensaje ||
            '<style  type="text/css">td {font-family:''Courier New'', Courier, monospace; font-size:13px}</style>' ||
            '<table cellspacing=0 cellpadding=0 width=942>' ||
            '  <img scr="http://10.0.212.74:30542/opt/bantotal/archivosbt/logos/logo_caja.jpg"/>'||
            '  <tr>' ||
            '    <td align="center" colspan="2"><b style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:15px">DECLARACION JURADA ANUAL </b></td>' ||
            '  </tr><br/>' ||
            '  <tr>' ||
            '    <td align="center" colspan="2">REGISTRO DE FAMILIARES</td>' ||
            '  </tr>' ||
            '  <tr>' ||
            '    <td width="74" align="left">AREQUIPA, </td>' ||
            '    <td width="724" align="left">'||to_char(trunc(sysdate), 'DD-MON-YYYY') ||'</td>' ||
            '  </tr>    ' ||
            '</table>' ||
            '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> Estimado colaborador en cumplimiento a la disposici&oacute;n en actualizaci&oacute;n de declaraciones juradas, </p>' ||
            '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> detatallamos a continuaci&oacute;n el reporte de familiares que se encuentran registrados  a la </p>' ||
            '<p style="font-family:''Courier New'', Courier, monospace;  font-size:13px"> fecha en nuestro sistema Bantotal:   </p> <br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:13px"> '|| 'NRO DNI -  ' ||'  '|| 'V&Iacute;NCULO FAMILIAR - '||'  '||'NOMBRE APELLIDOS DEL FAMILIAR'||'</p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
        /*   lv_mensaje := --ll_mensaje ||
        //    '<pre><p style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:15px">'|| 'Nombre y Apellidos de Familiar' ||'     ' || 'V&iacute;nculo Familiar ' ||'   ' ||'DNI '||' </p></pre>';
        //    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   */

       For x in familia(LN_DNI,LC_USUARIO) loop
           lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; font-size:11px"><pre>'||X.JAQY667DNIF ||' '||'<b style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:13px">'|| trim(X.JAQY667DCOD)||'</b>'||' '||TRIM(X.JAQY667NOMF)||'</pre></p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           cont_abu := cont_abu + x.JAQY667NABU;
           cont_pad := cont_pad + x.JAQY667NPAD;
           cont_coy := cont_coy + x.JAQY667NCOY;
           cont_hij := cont_hij + x.JAQY667NHIJ;
           cont_sug := cont_sug + x.JAQY667NSUE;
           cont_conv := cont_conv + x.JAQY667AUX6;
           cont_proex := cont_proex + x.JAQY667AUX7;
        End loop;
        For y in familia1(LN_DNI,LC_USUARIO) loop
            lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; font-size:11px"><pre> '||'            '||' '||'<b style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:13px">'|| trim(y.jaqy673dcod) ||'</b>'||' '||TRIM(y.jaqy673nomf) ||'</pre></p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

           cont_abu := cont_abu + y.jaqy673nabu;
           cont_pad := cont_pad + y.jaqy673npad;
           cont_coy := cont_coy + y.jaqy673ncoy;
           cont_hij := cont_hij + y.jaqy673nhij;
           cont_sug := cont_sug + y.jaqy673nsue;
           cont_conv := cont_conv + y.jaqy673aux5;
           cont_proex := cont_proex + y.jaqy673aux6;
        End loop;
      exception
          When no_data_found then
            lv_dni574 := LN_DNI;
            Begin
            select trim(pfape1)||' '||trim(pfape2)||' '||trim(pfnom1)||' '||trim(pfnom2)
              into lv_nombre
              from fsd002
             where pfpais =604
               and pftdoc =21
               and pfndoc = lv_dni574;
            exception
              when no_data_found then
                lv_nombre := 'No corresponde';
            end;     
      end;
      Begin
         Select 1
           INTO V_EXISTE
           from jaqy667
          where jaqy667dnit = LN_DNI
            --and jaqy667user = LC_USUARIO
            and jaqy667crel = 99;
            lv_mensaje := --ll_mensaje ||
           '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> UD.NO TIENE REGISTRADO NINGUN FAMILIAR</p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
      Exception
        When no_data_found then
          null;
      End;

          lv_mensaje := '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px; color:red; size="5"> ALERTA DE REGISTROS FALTANTES: </p>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);

         if cont_abu < 4 then
            cont_abu := 4 -cont_abu;
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_abu || '  ABUELO(S)'||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Debe Registrar'||' '|| cont_abu || 'ABUELO(S)';
            flag := 1;
         end if;

         if cont_abu > 4 then
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted ingreso'||'  '|| cont_abu || '  ABUELO(S). Verifique solo debe tener 4 abuelos registrados'||' </p>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            flag := 1;
             MenIncon := MenIncon ||'Usted ingreso'||'  '|| cont_abu || '  ABUELO(S). Verifique solo debe tener 4 abuelos registrados';
         end if;

         if cont_pad < 2 then
            cont_pad := 2 -cont_pad;
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_pad || '  PADRE(S)'||' </p><br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Debe Registrar'||'  '|| cont_pad || '  PADRE(S)';
            flag := 1;
         end if;
         if cont_pad > 2 then
            lv_mensaje := --ll_mensaje ||
            '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted Ingreso'||'  '|| cont_pad || '  PADRE(S). Verifique solo debe tener 2 padres registrados'||' </p><br/>';
            dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
            MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_pad || '  PADRE(S). Verifique solo debe tener 2 padres registrados';
            flag := 1;
         end if;

         if cont_hij > 0 then
           if cont_coy = 0 then
              if cont_conv = 0 then
                if cont_proex = 0 then

                    lv_mensaje := --ll_mensaje ||
                    '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar A SU CONYUGE O CONVIVIENTE O AL PROGENITOR DE SU(S) HIJO(S) o Verifique su Estado Civil'||' </p><br/>';
                    dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                    MenIncon := MenIncon ||'Debe Registrar A SU CONYUGE O CONVIVIENTE O AL PROGENITOR DE SU(S) HIJO(S) o Verifique su Estado Civil ';
                    flag := 1;
                end if ;
              end if;
           end if;
         end if;
         if cont_coy = 1 then
           if cont_sug < 2 then
             cont_sug := 2 - cont_sug;
              lv_mensaje := --ll_mensaje ||
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)'||' </p><br/>';
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)';
              flag := 1;
           end if;
           if cont_sug > 2 then
              lv_mensaje := --ll_mensaje ||                                           
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr&oacute;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.'||' </p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
              MenIncon := MenIncon ||'Usted registr&oacute;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.';
              flag := 1;           end if;
           if cont_conv >= 1 then
              lv_mensaje := --ll_mensaje ||                                           
              '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr&oacute;'||'  '|| cont_coy || '  CONYUGE y'||'  '|| cont_conv ||' CONVIVIENTE . Verifique solo puede registrar un conyuge o un conviviente no ambos.'||' </p><br/>';  
              dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje); 
              MenIncon := MenIncon ||'Usted registr&oacute;'||'  '|| cont_sug || 'Conyuge y'||'  '||cont_conv||' conviviente Verifique solo puede tener un conyuge o un conviviente no ambos.';
              flag := 1;
           end if;
         else
           if  cont_coy > 1 then
             lv_mensaje := --ll_mensaje ||                              
             '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted Ingreso'||'  '|| cont_coy || 'CONYUGES. Verifique ud. debe tener solo 1 conyuge registrado'||' </p><br/>';  
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);   
             MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_coy || 'CONYUGES. Verifique ud. debe tener solo 1 conyuge registrado.';
             flag := 1;
           end if;
         end if;
                  ---------SMA 05122018---------
         if cont_sug <> 0 THEN
           if cont_coy = 0 then
             lv_mensaje := --ll_mensaje ||
             '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted ingreso'||'  '|| cont_sug || 'SUEGRO(S). Verifique ud. debe registrar un conyuge o Verifique su Estado Civil '||' </p><br/>';
             dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
              MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegros. Verifique ud. debe registrar 1 conyuge o eliminar los suegros o Verifique su Estado Civil';
             flag := 1;
           else
             if cont_sug < 2 then
               cont_sug := 2 - cont_sug;
                lv_mensaje := --ll_mensaje ||
                '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Debe Registrar'||'  '|| cont_sug || '  SUEGRO(S)'||' </p><br/>';
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegro. Verifique ud. debe registrar dos suegros.';
                flag := 1;
             end if;
              if cont_sug > 2 then
                lv_mensaje := --ll_mensaje ||
                '<p style="font-family:''Courier New'', Courier, monospace; color:red; font-size:13px"> Usted registr;'||'  '|| cont_sug || '  SUEGRO(S). Verifique solo puede tenere dos suegros registrados.'||' </p><br/>';
                dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
                MenIncon := MenIncon ||'Usted Ingreso'||'  '|| cont_sug || 'Suegros. Verifique ud. debe registrar dos suegros.';
                flag := 1;
             end if;
           end if;
         end if;

         ------------------------------

         lv_mensaje := --ll_mensaje ||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"><pre>  </p>'||
         '<p style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:13px"> Consideraciones: </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 1.-  De encontrarse la informaci&oacute;n correcta de registro de sus familiares, solicitamos realice la FIRMA DIGITAL en la opci&oacute;n de confirmaci&oacute;n del  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Bantotal al cual podr&aacute; acceder en la siguiente ruta en el sistema BT: Sistema Bantotal, men&uacute; de RRHH y la opci&oacute;n de Registro de  Familiares</p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      del trabajador, Firma digital.  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 2.-  De realizar algún registro adicional por actualizaci&oacute;n de familiares, se debe tener en cuenta las siguientes instrucciones:  '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 2.1- Para registrar a sus familiares deber&aacute; ingresar al Sistema Bantotal, men&uacute; de RRHH y la opci&oacute;n de Registro de Familiares del trabajador.  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Se cuenta con una Gu&iacute;a Operativa para el ingreso de familiares al Bantotal en la que se detalla los pasos para el registro de sus familiares,  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      la cual podr&aacute; ubicarla en el portal de INTRANET  en la siguiente ruta:    </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Biblioteca/Gu&iacute;as Operativas/Administraci&oacute;n de Personal'||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 2.2- Recuerde que el proceso culmina con la realizaci&oacute;n de la FIRMA DIGITAL, caso contrario el sistema no considerar&aacute el registro de sus familiares. </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> 3.-  Si por actualizaci&oacute;n requiere eliminar alg&uacute;n registro, deber&aacute; de remitir un correo a registrodefamiliares@cajaaarequipa.pe adjuntando el </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      sustento respectivo para que se elimine el registro. Considerar que los colaboradores no contamos con la opci&oacute;n de eliminar familiares en el BT. </p>'||
         '<p style="font-family:''Arial Black'', Gadget, Sans-Serif; font-size:13px"> IMPORTANTE: </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Le recordamos que es obligaci&oacute;n del trabajador mantener actualizado el registro de sus familiares, de acuerdo a lo establecido en el punto 6.2 del  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Cap&iacute;tulo II del T&iacute;tulo VI de nuestro Reglamento Interno de Trabajo. Su incumplimiento es considerado como Falta Laboral.  '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Se debe considerar que la FIRMA DIGITAL tiene car&aacute;cter de Declaraci&oacute;n Jurada. </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      </p><br/>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">      Considerar que no se podr&aacute; generar la firma digital en caso se presente alguna inconsistencia. '||'</pre> </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '||' </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px"> '||' </p><br/>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">  </p>'||
         '<p style="font-family:''Courier New'', Courier, monospace; font-size:13px">  </p>';
          dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);


        If LC_RUTA is null then
          Begin
            insert into JAQZ574(jaqz574year,
                                JAQZ574DNI,
                                JAQZ574FCH,
                                JAQZ574HRAG,
                                JAQZ574FEN,
                                JAQZ574MAI,
                                JAQZ574CUE,
                                JAQZ574USR,
                                JAQZ574USE,
                                JAQZ574EST,
                                JAQZ574CTRL)
                         values(v_year,
                                lv_dni574,
                                ld_fec_gen,
                                to_char(sysdate,'HH24:mi:ss'),
                                null,
                                correo,
                                ll_mensaje,
                                lc_usuario,
                                null,
                                'N',
                                flag);
                        commit;
          exception
            when dup_val_on_index then
              null;
          End;
        ELSE

               Begin
                 select jaqz574fch,
                        JAQZ574HRAG,
                        JAQZ574MAI,
                        JAQZ574CUE,
                        JAQZ574USR,
                       -- JAQZ574EST,
                        JAQZ574CTRL,
                        jaqz574uconf, 
                        jaqz574fconf, 
                        jaqz574hconf, 
                        jaqz574rep 
                   into FECHAPRO,
                        hora,
                        correo,
                        cuerpo,
                        usuario,
                      --  estado,
                        control,
                        jaqz574uconf1, 
                        jaqz574fconf1, 
                        jaqz574hconf1, 
                        jaqz574rep1 
                   from jaqz574
                  where jaqz574year = v_year
                    and JAQZ574DNI =  lv_dni574;

                 delete jaqz574
                  where jaqz574year = v_year
                    and JAQZ574DNI =  lv_dni574;

               insert into JAQZ574( jaqz574year,
                                    JAQZ574DNI,
                                    JAQZ574FCH,
                                    JAQZ574HRAG,
                                    JAQZ574FEN,
                                    JAQZ574MAI,
                                    JAQZ574CUE,
                                    JAQZ574USR,
                                    JAQZ574USE,
                                    JAQZ574EST,
                                    JAQZ574ERR,
                                    JAQZ574CTRL,
                                    JAQZ574AU7,
                                    JAQZ574AU3,
                                    jaqz574uconf, 
                                    jaqz574fconf, 
                                    jaqz574hconf, 
                                    jaqz574rep, 
                                    jaqz574narch,
                                    JAQZ574ARCHI
                                    )
                              values(v_year,
                                     lv_dni574,
                                     ld_fec_gen,
                                     to_char(sysdate,'HH24:mi:ss'),
                                     null,
                                     correo,
                                     ll_mensaje,
                                     usuario,--
                                     lc_usuario,
                                     'N',
                                     lc_error,
                                     flag,
                                     FECHAPRO,
                                     HORA,
                                     jaqz574uconf1, 
                                     jaqz574fconf1, 
                                     jaqz574hconf1, 
                                     jaqz574rep1, 
                                     LC_NOMARC,
                                     EMPTY_BLOB()
                                    )RETURN JAQZ574ARCHI INTO l_blob;
--                              l_bfile := BFILENAME(LC_RUTA, LC_NOMARC);
                              l_bfile := BFILENAME(lv_nomrep, LC_NOMARC);
                              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                              DBMS_LOB.fileclose(l_bfile);
                              commit;
              EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                  NULL;
              END;              
        END if;
        Begin
           insert into jaqy672tem(jaqy672dnit,
                                  jaqy672fcht,
  --                                jaqy672cuet,  pruebas140119
                                  jaqy672usrt,
                                --  jaqy672uset,
                                --  jaqy672estt,
                                  jaqy672msg,
                                  jaqy672errt,
                                  jaqy672hrgt,
                                  jaqy672hret)
                           VALUES(lv_dni574,
                                  ld_fec_gen,
--                                  ll_mensaje, pruebas 140119
                                  'TEMPORAL',
                                  MenIncon,
                                  lc_error,
                                  to_char(sysdate,'HH24:mi:ss'),
                                  to_char(sysdate,'HH24:mi:ss')
                                  );
                           commit;
        exception
          when dup_val_on_index then
            null;
          when others then
            null;
        end;
 ---End Loop;
END SP_GENERA_INFO;

procedure SP_ENVIA_CORREO (LC_USUARIO IN VARCHAR2,
                           LD_FECGEN IN DATE) IS


  cursor c_mail is
   SELECT *
     FROM JAQZ574
    WHERE JAQZ574MOT is null
      AND JAQZ574EST = 'N'
      AND trim(JAQZ574USR) = trim(lc_usuario)----rpad(lc_usuario,10,' ')
      AND trunc(JAQZ574FCH) = ld_fecgen;

  lc_error  varchar2(400);
  lc_usrsup varchar2(50);
  lc_coderr varchar2(400):= null;
  lc_deserr varchar2(400):= null;
  BEGIN
      for i in c_mail loop
       begin
         lc_usrsup := 'registrosdepersonal';---@cajaarequipa.pe'; -- cambiar por correo de  rrhh

        /* sys.sp_sy_enviamail_html(pc_aquien =>I.JAQZ574MAI,--- sys.sp_sy_enviamail_html_silvia
                                  pc_de => 'declaracionjurada@cajaarequipa.pe',
                                  pc_motivo => 'Declaracion Jurada de Registro de Familiares',
                                  pc_mensaje => i.JAQZ574cue
                                 );   */
                             -- Call the procedure

          pq_ah_planillas.p_sendmailattach(p_destinatariospara => trim(i.jaqz574mai),--trim(lc_usrori)||'@cajaarequipa.pe',
                                           p_destinatarioscc   => CASE
                                                                    WHEN trim(lc_usrsup) is not null THEN
                                                                      trim(lc_usrsup)||'@cajaarequipa.pe'
                                                                    ELSE
                                                                      ''
                                                                    END,
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => i.jaqz574cue, --ll_mensaje,
                                           p_remitente         => 'notificacionesbantotal@cajaarequipa.pe',
                                           p_asunto            => 'Alerta de Declaracion Jurada Anual'||i.jaqz574year,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => lc_coderr,
                                           p_c_deserr          => lc_deserr
                                           );


         update JAQZ574 a
            set a.JAQZ574fen = ld_fecgen,--sysdate,
                a.JAQZ574hrae = to_char(sysdate,'HH24:mi:ss'),
                a.JAQZ574use = lc_usuario,
                a.JAQZ574est = 'S',
                a.JAQZ574mot = TRIM('ENVIADO CORRECTAMENTE')
          where a.jaqz574year = i.jaqz574year
            and a.jaqz574dni = i.jaqz574dni;
       exception
       when others then
         lc_error:= sqlcode||'-'||sqlerrm;
         update JAQZ574 a
            set a.JAQZ574est = 'N',
                a.JAQZ574mot = lc_error
          where a.jaqz574year = i.jaqz574year
            and a.jaqz574dni = i.jaqz574dni;
       end;
       commit;
      end loop;

END SP_ENVIA_CORREO;
procedure SP_ACTUALIZATABLA(LC_USUARIO IN VARCHAR2,
                            LC_DNI     IN VARCHAR2,
                            LC_RUTA    IN VARCHAR2,
                            LC_FLAG    IN NUMBER) IS



--usuario varchar2(10);
DOCUMENTO CHAR(12);
email varchar2(50);
--archivo char(30);
v_year   number;
--ruta char(43);
/*
jaqz574year1 number;
jaqz574dni1 char(12);
jaqz574fch1  date;
jaqz574hrag1 char(8);
jaqz574fen1  date;
jaqz574hrae1 char(8);
jaqz574mai1  varchar2(50);
jaqz574cue1  clob;

jaqz574usr1  varchar2(10);
jaqz574use1  varchar2(10);
jaqz574est1  char(1);
jaqz574mot1  varchar2(400);

jaqz574ctrl1 number(4);

jaqz574au61  varchar2(100);

lv_nomrep  varchar2(10):='DIRDECLARA';

l_bfile  BFILE;
l_blob   BLOB;*/
Begin
    --   ruta := '/opt/bantotal/archivosbt/spool/Declaracion';
       --archivo := substr(lc_ruta,44,30);
       email := TRIM(Lower(trim(lc_usuario)||'@cajaarequipa.pe'));
       DOCUMENTO := LC_DNI;
       select EXTRACT(YEAR FROM pgfape)
        into v_year
        from fst017 where pgcod = 1;



          UPDATE JAQZ574
             SET jaqz574au6   = trim(LC_RUTA), --nomarch small
                 jaqz574ctrl  = LC_FLAG
           WHERE jaqz574year = v_year
             and jaqz574dni = DOCUMENTO
             and JAQZ574MAI  like (email||'%')
             and (jaqz574rep is null or jaqz574rep=' ') ;
        COMMIT;

end Sp_Actualizatabla;
procedure Sp_Copia (LC_DNI     IN VARCHAR2,
                    LC_RUTA    IN VARCHAR2
                    )is
--ruta char(43);
DOCUMENTO CHAR(12);
jaqz574year1 number;
jaqz574dni1 char(12);
jaqz574fch1  date;
jaqz574hrag1 char(8);
jaqz574fen1  date;
jaqz574hrae1 char(8);
jaqz574mai1  varchar2(50);
jaqz574cue1  clob;

jaqz574usr1  varchar2(10);
jaqz574use1  varchar2(10);
jaqz574est1  char(1);
jaqz574mot1  varchar2(400);

jaqz574ctrl1 number(4);
jaqz574au61  varchar2(100);

jaqz574uconf1 varchar2(10);
jaqz574fconf1 date;
jaqz574hconf1 char(8);
jaqz574rep1   char(12);

lv_nomrep  varchar2(10):='DIRDECLARA';
l_bfile  BFILE;
l_blob   BLOB;
archivo  varchar2(30);
v_year   number;
seguir char(1);
Begin
       archivo := trim(substr(lc_ruta,44,30));
       DOCUMENTO := LC_DNI;
       select EXTRACT(YEAR FROM pgfape)
        into v_year
        from fst017 where pgcod = 1;
        Begin
                 select jaqz574year,
                        jaqz574dni,
                        jaqz574fch,
                        jaqz574hrag,
                        jaqz574fen,
                        jaqz574hrae,
                        jaqz574mai,
                        jaqz574cue, --
                        jaqz574usr,
                        jaqz574use,
                        jaqz574est,
                        jaqz574mot,
                        jaqz574ctrl,
                        lc_ruta,
                        jaqz574uconf, 
                        jaqz574fconf, 
                        jaqz574hconf,
                        jaqz574rep               
                   into jaqz574year1,
                        jaqz574dni1,
                        jaqz574fch1,
                        jaqz574hrag1,
                        jaqz574fen1,
                        jaqz574hrae1,
                        jaqz574mai1,
                        jaqz574cue1, ---
                        jaqz574usr1,
                        jaqz574use1,
                        jaqz574est1,
                        jaqz574mot1,
                        jaqz574ctrl1,
                        jaqz574au61,
                        jaqz574uconf1, 
                        jaqz574fconf1, 
                        jaqz574hconf1,
                        jaqz574rep1
                   from jaqz574
                  where jaqz574year = v_year
                    and JAQZ574DNI = documento;
                    Seguir := 'S';
        exception
          when no_data_found then
            Seguir := 'N';
        end;
        if Seguir = 'S' then
                 delete jaqz574
                  where jaqz574year = v_year
                    and JAQZ574DNI = documento;
               commit;
               Begin
               insert into JAQZ574(jaqz574year,
                                    jaqz574dni,
                                    jaqz574fch,
                                    jaqz574hrag,
                                    jaqz574fen,
                                    jaqz574hrae,
                                    jaqz574mai,
                                    jaqz574cue, --
                                    jaqz574usr,
                                    jaqz574use,
                                    jaqz574est,
                                    jaqz574mot,
                                    jaqz574ctrl,
                                    jaqz574au6,                                    
                                    jaqz574uconf, 
                                    jaqz574fconf, 
                                    jaqz574hconf,
                                    jaqz574rep,
                                    jaqz574narch,                                    
                                    JAQZ574ARCHI
                                    )
                              values(jaqz574year1,
                                      jaqz574dni1,
                                      jaqz574fch1,
                                      jaqz574hrag1,
                                      jaqz574fen1,
                                      jaqz574hrae1,
                                      jaqz574mai1,
                                      jaqz574cue1, ---
                                      jaqz574usr1,
                                      jaqz574use1,
                                      jaqz574est1,
                                      jaqz574mot1,
                                      jaqz574ctrl1,
                                      jaqz574au61,
                                      jaqz574uconf1, 
                                      jaqz574fconf1, 
                                      jaqz574hconf1, 
                                      jaqz574rep1,
                                      archivo,
                                      EMPTY_BLOB()
                                     )RETURN JAQZ574ARCHI INTO l_blob;
--                              l_bfile := BFILENAME(LC_RUTA, LC_NOMARC);
                              l_bfile := BFILENAME(lv_nomrep, archivo);
                              DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
                              DBMS_LOB.loadfromfile(l_blob,l_bfile,DBMS_LOB.getlength(l_bfile));
                              DBMS_LOB.fileclose(l_bfile);
                              commit;
              EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                  NULL;
              end;
          end if;
end Sp_Copia;
procedure SP_RRHH_CONTROL(P_DNIT     IN VARCHAR2,
                          P_RELA     IN NUMBER,
                          P_ESTC     IN VARCHAR2,
                          P_MENSAJE OUT VARCHAR2) is
CURSOR FAMILIARES (DNI CHAR) IS
    select Sum(t.contador) VALOR , t.relacion RELA
      from ((select COUNT(*) contador, RPCCYG relacion
              from fsr002
             where pepais = 604
               and petdoc = 21
               and pendoc = DNI--'47216030' --'45068541'
               AND RPCCYG IN ( 63, 66, 71, 75, 91, 92)
             gROUP BY rpccyg
             union
            select COUNT(*) contador, RPCCYG relacion
              from fsr002
             where rppais  = 604
               and rptdoc  = 21
               and rpndoc  =DNI -- '47216030'
               AND RPCCYG IN ( 63, 66, 71, 75, 91, 92)
             gROUP BY rpccyg)
            union all
            select count(*) contador, jaqy673crel relacion
              from jaqy673
             where jaqy673dnit = DNI --'47216030'
               AND jaqy673crel IN ( 63, 66, 71, 75, 91, 92)
             gROUP BY jaqy673crel) t
     group by t.relacion;

DNI CHAR(12);
mensaje varchar2(100);
contcony number:= 0;
contconv number:= 0;

begin

  DNI := P_DNIT;
  mensaje := '0';

  For fam in familiares(Dni) loop
     if fam.rela = 66 then
        contcony := fam.valor;
     end if;
     if fam.rela = 91 then
        contconv := fam.valor;
     end if;

     if p_rela = fam.rela and fam.rela = 63 then
       If fam.valor >= 4  then
         mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ya tiene registrado 4 Abuelos';
         exit;
       else
         mensaje := '0';
       end if;
     end if;
     if p_rela = fam.rela and fam.rela = 66 then
       if P_ESTC = '1' then
           If fam.valor >= 1  then
             mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ya tiene registrado 1 conyuge';
             exit;
           else
             mensaje := '0';

           end if;
       else
         mensaje := 'Ud. No puede registrar este familiar con esa relacion.Su Estado Civil es diferente a Casado';
         exit;
       end if;
     end if;
      if p_rela = fam.rela and fam.rela = 71 then
       If fam.valor >= 2  then
         mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ya tiene registrado 2 Padres';
         exit;
       else
          mensaje := '0';
       end if;
     end if;
     if p_rela = fam.rela and fam.rela = 75 then
       If fam.valor >= 2  then
         mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ya tiene registrado 2 Suegros';
         exit;
       else
         mensaje := '0';
       end if;
     end if;

      if p_rela = fam.rela and fam.rela = 91 then
       if P_ESTC = '3' then
           If fam.valor >= 1  then
             mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ya tiene registrado 1 conyuge';
             exit;
           else
             mensaje := '0';

           end if;
       else
         mensaje := 'Ud. No puede registrar este familiar con esa relacion.Su Estado Civil es diferente a conviviente';
         exit;
       end if;
     end if;
  end loop;
  if (trim(mensaje) = '0')  then
    if p_rela = 66 then
      if contcony > 0 then
        mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ud. tiene registrado a un conviviente';
      end if;
    else
       if p_rela = 91 then
          if contconv > 0 then
            mensaje := 'Ud. No puede registrar este familiar con esa relacion.Ud. tiene registrado a un conyuge';
          end if;
       end if;
    end if ;
  end if;
  p_mensaje := mensaje;
end SP_RRHH_CONTROL;
procedure SP_RRHH_INSJAQZ573_FF(p_opc in varchar2,
                                p_dni in varchar2,
                                p_rel in number,
                                p_nomf in varchar2,
                                p_usu in varchar2) is

codigo number := 0;
dni    char(12);
fecha  date;
hora   char(8);

begin
  dni := p_dni;
  select MAX(jaqz573cod)+ 1
    into codigo
    from JAQZ573;
  select pgfape
    into fecha
    from fst017
   where pgcod = 1;

  select to_char(sysdate,'hh24:mi:ss')
    into hora
    from dual;
  Begin
    INSERT INTO JAQZ573(jaqz573cod,
                        jaqz573pais,
                        jaqz573tdoc,
                        jaqz573ndoc,
                        jaqz573rel,
                        jaqz573fpais,
                        jaqz573ftdoc,
                        jaqz573fndoc,
                        jaqz573fecha,
                        jaqz573inst,
                        jaqz573au4,
                        jaqz573au5,
                        jaqz573usr)
                 values(codigo,
                        604,
                        21,
                        dni,
                        p_rel,
                        0,
                        0,
                        '0',
                        fecha,
                        p_opc,
                        hora,
                        p_nomf,
                        p_usu);
   commit;
   exception
    when dup_val_on_index then
      null;
   end;
end SP_RRHH_INSJAQZ573_FF;
END PQ_AH_DECLARA_RRHH;
/

